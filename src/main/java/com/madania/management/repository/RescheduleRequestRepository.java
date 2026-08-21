package com.madania.management.repository;

import com.madania.management.entity.RescheduleRequest;
import com.madania.management.enums.RescheduleStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface RescheduleRequestRepository extends JpaRepository<RescheduleRequest, UUID> {

    List<RescheduleRequest> findByStatus(RescheduleStatus status);
    List<RescheduleRequest> findBySessionId(UUID sessionId);
    List<RescheduleRequest> findByRequestedById(UUID userId);
}
