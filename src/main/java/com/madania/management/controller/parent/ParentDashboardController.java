package com.madania.management.controller.parent;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/parent")
public class ParentDashboardController {

    @GetMapping("/dashboard")
    public String dashboard() {
        return "pages/parent/dashboard";
    }

    @GetMapping("/schedule")
    public String schedule() {
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


}
