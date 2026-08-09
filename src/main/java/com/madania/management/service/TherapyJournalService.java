package com.madania.management.service;

import com.madania.management.entity.TherapyJournal;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.TherapyJournalRepository;
import com.madania.management.repository.TherapySessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TherapyJournalService {

    private final TherapyJournalRepository journalRepository;
    private final TherapySessionRepository sessionRepository;
    private final TherapistRepository therapistRepository;

    public List<TherapyJournal> getJournalsByTherapistId(UUID therapistId) {
        return journalRepository.findByTherapistId(therapistId);
    }

    public TherapyJournal getJournalBySessionId(UUID sessionId) {
        return journalRepository.findBySessionId(sessionId).orElse(null);
    }

    public TherapyJournal getJournalById(UUID id) {
        return journalRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Journal not found with id: " + id));
    }

}
