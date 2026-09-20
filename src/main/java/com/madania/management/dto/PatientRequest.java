package com.madania.management.dto;

import com.madania.management.enums.Gender;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.util.UUID;

@Data
public class PatientRequest {

    private UUID parentId;

    @NotBlank(message = "Nama lengkap wajib diisi")
    private String fullName;

    @NotNull(message = "Tanggal lahir wajib diisi")
    private LocalDate dateOfBirth;

    @NotNull(message = "Jenis kelamin wajib dipilih")
    private Gender gender;

    private String diagnosis;

    private String notes;

    private boolean isActive;
}