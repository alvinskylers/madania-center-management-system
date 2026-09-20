/*
 * Tap-a-slot selection for the "Ajukan Reschedule" modal (parent + therapist pages).
 *
 * Lets the user tap an empty slot on the modal's mini FullCalendar to fill the
 * "Waktu baru yang diminta" date-time picker. The picker keeps working as before,
 * and the two stay in sync: whatever is in the picker is highlighted on the calendar.
 *
 * This is a UX shortcut only. RescheduleService / RescheduleNoticePolicy remain the
 * source of truth and re-validate everything on submit. The checks below simply give
 * the user an instant reason when a tapped slot would be rejected anyway.
 *
 * Staff (admin / receptionist) pass allowSameDay: true. They can move a session within the same
 * day (emergencies), so the "different date" checks are skipped; a slot identical to the session's
 * current time is still refused. See staff-reschedule.js.
 *
 * Usage (see pages/parent/schedule.jte and pages/therapist/schedule/index.jte):
 *
 *   var slotPicker = RescheduleSlotPicker.create({
 *       timeInput:      document.getElementById("reschedule_requested_time"),
 *       sessionIdInput: document.getElementById("reschedule_session_id"),
 *       hintEl:         document.getElementById("reschedule_slot_hint"),
 *       getCalendar:    function () { return rescheduleCalendar; }   // lazy: calendar is built afterwards
 *   });
 *   new FullCalendar.Calendar(el, {
 *       ...,
 *       businessHours: slotPicker.businessHours,
 *       dateClick:     slotPicker.onDateClick,
 *       eventClick:    slotPicker.onEventClick
 *   });
 *   // when the modal opens for a session:  slotPicker.open(sessionStartDate);
 *
 * Written in plain ES5 to match the rest of the page scripts. Do not put this code inside
 * a .jte template: it would have to avoid backticks, "@" and "${" there.
 */
