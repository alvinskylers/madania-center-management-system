package com.madania.management.repository;

import com.madania.management.entity.Therapist;

public interface TherapistRepository {
    Therapist findByUsername(Long userId);
}
