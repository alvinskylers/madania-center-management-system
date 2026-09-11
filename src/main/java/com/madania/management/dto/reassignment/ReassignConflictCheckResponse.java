package com.madania.management.dto.reassignment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReassignConflictCheckResponse {
    private boolean hasConflicts;
    private List<SessionConflictDto> sessions;
}
