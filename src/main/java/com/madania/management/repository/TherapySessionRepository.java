package com.madania.management.repository;

import com.madania.management.entity.TherapySession;
import com.madania.management.enums.SessionStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface TherapySessionRepository extends JpaRepository<TherapySession, Long> {
    List<TherapySession> findByTherapyPackageId(Long packageId);
    List<TherapySession> findByPatientId(Long patientId);
    List<TherapySession> findByPatientIdAndStatus(Long patientId, SessionStatus status);
    List<TherapySession> findByTherapistId(Long therapistId);
    List<TherapySession> findByTherapistIdAndStatus(Long therapistId, SessionStatus status);
    List<TherapySession> findByStartTimeBetween(LocalDateTime start, LocalDateTime end);
    List<TherapySession> findByTherapistIdAndStartTimeBetween(Long therapistId, LocalDateTime start, LocalDateTime end);
    List<TherapySession> findByPatientIdAndStartTimeBetween(Long patientId, LocalDateTime start, LocalDateTime end);
}