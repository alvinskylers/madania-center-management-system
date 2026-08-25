package com.madania.management.repository;


import com.madania.management.entity.Patient;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface PatientRepository extends JpaRepository<Patient, UUID> {
    List<Patient> findByParentId(UUID id);
    List<Patient> findByIsActiveTrue();

    @Query("SELECT p FROM Patient p WHERE " +
            "(:query IS NULL OR :query = '' OR " +
            "LOWER(p.fullName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(p.diagnosis) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(p.parent.fullName) LIKE LOWER(CONCAT('%', :query, '%')))")
    Page<Patient> searchPatientsByQuery(Pageable pageable, @Param("query") String query);
}
