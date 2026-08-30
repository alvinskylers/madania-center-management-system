@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import com.madania.management.enums.Gender
@import com.madania.management.dto.PackageJournalGroup
@import java.util.List
@import java.util.UUID

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param User user
@param Patient patient
@param List<PackageJournalGroup> packageGroups
@param UUID viewerTherapistId

@template.layout.base(
title = "Child Details",
role = role,
user = user,
_csrf = _csrf,
content = @`
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Patient Details</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/therapist/dashboard" class="text-muted text-hover-primary">Home</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/therapist/patients" class="text-muted text-hover-primary">My Patients</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${patient.getFullName()}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="d-flex flex-column flex-lg-row">
                <div class="flex-column flex-lg-row-auto w-lg-250px w-xl-350px mb-10">
                    <div class="card mb-5 mb-xl-8">
                        <div class="card-body">
                            <div class="d-flex flex-center flex-column py-5">
                                <div class="symbol symbol-100px symbol-circle mb-7">
                                    @if(patient.getGender() == Gender.MALE)
                                        <img src="/media/avatars/boy.png" alt="image" />
                                    @elseif(patient.getGender() == Gender.FEMALE)
                                        <img src="/media/avatars/girl.png" alt="image" />
                                    @else
                                        <img src="/media/avatars/blank.png" alt="image" />
                                    @endif
                                </div>
                                <span class="fs-3 text-gray-800 fw-bold mb-3">${patient.getFullName()}</span>
                            </div>
                            <div class="separator"></div>
                            <div class="pb-5 fs-6">
                                <div class="fw-bold mt-5">Age</div>
                                <div class="text-gray-600">${patient.getAge().getYears() + " years, " + patient.getAge().getMonths() + " months old"}</div>
                                <div class="fw-bold mt-5">Diagnosis</div>
                                <div class="text-gray-600">${patient.getDiagnosis() != null ? patient.getDiagnosis() : "—"}</div>
                                <div class="fw-bold mt-5">Notes</div>
                                <div class="text-gray-600">${patient.getNotes() != null ? patient.getNotes() : "—"}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="flex-lg-row-fluid ms-lg-15">
                    <ul class="nav nav-custom nav-tabs nav-line-tabs nav-line-tabs-2x border-0 fs-4 fw-semibold mb-8">
                        <li class="nav-item"><a class="nav-link text-active-primary pb-4 active" data-bs-toggle="tab" href="#kt_patient_schedule_tab">Schedule</a></li>
                        <li class="nav-item"><a class="nav-link text-active-primary pb-4" data-bs-toggle="tab" href="#kt_patient_journals_tab">Journals</a></li>
                    </ul>

                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="kt_patient_schedule_tab" role="tabpanel">
                            <div class="card card-flush mb-6 mb-xl-9">
                                <div class="card-header mt-6">
                                    <div class="card-title flex-column">
                                        <h2 class="mb-1">Patient Schedule</h2>
                                        <div class="fs-6 fw-semibold text-muted">Sessions for ${patient.getFullName()}</div>
                                    </div>
                                </div>
                                <div class="card-body p-9 pt-4">
                                    <div id="kt_patient_calendar"></div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="kt_patient_journals_tab" role="tabpanel">
                            <div class="card card-flush mb-6 mb-xl-9">
                                <div class="card-header mt-6">
                                    <div class="card-title flex-column">
                                        <h2 class="mb-1">Therapy Packages &amp; Journals</h2>
                                        <div class="fs-6 fw-semibold text-muted">All packages and session journals for ${patient.getFullName()}</div>
                                    </div>
                                </div>
                                <div class="card-body p-9 pt-4">
                                    @if(packageGroups == null || packageGroups.isEmpty())
                                        <div class="alert alert-info">No therapy packages yet for this patient.</div>
                                    @else
                                        <div class="accordion" id="kt_patient_packages_accordion">
                                            @for(int i = 0; i < packageGroups.size(); i++)
                                                @template.pages.parent.child.row(
                                                group = packageGroups.get(i),
                                                index = i,
                                                journalBasePath = "/parent/journal",
                                                viewerTherapistId = viewerTherapistId
                                                )
                                            @endfor
                                        </div>
                                    @endif
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <link href="/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet">
    <script src="/plugins/custom/fullcalendar/fullcalendar.bundle.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("kt_patient_calendar");

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "timeGridWeek",
                height: "auto",
                headerToolbar: {
                    left: "prev,next today",
                    center: "title",
                    right: "dayGridMonth,timeGridWeek,timeGridDay"
                },
                slotMinTime: "07:00:00",
                slotMaxTime: "20:00:00",
                allDaySlot: false,
                events: "/parent/child/${String.valueOf(patient.getId())}/events"
            });

            calendar.render();
        });
    </script>
`)