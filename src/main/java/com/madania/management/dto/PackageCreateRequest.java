package com.madania.management.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@Data
public class PackageCreateRequest {

    @NotNull(message = "Patient is required")
    private UUID patientId;

    @NotNull(message = "Therapist is required")
    private UUID therapistId;

    @NotNull(message = "Package type is required")
    private UUID packageTypeId;

    @NotBlank(message = "Diagnosis is required before a therapy package can be created")
    private String diagnosis;

    @NotNull(message = "Start date is required")
    @FutureOrPresent(message = "Start date cannot be in the past")
    private LocalDate startDate;

    @NotNull(message = "Preferred time is required")
    private LocalTime preferredTime;

    @NotNull(message = "Please select the days for this package")
    private List<DayOfWeek> days;

    private String notes;
}