package com.madania.management.service;

import java.time.Clock;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Rules that decide whether a parent / therapist may request a reschedule.
 * <p>
 * Kept free of Spring / JPA on purpose: it only depends on {@code java.time}, so it is trivial
 * to unit-test with a fixed {@link Clock}. It is wired up as a bean in
 * {@code SchedulingRulesConfig}.
 * <p>
 * Rules:
 * <ol>
 *   <li><b>Minimum notice</b> - measured in calendar days against the ORIGINAL session date.
 *       With a 3-day notice, a session on Monday can be requested up to (and including) Friday.
 *       A session starting in 30 minutes can never be requested.</li>
 *   <li><b>Different date</b> - the requested time may not fall on the same calendar date as the
 *       session's current date.</li>
 *   <li><b>Not in the past</b> - the requested time must not be before "now".</li>
 * </ol>
 * These are deliberately NOT part of the shared {@code TherapySessionService} validators, because
 * leave approval, package reassignment, etc. move sessions too and must not inherit them.
 */
public class RescheduleNoticePolicy {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("EEEE, d MMMM yyyy");
    private static final DateTimeFormatter DATE_TIME_FORMAT = DateTimeFormatter.ofPattern("EEEE, d MMMM yyyy HH:mm");

    private final Clock clock;
    private final int minNoticeDays;

    public RescheduleNoticePolicy(Clock clock, int minNoticeDays) {
        if (clock == null) {
            throw new IllegalArgumentException("clock wajib diisi");
        }
        if (minNoticeDays < 0) {
            throw new IllegalArgumentException("Minimum hari pemberitahuan tidak boleh negatif: " + minNoticeDays);
        }
        this.clock = clock;
        this.minNoticeDays = minNoticeDays;
    }

    public int getMinNoticeDays() {
        return minNoticeDays;
    }

    /** Last calendar day on which a reschedule may still be requested for a session starting at {@code originalStart}. */
    public LocalDate deadlineFor(LocalDateTime originalStart) {
        return originalStart.toLocalDate().minusDays(minNoticeDays);
    }

    /** True if the session has not started yet and today is not past the notice deadline. */
    public boolean canRequest(LocalDateTime originalStart) {
        LocalDateTime now = LocalDateTime.now(clock);
        if (originalStart.isBefore(now)) {
            return false;
        }
        return !now.toLocalDate().isAfter(deadlineFor(originalStart));
    }

    /**
     * Full check applied when a reschedule request is SUBMITTED.
     *
     * @throws RuntimeException with a user-facing (Indonesian) message when a rule is violated,
     *                          matching the error style used across the service layer
     */
    public void validateRequest(LocalDateTime originalStart, LocalDateTime requestedStart) {
        if (requestedStart == null) {
            throw new RuntimeException("Waktu baru untuk penjadwalan ulang wajib diisi.");
        }

        if (originalStart.isBefore(LocalDateTime.now(clock))) {
            throw new RuntimeException("Sesi ini sudah dimulai atau sudah berlalu sehingga tidak dapat dijadwalkan ulang.");
        }

        if (!canRequest(originalStart)) {
            throw new RuntimeException(
                    "Penjadwalan ulang harus diajukan paling lambat " + minNoticeDays + " hari sebelum tanggal sesi. " +
                            "Untuk sesi pada " + originalStart.toLocalDate().format(DATE_FORMAT) +
                            ", batas pengajuan adalah " + deadlineFor(originalStart).format(DATE_FORMAT) + ". " +
                            "Silakan hubungi klinik untuk bantuan."
            );
        }

        if (requestedStart.toLocalDate().equals(originalStart.toLocalDate())) {
            throw new RuntimeException(
                    "Waktu baru tidak boleh berada pada tanggal yang sama dengan jadwal sesi saat ini (" +
                            originalStart.toLocalDate().format(DATE_FORMAT) + "). Silakan pilih tanggal lain."
            );
        }

        validateNotInPast(requestedStart);
    }

    /**
     * Applied on submission AND again on approval: a request can be valid when submitted but
     * the requested time may already have passed by the time an admin gets to it.
     */
    public void validateNotInPast(LocalDateTime requestedStart) {
        if (requestedStart.isBefore(LocalDateTime.now(clock))) {
            throw new RuntimeException(
                    "Waktu yang diminta (" + requestedStart.format(DATE_TIME_FORMAT) + ") tidak boleh di masa lalu."
            );
        }
    }
}
