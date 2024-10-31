import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import 'package:rxdart/rxdart.dart';

import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/inbound_order_status/inbound_order_status/inbound_order_status_bloc.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../../data/models/customer/contract_logistics/inbound_order_status/get_inbound_order_req.dart';
import '../../../../../data/models/customer/contract_logistics/inbound_order_status/get_inbound_order_res.dart';
import '../../../../../data/services/injection/injection_igls.dart';
import '../../../../../data/services/navigator/navigation_service.dart';
import '../../../../../data/shared/utils/file_utils.dart';
import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/admin_component/header_table.dart';
import '../../../../widgets/app_bar_custom.dart';
import '../../../../widgets/table_widget/table_data.dart';

class InboundOrderStatusView extends StatefulWidget {
  const InboundOrderStatusView({
    super.key,
    required this.model,
  });
  final GetInboundOrderReq model;
  @override
  State<InboundOrderStatusView> createState() => _InboundOrderStatusViewState();
}

class _InboundOrderStatusViewState extends State<InboundOrderStatusView> {
  // final _orderNoController = TextEditingController();
  final _navigationService = getIt<NavigationService>();
  late CustomerBloc customerBloc;
  late CustomerIOSBloc iosBloc;
  final ValueNotifier _viewDetailNotifier = ValueNotifier(false);
  // final fromDateCtrl = TextEditingController(
  //     text: FileUtils.formatToStringFromDatetime2(
  //         DateTime.now().subtract(const Duration(days: 1))));
  // final toDateCtrl = TextEditingController(
  //     text: FileUtils.formatToStringFromDatetime2(DateTime.now()));
  final BehaviorSubject<List<GetInboundOrderRes>> lstInoundCtrl =
      BehaviorSubject<List<GetInboundOrderRes>>();
  // ValueNotifier<List<GetStdCodeRes>> lstOrdStatus = ValueNotifier([]);
  // ValueNotifier<List<GetStdCodeRes>> lstInboundDateser = ValueNotifier([]);
  // ValueNotifier<List<UserDCResult>> lstDC = ValueNotifier([]);
  // ValueNotifier inboundDateserSelected = ValueNotifier(GetStdCodeRes());
  // DateTime fromDate = DateTime.now().subtract(const Duration(days: 1));
  // DateTime toDate = DateTime.now();

