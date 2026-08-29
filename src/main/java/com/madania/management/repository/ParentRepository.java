package com.madania.management.repository;

import com.madania.management.entity.Parent;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface ParentRepository extends JpaRepository<Parent, UUID> {

    Optional<Parent> findByUserId(UUID userId);

    @Query("SELECT p FROM Parent p WHERE " +
            "(:query IS NULL OR :query = '' OR " +
            "LOWER(p.fullName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(p.user.email) LIKE LOWER(CONCAT('%', :query, '%')))")
    Page<Parent> searchParentsByQuery(Pageable pageable, @Param("query") String query);
}
