package com.madania.management.repository;

import com.madania.management.entity.Parent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ParentRepository extends JpaRepository<Parent, Long> {
    Parent findByUserId(Long userId);

}
