@import com.madania.management.dto.PatientRequest
@import com.madania.management.entity.Parent
@import com.madania.management.enums.Gender
@import org.springframework.validation.BindingResult
@import java.util.List

@param String role
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param PatientRequest request
@param List<Parent> parents
@param BindingResult bindingResult = null

@template.layout.base(
title = "Add Patient",
role = role,
content = @`

    @if(bindingResult != null && bindingResult.hasErrors())
        @for(var error : bindingResult.getAllErrors())
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <p>${error.getDefaultMessage()}</p>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        @endfor
    @endif

    <div class="container-fluid">
        <div class="row g-7">
            <div class="col-xl-12">
                <div class="card card-flush h-lg-100" id="kt_contacts_main">
                    <div class="card-header pt-7">
                        <div class="card-title">
                            <i class="ki-outline ki-badge fs-1 me-2"></i>
                            <h2>Create Patient</h2>
                        </div>
                    </div>
                    <div class="card-body pt-5">
                        <form id="kt_ecommerce_settings_general_form" class="form"
                              action="/admin/patient/create" method="post"
                              enctype="multipart/form-data">
                            <input type="hidden" name="_csrf" value="${_csrf.getToken()}"/>
                            <!-- Name -->
                            <div class="row row-cols-1 row-cols-sm-2">
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span class="required">Name</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Enter the patient's name.">
                                                <i class="ki-outline ki-information fs-7"></i>
                                            </span>
                                        </label>
                                        <input type="text" class="form-control form-control-solid" name="fullName" />
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span>Parent</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Enter patient's parent.">
                                                <i class="ki-outline ki-information fs-7"></i>
                                            </span>
                                        </label>
                                        <select class="form-control form-control-solid" name="parentId">
                                            <option value="">Select patient parent</option>
                                            @for(Parent parent : parents)
                                                <option value="${String.valueOf(parent.getId())}">${parent.getFullName()}</option>
                                            @endfor
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Birth & Gender -->
                            <div class="row row-cols-1 row-cols-sm-2">
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span class="required">Date of Birth</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Enter the patient's birth date.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                        </label>
                                        <input type="date" class="form-control form-control-solid" name="dateOfBirth" />
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="fv-row mb-7">
                                        <label class="fs-6 fw-semibold form-label mt-3">
                                            <span>Gender</span>
                                            <span class="ms-1" data-bs-toggle="tooltip" title="Enter patient's gender.">
                                            <i class="ki-outline ki-information fs-7"></i>
                                        </span>
                                        </label>
                                        <select class="form-control form-control-solid" name="gender">
                                            <option value="">Select patient gender</option>
                                            <option value="${Gender.MALE}">Male</option>
                                            <option value="${Gender.FEMALE}">Female</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Diagnosis  -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">
                                    <span>Diagnosis</span>
                                    <span class="ms-1" data-bs-toggle="tooltip" title="Enter patient's diagnosis.">
                                    <i class="ki-outline ki-information fs-7"></i>
                                </span>
                                </label>
                                <input type="text" class="form-control form-control-solid" name="diagnosis" />
                            </div>

                            <!-- Notes -->
                            <div class="fv-row mb-7">
                                <label class="fs-6 fw-semibold form-label mt-3">
                                    <span>Notes</span>
                                    <span class="ms-1" data-bs-toggle="tooltip" title="Enter any additional notes (optional).">
                                    <i class="ki-outline ki-information fs-7"></i>
                                </span>
                                </label>
                                <textarea class="form-control form-control-solid" name="notes"></textarea>
                            </div>

                            <div class="separator mb-6"></div>
                            <div class="d-flex justify-content-end">
                                <a href="/admin/patients" class="btn btn-light me-3">Cancel</a>
                                <button type="submit" data-kt-contacts-type="submit" class="btn btn-primary">
                                    <span class="indicator-label">Save</span>
                                    <span class="indicator-progress">Please wait...
                                    <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
                                </span>
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

`
)