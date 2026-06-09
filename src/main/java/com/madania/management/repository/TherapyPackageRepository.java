package com.madania.management.repository;

import com.madania.management.entity.TherapyPackage;
import com.madania.management.enums.PackageStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TherapyPackageRepository extends JpaRepository<TherapyPackage, Long> {
    List<TherapyPackage> findByPatientId(Long patientId);
    List<TherapyPackage> findByTherapistId(Long therapistId);
    List<TherapyPackage> findByStatus(PackageStatus status);
}
