package com.madania.management.service;

import com.madania.management.entity.RescheduleRequest;
import com.madania.management.entity.TherapySession;
import com.madania.management.entity.User;
import com.madania.management.enums.RescheduleStatus;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.RescheduleRequestRepository;
import com.madania.management.repository.TherapySessionRepository;
import com.madania.management.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RescheduleService {

    private final RescheduleRequestRepository rescheduleRepository;
    private final TherapySessionRepository sessionRepository;
    private final UserRepository userRepository;
    private final TherapySessionService sessionService;

    public List<RescheduleRequest> getAllPendingRequests() {
        return rescheduleRepository.findByStatus(RescheduleStatus.PENDING);
    }

    public RescheduleRequest getRescheduleRequestById(UUID id) {
        return rescheduleRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Request schedule not found: " + id));
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

        return rescheduleRepository.save(request);
    }

}
