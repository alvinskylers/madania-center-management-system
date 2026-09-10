package com.madania.management.service;

import com.madania.management.entity.PackageType;
import com.madania.management.repository.PackageTypeRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PackageTypeService {

    private final PackageTypeRepository packageTypeRepository;

    public List<PackageType> getAllPackageTypes() {
        return packageTypeRepository.findAll();
    }

    public List<PackageType> getActivePackageTypes() {
        return packageTypeRepository.findByIsActiveTrue();
    }

    public PackageType getPackageTypeById(UUID id) {
        return packageTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Package type not found with id: " + id));
    }

    @Transactional
    public PackageType createPackageType(String name, int totalSessions, int sessionsPerWeek) {
        if (name == null || name.isBlank()) {
            throw new RuntimeException("Name is required.");
        }
        if (packageTypeRepository.existsByName(name)) {
            throw new RuntimeException("A package type named \"" + name + "\" already exists.");
        }
        if (totalSessions <= 0 || sessionsPerWeek <= 0) {
            throw new RuntimeException("Total sessions and sessions per week must both be greater than zero.");
        }

        if (totalSessions % sessionsPerWeek != 0) {
            throw new RuntimeException(
                    "Total sessions (" + totalSessions + ") must be evenly divisible by sessions per week (" +
                            sessionsPerWeek + "), otherwise the last week would have a different number of sessions.");
        }

        PackageType packageType = PackageType.builder()
                .name(name)
                .totalSessions(totalSessions)
                .sessionsPerWeek(sessionsPerWeek)
                .isActive(true)
                .build();

        return packageTypeRepository.save(packageType);
    }

    @Transactional
    public void deactivatePackageType(UUID id) {
        PackageType packageType = getPackageTypeById(id);
        packageType.setActive(false);
        packageTypeRepository.save(packageType);
    }

    @Transactional
    public void activatePackageType(UUID id) {
        PackageType packageType = getPackageTypeById(id);
        packageType.setActive(true);
        packageTypeRepository.save(packageType);
    }
}