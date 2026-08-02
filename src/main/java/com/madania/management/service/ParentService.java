package com.madania.management.service;

import com.madania.management.entity.Parent;
import com.madania.management.repository.ParentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ParentService {

    private final ParentRepository parentRepository;

    public List<Parent> getAllParent() {
        return parentRepository.findAll();
    }
}
