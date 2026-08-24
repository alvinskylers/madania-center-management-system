package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.LeaveRequest;
import com.madania.management.entity.Therapist;
import com.madania.management.service.LeaveService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/therapist/leave")
@RequiredArgsConstructor
public class TherapistLeaveController {

    private final LeaveService leaveService;
    private final TherapySessionService sessionService;

    @GetMapping
    public String index(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        List<LeaveRequest> myRequests = leaveService.getAllRequests().stream()
                .filter(l -> l.getTherapist().getId().equals(therapist.getId()))
                .toList();

        model.addAttribute("requests", myRequests);
        return "pages/therapist/leave/index";
    }

    @PostMapping
    public String submit(@RequestParam LocalDate startDate,
                         @RequestParam LocalDate endDate,
                         @RequestParam(required = false) String reason,
                         Authentication authentication,
                         RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        try {
            leaveService.submitLeave(therapist, startDate, endDate, reason);
            redirectAttributes.addFlashAttribute("leaveSuccess", "Leave request submitted.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("leaveError", e.getMessage());
        }

        return "redirect:/therapist/leave";
    }
}