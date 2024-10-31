import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inventory_wp/inventory_wp/inventory_wp_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inventory/inventory_total_res.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/widgets/admin_component/header_table.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import '../../../../presentations.dart';
import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/table_widget/table_data.dart';

class CustomerInventoryView extends StatefulWidget {
  const CustomerInventoryView({super.key, required this.model});
  final CustomerInventoryReq model;
  @override
  State<CustomerInventoryView> createState() => _CustomerInventoryViewState();
}

class _CustomerInventoryViewState extends State<CustomerInventoryView> {
  late CustomerBloc customerBloc;
  late CustomerInventoryWPBloc _bloc;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<CustomerInventoryWPBloc>(context);
    _bloc.add(CustomerInventoryWPSearch(
        model: widget.model, customerBloc: customerBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerInventoryWPBloc, CustomerInventoryWPState>(
      listener: (context, state) {
        if (state is CustomerInventoryWPFailure) {
          if (state.errorCode == constants.errorNoConnect) {
            CustomDialog().error(
              btnMessage: '5038'.tr(),
              context,
              err: state.message,
              btnOkOnPress: () => _bloc.add(
                  CustomerInventoryWPViewLoaded(customerBloc: customerBloc)),
            );

            return;
          }
          CustomDialog().error(context, err: state.message);
        }
      },
      builder: (context, state) {
        if (state is CustomerInventoryWPSuccess) {
          return Scaffold(
            appBar: AppBarCustom(
              title: Text('93'.tr()),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    widget.model.isSummary == '0'
                        ? _buildTable(lstInventory: state.lstInventory)
                        : _buildTableTotal(
                            lstInventoryTotal: state.lstInventoryTotal),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
            appBar: AppBarCustom(title: Text('93'.tr())),
            body: const ItemLoading());
      },
    );
  }

  Widget _buildTable({required List<CustomerInventoryRes> lstInventory}) {
    double sumStockQty = 0;
    double sumReserved = 0;
    double sumAvailable = 0;
    for (var element in lstInventory) {
      sumStockQty += element.balance ?? 0;
      sumReserved += element.reservedQty ?? 0;
      sumAvailable += element.availabileQty ?? 0;
    }
    return lstInventory.isEmpty
        ? TableView(headerChildren: _headerLstStr, rowChildren: const [])
        : TableDataWidget(
            listTableRowHeader: _headerTable(),
            listTableRowContent: lstInventory.isEmpty
                ? []
                : [
                    ...List.generate(lstInventory.length, (index) {
                      final item = lstInventory[index];

                      return ColoredBox(
                        color: colorRowTable(
                            index: index,
                            color: colors.defaultColor.withOpacity(0.2)),
                        child: Row(children: [
                          CellTableWidget(
                              width: 100, content: item.itemCode ?? ''),
                          CellTableWidget(
                              width: 300, content: item.itemDesc ?? ''),
                          CellTableWidget(
                              width: 210, content: item.grade ?? ''),
                          CellTableWidget(
                              width: 150, content: item.itemStatus ?? ''),
                          CellTableWidget(
                              width: 100, content: item.dcCode.toString()),
                          CellTableWidget(
                              width: 100,
                              content: NumberFormatter.numberFormatTotalQty(
                                  item.grQty ?? 0)),
                          CellTableWidget(
                              width: 200,
                              content: NumberFormatter.numberFormatTotalQty(
                                  item.balance ?? 0)),
                          CellTableWidget(
                              width: 210,
                              content: NumberFormatter.numberFormatTotalQty(
                                  item.reservedQty ?? 0)),
                          CellTableWidget(
                              width: 210,
                              content: NumberFormatter.numberFormatTotalQty(
                                  item.availabileQty ?? 0)),
                          CellTableWidget(
                              width: 210, content: item.clientRefNo.toString()),
                          CellTableWidget(
                              width: 210, content: item.weight.toString()),
                          CellTableWidget(
                              width: 210, content: item.volume.toString()),
                          CellTableWidget(
                              width: 210,
                              content: item.productionDate != null
                                  ? FileUtils
                                      .converFromDateTimeToStringddMMyyyy(
                                          item.productionDate.toString())
                                  : ''),
                          CellTableWidget(
                              width: 210,
                              content: item.expiredDate != null
                                  ? FileUtils
                                      .converFromDateTimeToStringddMMyyyy(
                                          item.expiredDate.toString())
                                  : ''),
                          CellTableWidget(
                              width: 210, content: item.createDate.toString())
                        ]),
                      );
                    }),
                    ColoredBox(
                      color: Colors.amber,
                      child: Row(children: [
                        const CellTableWidget(width: 100, content: ''),
                        CellTableWidget(
                            width: 300,
                            isBold: true,
                            content:
                                '${'1261'.tr()}: ${lstInventory.length.toString()}'),
                        const CellTableWidget(width: 210, content: ''),
                        const CellTableWidget(width: 150, content: ''),
                        const CellTableWidget(width: 100, content: ''),
                        const CellTableWidget(width: 100, content: ''),
                        CellTableWidget(
                            width: 200,
                            content:
                                '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumStockQty)}',
                            isBold: true),
                        CellTableWidget(
                            width: 210,
                            isBold: true,
                            content:
                                '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumReserved)}'),
                        CellTableWidget(
                            width: 210,
                            isBold: true,
                            content:
                                '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumAvailable)}'),
                        const CellTableWidget(width: 210, content: ''),
                        const CellTableWidget(width: 210, content: ''),
                        const CellTableWidget(width: 210, content: ''),
                        const CellTableWidget(width: 210, content: ''),
                        const CellTableWidget(width: 210, content: ''),
                        const CellTableWidget(width: 210, content: '')
                      ]),
                    ),
                  ]);
    // TableDataWidget(
    //     listTableRowHeader: _headerTable(),
    //     listTableRowContent: lstInventory.isEmpty
    //         ? []
    //         : [
    //             ...List.generate(lstInventory.length, (index) {
    //               final item = lstInventory[index];

    //               return ColoredBox(
    //                 color: colorRowTable(
    //                     index: index,
    //                     color: colors.defaultColor.withOpacity(0.2)),
    //                 child: Row(children: [
    //                   CellTableWidget(
    //                       width: 100, content: item.itemCode ?? ''),
    //                   CellTableWidget(
    //                       width: 300, content: item.itemDesc ?? ''),
    //                   CellTableWidget(width: 210, content: item.grade ?? ''),
    //                   CellTableWidget(
    //                       width: 150, content: item.itemStatus ?? ''),
    //                   CellTableWidget(
    //                       width: 100, content: item.dcCode.toString()),
    //                   CellTableWidget(
    //                       width: 100,
    //                       content: NumberFormatter.numberFormatTotalQty(
    //                           item.grQty ?? 0)),
    //                   CellTableWidget(
    //                       width: 200,
    //                       content: NumberFormatter.numberFormatTotalQty(
    //                           item.balance ?? 0)),
    //                   CellTableWidget(
    //                       width: 210,
    //                       content: NumberFormatter.numberFormatTotalQty(
    //                           item.reservedQty ?? 0)),
    //                   CellTableWidget(
    //                       width: 210,
    //                       content: NumberFormatter.numberFormatTotalQty(
    //                           item.availabileQty ?? 0)),
    //                   CellTableWidget(
    //                       width: 210, content: item.clientRefNo.toString()),
    //                   CellTableWidget(
    //                       width: 210, content: item.weight.toString()),
    //                   CellTableWidget(
    //                       width: 210, content: item.volume.toString()),
    //                   CellTableWidget(
    //                       width: 210,
    //                       content: item.productionDate != null
    //                           ? FileUtils.converFromDateTimeToStringddMMyyyy(
    //                               item.productionDate.toString())
    //                           : ''),
    //                   CellTableWidget(
    //                       width: 210,
    //                       content: item.expiredDate != null
    //                           ? FileUtils.converFromDateTimeToStringddMMyyyy(
    //                               item.expiredDate.toString())
    //                           : ''),
    //                   CellTableWidget(
    //                       width: 210, content: item.createDate.toString())
    //                 ]),
    //               );
    //             }),
    //             ColoredBox(
    //               color: Colors.amber,
    //               child: Row(children: [
    //                 const CellTableWidget(width: 150, content: ''),
    //                 CellTableWidget(
    //                     width: 210,
    //                     isBold: true,
    //                     content:
    //                         '${'1261'.tr()}: ${lstInventory.length.toString()}'),
    //                 const CellTableWidget(width: 210, content: ''),
    //                 const CellTableWidget(width: 150, content: ''),
    //                 const CellTableWidget(width: 100, content: ''),
    //                 const CellTableWidget(width: 100, content: ''),
    //                 CellTableWidget(
    //                     width: 200,
    //                     content:
    //                         '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumStockQty)}',
    //                     isBold: true),
    //                 CellTableWidget(
    //                     width: 210,
    //                     isBold: true,
    //                     content:
    //                         '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumReserved)}'),
    //                 CellTableWidget(
    //                     width: 210,
    //                     isBold: true,
    //                     content:
    //                         '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumAvailable)}'),
    //                 const CellTableWidget(width: 210, content: ''),
    //                 const CellTableWidget(width: 210, content: ''),
    //                 const CellTableWidget(width: 210, content: ''),
    //                 const CellTableWidget(width: 210, content: ''),
    //                 const CellTableWidget(width: 210, content: ''),
    //                 const CellTableWidget(width: 210, content: '')
    //               ]),
    //             ),
    //           ]),
  }

  final List<String> _headerLstStr = [
    '128',
    '131',
    '132',
    '146',
    '1297',
    '178',
    '180',
    '194',
    '195',
    '122',
    '149',
    '151',
    '167',
    '166',
    '66',
  ];
  final List<String> _headerTotalLstStr = [
    '128',
    '131',
    '132',
    '146',
    '1297',
    '178',
    '180',
    '197',
    '195',
  ];

  Widget _buildTableTotal(
      {required List<CustomerInventoryTotalRes> lstInventoryTotal}) {
    double sumStockQty = 0;
    double sumReserved = 0;
    double sumAvailable = 0;
    for (var element in lstInventoryTotal) {
      sumStockQty += element.totalBalance ?? 0;
      sumReserved += element.totalReservedQty ?? 0;
      sumAvailable += element.totalAvailabileQty ?? 0;
    }
    return lstInventoryTotal.isEmpty
        ? TableView(headerChildren: _headerTotalLstStr, rowChildren: const [])
        : TableDataWidget(
            listTableRowHeader: _headerTableTotal(),
            listTableRowContent: lstInventoryTotal.isEmpty
                ? []
                : [
                    ...List.generate(lstInventoryTotal.length, (index) {
                      final item = lstInventoryTotal[index];
                      return ColoredBox(
                        color: colorRowTable(
                            index: index,
                            color: colors.defaultColor.withOpacity(0.2)),
                        child: Row(children: [
                          CellTableWidget(
                              width: 150, content: item.itemCode ?? ''),
                          CellTableWidget(
                              width: 210, content: item.itemDesc ?? ''),
                          CellTableWidget(
                              width: 210, content: item.grade ?? ''),
                          CellTableWidget(
                              width: 150, content: item.itemStatus ?? ''),
                          CellTableWidget(
                              width: 100, content: item.dcCode.toString()),
                          CellTableWidget(
                              width: 100,
                              content: NumberFormatter.numberFormatTotalQty(
                                  item.totalGrQty ?? 0)),
                          CellTableWidget(
                              width: 210,
                              content: NumberFormatter.numberFormatTotalQty(
                                  item.totalBalance ?? 0)),
                          CellTableWidget(
                              width: 210,
                              content: NumberFormatter.numberFormatTotalQty(
                                  item.totalReservedQty ?? 0)),
                          CellTableWidget(
                              width: 210,
                              content: NumberFormatter.numberFormatTotalQty(
                                  item.totalAvailabileQty ?? 0)),
                        ]),
                      );
                    }),
                    ColoredBox(
                      color: Colors.amber,
                      child: Row(children: [
                        const CellTableWidget(width: 150, content: ''),
                        CellTableWidget(
                            width: 210,
                            content:
                                '${'1261'.tr()}: ${lstInventoryTotal.length.toString()}',
                            isBold: true),
                        const CellTableWidget(width: 210, content: ''),
                        const CellTableWidget(width: 150, content: ''),
                        const CellTableWidget(width: 100, content: ''),
                        const CellTableWidget(width: 100, content: ''),
                        CellTableWidget(
                            width: 210,
                            isBold: true,
                            content:
                                '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumStockQty)}'),
                        CellTableWidget(
                            width: 210,
                            isBold: true,
                            content:
                                '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumReserved)}'),
                        CellTableWidget(
                          width: 210,
                          isBold: true,
                          content:
                              '${'1284'.tr()}: ${NumberFormatter.numberFormatter(sumAvailable)}',
                        ),
                      ]),
                    ),
                  ]);
  }

  List<Widget> _headerTable() {
    return const [
      HeaderTable2Widget(label: '128', width: 100),
      HeaderTable2Widget(label: '131', width: 300),
      HeaderTable2Widget(label: '132', width: 210),
      HeaderTable2Widget(label: '146', width: 150),
      HeaderTable2Widget(label: '1297', width: 100),
      HeaderTable2Widget(label: '178', width: 100),
      HeaderTable2Widget(label: '180', width: 200),
      HeaderTable2Widget(label: '194', width: 210),
      HeaderTable2Widget(label: '195', width: 210),
      HeaderTable2Widget(label: '122', width: 210),
      HeaderTable2Widget(label: '149', width: 210),
      HeaderTable2Widget(label: '151', width: 210),
      HeaderTable2Widget(label: '167', width: 210),
      HeaderTable2Widget(label: '166', width: 210),
      HeaderTable2Widget(label: '66', width: 210),
    ];
  }

  List<Widget> _headerTableTotal() {
    return const [
      HeaderTable2Widget(label: '128', width: 150),
      HeaderTable2Widget(label: '131', width: 210),
      HeaderTable2Widget(label: '132', width: 210),
      HeaderTable2Widget(label: '146', width: 150),
      HeaderTable2Widget(label: '1297', width: 100),
      HeaderTable2Widget(label: '178', width: 100),
      HeaderTable2Widget(label: '180', width: 210),
      HeaderTable2Widget(label: '197', width: 210),
      HeaderTable2Widget(label: '195', width: 210),
    ];
  }

  // Widget _buildBtnSearch() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ElevatedButtonWidget(
  //         onPressed: () {
  //           _bloc.add(CustomerInventoryWPSearch(
  //               defaultClient: contactSelected ?? '',
  //               customerBloc: customerBloc,
  //               itemCode: _itemCodeController.text,
  //               grade: gradeSelected?.codeID ?? '',
  //               itemStatus: itemStatusSelected?.codeID ?? "",
  //               fromDate: FileUtils.formatToStringFromDatetime(fromDate),
  //               toDate: FileUtils.formatToStringFromDatetime(toDate),
  //               dc: dcSelected?.dCCode ?? '',
  //               isSummary: _isSummaryNotifier.value ? "1" : "0",
  //               isFilterReceiptDate: _filterReceiptNotifier.value));
  //           Navigator.of(context).pop();
  //         },
  //         text: '36'),
  //   );
  // }

  // Widget _buildContactList() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     child: CustomerContactDropdown(
  //         lstContact:
  //             customerBloc.contactList!.map((e) => e.clientId!).toList(),
  //         value: contactSelected,
  //         label: '1326',
  //         onChanged: (p0) {
  //           String contactCode = p0 as String;
  //           contactSelected = contactCode;
  //           _contactNotifier.value = contactCode;
  //         }),
  //   );
  // }

  // Widget _buildFromToDate() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //             child: InkWell(
  //           onTap: () {
  //             pickDate(
  //                 date: fromDate,
  //                 context: context,
  //                 function: (selectDate) {
  //                   _fromDateController.text =
  //                       FileUtils.formatToStringFromDatetime2(selectDate);
  //                   fromDate = selectDate;
  //                   log(_fromDateController.text);
  //                 });
  //           },
  //           child: TextFormField(
  //             controller: _fromDateController,
  //             enabled: false,
  //             decoration: InputDecoration(
  //                 label: Text('5273'.tr()),
  //                 suffixIcon: const Icon(Icons.calendar_month,
  //                     color: colors.defaultColor)),
  //           ),
  //         )),
  //         const SizedBox(
  //           width: 8,
  //         ),
  //         Expanded(
  //             child: InkWell(
  //           onTap: () {
  //             pickDate(
  //                 date: toDate,
  //                 context: context,
  //                 function: (selectDate) {
  //                   _toDateController.text =
  //                       FileUtils.formatToStringFromDatetime2(selectDate);
  //                   toDate = selectDate;
  //                   log(_toDateController.text);
  //                 });
  //           },
  //           child: TextFormField(
  //             controller: _toDateController,
  //             enabled: false,
  //             decoration: InputDecoration(
  //                 label: Text('5274'.tr()),
  //                 suffixIcon: const Icon(Icons.calendar_month,
  //                     color: colors.defaultColor)),
  //           ),
  //         )),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFilterReceiptDate() {
  //   return ValueListenableBuilder(
  //     valueListenable: _filterReceiptNotifier,
  //     builder: (context, value, child) => CheckboxListTile(
  //       visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
  //       title: Text('5367'.tr()),
  //       value: value,
  //       onChanged: (value) {
  //         _filterReceiptNotifier.value = value;
  //       },
  //       controlAffinity: ListTileControlAffinity.leading,
  //     ),
  //   );
  // }

  // Widget _buildDCSummary({required List<UserDCResult> lstDC}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 3,
  //           child: DropdownButtonFormField2(
  //             dropdownStyleData: DropdownStyleData(
  //                 decoration:
  //                     BoxDecoration(borderRadius: BorderRadius.circular(16))),
  //             value: dcSelected,
  //             isExpanded: true,
  //             decoration: InputDecoration(
  //               label: Text('90'.tr()),
  //             ),
  //             onChanged: (value) {
  //               dcSelected = value as UserDCResult;
  //             },
  //             selectedItemBuilder: (context) {
  //               return lstDC.map((e) {
  //                 return Text(
  //                   e.dCDesc ?? '',
  //                   overflow: TextOverflow.ellipsis,
  //                   maxLines: 1,
  //                 );
  //               }).toList();
  //             },
  //             menuItemStyleData:
  //                 MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
  //               return ColoredBox(
  //                 color: colors.defaultColor.withOpacity(0.2),
  //                 child: child,
  //               );
  //             }),
  //             items: lstDC
  //                 .map<DropdownMenuItem<UserDCResult>>((UserDCResult value) {
  //               return DropdownMenuItem<UserDCResult>(
  //                 value: value,
  //                 child: Text(
  //                   value.dCDesc.toString(),
  //                   overflow: TextOverflow.ellipsis,
  //                   maxLines: 1,
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //         Expanded(
  //             flex: 2,
  //             child: ValueListenableBuilder(
  //               valueListenable: _isSummaryNotifier,
  //               builder: (context, value, child) => CheckboxListTile(
  //                 visualDensity:
  //                     const VisualDensity(horizontal: -4, vertical: -4),
  //                 title: Text('5368'.tr()),
  //                 value: value,
  //                 onChanged: (value) {
  //                   _isSummaryNotifier.value = value;
  //                 },
  //                 controlAffinity: ListTileControlAffinity.leading,
  //               ),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildItemCode() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: TextFormField(
  //       controller: _itemCodeController,
  //       decoration: InputDecoration(label: Text('128'.tr())),
  //     ),
  //   );
  // }

  // Widget _buildItemStatus({
  //   required List<GetStdCodeRes> lstItemsStatus,
  //   required List<GetStdCodeRes> lstGrade,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //             child: CustomerSTDCodeDropdown(
  //                 value: itemStatusSelected,
  //                 onChanged: (p0) {
  //                   itemStatusSelected = p0 as GetStdCodeRes;
  //                 },
  //                 label: '146',
  //                 listSTD: lstItemsStatus)),
  //         const SizedBox(
  //           width: 8,
  //         ),
  //         Expanded(
  //             child: CustomerSTDCodeDropdown(
  //                 value: gradeSelected,
  //                 onChanged: (p0) {
  //                   gradeSelected = p0 as GetStdCodeRes;
  //                 },
  //                 label: '132',
  //                 listSTD: lstGrade)),
  //       ],
  //     ),
  //   );
  // }
}
