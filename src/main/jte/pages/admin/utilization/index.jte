@import com.madania.management.dto.utilization.TherapistUtilizationDto
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import java.util.List

@param String role
@param User user
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<TherapistUtilizationDto> rows
@param long activeTherapistCount
@param long averageSessionsThisWeek
@param long overloadedCount
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Utilisasi Terapis",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    <!--begin::Header-->
    <div class="d-flex justify-content-between align-items-center mb-7">
        <h1 class="fs-2 fw-bold">Utilisasi Terapis</h1>
    </div>
    <!--end::Header-->

    <!--begin::Stats row-->
    <div class="row g-5 mb-5">
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                        <span class="symbol-label bg-light-primary">
                            <i class="ki-outline ki-people fs-2x text-primary"></i>
                        </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${activeTherapistCount}</span>
                        <p class="text-muted mb-0">Terapis Aktif</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                        <span class="symbol-label bg-light-info">
                            <i class="ki-outline ki-calendar fs-2x text-info"></i>
                        </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${averageSessionsThisWeek}</span>
                        <p class="text-muted mb-0">Rata-rata Sesi / Minggu</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                        <span class="symbol-label bg-light-warning">
                            <i class="ki-outline ki-shield-cross fs-2x text-warning"></i>
                        </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${overloadedCount}</span>
                        <p class="text-muted mb-0">Beban Tidak Seimbang</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--end::Stats row-->

    <!--begin::Table-->
    <div class="card">
        <div class="card-body">
            @if(rows.isEmpty())
                <div class="text-center py-10">
                    <p class="text-muted">Belum ada terapis terdaftar.</p>
                </div>
            @else
                <div class="table-responsive">
                    <table class="table table-row-dashed align-middle fs-6 gy-4">
                        <thead>
                            <tr class="text-muted text-uppercase fs-7">
                                <th>Terapis</th>
                                <th>Caseload Aktif</th>
                                <th style="min-width: 180px;">Sesi Minggu Ini</th>
                                <th>Tingkat Penyelesaian</th>
                                <th>Cuti</th>
                            </tr>
                        </thead>
                        <tbody>
                            @for(TherapistUtilizationDto row : rows)
                                <tr class="${row.isOverloaded() ? "table-warning" : ""}">
                                    <td class="fw-semibold">
                                        <a href="/admin/therapist/${String.valueOf(row.getTherapistId())}" class="text-gray-800 text-hover-primary">
                                            ${row.getFullName()}
                                        </a>
                                    </td>
                                    <td>${row.getActiveCaseload()} pasien</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="progress h-6px w-100px">
                                                <div class="progress-bar ${row.isOverloaded() ? "bg-warning" : "bg-primary"}"
                                                     role="progressbar"
                                                     style="width: ${String.valueOf(Math.min(100, row.getSessionsThisWeek() * 8))}%;"></div>
                                            </div>
                                            <span class="fw-semibold">${row.getSessionsThisWeek()}</span>
                                        </div>
                                    </td>
                                    <td>
                                        @if(row.getCompletionRatePercent() == null)
                                            <span class="text-muted">-</span>
                                        @elseif(row.getCompletionRatePercent() >= 90)
                                            <span class="badge badge-light-success">${String.valueOf(Math.round(row.getCompletionRatePercent()))}%</span>
                                        @elseif(row.getCompletionRatePercent() >= 75)
                                            <span class="badge badge-light-warning">${String.valueOf(Math.round(row.getCompletionRatePercent()))}%</span>
                                        @else
                                            <span class="badge badge-light-danger">${String.valueOf(Math.round(row.getCompletionRatePercent()))}%</span>
                                        @endif
                                    </td>
                                    <td>
                                        @if(row.isOnLeaveThisWeek())
                                            <span class="badge badge-light-secondary">${row.getLeaveRangeLabel()}</span>
                                        @else
                                            <span class="text-muted">-</span>
                                        @endif
                                    </td>
                                </tr>
                            @endfor
                        </tbody>
                    </table>
                </div>
            @endif
        </div>
    </div>
    <!--end::Table-->
`
)
