package com.madania.management.controller.admin;

import com.madania.management.entity.Therapist;
import com.madania.management.service.TherapistService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminTherapistController {

    private final TherapistService therapistService;

    @GetMapping("/therapists")
    public String therapist(Model model) {
        List<Therapist> therapists = therapistService.getAllTherapists();
        model.addAttribute("therapists", therapists);
        return "pages/therapists";
    }

    @GetMapping("/therapists/create")
    public String createTherapistForm() {
        return "pages/therapist-create";
    }

    @PostMapping("/therapists/create")
    public String createTherapist() {
        return "redirect:/therapists";
    }

}
