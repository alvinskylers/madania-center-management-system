@import com.madania.management.entity.TherapySession
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<TherapySession> sessions

@template.layout.base(
title = "My Sessions",
role = role,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Completed Sessions</h1>
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
                    <th>Journal</th>
                </tr>
                </thead>
                <tbody>
                @if(sessions != null && !sessions.isEmpty())
                    @for(TherapySession session : sessions)
                        <tr>
                            <td>${session.getSessionNumber()}</td>
                            <td>${session.getPatient().getFullName()}</td>
                            <td>${session.getStartTime().toLocalDate().toString()}</td>
                            <td>${session.getStartTime().toLocalTime().toString()}</td>
                            <td>
                                <a href="/therapist/journal/create/${String.valueOf(session.getId())}"
                                   class="btn btn-sm btn-primary">
                                    Write Journal
                                </a>
                            </td>
                        </tr>
                    @endfor
                @else
                   <p> no completed sessions</p>
                @endif
                </tbody>
            </table>
        </div>
    </div>
`
)