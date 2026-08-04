@import com.madania.management.enums.Gender
@param com.madania.management.entity.Patient patient


<!--begin::Card-->
<div class="card">
    <!--begin::Card body-->
    <div class="card-body d-flex flex-center flex-column pt-12 p-9">
        <!--begin::Avatar-->
        <div class="symbol symbol-65px symbol-circle mb-5">
            @if(patient.getGender() == Gender.MALE)
                <img src="/media/avatars/boy.png" alt="image" />
            @elseif(patient.getGender() == Gender.FEMALE)
                <img src="/media/avatars/girl.png" alt="image" />
            @else
                <img src="/media/avatars/blank.png" alt="image" />
            @endif

            @if (patient.isActive())
                <div class="bg-success position-absolute border border-4 border-body h-15px w-15px rounded-circle translate-middle start-100 top-100 ms-n3 mt-n3"></div>
            @endif
        </div>
        <!--end::Avatar-->

        <!--begin::Name-->
        <a href="/admin/patient/${String.valueOf(patient.getId())}" class="fs-4 text-gray-800 text-hover-primary fw-bold mb-0">${patient.getFullName()}</a>
        <!--end::Name-->

        <!--begin::Parent (or other info)-->
        <div class="fw-semibold text-gray-500 mb-6">
           ${patient.getDiagnosis()}
        </div>
        <!--end::Parent-->

        <!--begin::Stats (3 small info boxes)-->
        <div class="d-flex flex-center flex-wrap">
            <!-- Age -->
            <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                <div class="fw-semibold text-gray-500">Age</div>
                <div class="fs-6 fw-bold text-gray-700"><p>${patient.getAge().getYears()} Years, ${patient.getAge().getMonths()} Months</p></div>
            </div>
            <!-- Gender -->
            <div class="border border-gray-300 border-dashed rounded min-w-80px py-3 px-4 mx-2 mb-3">
                <div class="fw-semibold text-gray-500">Gender</div>
                <div class="fs-6 fw-bold text-gray-700"><p>${patient.getGender() != null ? patient.getGender().name() : "—"}</p></div>
            </div>
        </div>
        <!--end::Stats-->
    </div>
    <!--end::Card body-->
</div>
<!--end::Card-->