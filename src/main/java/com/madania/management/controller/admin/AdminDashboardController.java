package com.madania.management.controller.admin;

import com.madania.management.entity.TherapyPackage;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.Role;
import com.madania.management.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminDashboardController {

    private final UserService userService;
    private final PatientService patientService;
    private final TherapyJournalService journalService;
    private final TherapySessionService sessionService;
    private final TherapyPackageService packageService;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        // user counts
        model.addAttribute("totalTherapists", userService.countUsersByRole(Role.THERAPIST));
        model.addAttribute("totalParents", userService.countUsersByRole(Role.PARENT));

        // patient counts
        model.addAttribute("totalPatients", patientService.countAllPatients());
        model.addAttribute("totalUsers", userService.countAllUsers());

        // package counts
        model.addAttribute("activePackages", packageService.countActivePackages());
        model.addAttribute("completedPackages", packageService.countCompletedPackages());

        // session counts
        model.addAttribute("todaySessionCount", sessionService.getTodaySessionsAllTherapist().size());
        model.addAttribute("totalCompletedSessions", sessionService.countCompletedSessions());

        // journal count
        model.addAttribute("totalJournals", journalService.countAllJournals());

        // lists
        model.addAttribute("todaySessions", sessionService.getTodaySessionsAllTherapist());
        model.addAttribute("recentPackages", packageService.getRecentPackages());


        return "pages/admin/dashboard";
    }


}