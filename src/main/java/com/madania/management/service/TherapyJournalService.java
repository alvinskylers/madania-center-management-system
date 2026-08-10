package com.madania.management.service;

import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.MoodRating;
import com.madania.management.enums.TherapyType;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.TherapyJournalRepository;
import com.madania.management.repository.TherapySessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Transactional
    public TherapyJournal createJournal(UUID sessionId, UUID therapistId,
                                        String title, TherapyType therapyType,
                                        String sessionGoals, String content,
                                        String progressNotes, String goalsAchieved,
                                        String parentRecommendations, MoodRating moodRating,
                                        String documentationUrl) {

        TherapySession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found with id: " + sessionId));

        if (journalRepository.findBySessionId(sessionId).isPresent()) {
            throw new RuntimeException("A journal already exists for this session");
        }

        Therapist therapist = therapistRepository.findById(therapistId)
                .orElseThrow(() -> new RuntimeException("Therapist not found with id: " + therapistId));

        TherapyJournal journal = TherapyJournal.builder()
                .session(session)
                .therapist(therapist)
                .patient(session.getPatient())
                .title(title)
                .therapyType(therapyType)
                .sessionGoals(sessionGoals)
                .content(content)
                .progressNotes(progressNotes)
                .goalsAchieved(goalsAchieved)
                .parentRecommendations(parentRecommendations)
                .mood(moodRating)
                .documentationUrl(documentationUrl)
                .build();

        return journalRepository.save(journal);
    }

    @Transactional
    public TherapyJournal updateJournal(UUID id, String title, TherapyType therapyType,
                                        String sessionGoals, String content,
                                        String progressNotes, String goalsAchieved,
                                        String parentRecommendations, MoodRating moodRating,
                                        String documentationUrl) {

        TherapyJournal journal = getJournalById(id);
        journal.setTitle(title);
        journal.setTherapyType(therapyType);
        journal.setSessionGoals(sessionGoals);
        journal.setContent(content);
        journal.setProgressNotes(progressNotes);
        journal.setGoalsAchieved(goalsAchieved);
        journal.setParentRecommendations(parentRecommendations);
        journal.setMood(moodRating);
        journal.setDocumentationUrl(documentationUrl);

        return journalRepository.save(journal);
    }
}
