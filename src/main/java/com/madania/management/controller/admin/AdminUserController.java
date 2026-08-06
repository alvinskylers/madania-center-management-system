package com.madania.management.controller.admin;

import com.madania.management.entity.User;
import com.madania.management.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminUserController {

    private final UserService userService;

    @GetMapping("/users")
    public String users(Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "asc") String sort,
            @RequestParam(required = false) String query) {
        Page<User> userPage = userService.getAllQueried(query, page, size, sort);

        model.addAttribute("users" , userPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("totalItems", userPage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("query", query);

        return "pages/admin/user/index";
    }

    @PostMapping("/users/{id}/deactive")
    public String deactivateUser (@PathVariable UUID id) {
        userService.deactivateUser(id);
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/active")
    public String activateUser(@PathVariable UUID id) {
        userService.activateUser(id);
        return "redirect:/admin/users";
    }

    @GetMapping("/users/{id}/reset-password")
    public String resetPasswordForm(@PathVariable UUID id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user" ,user);
        return "pages/user-reset-password";
    }

    @PostMapping("/users/{id}/reset-password")
    public String resetPassword(@PathVariable UUID id, @RequestParam String newPassword) {
        userService.resetPassword(id, newPassword);
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable UUID id) {
        userService.deleteUser(id);
        return "redirect:/admin/users";
    }

}
