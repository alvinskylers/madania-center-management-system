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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Permohonan Cuti</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
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
                                <div class="fs-7 text-muted">Menunggu Hasil</div>
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

            <!--begin::Requests Table-->
            <div class="card card-flush">
                <div class="card-header pt-7">
                    <div class="card-title">
                        <h2>Permohonan Cuti</h2>
                    </div>
                </div>
                <div class="card-body pt-5">
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-4">
                            <thead>
                            <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                <th>Terapis</th>
                                <th>Rentang Cuti</th>
                                <th>Alasan</th>
                                <th>Status</th>
                                <th>Diajukan</th>
                                <th>Aksi</th>
                            </tr>
                            </thead>
                            <tbody>
                            @if(requests != null && !requests.isEmpty())
                                @for(LeaveRequest r : requests)
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="symbol symbol-35px symbol-circle me-3">
                                                    <span class="symbol-label bg-light-primary text-primary fw-bold">
                                                        ${r.getTherapist().getFullName().substring(0, 1).toUpperCase()}
                                                    </span>
                                                </div>
                                                <span class="text-gray-800 fw-semibold">${r.getTherapist().getFullName()}</span>
                                            </div>
                                        </td>
                                        <td>${r.getStartDate().toString()} &rarr; ${r.getEndDate().toString()}</td>
                                        <td class="text-gray-700">${r.getReason() != null && !r.getReason().isBlank() ? r.getReason() : "—"}</td>
                                        <td>
                                            @if(r.getStatus() == LeaveStatus.PENDING)
                                                    <span class="badge badge-light-warning">Pending</span>
                                            @elseif(r.getStatus() == LeaveStatus.APPROVED)
                                                <span class="badge badge-light-success">Disetujui</span>
                                            @else
                                                <span class="badge badge-light-danger">Ditolak</span>
                                            @endif
                                        </td>
                                        <td class="text-muted fs-7">
                                            ${r.getCreatedAt() != null ? r.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy")) : "—"}
                                        </td>
                                        <td class="text-end">
                                            @if(r.getStatus() == LeaveStatus.PENDING)
                                                <a href="/admin/leaves/${String.valueOf(r.getId())}" class="btn btn-primary btn-sm">
                                                    <i class="ki-outline ki-eye fs-4"></i>Review
                                                </a>
                                            @else
                                                <a href="/admin/leaves/${String.valueOf(r.getId())}" class="btn btn-light btn-sm">
                                                    <i class="ki-outline ki-eye fs-4"></i>View
                                                </a>
                                            @endif
                                        </td>
                                    </tr>
                                @endfor
                            @else
                                <tr>
                                    <td colspan="6">
                                        <div class="alert alert-info text-center mb-0">Belum ada permohonan cuti.</div>
                                    </td>
                                </tr>
                            @endif
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!--end::Requests Table-->

        </div>
    </div>
    <!--end::Content-->
`
)
