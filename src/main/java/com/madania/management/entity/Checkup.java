package com.madania.management.entity;

import com.madania.management.enums.CheckupStatus;
import com.madania.management.enums.ParentDecision;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * An initial diagnosis checkup, scheduled before any therapy package exists.
 * Business flow: receptionist registers parent + patient -> schedules a
 * Checkup with a therapist -> after the checkup happens, receptionist
 * records the diagnosis and the parent's decision -> if the parent wants to
 * proceed, a TherapyPackage is created and linked back to this checkup.
 */
@Entity
@Getter
@Setter
@Builder
@Table(name = "checkups")
@NoArgsConstructor
@AllArgsConstructor
public class Checkup {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "therapist_id", nullable = false)
    private Therapist therapist;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by_id")
    private User createdBy;

    @Column(nullable = false)
    private LocalDateTime scheduledAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CheckupStatus status;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ParentDecision parentDecision;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(columnDefinition = "TEXT")
    private String diagnosisNotes;

    private String cancellationReason;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
