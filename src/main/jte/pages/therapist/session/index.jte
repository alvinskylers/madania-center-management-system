@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapySession
@import com.madania.management.enums.SessionStatus
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<TherapySession> sessions
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "My Sessions",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">My Sessions</h1>
    </div>

    <div class="card">
        <div class="card-body">
            <table class="table table-row-dashed">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Patient</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                @for(TherapySession session : sessions)
                    <tr>
                        <td>${session.getSessionNumber()}</td>
                        <td>${session.getPatient().getFullName()}</td>
                        <td>${session.getStartTime().toLocalDate().toString()}</td>
                        <td>${session.getStartTime().toLocalTime().toString()}</td>
                        <td>
                            @if(session.getStatus() == SessionStatus.SCHEDULED)
                                <span class="badge badge-light-primary">Scheduled</span>
                            @elseif(session.getStatus() == SessionStatus.COMPLETED)
                                <span class="badge badge-light-success">Completed</span>
                            @elseif(session.getStatus() == SessionStatus.CANCELLED)
                                <span class="badge badge-light-danger">Cancelled</span>
                            @else
                                <span class="badge badge-light-warning">Rescheduled</span>
                            @endif
                        </td>
                        <td>
                            @if(session.getStatus() == SessionStatus.SCHEDULED)
                                <form action="/therapist/session/${String.valueOf(session.getId())}/complete"
                                      method="post" class="d-inline-block"
                                      onsubmit="return confirm('Mark this session as completed?');">
                                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                                    <button type="submit" class="btn btn-sm btn-light-success">
                                        Mark Complete
                                    </button>
                                </form>
                            @elseif(session.getStatus() == SessionStatus.COMPLETED)
                                <a href="/therapist/journal/create/${String.valueOf(session.getId())}"
                                   class="btn btn-sm btn-primary">
                                    Write Journal
                                </a>
                            @endif
                        </td>
                    </tr>
                @endfor
                </tbody>
            </table>
        </div>
    </div>
`
)