package com.madania.management.dto;

import com.madania.management.enums.ParentDecision;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CheckupDecisionRequest {

    @NotNull(message = "Silakan catat keputusan wali pasien")
    private ParentDecision parentDecision;
}
