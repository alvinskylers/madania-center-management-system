@import com.madania.management.entity.Parent
@import com.madania.management.entity.Patient
@import com.madania.management.entity.User
@import java.util.List

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param User user
@param Parent parent
@param List<Patient> children

@template.layout.base(
title = "Parent Details",
role = role,
user = user,
_csrf = _csrf,
content = @`
    <!--begin::Toolbar-->
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Informasi Wali</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted"><a href="/receptionist/dashboard" class="text-muted text-hover-primary">Dashboard</a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted"><a href="/receptionist/parents" class="text-muted text-hover-primary">Wali </a></li>
                        <li class="breadcrumb-item"><span class="bullet bg-gray-500 w-5px h-2px"></span></li>
                        <li class="breadcrumb-item text-muted">${parent.getFullName()}</li>
                    </ul>
                </div>
                <div class="d-flex align-items-center gap-2 gap-lg-3">
                    <a href="/receptionist/parent/${String.valueOf(parent.getId())}/edit" class="btn btn-light-primary">Ubah</a>
                </div>
            </div>
    </div>
    <!--end::Toolbar-->

            <div class="d-flex flex-column flex-lg-row">
                <!--begin::Sidebar-->
                <div class="flex-column flex-lg-row-auto w-lg-250px w-xl-350px mb-10">
                    <div class="card mb-5 mb-xl-8">
                        <div class="card-body">
                            <div class="d-flex flex-center flex-column py-5">
                                <div class="symbol symbol-100px symbol-circle mb-7">
                                    <img src="/media/avatars/blank.png" alt="image" />
                                </div>
                                <span class="fs-3 text-gray-800 fw-bold mb-3">${parent.getFullName()}</span>
                            </div>
                            <div class="separator"></div>
                            <div class="pb-5 fs-6">
                                <div class="fw-bold mt-5">Telepon</div>
                                <div class="text-gray-600">${parent.getPhone() != null ? parent.getPhone() : "—"}</div>
                                <div class="fw-bold mt-5">Alamat</div>
                                <div class="text-gray-600">${parent.getAddress() != null ? parent.getAddress() : "—"}</div>
                                <div class="fw-bold mt-5">Email</div>
                                <div class="text-gray-600">${parent.getUser().getEmail()}</div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--end::Sidebar-->

                <!--begin::Content-->
                <div class="flex-lg-row-fluid ms-lg-15">
                    <div class="card card-flush mb-6 mb-xl-9">
                        <div class="card-header mt-6">
                            <div class="card-title flex-column">
                                <h2 class="mb-1">Pasien</h2>
                                <div class="fs-6 fw-semibold text-muted">Anak dari wali ini</div>
                            </div>
                            <div class="card-toolbar">
                                <a href="/receptionist/patient/create" class="btn btn-sm btn-primary">
                                    <i class="ki-outline ki-plus fs-3"></i> Daftarkan Pasien
                                </a>
                            </div>
                        </div>
                        <div class="card-body p-9 pt-4">
                            @if(children != null && !children.isEmpty())
                                <div class="table-responsive">
                                    <table class="table align-middle table-row-dashed fs-6 gy-4">
                                        <thead>
                                        <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                                            <th>Nama</th>
                                            <th>Usia</th>
                                            <th>Status</th>
                                            <th class="text-end">Tindakan</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        @for(Patient child : children)
                                            <tr>
                                                <td class="fw-semibold text-gray-800">${child.getFullName()}</td>
                                                <td>${child.getAge().getYears()} Tahun</td>
                                                <td>
                                                    @if(child.isActive())
                                                        <span class="badge badge-light-success">Aktif</span>
                                                    @else
                                                        <span class="badge badge-light-secondary">Tidak Aktif</span>
                                                    @endif
                                                </td>
                                                <td class="text-end">
                                                    <a href="/receptionist/patient/${String.valueOf(child.getId())}/edit" class="btn btn-light-primary btn-sm">
                                                        <i class="ki-outline ki-notepad-edit fs-3"></i> Ubah
                                                    </a>
                                                </td>
                                            </tr>
                                        @endfor
                                        </tbody>
                                    </table>
                                </div>
                            @else
                                <div class="alert alert-info text-center mb-0">
                                    Wali ini belum memiliki pasien terdaftar.
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
                <!--end::Content-->
            </div>
`)
