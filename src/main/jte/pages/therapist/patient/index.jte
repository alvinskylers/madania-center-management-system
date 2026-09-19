@import com.madania.management.entity.User
@import com.madania.management.entity.Patient
@import org.springframework.data.domain.Page

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param User user
@param String role
@param Page<Patient> patients
@param int currentPage = 0
@param int totalPages = 0
@param long totalItems = 0
@param int pageSize = 12
@param String query = null
@param String patientError = null
@param boolean myPatients = false

@template.layout.base(
title = "My Patients",
role = role,
user = user,
_csrf = _csrf,
content = @`

    @if(patientError != null)
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>${patientError}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
        </div>
    @endif

    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="d-flex flex-wrap align-items-center my-1">
                    <h1 class="page-heading text-gray-900 fw-bold fs-3 m-0 me-5">${myPatients ? "Pasien Saya" : "Semua Pasien"}</h1>
                    <form method="GET" action="/therapist/patients" class="d-flex align-items-center position-relative my-1">
                        <i class="ki-outline ki-magnifier fs-3 position-absolute ms-3"></i>
                        <input type="text" name="query" class="form-control form-control-sm border-body bg-body w-200px ps-10" placeholder="Cari pasien..." value="${query != null ? query : ""}" />
                        <input type="hidden" name="page" value="0" />
                        <input type="hidden" name="myPatients" value="${String.valueOf(myPatients)}" />
                        <button type="submit" class="btn btn-primary ms-2 d-none d-sm-inline-block">Cari</button>
                    </form>
                    <div class="form-check form-switch form-check-custom form-check-solid ms-5">
                        <input class="form-check-input" type="checkbox" id="myPatientsToggle" checked="${myPatients}" />
                        <label class="form-check-label fw-semibold text-gray-700" for="myPatientsToggle">Pasien Saya saja</label>
                    </div>
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
                        <div class="col-md-6 col-xxl-4">
                            @template.pages.therapist.patient.card(patient = patient, basePath = "/therapist/patient")
                        </div>
                    @endfor
                @else
                    <div class="col-12">
                        <div class="alert alert-info text-center">
                            ${myPatients ? "Anda belum memiliki pasien" : "Tidak ada pasien ditemukan"}
                        </div>
                    </div>
                @endif
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
                        @if(patients.hasPrevious())
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&query=${query != null ? query : ""}&myPatients=${String.valueOf(myPatients)}">Sebelum</a>
                            </li>
                        @else
                            <li class="page-item disabled"><span class="page-link">Sebelum</span></li>
                        @endif

                        @for(int i = 0; i < totalPages; i++)
                            @if(i == currentPage)
                                <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                            @else
                                <li class="page-item">
                                    <a class="page-link" href="?page=${i}&query=${query != null ? query : ""}&myPatients=${String.valueOf(myPatients)}">${i + 1}</a>
                                </li>
                            @endif
                        @endfor

                        @if(patients.hasNext())
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&query=${query != null ? query : ""}&myPatients=${String.valueOf(myPatients)}">Berikut</a>
                            </li>
                        @else
                            <li class="page-item disabled"><span class="page-link">Berikut</span></li>
                        @endif
                    </ul>
                </div>
            @endif
        </div>
    </div>
    <!--end::Content-->

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var toggle = document.getElementById("myPatientsToggle");
            if (!toggle) return;
            toggle.addEventListener("change", function () {
                var params = new URLSearchParams(window.location.search);
                params.set("myPatients", toggle.checked ? "true" : "false");
                params.set("page", "0");
                window.location.href = "/therapist/patients?" + params.toString();
            });
        });
    </script>
`)