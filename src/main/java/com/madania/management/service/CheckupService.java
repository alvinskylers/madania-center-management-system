package com.madania.management.service;

import com.madania.management.entity.Checkup;
import com.madania.management.entity.Patient;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.User;
import com.madania.management.enums.CheckupStatus;
import com.madania.management.enums.ParentDecision;
import com.madania.management.repository.CheckupRepository;
import com.madania.management.repository.PatientRepository;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CheckupService {

    private static final DateTimeFormatter CONFLICT_DATE_FORMAT = DateTimeFormatter.ofPattern("EEEE, d MMMM yyyy HH:mm");
    private static final int CHECKUP_DURATION_MINUTES = 60;

    private final CheckupRepository checkupRepository;
    private final PatientRepository patientRepository;
    private final TherapistRepository therapistRepository;
    private final UserRepository userRepository;
    private final TherapySessionService sessionService;

    public Page<Checkup> getAllQueried(CheckupStatus status, String query, int page, int size, String direction) {
        Sort sort = Sort.by(Sort.Direction.fromString(direction), "scheduledAt");
        Pageable pageable = PageRequest.of(page, size, sort);
        return checkupRepository.searchCheckups(pageable, status, query);
    }

    public Page<Checkup> getCheckupsForTherapist(UUID therapistUserId, CheckupStatus status, int page, int size, String direction) {
        Therapist therapist = therapistRepository.findByUserId(therapistUserId)
                .orElseThrow(() -> new RuntimeException("Therapist profile not found."));
        Sort sort = Sort.by(Sort.Direction.fromString(direction), "scheduledAt");
        Pageable pageable = PageRequest.of(page, size, sort);
        return checkupRepository.searchCheckupsForTherapist(pageable, therapist.getId(), status);
    }

    public Checkup getCheckupById(UUID id) {
        return checkupRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Checkup not found with id: " + id));
    }

    public List<Checkup> getCheckupsByPatientId(UUID patientId) {
        return checkupRepository.findByPatientId(patientId);
    }

    @Transactional
    public Checkup scheduleCheckup(UUID patientId, UUID therapistId, UUID createdByUserId,
                                    LocalDate date, LocalTime time, String notes) {

        LocalDateTime startTime = LocalDateTime.of(date, time);
        LocalDateTime endTime = startTime.plusMinutes(CHECKUP_DURATION_MINUTES);

        sessionService.validateWithinOperatingHours(time, time.plusMinutes(CHECKUP_DURATION_MINUTES));

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found."));
        Therapist therapist = therapistRepository.findById(therapistId)
                .orElseThrow(() -> new RuntimeException("Therapist not found."));
        User createdBy = userRepository.findById(createdByUserId)
                .orElseThrow(() -> new RuntimeException("User not found."));

        // A therapist shouldn't be double-booked between a checkup and a therapy session.
        sessionService.validateNoConflict(therapistId, startTime, endTime, null);
        validateNoCheckupConflict(therapistId, startTime, endTime, null);

        Checkup checkup = Checkup.builder()
                .patient(patient)
                .therapist(therapist)
                .createdBy(createdBy)
                .scheduledAt(startTime)
                .status(CheckupStatus.SCHEDULED)
                .parentDecision(ParentDecision.PENDING)
                .notes(notes)
                .build();

        return checkupRepository.save(checkup);
    }

    @Transactional
    public Checkup diagnoseCheckup(UUID id, UUID therapistUserId, String diagnosisNotes) {
        Checkup checkup = getCheckupById(id);

        if (checkup.getStatus() != CheckupStatus.SCHEDULED) {
            throw new RuntimeException("Only scheduled checkups can be diagnosed.");
        }

        Therapist therapist = therapistRepository.findByUserId(therapistUserId)
                .orElseThrow(() -> new RuntimeException("Therapist profile not found."));

        if (!checkup.getTherapist().getId().equals(therapist.getId())) {
            throw new RuntimeException("You are not the assigned therapist for this checkup.");
        }

        checkup.setStatus(CheckupStatus.COMPLETED);
        checkup.setDiagnosisNotes(diagnosisNotes);

        Patient patient = checkup.getPatient();
        patient.setDiagnosis(diagnosisNotes);
        patientRepository.save(patient);

        return checkupRepository.save(checkup);
    }

    @Transactional
    public Checkup recordParentDecision(UUID id, ParentDecision parentDecision) {
        Checkup checkup = getCheckupById(id);

        if (checkup.getStatus() != CheckupStatus.COMPLETED) {
            throw new RuntimeException("The therapist must enter a diagnosis before the parent's decision can be recorded.");
        }

        checkup.setParentDecision(parentDecision);
        return checkupRepository.save(checkup);
    }

    @Transactional
    public void cancelCheckup(UUID id, String reason) {
        Checkup checkup = getCheckupById(id);

        if (checkup.getStatus() != CheckupStatus.SCHEDULED) {
            throw new RuntimeException("Only scheduled checkups can be cancelled.");
        }

        checkup.setStatus(CheckupStatus.CANCELLED);
        checkup.setCancellationReason(reason);
        checkupRepository.save(checkup);
    }

    private void validateNoCheckupConflict(UUID therapistId, LocalDateTime startTime, LocalDateTime endTime, UUID excludeCheckupId) {
        List<Checkup> scheduled = checkupRepository.findByTherapistIdAndStatus(therapistId, CheckupStatus.SCHEDULED);

        Optional<Checkup> conflict = scheduled.stream()
                .filter(c -> excludeCheckupId == null || !c.getId().equals(excludeCheckupId))
                .filter(c -> {
                    LocalDateTime existingEnd = c.getScheduledAt().plusMinutes(CHECKUP_DURATION_MINUTES);
                    return startTime.isBefore(existingEnd) && endTime.isAfter(c.getScheduledAt());
                })
                .findFirst();

        conflict.ifPresent(existing -> {
            throw new RuntimeException(
                    "Therapist already has a checkup with " + existing.getPatient().getFullName() +
                            " on " + existing.getScheduledAt().format(CONFLICT_DATE_FORMAT) +
                            ", which overlaps with the requested time on " + startTime.format(CONFLICT_DATE_FORMAT) + "."
            );
        });
    }
}
