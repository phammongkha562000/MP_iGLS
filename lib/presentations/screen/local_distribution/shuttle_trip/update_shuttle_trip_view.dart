import 'dart:async';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:igls_new/businesses_logics/bloc/local_distribution/shuttle_trip/update_shuttle_trip/update_shuttle_trip_bloc.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/utils.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/models.dart';
import '../../../widgets/app_bar_custom.dart';

class UpdateShuttleTripView extends StatefulWidget {
  const UpdateShuttleTripView({
    super.key,
    required this.shuttleTrip,
    required this.dateTime,
  });
  final ShuttleTripsResponse shuttleTrip;
  final DateTime dateTime;
  @override
  State<UpdateShuttleTripView> createState() => _UpdateShuttleTripViewState();
}

class _UpdateShuttleTripViewState extends State<UpdateShuttleTripView> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<CompanyResponse> _fromNotifier =
      ValueNotifier<CompanyResponse>(CompanyResponse(
          companyId: '', companyCode: '', companyName: '', companyType: ''));
  CompanyResponse? fromSelected;
  final ValueNotifier<StdCode> _stdNotifier =
      ValueNotifier<StdCode>(StdCode(codeType: '', codeDesc: '', codeId: ''));
  StdCode? stdSelected;
  final ValueNotifier<CompanyResponse> _toNotifier =
      ValueNotifier<CompanyResponse>(CompanyResponse(
          companyId: '', companyCode: '', companyName: '', companyType: ''));
  CompanyResponse? toSelected;
  final _invoiceNoController = TextEditingController();
  final _qtyController = TextEditingController();
  final _shippmentNoController = TextEditingController();
  final _sealNoController = TextEditingController();

  final _startTimeController = TextEditingController();
  final _startDateController = TextEditingController();

  final _endTimeController = TextEditingController();
  final _endDateController = TextEditingController();

  final _startLocController = TextEditingController();
  final _endLocController = TextEditingController();
  final _tripModeController = TextEditingController();

  bool isPending = false;

  late UpdateShuttleTripBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<UpdateShuttleTripBloc>(context);
    _bloc.add(UpdateShuttleTripViewLoaded(
      shuttleTrip: widget.shuttleTrip,
      dateTime: widget.dateTime,
      generalBloc: generalBloc,
    ));
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.shuttleTripRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: PopScope(
        onPopInvoked: (bool didPop) async => _back(context),
        // onPopInvokedWithResult: (didPop, result) => _back(context),
        child: Scaffold(
          appBar: AppBarCustom(
            title: Text('5154'.tr()),
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.pop(context, 1)),
          ),
          body: BlocConsumer<UpdateShuttleTripBloc, UpdateShuttleTripState>(
            listener: (context, state) {
              if (state is UpdateShuttleTripSuccess) {
                if (state.isSuccess == true) {
                  CustomDialog().success(context);
                }
                if (state.isDelete == true) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    showToastWidget(
                      const SuccessToast(),
                      position: StyledToastPosition.top,
                      animation: StyledToastAnimation.slideFromRightFade,
                      context: context,
                    );
                  });

                  Navigator.pop(context, 1);
                }
              }
              if (state is UpdateShuttleTripFailure) {
                CustomDialog().error(context, err: state.message);
              }
            },
            builder: (context, state) {
              if (state is UpdateShuttleTripSuccess) {
                isPending =
                    state.shuttleTrip.postedStatus == 'Pending' ? true : false;
                log(isPending.toString());
                _sealNoController.text = state.shuttleTrip.itemNote ?? '';

                _shippmentNoController.text = state.shuttleTrip.shipmentNo!;
                _qtyController.text = state.shuttleTrip.qty!.toString();
                _invoiceNoController.text = state.shuttleTrip.invoiceNo!;
                fromSelected = state.companyList
                    .where((element) =>
                        element.companyCode == state.shuttleTrip.startLoc)
                    .first;
                toSelected = state.companyList
                    .where((element) =>
                        element.companyCode == state.shuttleTrip.endLoc)
                    .first;
                stdSelected = state.listStd
                    .where((element) =>
                        element.codeId == state.shuttleTrip.tripMode)
                    .single;
                _startDateController.text =
                    FormatDateConstants.convertddMMyyyyDate(
                        state.shuttleTrip.startTime!);
                _startTimeController.text = FormatDateConstants.convertHHmm(
                    state.shuttleTrip.startTime!);

                _endDateController.text =
                    FormatDateConstants.convertddMMyyyyDate(
                        state.shuttleTrip.endTime ?? '');
                _endTimeController.text = FormatDateConstants.convertHHmm(
                    state.shuttleTrip.endTime ?? '');
                _startLocController.text = state.shuttleTrip.startLocDesc ?? '';
                _endLocController.text = state.shuttleTrip.endLocDesc ?? '';
                _tripModeController.text = state.listStd
                    .where((element) =>
                        element.codeId == state.shuttleTrip.tripMode!)
                    .single
                    .codeDesc!
                    .tr();

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFrom(list: state.companyList, isPosted: !isPending),
                      Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _listCompanyFreq(
                              listCompany: state.companyList,
                              listFreq: state.companyFreqFrom,
                              typeCompany: 'FROM')),
                      _buildReqGroup(),
                      _buildOtherRef(),
                      _buildItemNote(),
                      _buildTripMode(
                          listStd: state.listStd, isPosted: !isPending),
                      Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _listTripModeFreq(
                            listStd: state.listStd,
                            listFreq: state.listStdFreq ?? [],
                          )),
                      _buildStartTime(value: state.shuttleTrip.startTime!),
                      _buildTo(list: state.companyList, isPosted: !isPending),
                      Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _listCompanyFreq(
                              listCompany: state.companyList,
                              listFreq: state.companyFreqTo,
                              typeCompany: 'TO')),
                      _buildEndTime(value: state.shuttleTrip.endTime ?? ''),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: -1,
                        child: Column(
                          children: [
                            _padding(
                              widget: ElevatedButtonWidget(
                                text: '5589',
                                onPressed:
                                    isPending ? () => _onUpdatePressed() : null,
                                backgroundColor:
                                    isPending ? null : colors.btnGreyDisable,
                              ),
                            ),
                            _padding(
                              widget: ElevatedButtonWidget(
                                text: '24',
                                onPressed: isPending
                                    ? () {
                                        if (_formKey.currentState!.validate()) {
                                          showDeleteDialog(context);
                                        }
                                      }
                                    : null,
                                backgroundColor:
                                    isPending ? null : colors.btnGreyDisable,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const ItemLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _listTripModeFreq({
    required List<StdCode> listFreq,
    required List<StdCode> listStd,
  }) =>
      Wrap(
          direction: Axis.horizontal,
          children: List.generate(
              listFreq.length,
              (index) => Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(1),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(100, 30)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.r),
                                    side: const BorderSide(
                                        color: colors.defaultColor)))),
                        onPressed: () {
                          _stdNotifier.value = listStd
                              .where((element) =>
                                  element.codeId == listFreq[index].codeId)
                              .single;
                          stdSelected = listStd
                              .where((element) =>
                                  element.codeId == listFreq[index].codeId)
                              .single;
                        },
                        child: Text(
                          listFreq[index].codeDesc!.tr(),
                          maxLines: 1,
                          style: const TextStyle(
                              color: colors.defaultColor,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold),
                        )),
                  )));

  _onUpdatePressed() {
    if (_formKey.currentState!.validate()) {
      final start1 = '${FormatDateConstants.formatddMMyyyyToMMddyyyy(
        _startDateController.text,
      )} ${_startTimeController.text}';
      final end1 = '${FormatDateConstants.formatddMMyyyyToMMddyyyy(
        _endDateController.text,
      )} ${_endTimeController.text}';
      final startTime1 = FormatDateConstants.convertToDateTimeMMddyyyy2(start1)
          .add(const Duration(minutes: constants.minuteComplete));

      final endTime1 = FormatDateConstants.convertToDateTimeMMddyyyy2(end1);
      if (endTime1.isAfter(startTime1) == false) {
        CustomDialog().error(
          context,
          err:
              '${'5155'.tr()} ${constants.minuteComplete}${'5157'.tr()}${'5156'.tr()}',
        );
      } else {
        _bloc.add(UpdateShuttleTripPressed(
            generalBloc: generalBloc,
            fromId: fromSelected!.companyCode!,
            invoiceNo: _invoiceNoController.text,
            quantity: _qtyController.text,
            shipmentNo: _shippmentNoController.text,
            sealNo: _sealNoController.text,
            tripModeId: stdSelected!.codeId ?? '',
            toId: toSelected!.companyCode!,
            startDate: FormatDateConstants.formatddMMyyyyToMMddyyyy(
              _startDateController.text,
            ),
            startTime: _startTimeController.text,
            endDate: FormatDateConstants.formatddMMyyyyToMMddyyyy(
              _endDateController.text,
            ),
            endTime: _endTimeController.text));
      }
    }
  }

  Future showDeleteDialog(
    BuildContext context,
  ) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      btnOkOnPress: () {
        _bloc.add(UpdateShuttleTripDelete(generalBloc: generalBloc));
      },
      btnCancelOnPress: () {},
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      btnCancelText: '26'.tr(),
      btnOkText: '4171'.tr(),
      body: Column(
        children: [
          Text(
            "24".tr(),
            style: const TextStyle(
              color: colors.defaultColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).show();
  }

  Widget _buildFrom({required List<CompanyResponse> list, bool? isPosted}) =>
      _padding(
          widget: isPosted ?? false
              ? _textFormField(
                  controller: _startLocController,
                  hintText: '',
                )
              : ValueListenableBuilder(
                  valueListenable: _fromNotifier,
                  builder: (context, value, child) =>
                      DropDownButtonFormField2CompanyWidget(
                    onChanged: (value) {
                      _fromNotifier.value = value as CompanyResponse;
                      fromSelected = value;
                    },
                    value: fromSelected,
                    hintText: '5146',
                    list: list,
                    label: '5147',
                  ),
                ));

  Widget _buildReqGroup() => _padding(
        widget: Row(
          children: [
            Expanded(
              child: _textFormField(
                controller: _invoiceNoController,
                hintText: '5148',
              ),
            ),
            const WidthSpacer(width: 0.01),
            Expanded(
                child: _textFormField(
                    isRequired: true,
                    controller: _qtyController,
                    hintText: '133',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '5067'.tr();
                      }
                      return null;
                    },
                    isQty: true))
          ],
        ),
      );
  Widget _buildOtherRef() => _padding(
        widget: _textFormField(
          isRequired: true,
          controller: _shippmentNoController,
          hintText: '5149',
          validator: (value) {
            if (value!.isEmpty) {
              return '5067'.tr();
            }
            return null;
          },
        ),
      );
  Widget _buildItemNote() => _padding(
          widget: _textFormField(
        controller: _sealNoController,
        hintText: '3659',
      ));
  Widget _buildTripMode(
          {required List<StdCode> listStd, required bool isPosted}) =>
      _padding(
        widget: isPosted
            ? _textFormField(
                controller: _tripModeController,
                hintText: '',
              )
            : ValueListenableBuilder(
                valueListenable: _stdNotifier,
                builder: (context, value, child) =>
                    DropDownButtonFormField2TripModeWidget(
                        onChanged: (value) {
                          _stdNotifier.value = value as StdCode;
                          stdSelected = value;
                        },
                        value: stdSelected,
                        hintText: '5150',
                        label: '5150',
                        list: listStd),
              ),
      );

  Widget _buildStartTime({required String value}) => _padding(
        widget: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: isPending
                    ? () => pickDate(
                        lastDate: DateTime.now(),
                        date: DateTime.now(),
                        context: context,
                        function: (selectDate) {
                          _startDateController.text =
                              FileUtils.formatToStringFromDatetime2(selectDate);
                          log(_startDateController.text);
                        })
                    : null,
                child: SizedBox(
                  child: _textFormField(
                      controller: _startDateController,
                      hintText: '5152',
                      isTime: true,
                      isDate: true),
                ),
              ),
            ),
            const WidthSpacer(width: 0.01),
            Expanded(
              child: InkWell(
                onTap: isPending
                    ? () => pickTime(
                          initTime: _startTimeController.text,
                          context: context,
                          function: (TimeOfDay selectTime) {
                            _startTimeController.text =
                                '${selectTime.hour}:${selectTime.minute}';
                            log(_startTimeController.text);
                          },
                        )
                    : null,
                child: SizedBox(
                  child: _textFormField(
                      controller: _startTimeController,
                      hintText: '4330',
                      isTime: true),
                ),
              ),
            ),
          ],
        ),
      );
  Widget _buildTo(
          {required List<CompanyResponse> list, required bool isPosted}) =>
      _padding(
        widget: isPosted
            ? _textFormField(
                controller: _endLocController,
                hintText: '',
              )
            : ValueListenableBuilder(
                valueListenable: _toNotifier,
                builder: (context, value, child) =>
                    DropDownButtonFormField2CompanyWidget(
                  onChanged: (value) {
                    _toNotifier.value = value as CompanyResponse;
                    toSelected = value;
                  },
                  value: toSelected,
                  hintText: '5146',
                  list: list,
                  label: '5151',
                ),
              ),
      );

  Widget _buildEndTime({required String value}) => _padding(
          widget: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: isPending
                  ? () => pickDate(
                      date: DateTime.now(),
                      context: context,
                      function: (selectDate) {
                        _endDateController.text =
                            FileUtils.formatToStringFromDatetime2(selectDate);
                        log(_endDateController.text);
                      })
                  : null,
              child: SizedBox(
                child: _textFormField(
                    controller: _endDateController,
                    hintText: '5153',
                    isTime: true,
                    isDate: true),
              ),
            ),
          ),
          const WidthSpacer(width: 0.01),
          Expanded(
            child: InkWell(
              onTap: isPending
                  ? () => pickTime(
                        initTime: _endTimeController.text,
                        context: context,
                        function: (TimeOfDay selectTime) {
                          _endTimeController.text =
                              '${selectTime.hour}:${selectTime.minute}';
                          log(_endTimeController.text);
                        },
                      )
                  : null,
              child: SizedBox(
                child: _textFormField(
                    controller: _endTimeController,
                    hintText: '4330',
                    isTime: true),
              ),
            ),
          ),
        ],
      ));
  Widget _listCompanyFreq(
          {required List<CompanyFreqResponse> listFreq,
          required List<CompanyResponse> listCompany,
          required String typeCompany}) =>
      Wrap(
          direction: Axis.horizontal,
          children: List.generate(
              listFreq.length,
              (index) => Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(1),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(100, 30)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.r),
                                    side: const BorderSide(
                                        color: colors.defaultColor)))),
                        onPressed: () {
                          typeCompany == 'FROM'
                              ? _fromNotifier.value = listCompany
                                  .where((element) =>
                                      element.companyId! ==
                                      listFreq[index].companyId)
                                  .single
                              : _toNotifier.value = listCompany
                                  .where((element) =>
                                      element.companyId! ==
                                      listFreq[index].companyId)
                                  .single;
                          typeCompany == 'FROM'
                              ? fromSelected = _fromNotifier.value
                              : toSelected = _toNotifier.value;
                        },
                        child: Text(
                          listFreq[index].companyName!,
                          maxLines: 1,
                          style: const TextStyle(
                              color: colors.defaultColor,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold),
                        )),
                  )));
  Widget _padding({required Widget widget}) =>
      Padding(padding: EdgeInsets.symmetric(vertical: 8.h), child: widget);
  Widget _textFormField(
      {required TextEditingController controller,
      required String hintText,
      bool? isRequired,
      String? Function(String?)? validator,
      void Function(String)? onChanged,
      bool? isQty,
      bool? isTime,
      bool? isDate}) {
    return TextFormField(
      controller: controller,
      readOnly: !isPending,
      onChanged: onChanged,
      enabled: isTime ?? false ? false : true,
      decoration: InputDecoration(
          suffixIcon: isTime ?? false
              ? (isDate ?? false
                  ? const Icon(Icons.calendar_month_rounded)
                  : const Icon(Icons.av_timer))
              : null,
          label: isRequired ?? false
              ? TextRichRequired(label: hintText)
              : Text(hintText.tr()),
          hintText: hintText.tr()),
      validator: validator,
      keyboardType: isQty ?? false
          ? const TextInputType.numberWithOptions(signed: true, decimal: true)
          : null,
      inputFormatters: isQty ?? false
          ? [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
            ]
          : null,
    );
  }

  Widget textRich({required String text}) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: text.tr()),
      const TextSpan(
          text: ' *',
          style: TextStyle(color: colors.textRed, fontWeight: FontWeight.bold)),
    ]));
  }

  Future<dynamic> showDatePicker(
      {required String value,
      required VoidCallback onUpdate,
      required void Function(DateTime) onDateTimeChanged}) {
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoTheme(
        data: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryContrastingColor: Colors.red,
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
              color: colors.defaultColor,
              fontSize: 18,
            ),
          ),
        ),
        child: CupertinoActionSheet(
          actions: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                backgroundColor: Colors.white,
                use24hFormat: true,
                initialDateTime: value == "+"
                    ? DateTime.now()
                    : (FileUtils.formatToDateTimeFromString2(value)),
                onDateTimeChanged: (value) => onDateTimeChanged(value),
              ),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: onUpdate,
            child: Text(
              "5589".tr(),
              style: const TextStyle(color: colors.defaultColor),
            ),
          ),
        ),
      ),
    );
  }
}
