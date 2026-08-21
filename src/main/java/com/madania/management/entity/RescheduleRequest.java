package com.madania.management.entity;

import com.madania.management.enums.RescheduleStatus;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@Builder
@Table(name = "reschedule_requests")
@AllArgsConstructor
@NoArgsConstructor
public class RescheduleRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "therapy_session_id")
    private TherapySession session;

    @ManyToOne
    @JoinColumn(name = "requested_by_id")
    private User requestedBy;

    @Enumerated
    @Column(nullable = false)
    private RescheduleStatus status = RescheduleStatus.PENDING;

    @Column(nullable = false)
    private LocalDateTime requestedStartTime;

    private String reason;

    private String adminNotes;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

}
