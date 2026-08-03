package com.madania.management.service;

import com.madania.management.entity.Parent;
import com.madania.management.entity.Therapist;
import com.madania.management.entity.User;
import com.madania.management.enums.Role;
import com.madania.management.repository.ParentRepository;
import com.madania.management.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ParentService {

    private final ParentRepository parentRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public List<Parent> getAllParent() {
        return parentRepository.findAll();
    }
    @Transactional
    public User createParent(String name, String email, String password,
                             String phone, String address) {

        User user = User.builder()
                .name(name)
                .email(email)
                .password(passwordEncoder.encode(password))
                .role(Role.PARENT)
                .isActive(true)
                .build();

        user = userRepository.save(user);

        Parent parent = Parent.builder()
                .user(user)
                .fullName(name)
                .address(address)
                .phone(phone)
                .build();

        parentRepository.save(parent);

        return user;
    }

    @Transactional
    public void updateParent(UUID userId,String email,
                             String fullName, String phone, String address) {
        Parent parent = getParentById(userId);
        User parentUser = getUserByParentId(userId);

        if (!parentUser.getEmail().equals(email) && userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already in use: " + email);
        }
        parentUser.setName(fullName);
        parentUser.setEmail(email);
        userRepository.save(parentUser);

        parent.setFullName(fullName);
        parent.setPhone(phone);
        parent.setAddress(address);
        parentRepository.save(parent);
    }

    @Transactional
    public void deleteParent(UUID id) {
        Parent parent = getParentById(id);
        User parentUser = getUserByParentId(id);

        if (parentUser.isActive()) {
            throw new RuntimeException("user is still active, please disable this user first");
        }

        parentRepository.delete(parent);
        userRepository.delete(parentUser);
    }

    public Parent getParentById(UUID id) {
        return parentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Parent profile not found for user id: " + id));
    }

    public User getUserByParentId(UUID id) {
        return getParentById(id).getUser();
    }
}
