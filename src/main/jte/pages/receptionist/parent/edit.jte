@import com.madania.management.dto.ParentEditRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import org.springframework.validation.BindingResult
@import java.util.List
@import java.util.UUID

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ParentEditRequest request
@param UUID userId
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Ubah Wali",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 mb-5">
        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted"><a href="/receptionist/parents" class="text-muted text-hover-primary">Wali Pasien</a></li>
        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
        <li class="breadcrumb-item text-muted">Ubah Wali Pasien</li>
    </ul>
    <h1>Ubah Wali Pasien</h1>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    <form action="/receptionist/parent/${String.valueOf(userId)}/edit" method="post">
        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

        <div class="mb-5">
            <label>Email</label>
            <input type="email" name="email" class="form-control" value="${request.getEmail()}" required>
        </div>

        <div class="mb-5">
            <label>Nama Wali</label>
            <input type="text" name="fullName" class="form-control" value="${request.getFullName()}" required>
        </div>

        <div class="mb-5">
            <label>Telepon</label>
            <input type="text" name="phone" class="form-control" value="${request.getPhone()}">
        </div>

        <div class="mb-5">
            <label>Alamat</label>
            <input type="text" name="address" class="form-control" value="${request.getAddress()}">
        </div>

        <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
    </form>
`
)
