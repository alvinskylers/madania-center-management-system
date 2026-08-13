package com.madania.management.service;

import com.madania.management.entity.Therapist;
import com.madania.management.entity.User;
import com.madania.management.enums.Role;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TherapistService {

    private final TherapistRepository therapistRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public List<Therapist> getAllTherapists() {
        return therapistRepository.findAll();
    }

    @Transactional
    public User createTherapist(String email, String password,
                                String fullName, String specialization, String phone) {

        User user = User.builder()
                .name(fullName)
                .email(email)
                .password(passwordEncoder.encode(password))
                .role(Role.THERAPIST)
                .isActive(true)
                .build();
        user = userRepository.save(user);

        Therapist therapist = Therapist.builder()
                .user(user)
                .fullName(fullName)
                .specialization(specialization)
                .phone(phone)
                .build();

        therapistRepository.save(therapist);

        return user;
    }

    @Transactional
    public void updateTherapist(UUID therapistId, String email, String fullName,
                                String specialization, String phone) {
        Therapist therapist = getTherapistById(therapistId);
        User therapistUser = getUserByTherapistId(therapistId);

        if (!therapistUser.getEmail().equals(email) && userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already in use: " + email);
        }

        therapistUser.setName(fullName);
        therapistUser.setEmail(email);
        userRepository.save(therapist.getUser());

        therapist.setFullName(fullName);
        therapist.setSpecialization(specialization);
        therapist.setPhone(phone);
        therapistRepository.save(therapist);
    }

    @Transactional
    public void deleteTherapist(UUID id) {
        Therapist therapist = getTherapistById(id);
        User therapistUser = getUserByTherapistId(id);

        if (therapist.getUser().isActive()) {
           throw new RuntimeException("user is still active, please disable this user first");
        }

        therapistRepository.delete(therapist);
        userRepository.delete(therapistUser);
    }

    @Transactional
    public void updateProfile(UUID userId, String fullName, String email,
                              String phone, String specialization) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!user.getEmail().equals(email) && userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already in use");
        }

        user.setName(fullName);
        user.setEmail(email);
        userRepository.save(user);

        Therapist therapist = therapistRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Therapist profile not found"));

        therapist.setFullName(fullName);
        therapist.setPhone(phone);
        therapist.setSpecialization(specialization);
        therapistRepository.save(therapist);
    }

    public Therapist getTherapistById(UUID id) {
        return therapistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Therapist profile not found for user id: " + id));
    }

    public Therapist getTherapistByUserId(UUID id) {
        return therapistRepository.findByUserId(id)
                .orElseThrow(() -> new RuntimeException("Therapist profile not found for user id: " + id));
    }

    public User getUserByTherapistId(UUID id) {
        return getTherapistById(id).getUser();
    }

}
