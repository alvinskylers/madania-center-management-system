@import com.madania.management.dto.PackageCreateRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import com.madania.management.entity.Patient
@import com.madania.management.entity.Therapist
@import org.springframework.validation.BindingResult
@import java.time.DayOfWeek
@import java.util.List
@import java.time.format.TextStyle
@import java.util.Locale

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param PackageCreateRequest request
@param List<Patient> patients
@param List<Therapist> therapists
@param List<DayOfWeek> days
@param String daysError = null
@param String scheduleError = null
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String selectedPatientId = request.getPatientId() != null ? String.valueOf(request.getPatientId()) : "";}
!{String selectedTherapistId = request.getTherapistId() != null ? String.valueOf(request.getTherapistId()) : "";}
!{String notesValue = request.getNotes() != null ? request.getNotes() : "";}

@template.layout.base(
title = "Create Therapy Package",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Buat Paket Terapi Baru</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/packages" class="text-muted text-hover-primary">Paket Terapi</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Buat Baru</li>
                    </ul>
                </div>
                <div class="align-items-center">
                    <a href="/admin/packages" class="btn btn-light h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-black-left fs-3"></i>Kembali ke Paket
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            @if(bindingResult != null && bindingResult.hasErrors())
                <div class="alert alert-danger d-flex flex-column alert-dismissible fade show" role="alert">
                    @for(var fieldError : bindingResult.getAllErrors())
                        <span>${fieldError.getDefaultMessage()}</span>
                    @endfor
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif
            @if(daysError != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <span>${daysError}</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif
            @if(scheduleError != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <span>${scheduleError}</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <div class="row g-7">
                <!--begin::Form column-->
                <div class="col-xl-8">
                    <div class="card card-flush">
                        <div class="card-header pt-7">
                            <div class="card-title">
                                <i class="ki-outline ki-calendar-add fs-1 text-primary me-2"></i>
                                <h2>Informasi Paket Terapi</h2>
                            </div>
                        </div>
                        <div class="card-body pt-5">
                            <form id="kt_package_create_form" class="form" action="/admin/package/create" method="post">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                                <!--begin::Patient & Therapist-->
                                <div class="row row-cols-1 row-cols-sm-2">
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Pasien</span>
                                                <span class="ms-1" data-bs-toggle="tooltip" title="Pilihlah pasien untuk paket terapi yang akan dibuat.">
                                                    <i class="ki-outline ki-information fs-7"></i>
                                                </span>
                                            </label>
                                            <select class="form-select form-select-solid" name="patientId" required>
                                                <option value="">Pilih pasien</option>
                                                @for(Patient patient : patients)
                                                    @if(selectedPatientId.equals(String.valueOf(patient.getId())))
                                                        <option value="${String.valueOf(patient.getId())}" selected>${patient.getFullName()}</option>
                                                    @else
                                                        <option value="${String.valueOf(patient.getId())}">${patient.getFullName()}</option>
                                                    @endif
                                                @endfor
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Terapis</span>
                                                <span class="ms-1" data-bs-toggle="tooltip" title="Pilihlah terapis yang akan ditetapkan kepada pasien.">
                                                    <i class="ki-outline ki-information fs-7"></i>
                                                </span>
                                            </label>
                                            <select class="form-select form-select-solid" name="therapistId" required>
                                                <option value="">Pilih terapis</option>
                                                @for(Therapist therapist : therapists)
                                                    @if(selectedTherapistId.equals(String.valueOf(therapist.getId())))
                                                        <option value="${String.valueOf(therapist.getId())}" selected>${therapist.getFullName()}</option>
                                                    @else
                                                        <option value="${String.valueOf(therapist.getId())}">${therapist.getFullName()}</option>
                                                    @endif
                                                @endfor
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Patient & Therapist-->

                                <!--begin::Start Date & Time-->
                                <div class="row row-cols-1 row-cols-sm-2">
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Tanggal Mulai</span>
                                                <span class="ms-1" data-bs-toggle="tooltip" title="Tanggal sesi pertama dimulai dari hari ini atau setelahnya.">
                                                    <i class="ki-outline ki-information fs-7"></i>
                                                </span>
                                            </label>
                                            <input type="date" class="form-control form-control-solid" name="startDate"
                                                   value="${request.getStartDate() != null ? request.getStartDate().toString() : ""}" required/>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Jam Sesi</span>
                                                <span class="ms-1" data-bs-toggle="tooltip" title="Setiap 12 sesi akan dijadwalkan di jam ini pada hari yang telah di pilih dengan durasi 1 jam.">
                                                    <i class="ki-outline ki-information fs-7"></i>
                                                </span>
                                            </label>
                                            <input type="time" class="form-control form-control-solid" name="preferredTime"
                                                   value="${request.getPreferredTime() != null ? request.getPreferredTime().toString() : ""}" required/>
                                        </div>
                                    </div>
                                </div>
                                <!--end::Start Date & Time-->

                                <!--begin::Days of week-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3 d-flex flex-column">
                                        <span class="required">Hari Sesi Terapi</span>
                                        <span class="fs-7 fw-normal text-muted mt-1">Pilihlah 3 hari perminggu. 12 sesi akan di dibuat secara otomatis.</span>
                                    </label>
                                    <div class="d-flex flex-wrap gap-3 mt-3" id="kt_package_days_group">
                                        @for(DayOfWeek day : days)
                                            @if(day != DayOfWeek.SATURDAY && day != DayOfWeek.SUNDAY)
                                                @if(request.getDays() != null && request.getDays().contains(day))
                                                    <input type="checkbox" class="btn-check package-day-checkbox" name="days" value="${day}" id="day_${day}" checked/>
                                                @else
                                                    <input type="checkbox" class="btn-check package-day-checkbox" name="days" value="${day}" id="day_${day}"/>
                                                @endif
                                                <label class="btn btn-outline btn-outline-dashed btn-outline-default px-6 py-3" for="day_${day}">
                                                    ${day.getDisplayName(TextStyle.FULL, new Locale("id", "ID"))}
                                                </label>
                                            @endif
                                        @endfor
                                    </div>
                                    <div class="fs-7 text-muted mt-2">
                                        Terpilih: <span id="kt_package_days_count">0</span> / 3
                                    </div>
                                </div>
                                <!--end::Days of week-->

                                <!--begin::Notes-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Catatan</span>
                                        <span class="ms-1" data-bs-toggle="tooltip" title="Catatan tambahan tentang paket terapi ini (Opsional).">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                    </label>
                                    <textarea class="form-control form-control-solid" name="notes" rows="3">${notesValue}</textarea>
                                </div>
                                <!--end::Notes-->

                                <div class="separator mb-6"></div>
                                <div class="d-flex justify-content-end">
                                    <a href="/admin/packages" class="btn btn-light me-3">Batalkan</a>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="indicator-label">Buat Paket</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <!--end::Form column-->

                <!--begin::Info column-->
                <div class="col-xl-4">
                    <div class="card card-flush bg-light-primary">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-4">
                                <i class="ki-outline ki-information-5 fs-1 text-primary me-3"></i>
                                <h3 class="text-gray-900 fs-5 fw-bold m-0">Cara Kerjanya</h3>
                            </div>
                            <ul class="text-gray-700 fs-6 ps-4 mb-0" style="list-style: disc;">
                                <li class="mb-3">Setiap paket berlangsung selama <strong>12 sesi</strong>, masing-masing berdurasi <strong>1 jam</strong>.</li>
                                <li class="mb-3">Sesi dibuat secara otomatis pada <strong>3 hari yang dipilih</strong> setiap minggunya, dimulai dari tanggal mulai.</li>
                                <li class="mb-3">Sistem memeriksa jadwal terapis untuk menghindari bentrok dan menolak sesi yang bertabrakan.</li>
                                <li class="mb-0">Seorang pasien tidak boleh memiliki dua paket aktif yang waktunya bertabrakan pada saat yang sama.</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!--end::Info column-->
            </div>

        </div>
    </div>
    <!--end::Content-->

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var checkboxes = document.querySelectorAll(".package-day-checkbox");
            var counter = document.getElementById("kt_package_days_count");

            function updateCount() {
                var checked = document.querySelectorAll(".package-day-checkbox:checked");
                counter.textContent = checked.length;

                checkboxes.forEach(function (cb) {
                    cb.disabled = checked.length >= 3 && !cb.checked;
                });
            }

            checkboxes.forEach(function (cb) {
                cb.addEventListener("change", updateCount);
            });

            updateCount();
        });
    </script>
`
)