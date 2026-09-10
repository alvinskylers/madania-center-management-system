package com.madania.management.controller.receptionist;

import com.madania.management.dto.PatientRequest;
import com.madania.management.entity.Patient;
import com.madania.management.service.PatientService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.UUID;

@Controller
@RequestMapping("/receptionist")
@RequiredArgsConstructor
public class ReceptionistPatientController {

    private final PatientService patientService;

    @GetMapping("/patients")
    public String patients(Model model,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "12") int size,
                           @RequestParam(defaultValue = "asc") String sort,
                           @RequestParam(required = false) String query) {
        Page<Patient> patientPage = patientService.getAllQueried(query, page, size, sort);

        model.addAttribute("patients", patientPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", patientPage.getTotalPages());
        model.addAttribute("totalItems", patientPage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("query", query);

        return "pages/receptionist/patient/index";
    }

    @GetMapping("/patient/create")
    public String createPatientForm(Model model) {
        model.addAttribute("request", new PatientRequest());
        model.addAttribute("parents", patientService.getAllParents());
        return "pages/receptionist/patient/create";
    }

    @PostMapping("/patient/create")
    public String createPatient(@Valid @ModelAttribute("request") PatientRequest request,
                                BindingResult bindingResult,
                                RedirectAttributes redirectAttributes,
                                Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("parents", patientService.getAllParents());
            model.addAttribute("bindingResult", bindingResult);
            return "pages/receptionist/patient/create";
        }

        patientService.createPatient(request.getParentId(), request.getFullName(),
                request.getDateOfBirth(), request.getGender(),
                null, null);
        redirectAttributes.addFlashAttribute("success", "Patient successfully registered.");
        return "redirect:/receptionist/patients";
    }

    @GetMapping("/patient/{id}/edit")
    public String editPatientForm(@PathVariable UUID id, Model model) {
        Patient patient = patientService.getPatientById(id);

        PatientRequest request = new PatientRequest();
        request.setFullName(patient.getFullName());
        request.setDateOfBirth(patient.getDateOfBirth());
        request.setGender(patient.getGender());
        request.setActive(patient.isActive());

        model.addAttribute("request", request);
        model.addAttribute("patient", patient);
        return "pages/receptionist/patient/edit";
    }

    @PostMapping("/patient/{id}/edit")
    public String editPatient(@PathVariable UUID id,
                              @Valid @ModelAttribute("request") PatientRequest request,
                              BindingResult bindingResult,
                              RedirectAttributes redirectAttributes,
                              Model model) {
        Patient existingPatient = patientService.getPatientById(id);

        if (bindingResult.hasErrors()) {
            model.addAttribute("patient", existingPatient);
            model.addAttribute("bindingResult", bindingResult);
            return "pages/receptionist/patient/edit";
        }

        // Diagnosis and notes aren't on this form - carry the existing
        // values forward so this edit can't wipe clinical data.
        patientService.updatePatient(id, request.getFullName(),
                request.getDateOfBirth(), request.getGender(),
                existingPatient.getDiagnosis(), existingPatient.getNotes(),
                request.isActive());
        redirectAttributes.addFlashAttribute("success", "Patient successfully updated.");
        return "redirect:/receptionist/patients";
    }

}