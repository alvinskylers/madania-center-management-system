@import com.madania.management.dto.CheckupDecisionRequest
@import com.madania.management.entity.Checkup
@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import com.madania.management.enums.ParentDecision
@import org.springframework.validation.BindingResult
@import java.time.format.DateTimeFormatter
@import java.util.List

@param User user
@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param Checkup checkup
@param CheckupDecisionRequest decisionRequest
@param String success = null
@param String error = null
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

!{String status = checkup.getStatus().name();}
!{String decision = checkup.getParentDecision().name();}
!{DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");}
!{String basePath = role.equals("ADMIN") ? "/admin" : "/receptionist";}

@template.layout.base(
title = "Detail Checkup",
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
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Detail Checkup</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="${basePath}/checkups" class="text-muted text-hover-primary">Checkup Diagnosa</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${checkup.getPatient().getFullName()}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!--end::Toolbar-->

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">

            @if(success != null)
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>${success}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
                </div>
            @endif
            @if(error != null)
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>${error}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
                </div>
            @endif

            <div class="d-flex flex-column flex-lg-row">

                <!--begin::Sidebar-->
                <div class="flex-column flex-lg-row-auto w-lg-350px mb-10">
                    <div class="card mb-5 mb-xl-8">
                        <div class="card-body">
                            <div class="d-flex flex-center flex-column py-5">
                                <div class="symbol symbol-75px symbol-circle mb-5">
                                    <span class="symbol-label bg-light-primary">
                                        <i class="ki-outline ki-user fs-2x text-primary"></i>
                                    </span>
                                </div>
                                <span class="fs-3 text-gray-800 fw-bold mb-2 text-center">${checkup.getPatient().getFullName()}</span>
                                <div class="fs-6 text-muted mb-3">${checkup.getTherapist().getFullName()}</div>
                                @if(status.equals("SCHEDULED"))
                                    <span class="badge badge-light-primary fs-7">${checkup.getStatus().getLabel()}</span>
                                @elseif(status.equals("COMPLETED"))
                                    <span class="badge badge-light-success fs-7">${checkup.getStatus().getLabel()}</span>
                                @else
                                    <span class="badge badge-light-danger fs-7">${checkup.getStatus().getLabel()}</span>
                                @endif
                            </div>

                            <div class="separator my-3"></div>

                            <div class="pb-3 fs-6">
                                <div class="fw-bold mt-5">Jadwal</div>
                                <div class="text-gray-600">${checkup.getScheduledAt().format(fmt)}</div>

                                <div class="fw-bold mt-5">Wali Pasien</div>
                                <div class="text-gray-600">${checkup.getPatient().getParent().getFullName()}</div>

                                <div class="fw-bold mt-5">Keputusan Wali</div>
                                <div class="text-gray-600">${checkup.getParentDecision().getLabel()}</div>

                                @if(checkup.getNotes() != null && !checkup.getNotes().isBlank())
                                    <div class="fw-bold mt-5">Catatan Jadwal</div>
                                    <div class="text-gray-600">${checkup.getNotes()}</div>
                                @endif

                                @if(status.equals("COMPLETED"))
                                    <div class="fw-bold mt-5">Hasil Diagnosis (oleh Terapis)</div>
                                    <div class="text-gray-600">${checkup.getDiagnosisNotes()}</div>
                                @endif

                                @if(status.equals("CANCELLED") && checkup.getCancellationReason() != null)
                                    <div class="fw-bold mt-5">Alasan Dibatalkan</div>
                                    <div class="text-gray-600">${checkup.getCancellationReason()}</div>
                                @endif
                            </div>

                            @if(status.equals("COMPLETED") && decision.equals("PROCEED_TO_THERAPY"))
                                <div class="separator my-3"></div>
                                <a href="${basePath}/package/create?checkupId=${String.valueOf(checkup.getId())}" class="btn btn-primary w-100">
                                    <i class="ki-outline ki-parcel fs-3"></i> Buat Paket Terapi
                                </a>
                            @endif

                            @if(status.equals("SCHEDULED"))
                                <div class="separator my-3"></div>
                                <form action="${basePath}/checkup/${String.valueOf(checkup.getId())}/cancel" method="post"
                                      onsubmit="return confirm('Batalkan checkup ini?');">
                                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>
                                    <button type="submit" class="btn btn-light-danger w-100">Batalkan Checkup</button>
                                </form>
                            @endif
                        </div>
                    </div>
                </div>
                <!--end::Sidebar-->

                <!--begin::Content-->
                <div class="flex-lg-row-fluid ms-lg-15">

                    @if(status.equals("SCHEDULED"))
                        <div class="card card-flush mb-6 mb-xl-9">
                            <div class="card-body">
                                <div class="alert alert-light-warning mb-0">
                                    <i class="ki-outline ki-time fs-2 me-2"></i>
                                    Menunggu hasil diagnosis dari terapis. Keputusan wali pasien dapat dicatat
                                    setelah terapis mengisi hasil diagnosis checkup ini.
                                </div>
                            </div>
                        </div>
                    @elseif(status.equals("COMPLETED") && decision.equals("PENDING"))
                        <div class="card card-flush mb-6 mb-xl-9">
                            <div class="card-header mt-6">
                                <div class="card-title flex-column">
                                    <h2 class="mb-1">Keputusan Wali Pasien</h2>
                                    <div class="fs-6 fw-semibold text-muted">Terapis telah mengisi hasil diagnosis (lihat panel kiri). Tanyakan kepada wali pasien apakah ingin melanjutkan ke terapi.</div>
                                </div>
                            </div>
                            <div class="card-body pt-0">
                                @if(bindingResult != null && bindingResult.hasErrors())
                                    <div class="alert alert-danger d-flex flex-column alert-dismissible fade show" role="alert">
                                        @for(var fieldError : bindingResult.getAllErrors())
                                            <span>${fieldError.getDefaultMessage()}</span>
                                        @endfor
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Tutup"></button>
                                    </div>
                                @endif

                                <form action="${basePath}/checkup/${String.valueOf(checkup.getId())}/decision" method="post">
                                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span class="required">Apakah wali ingin melanjutkan ke terapi?</span>
                                        </label>
                                        <select class="form-select form-select-solid" name="parentDecision" required data-control="select2" data-width="100%" data-hide-search="true">
                                            <option value="">Pilih keputusan wali</option>
                                            @for(ParentDecision d : ParentDecision.values())
                                                @if(!d.name().equals("PENDING"))
                                                    <option value="${d.name()}">${d.getLabel()}</option>
                                                @endif
                                            @endfor
                                        </select>
                                    </div>

                                    <div class="separator mb-6"></div>
                                    <div class="d-flex justify-content-end">
                                        <button type="submit" class="btn btn-primary">
                                            <span class="indicator-label">Simpan Keputusan</span>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    @elseif(status.equals("COMPLETED"))
                        <div class="card card-flush mb-6 mb-xl-9">
                            <div class="card-body">
                                @if(decision.equals("PROCEED_TO_THERAPY"))
                                    <div class="alert alert-light-success mb-0">
                                        Wali pasien memilih untuk melanjutkan ke terapi. Silakan buat paket terapi melalui tombol di panel kiri.
                                    </div>
                                @else
                                    <div class="alert alert-light-secondary mb-0">
                                        Wali pasien memilih untuk tidak melanjutkan ke terapi.
                                    </div>
                                @endif
                            </div>
                        </div>
                    @else
                        <div class="card card-flush mb-6 mb-xl-9">
                            <div class="card-body">
                                <div class="alert alert-light-danger mb-0">
                                    Checkup ini telah dibatalkan.
                                </div>
                            </div>
                        </div>
                    @endif

                </div>
                <!--end::Content-->
            </div>
        </div>
    </div>
`
)
