package com.madania.management.enums;

public enum MoodRating {
    VERY_HAPPY("Sangat Senang", "\uD83D\uDE04"),
    HAPPY("Senang", "\uD83D\uDE42"),
    NEUTRAL("Netral", "\uD83D\uDE10"),
    UPSET("Sedih", "\uD83D\uDE41"),
    VERY_UPSET("Sangat Sedih", "\uD83D\uDE22");

    private final String label;
    private final String emoji;

    MoodRating(String label, String emoji) {
        this.label = label;
        this.emoji = emoji;
    }

    public String getLabel() {
        return label;
    }

    public String getEmoji() {
        return emoji;
    }
}
