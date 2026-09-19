/*
 * Metronic-styled date / time pickers (flatpickr, already bundled in plugins.bundle.js).
 *
 * Usage in templates:
 *   <input type="text" data-picker="date"     name="..." class="form-control ..."/>   -> submits yyyy-MM-dd
 *   <input type="text" data-picker="time"     name="..." class="form-control ..."/>   -> submits HH:mm
 *   <input type="text" data-picker="datetime" name="..." class="form-control ..."/>   -> submits yyyy-MM-ddTHH:mm
 *
 * Optional: data-min-date="today", data-max-date="today".
 * The submitted values use exactly the same formats as the native inputs, so no
 * controller / DTO changes are needed. Date and datetime pickers show dd/mm/yyyy
 * to the user while the hidden real input keeps the ISO value.
 *
 * Inputs added later with JS (innerHTML, etc.) can be activated with window.initPickers(container).
 */
(function () {
    if (typeof flatpickr === "undefined") {
        return;
    }

    // Indonesian calendar labels (the UI is Indonesian).
    flatpickr.l10ns.id = {
        weekdays: {
            shorthand: ["Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"],
            longhand: ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"]
        },
        months: {
            shorthand: ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"],
            longhand: ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
        },
        firstDayOfWeek: 1,
        rangeSeparator: " - ",
        weekAbbreviation: "Mgg",
        scrollTitle: "Gulir untuk mengubah",
        toggleTitle: "Klik untuk mengganti",
        time_24hr: true,
        ordinal: function () { return ""; }
    };
    flatpickr.localize(flatpickr.l10ns.id);

    // Bootstrap modals pull focus back into the modal, which makes the calendar's
    // year / hour / minute fields (they live on <body>) impossible to type into.
    document.addEventListener("focusin", function (e) {
        if (e.target && e.target.closest && e.target.closest(".flatpickr-calendar")) {
            e.stopImmediatePropagation();
        }
    }, true);

    var KINDS = {
        date: {
            placeholder: "Pilih tanggal",
            config: { dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y" }
        },
        time: {
            placeholder: "Pilih jam",
            config: { enableTime: true, noCalendar: true, dateFormat: "H:i", time_24hr: true }
        },
        datetime: {
            placeholder: "Pilih tanggal & jam",
            config: { enableTime: true, time_24hr: true, dateFormat: "Y-m-d\\TH:i", altInput: true, altFormat: "d/m/Y H:i" }
        }
    };

    function initPickers(root) {
        (root || document).querySelectorAll("input[data-picker]").forEach(function (input) {
            if (input._flatpickr) {
                return;
            }
            var kind = KINDS[input.getAttribute("data-picker")];
            if (!kind) {
                return;
            }

            var config = Object.assign({
                locale: "id",
                allowInput: true,        // keeps HTML "required" validation working
                disableMobile: true,     // always use the Metronic calendar, not the native one
                altInputClass: input.className   // visible field keeps form-control-solid / -sm / width classes
            }, kind.config);

            if (input.hasAttribute("data-min-date")) {
                config.minDate = input.getAttribute("data-min-date");
            }
            if (input.hasAttribute("data-max-date")) {
                config.maxDate = input.getAttribute("data-max-date");
            }

            input.type = "text";
            if (!input.getAttribute("placeholder")) {
                input.setAttribute("placeholder", kind.placeholder);
            }
            input.setAttribute("autocomplete", "off");

            flatpickr(input, config);
        });
    }

    window.initPickers = initPickers;
    initPickers();
})();
