@import com.madania.management.dto.PatientRequest
@import com.madania.management.entity.Parent
@import com.madania.management.enums.Gender
@import org.springframework.validation.BindingResult
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param PatientRequest request
@param List<Parent> parents
@param BindingResult bindingResult = null

@template.layout.base(
title = "Add Patient",
role = role,
content = @`
    <h1>Add Patient</h1>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    <form action="/admin/patient/create" method="post">
        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

        <div class="mb-5">
            <label>Parent</label>
            <select name="parentId" class="form-select" required>
                <option value="">Select a parent</option>
                @for(Parent parent : parents)
                    <option value="${String.valueOf(parent.getId())}">${parent.getFullName()}</option>
                @endfor
            </select>
        </div>

        <div class="mb-5">
            <label>Full Name</label>
            <input type="text" name="fullName" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Date of Birth</label>
            <input type="date" name="dateOfBirth" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Gender</label>
            <select name="gender" class="form-select">
                <option value="">Select gender</option>
                <option value="${Gender.MALE}">Male</option>
                <option value="${Gender.FEMALE}">Female</option>
            </select>
        </div>

        <div class="mb-5">
            <label>Diagnosis</label>
            <input type="text" name="diagnosis" class="form-control" placeholder="e.g. Autism, ADHD, Speech Delay">
        </div>

        <div class="mb-5">
            <label>Notes</label>
            <textarea name="notes" class="form-control"></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Create Patient</button>
    </form>
`
)