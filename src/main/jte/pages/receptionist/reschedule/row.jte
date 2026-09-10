@import com.madania.management.entity.RescheduleRequest
@import com.madania.management.enums.RescheduleStatus
@import java.time.format.DateTimeFormatter

@param RescheduleRequest request
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{String reqId = String.valueOf(request.getId());}
!{DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");}

<tr>
    <td class="text-gray-800 fw-semibold">${request.getSession().getPatient().getFullName()}</td>
    <td class="text-gray-700">${request.getSession().getTherapist().getFullName()}</td>
    <td class="text-muted fs-7">${request.getSession().getStartTime().format(fmt)}</td>
    <td class="text-muted fs-7">${request.getRequestedStartTime().format(fmt)}</td>
    <td>
        ${request.getRequestedBy().getName()}
        <span class="text-muted fs-8 d-block">${request.getRequestedBy().getRole().name()}</span>
    </td>
    <td class="text-gray-700">${request.getReason() != null && !request.getReason().isBlank() ? request.getReason() : "—"}</td>
    <td>
        @if(request.getStatus() == RescheduleStatus.PENDING)
            <span class="badge badge-light-warning">Menunggu</span>
        @elseif(request.getStatus() == RescheduleStatus.APPROVED)
            <span class="badge badge-light-success">Disetujui</span>
        @else
            <span class="badge badge-light-danger">Ditolak</span>
        @endif
    </td>
    <td class="text-end">
        @if(request.getStatus() == RescheduleStatus.PENDING)
            <form action="/receptionist/reschedules/${reqId}/approve" method="post" class="d-inline-block mb-1" id="approve-form-${reqId}">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <button type="button" class="btn btn-light-success btn-sm reschedule-confirm-btn"
                        data-form-id="approve-form-${reqId}"
                        data-message="Approve this reschedule? The session time will be updated immediately.">
                    <i class="ki-outline ki-check fs-4"></i>Setujui
                </button>
            </form>

            <form action="/receptionist/reschedules/${reqId}/reject" method="post" class="d-inline-block mb-1" id="reject-form-${reqId}">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <button type="button" class="btn btn-light-danger btn-sm reschedule-confirm-btn"
                        data-form-id="reject-form-${reqId}"
                        data-message="Reject this reschedule request?">
                    <i class="ki-outline ki-cross fs-4"></i>Tolak
                </button>
            </form>
        @else
            <span class="text-muted">—</span>
        @endif
    </td>
</tr>
