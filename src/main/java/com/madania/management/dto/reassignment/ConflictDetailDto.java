package com.madania.management.dto.reassignment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * One thing that a proposed session time collides with — either an existing session
 * already on the new therapist's schedule, or another remaining session from the
 * same package that is also being moved to the new therapist.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConflictDetailDto {
    private UUID conflictingSessionId;
    private String patientName;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    /** "EXTERNAL" = clashes with the new therapist's existing schedule, "SAME_PACKAGE" = clashes with another remaining session in this same package */
    private String source;
}
