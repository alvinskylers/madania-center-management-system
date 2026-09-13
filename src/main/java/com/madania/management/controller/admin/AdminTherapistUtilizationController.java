package com.madania.management.controller.admin;

import com.madania.management.dto.utilization.TherapistUtilizationDto;
import com.madania.management.service.TherapistUtilizationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin/therapist-utilization")
@RequiredArgsConstructor
public class AdminTherapistUtilizationController {

    private final TherapistUtilizationService utilizationService;

    @GetMapping
    public String index(Model model) {
        List<TherapistUtilizationDto> rows = utilizationService.getUtilizationOverview();

        long activeTherapistCount = rows.size();
        double averageSessionsThisWeek = rows.stream()
                .mapToLong(TherapistUtilizationDto::getSessionsThisWeek)
                .average()
                .orElse(0);
        long overloadedCount = rows.stream().filter(TherapistUtilizationDto::isOverloaded).count();

        model.addAttribute("rows", rows);
        model.addAttribute("activeTherapistCount", activeTherapistCount);
        model.addAttribute("averageSessionsThisWeek", Math.round(averageSessionsThisWeek));
        model.addAttribute("overloadedCount", overloadedCount);

        return "pages/admin/utilization/index";
    }
}
