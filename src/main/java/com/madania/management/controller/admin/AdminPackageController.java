package com.madania.management.controller.admin;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.PackageCreateRequest;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.service.PatientService;
import com.madania.management.service.TherapyPackageService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminPackageController {

    private final TherapyPackageService packageService;
    private final PatientService patientService;
    private final TherapistRepository therapistRepository;

    @GetMapping("/packages")
    public String packages(Model model) {
        model.addAttribute("packages", packageService.getAllPackages());
        return "pages/packages";
    }

    @GetMapping("/package/create")
    public String createPackageForm(Model model) {
        model.addAttribute("request", new PackageCreateRequest());
        model.addAttribute("patients", patientService.getActivePatients());
        model.addAttribute("therapists", therapistRepository.findAll());
        model.addAttribute("days", packageService.getDays());
        return "pages/package-create";
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
            return "pages/package-create";
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        System.out.println(userDetails.getUser().getId());
        packageService.createPackage(
                request.getPatientId(), request.getTherapistId(),
                userDetails.getUser().getId(), request.getStartDate(),
                request.getPreferredTime(), request.getDays(), request.getNotes());

        return "redirect:/admin/dashboard";
    }


}
