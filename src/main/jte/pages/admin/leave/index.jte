@import com.madania.management.entity.LeaveRequest
@import com.madania.management.entity.Notification
@import com.madania.management.enums.LeaveStatus
@import com.madania.management.entity.User
@import java.util.List

@param User user
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
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Leave Requests</h1>
    </div>

    @if(leaveSuccess != null)
        <div class="alert alert-success"><p>${leaveSuccess}</p></div>
    @endif
    @if(leaveError != null)
        <div class="alert alert-danger"><p>${leaveError}</p></div>
    @endif

    <div class="card">
        <div class="card-body">
            <table class="table align-middle">
                <thead>
                <tr>
                    <th>Therapist</th>
                    <th>Start</th>
                    <th>End</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                @if(requests != null && !requests.isEmpty())
                    @for(LeaveRequest r : requests)
                        <tr>
                            <td>${r.getTherapist().getFullName()}</td>
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
                            <td>
                                <a href="/admin/leaves/${String.valueOf(r.getId())}" class="btn btn-light-primary btn-sm">
                                    @if(r.getStatus() == LeaveStatus.PENDING)
                                        Review
                                    @else
                                        View
                                    @endif
                                </a>
                            </td>
                        </tr>
                    @endfor
                @else
                    <tr><td colspan="6">No leave requests yet</td></tr>
                @endif
                </tbody>
            </table>
        </div>
    </div>
`
)