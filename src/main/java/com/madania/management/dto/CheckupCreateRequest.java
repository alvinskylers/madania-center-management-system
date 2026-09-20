package com.madania.management.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

@Data
public class CheckupCreateRequest {

    @NotNull(message = "Pasien wajib dipilih")
    private UUID patientId;

    @NotNull(message = "Terapis wajib dipilih")
    private UUID therapistId;

    @NotNull(message = "Tanggal wajib diisi")
    @FutureOrPresent(message = "Tanggal tidak boleh di masa lalu")
    private LocalDate date;

    @NotNull(message = "Jam wajib diisi")
    private LocalTime time;

    private String notes;
}
