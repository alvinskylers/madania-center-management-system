package com.madania.management.controller.admin;

import com.madania.management.dto.PackageJournalGroup;
import com.madania.management.dto.PatientRequest;
import com.madania.management.dto.SessionJournalPair;
import com.madania.management.entity.Patient;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.entity.TherapyPackage;
import com.madania.management.entity.TherapySession;
import com.madania.management.repository.TherapyJournalRepository;
import com.madania.management.repository.TherapyPackageRepository;
import com.madania.management.repository.TherapySessionRepository;
import com.madania.management.service.PatientService;
import com.madania.management.service.TherapySessionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminPatientController {

    private final PatientService patientService;
    private final TherapySessionService sessionService;
    private final TherapyJournalRepository journalRepository;
    private final TherapyPackageRepository packageRepository;

    @GetMapping("/patients")
    public String patient(Model model,
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

        return "pages/admin/patient/index";
    }

    @GetMapping("/patient/create")
    public String createPatientForm(Model model) {
        model.addAttribute("request", new PatientRequest());
        model.addAttribute("parents", patientService.getAllParents());
        return "pages/admin/patient/create";
    }

    @PostMapping("/patient/create")
    public String createPatient(@Valid @ModelAttribute("request") PatientRequest request,
                                BindingResult bindingResult,
                                RedirectAttributes redirectAttributes,
                                Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("parents", patientService.getAllParents());
            model.addAttribute("bindingResult", bindingResult);
            return "pages/admin/patient/create";
        }

        patientService.createPatient(request.getParentId(), request.getFullName(),
                request.getDateOfBirth(), request.getGender(),
                request.getDiagnosis(), request.getNotes());
        redirectAttributes.addFlashAttribute("success", "Patient successfully created.");
        return "redirect:/admin/patients";
    }

    @GetMapping("/patient/{id}")
    public String patient(@PathVariable UUID id, Model model) {
        Patient patient = patientService.getPatientById(id);
        model.addAttribute("patient", patient);
        model.addAttribute("packageGroups", buildPackageJournalGroups(id));
        return "pages/admin/patient/view";
    }

    @GetMapping("/patient/{id}/events")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getPatientEvents(@PathVariable UUID id) {
        List<TherapySession> sessions = sessionService.getSessionsByPatientId(id);

        List<Map<String, Object>> events = sessions.stream().map(session -> {
            Map<String, Object> event = new HashMap<>();
            event.put("id", session.getId());
            event.put("title", "Session " + session.getSessionNumber() + " - " + session.getTherapist().getFullName());
            event.put("start", session.getStartTime().toString());
            event.put("end", session.getEndTime().toString());
            event.put("status", session.getStatus().name());
            event.put("color", switch (session.getStatus().name()) {
                case "SCHEDULED"   -> "#1B84FF";
                case "COMPLETED"   -> "#17C653";
                case "CANCELLED"   -> "#F1416C";
                case "RESCHEDULED" -> "#FFA800";
                default            -> "#7E8299";
            });
            return event;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(events);
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
        return "pages/admin/patient/edit";
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
            return "pages/admin/patient/edit";
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

    private List<PackageJournalGroup> buildPackageJournalGroups(UUID patientId) {
        List<TherapyPackage> packages = packageRepository.findByPatientId(patientId);

        List<PackageJournalGroup> groups = new ArrayList<>();
        for (TherapyPackage pkg : packages) {
            List<TherapySession> sessions = sessionService.getSessionsByTherapyPackageId(pkg.getId()).stream()
                    .sorted(Comparator.comparing(TherapySession::getSessionNumber))
                    .toList();

            List<SessionJournalPair> pairs = sessions.stream()
                    .map(session -> {
                        TherapyJournal journal = journalRepository.findBySessionId(session.getId()).orElse(null);
                        return new SessionJournalPair(session, journal);
                    })
                    .collect(Collectors.toList());

            groups.add(new PackageJournalGroup(pkg, pairs));
        }

        groups.sort(Comparator.comparing(g -> g.getTherapyPackage().getStartDate(), Comparator.reverseOrder()));
        return groups;
    }
}
