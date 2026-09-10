@import com.madania.management.entity.User
@import com.madania.management.enums.Role
@import java.time.format.DateTimeFormatter;

@param String role
@param User user
@param org.springframework.security.web.csrf.CsrfToken _csrf

<tr>
    <td>
        <span class="text-gray-800 mb-1">${user.getName()}</span>
    </td>
    <td>
        <a href="mailto:${user.getEmail()}" class="text-gray-600 text-hover-primary mb-1">${user.getEmail()}</a>
    </td>
    <td>
        @if(user.getRole() == Role.ADMIN)
            <span class="badge badge-light-danger">Admin</span>
        @elseif(user.getRole() == Role.RECEPTIONIST)
            <span class="badge badge-light-primary">Resepsionis</span>
        @elseif(user.getRole() == Role.THERAPIST)
            <span class="badge badge-light-info">Terapis</span>
        @elseif(user.getRole() == Role.PARENT)
            <span class="badge badge-light-warning">Wali Pasien</span>
        @endif
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
                @if(user.getRole().equals(Role.THERAPIST))
                    <a href="/admin/therapist/by-user/${String.valueOf(user.getId())}" class="menu-link px-3">Lihat Profil</a>
                @elseif(user.getRole().equals(Role.PARENT))
                    <a href="/admin/parent/by-user/${String.valueOf(user.getId())}" class="menu-link px-3">Lihat Profil</a>
                @endif
            </div>
            <div class="menu-item px-3">
                <!-- Delete form with CSRF protection -->
                <form method="post" action="/admin/users/${String.valueOf(user.getId())}/delete" style="display:inline;">
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}" />
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