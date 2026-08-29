package com.madania.management.controller.parent;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.JournalComment;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.service.JournalCommentService;
import com.madania.management.service.ParentService;
import com.madania.management.service.TherapyJournalService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/parent")
@RequiredArgsConstructor
public class ParentJournalController {

    private final ParentService parentService;
    private final TherapyJournalService journalService;
    private final JournalCommentService commentService;

    @GetMapping("/journals")
    public String journals(Authentication authentication, Model model,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "10") int size,
                           @RequestParam(defaultValue = "desc") String sort,
                           @RequestParam(required = false) UUID patientId,
                           @RequestParam(required = false) Integer sessionNumber,
                           @RequestParam(required = false) LocalDate startDate,
                           @RequestParam(required = false) LocalDate endDate) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());
        List<Patient> children = parentService.getPatientsByParentId(parent.getId());

        Page<TherapyJournal> journalPage = journalService.getQueriedForParent(
                parent.getId(), patientId, sessionNumber, startDate, endDate, page, size, sort);

        model.addAttribute("journals", journalPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", journalPage.getTotalPages());
        model.addAttribute("totalItems", journalPage.getTotalElements());
        model.addAttribute("pageSize", size);

        model.addAttribute("children", children);
        model.addAttribute("sessionNumbers", List.of(1,2,3,4,5,6,7,8,9,10,11,12));

        model.addAttribute("selectedPatientId", patientId);
        model.addAttribute("selectedSessionNumber", sessionNumber);
        model.addAttribute("selectedStartDate", startDate);
        model.addAttribute("selectedEndDate", endDate);

        return "pages/parent/journal";
    }


    @GetMapping("/journal/{id}")
    public String journal(Authentication authentication, Model model,
                          @PathVariable UUID id,
                          RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());

        TherapyJournal journal = journalService.getJournalById(id);
        boolean ownsChild = journal.getPatient().getParent().getId().equals(parent.getId());
        if (!ownsChild) {
            redirectAttributes.addFlashAttribute("journalError", "You can only view your own child's journal entries.");
            return "redirect:/parent/journals";
        }

        model.addAttribute("journal", journal);
        model.addAttribute("comments", commentService.getCommentsForJournal(id));
        return "pages/parent/detail";
    }

    @PostMapping("/journal/{id}/comment")
    public String addComment(@PathVariable UUID id,
                             @RequestParam String content,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());

        TherapyJournal journal = journalService.getJournalById(id);
        boolean ownsChild = journal.getPatient().getParent().getId().equals(parent.getId());
        if (!ownsChild) {
            redirectAttributes.addFlashAttribute("commentError", "You can only respond to your own child's journal entries.");
            return "redirect:/parent/journal/" + id;
        }

        try {
            commentService.addComment(id, userDetails.getUser().getId(), content);
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("commentError", e.getMessage());
        }

        return "redirect:/parent/journal/" + id;
    }

}