package com.madania.management.controller.admin;

import com.madania.management.dto.ParentCreateRequest;
import com.madania.management.entity.Parent;
import com.madania.management.service.ParentService;

import com.madania.management.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminParentController {

    private final ParentService parentService;
    private final UserService userService;

    @GetMapping("/parents")
    public String parents(Model model) {
        List<Parent> parents = parentService.getAllParent();
        model.addAttribute("parents", parents);
        return "pages/user-parents";
    }

    @GetMapping("/parent/create")
    public String createParentForm(Model model) {
        model.addAttribute("request", new ParentCreateRequest());
        return "pages/user-create-parent";
    }

    @PostMapping("/parent/create")
    public String createParent(@Valid @ModelAttribute("request") ParentCreateRequest request,
                               BindingResult bindingResult,
                               Model model) {
        boolean emailTaken = userService.emailExists(request.getEmail());

        if (emailTaken) {
            bindingResult.addError(new FieldError(
                    "request",
                    "email",
                    "email already exists!"
            ));
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("request", request);
            model.addAttribute("bindingResult", bindingResult);
            return "pages/user-create-parent";
        }

        userService.createParent(
                request.getUsername(),
                request.getEmail(),
                request.getPassword(),
                request.getPhone(),
                request.getAddress());

        return "redirect:/admin/parents";
    }



}
