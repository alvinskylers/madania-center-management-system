package com.madania.management.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    @GetMapping("/dashboard")
    public String dashboard() {
        return "admin/dashboard";
    }

    @GetMapping("/schedule")
    public String schedule() {
        return "pages/schedule";
    }

    @GetMapping("/schedule/create")
    public String createSchedule() {
        return "pages/schedule";
    }

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

}