@import com.madania.management.entity.TherapyPackage

@param TherapyPackage therapyPackage
@param org.springframework.security.web.csrf.CsrfToken _csrf

<tr>
    <td>${therapyPackage.getPatient().getFullName()}</td>
    <td>${therapyPackage.getTherapist().getFullName()}</td>
    <td>${therapyPackage.getStartDate().toString()}</td>
    <td>${therapyPackage.getCompletedSessions()} / ${therapyPackage.getTotalSessions()}</td>
    <td>
        @if(therapyPackage.getStatus().name().equals("ACTIVE"))
            <span class="badge badge-success">Active</span>
        @elseif(therapyPackage.getStatus().name().equals("COMPLETED"))
            <span class="badge badge-primary">Completed</span>
        @else
            <span class="badge badge-danger">Cancelled</span>
        @endif
    </td>
    <td>
        <a href="/admin/package/${String.valueOf(therapyPackage.getId())}" class="btn btn-icon btn-bg-light btn-sm">
            <i class="ki-outline ki-eye fs-3"></i>
        </a>

        @if(therapyPackage.getStatus().name().equals("ACTIVE"))
            <form action="/admin/package/${String.valueOf(therapyPackage.getId())}/cancel" method="post" class="d-inline-block"
                  onsubmit="return confirm('Cancel this package? All remaining scheduled sessions will be cancelled.');">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <button type="submit" class="btn btn-icon btn-bg-light btn-sm">
                    <i class="ki-outline ki-cross-circle fs-3"></i>
                </button>
            </form>
        @endif
    </td>
</tr>