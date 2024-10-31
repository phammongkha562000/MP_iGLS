import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/timesheets_detail/timesheets_detail_bloc.dart';
import 'package:igls_new/data/models/mpi/common/mpi_std_code_response.dart';
import 'package:igls_new/data/models/mpi/timesheet/timesheets/timesheets_response.dart';
import 'package:igls_new/data/models/mpi/timesheet/timesheets/timesheets_update_wh_request.dart';
import 'package:igls_new/data/shared/utils/date_time_extension.dart';
import 'package:igls_new/data/shared/utils/datetime_format.dart';
import 'package:igls_new/data/shared/utils/format_date_local.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/load/load_list.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/widgets/spacer_width.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;
// import 'package:igls_new/presentations/widgets/components/dropdown_custom.dart'
//     as dropdown_custom;

class TimesheetsDetailView extends StatefulWidget {
  const TimesheetsDetailView({super.key, required this.timesheetsResponse});
  final TimesheetResult timesheetsResponse;

  @override
  State<TimesheetsDetailView> createState() => _TimesheetsDetailViewState();
}

class _TimesheetsDetailViewState extends State<TimesheetsDetailView> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  MPiStdCode? _stdSelected;
  final ValueNotifier<MPiStdCode> _stdNotifier =
      ValueNotifier<MPiStdCode>(MPiStdCode());

  TimesheetResult? timesheetsItem;
  late TimesheetsDetailBloc _bloc;
  late GeneralBloc generalBloc;
  Color primaryColor = colors.defaultColor;
  @override
  void initState() {
    super.initState();
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TimesheetsDetailBloc>(context)
      ..add(TimesheetsDetailViewLoaded(
          timesheetsItem: widget.timesheetsResponse, generalBloc: generalBloc));
  }

  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarCustom(
          title: Text('5678'.tr()), //hardcode
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: BlocConsumer<TimesheetsDetailBloc, TimesheetsDetailState>(
          listener: (context, state) {
            if (state is TimesheetsDetailSuccess) {
              if (state.updateSuccess == true) {
                CustomDialog().success(context);
                // MyDialog.showSuccess(
                //     context: context, message: 'updatesuccess'.tr());
              }
            }
            if (state is TimesheetsDetailFailure) {
              CustomDialog().error(context, err: state.message,
                  btnOkOnPress: () {
                Navigator.of(context).pop();
                _bloc.add(TimesheetsDetailViewLoaded(
                    generalBloc: generalBloc,
                    timesheetsItem: widget.timesheetsResponse));
              });

              // MyDialog.showError(
              //     text: 'close'.tr(),
              //     context: context,
              //     messageError: state.message,
              //     pressTryAgain: () {
              //       Navigator.pop(context);
              //       _bloc.add(TimesheetsDetailViewLoaded(
              //           appBloc: appBloc,
              //           timesheetsItem: widget.timesheetsResponse));
              //     });
            }
          },
          builder: (context, state) {
            if (state is TimesheetsDetailSuccess) {
              timesheetsItem = state.timesheetsItem;
              _stdNotifier.value = state.stdCodeList.first;
              _stdSelected = state.stdCodeList.first;
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildName(name: state.name),
                            _buildCardTime(),
                            _buildCardInfo(),
                          ],
                        ),
                      ),
                      _buildBtnUpdate(
                          stdCodeList: state.stdCodeList,
                          employeeId: 0 /*  state.employeeId */) //hard
                    ]),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildName({required String name}) {
    return Row(
      children: [
        generalBloc.generalUserInfo?.avartarThumbnail != ''
            ? ClipRRect(
                borderRadius: BorderRadius.circular(64),
                child: Image.network(
                    '${constants.urlMPI}${generalBloc.generalUserInfo?.avartarThumbnail}',
                    errorBuilder: (context, error, stackTrace) {
                  return Image.asset(assets.avtUser, width: 60);
                }, width: 60))
            : Image.asset(assets.avtUser, width: 60),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child:
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildCardTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: _buildRowIcon(
              iconData: Icons.calendar_month,
              text:
                  '${FormatDateConstants.convertUTCtoDateTime(timesheetsItem!.createDate!).convertToDayName2} - ${FormatDateLocal.format_dd_MM_yyyy(timesheetsItem!.createDate.toString())}'),
        ),
        Row(
          children: [
            _buildTime(date: timesheetsItem!.startTime ?? 0),
            _buildTime(date: timesheetsItem!.endTime ?? 0),
          ],
        ),
      ],
    );
  }

  Widget _buildTime({required int date}) {
    return Card(
      color: (FormatDateConstants.convertUTCtoDateTime(date).hour != 0)
          ? colors.textWhite
          : colors.bgDrawerColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
          side: BorderSide(
              color: (FormatDateConstants.convertUTCtoDateTime(date).hour != 0)
                  ? primaryColor
                  : Colors.transparent)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
        child: Text(
          FormatDateConstants.convertUTCTime(date),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTime2({required int date, required String date2}) {
    return Card(
      color: (FormatDateConstants.convertUTCtoDateTime(date).hour != 0)
          ? colors.textWhite
          : colors.bgDrawerColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
          side: BorderSide(
              color: (FormatDateConstants.convertUTCtoDateTime(date).hour != 0)
                  ? primaryColor
                  : Colors.transparent)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
        child: Text(
          date2,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCardInfo() {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 16.h),
        elevation: 4,
        surfaceTintColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRowText(
                        title: '5677',
                        content: timesheetsItem!.workHour.toString(),
                      ),
                      _buildRowText(
                        title: '5680',
                        content: timesheetsItem!.overtTimeHour.toString(),
                      ),
                      _buildRowText(
                        title: '5681', //hardcode
                        content: timesheetsItem!.manualPostReason ?? '',
                      ),
                      _buildRowText(
                        title: '5682', //hardcode
                        content: timesheetsItem!.approveType ?? '',
                      ),
                      _buildRowText(
                        title: '5683',
                        content: timesheetsItem!.approvedNameBy ?? '',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildBtnUpdate(
      {required List<MPiStdCode> stdCodeList, required int employeeId}) {
    return Expanded(
      flex: -1,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: ElevatedButton(
            style: ButtonStyle(
                maximumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 60)),
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 60)),
                elevation: MaterialStateProperty.all(5),
                backgroundColor: MaterialStateProperty.all(primaryColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.r)))),
            onPressed: () {
              _showDialogUpdate(
                  stdCodeList: stdCodeList, employeeId: employeeId);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit, color: Colors.white),
                const WidthSpacer(width: 0.01),
                Text(
                  '5679'.tr().toUpperCase(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            )),
      ),
    );
  }

  _showDialogUpdate(
      {required List<MPiStdCode> stdCodeList, required int employeeId}) {
    _remarkController.text =
        timesheetsItem != null ? timesheetsItem!.manualPostReason ?? '' : '';
    _startController.text =
        FormatDateConstants.convertUTCTime(timesheetsItem!.startTime ?? 0);
    _endController.text =
        FormatDateConstants.convertUTCTime(timesheetsItem!.endTime ?? 0);
    final formKey = GlobalKey<FormState>();

    AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        dialogBorderRadius: BorderRadius.circular(24.r),
        animType: AnimType.rightSlide,
        padding: EdgeInsets.all(12.w),
        onDismissCallback: (type) {},
        btnCancel: TextButton(
          style: ButtonStyle(
              side: MaterialStateProperty.all(BorderSide(color: primaryColor))),
          child: Text('26'.tr()),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        btnOk: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
          child: Text('4171'.tr(), style: const TextStyle(color: Colors.white)),
          onPressed: () {
            // Navigator.pop(context);
            final start = DateTime.parse(
                '${FormatDateConstants.convertUTCDateTimeToyyyyyMMdd(timesheetsItem!.startTime ?? 0)} ${formatTime(time: _startController.text)}:00');
            final end = DateTime.parse(
                '${FormatDateConstants.convertUTCDateTimeToyyyyyMMdd(timesheetsItem!.endTime ?? 0)} ${formatTime(time: _endController.text)}:00');

            if (formKey.currentState!.validate()) {
              if (end.hour != 0) {
                if (end.isAfter(start)) {
                  _bloc.add(TimesheetsDetailUpdate(
                      generalBloc: generalBloc,
                      timesheets: TimesheetsUpdateRequest(
                          tSId: timesheetsItem!.tsId ?? 0,
                          startTime:
                              '${FormatDateConstants.convertUTCDateTimeShort2(timesheetsItem!.startTime ?? 0)} ${_startController.text}:00',
                          endTime:
                              '${FormatDateConstants.convertUTCDateTimeShort2(timesheetsItem!.endTime ?? 0)} ${_endController.text}:00',
                          workHour: timesheetsItem!.workHour ?? 0,
                          overtTimeHour: timesheetsItem!.overtTimeHour ?? 0,
                          manualPostType: _stdNotifier.value.codeId ?? '',
                          manualPostReason: _remarkController.text.trim(),
                          employeeCode:
                              generalBloc.generalUserInfo?.empCode ?? '')));
                  Navigator.pop(context);
                } else {
                  log('Lỗi validate');
                  CustomDialog().error(context, err: '5695'.tr(),
                      btnOkOnPress: () {
                    _bloc.add(TimesheetsDetailViewLoaded(
                        generalBloc: generalBloc,
                        timesheetsItem: widget.timesheetsResponse));
                  });
                }
              } else {
                _bloc.add(TimesheetsDetailUpdate(
                    generalBloc: generalBloc,
                    timesheets: TimesheetsUpdateRequest(
                        tSId: timesheetsItem!.tsId ?? 0,
                        startTime:
                            '${FormatDateConstants.convertUTCDateTimeShort2(timesheetsItem!.startTime ?? 0)} ${_startController.text}:00',
                        endTime:
                            '${FormatDateConstants.convertUTCDateTimeShort2(timesheetsItem!.endTime ?? 0)} ${_endController.text}:00',
                        workHour: timesheetsItem!.workHour ?? 0,
                        overtTimeHour: timesheetsItem!.overtTimeHour ?? 0,
                        manualPostType: _stdNotifier.value.codeId ?? '',
                        manualPostReason: _remarkController.text.trim(),
                        employeeCode:
                            generalBloc.generalUserInfo?.empCode ?? '')));
                Navigator.pop(context);
              }
            }
          },
        ),
        autoDismiss: false,
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5694'.tr()),
                      const SizedBox(
                        width: 8,
                      ),
                      _buildDropDownType(stdCodeList: stdCodeList),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimeUpdate(
                      controller: _startController,
                      isCheckIn: true,
                    ),
                    _buildTimeUpdate(
                      controller: _endController,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: TextFormField(
                    controller: _remarkController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '5067'.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: colors.textRed,
                        ),
                        onPressed: () {
                          _remarkController.clear();
                        },
                      ),
                      labelText: '1276'.tr(),
                    ),
                  ),
                )
              ],
            ),
          ),
        )).show();
  }

  String formatTime({required String time}) {
    final destruct = time.split(':');
    String hour = destruct[0].toString();
    String minute = destruct[1];
    if (hour.length == 1) {
      hour = '0$hour';
    }
    if (minute.length == 1) {
      minute = '0$minute';
    }
    return '$hour:$minute';
  }

  Widget _buildDropDownType({required List<MPiStdCode> stdCodeList}) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: _stdNotifier,
        builder: (context, value, child) => DropdownButtonFormField2(
            isExpanded: true,
            hint: Row(
              children: [
                Expanded(
                  child: Text(
                    '4859'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.darkLiver,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: stdCodeList
                .map((item) => DropdownMenuItem<MPiStdCode>(
                      value: item,
                      child: Text(
                        item.codeDesc ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: _stdSelected,
            onChanged: (value) {
              _stdNotifier.value = value as MPiStdCode;
              _stdSelected = value;
            },
            isDense: true,
            buttonStyleData: dropdown_custom.buttonStyleData,
            dropdownStyleData: dropdown_custom.dropdownStyleData,
            menuItemStyleData: dropdown_custom.menuItemStyleData),
      ),
    );
  }

  Widget _buildTimeUpdate({
    required TextEditingController controller,
    bool? isCheckIn,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: StatefulBuilder(
        builder: (context, setState) => InkWell(
          onTap: () => pickTimeDetailView(
            initTime: controller.text,
            context: context,
            function: (TimeOfDay selectTime) {
              setState(() =>
                  controller.text = '${selectTime.hour}:${selectTime.minute}');
              log(controller.text);
            },
          ),
          child: Row(
            children: [
              _buildTime2(
                  date2: controller.text,
                  date: isCheckIn ?? false
                      ? timesheetsItem!.startTime ?? 0
                      : timesheetsItem!.endTime ?? 0),
              const Icon(
                Icons.edit,
                color: colors.darkLiver,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowText({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          Expanded(child: Text(title.tr())),
          Expanded(
              child: Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))
        ],
      ),
    );
  }

  Widget _buildRowIcon({required String text, required IconData iconData}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          iconData,
          color: primaryColor,
          size: 30,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text(text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.textBlack,
              )),
        ),
      ],
    );
  }
}

Future pickTimeDetailView(
    {required BuildContext context,
    required function,
    required String? initTime}) async {
  TimeOfDay initTimeTOD = TimeOfDay(
      hour: int.parse(initTime!.split(":")[0]),
      minute: int.parse(initTime.split(":")[1]));
  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: initTimeTOD,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child ?? const SizedBox(),
      );
    },
  );
  if (selectedTime != null) {
    function(selectedTime);
  }
}
