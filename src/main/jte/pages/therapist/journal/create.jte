@import com.madania.management.dto.JournalRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.TherapySession
@import com.madania.management.entity.User
@import com.madania.management.enums.TherapyType
@import com.madania.management.enums.MoodRating
@import org.springframework.validation.BindingResult
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param JournalRequest request
@param TherapySession session
@param TherapyType[] therapyTypes
@param MoodRating[] moodRatings
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Tulis Jurnal",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Tulis Jurnal</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/therapist/dashboard" class="text-muted text-hover-primary">Dasbor</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/therapist/sessions" class="text-muted text-hover-primary">Sesi</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">Jurnal Baru</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="d-flex flex-column flex-lg-row">

                <!--begin::Session info sidebar-->
                <div class="flex-column flex-lg-row-auto w-lg-300px mb-10">
                    <div class="card mb-5">
                        <div class="card-header border-0 pt-6">
                            <div class="card-title">
                                <h3 class="fw-bold">Detail Sesi</h3>
                            </div>
                        </div>
                        <div class="card-body pt-0">
                            <div class="d-flex align-items-center mb-6">
                                <div class="symbol symbol-45px me-4">
                                    <div class="symbol-label bg-light-primary">
                                        <i class="ki-outline ki-profile-circle fs-2 text-primary"></i>
                                    </div>
                                </div>
                                <div class="d-flex flex-column">
                                    <span class="fs-7 text-muted">Pasien</span>
                                    <span class="fs-6 fw-bold text-gray-900">${session.getPatient().getFullName()}</span>
                                </div>
                            </div>
                            <div class="separator separator-dashed my-5"></div>
                            <div class="d-flex justify-content-between mb-4">
                                <span class="fs-7 text-muted">Sesi</span>
                                <span class="fs-7 fw-semibold text-gray-800">${session.getSessionNumber()} dari ${session.getTherapyPackage().getTotalSessions()}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-4">
                                <span class="fs-7 text-muted">Tanggal</span>
                                <span class="fs-7 fw-semibold text-gray-800">${session.getStartTime().toLocalDate().toString()}</span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span class="fs-7 text-muted">Waktu</span>
                                <span class="fs-7 fw-semibold text-gray-800">${session.getStartTime().toLocalTime().toString()}</span>
                            </div>
                        </div>
                    </div>

                    <div class="notice d-flex bg-light-info rounded border-info border border-dashed p-5">
                        <i class="ki-outline ki-information-5 fs-2tx text-info me-4"></i>
                        <div class="d-flex flex-stack flex-grow-1">
                            <div class="fw-semibold">
                                <div class="fs-7 text-gray-700">
                                    Kolom bertanda <span class="text-danger">*</span> wajib diisi. Catatan ini akan menjadi bagian dari rekam resmi sesi ini.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--end::Session info sidebar-->

                <!--begin::Form-->
                <div class="flex-lg-row-fluid ms-lg-15">

                    @if(bindingResult != null && bindingResult.hasErrors())
                        <div class="alert alert-danger d-flex align-items-center p-5 mb-8">
                            <i class="ki-outline ki-shield-cross fs-2hx text-danger me-4"></i>
                            <div class="d-flex flex-column">
                                @for(var error : bindingResult.getAllErrors())
                                    <span>${error.getDefaultMessage()}</span>
                                @endfor
                            </div>
                        </div>
                    @endif

                    <form action="/therapist/journal/create/${String.valueOf(session.getId())}" method="post">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                        <!--begin::Overview card-->
                        <div class="card mb-5">
                            <div class="card-header border-0 pt-6">
                                <div class="card-title">
                                    <h3 class="fw-bold">Ringkasan</h3>
                                </div>
                            </div>
                            <div class="card-body pt-0">
                                <div class="row mb-6">
                                    <label class="col-lg-3 col-form-label required fw-semibold fs-6">Judul</label>
                                    <div class="col-lg-9">
                                        <input type="text" name="title" class="form-control form-control-solid"
                                               placeholder="cth. Sesi Ketiga - Peningkatan Kontrol Diri" required>
                                    </div>
                                </div>
                                <div class="row mb-6">
                                    <label class="col-lg-3 col-form-label required fw-semibold fs-6">Jenis Terapi</label>
                                    <div class="col-lg-9">
                                        <select name="therapyType" class="form-select form-select-solid" required>
                                            <option value="">Pilih jenis</option>
                                            @for(TherapyType type : therapyTypes)
                                                <option value="${type.name()}">${type.name()}</option>
                                            @endfor
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-lg-3 col-form-label fw-semibold fs-6">Mood Anak</label>
                                    <div class="col-lg-9">
                                        <div class="d-flex flex-wrap gap-3" id="kt_mood_selector">
                                            @for(MoodRating mood : moodRatings)
                                                <label class="btn btn-outline btn-outline-dashed btn-color-muted btn-active-light-primary mood-option px-4 py-3 d-flex flex-column align-items-center" style="min-width: 90px;">
                                                    <input type="radio" name="moodRating" value="${mood.name()}" class="btn-check" />
                                                    <span class="fs-2 mb-1">
                                                        @if(mood.name() == "VERY_HAPPY")
                                                            😄
                                                        @elseif(mood.name() == "HAPPY")
                                                            🙂
                                                        @elseif(mood.name() == "NEUTRAL")
                                                            😐
                                                        @elseif(mood.name() == "UPSET")
                                                            🙁
                                                        @elseif(mood.name() == "VERY_UPSET")
                                                            😢
                                                        @endif
                                                    </span>
                                                    <span class="fs-8 fw-semibold">${mood.name()}</span>
                                                </label>
                                            @endfor
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--end::Overview card-->

                        <!--begin::Session record card-->
                        <div class="card mb-5">
                            <div class="card-header border-0 pt-6">
                                <div class="card-title">
                                    <h3 class="fw-bold">Rekam Sesi</h3>
                                </div>
                            </div>
                            <div class="card-body pt-0">
                                <div class="mb-6">
                                    <label class="form-label required fw-semibold fs-6">Target Sesi</label>
                                    <textarea name="sessionGoals" class="form-control form-control-solid" rows="3"
                                              placeholder="Apa tujuan sesi ini?" required></textarea>
                                </div>
                                <div class="mb-6">
                                    <label class="form-label required fw-semibold fs-6">Catatan Sesi</label>
                                    <textarea name="content" class="form-control form-control-solid" rows="5"
                                              placeholder="Ceritakan apa yang terjadi selama sesi berlangsung..." required></textarea>
                                </div>
                                <div class="mb-0">
                                    <label class="form-label required fw-semibold fs-6">Catatan Perkembangan</label>
                                    <textarea name="progressNotes" class="form-control form-control-solid" rows="3"
                                              placeholder="Bagaimana perkembangan anak dibanding sesi sebelumnya?" required></textarea>
                                </div>
                            </div>
                        </div>
                        <!--end::Session record card-->

                        <!--begin::Outcomes card-->
                        <div class="card mb-5">
                            <div class="card-header border-0 pt-6">
                                <div class="card-title">
                                    <h3 class="fw-bold">Hasil &amp; Rekomendasi</h3>
                                </div>
                                <div class="card-toolbar">
                                    <span class="badge badge-light-secondary">Opsional</span>
                                </div>
                            </div>
                            <div class="card-body pt-0">
                                <div class="mb-6">
                                    <label class="form-label fw-semibold fs-6">Target Tercapai</label>
                                    <textarea name="goalsAchieved" class="form-control form-control-solid" rows="3"
                                              placeholder="Adakah target terukur yang tercapai pada sesi ini?"></textarea>
                                </div>
                                <div class="mb-0">
                                    <label class="form-label fw-semibold fs-6">Saran dan Rekomendasi untuk Wali Pasien</label>
                                    <textarea name="parentRecommendations" class="form-control form-control-solid" rows="3"
                                              placeholder="Apa yang bisa dilakukan wali pasien di rumah untuk mendukung perkembangan anak?"></textarea>
                                </div>
                            </div>
                        </div>
                        <!--end::Outcomes card-->

                        <!--begin::Documentation card-->
                        <div class="card mb-5">
                            <div class="card-header border-0 pt-6">
                                <div class="card-title">
                                    <h3 class="fw-bold">Dokumentasi</h3>
                                </div>
                                <div class="card-toolbar">
                                    <span class="badge badge-light-secondary">Opsional</span>
                                </div>
                            </div>
                            <div class="card-body pt-0">
                                <label class="form-label fw-semibold fs-6">URL Dokumentasi</label>
                                <div class="position-relative">
                                    <i class="ki-outline ki-folder fs-3 position-absolute ms-4 top-50 translate-middle-y text-muted"></i>
                                    <input type="url" name="documentationUrl" class="form-control form-control-solid ps-12"
                                           placeholder="Tautan folder Google Drive (foto, lembar kerja, dsb.)">
                                </div>
                            </div>
                        </div>
                        <!--end::Documentation card-->

                        <!--begin::Actions-->
                        <div class="d-flex justify-content-end gap-3 mb-10">
                            <a href="/therapist/sessions" class="btn btn-light">Batalkan</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="ki-outline ki-check fs-3"></i>Simpan Jurnal
                            </button>
                        </div>
                        <!--end::Actions-->
                    </form>
                </div>
                <!--end::Form-->
            </div>
        </div>
    </div>

    <style>
        .mood-option input[type="radio"]:checked + span,
        .mood-option:has(input[type="radio"]:checked) {
            border-color: var(--bs-primary) !important;
            background-color: var(--bs-primary-light, #f1faff) !important;
        }
    </style>
`
)