package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.JournalRequest;
import com.madania.management.entity.Patient;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.TherapyType;
import com.madania.management.enums.MoodRating;
import com.madania.management.repository.PatientRepository;
import com.madania.management.service.JournalCommentService;
import com.madania.management.service.TherapyJournalService;
import com.madania.management.service.TherapySessionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("therapist")
@RequiredArgsConstructor
public class TherapistJournalController {

    private final TherapySessionService sessionService;
    private final TherapyJournalService journalService;
    private final JournalCommentService commentService;
    private final PatientRepository patientRepository;

    @GetMapping("/journals")
    public String journals(Authentication authentication, Model model,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "10") int size,
                           @RequestParam(defaultValue = "desc") String sort,
                           @RequestParam(required = false) UUID patientId,
                           @RequestParam(required = false) Integer sessionNumber,
                           @RequestParam(required = false) LocalDate startDate,
                           @RequestParam(required = false) LocalDate endDate) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        System.out.print(startDate);
        System.out.print(endDate);
        Page<TherapyJournal> journalPage = journalService.getQueriedForTherapist(
                therapist.getId(), patientId, sessionNumber, startDate, endDate, page, size, sort);

        model.addAttribute("journals", journalPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", journalPage.getTotalPages());
        model.addAttribute("totalItems", journalPage.getTotalElements());
        model.addAttribute("pageSize", size);

        List<Patient> myPatients = patientRepository.findDistinctByTherapistId(therapist.getId());
        model.addAttribute("patients", myPatients);
        model.addAttribute("sessionNumbers", List.of(1,2,3,4,5,6,7,8,9,10,11,12));

        model.addAttribute("selectedPatientId", patientId);
        model.addAttribute("selectedSessionNumber", sessionNumber);
        model.addAttribute("selectedStartDate", startDate);
        model.addAttribute("selectedEndDate", endDate);

        return "pages/therapist/journal/index";
    }

    @GetMapping("/journal/{id}")
    public String viewJournal(@PathVariable UUID id, Model model,
                              Authentication authentication,
                              RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        TherapyJournal journal = journalService.getJournalById(id);
        boolean ownsJournal = journal.getTherapist().getId().equals(therapist.getId());
        if (!ownsJournal) {
            redirectAttributes.addFlashAttribute("journalError", "You can only view journal entries you wrote.");
            return "redirect:/therapist/journals";
        }

        model.addAttribute("journal", journal);
        model.addAttribute("comments", commentService.getCommentsForJournal(id));
        return "pages/therapist/journal/view";
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

    @GetMapping("/journal/{id}/edit")
    public String editJournalForm(@PathVariable UUID id, Model model) {
        TherapyJournal journal = journalService.getJournalById(id);

        JournalRequest request = new JournalRequest();
        request.setTitle(journal.getTitle());
        request.setTherapyType(journal.getTherapyType());
        request.setSessionGoals(journal.getSessionGoals());
        request.setContent(journal.getContent());
        request.setProgressNotes(journal.getProgressNotes());
        request.setGoalsAchieved(journal.getGoalsAchieved());
        request.setParentRecommendations(journal.getParentRecommendations());
        request.setMoodRating(journal.getMood());
        request.setDocumentationUrl(journal.getDocumentationUrl());

        model.addAttribute("journal", journal);
        model.addAttribute("request", request);
        model.addAttribute("therapyTypes", TherapyType.values());
        model.addAttribute("moodRatings", MoodRating.values());
        return "pages/therapist/journal/edit";
    }

    @PostMapping("/journal/{id}/edit")
    public String updateJournal(@PathVariable UUID id,
                                @Valid @ModelAttribute("request") JournalRequest request,
                                BindingResult bindingResult,
                                Model model) {
        if (bindingResult.hasErrors()) {
            TherapyJournal journal = journalService.getJournalById(id);
            model.addAttribute("journal", journal);
            model.addAttribute("request", request);
            model.addAttribute("therapyTypes", com.madania.management.enums.TherapyType.values());
            model.addAttribute("moodRatings", com.madania.management.enums.MoodRating.values());
            return "pages/therapist/journal/edit";
        }

        journalService.updateJournal(id,
                request.getTitle(), request.getTherapyType(),
                request.getSessionGoals(), request.getContent(),
                request.getProgressNotes(), request.getGoalsAchieved(),
                request.getParentRecommendations(), request.getMoodRating(),
                request.getDocumentationUrl());

        return "redirect:/therapist/journals";
    }
}