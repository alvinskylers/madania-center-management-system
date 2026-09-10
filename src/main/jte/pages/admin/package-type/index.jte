@import com.madania.management.entity.PackageType
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import org.springframework.security.web.csrf.CsrfToken
@import java.util.List

@param User user
@param String role
@param CsrfToken _csrf
@param List<PackageType> packageTypes
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Jenis Paket",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Jenis Paket</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/packages" class="text-muted text-hover-primary">Paket Terapi</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Jenis Paket</li>
                    </ul>
                </div>
                <div class="align-items-center">
                    <a href="/admin/package-type/create" class="btn btn-primary h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-plus fs-3"></i>Tambah Jenis Paket
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="card">
                <div class="card-header border-0 pt-6">
                    <div class="card-title">
                        <h3>Semua Jenis Paket</h3>
                    </div>
                </div>
                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-5">
                            <thead>
                            <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                                <th class="min-w-150px">Nama</th>
                                <th class="min-w-100px">Total Sesi</th>
                                <th class="min-w-125px">Sesi / Minggu</th>
                                <th class="min-w-100px">Status</th>
                                <th class="text-end min-w-70px">Tindakan</th>
                            </tr>
                            </thead>
                            <tbody class="fw-semibold text-gray-600">
                            @for(PackageType type : packageTypes)
                                <tr>
                                    <td class="text-gray-800 fw-bold">${type.getName()}</td>
                                    <td>${type.getTotalSessions()}</td>
                                    <td>${type.getSessionsPerWeek()}x / minggu</td>
                                    <td>
                                        @if(type.isActive())
                                            <span class="badge badge-light-success">Aktif</span>
                                        @else
                                            <span class="badge badge-light-danger">Tidak Aktif</span>
                                        @endif
                                    </td>
                                    <td class="text-end">
                                        @if(type.isActive())
                                            <form method="post" action="/admin/package-type/${String.valueOf(type.getId())}/deactivate" style="display:inline;">
                                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}" />
                                                <button type="submit" class="btn btn-sm btn-light-danger"
                                                        onclick="return confirm('Nonaktifkan jenis paket ini? Paket yang sudah dibuat dengan jenis ini tidak akan terpengaruh.')">
                                                    Nonaktifkan
                                                </button>
                                            </form>
                                        @else
                                            <form method="post" action="/admin/package-type/${String.valueOf(type.getId())}/activate" style="display:inline;">
                                                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}" />
                                                <button type="submit" class="btn btn-sm btn-light-success">Aktifkan</button>
                                            </form>
                                        @endif
                                    </td>
                                </tr>
                            @endfor
                            @if(packageTypes.isEmpty())
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-10">Belum ada jenis paket. Klik "Tambah Jenis Paket" untuk membuat yang pertama.</td>
                                </tr>
                            @endif
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
`
)