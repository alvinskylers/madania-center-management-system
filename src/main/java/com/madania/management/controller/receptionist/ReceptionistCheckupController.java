package com.madania.management.controller.receptionist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.CheckupCompleteRequest;
import com.madania.management.dto.CheckupCreateRequest;
import com.madania.management.entity.Checkup;
import com.madania.management.enums.CheckupStatus;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.service.CheckupService;
import com.madania.management.service.PatientService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@Controller
@RequestMapping("/receptionist")
@RequiredArgsConstructor
public class ReceptionistCheckupController {

    private final CheckupService checkupService;
    private final PatientService patientService;
    private final TherapistRepository therapistRepository;

    @GetMapping("/checkups")
    public String checkups(Model model,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "10") int size,
                           @RequestParam(defaultValue = "desc") String sort,
                           @RequestParam(required = false) CheckupStatus status,
                           @RequestParam(required = false) String query) {
        Page<Checkup> checkupPage = checkupService.getAllQueried(status, query, page, size, sort);

        model.addAttribute("checkups", checkupPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", checkupPage.getTotalPages());
        model.addAttribute("totalItems", checkupPage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("status", status);
        model.addAttribute("query", query);
        return "pages/receptionist/checkup/index";
    }

    @GetMapping("/checkup/{id}")
    public String viewCheckup(@PathVariable UUID id, Model model) {
        model.addAttribute("checkup", checkupService.getCheckupById(id));
        model.addAttribute("completeRequest", new CheckupCompleteRequest());
        return "pages/receptionist/checkup/view";
    }

    @GetMapping("/checkup/create")
    public String createCheckupForm(Model model) {
        model.addAttribute("request", new CheckupCreateRequest());
        model.addAttribute("patients", patientService.getActivePatients());
        model.addAttribute("therapists", therapistRepository.findAll());
        return "pages/receptionist/checkup/create";
    }

    @PostMapping("/checkup/create")
    public String createCheckup(@Valid @ModelAttribute("request") CheckupCreateRequest request,
                                BindingResult bindingResult,
                                Authentication authentication,
                                Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("patients", patientService.getActivePatients());
            model.addAttribute("therapists", therapistRepository.findAll());
            model.addAttribute("bindingResult", bindingResult);
            return "pages/receptionist/checkup/create";
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        try {
            checkupService.scheduleCheckup(
                    request.getPatientId(), request.getTherapistId(), userDetails.getUser().getId(),
                    request.getDate(), request.getTime(), request.getNotes()
            );
        } catch (RuntimeException e) {
            model.addAttribute("scheduleError", e.getMessage());
            model.addAttribute("patients", patientService.getActivePatients());
            model.addAttribute("therapists", therapistRepository.findAll());
            return "pages/receptionist/checkup/create";
        }

        return "redirect:/receptionist/checkups";
    }

    @PostMapping("/checkup/{id}/complete")
    public String completeCheckup(@PathVariable UUID id,
                                  @Valid @ModelAttribute("completeRequest") CheckupCompleteRequest request,
                                  BindingResult bindingResult,
                                  Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("checkup", checkupService.getCheckupById(id));
            model.addAttribute("bindingResult", bindingResult);
            return "pages/receptionist/checkup/view";
        }

        try {
            checkupService.completeCheckup(id, request.getDiagnosisNotes(), request.getParentDecision());
        } catch (RuntimeException e) {
            model.addAttribute("checkup", checkupService.getCheckupById(id));
            model.addAttribute("completeRequest", request);
            model.addAttribute("error", e.getMessage());
            return "pages/receptionist/checkup/view";
        }

        return "redirect:/receptionist/checkup/" + id;
    }

    @PostMapping("/checkup/{id}/cancel")
    public String cancelCheckup(@PathVariable UUID id, @RequestParam(required = false) String reason) {
        checkupService.cancelCheckup(id, reason);
        return "redirect:/receptionist/checkups";
    }
}
