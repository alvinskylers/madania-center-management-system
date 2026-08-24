package com.madania.management.repository;

import com.madania.management.entity.LeaveRequest;
import com.madania.management.enums.LeaveStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, UUID> {
    List<LeaveRequest> findByTherapistId(UUID therapistId);
    List<LeaveRequest> findByStatus(LeaveStatus status);
    List<LeaveRequest> findAllByOrderByCreatedAtDesc();
}