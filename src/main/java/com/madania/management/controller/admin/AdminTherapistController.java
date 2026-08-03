package com.madania.management.controller.admin;

import com.madania.management.dto.TherapistCreateRequest;
import com.madania.management.entity.Therapist;
import com.madania.management.service.TherapistService;
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
public class AdminTherapistController {

    private final TherapistService therapistService;
    private final UserService userService;

    @GetMapping("/therapists")
    public String therapist(Model model) {
        List<Therapist> therapists = therapistService.getAllTherapists();
        model.addAttribute("therapists", therapists);
        return "pages/user-therapists";
    }

    @GetMapping("/therapist/create")
    public String createTherapistForm(Model model) {
        model.addAttribute("request", new TherapistCreateRequest());
        return "pages/user-create-therapist";
    }

    @PostMapping("/therapist/create")
    public String createTherapist(@Valid @ModelAttribute("request") TherapistCreateRequest request,
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
            return "pages/user-create-therapist";
        }

        therapistService.createTherapist(
                request.getEmail(),
                request.getPassword(),
                request.getFullName(),
                request.getSpecialization(),
                request.getPhone());

        return "redirect:/admin/therapists";
    }

}
