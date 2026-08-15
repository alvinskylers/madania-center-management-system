@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.base(
title = "All Sessions",
role = role,
_csrf =  _csrf,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">All Sessions</h1>
        <div class="d-flex gap-3 align-items-center">
                <span class="d-flex align-items-center gap-2">
                    <span class="bullet bullet-dot" style="background:#1B84FF"></span>
                    <small>Scheduled</small>
                </span>
            <span class="d-flex align-items-center gap-2">
                    <span class="bullet bullet-dot" style="background:#17C653"></span>
                    <small>Completed</small>
                </span>
            <span class="d-flex align-items-center gap-2">
                    <span class="bullet bullet-dot" style="background:#F1416C"></span>
                    <small>Cancelled</small>
                </span>
            <span class="d-flex align-items-center gap-2">
                    <span class="bullet bullet-dot" style="background:#FFA800"></span>
                    <small>Rescheduled</small>
                </span>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div id="kt_calendar"></div>
        </div>
    </div>

    <link href="/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet">
    <script src="/plugins/custom/fullcalendar/fullcalendar.bundle.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("kt_calendar");

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "timeGridWeek",
                height: "auto",
                headerToolbar: {
                    left: "prev,next today",
                    center: "title",
                    right: "dayGridMonth,timeGridWeek,timeGridDay"
                },
                slotMinTime: "07:00:00",
                slotMaxTime: "20:00:00",
                allDaySlot: false,
                events: "/admin/schedule/events",
                eventClick: function (info) {
                    alert(info.event.title);
                }
            });

            calendar.render();
        });
    </script>
`
)