package com.madania.management.repository;

import com.madania.management.entity.PackageType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PackageTypeRepository extends JpaRepository<PackageType, UUID> {
    boolean existsByName(String name);
    Optional<PackageType> findByName(String name);
    List<PackageType> findByIsActiveTrue();
}