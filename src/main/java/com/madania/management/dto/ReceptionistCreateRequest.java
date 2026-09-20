package com.madania.management.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class ReceptionistCreateRequest {

    @NotBlank(message = "Username wajib diisi")
    @Size(min = 3, max = 50, message = "Username harus terdiri dari 3 hingga 50 karakter")
    private String username;

    @NotBlank(message = "Email wajib diisi")
    @Email(message = "Masukkan alamat email yang valid")
    private String email;

    @NotBlank(message = "Kata sandi wajib diisi")
    @Size(min = 8, message = "Kata sandi minimal 8 karakter")
    private String password;
}
