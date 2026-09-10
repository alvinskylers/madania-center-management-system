@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapySession
@import com.madania.management.entity.User
@import com.madania.management.enums.SessionStatus
@import java.time.format.DateTimeFormatter
@import java.util.List

@param String role
@param User user
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param long totalParents
@param long totalPatients
@param int todaySessionCount
@param List<TherapySession> todaySessions
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Dashboard Resepsionis",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    <!--begin::Header-->
    <div class="d-flex justify-content-between align-items-center mb-7">
        <div>
            <h1 class="page-heading">Dashboard Resepsionis</h1>
            <p class="text-muted">Selamat datang, ${user.getName()}</p>
        </div>
        <div class="d-flex gap-3">
            <a href="/receptionist/parent/create" class="btn btn-light-primary">
                <i class="ki-outline ki-plus fs-3"></i> Wali Baru
            </a>
            <a href="/receptionist/patient/create" class="btn btn-primary">
                <i class="ki-outline ki-plus fs-3"></i> Pasien Baru
            </a>
        </div>
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
                        <span class="fs-2x fw-bold text-gray-800">${totalParents}</span>
                        <p class="text-muted mb-0">Wali Pasien Terdaftar</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                        <span class="symbol-label bg-light-success">
                            <i class="ki-outline ki-profile-circle fs-2x text-success"></i>
                        </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalPatients}</span>
                        <p class="text-muted mb-0">Pasien Terdaftar</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                        <span class="symbol-label bg-light-warning">
                            <i class="ki-outline ki-calendar fs-2x text-warning"></i>
                        </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${todaySessionCount}</span>
                        <p class="text-muted mb-0">Sesi Hari Ini</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--end::Stats row-->

    <!--begin::Today's sessions-->
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <h2>Sesi Hari Ini</h2>
            </div>
            <div class="card-toolbar">
                <a href="/receptionist/schedule" class="btn btn-sm btn-light-primary">Lihat Jadwal Penuh</a>
            </div>
        </div>
        <div class="card-body pt-0">
            <div class="table-responsive">
                <table class="table align-middle table-row-dashed fs-6 gy-4">
                    <thead>
                    <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                        <th>Waktu</th>
                        <th>Pasien</th>
                        <th>Terapis</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    @if(todaySessions != null && !todaySessions.isEmpty())
                        @for(TherapySession session : todaySessions)
                            <tr>
                                <td>${session.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm"))}</td>
                                <td class="fw-semibold text-gray-800">${session.getPatient().getFullName()}</td>
                                <td>${session.getTherapist().getFullName()}</td>
                                <td>
                                    @if(session.getStatus() == SessionStatus.SCHEDULED)
                                        <span class="badge badge-light-primary">${session.getStatus().getLabel()}</span>
                                    @elseif(session.getStatus() == SessionStatus.COMPLETED)
                                        <span class="badge badge-light-success">${session.getStatus().getLabel()}</span>
                                    @elseif(session.getStatus() == SessionStatus.CANCELLED)
                                        <span class="badge badge-light-danger">${session.getStatus().getLabel()}</span>
                                    @elseif(session.getStatus() == SessionStatus.RESCHEDULED)
                                        <span class="badge badge-light-warning">${session.getStatus().getLabel()}</span>
                                    @endif
                                </td>
                            </tr>
                        @endfor
                    @else
                        <tr>
                            <td colspan="4">
                                <div class="alert alert-info text-center mb-0">Tidak ada sesi hari ini.</div>
                            </td>
                        </tr>
                    @endif
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!--end::Today's sessions-->
`
)