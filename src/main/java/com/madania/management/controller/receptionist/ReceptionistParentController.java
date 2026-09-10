package com.madania.management.controller.receptionist;

import com.madania.management.dto.ParentCreateRequest;
import com.madania.management.dto.ParentEditRequest;
import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.service.ParentService;
import com.madania.management.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.UUID;

/**
 * Receptionist is the clinic's first point of contact: they register new
 * families and their children. They can list/create/edit parent accounts,
 * but (unlike admin) cannot delete accounts or manage anything clinical.
 */
@Controller
@RequestMapping("/receptionist")
@RequiredArgsConstructor
public class ReceptionistParentController {

    private final ParentService parentService;
    private final UserService userService;

    @GetMapping("/parents")
    public String parents(Model model,
                          @RequestParam(defaultValue = "0") int page,
                          @RequestParam(defaultValue = "10") int size,
                          @RequestParam(defaultValue = "asc") String sort,
                          @RequestParam(required = false) String query) {
        Page<Parent> parentPage = parentService.getAllQueried(query, page, size, sort);

        model.addAttribute("parents", parentPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", parentPage.getTotalPages());
        model.addAttribute("totalItems", parentPage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("query", query);

        return "pages/receptionist/parent/index";
    }

    @GetMapping("/parent/{id}")
    public String viewParent(@PathVariable UUID id, Model model) {
        Parent parent = parentService.getParentById(id);
        List<Patient> children = parentService.getPatientsByParentId(id);
        model.addAttribute("parent", parent);
        model.addAttribute("children", children);
        return "pages/receptionist/parent/view";
    }

    @GetMapping("/parent/create")
    public String createParentForm(Model model) {
        model.addAttribute("request", new ParentCreateRequest());
        return "pages/receptionist/parent/create";
    }

    @PostMapping("/parent/create")
    public String createParent(@Valid @ModelAttribute("request") ParentCreateRequest request,
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
            return "pages/receptionist/parent/create";
        }

        parentService.createParent(
                request.getUsername(),
                request.getEmail(),
                request.getPassword(),
                request.getPhone(),
                request.getAddress());

        redirectAttributes.addFlashAttribute("success", "Parent account successfully created.");
        return "redirect:/receptionist/parents";
    }

    @GetMapping("/parent/{id}/edit")
    public String editParentForm(@PathVariable UUID id, Model model) {
        Parent parent = parentService.getParentById(id);

        ParentEditRequest request = new ParentEditRequest();
        request.setEmail(parent.getUser().getEmail());
        request.setFullName(parent.getFullName());
        request.setPhone(parent.getPhone());
        request.setAddress(parent.getAddress());

        model.addAttribute("request", request);
        model.addAttribute("userId", id);
        return "pages/receptionist/parent/edit";
    }

    @PostMapping("/parent/{id}/edit")
    public String editParent(@PathVariable UUID id,
                             @Valid @ModelAttribute("request") ParentEditRequest request,
                             BindingResult bindingResult,
                             RedirectAttributes redirectAttributes,
                             Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("userId", id);
            model.addAttribute("bindingResult", bindingResult);
            return "pages/receptionist/parent/edit";
        }

        parentService.updateParent(id, request.getEmail(),
                request.getFullName(), request.getPhone(), request.getAddress());

        redirectAttributes.addFlashAttribute("success", "Parent account successfully updated.");
        return "redirect:/receptionist/parents";
    }

}
