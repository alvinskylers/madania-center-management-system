@import com.madania.management.entity.TherapyPackage
@import com.madania.management.entity.TherapySession
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param long totalTherapists
@param long totalParents
@param long totalPatients
@param long totalUsers
@param long activePackages
@param long completedPackages
@param long totalCompletedSessions
@param long totalJournals
@param int todaySessionCount
@param List<TherapySession> todaySessions
@param List<TherapyPackage> recentPackages

@template.layout.base(
title = "Admin Dashboard",
role = role,
_csrf = _csrf,
content = @`

    <!--begin::Header-->
    <div class="d-flex justify-content-between align-items-center mb-7">
        <div>
            <h1 class="page-heading">Admin Dashboard</h1>
            <p class="text-muted">Clinic overview and management</p>
        </div>
        <a href="/admin/packages/create" class="btn btn-primary">
            <i class="ki-outline ki-plus fs-2"></i>
            New Package
        </a>
    </div>
    <!--end::Header-->

    <!--begin::Stats row-->
    <div class="row g-5 mb-5">

        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                    <span class="symbol-label bg-light-primary">
                        <i class="ki-outline ki-user fs-2x text-primary"></i>
                    </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalTherapists}</span>
                        <p class="text-muted mb-0">Therapists</p>
                    </div>
                </div>
                <div class="card-footer py-3">
                    <a href="/admin/therapists" class="text-primary fw-semibold fs-7">
                        View all <i class="ki-outline ki-arrow-right fs-7 text-primary"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                    <span class="symbol-label bg-light-info">
                        <i class="ki-outline ki-people fs-2x text-info"></i>
                    </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalParents}</span>
                        <p class="text-muted mb-0">Parents</p>
                    </div>
                </div>
                <div class="card-footer py-3">
                    <a href="/admin/parents" class="text-info fw-semibold fs-7">
                        View all <i class="ki-outline ki-arrow-right fs-7 text-info"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                    <span class="symbol-label bg-light-success">
                        <i class="ki-outline ki-heart fs-2x text-success"></i>
                    </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalPatients}</span>
                        <p class="text-muted mb-0">Active Patients</p>
                    </div>
                </div>
                <div class="card-footer py-3">
                    <a href="/admin/patients" class="text-success fw-semibold fs-7">
                        View all <i class="ki-outline ki-arrow-right fs-7 text-success"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                    <span class="symbol-label bg-light-success">
                        <i class="ki-outline ki-people fs-2x text-success"></i>
                    </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalUsers}</span>
                        <p class="text-muted mb-0">Total Users</p>
                    </div>
                </div>
                <div class="card-footer py-3">
                    <a href="/admin/users" class="text-success fw-semibold fs-7">
                        View all <i class="ki-outline ki-arrow-right fs-7 text-success"></i>
                    </a>
                </div>
            </div>
        </div>

    </div>
    <!--end::Stats row 1-->

    <!--begin::Stats row 2-->
    <div class="row g-5 mb-7">

        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                    <span class="symbol-label bg-light-warning">
                        <i class="ki-outline ki-package fs-2x text-warning"></i>
                    </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${activePackages}</span>
                        <p class="text-muted mb-0">Active Packages</p>
                    </div>
                </div>
                <div class="card-footer py-3">
                    <a href="/admin/packages" class="text-warning fw-semibold fs-7">
                        View all <i class="ki-outline ki-arrow-right fs-7 text-warning"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                    <span class="symbol-label bg-light-primary">
                        <i class="ki-outline ki-check-circle fs-2x text-primary"></i>
                    </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${completedPackages}</span>
                        <p class="text-muted mb-0">Completed Packages</p>
                    </div>
                </div>
                <div class="card-footer py-3">
                    <a href="/admin/packages" class="text-primary fw-semibold fs-7">
                        View all <i class="ki-outline ki-arrow-right fs-7 text-primary"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                    <span class="symbol-label bg-light-success">
                        <i class="ki-outline ki-calendar-tick fs-2x text-success"></i>
                    </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalCompletedSessions}</span>
                        <p class="text-muted mb-0">Completed Sessions</p>
                    </div>
                </div>
                <div class="card-footer py-3">
                    <span class="text-muted fs-7">All time</span>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card h-100">
                <div class="card-body d-flex align-items-center gap-4">
                    <div class="symbol symbol-50px">
                    <span class="symbol-label bg-light-info">
                        <i class="ki-outline ki-notepad-edit fs-2x text-info"></i>
                    </span>
                    </div>
                    <div>
                        <span class="fs-2x fw-bold text-gray-800">${totalJournals}</span>
                        <p class="text-muted mb-0">Journals Written</p>
                    </div>
                </div>
                <div class="card-footer py-3">
                    <span class="text-muted fs-7">All time</span>
                </div>
            </div>
        </div>

    </div>

    <div class="row g-5">

        <!--begin::Today's sessions-->
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="card-title">
                        Today's Sessions
                        <span class="badge badge-light-primary ms-2">${todaySessionCount}</span>
                    </h3>
                </div>
                <div class="card-body">
                    @if(todaySessions.isEmpty())
                        <div class="text-center py-10">
                            <i class="ki-outline ki-calendar-2 fs-3x text-muted mb-3"></i>
                            <p class="text-muted">No sessions scheduled for today</p>
                        </div>
                    @else
                        <div class="d-flex flex-column gap-3">
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
                                            ${session.getTherapist().getFullName()}
                                        </small>
                                    </div>
                                    <div class="text-end">
                                        <small class="fw-semibold d-block">
                                            ${session.getStartTime().toLocalTime().toString()}
                                        </small>
                                        <span class="badge badge-light-primary fs-8">
                                                ${session.getStatus().name()}
                                            </span>
                                    </div>
                                </div>
                            @endfor
                        </div>
                    @endif
                </div>
            </div>
        </div>
        <!--end::Today's sessions-->

        <!--begin::Recent packages-->
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="card-title">Recent Packages</h3>
                    <div class="card-toolbar">
                        <a href="/admin/packages" class="btn btn-sm btn-light">View All</a>
                    </div>
                </div>
                <div class="card-body">
                    @if(recentPackages.isEmpty())
                        <div class="text-center py-10">
                            <i class="ki-outline ki-package fs-3x text-muted mb-3"></i>
                            <p class="text-muted">No packages created yet</p>
                        </div>
                    @else
                        <div class="d-flex flex-column gap-3">
                            @for(TherapyPackage pkg : recentPackages)
                                <div class="d-flex align-items-center gap-4 p-3 rounded bg-light">
                                    <div class="flex-grow-1">
                                        <p class="fw-bold mb-0">${pkg.getPatient().getFullName()}</p>
                                        <small class="text-muted">
                                            ${pkg.getTherapist().getFullName()} —
                                            ${pkg.getStartDate().toString()}
                                        </small>
                                    </div>
                                    <div class="text-end">
                                        <small class="text-muted d-block">
                                            ${pkg.getCompletedSessions()}/${pkg.getTotalSessions()} sessions
                                        </small>
                                        @if(pkg.getStatus().name().equals("ACTIVE"))
                                            <span class="badge badge-light-success">Active</span>
                                        @elseif(pkg.getStatus().name().equals("COMPLETED"))
                                            <span class="badge badge-light-primary">Completed</span>
                                        @else
                                            <span class="badge badge-light-danger">Cancelled</span>
                                        @endif
                                    </div>
                                </div>
                            @endfor
                        </div>
                    @endif
                </div>
            </div>
        </div>
        <!--end::Recent packages-->

    </div>

`
)