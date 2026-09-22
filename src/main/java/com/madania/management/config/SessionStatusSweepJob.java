package com.madania.management.config;

import com.madania.management.entity.TherapySession;
import com.madania.management.enums.SessionStatus;
import com.madania.management.repository.TherapySessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Sessions are only resolved to COMPLETED or NO_SHOW by a human action (a therapist
 * clicking a button). If nobody acts, a session whose time has already passed would
 * otherwise sit as SCHEDULED forever, which is misleading on the calendar and in reports.
 * <p>
 * This job periodically sweeps for exactly that case and moves the session to
 * PENDING_REVIEW instead — a distinct, honest state meaning "this already happened,
 * but nobody has confirmed what happened yet." A therapist (or admin) still has to
 * resolve it manually into COMPLETED or NO_SHOW; this job never guesses the outcome,
 * it only stops the record from silently lying about the session still being upcoming.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class SessionStatusSweepJob {

    private final TherapySessionRepository sessionRepository;

    @Scheduled(cron = "0 0 * * * *") // every hour, on the hour
    @Transactional
    public void flagOverdueSessions() {
        List<TherapySession> overdue = sessionRepository
                .findByStatusAndEndTimeBefore(SessionStatus.SCHEDULED, LocalDateTime.now());

        if (overdue.isEmpty()) {
            return;
        }

        overdue.forEach(s -> s.setStatus(SessionStatus.PENDING_REVIEW));
        sessionRepository.saveAll(overdue);

        log.info("Flagged {} overdue session(s) as PENDING_REVIEW", overdue.size());
    }
}
