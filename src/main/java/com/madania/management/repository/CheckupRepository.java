package com.madania.management.repository;

import com.madania.management.entity.Checkup;
import com.madania.management.enums.CheckupStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface CheckupRepository extends JpaRepository<Checkup, UUID> {
    List<Checkup> findByPatientId(UUID patientId);
    List<Checkup> findByTherapistId(UUID therapistId);
    List<Checkup> findByStatus(CheckupStatus status);
    List<Checkup> findByTherapistIdAndStatus(UUID therapistId, CheckupStatus status);

    @Query("SELECT c FROM Checkup c WHERE " +
            "(:status IS NULL OR c.status = :status) AND " +
            "(:query IS NULL OR :query = '' OR " +
            "LOWER(c.patient.fullName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(c.therapist.fullName) LIKE LOWER(CONCAT('%', :query, '%')))")
    Page<Checkup> searchCheckups(Pageable pageable, @Param("status") CheckupStatus status, @Param("query") String query);

    List<Checkup> findByScheduledAtBetween(LocalDateTime start, LocalDateTime end);
}
