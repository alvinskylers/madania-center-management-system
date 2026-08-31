@import com.madania.management.entity.Notification
@import com.madania.management.entity.RescheduleRequest
@import com.madania.management.entity.User
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<RescheduleRequest> requests
@param String rescheduleError = null
@param String rescheduleSuccess = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Permohonan Reschedule",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Reschedule Requests</h1>
    </div>

    @if(rescheduleSuccess != null)
        <div class="alert alert-success"><p>${rescheduleSuccess}</p></div>
    @endif
    @if(rescheduleError != null)
        <div class="alert alert-danger"><p>${rescheduleError}</p></div>
    @endif

    <div class="card">
        <div class="card-body">
            <table class="table align-middle">
                <thead>
                <tr>
                <tr>
                    <th>Pasien</th>
                    <th>Terapis</th>
                    <th>Tanggal Sesi</th>
                    <th>Tanggal Ganti</th>
                    <th>Pemohon</th>
                    <th>Alasan</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
                </tr>
                </thead>
                <tbody>
                @if(requests != null && !requests.isEmpty())
                    @for(RescheduleRequest request : requests)
                        @template.pages.admin.reschedule.row(request = request, _csrf = _csrf)
                    @endfor
                @else
                    <tr><td colspan="7">Belum ada permohonan...</td></tr>
                @endif
                </tbody>
            </table>
        </div>
    </div>

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
                    <button type="button" class="btn btn-primary" id="kt_modal_confirm_submit">Izinkan</button>
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
)    <!--begin::Modal - Confirm Action-->
    <div class="modal fade" id="kt_modal_confirm_action" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Confirm</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>
                <div class="modal-body" id="kt_modal_confirm_message"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batalkan</button>
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