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
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TherapySessionService {

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
