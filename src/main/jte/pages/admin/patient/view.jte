@import com.madania.management.entity.Notification
@import com.madania.management.entity.Patient
@import com.madania.management.enums.Gender
@import java.time.format.DateTimeFormatter
@import java.util.List

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param Patient patient
@param String success
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Patient Details",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <!--begin::Toolbar (Page title & actions)-->

    @if(success != null)
        <div class="alert alert-primary alert-dismissible fade show" role="alert">
            <strong>${success}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif

    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <!--begin::Page title-->
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Patient Details</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Home</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/patients" class="text-muted text-hover-primary">Patients</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${patient.getFullName()}</li>
                    </ul>
                </div>
                <!--end::Page title-->
                <!--begin::Actions-->
                <div class="d-flex align-items-center gap-2 gap-lg-3">
                    <span data-bs-toggle="tooltip" data-bs-trigger="hover" title="Edit patient details">
                        <a href="/admin/patient/${String.valueOf(patient.getId())}/edit" class="btn btn-light-primary"> Edit </a>
                    </span>
                    <span data-bs-toggle="tooltip" data-bs-trigger="hover" title="Delete patient ">
                        <form action="/admin/patient/${String.valueOf(patient.getId())}/delete" method="post">
                            <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                            <button type="submit" class="btn btn-light-danger"> Delete</button>
                        </form>
                    </span>
                </div>
                <!--end::Actions-->
            </div>
        </div>
    </div>
    <!--end::Toolbar-->
    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <!--begin::Layout-->
            <div class="d-flex flex-column flex-lg-row">
                <!--begin::Sidebar-->
                <div class="flex-column flex-lg-row-auto w-lg-250px w-xl-350px mb-10">
                    <!--begin::Card-->
                    <div class="card mb-5 mb-xl-8">
                        <div class="card-body">
                            <!--begin::User Info-->
                            <div class="d-flex flex-center flex-column py-5">
                                <!--begin::Avatar-->
                                <div class="symbol symbol-100px symbol-circle mb-7">
                                    @if(patient.getGender() == Gender.MALE)
                                        <img src="/media/avatars/boy.png" alt="image" />
                                    @elseif(patient.getGender() == Gender.FEMALE)
                                        <img src="/media/avatars/girl.png" alt="image" />
                                    @else
                                        <img src="/media/avatars/blank.png" alt="image" />
                                    @endif
                                </div>
                                <!--end::Avatar-->
                                <!--begin::Name-->
                                <a href="#" class="fs-3 text-gray-800 text-hover-primary fw-bold mb-3">${patient.getFullName()}</a>
                                <!--end::Name-->
                                <!--begin::Status-->

                            </div>
                            <!--end::User Info-->
                            <!--begin::Details toggle-->
                            <div class="d-flex flex-stack fs-4 py-3">
                                <div class="fw-bold rotate collapsible" data-bs-toggle="collapse" href="#kt_user_view_details" role="button" aria-expanded="false" aria-controls="kt_user_view_details">Details
                                    <span class="ms-2 rotate-180"><i class="ki-outline ki-down fs-3"></i></span></div>
                            </div>
                            <div class="separator"></div>
                            <!--begin::Details content-->
                            <div id="kt_user_view_details" class="collapse show">
                                <div class="pb-5 fs-6">
                                    <div class="fw-bold mt-5">Patient ID</div>
                                    <div class="text-gray-600">${patient.getId().toString()}</div>
                                    <div class="fw-bold mt-5">Patient Status</div>
                                    <div class="text-gray-600"> ${patient.isActive() ? "Active" : "Inactive"}</div>
                                    <div class="fw-bold mt-5">Registered At</div>
                                    <div class="text-gray-600">${patient.getCreatedAt() != null ? patient.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")) : "—"}</div>
                                    <div class="fw-bold mt-5">Last Update</div>
                                    <div class="text-gray-600">${patient.getUpdatedAt() != null ? patient.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")) : "—"}</div>
                                </div>
                            </div>
                            <!--end::Details content-->
                        </div>
                    </div>
                    <!--end::Card-->

                </div>
                <!--end::Sidebar-->

                <!--begin::Content-->
                <div class="flex-lg-row-fluid ms-lg-15">
                    <!--begin:::Tabs-->
                    <ul class="nav nav-custom nav-tabs nav-line-tabs nav-line-tabs-2x border-0 fs-4 fw-semibold mb-8">
                        <li class="nav-item"><a class="nav-link text-active-primary pb-4 active" data-bs-toggle="tab" href="#kt_user_view_overview_tab">Schedule</a></li>
                        <li class="nav-item"><a class="nav-link text-active-primary pb-4" data-kt-countup-tabs="true" data-bs-toggle="tab" href="#kt_user_view_overview_security">Profile</a></li>
                    </ul>
                    <!--end:::Tabs-->

                    <!--begin:::Tab content-->
                    <div class="tab-content" id="myTabContent">
                        <!--begin:::Tab pane: Schedule-->
                        <div class="tab-pane fade show active" id="kt_user_view_overview_tab" role="tabpanel">
                            <!-- Card: Schedule placeholder -->
                            <div class="card card-flush mb-6 mb-xl-9">
                                <div class="card-header mt-6">
                                    <div class="card-title flex-column">
                                        <h2 class="mb-1">Patient Schedule</h2>
                                        <div class="fs-6 fw-semibold text-muted">2 upcoming meetings</div>
                                    </div>
                                    <div class="card-toolbar">
                                        <button type="button" class="btn btn-light-primary btn-sm" data-bs-toggle="modal" data-bs-target="#kt_modal_add_schedule"><i class="ki-outline ki-brush fs-3"></i>Add Schedule</button>
                                    </div>
                                </div>
                                <div class="card-body p-9 pt-4">
                                    <!-- Date tabs (static) -->
                                    <ul class="nav nav-pills d-flex flex-nowrap hover-scroll-x py-2">
                                        <li class="nav-item me-1"><a class="nav-link btn d-flex flex-column flex-center rounded-pill min-w-40px me-2 py-4 btn-active-primary" data-bs-toggle="tab" href="#kt_schedule_day_0"><span class="opacity-50 fs-7 fw-semibold">Su</span><span class="fs-6 fw-bolder">21</span></a></li>
                                        <li class="nav-item me-1"><a class="nav-link btn d-flex flex-column flex-center rounded-pill min-w-40px me-2 py-4 btn-active-primary active" data-bs-toggle="tab" href="#kt_schedule_day_1"><span class="opacity-50 fs-7 fw-semibold">Mo</span><span class="fs-6 fw-bolder">22</span></a></li>
                                        <!-- Add more days as needed -->
                                    </ul>
                                    <div class="tab-content">
                                        <div id="kt_schedule_day_0" class="tab-pane fade show">
                                            <div class="d-flex flex-stack position-relative mt-6">
                                                <div class="position-absolute h-100 w-4px bg-secondary rounded top-0 start-0"></div>
                                                <div class="fw-semibold ms-5">
                                                    <div class="fs-7 mb-1">12:00 - 13:00 <span class="fs-7 text-muted text-uppercase">pm</span></div>
                                                    <a href="#" class="fs-5 fw-bold text-gray-900 text-hover-primary mb-2">Creative Content Initiative</a>
                                                    <div class="fs-7 text-muted">Lead by <a href="#">Sean Bean</a></div>
                                                </div>
                                                <a href="#" class="btn btn-light bnt-active-light-primary btn-sm">View</a>
                                            </div>
                                        </div>
                                        <div id="kt_schedule_day_1" class="tab-pane fade show active">
                                            <div class="d-flex flex-stack position-relative mt-6">
                                                <div class="position-absolute h-100 w-4px bg-secondary rounded top-0 start-0"></div>
                                                <div class="fw-semibold ms-5">
                                                    <div class="fs-7 mb-1">14:30 - 15:30 <span class="fs-7 text-muted text-uppercase">pm</span></div>
                                                    <a href="#" class="fs-5 fw-bold text-gray-900 text-hover-primary mb-2">Weekly Team Stand-Up</a>
                                                    <div class="fs-7 text-muted">Lead by <a href="#">Yannis Gloverson</a></div>
                                                </div>
                                                <a href="#" class="btn btn-light bnt-active-light-primary btn-sm">View</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!--end:::Tab pane-->

                        <!--begin:::Tab pane: Profile-->
                        <div class="tab-pane fade" id="kt_user_view_overview_security" role="tabpanel">
                            <!-- Profile fields -->
                            <div class="card pt-4 mb-6 mb-xl-9">
                                <div class="card-header border-0"><div class="card-title"><h2>Profile</h2></div></div>
                                <div class="card-body pt-0 pb-5">
                                    <div class="table-responsive">
                                        <table class="table align-middle table-row-dashed gy-5">
                                            <tbody class="fs-6 fw-semibold text-gray-600">
                                            <tr><td>Full Name</td><td>${patient.getFullName()}</td><td class="text-end"></td></tr>
                                            <tr><td>Age</td><td>${patient.getAge().getYears() + " years, " +patient.getAge().getMonths() + " months old" }</td><td class="text-end"></td></tr>
                                            <tr><td>Date of Birth</td><td>${patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "—"}</td><td class="text-end"></td></tr>
                                            <tr><td>Gender</td><td>${patient.getGender() == Gender.MALE ? "Male" : "Female"}</td><td class="text-end"></td></tr>
                                            <tr><td>Diagnosis</td><td>${patient.getDiagnosis() != null ? patient.getDiagnosis() : "—"}</td><td class="text-end"></td></tr>
                                            <tr><td>Parent</td><td>${patient.getParent() != null ? patient.getParent().getFullName() : "—"}</td><td class="text-end"></td></tr>
                                            <tr><td>Notes</td><td>${patient.getNotes() != null ? patient.getNotes() : "—"}</td><td class="text-end"></td></tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!--end:::Tab pane-->

                    </div>
                    <!--end:::Tab content-->
                </div>
                <!--end::Content-->
            </div>
            <!--end::Layout-->
        </div>
    </div>
    <!--end::Content-->
`)