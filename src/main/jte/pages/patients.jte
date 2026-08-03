@import com.madania.management.entity.Patient

@param org.springframework.security.web.csrf.CsrfToken _csrf
@param String role
@param java.util.List<Patient> patients

@template.layout.base(title = "Patients", role = role, content = @`
    <!--begin::Toolbar-->
    <div class="d-flex flex-wrap flex-stack pb-7">
        <!-- ... same toolbar as before ... -->
    </div>
    <!--end::Toolbar-->

    <!--begin::Card Grid-->
    <div class="row g-6 g-xl-9">
        @if(patients.isEmpty())
            <p>no patients available</p>
        @else
            @for (Patient patient : patients)
                <div class="col-md-6 col-xxl-3">
                    @template.components.patient-card(patient = patient)
                </div>
            @endfor
        @endif


            </div>
    <!--end::Card Grid-->

    <!-- (Optional) Pagination placeholder – can be added later -->
`)