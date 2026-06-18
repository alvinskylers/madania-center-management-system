@param String role

@template.layout.base(title = "Create Journal", role =role , content = @`
    <!--begin::Card-->
    <div class="card">
        <div class="card-header d-flex align-items-center justify-content-between py-3">
            <h2 class="card-title m-0">Compose Message</h2>
            <!--begin::Toggle-->
            <a href="#" class="btn btn-sm btn-icon btn-color-primary btn-light btn-active-light-primary d-lg-none" data-bs-toggle="tooltip" data-bs-dismiss="click" data-bs-placement="top" title="Toggle inbox menu" id="kt_inbox_aside_toggle">
                <i class="ki-outline ki-burger-menu-2 fs-3 m-0"></i>
            </a>
            <!--end::Toggle-->
        </div>
        <div class="card-body p-0">
            <!--begin::Form-->
            <form id="kt_inbox_compose_form">
                <!--begin::Body-->
                <div class="d-block">
                    <!--begin::To-->
                    <div class="d-flex align-items-center border-bottom px-8 min-h-50px">
                        <!--begin::Label-->
                        <div class="text-gray-900 fw-bold w-75px">To:</div>
                        <!--end::Label-->
                        <!--begin::Input-->
                        <input type="text" class="form-control form-control-transparent border-0" name="compose_to" value="" data-kt-inbox-form="tagify" />
                        <!--end::Input-->
                        <!--begin::CC & BCC buttons-->
                        <div class="ms-auto w-75px text-end">
                            <span class="text-muted fs-bold cursor-pointer text-hover-primary me-2" data-kt-inbox-form="cc_button">Cc</span>
                            <span class="text-muted fs-bold cursor-pointer text-hover-primary" data-kt-inbox-form="bcc_button">Bcc</span>
                        </div>
                        <!--end::CC & BCC buttons-->
                    </div>
                    <!--end::To-->
                    <!--begin::CC-->
                    <div class="d-none align-items-center border-bottom ps-8 pe-5 min-h-50px" data-kt-inbox-form="cc">
                        <!--begin::Label-->
                        <div class="text-gray-900 fw-bold w-75px">Cc:</div>
                        <!--end::Label-->
                        <!--begin::Input-->
                        <input type="text" class="form-control form-control-transparent border-0" name="compose_cc" value="" data-kt-inbox-form="tagify" />
                        <!--end::Input-->
                        <!--begin::Close-->
                        <span class="btn btn-clean btn-xs btn-icon" data-kt-inbox-form="cc_close">
																	<i class="ki-outline ki-cross fs-5"></i>
																</span>
                        <!--end::Close-->
                    </div>
                    <!--end::CC-->
                    <!--begin::BCC-->
                    <div class="d-none align-items-center border-bottom inbox-to-bcc ps-8 pe-5 min-h-50px" data-kt-inbox-form="bcc">
                        <!--begin::Label-->
                        <div class="text-gray-900 fw-bold w-75px">Bcc:</div>
                        <!--end::Label-->
                        <!--begin::Input-->
                        <input type="text" class="form-control form-control-transparent border-0" name="compose_bcc" value="" data-kt-inbox-form="tagify" />
                        <!--end::Input-->
                        <!--begin::Close-->
                        <span class="btn btn-clean btn-xs btn-icon" data-kt-inbox-form="bcc_close">
																	<i class="ki-outline ki-cross fs-5"></i>
																</span>
                        <!--end::Close-->
                    </div>
                    <!--end::BCC-->
                    <!--begin::Subject-->
                    <div class="border-bottom">
                        <input class="form-control form-control-transparent border-0 px-8 min-h-45px" name="compose_subject" placeholder="Subject" />
                    </div>
                    <!--end::Subject-->
                    <!--begin::Message-->
                    <div id="kt_inbox_form_editor" class="bg-transparent border-0 h-350px px-3"></div>
                    <!--end::Message-->
                    <!--begin::Attachments-->
                    <div class="dropzone dropzone-queue px-8 py-4" id="kt_inbox_reply_attachments" data-kt-inbox-form="dropzone">
                        <div class="dropzone-items">
                            <div class="dropzone-item" style="display:none">
                                <!--begin::Dropzone filename-->
                                <div class="dropzone-file">
                                    <div class="dropzone-filename" title="some_image_file_name.jpg">
                                        <span data-dz-name="">some_image_file_name.jpg</span>
                                        <strong>(
                                            <span data-dz-size="">340kb</span>)</strong>
                                    </div>
                                    <div class="dropzone-error" data-dz-errormessage=""></div>
                                </div>
                                <!--end::Dropzone filename-->
                                <!--begin::Dropzone progress-->
                                <div class="dropzone-progress">
                                    <div class="progress bg-gray-300">
                                        <div class="progress-bar bg-primary" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0" data-dz-uploadprogress=""></div>
                                    </div>
                                </div>
                                <!--end::Dropzone progress-->
                                <!--begin::Dropzone toolbar-->
                                <div class="dropzone-toolbar">
																			<span class="dropzone-delete" data-dz-remove="">
																				<i class="ki-outline ki-cross fs-2"></i>
																			</span>
                                </div>
                                <!--end::Dropzone toolbar-->
                            </div>
                        </div>
                    </div>
                    <!--end::Attachments-->
                </div>
                <!--end::Body-->
                <!--begin::Footer-->
                <div class="d-flex flex-stack flex-wrap gap-2 py-5 ps-8 pe-5 border-top">
                    <!--begin::Actions-->
                    <div class="d-flex align-items-center me-3">
                        <!--begin::Send-->
                        <div class="btn-group me-4">
                            <!--begin::Submit-->
                            <span class="btn btn-primary fs-bold px-6" data-kt-inbox-form="send">
																		<span class="indicator-label">Send</span>
																		<span class="indicator-progress">Please wait...
																		<span class="spinner-border spinner-border-sm align-middle ms-2"></span></span>
																	</span>
                            <!--end::Submit-->
                            <!--begin::Send options-->
                            <span class="btn btn-primary btn-icon fs-bold w-30px pe-0" role="button">
																		<span class="lh-0" data-kt-menu-trigger="click" data-kt-menu-placement="top-start">
																			<i class="ki-outline ki-down fs-4 m-0"></i>
																		</span>
                                <!--begin::Menu-->
																		<div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4" data-kt-menu="true">
																			<!--begin::Menu item-->
																			<div class="menu-item px-3">
																				<a href="#" class="menu-link px-3">Schedule send</a>
																			</div>
                                                                            <!--end::Menu item-->
                                                                            <!--begin::Menu item-->
																			<div class="menu-item px-3">
																				<a href="#" class="menu-link px-3">Save & archive</a>
																			</div>
                                                                            <!--end::Menu item-->
                                                                            <!--begin::Menu item-->
																			<div class="menu-item px-3">
																				<a href="#" class="menu-link px-3">Cancel</a>
																			</div>
                                                                            <!--end::Menu item-->
																		</div>
                                <!--end::Menu-->
																	</span>
                            <!--end::Send options-->
                        </div>
                        <!--end::Send-->
                        <!--begin::Upload attachement-->
                        <span class="btn btn-icon btn-sm btn-clean btn-active-light-primary me-2" id="kt_inbox_reply_attachments_select" data-kt-inbox-form="dropzone_upload">
																	<i class="ki-outline ki-paper-clip fs-2 m-0"></i>
																</span>
                        <!--end::Upload attachement-->
                        <!--begin::Pin-->
                        <span class="btn btn-icon btn-sm btn-clean btn-active-light-primary">
																	<i class="ki-outline ki-geolocation fs-2 m-0"></i>
																</span>
                        <!--end::Pin-->
                    </div>
                    <!--end::Actions-->
                    <!--begin::Toolbar-->
                    <div class="d-flex align-items-center">
                        <!--begin::More actions-->
                        <span class="btn btn-icon btn-sm btn-clean btn-active-light-primary me-2" data-toggle="tooltip" title="More actions">
																	<i class="ki-outline ki-setting-2 fs-2"></i>
																</span>
                        <!--end::More actions-->
                        <!--begin::Dismiss reply-->
                        <span class="btn btn-icon btn-sm btn-clean btn-active-light-primary" data-inbox="dismiss" data-toggle="tooltip" title="Dismiss reply">
																	<i class="ki-outline ki-trash fs-2"></i>
																</span>
                        <!--end::Dismiss reply-->
                    </div>
                    <!--end::Toolbar-->
                </div>
                <!--end::Footer-->
            </form>
            <!--end::Form-->
        </div>
    </div>
    <!--end::Card-->
`)
