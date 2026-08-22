@import com.madania.management.entity.RescheduleRequest
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<RescheduleRequest> requests
@param String rescheduleError = null
@param String rescheduleSuccess = null

@template.layout.base(
title = "Reschedule Requests",
role = role,
_csrf = _csrf,
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
                    <th>Patient</th>
                    <th>Therapist</th>
                    <th>Current Time</th>
                    <th>Requested Time</th>
                    <th>Requested By</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </tr>
                </thead>
                <tbody>
                @if(requests != null && !requests.isEmpty())
                    @for(RescheduleRequest request : requests)
                        @template.pages.admin.reschedule.row(request = request, _csrf = _csrf)
                    @endfor
                @else
                    <tr><td colspan="7">No pending reschedule requests</td></tr>
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
                    <h2 class="modal-title">Confirm</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>
                <div class="modal-body" id="kt_modal_confirm_message"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="kt_modal_confirm_submit">Confirm</button>
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
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="kt_modal_confirm_submit">Confirm</button>
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