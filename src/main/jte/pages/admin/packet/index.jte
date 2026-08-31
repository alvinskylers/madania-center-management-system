@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapyPackage
@import com.madania.management.entity.Therapist
@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import org.springframework.data.domain.Page
@import java.time.LocalDate
@import java.util.List
@import java.util.UUID

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param Page<TherapyPackage> packages
@param int currentPage = 0
@param int totalPages = 0
@param long totalItems = 0
@param int pageSize = 10
@param UUID therapistId = null
@param UUID patientId = null
@param LocalDate dateFrom = null
@param LocalDate dateTo = null
@param List<Therapist> therapists
@param List<Patient> patients
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String therapistIdStr = therapistId != null ? String.valueOf(therapistId) : "";}
!{String patientIdStr = patientId != null ? String.valueOf(patientId) : "";}
!{String dateFromStr = dateFrom != null ? dateFrom.toString() : "";}
!{String dateToStr = dateTo != null ? dateTo.toString() : "";}
!{boolean hasFilters = therapistId != null || patientId != null || dateFrom != null || dateTo != null;}

@template.layout.base(
title = "Therapy Packages",
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
                <!--begin::Left side: Title-->
                <div class="d-flex flex-wrap align-items-center my-1">
                    <h1 class="page-heading text-gray-900 fw-bold fs-3 m-0">Paket Terapi</h1>
                </div>
                <!--end::Left side-->
                <!--begin::Right side: Action buttons-->
                <div class="align-items-center">
                    <a href="/admin/package/create" class="btn btn-primary h-40px fs-7 fw-bold">
                        <i class="ki-outline ki-plus fs-3"></i>Buat Paket Terapi
                    </a>
                </div>
                <!--end::Right side-->
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            <!--begin::Filter Card-->
            <div class="card mb-6">
                <div class="card-body py-6">
                    <form method="GET" action="/admin/packages" class="row g-4 align-items-end">
                        <input type="hidden" name="page" value="0"/>

                        <!--begin::Therapist filter-->
                        <div class="col-sm-6 col-lg-3">
                            <label class="form-label fs-7 fw-semibold text-gray-700 mb-1">Terapis</label>
                            <select name="therapistId" class="form-select form-select-sm">
                                <option value="">Semua terapis</option>
                                @for(Therapist therapist : therapists)
                                    @if(therapistIdStr.equals(String.valueOf(therapist.getId())))
                                        <option value="${String.valueOf(therapist.getId())}" selected>${therapist.getFullName()}</option>
                                    @else
                                        <option value="${String.valueOf(therapist.getId())}">${therapist.getFullName()}</option>
                                    @endif
                                @endfor
                            </select>
                        </div>
                        <!--end::Therapist filter-->

                        <!--begin::Patient filter-->
                        <div class="col-sm-6 col-lg-3">
                            <label class="form-label fs-7 fw-semibold text-gray-700 mb-1">Pasien</label>
                            <select name="patientId" class="form-select form-select-sm">
                                <option value="">Semua pasien</option>
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
                        <div class="col-sm-6 col-lg-2">
                            <label class="form-label fs-7 fw-semibold text-gray-700 mb-1">Tanggal batas awal</label>
                            <input type="date" name="dateFrom" class="form-control form-control-sm" value="${dateFromStr}"/>
                        </div>
                        <!--end::Date From-->

                        <!--begin::Date To-->
                        <div class="col-sm-6 col-lg-2">
                            <label class="form-label fs-7 fw-semibold text-gray-700 mb-1">Tanggal batas akhir</label>
                            <input type="date" name="dateTo" class="form-control form-control-sm" value="${dateToStr}"/>
                        </div>
                        <!--end::Date To-->

                        <!--begin::Filter actions-->
                        <div class="col-sm-12 col-lg-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-sm flex-grow-1">
                                <i class="ki-outline ki-filter fs-4"></i>Filter
                            </button>
                            @if(hasFilters)
                                <a href="/admin/packages" class="btn btn-light btn-sm" title="Reset filters">
                                    <i class="ki-outline ki-cross fs-4"></i>
                                </a>
                            @endif
                        </div>
                        <!--end::Filter actions-->
                    </form>
                </div>
            </div>
            <!--end::Filter Card-->

            <!--begin::Table Card-->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-4">
                            <thead>
                            <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                <th>Pasien</th>
                                <th>Terapis</th>
                                <th>Tanggal Sesi</th>
                                <th>No Sesi</th>
                                <th>Status</th>
                                <th>Tindakan</th>
                            </tr>
                            </thead>
                            <tbody>
                            @if(packages != null && !packages.isEmpty())
                                @for(TherapyPackage pkg : packages)
                                    @template.components.package-row(therapyPackage = pkg, _csrf = _csrf)
                                @endfor
                            @else
                                <tr>
                                    <td colspan="6">
                                        <div class="alert alert-info text-center mb-0">
                                            Paket dengan kritera tersebut tidak tersedia
                                        </div>
                                    </td>
                                </tr>
                            @endif
                            </tbody>
                        </table>
                    </div>

                    <!-- ===== START PAGINATION ===== -->
                    @if(totalPages > 0)
                        <div class="d-flex justify-content-between align-items-center pt-6">
                            <!-- Entries summary -->
                            <div class="text-muted fs-7">
                                Menampilkan
                                ${currentPage * pageSize + 1}
                                sampai
                                ${Math.min((currentPage + 1) * pageSize, totalItems)}
                                dari
                                ${totalItems}
                                item
                            </div>

                            <!-- Pagination controls -->
                            <ul class="pagination m-0">
                                <!-- Previous -->
                                @if(packages.hasPrevious())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&therapistId=${therapistIdStr}&patientId=${patientIdStr}&dateFrom=${dateFromStr}&dateTo=${dateToStr}">Sebelum</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Sebelum</span></li>
                                @endif

                                <!-- Page numbers -->
                                @for(int i = 0; i < totalPages; i++)
                                    @if(i == currentPage)
                                        <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                                    @else
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${i}&therapistId=${therapistIdStr}&patientId=${patientIdStr}&dateFrom=${dateFromStr}&dateTo=${dateToStr}">${i + 1}</a>
                                        </li>
                                    @endif
                                @endfor

                                <!-- Next -->
                                @if(packages.hasNext())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&therapistId=${therapistIdStr}&patientId=${patientIdStr}&dateFrom=${dateFromStr}&dateTo=${dateToStr}">Berikut</a>
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
            <!--end::Table Card-->

        </div>
    </div>
    <!--end::Content-->
`
)