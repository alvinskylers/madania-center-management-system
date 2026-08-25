@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapyJournal
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<TherapyJournal> journals
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null
@param String journalError = null

@template.layout.base(
title = "Journals",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Progress Journals</h1>
        @if(journalError != null)
            <div class="alert alert-danger"><p>${journalError}</p></div>
        @endif
    </div>

    <div class="card">
        <div class="card-body">
            <table class="table table-row-dashed">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Child</th>
                    <th>Therapy Type</th>
                    <th>Date</th>
                    <th>Mood</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                @for(TherapyJournal journal : journals)
                    <tr>
                        <td>${journal.getTitle()}</td>
                        <td>${journal.getPatient().getFullName()}</td>
                        <td>${journal.getTherapyType().name()}</td>
                        <td>${journal.getCreatedAt().toLocalDate().toString()}</td>
                        <td>
                            @if(journal.getMood() != null)
                                ${journal.getMood().name()}
                            @else
                                -
                            @endif
                        </td>
                        <td>
                            <a href="/parent/journal/${String.valueOf(journal.getId())}"
                               class="btn btn-sm btn-light-primary">
                                View
                            </a>
                        </td>
                    </tr>
                @endfor
                </tbody>
            </table>
        </div>
    </div>
`
)