package com.madania.management.controller.admin;

import com.madania.management.dto.TherapistCreateRequest;
import com.madania.management.dto.TherapistEditRequest;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.service.TherapistService;
import com.madania.management.service.TherapySessionService;
import com.madania.management.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminTherapistController {

    private final TherapySessionService sessionService;
    private final TherapistService therapistService;
    private final UserService userService;

    @GetMapping("/therapists")
    public String therapist(Model model,
                            @RequestParam(defaultValue = "0") int page,
                            @RequestParam(defaultValue = "10") int size,
                            @RequestParam(defaultValue = "asc") String sort,
                            @RequestParam(required = false) String query) {
        Page<Therapist> therapistPage = therapistService.getAllQueried(query, page, size, sort);

        model.addAttribute("therapists", therapistPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", therapistPage.getTotalPages());
        model.addAttribute("totalItems", therapistPage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("query", query);

        return "pages/admin/therapist/index";
    }

    @GetMapping("/therapist/{id}")
    public String viewTherapist(@PathVariable UUID id, Model model) {
        Therapist therapist = therapistService.getTherapistById(id);
        model.addAttribute("therapist", therapist);
        return "pages/admin/therapist/view";
    }

    @GetMapping("/therapist/{id}/events")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getTherapistEvents(@PathVariable UUID id) {
        List<TherapySession> sessions = sessionService.getSessionsByTherapistId(id);

        List<Map<String, Object>> events = sessions.stream().map(session -> {
            Map<String, Object> event = new HashMap<>();
            event.put("id", session.getId());
            event.put("title", "Session " + session.getSessionNumber() + " - " + session.getPatient().getFullName());
            event.put("start", session.getStartTime().toString());
            event.put("end", session.getEndTime().toString());
            event.put("status", session.getStatus().name());
            event.put("color", switch (session.getStatus().name()) {
                case "SCHEDULED"   -> "#1B84FF";
                case "COMPLETED"   -> "#17C653";
                case "CANCELLED"   -> "#F1416C";
                case "RESCHEDULED" -> "#FFA800";
                default            -> "#7E8299";
            });
            return event;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(events);
    }

    @GetMapping("/therapist/create")
    public String createTherapistForm(Model model) {
        model.addAttribute("request", new TherapistCreateRequest());
        return "pages/admin/therapist/create";
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
            return "pages/admin/therapist/create";
        }

        therapistService.createTherapist(
                request.getEmail(),
                request.getPassword(),
                request.getFullName(),
                request.getSpecialization(),
                request.getPhone());

        return "redirect:/admin/therapists";
    }

    @GetMapping("/therapist/{id}/edit")
    public String editTherapistForm(@PathVariable UUID id, Model model) {
        Therapist therapist = therapistService.getTherapistById(id);

        TherapistEditRequest request = new TherapistEditRequest();
        request.setEmail(therapist.getUser().getEmail());
        request.setFullName(therapist.getFullName());
        request.setSpecialization(therapist.getSpecialization());
        request.setPhone(therapist.getPhone());

        model.addAttribute("request", request);
        model.addAttribute("userId", id);
        return "pages/admin/therapist/edit";
    }

    @PostMapping("/therapist/{id}/edit")
    public String editTherapist(@PathVariable UUID id,
                                @Valid @ModelAttribute("request") TherapistEditRequest request,
                                BindingResult bindingResult,
                                Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("userId", id);
            model.addAttribute("bindingResult", bindingResult);
            return "pages/admin/therapist/edit";
        }

        therapistService.updateTherapist(id, request.getEmail(),
                request.getFullName(), request.getSpecialization(), request.getPhone());

        return "redirect:/admin/therapists";
    }

    @PostMapping("therapist/{id}/delete")
    public String deleteTherapist(@PathVariable UUID id) {
        therapistService.deleteTherapist(id);
        //TODO: add error binding to try to delete an active account
        return "redirect:/admin/therapists";
    }

}
