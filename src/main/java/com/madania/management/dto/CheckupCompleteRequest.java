package com.madania.management.dto;

import com.madania.management.enums.ParentDecision;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CheckupCompleteRequest {

    @NotBlank(message = "Diagnosis notes are required to complete a checkup")
    private String diagnosisNotes;

    @NotNull(message = "Please record the parent's decision")
    private ParentDecision parentDecision;
}
