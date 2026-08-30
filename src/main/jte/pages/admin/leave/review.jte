@import com.madania.management.entity.LeaveRequest
@import com.madania.management.entity.TherapySession
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import com.madania.management.enums.LeaveStatus
@import java.time.LocalDateTime
@import java.util.List
@import java.util.Map

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param LeaveRequest leave
@param Map<TherapySession, LocalDateTime> suggestions
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null
@param String leaveError = null

!{String leaveId = String.valueOf(leave.getId());}
!{boolean isPending = leave.getStatus() == LeaveStatus.PENDING;}

@template.layout.base(
title = "Review Leave Request",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Review Leave Request</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Home</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/leaves" class="text-muted text-hover-primary">Leave Requests</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${leave.getTherapist().getFullName()}</li>
                    </ul>
                </div>
                <div class="align-items-center">
                    <a href="/admin/leaves" class="btn btn-light h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-black-left fs-3"></i>Back to Requests
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            @if(leaveError != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>${leaveError}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <!--begin::Summary Card-->
            <div class="card card-flush mb-6">
                <div class="card-body py-6">
                    <div class="d-flex flex-wrap align-items-center gap-6">
                        <div class="symbol symbol-55px symbol-circle">
                            <span class="symbol-label bg-light-primary text-primary fw-bold fs-3">
                                ${leave.getTherapist().getFullName().substring(0, 1).toUpperCase()}
                            </span>
                        </div>
                        <div class="d-flex flex-column">
                            <span class="fs-7 text-muted">Therapist</span>
                            <span class="fs-5 fw-bold text-gray-800">${leave.getTherapist().getFullName()}</span>
                        </div>
                        <div class="separator separator-dashed d-none d-md-block h-40px"></div>
                        <div class="d-flex flex-column">
                            <span class="fs-7 text-muted">Leave Period</span>
                            <span class="fs-5 fw-bold text-gray-800">${leave.getStartDate().toString()} &rarr; ${leave.getEndDate().toString()}</span>
                        </div>
                        <div class="separator separator-dashed d-none d-md-block h-40px"></div>
                        <div class="d-flex flex-column">
                            <span class="fs-7 text-muted">Status</span>
                            <span class="mt-1">
                                @if(leave.getStatus() == LeaveStatus.PENDING)
                                    <span class="badge badge-light-warning">Pending</span>
                                @elseif(leave.getStatus() == LeaveStatus.APPROVED)
                                    <span class="badge badge-light-success">Approved</span>
                                @else
                                    <span class="badge badge-light-danger">Rejected</span>
                                @endif
                            </span>
                        </div>
                        <div class="separator separator-dashed d-none d-md-block h-40px"></div>
                        <div class="d-flex flex-column flex-grow-1">
                            <span class="fs-7 text-muted">Reason</span>
                            <span class="fs-6 text-gray-700">${leave.getReason() != null && !leave.getReason().isBlank() ? leave.getReason() : "—"}</span>
                        </div>
                    </div>

                    @if(!isPending && leave.getAdminNotes() != null && !leave.getAdminNotes().isBlank())
                        <div class="separator my-5"></div>
                        <div class="d-flex flex-column">
                            <span class="fs-7 text-muted mb-1">Admin Notes</span>
                            <span class="fs-6 text-gray-700">${leave.getAdminNotes()}</span>
                        </div>
                    @endif
                </div>
            </div>
            <!--end::Summary Card-->

            <!--begin::Calendar Card-->
            <div class="card card-flush mb-6">
                <div class="card-header pt-7">
                    <div class="card-title flex-column">
                        <h2 class="mb-1">Therapist's Schedule</h2>
                        <div class="fs-7 fw-semibold text-muted">
                            The shaded period is this leave request &mdash; use it to judge good replacement times.
                        </div>
                    </div>
                </div>
                <div class="card-body pt-5">
                    <div class="d-flex flex-wrap gap-5 mb-5 fs-7">
                        <div class="d-flex align-items-center">
                            <span class="bullet bullet-dot me-2" style="background-color:#1B84FF;"></span>Scheduled
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="bullet bullet-dot me-2" style="background-color:#17C653;"></span>Completed
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="bullet bullet-dot me-2" style="background-color:#F1416C;"></span>Cancelled
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="bullet bullet-dot me-2" style="background-color:#FFA800;"></span>Rescheduled
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="bullet bullet-dot me-2" style="background-color:#F1416C; opacity:0.3;"></span>Leave Period
                        </div>
                    </div>
                    <div id="kt_therapist_calendar"></div>
                </div>
            </div>
            <!--end::Calendar Card-->

            @if(isPending)
                <!--begin::Affected Sessions-->
                <div class="card card-flush">
                    <div class="card-header pt-7">
                        <div class="card-title">
                            <i class="ki-outline ki-calendar-tick fs-1 text-primary me-2"></i>
                            <h2>Affected Sessions</h2>
                        </div>
                    </div>
                    <div class="card-body pt-5">

                        @if(suggestions.isEmpty())
                            <div class="alert alert-info">No scheduled sessions fall within this leave period.</div>

                            <form action="/admin/leaves/${leaveId}/approve" method="post" id="approve-leave-form">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                            </form>

                            <div class="d-flex justify-content-end gap-3">
                                <form action="/admin/leaves/${leaveId}/reject" method="post" id="reject-leave-form">
                                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                                    <button type="button" class="btn btn-light-danger leave-confirm-btn"
                                            data-form-id="reject-leave-form"
                                            data-message="Reject this leave request?">
                                        Reject Leave
                                    </button>
                                </form>
                                <button type="button" class="btn btn-success leave-confirm-btn"
                                        data-form-id="approve-leave-form"
                                        data-message="Approve this leave request?">
                                    Approve Leave
                                </button>
                            </div>
                        @else
                            <div class="alert alert-primary d-flex align-items-center">
                                <i class="ki-outline ki-information-5 fs-2 me-3"></i>
                                <span>
                                    We've suggested a new time for each session below (next available same weekday/time after the leave ends).
                                    Review or adjust before approving &mdash; sessions without a suggestion need a manual time.
                                </span>
                            </div>

                            <form action="/admin/leaves/${leaveId}/approve" method="post" id="approve-leave-form">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                                <div class="table-responsive">
                                    <table class="table align-middle table-row-dashed fs-6 gy-4 mb-5">
                                        <thead>
                                        <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                            <th>Patient</th>
                                            <th>Session #</th>
                                            <th>Original Time</th>
                                            <th>New Time</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        @for(var entry : suggestions.entrySet())
                                            <tr>
                                                <td class="fw-semibold text-gray-800">${entry.getKey().getPatient().getFullName()}</td>
                                                <td>${entry.getKey().getSessionNumber()}</td>
                                                <td class="text-muted">${entry.getKey().getStartTime().toString()}</td>
                                                <td>
                                                    <input type="datetime-local" class="form-control form-control-solid"
                                                           name="sessionTime_${String.valueOf(entry.getKey().getId())}"
                                                           value="${entry.getValue() != null ? entry.getValue().toString() : ""}"
                                                           required>
                                                    @if(entry.getValue() == null)
                                                        <span class="text-danger fs-8">
                                                            <i class="ki-outline ki-information-5 fs-8"></i>
                                                            No slot found automatically &mdash; please pick manually
                                                        </span>
                                                    @endif
                                                </td>
                                            </tr>
                                        @endfor
                                        </tbody>
                                    </table>
                                </div>

                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Admin Notes</span>
                                        <span class="fs-7 fw-normal text-muted ms-2">Optional</span>
                                    </label>
                                    <textarea class="form-control form-control-solid" name="adminNotes" rows="2"
                                              placeholder="Any notes about this decision (optional)"></textarea>
                                </div>
                            </form>

                            <div class="separator mb-6"></div>
                            <div class="d-flex justify-content-end gap-3">
                                <form action="/admin/leaves/${leaveId}/reject" method="post" id="reject-leave-form">
                                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                                    <button type="button" class="btn btn-light-danger leave-confirm-btn"
                                            data-form-id="reject-leave-form"
                                            data-message="Reject this leave request?">
                                        Reject Leave
                                    </button>
                                </form>
                                <button type="button" class="btn btn-success leave-confirm-btn"
                                        data-form-id="approve-leave-form"
                                        data-message="Approve this leave? All listed sessions will be rescheduled to the times shown.">
                                    Approve Leave &amp; Reschedule Sessions
                                </button>
                            </div>
                        @endif
                    </div>
                </div>
                <!--end::Affected Sessions-->
            @endif

        </div>
    </div>
    <!--end::Content-->

    <!--begin::Modal - Confirm Action-->
    <div class="modal fade" id="kt_modal_confirm_leave_action" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Confirm</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>
                <div class="modal-body" id="kt_modal_confirm_leave_message"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="kt_modal_confirm_leave_submit">Confirm</button>
                </div>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    <link href="/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet">
    <script src="/plugins/custom/fullcalendar/fullcalendar.bundle.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("kt_therapist_calendar");

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "dayGridMonth",
                initialDate: "${leave.getStartDate().toString()}",
                height: "auto",
                headerToolbar: {
                    left: "prev,next today",
                    center: "title",
                    right: "dayGridMonth,timeGridWeek"
                },
                events: "/admin/leaves/${leaveId}/therapist-events"
            });

            calendar.render();

            var confirmModal = new bootstrap.Modal(document.getElementById("kt_modal_confirm_leave_action"));
            var confirmMessage = document.getElementById("kt_modal_confirm_leave_message");
            var confirmSubmitBtn = document.getElementById("kt_modal_confirm_leave_submit");
            var pendingFormId = null;

            document.querySelectorAll(".leave-confirm-btn").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    pendingFormId = btn.getAttribute("data-form-id");
                    confirmMessage.innerText = btn.getAttribute("data-message");
                    confirmModal.show();
                });
            });

            confirmSubmitBtn.addEventListener("click", function () {
                if (pendingFormId) {
                    document.getElementById(pendingFormId).submit();
                }
            });
        });
    </script>
`
)
