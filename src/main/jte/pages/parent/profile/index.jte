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
@param String success = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String initials = request.getUsername() != null && !request.getUsername().isBlank() ? request.getUsername().substring(0, 1).toUpperCase() : "?";}

@template.layout.base(
title = "Profil Saya",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Profil Saya</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/parent/dashboard" class="text-muted text-hover-primary">Beranda</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Profil Saya</li>
                    </ul>
                </div>
                <div class="d-flex align-items-center gap-2 gap-lg-3">
                    <a href="/profile/edit" class="btn btn-light-primary btn-sm">
                        <i class="ki-outline ki-pencil fs-4"></i>Edit Profil
                    </a>
                    <a href="/profile/password" class="btn btn-primary btn-sm">
                        <i class="ki-outline ki-key fs-4"></i>Ubah Kata Sandi
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            @if(success != null)
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>${success}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif
            @if(bindingResult != null && bindingResult.hasErrors())
                <div class="alert alert-danger d-flex flex-column alert-dismissible fade show" role="alert">
                    @for(var error : bindingResult.getAllErrors())
                        <span>${error.getDefaultMessage()}</span>
                    @endfor
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <div class="row g-7 justify-content-center">
                <div class="col-12 col-lg-8 col-xl-6">
                    <!--begin::Profile Card-->
                    <div class="card card-flush">
                        <div class="card-body">
                            <!--begin::Avatar + Name-->
                            <div class="d-flex flex-center flex-column py-8">
                                <div class="symbol symbol-100px symbol-circle mb-6">
                                    <span class="symbol-label bg-light-primary text-primary fs-1 fw-bold">${initials}</span>
                                </div>
                                <span class="fs-3 text-gray-800 fw-bold mb-2">${request.getUsername()}</span>
                                <span class="badge badge-lg badge-light-primary">Orang Tua / Wali</span>
                            </div>
                            <!--end::Avatar + Name-->

                            <div class="separator mb-8"></div>

                            <!--begin::Detail rows-->
                            <div class="d-flex flex-column gap-6">
                                <div class="d-flex align-items-center">
                                    <div class="symbol symbol-40px me-4">
                                        <span class="symbol-label bg-light-info">
                                            <i class="ki-outline ki-sms fs-2 text-info"></i>
                                        </span>
                                    </div>
                                    <div class="d-flex flex-column">
                                        <span class="fs-7 text-muted">Email</span>
                                        <a href="mailto:${request.getEmail()}" class="fs-6 fw-semibold text-gray-800 text-hover-primary">${request.getEmail()}</a>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center">
                                    <div class="symbol symbol-40px me-4">
                                        <span class="symbol-label bg-light-success">
                                            <i class="ki-outline ki-phone fs-2 text-success"></i>
                                        </span>
                                    </div>
                                    <div class="d-flex flex-column">
                                        <span class="fs-7 text-muted">Telepon</span>
                                        <span class="fs-6 fw-semibold text-gray-800">
                                            ${request.getPhone() != null && !request.getPhone().isEmpty() ? request.getPhone() : "Belum diisi"}
                                        </span>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center">
                                    <div class="symbol symbol-40px me-4">
                                        <span class="symbol-label bg-light-warning">
                                            <i class="ki-outline ki-geolocation fs-2 text-warning"></i>
                                        </span>
                                    </div>
                                    <div class="d-flex flex-column">
                                        <span class="fs-7 text-muted">Alamat</span>
                                        <span class="fs-6 fw-semibold text-gray-800">
                                            ${request.getAddress() != null && !request.getAddress().isEmpty() ? request.getAddress() : "Belum ditentukan"}
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <!--end::Detail rows-->
                        </div>
                    </div>
                    <!--end::Profile Card-->
                </div>
            </div>

        </div>
    </div>
    <!--end::Content-->
`
)