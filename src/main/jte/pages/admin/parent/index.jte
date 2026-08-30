@import com.madania.management.entity.Parent
@import com.madania.management.entity.User
@import org.springframework.data.domain.Page
@import org.springframework.security.web.csrf.CsrfToken

@param Page<Parent> parents
@param String role
@param User user
@param String query
@param CsrfToken _csrf

@template.layout.base(
title = "Parents",
role = role,
user = user,
_csrf = _csrf,
content = @`
    <div id="kt_app_toolbar" class="app-toolbar pt-7 pt-lg-10">
        <div id="kt_app_toolbar_container" class="app-container container-fluid d-flex align-items-stretch">
            <div class="app-toolbar-wrapper d-flex flex-stack flex-wrap gap-4 w-100">
                <div class="page-title d-flex flex-column justify-content-center gap-1 me-3">
                    <h1 class="page-heading d-flex flex-column justify-content-center text-gray-900 fw-bold fs-3 m-0">Parent List</h1>
                    <ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0">
                        <li class="breadcrumb-item text-muted">
                            <a href="/admin/dashboard" class="text-muted text-hover-primary">Dashboard</a>
                        </li>
                        <li class="breadcrumb-item">
                            <span class="bullet bg-gray-500 w-5px h-2px"></span>
                        </li>
                        <li class="breadcrumb-item text-muted">Parents</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div id="kt_app_content" class="app-content flex-column-fluid">
        <div id="kt_app_content_container" class="app-container container-fluid">
            <div class="card">
                <div class="card-header border-0 pt-6">
                    <div class="card-title">
                        <form action="/admin/parents" method="get" enctype="text/plain">
                            <input type="hidden" name="_csrf" value="${_csrf.getToken()}"/>
                            <div class="d-flex align-items-center position-relative my-1">
                                <i class="ki-outline ki-magnifier fs-3 position-absolute ms-5"></i>
                                <input type="text"
                                       name="query"
                                       class="form-control form-control-solid w-250px ps-13"
                                       placeholder="Search Parents"
                                       value="${query != null ? query : ""}" />
                                <input type="hidden" name="page" value="0" />
                                <button type="submit" class="btn btn-light-primary me-3 gap-3">Search</button>
                            </div>
                        </form>
                    </div>
                    <div class="card-toolbar">
                        <a href="/admin/parent/create" class="btn btn-primary">
                            <i class="ki-outline ki-plus fs-2"></i>Add Parent
                        </a>
                    </div>
                </div>

                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_parents_table">
                            <thead>
                            <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                                <th class="min-w-250px">Parent</th>
                                <th class="min-w-125px">Phone</th>
                                <th class="min-w-125px">Address</th>
                                <th class="text-end min-w-70px">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="fw-semibold text-gray-600">
                            @for(Parent parent : parents)
                                @template.components.parent-row(parent = parent, _csrf = _csrf)
                            @endfor
                            </tbody>
                        </table>
                    </div>

                    <!-- ===== START PAGINATION ===== -->
                    @if(parents.getTotalPages() > 0)
                        <div class="d-flex justify-content-between align-items-center pt-5">
                            <div class="text-muted fs-7">
                                Showing
                                ${parents.getNumber() * parents.getSize() + 1}
                                to
                                ${Math.min((parents.getNumber() + 1) * parents.getSize(), parents.getTotalElements())}
                                of
                                ${parents.getTotalElements()}
                                entries
                            </div>

                            <ul class="pagination m-0">
                                @if(parents.hasPrevious())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${parents.getNumber() - 1}&query=${query != null ? query : ""}">Previous</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Previous</span></li>
                                @endif

                                @for(int i = 0; i < parents.getTotalPages(); i++)
                                    @if(i == parents.getNumber())
                                        <li class="page-item active"><span class="page-link">${i + 1}</span></li>
                                    @else
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${i}&query=${query != null ? query : ""}">${i + 1}</a>
                                        </li>
                                    @endif
                                @endfor

                                @if(parents.hasNext())
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${parents.getNumber() + 1}&query=${query != null ? query : ""}">Next</a>
                                    </li>
                                @else
                                    <li class="page-item disabled"><span class="page-link">Next</span></li>
                                @endif
                            </ul>
                        </div>
                    @endif
                    <!-- ===== END PAGINATION ===== -->
                </div>
            </div>
        </div>
    </div>
`
)