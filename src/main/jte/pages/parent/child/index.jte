@import com.madania.management.entity.Notification
@import com.madania.management.entity.Patient
@import java.util.List

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param List<Patient> children
@param String patientError = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "My Children",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
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
                    <form method="GET" action="/parent/children" class="d-flex align-items-center position-relative my-1">
                        <i class="ki-outline ki-magnifier fs-3 position-absolute ms-3"></i>
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
                @if (children != null && !children.isEmpty())
                    @for (Patient patient : children)
                        <div class="col-md-3 col-xxl-3">
                            @template.pages.parent.child.card(patient = patient, basePath = "/parent/child")
                        </div>
                    @endfor
                @else
                    <div class="col-12">
                        <div class="alert alert-info text-center">
                            No children registered to you yet.
                        </div>
                    </div>
                @endif
            </div>

        </div>
    </div>
    <!--end::Content-->
`)