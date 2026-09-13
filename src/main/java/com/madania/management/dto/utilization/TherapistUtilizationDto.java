package com.madania.management.dto.utilization;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder(toBuilder = true)
@NoArgsConstructor
@AllArgsConstructor
public class TherapistUtilizationDto {
    private UUID therapistId;
    private String fullName;
    private long activeCaseload;
    private long sessionsThisWeek;
    /** Null when the therapist has no completed/cancelled sessions yet to compute a rate from. */
    private Double completionRatePercent;
    private boolean onLeaveThisWeek;
    /** Human-readable date range, e.g. "15 Sep - 18 Sep", only set when onLeaveThisWeek is true. */
    private String leaveRangeLabel;
    /** True when sessionsThisWeek is well above the group average, for the summary count and row highlight. */
    private boolean overloaded;
}
