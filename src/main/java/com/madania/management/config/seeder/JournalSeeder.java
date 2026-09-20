package com.madania.management.config.seeder;

import com.madania.management.entity.Therapist;
import com.madania.management.entity.TherapySession;
import com.madania.management.enums.MoodRating;
import com.madania.management.enums.SessionStatus;
import com.madania.management.enums.TherapyType;
import com.madania.management.repository.TherapyJournalRepository;
import com.madania.management.service.TherapistService;
import com.madania.management.service.TherapyJournalService;
import com.madania.management.service.TherapySessionService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Seeds a journal entry for every session TherapyPackageSeeder already
 * settled as COMPLETED - both sessions belonging to the 2 fully completed
 * packages and the already-happened sessions of the 6 still-ongoing
 * packages. One journal per completed session, written in a style/therapy
 * type matching that therapist's specialty.
 * <p>
 * Exception: the {@value #PENDING_JOURNAL_COUNT} most recent completed
 * sessions of {@value #PATIENT_WITH_PENDING_JOURNALS} are deliberately left
 * WITHOUT a journal, so the "journals not written yet" flow (the therapist
 * dashboard's pending list) has demo data to show.
 */
@Component
@Order(6)
@RequiredArgsConstructor
@Slf4j
public class JournalSeeder implements CommandLineRunner {

    private final TherapyJournalService journalService;
    private final TherapySessionService sessionService;
    private final TherapistService therapistService;
    private final TherapyJournalRepository journalRepository;

    /** Patient whose latest completed sessions are left without a journal. */
    private static final String PATIENT_WITH_PENDING_JOURNALS = "Kevin Santoso";

    /** How many of that patient's most recent completed sessions stay unwritten. */
    private static final int PENDING_JOURNAL_COUNT = 2;

    private static final Map<String, TherapyType> THERAPY_TYPE_BY_SPECIALIZATION = Map.of(
            "ADHD", TherapyType.BEHAVIOURAL,
            "Speech Delay", TherapyType.SPEECH,
            "Autism Spectrum Disorder", TherapyType.ABA
    );

    private static final Map<String, List<String>> GOALS_BY_SPECIALIZATION = Map.of(
            "ADHD", List.of(
                    "Meningkatkan kemampuan fokus selama 15 menit",
                    "Melatih kontrol impuls saat menunggu giliran",
                    "Mengurangi perilaku hiperaktif saat duduk tenang"),
            "Speech Delay", List.of(
                    "Melatih pengucapan kata benda sehari-hari",
                    "Meningkatkan kemampuan menyusun kalimat 2 kata",
                    "Melatih pemahaman instruksi sederhana"),
            "Autism Spectrum Disorder", List.of(
                    "Melatih kontak mata saat berkomunikasi",
                    "Meningkatkan kemampuan bermain interaktif",
                    "Mengurangi perilaku repetitif melalui pengalihan aktivitas")
    );

    private static final MoodRating[] MOOD_CYCLE = {
            MoodRating.HAPPY, MoodRating.NEUTRAL, MoodRating.VERY_HAPPY, MoodRating.HAPPY, MoodRating.NEUTRAL
    };

    @Override
    @Transactional
    public void run(String... args) {
        if (!journalRepository.findAll().isEmpty()) {
            return;
        }

        Set<UUID> pendingSessionIds = findSessionIdsToLeaveUnwritten();
        int totalJournals = 0;

        for (Therapist therapist : therapistService.getAllTherapists()) {
            TherapyType therapyType = THERAPY_TYPE_BY_SPECIALIZATION.getOrDefault(
                    therapist.getSpecialization(), TherapyType.OTHER);
            List<String> goals = GOALS_BY_SPECIALIZATION.getOrDefault(
                    therapist.getSpecialization(), List.of("Melanjutkan target terapi sesuai rencana."));

            List<TherapySession> completedSessions = sessionService.getCompletedSessionsWithoutJournal(therapist.getId())
                    .stream()
                    .filter(s -> !pendingSessionIds.contains(s.getId()))
                    .sorted(Comparator.comparing(TherapySession::getStartTime))
                    .toList();

            int i = 0;
            for (TherapySession session : completedSessions) {
                String patientName = session.getPatient().getFullName();

                journalService.createJournal(
                        session.getId(), therapist.getId(),
                        "Sesi " + session.getSessionNumber() + " - " + patientName,
                        therapyType,
                        goals.get(i % goals.size()),
                        patientName + " berpartisipasi aktif dan mengikuti seluruh rangkaian aktivitas " +
                                "sesi ini dengan baik.",
                        "Menunjukkan kemajuan bertahap dibandingkan sesi-sesi sebelumnya.",
                        i % 2 == 0 ? "Berhasil menyelesaikan sebagian besar target yang ditetapkan untuk sesi ini." : null,
                        "Lanjutkan latihan serupa di rumah selama 10-15 menit setiap hari, dengan pendampingan orang tua.",
                        MOOD_CYCLE[i % MOOD_CYCLE.length],
                        null
                );
                i++;
                totalJournals++;
            }
        }

        log.info("Seeded {} demo therapy journals ({} completed sessions of {} left without a journal).",
                totalJournals, pendingSessionIds.size(), PATIENT_WITH_PENDING_JOURNALS);
    }

    /**
     * Picks the PENDING_JOURNAL_COUNT most recent COMPLETED sessions of
     * PATIENT_WITH_PENDING_JOURNALS. Those are the ones a therapist would
     * realistically not have written up yet. Older sessions still get their
     * journal as usual.
     */
    private Set<UUID> findSessionIdsToLeaveUnwritten() {
        Set<UUID> ids = sessionService.getAllSessions().stream()
                .filter(s -> s.getStatus() == SessionStatus.COMPLETED)
                .filter(s -> s.getPatient().getFullName().equals(PATIENT_WITH_PENDING_JOURNALS))
                .sorted(Comparator.comparing(TherapySession::getStartTime).reversed())
                .limit(PENDING_JOURNAL_COUNT)
                .map(TherapySession::getId)
                .collect(Collectors.toSet());

        if (ids.size() < PENDING_JOURNAL_COUNT) {
            log.warn("Only {} completed session(s) found for {}; expected at least {} to leave unwritten.",
                    ids.size(), PATIENT_WITH_PENDING_JOURNALS, PENDING_JOURNAL_COUNT);
        }

        return ids;
    }
}