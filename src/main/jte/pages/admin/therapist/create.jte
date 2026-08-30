@import com.madania.management.dto.TherapistCreateRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapistCreateRequest request
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Add Therapist",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <h1>Add Therapist</h1>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    <form action="/admin/therapist/create" method="post">
        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

        <div class="mb-5">
            <label>Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Full Name</label>
            <input type="text" name="fullName" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Specialization</label>
            <input type="text" name="specialization" class="form-control" placeholder="e.g. Speech Therapy" required>
        </div>

        <div class="mb-5">
            <label>Phone</label>
            <input type="text" name="phone" class="form-control">
        </div>

        <button type="submit" class="btn btn-primary">Create Therapist</button>
    </form>
`
)