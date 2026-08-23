@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapyJournal
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyJournal journal
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
        <a href="/admin/journals" class="btn btn-light">Back</a>
    </div>

    <div class="card mb-5">
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Patient:</strong> ${journal.getPatient().getFullName()}</p>
                    <p><strong>Therapist:</strong> ${journal.getTherapist().getFullName()}</p>
                    <p><strong>Therapy Type:</strong> ${journal.getTherapyType().name()}</p>
                </div>
                <div class="col-md-6">
                    <p><strong>Session:</strong> ${journal.getSession().getSessionNumber()} of ${journal.getSession().getTherapyPackage().getTotalSessions()}</p>
                    <p><strong>Session Date:</strong> ${journal.getSession().getStartTime().toLocalDate().toString()}</p>
                    <p><strong>Date Written:</strong> ${journal.getCreatedAt().toLocalDate().toString()}</p>
                    @if(journal.getMood() != null)
                        <p><strong>Child's Mood:</strong> ${journal.getMood().name()}</p>
                    @endif
                </div>
            </div>
        </div>
    </div>

    <div class="card">
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
                    <a href="${journal.getDocumentationUrl()}" target="_blank"
                       class="btn btn-light-primary">
                        View Files
                    </a>
                </div>
            @endif

        </div>
    </div>
`
)