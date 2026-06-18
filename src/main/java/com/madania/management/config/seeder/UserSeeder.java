package com.madania.management.config.seeder;

import com.madania.management.entity.User;
import com.madania.management.enums.Role;
import com.madania.management.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@RequiredArgsConstructor
public class UserSeeder {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Bean
    public CommandLineRunner GenerateUsers(){
        return  args -> {
            if (!userRepository.existsByEmail("admin@madania.com")) {
                User admin = User.builder()
                        .username("Admin")
                        .email("admin@madania.com")
                        .password(passwordEncoder.encode("password"))
                        .role(Role.ADMIN)
                        .isActive(true)
                        .build();
                userRepository.save(admin);
                System.out.println("ADMIN USER INITIALIZED... \n");
            }
            if (!userRepository.existsByEmail("therapist@mail.com")) {
                User admin = User.builder()
                        .username("therapist")
                        .email("therapist@mail.com")
                        .password(passwordEncoder.encode("password"))
                        .role(Role.THERAPIST)
                        .isActive(true)
                        .build();
                userRepository.save(admin);
                System.out.println("THERAPIST USER INITIALIZED... \n");
            }
            if (!userRepository.existsByEmail("parent@mail.com")) {
                User admin = User.builder()
                        .username("Parent")
                        .email("parent@mail.com")
                        .password(passwordEncoder.encode("password"))
                        .role(Role.PARENT)
                        .isActive(true)
                        .build();
                userRepository.save(admin);
                System.out.println("PARENT USER INITIALIZED... \n");
            }
        };
    }
}
