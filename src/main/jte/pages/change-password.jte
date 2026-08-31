@import com.madania.management.dto.ChangePasswordRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ChangePasswordRequest request
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Ubah Kata Sandi",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Ubah Kata Sandi</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/profile" class="text-muted text-hover-primary">Profil Saya</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Ubah Kata Sandi</li>
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
                        <div class="card-header pt-7">
                            <div class="card-title">
                                <i class="ki-outline ki-key fs-1 text-primary me-2"></i>
                                <h2>Perbarui Kata Sandi Anda</h2>
                            </div>
                        </div>
                        <div class="card-body pt-5">
                            <form action="/profile/password" method="post" class="form">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                                <!--begin::Current Password-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Kata Sandi Saat Ini</span>
                                    </label>
                                    <input type="password" name="currentPassword" class="form-control form-control-solid"
                                           placeholder="Masukkan kata sandi saat ini" required/>
                                </div>
                                <!--end::Current Password-->

                                <!--begin::New Password-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Kata Sandi Baru</span>
                                    </label>
                                    <input type="password" name="newPassword" class="form-control form-control-solid"
                                           placeholder="Masukkan kata sandi baru" required/>
                                </div>
                                <!--end::New Password-->

                                <!--begin::Confirm New Password-->
                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Konfirmasi Kata Sandi Baru</span>
                                    </label>
                                    <input type="password" name="confirmPassword" class="form-control form-control-solid"
                                           placeholder="Ulangi kata sandi baru" required/>
                                </div>
                                <!--end::Confirm New Password-->

                                <div class="separator mb-6"></div>
                                <div class="d-flex justify-content-end">
                                    <a href="/profile" class="btn btn-light me-3">Batal</a>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="indicator-label">Ubah Kata Sandi</span>
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