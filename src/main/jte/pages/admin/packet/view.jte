@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapyPackage
@import com.madania.management.entity.TherapySession
@import java.time.format.DateTimeFormatter
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyPackage therapyPackage
@param List<TherapySession> sessions
@param String success = null
@param String error = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String pkgId = String.valueOf(therapyPackage.getId());}
!{String status = therapyPackage.getStatus().name();}
!{int progressPercent = therapyPackage.getTotalSessions() > 0 ? (therapyPackage.getCompletedSessions() * 100 / therapyPackage.getTotalSessions()) : 0;}

@template.layout.base(
title = "Package Details",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <!--begin::Page title-->
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Package Details</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Home</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/packages" class="text-muted text-hover-primary">Therapy Packages</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${therapyPackage.getPatient().getFullName()}</li>
                    </ul>
                </div>
                <!--end::Page title-->
                <!--begin::Actions-->
                <div class="d-flex align-items-center gap-2 gap-lg-3">
                    @if(status.equals("ACTIVE"))
                        <button type="button" class="btn btn-light-danger" id="kt_package_cancel_btn"
                                data-bs-toggle="tooltip" title="Cancel this package">
                            <i class="ki-outline ki-cross-circle fs-4"></i>Cancel Package
                        </button>
                    @endif
                </div>
                <!--end::Actions-->
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            @if(success != null)
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>${success}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif
            @if(error != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>${error}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <!--begin::Layout-->
            <div class="d-flex flex-column flex-lg-row">

                <!--begin::Sidebar-->
                <div class="flex-column flex-lg-row-auto w-lg-350px mb-10">
                    <!--begin::Summary Card-->
                    <div class="card mb-5 mb-xl-8">
                        <div class="card-body">
                            <!--begin::Icon + Status-->
                            <div class="d-flex flex-center flex-column py-5">
                                <div class="symbol symbol-75px symbol-circle mb-5">
                                    <span class="symbol-label bg-light-primary">
                                        <i class="ki-outline ki-calendar-tick fs-2x text-primary"></i>
                                    </span>
                                </div>
                                <a href="/admin/patient/${String.valueOf(therapyPackage.getPatient().getId())}" class="fs-3 text-gray-800 text-hover-primary fw-bold mb-2 text-center">
                                    ${therapyPackage.getPatient().getFullName()}
                                </a>
                                <div class="fs-6 text-muted mb-3">with ${therapyPackage.getTherapist().getFullName()}</div>
                                @if(status.equals("ACTIVE"))
                                    <span class="badge badge-light-success fs-7">Active</span>
                                @elseif(status.equals("COMPLETED"))
                                    <span class="badge badge-light-primary fs-7">Completed</span>
                                @else
                                    <span class="badge badge-light-danger fs-7">Cancelled</span>
                                @endif
                            </div>
                            <!--end::Icon + Status-->

                            <div class="separator my-3"></div>

                            <!--begin::Progress-->
                            <div class="pb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="fw-semibold fs-7 text-gray-700">Session Progress</span>
                                    <span class="fw-bold fs-7 text-gray-800">${therapyPackage.getCompletedSessions()} / ${therapyPackage.getTotalSessions()}</span>
                                </div>
                                <div class="progress h-6px w-100">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: ${progressPercent}%;"></div>
                                </div>
                            </div>
                            <!--end::Progress-->

                            <div class="separator my-3"></div>

                            <!--begin::Details-->
                            <div class="pb-3 fs-6">
                                <div class="fw-bold mt-5">Start Date</div>
                                <div class="text-gray-600">${therapyPackage.getStartDate() != null ? therapyPackage.getStartDate().toString() : "—"}</div>

                                <div class="fw-bold mt-5">End Date</div>
                                <div class="text-gray-600">${therapyPackage.getEndDate() != null ? therapyPackage.getEndDate().toString() : "—"}</div>

                                <div class="fw-bold mt-5">Session Time</div>
                                <div class="text-gray-600">${therapyPackage.getSessionTime() != null ? therapyPackage.getSessionTime().toString() : "—"}</div>

                                <div class="fw-bold mt-5">Created By</div>
                                <div class="text-gray-600">${therapyPackage.getCreatedBy() != null ? therapyPackage.getCreatedBy().getEmail() : "—"}</div>

                                <div class="fw-bold mt-5">Created At</div>
                                <div class="text-gray-600">${therapyPackage.getCreatedAt() != null ? therapyPackage.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")) : "—"}</div>

                                @if(therapyPackage.getNotes() != null && !therapyPackage.getNotes().isBlank())
                                    <div class="fw-bold mt-5">Notes</div>
                                    <div class="text-gray-600">${therapyPackage.getNotes()}</div>
                                @endif
                            </div>
                            <!--end::Details-->
                        </div>
                    </div>
                    <!--end::Summary Card-->
                </div>
                <!--end::Sidebar-->

                <!--begin::Content-->
                <div class="flex-lg-row-fluid ms-lg-15">
                    <div class="card card-flush mb-6 mb-xl-9">
                        <div class="card-header mt-6">
                            <div class="card-title flex-column">
                                <h2 class="mb-1">Sessions</h2>
                                <div class="fs-6 fw-semibold text-muted">All ${therapyPackage.getTotalSessions()} scheduled sessions for this package</div>
                            </div>
                        </div>
                        <div class="card-body pt-0">
                            <div class="table-responsive">
                                <table class="table align-middle table-row-dashed fs-6 gy-4">
                                    <thead>
                                    <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                        <th>#</th>
                                        <th>Date</th>
                                        <th>Day</th>
                                        <th>Time</th>
                                        <th>Status</th>
                                        <th>Notes</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @if(sessions != null && !sessions.isEmpty())
                                        @for(TherapySession session : sessions)
                                            <tr>
                                                <td>${session.getSessionNumber()}</td>
                                                <td>${session.getStartTime().toLocalDate().toString()}</td>
                                                <td>${session.getDay().toString()}</td>
                                                <td>${session.getStartTime().toLocalTime().toString()} - ${session.getEndTime().toLocalTime().toString()}</td>
                                                <td>
                                                    @if(session.getStatus().name().equals("SCHEDULED"))
                                                        <span class="badge badge-light-primary">Scheduled</span>
                                                    @elseif(session.getStatus().name().equals("COMPLETED"))
                                                        <span class="badge badge-light-success">Completed</span>
                                                    @elseif(session.getStatus().name().equals("CANCELLED"))
                                                        <span class="badge badge-light-danger">Cancelled</span>
                                                    @else
                                                        <span class="badge badge-light-warning">Rescheduled</span>
                                                    @endif
                                                </td>
                                                <td class="text-muted fs-7">
                                                    ${session.getCancellationReason() != null ? session.getCancellationReason() : "—"}
                                                </td>
                                            </tr>
                                        @endfor
                                    @else
                                        <tr>
                                            <td colspan="6">
                                                <div class="alert alert-info text-center mb-0">No sessions found for this package.</div>
                                            </td>
                                        </tr>
                                    @endif
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!--end::Content-->
            </div>
            <!--end::Layout-->
        </div>
    </div>
    <!--end::Content-->

    <!--begin::Modal - Confirm Cancel Package-->
    <div class="modal fade" id="kt_package_cancel_modal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Cancel Package</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>
                <div class="modal-body">
                    Are you sure you want to cancel this package for
                    <strong>${therapyPackage.getPatient().getFullName()}</strong>?
                    All remaining <strong>scheduled</strong> sessions in this package will also be cancelled.
                    This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Go Back</button>
                    <form action="/admin/package/${pkgId}/cancel" method="post">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                        <button type="submit" class="btn btn-danger">Yes, Cancel Package</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var cancelBtn = document.getElementById("kt_package_cancel_btn");
            if (cancelBtn) {
                var cancelModal = new bootstrap.Modal(document.getElementById("kt_package_cancel_modal"));
                cancelBtn.addEventListener("click", function () {
                    cancelModal.show();
                });
            }
        });
    </script>
`
)