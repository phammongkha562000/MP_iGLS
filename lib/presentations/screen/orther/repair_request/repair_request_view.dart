import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/other/repair_request/repair_request_bloc.dart';
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/admin_component/text_form_field_admin.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class RepairRequestView extends StatefulWidget {
  const RepairRequestView({super.key});

  @override
  State<RepairRequestView> createState() => _RepairRequestViewState();
}

class _RepairRequestViewState extends State<RepairRequestView> {
  final _currentMileageController = TextEditingController();
  final _issueDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late RepairRequestBloc _bloc;
  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<RepairRequestBloc>(context);
    _bloc.add(RepairRequestViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBarCustom(title: Text('4726'.tr())),
        body: BlocListener<RepairRequestBloc, RepairRequestState>(
          listener: (context, state) {
            if (state is RepairRequestSuccess) {
              if (state.isSuccess == true) {
                CustomDialog().success(context);
                _resetText();
              }
            }
            if (state is RepairRequestFailure) {
              _resetText();

              if (state.errorCode == constants.errorNullEquipDriverId) {
                CustomDialog().error(
                  context,
                  err: state.message,
                  btnOkOnPress: () => Navigator.of(context).pop(),
                );
                return;
              }
              CustomDialog().error(context, err: state.message);
            }
          },
          child: BlocBuilder<RepairRequestBloc, RepairRequestState>(
            builder: (context, state) {
              if (state is RepairRequestSuccess) {
                return Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                            child: RowFlex3and7(
                                child3: Text(
                                  '1298'.tr(),
                                  style: styleTextTitle,
                                ),
                                child7: Text(
                                  state.equipmentNo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          RowFlex3and7(
                              child3: Text(
                                '4188'.tr(),
                                style: styleTextTitle,
                              ),
                              child7: Text(state.driverName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                            child: _buildTextFieldMileage(),
                          ),
                          _buildTextFieldIssue(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: -1, child: _buildButtonSubmit()),
                ]);
              }
              return const ItemLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldMileage() => TextFormFieldAdmin(
        padding: EdgeInsets.zero,
        colorLabel: colors.defaultColor,
        isRequired: true,
        controller: _currentMileageController,
        validator: (value) {
          if (value!.isEmpty) {
            return "5067".tr();
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        inputFormats: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
        ],
        onChanged: (value) {
          if (value == '.' || value == 0.toString()) {
            _currentMileageController.text = '';
          }
        },
        label: '4540',
      );
  Widget _buildTextFieldIssue() => TextFormFieldAdmin(
        padding: EdgeInsets.zero,
        maxLines: 5,
        controller: _issueDescController,
        validator: (value) {
          if (value!.isEmpty) {
            return "5067".tr();
          } else {
            return null;
          }
        },
        label: '5112',
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        isRequired: true,
        colorLabel: colors.defaultColor,
      );
  Widget _buildButtonSubmit() => ElevatedButtonWidget(
        isPaddingBottom: true,
        text: '37',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            BlocProvider.of<RepairRequestBloc>(context).add(RepairRequestSave(
                generalBloc: generalBloc,
                currentMileage: _currentMileageController.text,
                issueDesc: _issueDescController.text));
          }
        },
      );
  void _resetText() {
    _currentMileageController.clear();
    _issueDescController.clear();
  }
}
