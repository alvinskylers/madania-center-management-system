package com.madania.management.dto.reassignment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SessionConflictDto {
    private UUID sessionId;
    private int sessionNumber;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    /** true if startTime/endTime above reflect an admin override rather than the session's original time */
    private boolean overridden;
    private List<ConflictDetailDto> conflicts;
}
