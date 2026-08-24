@import com.madania.management.entity.LeaveRequest
@import com.madania.management.entity.Notification
@import com.madania.management.enums.LeaveStatus
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<LeaveRequest> requests
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null
@param String leaveError = null
@param String leaveSuccess = null

@template.layout.base(
title = "Leave Requests",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">My Leave Requests</h1>
    </div>

    @if(leaveSuccess != null)
        <div class="alert alert-success"><p>${leaveSuccess}</p></div>
    @endif
    @if(leaveError != null)
        <div class="alert alert-danger"><p>${leaveError}</p></div>
    @endif

    <div class="card mb-5">
        <div class="card-body">
            <h5 class="mb-5">Request Leave</h5>
            <form action="/therapist/leave" method="post">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="fs-6 fw-semibold mb-2">Start date</label>
                        <input type="date" class="form-control" name="startDate" required>
                    </div>
                    <div class="col-md-4">
                        <label class="fs-6 fw-semibold mb-2">End date</label>
                        <input type="date" class="form-control" name="endDate" required>
                    </div>
                </div>
                <div class="fv-row mb-3">
                    <label class="fs-6 fw-semibold mb-2">Reason</label>
                    <textarea class="form-control" name="reason" rows="2" placeholder="e.g. Family event, medical leave"></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Submit Leave Request</button>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <h5 class="mb-5">History</h5>
            <table class="table align-middle">
                <thead>
                <tr>
                    <th>Start</th>
                    <th>End</th>
                    <th>Reason</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                @if(requests != null && !requests.isEmpty())
                    @for(LeaveRequest r : requests)
                        <tr>
                            <td>${r.getStartDate().toString()}</td>
                            <td>${r.getEndDate().toString()}</td>
                            <td>${r.getReason() != null ? r.getReason() : "-"}</td>
                            <td>
                                @if(r.getStatus() == LeaveStatus.PENDING)
                                    <span class="badge badge-light-warning">Pending</span>
                                @elseif(r.getStatus() == LeaveStatus.APPROVED)
                                    <span class="badge badge-light-success">Approved</span>
                                @elseif(r.getStatus() == LeaveStatus.REJECTED)
                                    <span class="badge badge-light-danger">Rejected</span>
                                @endif
                            </td>
                        </tr>
                    @endfor
                @else
                    <tr><td colspan="4">No leave requests yet</td></tr>
                @endif
                </tbody>
            </table>
        </div>
    </div>
`
)