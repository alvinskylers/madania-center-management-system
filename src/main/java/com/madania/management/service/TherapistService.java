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

}
