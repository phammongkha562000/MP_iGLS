import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_order_status/transport_order_status/transport_order_status_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/company_res.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_req.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_order_status/transport_order_status_res.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/admin_component/cell_table.dart';
import 'package:igls_new/presentations/widgets/admin_component/header_table.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';

import '../../../../../data/services/services.dart';

class CustomerTOSView extends StatefulWidget {
  const CustomerTOSView({super.key, required this.content});
  final CustomerTOSReq content;
  @override
  State<CustomerTOSView> createState() => _CustomerTOSViewState();
}

class _CustomerTOSViewState extends State<CustomerTOSView> {
  final _navigationService = getIt<NavigationService>();

  late CustomerBloc customerBloc;
  late CustomerTOSBloc oosBloc;

  CustomerCompanyRes? pickSelected;
  CustomerCompanyRes? shipSelected;
  GetStdCodeRes? orderStatusSelected;
  UserDCResult? dcSelected;

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime toDate = DateTime.now();

  String? contactSelected;

  ValueNotifier<List<CustomerCompanyRes>> companyLst = ValueNotifier([]);
  ValueNotifier<List<UserDCResult>> lstDC = ValueNotifier([]);
  ValueNotifier<List<GetStdCodeRes>> lstOrdStatus = ValueNotifier([]);
  List<String> lstContact = [];
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    oosBloc = BlocProvider.of<CustomerTOSBloc>(context);
    oosBloc.add(CustomerTOSViewLoaded(
        customerBloc: customerBloc, content: widget.content));
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';

    lstDC.value = customerBloc.cusPermission?.userDCResult ?? [];
    dcSelected = lstDC.value.isNotEmpty
        ? lstDC.value
            .where((element) =>
                element.dCCode ==
                customerBloc.userLoginRes?.userInfo?.defaultCenter)
            .single
        : UserDCResult();
    _fromDateController.text = FileUtils.formatToStringFromDatetime2(fromDate);
    _toDateController.text = FileUtils.formatToStringFromDatetime2(toDate);