  // GetStdCodeRes? orderStatusSelected;
  // UserDCResult? dcSelected;
  // String? contactSelected;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    iosBloc = BlocProvider.of<CustomerIOSBloc>(context)
      ..add(CustomerGetInboundOrder(
          model: widget.model,
          subsidiaryId:
              customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
    // contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarCustom(
          title: Text('236'.tr()),
        ),
        body: BlocConsumer<CustomerIOSBloc, CustomerIOSState>(
            listener: (context, state) {
          if (state is CustomerIOSLoaded) {
            // lstOrdStatus.value = state.lstOrdStatus;
            // lstInboundDateser.value = state.lstInboundDateser;
            // lstDC.value = state.lstDC;

            // if (state.lstInboundDateser.isNotEmpty) {
            //   inboundDateserSelected.value = state.lstInboundDateser
            //       .where((element) => element.codeID == 'ETA')
            //       .first;
            // }
            // UserInfo userInfo =
            //     customerBloc.userLoginRes?.userInfo ?? UserInfo();
            // iosBloc.add(CustomerGetInboundOrder(
            //     subsidiaryId: userInfo.subsidiaryId ?? '',
            //     model: GetInboundOrderReq(
            //         contactCode: contactSelected ?? '',
            //         dcNo: userInfo.defaultCenter ?? '',
            //         dateF: FileUtils.formatToStringFromDatetime(fromDate),
            //         dateT: FileUtils.formatToStringFromDatetime(toDate),
            //         dateTypeSearch: inboundDateserSelected.value.codeDesc ?? '',
            // _viewDetailNotifier.value =
            //     widget.model.isViewDetail == '1' ? true : false;
            //         orderNo: _orderNoController.text,
            //         orderStatus: orderStatusSelected?.codeDesc ?? '')));
          }
          if (state is CustomerIOSLoadedFail) {
            CustomDialog().error(context, err: state.message, btnOkOnPress: () {
              Navigator.pop(context);
            });
          }
          if (state is GetInboundOrderSuccess) {
            _viewDetailNotifier.value =
                widget.model.isViewDetail == '1' ? true : false;
            lstInoundCtrl.add(state.lstInboundOrder);
          }
          if (state is GetInboundOrderFail) {
            CustomDialog()
                .error(context, err: state.message, btnOkOnPress: () {});
          }
        }, builder: (context, state) {
          if (state is ShowLoadingState) {
            return const Center(child: ItemLoading());
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  _buildListInbound(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // _buildOrderNo() => Padding(
  //       padding: EdgeInsets.symmetric(vertical: 8.0.h),
  //       child: TextFormField(
  //         controller: _orderNoController,
  //         decoration: InputDecoration(label: Text('122'.tr())),
  //       ),
  //     );

  // _buildOrderStatus() => Padding(
  //       padding: EdgeInsets.symmetric(vertical: 8.0.h),
  //       child: Row(children: [
  //         Expanded(
  //             child: ValueListenableBuilder(
  //           valueListenable: lstOrdStatus,
  //           builder: (context, value, child) {
  //             return CustomerSTDCodeDropdown(
  //                 value: value.isNotEmpty
  //                     ? orderStatusSelected ?? value[0]
  //                     : GetStdCodeRes(),
  //                 onChanged: (p0) {
  //                   orderStatusSelected = p0 as GetStdCodeRes;
  //                 },
  //                 label: '124',
  //                 listSTD: value);
  //           },
  //         )),
  //         SizedBox(
  //           width: 8.w,
  //         ),
  //         Expanded(
  //             child: ValueListenableBuilder(
  //           valueListenable: lstInboundDateser,
  //           builder: (context, value, child) {
  //             return CustomerSTDCodeDropdown(
  //                 value: value.isNotEmpty
  //                     ? inboundDateserSelected.value ?? value[0]
  //                     : GetStdCodeRes(),
  //                 onChanged: (p0) {
  //                   inboundDateserSelected.value = p0 as GetStdCodeRes;
  //                 },
  //                 label: '',
  //                 listSTD: value);
  //           },
  //         )),
  //       ]),
  //     );

  // _buildFromToDate() => Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.0.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //             child: GestureDetector(
  //           onTap: () {
  //             pickDate(
  //                 date: fromDate,
  //                 context: context,
  //                 function: (selectDate) {
  //                   fromDateCtrl.text =
  //                       FileUtils.formatToStringFromDatetime2(selectDate);
  //                   fromDate = selectDate;
  //                 });
  //           },
  //           child: TextFormField(
  //             controller: fromDateCtrl,
  //             enabled: false,
  //             decoration: InputDecoration(
  //                 suffixIcon: const Icon(Icons.calendar_month),
  //                 label: Text('5273'.tr())),
  //           ),
  //         )),
  //         const SizedBox(
  //           width: 8,
  //         ),
  //         Expanded(
  //             child: GestureDetector(
  //           onTap: () {
  //             pickDate(
  //                 date: toDate,
  //                 context: context,
  //                 function: (selectDate) {
  //                   toDateCtrl.text =
  //                       FileUtils.formatToStringFromDatetime2(selectDate);
  //                   toDate = selectDate;
  //                 });
  //           },
  //           child: TextFormField(
  //             controller: toDateCtrl,
  //             enabled: false,
  //             decoration: InputDecoration(
  //                 suffixIcon: const Icon(Icons.calendar_month),
  //                 label: Text('5274'.tr())),
  //           ),
  //         )),
  //       ],
  //     ));

  // _buildDC() => Padding(
  //       padding: EdgeInsets.symmetric(vertical: 8.0.h),
  //       child: Row(
  //         children: [
  //           Expanded(
  //               flex: 3,
  //               child: ValueListenableBuilder(
  //                   valueListenable: lstDC,
  //                   builder: (context, value, child) {
  //                     return DropdownButtonFormField2(
  //                       value: value.isNotEmpty
  //                           ? dcSelected ?? value[0]
  //                           : UserDCResult(),
  //                       isExpanded: true,
  //                       decoration: InputDecoration(
  //                         label: Text('90'.tr()),
  //                       ),
  //                       dropdownStyleData: DropdownStyleData(
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(16))),
  //                       menuItemStyleData: MenuItemStyleData(
  //                           selectedMenuItemBuilder: (context, child) {
  //                         return ColoredBox(
  //                           color: colors.defaultColor.withOpacity(0.2),
  //                           child: child,
  //                         );
  //                       }),
  //                       onChanged: (value) {
  //                         dcSelected = value as UserDCResult;
  //                       },
  //                       selectedItemBuilder: (context) {
  //                         return value.map((e) {
  //                           return Text(
  //                             e.dCDesc ?? '',
  //                             overflow: TextOverflow.ellipsis,
  //                             maxLines: 1,
  //                           );
  //                         }).toList();
  //                       },
  //                       items: value.map<DropdownMenuItem<UserDCResult>>(
  //                           (UserDCResult value) {
  //                         return DropdownMenuItem<UserDCResult>(
  //                           value: value,
  //                           child: Text(
  //                             value.dCDesc.toString(),
  //                             overflow: TextOverflow.ellipsis,
  //                             maxLines: 1,
  //                           ),
  //                         );
  //                       }).toList(),
  //                     );
  //                   })),
  //           Expanded(
  //               flex: 2,
  //               child: ValueListenableBuilder(
  //                 valueListenable: _viewDetailNotifier,
  //                 builder: (context, value, child) => CheckboxListTile(
  //                   visualDensity:
  //                       const VisualDensity(horizontal: -4, vertical: -4),
  //                   title: Text('5275'.tr()),
  //                   value: value,
  //                   onChanged: (value) {
  //                     _viewDetailNotifier.value = value;
  //                   },
  //                   controlAffinity: ListTileControlAffinity.leading,
  //                 ),
  //               ))
  //         ],
  //       ),
  //     );
  // _buildContractCode() => Padding(
  //       padding: EdgeInsets.symmetric(vertical: 8.0.w),
  //       child: CustomerContactDropdown(
  //           lstContact: [...customerBloc.contactList!.map((e) => e.clientId!)],
  //           value: contactSelected,
  //           label: '1326',
  //           onChanged: (p0) {
  //             String contactCode = p0 as String;
  //             contactSelected = contactCode;
  //             UserInfo userInfo =
  //                 customerBloc.userLoginRes?.userInfo ?? UserInfo();
  //             iosBloc.add(CustomerGetInboundOrder(
  //                 subsidiaryId: userInfo.subsidiaryId ?? '',
  //                 model: GetInboundOrderReq(
  //                     contactCode: contactSelected ?? '',
  //                     dcNo: userInfo.defaultCenter ?? '',
  //                     dateF: FileUtils.formatToStringFromDatetime(fromDate),
  //                     dateT: FileUtils.formatToStringFromDatetime(toDate),
  //                     dateTypeSearch:
  //                         inboundDateserSelected.value.codeDesc ?? '',
  //                     isViewDetail:
  //                         _viewDetailNotifier.value == true ? "1" : "0",
  //                     orderNo: _orderNoController.text,
  //                     orderStatus: orderStatusSelected?.codeDesc ?? '')));
  //           }),
  //     );
  // _buildBtnSearch() => Padding(
  //       padding: EdgeInsets.all(8.0.w),
  //       child: ElevatedButtonWidget(
  //           onPressed: () {
  //             UserInfo userInfo =
  //                 customerBloc.userLoginRes?.userInfo ?? UserInfo();
  //             iosBloc.add(CustomerGetInboundOrder(
  //                 subsidiaryId: userInfo.subsidiaryId ?? '',
  //                 model: GetInboundOrderReq(
  //                     contactCode: contactSelected ?? '',
  //                     dcNo: userInfo.defaultCenter ?? '',
  //                     dateF: FileUtils.formatToStringFromDatetime(fromDate),
  //                     dateT: FileUtils.formatToStringFromDatetime(toDate),
  //                     dateTypeSearch:
  //                         inboundDateserSelected.value.codeDesc ?? '',
  //                     isViewDetail:
  //                         _viewDetailNotifier.value == true ? "1" : "0",
  //                     orderNo: _orderNoController.text,
  //                     orderStatus: orderStatusSelected?.codeDesc ?? '')));
  //             Navigator.pop(context);
  //           },
  //           text: '36'),
  //     );

  _buildListInbound() => StreamBuilder<List<GetInboundOrderRes>>(
      stream: lstInoundCtrl.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            return TableDataWidget(
                listTableRowHeader: _headerTable(),
                listTableRowContent:
                    List.generate(snapshot.data!.length, (index) {
                  final item = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      _navigationService.pushNamed(
                        routes.customerIOSDetailRoute,
                        args: {
                          key_params.orderId: item.ordeId,
                        },
                      );
                    },
                    child: ColoredBox(
                      color: colorRowTable(index: index),
                      child: Row(children: [
                        CellTableWidget(
                          width: 150.w,
                          content: item.clientRefNo ?? '',
                        ),
                        CellTableWidget(
                          width: 210.w,
                          content: FileUtils.convertDateForHistoryDetailItem(
                              item.receiptDate ?? ''),
                        ),
                        CellTableWidget(
                          width: 210.w,
                          content: FileUtils.convertDateForHistoryDetailItem(
                              item.eTA ?? ''),
                        ),
                        CellTableWidget(
                          width: 150.w,
                          content: item.orderTypeDesc ?? '',
                        ),
                        CellTableWidget(
                          width: 120.w,
                          content: item.ordStatusName ?? '',
                        ),
                        ValueListenableBuilder(
                            valueListenable: _viewDetailNotifier,
                            builder: (context, value, child) {
                              if (value != false) {
                                return Row(
                                  children: [
                                    CellTableWidget(
                                      width: 120.w,
                                      content: item.itemCode ?? '',
                                    ),
                                    CellTableWidget(
                                      width: 250.w,
                                      content: item.itemDesc ?? '',
                                    ),
                                    CellTableWidget(
                                      width: 100.w,
                                      content: item.grade ?? '',
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox();
                            }),
                        CellTableWidget(
                          width: 100.w,
                          content: item.dCCode ?? '',
                        ),
                        CellTableWidget(
                          width: 150.w,
                          content: item.qty.toString(),
                        ),
                        CellTableWidget(
                            width: 150.w, content: item.gRQty.toString()),
                        CellTableWidget(
                          width: 210.w,
                          content: FileUtils.convertDateForHistoryDetailItem(
                              item.createDate.toString()),
                        ),
                      ]),
                    ),
                  );
                }));
          }
          return TableView(
              headerChildren: _viewDetailNotifier.value
                  ? _headerLstStrIsViewDetail
                  : _headerLstStr,
              rowChildren: const []); 
        }
        return TableDataWidget(
            listTableRowHeader: _headerTable(), listTableRowContent: const []);
      });
  final List<String> _headerLstStrIsViewDetail = [
    '122',
    '125',
    '164',
    '123',
    '124',
    '128',
    '131',
    '132',
    '1297',
    '133',
    '178',
    '62',
  ];
  final List<String> _headerLstStr = [
    '122',
    '125',
    '164',
    '123',
    '124',
    '1297',
    '133',
    '178',
    '62',
  ];
  List<Widget> _headerTable() {
    return [
      HeaderTable2Widget(label: '122', width: 150.w),
      HeaderTable2Widget(label: '125', width: 210.w),
      HeaderTable2Widget(label: '164', width: 210.w),
      HeaderTable2Widget(label: '123', width: 150.w),
      HeaderTable2Widget(label: '124', width: 120.w),
      _headerTableDetail(HeaderTable2Widget(label: '128', width: 120.w)),
      _headerTableDetail(HeaderTable2Widget(label: '131', width: 250.w)),
      _headerTableDetail(HeaderTable2Widget(label: '132', width: 100.w)),
      HeaderTable2Widget(label: '1297', width: 100.w),
      HeaderTable2Widget(label: '133', width: 150.w),
      HeaderTable2Widget(label: '178', width: 150.w),
      HeaderTable2Widget(label: '62', width: 210.w),
    ];
  }

  Widget _headerTableDetail(Widget headerTable) {
    return ValueListenableBuilder(
      valueListenable: _viewDetailNotifier,
      builder: (context, value, child) {
        if (value != false) {
          return headerTable;
        }
        return const SizedBox();
      },
    );
  }
}
