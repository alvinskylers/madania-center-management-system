@import com.madania.management.entity.Notification
@import com.madania.management.entity.Patient
@import java.util.List

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param String success
@param String error
@param java.util.List<Patient> patients
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Patients",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
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
                    <form method="GET" action="" class="d-flex align-items-center position-relative my-1">
                        <i class="ki-outline ki-magnifier fs-3 position-absolute ms-3"></i>
                        <input type="text" name="search" id="patientSearch" class="form-control form-control-sm border-body bg-body w-200px ps-10" placeholder="Search patients..." value="" />
                        <button type="submit" class="btn btn-primary ms-2 d-none d-sm-inline-block">Search</button>
                        <!-- optional: if you want to keep the button hidden and rely on Enter, you can remove the button and just use input -->
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
                            No patients registered yet.
                        </div>
                    </div>
                @endif
            </div>
            <!--end::Patients Grid-->
        </div>
    </div>
    <!--end::Content-->
`)