package com.madania.management.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CheckupDiagnosisRequest {

    @NotBlank(message = "Catatan diagnosis wajib diisi")
    private String diagnosisNotes;
}
