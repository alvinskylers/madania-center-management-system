@import com.madania.management.entity.TherapyJournal
@import java.time.format.DateTimeFormatter

@param TherapyJournal journal

<link href="https://fonts.googleapis.com/css2?family=Source+Serif+4:opsz,wght@8..60,400;8..60,600;8..60,700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
    .jdoc-wrap {
        --jdoc-paper: #FFFFFF;
        --jdoc-ink: #1F2430;
        --jdoc-ink-soft: #5C6270;
        --jdoc-blue: #1B3FA6;
        --jdoc-blue-deep: #122B75;
        --jdoc-green: #1E8F4E;
        --jdoc-line: #DDE2EC;
        --jdoc-tint: #F4F7FD;
    }
    .jdoc-card {
        position: relative;
        background: var(--jdoc-paper);
        color: var(--jdoc-ink);
        border: 1px solid var(--jdoc-line);
        border-radius: 8px;
        padding: 3rem 3.25rem 2.25rem;
        max-width: 900px;
        margin: 0 auto;
        overflow: hidden;
        box-shadow: 0 1px 3px rgba(18, 43, 117, 0.06);
    }
    .jdoc-watermark {
        position: absolute;
        top: 50%;
        left: 50%;
        width: 520px;
        height: 520px;
        transform: translate(-50%, -50%);
        background: url('/media/logos/madania-logo.png') center / contain no-repeat;
        opacity: 0.04;
        pointer-events: none;
        z-index: 0;
    }
    .jdoc-content { position: relative; z-index: 1; }

    .jdoc-letterhead {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1.5rem;
        margin-bottom: 1.5rem;
    }
    .jdoc-brand {
        display: flex;
        align-items: center;
        gap: 0.9rem;
    }
    .jdoc-brand img {
        width: 58px;
        height: 58px;
        object-fit: contain;
        flex-shrink: 0;
    }
    .jdoc-brand-name {
        font-family: "Inter", sans-serif;
        font-weight: 800;
        font-size: 1.05rem;
        letter-spacing: 0.04em;
        color: var(--jdoc-blue-deep);
        line-height: 1.2;
    }
    .jdoc-brand-tagline {
        font-family: "Inter", sans-serif;
        font-style: italic;
        font-weight: 500;
        font-size: 0.75rem;
        color: var(--jdoc-ink-soft);
        margin-top: 0.15rem;
    }
    .jdoc-doctype {
        font-family: "Inter", sans-serif;
        font-size: 0.68rem;
        font-weight: 700;
        letter-spacing: 0.12em;
        text-transform: uppercase;
        color: var(--jdoc-blue);
        background: var(--jdoc-tint);
        border: 1px solid var(--jdoc-line);
        border-radius: 4px;
        padding: 0.4rem 0.75rem;
        white-space: nowrap;
    }

    .jdoc-rule-thick {
        height: 3px;
        border: none;
        margin: 0 0 1.75rem 0;
        background: linear-gradient(90deg, var(--jdoc-blue) 0%, var(--jdoc-blue) 70%, var(--jdoc-green) 100%);
    }

    .jdoc-title {
        font-family: "Source Serif 4", Georgia, serif;
        font-weight: 700;
        font-size: 1.85rem;
        line-height: 1.25;
        color: var(--jdoc-ink);
        margin: 0 0 1.5rem 0;
    }

    .jdoc-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 0;
        background: var(--jdoc-tint);
        border: 1px solid var(--jdoc-line);
        border-radius: 6px;
        margin-bottom: 2.25rem;
        overflow: hidden;
    }
    .jdoc-meta-item {
        flex: 1 1 150px;
        padding: 0.85rem 1.1rem;
        border-right: 1px solid var(--jdoc-line);
    }
    .jdoc-meta-item:last-child { border-right: none; }
    .jdoc-meta-label {
        font-family: "Inter", sans-serif;
        font-size: 0.64rem;
        font-weight: 700;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        color: var(--jdoc-blue);
        margin-bottom: 0.3rem;
    }
    .jdoc-meta-value {
        font-family: "Inter", sans-serif;
        font-size: 0.95rem;
        font-weight: 600;
        color: var(--jdoc-ink);
    }

    .jdoc-section { margin-bottom: 1.9rem; }
    .jdoc-section-label {
        font-family: "Inter", sans-serif;
        font-size: 0.7rem;
        font-weight: 700;
        letter-spacing: 0.12em;
        text-transform: uppercase;
        color: var(--jdoc-blue);
        margin-bottom: 0.5rem;
        padding-bottom: 0.4rem;
        border-bottom: 2px solid var(--jdoc-line);
    }
    .jdoc-section-body {
        font-family: "Inter", sans-serif;
        font-size: 0.98rem;
        line-height: 1.7;
        color: var(--jdoc-ink);
        white-space: pre-line;
    }

    .jdoc-badge {
        display: inline-block;
        font-family: "Inter", sans-serif;
        font-size: 0.78rem;
        font-weight: 700;
        color: #fff;
        background: var(--jdoc-green);
        padding: 0.2rem 0.7rem;
        border-radius: 999px;
    }

    .jdoc-footer {
        margin-top: 2.5rem;
        padding-top: 1.25rem;
        border-top: 2px solid var(--jdoc-line);
        display: flex;
        justify-content: space-between;
        align-items: baseline;
        font-family: "Inter", sans-serif;
    }
    .jdoc-footer-signed {
        font-size: 0.85rem;
        color: var(--jdoc-ink-soft);
    }
    .jdoc-footer-signed strong { color: var(--jdoc-ink); }
    .jdoc-footer-date {
        font-size: 0.8rem;
        color: var(--jdoc-ink-soft);
    }
    .jdoc-footer-seal {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .jdoc-footer-seal img {
        width: 34px;
        height: 34px;
        object-fit: contain;
        opacity: 0.85;
    }

    @media print {
        body * { visibility: hidden; }
        #jdocPrintArea, #jdocPrintArea * { visibility: visible; }
        #jdocPrintArea {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
        }
        .jdoc-card { border: none; box-shadow: none; padding: 0; max-width: 100%; }
        .jdoc-no-print { display: none !important; }
    }
