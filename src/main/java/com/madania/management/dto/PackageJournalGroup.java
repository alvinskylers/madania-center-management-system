package com.madania.management.dto;

import com.madania.management.entity.TherapyPackage;
import com.madania.management.entity.TherapySession;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Getter
@RequiredArgsConstructor
public class PackageJournalGroup {
    private final TherapyPackage therapyPackage;
    private final List<SessionJournalPair> sessions;
}
