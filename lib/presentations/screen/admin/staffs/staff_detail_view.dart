import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/admin/staffs/staff_detail/staff_detail_bloc.dart';
import 'package:igls_new/data/models/staffs/staff_update_request.dart';
import 'package:igls_new/data/models/staffs/vendor_response.dart';
import 'package:igls_new/presentations/widgets/admin_component/text_form_field_admin.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_equipment.dart';
import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_std_code.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../../data/shared/utils/utils.dart';
import '../../../widgets/app_bar_custom.dart';

class StaffDetailView extends StatefulWidget {
  const StaffDetailView({
    super.key,
    required this.userId,
  });
  final String userId;
  @override
  State<StaffDetailView> createState() => _StaffDetailViewState();
}

class _StaffDetailViewState extends State<StaffDetailView> {
  final TextEditingController _staffIDController = TextEditingController();
  final TextEditingController _staffNameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final ValueNotifier<StdCode> _roleTypeNotifier =
      ValueNotifier<StdCode>(StdCode());
  StdCode? roleTypeSelected;

  final ValueNotifier<DcLocal> _dcNotifier = ValueNotifier<DcLocal>(DcLocal());
  DcLocal? dcSelected;

  final ValueNotifier<StdCode> _statusWorkingNotifier =
      ValueNotifier<StdCode>(StdCode());
  StdCode? statusWorkingSelected;

  final TextEditingController _resignedDateController = TextEditingController();
  final TextEditingController _driverLicenseNoController =
      TextEditingController();
  final TextEditingController _dateOfJoinedController = TextEditingController();
  final TextEditingController _icNoController = TextEditingController();
  final ValueNotifier<VendorResponse> _vendorCodeNotifier =
      ValueNotifier<VendorResponse>(VendorResponse());
  VendorResponse? vendorCodeSelected;

  final ValueNotifier<EquipmentResponse> _defaultEquipmentNotifier =
      ValueNotifier<EquipmentResponse>(EquipmentResponse());
  EquipmentResponse? defaultEquipmentSelected;
  final TextEditingController _remarkController = TextEditingController();

  StaffGetDetail1? detail;
  List<DcLocal>? listDC;

  late String userId;
  bool isUpdate = false;

  final _formkey = GlobalKey<FormState>();

