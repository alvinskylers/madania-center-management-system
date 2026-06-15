package com.madania.management.controller;

import com.madania.management.config.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class DashboardController {

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        return switch (userDetails.getUser().getRole()) {
            case ADMIN -> "redirect:/admin/dashboard";
            case THERAPIST -> "redirect:/therapist/dashboard";
            case PARENT -> "redirect:/parent/dashbord";
        };
    }

}
