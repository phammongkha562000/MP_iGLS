import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/customer_notify_order_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_detail_res.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/std_code_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/title_expansion.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_order_status/transport_order_status_detail/transport_order_status_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_detail_res.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import 'package:igls_new/presentations/widgets/customer_component/text_form_field_readonly.dart';
import 'package:igls_new/presentations/widgets/photo_view_widget.dart';

import '../../../../../data/services/services.dart';
import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/admin_component/header_table.dart';
import '../../../../widgets/components/validate_form_field.dart';
import '../../../../widgets/table_widget/table_data.dart';
import '../../../../widgets/table_widget/table_no_data.dart';

class CustomerTOSDetailView extends StatefulWidget {
  const CustomerTOSDetailView({
    super.key,
    required this.orderId,
    required this.tripNo,
    required this.deliveryMode,
  });
  final String orderId;
  final String tripNo;
  final String deliveryMode;

  @override
  State<CustomerTOSDetailView> createState() => _CustomerTOSDetailViewState();
}

final _navigationService = getIt<NavigationService>();

class _CustomerTOSDetailViewState extends State<CustomerTOSDetailView> {
  final TextEditingController _orderNoController = TextEditingController();
  final TextEditingController _tripNoController = TextEditingController();
  final TextEditingController _equipmentTypeController =
      TextEditingController();
  final TextEditingController _equipmentController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _pickupAddressController =
      TextEditingController();

  final TextEditingController _shipToController = TextEditingController();
  final TextEditingController _shipToAddressController =
      TextEditingController();

  final TextEditingController _totalQtyController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _codController = TextEditingController();

  bool isPlan = false;
  bool isPickupArrival = false;
  bool isStartDelivery = false;
  bool isDelivered = false;

