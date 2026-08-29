package com.madania.management.repository;

import com.madania.management.entity.Therapist;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface TherapistRepository extends JpaRepository<Therapist, UUID> {
    Optional<Therapist> findByUserId(UUID id);

    @Query("SELECT t FROM Therapist t WHERE " +
            "(:query IS NULL OR :query = '' OR " +
            "LOWER(t.fullName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(t.specialization) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(t.user.email) LIKE LOWER(CONCAT('%', :query, '%')))")
    Page<Therapist> searchTherapistsByQuery(Pageable pageable, @Param("query") String query);
}
