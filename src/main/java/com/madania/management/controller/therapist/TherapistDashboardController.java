package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import org.springframework.beans.factory.config.CustomEditorConfigurer;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/therapist")
public class TherapistDashboardController {
    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        model.addAttribute("role", userDetails.getUser().getRole().name());
        return "therapist/dashboard";
    }
}
