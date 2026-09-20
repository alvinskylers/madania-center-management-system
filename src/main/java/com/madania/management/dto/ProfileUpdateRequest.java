package com.madania.management.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ProfileUpdateRequest{

        @NotBlank(message = "Nama lengkap wajib diisi")
        private String username;

        @Email(message = "Masukkan alamat email yang valid")
        @NotBlank(message = "Email wajib diisi")
        private String email;

        private String phone;

        private String address;

        private String specialization;

}
