package com.madania.management.dto;

import com.madania.management.enums.Gender;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.util.UUID;

@Data
public class PatientRequest {

    @NotNull(message = "Parent is required")
    private UUID parentId;

    @NotBlank(message = "Full name is required")
    private String fullName;

    @NotNull(message = "Date of birth is required")
    private LocalDate dateOfBirth;

    private Gender gender;

    private String diagnosis;

    private String notes;
}