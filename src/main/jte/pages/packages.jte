@import com.madania.management.entity.TherapyPackage
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<TherapyPackage> packages

@template.layout.base(
title = "Therapy Packages",
role = role,
content = @`
    <h1>Therapy Packages</h1>
    <a href="/admin/packages/create" class="btn btn-primary">+ Create New Package</a>

    <table class="table">
        <thead>
        <tr>
            <th>Patient</th>
            <th>Therapist</th>
            <th>Start Date</th>
            <th>Progress</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        @if(packages.isEmpty())
            @for(TherapyPackage pkg : packages)
                @template.components.package-row(therapyPackage = pkg, _csrf = _csrf)
            @endfor
        @else
            <p>No packages available</p>
        @endif

        </tbody>
    </table>
`
)