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

    public List<RescheduleRequest> getAllPendingRequests() {
        return rescheduleRepository.findByStatus(RescheduleStatus.PENDING);
    }

    public RescheduleRequest getRescheduleRequestById(UUID id) {
        return rescheduleRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Request schedule not found: " + id));
    }

    public List<RescheduleRequest> getAllRequests() {
        return rescheduleRepository.findAllByOrderByCreatedAtDesc();
    }

    @Transactional
    public RescheduleRequest submitRequest(UUID sessionId, UUID requestedByUserId,
                                           LocalDateTime requestedStartTime, String reason, String notes) {

        TherapySession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("session not found: " + sessionId));

        if (session.getStatus() != SessionStatus.SCHEDULED) {
            throw new RuntimeException("Only a scheduled session can be rescheduled. Current session status: " + session.getStatus() );
        }

        boolean rescheduleAlreadyPending = rescheduleRepository.findBySessionId(sessionId).stream()
                .anyMatch(r -> r.getStatus() == RescheduleStatus.PENDING);

        if (rescheduleAlreadyPending) {
            throw new RuntimeException("This session already has a pending reschedule request");
        }

        User requestedBy = userRepository.findById(requestedByUserId)
                .orElseThrow(() -> new RuntimeException("User not found: " + requestedByUserId));

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
        String message = requestedBy.getName() + " requested to reschedule a session on "
                + session.getStartTime().format(NOTIFICATION_DATE_FORMAT) + " to " + requestedStartTime.format(NOTIFICATION_DATE_FORMAT);
        admins.forEach(admin -> notificationService.notify(admin, NotificationType.RESCHEDULE_REQUESTED, message, session));

        return saved;
    }

    @Transactional
    public RescheduleRequest approveRequest(UUID requestId, String adminNotes) {
        RescheduleRequest request = rescheduleRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Reschedule request not found: " + requestId));

        if (request.getStatus() != RescheduleStatus.PENDING) {
            throw new RuntimeException("Only a pending request can be approved. Current status: " + request.getStatus());
        }

        TherapySession oldSession = request.getSession();
        LocalDateTime newStart = request.getRequestedStartTime();
        LocalDateTime newEnd = newStart.plusHours(1);

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
                "Rescheduled" + (request.getReason() != null ? ": " + request.getReason() : "")
        );
        oldSession.setRescheduledTo(newSession);
        request.setStatus(RescheduleStatus.APPROVED);
        request.setAdminNotes(adminNotes);

        User parentUser = oldSession.getPatient().getParent().getUser();
        User therapistUser = oldSession.getTherapist().getUser();

        String approvedMessage = "Session on " + oldSession.getStartTime().format(NOTIFICATION_DATE_FORMAT) + " has been rescheduled to " + newStart.format(NOTIFICATION_DATE_FORMAT);
        notificationService.notify(parentUser, NotificationType.RESCHEDULE_APPROVED, approvedMessage, newSession);
        notificationService.notify(therapistUser, NotificationType.RESCHEDULE_APPROVED, approvedMessage, newSession);

        return rescheduleRepository.save(request);
    }

    @Transactional
    public RescheduleRequest rejectRequest(UUID requestId, String adminNotes) {
        RescheduleRequest request = rescheduleRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Reschedule request not found: " + requestId));

        if (request.getStatus() != RescheduleStatus.PENDING) {
            throw new RuntimeException("Only a pending request can be rejected. Current status: " + request.getStatus());
        }

        request.setStatus(RescheduleStatus.REJECTED);
        request.setAdminNotes(adminNotes);

        String rejectedMessage = "Your reschedule request for the session on "
                + request.getSession().getStartTime().format(NOTIFICATION_DATE_FORMAT) + " was rejected."
                + (adminNotes != null ? " Note: " + adminNotes : "");
        notificationService.notify(request.getRequestedBy(), NotificationType.RESCHEDULE_REJECTED, rejectedMessage, request.getSession());

        return rescheduleRepository.save(request);
    }
}
