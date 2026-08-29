package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.PackageJournalGroup;
import com.madania.management.dto.SessionJournalPair;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapyPackage;
import com.madania.management.entity.TherapySession;
import com.madania.management.service.TherapyJournalService;
import com.madania.management.service.TherapyPackageService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@RequestMapping("/therapist")
public class TherapistSessionController {

    private final TherapySessionService sessionService;
    private final TherapyPackageService packageService;
    private final TherapyJournalService journalService;

    @GetMapping("/sessions")
    public String sessions(Authentication authentication, Model model,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "5") int size,
                           @RequestParam(required = false) UUID patientId,
                           @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFrom,
                           @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateTo) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        Page<TherapyPackage> packagePage = packageService.getAllQueried(
                therapist.getId(), patientId, dateFrom, dateTo, page, size, "desc");

        List<PackageJournalGroup> packageGroups = packagePage.getContent().stream()
                .map(this::buildPackageJournalGroup)
                .toList();

        model.addAttribute("packageGroups", packageGroups);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", packagePage.getTotalPages());
        model.addAttribute("totalItems", packagePage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("patientId", patientId);
        model.addAttribute("dateFrom", dateFrom);
        model.addAttribute("dateTo", dateTo);
        model.addAttribute("patients", packageService.getAssignedPatients(therapist.getId()));

        return "pages/therapist/session/index";
    }

    @PostMapping("/session/{sessionId}/complete")
    public String completeSession(@PathVariable UUID sessionId,
                                  @RequestParam(defaultValue = "0") int page,
                                  @RequestParam(defaultValue = "5") int size,
                                  @RequestParam(required = false) UUID patientId,
                                  @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFrom,
                                  @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateTo,
                                  RedirectAttributes redirectAttributes) {
        try {
            sessionService.completeSession(sessionId);
            redirectAttributes.addFlashAttribute("success", "Session marked as completed.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        StringBuilder redirect = new StringBuilder("redirect:/therapist/sessions?page=" + page + "&size=" + size);
        if (patientId != null) redirect.append("&patientId=").append(patientId);
        if (dateFrom != null) redirect.append("&dateFrom=").append(dateFrom);
        if (dateTo != null) redirect.append("&dateTo=").append(dateTo);
        return redirect.toString();
    }

    private PackageJournalGroup buildPackageJournalGroup(TherapyPackage pkg) {
        List<SessionJournalPair> pairs = sessionService.getSessionsByTherapyPackageId(pkg.getId()).stream()
                .sorted(Comparator.comparing(TherapySession::getSessionNumber))
                .map(session -> new SessionJournalPair(session, journalService.getJournalBySessionId(session.getId())))
                .toList();
        return new PackageJournalGroup(pkg, pairs);
    }
}