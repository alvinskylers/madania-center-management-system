package com.madania.management.controller.receptionist;

import com.madania.management.enums.Role;
import com.madania.management.service.PatientService;
import com.madania.management.service.TherapySessionService;
import com.madania.management.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/receptionist")
@RequiredArgsConstructor
public class ReceptionistDashboardController {

    private final UserService userService;
    private final PatientService patientService;
    private final TherapySessionService sessionService;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("totalParents", userService.countUsersByRole(Role.PARENT));
        model.addAttribute("totalPatients", patientService.countAllPatients());
        model.addAttribute("todaySessions", sessionService.getTodaySessionsAllTherapist());
        model.addAttribute("todaySessionCount", sessionService.getTodaySessionsAllTherapist().size());

        return "pages/receptionist/dashboard";
    }

}