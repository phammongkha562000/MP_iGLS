import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/admin/equipments/equipment_detail/equipment_detail_bloc.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/widgets/admin_component/text_form_field_admin.dart';

import 'package:igls_new/presentations/widgets/components/dropdown_button_custom/dropdown_button_custom_staff.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class EquipmentDetailView extends StatefulWidget {
  const EquipmentDetailView({super.key, required this.equipmentCode});
  final String equipmentCode;
  @override
  State<EquipmentDetailView> createState() => _EquipmentDetailViewState();
}

class _EquipmentDetailViewState extends State<EquipmentDetailView> {
  final TextEditingController _equipmentCodeController =
      TextEditingController();
  final TextEditingController _equipmentTypeController =
      TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final ValueNotifier<StaffsResponse> _staffNotifier =
      ValueNotifier<StaffsResponse>(StaffsResponse());
  StaffsResponse? staffSelected;
  bool isUpdate = false;
  late EquipmentDetailBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<EquipmentDetailBloc>(context);
    _bloc.add(EquipmentDetailViewLoaded(
        equipmentCode: widget.equipmentCode,
        isDeleted: 0,
        generalBloc: generalBloc));
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.equipmentsRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      onPopInvoked: (bool didPop) => _back(context),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text('5123'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, isUpdate),
          ),
        ),
        body: BlocConsumer<EquipmentDetailBloc, EquipmentDetailState>(
          listener: (context, state) {
            if (state is EquipmentDetailUpdateSuccessfully) {
              isUpdate = true;
              CustomDialog().success(context).whenComplete(
                    () => _bloc.add(EquipmentDetailViewLoaded(
                        generalBloc: generalBloc,
                        equipmentCode: widget.equipmentCode,
                        isDeleted: 0)),
                  );
            }
            if (state is EquipmentDetailFailure) {
              CustomDialog().error(context, err: state.message);
            }
          },
          builder: (context, state) {
            if (state is EquipmentDetailSuccess) {
              _equipmentTypeController.text =
                  state.detail.getDataDetail![0].equipTypeNo!;
              _equipmentCodeController.text =
                  state.detail.getDataDetail![0].equipmentCode!;
              final staffDefault = state.staffList
                  .where((element) =>
                      element.staffUserId ==
                      state.detail.getDataDetail![0].defaultStaffId)
                  .toList();
              if (staffDefault.isNotEmpty) {
                _staffNotifier.value = staffDefault.first;
                staffSelected = staffDefault.first;
              }
              _remarkController.text =
                  state.detail.getDataDetail![0].remarks ?? '';
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormFieldAdmin(
                        readOnly: true,
                        controller: _equipmentCodeController,
                        label: '1298'),
                    TextFormFieldAdmin(
                        readOnly: true,
                        controller: _equipmentTypeController,
                        label: '1291'),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: ValueListenableBuilder(
                        valueListenable: _staffNotifier,
                        builder: (context, value, child) =>
                            DropDownButtonFormField2StaffsWidget(
                                isRequired: false,
                                onChanged: (value) {
                                  _staffNotifier.value =
                                      value as StaffsResponse;
                                  staffSelected = value;
                                },
                                value: staffSelected,
                                label: '1299',
                                hintText: '1299',
                                list: state.staffList),
                      ),
                    ),
                    TextFormFieldAdmin(
                        controller: _remarkController, label: '1276'),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                      child: const TextRichRequired(
                        label: '4114',
                        isBold: true,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: state.dcList.length,
                      itemBuilder: (context, index) => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(state.dcList[index].dcDesc ?? ''),
                          value: state.dcList[index].isSelected ?? false,
                          onChanged: ((value) {
                            _bloc.add(EquipmentDetailSelectedRelateDC(
                                dcCode: state.dcList[index].dcCode!));
                          })),
                    )
                  ],
                ),
              );
            }
            return const ItemLoading();
          },
        ),
        bottomNavigationBar: ElevatedButtonWidget(
            isPaddingBottom: true,
            onPressed: () {
              _bloc.add(EquipmentDetailUpdate(
                generalBloc: generalBloc,
                staffId: _staffNotifier.value.staffUserId!,
                remark: _remarkController.text,
              ));
            },
            text: '5589'),
      ),
    );
  }
}
