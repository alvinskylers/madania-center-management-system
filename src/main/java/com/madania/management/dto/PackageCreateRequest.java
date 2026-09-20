package com.madania.management.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@Data
public class PackageCreateRequest {

    @NotNull(message = "Pasien wajib dipilih")
    private UUID patientId;

    @NotNull(message = "Terapis wajib dipilih")
    private UUID therapistId;

    @NotNull(message = "Jenis paket wajib dipilih")
    private UUID packageTypeId;

    private UUID checkupId;

    @NotBlank(message = "Diagnosis wajib diisi sebelum paket terapi dapat dibuat")
    private String diagnosis;

    @NotNull(message = "Tanggal mulai wajib diisi")
    @FutureOrPresent(message = "Tanggal mulai tidak boleh di masa lalu")
    private LocalDate startDate;

    @NotNull(message = "Jam yang diinginkan wajib diisi")
    private LocalTime preferredTime;

    @NotNull(message = "Silakan pilih hari untuk paket ini")
    private List<DayOfWeek> days;

    private String notes;
}