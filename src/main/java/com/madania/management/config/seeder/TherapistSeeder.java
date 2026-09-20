package com.madania.management.config.seeder;

import com.madania.management.repository.UserRepository;
import com.madania.management.service.TherapistService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * Seeds 3 demo therapists, one per specialty this clinic focuses on:
 * ADHD, Speech Delay, and Autism Spectrum Disorder. TherapyPackageSeeder
 * and JournalSeeder both look these up by email/specialization, so keep
 * those in sync if you change anything here.
 */
@Component
@Order(2)
@RequiredArgsConstructor
@Slf4j
public class TherapistSeeder implements CommandLineRunner {

    private final TherapistService therapistService;
    private final UserRepository userRepository;

    @Override
    public void run(String... args) {
        if (userRepository.existsByEmail("nadia.putri@madania.com")) {
            return;
        }

        therapistService.createTherapist(
                "nadia.putri@madania.com", "password",
                "Nadia Putri, S.Psi", "ADHD", "081234500001");

        therapistService.createTherapist(
                "rizky.hidayat@madania.com", "password",
                "Rizky Hidayat, M.Psi", "Speech Delay", "081234500002");

        therapistService.createTherapist(
                "amelia.wijaya@madania.com", "password",
                "Amelia Wijaya, S.Psi., Psikolog", "Autism Spectrum Disorder", "081234500003");

        log.info("Seeded 3 demo therapists.");
    }
}
