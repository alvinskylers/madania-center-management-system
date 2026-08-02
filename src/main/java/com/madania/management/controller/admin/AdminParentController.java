package com.madania.management.controller.admin;

import com.madania.management.entity.Parent;
import com.madania.management.service.ParentService;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminParentController {

    private final ParentService parentService;

    @GetMapping("/parents")
    public String parents(Model model) {
        List<Parent> parents = parentService.getAllParent();
        model.addAttribute("parents", parents);
        return "pages/user-parents";
    }




}
