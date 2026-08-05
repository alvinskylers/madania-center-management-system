package com.madania.management.repository;

import com.madania.management.entity.TherapyDaySchedule;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface TherapyDayScheduleRepository extends JpaRepository<TherapyDaySchedule, Long> {
    List<TherapyDaySchedule> findByTherapyPackageId(UUID packageId);
}
