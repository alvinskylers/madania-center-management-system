@import com.madania.management.entity.Notification
@import com.madania.management.entity.Therapist
@import com.madania.management.entity.TherapyPackage
@import com.madania.management.entity.TherapySession
@import com.madania.management.entity.User
@import java.time.format.DateTimeFormatter
@import java.util.List
@import java.time.format.TextStyle
@import java.util.Locale

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyPackage therapyPackage
@param List<TherapySession> sessions
@param List<Therapist> therapists = null
@param String success = null
@param String error = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String pkgId = String.valueOf(therapyPackage.getId());}
!{String status = therapyPackage.getStatus().name();}
!{int progressPercent = therapyPackage.getTotalSessions() > 0 ? (therapyPackage.getCompletedSessions() * 100 / therapyPackage.getTotalSessions()) : 0;}

@template.layout.base(
title = "Detail Paket Terapi",
role = role,
_csrf = _csrf,
user = user,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <!--begin::Page title-->
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Informasi Paket</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/packages" class="text-muted text-hover-primary">Paket Terapi</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${therapyPackage.getPatient().getFullName()}</li>
                    </ul>
                </div>
                <!--end::Page title-->
                <!--begin::Actions-->
                <div class="d-flex align-items-center gap-2 gap-lg-3">
                    @if(status.equals("ACTIVE"))
                        <button type="button" class="btn btn-light-primary" id="kt_package_reassign_btn"
                                data-bs-toggle="tooltip" title="Alihkan terapis untuk sesi yang tersisa">
                            <i class="ki-outline ki-arrow-right-left fs-4"></i>Alihkan Terapis
                        </button>
                        <button type="button" class="btn btn-light-danger" id="kt_package_cancel_btn"
                                data-bs-toggle="tooltip" title="Batalkan paket ini">
                            <i class="ki-outline ki-cross-circle fs-4"></i>Batalkan Paket
                        </button>
                    @endif
                </div>
                <!--end::Actions-->
            </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->

            @if(success != null)
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>${success}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
                </div>
            @endif
            @if(error != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>${error}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
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
                                <div class="fs-6 text-muted mb-3"> ${therapyPackage.getTherapist().getFullName()}</div>
                                @if(status.equals("ACTIVE"))
                                    <span class="badge badge-light-success fs-7">Aktif</span>
                                @elseif(status.equals("COMPLETED"))
                                    <span class="badge badge-light-primary fs-7">Tuntas</span>
                                @else
                                    <span class="badge badge-light-danger fs-7">Dibatalkan</span>
                                @endif
                            </div>
                            <!--end::Icon + Status-->

                            <div class="separator my-3"></div>

                            <!--begin::Progress-->
                            <div class="pb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="fw-semibold fs-7 text-gray-700">Progress Paket Terapi</span>
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
                                <div class="fw-bold mt-5">Jenis Paket</div>
                                <div class="text-gray-600">${therapyPackage.getPackageType() != null ? therapyPackage.getPackageType().getName() : "—"}</div>

                                <div class="fw-bold mt-5">Tanggal Mulai</div>
                                <div class="text-gray-600">${therapyPackage.getStartDate() != null ? therapyPackage.getStartDate().toString() : "—"}</div>

                                <div class="fw-bold mt-5">Tanggal Berakhir</div>
                                <div class="text-gray-600">${therapyPackage.getEndDate() != null ? therapyPackage.getEndDate().toString() : "—"}</div>

                                <div class="fw-bold mt-5">Waktu Sesi</div>
                                <div class="text-gray-600">${therapyPackage.getSessionTime() != null ? therapyPackage.getSessionTime().toString() : "—"}</div>

                                <div class="fw-bold mt-5">Dibuat Oleh</div>
                                <div class="text-gray-600">${therapyPackage.getCreatedBy() != null ? therapyPackage.getCreatedBy().getEmail() : "—"}</div>

                                <div class="fw-bold mt-5">Dibuat pada</div>
                                <div class="text-gray-600">${therapyPackage.getCreatedAt() != null ? therapyPackage.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a")) : "—"}</div>

                                <div class="fw-bold mt-5">Diagnosis</div>
                                <div class="text-gray-600">${therapyPackage.getDiagnosis() != null && !therapyPackage.getDiagnosis().isBlank() ? therapyPackage.getDiagnosis() : "—"}</div>

                                @if(therapyPackage.getNotes() != null && !therapyPackage.getNotes().isBlank())
                                    <div class="fw-bold mt-5">Catatan</div>
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
                                <h2 class="mb-1">Sesi Terapi</h2>
                                <div class="fs-6 fw-semibold text-muted">Setiap ${therapyPackage.getTotalSessions()} sesi yang terjadwal untuk paket ini</div>
                            </div>
                        </div>
                        <div class="card-body pt-0">
                            <div class="table-responsive">
                                <table class="table align-middle table-row-dashed fs-6 gy-4">
                                    <thead>
                                    <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                        <th>#</th>
                                        <th>Tanggal</th>
                                        <th>Hari</th>
                                        <th>Jam</th>
                                        <th>Status</th>
                                        <th>Catatan</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @if(sessions != null && !sessions.isEmpty())
                                        @for(TherapySession session : sessions)
                                            <tr>
                                                <td>${session.getSessionNumber()}</td>
                                                <td>${session.getStartTime().toLocalDate().toString()}</td>
                                                <td>${session.getDay().getDisplayName(TextStyle.FULL, new Locale("id", "ID"))}</td>
                                                <td>${session.getStartTime().toLocalTime().toString()} - ${session.getEndTime().toLocalTime().toString()}</td>
                                                <td>
                                                    @if(session.getStatus().name().equals("SCHEDULED"))
                                                        <span class="badge badge-light-primary">Dijadwalkan</span>
                                                    @elseif(session.getStatus().name().equals("COMPLETED"))
                                                        <span class="badge badge-light-success">Tuntas</span>
                                                    @elseif(session.getStatus().name().equals("CANCELLED"))
                                                        <span class="badge badge-light-danger">Dibatalkan</span>
                                                    @else
                                                        <span class="badge badge-light-warning">Reschedule</span>
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
                                                <div class="alert alert-info text-center mb-0">Tidak ada sesi untuk paket ini.</div>
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
    <!--end::Content-->

    <!--begin::Modal - Confirm Cancel Package-->
    <div class="modal fade" id="kt_package_cancel_modal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Batalkan Paket</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>
                <div class="modal-body">
                    Apakah anda yakin untuk membatalkan paket untuk ananda
                    <strong>${therapyPackage.getPatient().getFullName()}</strong>?
                    Sisa sesi yang <strong>terjadwalkan</strong> pada paket ini akan di batalkan.
                    <strong>Aksi ini bersifat permanen.</strong>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Kembali</button>
                    <form action="/admin/package/${pkgId}/cancel" method="post">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                        <button type="submit" class="btn btn-danger">Ya, Batalkan Paket</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    <!--begin::Modal - Reassign Therapist-->
    @if(status.equals("ACTIVE") && therapists != null)
        <div class="modal fade" id="kt_package_reassign_modal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2 class="modal-title">Alihkan Terapis</h2>
                        <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                            <i class="ki-outline ki-cross fs-1"></i>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div id="reassign_alert_area"></div>
                        <div class="text-muted fs-7 mb-4">
                            Sesi yang sudah <strong>Tuntas</strong>, <strong>Dibatalkan</strong>, atau sudah di-reschedule
                            akan tetap tercatat pada <strong>${therapyPackage.getTherapist().getFullName()}</strong>.
                            Hanya sesi yang masih <strong>Dijadwalkan</strong> yang akan dipindahkan.
                        </div>

                        <div class="row g-4 mb-4">
                            <div class="col-md-7">
                                <label class="form-label fw-bold">Terapis Baru</label>
                                <select class="form-select" id="reassign_new_therapist" data-control="select2" data-width="100%" data-dropdown-parent="#kt_package_reassign_modal">
                                    <option value="">-- Pilih terapis --</option>
                                    @for(Therapist t : therapists)
                                        @if(!t.getId().equals(therapyPackage.getTherapist().getId()))
                                            <option value="${String.valueOf(t.getId())}">${t.getFullName()}</option>
                                        @endif
                                    @endfor
                                </select>
                            </div>
                            <div class="col-md-5 d-flex align-items-end">
                                <button type="button" class="btn btn-light-primary w-100" id="reassign_check_btn">Cek Jadwal</button>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Alasan (opsional)</label>
                            <input type="text" class="form-control" id="reassign_reason" placeholder="mis. Terapis A mengundurkan diri">
                        </div>

                        <div id="reassign_sessions_area"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Kembali</button>
                        <button type="button" class="btn btn-primary" id="reassign_confirm_btn" disabled>Konfirmasi Pengalihan</button>
                    </div>
                </div>
            </div>
        </div>
    @endif
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

            var reassignBtn = document.getElementById("kt_package_reassign_btn");
            var reassignModalEl = document.getElementById("kt_package_reassign_modal");
            if (!reassignBtn || !reassignModalEl) return;

            var reassignModal = new bootstrap.Modal(reassignModalEl);
            reassignBtn.addEventListener("click", function () { reassignModal.show(); });

            var packageId = "${pkgId}";
            var reassignPrefix = "/admin";
            var csrfHeader = "${_csrf.getHeaderName()}";
            var csrfToken = "${_csrf.getToken()}";

            var checkBtn = document.getElementById("reassign_check_btn");
            var confirmBtn = document.getElementById("reassign_confirm_btn");
            var therapistSelect = document.getElementById("reassign_new_therapist");
            var reasonInput = document.getElementById("reassign_reason");
            var sessionsArea = document.getElementById("reassign_sessions_area");
            var alertArea = document.getElementById("reassign_alert_area");

            var overrides = {};

            function showAlert(message, type) {
                alertArea.innerHTML = '<div class="alert alert-' + type + '">' + message + '</div>';
            }
            function clearAlert() { alertArea.innerHTML = ""; }
            function overridesArray() {
                return Object.keys(overrides).map(function (sid) {
                    return { sessionId: sid, newStartTime: overrides[sid] };
                });
            }

            function runCheck() {
                var newTherapistId = therapistSelect.value;
                if (!newTherapistId) {
                    showAlert("Silakan pilih terapis terlebih dahulu.", "warning");
                    return;
                }
                clearAlert();
                confirmBtn.disabled = true;
                sessionsArea.innerHTML = '<div class="text-muted">Memeriksa jadwal...</div>';

                fetch(reassignPrefix + "/package/" + packageId + "/reassign/conflicts", {
                    method: "POST",
                    headers: { "Content-Type": "application/json", [csrfHeader]: csrfToken },
                    body: JSON.stringify({ newTherapistId: newTherapistId, overrides: overridesArray() })
                })
                .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
                .then(function (result) {
                    if (!result.ok) {
                        showAlert(result.body.error || "Gagal memeriksa jadwal.", "danger");
                        sessionsArea.innerHTML = "";
                        return;
                    }
                    renderSessions(result.body);
                })
                .catch(function () { showAlert("Terjadi kesalahan jaringan.", "danger"); });
            }

            function renderSessions(data) {
                if (!data.sessions || data.sessions.length === 0) {
                    sessionsArea.innerHTML = '<div class="alert alert-info">Tidak ada sesi terjadwal tersisa pada paket ini.</div>';
                    confirmBtn.disabled = false;
                    return;
                }

                var html = '<div class="table-responsive"><table class="table table-row-dashed align-middle fs-7">';
                html += '<thead><tr class="text-muted text-uppercase fs-8"><th>#</th><th>Waktu</th><th>Konflik</th><th></th></tr></thead><tbody>';

                data.sessions.forEach(function (s) {
                    var inputValue = s.startTime.substring(0, 16);
                    var hasConflict = s.conflicts && s.conflicts.length > 0;

                    html += '<tr class="' + (hasConflict ? "table-danger" : "") + '">';
                    html += '<td>' + s.sessionNumber + '</td>';
                    html += '<td><input type="text" data-picker="datetime" class="form-control form-control-sm reassign-time-input" data-session-id="' + s.sessionId + '" value="' + inputValue + '"></td>';
                    html += '<td>';
                    if (hasConflict) {
                        s.conflicts.forEach(function (c) {
                            html += '<div class="text-danger">' + c.patientName + ' &mdash; ' + c.startTime.replace("T", " ") + '</div>';
                        });
                    } else {
                        html += '<span class="text-success">Tidak ada konflik</span>';
                    }
                    html += '</td><td>';
                    if (hasConflict) {
                        html += '<button type="button" class="btn btn-sm btn-light-primary reassign-recheck-btn" data-session-id="' + s.sessionId + '">Cek Ulang</button>';
                    }
                    html += '</td></tr>';
                });

                html += '</tbody></table></div>';
                sessionsArea.innerHTML = html;
                window.initPickers(sessionsArea);

                document.querySelectorAll(".reassign-recheck-btn").forEach(function (btn) {
                    btn.addEventListener("click", function () {
                        var sessionId = btn.getAttribute("data-session-id");
                        var input = document.querySelector('.reassign-time-input[data-session-id="' + sessionId + '"]');
                        overrides[sessionId] = input.value + ":00";
                        runCheck();
                    });
                });

                confirmBtn.disabled = data.hasConflicts;
                if (data.hasConflicts) {
                    showAlert("Beberapa sesi masih memiliki konflik jadwal. Sesuaikan waktu lalu klik \"Cek Ulang\".", "warning");
                } else {
                    clearAlert();
                }
            }

            checkBtn.addEventListener("click", runCheck);
            $(therapistSelect).on("change", function () {
                overrides = {};
                sessionsArea.innerHTML = "";
                confirmBtn.disabled = true;
                clearAlert();
            });

            confirmBtn.addEventListener("click", function () {
                var newTherapistId = therapistSelect.value;
                if (!newTherapistId) return;
                confirmBtn.disabled = true;

                fetch(reassignPrefix + "/package/" + packageId + "/reassign", {
                    method: "POST",
                    headers: { "Content-Type": "application/json", [csrfHeader]: csrfToken },
                    body: JSON.stringify({
                        newTherapistId: newTherapistId,
                        reason: reasonInput.value,
                        overrides: overridesArray()
                    })
                })
                .then(function (res) { return res.json().then(function (body) { return { ok: res.ok, body: body }; }); })
                .then(function (result) {
                    if (!result.ok) {
                        showAlert(result.body.error || "Gagal mengalihkan terapis.", "danger");
                        confirmBtn.disabled = false;
                        return;
                    }
                    window.location.href = result.body.redirectUrl + "?success=" + encodeURIComponent("Terapis berhasil dialihkan.");
                })
                .catch(function () {
                    showAlert("Terjadi kesalahan jaringan.", "danger");
                    confirmBtn.disabled = false;
                });
            });
        });
    </script>
`
)