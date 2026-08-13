@import com.madania.management.dto.ProfileUpdateRequest
@import org.springframework.validation.BindingResult

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ProfileUpdateRequest request
@param BindingResult bindingResult = null

@template.layout.base(
title = "My Profile",
role = role,
content = @`
    <!--begin::Edit Profile - form card-->
    <div class="row g-7 justify-content-center">
        <div class="col-12 col-lg-8 col-xl-6">
            <!--begin::Card-->
            <div class="card mb-5 mb-xl-8">
                <!--begin::Card header with title and buttons-->
                <div class="card-header">
                    <div class="card-title">
                        <i class="ki-outline ki-pencil fs-1 me-2"></i>
                        <h2>Edit Profile</h2>
                    </div>
                    <div class="card-toolbar">
                        <a href="/profile" class="btn btn-sm btn-light">
                            <i class="ki-outline ki-arrow-left fs-2 me-1"></i>Cancel
                        </a>
                    </div>
                </div>
                <!--end::Card header-->

                <!--begin::Card body with form-->
                <div class="card-body">
                    <!--begin::Error messages-->
                    @if(bindingResult != null && bindingResult.hasErrors())
                        <div class="alert alert-danger d-flex align-items-center p-5 mb-10">
                            <i class="ki-outline ki-information-5 fs-2hx me-3"></i>
                            <div class="d-flex flex-column">
                                <h4 class="mb-1">Please fix the following errors:</h4>
                                @for(var error : bindingResult.getAllErrors())
                                    <span>• ${error.getDefaultMessage()}</span>
                                @endfor
                            </div>
                        </div>
                    @endif
                    <!--end::Error messages-->

                    <!--begin::Form-->
                    <form action="/profile/edit" method="post" class="form">
                        <!-- CSRF token -->
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}" />

                        <!--begin::Username (Full Name)-->
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold form-label mt-3">Full Name</label>
                            <input type="text" class="form-control form-control-solid"
                                   name="username" value="${request.getUsername()}"
                                   placeholder="Enter full name" />
                        </div>
                        <!--end::Username-->

                        <!--begin::Email-->
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold form-label">Email</label>
                            <input type="email" class="form-control form-control-solid"
                                   name="email" value="${request.getEmail()}"
                                   placeholder="Enter email address" />
                        </div>
                        <!--end::Email-->

                        <!--begin::Phone-->
                        <div class="fv-row mb-7">
                            <label class="fs-6 fw-semibold form-label">Phone</label>
                            <input type="tel" class="form-control form-control-solid"
                                   name="phone" value="${request.getPhone()}"
                                   placeholder="Enter phone number" />
                        </div>
                        <!--end::Phone-->

                        <!--begin::Address (visible only for PARENT)-->
                        @if(role == "PARENT")
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label">Address</label>
                                <input type="text" class="form-control form-control-solid"
                                       name="address" value="${request.getAddress()}"
                                       placeholder="Enter address" />
                            </div>
                        @endif
                        <!--end::Address-->

                        <!--begin::Actions-->
                        <div class="text-center pt-10">
                            <button type="submit" class="btn btn-primary me-2">
                                <i class="ki-outline ki-check fs-2 me-1"></i>Save Changes
                            </button>
                            <a href="/profile" class="btn btn-light">Cancel</a>
                        </div>
                        <!--end::Actions-->
                    </form>
                    <!--end::Form-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card-->
        </div>
    </div>
    <!--end::Edit Profile-->
`
)