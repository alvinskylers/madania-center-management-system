@import com.madania.management.entity.Notification
@import com.madania.management.entity.User
@import com.madania.management.enums.Role
@import org.springframework.data.domain.Page
@import org.springframework.security.web.csrf.CsrfToken
@import java.util.List

@param User user
@param Page<User> users
@param String role
@param String query
@param String roleFilter = null
@param CsrfToken _csrf
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null
@param String success = null
@param String error = null

@template.layout.base(
title = "Pengguna",
role = role,
user = user,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    @if(success != null)
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>${success}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif
    @if(error != null)
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>${error}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif

    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <!--begin::Toolbar container-->
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <!--begin::Toolbar wrapper-->
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <!--begin::Page title-->
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <!--begin::Title-->
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Pengguna</h1>
                    <!--end::Title-->
                    <!--begin::Breadcrumb-->
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <!--begin::Item-->
                        <li class="breadcrumb-item text-muted">
                            <a href="" class="text-muted text-hover-primary">Dashboard</a>
                        </li>
                        <!--end::Item-->
                        <li class="breadcrumb-item">
                            <span class="bullet bg-gray-500 w-5px h-2px"></span>
                        </li>
                        <!--begin::Item-->
                        <li class="breadcrumb-item text-muted">Pengguna</li>
                        <!--end::Item-->
                    </ul>
                    <!--end::Breadcrumb-->
                </div>
                <!--end::Page title-->
            </div>
            <!--end::Toolbar wrapper-->
        </div>
        <!--end::Toolbar container-->
    </div>

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <!--begin::Content container-->
        <div id="kt_app_content_container" class="app-container container-fluid">
            <!--begin::Card-->
            <div class="card">
                <!--begin::Card header-->
                <div class="card-header border-0 pt-6">
                    <!--begin::Card title-->
                    <div class="card-title">
                        <!--begin::Search-->
                        <form action="/admin/users" method="get" enctype="text/plain">
                            <input type="hidden" name="_csrf" value="${_csrf.getToken()}"/>
                            <div class="d-flex align-items-center position-relative my-1">
                                <i class="ki-outline ki-magnifier fs-3 position-absolute ms-5"></i>
                                <input type="text"
                                       name="query"
                                       class="form-control form-control-solid w-250px ps-13"
                                       placeholder="Cari pengguna"
                                       value="${query != null ? query : ""}" />
                                <input type="hidden" name="page" value="0" />
                                <button type="submit" class="btn btn-light-primary me-3 gap-3">Cari</button>

                                <select name="role" class="form-select form-select-solid w-150px" onchange="this.form.submit()">
                                    <option value="">Semua Role</option>
                                    @for(Role r : Role.values())
                                        <option value="${r.name()}" selected="${roleFilter != null && roleFilter.equals(r.name())}">
                                            @if(r == Role.ADMIN) Admin
                                            @elseif(r == Role.RECEPTIONIST) Resepsionis
                                            @elseif(r == Role.THERAPIST) Terapis
                                            @elseif(r == Role.PARENT) Wali Pasien
                                            @else ${r.name()}
                                            @endif
                                        </option>
                                    @endfor
                                </select>

                                @if(roleFilter != null && !roleFilter.isBlank())
                                    <a href="/admin/users${query != null && !query.isBlank() ? "?query=" + query : ""}" class="btn btn-light-danger btn-sm ms-3">Kosongkan Filter</a>
                                @endif
                            </div>
                        </form>
                        <!--end::Search-->
                    </div>
                    <!--begin::Card toolbar-->
                    <div class="card-toolbar">
                        <!--begin::Add user dropdown-->
                        <a href="#" class="btn btn-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end">
                            <i class="ki-outline ki-plus fs-2"></i>Tambah Pengguna
                        </a>
                        <!--begin::Menu-->
                        <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-200px py-4" data-kt-menu="true">
                            <div class="menu-item px-3">
                                <a href="/admin/parent/create" class="menu-link px-3">
                                    <i class="ki-outline ki-user fs-4 me-2"></i>Wali Pasien
                                </a>
                            </div>
                            <div class="menu-item px-3">
                                <a href="/admin/therapist/create" class="menu-link px-3">
                                    <i class="ki-outline ki-user fs-4 me-2"></i>Terapis
                                </a>
                            </div>
                            <div class="menu-item px-3">
                                <a href="/admin/receptionist/create" class="menu-link px-3">
                                    <i class="ki-outline ki-user fs-4 me-2"></i>Resepsionis
                                </a>
                            </div>
                        </div>
                        <!--end::Menu-->
                        <!--end::Add user dropdown-->
                    </div>
                    <!--end::Card toolbar-->
                </div>
                <!--end::Card header-->

                <!--begin::Card body-->
                <div class="card-body pt-0">
                    <!--begin::Table-->
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_users_table">
                            <thead>
                            <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                                <th class="min-w-125px">Nama</th>
                                <th class="min-w-125px">Email</th>
                                <th class="min-w-125px">Role</th>
                                <th class="min-w-125px">Status</th>
                                <th class="min-w-125px">Tanggal Dibuat</th>
                                <th class="text-end min-w-70px">Tindakan</th>
                            </tr>
                            </thead>
                            <tbody class="fw-semibold text-gray-600">
                            @for(User user : users)
                                @template.pages.admin.user.row(user = user, role = role, _csrf = _csrf)
                            @endfor
                            </tbody>
                        </table>
                    </div>
                    <!--end::Table-->

                    <!-- ===== START PAGINATION ===== -->
                    @if(users.getTotalPages() > 0)
                        <div class="d-flex justify-content-between align-items-center pt-5">
                            <!-- Entries summary -->
                            <div class="text-muted fs-7">
                                Menampilkan
                                ${users.getNumber() * users.getSize() + 1}
                                sampai
                                ${Math.min((users.getNumber() + 1) * users.getSize(), users.getTotalElements())}
                                dari
                                ${users.getTotalElements()}
                                item
                            </div>

                            <!-- Pagination controls -->
                            <ul class="pagination m-0">
                                <!-- Previous -->
                                @if(users.hasPrevious())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${users.getNumber() - 1}&query=${query != null ? query : ""}&role=${roleFilter != null ? roleFilter : ""}">Sebelum</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Sebelum</span></li>
                                @endif

                                <!-- Page numbers -->
                                @for(int i = 0; i < users.getTotalPages(); i++)
                                    @if(i == users.getNumber())
                                        <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                                    @else
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${i}&query=${query != null ? query : ""}&role=${roleFilter != null ? roleFilter : ""}">${i + 1}</a>
                                        </li>
                                    @endif
                                @endfor

                                <!-- Next -->
                                @if(users.hasNext())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${users.getNumber() + 1}&query=${query != null ? query : ""}&role=${roleFilter != null ? roleFilter : ""}">Berikut</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Berikut</span></li>
                                @endif
                            </ul>
                        </div>
                    @endif
                    <!-- ===== END PAGINATION ===== -->

                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card-->

        </div>
    </div>
`
)