@import com.madania.management.dto.JournalRequest
@import com.madania.management.entity.TherapySession
@import com.madania.management.enums.TherapyType
@import com.madania.management.enums.MoodRating
@import org.springframework.validation.BindingResult

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param JournalRequest request
@param TherapySession session
@param TherapyType[] therapyTypes
@param MoodRating[] moodRatings
@param BindingResult bindingResult = null

@template.layout.base(
title = "Write Journal",
role = role,
_csrf = _csrf,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Write Journal</h1>
    </div>

    <div class="card mb-5">
        <div class="card-body">
            <p><strong>Patient:</strong> ${session.getPatient().getFullName()}</p>
            <p><strong>Session:</strong> ${session.getSessionNumber()} of ${session.getTherapyPackage().getTotalSessions()}</p>
            <p><strong>Date:</strong> ${session.getStartTime().toLocalDate().toString()}</p>
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
            <form action="/therapist/journal/create/${String.valueOf(session.getId())}" method="post">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                <div class="mb-5">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control" required>
                </div>

                <div class="mb-5">
                    <label class="form-label">Therapy Type</label>
                    <select name="therapyType" class="form-select" required>
                        <option value="">Select type</option>
                        @for(TherapyType type : therapyTypes)
                            <option value="${type.name()}">${type.name()}</option>
                        @endfor
                    </select>
                </div>

                <div class="mb-5">
                    <label class="form-label">Session Goals</label>
                    <textarea name="sessionGoals" class="form-control" rows="3" required></textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Session Notes</label>
                    <textarea name="content" class="form-control" rows="5" required></textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Progress Notes</label>
                    <textarea name="progressNotes" class="form-control" rows="3" required></textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Goals Achieved</label>
                    <textarea name="goalsAchieved" class="form-control" rows="3"></textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Recommendations for Parents</label>
                    <textarea name="parentRecommendations" class="form-control" rows="3"></textarea>
                </div>

                <div class="mb-5">
                    <label class="form-label">Child's Mood</label>
                    <select name="moodRating" class="form-select">
                        <option value="">Select mood</option>
                        @for(MoodRating mood : moodRatings)
                            <option value="${mood.name()}">${mood.name()}</option>
                        @endfor
                    </select>
                </div>

                <div class="mb-5">
                    <label class="form-label">Documentation URL</label>
                    <input type="url" name="documentationUrl" class="form-control"
                           placeholder="Google Drive folder link (optional)">
                </div>

                <button type="submit" class="btn btn-primary">Save Journal</button>
                <a href="/therapist/sessions" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </div>
`
)