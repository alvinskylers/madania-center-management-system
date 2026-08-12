@import com.madania.management.entity.Patient
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<Patient> children

@template.layout.base(
title = "Schedule",
role = role,
content = @`
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1 class="page-heading">My Children's Schedule</h1>
    </div>

    <div class="card mb-5">
        <div class="card-body p-3">
            <div class="d-flex gap-3 align-items-center flex-wrap">
                @for(Patient child : children)
                    <span class="d-flex align-items-center gap-2">
                            <span class="bullet bullet-dot bg-primary"></span>
                            <span class="fw-semibold">${child.getFullName()}</span>
                        </span>
                @endfor
            </div>
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
                events: "/parent/schedule/events"
            });

            calendar.render();
        });
    </script>
`
)