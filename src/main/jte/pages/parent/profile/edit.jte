@import com.madania.management.dto.ProfileUpdateRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ProfileUpdateRequest request
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String initials = request.getUsername() != null && !request.getUsername().isBlank() ? request.getUsername().substring(0, 1).toUpperCase() : "?";}

@template.layout.base(
title = "Edit Profil",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Edit Profil</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/parent/dashboard" class="text-muted text-hover-primary">Beranda</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/profile" class="text-muted text-hover-primary">Profil Saya</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Edit</li>
                    </ul>
                </div>
                <div class="align-items-center">
                    <a href="/profile" class="btn btn-light h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-black-left fs-3"></i>Kembali ke Profil
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
                    @for(var error : bindingResult.getAllErrors())
                        <span>${error.getDefaultMessage()}</span>
                    @endfor
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <div class="row g-7 justify-content-center">
                <!--begin::Form column-->
                <div class="col-12 col-lg-8 col-xl-6">
                    <div class="card card-flush">
                        <div class="card-body pt-9">
                            <!--begin::Avatar-->
                            <div class="d-flex flex-center flex-column py-5 mb-5">
                                <div class="symbol symbol-90px symbol-circle mb-4">
                                    <span class="symbol-label bg-light-primary text-primary fs-2 fw-bold">${initials}</span>
                                </div>
                                <span class="badge badge-lg badge-light-primary">Orang Tua / Wali</span>
                            </div>
                            <!--end::Avatar-->

                            <div class="separator mb-8"></div>

                            <form action="/profile/edit" method="post" class="form">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}" />

                                <!--begin::Full Name-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Nama Lengkap</span>
                                    </label>
                                    <input type="text" class="form-control form-control-solid"
                                           name="username" value="${request.getUsername()}"
                                           placeholder="Masukkan nama lengkap" required/>
                                </div>
                                <!--end::Full Name-->

                                <!--begin::Email-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Email</span>
                                    </label>
                                    <input type="email" class="form-control form-control-solid"
                                           name="email" value="${request.getEmail()}"
                                           placeholder="Masukkan alamat email" required/>
                                </div>
                                <!--end::Email-->

                                <!--begin::Phone-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Telepon</span>
                                        <span class="fs-7 fw-normal text-muted ms-2">Opsional</span>
                                    </label>
                                    <input type="tel" class="form-control form-control-solid"
                                           name="phone" value="${request.getPhone() != null ? request.getPhone() : ""}"
                                           placeholder="Masukkan nomor telepon"/>
                                </div>
                                <!--end::Phone-->

                                <!--begin::Address-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span>Alamat</span>
                                        <span class="fs-7 fw-normal text-muted ms-2">Opsional</span>
                                    </label>
                                    <input type="text" class="form-control form-control-solid"
                                           name="address" value="${request.getAddress() != null ? request.getAddress() : ""}"
                                           placeholder="Masukkan alamat"/>
                                </div>
                                <!--end::Address-->

                                <div class="separator mb-6"></div>
                                <div class="d-flex justify-content-end">
                                    <a href="/profile" class="btn btn-light me-3">Batal</a>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="indicator-label">Simpan Perubahan</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <!--end::Form column-->
            </div>

        </div>
    </div>
    <!--end::Content-->
`
)