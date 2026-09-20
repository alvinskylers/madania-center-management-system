package com.madania.management.controller;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.RescheduleRequestDto;
import com.madania.management.entity.RescheduleRequest;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.Role;
import com.madania.management.enums.SessionStatus;
import com.madania.management.service.RescheduleService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Direct ("break glass") reschedule from the admin and receptionist schedule calendars.
 * <p>
 * One controller serves both roles: access is already split by prefix in SecurityConfig
 * ({@code /admin/**} -> ADMIN, {@code /receptionist/**} -> RECEPTIONIST), and
 * {@link RescheduleService#staffReschedule} re-checks the caller's role as a second guard.
 * The parent / therapist request flow is untouched.
 */
@Controller
@RequestMapping({"/admin/schedule", "/receptionist/schedule"})
@RequiredArgsConstructor
public class StaffRescheduleController {

    private static final DateTimeFormatter SUCCESS_DATE_FORMAT = DateTimeFormatter.ofPattern("d MMM yyyy, HH:mm");

    private final RescheduleService rescheduleService;
    private final TherapySessionService sessionService;

    /**
     * The session's therapist schedule, shown inside the reschedule modal so staff can pick a
     * free slot. Staff can see patient names, so unlike the parent version nothing is masked.
     */
    @GetMapping("/therapist-events/{sessionId}")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getTherapistEvents(@PathVariable UUID sessionId) {
        TherapySession session = sessionService.getSessionById(sessionId);

        List<Map<String, Object>> events = sessionService.getSessionsByTherapistId(session.getTherapist().getId()).stream()
                .filter(s -> s.getStatus() == SessionStatus.SCHEDULED)
                .map(s -> {
                    boolean isThisSession = s.getId().equals(sessionId);

                    Map<String, Object> event = new HashMap<>();
                    event.put("id", s.getId());
                    event.put("title", isThisSession
                            ? "Sesi Ini (Saat Ini)"
                            : s.getPatient().getFullName() + " - Sesi " + s.getSessionNumber());
                    event.put("start", s.getStartTime().toString());
                    event.put("end", s.getEndTime().toString());
                    event.put("color", isThisSession ? "#FFA800" : "#F1416C");
                    return event;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(events);
    }

    @PostMapping("/reschedule")
    public String reschedule(@ModelAttribute RescheduleRequestDto dto,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        String redirect = userDetails.getUser().getRole() == Role.ADMIN
                ? "redirect:/admin/schedule"
                : "redirect:/receptionist/schedule";

        try {
            RescheduleRequest result = rescheduleService.staffReschedule(
                    dto.getSessionId(), userDetails.getUser().getId(), dto.getRequestedStartTime(), dto.getReason());
            redirectAttributes.addFlashAttribute("rescheduleSuccess",
                    "Sesi berhasil dijadwalkan ulang ke " + result.getRequestedStartTime().format(SUCCESS_DATE_FORMAT)
                            + ". Orang tua dan terapis telah diberi tahu.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("rescheduleError", e.getMessage());
        }

        return redirect;
    }
}
