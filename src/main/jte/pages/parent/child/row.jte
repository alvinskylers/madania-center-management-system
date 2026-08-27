@import com.madania.management.dto.PackageJournalGroup
@import com.madania.management.dto.SessionJournalPair
@import com.madania.management.enums.PackageStatus
@import com.madania.management.enums.SessionStatus
@import java.util.UUID

@param PackageJournalGroup group
@param int index
@param String journalBasePath = "/parent/journal"
@param UUID viewerTherapistId = null

<div class="accordion-item">
    <h2 class="accordion-header" id="pkg_heading_${index}">
        <button class="accordion-button ${index == 0 ? "" : "collapsed"} fs-5 fw-semibold" type="button"
                data-bs-toggle="collapse" data-bs-target="#pkg_collapse_${index}"
                aria-expanded="${index == 0 ? "true" : "false"}" aria-controls="pkg_collapse_${index}">
            <div class="d-flex flex-column flex-md-row justify-content-between w-100 me-5">
                <span>
                    Package: ${group.getTherapyPackage().getStartDate().toString()}
                    to ${group.getTherapyPackage().getEndDate() != null ? group.getTherapyPackage().getEndDate().toString() : "ongoing"}
                    &nbsp;&middot;&nbsp; ${group.getTherapyPackage().getTherapist().getFullName()}
                </span>
                <span class="fs-7 text-muted">
                    ${group.getTherapyPackage().getCompletedSessions()} / ${group.getTherapyPackage().getTotalSessions()} sessions completed
                    &nbsp;
                    @if(group.getTherapyPackage().getStatus() == PackageStatus.ACTIVE)
                        <span class="badge badge-light-primary">Active</span>
                    @elseif(group.getTherapyPackage().getStatus() == PackageStatus.COMPLETED)
                        <span class="badge badge-light-success">Completed</span>
                    @elseif(group.getTherapyPackage().getStatus() == PackageStatus.CANCELLED)
                        <span class="badge badge-light-danger">Cancelled</span>
                    @endif
                </span>
            </div>
        </button>
    </h2>
    <div id="pkg_collapse_${index}" class="accordion-collapse collapse ${index == 0 ? "show" : ""}"
         aria-labelledby="pkg_heading_${index}" data-bs-parent="#kt_patient_packages_accordion">
        <div class="accordion-body">
            <table class="table align-middle table-row-dashed gy-3">
                <thead>
                <tr class="fs-7 text-muted text-uppercase">
                    <th>Session #</th>
                    <th>Date &amp; Time</th>
                    <th>Status</th>
                    <th>Journal</th>
                </tr>
                </thead>
                <tbody class="fs-6">
                @for(SessionJournalPair pair : group.getSessions())
                    <tr>
                        <td>${pair.getSession().getSessionNumber()}</td>
                        <td>${pair.getSession().getStartTime().toString()}</td>
                        <td>
                            @if(pair.getSession().getStatus() == SessionStatus.SCHEDULED)
                                <span class="badge badge-light-primary">Scheduled</span>
                            @elseif(pair.getSession().getStatus() == SessionStatus.COMPLETED)
                                <span class="badge badge-light-success">Completed</span>
                            @elseif(pair.getSession().getStatus() == SessionStatus.CANCELLED)
                                <span class="badge badge-light-danger">Cancelled</span>
                            @elseif(pair.getSession().getStatus() == SessionStatus.RESCHEDULED)
                                <span class="badge badge-light-warning">Rescheduled</span>
                            @endif
                        </td>
                        <td>
                            @if(pair.getJournal() != null)
                                @if(viewerTherapistId == null || pair.getJournal().getTherapist().getId().equals(viewerTherapistId))
                                    <a href="${journalBasePath}/${String.valueOf(pair.getJournal().getId())}" class="btn btn-light-primary btn-sm">
                                        View Journal
                                    </a>
                                @else
                                    <span class="text-muted fs-7">Written by ${pair.getJournal().getTherapist().getFullName()}</span>
                                @endif
                            @else
                                <span class="text-muted fs-7">Not written yet</span>
                            @endif
                        </td>
                    </tr>
                @endfor
                </tbody>
            </table>
        </div>
    </div>
</div>