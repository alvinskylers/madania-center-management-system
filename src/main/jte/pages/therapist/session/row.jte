@import com.madania.management.dto.PackageJournalGroup
@import com.madania.management.dto.SessionJournalPair
@import com.madania.management.enums.PackageStatus
@import com.madania.management.enums.SessionStatus
@import java.time.LocalDate
@import java.time.LocalDateTime
@import java.util.UUID

@param PackageJournalGroup group
@param int index
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param int currentPage = 0
@param int pageSize = 5
@param UUID patientId = null
@param LocalDate dateFrom = null
@param LocalDate dateTo = null

!{String patientIdStr = patientId != null ? String.valueOf(patientId) : "";}
!{String dateFromStr = dateFrom != null ? dateFrom.toString() : "";}
!{String dateToStr = dateTo != null ? dateTo.toString() : "";}

<div class="accordion-item">
    <h2 class="accordion-header" id="pkg_heading_${index}">
        <button class="accordion-button ${index == 0 ? "" : "collapsed"} fs-5 fw-semibold" type="button"
                data-bs-toggle="collapse" data-bs-target="#pkg_collapse_${index}"
                aria-expanded="${index == 0 ? "true" : "false"}" aria-controls="pkg_collapse_${index}">
            <div class="d-flex flex-column flex-md-row justify-content-between w-100 me-5">
                <span>
                    <i class="ki-outline ki-user fs-4 me-1"></i>
                    ${group.getTherapyPackage().getPatient().getFullName()}
                    <span class="text-muted fs-7">
                        &nbsp;&middot;&nbsp; ${group.getTherapyPackage().getStartDate().toString()}
                        sampai ${group.getTherapyPackage().getEndDate() != null ? group.getTherapyPackage().getEndDate().toString() : "ongoing"}
                    </span>
                </span>
                <span class="fs-7 text-muted">
                    ${group.getTherapyPackage().getCompletedSessions()} / ${group.getTherapyPackage().getTotalSessions()} Sesi
                    &nbsp;
                    @if(group.getTherapyPackage().getStatus() == PackageStatus.ACTIVE)
                        <span class="badge badge-light-success">Aktif</span>
                    @elseif(group.getTherapyPackage().getStatus() == PackageStatus.COMPLETED)
                        <span class="badge badge-light-primary">Tuntas</span>
                    @else
                        <span class="badge badge-light-danger">Dibatalkan</span>
                    @endif
                </span>
            </div>
        </button>
    </h2>
    <div id="pkg_collapse_${index}" class="accordion-collapse collapse ${index == 0 ? "show" : ""}"
         aria-labelledby="pkg_heading_${index}" data-bs-parent="#kt_therapist_sessions_accordion">
        <div class="accordion-body">
            <div class="table-responsive">
                <table class="table align-middle table-row-dashed gy-3">
                    <thead>
                    <tr class="fs-7 text-muted text-uppercase">
                        <th>No Sesi</th>
                        <th>Tanggal</th>
                        <th>Waktu</th>
                        <th>Status</th>
                        <th class="text-end">Aksi</th>
                    </tr>
                    </thead>
                    <tbody class="fs-6">
                    @for(SessionJournalPair pair : group.getSessions())
                        !{boolean datePassed = !pair.getSession().getStartTime().isAfter(LocalDateTime.now());}
                        !{boolean hasJournal = pair.getJournal() != null;}
                        <tr>
                            <td>${pair.getSession().getSessionNumber()}</td>
                            <td>${pair.getSession().getStartTime().toLocalDate().toString()}</td>
                            <td>${pair.getSession().getStartTime().toLocalTime().toString()} - ${pair.getSession().getEndTime().toLocalTime().toString()}</td>
                            <td>
                                @if(pair.getSession().getStatus() == SessionStatus.SCHEDULED)
                                    <span class="badge badge-light-primary">Dijadwalkan</span>
                                @elseif(pair.getSession().getStatus() == SessionStatus.COMPLETED)
                                    <span class="badge badge-light-success">Tuntas</span>
                                @elseif(pair.getSession().getStatus() == SessionStatus.CANCELLED)
                                    <span class="badge badge-light-danger">Dibatalkan</span>
                                @else
                                    <span class="badge badge-light-warning">Rescheduled</span>
                                @endif
                            </td>
                            <td class="text-end">
                                @if(pair.getSession().getStatus() == SessionStatus.SCHEDULED)
                                    <form action="/therapist/session/${String.valueOf(pair.getSession().getId())}/complete"
                                          method="post" class="d-inline-block"
                                          onsubmit="return confirm('Mark this session as completed?');">
                                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                                        <input type="hidden" name="page" value="${currentPage}"/>
                                        <input type="hidden" name="size" value="${pageSize}"/>
                                        <input type="hidden" name="patientId" value="${patientIdStr}"/>
                                        <input type="hidden" name="dateFrom" value="${dateFromStr}"/>
                                        <input type="hidden" name="dateTo" value="${dateToStr}"/>
                                        @if(datePassed)
                                            <button type="submit" class="btn btn-sm btn-light-success">Tandai Tuntas</button>
                                        @else
                                            <button type="button" class="btn btn-sm btn-light" disabled
                                                    data-bs-toggle="tooltip" title="Available once the session date has passed">
                                                Tandai Tuntas
                                            </button>
                                        @endif
                                    </form>
                                @endif

                                @if(pair.getSession().getStatus() != SessionStatus.CANCELLED)
                                    @if(hasJournal)
                                        <a href="/therapist/journal/create/${String.valueOf(pair.getSession().getId())}" class="btn btn-sm btn-light-primary">
                                            Lihat Jurnal
                                        </a>
                                    @elseif(datePassed)
                                        <a href="/therapist/journal/create/${String.valueOf(pair.getSession().getId())}" class="btn btn-sm btn-primary">
                                            Tulis Jurnal
                                        </a>
                                    @else
                                        <button type="button" class="btn btn-sm btn-light" disabled
                                                data-bs-toggle="tooltip" title="Available once the session date has passed">
                                            Tulis Jurnal
                                        </button>
                                    @endif
                                @endif
                            </td>
                        </tr>
                    @endfor
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>