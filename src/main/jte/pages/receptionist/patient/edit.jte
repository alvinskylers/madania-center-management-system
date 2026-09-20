@import com.madania.management.entity.Notification
@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import com.madania.management.enums.Gender
@import org.springframework.validation.BindingResult
@import java.util.List

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param User user
@param String role
@param Patient patient
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Ubah Pasien",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 mb-5">
        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted"><a href="/receptionist/patients" class="text-muted text-hover-primary">Pasien</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted">Ubah Pasien</li>
    </ul>

    @if(bindingResult != null && bindingResult.hasErrors())
        @for(var error : bindingResult.getAllErrors())
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <p>${error.getDefaultMessage()}</p>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
            </div>
        @endfor
    @endif

    <div class="container-fluid">
        <div class="row g-7">
            <div class="col-xl-12">
                <div class="card card-flush h-lg-100" id="kt_contacts_main">
                    <div class="card-header pt-7">
                        <div class="card-title">
                            <i class="ki-outline ki-badge fs-1 me-2"></i>
                            <h2>Ubah Informasi Pasien</h2>
                        </div>
                    </div>
                    <div class="card-body pt-5">
                        <div class="alert alert-light-info mb-7">
                            Halaman ini hanya untuk data dasar pasien. Diagnosis dan catatan klinis dikelola oleh terapis/admin.
                        </div>
                        <form id="kt_ecommerce_settings_general_form" class="form"
                              action="/receptionist/patient/${String.valueOf(patient.getId())}/edit" method="post"
                              enctype="multipart/form-data">
                            <input type="hidden" name="_csrf" value="${_csrf.getToken()}"/>
                            <!-- Name -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">
                                    <span class="required">Nama</span>
                                </label>
                                <input type="text" class="form-control form-control-solid" name="fullName" value="${patient.getFullName()}" />
                            </div>

                            <!-- Birth & Gender -->
                            <div class="row row-cols-1 row-cols-sm-2">
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span class="required">Tanggal Lahir</span>
                                        </label>
                                        <input type="text" data-picker="date" class="form-control form-control-solid" name="dateOfBirth" value="${patient.getDateOfBirth().toString()}" />
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span>Jenis Kelamin</span>
                                        </label>
                                        <select class="form-select form-select-solid" name="gender" data-control="select2" data-width="100%" data-hide-search="true">
                                            <option value="${patient.getGender()}">${patient.getGender()}</option>
                                            <option value="${Gender.MALE}">Laki-laki</option>
                                            <option value="${Gender.FEMALE}">Perempuan</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Status (Active / Inactive) -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">Status Pasien</label>
                                <div class="d-flex">
                                    @if(patient.isActive())
                                        <div class="form-check form-check-custom form-check-solid me-5">
                                            <input class="form-check-input" type="radio" name="isActive" value="true" checked/>
                                            <label class="form-check-label">Aktif</label>
                                        </div>
                                        <div class="form-check form-check-custom form-check-solid">
                                            <input class="form-check-input" type="radio" name="isActive" value="false"/>
                                            <label class="form-check-label">Tidak Aktif</label>
                                        </div>
                                    @else
                                        <div class="form-check form-check-custom form-check-solid me-5">
                                            <input class="form-check-input" type="radio" name="isActive" value="true"/>
                                            <label class="form-check-label">Aktif</label>
                                        </div>
                                        <div class="form-check form-check-custom form-check-solid">
                                            <input class="form-check-input" type="radio" name="isActive" value="false" checked/>
                                            <label class="form-check-label">Tidak Aktif</label>
                                        </div>
                                    @endif
                                </div>
                            </div>

                            <div class="separator mb-6"></div>
                            <div class="d-flex justify-content-end">
                                <a href="/receptionist/patients" class="btn btn-light me-3">Kembali</a>
                                <button type="submit" data-kt-contacts-type="submit" class="btn btn-primary">
                                    <span class="indicator-label">Simpan</span>
                                    <span class="indicator-progress">Memuat...
                                    <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
                                </span>
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
`)
