package com.madania.management.config.seeder;

import com.madania.management.entity.Parent;
import com.madania.management.entity.Patient;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.User;
import com.madania.management.enums.Gender;
import com.madania.management.enums.Role;
import com.madania.management.repository.ParentRepository;
import com.madania.management.repository.PatientRepository;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.UserRepository;
import com.madania.management.service.TherapyPackageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner{

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final TherapistRepository therapistRepository;
    private final ParentRepository parentRepository;
    private final PatientRepository patientRepository;
    private final TherapyPackageService packageService;

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
        boolean patientExists = patientRepository.count() > 0;

        if (!patientExists) {
            Patient patient1 = Patient.builder()
                    .parent(parent)
                    .fullName("Adam Rahman")
                    .dateOfBirth(LocalDate.of(2018, 5, 15))
                    .gender(Gender.MALE)
                    .diagnosis("Autism Spectrum Disorder")
                    .notes("Has difficulty with social interactions and repetitive behaviors")
                    .isActive(true)
                    .build();

            Patient patient2 = Patient.builder()
                    .parent(parent)
                    .fullName("Sara Rahman")
                    .dateOfBirth(LocalDate.of(2019, 3, 22))
                    .gender(Gender.FEMALE)
                    .diagnosis("Speech Delay")
                    .notes("Limited vocabulary for age group, responds well to visual cues")
                    .isActive(true)
                    .build();

            Patient patient3 = Patient.builder()
                    .parent(parent)
                    .fullName("Yusuf Rahman")
                    .dateOfBirth(LocalDate.of(2020, 8, 10))
                    .gender(Gender.MALE)
                    .diagnosis("ADHD")
                    .notes("High energy, difficulty maintaining focus for more than 5 minutes")
                    .isActive(true)
                    .build();

            patientRepository.saveAll(List.of(patient1, patient2, patient3));
        }

        seedPackages(admin.getId());


        log.warn("==============================================================");
        log.warn(" No admin account existed — created one for first login:");
        log.warn("   email:    {}", email);
        log.warn("   password: {}", password);
        log.warn(" Log in and change this password immediately.");
        log.warn(" Override with ADMIN_EMAIL / ADMIN_PASSWORD env vars next time.");
        log.warn("==============================================================");
    }

    private void seedPackages(java.util.UUID createdByUserId) {
        List<Therapist> therapists = therapistRepository.findAll();
        List<Patient> patients = patientRepository.findAll();

        if (therapists.isEmpty() || patients.isEmpty()) {
            log.warn("Skipping package seeding: no therapist or patient records found.");
            return;
        }

        Therapist therapist = therapists.get(0);
        LocalDate nextMonday = LocalDate.now().with(DayOfWeek.MONDAY).isBefore(LocalDate.now())
                ? LocalDate.now().plusWeeks(1).with(DayOfWeek.MONDAY)
                : LocalDate.now().with(DayOfWeek.MONDAY);

        try {
            if (patients.size() > 0) {
                packageService.createPackage(
                        patients.get(0).getId(), therapist.getId(), createdByUserId,
                        nextMonday, LocalTime.of(9, 0),
                        List.of(DayOfWeek.MONDAY, DayOfWeek.WEDNESDAY, DayOfWeek.FRIDAY),
                        "Seeded package for UI testing"
                );
            }
            if (patients.size() > 1) {
                packageService.createPackage(
                        patients.get(1).getId(), therapist.getId(), createdByUserId,
                        nextMonday, LocalTime.of(11, 0),
                        List.of(DayOfWeek.MONDAY, DayOfWeek.WEDNESDAY, DayOfWeek.FRIDAY),
                        "Seeded package for UI testing"
                );
            }
            if (patients.size() > 2) {
                packageService.createPackage(
                        patients.get(2).getId(), therapist.getId(), createdByUserId,
                        nextMonday, LocalTime.of(10, 0),
                        List.of(DayOfWeek.TUESDAY, DayOfWeek.THURSDAY, DayOfWeek.SATURDAY),
                        "Seeded package for UI testing"
                );
            }
            log.warn("Seeded {} therapy package(s) for UI testing.", Math.min(patients.size(), 3));
        } catch (RuntimeException e) {
            log.warn("Package seeding skipped/partial due to: {}", e.getMessage());
        }
    }
}