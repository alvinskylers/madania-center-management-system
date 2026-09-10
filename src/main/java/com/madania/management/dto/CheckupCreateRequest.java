package com.madania.management.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

@Data
public class CheckupCreateRequest {

    @NotNull(message = "Patient is required")
    private UUID patientId;

    @NotNull(message = "Therapist is required")
    private UUID therapistId;

    @NotNull(message = "Date is required")
    @FutureOrPresent(message = "Date cannot be in the past")
    private LocalDate date;

    @NotNull(message = "Time is required")
    private LocalTime time;

    private String notes;
}
