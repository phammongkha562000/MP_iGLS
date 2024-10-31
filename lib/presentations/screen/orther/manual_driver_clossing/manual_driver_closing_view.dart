// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:igls_new/data/shared/utils/format_number.dart';
// import 'package:igls_new/presentations/common/colors.dart' as colors;

// import '../../../../businesses_logics/bloc/general/general_bloc.dart';
// import '../../../../data/services/services.dart';
// import '../../../widgets/app_bar_custom.dart';
// import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
// import 'package:igls_new/presentations/common/key_params.dart' as key_params;

// class ManualDriverClosingView extends StatefulWidget {
//   const ManualDriverClosingView({
//     super.key,
//     this.tripHistory,
//   });

//   final HistoryNormalTrip? tripHistory;
//   @override
//   State<ManualDriverClosingView> createState() =>
//       _ManualDriverClosingViewState();
// }

// ContactLocal? customerSelected;

// final _refNoController = TextEditingController();
// final _mileageStartController = TextEditingController();
// final _mileageEndController = TextEditingController();
// final _tripDateController = TextEditingController();
// final _tripRouteController = TextEditingController();
// final _allowanceController = TextEditingController();
// final _mealAllowanceController = TextEditingController();
// final _tollFeeController = TextEditingController();
// final _loadUnCostController = TextEditingController();
// final _othersController = TextEditingController();
// final _totalController = TextEditingController();
// final _driverMemoController = TextEditingController();
// final _totalNotifer = ValueNotifier<double>(0);
// bool isEdit = true;
// DriverDailyClosingDetailResponse? detail;
// late ManualDriverClosingBloc _bloc;
// late GeneralBloc generalBloc;

// final _navigationService = getIt<NavigationService>();

// class _ManualDriverClosingViewState extends State<ManualDriverClosingView> {
//   @override
//   void initState() {
//     _bloc = BlocProvider.of<ManualDriverClosingBloc>(context);
//     generalBloc = BlocProvider.of<GeneralBloc>(context);
//     _bloc.add(ManualDriverClosingViewLoaded(generalBloc: generalBloc));
//     _clearText();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final formKey = GlobalKey<FormState>();

//     return Form(
//       key: formKey,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBarCustom(title: Text('4550'.tr())),
//         body: BlocListener<ManualDriverClosingBloc, ManualDriverClosingState>(
//           listener: (context, state) async {
//             if (state is ManualDriverClosingFailure) {
//               _clearText();

