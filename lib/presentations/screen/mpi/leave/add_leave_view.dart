// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/leave/new_leave/add_leave_bloc.dart';
import 'package:igls_new/data/models/mpi/common/mpi_std_code_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/datetime_format.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/default_button.dart';
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/load/load_list.dart';
import 'package:igls_new/presentations/widgets/mpi/mpi_text_form_field_custom.dart';
import 'package:igls_new/presentations/widgets/mpi/mpi_text_rich__required.dart';
import 'package:igls_new/presentations/widgets/mpi/workflow_dialog.dart';
import 'package:igls_new/presentations/widgets/row/row_5_5.dart';
import 'package:igls_new/presentations/widgets/row/row_7_3.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class AddLeaveView extends StatefulWidget {
  const AddLeaveView({super.key});

  @override
  State<AddLeaveView> createState() => _AddLeaveViewState();
}

class _AddLeaveViewState extends State<AddLeaveView> {
  final _navigationService = getIt<NavigationService>();

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _reasonController = TextEditingController();

// * Calendar
  DateTime now = DateTime.now();
  DateTime startDayCalendar = DateTime(DateTime.now().year, 1, 1);
  DateTime endDayCalendar = DateTime(DateTime.now().year, 12, 31);
  //* Calculator Date
  DateTime calDateFrom = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 00, 00, 00);
  DateTime calDateTo = DateTime.now();

  bool isAddLeave = false;

  final ValueNotifier<num> _totalDateNotifier = ValueNotifier(0.0);

  final _formKey = GlobalKey<FormState>();
  late GeneralBloc generalBloc;
  late AddLeaveBloc _bloc;
  @override
  void initState() {
    super.initState();
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<AddLeaveBloc>(context);
    _bloc.add(AddLeaveLoaded());
    _bloc.generalBloc = generalBloc;
  }

  Color backgroundPanel = Colors.black;
  Color colorPanel = colors.defaultColor;

  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? colors.defaultColor;
    return Scaffold(
      appBar: AppBarCustom(
          title: Text("5701".tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, isAddLeave),
          )),
      body: BlocConsumer<AddLeaveBloc, AddLeaveState>(
        listener: (context, state) {
          if (state is AddLeaveSuccessfully) {
            isAddLeave = true;
            CustomDialog().success(context).whenComplete(() =>
                _navigationService.pushNamed(routes.mpiLeaveRoute,
                    args: {key_params.isAddLeave: isAddLeave}));

            // MyDialog.showSuccess(
            //   message: 'addsuccess'.tr(),
            //   context: context,
            //   pressContinue: () {},
            //   whenComplete: () {
            //     _navigationService.pushNamed(MyRoute.leaveRoute,
            //         args: {KeyParams.isAddLeave: isAddLeave});
            //   },
            // );
          }
          if (state is AddLeaveFailure) {
            CustomDialog().error(context, err: state.message, btnOkOnPress: () {
              _bloc.add(AddLeaveLoaded());
              // _navigationService.pushNamed(routes.mpiAddLeaveRoute);
            });
            /* if (state.errorCode == MyError.errCodeAddLeave) {
              MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    _navigationService.pushNamed(MyRoute.AddLeave);
                  });
            } else {
              MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    _navigationService.pushNamed(MyRoute.AddLeave);
                  });
            } */
          }
        },
        builder: (context, state) {
          if (state is AddLeaveLoadSuccess) {
            _fromDateController.text =
                FormatDateConstants.convertddMMyyyyFromDateTime(state.fromDate);
            _toDateController.text =
                FormatDateConstants.convertddMMyyyyFromDateTime(state.toDate);
            _totalDateNotifier.value = state.calDate;

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        buildWorkFlow(context, state),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.w, top: 6.h),
                              child: TextRichRequired(label: "5686".tr()),
                            ),
                            buildRow1(state),
                            _buildFromDateToDate(state: state),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 8.w, top: 6.h),
                            //   child: TextRichRequired(label: "5685".tr()),
                            // ),
                            _buildCalculatorDate(state: state),
                            InputTextFieldNew(
                              isRequired: true,
                              controller: _reasonController,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return '5713'.tr();
                                }
                                return null;
                              },
                              labelText: '5711',
                              hintText: '5845',
                            ),
                            // InputTextFieldNew(
                            //     isRequired: true,
                            //     controller: _handOverController,
                            //     validator: (value) {
                            //       if (value!.trim().isEmpty) {
                            //         return '5714'.tr();
                            //       }
                            //       return null;
                            //     },
                            //     labelText: '5702'),
                            // InputTextFieldNew(
                            //     isRequired: true,
                            //     controller: _handOverEmpController,
                            //     validator: (value) {
                            //       if (value!.trim().isEmpty) {
                            //         return '5715'.tr();
                            //       }
                            //       return null;
                            //     },
                            //     labelText: '5703'),iw
                            // InputTextFieldNew(
                            //     type: TextInputType.phone,
                            //     isRequired: true,
                            //     controller: _phoneController,
                            //     validator: (value) {
                            //       if (value!.trim().isEmpty) {
                            //         return '5716'.tr();
                            //       }
                            //       return null;
                            //     },
                            //     labelText: '5704'),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: -1,
                    child: ElevatedButtonWidget(
                      text: "5705",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String remark =
                              "- Lý Do Nghỉ: ${_reasonController.text}";
                          _bloc.add(AddLeaveSubmit(remark: remark));
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _buildFromDateToDate({required AddLeaveLoadSuccess state}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: RowFlex5and5(
          left: InputTextFieldNew(
              labelText: '5147',
              readOnly: true,
              isRequired: true,
              controller: _fromDateController,
              suffixIcon: IconButton(
                onPressed: () async {
                  DateTime? fromDate = await showDatePicker(
                    context: context,
                    initialDate: state.fromDate,
                    firstDate: startDayCalendar,
                    lastDate: endDayCalendar,
                  );
                  _bloc.add(AddLeaveChangeFromDate(
                      fromDate: fromDate ?? state.fromDate,
                      divisionCode:
                          generalBloc.generalUserInfo?.divisionCode ?? ''));
                },
                icon: iconCalendar(),
              )),
          spacer: true,
          right: InputTextFieldNew(
              labelText: '5151',
              readOnly: true,
              isRequired: true,
              controller: _toDateController,
              suffixIcon: IconButton(
                  onPressed: () async {
                    DateTime? toDate = await showDatePicker(
                      context: context,
                      initialDate: state.toDate,
                      firstDate: state.fromDate,
                      lastDate: endDayCalendar,
                    );
                    _bloc.add(AddLeaveChangeToDate(
                        toDate: toDate ?? state.toDate,
                        divisionCode:
                            generalBloc.generalUserInfo?.divisionCode ?? ''));
                  },
                  icon: iconCalendar()))),
    );
  }

  Widget _buildCalculatorDate({required AddLeaveLoadSuccess state}) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h),
      child: ValueListenableBuilder(
        valueListenable: _totalDateNotifier,
        builder: (context, value, child) {
          return RowFlex5and5(
            left: TextRichRequired(label: "5685".tr()),
            right: RowFlex7and3(
              child7: const SizedBox(),
              child3: Text(state.calDate.toString(), style: styleContent()),
            ),
          );
        },
      ),
    );
  }

  Padding buildRow1(AddLeaveLoadSuccess state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: RowFlex5and5(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacer: true,
          left: buildLeaveType(state),
          right: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: RowFlex7and3(
                child7: Text(
                  "5706".tr(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                child3: Text(
                    state.leaveResponse == null
                        ? "0.0"
                        : state.leaveResponse!.balance.toString(),
                    style: styleContent())),
          )),
    );
  }

  TextStyle styleContent() {
    return const TextStyle(
        color: colors.textBlack, fontWeight: FontWeight.bold);
  }

  Widget buildLeaveType(AddLeaveLoadSuccess state) {
    return DropdownButtonFormField2<MPiStdCode>(
      validator: (value) {
        if (value == null) {
          return '5719'.tr();
        } else if ((state.leaveResponse!.balance == 0 &&
                state.typeLeave!.codeId == "ANNU") ||
            (state.leaveResponse!.balance == 0 &&
                state.typeLeave!.codeId == "ANNPR")) {
          return "5720".tr();
        } else if ((state.leaveResponse!.balance! < state.calDate &&
                state.typeLeave!.codeId == 'ANNU') ||
            (state.leaveResponse!.balance! < state.calDate &&
                state.typeLeave!.codeId == 'ANNPR')) {
          return "5707".tr();
        }
        return null;
      },
      buttonStyleData: dropdown_custom.buttonStyleData,
      isExpanded: true,
      hint: Text(
        "5708".tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style:
            TextStyle(fontSize: 14, color: colors.outerSpace.withOpacity(0.5)),
      ),
      items: state.listStdCodeHr!
          .map((item) => DropdownMenuItem<MPiStdCode>(
                value: item,
                child: Text(
                  _getDescLeaveType(leaveId: item.codeId ?? '').tr(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      value: state.typeLeave,
      dropdownStyleData: DropdownStyleData(
          elevation: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          )),
      onChanged: (value) {
        value as MPiStdCode;
        _bloc.add(AddLeaveChangeTypeLeave(typeLeave: value));
      },
      selectedItemBuilder: (context) {
        return state.listStdCodeHr!.map((e) {
          return Text(
            _getDescLeaveType(leaveId: e.codeId ?? '').tr(),
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 14),
          );
        }).toList();
      },
      menuItemStyleData: dropdown_custom.menuItemStyleData,
    );
  }

  InkWell buildWorkFlow(BuildContext context, AddLeaveLoadSuccess state) {
    return InkWell(
      onTap: () {
        //hardcode
        showDialogWorkFlow(context: context, workflowList: state.workFlow ?? [])
            .show();
      },
      child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
              color: backgroundPanel,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.r),
                bottomRight: Radius.circular(15.r),
              )),
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: '5709'.tr(),
                style:
                    TextStyle(color: colorPanel, fontWeight: FontWeight.bold)),
            TextSpan(
                text: ' ${'5710'.tr()}',
                style: const TextStyle(
                    color: colors.nokiaBlue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline)),
          ]))),
    );
  }

  Icon iconCalendar() {
    return const Icon(Icons.calendar_month, size: 30);
  }

  DateTime parseDateString(String dateString) {
    List<String> dateParts = dateString.split('/');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      errorStyle: const TextStyle(
        height: 0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
    );
  }

  String _getDescLeaveType({required String leaveId}) {
    switch (leaveId) {
      case 'ANNU':
        return '5763';
      case 'ANNPR':
        return '5764';

      case 'NOPA':
        return '5765';

      case 'PARE':
        return '5766';

      case 'MARR':
        return '5767';

      case 'MATE':
        return '5768';

      case 'COMP':
        return '5769';

      default:
        return '';
    }
  }
}

class SessionType {
  final String session;
  final int sessionCode;
  final String sessionId;
  SessionType(
      {required this.session,
      required this.sessionCode,
      required this.sessionId});
}