  late CustomerTOSDetailBloc _bloc;
  late CustomerBloc customerBloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<CustomerTOSDetailBloc>(context);
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc.add(CustomerTOSDetailViewLoaded(
        orderId: widget.orderId,
        customerBloc: customerBloc,
        deliveryMode: widget.deliveryMode,
        tripNo: widget.tripNo));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5402'.tr())),
      body: BlocConsumer<CustomerTOSDetailBloc, CustomerTOSDetailState>(
        listener: (context, state) {
          if (state is CustomerTOSDetailSaveNotifySuccess) {
            _bloc.add(CustomerTOSDetailViewLoaded(
                orderId: widget.orderId,
                customerBloc: customerBloc,
                deliveryMode: widget.deliveryMode,
                tripNo: widget.tripNo));
          }
          if (state is CustomerTOSDetailFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is CustomerTOSDetailSuccess) {
            List<GetTransportOrderDetailMovement> lstMovement =
                state.detail.getTransportOrderDetailMovement ?? [];

            GetTransportOrderGeneral general =
                state.detail.getTransportOrderGeneral?.first ??
                    GetTransportOrderGeneral();

            CustomerNotifyOrderRes notifyOrder = state.notifyOrder;
            _emailController.text =
                notifyOrder.id != 0 ? notifyOrder.receiver ?? '' : '';

            isPlan = lstMovement.isNotEmpty ? true : false;
            isPickupArrival = lstMovement.length > 1 ? true : false;
            isStartDelivery = lstMovement.length > 2 ? true : false;
            isDelivered = lstMovement.length > 3 ? true : false;

            _orderNoController.text = general.orderNo ?? '';
            _tripNoController.text = general.tripNo ?? '';
            _equipmentTypeController.text = general.equipTypeNo ?? '';
            _equipmentController.text = general.equipmentCode ?? '';
            _driverController.text = general.driverDesc ?? '';
            _statusController.text = general.ordStatus ?? '';

            _pickupController.text = general.pickUpName ?? '';
            _pickupAddressController.text = general.pickUpAddress ?? '';
            _shipToController.text = general.shipToName ?? '';
            _shipToAddressController.text = general.shipToAddress ?? '';
            _totalQtyController.text = general.totalQty.toString();
            _volumeController.text = general.totalVolume.toString();
            _weightController.text = general.totalWeight.toString();
            _codController.text = general.codAmount.toString();
            return SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: SingleChildScrollView(
                child: Column(children: [
                  _buildGeneral(
                      lstStdNotify: state.lstStdNotify,
                      orderStatus: general.ordStatus ?? ''),
                  _buildStepLine(),
                  _buildDocumments(lstDocument: []),
                  _buildMovements(lstMovement: lstMovement),
                  const SizedBox(
                    height: 50,
                  )
                ]),
              ),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _buildStepLine() {
    return Row(
      children: [
        _buildTimeLine(
            step: '1',
            isEnable: isPlan,
            text: '199',
            time: '123',
            isFirst: true),
        _buildTimeLine(
          isEnable: isPickupArrival,
          text: '5141',
          time: '123',
          step: '2',
        ),
        _buildTimeLine(
          isEnable: isStartDelivery,
          text: '5069',
          time: '123',
          step: '3',
        ),
        _buildTimeLine(
            isEnable: isDelivered,
            text: '5403',
            time: '123',
            step: '4',
            isLast: true),
      ],
    );
  }

  Widget _buildGeneral(
      {required List<GetStdCodeRes> lstStdNotify,
      required String orderStatus}) {
    return ExpansionTile(
      initiallyExpanded: true,
      title:
          const TitleExpansionWidget(text: '102', asset: Icon(Icons.dashboard)),
      childrenPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _orderNoController,
                  label: '122',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _tripNoController,
                  label: '2468',
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _equipmentTypeController,
                  label: '1291',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _equipmentController,
                  label: '1298',
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _statusController,
                  label: '1279',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _driverController,
                  label: '1321',
                ),
              )
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: orderStatus != 'COMPLETE'
                ? (_emailController.text != ''
                    ? Row(children: [
                        Expanded(
                            child: _btnNotify(
                          lstStdNotify: lstStdNotify,
                          text: '5406',
                          icon: const Icon(Icons.check, color: Colors.white),
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextFormFieldReadOnly(
                            controller: _emailController,
                            label: 'Email',
                          ),
                        )
                      ])
                    : _btnNotify(
                        lstStdNotify: lstStdNotify,
                        text: '5293',
                        icon: const Icon(Icons.notifications,
                            color: Colors.white),
                      ))
                : TextFormFieldReadOnly(
                    controller: _emailController,
                    label: 'Email',
                  )),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _pickupController,
                  label: '3573',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _pickupAddressController,
                  label: '2480',
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _shipToController,
                  label: '141',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _shipToAddressController,
                  label: '3858',
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _totalQtyController,
                  label: '4211',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _volumeController,
                  label: '151',
                ),
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
                  controller: _weightController,
                  label: '149',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormFieldReadOnly(
                  controller: _codController,
                  label: '5371',
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _btnNotify({
    required List<GetStdCodeRes> lstStdNotify,
    required Icon icon,
    required String text,
  }) {
    return ElevatedButton(
        style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(colors.defaultColor),
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
      context: context,
      padding: EdgeInsets.all(16.w),
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      btnOk: Row(
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
                              _bloc.add(CustomerTOSDetailDeleteNotify(
                                  tripNo: widget.tripNo,
                                  orderId: widget.orderId,
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
                        borderRadius: BorderRadius.circular(32)))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('26'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    _bloc.add(CustomerTOSDetailSaveNotify(
                        customerBloc: customerBloc,
                        messageType: methodSelected?.codeID ?? '',
                        notes: '',
                        orderId: widget.orderId,
                        tripNo: widget.tripNo,
                        receiver: receiverController.text));
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  '37'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: colors.textWhite),
                )),
          ),
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
                          label: 'Notify Method',
                          onChanged: (p0) {
                            methodSelected = p0 as GetStdCodeRes;
                          }),
                    ),
                    TextFormField(
                      controller: receiverController,
                      validator: (value) => validateEmail(value ?? ''),
                      decoration: InputDecoration(
                        label: Text(
                          "Destination".tr(),
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
          ],
        ),
      ),
    ).show();
  }

  Widget _buildMovements(
      {required List<GetTransportOrderDetailMovement> lstMovement}) {
    return ExpansionTile(
        title: const TitleExpansionWidget(
            text: '3654', asset: Icon(Icons.app_registration_sharp)),
        initiallyExpanded: true,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                lstMovement.isEmpty
                    ? _buildTableMovementNoData()
                    : TableDataWidget(
                        listTableRowHeader: _headerTableMovements(),
                        listTableRowContent: List.generate(
                            lstMovement.length,
                            (index) => ColoredBox(
                                  color: colorRowTable(
                                      index: index,
                                      color:
                                          colors.defaultColor.withOpacity(0.2)),
                                  child: Row(
                                    children: [
                                      CellTableWidget(
                                          width: 150,
                                          content: lstMovement[index]
                                              .processType
                                              .toString()),
                                      CellTableWidget(
                                          width: 210,
                                          content: FileUtils
                                              .convertDateForHistoryDetailItem(
                                                  lstMovement[index].planned ??
                                                      '')),
                                      CellTableWidget(
                                          width: 150,
                                          content: FileUtils
                                              .convertDateForHistoryDetailItem(
                                                  lstMovement[index].actual ??
                                                      '')),
                                      CellTableWidget(
                                          width: 210,
                                          content:
                                              lstMovement[index].remark ?? ''),
                                    ],
                                  ),
                                )),
                      )
              ],
            ),
          ),
        ]);
  }

  Widget _buildTableMovementNoData() {
    return TableNoDataWidget(
      listTableRow: [
        TableRow(children: _headerTableMovements()),
        TableRow(children: [
          const SizedBox(),
          _buildTextNoData(),
          const SizedBox(),
          const SizedBox(),
        ])
      ],
    );
  }

  List<Widget> _headerTableMovements() {
    return const [
      HeaderTable2Widget(label: '5276', width: 150),
      HeaderTable2Widget(label: '3662', width: 210),
      HeaderTable2Widget(label: '3663', width: 150),
      HeaderTable2Widget(label: '198', width: 210),
    ];
  }

  Widget _buildDocumments({required List<OrderDocument> lstDocument}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: const TitleExpansionWidget(
            text: '2463', asset: Icon(Icons.edit_document)),
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                lstDocument.isEmpty
                    ? _buildTableDocumentNoData()
                    : TableDataWidget(
                        listTableRowHeader: _headerTableDocumments(),
                        listTableRowContent: List.generate(
                            lstDocument.length,
                            (index) => ColoredBox(
                                  color: colorRowTable(
                                      index: index,
                                      color:
                                          colors.defaultColor.withOpacity(0.2)),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (lstDocument[index].fileType ==
                                              "PDF") {
                                            _navigationService.pushNamed(
                                                routes.pdfViewRoute,
                                                args: {
                                                  key_params.fileLocation:
                                                      lstDocument[index]
                                                          .filePath,
                                                });
                                          } else if (lstDocument[index]
                                                  .fileType ==
                                              "XLSX") {
                                            final result = await OpenFile.open(
                                              lstDocument[index].filePath,
                                            );

                                            if (result.type !=
                                                ResultType.done) {
                                              CustomDialog().warning(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                message:
                                                    "${result.message}, Download App?",
                                                isOk: true,
                                                ok: () {
                                                  if (Platform.isAndroid) {
                                                    launchUrl(
                                                      Uri.parse(
                                                          "https://play.google.com/store/apps/details?id=com.microsoft.office.excel"),
                                                      mode: LaunchMode
                                                          .externalApplication,
                                                    );
                                                  } else if (Platform.isIOS) {}
                                                },
                                              );
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PhotoViewWidget(
                                                    path: lstDocument[index]
                                                            .filePath
                                                            ?.replaceAll(
                                                                "D:\\LE\\DS_FILES\\S1",
                                                                'https://pro.igls.vn/uploads') ??
                                                        '');
                                              },
                                            );
                                          }
                                        },
                                        child: CellTableWidget(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            content:
                                                lstDocument[index].fileName ??
                                                    ''),
                                      ),
                                      CellTableWidget(
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  2,
                                          content:
                                              lstDocument[index].createUser ??
                                                  ''),
                                    ],
                                  ),
                                )),
                      )
              ],
            ),
          ),
        ]);
  }

  Widget _buildTableDocumentNoData() {
    return TableNoDataWidget(
      listTableRow: [
        TableRow(children: _headerTableDocumments()),
        TableRow(children: [
          const SizedBox(),
          _buildTextNoData(),
        ])
      ],
    );
  }

  Widget _buildTextNoData() {
    return SizedBox(
      width: 200,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Text(
            "5058".tr().toUpperCase(),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          )),
    );
  }

  List<Widget> _headerTableDocumments() {
    return [
      HeaderTable2Widget(
          label: '5279', width: MediaQuery.sizeOf(context).width / 2),
      HeaderTable2Widget(
          label: '5280', width: MediaQuery.sizeOf(context).width / 2),
    ];
  }

  Widget _buildTimeLine(
      {required String text,
      required String time,
      required bool isEnable,
      required String step,
      bool? isFirst,
      bool? isLast}) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: (MediaQuery.sizeOf(context).width - 16) / 4,
      child: TimelineTile(
          axis: TimelineAxis.horizontal,
          isFirst: isFirst ?? false,
          isLast: isLast ?? false,
          indicatorStyle: IndicatorStyle(
              indicatorXY: 0.5,
              width: 40,
              height: 40,
              indicator: DecoratedBox(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff00a65a), width: 3),
                      color: isEnable ? const Color(0xff00a65a) : Colors.white,
                      shape: BoxShape.circle),
                  child: Center(
                      child: DecoratedBox(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.darkLiver,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        step,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )))),
          alignment: TimelineAlign.manual,
          beforeLineStyle:
              const LineStyle(thickness: 3, color: Color(0xff00a65a)),
          lineXY: 0.3,
          endChild: Text(
            text.tr(),
          ),
          startChild: const SizedBox()),
    );
  }
}
