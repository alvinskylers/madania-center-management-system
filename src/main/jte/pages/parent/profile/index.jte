@import com.madania.management.dto.ProfileUpdateRequest
@import com.madania.management.entity.Notification
@import org.springframework.validation.BindingResult
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ProfileUpdateRequest request
@param BindingResult bindingResult = null
@param String success
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null


@template.layout.base(
title = "Edit Profile",
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

    <!--begin::My Profile - only the user details card (no slider)-->
    <div class="row g-7 justify-content-center">
        <div class="col-12 col-lg-8 col-xl-6">
            <!--begin::Card (copied from new HTML's left sidebar)-->
            <div class="card mb-5 mb-xl-8">
                <!--begin::Card header with title and buttons-->
                <div class="card-header">
                    <div class="card-title">
                        <i class="ki-outline ki-user fs-1 me-2"></i>
                        <h2>My Profile</h2>
                    </div>
                    <div class="card-toolbar gap-3">
                        <a href="/profile/edit" class="btn btn-sm btn-light btn-active-light-primary">
                            <i class="ki-outline ki-pencil fs-2 me-1"></i>Edit Profile
                        </a>
                        <a href="/profile/password" class="btn btn-sm btn-primary">
                            <i class="ki-outline ki-key fs-2 me-1"></i>Change Password
                        </a>
                    </div>
                </div>
                <!--end::Card header-->

                <!--begin::Card body-->
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

                    <!--begin::User Info (avatar + name)-->
                    <div class="d-flex flex-center flex-column py-5">
                        <!--begin::Avatar (using static blank.png, or you can use initials)-->
                        <div class="symbol symbol-100px symbol-circle mb-7">
                            <img src="/media/avatars/blank.png" alt="user" />
                        </div>
                        <!--end::Avatar-->
                        <!--begin::Name-->
                        <a href="#" class="fs-3 text-gray-800 text-hover-primary fw-bold mb-3">
                            ${request.getUsername()}
                        </a>
                        <!--end::Name-->
                        <!--begin::Position/Role-->
                        <div class="mb-9">
                            <div class="badge badge-lg badge-light-primary d-inline">${role}</div>
                        </div>
                        <!--end::Position-->

                    </div>
                    <!--end::User Info-->

                    <!--begin::Details toggle (optional)-->
                    <div class="d-flex flex-stack fs-4 py-3">
                        <div class="fw-bold rotate collapsible" data-bs-toggle="collapse" href="#kt_user_view_details" role="button" aria-expanded="true" aria-controls="kt_user_view_details">
                            Details
                            <span class="ms-2 rotate-180">
                  <i class="ki-outline ki-down fs-3"></i>
                </span>
                        </div>
                    </div>
                    <div class="separator"></div>

                    <!--begin::Details content-->
                    <div id="kt_user_view_details" class="collapse show">
                        <div class="pb-5 fs-6">

                            <!-- Email -->
                            <div class="fw-bold mt-5">Email</div>
                            <div class="text-gray-600">
                                <a href="mailto:${request.getEmail()}" class="text-gray-600 text-hover-primary">${request.getEmail()}</a>
                            </div>

                            <!-- Phone -->
                            <div class="fw-bold mt-5">Phone</div>
                            <div class="text-gray-600">${request.getPhone() != null && !request.getPhone().isEmpty() ? request.getPhone() : "Not provided"}</div>

                            <!-- Address -->
                            <div class="fw-bold mt-5">Address</div>
                            <div class="text-gray-600">${request.getAddress() != null && !request.getAddress().isEmpty() ? request.getAddress() : "Not specified"}</div>


                        </div>
                    </div>
                    <!--end::Details content-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card-->
        </div>
    </div>
    <!--end::My Profile-->
`
)