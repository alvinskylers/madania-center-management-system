@import com.madania.management.entity.JournalComment
@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapyJournal
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyJournal journal
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null
@param List<JournalComment> comments

@template.layout.base(
title = "Journal Detail",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5 jdoc-no-print">
        <h1 class="page-heading">Therapy Journal</h1>
        <div class="d-flex gap-3">
            <a href="/therapist/journal/${String.valueOf(journal.getId())}/edit" class="btn btn-primary">
                Edit Journal
            </a>
            <a href="/therapist/journals" class="btn btn-light">Back</a>
        </div>
    </div>

    @template.components.journal-document(journal = journal)

    <div class="card mt-5 jdoc-no-print" style="max-width: 900px; margin: 0 auto;">
        <div class="card-body">
            <h5 class="fw-bold mb-5">Parent Responses</h5>

            @if(comments != null && !comments.isEmpty())
                @for(JournalComment comment : comments)
                    <div class="d-flex flex-column mb-4 p-3 bg-light rounded">
                        <div class="fs-7 text-gray-800">${comment.getContent()}</div>
                        <div class="fs-8 text-muted mt-1">${comment.getTimeAgo()}</div>
                    </div>
                @endfor
            @else
                <p class="text-muted">No responses from the parent yet.</p>
            @endif
        </div>
    </div>
`
)