package com.madania.management.service;

import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapyPackage;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.PackageStatus;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.TherapyPackageRepository;
import com.madania.management.repository.TherapySessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TherapySessionService {

    private final TherapySessionRepository sessionRepository;
    private final TherapistRepository therapistRepository;
    private final TherapyPackageRepository packageRepository;

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
