package com.madania.management.dto;

import com.madania.management.enums.ParentDecision;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CheckupCompleteRequest {

    @NotBlank(message = "Catatan diagnosis wajib diisi untuk menyelesaikan checkup")
    private String diagnosisNotes;

    @NotNull(message = "Silakan catat keputusan wali pasien")
    private ParentDecision parentDecision;
}
