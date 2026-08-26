package com.madania.management.service;

import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapyPackage;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.PackageStatus;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.TherapyJournalRepository;
import com.madania.management.repository.TherapyPackageRepository;
import com.madania.management.repository.TherapySessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TherapySessionService {

    private static final DateTimeFormatter CONFLICT_DATE_FORMAT = DateTimeFormatter.ofPattern("EEEE, d MMMM yyyy HH:mm");
    private static final LocalTime CLINIC_OPENING = LocalTime.of(8,0);
    private static final LocalTime CLINIC_CLOSING = LocalTime.of(17,0);

    private final TherapySessionRepository sessionRepository;
    private final TherapistRepository therapistRepository;
    private final TherapyPackageRepository packageRepository;
    private final TherapyJournalRepository journalRepository;

    public Therapist getTherapistByUserId(UUID id) {
        return therapistRepository.findByUserId(id)
                .orElseThrow(() -> new RuntimeException("Therapist profile not found for id: " + id));
    }

    public List<TherapySession> getSessionsByTherapistId(UUID therapistId) {
        return sessionRepository.findByTherapistId(therapistId);
    }

    public TherapySession getSessionById(UUID sessionId) {
        return sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found with id: " + sessionId));
    }

    public List<TherapySession> getSessionsByTherapyPackageId(UUID packageId) {
        return sessionRepository.findByTherapyPackageId(packageId);
    }

    public Optional<TherapySession> findConflict(UUID therapistId, LocalDateTime startTime, LocalDateTime endTime, UUID excludeId) {
        List<TherapySession> scheduledSessions = sessionRepository.findByTherapistIdAndStatus(therapistId, SessionStatus.SCHEDULED);

        return scheduledSessions.stream()
                .filter(s -> excludeId == null || !s.getId().equals(excludeId))
                .filter(s -> startTime.isBefore(s.getEndTime()) && endTime.isAfter(s.getStartTime()))
                .findFirst();
    }

    public boolean hasConflict(UUID therapistId, LocalDateTime startTime, LocalDateTime endTime, UUID excludeSessionId) {
        return findConflict(therapistId, startTime, endTime, excludeSessionId).isPresent();
    }

    public void validateNoConflict(UUID therapistId, LocalDateTime startTime, LocalDateTime endTime, UUID excludeSessionId) {
        findConflict(therapistId, startTime, endTime, excludeSessionId).ifPresent(existing -> {
            throw new RuntimeException(
                    "Therapist already has a session with " + existing.getPatient().getFullName() +
                            " on " + existing.getStartTime().format(CONFLICT_DATE_FORMAT) +
                            " (until " + existing.getEndTime().toLocalTime() + "), " +
                            "which overlaps with the requested time on " + startTime.format(CONFLICT_DATE_FORMAT) + "."
            );
        });
    }

    public void validateWithinOperatingHours(LocalTime sessionStart, LocalTime sessionEnd) {
        if (sessionStart.isBefore(CLINIC_OPENING) || sessionEnd.isAfter(CLINIC_CLOSING)) {
            throw new RuntimeException(
                    "Session time " + sessionStart + " - " + sessionEnd +
                            " is outside clinic operating hours (08:00 - 17:00)."
            );
        }
    }

    public List<TherapySession> getSessionsByPatientId(UUID patientId) {
        return sessionRepository.findByPatientId(patientId);
    }

    public List<TherapySession> getTodaySessionsByTherapistId(UUID id) {
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);
        return sessionRepository.findByTherapistIdAndStartTimeBetween(id, startOfDay, endOfDay);
    }

    public List<TherapySession> getUpcomingSessionsByTherapistId(UUID id) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime endOfWeek = now.plusDays(7);
        return  sessionRepository.findByTherapistIdAndStartTimeBetween(id, now, endOfWeek);
    }

    public List<TherapySession> getCompletedSessionsWithoutJournal(UUID id) {
        return sessionRepository.findByTherapistId(id).stream()
                .filter( s -> s.getStatus() == SessionStatus.COMPLETED)
                .filter( s -> journalRepository.findBySessionId(s.getId()).isEmpty())
                .toList();
    }

    public List<TherapySession> getTodaySessionsAllTherapist() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(23 ,59, 59);
        return sessionRepository.findByStartTimeBetween(startOfDay, endOfDay);
    }

    public long countCompletedSessions() {
        return sessionRepository.findAll().stream()
                .filter(s -> s.getStatus() == SessionStatus.COMPLETED)
                .count();
    }

    public List<TherapySession> getUpcomingSessionsByPatientId(UUID id) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime endOfWeek = now.plusDays(7);
        return sessionRepository.findByPatientIdAndStartTimeBetween(id, now, endOfWeek);
    }

    public List<TherapySession> getAllSessions() {
        return sessionRepository.findAll();
    }

    @Transactional
    public void completeSession(UUID sessionId) {
        TherapySession session = getSessionById(sessionId);

        if (session.getStatus() != SessionStatus.SCHEDULED) {
            throw new RuntimeException("Only scheduled sessions can be marked as completed");
        }

        session.setStatus(SessionStatus.COMPLETED);
        sessionRepository.save(session);

        TherapyPackage pkg = session.getTherapyPackage();
        pkg.setCompletedSessions(pkg.getCompletedSessions() + 1);

        if (pkg.getCompletedSessions() >= pkg.getTotalSessions()) {
            pkg.setStatus(PackageStatus.COMPLETED);
        }

        packageRepository.save(pkg);
    }
}
