package com.madania.management.config.seeder;

import com.madania.management.entity.Parent;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.User;
import com.madania.management.enums.Role;
import com.madania.management.repository.ParentRepository;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner{

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final TherapistRepository therapistRepository;
    private final ParentRepository parentRepository;

    @Override
    public void run(String... args) throws Exception {

        boolean adminExists = userRepository.findAll().stream()
                .anyMatch(u -> u.getRole() == Role.ADMIN);
        boolean therapistExists = userRepository.findAll().stream()
                .anyMatch(u -> u.getRole() == Role.THERAPIST);
        boolean parentExists = userRepository.findAll().stream()
                .anyMatch(u -> u.getRole() == Role.PARENT);

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


        if (!therapistExists) {
            User therapistUser  = User.builder()
                    .email("therapist@mail.com")
                    .password(passwordEncoder.encode("password"))
                    .name("Therapist")
                    .role(Role.THERAPIST)
                    .isActive(true)
                    .build();

            Therapist therapist = Therapist.builder()
                    .user(therapistUser)
                    .fullName(therapistUser.getName())
                    .build();

            userRepository.save(therapistUser);
            therapistRepository.save(therapist);
        }

        if (!parentExists) {
            User parentUser  = User.builder()
                    .email("parent@mail.com")
                    .password(passwordEncoder.encode(password))
                    .name("Parent")
                    .role(Role.PARENT)
                    .isActive(true)
                    .build();

            Parent parent = Parent.builder()
                    .user(parentUser)
                    .fullName(parentUser.getName())
                    .build();

            userRepository.save(parentUser);
            parentRepository.save(parent);
        }

        log.warn("==============================================================");
        log.warn(" No admin account existed — created one for first login:");
        log.warn("   email:    {}", email);
        log.warn("   password: {}", password);
        log.warn(" Log in and change this password immediately.");
        log.warn(" Override with ADMIN_EMAIL / ADMIN_PASSWORD env vars next time.");
        log.warn("==============================================================");
    }
}
