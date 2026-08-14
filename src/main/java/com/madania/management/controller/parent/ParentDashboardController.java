package com.madania.management.controller.parent;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.SessionStatus;
import com.madania.management.service.ParentService;
import com.madania.management.service.TherapyJournalService;
import com.madania.management.service.TherapySessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/parent")
@RequiredArgsConstructor
public class ParentDashboardController {

    private final ParentService parentService;
    private final TherapySessionService sessionService;
    private final TherapyJournalService journalService;

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Parent parent = parentService.getParentByUserId(userDetails.getUser().getId());
        List<Patient> children = parentService.getPatientsByParentId(parent.getId());

        // collect upcoming sessions for all children
        List<TherapySession> upcomingSessions = new ArrayList<>();
        long totalCompletedSessions = 0;
        long totalJournals = 0;

        for (Patient child : children) {
            upcomingSessions.addAll(
                    sessionService.getUpcomingSessionsByPatientId(child.getId())
            );
            totalCompletedSessions += sessionService.getSessionsByPatientId(child.getId())
                    .stream()
                    .filter(s -> s.getStatus() == SessionStatus.COMPLETED)
                    .count();
            totalJournals += journalService.getJournalsByPatientId(child.getId()).size();
        }

        upcomingSessions.sort((a, b) -> a.getStartTime().compareTo(b.getStartTime()));

        model.addAttribute("parent", parent);
        model.addAttribute("children", children);
        model.addAttribute("upcomingSessions", upcomingSessions.stream().limit(3).toList());
        model.addAttribute("totalChildren", children.size());
        model.addAttribute("totalCompletedSessions", totalCompletedSessions);
        model.addAttribute("totalJournals", totalJournals);
        model.addAttribute("upcomingCount", upcomingSessions.size());

        return "pages/parent/dashboard";
    }


}
