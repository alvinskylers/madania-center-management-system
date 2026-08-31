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
            <span class="badge badge-light-success">Aktif</span>
        @elseif(therapyPackage.getStatus().name().equals("COMPLETED"))
            <span class="badge badge-light-primary">Tuntas</span>
        @else
            <span class="badge badge-light-danger">Dibatalkan</span>
        @endif
    </td>
    <td>
        <a href="/admin/package/${String.valueOf(therapyPackage.getId())}" class="btn btn-bg-light btn-active-color-primary btn-sm justify-content-end">
            <i class="ki-outline ki-eye fs-3"></i> Lihat
        </a>
    </td>
</tr>