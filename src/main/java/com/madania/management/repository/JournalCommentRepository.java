package com.madania.management.repository;

import com.madania.management.entity.JournalComment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface JournalCommentRepository extends JpaRepository<JournalComment, UUID> {
    List<JournalComment> findByJournalIdOrderByCreatedAtAsc(UUID journalId);
}
