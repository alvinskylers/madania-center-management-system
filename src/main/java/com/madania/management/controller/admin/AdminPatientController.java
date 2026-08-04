package com.madania.management.controller.admin;

import com.madania.management.dto.PatientRequest;
import com.madania.management.entity.Patient;
import com.madania.management.service.PatientService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.UUID;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminPatientController {

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

    @GetMapping("/patient/{id}")
    public String patient(@PathVariable UUID id, Model model) {
        model.addAttribute("patient", patientService.getPatientById(id));
        return "pages/patient";
    }

    @GetMapping("/patient/{id}/edit")
    public String editPatientForm(@PathVariable UUID id, Model model) {
        Patient patient = patientService.getPatientById(id);

        PatientRequest request = new PatientRequest();
        request.setFullName(patient.getFullName());
        request.setDateOfBirth(patient.getDateOfBirth());
        request.setGender(patient.getGender());
        request.setDiagnosis(patient.getDiagnosis());
        request.setNotes(patient.getNotes());

        model.addAttribute("request", request);
        model.addAttribute("patient", patient);
        return "pages/patient-edit";
    }

    @PostMapping("/patient/{id}/edit")
    public String editPatient(@PathVariable UUID id,
                              @Valid @ModelAttribute("request") PatientRequest request,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes,
                              Model model) {
        if (bindingResult.hasErrors()) {
            bindingResult.getAllErrors().forEach(System.out::println);
            Patient patient = patientService.getPatientById(id);
            model.addAttribute("patient", patient);
            model.addAttribute("bindingResult", bindingResult);
            model.addAttribute("patientId", id);
            return "pages/patient-edit";
        }

        patientService.updatePatient(id, request.getFullName(),
                request.getDateOfBirth(), request.getGender(),
                request.getDiagnosis(), request.getNotes(),
                request.isActive());
        redirectAttributes.addFlashAttribute("success", "Patient successfully updated.");
        return "redirect:/admin/patient/{id}";
    }

    @PostMapping("/patient/{id}/delete")
    public String deletePatient(@PathVariable UUID id,
                                RedirectAttributes redirectAttributes) {
        try {
            patientService.deletePatient(id);
            redirectAttributes.addFlashAttribute("success", "Patient successfully deleted.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/patients";
    }

}
