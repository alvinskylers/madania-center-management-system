package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.Therapist;

import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

@Controller
@RequiredArgsConstructor
@RequestMapping("/therapist")
public class TherapistSessionController {

    private final TherapySessionService sessionService;

    @GetMapping("/sessions")
    public String sessions(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        model.addAttribute("sessions", sessionService.getSessionsByTherapistId(therapist.getId()));

        return "pages/therapist/session/index";
    }
}
