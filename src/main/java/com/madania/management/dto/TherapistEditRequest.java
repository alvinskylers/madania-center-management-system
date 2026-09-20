package com.madania.management.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class TherapistEditRequest {


    @NotBlank(message = "Email wajib diisi")
    @Email(message = "Masukkan alamat email yang valid")
    private String email;

    @NotBlank(message = "Nama lengkap wajib diisi")
    private String fullName;

    @NotBlank(message = "Spesialisasi wajib diisi")
    private String specialization;

    private String phone;
}