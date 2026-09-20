package com.madania.management.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class TherapistCreateRequest{

    @NotBlank(message = "Email wajib diisi")
    @Email(message = "Masukkan alamat email yang valid")
    private String email;

    @NotBlank(message = "Kata sandi wajib diisi")
    @Size(min = 8, message = "Kata sandi minimal 8 karakter")
    private String password;

    @NotBlank(message = "Nama lengkap wajib diisi")
    private String fullName;

    @NotBlank(message = "Spesialisasi wajib diisi")
    private String specialization;

    @NotBlank(message = "Nomor telepon wajib diisi")
    private String phone;

}
