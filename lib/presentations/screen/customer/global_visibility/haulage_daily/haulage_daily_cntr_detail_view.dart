import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_daily/haulage_daily_cntr_detail/haulage_daily_cntr_detail_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/global_visibility/cntr_haulage/get_detail_cntr_haulage_res.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/components/validate_form_field.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/std_code_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/text_form_field_readonly.dart';
import '../../../../../data/services/services.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/constants.dart' as constants;

class HaulageDailyCNTRDetailView extends StatefulWidget {
  const HaulageDailyCNTRDetailView(
      {super.key,
      required this.woNo,
      required this.woItemNo,
      required this.blCarrierNo});
  final String woNo;
  final int woItemNo;
  final String blCarrierNo;

  @override
  State<HaulageDailyCNTRDetailView> createState() =>
      _HaulageDailyCNTRDetailViewState();
}

class _HaulageDailyCNTRDetailViewState
    extends State<HaulageDailyCNTRDetailView> {
  final TextEditingController _blCarrierController = TextEditingController();
  final TextEditingController _customerRefNoController =
      TextEditingController();
  final TextEditingController _polPodController = TextEditingController();
  final TextEditingController _vesselorFlightController =
      TextEditingController();
  final TextEditingController _tradeTypeController = TextEditingController();
  final TextEditingController _cdDateController = TextEditingController();
  final TextEditingController _cdNoController = TextEditingController();
  final TextEditingController _tractorController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _pickUpController = TextEditingController();
  final TextEditingController _taskMemoController = TextEditingController();
  final TextEditingController _taskStatusController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _taskStartController = TextEditingController();
  final TextEditingController _taskEndController = TextEditingController();

  late HaulageDailyCntrDetailBloc _bloc;
  late CustomerBloc customerBloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<HaulageDailyCntrDetailBloc>(context);
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc.add(HaulageDailyCntrDetailViewLoaded(
        customerBloc: customerBloc,
        woItemNo: widget.woItemNo.toString(),
        woNo: widget.woNo));
    super.initState();
  }

  final _navigationService = getIt<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5404'.tr()),
      ),
      body:
          BlocConsumer<HaulageDailyCntrDetailBloc, HaulageDailyCntrDetailState>(
        listener: (context, state) {
          if (state is HaulageDailyCntrDetailSaveNotifySuccess) {
            _bloc.add(HaulageDailyCntrDetailViewLoaded(
                customerBloc: customerBloc,
                woNo: widget.woNo,
                woItemNo: widget.woItemNo.toString()));
          } else if (state is HaulageDailyCntrDetailFailure) {
            if (state.errorCode == constants.errorNoConnect) {
              CustomDialog().error(
                btnMessage: '5038'.tr(),
                context,
                err: state.message,
                btnOkOnPress: () => _bloc.add(HaulageDailyCntrDetailViewLoaded(
                    customerBloc: customerBloc,
                    woItemNo: widget.woItemNo.toString(),
                    woNo: widget.woNo)),
              );

              return;
            }
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is HaulageDailyCntrDetailSuccess) {
            WOCDetail woDetail = state
                .detailCNTR.getWOCNTRManifestsResult!.wOCDetail!
                .where((element) => element.wOEquipMode == 'PICKUP')
                .single;
            bool isComplete = state
                    .detailCNTR.getWOCNTRManifestsResult!.wOCDetail!
                    .where((element) =>
                        element.actualEnd == '' || element.actualEnd == null)
                    .isNotEmpty
                ? false
                : true;
            _blCarrierController.text = widget.blCarrierNo;
            _customerRefNoController.text = woDetail.custRefNo ?? '';
            _polPodController.text = woDetail.pOL ?? '';
            _vesselorFlightController.text = woDetail.vesselorFlight ?? '';
            _tradeTypeController.text = woDetail.tradeType ?? '';
            _cdDateController.text = woDetail.cDDate ?? '';
            _cdNoController.text = woDetail.cDNo ?? '';
            _tractorController.text = woDetail.tractor ?? '';
            _driverController.text = woDetail.driverDesc ?? '';
            _pickUpController.text = woDetail.pickDate ?? '';
            _taskMemoController.text = woDetail.taskMemo ?? '';
            _taskStatusController.text = woDetail.taskStatus ?? '';
            _emailController.text =
                state.notifyRes.id != 0 ? state.notifyRes.receiver ?? '' : '';

            _taskStartController.text = woDetail.actualStart == null
                ? ''
                : FileUtils.convertDateForHistoryDetailItem(
                    woDetail.actualStart.toString());
            _taskEndController.text = woDetail.actualEnd == null
                ? ''
                : FileUtils.convertDateForHistoryDetailItem(
                    woDetail.actualEnd.toString());

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _blCarrierController,
                                label: '5476'),
                          ),
                          _sizedBox(),
                          Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _customerRefNoController,
                                label: '3535'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormFieldReadOnly(
                                  controller: _polPodController,
                                  label: '3923')),
                          _sizedBox(),
                          Expanded(
                              child: TextFormFieldReadOnly(
                                  controller: _vesselorFlightController,
                                  label: '5477')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _tradeTypeController,
                                label: '3762'),
                          ),
                          _sizedBox(),
                          Expanded(
                              child: TextFormFieldReadOnly(
                                  controller: _cdDateController,
                                  label: '3578')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormFieldReadOnly(
                                  controller: _cdNoController, label: '4572')),
                          _sizedBox(),
                          Expanded(
                              child: TextFormFieldReadOnly(
                                  controller: _tractorController,
                                  label: '4011')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormFieldReadOnly(
                                  controller: _pickUpController, label: '139')),
                          _sizedBox(),
                          Expanded(
                              child: TextFormFieldReadOnly(
                                  controller: _driverController,
                                  label: '5478')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _taskMemoController, label: '4017'),
                          ),
                          _sizedBox(),
                          Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _taskStatusController,
                                label: '5405'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: isComplete
                            ? TextFormFieldReadOnly(
                                controller: _emailController,
                                label: '2415',
                              )
                            : (_emailController.text != ''
                                ? Row(
                                    children: [
                                      Expanded(
                                          child: _btnNotify(
                                              text: '5406',
                                              icon: const Icon(Icons.check,
                                                  color: Colors.white),
                                              lstStdNotify:
                                                  state.lstStdNotify)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: TextFormFieldReadOnly(
                                          controller: _emailController,
                                          label: 'Email',
                                        ),
                                      )
                                    ],
                                  )
                                : _btnNotify(
                                    text: '5293',
                                    icon: const Icon(Icons.notifications,
                                        color: Colors.white),
                                    lstStdNotify: state.lstStdNotify))),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _taskStartController,
                                label: '5407'),
                          ),
                          _sizedBox(),
                          Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _taskEndController, label: '5408'),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _navigationService.pushNamed(
                            routes.customerHaulageDailyCNTRPhotoRoute,
                            args: {
                              key_params.customerWoTaskID: woDetail.wOTaskId
                            });
                      },
                      child: Text(
                        '5278'.tr(),
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ]),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _sizedBox() {
    return SizedBox(
      width: 8.w,
    );
  }

  Widget _btnNotify(
      {required List<GetStdCodeRes> lstStdNotify,
      required String text,
      required Icon icon}) {
    return ElevatedButton(
        style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(colors.btnGreen),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32)))),
        child: Row(
          children: [
            icon,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child:
                  Text(text.tr(), style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        onPressed: () => _showNotify(
            lstStdNotify: lstStdNotify, destination: _emailController.text));
  }

  _showNotify(
      {required List<GetStdCodeRes> lstStdNotify,
      required String destination}) {
    final formKey = GlobalKey<FormState>();
    TextEditingController receiverController =
        TextEditingController(text: destination);
    GetStdCodeRes? methodSelected =
        lstStdNotify != [] ? lstStdNotify.first : GetStdCodeRes();

    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      btnOk: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          destination != ''
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.r)))),
                      onPressed: destination == ''
                          ? null
                          : () {
                              _bloc.add(HaulageDailyCntrDetailDeleteNotify(
                                  woNo: widget.woNo,
                                  itemNo: widget.woItemNo,
                                  customerBloc: customerBloc));
                              Navigator.of(context).pop();
                            },
                      child: Text(
                        '24'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r)))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('26'.tr()),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r))),
                    backgroundColor:
                        MaterialStateProperty.all(colors.btnGreen)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _bloc.add(HaulageDailyCntrDetailSaveNotify(
                        customerBloc: customerBloc,
                        messageType: methodSelected?.codeID ?? '',
                        notes: '',
                        woNo: widget.woNo,
                        itemNo: widget.woItemNo,
                        receiver: receiverController.text));
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  '37'.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Row(children: [
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: CustomerSTDCodeDropdown(
                          value: methodSelected,
                          listSTD: lstStdNotify,
                          label: '5294',
                          onChanged: (p0) {
                            methodSelected = p0 as GetStdCodeRes;
                          }),
                    ),
                    TextFormField(
                      controller: receiverController,
                      validator: (value) => validateEmail(value ?? ''),
                      decoration: InputDecoration(
                        label: Text(
                          "5296".tr(),
                          style: styleLabelInput,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              receiverController.clear();
                            },
                            icon: const Icon(Icons.close)),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            const HeightSpacer(height: 0.01),
          ],
        ),
      ),
    ).show();
  }
}
