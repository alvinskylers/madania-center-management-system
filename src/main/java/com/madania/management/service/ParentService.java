package com.madania.management.service;

import com.madania.management.entity.Parent;
import com.madania.management.entity.User;
import com.madania.management.enums.Role;
import com.madania.management.repository.ParentRepository;
import com.madania.management.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

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

}
