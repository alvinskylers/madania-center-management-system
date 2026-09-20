package com.madania.management.config.seeder;

import com.madania.management.entity.User;
import com.madania.management.enums.Role;
import com.madania.management.repository.PackageTypeRepository;
import com.madania.management.repository.UserRepository;
import com.madania.management.service.PackageTypeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Seeds the default package types so the demo seeders (which reference
 * "Paket Reguler" by name) have something to attach their packages to.
 * Runs before every other seeder (@Order(0)).
 */
@Component
@Order(1)
@RequiredArgsConstructor
@Slf4j
public class PackageTypeSeeder implements CommandLineRunner {

    private final PackageTypeRepository packageTypeRepository;
    private final PackageTypeService packageTypeService;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (!packageTypeRepository.existsByName("Paket Reguler")) {
            packageTypeService.createPackageType("Paket Ringan", 8, 2);
            packageTypeService.createPackageType("Paket Reguler", 12, 3);
            packageTypeService.createPackageType("Paket Intensif", 20, 5);
            log.info("Seeded default packages.");
        }


        boolean receptionistExists = userRepository.findAll().stream()
                .anyMatch(u -> u.getRole() == Role.RECEPTIONIST);

        if (receptionistExists) {
            return;
        }

        String email = System.getenv().getOrDefault("RECEPTIONIST_EMAIL","receptionist@madania.com");
        String password = System.getenv().getOrDefault("RECEPTIONIST_PASSWORD","password");

        User receptionist  = User.builder()
                .email(email)
                .password(passwordEncoder.encode(password))
                .name("Receptionist")
                .role(Role.RECEPTIONIST)
                .isActive(true)
                .build();
        userRepository.save(receptionist);
    }


}
