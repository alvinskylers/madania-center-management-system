package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

import java.util.List;

@Controller
@RequestMapping("/therapist")
@RequiredArgsConstructor
public class TherapistDashboardController {

    private final TherapySessionService sessionService;

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        List<TherapySession> todaySessions = sessionService
                .getTodaySessionsByTherapistId(therapist.getId());

        List<TherapySession> upcomingSessions = sessionService
                .getUpcomingSessionsByTherapistId(therapist.getId())
                .stream()
                .limit(3)
                .toList();

        List<TherapySession> pendingJournals = sessionService
                .getCompletedSessionsWithoutJournal(therapist.getId());

        long totalPatients = sessionService.getUpcomingSessionsByTherapistId(therapist.getId())
                .stream()
                .map(s -> s.getPatient().getId())
                .distinct()
                .count();

        model.addAttribute("therapist", therapist);
        model.addAttribute("todaySessions", todaySessions);
        model.addAttribute("todayCount", todaySessions.size());
        model.addAttribute("upcomingSessions", upcomingSessions);
        model.addAttribute("pendingJournals", pendingJournals);
        model.addAttribute("pendingJournalCount", pendingJournals.size());
        model.addAttribute("totalPatients", totalPatients);

        return "pages/therapist/dashboard";
    }

}
