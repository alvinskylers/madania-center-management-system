package com.madania.management.controller.admin;

import com.madania.management.dto.PatientRequest;
import com.madania.management.repository.PatientRepository;
import com.madania.management.service.PatientService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminPatientController {

    private final PatientRepository patientRepository;
    private final PatientService patientService;

    @GetMapping("/patients")
    public String patient(Model model) {
        model.addAttribute("patients", patientService.getAllPatients());
        return "pages/patients";
    }

    @GetMapping("/patient/create")
    public String createPatientForm(Model model) {
        model.addAttribute("request", new PatientRequest());
        model.addAttribute("parents", patientService.getAllParents());
        return "pages/patient-create";
    }

    @PostMapping("/patient/create")
    public String createPatient(@Valid @ModelAttribute("request") PatientRequest request,
                                BindingResult bindingResult,
                                Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("parents", patientService.getAllParents());
            model.addAttribute("bindingResult", bindingResult);
            return "pages/patient-create";
        }

        patientService.createPatient(request.getParentId(), request.getFullName(),
                request.getDateOfBirth(), request.getGender(),
                request.getDiagnosis(), request.getNotes());

        return "redirect:/admin/patients";
    }

}
