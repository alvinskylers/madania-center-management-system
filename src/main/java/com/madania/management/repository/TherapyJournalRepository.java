package com.madania.management.repository;

import com.madania.management.entity.TherapyJournal;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface TherapyJournalRepository extends JpaRepository<TherapyJournal, Long> {
    List<TherapyJournal> findByTherapistId(Long therapistId);
    List<TherapyJournal> findByPatientId(Long patientId);
    Optional<TherapyJournal> findBySessionId(Long SessionId);

}
