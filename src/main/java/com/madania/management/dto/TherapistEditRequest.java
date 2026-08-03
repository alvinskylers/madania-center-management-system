package com.madania.management.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class TherapistEditRequest {


    @NotBlank(message = "Email is required")
    @Email(message = "Please provide a valid email")
    private String email;

    @NotBlank(message = "Full name is required")
    private String fullName;

    @NotBlank(message = "Specialization is required")
    private String specialization;

    private String phone;
}