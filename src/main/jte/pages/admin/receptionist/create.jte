@import com.madania.management.dto.ReceptionistCreateRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ReceptionistCreateRequest request
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Buat Resepsionis",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 mb-5">
        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted"><a href="/admin/users" class="text-muted text-hover-primary">Pengguna</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted">Buat Resepsionis</li>
    </ul>
    <h1>Tambah Resepsionis</h1>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    <form action="/admin/receptionist/create" method="post">
        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

        <div class="mb-5">
            <label>Username</label>
            <input type="text" name="username" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-primary">Buat Resepsionis</button>
    </form>
`
)