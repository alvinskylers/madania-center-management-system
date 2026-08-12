package com.madania.management.controller.parent;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.entity.TherapySession;
import com.madania.management.service.ParentService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/parent")
@RequiredArgsConstructor
public class ParentScheduleController {

    private final ParentService parentService;
    private final TherapySessionService sessionService;


    @GetMapping("/schedule")
    public String schedule(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());
        List<Patient> children = parentService.getPatientsByParentId(parent.getId());

        model.addAttribute("children", children);
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
                event.put("color", switch (session.getStatus().name()) {
                   case "SCHEDULED"     -> "#1B84FF";
                   case "COMPLETED"     -> "#17C653";
                   case "CANCELLED"     -> "#F1416C";
                   case "RESCHEDULED"   -> "#FFA800";
                   default  -> "#7E8299";
                });
                events.add(event);
            }

        }
        return  ResponseEntity.ok(events);
    }

}
