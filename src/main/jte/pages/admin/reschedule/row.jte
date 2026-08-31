@import com.madania.management.entity.RescheduleRequest
@import com.madania.management.enums.RescheduleStatus

@param RescheduleRequest request
@param org.springframework.security.web.csrf.CsrfToken _csrf

<tr>
    <td>${request.getSession().getPatient().getFullName()}</td>
    <td>${request.getSession().getTherapist().getFullName()}</td>
    <td>${request.getSession().getStartTime().toString()}</td>
    <td>${request.getRequestedStartTime().toString()}</td>
    <td>${request.getRequestedBy().getName()} (${request.getRequestedBy().getRole().name()})</td>
    <td>${request.getReason() != null ? request.getReason() : "-"}</td>
    <td>
        @if(request.getStatus() == RescheduleStatus.PENDING)
            <span class="badge badge-light-warning">Menunggu</span>
        @elseif(request.getStatus() == RescheduleStatus.APPROVED)
            <span class="badge badge-light-success">Disetujui</span>
        @elseif(request.getStatus() == RescheduleStatus.REJECTED)
            <span class="badge badge-light-danger">Ditolak</span>
        @endif
    </td>
    <td>
        @if(request.getStatus() == RescheduleStatus.PENDING)
            <form action="/admin/reschedules/${String.valueOf(request.getId())}/approve" method="post" class="d-inline-block mb-1" id="approve-form-${String.valueOf(request.getId())}">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <button type="button" class="btn btn-light-success btn-sm reschedule-confirm-btn"
                        data-form-id="approve-form-${String.valueOf(request.getId())}"
                        data-message="Approve this reschedule? The session time will be updated immediately.">Setujui</button>
            </form>

            <form action="/admin/reschedules/${String.valueOf(request.getId())}/reject" method="post" class="d-inline-block mb-1" id="reject-form-${String.valueOf(request.getId())}">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <button type="button" class="btn btn-light-danger btn-sm reschedule-confirm-btn"
                        data-form-id="reject-form-${String.valueOf(request.getId())}"
                        data-message="Reject this reschedule request?">Tolak</button>
            </form>
        @else
            <span class="text-muted">—</span>
        @endif
    </td>
</tr>