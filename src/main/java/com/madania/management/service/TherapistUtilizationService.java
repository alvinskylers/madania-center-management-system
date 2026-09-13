package com.madania.management.service;

import com.madania.management.dto.utilization.TherapistUtilizationDto;
import com.madania.management.entity.LeaveRequest;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.LeaveStatus;
import com.madania.management.enums.PackageStatus;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.LeaveRequestRepository;
import com.madania.management.repository.TherapyPackageRepository;
import com.madania.management.repository.TherapySessionRepository;
import com.madania.management.repository.TherapistRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TherapistUtilizationService {

    private static final DateTimeFormatter LEAVE_LABEL_FORMAT = DateTimeFormatter.ofPattern("d MMM");

    private final TherapistRepository therapistRepository;
    private final TherapyPackageRepository packageRepository;
    private final TherapySessionRepository sessionRepository;
    private final LeaveRequestRepository leaveRequestRepository;

    public List<TherapistUtilizationDto> getUtilizationOverview() {
        LocalDate weekStartDate = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate weekEndDate = weekStartDate.plusDays(7);
        LocalDateTime weekStart = weekStartDate.atStartOfDay();
        LocalDateTime weekEnd = weekEndDate.atStartOfDay();

        List<Therapist> therapists = therapistRepository.findAll();

        List<TherapistUtilizationDto> rows = therapists.stream()
                .map(therapist -> buildRow(therapist, weekStart, weekEnd, weekStartDate, weekEndDate))
                .toList();

        double averageSessionsThisWeek = rows.stream()
                .mapToLong(TherapistUtilizationDto::getSessionsThisWeek)
                .average()
                .orElse(0);

        // Flag anyone at least 50% above the group average as overloaded, purely for the
        // summary count and row highlight - not a hard threshold, just a visual signal.
        return rows.stream()
                .map(row -> row.toBuilder()
                        .overloaded(averageSessionsThisWeek > 0 && row.getSessionsThisWeek() > averageSessionsThisWeek * 1.5)
                        .build())
                .toList();
    }

    private TherapistUtilizationDto buildRow(Therapist therapist, LocalDateTime weekStart, LocalDateTime weekEnd,
                                             LocalDate weekStartDate, LocalDate weekEndDate) {
        long activeCaseload = packageRepository.findByTherapistId(therapist.getId()).stream()
                .filter(pkg -> pkg.getStatus() == PackageStatus.ACTIVE)
                .count();

        List<TherapySession> weekSessions = sessionRepository
                .findByTherapistIdAndStartTimeBetween(therapist.getId(), weekStart, weekEnd);
        long sessionsThisWeek = weekSessions.stream()
                .filter(s -> s.getStatus() != SessionStatus.CANCELLED)
                .count();

        List<TherapySession> allSessions = sessionRepository.findByTherapistId(therapist.getId());
        long completed = allSessions.stream().filter(s -> s.getStatus() == SessionStatus.COMPLETED).count();
        long cancelled = allSessions.stream().filter(s -> s.getStatus() == SessionStatus.CANCELLED).count();
        Double completionRate = (completed + cancelled) == 0
                ? null
                : (completed * 100.0) / (completed + cancelled);

        LeaveRequest overlappingLeave = leaveRequestRepository.findByTherapistId(therapist.getId()).stream()
                .filter(leave -> leave.getStatus() == LeaveStatus.APPROVED)
                .filter(leave -> !leave.getEndDate().isBefore(weekStartDate) && !leave.getStartDate().isAfter(weekEndDate.minusDays(1)))
                .findFirst()
                .orElse(null);

        return TherapistUtilizationDto.builder()
                .therapistId(therapist.getId())
                .fullName(therapist.getFullName())
                .activeCaseload(activeCaseload)
                .sessionsThisWeek(sessionsThisWeek)
                .completionRatePercent(completionRate)
                .onLeaveThisWeek(overlappingLeave != null)
                .leaveRangeLabel(overlappingLeave == null ? null :
                        overlappingLeave.getStartDate().format(LEAVE_LABEL_FORMAT) + " - " +
                        overlappingLeave.getEndDate().format(LEAVE_LABEL_FORMAT))
                .build();
    }
}
