@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String action

<!--begin::Modal - Staff Reschedule-->
<div class="modal fade" id="kt_modal_staff_reschedule" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <form method="post" action="${action}" id="kt_staff_reschedule_form" novalidate>
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <input type="hidden" name="sessionId" id="staff_reschedule_session_id">

                <div class="modal-header">
                    <h2 class="modal-title">Jadwalkan Ulang Sesi</h2>
                    <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
                        <i class="ki-outline ki-cross fs-1"></i>
                    </div>
                </div>

                <div class="modal-body">
                    <div class="fs-6 text-gray-600 mb-4" id="staff_reschedule_session_label"></div>

                    <div class="alert alert-warning d-flex align-items-center py-3 mb-5">
                        <i class="ki-outline ki-information-5 fs-2 me-3"></i>
                        <span class="fs-7">
                            Perubahan berlaku langsung tanpa persetujuan dan tidak dibatasi aturan batas waktu pemberitahuan
                            untuk orang tua/terapis. Jam operasional dan bentrok jadwal terapis tetap diperiksa.
                            Orang tua dan terapis akan menerima notifikasi beserta alasannya.
                        </span>
                    </div>

                    <!--begin::Therapist availability calendar-->
                    <div class="mb-5">
                        <div class="d-flex align-items-center mb-3">
                            <i class="ki-outline ki-calendar-8 fs-2 text-primary me-2"></i>
                            <span class="fw-semibold fs-6">Jadwal Terapis</span>
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
                        <div id="kt_staff_reschedule_calendar"></div>
                        <div class="fs-8 mt-2 text-muted" id="staff_reschedule_slot_hint"></div>
                    </div>
                    <!--end::Therapist availability calendar-->

                    <div class="fv-row mb-5">
                        <label class="fs-6 fw-semibold mb-2 required">Waktu baru</label>
                        <input type="text" data-picker="datetime" class="form-control" name="requestedStartTime"
                               id="staff_reschedule_requested_time" required>
                        <div class="fv-plugins-message-container invalid-feedback d-block d-none" id="staff_reschedule_time_feedback">
                            <i class="ki-outline ki-information-5 fs-7"></i>
                            Silakan pilih waktu baru terlebih dahulu.
                        </div>
                    </div>

                    <div class="fv-row mb-2">
                        <label class="fs-6 fw-semibold mb-2 required">Alasan</label>
                        <textarea class="form-control" name="reason" id="staff_reschedule_reason" rows="3" maxlength="200" required
                                  placeholder="Contoh: Terapis mengalami kecelakaan, sesi dipindahkan sesuai telepon dari orang tua."></textarea>
                        <div class="fv-plugins-message-container invalid-feedback d-block d-none" id="staff_reschedule_reason_feedback">
                            <i class="ki-outline ki-information-5 fs-7"></i>
                            Alasan wajib diisi.
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning" id="staff_reschedule_submit">Jadwalkan Ulang</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!--end::Modal-->

<style>
    /* empty time slots in the reschedule modal calendar are tappable */
    #kt_staff_reschedule_calendar .fc-timegrid-col-frame { cursor: pointer; }
</style>
