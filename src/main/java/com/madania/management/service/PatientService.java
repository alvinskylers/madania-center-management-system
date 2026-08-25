package com.madania.management.service;

import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.enums.Gender;
import com.madania.management.repository.ParentRepository;
import com.madania.management.repository.PatientRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PatientService {

    private final PatientRepository patientRepository;
    private final ParentRepository parentRepository;

    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    public Page<Patient> getAllQueried(String query, int page, int size, String direction) {
        Sort sort = Sort.by(Sort.Direction.fromString(direction), "createdAt");
        Pageable pageable = PageRequest.of(page, size, sort);
        return patientRepository.searchPatientsByQuery(pageable, query);
    }

    public List<Parent> getAllParents() {
        return parentRepository.findAll();
    }

    public List<Patient> getActivePatients() {
        return patientRepository.findByIsActiveTrue();
    }

    public List<Patient> getPatientsByParent(UUID id) {
        return patientRepository.findByParentId(id);
    }

    public Patient getPatientById(UUID id) {
        return patientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Patient not found with id: " + id));
    }

    public long countActivePatients() {
        return patientRepository.findByIsActiveTrue().size();
    }

    public long countAllPatients() {
        return patientRepository.findAll().size();
    }

    @Transactional
    public Patient createPatient(UUID parentId, String fullName, LocalDate dateOfBirth,
                                 Gender gender, String diagnosis, String notes) {
        Parent parent = parentRepository.findById(parentId)
                .orElseThrow(() -> new RuntimeException("Parent not found with id: " + parentId));

        Patient patient = Patient.builder()
                .parent(parent)
                .fullName(fullName)
                .dateOfBirth(dateOfBirth)
                .gender(gender)
                .diagnosis(diagnosis)
                .notes(notes)
                .isActive(true)
                .build();

        return patientRepository.save(patient);
    }

    @Transactional
    public Patient updatePatient(UUID id, String fullName, LocalDate dateOfBirth,
                                 Gender gender, String diagnosis, String notes, boolean active) {
        Patient patient = getPatientById(id);

        patient.setFullName(fullName);
        patient.setDateOfBirth(dateOfBirth);
        patient.setGender(gender);
        patient.setDiagnosis(diagnosis);
        patient.setNotes(notes);
        patient.setActive(active);

        return patientRepository.save(patient);
    }

    @Transactional
    public void deletePatient(UUID id) {
        Patient patient = getPatientById(id);

        if (patient.isActive()) {
            throw new RuntimeException("Cannot delete an active patient. Please deactivate the patient first.");
        }

        patientRepository.delete(patient);
    }

}
