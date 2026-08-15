@import com.madania.management.entity.TherapyJournal

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyJournal journal

@template.layout.base(
title = "Journal Detail",
role = role,
_csrf = _csrf,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">${journal.getTitle()}</h1>
        <a href="/parent/journals" class="btn btn-light">Back</a>
    </div>

    <div class="card">
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
`
)