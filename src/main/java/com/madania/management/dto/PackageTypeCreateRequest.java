package com.madania.management.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PackageTypeCreateRequest {

    @NotBlank(message = "Name is required")
    private String name;

    @NotNull(message = "Total sessions is required")
    @Min(value = 2, message = "Total sessions must be at least 1")
    private Integer totalSessions;

    @NotNull(message = "Sessions per week is required")
    @Min(value = 2, message = "Sessions per week must be at least 1")
    private Integer sessionsPerWeek;
}