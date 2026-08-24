package com.madania.management.service;

import com.madania.management.entity.LeaveRequest;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.entity.User;
import com.madania.management.enums.LeaveStatus;
import com.madania.management.enums.NotificationType;
import com.madania.management.enums.Role;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.LeaveRequestRepository;
import com.madania.management.repository.TherapySessionRepository;
import com.madania.management.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class LeaveService {

    private static final int MAX_SLOT_SEARCH_WEEKS = 8;

    private final LeaveRequestRepository leaveRepository;
    private final TherapySessionRepository sessionRepository;
    private final UserRepository userRepository;
    private final TherapySessionService sessionService;
    private final NotificationService notificationService;

    public List<LeaveRequest> getAllRequests() {
        return leaveRepository.findAllByOrderByCreatedAtDesc();
    }

    public LeaveRequest getRequestById(UUID id) {
        return leaveRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Leave request not found: " + id));
    }

    @Transactional
    public LeaveRequest submitLeave(Therapist therapist, LocalDate startDate, LocalDate endDate, String reason) {
        if (endDate.isBefore(startDate)) {
            throw new RuntimeException("End date cannot be before start date.");
        }

        boolean overlapsExistingLeave = leaveRepository.findByTherapistId(therapist.getId()).stream()
                .filter(l -> l.getStatus() != LeaveStatus.REJECTED)
                .anyMatch(l -> !endDate.isBefore(l.getStartDate()) && !startDate.isAfter(l.getEndDate()));
        if (overlapsExistingLeave) {
            throw new RuntimeException("You already have a leave request covering an overlapping date range.");
        }

        LeaveRequest request = LeaveRequest.builder()
                .therapist(therapist)
                .startDate(startDate)
                .endDate(endDate)
                .reason(reason)
                .status(LeaveStatus.PENDING)
                .build();
        LeaveRequest saved = leaveRepository.save(request);

        List<User> admins = userRepository.findByRole(Role.ADMIN);
        String message = therapist.getFullName() + " requested leave from " + startDate + " to " + endDate;
        admins.forEach(admin -> notificationService.notify(admin, NotificationType.LEAVE_REQUESTED, message, null));

        return saved;
    }

    public List<TherapySession> getAffectedSessions(LeaveRequest leave) {
        LocalDateTime rangeStart = leave.getStartDate().atStartOfDay();
        LocalDateTime rangeEnd = leave.getEndDate().atTime(LocalTime.MAX);

        return sessionRepository.findByTherapistIdAndStartTimeBetween(leave.getTherapist().getId(), rangeStart, rangeEnd)
                .stream()
                .filter(s -> s.getStatus() == SessionStatus.SCHEDULED)
                .toList();
    }

    /**
     * Suggests the next available slot for a session affected by leave, searching forward
     * week-by-week (same weekday/time) starting the day after the leave ends.
     * `claimedSlots` tracks start-times already suggested earlier in this same batch,
     * so two affected sessions don't collide with each other before either is saved.
     */
    public Optional<LocalDateTime> suggestNextAvailableSlot(TherapySession session, LocalDate leaveEndDate,
                                                            Set<LocalDateTime> claimedSlots) {
        LocalTime time = session.getStartTime().toLocalTime();
        LocalDate candidateDate = leaveEndDate.plusDays(1);

        // move forward to the same day-of-week as the original session
        while (candidateDate.getDayOfWeek() != session.getStartTime().getDayOfWeek()) {
            candidateDate = candidateDate.plusDays(1);
        }

        UUID therapistId = session.getTherapist().getId();

        for (int i = 0; i < MAX_SLOT_SEARCH_WEEKS; i++) {
            LocalDateTime candidateStart = LocalDateTime.of(candidateDate, time);
            LocalDateTime candidateEnd = candidateStart.plusHours(1);

            boolean claimedByThisBatch = claimedSlots.contains(candidateStart);
            boolean conflictsInDb = sessionService.hasConflict(therapistId, candidateStart, candidateEnd, session.getId());

            if (!claimedByThisBatch && !conflictsInDb) {
                return Optional.of(candidateStart);
            }
            candidateDate = candidateDate.plusWeeks(1);
        }

        return Optional.empty();
    }
}