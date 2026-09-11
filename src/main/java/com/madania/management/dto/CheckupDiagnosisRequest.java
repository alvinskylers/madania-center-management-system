package com.madania.management.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CheckupDiagnosisRequest {

    @NotBlank(message = "Diagnosis notes are required")
    private String diagnosisNotes;
}
