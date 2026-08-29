package com.madania.management.controller.admin;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.PackageCreateRequest;
import com.madania.management.entity.TherapyPackage;
import com.madania.management.entity.TherapySession;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.service.PatientService;
import com.madania.management.service.TherapyPackageService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminPackageController {

    private final TherapyPackageService packageService;
    private final PatientService patientService;
    private final TherapistRepository therapistRepository;

    @GetMapping("/packages")
    public String packages(Model model,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "10") int size,
                           @RequestParam(defaultValue = "desc") String sort,
                           @RequestParam(required = false) UUID therapistId,
                           @RequestParam(required = false) UUID patientId,
                           @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFrom,
                           @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateTo) {
        Page<TherapyPackage> packagePage = packageService.getAllQueried(
                therapistId, patientId, dateFrom, dateTo, page, size, sort);

        model.addAttribute("packages", packagePage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", packagePage.getTotalPages());
        model.addAttribute("totalItems", packagePage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("therapistId", therapistId);
        model.addAttribute("patientId", patientId);
        model.addAttribute("dateFrom", dateFrom);
        model.addAttribute("dateTo", dateTo);
        model.addAttribute("therapists", therapistRepository.findAll());
        model.addAttribute("patients", patientService.getActivePatients());
        return "pages/admin/packet/index";
    }

    @GetMapping("/package/{id}")
    public String viewPackage(@PathVariable UUID id, Model model) {
        TherapyPackage therapyPackage = packageService.getPackageById(id);
        List<TherapySession> sessions = packageService.getSessionsByPackageId(id).stream()
                .sorted(Comparator.comparing(TherapySession::getSessionNumber))
                .toList();
        model.addAttribute("therapyPackage", therapyPackage);
        model.addAttribute("sessions", sessions);
        return "pages/admin/packet/view";
    }


    @GetMapping("/package/create")
    public String createPackageForm(Model model) {
        model.addAttribute("request", new PackageCreateRequest());
        model.addAttribute("patients", patientService.getActivePatients());
        model.addAttribute("therapists", therapistRepository.findAll());
        model.addAttribute("days", packageService.getDays());
        return "pages/admin/packet/create";
    }

    @PostMapping("/package/create")
    public String createPackage(@Valid @ModelAttribute("request") PackageCreateRequest request,
                                BindingResult bindingResult,
                                Authentication authentication,
                                Model model) {
        if (bindingResult.hasErrors() || request.getDays() == null || request.getDays().size() != 3) {
            if (request.getDays() != null && request.getDays().size() != 3) {
                model.addAttribute("daysError", "Please select exactly 3 days");
                model.addAttribute("bindingResult", bindingResult);
            }
            model.addAttribute("patients", patientService.getActivePatients());
            model.addAttribute("therapists", therapistRepository.findAll());
            model.addAttribute("days", packageService.getDays());
            model.addAttribute("bindingResult", bindingResult);
            return "pages/admin/packet/create";
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        try {
            packageService.createPackage(
                    request.getPatientId(), request.getTherapistId(),
                    userDetails.getUser().getId(), request.getStartDate(),
                    request.getPreferredTime(), request.getDays(), request.getNotes()
            );
        } catch(RuntimeException e) {
            model.addAttribute("scheduleError", e.getMessage());
            model.addAttribute("patients", patientService.getActivePatients());
            model.addAttribute("therapists", therapistRepository.findAll());
            model.addAttribute("days", packageService.getDays());
            model.addAttribute("bindingResult", bindingResult);
            return "pages/admin/packet/create";
        }

        return "redirect:/admin/packages";
    }

    @PostMapping("/package/{id}/cancel")
    public String cancelPackage(@PathVariable UUID id) {
        packageService.cancelPackage(id);
        return "redirect:/admin/packages";
    }


}