</style>

<div class="jdoc-wrap">
    <div class="d-flex justify-content-end mb-3 jdoc-no-print">
        <button type="button" class="btn btn-light-primary btn-sm" onclick="window.print()">
            <i class="ki-outline ki-printer fs-4 me-1"></i> Print / Save as PDF
        </button>
    </div>

    <div id="jdocPrintArea">
        <div class="jdoc-card">
            <div class="jdoc-watermark"></div>
            <div class="jdoc-content">

                <div class="jdoc-letterhead">
                    <div class="jdoc-brand">
                        <img src="/media/logos/logo.png" alt="Madania Center" />
                        <div>
                            <div class="jdoc-brand-name">MADANIA CENTER</div>
                            <div class="jdoc-brand-tagline">Konsultan Psikologi &amp; Klinik Hypnotherapy</div>
                        </div>
                    </div>
                    <div class="jdoc-doctype">Therapy Session Journal</div>
                </div>

                <hr class="jdoc-rule-thick">

                <h1 class="jdoc-title">${journal.getTitle()}</h1>

                <div class="jdoc-meta">
                    <div class="jdoc-meta-item">
                        <div class="jdoc-meta-label">Patient</div>
                        <div class="jdoc-meta-value">${journal.getPatient().getFullName()}</div>
                    </div>
                    <div class="jdoc-meta-item">
                        <div class="jdoc-meta-label">Therapist</div>
                        <div class="jdoc-meta-value">${journal.getTherapist().getFullName()}</div>
                    </div>
                    <div class="jdoc-meta-item">
                        <div class="jdoc-meta-label">Therapy Type</div>
                        <div class="jdoc-meta-value">${journal.getTherapyType().name()}</div>
                    </div>
                    <div class="jdoc-meta-item">
                        <div class="jdoc-meta-label">Session Date</div>
                        <div class="jdoc-meta-value">${journal.getSession().getStartTime().toLocalDate().toString()}</div>
                    </div>
                    <div class="jdoc-meta-item">
                        <div class="jdoc-meta-label">Session #</div>
                        <div class="jdoc-meta-value">${journal.getSession().getSessionNumber()}</div>
                    </div>
                    @if(journal.getMood() != null)
                        <div class="jdoc-meta-item">
                            <div class="jdoc-meta-label">Child's Mood</div>
                            <div class="jdoc-meta-value"><span class="jdoc-badge">${journal.getMood().name()}</span></div>
                        </div>
                    @endif
                </div>

                <div class="jdoc-section">
                    <div class="jdoc-section-label">Session Goals</div>
                    <div class="jdoc-section-body">${journal.getSessionGoals()}</div>
                </div>

                <div class="jdoc-section">
                    <div class="jdoc-section-label">Session Notes</div>
                    <div class="jdoc-section-body">${journal.getContent()}</div>
                </div>

                <div class="jdoc-section">
                    <div class="jdoc-section-label">Progress Notes</div>
                    <div class="jdoc-section-body">${journal.getProgressNotes()}</div>
                </div>

                @if(journal.getGoalsAchieved() != null)
                    <div class="jdoc-section">
                        <div class="jdoc-section-label">Goals Achieved</div>
                        <div class="jdoc-section-body">${journal.getGoalsAchieved()}</div>
                    </div>
                @endif

                @if(journal.getParentRecommendations() != null)
                    <div class="jdoc-section">
                        <div class="jdoc-section-label">Recommendations for Parents</div>
                        <div class="jdoc-section-body">${journal.getParentRecommendations()}</div>
                    </div>
                @endif

                @if(journal.getDocumentationUrl() != null)
                    <div class="jdoc-section jdoc-no-print">
                        <div class="jdoc-section-label">Session Documentation</div>
                        <a href="${journal.getDocumentationUrl()}" target="_blank" class="btn btn-light-primary btn-sm">View Files</a>
                    </div>
                @endif

                <div class="jdoc-footer">
                    <div class="jdoc-footer-seal">
                        <img src="/media/logos/logo.png" alt="" />
                        <div class="jdoc-footer-signed">Documented by <strong>${journal.getTherapist().getFullName()}</strong></div>
                    </div>
                    <div class="jdoc-footer-date">${journal.getCreatedAt().format(DateTimeFormatter.ofPattern("d MMMM yyyy, HH:mm"))}</div>
                </div>

            </div>
        </div>
    </div>
</div>