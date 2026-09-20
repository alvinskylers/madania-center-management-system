@import com.madania.management.dto.PatientRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.Parent
@import com.madania.management.entity.User
@import com.madania.management.enums.Gender
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param PatientRequest request
@param List<Parent> parents
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Tambahkan Pasien",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 mb-5">
        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted"><a href="/admin/patients" class="text-muted text-hover-primary">Pasien</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted">Tambah Pasien</li>
    </ul>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger d-flex align-items-center" role="alert">
            <i class="ki-outline ki-information-5 fs-2 me-3"></i>
            <span>Beberapa isian belum sesuai. Silakan periksa kembali kolom yang ditandai di bawah.</span>
        </div>
    @endif

    <div class="container-fluid">
        <div class="row g-7">
            <div class="col-xl-12">
                <div class="card card-flush h-lg-100" id="kt_contacts_main">
                    <div class="card-header pt-7">
                        <div class="card-title">
                            <i class="ki-outline ki-badge fs-1 me-2"></i>
                            <h2>Tambahkan Pasien</h2>
                        </div>
                    </div>
                    <div class="card-body pt-5">
                        <form id="kt_ecommerce_settings_general_form" class="form"
                              action="/admin/patient/create" method="post"
                              enctype="multipart/form-data">
                            <input type="hidden" name="_csrf" value="${_csrf.getToken()}"/>
                            <!-- Name -->
                            <div class="row row-cols-1 row-cols-sm-2">
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span class="required">Nama</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Masukkan nama pasien.">
                                                <i class="ki-outline ki-information fs-7"></i>
                                            </span>
                                        </label>
                                        <input type="text" class="form-control form-control-solid ${bindingResult != null && bindingResult.hasFieldErrors("fullName") ? "is-invalid" : ""}" name="fullName" value="${request.getFullName() != null ? request.getFullName() : ""}" />
                                        @if(bindingResult != null && bindingResult.hasFieldErrors("fullName"))
                                            <div class="fv-plugins-message-container invalid-feedback d-block">${bindingResult.getFieldError("fullName").getDefaultMessage()}</div>
                                        @endif
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span>Wali Pasien</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Pilihlah wali pasien.">
                                                <i class="ki-outline ki-information fs-7"></i>
                                            </span>
                                        </label>
                                        <select class="form-select form-select-solid" name="parentId" data-control="select2" data-width="100%">
                                            <option value="">Pilih wali pasien</option>
                                            @for(Parent parent : parents)
                                                <option value="${String.valueOf(parent.getId())}" selected="${request.getParentId() != null && request.getParentId().equals(parent.getId())}">${parent.getFullName()}</option>
                                            @endfor
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Birth & Gender -->
                            <div class="row row-cols-1 row-cols-sm-2">
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span class="required">Tanggal Lahir</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Masukkan tanggal lahir pasien.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                        </label>
                                        <input type="text" data-picker="date" class="form-control form-control-solid ${bindingResult != null && bindingResult.hasFieldErrors("dateOfBirth") ? "is-invalid" : ""}" name="dateOfBirth" value="${request.getDateOfBirth() != null ? request.getDateOfBirth().toString() : ""}" />
                                        @if(bindingResult != null && bindingResult.hasFieldErrors("dateOfBirth"))
                                            <div class="fv-plugins-message-container invalid-feedback d-block">${bindingResult.getFieldError("dateOfBirth").getDefaultMessage()}</div>
                                        @endif
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span>Jenis Kelamin</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Pilihlah jenis kelamin pasien">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                        </label>
                                        <select class="form-select form-select-solid ${bindingResult != null && bindingResult.hasFieldErrors("gender") ? "is-invalid" : ""}" name="gender" data-control="select2" data-width="100%" data-hide-search="true">
                                            <option value="">Pilih jenis kelamin pasien</option>
                                            <option value="${Gender.MALE}" selected="${request.getGender() == Gender.MALE}">Laki-laki</option>
                                            <option value="${Gender.FEMALE}" selected="${request.getGender() == Gender.FEMALE}">Perempuan</option>
                                        </select>
                                        @if(bindingResult != null && bindingResult.hasFieldErrors("gender"))
                                            <div class="fv-plugins-message-container invalid-feedback d-block">${bindingResult.getFieldError("gender").getDefaultMessage()}</div>
                                        @endif
                                    </div>
                                </div>
                            </div>

                            <!-- Diagnosis  -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">
                                    <span>Diagnosis</span>
                                    <span class="ms-1" data-bs-toggle="tooltip" title="Masukkan diagnosis pasien">
                                    <i class="ki-outline ki-information fs-7"></i>
                                </span>
                                </label>
                                <input type="text" class="form-control form-control-solid" name="diagnosis" value="${request.getDiagnosis() != null ? request.getDiagnosis() : ""}" />
                            </div>

                            <!-- Notes -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">
                                    <span>Catatan</span>
                                    <span class="ms-1" data-bs-toggle="tooltip" title="Masukkan catatan tambahan (opsional).">
                                    <i class="ki-outline ki-information fs-7"></i>
                                </span>
                                </label>
                                <textarea class="form-control form-control-solid" name="notes">${request.getNotes() != null ? request.getNotes() : ""}</textarea>
                            </div>

                            <div class="separator mb-6"></div>
                            <div class="d-flex justify-content-end">
                                <a href="/admin/patients" class="btn btn-light me-3">Batal</a>
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

`
)