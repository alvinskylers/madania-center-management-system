package com.madania.management.controller;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.ProfileUpdateRequest;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Therapist;
import com.madania.management.enums.Role;
import com.madania.management.service.ParentService;
import com.madania.management.service.TherapistService;
import com.madania.management.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.UUID;

@Controller
@RequestMapping("/profile")
@RequiredArgsConstructor
public class ProfileController {

    private final UserService userService;
    private final ParentService parentService;
    private final TherapistService therapistService;

    @GetMapping
    public String profile(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        UUID userId = userDetails.getUser().getId();
        Role role = userDetails.getUser().getRole();

        ProfileUpdateRequest request = new ProfileUpdateRequest();
        request.setEmail(userDetails.getUser().getEmail());

        if (role == Role.THERAPIST) {
            Therapist therapist = therapistService.getTherapistByUserId(userId);
            request.setUsername(therapist.getFullName());
            request.setSpecialization(therapist.getSpecialization());
            request.setPhone(therapist.getPhone());
            model.addAttribute("request", request);
            return "pages/therapist/profile/index";
        }

        if (role == Role.PARENT) {
            Parent parent = parentService.getParentByUserId(userId);
            request.setUsername(parent.getFullName());
            request.setAddress(parent.getAddress());
            request.setPhone(parent.getPhone());
            model.addAttribute("request", request);
            return "pages/parent/profile/index";
        }

        return "redirect:/dashboard";
    }

    @GetMapping("/edit")
    public String edit(Authentication authentication, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        UUID userId = userDetails.getUser().getId();
        Role role = userDetails.getUser().getRole();

        ProfileUpdateRequest request = new ProfileUpdateRequest();
        request.setEmail(userDetails.getUser().getEmail());

        if (role == Role.THERAPIST) {
            Therapist therapist = therapistService.getTherapistByUserId(userId);
            request.setUsername(therapist.getFullName());
            request.setSpecialization(therapist.getSpecialization());
            request.setPhone(therapist.getPhone());
            model.addAttribute("request", request);
            return "pages/therapist/profile/edit";
        }

        if (role == Role.PARENT) {
            Parent parent = parentService.getParentByUserId(userId);
            request.setUsername(parent.getFullName());
            request.setAddress(parent.getAddress());
            request.setPhone(parent.getPhone());
            model.addAttribute("request", request);
            return "pages/parent/profile/edit";
        }

        return "redirect:/dashboard";
    }

    @PostMapping("/edit")
    public String updateProfile(@Valid @ModelAttribute("request") ProfileUpdateRequest request,
                                BindingResult bindingResult,
                                Authentication authentication,
                                RedirectAttributes redirectAttributes,
                                Model model) {


        if (userService.emailExists(request.getEmail())) {
            bindingResult.addError(new FieldError(
                    "request",
                    "email",
                    "email already exists!"
            ));
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("bindingResult", bindingResult);
            return getProfileView(authentication);
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        UUID userId = userDetails.getUser().getId();
        Role role = userDetails.getUser().getRole();

        try {
            if (role == Role.THERAPIST) {
                therapistService.updateProfile(userId, request.getUsername(), request.getEmail(),
                        request.getPhone(), request.getSpecialization());
            } else if (role == Role.PARENT) {
                parentService.updateProfile(userId, request.getUsername(), request.getEmail(),
                        request.getPhone(), request.getAddress());
            }
            redirectAttributes.addFlashAttribute("success", "Profile updated successfully");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile";
    }

    private String getProfileView(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Role role = userDetails.getUser().getRole();
        return role == Role.THERAPIST
                ? "pages/therapist/profile/edit"
                : "pages/parent/profile/edit";
    }

}
