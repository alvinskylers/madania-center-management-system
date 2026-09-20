package com.madania.management.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class RescheduleRequestDto {

    @NotNull(message = "Sesi wajib dipilih.")
    private UUID sessionId;

    @NotNull(message = "waktu mulai yang diminta wajib diisi")
    @FutureOrPresent(message = "Waktu yang diminta tidak boleh di masa lalu")
    private LocalDateTime requestedStartTime;

    private String reason;

}
