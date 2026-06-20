package com.madania.management.repository;

import com.madania.management.entity.Therapist;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TherapistRepository extends JpaRepository<Therapist, Long> {
    Therapist findByUserId(Long userId);
}
