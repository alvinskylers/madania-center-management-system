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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

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

    public Page<User> getAll(int page, int size, String direction) {
        Sort sort = Sort.by(Sort.Direction.fromString(direction), "createdAt");
        Pageable pageable = PageRequest.of(page, size, sort);
        return userRepository.findAll(pageable);
    }

    public Page<User> getAllQueried(String query, int page, int size, String direction) {
        Sort sort = Sort.by(Sort.Direction.fromString(direction), "createdAt");
        Pageable pageable = PageRequest.of(page, size, sort);
        return userRepository.searchUsersByQuery(pageable, query);
    }

    public User getUserById(UUID id) {
        return userRepository.findById(id)
                .orElseThrow( () ->new RuntimeException("User not found with id: " + id));
    }

    @Transactional
    public User createAdmin(String name, String email, String password) {
        validateUniqueness(email);

        User user = User.builder()
                .name(name)
                .email(email)
                .password(passwordEncoder.encode(password))
                .role(Role.ADMIN)
                .isActive(true)
                .build();

        return userRepository.save(user);
    }

    @Transactional
    public User updateUser(UUID id, String name, String email) {
        User user = getUserById(id);

        if (!user.getEmail().equals(email) && userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already in use: " + email);
        }

        user.setEmail(name);
        user.setEmail(email);
        return userRepository.save(user);
    }

    @Transactional
    public void deleteUser(UUID id) {
        User user = getUserById(id);
        userRepository.delete(user);
    }

    @Transactional
    public void deactivateUser(UUID id) {
        User user = getUserById(id);
        user.setActive(false);
        userRepository.save(user);
    }

    @Transactional
    public void activateUser(UUID id) {
        User user = getUserById(id);
        user.setActive(true);
        userRepository.save(user);
    }

    @Transactional
    public void resetPassword(UUID id, String password) {
        User user = getUserById(id);
        user.setPassword(passwordEncoder.encode(password));
        userRepository.save(user);
    }

    private void validateUniqueness(String email) {
        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already in use: " + email);
        }
    }

    public boolean emailExists(String email) {
        return userRepository.existsByEmail(email);
    }
}
