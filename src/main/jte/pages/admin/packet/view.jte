@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapyPackage
@import com.madania.management.entity.TherapySession
@import java.util.List


@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyPackage therapyPackage
@param List<TherapySession> sessions
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Package Details",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <h1>Package Details</h1>

    <p><strong>Patient:</strong> ${therapyPackage.getPatient().getFullName()}</p>
    <p><strong>Therapist:</strong> ${therapyPackage.getTherapist().getFullName()}</p>
    <p><strong>Start Date:</strong> ${therapyPackage.getStartDate().toString()}</p>
    <p><strong>End Date:</strong> ${therapyPackage.getEndDate().toString()}</p>
    <p><strong>Progress:</strong> ${therapyPackage.getCompletedSessions()} / ${therapyPackage.getTotalSessions()}</p>
    <p><strong>Status:</strong> ${therapyPackage.getStatus().name()}</p>

    <h3>Sessions</h3>
    <table class="table">
        <thead>
        <tr>
            <th>#</th>
            <th>Date</th>
            <th>Day</th>
            <th>Time</th>
            <th>Status</th>
        </tr>
        </thead>
        <tbody>
        @for(TherapySession session : sessions)
            <tr>
                <td>${session.getSessionNumber()}</td>
                <td>${session.getStartTime().toLocalDate().toString()}</td>
                <td>${session.getDay().toString()}</td>
                <td>${session.getStartTime().toLocalTime().toString()}</td>
                <td>${session.getStatus().name()}</td>
            </tr>
        @endfor
        </tbody>
    </table>
`
)