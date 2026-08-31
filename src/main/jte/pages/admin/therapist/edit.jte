@import com.madania.management.dto.TherapistEditRequest
@import com.madania.management.entity.User
@import com.madania.management.entity.Notification
@import org.springframework.validation.BindingResult
@import java.util.List
@import java.util.UUID

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapistEditRequest request
@param UUID userId
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Ubah Terapis",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <h1>Ubah Terapis</h1>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    <form action="/admin/therapist/${String.valueOf(userId)}/edit" method="post">
        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

        <div class="mb-5">
            <label>Email</label>
            <input type="email" name="email" class="form-control" value="${request.getEmail()}" required>
        </div>

        <div class="mb-5">
            <label>Nama Lengkap</label>
            <input type="text" name="fullName" class="form-control" value="${request.getFullName()}" required>
        </div>

        <div class="mb-5">
            <label>Spesialisasi</label>
            <input type="text" name="specialization" class="form-control" value="${request.getSpecialization()}" required>
        </div>

        <div class="mb-5">
            <label>Telepon</label>
            <input type="text" name="phone" class="form-control" value="${request.getPhone()}">
        </div>

        <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
    </form>
`
)