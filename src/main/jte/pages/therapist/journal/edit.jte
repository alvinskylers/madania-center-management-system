@import com.madania.management.dto.JournalRequest
@import com.madania.management.entity.TherapyJournal
@import com.madania.management.enums.TherapyType
@import com.madania.management.enums.MoodRating
@import org.springframework.validation.BindingResult

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param JournalRequest request
@param TherapyJournal journal
@param TherapyType[] therapyTypes
@param MoodRating[] moodRatings
@param BindingResult bindingResult = null

@template.layout.base(
title = "Edit Journal",
role = role,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Edit Journal</h1>
        <a href="/therapist/journals" class="btn btn-light">Back</a>
    </div>

    <div class="card mb-5">
        <div class="card-body">
            <p><strong>Patient:</strong> ${journal.getPatient().getFullName()}</p>
            <p><strong>Session:</strong> ${journal.getSession().getSessionNumber()} of ${journal.getSession().getTherapyPackage().getTotalSessions()}</p>
            <p><strong>Date:</strong> ${journal.getSession().getStartTime().toLocalDate().toString()}</p>
        </div>
    </div>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    <div class="card">
        <div class="card-body">
            <form action="/therapist/journal/${String.valueOf(journal.getId())}/edit" method="post">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                <div class="mb-5">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control"
                           value="${request.getTitle()}" required>
                </div>

                <div class="mb-5">
                    <label class="form-label">Therapy Type</label>
                    <select name="therapyType" class="form-select" required>
                        @for(TherapyType type : therapyTypes)
                            @if(type == request.getTherapyType())
                                <option value="${type.name()}" selected>${type.name()}</option>
                            @else
                                <option value="${type.name()}">${type.name()}</option>
                            @endif
                        @endfor
                    </select>
                </div>

                <div class="mb-5">
                    <label class="form-label">Session Goals</label>
                    <textarea name="sessionGoals" class="form-control" rows="3" required>${request.getSessionGoals()}</textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Session Notes</label>
                    <textarea name="content" class="form-control" rows="5" required>${request.getContent()}</textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Progress Notes</label>
                    <textarea name="progressNotes" class="form-control" rows="3" required>${request.getProgressNotes()}</textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Goals Achieved</label>
                    <textarea name="goalsAchieved" class="form-control" rows="3">${request.getGoalsAchieved()}</textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Recommendations for Parents</label>
                    <textarea name="parentRecommendations" class="form-control" rows="3">${request.getParentRecommendations()}</textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Child's Mood</label>
                    <select name="moodRating" class="form-select">
                        <option value="">Select mood</option>
                        @for(MoodRating mood : moodRatings)
                            @if(mood == request.getMoodRating())
                                <option value="${mood.name()}" selected>${mood.name()}</option>
                            @else
                                <option value="${mood.name()}">${mood.name()}</option>
                            @endif
                        @endfor
                    </select>
                </div>

                <div class="mb-5">
                    <label class="form-label">Documentation URL</label>
                    <input type="url" name="documentationUrl" class="form-control"
                           value="${request.getDocumentationUrl() != null ? request.getDocumentationUrl() : ""}">
                </div>

                <div class="d-flex gap-3">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a href="/therapist/journals" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
`
)