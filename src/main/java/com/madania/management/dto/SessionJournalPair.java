package com.madania.management.dto;

import com.madania.management.entity.TherapyJournal;
import com.madania.management.entity.TherapySession;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class SessionJournalPair {
    private final TherapySession session;
    private final TherapyJournal Journal;
}
