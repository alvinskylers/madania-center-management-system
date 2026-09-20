package com.madania.management.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class ParentEditRequest {

    @NotBlank(message = "Email wajib diisi")
    @Email(message = "Masukkan alamat email yang valid")
    private String email;

    @NotBlank(message = "Nama lengkap wajib diisi")
    private String fullName;

    private String phone;
    private String address;
}