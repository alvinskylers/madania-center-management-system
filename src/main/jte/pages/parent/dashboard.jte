@import com.madania.management.entity.Parent
@import com.madania.management.entity.Patient
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param Parent parent
@param List<Patient> children

@template.layout.base(
title = "Dashboard",
role = role,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Welcome, ${parent.getFullName()}</h1>
    </div>

    <div class="row g-5">
        @for(Patient child : children)
            <div class="col-md-4">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title">${child.getFullName()}</h5>
                        <p class="text-muted">${child.getDiagnosis()}</p>
                        <p>
                            <small class="text-muted">
                                Date of Birth: ${child.getDateOfBirth().toString()}
                            </small>
                        </p>
                        <div class="d-flex gap-2 mt-4">
                            <a href="/parent/schedule" class="btn btn-sm btn-light-primary">
                                View Schedule
                            </a>
                            <a href="/parent/journals" class="btn btn-sm btn-light-info">
                                View Journals
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        @endfor
    </div>
`
)