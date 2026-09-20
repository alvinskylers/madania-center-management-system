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
    @NotNull(message = "sessionId wajib diisi")
    private UUID sessionId;

    @NotNull(message = "newStartTime wajib diisi")
    private LocalDateTime newStartTime;
}
