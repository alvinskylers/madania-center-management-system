package com.madania.management.controller.parent;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.RescheduleRequestDto;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.entity.TherapySession;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.enums.SessionStatus;
import com.madania.management.service.ParentService;
import com.madania.management.service.RescheduleService;
import com.madania.management.service.TherapyJournalService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/parent")
@RequiredArgsConstructor
public class ParentScheduleController {

    private final ParentService parentService;
    private final TherapySessionService sessionService;
    private final RescheduleService rescheduleService;
    private final TherapyJournalService journalService;


    @GetMapping("/schedule")
    public String schedule(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());
        List<Patient> children = parentService.getPatientsByParentId(parent.getId());

        model.addAttribute("children", children);
        model.addAttribute("myRescheduleRequests", rescheduleService.getRequestsByUserId(userDetails.getUser().getId()));
        return "pages/parent/schedule";
    }


    @GetMapping("/schedule/events")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getScheduled(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());
        List<Patient> children = parentService.getPatientsByParentId(parent.getId());

        List<Map<String, Object>> events = new ArrayList<>();

        for (Patient child: children) {
            List<TherapySession> sessions = sessionService.getSessionsByPatientId(child.getId());

            for (TherapySession session : sessions) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", session.getId());
                event.put("title", child.getFullName() + " - Session " + session.getSessionNumber());
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
                    default  -> "#7E8299";
                });
                events.add(event);
            }

        }
        return  ResponseEntity.ok(events);
    }

    /**
     * Read-only view of the session's therapist schedule, so a parent can see which slots
     * are already taken before picking a new reschedule time in the modal, instead of
     * blindly guessing a time. Other families' sessions are shown as "Terisi" (booked)
     * without exposing another patient's name.
     */
    @GetMapping("/schedule/therapist-events/{sessionId}")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getTherapistEventsForSession(
            @PathVariable UUID sessionId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());

        TherapySession session = sessionService.getSessionById(sessionId);
        boolean ownsSession = session.getPatient().getParent().getId().equals(parent.getId());
        if (!ownsSession) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        List<TherapySession> therapistSessions = sessionService.getSessionsByTherapistId(session.getTherapist().getId());

        List<Map<String, Object>> events = therapistSessions.stream()
                .filter(s -> s.getStatus() == SessionStatus.SCHEDULED)
                .map(s -> {
                    boolean isThisSession = s.getId().equals(sessionId);
                    boolean isOwnChild = s.getPatient().getId().equals(session.getPatient().getId());

                    Map<String, Object> event = new HashMap<>();
                    event.put("id", s.getId());
                    event.put("title", isThisSession
                            ? "Sesi Ini (Saat Ini)"
                            : (isOwnChild ? s.getPatient().getFullName() + " - Sesi " + s.getSessionNumber() : "Terisi"));
                    event.put("start", s.getStartTime().toString());
                    event.put("end", s.getEndTime().toString());
                    event.put("color", isThisSession ? "#FFA800" : "#F1416C");
                    return event;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(events);
    }

    @PostMapping("/schedule/reschedule")
    public String reschedule(@ModelAttribute RescheduleRequestDto dto,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());

        TherapySession session = sessionService.getSessionById(dto.getSessionId());
        boolean ownsSession = session.getPatient().getParent().getId().equals(parent.getId());

        if (!ownsSession) {
            redirectAttributes.addFlashAttribute("rescheduleError","You can only request reschedule for your own child");
            return "redirect:/parent/schedule";
        }

        try {
            rescheduleService.submitRequest(dto.getSessionId(), userDetails.getUser().getId(),
                    dto.getRequestedStartTime(), dto.getReason(), null);
            redirectAttributes.addFlashAttribute("rescheduleSuccess", "Reschedule request submitted");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("rescheduleError", e.getMessage());
        }

        return "redirect:/parent/schedule";
    }

}