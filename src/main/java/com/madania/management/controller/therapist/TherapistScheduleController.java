package com.madania.management.controller.therapist;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/therapist")
@RequiredArgsConstructor
public class TherapistScheduleController {

    private final TherapySessionService sessionService;

    @GetMapping("/schedule")
    public String schedule() {
        return "pages/therapist/schedule";
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
}
