@import com.madania.management.dto.ProfileUpdateRequest
@import org.springframework.validation.BindingResult

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ProfileUpdateRequest request
@param BindingResult bindingResult = null

@template.layout.base(
title = "My Profile",
role = role,
_csrf = _csrf,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">My Profile</h1>
        <a href="/profile/password" class="btn btn-light">Change Password</a>
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
            <form action="/profile/edit" method="post">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                <div class="mb-5">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="username" class="form-control"
                           value="${request.getUsername()}" required>
                </div>

                <div class="mb-5">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control"
                           value="${request.getEmail()}" required>
                </div>

                <div class="mb-5">
                    <label class="form-label">Phone</label>
                    <input type="text" name="phone" class="form-control"
                           value="${request.getPhone() != null ? request.getPhone() : ""}">
                </div>

                <div class="mb-5">
                    <label class="form-label">Specialization</label>
                    <input type="text" name="specialization" class="form-control"
                           value="${request.getSpecialization() != null ? request.getSpecialization() : ""}" required>
                </div>

                <button type="submit" class="btn btn-primary">Save Changes</button>
            </form>
        </div>
    </div>
`
)