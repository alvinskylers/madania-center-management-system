package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.JournalRequest;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.entity.TherapySession;
import com.madania.management.service.TherapyJournalService;
import com.madania.management.service.TherapySessionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import java.util.UUID;

@Controller
@RequestMapping("therapist")
@RequiredArgsConstructor
public class TherapistJournalController {

    private final TherapySessionService sessionService;
    private final TherapyJournalService journalService;

    @GetMapping("/journals")
    public String journals(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        model.addAttribute("journals", journalService.getJournalsByTherapistId(therapist.getId()));
        return "pages/therapist/journal/index";
    }

    @GetMapping("/journal/create/{sessionId}")
    public String createJournalForm(@PathVariable UUID sessionId,
                                    Authentication authentication,
                                    Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        TherapySession session = sessionService.getSessionById(sessionId);

        TherapyJournal existing = journalService.getJournalBySessionId(sessionId);
        if (existing != null) {
            return "redirect:/therapist/journal/" + existing.getId() + "/edit";
        }

        model.addAttribute("session", session);
        model.addAttribute("therapist", therapist);
        model.addAttribute("request", new JournalRequest());
        model.addAttribute("therapyTypes", com.madania.management.enums.TherapyType.values());
        model.addAttribute("moodRatings", com.madania.management.enums.MoodRating.values());
        return "pages/therapist/journal/create";
    }

    @PostMapping("/journal/create/{sessionId}")
    public String createJournal(@PathVariable UUID sessionId,
                                @Valid @ModelAttribute("request") JournalRequest request,
                                BindingResult bindingResult,
                                Authentication authentication,
                                Model model) {

        if (bindingResult.hasErrors()) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());
            model.addAttribute("session", sessionService.getSessionById(sessionId));
            model.addAttribute("therapist", therapist);
            model.addAttribute("request", request);
            model.addAttribute("therapyTypes", com.madania.management.enums.TherapyType.values());
            model.addAttribute("moodRatings", com.madania.management.enums.MoodRating.values());
            return "pages/therapist/journal/create";
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        journalService.createJournal(
                sessionId, therapist.getId(),
                request.getTitle(), request.getTherapyType(),
                request.getSessionGoals(), request.getContent(),
                request.getProgressNotes(), request.getGoalsAchieved(),
                request.getParentRecommendations(), request.getMoodRating(),
                request.getDocumentationUrl());

        return "redirect:/therapist/sessions";
    }
}
