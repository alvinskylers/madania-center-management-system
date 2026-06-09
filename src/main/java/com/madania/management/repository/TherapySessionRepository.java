package com.madania.management.repository;

import com.madania.management.entity.TherapySession;
import com.madania.management.enums.SessionStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface TherapySessionRepository extends JpaRepository<TherapySession, Long> {
    List<TherapySession> findByTherapyPackage(Long packageId);
    List<TherapySession> findByPatientId(Long patientId);
    List<TherapySession> findByPatientAndStatus(Long patientId, SessionStatus status);
    List<TherapySession> findByTherapistId(Long therapistId);
    List<TherapySession> findByTherapistAndStatus(Long therapistId, SessionStatus status);
    List<TherapySession> findByTime(LocalDateTime time);
    List<TherapySession> findByTime(LocalDateTime start, LocalDateTime end);
    List<TherapySession> findByTherapistIdAndTime(Long therapistId, LocalDateTime time);
    List<TherapySession> findByPatientIdAndTime(Long patientId, LocalDateTime time);
}
