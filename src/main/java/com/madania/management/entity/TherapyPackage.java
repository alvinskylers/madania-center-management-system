package com.madania.management.entity;

import com.madania.management.enums.PackageStatus;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@Builder
@Table(name = "therapy_packages")
@NoArgsConstructor
@AllArgsConstructor
public class TherapyPackage {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "therapist_id")
    private Therapist therapist;

    @ManyToOne
    @JoinColumn(name = "creator_id")
    private User createdBy;

    @ManyToOne
    @JoinColumn(name = "package_type_id")
    private PackageType packageType;

    @ManyToOne
    @JoinColumn(name = "checkup_id")
    private Checkup checkup;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String diagnosis;

    @Column(nullable = false)
    private LocalDate startDate;

    private LocalDate endDate;

    private LocalTime sessionTime;

    @Column(nullable = false)
    private int totalSessions;

    @Column(nullable = false)
    private int completedSessions = 0;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PackageStatus status = PackageStatus.ACTIVE;

    private String notes;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}