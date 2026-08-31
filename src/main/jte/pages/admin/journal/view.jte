@import com.madania.management.entity.JournalComment
@import com.madania.management.entity.TherapyJournal
@import com.madania.management.entity.User
@import java.util.List

@param String role
@param User user
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyJournal journal
@param List<JournalComment> comments

@template.layout.base(
title = "Journal Detail",
role = role,
user = user,
_csrf = _csrf,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5 jdoc-no-print">
        <h1 class="page-heading">Jurnal Terapi</h1>
        <a href="/admin/journals" class="btn btn-light">Kembali</a>
    </div>

    @template.components.journal-document(journal = journal)

    <div class="card mt-5 jdoc-no-print" style="max-width: 900px; margin: 0 auto;">
        <div class="card-body">
            <h5 class="fw-bold mb-5">Komentar Wali</h5>

            @if(comments != null && !comments.isEmpty())
                @for(JournalComment comment : comments)
                    <div class="d-flex flex-column mb-4 p-3 bg-light rounded">
                        <div class="fs-7 text-gray-800">${comment.getContent()}</div>
                        <div class="fs-8 text-muted mt-1">${comment.getTimeAgo()}</div>
                    </div>
                @endfor
            @else
                <p class="text-muted">Wali belum berkomentar.</p>
            @endif
        </div>
    </div>
`
)