@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import com.madania.management.entity.Notification
@import org.springframework.data.domain.Page
@import java.util.List

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param User user
@param String role
@param String success = null
@param String error = null
@param Page<Patient> patients
@param int currentPage = 0
@param int totalPages = 0
@param long totalItems = 0
@param int pageSize = 12
@param String query = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Pasien",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    @if(success != null)
        <div class="alert alert-primary alert-dismissible fade show" role="alert">
            <strong>${success}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
        </div>
    @endif

    @if(error != null)
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>${error}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
        </div>
    @endif

    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="d-flex flex-wrap align-items-center my-1">
                    <h1 class="page-heading text-gray-900 fw-bold fs-3 m-0 me-5">Pasien</h1>
                    <form method="GET" action="/receptionist/patients" class="d-flex align-items-center position-relative my-1">
                        <i class="ki-outline ki-magnifier fs-3 position-absolute ms-3"></i>
                        <input type="text" name="query" class="form-control form-control-sm border-body bg-body w-200px ps-10" placeholder="Cari Pasien..." value="${query != null ? query : ""}" />
                        <input type="hidden" name="page" value="0" />
                        <button type="submit" class="btn btn-primary ms-2 d-none d-sm-inline-block">Cari</button>
                    </form>
                </div>
                <div class="align-items-center">
                    <a href="/receptionist/patient/create" class="btn btn-primary h-40px fs-7 fw-bold"><i class="ki-solid ki-user-edit"></i>Daftarkan Pasien</a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="card">
                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-5">
                            <thead>
                            <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                                <th class="min-w-250px">Nama</th>
                                <th class="min-w-125px">Wali</th>
                                <th class="min-w-100px">Usia</th>
                                <th class="min-w-100px">Status</th>
                                <th class="text-end min-w-70px">Tindakan</th>
                            </tr>
                            </thead>
                            <tbody class="fw-semibold text-gray-600">
                            @if (patients != null && !patients.isEmpty())
                                @for (Patient patient : patients)
                                    <tr>
                                        <td class="text-gray-800">${patient.getFullName()}</td>
                                        <td>${patient.getParent().getFullName()}</td>
                                        <td>${patient.getAge().getYears()} Tahun</td>
                                        <td>
                                            @if(patient.isActive())
                                                <span class="badge badge-light-success">Aktif</span>
                                            @else
                                                <span class="badge badge-light-secondary">Tidak Aktif</span>
                                            @endif
                                        </td>
                                        <td class="text-end">
                                            <a href="/receptionist/patient/${String.valueOf(patient.getId())}/edit" class="btn btn-light-primary btn-sm">
                                                <i class="ki-outline ki-notepad-edit fs-3"></i> Ubah
                                            </a>
                                        </td>
                                    </tr>
                                @endfor
                            @else
                                <tr>
                                    <td colspan="5">
                                        <div class="alert alert-info text-center mb-0">Belum ada pasien terdaftar.</div>
                                    </td>
                                </tr>
                            @endif
                            </tbody>
                        </table>
                    </div>

                    <!-- ===== START PAGINATION ===== -->
                    @if(totalPages > 0)
                        <div class="d-flex justify-content-between align-items-center pt-8">
                            <div class="text-muted fs-7">
                                Menampilkan
                                ${currentPage * pageSize + 1}
                                sampai
                                ${Math.min((currentPage + 1) * pageSize, totalItems)}
                                dari
                                ${totalItems}
                                item
                            </div>

                            <ul class="pagination m-0">
                                @if(patients.hasPrevious())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&query=${query != null ? query : ""}">Sebelum</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Sebelum</span></li>
                                @endif

                                @for(int i = 0; i < totalPages; i++)
                                    @if(i == currentPage)
                                        <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                                    @else
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${i}&query=${query != null ? query : ""}">${i + 1}</a>
                                        </li>
                                    @endif
                                @endfor

                                @if(patients.hasNext())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&query=${query != null ? query : ""}">Berikut</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Berikut</span></li>
                                @endif
                            </ul>
                        </div>
                    @endif
                    <!-- ===== END PAGINATION ===== -->
                </div>
            </div>
        </div>
    </div>
`
)
