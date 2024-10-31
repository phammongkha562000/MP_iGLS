import 'package:flutter/material.dart';

import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/outbound_order_status/outbound_order_status_detail/outbound_order_status_detail_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_detail_res.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/text_form_field_readonly.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/widgets/table_widget/table_no_data.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;

import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../../data/services/services.dart';
import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/admin_component/header_table.dart';

class CustomerOOSDetailView extends StatefulWidget {
  const CustomerOOSDetailView({
    super.key,
    required this.orderId,
  });
  final int orderId;

  @override
  State<CustomerOOSDetailView> createState() => _CustomerOOSDetailViewState();
}

class _CustomerOOSDetailViewState extends State<CustomerOOSDetailView> {
  final TextEditingController _receiptDateController = TextEditingController();
  final TextEditingController _orderTypeController = TextEditingController();

  final TextEditingController _orderStatusController = TextEditingController();
  final TextEditingController _equipmentController = TextEditingController();

  final TextEditingController _createController = TextEditingController();
  final TextEditingController _updateController = TextEditingController();

  final TextEditingController _shipNameController = TextEditingController();
  final TextEditingController _shipAddressController = TextEditingController();

  late CustomerOOSDetailBloc _bloc;
  late CustomerBloc customerBloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<CustomerOOSDetailBloc>(context);
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc.add(CustomerOOSDetailViewLoaded(
        orderId: widget.orderId, customerBloc: customerBloc));
    super.initState();
  }

  final _navigationService = getIt<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5366'.tr())),
      body: BlocConsumer<CustomerOOSDetailBloc, CustomerOOSDetailState>(
        listener: (context, state) {
          if (state is CustomerOOSDetailFailure) {
            if (state.errorCode == constants.errorNoConnect) {
              CustomDialog().error(
                btnMessage: '5038'.tr(),
                context,
                err: state.message,
                btnOkOnPress: () => _bloc.add(CustomerOOSDetailViewLoaded(
                    orderId: widget.orderId, customerBloc: customerBloc)),
              );

              return;
            }
            CustomDialog().error(context, err: state.message);
          }
        },
        builder: (context, state) {
          if (state is CustomerOOSDetailSuccess) {
            _receiptDateController.text =
                FileUtils.convertDateForHistoryDetailItem(
                    state.detail.orderDetail?.receiptDate ?? '');
            _orderTypeController.text =
                state.detail.orderDetail?.orderTypeDesc ?? '';
            _orderStatusController.text =
                state.detail.orderDetail?.ordStatusDesc ?? '';
            _equipmentController.text =
                '${state.detail.orderTrip?.equipTypeNo ?? ''}\n${state.detail.orderTrip?.equipmentCode ?? ''}';
            _createController.text =
                '${FileUtils.convertDateForHistoryDetailItem(state.detail.orderDetail?.createDate ?? '')}\nBy ${state.detail.orderDetail?.createUser ?? ''}';
            _updateController.text =
                '${FileUtils.convertDateForHistoryDetailItem(state.detail.orderDetail?.updateDate ?? '')}\nBy ${state.detail.orderDetail?.updateUser ?? ''}';
            _shipNameController.text = state.detail.orderOrg?.orgName ?? '';
            _shipAddressController.text =
                '${state.detail.orderOrg?.orgAddr1 ?? ''}, ${state.detail.orderOrg?.orgAddr2 ?? ''}, ${state.detail.orderOrg?.orgAddr3 ?? ''}';

            return SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: SingleChildScrollView(
                child: Column(children: [
                  _buildGeneral(),
                  _buildItems(lstItem: state.detail.items ?? []),
                  _buildDocumments(
                      lstDocument: state.detail.orderDocuments ?? []),
                  _buildMovements(lstMovement: state.detail.movements ?? []),
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

  Widget _buildGeneral() {
    return ExpansionTile(
      initiallyExpanded: true,
      title: _buildTitleExpansion(
          text: '102', assets: const Icon(Icons.dashboard)),
      childrenPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                  child: TextFormFieldReadOnly(
                      controller: _receiptDateController, label: '125')),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: TextFormFieldReadOnly(
                      controller: _orderTypeController, label: '123')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                  child: TextFormFieldReadOnly(
                      controller: _orderStatusController, label: '124')),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: TextFormFieldReadOnly(
                      controller: _equipmentController, label: '1298')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                  child: TextFormFieldReadOnly(
                      controller: _createController, label: '2385')),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: TextFormFieldReadOnly(
                      controller: _updateController, label: '2384')),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormFieldReadOnly(
                controller: _shipNameController, label: '5508')),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormFieldReadOnly(
                controller: _shipAddressController, label: '5509')),
      ],
    );
  }

  Widget _buildItems({required List<Item> lstItem}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: _buildTitleExpansion(
            text: '144', assets: const Icon(Icons.assignment_rounded)),
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                lstItem.isEmpty
                    ? _buildTableItemsNoData()
                    : TableDataWidget(
                        listTableRowHeader: _headerTableItems(),
                        listTableRowContent: List.generate(
                            lstItem.length,
                            (index) => ColoredBox(
                                  color: colorRowTable(
                                      index: index,
                                      color:
                                          colors.defaultColor.withOpacity(0.2)),
                                  child: Row(
                                    children: [
                                      CellTableWidget(
                                          width: 150,
                                          content:
                                              lstItem[index].itemCode ?? ''),
                                      CellTableWidget(
                                          width: 210,
                                          content:
                                              lstItem[index].itemDesc ?? ''),
                                      CellTableWidget(
                                        width: 210,
                                        content: lstItem[index].grade ?? '',
                                      ),
                                      CellTableWidget(
                                          width: 150,
                                          content:
                                              lstItem[index].lotCode ?? ''),
                                      CellTableWidget(
                                          width: 100,
                                          content:
                                              lstItem[index].productionDate ??
                                                  ''),
                                      CellTableWidget(
                                          width: 100,
                                          content:
                                              lstItem[index].expiredDate ?? ''),
                                      CellTableWidget(
                                          width: 100,
                                          content:
                                              lstItem[index].qty.toString()),
                                      CellTableWidget(
                                          width: 210,
                                          content:
                                              lstItem[index].giQty.toString()),
                                    ],
                                  ),
                                )),
                      )
              ],
            ),
          ),
        ]);
  }

  Widget _buildDocumments({required List<OrderDocument> lstDocument}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: _buildTitleExpansion(
            text: '2463', assets: const Icon(Icons.edit_document)),
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                lstDocument.isEmpty
                    ? _buildTableDocumentNoData()
                    : TableDataWidget(
                        color: colors.defaultColor,
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
                                                return _photoView(lstDocument[
                                                        index]
                                                    .filePath
                                                    ?.replaceAll(
                                                        "D:\\LE\\DS_FILES\\S1",
                                                        'https://pro.igls.vn/uploads'));
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

  Widget _buildMovements({required List<Movement> lstMovement}) {
    return ExpansionTile(
        title: _buildTitleExpansion(
            text: '3654', assets: const Icon(Icons.app_registration_sharp)),
        initiallyExpanded: true,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                lstMovement.isEmpty
                    ? _buildTableMovementNoData()
                    : TableDataWidget(
                        color: colors.defaultColor,
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
                                                  lstMovement[index]
                                                      .createDate
                                                      .toString())),
                                      CellTableWidget(
                                          width: 150,
                                          content: lstMovement[index]
                                              .createUser
                                              .toString()),
                                      CellTableWidget(
                                          width: 210,
                                          content: lstMovement[index]
                                              .memo
                                              .toString()),
                                    ],
                                  ),
                                )),
                      )
              ],
            ),
          ),
        ]);
  }

  Widget _buildTitleExpansion({required String text, required Icon assets}) {
    return Row(
      children: [
        assets,
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(text.tr()),
        )
      ],
    );
  }

  List<Widget> _headerTableItems() {
    return const [
      HeaderTable2Widget(label: '128', width: 150),
      HeaderTable2Widget(label: '131', width: 210),
      HeaderTable2Widget(label: '132', width: 210),
      HeaderTable2Widget(label: '148', width: 150),
      HeaderTable2Widget(label: '167', width: 100),
      HeaderTable2Widget(label: '166', width: 100),
      HeaderTable2Widget(label: '133', width: 100),
      HeaderTable2Widget(label: '3510', width: 210),
    ];
  }

  List<Widget> _headerTableDocumments() {
    return [
      HeaderTable2Widget(
          label: '5279', width: MediaQuery.sizeOf(context).width / 2),
      HeaderTable2Widget(
          label: '5280', width: MediaQuery.sizeOf(context).width / 2),
    ];
  }

  List<Widget> _headerTableMovements() {
    return const [
      HeaderTable2Widget(label: '5276', width: 150),
      HeaderTable2Widget(label: '2375', width: 210),
      HeaderTable2Widget(label: '5277', width: 150),
      HeaderTable2Widget(label: '198', width: 210),
    ];
  }

  Widget _buildTableItemsNoData() {
    return TableNoDataWidget(listTableRow: [
      TableRow(children: _headerTableItems()),
      TableRow(children: [
        const SizedBox(),
        const SizedBox(),
        const SizedBox(),
        _buildTextNoData(),
        const SizedBox(),
        const SizedBox(),
        const SizedBox(),
        const SizedBox(),
      ])
    ], color: colors.defaultColor);
  }

  Widget _buildTableMovementNoData() {
    return TableNoDataWidget(listTableRow: [
      TableRow(children: _headerTableMovements()),
      TableRow(children: [
        const SizedBox(),
        _buildTextNoData(),
        const SizedBox(),
        const SizedBox(),
      ])
    ], color: colors.defaultColor);
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
      color: colors.defaultColor,
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

  // Widget _buildTFF(
  //     {required TextEditingController controller, required String label}) {
  //   return TextFormField(
  //     minLines: 1,
  //     maxLines: 3,
  //     readOnly: true,
  //     controller: controller,
  //     decoration: InputDecoration(
  //         label: Text(
  //           label.tr(),
  //         ),
  //         contentPadding:
  //             const EdgeInsets.symmetric(vertical: 12, horizontal: 28)),
  //   );
  // }

  Widget _photoView(path) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Column(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.white,
                    size: 32,
                  ))),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: PhotoView(
                tightMode: true,
                imageProvider: NetworkImage('$path'),
                initialScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 2,
                backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
