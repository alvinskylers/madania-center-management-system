package com.madania.management.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PackageTypeCreateRequest {

    @NotBlank(message = "Nama wajib diisi")
    private String name;

    @NotNull(message = "Jumlah sesi wajib diisi")
    @Min(value = 2, message = "Jumlah sesi minimal 1")
    private Integer totalSessions;

    @NotNull(message = "Jumlah sesi per minggu wajib diisi")
    @Min(value = 2, message = "Jumlah sesi per minggu minimal 1")
    private Integer sessionsPerWeek;
}