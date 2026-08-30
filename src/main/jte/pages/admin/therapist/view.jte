@import com.madania.management.entity.Therapist
@import com.madania.management.entity.User

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param User user
@param Therapist therapist

@template.layout.base(
title = "Therapist Details",
role = role,
user = user,
_csrf = _csrf,
content = @`
    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Therapist Details</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Home</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/therapists" class="text-muted text-hover-primary">Therapists</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${therapist.getFullName()}</li>
                    </ul>
                </div>
                <div class="d-flex align-items-center gap-2 gap-lg-3">
                    <a href="/admin/therapist/${String.valueOf(therapist.getId())}/edit" class="btn btn-light-primary">Edit</a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="d-flex flex-column flex-lg-row">
                <!--begin::Sidebar-->
                <div class="flex-column flex-lg-row-auto w-lg-250px w-xl-350px mb-10">
                    <div class="card mb-5 mb-xl-8">
                        <div class="card-body">
                            <div class="d-flex flex-center flex-column py-5">
                                <div class="symbol symbol-100px symbol-circle mb-7">
                                    <img src="/media/avatars/blank.png" alt="image" />
                                </div>
                                <a href="#" class="fs-3 text-gray-800 text-hover-primary fw-bold mb-3">${therapist.getFullName()}</a>
                            </div>
                            <div class="d-flex flex-stack fs-4 py-3">
                                <div class="fw-bold rotate collapsible" data-bs-toggle="collapse" href="#kt_therapist_view_details" role="button" aria-expanded="false" aria-controls="kt_therapist_view_details">Details
                                    <span class="ms-2 rotate-180"><i class="ki-outline ki-down fs-3"></i></span></div>
                            </div>
                            <div class="separator"></div>
                            <div id="kt_therapist_view_details" class="collapse show">
                                <div class="pb-5 fs-6">
                                    <div class="fw-bold mt-5">Specialization</div>
                                    <div class="text-gray-600">${therapist.getSpecialization() != null ? therapist.getSpecialization() : "—"}</div>
                                    <div class="fw-bold mt-5">Phone</div>
                                    <div class="text-gray-600">${therapist.getPhone() != null ? therapist.getPhone() : "—"}</div>
                                    <div class="fw-bold mt-5">Email</div>
                                    <div class="text-gray-600">${therapist.getUser().getEmail()}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--end::Sidebar-->

                <!--begin::Content-->
                <div class="flex-lg-row-fluid ms-lg-15">
                    <ul class="nav nav-custom nav-tabs nav-line-tabs nav-line-tabs-2x border-0 fs-4 fw-semibold mb-8">
                        <li class="nav-item"><a class="nav-link text-active-primary pb-4 active" data-bs-toggle="tab" href="#kt_therapist_view_schedule_tab">Schedule</a></li>
                    </ul>

                    <div class="tab-content" id="myTabContent">
                        <!--begin:::Tab pane: Schedule-->
                        <div class="tab-pane fade show active" id="kt_therapist_view_schedule_tab" role="tabpanel">
                            <div class="card card-flush mb-6 mb-xl-9">
                                <div class="card-header mt-6">
                                    <div class="card-title flex-column">
                                        <h2 class="mb-1">Therapist Schedule</h2>
                                        <div class="fs-6 fw-semibold text-muted">All therapy sessions for ${therapist.getFullName()}</div>
                                    </div>
                                </div>
                                <div class="card-body p-9 pt-4">
                                    <div id="kt_therapist_calendar"></div>
                                </div>
                            </div>
                        </div>
                        <!--end:::Tab pane-->
                    </div>
                </div>
                <!--end::Content-->
            </div>
        </div>
    </div>

    <link href="/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet">
    <script src="/plugins/custom/fullcalendar/fullcalendar.bundle.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("kt_therapist_calendar");

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
                events: "/admin/therapist/${String.valueOf(therapist.getId())}/events"
            });

            calendar.render();
        });
    </script>
`)