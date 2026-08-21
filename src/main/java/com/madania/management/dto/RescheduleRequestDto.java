package com.madania.management.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class RescheduleRequestDto {

    @NotNull(message = "Session is required.")
    private UUID sessionId;

    @NotNull(message = "requested start time is required")
    @FutureOrPresent(message = "Requested time cannot be in the past")
    private LocalDateTime requestedStartTime;

    private String reason;

}
