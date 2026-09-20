package com.madania.management.config;

import com.madania.management.service.RescheduleNoticePolicy;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Clock;
import java.time.ZoneId;

@Configuration
public class SchedulingRulesConfig {

    /**
     * Single source of "now" for scheduling rules. Uses the JVM default zone unless
     * {@code app.timezone} (e.g. {@code Asia/Makassar}) is set, so behaviour is unchanged
     * by default but the clinic's timezone can be pinned when the server runs elsewhere.
     */
    @Bean
    public Clock clock(@Value("${app.timezone:}") String timezone) {
        if (timezone == null || timezone.isBlank()) {
            return Clock.systemDefaultZone();
        }
        return Clock.system(ZoneId.of(timezone.trim()));
    }

    @Bean
    public RescheduleNoticePolicy rescheduleNoticePolicy(Clock clock,
                                                         @Value("${app.reschedule.min-notice-days:3}") int minNoticeDays) {
        return new RescheduleNoticePolicy(clock, minNoticeDays);
    }
}
