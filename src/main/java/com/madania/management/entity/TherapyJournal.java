package com.madania.management.entity;

import com.madania.management.enums.MoodRating;
import com.madania.management.enums.TherapyType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Builder
@Table(name = "therapy_journals")
@NoArgsConstructor
@AllArgsConstructor
public class TherapyJournal {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @OneToOne
    @JoinColumn(name = "therapy_session_id", nullable = false, unique = true)
    private TherapySession session;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "therapist_id", nullable = false)
    private Therapist therapist;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TherapyType type;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String sessionGoals;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String progressNotes;

    @Column(columnDefinition = "TEXT")
    private String goalsAchieved;

    @Column(columnDefinition = "TEXT")
    private String parentRecommendations;

    @Column
    private String documentationUrl;

    @Enumerated(EnumType.STRING)
    private MoodRating mood;

    @CreationTimestamp
    @Column(nullable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

}
