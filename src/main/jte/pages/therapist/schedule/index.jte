@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String rescheduleError = null
@param String rescheduleSuccess = null
@param long unreadNotificationCount = 0
@param java.util.List<com.madania.management.entity.Notification> recentNotifications = null

@template.layout.base(
title = "My Schedule",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">My Schedule</h1>
    </div>

    @if(rescheduleSuccess != null)
        <div class="alert alert-success"><p>${rescheduleSuccess}</p></div>
    @endif
    @if(rescheduleError != null)
        <div class="alert alert-danger"><p>${rescheduleError}</p></div>
    @endif

    <div class="card">
        <div class="card-body">
            <div id="kt_calendar"></div>
        </div>
    </div>

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