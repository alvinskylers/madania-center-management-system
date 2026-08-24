@param String role

<!--begin::Sidebar-->
<div id="kt_app_sidebar" class="app-sidebar flex-column" data-kt-drawer="true" data-kt-drawer-name="app-sidebar" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="250px" data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_app_sidebar_mobile_toggle">
    <div class="app-sidebar-header d-flex flex-stack d-none d-lg-flex pt-8 pb-2" id="kt_app_sidebar_header">
        <!--begin::Logo-->
        <a href="/dashboard" class="app-sidebar-logo">
            <img alt="Logo" src="/media/logos/demo38.svg" class="h-25px d-none d-sm-inline app-sidebar-logo-default theme-light-show" />
            <img alt="Logo" src="/media/logos/demo38-dark.svg" class="h-20px h-lg-25px theme-dark-show" />
        </a>
        <!--end::Logo-->
        <!--begin::Sidebar toggle-->
        <div id="kt_app_sidebar_toggle" class="app-sidebar-toggle btn btn-sm btn-icon bg-light btn-color-gray-700 btn-active-color-primary d-none d-lg-flex rotate" data-kt-toggle="true" data-kt-toggle-state="active" data-kt-toggle-target="body" data-kt-toggle-name="app-sidebar-minimize">
            <i class="ki-outline ki-text-align-right rotate-180 fs-1"></i>
        </div>
        <!--end::Sidebar toggle-->
    </div>
    <!--begin::Nav-->
    <div class="app-sidebar-navs flex-column-fluid py-6" id="kt_app_sidebar_navs">
        <div id="kt_app_sidebar_navs_wrappers" class="app-sidebar-wrapper hover-scroll-y my-2" data-kt-scroll="true" data-kt-scroll-activate="true" data-kt-scroll-height="auto" data-kt-scroll-dependencies="#kt_app_sidebar_header" data-kt-scroll-wrappers="#kt_app_sidebar_navs" data-kt-scroll-offset="5px">
            <!--begin::Sidebar menu-->
            <div id="#kt_app_sidebar_menu" class="app-sidebar-menu-primary menu menu-column menu-rounded menu-sub-indention menu-state-bullet-primary">
                <!--begin::Heading-->
                <div class="menu-item mb-2">
                    <div class="menu-heading text-uppercase fs-7 fw-bold">Menu</div>
                    <div class="app-sidebar-separator separator"></div>
                </div>
                <!--end::Heading-->

                @if(role.equals("ADMIN"))
                    <!-- Home -->
                    <div class="menu-item">
                        <a class="menu-link" href="/dashboard" title="View Dashboard" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-home fs-2"></i></span>
                            <span class="menu-title">Dashboard</span>
                        </a>
                    </div>

                    <!-- Schedule -->
                    <div class="menu-item">
                        <a class="menu-link" href="/admin/schedule" title="View all schedules" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-calendar fs-2"></i></span>
                            <span class="menu-title">Schedule</span>
                        </a>
                    </div>

                    <!-- Reschedule Requests -->
                    <div class="menu-item">
                        <a class="menu-link" href="/admin/reschedules" title="View reschedule requests" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-time fs-2"></i></span>
                            <span class="menu-title">Reschedule Requests</span>
                        </a>
                    </div>

                    <!-- Packages -->
                    <div class="menu-item">
                        <a class="menu-link" href="/admin/packages" title="View all packages" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-parcel fs-2"></i></span>
                            <span class="menu-title">Package</span>
                        </a>
                    </div>

                    <!-- Journals -->
                    <div class="menu-item">
                        <a class="menu-link" href="/admin/journals" title="View all journals" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-book fs-2"></i></span>
                            <span class="menu-title">Journals</span>
                        </a>
                    </div>

                    <!-- Patients -->
                    <div class="menu-item">
                        <a class="menu-link" href="/admin/patients" title="View all patients" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-people fs-2"></i></span>
                            <span class="menu-title">Patients</span>
                        </a>
                    </div>

                    <!-- User Management -->
                    <div class="menu-item">
                        <a class="menu-link" href="/admin/users" title="View all users" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-people fs-2"></i></span>
                            <span class="menu-title">Users</span>
                        </a>
                    </div>
                    <div class="menu-item">
                        <a class="menu-link" href="/admin/parents"  title="View all parents" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-user fs-2"></i></span>
                            <span class="menu-title">Parents</span>
                        </a>
                    </div>
                    <div class="menu-item">
                        <a class="menu-link" href="/admin/therapists"  title="View all therapists" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-user fs-2"></i></span>
                            <span class="menu-title">Therapists</span>
                        </a>
                    </div>
                @endif

                @if(role.equals("THERAPIST"))
                    <!-- Home -->
                    <div class="menu-item">
                        <a class="menu-link" href="/dashboard" title="View Dashboard" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-home fs-2"></i></span>
                            <span class="menu-title">Dashboard</span>
                        </a>
                    </div>
                    <div class="menu-item">
                        <a class="menu-link" href="/profile" title="View My Profile" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-profile-circle fs-2"></i></span>
                            <span class="menu-title">Profile</span>
                        </a>
                    </div>

                    <!-- Schedule -->
                    <div class="menu-item">
                        <a class="menu-link" href="/therapist/schedule" title="View all schedules" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-calendar fs-2"></i></span>
                            <span class="menu-title">Schedule</span>
                        </a>
                    </div>

                    <!-- Sessions -->
                    <div class="menu-item">
                        <a class="menu-link" href="/therapist/sessions" title="View all schedules" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-calendar fs-2"></i></span>
                            <span class="menu-title">Sessions</span>
                        </a>
                    </div>

                    <!-- Leave Requests -->
                    <div class="menu-item">
                        <a class="menu-link" href="/therapist/leave" title="Request leave" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-airplane fs-2"></i></span>
                            <span class="menu-title">Leave Requests</span>
                        </a>
                    </div>

                    <!-- Journals -->
                    <div class="menu-item">
                        <a class="menu-link" href="/therapist/journals" title="View all journals" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-book fs-2"></i></span>
                            <span class="menu-title">Journals</span>
                        </a>
                    </div>

                    <!-- Patients -->
                    <div class="menu-item">
                        <a class="menu-link" href="/therapist/patients" title="View all patients" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-people fs-2"></i></span>
                            <span class="menu-title">Patients</span>
                        </a>
                    </div>
                @endif

                @if(role.equals("PARENT"))
                    <!-- Home -->
                    <div class="menu-item">
                        <a class="menu-link" href="/dashboard" title="View Dashboard" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-home fs-2"></i></span>
                            <span class="menu-title">Dashboard</span>
                        </a>
                    </div>
                    <div class="menu-item">
                        <a class="menu-link" href="/profile" title="View My Profile" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-profile-circle fs-2"></i></span>
                            <span class="menu-title">Profile</span>
                        </a>
                    </div>

                    <!-- Schedule -->
                    <div class="menu-item">
                        <a class="menu-link" href="/parent/schedule" title="View all schedules" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-calendar fs-2"></i></span>
                            <span class="menu-title">Schedule</span>
                        </a>
                    </div>

                    <!-- Journals -->
                    <div class="menu-item">
                        <a class="menu-link" href="/parent/journals" title="View all journals" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-dismiss="click" data-bs-placement="right">
                            <span class="menu-bullet"><i class="ki-outline ki-book fs-2"></i></span>
                            <span class="menu-title">Journals</span>
                        </a>
                    </div>
                @endif

            </div>
            <!--end::Sidebar menu-->
        </div>
    </div>
    <!--end::Navs-->
</div>
<!--end::Sidebar-->