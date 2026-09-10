package com.madania.management.controller.admin;

import com.madania.management.dto.ReceptionistCreateRequest;
import com.madania.management.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminReceptionistController {

    private final UserService userService;

    @GetMapping("/receptionist/create")
    public String createReceptionistForm(Model model) {
        model.addAttribute("request", new ReceptionistCreateRequest());
        return "pages/admin/receptionist/create";
    }

    @PostMapping("/receptionist/create")
    public String createReceptionist(@Valid @ModelAttribute("request") ReceptionistCreateRequest request,
                                     BindingResult bindingResult,
                                     RedirectAttributes redirectAttributes,
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
            return "pages/admin/receptionist/create";
        }

        userService.createReceptionist(request.getUsername(), request.getEmail(), request.getPassword());
        redirectAttributes.addFlashAttribute("success", "Receptionist account successfully created.");

        return "redirect:/admin/users";
    }

}