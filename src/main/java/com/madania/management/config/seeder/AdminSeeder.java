package com.madania.management.config.seeder;

import com.madania.management.entity.User;
import com.madania.management.enums.Role;
import com.madania.management.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;

@Slf4j
@Configuration
@RequiredArgsConstructor
@Order(0)
public class AdminSeeder implements CommandLineRunner{

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {

        boolean adminExists = userRepository.findAll().stream()
                .anyMatch(u -> u.getRole() == Role.ADMIN);

        if (adminExists) {
            return;
        }

        String email = System.getenv().getOrDefault("ADMIN_EMAIL","admin@madania.com");
        String password = System.getenv().getOrDefault("ADMIN_PASSWORD","password");

        User admin  = User.builder()
                .email(email)
                .password(passwordEncoder.encode(password))
                .name("Administrator")
                .role(Role.ADMIN)
                .isActive(true)
                .build();
        userRepository.save(admin);

        log.warn("==============================================================");
        log.warn(" No admin account existed — created one for first login:");
        log.warn("   email:    {}", email);
        log.warn("   password: {}", password);
        log.warn(" Log in and change this password immediately.");
        log.warn(" Override with ADMIN_EMAIL / ADMIN_PASSWORD env vars next time.");
        log.warn("==============================================================");
    }

}