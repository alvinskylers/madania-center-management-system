@import com.madania.management.entity.Checkup
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import com.madania.management.enums.CheckupStatus
@import org.springframework.data.domain.Page
@import java.time.format.DateTimeFormatter
@import java.util.List

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param User user
@param String role
@param String success = null
@param String error = null
@param Page<Checkup> checkups
@param int currentPage = 0
@param int totalPages = 0
@param long totalItems = 0
@param int pageSize = 10
@param String query = null
@param CheckupStatus status = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");}
!{String statusValue = status != null ? status.name() : "";}

@template.layout.base(
title = "Checkup Diagnosa",
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
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="d-flex flex-wrap align-items-center my-1">
                    <h1 class="page-heading text-gray-900 fw-bold fs-3 m-0 me-5">Checkup Diagnosa</h1>
                    <form method="GET" action="/receptionist/checkups" class="d-flex align-items-center flex-wrap gap-2 my-1">
                        <input type="text" name="query" class="form-control form-control-sm border-body bg-body w-200px" placeholder="Cari pasien/terapis..." value="${query != null ? query : ""}" />
                        <select name="status" class="form-select form-select-sm border-body bg-body w-150px" onchange="this.form.submit()" data-control="select2" data-width="150px" data-hide-search="true">
                            <option value="">Semua Status</option>
                            @for(CheckupStatus s : CheckupStatus.values())
                                @if(statusValue.equals(s.name()))
                                    <option value="${s.name()}" selected>${s.getLabel()}</option>
                                @else
                                    <option value="${s.name()}">${s.getLabel()}</option>
                                @endif
                            @endfor
                        </select>
                        <input type="hidden" name="page" value="0" />
                        <button type="submit" class="btn btn-primary btn-sm">Cari</button>
                    </form>
                </div>
                <div class="align-items-center">
                    <a href="/receptionist/checkup/create" class="btn btn-primary h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-calendar-add fs-3"></i>Jadwalkan Checkup
                    </a>
                </div>
            </div>
    </div>
    <!--end::Toolbar-->

            <div class="card">
                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-5">
                            <thead>
                            <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                                <th class="min-w-200px">Pasien</th>
                                <th class="min-w-150px">Terapis</th>
                                <th class="min-w-150px">Jadwal</th>
                                <th class="min-w-100px">Status</th>
                                <th class="min-w-150px">Keputusan Wali</th>
                                <th class="text-end min-w-70px">Tindakan</th>
                            </tr>
                            </thead>
                            <tbody class="fw-semibold text-gray-600">
                            @if(checkups != null && !checkups.isEmpty())
                                @for(Checkup checkup : checkups)
                                    <tr>
                                        <td class="text-gray-800">${checkup.getPatient().getFullName()}</td>
                                        <td>${checkup.getTherapist().getFullName()}</td>
                                        <td>${checkup.getScheduledAt().format(fmt)}</td>
                                        <td>
                                            @if(checkup.getStatus().name().equals("SCHEDULED"))
                                                <span class="badge badge-light-primary">${checkup.getStatus().getLabel()}</span>
                                            @elseif(checkup.getStatus().name().equals("COMPLETED"))
                                                <span class="badge badge-light-success">${checkup.getStatus().getLabel()}</span>
                                            @else
                                                <span class="badge badge-light-danger">${checkup.getStatus().getLabel()}</span>
                                            @endif
                                        </td>
                                        <td>
                                            @if(checkup.getParentDecision().name().equals("PROCEED_TO_THERAPY"))
                                                <span class="badge badge-light-success">${checkup.getParentDecision().getLabel()}</span>
                                            @elseif(checkup.getParentDecision().name().equals("DECLINED"))
                                                <span class="badge badge-light-secondary">${checkup.getParentDecision().getLabel()}</span>
                                            @else
                                                <span class="badge badge-light-warning">${checkup.getParentDecision().getLabel()}</span>
                                            @endif
                                        </td>
                                        <td class="text-end">
                                            <a href="/receptionist/checkup/${String.valueOf(checkup.getId())}" class="btn btn-light-primary btn-sm">
                                                <i class="ki-outline ki-eye fs-3"></i> Lihat
                                            </a>
                                        </td>
                                    </tr>
                                @endfor
                            @else
                                <tr>
                                    <td colspan="6">
                                        <div class="alert alert-info text-center mb-0">Belum ada checkup dijadwalkan.</div>
                                    </td>
                                </tr>
                            @endif
                            </tbody>
                        </table>
                    </div>

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
                                @if(checkups.hasPrevious())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&query=${query != null ? query : ""}&status=${statusValue}">Sebelumnya</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Sebelumnya</span></li>
                                @endif

                                @for(int i = 0; i < totalPages; i++)
                                    @if(i == currentPage)
                                        <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                                    @else
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${i}&query=${query != null ? query : ""}&status=${statusValue}">${i + 1}</a>
                                        </li>
                                    @endif
                                @endfor

                                @if(checkups.hasNext())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&query=${query != null ? query : ""}&status=${statusValue}">Berikutnya</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Berikutnya</span></li>
                                @endif
                            </ul>
                        </div>
                    @endif
                </div>
            </div>
`
)
