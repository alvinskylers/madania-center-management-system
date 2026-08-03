package com.madania.management.entity;

import com.madania.management.enums.Gender;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@Builder
@Table(name = "patients")
@NoArgsConstructor
@AllArgsConstructor
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id", nullable = false)
    private Parent parent;

    @Column(nullable = false)
    private String fullName;

    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    private String diagnosis;

    private String notes;

    private boolean isActive;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;
}
