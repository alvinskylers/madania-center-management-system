package com.madania.management.enums;

public enum TherapyType {
    OCCUPATIONAL("Occupational"),
    BEHAVIOURAL("Behavioural"),
    PHYSICAL("Physical"),
    SPEECH("Speech"),
    ABA("ABA"),
    OTHER("Other");

    private final String label;

    TherapyType(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
