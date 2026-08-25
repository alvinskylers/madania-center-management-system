package com.madania.management.controller.admin;

import com.madania.management.entity.LeaveRequest;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.LeaveStatus;
import com.madania.management.service.LeaveService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/leaves")
@RequiredArgsConstructor
public class AdminLeaveController {

    private final LeaveService leaveService;
    private final TherapySessionService sessionService;

    @GetMapping
    public String index(Model model) {
        List<LeaveRequest> requests = leaveService.getAllRequests();
        model.addAttribute("requests", requests);
        return "pages/admin/leave/index";
    }

    @GetMapping("/{id}")
    public String review(@PathVariable UUID id, Model model) {
        LeaveRequest leave = leaveService.getRequestById(id);

        if (leave.getStatus() != LeaveStatus.PENDING) {
            model.addAttribute("leave", leave);
            model.addAttribute("suggestions", Map.of());
            return "pages/admin/leave/review";
        }

        Map<TherapySession, LocalDateTime> suggestions = leaveService.getSuggestedSlotsForLeave(leave);
        model.addAttribute("leave", leave);
        model.addAttribute("suggestions", suggestions);
        return "pages/admin/leave/review";
    }

    @GetMapping("/{id}/therapist-events")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getTherapistEvents(@PathVariable UUID id) {
        LeaveRequest leave = leaveService.getRequestById(id);
        List<TherapySession> sessions = sessionService.getSessionsByTherapistId(leave.getTherapist().getId());

        List<Map<String, Object>> events = sessions.stream().map(session -> {
            Map<String, Object> event = new HashMap<>();
            event.put("id", session.getId());
            event.put("title", session.getPatient().getFullName() + " - Session " + session.getSessionNumber());
            event.put("start", session.getStartTime().toString());
            event.put("end", session.getEndTime().toString());
            event.put("color", switch (session.getStatus().name()) {
                case "SCHEDULED"   -> "#1B84FF";
                case "COMPLETED"   -> "#17C653";
                case "CANCELLED"   -> "#F1416C";
                case "RESCHEDULED" -> "#FFA800";
                default            -> "#7E8299";
            });
            return event;
        }).collect(Collectors.toList());

        Map<String, Object> leaveBlock = new HashMap<>();
        leaveBlock.put("title", "Leave Period");
        leaveBlock.put("start", leave.getStartDate().toString());
        leaveBlock.put("end", leave.getEndDate().plusDays(1).toString());
        leaveBlock.put("display", "background");
        leaveBlock.put("color", "#F1416C");
        events.add(leaveBlock);

        return ResponseEntity.ok(events);
    }

    @PostMapping("/{id}/approve")
    public String approve(@PathVariable UUID id,
                          @RequestParam Map<String, String> allParams,
                          RedirectAttributes redirectAttributes) {
        Map<UUID, LocalDateTime> chosenTimes = new LinkedHashMap<>();

        for (Map.Entry<String, String> entry : allParams.entrySet()) {
            if (entry.getKey().startsWith("sessionTime_") && entry.getValue() != null && !entry.getValue().isBlank()) {
                UUID sessionId = UUID.fromString(entry.getKey().substring("sessionTime_".length()));
                chosenTimes.put(sessionId, LocalDateTime.parse(entry.getValue()));
            }
        }

        String adminNotes = allParams.get("adminNotes");

        try {
            leaveService.approveLeave(id, chosenTimes, adminNotes);
            redirectAttributes.addFlashAttribute("leaveSuccess", "Leave approved and affected sessions rescheduled.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("leaveError", e.getMessage());
            return "redirect:/admin/leaves/" + id;
        }

        return "redirect:/admin/leaves";
    }

    @PostMapping("/{id}/reject")
    public String reject(@PathVariable UUID id,
                         @RequestParam(required = false) String adminNotes,
                         RedirectAttributes redirectAttributes) {
        try {
            leaveService.rejectLeave(id, adminNotes);
            redirectAttributes.addFlashAttribute("leaveSuccess", "Leave request rejected.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("leaveError", e.getMessage());
        }
        return "redirect:/admin/leaves";
    }
}