@import com.madania.management.dto.CheckupCreateRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.Patient
@import com.madania.management.entity.Therapist
@import com.madania.management.entity.User
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param CheckupCreateRequest request
@param List<Patient> patients
@param List<Therapist> therapists
@param String scheduleError = null
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String selectedPatientId = request.getPatientId() != null ? String.valueOf(request.getPatientId()) : "";}
!{String selectedTherapistId = request.getTherapistId() != null ? String.valueOf(request.getTherapistId()) : "";}
!{String notesValue = request.getNotes() != null ? request.getNotes() : "";}

@template.layout.base(
title = "Jadwalkan Checkup",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Jadwalkan Checkup Diagnosa</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/receptionist/checkups" class="text-muted text-hover-primary">Checkup Diagnosa</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Jadwalkan Baru</li>
                    </ul>
                </div>
                <div class="align-items-center">
                    <a href="/receptionist/checkups" class="btn btn-light h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-black-left fs-3"></i>Kembali
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            @if(bindingResult != null && bindingResult.hasErrors())
                <div class="alert alert-danger d-flex flex-column alert-dismissible fade show" role="alert">
                    @for(var fieldError : bindingResult.getAllErrors())
                        <span>${fieldError.getDefaultMessage()}</span>
                    @endfor
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
                </div>
            @endif
            @if(scheduleError != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <span>${scheduleError}</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
                </div>
            @endif

            <div class="row g-7">
                <div class="col-xl-8">
                    <div class="card card-flush">
                        <div class="card-header pt-7">
                            <div class="card-title">
                                <i class="ki-outline ki-calendar-add fs-1 text-primary me-2"></i>
                                <h2>Informasi Checkup</h2>
                            </div>
                        </div>
                        <div class="card-body pt-5">
                            <form id="kt_checkup_create_form" class="form" action="/receptionist/checkup/create" method="post">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                                <div class="row row-cols-1 row-cols-sm-2">
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Pasien</span>
                                            </label>
                                            <select class="form-select form-select-solid" name="patientId" required data-control="select2" data-width="100%">
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
                                            </label>
                                            <select class="form-select form-select-solid" name="therapistId" required data-control="select2" data-width="100%">
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

                                <div class="row row-cols-1 row-cols-sm-2">
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Tanggal</span>
                                            </label>
                                            <input type="date" class="form-control form-control-solid" name="date"
                                                   value="${request.getDate() != null ? request.getDate().toString() : ""}" required/>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Jam</span>
                                                <span class="ms-1" data-bs-toggle="tooltip" title="Checkup berdurasi 1 jam, dalam jam operasional klinik (08:00 - 17:00).">
                                                    <i class="ki-outline ki-information fs-7"></i>
                                                </span>
                                            </label>
                                            <input type="time" class="form-control form-control-solid" name="time"
                                                   value="${request.getTime() != null ? request.getTime().toString() : ""}" required/>
                                        </div>
                                    </div>
                                </div>

                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Catatan</span>
                                    </label>
                                    <textarea class="form-control form-control-solid" name="notes" rows="3">${notesValue}</textarea>
                                </div>

                                <div class="separator mb-6"></div>
                                <div class="d-flex justify-content-end">
                                    <a href="/receptionist/checkups" class="btn btn-light me-3">Batalkan</a>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="indicator-label">Jadwalkan Checkup</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4">
                    <div class="card card-flush bg-light-primary">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-4">
                                <i class="ki-outline ki-information-5 fs-1 text-primary me-3"></i>
                                <h3 class="text-gray-900 fs-5 fw-bold m-0">Alur Checkup</h3>
                            </div>
                            <ul class="text-gray-700 fs-6 ps-4 mb-0" style="list-style: disc;">
                                <li class="mb-3">Checkup berdurasi <strong>1 jam</strong> dan diperiksa agar tidak bentrok dengan jadwal terapis lainnya.</li>
                                <li class="mb-3">Setelah checkup berlangsung, catat hasil diagnosis dan keputusan wali di halaman detail checkup.</li>
                                <li class="mb-0">Jika wali memilih lanjut terapi, paket terapi baru dapat langsung dibuat dari halaman detail checkup dengan diagnosis yang sudah terisi.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
`
)
