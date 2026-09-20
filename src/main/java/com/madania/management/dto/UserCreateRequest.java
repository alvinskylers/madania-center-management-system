package com.madania.management.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserCreateRequest {

    @NotBlank(message = "role wajib diisi")
    private String role;

    @NotBlank(message = "username wajib diisi")
    private String username;

    @NotBlank(message = "email wajib diisi")
    @Email(message = "masukkan alamat email yang valid")
    private String email;

    @NotBlank(message = "password wajib diisi")
    @Size(min = 8, message = "password minimal 8 karakter")
    private String password;

    private String specialization;

    private String phone;
    private String address;
    private String fullName;
}
