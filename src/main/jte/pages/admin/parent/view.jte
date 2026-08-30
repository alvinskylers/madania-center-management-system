@import com.madania.management.entity.Parent
@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import java.util.List

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param User user
@param Parent parent
@param List<Patient> children

@template.layout.base(
title = "Parent Details",
role = role,
user = user,
_csrf = _csrf,
content = @`
    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Parent Details</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/admin/dashboard" class="text-muted text-hover-primary">Home</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/admin/parents" class="text-muted text-hover-primary">Parents</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${parent.getFullName()}</li>
                    </ul>
                </div>
                <div class="d-flex align-items-center gap-2 gap-lg-3">
                    <a href="/admin/parent/${String.valueOf(parent.getId())}/edit" class="btn btn-light-primary">Edit</a>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="d-flex flex-column flex-lg-row">
                <!--begin::Sidebar-->
                <div class="flex-column flex-lg-row-auto w-lg-250px w-xl-350px mb-10">
                    <div class="card mb-5 mb-xl-8">
                        <div class="card-body">
                            <div class="d-flex flex-center flex-column py-5">
                                <div class="symbol symbol-100px symbol-circle mb-7">
                                    <img src="/media/avatars/blank.png" alt="image" />
                                </div>
                                <a href="#" class="fs-3 text-gray-800 text-hover-primary fw-bold mb-3">${parent.getFullName()}</a>
                            </div>
                            <div class="d-flex flex-stack fs-4 py-3">
                                <div class="fw-bold rotate collapsible" data-bs-toggle="collapse" href="#kt_parent_view_details" role="button" aria-expanded="false" aria-controls="kt_parent_view_details">Details
                                    <span class="ms-2 rotate-180"><i class="ki-outline ki-down fs-3"></i></span></div>
                            </div>
                            <div class="separator"></div>
                            <div id="kt_parent_view_details" class="collapse show">
                                <div class="pb-5 fs-6">
                                    <div class="fw-bold mt-5">Phone</div>
                                    <div class="text-gray-600">${parent.getPhone() != null ? parent.getPhone() : "—"}</div>
                                    <div class="fw-bold mt-5">Address</div>
                                    <div class="text-gray-600">${parent.getAddress() != null ? parent.getAddress() : "—"}</div>
                                    <div class="fw-bold mt-5">Email</div>
                                    <div class="text-gray-600">${parent.getUser().getEmail()}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--end::Sidebar-->

                <!--begin::Content-->
                <div class="flex-lg-row-fluid ms-lg-15">
                    <ul class="nav nav-custom nav-tabs nav-line-tabs nav-line-tabs-2x border-0 fs-4 fw-semibold mb-8">
                        <li class="nav-item"><a class="nav-link text-active-primary pb-4 active" data-bs-toggle="tab" href="#kt_parent_view_children_tab">Children</a></li>
                    </ul>

                    <div class="tab-content" id="myTabContent">
                        <!--begin:::Tab pane: Children-->
                        <div class="tab-pane fade show active" id="kt_parent_view_children_tab" role="tabpanel">
                            <div class="card card-flush mb-6 mb-xl-9">
                                <div class="card-header mt-6">
                                    <div class="card-title flex-column">
                                        <h2 class="mb-1">Children</h2>
                                        <div class="fs-6 fw-semibold text-muted">Patients registered under ${parent.getFullName()}</div>
                                    </div>
                                </div>
                                <div class="card-body p-9 pt-4">
                                    <div class="row g-6 g-xl-9">
                                        @if(children != null && !children.isEmpty())
                                            @for(Patient child : children)
                                                <div class="col-md-3 col-xxl-3">
                                                    @template.components.patient-card(patient = child)
                                                </div>
                                            @endfor
                                        @else
                                            <div class="col-12">
                                                <div class="alert alert-info text-center">
                                                    No children registered under this parent yet.
                                                </div>
                                            </div>
                                        @endif
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--end:::Tab pane-->
                    </div>
                </div>
                <!--end::Content-->
            </div>
        </div>
    </div>
`)