package com.madania.management.controller.admin;

import com.madania.management.entity.TherapyJournal;
import com.madania.management.repository.PatientRepository;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.service.JournalCommentService;
import com.madania.management.service.TherapyJournalService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminJournalController {

    private final TherapistRepository therapistRepository;
    private final PatientRepository patientRepository;
    private final TherapyJournalService journalService;
    private final JournalCommentService commentService;

    @GetMapping("/journals")
    public String journals(Model model,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "10") int size,
                           @RequestParam(defaultValue = "desc") String sort,
                           @RequestParam(required = false) UUID therapistId,
                           @RequestParam(required = false) UUID patientId,
                           @RequestParam(required = false) Integer sessionNumber) {
        Page<TherapyJournal> journalPage = journalService.getAllQueried(therapistId, patientId, sessionNumber, page, size, sort);

        model.addAttribute("journals", journalPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", journalPage.getTotalPages());
        model.addAttribute("totalItems", journalPage.getTotalElements());
        model.addAttribute("pageSize", size);

        model.addAttribute("therapists", therapistRepository.findAll());
        model.addAttribute("patients", patientRepository.findAll());
        model.addAttribute("sessionNumbers", List.of(1,2,3,4,5,6,7,8,9,10,11,12));

        model.addAttribute("selectedTherapistId", therapistId);
        model.addAttribute("selectedPatientId", patientId);
        model.addAttribute("selectedSessionNumber", sessionNumber);

        return "pages/admin/journal/index";
    }

    @GetMapping("/journal/{id}")
    public String viewJournal(@PathVariable java.util.UUID id, Model model) {
        TherapyJournal journal = journalService.getJournalById(id);
        model.addAttribute("journal", journal);
        model.addAttribute("comments", commentService.getCommentsForJournal(id));
        return "pages/admin/journal/view";
    }
}
