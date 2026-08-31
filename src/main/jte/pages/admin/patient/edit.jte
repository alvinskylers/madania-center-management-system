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
@param BindingResult bindingResult
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

    @if(bindingResult != null && bindingResult.hasErrors())
        @for(var error : bindingResult.getAllErrors())
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <p>${error.getDefaultMessage()}</p>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
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
                        <form id="kt_ecommerce_settings_general_form" class="form"
                              action="/admin/patient/${String.valueOf(patient.getId())}/edit" method="post"
                              enctype="multipart/form-data">
                            <input type="hidden" name="_csrf" value="${_csrf.getToken()}"/>
                            <!-- Name -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">
                                    <span class="required">Nama</span>
                                    <span class="ms-1" data-bs-toggle="tooltip" title="Ubah nama pasien">
                                    <i class="ki-outline ki-information fs-7"></i>
                                </span>
                                </label>
                                <input type="text" class="form-control form-control-solid" name="fullName" value="${patient.getFullName()}" />
                            </div>

                            <!-- Birth & Gender -->
                            <div class="row row-cols-1 row-cols-sm-2">
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span class="required">Tanggal Lahir</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Ubah tanggal lahir pasien.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                        </label>
                                        <input type="date" class="form-control form-control-solid" name="dateOfBirth" value="${patient.getDateOfBirth().toString()}" />
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span>Jenis Kelamin</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Ubah jenis kelamin pasien.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                        </label>
                                        <select class="form-control form-control-solid" name="gender">
                                            <option value="${patient.getGender()}">${patient.getGender()}</option>
                                            <option value="${Gender.MALE}">Male</option>
                                            <option value="${Gender.FEMALE}">Female</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Diagnosis  -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">
                                    <span>Diagnosis</span>
                                    <span class="ms-1" data-bs-toggle="tooltip" title="Ubah diagnosis pasien.">
                                    <i class="ki-outline ki-information fs-7"></i>
                                </span>
                                </label>
                                <input type="text" class="form-control form-control-solid" name="diagnosis" value="${patient.getDiagnosis()}" />
                            </div>

                            <!-- Notes -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">
                                    <span>Catatan</span>
                                    <span class="ms-1" data-bs-toggle="tooltip" title="Ubah catatan tambahan.">
                                    <i class="ki-outline ki-information fs-7"></i>
                                </span>
                                </label>
                                <textarea class="form-control form-control-solid" name="notes">${patient.getNotes()}</textarea>
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
                                <a href="/admin/patients" class="btn btn-light me-3">Kembali</a>
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