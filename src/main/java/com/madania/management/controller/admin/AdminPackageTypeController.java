package com.madania.management.controller.admin;

import com.madania.management.dto.PackageTypeCreateRequest;
import com.madania.management.entity.PackageType;
import com.madania.management.service.PackageTypeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminPackageTypeController {

    private final PackageTypeService packageTypeService;

    @GetMapping("/package-types")
    public String packageTypes(Model model) {
        List<PackageType> packageTypes = packageTypeService.getAllPackageTypes();
        model.addAttribute("packageTypes", packageTypes);
        return "pages/admin/package-type/index";
    }

    @GetMapping("/package-type/create")
    public String createPackageTypeForm(Model model) {
        model.addAttribute("request", new PackageTypeCreateRequest());
        return "pages/admin/package-type/create";
    }

    @PostMapping("/package-type/create")
    public String createPackageType(@Valid @ModelAttribute("request") PackageTypeCreateRequest request,
                                    BindingResult bindingResult,
                                    Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("bindingResult", bindingResult);
            return "pages/admin/package-type/create";
        }

        try {
            packageTypeService.createPackageType(
                    request.getName(), request.getTotalSessions(), request.getSessionsPerWeek());
        } catch (RuntimeException e) {
            model.addAttribute("formError", e.getMessage());
            return "pages/admin/package-type/create";
        }

        return "redirect:/admin/package-types";
    }

    @PostMapping("/package-type/{id}/deactivate")
    public String deactivatePackageType(@PathVariable UUID id) {
        packageTypeService.deactivatePackageType(id);
        return "redirect:/admin/package-types";
    }

    @PostMapping("/package-type/{id}/activate")
    public String activatePackageType(@PathVariable UUID id) {
        packageTypeService.activatePackageType(id);
        return "redirect:/admin/package-types";
    }
}