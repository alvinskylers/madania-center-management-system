package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.RescheduleRequestDto;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.service.RescheduleService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.ui.Model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/therapist")
@RequiredArgsConstructor
public class TherapistScheduleController {

    private final TherapySessionService sessionService;
    private final RescheduleService rescheduleService;

    @GetMapping("/schedule")
    public String schedule(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        model.addAttribute("myRescheduleRequests", rescheduleService.getRequestsByUserId(userDetails.getUser().getId()));
        return "pages/therapist/schedule/index";
    }


    @GetMapping("/schedule/events")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getEvents(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        List<TherapySession> sessions = sessionService.getSessionsByTherapistId(therapist.getId());

        List<Map<String, Object>> events = sessions.stream().map(session -> {
            Map<String, Object> event = new HashMap<>();
            event.put("id", session.getId());
            event.put("title", "Session " + session.getSessionNumber() + " - " + session.getPatient().getFullName());
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

    @PostMapping(value = "/schedule/reschedule")
    public String requestReschedule(@ModelAttribute RescheduleRequestDto dto,
                                    Authentication authentication,
                                    RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Therapist therapist = sessionService.getTherapistByUserId(userDetails.getUser().getId());

        TherapySession session = sessionService.getSessionById(dto.getSessionId());
        boolean ownsSession = session.getTherapist().getId().equals(therapist.getId());
        if (!ownsSession) {
            redirectAttributes.addFlashAttribute("rescheduleError", "You can only request reschedule for your own sessions.");
            return "redirect:/therapist/schedule";
        }

        try {
            rescheduleService.submitRequest(dto.getSessionId(), userDetails.getUser().getId(),
                    dto.getRequestedStartTime(), dto.getReason(), null);
            redirectAttributes.addFlashAttribute("rescheduleSuccess", "Reschedule request submitted.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("rescheduleError", e.getMessage());
        }

        return "redirect:/therapist/schedule";
    }
}
