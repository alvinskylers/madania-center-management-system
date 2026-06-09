package com.madania.management.repository;

import com.madania.management.entity.TherapyDaySchedule;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TherapyDayScheduleRepository extends JpaRepository<TherapyDaySchedule, Long> {
    List<TherapyDaySchedule> findByTherapyPackageId(Long packageId);
}
