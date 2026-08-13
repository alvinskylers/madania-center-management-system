package com.madania.management.controller;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.dto.ProfileUpdateRequest;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Therapist;
import com.madania.management.enums.Role;
import com.madania.management.service.ParentService;
import com.madania.management.service.TherapistService;
import com.madania.management.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

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
            return "pages/therapist/profile";
        }

        if (role == Role.PARENT) {
            Parent parent = parentService.getParentByUserId(userId);
            request.setUsername(parent.getFullName());
            request.setAddress(parent.getAddress());
            request.setPhone(parent.getPhone());
            model.addAttribute("request", request);
            return "pages/parent/profile";
        }

        return "redirect:/dashboard";
    }
}
