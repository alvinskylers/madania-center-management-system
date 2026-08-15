@import com.madania.management.dto.ParentCreateRequest
@import org.springframework.validation.BindingResult

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param ParentCreateRequest request
@param BindingResult bindingResult = null

@template.layout.base(
title = "Add Parent",
role = role,
_csrf = _csrf,
content = @`
    <h1>Add Parent</h1>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    <form action="/admin/parent/create" method="post">
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

        <div class="mb-5">
            <label>Full Name</label>
            <input type="text" name="fullName" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Phone</label>
            <input type="text" name="phone" class="form-control">
        </div>

        <div class="mb-5">
            <label>Address</label>
            <input type="text" name="address" class="form-control">
        </div>

        <button type="submit" class="btn btn-primary">Create Parent</button>
    </form>
`
)