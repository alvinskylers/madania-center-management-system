package com.madania.management.enums;

public enum SessionStatus {
    SCHEDULED("Dijadwalkan"),
    COMPLETED("Tuntas"),
    CANCELLED("Dibatalkan"),
    RESCHEDULED("Reschedule");

    private final String label;

    SessionStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
