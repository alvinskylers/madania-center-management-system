package com.madania.management.repository;

import com.madania.management.entity.TherapyPackage;
import com.madania.management.enums.PackageStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface TherapyPackageRepository extends JpaRepository<TherapyPackage, UUID> {
    List<TherapyPackage> findByPatientId(UUID patientId);
    List<TherapyPackage> findByTherapistId(UUID therapistId);
    List<TherapyPackage> findByStatus(PackageStatus status);

    @Query("SELECT tp FROM TherapyPackage tp WHERE " +
            "(:therapistId IS NULL OR tp.therapist.id = :therapistId) AND " +
            "(:patientId IS NULL OR tp.patient.id = :patientId) AND " +
            "(:dateFrom IS NULL OR tp.startDate >= :dateFrom) AND " +
            "(:dateTo IS NULL OR tp.startDate <= :dateTo)")
    Page<TherapyPackage> searchPackages(Pageable pageable,
                                        @Param("therapistId") UUID therapistId,
                                        @Param("patientId") UUID patientId,
                                        @Param("dateFrom") LocalDate dateFrom,
                                        @Param("dateTo") LocalDate dateTo);

}
