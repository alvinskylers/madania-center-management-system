
@import org.springframework.security.web.csrf.CsrfToken
@import com.madania.management.entity.Notification
@import java.util.List

@param CsrfToken _csrf
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

<!--begin::Header-->
<div id="kt_app_header" class="app-header">
    <!--begin::Header container-->
    <div class="app-container container-fluid d-flex align-items-stretch flex-stack" id="kt_app_header_container">
        <!--begin::Sidebar toggle-->
        <div class="d-flex align-items-center d-block d-lg-none ms-n3" title="Show sidebar menu">
            <div class="btn btn-icon btn-active-color-primary w-35px h-35px me-2" id="kt_app_sidebar_mobile_toggle">
                <i class="ki-outline ki-abstract-14 fs-2"></i>
            </div>
            <!--begin::Logo image-->
            <a href="index.html">
                <img alt="Logo" src="/media/logos/demo38-small.svg" class="h-30px" />
            </a>
            <!--end::Logo image-->
        </div>
        <!--end::Sidebar toggle-->
        <!--begin::Navbar-->
        <div class="app-navbar flex-lg-grow-1" id="kt_app_header_navbar">
            <div class="app-navbar-item d-flex align-items-stretch flex-lg-grow-1">
            </div>
            <!--begin::Notifications-->
            <div class="app-navbar-item ms-1 ms-md-3">
                <div class="btn btn-icon btn-custom w-35px h-35px w-md-40px h-md-40px position-relative" data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-attach="parent" data-kt-menu-placement="bottom-end">
                    <i class="ki-outline ki-notification-status fs-2"></i>
                    @if(unreadNotificationCount > 0)
                        <span class="badge badge-circle badge-danger position-absolute top-0 start-100 translate-middle" style="font-size: 0.65rem; padding: 0.35em 0.5em;">
                            ${unreadNotificationCount > 9 ? "9+" : String.valueOf(unreadNotificationCount)}
                        </span>
                    @endif
                </div>
                <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg fw-semibold py-4 fs-6 w-300px" data-kt-menu="true">
                    <div class="menu-item px-3">
                        <div class="menu-content d-flex justify-content-between align-items-center px-3">
                            <span class="fw-bold fs-5">Notifications</span>
                            @if(unreadNotificationCount > 0)
                                <form action="/notifications/mark-all-read" method="post">
                                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                                    <button type="submit" class="btn btn-sm btn-link p-0 fs-8">Mark all read</button>
                                </form>
                            @endif
                        </div>
                    </div>
                    <div class="separator my-2"></div>
                    @if(recentNotifications != null && !recentNotifications.isEmpty())
                        @for(Notification n : recentNotifications)
                            <div class="menu-item px-3">
                                <div class="menu-content px-3 py-2 ${n.isRead() ? "" : "bg-light-primary rounded"}">
                                    <div class="fs-7">${n.getMessage()}</div>
                                    <div class="text-muted fs-8">${n.getTimeAgo()}</div>
                                </div>
                            </div>
                        @endfor
                    @else
                        <div class="menu-item px-3">
                            <div class="menu-content px-3 py-2 text-muted fs-7">No notifications yet</div>
                        </div>
                    @endif
                </div>
            </div>
            <!--end::Notifications-->
            <!--begin::User menu-->
            <div class="app-navbar-item ms-1 ms-md-3" id="kt_header_user_menu_toggle">
                <!--begin::Menu wrapper-->
                <div class="cursor-pointer symbol symbol-circle symbol-35px symbol-md-45px" data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-attach="parent" data-kt-menu-placement="bottom-end">
                    <img src="/media/avatars/blank.png" alt="user" />
                </div>
                <!--begin::User account menu-->
                <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg menu-state-color fw-semibold py-4 fs-6 w-275px" data-kt-menu="true">
                    <!--begin::Menu item-->
                    <div class="menu-item px-3">
                        <div class="menu-content d-flex align-items-center px-3">
                            <!--begin::Avatar-->
                            <div class="symbol symbol-50px me-5">
                                <img alt="Logo" src="/media/avatars/blank.png" />
                            </div>
                            <!--end::Avatar-->
                            <!--begin::Username-->
                            <div class="d-flex flex-column">
                                <div class="fw-bold d-flex align-items-center fs-5">Max Smith </div>
                                <a href="#" class="fw-semibold text-muted text-hover-primary fs-7">max@kt.com</a>
                            </div>
                            <!--end::Username-->
                        </div>
                    </div>
                    <!--end::Menu item-->
                    <!--begin::Menu separator-->
                    <div class="separator my-2"></div>
                    <!--end::Menu separator-->
                    <!--begin::Menu item-->
                    <div class="menu-item px-5">
                        <a href="" class="menu-link px-5">My Profile</a>
                    </div>
                    <!--end::Menu item-->
                    <!--begin::Menu item-->
                    <div class="menu-item px-5" data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="left-start" data-kt-menu-offset="-15px, 0">
                        <a href="#" class="menu-link px-5">
                            <span class="menu-title position-relative">Language
                                <span class="fs-8 rounded bg-light px-3 py-2 position-absolute translate-middle-y top-50 end-0">English
                                    <img class="w-15px h-15px rounded-1 ms-2" src="/media/flags/united-states.svg" alt="" />
                                </span>
                            </span>
                        </a>
                        <!--begin::Menu sub-->
                        <div class="menu-sub menu-sub-dropdown w-175px py-4">
                            <!--begin::Menu item-->
                            <div class="menu-item px-3">
                                <a href="" class="menu-link d-flex px-5 active">
                                    <span class="symbol symbol-20px me-4">
                                        <img class="rounded-1" src="/media/flags/united-states.svg" alt="" />
                                    </span>
                                    English
                                </a>
                            </div>
                            <!--end::Menu item-->
                            <!--begin::Menu item-->
                            <div class="menu-item px-3">
                                <a href="" class="menu-link d-flex px-5">
                                    <span class="symbol symbol-20px me-4">
                                        <img class="rounded-1" src="/media/flags/indonesia.svg" alt="" />
                                    </span>
                                    Indonesian
                                </a>
                            </div>
                            <!--end::Menu item-->
                        </div>
                        <!--end::Menu sub-->
                    </div>
                    <!--end::Menu item-->
                    <!--begin::Menu item-->
                    <div class="menu-item px-5" data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="left-start" data-kt-menu-offset="-15px, 0">
                        <a href="#" class="menu-link px-5">
                            <span class="menu-title position-relative">Mode
                                <span class="ms-5 position-absolute translate-middle-y top-50 end-0">
                                    <i class="ki-outline ki-night-day theme-light-show fs-2"></i>
                                    <i class="ki-outline ki-moon theme-dark-show fs-2"></i>
                                </span>
                            </span>
                        </a>
                        <!--begin::Menu-->
                        <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-title-gray-700 menu-icon-gray-500 menu-active-bg menu-state-color fw-semibold py-4 fs-base w-150px" data-kt-menu="true" data-kt-element="theme-mode-menu">
                            <!--begin::Menu item-->
                            <div class="menu-item px-3 my-0">
                                <a href="#" class="menu-link px-3 py-2" data-kt-element="mode" data-kt-value="light">
                                    <span class="menu-icon" data-kt-element="icon">
                                        <i class="ki-outline ki-night-day fs-2"></i>
                                    </span>
                                    <span class="menu-title">Light</span>
                                </a>
                            </div>
                            <!--end::Menu item-->
                            <!--begin::Menu item-->
                            <div class="menu-item px-3 my-0">
                                <a href="#" class="menu-link px-3 py-2" data-kt-element="mode" data-kt-value="dark">
                                    <span class="menu-icon" data-kt-element="icon">
                                        <i class="ki-outline ki-moon fs-2"></i>
                                    </span>
                                    <span class="menu-title">Dark</span>
                                </a>
                            </div>
                            <!--end::Menu item-->
                            <!--begin::Menu item-->
                            <div class="menu-item px-3 my-0">
                                <a href="#" class="menu-link px-3 py-2" data-kt-element="mode" data-kt-value="system">
                                    <span class="menu-icon" data-kt-element="icon">
                                        <i class="ki-outline ki-screen fs-2"></i>
                                    </span>
                                    <span class="menu-title">System</span>
                                </a>
                            </div>
                            <!--end::Menu item-->
                        </div>
                        <!--end::Menu-->
                    </div>
                    <!--end::Menu item-->
                    <!--begin::Menu item-->
                    <div class="menu-item px-5">
                        <form action="/logout" method="post">
                            <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">
                            <button type="submit" class="btn menu-link px-5 border-0 w-100 text-start">
                                 <span class="menu-title position-relative">Sign out
                                    <span class="ms-5 position-absolute translate-middle-y top-50 end-0">
                                        <i class="ki-outline ki-exit-left theme-light-show fs-2"></i>
                                    </span>
                                </span>
                            </button>
                        </form>
                    </div>
                    <!--end::Menu item-->
                </div>
                <!--end::User account menu-->
                <!--end::Menu wrapper-->
            </div>
            <!--end::User menu-->
        </div>
        <!--end::Navbar-->
        <!--begin::Separator-->
        <div class="app-navbar-separator separator d-none d-lg-flex"></div>
        <!--end::Separator-->
    </div>
    <!--end::Header container-->
</div>
<!--end::Header-->