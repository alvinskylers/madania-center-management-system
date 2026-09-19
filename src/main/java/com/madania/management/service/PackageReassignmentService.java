package com.madania.management.service;

import com.madania.management.dto.reassignment.ConflictDetailDto;
import com.madania.management.dto.reassignment.ReassignConflictCheckResponse;
import com.madania.management.dto.reassignment.SessionConflictDto;
import com.madania.management.entity.*;
import com.madania.management.enums.NotificationType;
import com.madania.management.enums.PackageStatus;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.TherapyPackageRepository;
import com.madania.management.repository.TherapySessionRepository;
import com.madania.management.repository.TherapistRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class PackageReassignmentService {

    private static final DateTimeFormatter NOTIFICATION_DATE_FORMAT = DateTimeFormatter.ofPattern("d MMM yyyy, HH:mm");

    private final TherapyPackageRepository packageRepository;
    private final TherapySessionRepository sessionRepository;
    private final TherapistRepository therapistRepository;
    private final TherapySessionService sessionService;
    private final NotificationService notificationService;

    /**
     * Computes, for every remaining (SCHEDULED) session in the package, what it would conflict
     * with if moved to newTherapistId — checking both against the new therapist's existing
     * schedule AND against the other remaining sessions of this same package (which are also
     * being moved, and an admin-entered override could make two of them collide with each other
     * even though neither collided with the outside world).
     *
     * overrides: sessionId -> admin-proposed new start time, for sessions the admin has already
     * edited in the modal. Sessions without an entry keep their original time.
     */
    public ReassignConflictCheckResponse checkConflicts(UUID packageId, UUID newTherapistId, Map<UUID, LocalDateTime> overrides) {
        TherapyPackage pkg = getActivePackageOrThrow(packageId);
        Therapist newTherapist = getTherapistOrThrow(newTherapistId);
        validateDifferentTherapist(pkg, newTherapist);

        List<TherapySession> remaining = sessionRepository
                .findByTherapyPackageIdAndStatus(packageId, SessionStatus.SCHEDULED);

        // Precompute each remaining session's effective (possibly overridden) start/end time.
        Map<UUID, LocalDateTime[]> effectiveTimes = new HashMap<>();
        for (TherapySession session : remaining) {
            Duration duration = Duration.between(session.getStartTime(), session.getEndTime());
            LocalDateTime effectiveStart = overrides.getOrDefault(session.getId(), session.getStartTime());
            LocalDateTime effectiveEnd = effectiveStart.plus(duration);
            effectiveTimes.put(session.getId(), new LocalDateTime[]{effectiveStart, effectiveEnd});
        }

        List<SessionConflictDto> result = new ArrayList<>();
        boolean anyConflicts = false;

        for (TherapySession session : remaining) {
            LocalDateTime[] effective = effectiveTimes.get(session.getId());
            LocalDateTime effectiveStart = effective[0];
            LocalDateTime effectiveEnd = effective[1];

            List<ConflictDetailDto> conflicts = new ArrayList<>();

            // External: does this proposed time overlap anything already on Therapist B's schedule?
            for (TherapySession external : sessionService.findAllConflicts(newTherapistId, effectiveStart, effectiveEnd, null)) {
                conflicts.add(ConflictDetailDto.builder()
                        .conflictingSessionId(external.getId())
                        .patientName(external.getPatient().getFullName())
                        .startTime(external.getStartTime())
                        .endTime(external.getEndTime())
                        .source("EXTERNAL")
                        .build());
            }

            // Internal: does it overlap another remaining session of THIS package (also moving to Therapist B)?
            for (TherapySession other : remaining) {
                if (other.getId().equals(session.getId())) continue;
                LocalDateTime[] otherEffective = effectiveTimes.get(other.getId());
                boolean overlaps = effectiveStart.isBefore(otherEffective[1]) && effectiveEnd.isAfter(otherEffective[0]);
                if (overlaps) {
                    conflicts.add(ConflictDetailDto.builder()
                            .conflictingSessionId(other.getId())
                            .patientName(other.getPatient().getFullName() + " (Sesi " + other.getSessionNumber() + " dari paket ini)")
                            .startTime(otherEffective[0])
                            .endTime(otherEffective[1])
                            .source("SAME_PACKAGE")
                            .build());
                }
            }

            if (!conflicts.isEmpty()) {
                anyConflicts = true;
            }

            result.add(SessionConflictDto.builder()
                    .sessionId(session.getId())
                    .sessionNumber(session.getSessionNumber())
                    .startTime(effectiveStart)
                    .endTime(effectiveEnd)
                    .overridden(overrides.containsKey(session.getId()))
                    .conflicts(conflicts)
                    .build());
        }

        result.sort(Comparator.comparingInt(SessionConflictDto::getSessionNumber));

        return ReassignConflictCheckResponse.builder()
                .hasConflicts(anyConflicts)
                .sessions(result)
                .build();
    }

    /**
     * Commits the reassignment. Re-validates everything server-side (never trusts that the
     * client's "semua terselesaikan" state is actually conflict-free) before mutating anything.
     *
     * Per spec: history stays put. Completed/cancelled sessions and their journals keep pointing
     * at the original therapist untouched — only the package's own therapist field and the
     * remaining SCHEDULED sessions move. Day/time pattern, session count, and price are otherwise
     * untouched except where the admin explicitly resolved a conflict via override.
     */
    @Transactional
    public TherapyPackage reassignTherapist(UUID packageId, UUID newTherapistId, String reason, Map<UUID, LocalDateTime> overrides) {
        TherapyPackage pkg = getActivePackageOrThrow(packageId);
        Therapist oldTherapist = pkg.getTherapist();
        Therapist newTherapist = getTherapistOrThrow(newTherapistId);
        validateDifferentTherapist(pkg, newTherapist);

        List<TherapySession> remaining = sessionRepository
                .findByTherapyPackageIdAndStatus(packageId, SessionStatus.SCHEDULED);

        ReassignConflictCheckResponse revalidated = checkConflicts(packageId, newTherapistId, overrides);
        if (revalidated.isHasConflicts()) {
            throw new RuntimeException(
                    "Tidak dapat menyelesaikan pengalihan: satu atau lebih sesi yang tersisa masih memiliki konflik jadwal yang belum terselesaikan."
            );
        }

        for (TherapySession session : remaining) {
            session.setTherapist(newTherapist);
            LocalDateTime override = overrides.get(session.getId());
            if (override != null) {
                Duration duration = Duration.between(session.getStartTime(), session.getEndTime());
                sessionService.validateWithinOperatingHours(override.toLocalTime(), override.plus(duration).toLocalTime());
                session.setStartTime(override);
                session.setEndTime(override.plus(duration));
                session.setDay(override.getDayOfWeek());
            }
        }
        sessionRepository.saveAll(remaining);

        pkg.setTherapist(newTherapist);
        packageRepository.save(pkg);

        notifyReassignment(pkg, oldTherapist, newTherapist, reason, remaining);

        return pkg;
    }

    private void notifyReassignment(TherapyPackage pkg, Therapist oldTherapist, Therapist newTherapist,
                                    String reason, List<TherapySession> remaining) {
        // notify() requires an anchor TherapySession; use the earliest remaining one if there is one.
        TherapySession anchor = remaining.stream()
                .min(Comparator.comparingInt(TherapySession::getSessionNumber))
                .orElse(null);
        if (anchor == null) {
            return; // nothing left to notify about (package had no remaining scheduled sessions)
        }

        String patientName = pkg.getPatient().getFullName();
        String baseMessage = "Sesi yang tersisa dalam " + patientName + " paket terapinya telah dialihkan dari "
                + oldTherapist.getFullName() + " ke " + newTherapist.getFullName()
                + " (berlaku mulai " + anchor.getStartTime().format(NOTIFICATION_DATE_FORMAT) + " dan seterusnya)"
                + (reason != null && !reason.isBlank() ? ". Alasan: " + reason : ".");

        notificationService.notify(oldTherapist.getUser(), NotificationType.THERAPIST_REASSIGNED, baseMessage, anchor);
        notificationService.notify(newTherapist.getUser(), NotificationType.THERAPIST_REASSIGNED, baseMessage, anchor);

        User parentUser = pkg.getPatient().getParent().getUser();
        notificationService.notify(parentUser, NotificationType.THERAPIST_REASSIGNED, baseMessage, anchor);
    }

    private TherapyPackage getActivePackageOrThrow(UUID packageId) {
        TherapyPackage pkg = packageRepository.findById(packageId)
                .orElseThrow(() -> new RuntimeException("Paket tidak ditemukan dengan id: " + packageId));
        if (pkg.getStatus() != PackageStatus.ACTIVE) {
            throw new RuntimeException("Hanya terapis dari paket yang aktif yang dapat dialihkan. Status saat ini: " + pkg.getStatus());
        }
        return pkg;
    }

    private Therapist getTherapistOrThrow(UUID therapistId) {
        return therapistRepository.findById(therapistId)
                .orElseThrow(() -> new RuntimeException("Terapis tidak ditemukan dengan id: " + therapistId));
    }

    private void validateDifferentTherapist(TherapyPackage pkg, Therapist newTherapist) {
        if (pkg.getTherapist() != null && pkg.getTherapist().getId().equals(newTherapist.getId())) {
            throw new RuntimeException("Paket ini sudah ditugaskan kepada " + newTherapist.getFullName() + ".");
        }
    }
}
