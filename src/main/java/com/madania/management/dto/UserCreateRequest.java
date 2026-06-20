package com.madania.management.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserCreateRequest {

    @NotBlank(message = "role is required")
    private String role;

    @NotBlank(message = "username is required")
    private String username;

    @NotBlank(message = "email is required")
    @Email(message = "please provide a valid email")
    private String email;

    @NotBlank(message = "password is required")
    @Size(min = 8, message = "password must be at least 8 characters")
    private String password;

    private String specialization;

    private String phone;
    private String address;
    private String fullName;
}
