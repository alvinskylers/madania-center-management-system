package com.madania.management.controller.admin;

import com.madania.management.dto.UserCreateRequest;
import com.madania.management.entity.User;
import com.madania.management.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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

    @GetMapping("/users/create")
    public String createUserForm(Model model) {
        model.addAttribute("userRequest", new UserCreateRequest());
        return "pages/user-create";
    }

    @PostMapping("/users/create")
    public String createUser(@Valid @ModelAttribute UserCreateRequest request,
                             BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return "pages/user-create";
        }

        switch (request.getRole()) {
            case "ADMIN" -> userService.createAdmin(
                    request.getUsername(), request.getEmail(), request.getPassword());
            case "THERAPIST" -> userService.createTherapist(
                    request.getUsername(), request.getEmail(), request.getPassword(),
                    request.getPhone(), request.getSpecialization());
            case "PARENT" -> userService.createParent(
                    request.getUsername(), request.getEmail(), request.getPassword(),
                    request.getPhone(), request.getAddress());
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/users/{id}/edit")
    public String editUserForm(@PathVariable Long id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "pages/user-edit";
    }

    @PostMapping("/users/{id}/edit")
    public String editUser(@PathVariable Long id,
                           @RequestParam String username,
                           @RequestParam String email) {
        userService.updateUser(id, username, email);
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/deactive")
    public String deactivateUser (@PathVariable Long id) {
        userService.deactivateUser(id);
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/active")
    public String activateUser(@PathVariable Long id) {
        userService.activateUser(id);
        return "redirect:/admin/users";
    }

    @GetMapping("/users/{id}/reset-password")
    public String resetPasswordForm(@PathVariable Long id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user" ,user);
        return "pages/user-reset-password";
    }

    @PostMapping("/users/{id}/reset-password")
    public String resetPassword(@PathVariable Long id, @RequestParam String newPassword) {
        userService.resetPassword(id, newPassword);
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return "redirect:/admin/users";
    }

}
