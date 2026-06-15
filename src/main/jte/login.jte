@param String error = null
@param String logout = null
@param org.springframework.security.web.csrf.CsrfToken _csrf

<!DOCTYPE html>
<html lang="en">
<head>
    <base href="/" />
    <title>Madania Therapy Center - Sign In</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="shortcut icon" href="/media/logos/favicon.ico" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700" />
    <link href="/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
    <link href="/css/style.bundle.css" rel="stylesheet" type="text/css" />
    <script>
        var defaultThemeMode = "light";
        var themeMode;
        if (document.documentElement) {
            if (document.documentElement.hasAttribute("data-bs-theme-mode")) {
                themeMode = document.documentElement.getAttribute("data-bs-theme-mode");
            } else {
                if (localStorage.getItem("data-bs-theme") !== null) {
                    themeMode = localStorage.getItem("data-bs-theme");
                } else {
                    themeMode = defaultThemeMode;
                }
            }
            if (themeMode === "system") {
                themeMode = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
            }
            document.documentElement.setAttribute("data-bs-theme", themeMode);
        }
    </script>
</head>
<body id="kt_body" class="app-blank bgi-size-cover bgi-attachment-fixed bgi-position-center">
<style>
    body { background-image: url('/media/auth/bg10.jpeg'); }
    [data-bs-theme="dark"] body { background-image: url('/media/auth/bg10-dark.jpeg'); }
</style>

<div class="d-flex flex-column flex-root" id="kt_app_root">
    <div class="d-flex flex-column flex-lg-row flex-column-fluid">

        <!--begin::Aside-->
        <div class="d-flex flex-lg-row-fluid">
            <div class="d-flex flex-column flex-center pb-0 pb-lg-10 p-10 w-100">
                <img class="theme-light-show mx-auto mw-100 w-150px w-lg-300px mb-10 mb-lg-20"
                     src="/media/auth/agency.png" alt="" />
                <img class="theme-dark-show mx-auto mw-100 w-150px w-lg-300px mb-10 mb-lg-20"
                     src="/media/auth/agency-dark.png" alt="" />
                <h1 class="text-gray-800 fs-2qx fw-bold text-center mb-7">
                    Madania Therapy Center
                </h1>
                <div class="text-gray-600 fs-base text-center fw-semibold">
                    Providing specialized therapy for children with special needs.
                </div>
            </div>
        </div>
        <!--end::Aside-->

        <!--begin::Body-->
        <div class="d-flex flex-column-fluid flex-lg-row-auto justify-content-center justify-content-lg-end p-12">
            <div class="bg-body d-flex flex-column flex-center rounded-4 w-md-600px p-10">
                <div class="d-flex flex-center flex-column align-items-stretch h-lg-100 w-md-400px">
                    <div class="d-flex flex-center flex-column flex-column-fluid pb-15 pb-lg-20">

                        <form class="form w-100" action="/login" method="post">
                            <input type="hidden"
                                   name="${_csrf.getParameterName()}"
                                   value="${_csrf.getToken()}">

                            <!--begin::Heading-->
                            <div class="text-center mb-11">
                                <h1 class="text-gray-900 fw-bolder mb-3">Sign In</h1>
                                <div class="text-gray-500 fw-semibold fs-6">
                                    Madania Therapy Center Management System
                                </div>
                            </div>
                            <!--end::Heading-->

                            @if(error != null)
                                <div class="alert alert-danger d-flex align-items-center mb-8">
                                    <span>Invalid email or password. Please try again.</span>
                                </div>
                            @endif

                            @if(logout != null)
                                <div class="alert alert-success d-flex align-items-center mb-8">
                                    <span>You have been logged out successfully.</span>
                                </div>
                            @endif

                            <!--begin::Email-->
                            <div class="fv-row mb-8">
                                <input type="email"
                                       placeholder="Email"
                                       name="email"
                                       autocomplete="off"
                                       class="form-control bg-transparent" />
                            </div>
                            <!--end::Email-->

                            <!--begin::Password-->
                            <div class="fv-row mb-3">
                                <input type="password"
                                       placeholder="Password"
                                       name="password"
                                       autocomplete="off"
                                       class="form-control bg-transparent" />
                            </div>
                            <!--end::Password-->

                            <!--begin::Submit-->
                            <div class="d-grid mb-10 mt-8">
                                <button type="submit" class="btn btn-primary">
                                    <span class="indicator-label">Sign In</span>
                                </button>
                            </div>
                            <!--end::Submit-->

                        </form>

                    </div>
                </div>
            </div>
        </div>
        <!--end::Body-->

    </div>
</div>

<script>var hostUrl = "/";</script>
<script src="/plugins/global/plugins.bundle.js"></script>
<script src="/js/scripts.bundle.js"></script>
<script src="/js/custom/authentication/sign-in/general.js"></script>
</body>
</html>