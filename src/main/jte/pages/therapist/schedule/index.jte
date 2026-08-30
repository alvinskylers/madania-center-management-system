@import com.madania.management.entity.User
@import com.madania.management.entity.RescheduleRequest
@import com.madania.management.enums.RescheduleStatus
@import java.time.format.DateTimeFormatter

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param java.util.List<RescheduleRequest> myRescheduleRequests
@param String rescheduleError = null
@param String rescheduleSuccess = null
@param long unreadNotificationCount = 0
@param java.util.List<com.madania.management.entity.Notification> recentNotifications = null

@template.layout.base(
title = "My Schedule",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">My Schedule</h1>
    </div>

    @if(rescheduleSuccess != null)
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>${rescheduleSuccess}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif
    @if(rescheduleError != null)
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>${rescheduleError}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif

    <div class="card mb-6">
        <div class="card-body">
            <div id="kt_calendar"></div>
        </div>
    </div>

    <!--begin::My Reschedule Requests-->
    <div class="card card-flush">
        <div class="card-header pt-7">
            <div class="card-title">
                <i class="ki-outline ki-calendar-8 fs-1 text-primary me-2"></i>
                <h2>My Reschedule Requests</h2>
            </div>
        </div>
        <div class="card-body pt-5">
            <div class="table-responsive">
                <table class="table align-middle table-row-dashed fs-6 gy-4">
                    <thead>
                    <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                        <th>Patient</th>
                        <th>Original Time</th>
                        <th>Requested Time</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Admin Notes</th>
                        <th>Submitted</th>
                    </tr>
                    </thead>
                    <tbody>
                    @if(myRescheduleRequests != null && !myRescheduleRequests.isEmpty())
                        @for(RescheduleRequest r : myRescheduleRequests)
                            <tr>
                                <td class="fw-semibold text-gray-800">${r.getSession().getPatient().getFullName()}</td>
                                <td class="text-muted">${r.getSession().getStartTime().toString()}</td>
                                <td>${r.getRequestedStartTime().toString()}</td>
                                <td class="text-gray-700">${r.getReason() != null && !r.getReason().isBlank() ? r.getReason() : "—"}</td>
                                <td>
                                    @if(r.getStatus() == RescheduleStatus.PENDING)
                                        <span class="badge badge-light-warning">Pending</span>
                                    @elseif(r.getStatus() == RescheduleStatus.APPROVED)
                                        <span class="badge badge-light-success">Approved</span>
                                    @else
                                        <span class="badge badge-light-danger">Rejected</span>
                                    @endif
                                </td>
                                <td class="text-muted fs-7">
                                    ${r.getAdminNotes() != null && !r.getAdminNotes().isBlank() ? r.getAdminNotes() : "—"}
                                </td>
                                <td class="text-muted fs-7">
                                    ${r.getCreatedAt() != null ? r.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy")) : "—"}
                                </td>
                            </tr>
                        @endfor
                    @else
                        <tr>
                            <td colspan="7">
                                <div class="alert alert-info text-center mb-0">You haven't submitted any reschedule requests yet.</div>
                            </td>
                        </tr>
                    @endif
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!--end::My Reschedule Requests-->

    <!--begin::Modal - Session Details-->
    <div class="modal fade" id="kt_modal_session_details" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Session Details</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <span class="fw-semibold text-gray-600">Session:</span>
                        <span id="detail_title"></span>
                    </div>
                    <div class="mb-3">
                        <span class="fw-semibold text-gray-600">Scheduled time:</span>
                        <span id="detail_time"></span>
                    </div>
                    <div class="mb-3">
                        <span class="fw-semibold text-gray-600">Status:</span>
                        <span id="detail_status" class="badge"></span>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="btn_open_reschedule">Request Reschedule</button>
                </div>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    <!--begin::Modal - Request Reschedule-->
    <div class="modal fade" id="kt_modal_request_reschedule" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form method="post" action="/therapist/schedule/reschedule">
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                    <input type="hidden" name="sessionId" id="reschedule_session_id">

                    <div class="modal-header">
                        <h2 class="modal-title">Request Reschedule</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                            <i class="ki-outline ki-cross fs-1"></i>
                        </div>
                    </div>

                    <div class="modal-body">
                        <div class="fs-6 text-gray-600 mb-5" id="reschedule_session_label"></div>

                        <div class="fv-row mb-5">
                            <label class="fs-6 fw-semibold mb-2">New requested time</label>
                            <input type="datetime-local" class="form-control" name="requestedStartTime" required>
                        </div>

                        <div class="fv-row mb-5">
                            <label class="fs-6 fw-semibold mb-2">Reason</label>
                            <textarea class="form-control" name="reason" rows="3" placeholder="Why do you need to reschedule this session?"></textarea>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit Request</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    <link href="/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet">
    <script src="/plugins/custom/fullcalendar/fullcalendar.bundle.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("kt_calendar");
            var detailsModal = new bootstrap.Modal(document.getElementById("kt_modal_session_details"));
            var rescheduleModal = new bootstrap.Modal(document.getElementById("kt_modal_request_reschedule"));
            var btnOpenReschedule = document.getElementById("btn_open_reschedule");

            var statusBadgeClass = {
                SCHEDULED: "badge-light-primary",
                COMPLETED: "badge-light-success",
                CANCELLED: "badge-light-danger",
                RESCHEDULED: "badge-light-warning"
            };

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "timeGridWeek",
                height: "auto",
                headerToolbar: {
                    left: "prev,next today",
                    center: "title",
                    right: "dayGridMonth,timeGridWeek,timeGridDay"
                },
                slotMinTime: "08:00:00",
                slotMaxTime: "18:00:00",
                allDaySlot: false,
                events: "/therapist/schedule/events",
                eventClick: function (info) {
                    var status = info.event.extendedProps.status;

                    document.getElementById("detail_title").innerText = info.event.title;
                    document.getElementById("detail_time").innerText =
                        info.event.start.toLocaleString() + " - " + info.event.end.toLocaleTimeString();

                    var badge = document.getElementById("detail_status");
                    badge.innerText = status;
                    badge.className = "badge " + (statusBadgeClass[status] || "badge-light-secondary");

                    if (status === "SCHEDULED") {
                        btnOpenReschedule.style.display = "inline-block";
                        btnOpenReschedule.onclick = function () {
                            document.getElementById("reschedule_session_id").value = info.event.id;
                            document.getElementById("reschedule_session_label").innerText =
                                info.event.title + " — currently " + info.event.start.toLocaleString();
                            detailsModal.hide();
                            rescheduleModal.show();
                        };
                    } else {
                        btnOpenReschedule.style.display = "none";
                    }

                    detailsModal.show();
                }
            });

            calendar.render();
        });
    </script>
`
)