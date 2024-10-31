import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/local_distribution/shuttle_trip/add_shuttle_trip/add_shuttle_trip_bloc.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/company_by_type_response.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/company_freq_response.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/shuttle_trips_response.dart';
import 'package:igls_new/data/models/std_code/std_code_response.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class AddShuttleTripView extends StatefulWidget {
  const AddShuttleTripView({
    super.key,
    this.shuttleTripsResponse,
  });
  final ShuttleTripsResponse? shuttleTripsResponse;

  @override
  State<AddShuttleTripView> createState() => _AddShuttleTripViewState();
}

class _AddShuttleTripViewState extends State<AddShuttleTripView> {
  final _formKey = GlobalKey<FormState>();

  ValueNotifier<CompanyResponse> _fromNotifier = ValueNotifier<CompanyResponse>(
      CompanyResponse(
          companyId: '', companyCode: '', companyName: '', companyType: ''));
  CompanyResponse? fromSelected;
  ValueNotifier<StdCode> _stdNotifier =
      ValueNotifier<StdCode>(StdCode(codeType: '', codeDesc: '', codeId: ''));
  StdCode? stdSelected;
  ValueNotifier<CompanyResponse> _toNotifier = ValueNotifier<CompanyResponse>(
      CompanyResponse(
          companyId: '', companyCode: '', companyName: '', companyType: ''));
  CompanyResponse? toSelected;
  final _invoiceNoController = TextEditingController();
  final _qtyController = TextEditingController();
  final _shippmentNoController = TextEditingController();
  final _sealNoController = TextEditingController();

  final _startLocController = TextEditingController();
  final _endLocController = TextEditingController();
  final _tripModeController = TextEditingController();

  bool isActive = false;
  bool isEdit = true;
  bool isEquipment = false;

