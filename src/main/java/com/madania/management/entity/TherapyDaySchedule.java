package com.madania.management.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.DayOfWeek;

@Entity
@Getter
@Setter
@Builder
@Table(name = "package_schedule_days")
@NoArgsConstructor
@AllArgsConstructor
public class TherapyDaySchedule {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "therapy_package_id")
    private TherapyPackage therapyPackage;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DayOfWeek day;

}
