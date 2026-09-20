package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.CheckupDiagnosisRequest;
import com.madania.management.entity.Checkup;
import com.madania.management.enums.CheckupStatus;
import com.madania.management.service.CheckupService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.UUID;

@Controller
@RequestMapping("/therapist")
@RequiredArgsConstructor
public class TherapistCheckupController {

    private final CheckupService checkupService;

    @GetMapping("/checkups")
    public String checkups(Authentication authentication, Model model,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "10") int size,
                           @RequestParam(defaultValue = "desc") String sort,
                           @RequestParam(required = false) CheckupStatus status) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Page<Checkup> checkupPage = checkupService.getCheckupsForTherapist(
                userDetails.getUser().getId(), status, page, size, sort);

        model.addAttribute("checkups", checkupPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", checkupPage.getTotalPages());
        model.addAttribute("totalItems", checkupPage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("status", status);
        return "pages/therapist/checkup/index";
    }

    @GetMapping("/checkup/{id}")
    public String viewCheckup(@PathVariable UUID id, Authentication authentication,
                              Model model, RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Checkup checkup = checkupService.getCheckupById(id);

        if (checkup.getTherapist().getUser() == null ||
                !checkup.getTherapist().getUser().getId().equals(userDetails.getUser().getId())) {
            redirectAttributes.addFlashAttribute("error", "Anda tidak ditugaskan untuk checkup tersebut.");
            return "redirect:/therapist/checkups";
        }

        model.addAttribute("checkup", checkup);
        model.addAttribute("diagnosisRequest", new CheckupDiagnosisRequest());
        return "pages/therapist/checkup/view";
    }

    @PostMapping("/checkup/{id}/diagnose")
    public String diagnoseCheckup(@PathVariable UUID id,
                                  @Valid @ModelAttribute("diagnosisRequest") CheckupDiagnosisRequest request,
                                  BindingResult bindingResult,
                                  Authentication authentication,
                                  Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("checkup", checkupService.getCheckupById(id));
            model.addAttribute("bindingResult", bindingResult);
            return "pages/therapist/checkup/view";
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        try {
            checkupService.diagnoseCheckup(id, userDetails.getUser().getId(), request.getDiagnosisNotes());
        } catch (RuntimeException e) {
            model.addAttribute("checkup", checkupService.getCheckupById(id));
            model.addAttribute("diagnosisRequest", request);
            model.addAttribute("error", e.getMessage());
            return "pages/therapist/checkup/view";
        }

        return "redirect:/therapist/checkup/" + id;
    }
}
