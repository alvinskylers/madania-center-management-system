package com.madania.management.controller.parent;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.service.ParentService;
import com.madania.management.service.TherapyJournalService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/parent")
@RequiredArgsConstructor
public class ParentJournalController {

    private final ParentService parentService;
    private final TherapyJournalService journalService;

    @GetMapping("/journals")
    public String journals(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());
        List<Patient> children = parentService.getPatientsByParentId(parent.getId());

        List<TherapyJournal> allJournals = new ArrayList<>();
        for (Patient child: children) {
            allJournals.addAll(journalService.getJournalsByPatientId(child.getId()));
        }

        model.addAttribute("journals", allJournals);
        model.addAttribute("children", children);
        return "pages/parent/journal";
    }

    @GetMapping("/journal/{id}")
    public String journal(Authentication authentication, Model model,
                          @PathVariable UUID id) {
        TherapyJournal journal = journalService.getJournalById(id);
        model.addAttribute("journal", journal);
        return "pages/parent/detail";
    }


}
