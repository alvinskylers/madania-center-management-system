package com.madania.management.controller.therapist;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/therapist")
public class TherapistDashboardController {

    @GetMapping("/dashboard")
    public String dashboard() {
        return "therapist/dashboard";
    }

//    @GetMapping("/schedule")
//    public String schedule() {
//        return "pages/schedule";
//    }

    @GetMapping("/journals")
    public String journals() {
        return "pages/journals";
    }

    @GetMapping("/journal")
    public String journal() {
        return "pages/journal";
    }

    @GetMapping("/journal/create")
    public String createJournal() {
        return "pages/journal-create";
    }

    @GetMapping("/patients")
    public String patient() {
        return "pages/patients";
    }
}
