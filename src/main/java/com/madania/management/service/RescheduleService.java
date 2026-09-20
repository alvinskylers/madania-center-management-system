package com.madania.management.service;

import com.madania.management.entity.RescheduleRequest;
import com.madania.management.entity.TherapySession;
import com.madania.management.entity.User;
import com.madania.management.enums.NotificationType;
import com.madania.management.enums.RescheduleStatus;
import com.madania.management.enums.Role;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.RescheduleRequestRepository;
import com.madania.management.repository.TherapySessionRepository;
import com.madania.management.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RescheduleService {

    private static final DateTimeFormatter NOTIFICATION_DATE_FORMAT = DateTimeFormatter.ofPattern("d MMM yyyy, HH:mm");
    /** Kept below the 255-char column limit of RescheduleRequest.reason / TherapySession.cancellationReason, which also carries a prefix. */
    public static final int MAX_STAFF_REASON_LENGTH = 200;
    private final RescheduleRequestRepository rescheduleRepository;
    private final TherapySessionRepository sessionRepository;
    private final NotificationService notificationService;
    private final UserRepository userRepository;
    private final TherapySessionService sessionService;
    private final RescheduleNoticePolicy noticePolicy;

    public List<RescheduleRequest> getAllPendingRequests() {
        return rescheduleRepository.findByStatus(RescheduleStatus.PENDING);
    }

    public List<RescheduleRequest> getRequestsByUserId(UUID userId) {
        return rescheduleRepository.findByRequestedById(userId).stream()
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                .toList();
    }

    public RescheduleRequest getRescheduleRequestById(UUID id) {
        return rescheduleRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Permohonan penjadwalan ulang tidak ditemukan: " + id));
    }

    public List<RescheduleRequest> getAllRequests() {
        return rescheduleRepository.findAllByOrderByCreatedAtDesc();
    }

    /** Whether a parent/therapist may still request a reschedule for this session (notice period not yet passed). */
    public boolean canRequestReschedule(TherapySession session) {
        return noticePolicy.canRequest(session.getStartTime());
    }

    /** Last calendar day on which a reschedule can still be requested for this session. */
    public LocalDate getRescheduleDeadline(TherapySession session) {
        return noticePolicy.deadlineFor(session.getStartTime());
    }

    /** Whether admin / receptionist can move this session directly (still SCHEDULED and not from a previous day). */
    public boolean canStaffReschedule(TherapySession session) {
        return session.getStatus() == SessionStatus.SCHEDULED && noticePolicy.canStaffMove(session.getStartTime());
    }

    @Transactional
    public RescheduleRequest submitRequest(UUID sessionId, UUID requestedByUserId,
                                           LocalDateTime requestedStartTime, String reason, String notes) {

        TherapySession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("sesi tidak ditemukan: " + sessionId));

        if (session.getStatus() != SessionStatus.SCHEDULED) {
            throw new RuntimeException("Hanya sesi berstatus terjadwal yang dapat dijadwalkan ulang. Status sesi saat ini: " + session.getStatus() );
        }

        // Notice period / different date / not in the past. Also guards a null requestedStartTime
        // before it is dereferenced further down.
        noticePolicy.validateRequest(session.getStartTime(), requestedStartTime);

        boolean rescheduleAlreadyPending = rescheduleRepository.findBySessionId(sessionId).stream()
                .anyMatch(r -> r.getStatus() == RescheduleStatus.PENDING);

        if (rescheduleAlreadyPending) {
            throw new RuntimeException("Sesi ini sudah memiliki permohonan penjadwalan ulang yang tertunda");
        }

        User requestedBy = userRepository.findById(requestedByUserId)
                .orElseThrow(() -> new RuntimeException("Pengguna tidak ditemukan: " + requestedByUserId));

        LocalDateTime requestedEndtime = requestedStartTime.plusHours(1);
        sessionService.validateWithinOperatingHours(requestedStartTime.toLocalTime(), requestedEndtime.toLocalTime());
        sessionService.validateNoConflict(session.getTherapist().getId(), requestedStartTime, requestedEndtime, sessionId);

        RescheduleRequest request = RescheduleRequest.builder()
                .session(session)
                .requestedBy(requestedBy)
                .requestedStartTime(requestedStartTime)
                .reason(reason)
                .adminNotes(notes)
                .status(RescheduleStatus.PENDING)
                .build();
        RescheduleRequest saved = rescheduleRepository.save(request);

        List<User> admins = userRepository.findByRole(Role.ADMIN);
        String message = requestedBy.getName() + " mengajukan penjadwalan ulang sesi pada "
                + session.getStartTime().format(NOTIFICATION_DATE_FORMAT) + " ke " + requestedStartTime.format(NOTIFICATION_DATE_FORMAT);
        admins.forEach(admin -> notificationService.notify(admin, NotificationType.RESCHEDULE_REQUESTED, message, session));

        return saved;
    }

    @Transactional
    public RescheduleRequest approveRequest(UUID requestId, String adminNotes) {
        RescheduleRequest request = rescheduleRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Permohonan penjadwalan ulang tidak ditemukan: " + requestId));

        if (request.getStatus() != RescheduleStatus.PENDING) {
            throw new RuntimeException("Hanya permohonan berstatus tertunda yang dapat disetujui. Status saat ini: " + request.getStatus());
        }

        TherapySession oldSession = request.getSession();
        LocalDateTime newStart = request.getRequestedStartTime();
        LocalDateTime newEnd = newStart.plusHours(1);

        // The requested time may have passed while the request sat in the queue. The notice-period
        // rule is intentionally NOT re-checked here - it applies to when the request was submitted.
        noticePolicy.validateNotInPast(newStart);
        sessionService.validateWithinOperatingHours(newStart.toLocalTime(), newEnd.toLocalTime());
        sessionService.validateNoConflict(oldSession.getTherapist().getId(), newStart, newEnd, oldSession.getId());

        TherapySession newSession = moveSession(oldSession, newStart,
                "Dijadwalkan ulang" + (request.getReason() != null ? ": " + request.getReason() : ""));
        request.setStatus(RescheduleStatus.APPROVED);
        request.setAdminNotes(adminNotes);

        User parentUser = oldSession.getPatient().getParent().getUser();
        User therapistUser = oldSession.getTherapist().getUser();

        String approvedMessage = "Sesi pada " + oldSession.getStartTime().format(NOTIFICATION_DATE_FORMAT) + " telah dijadwalkan ulang ke " + newStart.format(NOTIFICATION_DATE_FORMAT);
        notificationService.notify(parentUser, NotificationType.RESCHEDULE_APPROVED, approvedMessage, newSession);
        notificationService.notify(therapistUser, NotificationType.RESCHEDULE_APPROVED, approvedMessage, newSession);

        return rescheduleRepository.save(request);
    }

    /**
     * Direct reschedule by admin / receptionist, for emergencies where a parent or therapist phones
     * the clinic (there is no request / approval step).
     * <p>
     * Skips the minimum-notice and different-date rules that apply to parents and therapists, but
     * still requires: a SCHEDULED session that is not from a previous day, a new time that is not in
     * the past, inside operating hours, and free of therapist conflicts. A reason is mandatory.
     * <p>
     * A RescheduleRequest row is stored as APPROVED with the staff member as {@code requestedBy}, so
     * the move shows up in the existing reschedule history with the acting user and their role.
     * Any PENDING request for the same session is closed as superseded so it cannot linger.
     */
    @Transactional
    public RescheduleRequest staffReschedule(UUID sessionId, UUID staffUserId, LocalDateTime newStart, String reason) {
        User staff = userRepository.findById(staffUserId)
                .orElseThrow(() -> new RuntimeException("Pengguna tidak ditemukan: " + staffUserId));

        if (staff.getRole() != Role.ADMIN && staff.getRole() != Role.RECEPTIONIST) {
            throw new RuntimeException("Hanya admin atau resepsionis yang dapat menjadwalkan ulang sesi secara langsung.");
        }

        String cleanReason = reason == null ? "" : reason.trim();
        if (cleanReason.isEmpty()) {
            throw new RuntimeException("Alasan penjadwalan ulang wajib diisi.");
        }
        if (cleanReason.length() > MAX_STAFF_REASON_LENGTH) {
            throw new RuntimeException("Alasan terlalu panjang (maksimal " + MAX_STAFF_REASON_LENGTH + " karakter).");
        }

        TherapySession oldSession = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("sesi tidak ditemukan: " + sessionId));

        if (oldSession.getStatus() != SessionStatus.SCHEDULED) {
            throw new RuntimeException("Hanya sesi berstatus terjadwal yang dapat dijadwalkan ulang. Status sesi saat ini: " + oldSession.getStatus());
        }

        // No notice period / same-date rule for staff; still rejects null, past times and stale sessions.
        noticePolicy.validateStaffMove(oldSession.getStartTime(), newStart);

        LocalDateTime newEnd = newStart.plusHours(1);
        sessionService.validateWithinOperatingHours(newStart.toLocalTime(), newEnd.toLocalTime());
        sessionService.validateNoConflict(oldSession.getTherapist().getId(), newStart, newEnd, oldSession.getId());

        // Close out pending requests for this session: the session is moving, so they can no longer be actioned.
        String supersededNote = "Digantikan oleh penjadwalan ulang langsung dari staf klinik ke "
                + newStart.format(NOTIFICATION_DATE_FORMAT) + ".";
        rescheduleRepository.findBySessionId(sessionId).stream()
                .filter(r -> r.getStatus() == RescheduleStatus.PENDING)
                .forEach(r -> {
                    r.setStatus(RescheduleStatus.REJECTED);
                    r.setAdminNotes(supersededNote);
                    rescheduleRepository.save(r);
                });

        String oldTimeText = oldSession.getStartTime().format(NOTIFICATION_DATE_FORMAT);
        TherapySession newSession = moveSession(oldSession, newStart,
                "Dijadwalkan ulang oleh staf klinik: " + cleanReason);

        RescheduleRequest record = RescheduleRequest.builder()
                .session(oldSession)
                .requestedBy(staff)
                .requestedStartTime(newStart)
                .reason(cleanReason)
                .adminNotes("Dijadwalkan ulang langsung oleh staf klinik tanpa proses permohonan.")
                .status(RescheduleStatus.APPROVED)
                .build();
        RescheduleRequest saved = rescheduleRepository.save(record);

        User parentUser = oldSession.getPatient().getParent().getUser();
        User therapistUser = oldSession.getTherapist().getUser();
        String message = "Sesi pada " + oldTimeText + " telah dijadwalkan ulang oleh staf klinik ke "
                + newStart.format(NOTIFICATION_DATE_FORMAT) + ". Alasan: " + cleanReason;
        notificationService.notify(parentUser, NotificationType.RESCHEDULE_APPROVED, message, newSession);
        notificationService.notify(therapistUser, NotificationType.RESCHEDULE_APPROVED, message, newSession);

        return saved;
    }

    /**
     * Shared "move" mechanics: books a new SCHEDULED session (1 hour, same package / patient /
     * therapist / session number), then marks the old one RESCHEDULED and links it to the new one.
     * Callers are responsible for validation and notifications.
     */
    private TherapySession moveSession(TherapySession oldSession, LocalDateTime newStart, String cancellationReason) {
        TherapySession newSession = TherapySession.builder()
                .therapyPackage(oldSession.getTherapyPackage())
                .patient(oldSession.getPatient())
                .therapist(oldSession.getTherapist())
                .sessionNumber(oldSession.getSessionNumber())
                .day(newStart.getDayOfWeek())
                .startTime(newStart)
                .endTime(newStart.plusHours(1))
                .status(SessionStatus.SCHEDULED)
                .build();
        sessionRepository.save(newSession);

        oldSession.setStatus(SessionStatus.RESCHEDULED);
        oldSession.setCancellationReason(cancellationReason);
        oldSession.setRescheduledTo(newSession);
        return newSession;
    }

    @Transactional
    public RescheduleRequest rejectRequest(UUID requestId, String adminNotes) {
        RescheduleRequest request = rescheduleRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Permohonan penjadwalan ulang tidak ditemukan: " + requestId));

        if (request.getStatus() != RescheduleStatus.PENDING) {
            throw new RuntimeException("Hanya permohonan berstatus tertunda yang dapat ditolak. Status saat ini: " + request.getStatus());
        }

        request.setStatus(RescheduleStatus.REJECTED);
        request.setAdminNotes(adminNotes);

        String rejectedMessage = "Permohonan penjadwalan ulang Anda untuk sesi pada "
                + request.getSession().getStartTime().format(NOTIFICATION_DATE_FORMAT) + " telah ditolak."
                + (adminNotes != null ? " Catatan: " + adminNotes : "");
        notificationService.notify(request.getRequestedBy(), NotificationType.RESCHEDULE_REJECTED, rejectedMessage, request.getSession());

        return rescheduleRepository.save(request);
    }
}
