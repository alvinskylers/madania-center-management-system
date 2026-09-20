package com.madania.management.dto;

import com.madania.management.enums.MoodRating;
import com.madania.management.enums.TherapyType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class JournalRequest {

    @NotBlank(message = "Judul wajib diisi")
    private String title;

    @NotNull(message = "Jenis terapi wajib dipilih")
    private TherapyType therapyType;

    @NotBlank(message = "Tujuan sesi wajib diisi")
    private String sessionGoals;

    @NotBlank(message = "Konten wajib diisi")
    private String content;

    @NotBlank(message = "Catatan perkembangan wajib diisi")
    private String progressNotes;

    private String goalsAchieved;
    private String parentRecommendations;
    private MoodRating moodRating;
    private String documentationUrl;
}