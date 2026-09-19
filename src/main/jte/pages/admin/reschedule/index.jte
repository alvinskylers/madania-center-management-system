@import com.madania.management.entity.Notification
@import com.madania.management.entity.RescheduleRequest
@import com.madania.management.entity.User
@import com.madania.management.enums.RescheduleStatus
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<RescheduleRequest> requests
@param String rescheduleError = null
@param String rescheduleSuccess = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{long pendingCount = requests == null ? 0 : requests.stream().filter(r -> r.getStatus() == RescheduleStatus.PENDING).count();}
!{long approvedCount = requests == null ? 0 : requests.stream().filter(r -> r.getStatus() == RescheduleStatus.APPROVED).count();}
!{long rejectedCount = requests == null ? 0 : requests.stream().filter(r -> r.getStatus() == RescheduleStatus.REJECTED).count();}

@template.layout.base(
title = "Permintaan Reschedule",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Permintaan Reschedule</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Permintaan Reschedule</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

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
                        <h2>Permintaan Reschedule</h2>
                    </div>
                </div>
                <div class="card-body pt-5">
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-4">
                            <thead>
                            <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                <th>Pasien</th>
                                <th>Terapis</th>
                                <th>Tanggal Sesi</th>
                                <th>Tanggal Ganti</th>
                                <th>Pemohon</th>
                                <th>Alasan</th>
                                <th>Status</th>
                                <th class="text-end">Aksi</th>
                            </tr>
                            </thead>
                            <tbody>
                            @if(requests != null && !requests.isEmpty())
                                @for(RescheduleRequest request : requests)
                                    @template.pages.admin.reschedule.row(request = request, _csrf = _csrf)
                                @endfor
                            @else
                                <tr>
                                    <td colspan="8">
                                        <div class="alert alert-info text-center mb-0">Belum ada permohonan reschedule.</div>
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

    <!--begin::Modal - Confirm Action-->
    <div class="modal fade" id="kt_modal_confirm_action" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Konfirmasi</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>
                <div class="modal-body" id="kt_modal_confirm_message"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button>
                    <button type="button" class="btn btn-primary" id="kt_modal_confirm_submit">Konfirmasi</button>
                </div>
            </div>
        </div>
    </div>
    <!--end::Modal-->

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var confirmModal = new bootstrap.Modal(document.getElementById("kt_modal_confirm_action"));
            var confirmMessage = document.getElementById("kt_modal_confirm_message");
            var confirmSubmitBtn = document.getElementById("kt_modal_confirm_submit");
            var pendingFormId = null;

            document.querySelectorAll(".reschedule-confirm-btn").forEach(function (btn) {
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
