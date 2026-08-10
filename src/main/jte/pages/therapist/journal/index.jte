@import com.madania.management.entity.TherapyJournal
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<TherapyJournal> journals

@template.layout.base(
title = "Journals",
role = role,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">Progress Journals</h1>
    </div>

    <div class="card">
        <div class="card-body">
            <table class="table table-row-dashed">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Child</th>
                    <th>Therapy Type</th>
                    <th>Date</th>
                    <th>Mood</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                @for(TherapyJournal journal : journals)
                    <tr>
                        <td>${journal.getTitle()}</td>
                        <td>${journal.getPatient().getFullName()}</td>
                        <td>${journal.getTherapyType().name()}</td>
                        <td>${journal.getCreatedAt().toLocalDate().toString()}</td>
                        <td>
                            @if(journal.getMood() != null)
                                ${journal.getMood().name()}
                            @else
                                -
                            @endif
                        </td>
                        <td>
                            <a href="/therapist/journal/${String.valueOf(journal.getId())}/edit"
                               class="btn btn-sm btn-light-primary">
                                <i class="ki-outline ki-pencil fs-3"></i>
                            </a>
                            <a href="/therapist/journal/${String.valueOf(journal.getId())}"
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