//               CustomDialog().error(context, err: state.message);
//             } else if (state is ManualDriverClosingSaveSuccess) {
//               CustomDialog().success(context);
//               Future.delayed(
//                   const Duration(seconds: 3),
//                   () => _navigationService.pushReplacementNamed(
//                       routes.driverClosingHistoryDetailRoute,
//                       args: {key_params.dDCId: widget.tripHistory?.dDCId}));
//             }
//           },
//           child: BlocBuilder<ManualDriverClosingBloc, ManualDriverClosingState>(
//             builder: (context, state) {
//               if (state is ManualDriverClosingSuccess) {
//                 _tripDateController.text = DateFormat('dd/MM/yyyy')
//                     .format(state.date ?? DateTime.now());
//                 if (widget.tripHistory != null) {
//                   widget.tripHistory?.tripNo != null
//                       ? _refNoController.text = widget.tripHistory?.tripNo ?? ''
//                       : '';
//                 }
//                 return SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(vertical: 12.h),
//                   child: Column(children: [
//                     CardCustom(
//                       child: Column(children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               widget.tripHistory?.contactCode ?? '',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: colors.textGreen),
//                             ),
//                             Text(
//                               widget.tripHistory?.tripNo ?? '',
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('5586'.tr().toUpperCase()),
//                             Text(widget.tripHistory!.etp.toString()),
//                           ],
//                         ),
//                       ]),
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                             flex: 1,
//                             child: _buildTextFormFiled(
//                               enable: isEdit,
//                               isformatInput: false,
//                               inputFormatters: [NumberFormatter.formatMoney],
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                                 if (value!.isEmpty &&
//                                     _mileageEndController.text != '') {
//                                   return '5067'.tr();
//                                 }
//                                 if (value == "0" && value.isNotEmpty) {
//                                   return '5109'.tr();
//                                 }
//                                 return null;
//                               },
//                               hint: 'km',
//                               label: '5107'.tr(),
//                               controller: _mileageStartController,
//                             )),
//                         Expanded(
//                             flex: 1,
//                             child: _buildTextFormFiled(
//                                 enable: isEdit,
//                                 inputFormatters: [NumberFormatter.formatMoney],
//                                 keyboardType: TextInputType.number,
//                                 validator: (value) {
//                                   if (value!.isEmpty &&
//                                       _mileageStartController.text != '') {
//                                     return '5067'.tr();
//                                   }

//                                   if (value == "0" && value.isNotEmpty) {
//                                     return '5109'.tr();
//                                   }
//                                   if (_mileageStartController.text != '' &&
//                                       value.isNotEmpty &&
//                                       int.parse(value
//                                               .replaceAll(",", "")
//                                               .replaceAll(".", "")) <
//                                           int.parse(_mileageStartController.text
//                                               .replaceAll(",", "")
//                                               .replaceAll(".", ""))) {
//                                     return '5110'.tr();
//                                   }
//                                   return null;
//                                 },
//                                 hint: 'km',
//                                 label: '5106'.tr(),
//                                 controller: _mileageEndController)),
//                       ],
//                     ),
//                     _buildTextFormFiled(
//                         enable: isEdit,
//                         isformatInput: false,
//                         keyboardType: TextInputType.text,
//                         label: '4541'.tr(),
//                         controller: _tripRouteController),
//                     _buildTextFormFiled(
//                         enable: isEdit,
//                         onChanged: (value) {
//                           sumTotal();
//                         },
//                         controller: _allowanceController,
//                         inputFormatters: [NumberFormatter.formatMoney],
//                         keyboardType: TextInputType.number,
//                         label: '4527'.tr()),
//                     _buildTextFormFiled(
//                       enable: isEdit,
//                       onChanged: (value) {
//                         sumTotal();
//                       },
//                       controller: _mealAllowanceController,
//                       inputFormatters: [NumberFormatter.formatMoney],
//                       keyboardType: TextInputType.number,
//                       label: "4528".tr(),
//                     ),
//                     _buildTextFormFiled(
//                       enable: isEdit,
//                       onChanged: (value) {
//                         sumTotal();
//                       },
//                       controller: _tollFeeController,
//                       inputFormatters: [NumberFormatter.formatMoney],
//                       keyboardType: TextInputType.number,
//                       label: "4529".tr(),
//                     ),
//                     _buildTextFormFiled(
//                       enable: isEdit,
//                       onChanged: (value) {
//                         sumTotal();
//                       },
//                       controller: _loadUnCostController,
//                       inputFormatters: [NumberFormatter.formatMoney],
//                       keyboardType: TextInputType.number,
//                       label: "4530".tr(),
//                     ),
//                     _buildTextFormFiled(
//                       enable: isEdit,
//                       onChanged: (value) {
//                         sumTotal();
//                       },
//                       controller: _othersController,
//                       inputFormatters: [NumberFormatter.formatMoney],
//                       keyboardType: TextInputType.number,
//                       label: "4341",
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 12.h),
//                       padding: EdgeInsets.symmetric(horizontal: 24.w),
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.topRight,
//                               colors: <Color>[
//                             colors.defaultColor,
//                             Colors.blue.shade100
//                           ])),
//                       height: 48,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '1284'.tr(),
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           ValueListenableBuilder(
//                               valueListenable: _totalNotifer,
//                               builder: (context, value, child) => Text(
//                                     NumberFormatter.formatThousand(
//                                         _totalNotifer.value),
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold),
//                                   )),
//                         ],
//                       ),
//                     ),
//                     _buildTextFormFiled(
//                         enable: isEdit,
//                         isformatInput: false,
//                         label: '1276',
//                         controller: _driverMemoController),
//                     Padding(
//                       padding: EdgeInsets.only(top: 16.h),
//                       child: ElevatedButtonWidget(
//                           isPaddingBottom: true,
//                           onPressed: isEdit
//                               ? () {
//                                   if (formKey.currentState!.validate()) {
//                                     _onTapSaveWithTripNo();
//                                   }
//                                 }
//                               : null,
//                           text: '37'),
//                     ),
//                   ]),
//                 );
//               }
//               return const ItemLoading();
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   _onTapSaveWithTripNo() => BlocProvider.of<ManualDriverClosingBloc>(context)
//       .add(ManualDriverClosingSaveWithTripNo(
//           contactCode: widget.tripHistory?.contactCode ?? '',
//           generalBloc: generalBloc,
//           tripDate: DateFormat('dd/MM/yyyy hh:mm:ss').format(DateTime.now()),
//           mileStart: _mileageStartController.text.isEmpty
//               ? 0
//               : double.parse(_mileageStartController.text
//                   .replaceAll(",", "")
//                   .replaceAll(".", "")),
//           mileEnd: _mileageEndController.text.isEmpty
//               ? 0
//               : double.parse(_mileageEndController.text
//                   .replaceAll(",", "")
//                   .replaceAll(".", "")),
//           tripRoute: _tripRouteController.text,
//           allowance: _allowanceController.text.isEmpty
//               ? 0
//               : double.parse(_allowanceController.text
//                   .replaceAll(",", "")
//                   .replaceAll(".", "")),
//           mealAllowance: _mealAllowanceController.text.isEmpty
//               ? 0
//               : double.parse(
//                   _mealAllowanceController.text.replaceAll(",", "").replaceAll(".", "")),
//           tollFee: _tollFeeController.text.isEmpty ? 0 : double.parse(_tollFeeController.text.replaceAll(",", "").replaceAll(".", "")),
//           loadUnloadCost: _loadUnCostController.text.isEmpty ? 0 : double.parse(_loadUnCostController.text.replaceAll(",", "").replaceAll(".", "")),
//           othersFee: _othersController.text.isEmpty
//               ? 0
//               : _othersController.text.isEmpty
//                   ? 0
//                   : double.parse(_othersController.text.replaceAll(",", "").replaceAll(".", "")),
//           actualTotal: _totalNotifer.value,
//           driverMemo: _driverMemoController.text,
//           dDCId: widget.tripHistory?.dDCId,
//           tripNo: widget.tripHistory?.tripNo ?? '',
//           driverTripType: widget.tripHistory?.driverTripTypeDesc ?? ''));

