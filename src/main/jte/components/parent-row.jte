@import com.madania.management.entity.Parent
@import com.madania.management.enums.Role

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param Parent parent
<tr>

    <td class="d-flex align-items-center">
        <!--begin:: Avatar -->
        <div class="symbol symbol-circle symbol-50px overflow-hidden me-3">
            <a href="">
                <div class="symbol-label">
                    <img src="/media/avatars/blank.png" alt="${parent.getFullName()}" class="w-100" />
                </div>
            </a>
        </div>
        <!--end::Avatar-->
        <!--begin::User details-->
        <div class="d-flex flex-column">
            <a href="" class="text-gray-800 text-hover-primary mb-1">${parent.getFullName()}</a>
            <span>${parent.getUser().getEmail()}</span>
        </div>
        <!--begin::User details-->
    </td>
    <td>
        ${parent.getPhone()}
    </td>
    <td>
        ${parent.getAddress()}
    </td>
    <td class="text-end">
        <a href="#" class="btn btn-light btn-active-light-primary btn-flex btn-center btn-sm" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">Tindakan
            <i class="ki-outline ki-down fs-5 ms-1"></i></a>
        <!--begin::Menu-->
        <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-6 w-150px py-4" data-kt-menu="true">
            <!--begin::Menu item-->
            <div class="menu-item px-5">
                <a href="/admin/parent/${String.valueOf(parent.getId())}" class="btn btn-bg-light btn-active-color-success btn-sm d-block w-100 d-flex justify-content-start ms-2">
                    <i class="ki-outline ki-eye fs-3"></i> Lihat
                </a>
            </div>
            <div class="menu-item px-5">
                <form action="/admin/parent/${String.valueOf(parent.getId())}/edit" method="get" style="display:inline">
                    <button type="submit" class="btn btn-bg-light btn-active-color-success btn-sm d-block w-100 d-flex justify-content-start ms-2">
                        <i class="ki-outline ki-notepad-edit fs-3"></i> Ubah
                    </button>
                </form>
            </div>
            <!--end::Menu item-->
            <!--begin::Menu item-->
            <div class="menu-item px-5">
                <form action="/admin/parent/${String.valueOf(parent.getId())}/delete" method="post" style="display:inline"
                      onsubmit="return confirm('Are you sure you want to delete this user? This cannot be undone.');">
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                    <button type="submit" class="btn btn-bg-light btn-active-color-danger btn-sm d-block w-100 d-flex justify-content-start ms-2">
                        <i class="ki-outline ki-trash fs-3"></i> Hapus
                    </button>
                </form>
            </div>
            <!--end::Menu item-->
        </div>
        <!--end::Menu-->
    </td>
</tr>
