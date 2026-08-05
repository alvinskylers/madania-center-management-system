package com.madania.management.service;

import com.madania.management.entity.*;

import com.madania.management.enums.PackageStatus;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TherapyPackageService {

    private final TherapyDayScheduleRepository scheduleRepository;
    private final TherapyPackageRepository packageRepository;
    private final TherapySessionRepository sessionRepository;
    private final TherapistRepository therapistRepository;
    private final PatientRepository patientRepository;
    private final UserRepository userRepository;

    public List<TherapyPackage> getAllPackages(){
        return packageRepository.findAll();
    }

    public TherapyPackage findPackageById(UUID id) {
        return packageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Package with not found with id: " + id));
    }

    public List<DayOfWeek> getDays() {
        return Arrays.asList(DayOfWeek.values());
    }

    @Transactional
    public TherapyPackage createPackage(UUID patientId, UUID therapistId, UUID createdByUserId,
                                        LocalDate startDate, LocalTime preferredTime,
                                        List<DayOfWeek> days, String notes) {

        if (days.size() != 3) {
            throw new RuntimeException("Exactly 3 days must be selected for a package");
        }

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found."));
        Therapist therapist = therapistRepository.findById(therapistId)
                .orElseThrow(() -> new RuntimeException("Therapist not found."));
        User assigner = userRepository.findById(createdByUserId)
                .orElseThrow(() -> new RuntimeException("User not found."));

        TherapyPackage therapyPackage = TherapyPackage.builder()
                .patient(patient)
                .therapist(therapist)
                .createdBy(assigner)
                .startDate(startDate)
                .sessionTime(preferredTime)
                .totalSessions(12)
                .completedSessions(0)
                .status(PackageStatus.ACTIVE)
                .notes(notes)
                .build();
        therapyPackage = packageRepository.save(therapyPackage);

        for (DayOfWeek day : days) {
            TherapyDaySchedule daySchedule = TherapyDaySchedule.builder()
                    .therapyPackage(therapyPackage)
                    .day(day)
                    .build();
            scheduleRepository.save(daySchedule);
        }

        List<TherapySession> sessions = new ArrayList<>();
        LocalDate cursor = startDate;
        int sessionNumber = 1;

        System.out.println("Days received: " + days);
        System.out.println("Days types: " + days.getClass() + " contents type: " + (days.isEmpty() ? "empty" : days.get(0).getClass()));
        while (sessionNumber <= 12 ) {
            if (days.contains((cursor.getDayOfWeek()))) {
                LocalDateTime startTime = LocalDateTime.of(cursor, preferredTime);
                LocalDateTime endTime = startTime.plusHours(1);

                TherapySession session = TherapySession.builder()
                        .therapyPackage(therapyPackage)
                        .patient(patient)
                        .therapist(therapist)
                        .sessionNumber(sessionNumber)
                        .startTime(startTime)
                        .endTime(endTime)
                        .status(SessionStatus.SCHEDULED)
                        .build();
                sessions.add(session);
                sessionNumber++;
            }
            cursor = cursor.plusDays(1);
        }
        sessionRepository.saveAll(sessions);
        therapyPackage.setEndDate(sessions.get(sessions.size() - 1).getStartTime().toLocalDate());
        packageRepository.save(therapyPackage);

        return therapyPackage;
    }

}
