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
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">${journal.getTitle()}</h1>
        <div class="d-flex gap-3">
            <a href="/therapist/journal/${String.valueOf(journal.getId())}/edit" class="btn btn-primary">
                Edit Journal
            </a>
            <a href="/therapist/journals" class="btn btn-light">Back</a>
        </div>
    </div>

    <div class="card mb-5">
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Patient:</strong> ${journal.getPatient().getFullName()}</p>
                    <p><strong>Therapy Type:</strong> ${journal.getTherapyType().name()}</p>
                    <p><strong>Date:</strong> ${journal.getCreatedAt().toLocalDate().toString()}</p>
                </div>
                <div class="col-md-6">
                    <p><strong>Session:</strong> ${journal.getSession().getSessionNumber()} of ${journal.getSession().getTherapyPackage().getTotalSessions()}</p>
                    <p><strong>Session Date:</strong> ${journal.getSession().getStartTime().toLocalDate().toString()}</p>
                    @if(journal.getMood() != null)
                        <p><strong>Child's Mood:</strong> ${journal.getMood().name()}</p>
                    @endif
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-5">
        <div class="card-body">

            <div class="mb-7">
                <h5 class="fw-bold mb-3">Session Goals</h5>
                <p>${journal.getSessionGoals()}</p>
            </div>

            <div class="separator mb-7"></div>

            <div class="mb-7">
                <h5 class="fw-bold mb-3">Session Notes</h5>
                <p>${journal.getContent()}</p>
            </div>

            <div class="separator mb-7"></div>

            <div class="mb-7">
                <h5 class="fw-bold mb-3">Progress Notes</h5>
                <p>${journal.getProgressNotes()}</p>
            </div>

            @if(journal.getGoalsAchieved() != null)
                <div class="separator mb-7"></div>
                <div class="mb-7">
                    <h5 class="fw-bold mb-3">Goals Achieved</h5>
                    <p>${journal.getGoalsAchieved()}</p>
                </div>
            @endif

            @if(journal.getParentRecommendations() != null)
                <div class="separator mb-7"></div>
                <div class="mb-7">
                    <h5 class="fw-bold mb-3">Recommendations for Parents</h5>
                    <p>${journal.getParentRecommendations()}</p>
                </div>
            @endif

            @if(journal.getDocumentationUrl() != null)
                <div class="separator mb-7"></div>
                <div class="mb-7">
                    <h5 class="fw-bold mb-3">Documentation</h5>
                    <a href="${journal.getDocumentationUrl()}" target="_blank" class="btn btn-light-primary">
                        View Files
                    </a>
                </div>
            @endif

        </div>
    </div>

    <div class="card">
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