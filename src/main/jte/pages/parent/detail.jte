@import com.madania.management.entity.TherapyJournal
@import com.madania.management.entity.JournalComment
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyJournal journal
@param List<JournalComment> comments
@param String commentError = null

@template.layout.base(
title = "Journal Detail",
role = role,
_csrf = _csrf,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5 jdoc-no-print">
        <h1 class="page-heading">Therapy Journal</h1>
        <a href="/parent/journals" class="btn btn-light">Back</a>
    </div>

    @template.components.journal-document(journal = journal)

    <div class="card mt-5 jdoc-no-print" style="max-width: 900px; margin: 0 auto;">
        <div class="card-body">
            <h5 class="mb-5">Your Responses</h5>

            @if(commentError != null)
                <div class="alert alert-danger"><p>${commentError}</p></div>
            @endif

            @if(comments != null && !comments.isEmpty())
                @for(JournalComment comment : comments)
                    <div class="d-flex flex-column mb-4 p-3 bg-light rounded">
                        <div class="fs-7 text-gray-800">${comment.getContent()}</div>
                        <div class="fs-8 text-muted mt-1">${comment.getTimeAgo()}</div>
                    </div>
                @endfor
            @else
                <p class="text-muted">No responses yet. Share your thoughts with the therapist below.</p>
            @endif

            <form action="/parent/journal/${String.valueOf(journal.getId())}/comment" method="post" class="mt-5">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                <div class="fv-row mb-3">
                    <textarea class="form-control" name="content" rows="3" placeholder="Write a response to this journal entry..." required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Send Response</button>
            </form>
        </div>
    </div>
`
)