    lstContact = customerBloc.contactList!.map((e) => e.clientId!).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(title: Text('4183'.tr())),
        body: BlocConsumer<CustomerTOSBloc, CustomerTOSState>(
            listener: (context, state) {
          if (state is CustomerTOSFailure) {
            CustomDialog().error(context, err: state.message);
          }
        }, builder: (context, state) {
          if (state is CustomerTOSSuccess) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
              ),
              child: Column(children: [
                /* (state.lstTOS.isEmpty)
                    ? _buildTableNoData()
                    :  */
                _buildTable(tosList: state.lstTOS),
              ]),
            );
          }
          return const ItemLoading();
        }));
  }

  Widget _buildTable({required List<CustomerTOSRes> tosList}) {
    double sumCOD = 0;
    for (var element in tosList) {
      sumCOD += element.codAmount ?? 0;
    }
    return tosList.isEmpty
        ? TableView(headerChildren: _headerLstStr, rowChildren: const [])
        : TableDataWidget(
            listTableRowHeader: _headerTable(),
            listTableRowContent: [
                ...List.generate(tosList.length, (index) {
                  final item = tosList[index];
                  return InkWell(
                    onTap: () {
                      _navigationService
                          .pushNamed(routes.customerTOSDetailRoute, args: {
                        key_params.orderIdTOS: item.ordeId,
                        key_params.tripNoTOS: item.tripNo,
                        key_params.deliveryModeTOS: item.deliveryMode
                      });
                    },
                    child: ColoredBox(
                      color: colorRowTable(
                          index: index,
                          color: colors.defaultColor.withOpacity(0.2)),
                      child: Row(children: [
                        CellTableWidget(
                          width: 200,
                          content: item.clientRefNo ?? '',
                        ),
                        CellTableWidget(
                          width: 200,
                          content: item.deliveryMode ?? '',
                        ),
                        CellTableWidget(
                            width: 200,
                            content: FileUtils.convertDateForHistoryDetailItem(
                                item.etp.toString())),
                        CellTableWidget(
                          width: 200,
                          isAlignLeft: true,
                          content: item.shipToName.toString(),
                        ),
                        CellTableWidget(
                          width: 200,
                          content: item.orderTypeDesc ?? '',
                        ),
                        CellTableWidget(
                          width: 200,
                          content: item.tripNo ?? '',
                        ),
                        CellTableWidget(
                          width: 200,
                          content: item.equipmentCode ?? "",
                        ),
                        SizedBox(
                          width: 200,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            margin: EdgeInsets.symmetric(horizontal: 32.w),
                            decoration: BoxDecoration(
                              color: _colorStatus(
                                  status: item.ordStatusName ?? ''),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(item.ordStatusName ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        CellTableWidget(
                          width: 200,
                          content: item.codAmount.toString(),
                        ),
                        CellTableWidget(
                            width: 200,
                            content: FileUtils.convertDateForHistoryDetailItem(
                                item.createDate.toString())),
                        CellTableWidget(
                          width: 200,
                          content: item.atp != null
                              ? FileUtils.convertDateForHistoryDetailItem(
                                  item.atp.toString())
                              : '',
                        ),
                        CellTableWidget(
                          width: 200,
                          content: item.atd != null
                              ? FileUtils.convertDateForHistoryDetailItem(
                                  item.atd.toString())
                              : '',
                        ),
                        CellTableWidget(
                            width: 200,
                            content: item.ata != null
                                ? FileUtils.convertDateForHistoryDetailItem(
                                    item.ata.toString())
                                : ''),
                        CellTableWidget(
                          width: 200,
                          content: item.weight != null ? '${item.weight}' : '',
                        ),
                        CellTableWidget(
                          width: 200,
                          content:
                              item.volume != null ? item.volume.toString() : '',
                        ),
                        CellTableWidget(
                          width: 200,
                          content: item.qty.toString(),
                        ),
                      ]),
                    ),
                  );
                }),
                ColoredBox(
                  color: Colors.amber,
                  child: Row(children: [
                    CellTableWidget(
                      width: 200,
                      content: '${'1284'.tr()}: ${tosList.length}',
                      isBold: true,
                    ),
                    const CellTableWidget(
                      width: 200,
                      content: '',
                    ),
                    const CellTableWidget(width: 200, content: ''),
                    const CellTableWidget(
                      width: 200,
                      isAlignLeft: true,
                      content: '',
                    ),
                    const CellTableWidget(
                      width: 200,
                      content: '',
                    ),
                    const CellTableWidget(
                      width: 200,
                      content: '',
                    ),
                    const CellTableWidget(
                      width: 200,
                      content: "",
                    ),
                    const CellTableWidget(
                      width: 200,
                      content: '',
                    ),
                    CellTableWidget(
                      width: 200,
                      content: '${'5369'.tr()} COD: $sumCOD',
                      isBold: true,
                    ),
                    const CellTableWidget(width: 200, content: ''),
                    const CellTableWidget(
                      width: 200,
                      content: '',
                    ),
                    const CellTableWidget(
                      width: 200,
                      content: '',
                    ),
                    const CellTableWidget(width: 200, content: ''),
                    const CellTableWidget(width: 200, content: ''),
                    const CellTableWidget(width: 200, content: ''),
                    const CellTableWidget(width: 200, content: ''),
                  ]),
                ),
              ]);
  }

  final List<String> _headerLstStr = [
    '4297',
    '5370',
    '5586',
    '2482',
    '123',
    '2468',
    '1298',
    '2489',
    '5371',
    '62',
    '4057',
    '4056',
    '3574',
    '149',
    '151',
    '133',
  ];
  // Widget _buildTableNoData() {
  //   return TableNoDataWidget(
  //     listTableRow: [
  //       TableRow(children: _headerTable()),
  //       TableRow(children: [
  //         const SizedBox(),
  //         const SizedBox(),
  //         _buildTextNoData(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //         const SizedBox(),
  //       ]),
  //     ],
  //   );
  // }

  // Widget _buildTextNoData() {
  //   return SizedBox(
  //     child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
  //         child: Text(
  //           "5058".tr().toUpperCase(),
  //           maxLines: 2,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(color: Colors.grey),
  //         )),
  //   );
  // }

  List<Widget> _headerTable() {
    return const [
      HeaderTable2Widget(label: '4297', width: 200),
      HeaderTable2Widget(label: '5370', width: 200),
      HeaderTable2Widget(label: '5586', width: 200),
      HeaderTable2Widget(label: '2482', width: 200),
      HeaderTable2Widget(label: '123', width: 200),
      HeaderTable2Widget(label: '2468', width: 200),
      HeaderTable2Widget(label: '1298', width: 200),
      HeaderTable2Widget(label: '2489', width: 200),
      HeaderTable2Widget(label: '5371', width: 200),
      HeaderTable2Widget(label: '62', width: 200),
      HeaderTable2Widget(label: '4057', width: 200),
      HeaderTable2Widget(label: '4056', width: 200),
      HeaderTable2Widget(label: '3574', width: 200),
      HeaderTable2Widget(label: '149', width: 200),
      HeaderTable2Widget(label: '151', width: 200),
      HeaderTable2Widget(label: '133', width: 200),
    ];
  }

  // Widget _buildTFF(
  //     {required TextEditingController controller, required String label}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     child: TextFormField(
  //       controller: controller,
  //       decoration: InputDecoration(label: Text(label.tr())),
  //     ),
  //   );
  // }

  Color _colorStatus({required String status}) {
    Color colorStatus = Colors.white;
    switch (status) {
      case 'Confirmed':
        colorStatus = const Color(0xff616161);
        break;

      case 'Completed':
        colorStatus = const Color(0xff00a65a);
        break;
      case 'Planed':
        colorStatus = const Color(0xfff39c12);
        break;
      case 'Start Delivery':
        colorStatus = const Color(0xff00c0ef);
        break;
      case 'Pickup Arrival':
        colorStatus = const Color(0xff428bca);
        break;
      default:
    }
    return colorStatus;
  }
}
