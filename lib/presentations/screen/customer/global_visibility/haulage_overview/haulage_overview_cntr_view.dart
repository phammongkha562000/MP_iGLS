import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_overview/haulage_overview_cntr_detail/haulage_overview_cntr_detail_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/global_visibility/cntr_haulage/get_detail_cntr_haulage_res.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/std_code_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/text_form_field_readonly.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';

import '../../../../../data/services/services.dart';
import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/admin_component/header_table.dart';
import '../../../../widgets/components/validate_form_field.dart';

class HaulageOverviewCNTRView extends StatefulWidget {
  const HaulageOverviewCNTRView(
      {super.key,
      required this.woNo,
      required this.woItemNo,
      required this.blCarrierNo});
  final String woNo;
  final int woItemNo;
  final String blCarrierNo;

  @override
  State<HaulageOverviewCNTRView> createState() =>
      _HaulageOverviewCNTRViewState();
}

class _HaulageOverviewCNTRViewState extends State<HaulageOverviewCNTRView> {
  final TextEditingController _blCarrierController = TextEditingController();
  final TextEditingController _customerRefNoController =
      TextEditingController();
  final TextEditingController _polPodController = TextEditingController();
  final TextEditingController _vesselorFlightController =
      TextEditingController();
  final TextEditingController _tradeTypeController = TextEditingController();
  final TextEditingController _cdDateController = TextEditingController();
  final TextEditingController _cdNoController = TextEditingController();

  final TextEditingController _pickUpController = TextEditingController();
  final TextEditingController _tractorController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late HaulageOverviewCntrDetailBloc _bloc;
  late CustomerBloc customerBloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<HaulageOverviewCntrDetailBloc>(context);
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc.add(HaulageOverviewCntrDetailViewLoaded(
        customerBloc: customerBloc,
        woItemNo: widget.woItemNo.toString(),
        woNo: widget.woNo));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5404'.tr()),
      ),
      body: BlocConsumer<HaulageOverviewCntrDetailBloc,
          HaulageOverviewCntrDetailState>(
        listener: (context, state) {
          if (state is HaulageOverviewCntrDetailSaveNotifySuccess) {
            _bloc.add(HaulageOverviewCntrDetailViewLoaded(
                customerBloc: customerBloc,
                woNo: widget.woNo,
                woItemNo: widget.woItemNo.toString()));
          } else if (state is HaulageOverviewCntrDetailFailure) {
            if (state.errorCode == constants.errorNoConnect) {
              CustomDialog().error(
                btnMessage: '5038'.tr(),
                context,
                err: state.message,
                btnOkOnPress: () => _bloc.add(
                    HaulageOverviewCntrDetailViewLoaded(
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
          if (state is HaulageOverviewCntrDetailSuccess) {
            WOCDetail woDetail =
                state.detailCNTR.getWOCNTRManifestsResult!.wOCDetail!.first;
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
            _pickUpController.text = woDetail.pickDate ?? '';
            _emailController.text =
                state.notifyRes.id != 0 ? state.notifyRes.receiver ?? '' : '';

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormFieldReadOnly(
                              controller: _blCarrierController,
                              label: 'BL/Carrier No'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextFormFieldReadOnly(
                              controller: _customerRefNoController,
                              label: '3535'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _polPodController,
                                label: 'POL/POD')),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _vesselorFlightController,
                                label: 'Vesselor Flight')),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormFieldReadOnly(
                              controller: _tradeTypeController, label: '3668'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _cdDateController, label: '3578')),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _cdNoController, label: '4572')),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: TextFormFieldReadOnly(
                                controller: _tractorController, label: '4011')),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormFieldReadOnly(
                        controller: _pickUpController, label: 'PickUp'),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: isComplete
                          ? TextFormFieldReadOnly(
                              controller: _emailController,
                              label: 'Email',
                            )
                          : (_emailController.text != ''
                              ? Row(
                                  children: [
                                    Expanded(
                                        child: _btnNotify(
                                            text: '5406',
                                            icon: const Icon(Icons.check,
                                                color: Colors.white),
                                            lstStdNotify: state.lstStdNotify)),
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
                  _buildTable()
                ],
              ),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _buildTable(/* {required List<HaulageOverViewImport> lstImport} */) {
    return TableDataWidget(
        listTableRowHeader: _headerTable(),
        listTableRowContent: List.generate(1 /* lstImport.length */, (index) {
          // final item = lstImport[index];
          return InkWell(
            onTap: () {
              // _navigationService.pushNamed(
              //     routes.customerHaulageOverviewCNTRRoute,
              //     args: {
              //       key_params.woNoHaulageOverview: item.woNo,
              //       key_params.woItemNoHaulageOverview: item.woItemNo
              //     });
            },
            child: ColoredBox(
              color: colorRowTable(
                  index: index, color: colors.defaultColor.withOpacity(0.2)),
              child: const Row(children: [
                CellTableWidget(width: 200, content: ''),
                CellTableWidget(width: 200, content: ''),
                CellTableWidget(width: 200, content: ''),
                CellTableWidget(width: 200, content: ''),
                CellTableWidget(width: 200, content: ''),
                CellTableWidget(width: 200, content: ''),
              ]),
            ),
          );
        }));
  }

  List<Widget> _headerTable() {
    return const [
      HeaderTable2Widget(label: 'Item Code', width: 200),
      HeaderTable2Widget(label: 'Item Description', width: 200),
      HeaderTable2Widget(label: 'Qty', width: 200),
      HeaderTable2Widget(label: 'PO No', width: 200),
      HeaderTable2Widget(label: 'Customer PO No', width: 200),
      HeaderTable2Widget(label: 'CINV No', width: 200),
    ];
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
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                text.tr(),
                style: const TextStyle(color: Colors.white),
              ),
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
      padding: EdgeInsets.all(16.w),
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
                                  borderRadius: BorderRadius.circular(32)))),
                      onPressed: destination == ''
                          ? null
                          : () {
                              _bloc.add(HaulageOverviewCntrDetailDeleteNotify(
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
                    _bloc.add(HaulageOverviewCntrDetailSaveNotify(
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
      btnCancelColor: colors.textRed,
      btnOkColor: colors.textGreen,
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => validateEmail(value ?? ""),
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
