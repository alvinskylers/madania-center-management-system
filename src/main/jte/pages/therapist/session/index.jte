@import com.madania.management.dto.PackageJournalGroup
@import com.madania.management.entity.Notification
@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import java.time.LocalDate
@import java.util.List
@import java.util.UUID

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<PackageJournalGroup> packageGroups
@param int currentPage = 0
@param int totalPages = 0
@param long totalItems = 0
@param int pageSize = 5
@param UUID patientId = null
@param LocalDate dateFrom = null
@param LocalDate dateTo = null
@param List<Patient> patients
@param String success = null
@param String error = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String patientIdStr = patientId != null ? String.valueOf(patientId) : "";}
!{String dateFromStr = dateFrom != null ? dateFrom.toString() : "";}
!{String dateToStr = dateTo != null ? dateTo.toString() : "";}
!{boolean hasFilters = patientId != null || dateFrom != null || dateTo != null;}

@template.layout.base(
title = "Sesi Terapi Saya",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Sesi Terapi Saya</h1>
                    <div class="fs-6 text-muted">Paket Terapi dan Jurnal Terapi anda.</div>
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
            @if(error != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>${error}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            <!--begin::Filter Card-->
            <div class="card mb-6">
                <div class="card-body py-6">
                    <form method="GET" action="/therapist/sessions" class="row g-4 align-items-end">
                        <input type="hidden" name="page" value="0"/>
                        <input type="hidden" name="size" value="${pageSize}"/>

                        <!--begin::Patient filter-->
                        <div class="col-sm-6 col-lg-4">
                            <label class="form-label fs-7 fw-semibold text-gray-700 mb-1">Pasien</label>
                            <select name="patientId" class="form-select form-select-sm">
                                <option value="">Semua Pasien</option>
                                @for(Patient patient : patients)
                                    @if(patientIdStr.equals(String.valueOf(patient.getId())))
                                        <option value="${String.valueOf(patient.getId())}" selected>${patient.getFullName()}</option>
                                    @else
                                        <option value="${String.valueOf(patient.getId())}">${patient.getFullName()}</option>
                                    @endif
                                @endfor
                            </select>
                        </div>
                        <!--end::Patient filter-->

                        <!--begin::Date From-->
                        <div class="col-sm-6 col-lg-3">
                            <label class="form-label fs-7 fw-semibold text-gray-700 mb-1">Tanggal Batas Awal</label>
                            <input type="date" name="dateFrom" class="form-control form-control-sm" value="${dateFromStr}"/>
                        </div>
                        <!--end::Date From-->

                        <!--begin::Date To-->
                        <div class="col-sm-6 col-lg-3">
                            <label class="form-label fs-7 fw-semibold text-gray-700 mb-1">Tanggal Batas Akhir</label>
                            <input type="date" name="dateTo" class="form-control form-control-sm" value="${dateToStr}"/>
                        </div>
                        <!--end::Date To-->

                        <!--begin::Filter actions-->
                        <div class="col-sm-12 col-lg-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-sm flex-grow-1">
                                <i class="ki-outline ki-filter fs-4"></i>Filter
                            </button>
                            @if(hasFilters)
                                <a href="/therapist/sessions" class="btn btn-light btn-sm" title="Reset filters">
                                    <i class="ki-outline ki-cross fs-4"></i>
                                </a>
                            @endif
                        </div>
                        <!--end::Filter actions-->
                    </form>
                </div>
            </div>
            <!--end::Filter Card-->

            <!--begin::Packages Accordion Card-->
            <div class="card">
                <div class="card-body">
                    @if(packageGroups == null || packageGroups.isEmpty())
                        <div class="alert alert-info text-center mb-0">Paket Terapi tidak ditemukan dengan kriteria tersebut.</div>
                    @else
                        <div class="accordion" id="kt_therapist_sessions_accordion">
                            @for(int i = 0; i < packageGroups.size(); i++)
                                @template.pages.therapist.session.row(
                                group = packageGroups.get(i),
                                index = i,
                                _csrf = _csrf,
                                currentPage = currentPage,
                                pageSize = pageSize,
                                patientId = patientId,
                                dateFrom = dateFrom,
                                dateTo = dateTo
                                )
                            @endfor
                        </div>
                    @endif

                    <!-- ===== START PAGINATION ===== -->
                    @if(totalPages > 0)
                        <div class="d-flex justify-content-between align-items-center pt-6">
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
                                @if(currentPage > 0)
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&size=${pageSize}&patientId=${patientIdStr}&dateFrom=${dateFromStr}&dateTo=${dateToStr}">Sebelum</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Sebelum</span></li>
                                @endif

                                @for(int i = 0; i < totalPages; i++)
                                    @if(i == currentPage)
                                        <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                                    @else
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${i}&size=${pageSize}&patientId=${patientIdStr}&dateFrom=${dateFromStr}&dateTo=${dateToStr}">${i + 1}</a>
                                        </li>
                                    @endif
                                @endfor

                                @if(currentPage < totalPages - 1)
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&size=${pageSize}&patientId=${patientIdStr}&dateFrom=${dateFromStr}&dateTo=${dateToStr}">Berikut</a>
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
            <!--end::Packages Accordion Card-->

        </div>
    </div>
    <!--end::Content-->
`
)