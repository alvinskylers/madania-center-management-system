package com.madania.management.config;

import com.madania.management.config.security.CustomUserDetails;
import com.madania.management.entity.Notification;
import com.madania.management.service.NotificationService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.Collections;
import java.util.List;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalModelAttribute {

    private final NotificationService notificationService;

    @ModelAttribute("_csrf")
    public CsrfToken csrfToken(HttpServletRequest request) {
        return (CsrfToken) request.getAttribute(CsrfToken.class.getName());
    }

    @ModelAttribute("role")
    public String role(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails userDetails) {
            return userDetails.getUser().getRole().name();
        }
        return null;
    }

    @ModelAttribute("unreadNotificationCount")
    public long unreadNotificationCount(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails userDetails) {
            return notificationService.getUnreadCount(userDetails.getUser().getId());
        }
        return 0;
    }

    @ModelAttribute("recentNotifications")
    public List<Notification> recentNotifications(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails userDetails) {
            List<Notification> all = notificationService.getNotificationsForUser(userDetails.getUser().getId());
            return all.size() > 5 ? all.subList(0, 5) : all;
        }
        return Collections.emptyList();
    }

}