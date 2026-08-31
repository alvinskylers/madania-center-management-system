@import com.madania.management.entity.Notification
@import com.madania.management.entity.Parent
@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import com.madania.management.entity.TherapySession
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param Parent parent
@param List<Patient> children
@param List<TherapySession> upcomingSessions
@param int totalChildren
@param long totalCompletedSessions
@param long totalJournals
@param int upcomingCount
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null


@template.layout.base(
title = "Dashboard",
role = role,
_csrf = _csrf,
user = user,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    <!--begin::Header-->
    <div class="d-flex justify-content-between align-items-center mb-7">
        <div>
            <h1 class="page-heading">Selamat Datang, ${parent.getFullName()}</h1>
            <p class="text-muted">Berikut adalah rangkuman dari progres anak anda</p>
        </div>
    </div>
    <!--end::Header-->

    <!--begin::Stats row-->
    <div class="row g-5 mb-7">

        <!--begin::Total children-->
        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                            <span class="symbol-label bg-light-primary">
                                <i class="ki-outline ki-people fs-2x text-primary"></i>
                            </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalChildren}</span>
                        <p class="text-muted mb-0">Anak</p>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Total children-->

        <!--begin::Upcoming sessions-->
        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                            <span class="symbol-label bg-light-info">
                                <i class="ki-outline ki-calendar-2 fs-2x text-info"></i>
                            </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${upcomingCount}</span>
                        <p class="text-muted mb-0">Sesi yang akan datang</p>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Upcoming sessions-->

        <!--begin::Completed sessions-->
        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                            <span class="symbol-label bg-light-success">
                                <i class="ki-outline ki-check-circle fs-2x text-success"></i>
                            </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalCompletedSessions}</span>
                        <p class="text-muted mb-0">Sesi Tuntas</p>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Completed sessions-->

        <!--begin::Total journals-->
        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                            <span class="symbol-label bg-light-warning">
                                <i class="ki-outline ki-notepad-edit fs-2x text-warning"></i>
                            </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalJournals}</span>
                        <p class="text-muted mb-0">Jurnal Perkembangan</p>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Total journals-->

    </div>
    <!--end::Stats row-->

    <div class="row g-5">

        <!--begin::Children cards-->
        <div class="col-md-5">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="card-title">Anak-anak Saya</h3>
                </div>
                <div class="card-body">
                    <div class="d-flex flex-column gap-4">
                        @for(Patient child : children)
                            <div class="d-flex align-items-center gap-4 p-4 rounded bg-light">
                                <div class="symbol symbol-45px">
                                        <span class="symbol-label bg-primary text-white fw-bold fs-4">
                                            ${child.getFullName().substring(0, 1)}
                                        </span>
                                </div>
                                <div class="flex-grow-1">
                                    <p class="fw-bold mb-0">${child.getFullName()}</p>
                                    <small class="text-muted">${child.getDiagnosis()}</small>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="/parent/schedule" class="btn btn-sm btn-light-primary">
                                        Jadwal
                                    </a>
                                    <a href="/parent/journals" class="btn btn-sm btn-light-info">
                                        Jurnal
                                    </a>
                                </div>
                            </div>
                        @endfor
                    </div>
                </div>
            </div>
        </div>
        <!--end::Children cards-->

        <!--begin::Upcoming sessions-->
        <div class="col-md-7">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="card-title">Sesi yang akan datang</h3>
                    <div class="card-toolbar">
                        <a href="/parent/schedule" class="btn btn-sm btn-light">Lihat Jadwal</a>
                    </div>
                </div>
                <div class="card-body">
                    @if(upcomingSessions.isEmpty())
                        <div class="text-center py-10">
                            <i class="ki-outline ki-calendar-2 fs-3x text-muted mb-3"></i>
                            <p class="text-muted">Tidak ada sesi dalam 7 hari kedepan</p>
                        </div>
                    @else
                        <div class="d-flex flex-column gap-4">
                            @for(TherapySession session : upcomingSessions)
                                <div class="d-flex align-items-center gap-4 p-3 rounded bg-light">
                                    <div class="symbol symbol-40px">
                                            <span class="symbol-label bg-info text-white fw-bold">
                                                ${session.getSessionNumber()}
                                            </span>
                                    </div>
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0">${session.getPatient().getFullName()}</p>
                                        <small class="text-muted">
                                            ${session.getStartTime().toLocalDate().toString()}
                                            at ${session.getStartTime().toLocalTime().toString()}
                                        </small>
                                    </div>
                                    <div class="text-end">
                                        <small class="text-muted d-block">Terapis</small>
                                        <small class="fw-semibold">
                                            ${session.getTherapist().getFullName()}
                                        </small>
                                    </div>
                                </div>
                            @endfor
                        </div>
                    @endif
                </div>
            </div>
        </div>
        <!--end::Upcoming sessions-->

    </div>

`
)