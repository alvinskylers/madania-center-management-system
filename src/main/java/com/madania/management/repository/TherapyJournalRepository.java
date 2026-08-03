package com.madania.management.repository;

import com.madania.management.entity.TherapyJournal;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TherapyJournalRepository extends JpaRepository<TherapyJournal, Long> {
    List<TherapyJournal> findByTherapistId(UUID therapistId);
    List<TherapyJournal> findByPatientId(UUID patientId);
    Optional<TherapyJournal> findBySessionId(Long sessionId);

}
