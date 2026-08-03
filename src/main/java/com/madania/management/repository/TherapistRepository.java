package com.madania.management.repository;

import com.madania.management.entity.Therapist;
import com.madania.management.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface TherapistRepository extends JpaRepository<Therapist, UUID> {

}
