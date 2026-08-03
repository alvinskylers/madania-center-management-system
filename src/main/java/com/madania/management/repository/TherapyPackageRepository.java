package com.madania.management.repository;

import com.madania.management.entity.TherapyPackage;
import com.madania.management.enums.PackageStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface TherapyPackageRepository extends JpaRepository<TherapyPackage, Long> {
    List<TherapyPackage> findByPatientId(UUID patientId);
    List<TherapyPackage> findByTherapistId(UUID therapistId);
    List<TherapyPackage> findByStatus(PackageStatus status);
}
