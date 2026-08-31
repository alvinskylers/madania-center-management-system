@import com.madania.management.entity.User
@import com.madania.management.entity.Patient
@import com.madania.management.entity.TherapyJournal
@import org.springframework.data.domain.Page
@import java.util.List
@import java.util.UUID
@import java.time.LocalDate

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param Page<TherapyJournal> journals
@param int currentPage = 0
@param int totalPages = 0
@param long totalItems = 0
@param int pageSize = 10
@param List<Patient> children
@param List<Integer> sessionNumbers
@param UUID selectedPatientId = null
@param Integer selectedSessionNumber = null
@param LocalDate selectedStartDate = null
@param LocalDate selectedEndDate = null
@param String journalError = null

@template.layout.base(
title = "Jurnal Perkembangan",
role = role,
user = user,
_csrf = _csrf,
content = @`
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Jurnal Saya</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/parent/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Jurnal Saya</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    @if(journalError != null)
        <div class="alert alert-danger"><p>${journalError}</p></div>
    @endif

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="card">
                <div class="card-header border-0 pt-6">
                    <div class="card-title w-100">
                        <form action="/parent/journals" method="get" class="d-flex flex-wrap align-items-end gap-3 w-100">
                            <input type="hidden" name="page" value="0" />

                            <div>
                                <label class="fs-8 text-muted mb-1 d-block">Anak</label>
                                <select name="patientId"
                                        class="form-select form-select-solid w-200px tom-select"
                                        onchange="this.form.submit()"
                                        data-placeholder="Cari anak...">
                                    <option value="">All Children</option>
                                    @for(Patient p : children)
                                        @if(selectedPatientId != null && selectedPatientId.equals(p.getId()))
                                            <option value="${String.valueOf(p.getId())}" selected>${p.getFullName()}</option>
                                        @else
                                            <option value="${String.valueOf(p.getId())}">${p.getFullName()}</option>
                                        @endif
                                    @endfor
                                </select>
                            </div>

                            <div>
                                <label class="fs-8 text-muted mb-1 d-block">No Sesi</label>
                                <select name="sessionNumber" class="form-select form-select-solid w-150px" onchange="this.form.submit()">
                                    <option value="">All Sessions</option>
                                    @for(Integer n : sessionNumbers)
                                        @if(selectedSessionNumber != null && selectedSessionNumber.equals(n))
                                            <option value="${n}" selected>Session ${n}</option>
                                        @else
                                            <option value="${n}">Session ${n}</option>
                                        @endif
                                    @endfor
                                </select>
                            </div>

                            <div>
                                <label class="fs-8 text-muted mb-1 d-block">Batas Tanggal Awal</label>
                                <input type="date" name="startDate" class="form-control form-control-solid w-150px"
                                       value="${selectedStartDate != null ? selectedStartDate.toString() : ""}" />
                            </div>

                            <div>
                                <label class="fs-8 text-muted mb-1 d-block">Batas Tanggal Akhir</label>
                                <input type="date" name="endDate" class="form-control form-control-solid w-150px"
                                       value="${selectedEndDate != null ? selectedEndDate.toString() : ""}" />
                            </div>

                            <button type="submit" class="btn btn-light-primary">Filter</button>

                            @if(selectedPatientId != null || selectedSessionNumber != null || selectedStartDate != null || selectedEndDate != null)
                                <a href="/parent/journals" class="btn btn-light-danger">Kosongkan Filters</a>
                            @endif
                        </form>
                    </div>
                </div>

                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table table-row-dashed align-middle fs-6 gy-5">
                            <thead>
                            <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                                <th>Judul</th>
                                <th>Anak</th>
                                <th>No Sesi #</th>
                                <th>Jenis Terapi</th>
                                <th>Mood</th>
                                <th>Tanggal</th>
                                <th>Aksi</th>
                            </tr>
                            </thead>
                            <tbody class="fw-semibold text-gray-600">
                            @if(journals != null && !journals.isEmpty())
                                @for(TherapyJournal journal : journals)
                                    <tr>
                                        <td>${journal.getTitle()}</td>
                                        <td>${journal.getPatient().getFullName()}</td>
                                        <td>${journal.getSession().getSessionNumber()}</td>
                                        <td>${journal.getTherapyType().getLabel()}</td>
                                        <td>
                                            @if(journal.getMood() != null)
                                                ${journal.getMood().getEmoji()} ${journal.getMood().getLabel()}
                                            @else
                                                -
                                            @endif
                                        </td>
                                        <td>${journal.getCreatedAt().toLocalDate().toString()}</td>
                                        <td>
                                            <a href="/parent/journal/${String.valueOf(journal.getId())}"
                                               class="btn btn-icon btn-bg-light btn-sm">
                                                <i class="ki-outline ki-eye fs-3"></i>
                                            </a>
                                        </td>
                                    </tr>
                                @endfor
                            @else
                                <tr><td colspan="7" class="text-center text-muted">Jurnal tidak ditemukan dengan kriteria tersebut</td></tr>
                            @endif
                            </tbody>
                        </table>
                    </div>

                    <!-- ===== START PAGINATION ===== -->
                    @if(totalPages > 0)
                        <div class="d-flex justify-content-between align-items-center pt-5">
                            <div class="text-muted fs-7">
                                Menampilkan
                                ${currentPage * pageSize + 1}
                                sampai
                                ${Math.min((currentPage + 1) * pageSize, totalItems)}
                                dari
                                ${totalItems}
                                item
                            </div>

                            <ul class="pagination m-0">
                                @if(currentPage > 0)
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&patientId=${selectedPatientId != null ? String.valueOf(selectedPatientId) : ""}&sessionNumber=${selectedSessionNumber != null ? String.valueOf(selectedSessionNumber) : ""}&startDate=${selectedStartDate != null ? selectedStartDate.toString() : ""}&endDate=${selectedEndDate != null ? selectedEndDate.toString() : ""}">Sebelum</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Sebelum</span></li>
                                @endif

                                @for(int i = 0; i < totalPages; i++)
                                    @if(i == currentPage)
                                        <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                                    @else
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${i}&patientId=${selectedPatientId != null ? String.valueOf(selectedPatientId) : ""}&sessionNumber=${selectedSessionNumber != null ? String.valueOf(selectedSessionNumber) : ""}&startDate=${selectedStartDate != null ? selectedStartDate.toString() : ""}&endDate=${selectedEndDate != null ? selectedEndDate.toString() : ""}">${i + 1}</a>
                                        </li>
                                    @endif
                                @endfor

                                @if(currentPage < totalPages - 1)
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&patientId=${selectedPatientId != null ? String.valueOf(selectedPatientId) : ""}&sessionNumber=${selectedSessionNumber != null ? String.valueOf(selectedSessionNumber) : ""}&startDate=${selectedStartDate != null ? selectedStartDate.toString() : ""}&endDate=${selectedEndDate != null ? selectedEndDate.toString() : ""}">Berikut</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Berikut</span></li>
                                @endif
                            </ul>
                        </div>
                    @endif
                    <!-- ===== END PAGINATION ===== -->
                </div>
            </div>
        </div>
    </div>
`
)