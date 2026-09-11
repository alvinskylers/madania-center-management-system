package com.madania.management.dto.reassignment;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SessionOverrideDto {
    @NotNull(message = "sessionId is required")
    private UUID sessionId;

    @NotNull(message = "newStartTime is required")
    private LocalDateTime newStartTime;
}
