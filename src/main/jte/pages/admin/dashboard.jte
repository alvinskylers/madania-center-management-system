
@import org.springframework.security.web.csrf.CsrfToken
@param CsrfToken _csrf
@param String role

@template.layout.base(
title = "Dashboard",
role = role,
_csrf = _csrf,
content = @`
    <!--begin::Row-->
    <div class="row gx-5 gx-xl-10">
        <!--begin::Col-->
        <div class="col-xl-8 mb-10">
            <!--begin::Lists Widget 19-->
            <div class="card card-flush h-xl-100">
                <!--begin::Heading-->
                <div class="card-header rounded bgi-no-repeat bgi-size-cover bgi-position-y-top bgi-position-x-center align-items-start h-250px" style="background-image:url('/media/svg/shapes/top-green.png" data-bs-theme="light">
                    <!--begin::Title-->
                    <h3 class="card-title align-items-start flex-column text-white pt-15">
                        <span class="fw-bold fs-2x mb-3">Welcome back, Admin!</span>
                        <div class="fs-4 text-white">
                            <span class="opacity-75">Let's get some work done today!</span>
                        </div>
                    </h3>
                    <!--end::Title-->
                    <!--begin::Toolbar-->
                    <div class="card-toolbar pt-5">
                        <!--begin::Menu-->
                        <button class="btn btn-sm btn-icon btn-active-color-primary btn-color-white bg-white bg-opacity-25 bg-hover-opacity-100 bg-hover-white bg-active-opacity-25 w-20px h-20px" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end" data-kt-menu-overflow="true">
                            <i class="ki-outline ki-dots-square fs-4"></i>
                        </button>
                        <!--begin::Menu 2-->
                        <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg-light-primary fw-semibold w-200px" data-kt-menu="true">
                            <!--begin::Menu item-->
                            <div class="menu-item px-3">
                                <div class="menu-content fs-6 text-gray-900 fw-bold px-3 py-4">Quick Actions</div>
                            </div>
                            <!--end::Menu item-->
                            <!--begin::Menu separator-->
                            <div class="separator mb-3 opacity-75"></div>
                            <!--end::Menu separator-->
                            <!--begin::Menu item-->
                            <div class="menu-item px-3">
                                <a href="#" class="menu-link px-3">New Ticket</a>
                            </div>
                            <!--end::Menu item-->
                            <!--begin::Menu item-->
                            <div class="menu-item px-3">
                                <a href="#" class="menu-link px-3">New Customer</a>
                            </div>
                            <!--end::Menu item-->
                            <!--begin::Menu item-->
                            <div class="menu-item px-3">
                                <a href="#" class="menu-link px-3">New Contact</a>
                            </div>
                            <!--end::Menu item-->
                            <!--begin::Menu separator-->
                            <div class="separator mt-3 opacity-75"></div>
                            <!--end::Menu separator-->
                            <!--begin::Menu item-->
                            <div class="menu-item px-3">
                                <div class="menu-content px-3 py-3">
                                    <a class="btn btn-primary btn-sm px-4" href="#">Generate Reports</a>
                                </div>
                            </div>
                            <!--end::Menu item-->
                        </div>
                        <!--end::Menu 2-->
                        <!--end::Menu-->
                    </div>
                    <!--end::Toolbar-->
                </div>
                <!--end::Heading-->
                <!--begin::Body-->
                <div class="card-body mt-n20">
                    <!--begin::Stats-->
                    <div class="mt-n20 position-relative">
                        <!--begin::Row-->
                        <div class="row g-3 g-lg-6">
                            <!--begin::Col-->
                            <div class="col-6">
                                <!--begin::Items-->
                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                    <!--begin::Symbol-->
                                    <div class="symbol symbol-30px me-5 mb-8">
																		<span class="symbol-label">
																			<i class="ki-outline ki-people fs-1 text-primary"></i>
																		</span>
                                    </div>
                                    <!--end::Symbol-->
                                    <!--begin::Stats-->
                                    <div class="m-0">
                                        <!--begin::Number-->
                                        <span class="text-gray-700 fw-bolder d-block fs-2qx lh-1 ls-n1 mb-1">37</span>
                                        <!--end::Number-->
                                        <!--begin::Desc-->
                                        <span class="text-gray-500 fw-semibold fs-6">Patients</span>
                                        <!--end::Desc-->
                                    </div>
                                    <!--end::Stats-->
                                </div>
                                <!--end::Items-->
                            </div>
                            <!--end::Col-->
                            <!--begin::Col-->
                            <div class="col-6">
                                <!--begin::Items-->
                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                    <!--begin::Symbol-->
                                    <div class="symbol symbol-30px me-5 mb-8">
																		<span class="symbol-label">
																			<i class="ki-outline ki-user-tick fs-1 text-primary"></i>
																		</span>
                                    </div>
                                    <!--end::Symbol-->
                                    <!--begin::Stats-->
                                    <div class="m-0">
                                        <!--begin::Number-->
                                        <span class="text-gray-700 fw-bolder d-block fs-2qx lh-1 ls-n1 mb-1">6</span>
                                        <!--end::Number-->
                                        <!--begin::Desc-->
                                        <span class="text-gray-500 fw-semibold fs-6">Therapists</span>
                                        <!--end::Desc-->
                                    </div>
                                    <!--end::Stats-->
                                </div>
                                <!--end::Items-->
                            </div>
                            <!--end::Col-->
                            <!--begin::Col-->
                            <div class="col-6">
                                <!--begin::Items-->
                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                    <!--begin::Symbol-->
                                    <div class="symbol symbol-30px me-5 mb-8">
																		<span class="symbol-label">
																			<i class="ki-outline ki-book-open fs-1 text-primary"></i>
																		</span>
                                    </div>
                                    <!--end::Symbol-->
                                    <!--begin::Stats-->
                                    <div class="m-0">
                                        <!--begin::Number-->
                                        <span class="text-gray-700 fw-bolder d-block fs-2qx lh-1 ls-n1 mb-1">4,7</span>
                                        <!--end::Number-->
                                        <!--begin::Desc-->
                                        <span class="text-gray-500 fw-semibold fs-6">Jounals</span>
                                        <!--end::Desc-->
                                    </div>
                                    <!--end::Stats-->
                                </div>
                                <!--end::Items-->
                            </div>
                            <!--end::Col-->
                            <!--begin::Col-->
                            <div class="col-6">
                                <!--begin::Items-->
                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                    <!--begin::Symbol-->
                                    <div class="symbol symbol-30px me-5 mb-8">
																		<span class="symbol-label">
																			<i class="ki-outline ki-people fs-1 text-primary"></i>
																		</span>
                                    </div>
                                    <!--end::Symbol-->
                                    <!--begin::Stats-->
                                    <div class="m-0">
                                        <!--begin::Number-->
                                        <span class="text-gray-700 fw-bolder d-block fs-2qx lh-1 ls-n1 mb-1">822</span>
                                        <!--end::Number-->
                                        <!--begin::Desc-->
                                        <span class="text-gray-500 fw-semibold fs-6">Parents</span>
                                        <!--end::Desc-->
                                    </div>
                                    <!--end::Stats-->
                                </div>
                                <!--end::Items-->
                            </div>
                            <!--end::Col-->
                        </div>
                        <!--end::Row-->
                    </div>
                    <!--end::Stats-->
                </div>
                <!--end::Body-->
            </div>
            <!--end::Lists Widget 19-->
        </div>
        <!--end::Col-->
        <!--begin::Col-->
        <div class="col-xl-4 mb-5 mb-xl-10">
            <!--begin::Slider Widget 2-->
            <div id="kt_sliders_widget_2_slider" class="card card-flush carousel carousel-custom carousel-stretch slide h-xl-100" data-bs-ride="carousel" data-bs-interval="5500">
                <!--begin::Header-->
                <div class="card-header pt-5">
                    <!--begin::Title-->
                    <h4 class="card-title d-flex align-items-start flex-column">
                        <span class="card-label fw-bold text-gray-800">Today’s Schedule</span>
                        <span class="text-gray-500 mt-1 fw-bold fs-7">69 Therapy Sessions</span>
                    </h4>
                    <!--end::Title-->
                    <!--begin::Toolbar-->
                    <div class="card-toolbar">
                        <!--begin::Carousel Indicators-->
                        <ol class="p-0 m-0 carousel-indicators carousel-indicators-bullet carousel-indicators-active-success">
                            <li data-bs-target="#kt_sliders_widget_2_slider" data-bs-slide-to="0" class="active ms-1"></li>
                            <li data-bs-target="#kt_sliders_widget_2_slider" data-bs-slide-to="1" class="ms-1"></li>
                            <li data-bs-target="#kt_sliders_widget_2_slider" data-bs-slide-to="2" class="ms-1"></li>
                        </ol>
                        <!--end::Carousel Indicators-->
                    </div>
                    <!--end::Toolbar-->
                </div>
                <!--end::Header-->
                <!--begin::Body-->
                <div class="card-body py-6">
                    <!--begin::Carousel-->
                    <div class="carousel-inner">
                        <!--begin::Item-->
                        <div class="carousel-item active show">
                            <!--begin::Wrapper-->
                            <div class="d-flex align-items-center mb-9">
                                <!--begin::Symbol-->
                                <div class="symbol symbol-70px symbol-circle me-5">
																			<span class="symbol-label bg-light-success">
																				<i class="ki-outline ki-abstract-24 fs-3x text-success"></i>
																			</span>
                                </div>
                                <!--end::Symbol-->
                                <!--begin::Info-->
                                <div class="m-0">
                                    <!--begin::Subtitle-->
                                    <h4 class="fw-bold text-gray-800 mb-3">Ruby on Rails</h4>
                                    <!--end::Subtitle-->
                                    <!--begin::Items-->
                                    <div class="d-flex d-grid gap-5">
                                        <!--begin::Item-->
                                        <div class="d-flex flex-column flex-shrink-0 me-4">
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center fs-7 fw-bold text-gray-500 mb-2">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>5 Topics</span>
                                            <!--end::Section-->
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center text-gray-500 fw-bold fs-7">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>1 Speakers</span>
                                            <!--end::Section-->
                                        </div>
                                        <!--end::Item-->
                                        <!--begin::Item-->
                                        <div class="d-flex flex-column flex-shrink-0">
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center fs-7 fw-bold text-gray-500 mb-2">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>60 Min</span>
                                            <!--end::Section-->
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center text-gray-500 fw-bold fs-7">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>137 students</span>
                                            <!--end::Section-->
                                        </div>
                                        <!--end::Item-->
                                    </div>
                                    <!--end::Items-->
                                </div>
                                <!--end::Info-->
                            </div>
                            <!--end::Wrapper-->
                            <!--begin::Action-->
                            <div class="m-0">
                                <a href="#" class="btn btn-sm btn-light me-2 mb-2">Details</a>
                                <a href="#" class="btn btn-sm btn-success mb-2" data-bs-toggle="modal" data-bs-target="#kt_modal_create_campaign">Join Event</a>
                            </div>
                            <!--end::Action-->
                        </div>
                        <!--end::Item-->
                        <!--begin::Item-->
                        <div class="carousel-item">
                            <!--begin::Wrapper-->
                            <div class="d-flex align-items-center mb-9">
                                <!--begin::Symbol-->
                                <div class="symbol symbol-70px symbol-circle me-5">
																			<span class="symbol-label bg-light-danger">
																				<i class="ki-outline ki-abstract-25 fs-3x text-danger"></i>
																			</span>
                                </div>
                                <!--end::Symbol-->
                                <!--begin::Info-->
                                <div class="m-0">
                                    <!--begin::Subtitle-->
                                    <h4 class="fw-bold text-gray-800 mb-3">Ruby on Rails</h4>
                                    <!--end::Subtitle-->
                                    <!--begin::Items-->
                                    <div class="d-flex d-grid gap-5">
                                        <!--begin::Item-->
                                        <div class="d-flex flex-column flex-shrink-0 me-4">
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center fs-7 fw-bold text-gray-500 mb-2">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>12 Topics</span>
                                            <!--end::Section-->
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center text-gray-500 fw-bold fs-7">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>1 Speakers</span>
                                            <!--end::Section-->
                                        </div>
                                        <!--end::Item-->
                                        <!--begin::Item-->
                                        <div class="d-flex flex-column flex-shrink-0">
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center fs-7 fw-bold text-gray-500 mb-2">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>50 Min</span>
                                            <!--end::Section-->
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center text-gray-500 fw-bold fs-7">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>72 students</span>
                                            <!--end::Section-->
                                        </div>
                                        <!--end::Item-->
                                    </div>
                                    <!--end::Items-->
                                </div>
                                <!--end::Info-->
                            </div>
                            <!--end::Wrapper-->
                            <!--begin::Action-->
                            <div class="m-0">
                                <a href="#" class="btn btn-sm btn-light me-2 mb-2">Details</a>
                                <a href="#" class="btn btn-sm btn-success mb-2" data-bs-toggle="modal" data-bs-target="#kt_modal_create_campaign">Join Event</a>
                            </div>
                            <!--end::Action-->
                        </div>
                        <!--end::Item-->
                        <!--begin::Item-->
                        <div class="carousel-item">
                            <!--begin::Wrapper-->
                            <div class="d-flex align-items-center mb-9">
                                <!--begin::Symbol-->
                                <div class="symbol symbol-70px symbol-circle me-5">
																			<span class="symbol-label bg-light-primary">
																				<i class="ki-outline ki-abstract-36 fs-3x text-primary"></i>
																			</span>
                                </div>
                                <!--end::Symbol-->
                                <!--begin::Info-->
                                <div class="m-0">
                                    <!--begin::Subtitle-->
                                    <h4 class="fw-bold text-gray-800 mb-3">Ruby on Rails</h4>
                                    <!--end::Subtitle-->
                                    <!--begin::Items-->
                                    <div class="d-flex d-grid gap-5">
                                        <!--begin::Item-->
                                        <div class="d-flex flex-column flex-shrink-0 me-4">
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center fs-7 fw-bold text-gray-500 mb-2">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>3 Topics</span>
                                            <!--end::Section-->
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center text-gray-500 fw-bold fs-7">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>1 Speakers</span>
                                            <!--end::Section-->
                                        </div>
                                        <!--end::Item-->
                                        <!--begin::Item-->
                                        <div class="d-flex flex-column flex-shrink-0">
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center fs-7 fw-bold text-gray-500 mb-2">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>50 Min</span>
                                            <!--end::Section-->
                                            <!--begin::Section-->
                                            <span class="d-flex align-items-center text-gray-500 fw-bold fs-7">
																					<i class="ki-outline ki-right-square fs-6 text-gray-600 me-2"></i>72 students</span>
                                            <!--end::Section-->
                                        </div>
                                        <!--end::Item-->
                                    </div>
                                    <!--end::Items-->
                                </div>
                                <!--end::Info-->
                            </div>
                            <!--end::Wrapper-->
                            <!--begin::Action-->
                            <div class="m-0">
                                <a href="#" class="btn btn-sm btn-light me-2 mb-2">Details</a>
                                <a href="#" class="btn btn-sm btn-success mb-2" data-bs-toggle="modal" data-bs-target="#kt_modal_create_campaign">Join Event</a>
                            </div>
                            <!--end::Action-->
                        </div>
                        <!--end::Item-->
                    </div>
                    <!--end::Carousel-->
                </div>
                <!--end::Body-->
            </div>
            <!--end::Slider Widget 2-->
        </div>
        <!--end::Col-->

    </div>
    <!--end::Row-->

    <!--begin::Row-->
    <div class="row g-5 gx-xl-12 mb-5 mb-xl-10">
        <!--begin::Col-->
        <div class="col-xl-12">
            <!--begin::Table widget 8-->
            <div class="card h-xl-100">
                <!--begin::Header-->
                <div class="card-header position-relative py-0 border-bottom-2">
                    <!--begin::Nav-->
                    <ul class="nav nav-stretch nav-pills nav-pills-custom d-flex mt-3">
                        <!--begin::Nav item-->
                        <li class="nav-item p-0 ms-0 me-8">
                            <!--begin::Nav link-->
                            <a class="nav-link btn btn-color-muted px-0" data-bs-toggle="tab" href="#kt_table_widget_7_tab_content_1">
                                <!--begin::Title-->
                                <span class="nav-text fw-semibold fs-4 mb-3">Monday</span>
                                <!--end::Title-->
                                <!--begin::Bullet-->
                                <span class="bullet-custom position-absolute z-index-2 w-100 h-2px top-100 bottom-n100 bg-primary rounded"></span>
                                <!--end::Bullet-->
                            </a>
                            <!--end::Nav link-->
                        </li>
                        <!--end::Nav item-->
                        <!--begin::Nav item-->
                        <li class="nav-item p-0 ms-0 me-8">
                            <!--begin::Nav link-->
                            <a class="nav-link btn btn-color-muted px-0" data-bs-toggle="tab" href="#kt_table_widget_7_tab_content_2">
                                <!--begin::Title-->
                                <span class="nav-text fw-semibold fs-4 mb-3">Tuesday</span>
                                <!--end::Title-->
                                <!--begin::Bullet-->
                                <span class="bullet-custom position-absolute z-index-2 w-100 h-2px top-100 bottom-n100 bg-primary rounded"></span>
                                <!--end::Bullet-->
                            </a>
                            <!--end::Nav link-->
                        </li>
                        <!--end::Nav item-->
                        <!--begin::Nav item-->
                        <li class="nav-item p-0 ms-0 me-8">
                            <!--begin::Nav link-->
                            <a class="nav-link btn btn-color-muted px-0 show active" data-bs-toggle="tab" href="#kt_table_widget_7_tab_content_3">
                                <!--begin::Title-->
                                <span class="nav-text fw-semibold fs-4 mb-3">Wednesday</span>
                                <!--end::Title-->
                                <!--begin::Bullet-->
                                <span class="bullet-custom position-absolute z-index-2 w-100 h-2px top-100 bottom-n100 bg-primary rounded"></span>
                                <!--end::Bullet-->
                            </a>
                            <!--end::Nav link-->
                        </li>
                        <!--end::Nav item-->
                        <!--begin::Nav item-->
                        <li class="nav-item p-0 ms-0 me-8">
                            <!--begin::Nav link-->
                            <a class="nav-link btn btn-color-muted px-0" data-bs-toggle="tab" href="#kt_table_widget_7_tab_content_4">
                                <!--begin::Title-->
                                <span class="nav-text fw-semibold fs-4 mb-3">Thursday</span>
                                <!--end::Title-->
                                <!--begin::Bullet-->
                                <span class="bullet-custom position-absolute z-index-2 w-100 h-2px top-100 bottom-n100 bg-primary rounded"></span>
                                <!--end::Bullet-->
                            </a>
                            <!--end::Nav link-->
                        </li>
                        <!--end::Nav item-->
                        <!--begin::Nav item-->
                        <li class="nav-item p-0 ms-0 me-8">
                            <!--begin::Nav link-->
                            <a class="nav-link btn btn-color-muted px-0" data-bs-toggle="tab" href="#kt_table_widget_7_tab_content_5">
                                <!--begin::Title-->
                                <span class="nav-text fw-semibold fs-4 mb-3">Friday</span>
                                <!--end::Title-->
                                <!--begin::Bullet-->
                                <span class="bullet-custom position-absolute z-index-2 w-100 h-2px top-100 bottom-n100 bg-primary rounded"></span>
                                <!--end::Bullet-->
                            </a>
                            <!--end::Nav link-->
                        </li>
                        <!--end::Nav item-->
                    </ul>
                    <!--end::Nav-->
                    <!--begin::Toolbar-->
                    <div class="card-toolbar">
                        <!--begin::Daterangepicker(defined in src/js/layout/app.js)-->
                        <div data-kt-daterangepicker="true" data-kt-daterangepicker-opens="left" class="btn btn-sm btn-light d-flex align-items-center px-4">
                            <!--begin::Display range-->
                            <div class="text-gray-600 fw-bold">Loading date range...</div>
                            <!--end::Display range-->
                            <i class="ki-outline ki-calendar-8 fs-1 ms-2 me-0"></i>
                        </div>
                        <!--end::Daterangepicker-->
                    </div>
                    <!--end::Toolbar-->
                </div>
                <!--end::Header-->
                <!--begin::Body-->
                <div class="card-body">
                    <!--begin::Tab Content (ishlamayabdi)-->
                    <div class="tab-content mb-2">
                        <!--begin::Tap pane-->
                        <div class="tab-pane fade" id="kt_table_widget_7_tab_content_1">
                            <!--begin::Table container-->
                            <div class="table-responsive">
                                <!--begin::Table-->
                                <table class="table align-middle">
                                    <!--begin::Table head-->
                                    <thead>
                                    <tr>
                                        <th class="min-w-150px p-0"></th>
                                        <th class="min-w-200px p-0"></th>
                                        <th class="min-w-100px p-0"></th>
                                        <th class="min-w-80px p-0"></th>
                                    </tr>
                                    </thead>
                                    <!--end::Table head-->
                                    <!--begin::Table body-->
                                    <tbody>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">11:43-09:43am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 1:
                                            <span class="text-gray-800">French class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">5</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 205min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">09:40-11:20am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 2:
                                            <span class="text-gray-800">Physics class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">13</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 25min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">10:35-43:09am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 3:
                                            <span class="text-gray-800">Chemistry class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Court:
                                            <span class="text-gray-800">Main</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 15min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">15:30-12:23pm</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 4:
                                            <span class="text-gray-800">Biology class</span>
                                            <!--begin::Icon-->
                                            <span class="cursor-pointer" data-bs-toggle="tooltip" data-bs-placement="top" title="Held by Dr. Ana">
																				<i class="ki-outline ki-information fs-1 text-warning"></i>
																			</span>
                                            <!--end::Icon--></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">23</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    </tbody>
                                    <!--end::Table body-->
                                </table>
                                <!--end::Table-->
                            </div>
                            <!--end::Table container-->
                        </div>
                        <!--end::Tap pane-->
                        <!--begin::Tap pane-->
                        <div class="tab-pane fade" id="kt_table_widget_7_tab_content_2">
                            <!--begin::Table container-->
                            <div class="table-responsive">
                                <!--begin::Table-->
                                <table class="table align-middle">
                                    <!--begin::Table head-->
                                    <thead>
                                    <tr>
                                        <th class="min-w-150px p-0"></th>
                                        <th class="min-w-200px p-0"></th>
                                        <th class="min-w-100px p-0"></th>
                                        <th class="min-w-80px p-0"></th>
                                    </tr>
                                    </thead>
                                    <!--end::Table head-->
                                    <!--begin::Table body-->
                                    <tbody>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">09:15-12:23am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 1:
                                            <span class="text-gray-800">Geography class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">45</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 20min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">08:30-09:30am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 2:
                                            <span class="text-gray-800">English class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">9</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 20min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">11:15-12:13am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 3:
                                            <span class="text-gray-800">Sports class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Court:
                                            <span class="text-gray-800">Main</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 25min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">14:10-15:35pm</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 4:
                                            <span class="text-gray-800">Picture class</span>
                                            <!--begin::Icon-->
                                            <span class="cursor-pointer" data-bs-toggle="tooltip" data-bs-placement="top" title="Held by Dr. Lebron">
																				<i class="ki-outline ki-information fs-1 text-warning"></i>
																			</span>
                                            <!--end::Icon--></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">12</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    </tbody>
                                    <!--end::Table body-->
                                </table>
                                <!--end::Table-->
                            </div>
                            <!--end::Table container-->
                        </div>
                        <!--end::Tap pane-->
                        <!--begin::Tap pane-->
                        <div class="tab-pane fade show active" id="kt_table_widget_7_tab_content_3">
                            <!--begin::Table container-->
                            <div class="table-responsive">
                                <!--begin::Table-->
                                <table class="table align-middle">
                                    <!--begin::Table head-->
                                    <thead>
                                    <tr>
                                        <th class="min-w-150px p-0"></th>
                                        <th class="min-w-200px p-0"></th>
                                        <th class="min-w-100px p-0"></th>
                                        <th class="min-w-80px p-0"></th>
                                    </tr>
                                    </thead>
                                    <!--end::Table head-->
                                    <!--begin::Table body-->
                                    <tbody>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">08:30-09:12am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 1:
                                            <span class="text-gray-800">Math class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">45</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 15min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">09:30-10:50am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 2:
                                            <span class="text-gray-800">History class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">12</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 20min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">10:35-11:20am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 3:
                                            <span class="text-gray-800">Sports class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Court:
                                            <span class="text-gray-800">Main</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 15min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">12:40-13:25pm</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 4:
                                            <span class="text-gray-800">Chemistry class</span>
                                            <!--begin::Icon-->
                                            <span class="cursor-pointer" data-bs-toggle="tooltip" data-bs-placement="top" title="Held by Dr. Natali">
																				<i class="ki-outline ki-information fs-1 text-warning"></i>
																			</span>
                                            <!--end::Icon--></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">19</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    </tbody>
                                    <!--end::Table body-->
                                </table>
                                <!--end::Table-->
                            </div>
                            <!--end::Table container-->
                        </div>
                        <!--end::Tap pane-->
                        <!--begin::Tap pane-->
                        <div class="tab-pane fade" id="kt_table_widget_7_tab_content_4">
                            <!--begin::Table container-->
                            <div class="table-responsive">
                                <!--begin::Table-->
                                <table class="table align-middle">
                                    <!--begin::Table head-->
                                    <thead>
                                    <tr>
                                        <th class="min-w-150px p-0"></th>
                                        <th class="min-w-200px p-0"></th>
                                        <th class="min-w-100px p-0"></th>
                                        <th class="min-w-80px p-0"></th>
                                    </tr>
                                    </thead>
                                    <!--end::Table head-->
                                    <!--begin::Table body-->
                                    <tbody>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">11:25-14:13am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 1:
                                            <span class="text-gray-800">Geography class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">15</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 25min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">08:30-09:30am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 2:
                                            <span class="text-gray-800">English class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">9</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 20min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">11:15-12:13am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 3:
                                            <span class="text-gray-800">Sports class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Court:
                                            <span class="text-gray-800">Main</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 25min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">14:10-15:35pm</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 4:
                                            <span class="text-gray-800">Picture class</span>
                                            <!--begin::Icon-->
                                            <span class="cursor-pointer" data-bs-toggle="tooltip" data-bs-placement="top" title="Held by Dr. Kevin">
																				<i class="ki-outline ki-information fs-1 text-warning"></i>
																			</span>
                                            <!--end::Icon--></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">12</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    </tbody>
                                    <!--end::Table body-->
                                </table>
                                <!--end::Table-->
                            </div>
                            <!--end::Table container-->
                        </div>
                        <!--end::Tap pane-->
                        <!--begin::Tap pane-->
                        <div class="tab-pane fade" id="kt_table_widget_7_tab_content_5">
                            <!--begin::Table container-->
                            <div class="table-responsive">
                                <!--begin::Table-->
                                <table class="table align-middle">
                                    <!--begin::Table head-->
                                    <thead>
                                    <tr>
                                        <th class="min-w-150px p-0"></th>
                                        <th class="min-w-200px p-0"></th>
                                        <th class="min-w-100px p-0"></th>
                                        <th class="min-w-80px p-0"></th>
                                    </tr>
                                    </thead>
                                    <!--end::Table head-->
                                    <!--begin::Table body-->
                                    <tbody>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">11:43-09:43am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 1:
                                            <span class="text-gray-800">French class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">5</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 205min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">09:40-11:20am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 2:
                                            <span class="text-gray-800">Physics class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">13</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 25min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">10:35-43:09am</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 3:
                                            <span class="text-gray-800">Chemistry class</span></td>
                                        <td class="fs-6 fw-bold text-gray-500">Court:
                                            <span class="text-gray-800">Main</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bg-light rounded text-gray-600 fs-8 fw-bold px-3 py-2" colspan="4">Break 15min</td>
                                    </tr>
                                    <tr>
                                        <td class="fs-6 fw-bold text-gray-800">15:30-12:23pm</td>
                                        <td class="fs-6 fw-bold text-gray-500">lesson 4:
                                            <span class="text-gray-800">Biology class</span>
                                            <!--begin::Icon-->
                                            <span class="cursor-pointer" data-bs-toggle="tooltip" data-bs-placement="top" title="Held by Dr. Emma">
																				<i class="ki-outline ki-information fs-1 text-warning"></i>
																			</span>
                                            <!--end::Icon--></td>
                                        <td class="fs-6 fw-bold text-gray-500">Cabinet:
                                            <span class="text-gray-800">23</span></td>
                                        <td class="pe-0 text-end">
                                            <button class="btn btn-sm btn-light">Skip</button>
                                        </td>
                                    </tr>
                                    </tbody>
                                    <!--end::Table body-->
                                </table>
                                <!--end::Table-->
                            </div>
                            <!--end::Table container-->
                        </div>
                        <!--end::Tap pane-->
                    </div>
                    <!--end::Tab Content-->
                    <!--begin::Action-->
                    <div class="float-end">
                        <a href="#" class="btn btn-sm btn-light me-2" data-bs-toggle="modal" data-bs-target="#kt_modal_create_project">Add Lesson</a>
                        <a href="#" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#kt_modal_create_app">Call Sick for Today</a>
                    </div>
                    <!--end::Action-->
                </div>
                <!--end: Card Body-->
            </div>
            <!--end::Table widget 8-->
        </div>
        <!--end::Col-->
    </div>
    <!--end::Row-->
`)