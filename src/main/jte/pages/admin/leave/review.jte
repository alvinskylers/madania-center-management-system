@import com.madania.management.entity.User
@import com.madania.management.entity.LeaveRequest
@import com.madania.management.entity.TherapySession
@import com.madania.management.entity.Notification
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

@template.layout.base(
title = "Review Leave Request",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Review Leave Request</h1>
        <a href="/admin/leaves" class="btn btn-light">Back</a>
    </div>

    @if(leaveError != null)
        <div class="alert alert-danger"><p>${leaveError}</p></div>
    @endif

    <div class="card mb-5">
        <div class="card-body">
            <p><strong>Therapist:</strong> ${leave.getTherapist().getFullName()}</p>
            <p><strong>Dates:</strong> ${leave.getStartDate().toString()} to ${leave.getEndDate().toString()}</p>
            <p><strong>Reason:</strong> ${leave.getReason() != null ? leave.getReason() : "-"}</p>
            <p><strong>Status:</strong>
                @if(leave.getStatus() == LeaveStatus.PENDING)
                    <span class="badge badge-light-warning">Pending</span>
                @elseif(leave.getStatus() == LeaveStatus.APPROVED)
                    <span class="badge badge-light-success">Approved</span>
                @elseif(leave.getStatus() == LeaveStatus.REJECTED)
                    <span class="badge badge-light-danger">Rejected</span>
                @endif
            </p>
        </div>
    </div>

    <div class="card mb-5">
        <div class="card-body">
            <h5 class="mb-3">Therapist's Schedule</h5>
            <p class="text-muted mb-3">The shaded period below is this leave request. Use this to judge good replacement times.</p>
            <div id="kt_therapist_calendar"></div>
        </div>
    </div>

    @if(leave.getStatus() == LeaveStatus.PENDING)
        <div class="card">
            <div class="card-body">
                <h5 class="mb-3">Affected Sessions</h5>

                @if(suggestions.isEmpty())
                    <p class="text-muted mb-5">No scheduled sessions fall within this leave period.</p>
                    <form action="/admin/leaves/${String.valueOf(leave.getId())}/approve" method="post" id="approve-leave-form">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                        <button type="button" class="btn btn-success leave-confirm-btn"
                                data-form-id="approve-leave-form"
                                data-message="Approve this leave request?">
                            Approve Leave
                        </button>
                    </form>
                @else
                    <p class="text-muted mb-5">
                        We've suggested a new time for each session below (next available same weekday/time after the leave ends).
                        Review or adjust before approving — sessions without a suggestion need a manual time.
                    </p>

                    <form action="/admin/leaves/${String.valueOf(leave.getId())}/approve" method="post" id="approve-leave-form">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                        <table class="table align-middle mb-5">
                            <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Session #</th>
                                <th>Original Time</th>
                                <th>New Time</th>
                            </tr>
                            </thead>
                            <tbody>
                            @for(var entry : suggestions.entrySet())
                                <tr>
                                    <td>${entry.getKey().getPatient().getFullName()}</td>
                                    <td>${entry.getKey().getSessionNumber()}</td>
                                    <td>${entry.getKey().getStartTime().toString()}</td>
                                    <td>
                                        <input type="datetime-local" class="form-control"
                                               name="sessionTime_${String.valueOf(entry.getKey().getId())}"
                                               value="${entry.getValue() != null ? entry.getValue().toString() : ""}"
                                               required>
                                        @if(entry.getValue() == null)
                                            <span class="text-danger fs-8">No slot found automatically — please pick manually</span>
                                        @endif
                                    </td>
                                </tr>
                            @endfor
                            </tbody>
                        </table>

                        <div class="fv-row mb-5">
                            <label class="fs-6 fw-semibold mb-2">Admin notes (optional)</label>
                            <textarea class="form-control" name="adminNotes" rows="2"></textarea>
                        </div>

                        <button type="button" class="btn btn-success leave-confirm-btn"
                                data-form-id="approve-leave-form"
                                data-message="Approve this leave? All listed sessions will be rescheduled to the times shown.">
                            Approve Leave &amp; Reschedule Sessions
                        </button>
                    </form>
                @endif

                <form action="/admin/leaves/${String.valueOf(leave.getId())}/reject" method="post" class="mt-3" id="reject-leave-form">
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                    <button type="button" class="btn btn-light-danger leave-confirm-btn"
                            data-form-id="reject-leave-form"
                            data-message="Reject this leave request?">
                        Reject Leave
                    </button>
                </form>
            </div>
        </div>
    @endif

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
                events: "/admin/leaves/${String.valueOf(leave.getId())}/therapist-events"
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