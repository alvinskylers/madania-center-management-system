package com.madania.management.repository;

import com.madania.management.entity.TherapySession;
import com.madania.management.enums.SessionStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface TherapySessionRepository extends JpaRepository<TherapySession, Long> {
    List<TherapySession> findByTherapyPackageId(Long packageId);
    List<TherapySession> findByPatientId(Long patientId);
    List<TherapySession> findByPatientIdAndStatus(Long patientId, SessionStatus status);
    List<TherapySession> findByTherapistId(UUID therapistId);
    List<TherapySession> findByTherapistIdAndStatus(UUID therapistId, SessionStatus status);
    List<TherapySession> findByStartTimeBetween(LocalDateTime start, LocalDateTime end);
    List<TherapySession> findByTherapistIdAndStartTimeBetween(UUID therapistId, LocalDateTime start, LocalDateTime end);
    List<TherapySession> findByPatientIdAndStartTimeBetween(Long patientId, LocalDateTime start, LocalDateTime end);
}