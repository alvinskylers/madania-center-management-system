@import com.madania.management.dto.ChangePasswordRequest
@import com.madania.management.entity.Notification
@import org.springframework.validation.BindingResult
@import com.madania.management.entity.User
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ChangePasswordRequest request
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Change Password",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Change Password</h1>
        <a href="/profile" class="btn btn-light">Back to Profile</a>
    </div>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    <div class="card">
        <div class="card-body">
            <form action="/profile/password" method="post">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                <div class="mb-5">
                    <label class="form-label">Current Password</label>
                    <input type="password" name="currentPassword" class="form-control" required>
                </div>

                <div class="mb-5">
                    <label class="form-label">New Password</label>
                    <input type="password" name="newPassword" class="form-control" required>
                </div>

                <div class="mb-5">
                    <label class="form-label">Confirm New Password</label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-primary">Change Password</button>
            </form>
        </div>
    </div>
`
)