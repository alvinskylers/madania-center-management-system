@import com.madania.management.entity.Patient
@import org.springframework.data.domain.Page

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param Page<Patient> patients
@param int currentPage = 0
@param int totalPages = 0
@param long totalItems = 0
@param int pageSize = 12
@param String query = null
@param String patientError = null

@template.layout.base(
title = "My Patients",
role = role,
_csrf = _csrf,
content = @`

    @if(patientError != null)
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>${patientError}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif

    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="d-flex flex-wrap align-items-center my-1">
                    <h1 class="page-heading text-gray-900 fw-bold fs-3 m-0 me-5">My Patients</h1>
                    <form method="GET" action="/therapist/patients" class="d-flex align-items-center position-relative my-1">
                        <i class="ki-outline ki-magnifier fs-3 position-absolute ms-3"></i>
                        <input type="text" name="query" class="form-control form-control-sm border-body bg-body w-200px ps-10" placeholder="Search my patients..." value="${query != null ? query : ""}" />
                        <input type="hidden" name="page" value="0" />
                        <button type="submit" class="btn btn-primary ms-2 d-none d-sm-inline-block">Search</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Content-->
    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="row g-6 g-xl-9" id="patientsGrid">
                @if (patients != null && !patients.isEmpty())
                    @for (Patient patient : patients)
                        <div class="col-md-3 col-xxl-3">
                            @template.pages.therapist.patient.card(patient = patient, basePath = "/therapist/patient")
                        </div>
                    @endfor
                @else
                    <div class="col-12">
                        <div class="alert alert-info text-center">
                            No patients assigned to you yet.
                        </div>
                    </div>
                @endif
            </div>

            @if(totalPages > 0)
                <div class="d-flex justify-content-between align-items-center pt-8">
                    <div class="text-muted fs-7">
                        Showing
                        ${currentPage * pageSize + 1}
                        to
                        ${Math.min((currentPage + 1) * pageSize, totalItems)}
                        of
                        ${totalItems}
                        entries
                    </div>

                    <ul class="pagination m-0">
                        @if(patients.hasPrevious())
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&query=${query != null ? query : ""}">Previous</a>
                            </li>
                        @else
                            <li class="page-item disabled"><span class="page-link">Previous</span></li>
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
                                <a class="page-link" href="?page=${currentPage + 1}&query=${query != null ? query : ""}">Next</a>
                            </li>
                        @else
                            <li class="page-item disabled"><span class="page-link">Next</span></li>
                        @endif
                    </ul>
                </div>
            @endif
        </div>
    </div>
    <!--end::Content-->
`)