  late StaffDetailBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<StaffDetailBloc>(context);
    _bloc.add(
        StaffDetailViewLoaded(userId: widget.userId, generalBloc: generalBloc));
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(
        context,
        routes.staffsRoute,
      );
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: Form(
        key: _formkey,
        child: Scaffold(
          appBar: AppBarCustom(
            title: Text('3521'.tr()),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, isUpdate),
            ),
          ),
          body: BlocConsumer<StaffDetailBloc, StaffDetailState>(
            listener: (context, state) {
              if (state is StaffDetailUpdateSuccessfully) {
                isUpdate = true;
                CustomDialog().success(context).whenComplete(
                      () => _bloc.add(StaffDetailViewLoaded(
                          userId: widget.userId, generalBloc: generalBloc)),
                    );
              }
              if (state is StaffDetailFailure) {
                if (state.errorCode == constants.errorNoConnect) {
                  CustomDialog().error(
                    btnMessage: '5038'.tr(),
                    context,
                    err: state.message,
                    btnOkOnPress: () => _bloc.add(StaffDetailViewLoaded(
                        userId: widget.userId, generalBloc: generalBloc)),
                  );
                  return;
                }
                CustomDialog().error(context, err: state.message);
              }
            },
            builder: (context, state) {
              if (state is StaffDetailSuccess) {
                detail = state.staffDetail.getDetail1?.first;
                listDC = state.dcList;
                userId = state.userId;
                _getData(state: state);
                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldAdmin(
                                controller: _staffIDController,
                                label: '3506',
                                readOnly: true),
                            TextFormFieldAdmin(
                                validator: (value) {
                                  if (value == '') {
                                    return '5067'.tr();
                                  }
                                  return null;
                                },
                                isRequired: true,
                                controller: _staffNameController,
                                label: '3507'),
                            TextFormFieldAdmin(
                              inputFormats: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              controller: _mobileNoController,
                              label: '2416',
                            ),
                            //roletype
                            Padding(
                              padding: EdgeInsets.all(8.w),
                              child: ValueListenableBuilder(
                                valueListenable: _roleTypeNotifier,
                                builder: (context, value, child) =>
                                    DropDownButtonFormField2StdCodeWidget(
                                        onChanged: (value) {
                                          _roleTypeNotifier.value =
                                              value as StdCode;
                                          roleTypeSelected = value;
                                        },
                                        value: roleTypeSelected,
                                        label: '3508',
                                        hintText: '3508',
                                        isRequired: true,
                                        list: state.roleTypeList),
                              ),
                            ),

                            //status working - std Code - DRVSTATUSWORK
                            Padding(
                              padding: EdgeInsets.all(8.w),
                              child: ValueListenableBuilder(
                                valueListenable: _statusWorkingNotifier,
                                builder: (context, value, child) =>
                                    DropDownButtonFormField2StdCodeWidget(
                                        isRequired: true,
                                        onChanged: (value) {
                                          _statusWorkingNotifier.value =
                                              value as StdCode;
                                          statusWorkingSelected = value;
                                        },
                                        value: statusWorkingSelected,
                                        label: '4403',
                                        hintText: '4403',
                                        list: state.statusWorkingList),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(8.w),
                              child: ValueListenableBuilder(
                                valueListenable: _defaultEquipmentNotifier,
                                builder: (context, value, child) =>
                                    DropDownButtonFormField2EquipmentWidget(
                                        isRequired: false,
                                        onChanged: (value) {
                                          _defaultEquipmentNotifier.value =
                                              value as EquipmentResponse;
                                          defaultEquipmentSelected = value;
                                        },
                                        value: defaultEquipmentSelected,
                                        label: '1298',
                                        hintText: '1298',
                                        list: state.equipmentList),
                              ),
                            ),
                            TextFormFieldAdmin(
                                controller: _remarkController, label: '1276'),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 16.h),
                              child: const TextRichRequired(
                                label: '4114',
                                isBold: true,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.dcList.length,
                              itemBuilder: (context, index) => CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(state.dcList[index].dcDesc ?? ''),
                                  value:
                                      state.dcList[index].isSelected ?? false,
                                  onChanged: ((value) {
                                    _bloc.add(StaffDetailSelectedRelateDC(
                                        dcCode: state.dcList[index].dcCode!,
                                        equipment:
                                            _defaultEquipmentNotifier.value,
                                        phone: _mobileNoController.text,
                                        remark: _remarkController.text,
                                        roleType: _roleTypeNotifier.value,
                                        staffName: _staffNameController.text,
                                        workingStatus:
                                            _statusWorkingNotifier.value));
                                  })),
                            )
                          ]),
                    ),
                  ),
                );
              }
              return const ItemLoading();
            },
          ),
          bottomNavigationBar: ElevatedButtonWidget(
            isPaddingBottom: true,
            text: '5589',
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                _bloc.add(StaffDetailUpdate(
                    generalBloc: generalBloc,
                    request: StaffUpdateRequest(
                        //updateUser thiếu
                        staffUserId: _staffIDController.text.trim(),
                        staffName: _staffNameController.text.trim(),
                        roleType: _roleTypeNotifier.value.codeId ?? '',
                        dcCode: _dcNotifier.value.dcCode ?? '',
                        updateUser: userId,
                        isActive: true,
                        mobileNo: _mobileNoController.text.trim(),
                        listDcCode: listDC!
                            .where((e) => e.isSelected == true)
                            .map((e) => e.dcCode)
                            .join(',')
                            .toString(),
                        statusWorking:
                            _statusWorkingNotifier.value.codeId ?? '',
                        driverLicenseNo: _driverLicenseNoController.text.trim(),
                        icNo: _icNoController.text.trim(),
                        vendorCode: _vendorCodeNotifier.value.contactCode ?? '',
                        remark: _remarkController.text.trim(),
                        defaultEquipment:
                            _defaultEquipmentNotifier.value.equipmentCode ??
                                '')));
              }
            },
          ),
        ),
      ),
    );
  }

  void _getData({required StaffDetailSuccess state}) {
    final detail = state.staffDetail.getDetail1!.first;

    _staffIDController.text = detail.staffUserId!;
    _staffNameController.text = state.staffName;
    _mobileNoController.text = state.mobileNo;
    _driverLicenseNoController.text = detail.driverLicenseNo ?? '';
    _icNoController.text = detail.icNo ?? '';
    _remarkController.text = state.remark;
    _roleTypeNotifier.value = state.roleTypeList
        .firstWhere((element) => element.codeId == state.roleType);
    roleTypeSelected = state.roleTypeList
        .firstWhere((element) => element.codeId == state.roleType);
    if (state.dcList
        .where((element) => element.dcCode == detail.dcCode)
        .isNotEmpty) {
      _dcNotifier.value =
          state.dcList.firstWhere((element) => element.dcCode == detail.dcCode);
      dcSelected =
          state.dcList.firstWhere((element) => element.dcCode == detail.dcCode);
    }

    _statusWorkingNotifier.value = state.statusWorkingList
        .firstWhere((element) => element.codeId == state.statusWorking);
    statusWorkingSelected = state.statusWorkingList
        .firstWhere((element) => element.codeId == state.statusWorking);

    _vendorCodeNotifier.value = (detail.vendorCode != null &&
            detail.vendorCode != 'MP')
        ? state.venderList
            .firstWhere((element) => element.contactCode == detail.vendorCode)
        : state.venderList.first;
    vendorCodeSelected = (detail.vendorCode != null &&
            detail.vendorCode != 'MP')
        ? state.venderList
            .firstWhere((element) => element.contactCode == detail.vendorCode)
        : state.venderList.first;

    _defaultEquipmentNotifier.value = (state.equipment != '')
        ? state.equipmentList.firstWhere(
            (element) => element.equipmentCode == state.equipment,
          )
        : state.equipmentList.first;
    defaultEquipmentSelected = (state.equipment != '')
        ? state.equipmentList.firstWhere(
            (element) => element.equipmentCode == state.equipment,
          )
        : state.equipmentList.first;
    _dateOfJoinedController.text = detail.dateOfJoined != null
        ? FileUtils.converFromDateTimeToStringddMMyyyy(detail.dateOfJoined)
        : '';
    _resignedDateController.text = detail.resignedDate != null
        ? FileUtils.converFromDateTimeToStringddMMyyyy(detail.resignedDate)
        : '';
  }
}
