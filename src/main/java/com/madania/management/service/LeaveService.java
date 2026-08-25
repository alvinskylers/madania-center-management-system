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

    public Map<TherapySession, LocalDateTime> getSuggestedSlotsForLeave(LeaveRequest leave) {
        List<TherapySession> affected = getAffectedSessions(leave);
        Map<TherapySession, LocalDateTime> suggestions = new LinkedHashMap<>();
        Set<LocalDateTime> claimedSlots = new HashSet<>();

        for (TherapySession session : affected) {
            Optional<LocalDateTime> suggestion = suggestNextAvailableSlot(session, leave.getEndDate(), claimedSlots);
            suggestion.ifPresent(claimedSlots::add);
            suggestions.put(session, suggestion.orElse(null));
        }

        return suggestions;
    }

    @Transactional
    public LeaveRequest approveLeave(UUID leaveId, Map<UUID, LocalDateTime> chosenTimes, String adminNotes) {
        LeaveRequest leave = getRequestById(leaveId);

        if (leave.getStatus() != LeaveStatus.PENDING) {
            throw new RuntimeException("Only a pending leave request can be approved. Current status: " + leave.getStatus());
        }

        List<TherapySession> affected = getAffectedSessions(leave);

        for (TherapySession oldSession : affected) {
            LocalDateTime newStart = chosenTimes.get(oldSession.getId());
            if (newStart == null) {
                throw new RuntimeException("No new time was chosen for session " + oldSession.getSessionNumber()
                        + " on " + oldSession.getStartTime());
            }

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
            oldSession.setCancellationReason("Therapist leave (" + leave.getStartDate() + " to " + leave.getEndDate() + ")");
            oldSession.setRescheduledTo(newSession);

            User parentUser = oldSession.getPatient().getParent().getUser();
            User therapistUser = oldSession.getTherapist().getUser();
            String message = "Session on " + oldSession.getStartTime() + " was moved to " + newStart + " due to therapist leave";
            notificationService.notify(parentUser, NotificationType.RESCHEDULE_APPROVED, message, newSession);
            notificationService.notify(therapistUser, NotificationType.RESCHEDULE_APPROVED, message, newSession);
        }

        leave.setStatus(LeaveStatus.APPROVED);
        leave.setAdminNotes(adminNotes);
        return leaveRepository.save(leave);
    }

    @Transactional
    public LeaveRequest rejectLeave(UUID leaveId, String adminNotes) {
        LeaveRequest leave = getRequestById(leaveId);

        if (leave.getStatus() != LeaveStatus.PENDING) {
            throw new RuntimeException("Only a pending leave request can be rejected. Current status: " + leave.getStatus());
        }

        leave.setStatus(LeaveStatus.REJECTED);
        leave.setAdminNotes(adminNotes);

        String message = "Your leave request for " + leave.getStartDate() + " to " + leave.getEndDate() + " was rejected."
                + (adminNotes != null ? " Note: " + adminNotes : "");
        notificationService.notify(leave.getTherapist().getUser(), NotificationType.LEAVE_REJECTED, message, null);

        return leaveRepository.save(leave);
    }
}