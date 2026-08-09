package com.madania.management.dto;

import com.madania.management.enums.MoodRating;
import com.madania.management.enums.TherapyType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class JournalRequest {

    @NotBlank(message = "Title is required")
    private String title;

    @NotNull(message = "Therapy type is required")
    private TherapyType therapyType;

    @NotBlank(message = "Session goals are required")
    private String sessionGoals;

    @NotBlank(message = "Content is required")
    private String content;

    @NotBlank(message = "Progress notes are required")
    private String progressNotes;

    private String goalsAchieved;
    private String parentRecommendations;
    private MoodRating moodRating;
    private String documentationUrl;
}