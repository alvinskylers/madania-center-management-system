package com.madania.management.repository;

import com.madania.management.entity.Patient;
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
            "tp.therapist.id = COALESCE(:therapistId, tp.therapist.id) AND " +
            "tp.patient.id = COALESCE(:patientId, tp.patient.id) AND " +
            "tp.startDate >= COALESCE(:dateFrom, tp.startDate) AND " +
            "tp.startDate <= COALESCE(:dateTo, tp.startDate)")
    Page<TherapyPackage> searchPackages(Pageable pageable,
                                        @Param("therapistId") UUID therapistId,
                                        @Param("patientId") UUID patientId,
                                        @Param("dateFrom") LocalDate dateFrom,
                                        @Param("dateTo") LocalDate dateTo);

    @Query("SELECT DISTINCT tp.patient FROM TherapyPackage tp " +
            "WHERE tp.therapist.id = :therapistId ORDER BY tp.patient.fullName")
    List<Patient> findDistinctPatientsByTherapistId(@Param("therapistId") UUID therapistId);


}
