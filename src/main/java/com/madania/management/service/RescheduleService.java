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

        TherapySession newSession = TherapySession.builder()
                .therapyPackage(oldSession.getTherapyPackage())
                .patient(oldSession.getPatient())
                .therapist(oldSession.getTherapist())
                .sessionNumber(oldSession.getSessionNumber())
                .day(newStart.getDayOfWeek())
                .startTime(newStart)
                .endTime(newEnd)
                .status(SessionStatus.SCHEDULED)
                .build();
        sessionRepository.save(newSession);

        oldSession.setStatus(SessionStatus.RESCHEDULED);
        oldSession.setCancellationReason(
                "Dijadwalkan ulang" + (request.getReason() != null ? ": " + request.getReason() : "")
        );
        oldSession.setRescheduledTo(newSession);
        request.setStatus(RescheduleStatus.APPROVED);
        request.setAdminNotes(adminNotes);

        User parentUser = oldSession.getPatient().getParent().getUser();
        User therapistUser = oldSession.getTherapist().getUser();

        String approvedMessage = "Sesi pada " + oldSession.getStartTime().format(NOTIFICATION_DATE_FORMAT) + " telah dijadwalkan ulang ke " + newStart.format(NOTIFICATION_DATE_FORMAT);
        notificationService.notify(parentUser, NotificationType.RESCHEDULE_APPROVED, approvedMessage, newSession);
        notificationService.notify(therapistUser, NotificationType.RESCHEDULE_APPROVED, approvedMessage, newSession);

        return rescheduleRepository.save(request);
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
