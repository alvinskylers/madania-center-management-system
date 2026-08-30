@import com.madania.management.dto.JournalRequest
@import com.madania.management.entity.User
@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapySession
@import com.madania.management.enums.TherapyType
@import com.madania.management.enums.MoodRating
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param JournalRequest request
@param TherapySession session
@param TherapyType[] therapyTypes
@param MoodRating[] moodRatings
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String selectedTherapyType = request.getTherapyType() != null ? request.getTherapyType().name() : "";}
!{String selectedMood = request.getMoodRating() != null ? request.getMoodRating().name() : "";}
!{String titleValue = request.getTitle() != null ? request.getTitle() : "";}
!{String sessionGoalsValue = request.getSessionGoals() != null ? request.getSessionGoals() : "";}
!{String contentValue = request.getContent() != null ? request.getContent() : "";}
!{String progressNotesValue = request.getProgressNotes() != null ? request.getProgressNotes() : "";}
!{String goalsAchievedValue = request.getGoalsAchieved() != null ? request.getGoalsAchieved() : "";}
!{String parentRecommendationsValue = request.getParentRecommendations() != null ? request.getParentRecommendations() : "";}
!{String documentationUrlValue = request.getDocumentationUrl() != null ? request.getDocumentationUrl() : "";}

@template.layout.base(
title = "Write Journal",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Write Journal</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/therapist/dashboard" class="text-muted text-hover-primary">Home</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/therapist/sessions" class="text-muted text-hover-primary">My Sessions</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Write Journal</li>
                    </ul>
                </div>
                <div class="align-items-center">
                    <a href="/therapist/sessions" class="btn btn-light h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-black-left fs-3"></i>Back to Sessions
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            <!--begin::Session Summary-->
            <div class="card mb-6">
                <div class="card-body py-5">
                    <div class="d-flex flex-wrap align-items-center gap-6">
                        <div class="symbol symbol-50px symbol-circle">
                            <span class="symbol-label bg-light-primary">
                                <i class="ki-outline ki-note-2 fs-2x text-primary"></i>
                            </span>
                        </div>
                        <div class="d-flex flex-column">
                            <span class="fs-7 text-muted">Patient</span>
                            <span class="fs-5 fw-bold text-gray-800">${session.getPatient().getFullName()}</span>
                        </div>
                        <div class="separator separator-dashed d-none d-md-block h-40px"></div>
                        <div class="d-flex flex-column">
                            <span class="fs-7 text-muted">Session</span>
                            <span class="fs-5 fw-bold text-gray-800">${session.getSessionNumber()} of ${session.getTherapyPackage().getTotalSessions()}</span>
                        </div>
                        <div class="separator separator-dashed d-none d-md-block h-40px"></div>
                        <div class="d-flex flex-column">
                            <span class="fs-7 text-muted">Session Date</span>
                            <span class="fs-5 fw-bold text-gray-800">${session.getStartTime().toLocalDate().toString()}</span>
                        </div>
                    </div>
                </div>
            </div>
            <!--end::Session Summary-->

            @if(bindingResult != null && bindingResult.hasErrors())
                <div class="alert alert-danger d-flex flex-column alert-dismissible fade show" role="alert">
                    @for(var fieldError : bindingResult.getAllErrors())
                        <span>${fieldError.getDefaultMessage()}</span>
                    @endfor
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <div class="row g-7">
                <!--begin::Form column-->
                <div class="col-xl-8">
                    <div class="card card-flush">
                        <div class="card-header pt-7">
                            <div class="card-title">
                                <i class="ki-outline ki-document fs-1 text-primary me-2"></i>
                                <h2>Journal Entry</h2>
                            </div>
                        </div>
                        <div class="card-body pt-5">
                            <form id="kt_journal_create_form" class="form" action="/therapist/journal/create/${String.valueOf(session.getId())}" method="post">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                                <!--begin::Title-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Title</span>
                                    </label>
                                    <input type="text" name="title" class="form-control form-control-solid"
                                           placeholder="e.g. Fine Motor Skills Practice" value="${titleValue}" required/>
                                </div>
                                <!--end::Title-->

                                <!--begin::Therapy Type & Mood-->
                                <div class="row row-cols-1 row-cols-sm-2">
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Therapy Type</span>
                                            </label>
                                            <select name="therapyType" class="form-select form-select-solid" required>
                                                <option value="">Select type</option>
                                                @for(TherapyType type : therapyTypes)
                                                    !{String typeLabel = type == TherapyType.OCCUPATIONAL ? "Occupational" : type == TherapyType.BEHAVIOURAL ? "Behavioural" : type == TherapyType.PHYSICAL ? "Physical" : type == TherapyType.SPEECH ? "Speech" : type == TherapyType.ABA ? "ABA" : "Other";}
                                                    @if(selectedTherapyType.equals(type.name()))
                                                        <option value="${type.name()}" selected>${typeLabel}</option>
                                                    @else
                                                        <option value="${type.name()}">${typeLabel}</option>
                                                    @endif
                                                @endfor
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span>Child's Mood</span>
                                                <span class="ms-1" data-bs-toggle="tooltip" title="How the child seemed during this session (optional).">
                                                    <i class="ki-outline ki-information fs-7"></i>
                                                </span>
                                            </label>
                                            <select name="moodRating" class="form-select form-select-solid">
                                                <option value="">Select mood</option>
                                                @for(MoodRating mood : moodRatings)
                                                    !{String moodEmoji = mood == MoodRating.VERY_HAPPY ? "\uD83D\uDE04" : mood == MoodRating.HAPPY ? "\uD83D\uDE42" : mood == MoodRating.NEUTRAL ? "\uD83D\uDE10" : mood == MoodRating.UPSET ? "\uD83D\uDE41" : "\uD83D\uDE22";}
                                                    !{String moodLabel = mood == MoodRating.VERY_HAPPY ? "Very Happy" : mood == MoodRating.HAPPY ? "Happy" : mood == MoodRating.NEUTRAL ? "Neutral" : mood == MoodRating.UPSET ? "Upset" : "Very Upset";}
                                                    @if(selectedMood.equals(mood.name()))
                                                        <option value="${mood.name()}" selected>${moodEmoji} ${moodLabel}</option>
                                                    @else
                                                        <option value="${mood.name()}">${moodEmoji} ${moodLabel}</option>
                                                    @endif
                                                @endfor
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Therapy Type & Mood-->

                                <!--begin::Session Goals-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Session Goals</span>
                                        <span class="ms-1" data-bs-toggle="tooltip" title="What this session aimed to work on.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                    </label>
                                    <textarea name="sessionGoals" class="form-control form-control-solid" rows="3"
                                              placeholder="What did today's session aim to achieve?" required>${sessionGoalsValue}</textarea>
                                </div>
                                <!--end::Session Goals-->

                                <!--begin::Session Notes-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Session Notes</span>
                                        <span class="ms-1" data-bs-toggle="tooltip" title="What actually happened during the session.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                    </label>
                                    <textarea name="content" class="form-control form-control-solid" rows="5"
                                              placeholder="Describe what happened during the session..." required>${contentValue}</textarea>
                                </div>
                                <!--end::Session Notes-->

                                <!--begin::Progress Notes-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Progress Notes</span>
                                        <span class="ms-1" data-bs-toggle="tooltip" title="How the patient is progressing overall.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                    </label>
                                    <textarea name="progressNotes" class="form-control form-control-solid" rows="3"
                                              placeholder="How is the patient progressing?" required>${progressNotesValue}</textarea>
                                </div>
                                <!--end::Progress Notes-->

                                <!--begin::Goals Achieved-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Goals Achieved</span>
                                        <span class="fs-7 fw-normal text-muted ms-2">Optional</span>
                                    </label>
                                    <textarea name="goalsAchieved" class="form-control form-control-solid" rows="3"
                                              placeholder="Any goals reached during this session (optional)">${goalsAchievedValue}</textarea>
                                </div>
                                <!--end::Goals Achieved-->

                                <!--begin::Recommendations-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Recommendations for Parents</span>
                                        <span class="fs-7 fw-normal text-muted ms-2">Optional</span>
                                    </label>
                                    <textarea name="parentRecommendations" class="form-control form-control-solid" rows="3"
                                              placeholder="Suggestions for the parents to support progress at home (optional)">${parentRecommendationsValue}</textarea>
                                </div>
                                <!--end::Recommendations-->

                                <!--begin::Documentation URL-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Documentation URL</span>
                                        <span class="ms-1" data-bs-toggle="tooltip" title="Link to photos, videos, or worksheets from this session (optional).">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                    </label>
                                    <input type="url" name="documentationUrl" class="form-control form-control-solid"
                                           placeholder="https://drive.google.com/..." value="${documentationUrlValue}"/>
                                </div>
                                <!--end::Documentation URL-->

                                <div class="separator mb-6"></div>
                                <div class="d-flex justify-content-end">
                                    <a href="/therapist/sessions" class="btn btn-light me-3">Cancel</a>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="indicator-label">Save Journal</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <!--end::Form column-->

                <!--begin::Info column-->
                <div class="col-xl-4">
                    <div class="card card-flush bg-light-primary">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-4">
                                <i class="ki-outline ki-information-5 fs-1 text-primary me-3"></i>
                                <h3 class="text-gray-900 fs-5 fw-bold m-0">Writing tips</h3>
                            </div>
                            <ul class="text-gray-700 fs-6 ps-4 mb-0" style="list-style: disc;">
                                <li class="mb-3">Be specific about what was practiced and how the patient responded.</li>
                                <li class="mb-3">Note any behavioural changes, big or small, compared to previous sessions.</li>
                                <li class="mb-3">Recommendations for parents should be practical things they can try at home before the next session.</li>
                                <li class="mb-0">This entry becomes visible to the patient's parent, so keep the tone constructive and easy to understand.</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!--end::Info column-->
            </div>

        </div>
    </div>
    <!--end::Content-->
`
)