(function (global) {
    "use strict";

    // Keep in sync with TherapySessionService (CLINIC_OPENING / CLINIC_CLOSING) and with
    // RescheduleService, which books requestedStartTime.plusHours(1).
    var CLINIC_OPEN_MINUTES = 8 * 60;
    var CLINIC_CLOSE_MINUTES = 17 * 60;
    var SESSION_MINUTES = 60;

    var SELECTED_EVENT_ID = "reschedule-selected-slot";
    var SELECTED_COLOR = "#7239EA";

    var DEFAULT_HINT = "Ketuk slot kosong pada kalender untuk memilih waktu baru (durasi sesi 1 jam), " +
        "atau isi tanggal & jam secara manual di bawah.";

    function pad(n) {
        return n < 10 ? "0" + n : String(n);
    }

    function sameDay(a, b) {
        return a.getFullYear() === b.getFullYear()
            && a.getMonth() === b.getMonth()
            && a.getDate() === b.getDate();
    }

    function minutesOfDay(d) {
        return d.getHours() * 60 + d.getMinutes();
    }

    function addMinutes(d, minutes) {
        return new Date(d.getTime() + minutes * 60000);
    }

    function formatSlot(d) {
        return pad(d.getDate()) + "/" + pad(d.getMonth() + 1) + "/" + d.getFullYear()
            + " " + pad(d.getHours()) + ":" + pad(d.getMinutes());
    }

    function create(opts) {
        var timeInput = opts.timeInput;
        var sessionIdInput = opts.sessionIdInput;
        var hintEl = opts.hintEl;
        var getCalendar = opts.getCalendar;
        var allowSameDay = opts.allowSameDay === true;

        var originalStart = null; // start of the session being rescheduled
        var hintKind = null;      // null | "error" | "success"

        function setHint(message, kind) {
            hintKind = kind || null;
            hintEl.innerText = message;
            hintEl.classList.remove("text-muted", "text-danger", "text-success");
            hintEl.classList.add(kind === "error" ? "text-danger" : kind === "success" ? "text-success" : "text-muted");
        }

        // Only SCHEDULED sessions block a slot (this matches the server's conflict check).
        // The therapist calendar also lists completed / cancelled / rescheduled sessions, which
        // do not block. The parent's therapist-events feed has no "status" key and only ever
        // contains SCHEDULED sessions, so a missing status counts as blocking.
        function isBlocking(calendarEvent) {
            var status = calendarEvent.extendedProps.status;
            return status === undefined || status === "SCHEDULED";
        }

        /** @return an error message (Indonesian) if the slot would be rejected, otherwise null. */
        function validate(start) {
            var end = addMinutes(start, SESSION_MINUTES);

            if (start.getTime() < Date.now()) {
                return "Waktu tersebut sudah lewat. Pilih waktu yang akan datang.";
            }

            if (originalStart && !allowSameDay && sameDay(start, originalStart)) {
                return "Tanggal ini sama dengan jadwal sesi saat ini. Pilih tanggal lain.";
            }

            if (originalStart && allowSameDay && start.getTime() === originalStart.getTime()) {
                return "Waktu ini sama dengan jadwal sesi saat ini. Pilih waktu lain.";
            }

            var startMinutes = minutesOfDay(start);
            if (startMinutes < CLINIC_OPEN_MINUTES || startMinutes + SESSION_MINUTES > CLINIC_CLOSE_MINUTES) {
                return "Di luar jam operasional klinik (08:00 - 17:00). Sesi berdurasi 1 jam, "
                    + "jadi mulai paling lambat pukul 16:00.";
            }

            var calendar = getCalendar();
            var currentSessionId = sessionIdInput.value;
            var events = calendar ? calendar.getEvents() : [];
            for (var i = 0; i < events.length; i++) {
                var ev = events[i];
                if (ev.id === SELECTED_EVENT_ID || ev.id === currentSessionId || !isBlocking(ev) || !ev.start || !ev.end) {
                    continue;
                }
                if (start < ev.end && end > ev.start) {
                    return "Slot ini bertabrakan dengan sesi lain. Pilih slot yang kosong.";
                }
            }

            return null;
        }

        /** Draw (or clear) the highlighted block for whatever the picker currently holds. */
        function sync() {
            var calendar = getCalendar();
            if (!calendar) {
                return;
            }

            var existing = calendar.getEventById(SELECTED_EVENT_ID);
            if (existing) {
                existing.remove();
            }

            var fp = timeInput._flatpickr;
            var chosen = fp && fp.selectedDates && fp.selectedDates.length ? fp.selectedDates[0] : null;
            if (!chosen) {
                return;
            }

            calendar.addEvent({
                id: SELECTED_EVENT_ID,
                title: "Waktu baru",
                start: chosen,
                end: addMinutes(chosen, SESSION_MINUTES),
                backgroundColor: SELECTED_COLOR,
                borderColor: SELECTED_COLOR,
                editable: false
            });
        }

        function selectSlot(start) {
            var error = validate(start);
            if (error) {
                setHint(error, "error");
                return;
            }

            var fp = timeInput._flatpickr;
            if (!fp) {
                return;
            }

            // triggerChange = true -> fires "change": the page clears its "time required" error
            // and our own listener below redraws the highlight.
            fp.setDate(start, true);
            setHint("Waktu baru dipilih: " + formatSlot(start) + ". Ketuk slot lain untuk mengganti.", "success");
        }

        // Empty slot tapped.
        function onDateClick(info) {
            selectSlot(info.date);
        }

        // An event block was tapped. Blocking sessions -> explain. Non-blocking ones (cancelled /
        // completed / rescheduled, therapist view only) sit on top of a genuinely free slot and
        // would otherwise swallow the tap, so treat the tap as picking that slot.
        function onEventClick(info) {
            var ev = info.event;
            if (ev.id === SELECTED_EVENT_ID) {
                return;
            }
            if (isBlocking(ev) && ev.id !== sessionIdInput.value) {
                setHint("Slot ini sudah terisi. Pilih slot yang kosong.", "error");
                return;
            }
            selectSlot(ev.start);
        }

        /** Call each time the reschedule modal is opened for a session. */
        function open(sessionStart) {
            originalStart = sessionStart;

            var fp = timeInput._flatpickr;
            if (fp) {
                // Same instant feedback for the manual picker: no past days, not the current session date.
                fp.set("minDate", "today");
                fp.set("disable", allowSameDay ? [] : [function (date) {
                    return sameDay(date, sessionStart);
                }]);
            }

            setHint(DEFAULT_HINT);
            sync();
        }

        // Typing / picking in the date-time field moves the highlight too, and clears a stale error.
        timeInput.addEventListener("change", function () {
            sync();
            if (hintKind === "error") {
                setHint(DEFAULT_HINT);
            }
        });

        setHint(DEFAULT_HINT);

        return {
            businessHours: {
                daysOfWeek: [0, 1, 2, 3, 4, 5, 6],
                startTime: pad(Math.floor(CLINIC_OPEN_MINUTES / 60)) + ":00",
                endTime: pad(Math.floor(CLINIC_CLOSE_MINUTES / 60)) + ":00"
            },
            onDateClick: onDateClick,
            onEventClick: onEventClick,
            open: open,
            sync: sync
        };
    }

    global.RescheduleSlotPicker = { create: create };
})(window);
