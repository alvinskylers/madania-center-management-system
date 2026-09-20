/*
 * Direct reschedule modal for the admin and receptionist schedule calendars.
 *
 * Staff pick a scheduled session on the calendar, then choose a new time (tap a free slot on the
 * therapist's calendar, or type it) and MUST give a reason. It posts to
 * {basePath}/reschedule (StaffRescheduleController) and applies immediately, no approval step.
 * Same-day moves are allowed. This is UX only: RescheduleService.staffReschedule re-validates
 * everything (operating hours, conflicts, not in the past, reason required).
 *
 * Markup lives in components/staff-reschedule-modal.jte. Usage on a schedule page:
 *
 *   var staffReschedule = StaffReschedule.init({ basePath: "/admin/schedule", detailsModal: detailsModal });
 *   // inside the calendar's eventClick:
 *   staffReschedule.bindButton(document.getElementById("btn_open_staff_reschedule"), info.event);
 *
 * Requires reschedule-slot-picker.js, FullCalendar and Bootstrap on the page.
 * Plain ES5 to match the other page scripts.
 */
(function (global) {
    "use strict";

    function init(opts) {
        var basePath = opts.basePath;
        var detailsModal = opts.detailsModal;

        var modalEl = document.getElementById("kt_modal_staff_reschedule");
        var modal = new bootstrap.Modal(modalEl);
        var form = document.getElementById("kt_staff_reschedule_form");
        var sessionIdInput = document.getElementById("staff_reschedule_session_id");
        var labelEl = document.getElementById("staff_reschedule_session_label");
        var timeInput = document.getElementById("staff_reschedule_requested_time");
        var timeFeedback = document.getElementById("staff_reschedule_time_feedback");
        var reasonInput = document.getElementById("staff_reschedule_reason");
        var reasonFeedback = document.getElementById("staff_reschedule_reason_feedback");
        var hintEl = document.getElementById("staff_reschedule_slot_hint");
        var submitBtn = document.getElementById("staff_reschedule_submit");

        function altInputOf(input) {
            var alt = input.nextElementSibling;
            return alt && alt.classList.contains("flatpickr-alt-input") ? alt : null;
        }

        function markTimeInvalid(invalid) {
            timeInput.classList.toggle("is-invalid", invalid);
            var alt = altInputOf(timeInput);
            if (alt) {
                alt.classList.toggle("is-invalid", invalid);
            }
            timeFeedback.classList.toggle("d-none", !invalid);
        }

        function markReasonInvalid(invalid) {
            reasonInput.classList.toggle("is-invalid", invalid);
            reasonFeedback.classList.toggle("d-none", !invalid);
        }

        timeInput.addEventListener("change", function () {
            if (timeInput.value && timeInput.value.trim() !== "") {
                markTimeInvalid(false);
            }
        });

        reasonInput.addEventListener("input", function () {
            if (reasonInput.value.trim() !== "") {
                markReasonInvalid(false);
            }
        });

        form.addEventListener("submit", function (e) {
            var timeMissing = !timeInput.value || timeInput.value.trim() === "";
            var reasonMissing = reasonInput.value.trim() === "";

            if (timeMissing || reasonMissing) {
                e.preventDefault();
                e.stopPropagation();
                markTimeInvalid(timeMissing);
                markReasonInvalid(reasonMissing);
                if (timeMissing) {
                    (altInputOf(timeInput) || timeInput).focus();
                } else {
                    reasonInput.focus();
                }
                return;
            }

            // Guard against a double click sending the reschedule twice.
            submitBtn.disabled = true;
        });

        var calendar = null;

        // Tap-a-slot helper. Reads the calendar lazily; allowSameDay lets staff move a session within the same day.
        var slotPicker = RescheduleSlotPicker.create({
            timeInput: timeInput,
            sessionIdInput: sessionIdInput,
            hintEl: hintEl,
            getCalendar: function () { return calendar; },
            allowSameDay: true
        });

        calendar = new FullCalendar.Calendar(document.getElementById("kt_staff_reschedule_calendar"), {
            initialView: "timeGridWeek",
            height: 380,
            headerToolbar: { left: "prev,next today", center: "title", right: "" },
            slotMinTime: "07:00:00",
            slotMaxTime: "20:00:00",
            allDaySlot: false,
            businessHours: slotPicker.businessHours,
            dateClick: slotPicker.onDateClick,
            eventClick: slotPicker.onEventClick,
            events: []
        });
        calendar.render();

        modalEl.addEventListener("shown.bs.modal", function () {
            calendar.updateSize();
        });

        function open(calendarEvent) {
            sessionIdInput.value = calendarEvent.id;
            labelEl.innerText = calendarEvent.title + " \u2014 saat ini " + calendarEvent.start.toLocaleString();

            // fresh form state for every session
            timeInput.value = "";
            if (timeInput._flatpickr) {
                timeInput._flatpickr.clear();
            }
            reasonInput.value = "";
            markTimeInvalid(false);
            markReasonInvalid(false);
            submitBtn.disabled = false;

            slotPicker.open(calendarEvent.start);

            calendar.setOption("events", basePath + "/therapist-events/" + calendarEvent.id);
            calendar.gotoDate(calendarEvent.start);

            detailsModal.hide();
            modal.show();
        }

        /** Show the button only for sessions staff can still move; the server decides via canStaffReschedule. */
        function bindButton(buttonEl, calendarEvent) {
            var props = calendarEvent.extendedProps;
            if (props.status === "SCHEDULED" && props.canStaffReschedule === true) {
                buttonEl.style.display = "inline-block";
                buttonEl.onclick = function () { open(calendarEvent); };
            } else {
                buttonEl.style.display = "none";
                buttonEl.onclick = null;
            }
        }

        return { bindButton: bindButton };
    }

    global.StaffReschedule = { init: init };
})(window);
