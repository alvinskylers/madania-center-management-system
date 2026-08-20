package com.madania.management.controller.admin;

import com.madania.management.entity.TherapyJournal;
import com.madania.management.service.TherapyJournalService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminJournalController {

    private final TherapyJournalService journalService;

    @GetMapping("/journals")
    public String journals(Model model) {
        List<TherapyJournal> journals = journalService.getAllJournals();
        model.addAttribute("journals", journals);
        return "pages/admin/journal/index";
    }

    @GetMapping("/journal/{id}")
    public String viewJournal(@PathVariable java.util.UUID id, Model model) {
        TherapyJournal journal = journalService.getJournalById(id);
        model.addAttribute("journal", journal);
        return "pages/admin/journal/view";
    }
}
