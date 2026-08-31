@import com.madania.management.entity.LeaveRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import com.madania.management.enums.LeaveStatus
@import java.time.format.DateTimeFormatter
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<LeaveRequest> requests
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null
@param String leaveError = null
@param String leaveSuccess = null

!{long pendingCount = requests == null ? 0 : requests.stream().filter(r -> r.getStatus() == LeaveStatus.PENDING).count();}
!{long approvedCount = requests == null ? 0 : requests.stream().filter(r -> r.getStatus() == LeaveStatus.APPROVED).count();}
!{long rejectedCount = requests == null ? 0 : requests.stream().filter(r -> r.getStatus() == LeaveStatus.REJECTED).count();}

@template.layout.base(
title = "Permohonan Cuti",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Permohonan Cuti Saya</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/therapist/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Permohonan Cuti</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            @if(leaveSuccess != null)
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>${leaveSuccess}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif
            @if(leaveError != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>${leaveError}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <!--begin::Summary Stats-->
            <div class="row g-5 g-xl-8 mb-6">
                <div class="col-sm-4">
                    <div class="card card-flush">
                        <div class="card-body d-flex align-items-center py-6">
                            <div class="symbol symbol-45px me-4">
                                <span class="symbol-label bg-light-warning">
                                    <i class="ki-outline ki-time fs-2x text-warning"></i>
                                </span>
                            </div>
                            <div>
                                <div class="fs-2 fw-bold text-gray-900">${pendingCount}</div>
                                <div class="fs-7 text-muted">Pending</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="card card-flush">
                        <div class="card-body d-flex align-items-center py-6">
                            <div class="symbol symbol-45px me-4">
                                <span class="symbol-label bg-light-success">
                                    <i class="ki-outline ki-check-circle fs-2x text-success"></i>
                                </span>
                            </div>
                            <div>
                                <div class="fs-2 fw-bold text-gray-900">${approvedCount}</div>
                                <div class="fs-7 text-muted">Disetujui</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="card card-flush">
                        <div class="card-body d-flex align-items-center py-6">
                            <div class="symbol symbol-45px me-4">
                                <span class="symbol-label bg-light-danger">
                                    <i class="ki-outline ki-cross-circle fs-2x text-danger"></i>
                                </span>
                            </div>
                            <div>
                                <div class="fs-2 fw-bold text-gray-900">${rejectedCount}</div>
                                <div class="fs-7 text-muted">Ditolak</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end::Summary Stats-->

            <div class="row g-7 mb-7">
                <!--begin::Request Form-->
                <div class="col-xl-7">
                    <div class="card card-flush h-100">
                        <div class="card-header pt-7">
                            <div class="card-title">
                                <i class="ki-outline ki-calendar-remove fs-1 text-primary me-2"></i>
                                <h2>Permohonan Cuti</h2>
                            </div>
                        </div>
                        <div class="card-body pt-5">
                            <form id="kt_leave_request_form" class="form" action="/therapist/leave" method="post">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                                <div class="row row-cols-1 row-cols-sm-2">
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Tanggal Mulai</span>
                                            </label>
                                            <input type="date" id="kt_leave_start_date" class="form-control form-control-solid" name="startDate" required/>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Tanggal Akhir</span>
                                            </label>
                                            <input type="date" id="kt_leave_end_date" class="form-control form-control-solid" name="endDate" required/>
                                        </div>
                                    </div>
                                </div>

                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Alasan</span>
                                        <span class="fs-7 fw-normal text-muted ms-2">Optional</span>
                                    </label>
                                    <textarea class="form-control form-control-solid" name="reason" rows="3"
                                              placeholder="e.g. Family event, medical leave"></textarea>
                                </div>

                                <div class="separator mb-6"></div>
                                <div class="d-flex justify-content-end">
                                    <button type="submit" class="btn btn-primary">
                                        <span class="indicator-label">Ajukan Permohonan Izin</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <!--end::Request Form-->

                <!--begin::Info column-->
                <div class="col-xl-5">
                    <div class="card card-flush bg-light-primary h-100">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-4">
                                <i class="ki-outline ki-information-5 fs-1 text-primary me-3"></i>
                                <h3 class="text-gray-900 fs-5 fw-bold m-0">Prosedur Permohonan Cuti</h3>
                            </div>
                            <ul class="text-gray-700 fs-6 ps-4 mb-0" style="list-style: disc;">
                                <li class="mb-3">Permintaan Anda akan ditinjau oleh tim admin sebelum disetujui.</li>
                                <li class="mb-3">Sesi terapi apa pun yang jatuh pada tanggal cuti Anda perlu dijadwalkan ulang setelah permintaan disetujui.</li>
                                <li class="mb-3">Mengajukan permintaan sedini mungkin memberikan pemberitahuan lebih awal kepada pasien jika ada sesi yang perlu diubah jadwalnya.</li>
                                <li class="mb-0">Anda akan melihat pembaruan status di bawah ini setelah admin meninjau permintaan Anda.</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!--end::Info column-->
            </div>

            <!--begin::History-->
            <div class="card card-flush">
                <div class="card-header pt-7">
                    <div class="card-title">
                        <h2>Request History</h2>
                    </div>
                </div>
                <div class="card-body pt-5">
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-4">
                            <thead>
                            <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                <th>Start</th>
                                <th>End</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th>Admin Notes</th>
                                <th>Submitted</th>
                            </tr>
                            </thead>
                            <tbody>
                            @if(requests != null && !requests.isEmpty())
                                @for(LeaveRequest r : requests)
                                    <tr>
                                        <td>${r.getStartDate().toString()}</td>
                                        <td>${r.getEndDate().toString()}</td>
                                        <td class="text-gray-700">${r.getReason() != null && !r.getReason().isBlank() ? r.getReason() : "—"}</td>
                                        <td>
                                            @if(r.getStatus() == LeaveStatus.PENDING)
                                                <span class="badge badge-light-warning">Pending</span>
                                            @elseif(r.getStatus() == LeaveStatus.APPROVED)
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
                                    <td colspan="6">
                                        <div class="alert alert-info text-center mb-0">You haven't submitted any leave requests yet.</div>
                                    </td>
                                </tr>
                            @endif
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!--end::History-->

        </div>
    </div>
    <!--end::Content-->

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var startInput = document.getElementById("kt_leave_start_date");
            var endInput = document.getElementById("kt_leave_end_date");
            var today = new Date().toISOString().split("T")[0];

            startInput.setAttribute("min", today);
            endInput.setAttribute("min", today);

            startInput.addEventListener("change", function () {
                endInput.setAttribute("min", startInput.value);
                if (endInput.value && endInput.value < startInput.value) {
                    endInput.value = startInput.value;
                }
            });
        });
    </script>
`
)