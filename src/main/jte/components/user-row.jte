@import com.madania.management.entity.User
@import com.madania.management.enums.Role

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param User user

<tr>

    <td class="d-flex align-items-center">
        <!--begin:: Avatar -->
        <div class="symbol symbol-circle symbol-50px overflow-hidden me-3">
            <a href="">
                <div class="symbol-label">
                    <img src="/media/avatars/blank.png" alt="${user.getUsername()}" class="w-100" />
                </div>
            </a>
        </div>
        <!--end::Avatar-->
        <!--begin::User details-->
        <div class="d-flex flex-column">
            <a href="" class="text-gray-800 text-hover-primary mb-1">${user.getUsername()}</a>
            <span>${user.getEmail()}</span>
        </div>
        <!--begin::User details-->
    </td>
    <td>
        @if(user.getRole().equals(Role.PARENT))
            <div class="badge badge-warning fw-bold mx-auto">Parent</div>
        @elseif(user.getRole().equals(Role.THERAPIST))
            <div class="badge badge-success fw-bold mx-auto">Therapist</div>
        @elseif(user.getRole().equals(Role.ADMIN))
            <div class="badge badge-danger fw-bold mx-auto">Admin</div>
        @endif
    </td>
    <td>
        ${user.getCreatedAt().toLocalDate().toString()}
    </td>
    <td>
        @if(user.isActive())
            <div class="badge badge-primary fw-bold mx-auto">Active</div>
        @else
            <div class="badge badge-danger fw-bold mx-auto">Deactivated</div>
        @endif
    </td>
    <td class="text-end">
        <a href="#" class="btn btn-light btn-active-light-primary btn-flex btn-center btn-sm" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">Actions
            <i class="ki-outline ki-down fs-5 ms-1"></i></a>
        <!--begin::Menu-->
        <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-6 w-150px py-4" data-kt-menu="true">
            <!--begin::Menu item-->
            <div class="menu-item px-5">
                <form action="/admin/users/${user.getId()}/edit" method="get" style="display:inline">
                    <button type="submit" class="btn btn-bg-light btn-active-color-success btn-sm d-block w-100 d-flex justify-content-start ms-2">
                        <i class="ki-outline ki-notepad-edit fs-3"></i> Edit
                    </button>
                </form>
            </div>
            <!--end::Menu item-->
            <!--begin::Menu item-->
            @if(!user.getEmail().equals("admin@madania.com"))
                <div class="menu-item px-5">
                @if(user.isActive())
                    <form action="/admin/users/${user.getId()}/deactive" method="post" style="display:inline"
                          onsubmit="return confirm('Are you sure you want to deactivate this user?');">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                        <button type="submit" class="btn btn-bg-light btn-active-color-danger btn-sm d-block w-100 d-flex justify-content-start ms-2">
                            <i class="ki-outline ki-cross-square fs-3"></i> Deactivate
                        </button>
                    </form>
                @else
                    <form action="/admin/users/${user.getId()}/active" method="post" style="display:inline"
                          onsubmit="return confirm('Are you sure you want to activate this user?');">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                        <button type="submit" class="btn btn-bg-light btn-active-color-primary btn-sm d-block w-100 d-flex justify-content-start ms-2">
                            <i class="ki-outline ki-check-circle fs-3"></i> Activate
                        </button>
                    </form>
                @endif
            </div>
            @endif
            <!--end::Menu item-->
            <!--begin::Menu item-->
            @if(!user.getEmail().equals("admin@madania.com"))
                <div class="menu-item px-5">
                    <form action="/admin/users/${user.getId()}/delete" method="post" style="display:inline"
                          onsubmit="return confirm('Are you sure you want to delete this user? This cannot be undone.');">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                        <button type="submit" class="btn btn-bg-light btn-active-color-danger btn-sm d-block w-100 d-flex justify-content-start ms-2">
                            <i class="ki-outline ki-trash fs-3"></i> Delete
                        </button>
                    </form>
                </div>
            @endif
            <!--end::Menu item-->
        </div>
        <!--end::Menu-->
    </td>
</tr>
