package com.madania.management.controller.parent;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.PackageJournalGroup;
import com.madania.management.dto.SessionJournalPair;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.entity.TherapyPackage;
import com.madania.management.entity.TherapySession;
import com.madania.management.repository.TherapyJournalRepository;
import com.madania.management.repository.TherapyPackageRepository;
import com.madania.management.service.ParentService;
import com.madania.management.service.PatientService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/parent")
@RequiredArgsConstructor
public class ParentChildrenController {

    private final ParentService parentService;
    private final PatientService patientService;
    private final TherapySessionService sessionService;
    private final TherapyPackageRepository packageRepository;
    private final TherapyJournalRepository journalRepository;

    @GetMapping("/children")
    public String children(Authentication authentication, Model model) {
        Parent parent = currentParent(authentication);
        List<Patient> children = parentService.getPatientsByParentId(parent.getId());
        model.addAttribute("children", children);
        return "pages/parent/child/index";
    }

    @GetMapping("/child/{id}")
    public String child(@PathVariable UUID id, Authentication authentication,
                        Model model, RedirectAttributes redirectAttributes) {
        Parent parent = currentParent(authentication);
        Patient patient = patientService.getPatientById(id);

        if (patient == null || patient.getParent() == null || !patient.getParent().getId().equals(parent.getId())) {
            redirectAttributes.addFlashAttribute("childError", "You can only view your own child's records.");
            return "redirect:/parent/children";
        }

        model.addAttribute("patient", patient);
        model.addAttribute("packageGroups", buildPackageJournalGroups(id));
        return "pages/parent/child/view";
    }

    @GetMapping("/child/{id}/events")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getChildEvents(@PathVariable UUID id, Authentication authentication) {
        Parent parent = currentParent(authentication);
        Patient patient = patientService.getPatientById(id);

        if (patient == null || patient.getParent() == null || !patient.getParent().getId().equals(parent.getId())) {
            return ResponseEntity.status(403).build();
        }

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

    private Parent currentParent(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        return parentService.getParentByUserId(userDetails.getUser().getId());
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