package com.madania.management.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ChangePasswordRequest {

    @NotBlank(message = "Kata sandi saat ini wajib diisi")
    private String currentPassword;

    @NotBlank(message = "Kata sandi baru wajib diisi")
    @Size(min = 8, message = "Kata sandi baru minimal 8 karakter")
    private String newPassword;

    @NotBlank(message = "Silakan konfirmasi kata sandi baru Anda")
    private String confirmPassword;
}