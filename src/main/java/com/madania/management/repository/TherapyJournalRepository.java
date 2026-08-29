package com.madania.management.repository;

import com.madania.management.entity.TherapyJournal;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TherapyJournalRepository extends JpaRepository<TherapyJournal, UUID> {
    List<TherapyJournal> findByTherapistId(UUID therapistId);
    List<TherapyJournal> findByPatientId(UUID patientId);
    Optional<TherapyJournal> findBySessionId(UUID sessionId);

    @Query("SELECT j FROM TherapyJournal j WHERE " +
            "(:therapistId IS NULL OR j.therapist.id = :therapistId) AND " +
            "(:patientId IS NULL OR j.patient.id = :patientId) AND " +
            "(:sessionNumber IS NULL OR j.session.sessionNumber = :sessionNumber)")
    Page<TherapyJournal> searchJournals(Pageable pageable,
                                        @Param("therapistId") UUID therapistId,
                                        @Param("patientId") UUID patientId,
                                        @Param("sessionNumber") Integer sessionNumber);

    @Query("SELECT j FROM TherapyJournal j WHERE j.patient.parent.id = :parentId AND " +
            "j.patient.id = COALESCE(:patientId, j.patient.id) AND " +
            "j.session.sessionNumber = COALESCE(:sessionNumber, j.session.sessionNumber) AND " +
            "j.createdAt >= COALESCE(:startDate, j.createdAt) AND " +
            "j.createdAt <= COALESCE(:endDate, j.createdAt)")
    Page<TherapyJournal> searchJournalsForParent(Pageable pageable,
                                                 @Param("parentId") UUID parentId,
                                                 @Param("patientId") UUID patientId,
                                                 @Param("sessionNumber") Integer sessionNumber,
                                                 @Param("startDate") LocalDateTime startDate,
                                                 @Param("endDate") LocalDateTime endDate);
}
