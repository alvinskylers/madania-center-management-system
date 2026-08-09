package com.madania.management.controller.therapist;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/therapist")
public class TherapistDashboardController {

    @GetMapping("/dashboard")
    public String dashboard() {
        return "pages/therapist/dashboard";
    }

    @GetMapping("/patients")
    public String patient() {
        return "pages/patients";
    }
}
