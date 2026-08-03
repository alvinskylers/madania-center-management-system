package com.madania.management.repository;

import com.madania.management.entity.Therapist;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface TherapistRepository extends JpaRepository<Therapist, UUID> {
    Therapist findByUserId(UUID userId);
}
