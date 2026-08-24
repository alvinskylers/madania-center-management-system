@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapyJournal
@import com.madania.management.entity.JournalComment
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyJournal journal
@param List<JournalComment> comments
@param String commentError = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Journal Detail",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">${journal.getTitle()}</h1>
        <a href="/parent/journals" class="btn btn-light">Back</a>
    </div>

    <div class="card mb-5">
        <div class="card-body">
            <div class="row mb-5">
                <div class="col-md-4">
                    <p><strong>Child:</strong> ${journal.getPatient().getFullName()}</p>
                    <p><strong>Therapy Type:</strong> ${journal.getTherapyType().name()}</p>
                    <p><strong>Date:</strong> ${journal.getCreatedAt().toLocalDate().toString()}</p>
                    @if(journal.getMood() != null)
                        <p><strong>Mood:</strong> ${journal.getMood().name()}</p>
                    @endif
                </div>
            </div>

            <div class="separator mb-5"></div>

            <div class="mb-7">
                <h5>Progress Notes</h5>
                <p>${journal.getProgressNotes()}</p>
            </div>

            @if(journal.getGoalsAchieved() != null)
                <div class="mb-7">
                    <h5>Goals Achieved</h5>
                    <p>${journal.getGoalsAchieved()}</p>
                </div>
            @endif

            @if(journal.getParentRecommendations() != null)
                <div class="mb-7">
                    <h5>Recommendations for You</h5>
                    <p>${journal.getParentRecommendations()}</p>
                </div>
            @endif

            @if(journal.getDocumentationUrl() != null)
                <div class="mb-7">
                    <h5>Session Documentation</h5>
                    <a href="${journal.getDocumentationUrl()}" target="_blank" class="btn btn-light-primary">
                        View Files
                    </a>
                </div>
            @endif
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <h5 class="mb-5">Your Responses</h5>

            @if(commentError != null)
                <div class="alert alert-danger"><p>${commentError}</p></div>
            @endif

            @if(comments != null && !comments.isEmpty())
                @for(JournalComment comment : comments)
                    <div class="d-flex flex-column mb-4 p-3 bg-light rounded">
                        <div class="fs-7 text-gray-800">${comment.getContent()}</div>
                        <div class="fs-8 text-muted mt-1">${comment.getTimeAgo()}</div>
                    </div>
                @endfor
            @else
                <p class="text-muted">No responses yet. Share your thoughts with the therapist below.</p>
            @endif

            <form action="/parent/journal/${String.valueOf(journal.getId())}/comment" method="post" class="mt-5">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <div class="fv-row mb-3">
                    <textarea class="form-control" name="content" rows="3" placeholder="Write a response to this journal entry..." required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Send Response</button>
            </form>
        </div>
    </div>
`
)