package com.madania.management.controller.admin;

import com.madania.management.repository.PatientRepository;
import com.madania.management.service.PatientService;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
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
}
