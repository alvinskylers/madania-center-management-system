@import com.madania.management.enums.Gender
@param com.madania.management.entity.Patient patient


<!--begin::Card-->
<div class="card">
    <!--begin::Card body-->

    <div class="card-body d-flex flex-center flex-column pt-12 p-9">
        <a href="/admin/patient/${String.valueOf(patient.getId())}">
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
            ${patient.getAge().getYears()} Tahun
        </div>
        <!--end::Parent-->
        </a>
    </div>
    <!--end::Card body-->
</div>
<!--end::Card-->