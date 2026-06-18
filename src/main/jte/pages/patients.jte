@param String role

@template.layout.base(title = "Patients", role = role, content = @`
    <!--begin::Toolbar-->
    <div class="d-flex flex-wrap flex-stack pb-7">
        <!--begin::Title-->
        <div class="d-flex flex-wrap align-items-center my-1">
            <h3 class="fw-bold me-5 my-1">Users (38)</h3>
            <!--begin::Search-->
            <div class="d-flex align-items-center position-relative my-1">
                <i class="ki-outline ki-magnifier fs-3 position-absolute ms-3"></i>
                <input type="text" id="kt_filter_search" class="form-control form-control-sm border-body bg-body w-150px ps-10" placeholder="Search" />
            </div>
            <!--end::Search-->
        </div>
        <!--end::Title-->
        <!--begin::Controls-->
        <div class="d-flex flex-wrap my-1">
            <!--begin::Tab nav-->
            <ul class="nav nav-pills me-6 mb-2 mb-sm-0">
                <li class="nav-item m-0">
                    <a class="btn btn-sm btn-icon btn-light btn-color-muted btn-active-primary me-3 active" data-bs-toggle="tab" href="#kt_project_users_card_pane">
                        <i class="ki-outline ki-element-plus fs-2"></i>
                    </a>
                </li>
                <li class="nav-item m-0">
                    <a class="btn btn-sm btn-icon btn-light btn-color-muted btn-active-primary" data-bs-toggle="tab" href="#kt_project_users_table_pane">
                        <i class="ki-outline ki-row-horizontal fs-2"></i>
                    </a>
                </li>
            </ul>
            <!--end::Tab nav-->
            <!--begin::Actions-->
            <div class="d-flex my-0">
                <!--begin::Select-->
                <select name="status" data-control="select2" data-hide-search="true" data-placeholder="Filter" class="form-select form-select-sm border-body bg-body w-150px me-5">
                    <option value="1">Recently Updated</option>
                    <option value="2">Last Month</option>
                    <option value="3">Last Quarter</option>
                    <option value="4">Last Year</option>
                </select>
                <!--end::Select-->
                <!--begin::Select-->
                <select name="status" data-control="select2" data-hide-search="true" data-placeholder="Export" class="form-select form-select-sm border-body bg-body w-100px">
                    <option value="1">Excel</option>
                    <option value="1">PDF</option>
                    <option value="2">Print</option>
                </select>
                <!--end::Select-->
            </div>
            <!--end::Actions-->
        </div>
        <!--end::Controls-->
    </div>
    <!--end::Toolbar-->
    <!--begin::Tab Content-->
    <div class="tab-content">
        <!--begin::Tab pane-->
        <div id="kt_project_users_card_pane" class="tab-pane fade show active">
            <!--begin::Row-->
            <div class="row g-6 g-xl-9">
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <img src="/media//avatars/300-2.jpg" alt="image" />
                                <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n3 mt-n3"></div>
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Karina Clark</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">Art Director at Novica Co.</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <span class="symbol-label fs-2x fw-semibold text-primary bg-light-primary">S</span>
                                <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n3 mt-n3"></div>
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Sean Bean</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">Developer at Loop Inc</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <img src="/media//avatars/300-1.jpg" alt="image" />
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Alan Johnson</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">Web Designer at Nextop Ltd.</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <img src="/media//avatars/300-14.jpg" alt="image" />
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Robert Doe</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">Marketing Analytic at Avito Ltd.</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <img src="/media//avatars/300-6.jpg" alt="image" />
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Olivia Wild</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">Art Director at Seal Inc.</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <span class="symbol-label fs-2x fw-semibold text-warning bg-light-warning">A</span>
                                <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n3 mt-n3"></div>
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Adam Williams</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">System Arcitect at Wolto Co.</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <span class="symbol-label fs-2x fw-semibold text-info bg-light-info">P</span>
                                <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n3 mt-n3"></div>
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Peter Marcus</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">Art Director at Novica Co.</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <span class="symbol-label fs-2x fw-semibold text-success bg-light-success">N</span>
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Neil Owen</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">Accountant at Numbers Co.</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
                <!--begin::Col-->
                <div class="col-md-6 col-xxl-4">
                    <!--begin::Card-->
                    <div class="card">
                        <!--begin::Card body-->
                        <div class="card-body d-flex flex-center flex-column pt-12 p-9">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-65px symbol-circle mb-5">
                                <img src="/media//avatars/300-12.jpg" alt="image" />
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Name-->
                            <a href="#" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">Benjamin Jacob</a>
                            <!--end::Name-->
                            <!--begin::Position-->
                            <div class="fw-semibold text-gray-500 mb-6">Art Director at Novica Co.</div>
                            <!--end::Position-->
                            <!--begin::Info-->
                            <div class="d-flex flex-center flex-wrap">
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$14,560</div>
                                    <div class="fw-semibold text-gray-500">Earnings</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">23</div>
                                    <div class="fw-semibold text-gray-500">Tasks</div>
                                </div>
                                <!--end::Stats-->
                                <!--begin::Stats-->
                                <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                                    <div class="fs-6 fw-bold text-gray-700">$236,400</div>
                                    <div class="fw-semibold text-gray-500">Sales</div>
                                </div>
                                <!--end::Stats-->
                            </div>
                            <!--end::Info-->
                        </div>
                        <!--end::Card body-->
                    </div>
                    <!--end::Card-->
                </div>
                <!--end::Col-->
            </div>
            <!--end::Row-->
            <!--begin::Pagination-->
            <div class="d-flex flex-stack flex-wrap pt-10">
                <div class="fs-6 fw-semibold text-gray-700">Showing 1 to 10 of 50 entries</div>
                <!--begin::Pages-->
                <ul class="pagination">
                    <li class="page-item previous">
                        <a href="#" class="page-link">
                            <i class="previous"></i>
                        </a>
                    </li>
                    <li class="page-item active">
                        <a href="#" class="page-link">1</a>
                    </li>
                    <li class="page-item">
                        <a href="#" class="page-link">2</a>
                    </li>
                    <li class="page-item">
                        <a href="#" class="page-link">3</a>
                    </li>
                    <li class="page-item">
                        <a href="#" class="page-link">4</a>
                    </li>
                    <li class="page-item">
                        <a href="#" class="page-link">5</a>
                    </li>
                    <li class="page-item">
                        <a href="#" class="page-link">6</a>
                    </li>
                    <li class="page-item next">
                        <a href="#" class="page-link">
                            <i class="next"></i>
                        </a>
                    </li>
                </ul>
                <!--end::Pages-->
            </div>
            <!--end::Pagination-->
        </div>
        <!--end::Tab pane-->
        <!--begin::Tab pane-->
        <div id="kt_project_users_table_pane" class="tab-pane fade">
            <!--begin::Card-->
            <div class="card card-flush">
                <!--begin::Card body-->
                <div class="card-body pt-0">
                    <!--begin::Table container-->
                    <div class="table-responsive">
                        <!--begin::Table-->
                        <table id="kt_project_users_table" class="table table-row-bordered table-row-dashed gy-4 align-middle fw-bold">
                            <thead class="fs-7 text-gray-500 text-uppercase">
                            <tr>
                                <th class="min-w-250px">Manager</th>
                                <th class="min-w-150px">Date</th>
                                <th class="min-w-90px">Amount</th>
                                <th class="min-w-90px">Status</th>
                                <th class="min-w-50px text-end">Details</th>
                            </tr>
                            </thead>
                            <tbody class="fs-6">
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-6.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Emma Smith</a>
                                            <div class="fw-semibold fs-6 text-gray-500">smith@kpmg.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>May 05, 2025</td>
                                <td>$851.00</td>
                                <td>
                                    <span class="badge badge-light-danger fw-bold px-4 py-3">Rejected</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-danger text-danger fw-semibold">M</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Melody Macy</a>
                                            <div class="fw-semibold fs-6 text-gray-500">melody@altbox.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Aug 19, 2025</td>
                                <td>$834.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-1.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Max Smith</a>
                                            <div class="fw-semibold fs-6 text-gray-500">max@kt.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jun 24, 2025</td>
                                <td>$412.00</td>
                                <td>
                                    <span class="badge badge-light-info fw-bold px-4 py-3">In progress</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-5.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Sean Bean</a>
                                            <div class="fw-semibold fs-6 text-gray-500">sean@dellito.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Nov 10, 2025</td>
                                <td>$714.00</td>
                                <td>
                                    <span class="badge badge-light-warning fw-bold px-4 py-3">Pending</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-25.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Brian Cox</a>
                                            <div class="fw-semibold fs-6 text-gray-500">brian@exchange.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jul 25, 2025</td>
                                <td>$553.00</td>
                                <td>
                                    <span class="badge badge-light-warning fw-bold px-4 py-3">Pending</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-warning text-warning fw-semibold">C</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Mikaela Collins</a>
                                            <div class="fw-semibold fs-6 text-gray-500">mik@pex.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Mar 10, 2025</td>
                                <td>$949.00</td>
                                <td>
                                    <span class="badge badge-light-danger fw-bold px-4 py-3">Rejected</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-9.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Francis Mitcham</a>
                                            <div class="fw-semibold fs-6 text-gray-500">f.mit@kpmg.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jun 24, 2025</td>
                                <td>$909.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-danger text-danger fw-semibold">O</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Olivia Wild</a>
                                            <div class="fw-semibold fs-6 text-gray-500">olivia@corpmail.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jun 24, 2025</td>
                                <td>$743.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-primary text-primary fw-semibold">N</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Neil Owen</a>
                                            <div class="fw-semibold fs-6 text-gray-500">owen.neil@gmail.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Aug 19, 2025</td>
                                <td>$681.00</td>
                                <td>
                                    <span class="badge badge-light-warning fw-bold px-4 py-3">Pending</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-23.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Dan Wilson</a>
                                            <div class="fw-semibold fs-6 text-gray-500">dam@consilting.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jun 24, 2025</td>
                                <td>$458.00</td>
                                <td>
                                    <span class="badge badge-light-info fw-bold px-4 py-3">In progress</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-danger text-danger fw-semibold">E</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Emma Bold</a>
                                            <div class="fw-semibold fs-6 text-gray-500">emma@intenso.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Sep 22, 2025</td>
                                <td>$644.00</td>
                                <td>
                                    <span class="badge badge-light-warning fw-bold px-4 py-3">Pending</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-12.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Ana Crown</a>
                                            <div class="fw-semibold fs-6 text-gray-500">ana.cf@limtel.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Dec 20, 2025</td>
                                <td>$626.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-info text-info fw-semibold">A</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Robert Doe</a>
                                            <div class="fw-semibold fs-6 text-gray-500">robert@benko.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Dec 20, 2025</td>
                                <td>$959.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-13.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">John Miller</a>
                                            <div class="fw-semibold fs-6 text-gray-500">miller@mapple.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jun 20, 2025</td>
                                <td>$858.00</td>
                                <td>
                                    <span class="badge badge-light-info fw-bold px-4 py-3">In progress</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-success text-success fw-semibold">L</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Lucy Kunic</a>
                                            <div class="fw-semibold fs-6 text-gray-500">lucy.m@fentech.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Apr 15, 2025</td>
                                <td>$730.00</td>
                                <td>
                                    <span class="badge badge-light-danger fw-bold px-4 py-3">Rejected</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-21.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Ethan Wilder</a>
                                            <div class="fw-semibold fs-6 text-gray-500">ethan@loop.com.au</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>May 05, 2025</td>
                                <td>$652.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-9.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Francis Mitcham</a>
                                            <div class="fw-semibold fs-6 text-gray-500">f.mit@kpmg.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Mar 10, 2025</td>
                                <td>$933.00</td>
                                <td>
                                    <span class="badge badge-light-info fw-bold px-4 py-3">In progress</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-13.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">John Miller</a>
                                            <div class="fw-semibold fs-6 text-gray-500">miller@mapple.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Nov 10, 2025</td>
                                <td>$897.00</td>
                                <td>
                                    <span class="badge badge-light-danger fw-bold px-4 py-3">Rejected</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-13.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">John Miller</a>
                                            <div class="fw-semibold fs-6 text-gray-500">miller@mapple.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>May 05, 2025</td>
                                <td>$948.00</td>
                                <td>
                                    <span class="badge badge-light-danger fw-bold px-4 py-3">Rejected</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-info text-info fw-semibold">A</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Robert Doe</a>
                                            <div class="fw-semibold fs-6 text-gray-500">robert@benko.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jun 20, 2025</td>
                                <td>$915.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-13.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">John Miller</a>
                                            <div class="fw-semibold fs-6 text-gray-500">miller@mapple.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jul 25, 2025</td>
                                <td>$601.00</td>
                                <td>
                                    <span class="badge badge-light-info fw-bold px-4 py-3">In progress</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-success text-success fw-semibold">L</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Lucy Kunic</a>
                                            <div class="fw-semibold fs-6 text-gray-500">lucy.m@fentech.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>May 05, 2025</td>
                                <td>$610.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-25.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Brian Cox</a>
                                            <div class="fw-semibold fs-6 text-gray-500">brian@exchange.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Apr 15, 2025</td>
                                <td>$856.00</td>
                                <td>
                                    <span class="badge badge-light-info fw-bold px-4 py-3">In progress</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-25.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Brian Cox</a>
                                            <div class="fw-semibold fs-6 text-gray-500">brian@exchange.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Aug 19, 2025</td>
                                <td>$643.00</td>
                                <td>
                                    <span class="badge badge-light-danger fw-bold px-4 py-3">Rejected</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-danger text-danger fw-semibold">M</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Melody Macy</a>
                                            <div class="fw-semibold fs-6 text-gray-500">melody@altbox.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Sep 22, 2025</td>
                                <td>$422.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-21.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Ethan Wilder</a>
                                            <div class="fw-semibold fs-6 text-gray-500">ethan@loop.com.au</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Jul 25, 2025</td>
                                <td>$968.00</td>
                                <td>
                                    <span class="badge badge-light-info fw-bold px-4 py-3">In progress</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-danger text-danger fw-semibold">O</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Olivia Wild</a>
                                            <div class="fw-semibold fs-6 text-gray-500">olivia@corpmail.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>May 05, 2025</td>
                                <td>$496.00</td>
                                <td>
                                    <span class="badge badge-light-warning fw-bold px-4 py-3">Pending</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-5.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Sean Bean</a>
                                            <div class="fw-semibold fs-6 text-gray-500">sean@dellito.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Dec 20, 2025</td>
                                <td>$751.00</td>
                                <td>
                                    <span class="badge badge-light-info fw-bold px-4 py-3">In progress</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <span class="symbol-label bg-light-danger text-danger fw-semibold">E</span>
                                            </div>
                                            <!--end::Avatar-->
                                            <!--begin::Online-->
                                            <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n1 mt-n1"></div>
                                            <!--end::Online-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Emma Bold</a>
                                            <div class="fw-semibold fs-6 text-gray-500">emma@intenso.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Sep 22, 2025</td>
                                <td>$834.00</td>
                                <td>
                                    <span class="badge badge-light-danger fw-bold px-4 py-3">Rejected</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--begin::User-->
                                    <div class="d-flex align-items-center">
                                        <!--begin::Wrapper-->
                                        <div class="me-5 position-relative">
                                            <!--begin::Avatar-->
                                            <div class="symbol symbol-35px symbol-circle">
                                                <img alt="Pic" src="/media/avatars/300-5.jpg" />
                                            </div>
                                            <!--end::Avatar-->
                                        </div>
                                        <!--end::Wrapper-->
                                        <!--begin::Info-->
                                        <div class="d-flex flex-column justify-content-center">
                                            <a href="" class="mb-1 text-gray-800 text-hover-primary">Sean Bean</a>
                                            <div class="fw-semibold fs-6 text-gray-500">sean@dellito.com</div>
                                        </div>
                                        <!--end::Info-->
                                    </div>
                                    <!--end::User-->
                                </td>
                                <td>Feb 21, 2025</td>
                                <td>$626.00</td>
                                <td>
                                    <span class="badge badge-light-success fw-bold px-4 py-3">Approved</span>
                                </td>
                                <td class="text-end">
                                    <a href="#" class="btn btn-light btn-sm">View</a>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <!--end::Table-->
                    </div>
                    <!--end::Table container-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card-->
        </div>
        <!--end::Tab pane-->
    </div>
    <!--end::Tab Content-->
`)
