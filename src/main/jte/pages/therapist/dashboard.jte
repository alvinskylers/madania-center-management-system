@import com.madania.management.entity.Notification
@import com.madania.management.entity.Therapist
@import com.madania.management.entity.TherapySession
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param Therapist therapist
@param List<TherapySession> todaySessions
@param List<TherapySession> upcomingSessions
@param List<TherapySession> pendingJournals
@param int todayCount
@param int pendingJournalCount
@param long totalPatients
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Dashboard",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`

    <!--begin::Header-->
    <div class="d-flex justify-content-between align-items-center mb-7">
        <div>
            <h1 class="page-heading">Welcome, ${therapist.getFullName()}</h1>
            <p class="text-muted">${therapist.getSpecialization()}</p>
        </div>
    </div>
    <!--end::Header-->

    <!--begin::Stats row-->
    <div class="row g-5 mb-7">

        <!--begin::Today's sessions-->
        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                            <span class="symbol-label bg-light-primary">
                                <i class="ki-outline ki-calendar-2 fs-2x text-primary"></i>
                            </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${todayCount}</span>
                        <p class="text-muted mb-0">Today's Sessions</p>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Today's sessions-->

        <!--begin::Total patients-->
        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                            <span class="symbol-label bg-light-success">
                                <i class="ki-outline ki-people fs-2x text-success"></i>
                            </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalPatients}</span>
                        <p class="text-muted mb-0">Total Patients</p>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Total patients-->

        <!--begin::Pending journals-->
        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                            <span class="symbol-label bg-light-warning">
                                <i class="ki-outline ki-notepad-edit fs-2x text-warning"></i>
                            </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${pendingJournalCount}</span>
                        <p class="text-muted mb-0">Pending Journals</p>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Pending journals-->

        <!--begin::Upcoming sessions-->
        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                            <span class="symbol-label bg-light-info">
                                <i class="ki-outline ki-time fs-2x text-info"></i>
                            </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${upcomingSessions.size()}</span>
                        <p class="text-muted mb-0">Upcoming (7 days)</p>
                    </div>
                </div>
            </div>
        </div>
        <!--end::Upcoming sessions-->

    </div>
    <!--end::Stats row-->

    <div class="row g-5">

        <!--begin::Today's sessions list-->
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="card-title">Today's Sessions</h3>
                </div>
                <div class="card-body">
                    @if(todaySessions.isEmpty())
                        <div class="text-center py-10">
                            <i class="ki-outline ki-calendar-2 fs-3x text-muted mb-3"></i>
                            <p class="text-muted">No sessions today</p>
                        </div>
                    @else
                        <div class="d-flex flex-column gap-4">
                            @for(TherapySession session : todaySessions)
                                <div class="d-flex align-items-center gap-4 p-3 rounded bg-light">
                                    <div class="symbol symbol-40px">
                                            <span class="symbol-label bg-primary text-white fw-bold">
                                                ${session.getSessionNumber()}
                                            </span>
                                    </div>
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0">${session.getPatient().getFullName()}</p>
                                        <small class="text-muted">
                                            ${session.getStartTime().toLocalTime().toString()}
                                            - ${session.getEndTime().toLocalTime().toString()}
                                        </small>
                                    </div>
                                    <span class="badge badge-light-primary">
                                            Session ${session.getSessionNumber()}
                                        </span>
                                </div>
                            @endfor
                        </div>
                    @endif
                </div>
            </div>
        </div>
        <!--end::Today's sessions list-->

        <!--begin::Pending journals list-->
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="card-title">Pending Journals</h3>
                    <div class="card-toolbar">
                        <a href="/therapist/sessions" class="btn btn-sm btn-light">View All</a>
                    </div>
                </div>
                <div class="card-body">
                    @if(pendingJournals.isEmpty())
                        <div class="text-center py-10">
                            <i class="ki-outline ki-notepad-edit fs-3x text-muted mb-3"></i>
                            <p class="text-muted">All sessions have journals</p>
                        </div>
                    @else
                        <div class="d-flex flex-column gap-4">
                            @for(TherapySession session : pendingJournals)
                                <div class="d-flex align-items-center gap-4 p-3 rounded bg-light">
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0">${session.getPatient().getFullName()}</p>
                                        <small class="text-muted">
                                            Session ${session.getSessionNumber()} —
                                            ${session.getStartTime().toLocalDate().toString()}
                                        </small>
                                    </div>
                                    <a href="/therapist/journal/create/${String.valueOf(session.getId())}"
                                       class="btn btn-sm btn-warning">
                                        Write
                                    </a>
                                </div>
                            @endfor
                        </div>
                    @endif
                </div>
            </div>
        </div>
        <!--end::Pending journals list-->

    </div>

    <!--begin::Upcoming sessions-->
    <div class="row g-5 mt-2">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Upcoming Sessions (Next 7 Days)</h3>
                    <div class="card-toolbar">
                        <a href="/therapist/schedule" class="btn btn-sm btn-light">Full Schedule</a>
                    </div>
                </div>
                <div class="card-body">
                    @if(upcomingSessions.isEmpty())
                        <div class="text-center py-10">
                            <i class="ki-outline ki-calendar-2 fs-3x text-muted mb-3"></i>
                            <p class="text-muted">No upcoming sessions in the next 7 days</p>
                        </div>
                    @else
                        <table class="table table-row-dashed">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Patient</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            @for(TherapySession session : upcomingSessions)
                                <tr>
                                    <td>${session.getSessionNumber()}</td>
                                    <td>${session.getPatient().getFullName()}</td>
                                    <td>${session.getStartTime().toLocalDate().toString()}</td>
                                    <td>${session.getStartTime().toLocalTime().toString()}</td>
                                    <td>
                                                <span class="badge badge-light-primary">
                                                    ${session.getStatus().name()}
                                                </span>
                                    </td>
                                </tr>
                            @endfor
                            </tbody>
                        </table>
                    @endif
                </div>
            </div>
        </div>
    </div>
    <!--end::Upcoming sessions-->

`
)