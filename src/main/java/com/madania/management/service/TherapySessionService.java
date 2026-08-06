package com.madania.management.service;

import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.TherapySessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TherapySessionService {

    private final TherapySessionRepository sessionRepository;
    private final TherapistRepository therapistRepository;
    private final TherapistService therapistService;

    public Therapist getTherapistByUserId(UUID id) {
        return therapistRepository.findByUserId(id)
                .orElseThrow(() -> new RuntimeException("Therapist profile not found for id: " + id));
    }

    public List<TherapySession> getSessionsByTherapistId(UUID therapistId) {
        return sessionRepository.findByTherapistId(therapistId);
    }

}
