@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import org.springframework.data.domain.Page

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

@template.layout.base(
title = "Patients",
role = role,
user = user,
_csrf = _csrf,
content = @`

    @if(success != null)
        <div class="alert alert-primary alert-dismissible fade show" role="alert">
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

    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <!--begin::Left side: Title + Search Form-->
                <div class="d-flex flex-wrap align-items-center my-1">
                    <h1 class="page-heading text-gray-900 fw-bold fs-3 m-0 me-5">Patients</h1>
                    <!-- Search form -->
                    <form method="GET" action="/admin/patients" class="d-flex align-items-center position-relative my-1">
                        <i class="ki-outline ki-magnifier fs-3 position-absolute ms-3"></i>
                        <input type="text" name="query" id="patientSearch" class="form-control form-control-sm border-body bg-body w-200px ps-10" placeholder="Search patients..." value="${query != null ? query : ""}" />
                        <input type="hidden" name="page" value="0" />
                        <button type="submit" class="btn btn-primary ms-2 d-none d-sm-inline-block">Search</button>
                    </form>
                </div>
                <!--end::Left side-->
                <!--begin::Right side: Action buttons-->
                <div class="align-items-center">
                    <a href="/admin/patient/create" class="btn btn-primary h-40px fs-7 fw-bold"><i class="ki-solid ki-user-edit"></i>Add Patient</a>
                </div>
                <!--end::Right side-->
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <!--begin::Patients Grid-->
            <div class="row g-6 g-xl-9" id="patientsGrid">
                @if (patients != null && !patients.isEmpty())
                    @for (Patient patient : patients)
                        <div class="col-md-3 col-xxl-3">
                            @template.components.patient-card(patient = patient)
                        </div>
                    @endfor
                @else
                    <div class="col-12">
                        <div class="alert alert-info text-center">
                            No patients found.
                        </div>
                    </div>
                @endif
            </div>
            <!--end::Patients Grid-->

            <!-- ===== START PAGINATION ===== -->
            @if(totalPages > 0)
                <div class="d-flex justify-content-between align-items-center pt-8">
                    <!-- Entries summary -->
                    <div class="text-muted fs-7">
                        Showing
                        ${currentPage * pageSize + 1}
                        to
                        ${Math.min((currentPage + 1) * pageSize, totalItems)}
                        of
                        ${totalItems}
                        entries
                    </div>

                    <!-- Pagination controls -->
                    <ul class="pagination m-0">
                        <!-- Previous -->
                        @if(patients.hasPrevious())
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&query=${query != null ? query : ""}">Previous</a>
                            </li>
                        @else
                            <li class="page-item disabled"><span class="page-link">Previous</span></li>
                        @endif

                        <!-- Page numbers -->
                        @for(int i = 0; i < totalPages; i++)
                            @if(i == currentPage)
                                <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                            @else
                                <li class="page-item">
                                    <a class="page-link" href="?page=${i}&query=${query != null ? query : ""}">${i + 1}</a>
                                </li>
                            @endif
                        @endfor

                        <!-- Next -->
                        @if(patients.hasNext())
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&query=${query != null ? query : ""}">Next</a>
                            </li>
                        @else
                            <li class="page-item disabled"><span class="page-link">Next</span></li>
                        @endif
                    </ul>
                </div>
            @endif
            <!-- ===== END PAGINATION ===== -->
        </div>
    </div>
    <!--end::Content-->
`)