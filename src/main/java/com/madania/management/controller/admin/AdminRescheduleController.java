package com.madania.management.controller.admin;

import com.madania.management.entity.RescheduleRequest;
import com.madania.management.service.RescheduleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin/reschedules")
@RequiredArgsConstructor
public class AdminRescheduleController {

    private final RescheduleService rescheduleService;

    @GetMapping
    public String index(Model model) {
        List<RescheduleRequest> requests = rescheduleService.getAllRequests();
        model.addAttribute("requests", requests);
        return "pages/admin/reschedule/index";
    }

    @PostMapping("/{id}/approve")
    public String approve(@PathVariable UUID id,
                          @RequestParam(required = false) String adminNotes,
                          RedirectAttributes redirectAttributes) {
        try{
            rescheduleService.approveRequest(id, adminNotes);
            redirectAttributes.addFlashAttribute("rescheduleSuccess", "Reschedule request approved.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("rescheduleError", e.getMessage());
        }

        return "redirect:/admin/reschedules";
    }

    @PostMapping("/{id}/reject")
    public String reject(@PathVariable UUID id,
                         @RequestParam(required = false)String adminNotes,
                         RedirectAttributes redirectAttributes) {
        try {
            rescheduleService.rejectRequest(id, adminNotes);
            redirectAttributes.addFlashAttribute("rescheduleSuccess", "Reschedule request declined");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("rescheduleError", e.getMessage());
        }

        return "redirect:/admin/reschedules";
    }
}
