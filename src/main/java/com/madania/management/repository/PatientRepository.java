package com.madania.management.repository;


import com.madania.management.entity.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    List<Patient> findByParentId(Long id);
    List<Patient> findByIsActiveTrue();
}
