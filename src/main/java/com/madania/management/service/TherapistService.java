package com.madania.management.service;

import com.madania.management.entity.Therapist;
import com.madania.management.repository.TherapistRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TherapistService {

    private final TherapistRepository therapistRepository;

    public List<Therapist> getAllTherapists() {
        return therapistRepository.findAll();
    }
}
