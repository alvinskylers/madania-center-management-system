package com.madania.management.enums;

public enum ParentDecision {
    PENDING("Menunggu Keputusan"),
    PROCEED_TO_THERAPY("Lanjut Terapi"),
    DECLINED("Tidak Melanjutkan");

    private final String label;

    ParentDecision(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
