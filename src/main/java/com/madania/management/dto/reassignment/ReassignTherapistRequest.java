package com.madania.management.dto.reassignment;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
public class ReassignTherapistRequest {

    @NotNull(message = "Silakan pilih terapis untuk pengalihan.")
    private UUID newTherapistId;

    private String reason;

    /** Manually resolved times for sessions that had a schedule conflict. Empty/absent if none. */
    private List<SessionOverrideDto> overrides = new ArrayList<>();
}
