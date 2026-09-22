package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.RescheduleRequestDto;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.enums.SessionStatus;
import com.madania.management.service.RescheduleService;
import com.madania.management.service.TherapyJournalService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.ui.Model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/therapist")
@RequiredArgsConstructor
public class TherapistScheduleController {

    private final TherapySessionService sessionService;
    private final RescheduleService rescheduleService;
    private final TherapyJournalService journalService;

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

        List<Map<String, Object>> events = new ArrayList<>();
        for (TherapySession session : sessions) {
            Map<String, Object> event = new HashMap<>();
            event.put("id", session.getId());
            event.put("title", "Session " + session.getSessionNumber() + " - " + session.getPatient().getFullName());
            event.put("start", session.getStartTime().toString());
            event.put("end", session.getEndTime().toString());
            event.put("status", session.getStatus().name());
            if (session.getStatus() == SessionStatus.SCHEDULED) {
                // Server decides, so the UI never disagrees with submitRequest's validation.
                event.put("canReschedule", rescheduleService.canRequestReschedule(session));
                event.put("rescheduleDeadline", rescheduleService.getRescheduleDeadline(session).toString());
            }
            if (session.getStatus().name().equals("COMPLETED")) {
                TherapyJournal journal = journalService.getJournalBySessionId(session.getId());
                if (journal != null) {
                    event.put("journalId", journal.getId().toString());
                }
            }
            event.put("color", switch (session.getStatus().name()) {
                case "SCHEDULED"      -> "#1B84FF";
                case "PENDING_REVIEW" -> "#F1BC00";
                case "COMPLETED"      -> "#17C653";
                case "NO_SHOW"        -> "#5E6278";
                case "CANCELLED"      -> "#F1416C";
                case "RESCHEDULED"    -> "#FFA800";
                default               -> "#7E8299";
            });
            events.add(event);
        }

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