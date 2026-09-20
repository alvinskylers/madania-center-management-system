package com.madania.management.controller.receptionist;

import com.madania.management.entity.TherapySession;
import com.madania.management.enums.SessionStatus;
import com.madania.management.service.RescheduleService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/receptionist")
@RequiredArgsConstructor
public class ReceptionistScheduleController {

    private final TherapySessionService sessionService;
    private final RescheduleService rescheduleService;

    @GetMapping("/schedule")
    public String schedule() {
        return "pages/receptionist/schedule/index";
    }

    @GetMapping("/schedule/events")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getScheduleEvents() {
        List<TherapySession> sessions = sessionService.getAllSessions();

        List<Map<String, Object>> events = sessions.stream().map(session -> {
            Map<String, Object> event = new HashMap<>();
            event.put("id", session.getId());
            event.put("title", session.getPatient().getFullName()
                    + " - " + session.getTherapist().getFullName()
                    + " (Session " + session.getSessionNumber() + ")");
            event.put("start", session.getStartTime().toString());
            event.put("end", session.getEndTime().toString());
            event.put("status", session.getStatus().name());
            if (session.getStatus() == SessionStatus.SCHEDULED) {
                // Server decides whether staff can still move this session (see RescheduleNoticePolicy.canStaffMove).
                event.put("canStaffReschedule", rescheduleService.canStaffReschedule(session));
            }
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
