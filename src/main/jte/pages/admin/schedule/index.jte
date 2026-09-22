@import com.madania.management.entity.User

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String rescheduleError = null
@param String rescheduleSuccess = null
@param long unreadNotificationCount = 0
@param java.util.List<com.madania.management.entity.Notification> recentNotifications = null

@template.layout.base(
title = "Sesi Terapi Keseluruhan",
role = role,
user = user,
_csrf =  _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 mb-5">
        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted">Jadwal Terapi</li>
    </ul>
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Sesi Terapi Keseluruhan</h1>
        <div class="d-flex gap-3 align-items-center">
                <span class="d-flex align-items-center gap-2">
                    <span class="bullet bullet-dot" style="background:#1B84FF"></span>
                    <small>Terjadwalkan</small>
                </span>
            <span class="d-flex align-items-center gap-2">
                    <span class="bullet bullet-dot" style="background:#17C653"></span>
                    <small>Tuntas</small>
                </span>
            <span class="d-flex align-items-center gap-2">
                    <span class="bullet bullet-dot" style="background:#F1416C"></span>
                    <small>Dibatalkan</small>
                </span>
            <span class="d-flex align-items-center gap-2">
                    <span class="bullet bullet-dot" style="background:#FFA800"></span>
                    <small>Reschedule</small>
                </span>
        </div>
    </div>

    @if(rescheduleSuccess != null)
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>${rescheduleSuccess}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
        </div>
    @endif
    @if(rescheduleError != null)
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>${rescheduleError}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
        </div>
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
                    <h2 class="modal-title">Detail Sesi</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <span class="fw-semibold text-gray-600">Sesi:</span>
                        <span id="detail_title"></span>
                    </div>
                    <div class="mb-3">
                        <span class="fw-semibold text-gray-600">Waktu terjadwal:</span>
                        <span id="detail_time"></span>
                    </div>
                    <div class="mb-3">
                        <span class="fw-semibold text-gray-600">Status:</span>
                        <span id="detail_status" class="badge"></span>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Tutup</button>
                    <button type="button" class="btn btn-warning" id="btn_open_staff_reschedule" style="display:none;">Jadwalkan Ulang</button>
                    <a href="#" id="btn_view_journal" class="btn btn-success" style="display:none;">Lihat Jurnal</a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    @template.components.staff-reschedule-modal(_csrf = _csrf, action = "/admin/schedule/reschedule")

    <link href="/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet">
    <script src="/plugins/custom/fullcalendar/fullcalendar.bundle.js"></script>
    <script src="/js/custom/reschedule-slot-picker.js"></script>
    <script src="/js/custom/staff-reschedule.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("kt_calendar");
            var detailsModal = new bootstrap.Modal(document.getElementById("kt_modal_session_details"));
            var staffReschedule = StaffReschedule.init({
                basePath: "/admin/schedule",
                detailsModal: detailsModal
            });
            var btnStaffReschedule = document.getElementById("btn_open_staff_reschedule");
            var btnViewJournal = document.getElementById("btn_view_journal");

            var statusBadgeClass = {
                SCHEDULED: "badge-light-primary",
                PENDING_REVIEW: "badge-light-warning",
                COMPLETED: "badge-light-success",
                NO_SHOW: "badge-light-dark",
                CANCELLED: "badge-light-danger",
                RESCHEDULED: "badge-light-warning"
            };
            var statusLabel = {
                SCHEDULED: "Dijadwalkan",
                PENDING_REVIEW: "Menunggu Konfirmasi",
                COMPLETED: "Tuntas",
                NO_SHOW: "Tidak Hadir",
                CANCELLED: "Dibatalkan",
                RESCHEDULED: "Reschedule"
            };

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
                events: "/admin/schedule/events",
                eventClick: function (info) {
                    var status = info.event.extendedProps.status;

                    // Server tells us if staff can still move this session (SCHEDULED, not from a previous day).
                    staffReschedule.bindButton(btnStaffReschedule, info.event);

                    document.getElementById("detail_title").innerText = info.event.title;
                    document.getElementById("detail_time").innerText =
                        info.event.start.toLocaleString() + " - " + info.event.end.toLocaleTimeString();

                    var badge = document.getElementById("detail_status");
                    badge.innerText = statusLabel[status] || status;
                    badge.className = "badge " + (statusBadgeClass[status] || "badge-light-secondary");

                    var journalId = info.event.extendedProps.journalId;
                    if (status === "COMPLETED" && journalId) {
                        btnViewJournal.style.display = "inline-block";
                        btnViewJournal.href = "/admin/journal/" + journalId;
                    } else {
                        btnViewJournal.style.display = "none";
                    }

                    detailsModal.show();
                }
            });

            calendar.render();
        });
    </script>
`
)