@import com.madania.management.entity.User
@import java.time.format.DateTimeFormatter;

@param User user

<tr>
    <td>
        <a href="@{/users/details/{id}(id=user.id)}" class="text-gray-800 text-hover-primary mb-1">${user.getName()}</a>
    </td>
    <td>
        <a href="mailto:@user.email" class="text-gray-600 text-hover-primary mb-1">${user.getEmail()}</a>
    </td>
    <td>
        <span class="badge badge-light">${user.getRole()}</span>
    </td>
    <td>
        @if(user.isActive())
            <div class="badge badge-light-success">Aktif</div>
        @else
            <div class="badge badge-light-danger">Tidak Aktif</div>
        @endif
    </td>
    <td>${user.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy, h:mm a"))}</td>
    <td class="text-end">
        <a href="#" class="btn btn-sm btn-light btn-flex btn-center btn-active-light-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">
            Aksi
            <i class="ki-outline ki-down fs-5 ms-1"></i>
        </a>
        <!--begin::Menu-->
        <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-125px py-4" data-kt-menu="true">
            <div class="menu-item px-3">
                <a href="${"/users/details/{id}(id=user.id)"}" class="menu-link px-3">Lihat</a>
            </div>
            <div class="menu-item px-3">
                <!-- Delete form with CSRF protection -->
                <form method="post" action="${"/users/delete/{id}(id=user.id)"}" style="display:inline;">
                    <input type="hidden" name="_csrf" value="@_csrf.token" />
                    <button type="submit" class="menu-link px-3" style="border:none; background:none; width:100%; text-align:left;"
                            onclick="return confirm('Are you sure you want to delete this user?')">
                        Hapus
                    </button>
                </form>
            </div>
        </div>
        <!--end::Menu-->
    </td>
</tr>