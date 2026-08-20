@import com.madania.management.entity.TherapyJournal
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<TherapyJournal> journals

@template.layout.base(
title = "All Journals",
role = role,
_csrf = _csrf,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">All Journals</h1>
    </div>

    <div class="card">
        <div class="card-body">
            <table class="table table-row-dashed">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Patient</th>
                    <th>Therapist</th>
                    <th>Therapy Type</th>
                    <th>Mood</th>
                    <th>Date</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                @for(TherapyJournal journal : journals)
                    <tr>
                        <td>${journal.getTitle()}</td>
                        <td>${journal.getPatient().getFullName()}</td>
                        <td>${journal.getTherapist().getFullName()}</td>
                        <td>${journal.getTherapyType().name()}</td>
                        <td>
                            @if(journal.getMood() != null)
                                ${journal.getMood().name()}
                            @else
                                -
                            @endif
                        </td>
                        <td>${journal.getCreatedAt().toLocalDate().toString()}</td>
                        <td>
                            <a href="/admin/journal/${String.valueOf(journal.getId())}"
                               class="btn btn-icon btn-bg-light btn-sm">
                                <i class="ki-outline ki-eye fs-3"></i>
                            </a>
                        </td>
                    </tr>
                @endfor
                </tbody>
            </table>
        </div>
    </div>
`
)