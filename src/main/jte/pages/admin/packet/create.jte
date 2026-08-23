@import com.madania.management.dto.PackageCreateRequest
@import com.madania.management.entity.Notification
@import com.madania.management.entity.Patient
@import com.madania.management.entity.Therapist
@import org.springframework.validation.BindingResult
@import java.time.DayOfWeek
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param PackageCreateRequest request
@param List<Patient> patients
@param List<Therapist> therapists
@param List<DayOfWeek> days
@param String daysError = null
@param String scheduleError = null
@param BindingResult bindingResult = null
@param long unreadNotificationCount = 0
@param List<Notification> recentNotifications = null

@template.layout.base(
title = "Create Therapy Package",
role = role,
_csrf = _csrf,
unreadNotificationCount = unreadNotificationCount,
recentNotifications = recentNotifications,
content = @`
    <h1>Create Therapy Package</h1>
    <p>This will assign a patient to a therapist for 12 sessions, 3 times per week.</p>

    @if(bindingResult != null && bindingResult.hasErrors())
        <div class="alert alert-danger">
            @for(var error : bindingResult.getAllErrors())
                <p>${error.getDefaultMessage()}</p>
            @endfor
        </div>
    @endif

    @if(daysError != null)
        <div class="alert alert-danger"><p>${daysError}</p></div>
    @endif
    @if(scheduleError != null)
        <div class="alert alert-danger"><p>${scheduleError}</p></div>
    @endif

    <form action="/admin/package/create" method="post">
        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

        <div class="mb-5">
            <label>Patient</label>
            <select name="patientId" class="form-select" required>
                <option value="">Select a patient</option>
                @for(Patient patient : patients)
                    <option value="${String.valueOf(patient.getId())}">${patient.getFullName()}</option>
                @endfor
            </select>
        </div>

        <div class="mb-5">
            <label>Therapist</label>
            <select name="therapistId" class="form-select" required>
                <option value="">Select a therapist</option>
                @for(Therapist therapist : therapists)
                    <option value="${String.valueOf(therapist.getId())}">${therapist.getFullName()} - ${therapist.getFullName()}</option>
                @endfor
            </select>
        </div>

        <div class="mb-5">
            <label>Start Date</label>
            <input type="date" name="startDate" class="form-control" required>
        </div>

        <div class="mb-5">
            <label>Preferred Session Time</label>
            <input type="time" name="preferredTime" class="form-control" required>
        </div>

        <div class="mb-5" name="days">
            <label>Select exactly 3 days per week</label><br>
            @for(DayOfWeek day : days)
                <label><input type="checkbox" name="days" value="${day}"/> ${day.name()}</label><br>
            @endfor
        </div>

        <div class="mb-5">
            <label>Notes</label>
            <textarea name="notes" class="form-control"></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Create Package</button>
    </form>
`
)