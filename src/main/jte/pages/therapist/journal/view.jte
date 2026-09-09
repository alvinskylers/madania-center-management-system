@import com.madania.management.entity.JournalComment
@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapyJournal
@import com.madania.management.entity.User
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param TherapyJournal journal
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null
@param List<JournalComment> comments
@param String journalError = null

@template.layout.base(
title = "Journal Detail",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5 jdoc-no-print">
        <h1 class="page-heading">Jurnal Terapi</h1>
        <div class="d-flex gap-3">
            @if(journal.isEditable())
                <a href="/therapist/journal/${String.valueOf(journal.getId())}/edit" class="btn btn-primary">
                    Ubah Jurnal
                </a>
            @else
                <button type="button" class="btn btn-secondary" disabled title="Batas waktu 15 menit untuk mengubah jurnal telah berakhir">
                    Jurnal Terkunci
                </button>
            @endif
            <a href="/therapist/journals" class="btn btn-light">Kembali</a>
        </div>
    </div>

    @if(journalError != null)
        <div class="alert alert-danger jdoc-no-print"><p>${journalError}</p></div>
    @endif

    @if(!journal.isEditable())
        <div class="alert alert-light border jdoc-no-print">
            <p class="mb-0">Jurnal ini sudah terkunci karena telah melewati batas waktu 15 menit sejak dibuat. Untuk menambahkan catatan tambahan, gunakan bagian komentar di bawah.</p>
        </div>
    @endif

    @template.components.journal-document(journal = journal)

    <div class="card mt-5 jdoc-no-print" style="max-width: 900px; margin: 0 auto;">
        <div class="card-body">
            <h5 class="fw-bold mb-5">Tanggapan Wali Pasien</h5>

            @if(comments != null && !comments.isEmpty())
                @for(JournalComment comment : comments)
                    <div class="d-flex flex-column mb-4 p-3 bg-light rounded">
                        <div class="fs-7 text-gray-800">${comment.getContent()}</div>
                        <div class="fs-8 text-muted mt-1">${comment.getTimeAgo()}</div>
                    </div>
                @endfor
            @else
                <p class="text-muted">Wali Pasien belum berkomentar.</p>
            @endif
        </div>
    </div>
`
)