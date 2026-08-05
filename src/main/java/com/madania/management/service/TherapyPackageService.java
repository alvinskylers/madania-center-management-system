package com.madania.management.service;

import com.madania.management.entity.TherapyPackage;
import com.madania.management.repository.PatientRepository;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.TherapyPackageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TherapyPackageService {

    private final TherapyPackageRepository packageRepository;
    private final TherapistRepository therapistRepository;
    private final PatientRepository patientRepository;

    public List<TherapyPackage> getAllPackages(){
        return packageRepository.findAll();
    }

    public TherapyPackage findPackageById(UUID id) {
        return packageRepository.findById(id).orElseThrow(() -> new RuntimeException("Package with not found with id: " + id));
    }


}
