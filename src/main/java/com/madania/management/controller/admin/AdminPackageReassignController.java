package com.madania.management.controller.admin;

import com.madania.management.dto.reassignment.ReassignConflictCheckResponse;
import com.madania.management.dto.reassignment.ReassignTherapistRequest;
import com.madania.management.dto.reassignment.SessionOverrideDto;
import com.madania.management.service.PackageReassignmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/package/{id}/reassign")
@RequiredArgsConstructor
public class AdminPackageReassignController {

    private final PackageReassignmentService reassignmentService;

    @PostMapping("/conflicts")
    @ResponseBody
    public ResponseEntity<?> checkConflicts(@PathVariable UUID id, @RequestBody ReassignTherapistRequest request) {
        try {
            ReassignConflictCheckResponse response = reassignmentService.checkConflicts(
                    id, request.getNewTherapistId(), toOverrideMap(request.getOverrides())
            );
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<?> reassign(@PathVariable UUID id, @RequestBody ReassignTherapistRequest request) {
        try {
            reassignmentService.reassignTherapist(
                    id, request.getNewTherapistId(), request.getReason(), toOverrideMap(request.getOverrides())
            );
            return ResponseEntity.ok(Map.of("redirectUrl", "/admin/package/" + id));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    private Map<UUID, LocalDateTime> toOverrideMap(List<SessionOverrideDto> overrides) {
        if (overrides == null) return Map.of();
        return overrides.stream()
                .collect(Collectors.toMap(SessionOverrideDto::getSessionId, SessionOverrideDto::getNewStartTime));
    }
}
