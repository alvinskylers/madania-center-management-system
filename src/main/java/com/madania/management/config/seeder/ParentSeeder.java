package com.madania.management.config.seeder;

import com.madania.management.repository.UserRepository;
import com.madania.management.service.ParentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * Seeds 4 demo parents. Budi Santoso and Siti Rahayu each get a second
 * child in PatientSeeder; Ahmad Fauzi and Dewi Lestari get one each.
 */
@Component
@Order(3)
@RequiredArgsConstructor
@Slf4j
public class ParentSeeder implements CommandLineRunner {

    private final ParentService parentService;
    private final UserRepository userRepository;

    @Override
    public void run(String... args) {
        if (userRepository.existsByEmail("budi.santoso@gmail.com")) {
            return;
        }

        parentService.createParent(
                "Budi Santoso", "budi.santoso@gmail.com", "password",
                "081234600001", "Jl. Merdeka No. 12, Jakarta Selatan");

        parentService.createParent(
                "Siti Rahayu", "siti.rahayu@gmail.com", "password",
                "081234600002", "Jl. Kenanga No. 5, Jakarta Timur");

        parentService.createParent(
                "Ahmad Fauzi", "ahmad.fauzi@gmail.com", "password",
                "081234600003", "Jl. Mawar No. 8, Jakarta Barat");

        parentService.createParent(
                "Dewi Lestari", "dewi.lestari@gmail.com", "password",
                "081234600004", "Jl. Anggrek No. 20, Jakarta Utara");

        log.info("Seeded 4 demo parents.");
    }
}
