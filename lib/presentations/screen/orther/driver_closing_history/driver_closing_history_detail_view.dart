import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/other/driver_closing_history/driver_closing_history_detail/driver_closing_history_detail_bloc.dart';
import 'package:igls_new/data/models/other/driver_closing_history/driver_closing_history_update_request.dart';
import 'package:igls_new/data/shared/preference/share_pref_service.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/widgets/layout_common.dart';

import '../../../../data/services/services.dart';

class DriverClosingHistoryDetailView extends StatefulWidget {
  const DriverClosingHistoryDetailView(
      {super.key, required this.dDCId, required this.etp});
  final int dDCId;
  final String etp;
  @override
  State<DriverClosingHistoryDetailView> createState() =>
      _DriverClosingHistoryDetailViewState();
}

class _DriverClosingHistoryDetailViewState
    extends State<DriverClosingHistoryDetailView> {
  late DriverClosingHistoryDetailBloc _bloc;
  late GeneralBloc generalBloc;
  final _mileageStartController = TextEditingController();
  final _mileageEndController = TextEditingController();
  final _tripRouteController = TextEditingController();
  final _allowanceController = TextEditingController();
  final _mealAllowanceController = TextEditingController();
  final _tollFeeController = TextEditingController();
  final _loadUnCostController = TextEditingController();
  final _othersController = TextEditingController();
  final _driverMemoController = TextEditingController();
  final _totalNotifer = ValueNotifier<double>(0);
  bool isEdit = true;
  late DriverDailyClosingDetailResponse detail;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _bloc = BlocProvider.of<DriverClosingHistoryDetailBloc>(context);
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc.add(DriverClosingHistoryDetailViewLoaded(
        dDCId: widget.dDCId, generalBloc: generalBloc));
    super.initState();
  }

  final _navigationService = getIt<NavigationService>();

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationService.pushReplacementNamed(
        routes.driverClosingHistoryRoute,
      );
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: PopScope(
        onPopInvoked: (bool didPop) => _back(context),
        // onPopInvokedWithResult: (didPop, result) => _back(context),
        child: Scaffold(
            appBar: AppBarCustom(
              title: Text('5464'.tr()),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, detail.dDCId),
              ),
            ),
            body: BlocConsumer<DriverClosingHistoryDetailBloc,
                DriverClosingHistoryDetailState>(
              listener: (context, state) {
                if (state is DriverClosingHistoryDetailFailure) {
                  CustomDialog().error(context,
                      err: state.message,
                      btnOkOnPress: () => Navigator.of(context).pop());
                  return;
                }
                if (state is DriverClosingHistoryDetailSaveSuccess) {
                  CustomDialog().success(context);
                  _bloc.add(DriverClosingHistoryDetailViewLoaded(
                      dDCId: widget.dDCId, generalBloc: generalBloc));
                }
              },
              builder: (context, state) {
                if (state is DriverClosingHistoryDetailSuccess) {
                  detail = state.detail;

                  isEdit = detail.closingStatus == "APPROVED" ? false : true;
                  _mileageStartController.text =
                      NumberFormatter.formatThousand(detail.mileStart ?? 0);
                  _mileageEndController.text =
                      NumberFormatter.formatThousand(detail.mileEnd ?? 0);
                  _tripRouteController.text = detail.triproute ?? '';
                  _allowanceController.text =
                      NumberFormatter.formatThousand(detail.allowance ?? 0);
                  _mealAllowanceController.text =
                      NumberFormatter.formatThousand(detail.mealAllowance ?? 0);
                  _tollFeeController.text =
                      NumberFormatter.formatThousand(detail.tollFee ?? 0);
                  _loadUnCostController.text = NumberFormatter.formatThousand(
                      detail.loadUnLoadCost ?? 0);
                  _othersController.text =
                      NumberFormatter.formatThousand(detail.othersFee ?? 0);
                  _totalNotifer.value = detail.acualTotal ?? 0;
                  _driverMemoController.text = detail.driverMemo ?? '';

                  return SingleChildScrollView(
                    padding: LayoutCommon.spaceBottomView,
                    child: Column(
                      children: [
                        CardCustom(
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  detail.contactCode ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colors.textGreen),
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                        color: detail.closingStatus == 'POST'
                                            ? colors.textGreen
                                            : colors.textGrey,
                                        borderRadius:
                                            BorderRadius.circular(16.r)),
                                    child: Text(detail.closingStatusDesc ?? '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))
                              ],
                            ),
                            const HeightSpacer(height: 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text(detail.clsosingStatusDesc ?? ''),
                                Text(detail.tripNo!.startsWith("S")
                                    ? TripType.simpleTrip.toString()
                                    : TripType.normalTrip.toString()),
                                Text(
                                  detail.tripNo ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ]),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: _buildTextFormFiled(
                                  enable: isEdit,
                                  isformatInput: false,
                                  inputFormatters: [
                                    NumberFormatter.formatMoney
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty &&
                                        _mileageEndController.text != '') {
                                      return '5067'.tr();
                                    }
                                    //  if (value == "0" && value.isNotEmpty ) {
                                    //     return '5109'.tr();
                                    //   }
                                    return null;
                                  },
                                  hint: 'km',
                                  // isRequired: true,
                                  label: '5107'.tr(),
                                  controller: _mileageStartController,
                                )),
                            Expanded(
                                flex: 1,
                                child: _buildTextFormFiled(
                                    enable: isEdit,
                                    inputFormatters: [
                                      NumberFormatter.formatMoney
                                    ],
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty &&
                                          _mileageStartController.text != '') {
                                        return '5067'.tr();
                                      }

                                      // if (value == "0" && value.isNotEmpty ) {
                                      //   return '5109'.tr();
                                      // }
                                      if (_mileageStartController.text != '' &&
                                          value.isNotEmpty &&
                                          int.parse(value
                                                  .replaceAll(",", "")
                                                  .replaceAll(".", "")) <
                                              int.parse(_mileageStartController
                                                  .text
                                                  .replaceAll(",", "")
                                                  .replaceAll(".", ""))) {
                                        return '5110'.tr();
                                      }
                                      return null;
                                    },
                                    hint: 'km',
                                    // isRequired: true,
                                    label: '5106'.tr(),
                                    controller: _mileageEndController)),
                          ],
                        ),
                        _buildTextFormFiled(
                            enable: isEdit,
                            isformatInput: false,
                            keyboardType: TextInputType.text,
                            /*  validator: (value) {
                              if (value!.isEmpty) {
                                return "5067".tr();
                              } else {
                                return null;
                              }
                            }, */
                            // isRequired: true,
                            label: '4541'.tr(),
                            controller: _tripRouteController),
                        _buildTextFormFiled(
                            enable: isEdit,
                            onChanged: (value) {
                              sumTotal();
                            },
                            controller: _allowanceController,
                            inputFormatters: [NumberFormatter.formatMoney],
                            keyboardType: TextInputType.number,
                            label: '4527'.tr()),
                        _buildTextFormFiled(
                          enable: isEdit,
                          onChanged: (value) {
                            sumTotal();
                          },
                          controller: _mealAllowanceController,
                          inputFormatters: [NumberFormatter.formatMoney],
                          keyboardType: TextInputType.number,
                          label: "4528".tr(),
                        ),
                        _buildTextFormFiled(
                          enable: isEdit,
                          onChanged: (value) {
                            sumTotal();
                          },
                          controller: _tollFeeController,
                          inputFormatters: [NumberFormatter.formatMoney],
                          keyboardType: TextInputType.number,
                          label: "4529".tr(),
                        ),
                        _buildTextFormFiled(
                          enable: isEdit,
                          onChanged: (value) {
                            sumTotal();
                          },
                          controller: _loadUnCostController,
                          inputFormatters: [NumberFormatter.formatMoney],
                          keyboardType: TextInputType.number,
                          label: "4530".tr(),
                        ),
                        _buildTextFormFiled(
                          enable: isEdit,
                          onChanged: (value) {
                            sumTotal();
                          },
                          controller: _othersController,
                          inputFormatters: [NumberFormatter.formatMoney],
                          keyboardType: TextInputType.number,
                          label: "4341",
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12.h),
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                colors.defaultColor,
                                Colors.blue.shade100
                              ])),
                          height: 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1284'.tr(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              ValueListenableBuilder(
                                  valueListenable: _totalNotifer,
                                  builder: (context, value, child) => Text(
                                        NumberFormatter.formatThousand(
                                            _totalNotifer.value),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                            ],
                          ),
                        ),
                        _buildTextFormFiled(
                            enable: isEdit,
                            isformatInput: false,
                            label: '1276',
                            controller: _driverMemoController),
                        isEdit
                            ? Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: ElevatedButtonWidget(
                                    isPaddingBottom: true,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        _updateClosing();
                                        /*   (detail.tripNo == null ||
                                                detail.tripNo == '')
                                            ? _onTapSaveWithoutTripNo()
                                            : _onTapSaveWithTripNo(); */
                                      }
                                    },
                                    text: '5589'),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  );
                }
                return const ItemLoading();
              },
            )),
      ),
    );
  }

  _updateClosing() async {
    final sharedPref = await SharedPreferencesService.instance;

    final DateTime a =
        FileUtils.formatToDateTimeFromString2(detail.tripDate ?? widget.etp);
    final content = UpdateDriverDailyClosingReq(
        equipmentNo: sharedPref.equipmentNo ?? '',
        tripDate: DateFormat('dd/MM/yyyy hh:mm:ss').format(a),
        ddcId: detail.dDCId ?? 0,
        userId: generalBloc.generalUserInfo?.userId ?? '',
        closeMemo: detail.closeMemo ?? '',
        driverTripType: detail.driverTripType ?? '',
        advAllowance: detail.advAllowance ?? 0,
        advMealAllowance: detail.advMealAllowance ?? 0,
        advTollFee: detail.advTollFee ?? 0,
        advLoadUnloadCost: detail.advLoadUnloadCost ?? 0,
        advOthersFee: detail.advOthersFee ?? 0,
        advCashAdvance: detail.advCashAdvance ?? 0,
        mileStart: double.parse(_mileageStartController.text
            .replaceAll(",", "")
            .replaceAll(".", "")),
        mileEnd: double.parse(
            _mileageEndController.text.replaceAll(",", "").replaceAll(".", "")),
        allowance: _allowanceController.text.isEmpty
            ? 0
            : double.parse(_allowanceController.text
                .replaceAll(",", "")
                .replaceAll(".", "")),
        mealAllowance: _mealAllowanceController.text.isEmpty
            ? 0
            : double.parse(_mealAllowanceController.text
                .replaceAll(",", "")
                .replaceAll(".", "")),
        tollFee: _tollFeeController.text.isEmpty
            ? 0
            : double.parse(_tollFeeController.text.replaceAll(",", "").replaceAll(".", "")),
        loadUnloadCost: _loadUnCostController.text.isEmpty ? 0 : double.parse(_loadUnCostController.text.replaceAll(",", "").replaceAll(".", "")),
        othersFee: _othersController.text.isEmpty ? 0 : double.parse(_othersController.text.replaceAll(",", "").replaceAll(".", "")),
        cashAdavanceMemo: detail.cashAdavanceMemo ?? '',
        actualTotal: _totalNotifer.value,
        tripRoute: _tripRouteController.text,
        driverMemo: _driverMemoController.text);
    _bloc.add(
        DriverClosingHistoryUpdate(generalBloc: generalBloc, content: content));
  }
  // _onTapSaveWithoutTripNo() => BlocProvider.of<DriverClosingHistoryDetailBloc>(context)
  //     .add(DriverClosingHistorySaveWithoutTripNo(
  //         generalBloc: generalBloc,
  //         contact: detail.contactCode ?? '',
  //         tripDate: _dateTripNotifer.value,
  //         tripNo: _refNoController.text,
  //         mileStart: double.parse(_mileageStartController.text
  //             .replaceAll(",", "")
  //             .replaceAll(".", "")),
  //         mileEnd: double.parse(_mileageEndController.text
  //             .replaceAll(",", "")
  //             .replaceAll(".", "")),
  //         tripRoute: _tripRouteController.text,
  //         allowance: _allowanceController.text.isEmpty
  //             ? 0
  //             : double.parse(_allowanceController.text
  //                 .replaceAll(",", "")
  //                 .replaceAll(".", "")),
  //         mealAllowance: _mealAllowanceController.text.isEmpty
  //             ? 0
  //             : double.parse(_mealAllowanceController.text.replaceAll(",", "").replaceAll(".", "")),
  //         tollFee: _tollFeeController.text.isEmpty ? 0 : double.parse(_tollFeeController.text.replaceAll(",", "").replaceAll(".", "")),
  //         loadUnloadCost: _loadUnCostController.text.isEmpty ? 0 : double.parse(_loadUnCostController.text.replaceAll(",", "").replaceAll(".", "")),
  //         othersFee: _othersController.text.isEmpty ? 0 : double.parse(_othersController.text.replaceAll(",", "").replaceAll(".", "")),
  //         actualTotal: _totalNotifer.value,
  //         driverMemo: _driverMemoController.text));

  // _onTapSaveWithTripNo() => BlocProvider.of<DriverClosingHistoryDetailBloc>(context)
  //     .add(DriverClosingHistorySaveWithTripNo(
  //         contactCode: detail.contactCode ?? '',
  //         generalBloc: generalBloc,
  //         tripDate: DateFormat('dd/MM/yyyy hh:mm:ss').format(DateTime.now()),
  //         mileStart: _mileageStartController.text.isEmpty
  //             ? 0
  //             : double.parse(_mileageStartController.text
  //                 .replaceAll(",", "")
  //                 .replaceAll(".", "")),
  //         mileEnd: _mileageEndController.text.isEmpty
  //             ? 0
  //             : double.parse(_mileageEndController.text
  //                 .replaceAll(",", "")
  //                 .replaceAll(".", "")),
  //         tripRoute: _tripRouteController.text,
  //         allowance: _allowanceController.text.isEmpty
  //             ? 0
  //             : double.parse(_allowanceController.text
  //                 .replaceAll(",", "")
  //                 .replaceAll(".", "")),
  //         mealAllowance: _mealAllowanceController.text.isEmpty
  //             ? 0
  //             : double.parse(
  //                 _mealAllowanceController.text.replaceAll(",", "").replaceAll(".", "")),
  //         tollFee: _tollFeeController.text.isEmpty ? 0 : double.parse(_tollFeeController.text.replaceAll(",", "").replaceAll(".", "")),
  //         loadUnloadCost: _loadUnCostController.text.isEmpty ? 0 : double.parse(_loadUnCostController.text.replaceAll(",", "").replaceAll(".", "")),
  //         othersFee: _othersController.text.isEmpty
  //             ? 0
  //             : _othersController.text.isEmpty
  //                 ? 0
  //                 : double.parse(_othersController.text.replaceAll(",", "").replaceAll(".", "")),
  //         actualTotal: _totalNotifer.value,
  //         driverMemo: _driverMemoController.text,
  //         dDCId: 0, //hardcode
  //         tripNo: detail.tripNo ?? '',
  //         driverTripType: detail.driverTripTypeDesc ?? ''));
  Widget _buildTextFormFiled(
          {required String label,
          bool? isRequired,
          String? hint,
          required TextEditingController controller,
          bool? enable,
          String? Function(String?)? validator,
          List<TextInputFormatter>? inputFormatters,
          TextInputType? keyboardType,
          void Function(String)? onChanged,
          bool? isformatInput}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: TextFormField(
          controller: controller,
          enabled: enable ?? true,
          validator: validator,
          onChanged: onChanged,
          inputFormatters: isformatInput ?? true
              ? [NumberFormatter.formatMoney]
              : inputFormatters,
          keyboardType:
              isformatInput ?? true ? TextInputType.number : keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor:
                enable == false ? colors.btnGreyDisable.shade100 : Colors.white,
            hintText:
                enable == false ? label.tr() : hint?.tr() ?? '${label.tr()}...',
            label: isRequired ?? false
                ? Text.rich(TextSpan(children: [
                    TextSpan(
                        text: label.tr(),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text: ' *', style: TextStyle(color: colors.textRed)),
                  ]))
                : Text(label.tr()),
          ),
        ),
      );
  void sumTotal() {
    double allowance = _allowanceController.text.isEmpty
        ? 0
        : double.parse(
            _allowanceController.text.replaceAll(",", "").replaceAll(".", ""));
    double mealAllowance = _mealAllowanceController.text.isEmpty
        ? 0
        : double.parse(_mealAllowanceController.text
            .replaceAll(",", "")
            .replaceAll(".", ""));
    double tollFee = _tollFeeController.text.isEmpty
        ? 0
        : double.parse(
            _tollFeeController.text.replaceAll(",", "").replaceAll(".", ""));
    double loaduploadCost = _loadUnCostController.text.isEmpty
        ? 0
        : double.parse(
            _loadUnCostController.text.replaceAll(",", "").replaceAll(".", ""));
    double others = _othersController.text.isEmpty
        ? 0
        : double.parse(
            _othersController.text.replaceAll(",", "").replaceAll(".", ""));
    double total =
        allowance + mealAllowance + tollFee + loaduploadCost + others;

    _totalNotifer.value = total;
  }
}
