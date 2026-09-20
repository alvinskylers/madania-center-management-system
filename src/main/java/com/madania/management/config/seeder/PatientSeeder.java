package com.madania.management.config.seeder;

import com.madania.management.entity.Parent;
import com.madania.management.entity.User;
import com.madania.management.enums.Gender;
import com.madania.management.repository.UserRepository;
import com.madania.management.service.ParentService;
import com.madania.management.service.PatientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

/**
 * Seeds 6 demo patients under the 4 demo parents from ParentSeeder. Budi
 * Santoso and Siti Rahayu each have two children; Ahmad Fauzi and Dewi
 * Lestari have one each. Diagnoses are split across the clinic's three
 * specialties (ADHD, Speech Delay, Autism Spectrum Disorder) so
 * TherapyPackageSeeder can assign each patient to the matching therapist.
 */
@Component
@Order(4)
@RequiredArgsConstructor
@Slf4j
public class PatientSeeder implements CommandLineRunner {

    private final PatientService patientService;
    private final ParentService parentService;
    private final UserRepository userRepository;

    @Override
    public void run(String... args) {
        if (patientService.getAllPatients().stream().anyMatch(p -> p.getFullName().equals("Kevin Santoso"))) {
            return;
        }

        Parent budi = parentOf("budi.santoso@gmail.com");
        Parent siti = parentOf("siti.rahayu@gmail.com");
        Parent ahmad = parentOf("ahmad.fauzi@gmail.com");
        Parent dewi = parentOf("dewi.lestari@gmail.com");

        patientService.createPatient(budi.getId(), "Kevin Santoso",
                LocalDate.now().minusYears(6).minusMonths(2), Gender.MALE,
                "ADHD - tipe kombinasi (inatentif dan hiperaktif-impulsif)",
                "Mudah teralihkan perhatiannya, cenderung aktif bergerak di kelas.");

        patientService.createPatient(budi.getId(), "Clara Santoso",
                LocalDate.now().minusYears(4).minusMonths(5), Gender.FEMALE,
                "Speech Delay - keterlambatan bicara ekspresif",
                "Kosakata masih terbatas untuk anak seusianya.");

        patientService.createPatient(siti.getId(), "Dimas Rahayu",
                LocalDate.now().minusYears(7).minusMonths(1), Gender.MALE,
                "Autism Spectrum Disorder - level 1 (membutuhkan dukungan)",
                "Kesulitan dalam interaksi sosial dan komunikasi dua arah.");

        patientService.createPatient(siti.getId(), "Putri Rahayu",
                LocalDate.now().minusYears(5).minusMonths(8), Gender.FEMALE,
                "ADHD - tipe inatentif dominan",
                "Sering melamun, sulit mempertahankan fokus saat mengerjakan tugas.");

        patientService.createPatient(ahmad.getId(), "Fajar Fauzi",
                LocalDate.now().minusYears(4).minusMonths(9), Gender.MALE,
                "Speech Delay - keterlambatan bicara reseptif dan ekspresif",
                "Baru mampu mengucapkan beberapa kata sederhana.");

        patientService.createPatient(dewi.getId(), "Nayla Lestari",
                LocalDate.now().minusYears(8), Gender.FEMALE,
                "Autism Spectrum Disorder - level 2 (membutuhkan dukungan substansial)",
                "Menunjukkan perilaku repetitif dan sensitivitas sensorik.");

        log.info("Seeded 6 demo patients.");
    }

    private Parent parentOf(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException(
                        "Seeder error: expected parent user " + email + " to already exist. " +
                                "Did ParentSeeder run first?"));
        return parentService.getParentByUserId(user.getId());
    }
}