  late AddShuttleTripBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<AddShuttleTripBloc>(context);
    _bloc.add(AddShuttleTripViewLoaded(
      shuttleTripPending: widget.shuttleTripsResponse,
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
          backgroundColor: Colors.white,
          appBar: AppBarCustom(
            title: Text('5144'.tr()),
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.pop(context, 1)),
          ),
          body: BlocListener<AddShuttleTripBloc, AddShuttleTripState>(
            listener: (context, state) {
              if (state is AddShuttleTripSuccess) {
                if (state.equipmentCode == '') {
                  CustomDialog()
                      .warning(context, message: strings.messErrorNoEquipment);
                }
                if (state.isSuccess == true) {
                  CustomDialog().success(context);
                } else if (state.isSuccess == false) {
                  CustomDialog().warning(context,
                      message:
                          '${'5050'.tr()} ${FormatDateConstants.convertyyyyMMddHHmmToHHmm(state.expectedTime.toString())}');
                }
              }
              if (state is AddShuttleTripFailure) {
                if (state.errorCode == constants.errorNoConnect) {
                  resetNotifier();
                  CustomDialog().error(
                    context,
                    btnMessage: '5038'.tr(),
                    err: state.message,
                    btnOkOnPress: () => _bloc.add(AddShuttleTripViewLoaded(
                        generalBloc: generalBloc,
                        shuttleTripPending: widget.shuttleTripsResponse)),
                  );
                  return;
                }
                CustomDialog().error(context, err: state.message.tr());
              }
            },
            child: BlocBuilder<AddShuttleTripBloc, AddShuttleTripState>(
              builder: (context, state) {
                if (state is AddShuttleTripSuccess) {
                  if (state.equipmentCode != '') {
                    isEquipment = true;
                  }
                  state.shuttleTrip != null
                      ? {
                          isActive = state.shuttleTrip!.endTime == null ||
                                  (state.shuttleTrip!.startTime != null &&
                                      state.shuttleTrip!.endTime != null)
                              ? true
                              : false,
                          isEdit = state.shuttleTrip!.startTime != null &&
                                  state.shuttleTrip!.endTime != null
                              ? false
                              : true,
                          _sealNoController.text =
                              state.shuttleTrip!.itemNote ?? '',
                          _shippmentNoController.text =
                              state.shuttleTrip!.shipmentNo!,
                          _qtyController.text =
                              state.shuttleTrip!.qty!.toString(),
                          _invoiceNoController.text =
                              state.shuttleTrip!.invoiceNo!,
                          fromSelected = state.companyList
                              .where((element) =>
                                  element.companyCode ==
                                  state.shuttleTrip!.startLoc)
                              .single,
                          toSelected = state.companyList
                              .where((element) =>
                                  element.companyCode ==
                                  state.shuttleTrip!.endLoc)
                              .single,
                          stdSelected = state.listStd
                              .where((element) =>
                                  element.codeId == state.shuttleTrip!.tripMode)
                              .single,
                          _startLocController.text =
                              state.shuttleTrip!.startLocDesc ?? '',
                          _endLocController.text =
                              state.shuttleTrip!.endLocDesc ?? '',
                          _tripModeController.text = state.listStd
                              .where((element) =>
                                  element.codeId ==
                                  state.shuttleTrip!.tripMode!)
                              .single
                              .codeDesc!
                        }
                      : {};
                  return SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _padding(
                              widget: isEdit
                                  ? ValueListenableBuilder(
                                      valueListenable: _fromNotifier,
                                      builder: (context, value, child) =>
                                          DropDownButtonFormField2CompanyWidget(
                                        onChanged: (value) {
                                          _fromNotifier.value =
                                              value as CompanyResponse;
                                          fromSelected = value;
                                        },
                                        value: fromSelected,
                                        hintText: '5146',
                                        list: state.companyList,
                                        label: '5147',
                                      ),
                                    )
                                  : _buildFromPosted(),
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: _listCompanyFreq(
                                    listCompany: state.companyList,
                                    listFreq: state.companyFreqFrom,
                                    typeCompany: 'FROM')),
                            _padding(
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
                            ),
                            _padding(
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
                            ),
                            _padding(
                              widget: _textFormField(
                                controller: _sealNoController,
                                hintText: '3659',
                              ),
                            ),
                            _padding(
                              widget: isEdit
                                  ? ValueListenableBuilder(
                                      valueListenable: _stdNotifier,
                                      builder: (context, value, child) =>
                                          DropDownButtonFormField2TripModeWidget(
                                              onChanged: (value) {
                                                _stdNotifier.value =
                                                    value as StdCode;
                                                stdSelected = value;
                                              },
                                              value: stdSelected,
                                              label: '5150',
                                              hintText: '5150',
                                              list: state.listStd),
                                    )
                                  : _buildtripModePosted(),
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: _listTripModeFreq(
                                  listStd: state.listStd,
                                  listFreq: state.listStdFreq ?? [],
                                )),
                            _padding(
                              widget: ValueListenableBuilder(
                                  valueListenable: _toNotifier,
                                  builder: (context, value, child) => isEdit
                                      ? DropDownButtonFormField2CompanyWidget(
                                          onChanged: (value) {
                                            _toNotifier.value =
                                                value as CompanyResponse;
                                            toSelected = value;
                                          },
                                          value: toSelected,
                                          hintText: '5146',
                                          list: state.companyList,
                                          label: '5151',
                                        )
                                      : _buildToPosted()),
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: _listCompanyFreq(
                                    listCompany: state.companyList,
                                    listFreq: state.companyFreqTo,
                                    typeCompany: 'TO')),
                            isEquipment
                                ? _padding(
                                    widget: ElevatedButtonWidget(
                                      // isPadding: false,
                                      text: isActive == true
                                          ? FormatDateConstants
                                              .convertddMMyyyyHHmm2(
                                                  state.shuttleTrip!.startTime!)
                                          : '5152',
                                      onPressed: isActive == true
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _bloc.add(AddShuttleTripStart(
                                                    generalBloc: generalBloc,
                                                    fromId: fromSelected!
                                                        .companyCode!,
                                                    invoiceNo:
                                                        _invoiceNoController
                                                            .text,
                                                    quantity:
                                                        _qtyController.text,
                                                    shipmentNo:
                                                        _shippmentNoController
                                                            .text,
                                                    sealNo:
                                                        _sealNoController.text,
                                                    tripModeId:
                                                        stdSelected!.codeId!,
                                                    toId: toSelected!
                                                        .companyCode!));
                                              }
                                            },
                                      backgroundColor: isActive == true
                                          ? colors.btnGreyDisable
                                          : null,
                                    ),
                                  )
                                : const SizedBox(),
                            isEquipment
                                ? _padding(
                                    widget: ElevatedButtonWidget(
                                        text: !isActive
                                            ? '5153'
                                            : isActive &&
                                                    state.shuttleTrip!
                                                            .endTime ==
                                                        null
                                                ? '5153'
                                                : FormatDateConstants
                                                    .convertddMMyyyyHHmm2(state
                                                        .shuttleTrip!.endTime!),
                                        onPressed: isActive == true
                                            ? isActive &&
                                                    state.shuttleTrip!
                                                            .endTime ==
                                                        null
                                                ? () {
                                                    _bloc.add(AddShuttleTripDone(
                                                        generalBloc:
                                                            generalBloc,
                                                        fromId: fromSelected!
                                                            .companyCode!,
                                                        invoiceNo:
                                                            _invoiceNoController
                                                                .text,
                                                        quantity:
                                                            _qtyController.text,
                                                        shipmentNo:
                                                            _shippmentNoController
                                                                .text,
                                                        sealNo:
                                                            _sealNoController
                                                                .text,
                                                        tripModeId: stdSelected!
                                                            .codeId!,
                                                        toId: toSelected!
                                                            .companyCode!));
                                                  }
                                                : null
                                            : null,
                                        backgroundColor: !isActive
                                            ? colors.btnGreyDisable
                                            : isActive &&
                                                    state.shuttleTrip!
                                                            .endTime ==
                                                        null
                                                ? null
                                                : colors.btnGreyDisable),
                                  )
                                : const SizedBox()
                          ]));
                }
                return const ItemLoading();
              },
            ),
          ),
        ),
      ),
    );
  }

  void resetNotifier() {
    _fromNotifier = ValueNotifier<CompanyResponse>(CompanyResponse(
        companyId: '', companyCode: '', companyName: '', companyType: ''));
    fromSelected = null;
    _stdNotifier =
        ValueNotifier<StdCode>(StdCode(codeType: '', codeDesc: '', codeId: ''));
    stdSelected = null;
    _toNotifier = ValueNotifier<CompanyResponse>(CompanyResponse(
        companyId: '', companyCode: '', companyName: '', companyType: ''));
    toSelected = null;
    _invoiceNoController.clear();
    _qtyController.clear();
    _shippmentNoController.clear();
    _sealNoController.clear();

    _startLocController.clear();
    _endLocController.clear();
    _tripModeController.clear();
  }

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
                                      element.companyCode! ==
                                      listFreq[index].companyCode)
                                  .single
                              : _toNotifier.value = listCompany
                                  .where((element) =>
                                      element.companyCode! ==
                                      listFreq[index].companyCode)
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

  Widget _padding({required Widget widget}) =>
      Padding(padding: EdgeInsets.symmetric(vertical: 8.h), child: widget);
  Widget _textFormField(
      {required TextEditingController controller,
      required String hintText,
      bool? isRequired,
      String? Function(String?)? validator,
      bool? isQty}) {
    return TextFormField(
      controller: controller,
      readOnly: !isEdit,
      decoration: InputDecoration(
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

  Widget _buildFromPosted() => _textFormField(
      controller: _startLocController, hintText: '5147', isRequired: true);
  Widget _buildtripModePosted() => _textFormField(
      controller: _tripModeController, hintText: '5151', isRequired: true);
  Widget _buildToPosted() => _textFormField(
      controller: _endLocController, hintText: '5150', isRequired: true);
}
