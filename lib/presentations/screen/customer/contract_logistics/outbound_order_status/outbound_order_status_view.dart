import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/outbound_order_status/outbound_order_status/outbound_order_status_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/outbound_order_status/outbound_order_status_res.dart';
import 'package:igls_new/data/services/services.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/admin_component/cell_table.dart';
import 'package:igls_new/presentations/widgets/admin_component/header_table.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';

class OutboundOrderStatusView extends StatefulWidget {
  const OutboundOrderStatusView({super.key, required this.model});
  final CustomerOOSReq model;
  @override
  State<OutboundOrderStatusView> createState() =>
      _OutboundOrderStatusViewState();
}

class _OutboundOrderStatusViewState extends State<OutboundOrderStatusView> {
  final _navigationService = getIt<NavigationService>();

  late CustomerBloc customerBloc;
  late CustomerOOSBloc oosBloc;
  final ValueNotifier<bool> _viewDetailNotifier = ValueNotifier(false);

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    oosBloc = BlocProvider.of<CustomerOOSBloc>(context);
    oosBloc.add(CustomerOOSSearch(
        model: widget.model,
        subsidiaryId: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerOOSBloc, CustomerOOSState>(
      listener: (context, state) {
        if (state is CustomerOOSFailure) {
          CustomDialog().error(context,
              err: state.message,
              btnOkOnPress: () => oosBloc.add(CustomerOOSSearch(
                  model: widget.model,
                  subsidiaryId:
                      customerBloc.userLoginRes?.userInfo?.subsidiaryId ??
                          '')));
        }
      },
      builder: (context, state) {
        if (state is CustomerOOSSuccess) {
          _viewDetailNotifier.value =
              widget.model.isViewDetail == '1' ? true : false;
          return Scaffold(
            appBar: AppBarCustom(
              title: Text('237'
                  .tr()), /* actions: [
              CustomerModalBottomSheetSearch(
                lstFieldSearch: [
                  _buildOrderNo(),
                  _buildOrderStatus(
                      lstOrdStatus: state.lstOrdStatus,
                      lstOutboundDateser: state.lstOutboundDateser),
                  _buildFromToDate(),
                  _buildDCViewDetail(lstDC: state.lstDC),
                  _buildContact(),
                  _buildBtnSearch(),
                ],
              )
            ] */
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: IntrinsicHeight(
                child: Column(children: [
                  _buildTable(oosList: state.oosList),
                ]),
              ),
            ),
          );
        }
        return Scaffold(
            appBar: AppBarCustom(
              title: Text('237'.tr()),
            ),
            body: const ItemLoading());
      },
    );
  }

  // Widget _buildContact() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     child: CustomerContactDropdown(
  //         lstContact:
  //             customerBloc.contactList!.map((e) => e.clientId!).toList(),
  //         value: contactSelectedCode,
  //         label: '1326',
  //         onChanged: (p0) {
  //           String contactCode = p0 as String;
  //           contactSelectedCode = contactCode;
  //         }),
  //   );
  // }
  final List<String> _headerLstStr = [
    '122',
    '125',
    '184',
    '123',
    '90',
    '133',
    '3510',
    '3829',
    '124',
    '62',
  ];
  final List<String> _headerLstStrIsViewDetail = [
    '122',
    '125',
    '184',
    '123',
    '128',
    '131',
    '132',
    '90',
    '133',
    '3510',
    '3829',
    '124',
    '62',
  ];
  Widget _buildTable({required List<CustomerOOSRes> oosList}) {
    return oosList.isEmpty
        ? ValueListenableBuilder(
            builder: (context, value, child) {
              return TableView(
                  headerChildren: _viewDetailNotifier.value
                      ? _headerLstStrIsViewDetail
                      : _headerLstStr,
                  rowChildren: const []);
            },
            valueListenable: _viewDetailNotifier,
          )
        : TableDataWidget(
            listTableRowHeader: _headerTable(),
            listTableRowContent: oosList.isEmpty
                ? []
                : List.generate(oosList.length, (index) {
                    final item = oosList[index];
                    return InkWell(
                      onTap: () {
                        _navigationService.pushNamed(
                            routes.customerOOSDetailRoute,
                            args: {key_params.orderIdOOS: item.ordeId});
                      },
                      child: ColoredBox(
                        color: colorRowTable(
                            index: index,
                            color: colors.defaultColor.withOpacity(0.2)),
                        child: Row(children: [
                          CellTableWidget(
                            width: 150,
                            content: item.clientRefNo.toString(),
                          ),
                          CellTableWidget(
                            width: 210,
                            content: FileUtils.convertDateForHistoryDetailItem(
                                item.receiptDate.toString()),
                          ),
                          CellTableWidget(
                            width: 210,
                            content: FileUtils.convertDateForHistoryDetailItem(
                                item.etd.toString()),
                          ),
                          CellTableWidget(
                            width: 150,
                            content: item.orderTypeDesc.toString(),
                          ),
                          ValueListenableBuilder(
                              valueListenable: _viewDetailNotifier,
                              builder: (context, value, child) {
                                if (value != false) {
                                  return Row(
                                    children: [
                                      CellTableWidget(
                                          width: 120,
                                          content: item.itemCode ?? ''),
                                      CellTableWidget(
                                          width: 250,
                                          content: item.itemDesc ?? ''),
                                      CellTableWidget(
                                          width: 100,
                                          content: item.grade ?? ''),
                                    ],
                                  );
                                }
                                return const SizedBox();
                              }),
                          CellTableWidget(
                              width: 100, content: item.dcCode ?? ''),
                          CellTableWidget(
                              width: 100,
                              content:
                                  item.qty == null ? '' : item.qty.toString()),
                          CellTableWidget(
                              width: 100,
                              content: item.giQty == null
                                  ? ''
                                  : item.giQty.toString()),
                          CellTableWidget(
                              width: 210,
                              content: item.codAmount == null
                                  ? ''
                                  : item.codAmount.toString()),
                          CellTableWidget(
                              width: 210,
                              content: item.ordStatusName == null
                                  ? ''
                                  : item.ordStatusName.toString()),
                          CellTableWidget(
                              width: 210,
                              content: item.createDate == null
                                  ? ''
                                  : FileUtils.convertDateForHistoryDetailItem(
                                      item.createDate.toString())),
                        ]),
                      ),
                    );
                  }));
  }

  // Widget _buildBtnSearch() {
  //   return Padding(
  //     padding: EdgeInsets.all(8.w),
  //     child: ElevatedButtonWidget(
  //         onPressed: () {
  //           BlocProvider.of<CustomerOOSBloc>(context).add(CustomerOOSSearch(
  //               customerBloc: customerBloc,
  //               orderNo: _orderNoController.text,
  //               orderStatus: orderStatusSelected ?? GetStdCodeRes(),
  //               dateTypeSearch: outboundDateserSelected ?? GetStdCodeRes(),
  //               fromDate: FileUtils.formatToStringFromDatetime(fromDate),
  //               toDate: FileUtils.formatToStringFromDatetime(toDate),
  //               dc: dcSelected ?? UserDCResult(),
  //               isViewDetail: _viewDetailNotifier.value ? "1" : "0",
  //               contactCode: contactSelectedCode ?? ''));
  //           Navigator.of(context).pop();
  //         },
  //         text: '36'),
  //   );
  // }

  // Widget _buildDCViewDetail({required List<UserDCResult> lstDC}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 3,
  //           child: DropdownButtonFormField2(
  //             menuItemStyleData:
  //                 MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
  //               return ColoredBox(
  //                 color: colors.defaultColor.withOpacity(0.2),
  //                 child: child,
  //               );
  //             }),
  //             dropdownStyleData: DropdownStyleData(
  //                 decoration:
  //                     BoxDecoration(borderRadius: BorderRadius.circular(16.r))),
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
  //               valueListenable: _viewDetailNotifier,
  //               builder: (context, value, child) => CheckboxListTile(
  //                 visualDensity:
  //                     const VisualDensity(horizontal: -4, vertical: -4),
  //                 title: Text('5275'.tr()),
  //                 value: value,
  //                 onChanged: (value) {
  //                   _viewDetailNotifier.value = value;
  //                 },
  //                 controlAffinity: ListTileControlAffinity.leading,
  //               ),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFromToDate() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
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

  // Widget _buildOrderStatus({
  //   required List<GetStdCodeRes> lstOrdStatus,
  //   required List<GetStdCodeRes> lstOutboundDateser,
  // }) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //             child: CustomerSTDCodeDropdown(
  //                 value: orderStatusSelected,
  //                 onChanged: (p0) {
  //                   orderStatusSelected = p0 as GetStdCodeRes;
  //                 },
  //                 label: '124',
  //                 listSTD: lstOrdStatus)),
  //         const SizedBox(
  //           width: 8,
  //         ),
  //         Expanded(
  //             child: CustomerSTDCodeDropdown(
  //                 value: outboundDateserSelected,
  //                 onChanged: (p0) {
  //                   outboundDateserSelected = p0 as GetStdCodeRes;
  //                 },
  //                 label: '',
  //                 listSTD: lstOutboundDateser)),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildOrderNo() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     child: TextFormField(
  //       controller: _orderNoController,
  //       decoration: InputDecoration(label: Text('122'.tr())),
  //     ),
  //   );
  // }

  List<Widget> _headerTable() {
    return [
      const HeaderTable2Widget(label: '122', width: 150),
      const HeaderTable2Widget(label: '125', width: 210),
      const HeaderTable2Widget(label: '184', width: 210),
      const HeaderTable2Widget(label: '123', width: 150),
      _headerTableDetail(const HeaderTable2Widget(label: '128', width: 120)),
      _headerTableDetail(const HeaderTable2Widget(label: '131', width: 250)),
      _headerTableDetail(const HeaderTable2Widget(label: '132', width: 100)),
      const HeaderTable2Widget(label: '90', width: 100),
      const HeaderTable2Widget(label: '133', width: 100),
      const HeaderTable2Widget(label: '3510', width: 100),
      const HeaderTable2Widget(label: '3829', width: 210),
      const HeaderTable2Widget(label: '124', width: 210),
      const HeaderTable2Widget(label: '62', width: 210),
    ];
  }

  Widget _headerTableDetail(Widget headerTable) {
    return ValueListenableBuilder(
      valueListenable: _viewDetailNotifier,
      builder: (context, value, child) {
        if (value != false) {
          return headerTable;
        }
        return const SizedBox.shrink();
      },
    );
  }
}
