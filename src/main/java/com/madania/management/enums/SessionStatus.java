package com.madania.management.enums;

public enum SessionStatus {
    SCHEDULED("Dijadwalkan"),
    PENDING_REVIEW("Menunggu Konfirmasi"),
    COMPLETED("Tuntas"),
    NO_SHOW("Tidak Hadir"),
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
