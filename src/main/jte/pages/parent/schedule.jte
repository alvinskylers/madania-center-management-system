@import com.madania.management.entity.Notification
@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import com.madania.management.entity.RescheduleRequest
@import com.madania.management.enums.RescheduleStatus
@import java.time.format.DateTimeFormatter
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<Patient> children
@param List<RescheduleRequest> myRescheduleRequests
@param String rescheduleError = null
@param String rescheduleSuccess = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Jadwal Terapi",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 mb-5">
        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted">Jadwal Terapi</li>
    </ul>
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Jadwal Anak Saya</h1>
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

    <div class="card mb-5">
        <div class="card-body p-3">
            <div class="d-flex gap-3 align-items-center flex-wrap">
                @for(Patient child : children)
                    <span class="d-flex align-items-center gap-2">
                            <span class="bullet bullet-dot bg-primary"></span>
                            <span class="fw-semibold">${child.getFullName()}</span>
                        </span>
                @endfor
            </div>
        </div>
    </div>

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
                <h2>Permohonan Reschedule Saya</h2>
            </div>
        </div>
        <div class="card-body pt-5">
            <div class="table-responsive">
                <table class="table align-middle table-row-dashed fs-6 gy-4">
                    <thead>
                    <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                        <th>Anak</th>
                        <th>Waktu Sesi</th>
                        <th>Waktu Reschedule</th>
                        <th>Alasan</th>
                        <th>Status</th>
                        <th>Catatan Admin</th>
                        <th>Pengajuan</th>
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
                                        <span class="badge badge-light-warning">Menunggu</span>
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
                                <div class="alert alert-info text-center mb-0">Anda belum mengajukan permintaan reschedule apa pun.</div>
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
                    <div class="alert alert-warning py-3 mb-0" id="detail_reschedule_hint" style="display:none;"></div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Tutup</button>
                    <a href="#" id="btn_view_journal" class="btn btn-success" style="display:none;">Lihat Jurnal</a>
                    <button type="button" class="btn btn-primary" id="btn_open_reschedule">Ajukan Reschedule</button>
                </div>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    <!--begin::Modal - Request Reschedule-->
    <div class="modal fade" id="kt_modal_request_reschedule" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <form method="post" action="/parent/schedule/reschedule" id="kt_reschedule_form" novalidate>
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                    <input type="hidden" name="sessionId" id="reschedule_session_id">

                    <div class="modal-header">
                        <h2 class="modal-title">Ajukan Reschedule</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                            <i class="ki-outline ki-cross fs-1"></i>
                        </div>
                    </div>

                    <div class="modal-body">
                        <div class="fs-6 text-gray-600 mb-5" id="reschedule_session_label"></div>

                        <!--begin::Therapist availability calendar-->
                        <div class="mb-5">
                            <div class="d-flex align-items-center mb-3">
                                <i class="ki-outline ki-calendar-8 fs-2 text-primary me-2"></i>
                                <span class="fw-semibold fs-6">Jadwal Terapis</span>
                            </div>
                            <div class="alert alert-primary d-flex align-items-center py-3 mb-3">
                                <i class="ki-outline ki-information-5 fs-2 me-3"></i>
                                <span class="fs-7">Gunakan kalender ini untuk melihat jadwal terapis sebelum memilih waktu baru, agar permohonan Anda lebih mudah disetujui.</span>
                            </div>
                            <div class="d-flex flex-wrap gap-4 mb-3 fs-8">
                                <div class="d-flex align-items-center">
                                    <span class="bullet bullet-dot me-2" style="background-color:#F1416C;"></span>Terisi
                                </div>
                                <div class="d-flex align-items-center">
                                    <span class="bullet bullet-dot me-2" style="background-color:#FFA800;"></span>Sesi ini (saat ini)
                                </div>
                                <div class="d-flex align-items-center">
                                    <span class="bullet bullet-dot me-2" style="background-color:#7239EA;"></span>Waktu baru (dipilih)
                                </div>
                            </div>
                            <div id="kt_reschedule_calendar"></div>
                            <div class="fs-8 mt-2 text-muted" id="reschedule_slot_hint"></div>
                        </div>
                        <!--end::Therapist availability calendar-->

                        <div class="fv-row mb-5">
                            <label class="fs-6 fw-semibold mb-2">Waktu baru yang diminta</label>
                            <input type="text" data-picker="datetime" class="form-control" name="requestedStartTime"
                                   id="reschedule_requested_time" required>
                            <div class="fv-plugins-message-container invalid-feedback d-block d-none" id="reschedule_time_feedback">
                                <i class="ki-outline ki-information-5 fs-7"></i>
                                Silakan pilih waktu reschedule terlebih dahulu sebelum mengirim permohonan.
                            </div>
                        </div>

                        <div class="fv-row mb-5">
                            <label class="fs-6 fw-semibold mb-2">Alasan</label>
                            <textarea class="form-control" name="reason" rows="3" placeholder="Mengapa Anda perlu menjadwalkan ulang sesi ini?"></textarea>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-primary">Ajukan Permohonan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    <style>
        /* empty time slots in the reschedule modal calendar are tappable */
        #kt_reschedule_calendar .fc-timegrid-col-frame { cursor: pointer; }
    </style>
    <link href="/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet">
    <script src="/plugins/custom/fullcalendar/fullcalendar.bundle.js"></script>
    <script src="/js/custom/reschedule-slot-picker.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("kt_calendar");
            var detailsModal = new bootstrap.Modal(document.getElementById("kt_modal_session_details"));
            var rescheduleModalEl = document.getElementById("kt_modal_request_reschedule");
            var rescheduleModal = new bootstrap.Modal(rescheduleModalEl);
            var btnOpenReschedule = document.getElementById("btn_open_reschedule");
            var btnViewJournal = document.getElementById("btn_view_journal");

            //begin::Reschedule modal - therapist availability calendar + validation
            var rescheduleForm = document.getElementById("kt_reschedule_form");
            var timeInput = document.getElementById("reschedule_requested_time");
            var timeFeedback = document.getElementById("reschedule_time_feedback");

            function markTimeInvalid(invalid) {
                timeInput.classList.toggle("is-invalid", invalid);
                var altInput = timeInput.nextElementSibling;
                if (altInput && altInput.classList.contains("flatpickr-alt-input")) {
                    altInput.classList.toggle("is-invalid", invalid);
                }
                timeFeedback.classList.toggle("d-none", !invalid);
            }

            timeInput.addEventListener("change", function () {
                if (timeInput.value && timeInput.value.trim() !== "") {
                    markTimeInvalid(false);
                }
            });

            rescheduleForm.addEventListener("submit", function (e) {
                if (!timeInput.value || timeInput.value.trim() === "") {
                    e.preventDefault();
                    e.stopPropagation();
                    markTimeInvalid(true);
                    var altInput = timeInput.nextElementSibling;
                    (altInput && altInput.classList.contains("flatpickr-alt-input") ? altInput : timeInput).focus();
                }
            });

            // Tap-a-slot helper (static/js/custom/reschedule-slot-picker.js). It reads the calendar lazily,
            // so it can be created before the calendar below exists.
            var slotPicker = RescheduleSlotPicker.create({
                timeInput: timeInput,
                sessionIdInput: document.getElementById("reschedule_session_id"),
                hintEl: document.getElementById("reschedule_slot_hint"),
                getCalendar: function () { return rescheduleCalendar; }
            });

            var rescheduleCalendar = new FullCalendar.Calendar(document.getElementById("kt_reschedule_calendar"), {
                initialView: "timeGridWeek",
                height: 380,
                headerToolbar: {
                    left: "prev,next today",
                    center: "title",
                    right: ""
                },
                slotMinTime: "07:00:00",
                slotMaxTime: "20:00:00",
                allDaySlot: false,
                businessHours: slotPicker.businessHours,
                dateClick: slotPicker.onDateClick,
                eventClick: slotPicker.onEventClick,
                events: []
            });
            rescheduleCalendar.render();

            rescheduleModalEl.addEventListener("shown.bs.modal", function () {
                rescheduleCalendar.updateSize();
            });
            //end::Reschedule modal - therapist availability calendar + validation

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
                events: "/parent/schedule/events",
                eventClick: function (info) {
                    var status = info.event.extendedProps.status;

                    document.getElementById("detail_title").innerText = info.event.title;
                    document.getElementById("detail_time").innerText =
                        info.event.start.toLocaleString() + " - " + info.event.end.toLocaleTimeString();

                    var badge = document.getElementById("detail_status");
                    badge.innerText = statusLabel[status] || status;
                    badge.className = "badge " + (statusBadgeClass[status] || "badge-light-secondary");

                    // Server tells us if the notice period has passed (see RescheduleNoticePolicy).
                    var rescheduleBlocked = status === "SCHEDULED" && info.event.extendedProps.canReschedule === false;
                    var rescheduleHint = document.getElementById("detail_reschedule_hint");
                    if (rescheduleBlocked) {
                        var deadline = info.event.extendedProps.rescheduleDeadline;
                        rescheduleHint.innerText = "Batas pengajuan reschedule untuk sesi ini sudah lewat" +
                            (deadline ? " (paling lambat " + new Date(deadline + "T00:00:00").toLocaleDateString() + ")" : "") +
                            ". Silakan hubungi klinik untuk bantuan.";
                        rescheduleHint.style.display = "block";
                    } else {
                        rescheduleHint.style.display = "none";
                    }

                    if (status === "SCHEDULED" && !rescheduleBlocked) {
                        btnOpenReschedule.style.display = "inline-block";
                        btnOpenReschedule.onclick = function () {
                            var sessionId = info.event.id;
                            document.getElementById("reschedule_session_id").value = sessionId;
                            document.getElementById("reschedule_session_label").innerText =
                                info.event.title + " — currently " + info.event.start.toLocaleString();

                            // reset validation state and empty time field from any previous attempt
                            timeInput.value = "";
                            if (timeInput._flatpickr) {
                                timeInput._flatpickr.clear();
                            }
                            markTimeInvalid(false);

                            // Resets the slot hint / highlight and applies the picker limits
                            // (no past days, not the current session date). The server still validates.
                            slotPicker.open(info.event.start);

                            // load this session's therapist schedule so the parent can pick a free slot
                            rescheduleCalendar.setOption("events", "/parent/schedule/therapist-events/" + sessionId);
                            rescheduleCalendar.gotoDate(info.event.start);

                            detailsModal.hide();
                            rescheduleModal.show();
                        };
                    } else {
                        btnOpenReschedule.style.display = "none";
                    }

                    var journalId = info.event.extendedProps.journalId;
                    if (status === "COMPLETED" && journalId) {
                        btnViewJournal.style.display = "inline-block";
                        btnViewJournal.href = "/parent/journal/" + journalId;
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