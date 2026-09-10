@import com.madania.management.dto.PackageTypeCreateRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import org.springframework.security.web.csrf.CsrfToken
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param CsrfToken _csrf
@param PackageTypeCreateRequest request
@param String formError = null
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String nameValue = request.getName() != null ? request.getName() : "";}
!{String totalSessionsValue = request.getTotalSessions() != null ? String.valueOf(request.getTotalSessions()) : "";}
!{String sessionsPerWeekValue = request.getSessionsPerWeek() != null ? String.valueOf(request.getSessionsPerWeek()) : "";}

@template.layout.base(
title = "Tambah Jenis Paket",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Tambah Jenis Paket</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/package-types" class="text-muted text-hover-primary">Jenis Paket</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Tambah Baru</li>
                    </ul>
                </div>
                <div class="align-items-center">
                    <a href="/admin/package-types" class="btn btn-light h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-black-left fs-3"></i>Kembali
                    </a>
                </div>
            </div>
        </div>
    </div>

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
            @if(formError != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <span>${formError}</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <div class="row g-7">
                <div class="col-xl-8">
                    <div class="card card-flush">
                        <div class="card-header pt-7">
                            <div class="card-title">
                                <i class="ki-outline ki-parcel fs-1 text-primary me-2"></i>
                                <h2>Informasi Jenis Paket</h2>
                            </div>
                        </div>
                        <div class="card-body pt-5">
                            <form class="form" action="/admin/package-type/create" method="post">
                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                                <div class="fv-row mb-7">
                                    <label class="fs-6 fw-semibold form-label mt-3">
                                        <span class="required">Nama Jenis Paket</span>
                                        <span class="ms-1" data-bs-toggle="tooltip" title="Nama yang akan tampil saat admin memilih jenis paket, contoh: Paket Reguler.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                    </label>
                                    <input type="text" class="form-control form-control-solid" name="name"
                                           placeholder="cth. Paket Reguler" value="${nameValue}" required/>
                                </div>

                                <div class="row row-cols-1 row-cols-sm-2">
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Total Sesi</span>
                                                <span class="ms-1" data-bs-toggle="tooltip" title="Total jumlah sesi dalam satu paket ini secara keseluruhan.">
                                                    <i class="ki-outline ki-information fs-7"></i>
                                                </span>
                                            </label>
                                            <input type="number" min="1" class="form-control form-control-solid" name="totalSessions"
                                                   value="${totalSessionsValue}" required/>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="fv-row mb-7">
                                            <label class="fs-6 fw-semibold form-label mt-3">
                                                <span class="required">Sesi per Minggu</span>
                                                <span class="ms-1" data-bs-toggle="tooltip" title="Berapa kali sesi berlangsung setiap minggunya. Total Sesi harus habis dibagi angka ini.">
                                                    <i class="ki-outline ki-information fs-7"></i>
                                                </span>
                                            </label>
                                            <input type="number" min="1" class="form-control form-control-solid" name="sessionsPerWeek"
                                                   value="${sessionsPerWeekValue}" required/>
                                        </div>
                                    </div>
                                </div>

                                <div class="separator mb-6"></div>
                                <div class="d-flex justify-content-end">
                                    <a href="/admin/package-types" class="btn btn-light me-3">Batalkan</a>
                                    <button type="submit" class="btn btn-primary">
                                        <span class="indicator-label">Simpan</span>
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
                                <h3 class="text-gray-900 fs-5 fw-bold m-0">Cara Kerjanya</h3>
                            </div>
                            <ul class="text-gray-700 fs-6 ps-4 mb-0" style="list-style: disc;">
                                <li class="mb-3"><strong>Total Sesi</strong> harus habis dibagi <strong>Sesi per Minggu</strong> - contoh: 12 total / 3 per minggu = 4 minggu penuh, atau 8 total / 2 per minggu = 4 minggu penuh.</li>
                                <li class="mb-3">Jika tidak habis dibagi (misal 8 total / 3 per minggu), minggu terakhir akan memiliki jumlah sesi yang berbeda, sehingga sistem akan menolak kombinasi tersebut.</li>
                                <li class="mb-0">Menonaktifkan jenis paket menyembunyikannya dari pilihan saat membuat paket baru, tapi paket yang sudah ada dengan jenis ini tidak akan terpengaruh.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
`
)