//   Widget _buildTextFormFiled(
//           {required String label,
//           bool? isRequired,
//           String? hint,
//           required TextEditingController controller,
//           bool? enable,
//           String? Function(String?)? validator,
//           List<TextInputFormatter>? inputFormatters,
//           TextInputType? keyboardType,
//           void Function(String)? onChanged,
//           bool? isformatInput}) =>
//       Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//         child: TextFormField(
//           controller: controller,
//           enabled: enable ?? true,
//           validator: validator,
//           onChanged: onChanged,
//           inputFormatters: isformatInput ?? true
//               ? [NumberFormatter.formatMoney]
//               : inputFormatters,
//           keyboardType:
//               isformatInput ?? true ? TextInputType.number : keyboardType,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor:
//                 enable == false ? colors.btnGreyDisable.shade300 : Colors.white,
//             hintText:
//                 enable == false ? label.tr() : hint?.tr() ?? '${label.tr()}...',
//             label: isRequired ?? false
//                 ? Text.rich(TextSpan(children: [
//                     TextSpan(
//                         text: label.tr(),
//                         style: const TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold)),
//                     const TextSpan(
//                         text: ' *', style: TextStyle(color: colors.textRed)),
//                   ]))
//                 : Text(label.tr()),
//           ),
//         ),
//       );
//   void sumTotal() {
//     double allowance = _allowanceController.text.isEmpty
//         ? 0
//         : double.parse(
//             _allowanceController.text.replaceAll(",", "").replaceAll(".", ""));
//     double mealAllowance = _mealAllowanceController.text.isEmpty
//         ? 0
//         : double.parse(_mealAllowanceController.text
//             .replaceAll(",", "")
//             .replaceAll(".", ""));
//     double tollFee = _tollFeeController.text.isEmpty
//         ? 0
//         : double.parse(
//             _tollFeeController.text.replaceAll(",", "").replaceAll(".", ""));
//     double loaduploadCost = _loadUnCostController.text.isEmpty
//         ? 0
//         : double.parse(
//             _loadUnCostController.text.replaceAll(",", "").replaceAll(".", ""));
//     double others = _othersController.text.isEmpty
//         ? 0
//         : double.parse(
//             _othersController.text.replaceAll(",", "").replaceAll(".", ""));
//     double total =
//         allowance + mealAllowance + tollFee + loaduploadCost + others;

//     _totalNotifer.value = total;
//   }

//   void _clearText() {
//     _totalNotifer.value = 0;
//     customerSelected = null;
//     _refNoController.clear();
//     _mileageStartController.clear();
//     _mileageEndController.clear();
//     _tripDateController.clear();
//     _tripRouteController.clear();
//     _allowanceController.clear();
//     _mealAllowanceController.clear();
//     _tollFeeController.clear();
//     _loadUnCostController.clear();
//     _othersController.clear();
//     _totalController.clear();
//     _driverMemoController.clear();
//     _totalNotifer.value = 0;
//   }
// }
