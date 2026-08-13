package com.madania.management.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ProfileUpdateRequest{

        @NotBlank(message = "Full name required")
        private String username;

        @Email(message = "Please provide a valid email")
        @NotBlank(message = "Email is required")
        private String email;

        private String phone;

        private String address;

        private String specialization;

}
