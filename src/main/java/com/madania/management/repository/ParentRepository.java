package com.madania.management.repository;

import com.madania.management.entity.Parent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ParentRepository extends JpaRepository<Parent, UUID> {

    Optional<Parent> findByUserId(UUID userId);
}
