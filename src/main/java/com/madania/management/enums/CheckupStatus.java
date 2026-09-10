package com.madania.management.enums;

public enum CheckupStatus {
    SCHEDULED("Dijadwalkan"),
    COMPLETED("Selesai"),
    CANCELLED("Dibatalkan");

    private final String label;

    CheckupStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
