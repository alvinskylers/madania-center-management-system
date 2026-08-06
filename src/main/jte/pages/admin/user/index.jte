@import com.madania.management.entity.User
@import org.springframework.data.domain.Page
@import org.springframework.security.web.csrf.CsrfToken

@param Page<User> users
@param String role
@param String query
@param CsrfToken _csrf

@template.layout.base(
title = "Users",
role = role,
content = @`
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <!--begin::Toolbar container-->
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <!--begin::Toolbar wrapper-->
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <!--begin::Page title-->
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <!--begin::Title-->
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">User List</h1>
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
                        <li class="breadcrumb-item text-muted">Users</li>
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
                                       placeholder="Search Users"
                                       value="${query != null ? query : ""}" />
                                <input type="hidden" name="page" value="0" />
                                <button type="submit" class="btn btn-light-primary me-3 gap-3">Search</button>
                            </div>
                        </form>
                        <!--end::Search-->
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
                                <th class="min-w-125px">Name</th>
                                <th class="min-w-125px">Email</th>
                                <th class="min-w-125px">Role</th>
                                <th class="min-w-125px">Status</th>
                                <th class="min-w-125px">Created Date</th>
                                <th class="text-end min-w-70px">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="fw-semibold text-gray-600">
                            @for(User user : users)
                                @template.pages.admin.user.row(user = user)
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
                                Showing
                                ${users.getNumber() * users.getSize() + 1}
                                to
                                ${Math.min((users.getNumber() + 1) * users.getSize(), users.getTotalElements())}
                                of
                                ${users.getTotalElements()}
                                entries
                            </div>

                            <!-- Pagination controls -->
                            <ul class="pagination m-0">
                                <!-- Previous -->
                                @if(users.hasPrevious())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${users.getNumber() - 1}&query=${query != null ? query : ""}">Previous</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Previous</span></li>
                                @endif

                                <!-- Page numbers -->
                                @for(int i = 0; i < users.getTotalPages(); i++)
                                    @if(i == users.getNumber())
                                        <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                                    @else
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${i}&query=${query != null ? query : ""}">${i + 1}</a>
                                        </li>
                                    @endif
                                @endfor

                                <!-- Next -->
                                @if(users.hasNext())
                                    <li class="page-item">
                                            <a class="page-link" href="?page=${users.getNumber() + 1}&query=${query != null ? query : ""}">Next</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Next</span></li>
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