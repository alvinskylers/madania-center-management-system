package com.madania.management.controller.admin;

import com.madania.management.service.TherapyPackageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminPackageController {

    private final TherapyPackageService packageService;


    @GetMapping("/packages")
    public String packages(Model model) {
        model.addAttribute("packages", packageService.getAllPackages());
        return "pages/packages";
    }

}
