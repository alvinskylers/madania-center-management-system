package com.madania.management.controller.admin;

import com.madania.management.entity.User;
import com.madania.management.service.UserService;
import lombok.RequiredArgsConstructor;
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
    public String users(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users" , users);
        return "pages/users";
    }

    @GetMapping("/users/{id}/edit")
    public String editUserForm(@PathVariable UUID id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "pages/user-edit";
    }

    @PostMapping("/users/{id}/edit")
    public String editUser(@PathVariable UUID id,
                           @RequestParam String username,
                           @RequestParam String email) {
        userService.updateUser(id, username, email);
        return "redirect:/admin/users";
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
