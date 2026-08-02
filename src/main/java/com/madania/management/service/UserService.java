package com.madania.management.service;

import com.madania.management.entity.Parent;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.User;
import com.madania.management.enums.Role;
import com.madania.management.repository.ParentRepository;
import com.madania.management.repository.TherapistRepository;
import com.madania.management.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.vote.RoleVoter;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final TherapistRepository therapistRepository;
    private final ParentRepository parentRepository;
    private final PasswordEncoder passwordEncoder;


    public List<User> getAllUsers () {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow( () ->new RuntimeException("User not found with id: " + id));
    }

    @Transactional
    public User createAdmin(String username, String email, String password) {
        validateUniqueness(username, email);

        User user = User.builder()
                .username(username)
                .email(email)
                .password(passwordEncoder.encode(password))
                .role(Role.ADMIN)
                .isActive(true)
                .build();

        return userRepository.save(user);
    }


    @Transactional
    public User createTherapist(String email, String password,
                                String fullName, String specialization, String phone) {

        User user = User.builder()
                .username(fullName)
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
    public User createParent(String username, String email, String password,
                             String phone, String address) {
        validateUniqueness(username, email);

        User user = User.builder()
                .username(username)
                .email(email)
                .password(passwordEncoder.encode(password))
                .role(Role.PARENT)
                .isActive(true)
                .build();

        user = userRepository.save(user);

        Parent parent = Parent.builder()
                .user(user)
                .fullName(username)
                .address(address)
                .phone(phone)
                .build();

        parentRepository.save(parent);

        return user;
    }

    @Transactional
    public User updateUser(Long id, String username, String email) {
        User user = getUserById(id);

        if (!user.getUsername().equals(username) && userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username already in use: " + username);
        }
        if (!user.getEmail().equals(email) && userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already in use: " + email);
        }

        user.setUsername(username);
        user.setEmail(email);
        return userRepository.save(user);
    }

    @Transactional
    public void deleteUser(Long id) {
        User user = getUserById(id);
        userRepository.delete(user);
    }

    @Transactional
    public void deactivateUser(Long id) {
        User user = getUserById(id);
        user.setActive(false);
        userRepository.save(user);
    }

    @Transactional
    public void activateUser(Long id) {
        User user = getUserById(id);
        user.setActive(true);
        userRepository.save(user);
    }

    @Transactional
    public void resetPassword(Long id, String password) {
        User user = getUserById(id);
        user.setPassword(passwordEncoder.encode(password));
        userRepository.save(user);
    }

    private void validateUniqueness(String username, String email) {
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username already in use: " + username);
        }

        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already in use: " + email);
        }
    }

    public boolean emailExists(String email) {
        return userRepository.existsByEmail(email);
    }
}
