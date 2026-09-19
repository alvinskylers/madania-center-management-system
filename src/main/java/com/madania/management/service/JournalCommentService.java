package com.madania.management.service;

import com.madania.management.entity.JournalComment;
import com.madania.management.entity.TherapyJournal;
import com.madania.management.entity.User;
import com.madania.management.enums.NotificationType;
import com.madania.management.repository.JournalCommentRepository;
import com.madania.management.repository.TherapyJournalRepository;
import com.madania.management.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class JournalCommentService {

    private final JournalCommentRepository commentRepository;
    private final TherapyJournalRepository journalRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public List<JournalComment> getCommentsForJournal(UUID journalId) {
        return commentRepository.findByJournalIdOrderByCreatedAtAsc(journalId);
    }

    @Transactional
    public JournalComment addComment(UUID journalId, UUID commentedByUserId, String content) {
        TherapyJournal journal = journalRepository.findById(journalId)
                .orElseThrow(() -> new RuntimeException("Jurnal tidak ditemukan: " + journalId));

        if (content == null || content.isBlank()) {
            throw new RuntimeException("Komentar tidak boleh kosong");
        }

        User commentedBy = userRepository.findById(commentedByUserId)
                .orElseThrow(() -> new RuntimeException("Pengguna tidak ditemukan: " + commentedByUserId));

        JournalComment comment = JournalComment.builder()
                .journal(journal)
                .commentedBy(commentedBy)
                .content(content.trim())
                .build();

        JournalComment saved = commentRepository.save(comment);

        User therapistUser = journal.getTherapist().getUser();
        String message = commentedBy.getName() + " mengomentari jurnal untuk "
                + journal.getPatient().getFullName() + " sesi";
        notificationService.notify(therapistUser, NotificationType.JOURNAL_COMMENT, message, journal.getSession());

        return saved;
    }
}