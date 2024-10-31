import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import 'package:rxdart/rxdart.dart';

import 'package:igls_new/data/models/customer/global_visibility/cntr_haulage/get_cntr_haulage_res.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../../data/models/customer/global_visibility/track_and_trace/get_unloc_res.dart';
import '../../../../../data/services/injection/injection_igls.dart';
import '../../../../../data/services/navigator/navigation_service.dart';
import '../../../../../data/shared/utils/file_utils.dart';
import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/app_bar_custom.dart';
import '../../../../widgets/table_widget/header_table.dart';
import '../../../../widgets/table_widget/table_data.dart';

class CNTRHaulageView extends StatefulWidget {
  const CNTRHaulageView({
    super.key,
    required this.model,
  });
  final GetCntrHaulageReq model;
  @override
  State<CNTRHaulageView> createState() => _CNTRHaulageViewState();
}

class _CNTRHaulageViewState extends State<CNTRHaulageView> {
  final masterBlCtrl = TextEditingController();
  final houseBlCtrl = TextEditingController();
  final carrierBcNoCtrl = TextEditingController();
  final cntrNoCtrl = TextEditingController();
  final itemCodeCtrl = TextEditingController();
  final invNoCtrl = TextEditingController();
  final cdNoCtrl = TextEditingController();
  final poNoCtrl = TextEditingController();
  TextEditingController fromDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(
          DateTime.now().subtract(const Duration(days: 1))));
  DateTime fromDateFormat = DateTime.now().subtract(const Duration(days: 1));
  TextEditingController toDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(DateTime.now()));
  DateTime toDateFormat = DateTime.now();

  final podCtrl = TextEditingController();
  final polCtrl = TextEditingController();
  ValueNotifier<List<TradeType>> lstTradeType = ValueNotifier([]);
  ValueNotifier<List<Status>> lstStatus = ValueNotifier([]);
  ValueNotifier<List<DayType>> lstDayType = ValueNotifier([]);
  DayType? dayTypeSelected;
  ValueNotifier<List<GetUnlocResult>> lstUnlocPod = ValueNotifier([]);
  ValueNotifier<List<GetUnlocResult>> lstUnlocPol = ValueNotifier([]);
  TradeType? tradeTypeSelected;
  Status? statusSelected;
  GetUnlocResult? unblocPodSelected;
  GetUnlocResult? unblocPolSelected;
  late CntrHaulageBloc cntrHaulageBloc;
  late CustomerBloc customerBloc;
  BehaviorSubject<List<GetCntrHaulageRes>> lstCntrHaulageCtrl =
      BehaviorSubject<List<GetCntrHaulageRes>>();
  final _navigationService = getIt<NavigationService>();
  String? contactSelected;
  List<WidgetFilter> lstWidget = [];
  List<WidgetFilter> lstWidgetFilter = [];
  // final ValueNotifier<List<WidgetFilter>> _lstNotifier =
  //     ValueNotifier<List<WidgetFilter>>([]);
  bool isChecked = false;
//21/03/2024

  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    cntrHaulageBloc = BlocProvider.of<CntrHaulageBloc>(context)
      ..add(CntrHaulageLoad(
          model: widget.model,
          strCompany: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBarCustom(
              title: Text('4265'.tr()),
            ),
            body: BlocConsumer<CntrHaulageBloc, CntrHaulageState>(
                listener: (context, state) {
              if (state is GetCntrHaulageSuccess) {
                lstCntrHaulageCtrl.add(state.lstCntrHaulage);
              }
              if (state is GetCntrHaulageFail) {
                CustomDialog()
                    .error(context, err: state.message, btnOkOnPress: () {});
              }
              if (state is CntrHaulageLoadFail) {
                CustomDialog().error(context, err: state.message,
                    btnOkOnPress: () {
                  Navigator.pop(context);
                });
              }
            }, builder: (context, state) {
              if (state is CntrHaulageLoading) {
                return const ItemLoading();
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.w,
                  ),
                  child: Column(children: [
                    buildLstCntrHaulage(
                        lstCNTRHaulage: lstCntrHaulageCtrl.hasValue
                            ? lstCntrHaulageCtrl.value
                            : [])
                  ]),
                );
              }
            })));
  }

  buildLstCntrHaulage({required List<GetCntrHaulageRes> lstCNTRHaulage}) =>
      lstCNTRHaulage.isEmpty
          ? TableView(headerChildren: _headerLstStr(), rowChildren: const [])
          : TableDataWidget(
              listTableRowHeader: _headerTable(),
              listTableRowContent:
                  List.generate(lstCNTRHaulage.length, (index) {
                final item = lstCNTRHaulage[index];
                return ColoredBox(
                  color: colorRowTable(index: index),
                  child: Row(children: [
                    CellTableWidget(width: 150.w, content: item.bLNo ?? ''),
                    CellTableWidget(
                        width: 150.w,
                        content: item.tradeType != null
                            ? item.tradeType == "I"
                                ? "5079".tr()
                                : "5080".tr()
                            : ""),
                    CellTableWidget(
                        width: 200.w, content: item.carrierBCNo ?? ''),
                    CellTableWidget(width: 150.w, content: item.cNTRType ?? ''),
                    CellTableWidget(
                      width: 180.w,
                      content: item.cNTRNo ?? '',
                      onTap: () {
                        _navigationService.navigateAndDisplaySelection(
                            routes.customerCNTRHaulageDetailRoute,
                            args: {
                              key_params.woNo: item.wONo,
                              key_params.woItemNo: item.wOItemNo,
                              key_params.statusCntrHaulage:
                                  item.workOrderStatus,
                              key_params.cusBLCarrier: item.tradeType == 'I'
                                  ? item.bLNo
                                  : item.carrierBCNo
                            });
                      },
                    ),
                    CellTableWidget(width: 150.w, content: item.cDNo ?? ''),
                    CellTableWidget(
                        width: 150.w,
                        content: FileUtils.convertDateForHistoryDetailItem(
                            item.cDComplete ?? '')),
                    CellTableWidget(
                        width: 150.w, content: item.pickTractor ?? ''),
                    CellTableWidget(
                        width: 210.w,
                        content: FileUtils.convertDateForHistoryDetailItem(
                            item.pickUpEndPlan ?? '')),
                    CellTableWidget(
                        width: 200.w,
                        content: FileUtils.convertDateForHistoryDetailItem(
                            item.pickUpEndActual ?? '')),
                    CellTableWidget(
                        width: 150.w, content: item.deliveryTrator ?? ''),
                    CellTableWidget(
                        width: 200.w,
                        content: FileUtils.convertDateForHistoryDetailItem(
                            item.deliveryReturnStartActual ?? '')),
                    CellTableWidget(
                        width: 200.w,
                        content: FileUtils.convertDateForHistoryDetailItem(
                            item.deliveryReturnEndActual ?? '')),
                    CellTableWidget(
                        width: 210.w,
                        content: FileUtils.convertDateForHistoryDetailItem(
                            item.loadUnloadEnd ?? '')),
                    CellTableWidget(width: 150.w, content: item.pOL ?? ''),
                    CellTableWidget(width: 150.w, content: item.pOD ?? ''),
                    CellTableWidget(
                        width: 210.w,
                        content: FileUtils.convertDateForHistoryDetailItem(
                            item.eTAETD ?? '')),
                    CellTableWidget(
                        width: 210.w, content: item.workOrderStatus ?? ''),
                  ]),
                );
              }));
  List<String> _headerLstStr() {
    return [
      '3606',
      '3762',
      '3719',
      '3660',
      '3645',
      '4572',
      '5466',
      '5467',
      '4556',
      '5468',
      '5469',
      '${"4006".tr()}/${'5470'.tr()}',
      '${"4006".tr()}/${'5471'.tr()}',
      '4101',
      '3642',
      '3643',
      '${"164".tr()}/${"184".tr()}',
      '1279',
    ];
  }

  List<Widget> _headerTable() {
    return [
      HeaderTable2Widget(label: '3606', width: 150.w),
      HeaderTable2Widget(label: '3762', width: 150.w),
      HeaderTable2Widget(label: '3719', width: 200.w),
      HeaderTable2Widget(label: '3660', width: 150.w),
      HeaderTable2Widget(label: '3645', width: 180.w),
      HeaderTable2Widget(label: '4572', width: 150.w),
      HeaderTable2Widget(label: '5466', width: 150.w),
      HeaderTable2Widget(label: '5467', width: 150.w),
      HeaderTable2Widget(label: '4556', width: 210.w),
      HeaderTable2Widget(label: '5468', width: 200.w),
      HeaderTable2Widget(label: '5469', width: 150.w),
      HeaderTable2Widget(label: '${"4006".tr()}/${'5470'.tr()}', width: 200.w),
      HeaderTable2Widget(label: '${"4006".tr()}/${'5471'.tr()}', width: 200.w),
      HeaderTable2Widget(label: '4101', width: 210.w),
      HeaderTable2Widget(label: '3642', width: 150.w),
      HeaderTable2Widget(label: '3643', width: 150.w),
      HeaderTable2Widget(label: '${"164".tr()}/${"184".tr()}', width: 210.w),
      HeaderTable2Widget(label: '1279', width: 210.w),
    ];
  }
}

class TradeType {
  final String? typeName;
  final String? typeCode;
  TradeType({this.typeName, this.typeCode});
}

class Status {
  final String? statusName;
  final String? statusCode;
  Status({this.statusName, this.statusCode});
}

class DayType {
  final String? dateTypeName;
  final String? dateTypeCode;
  DayType({this.dateTypeName, this.dateTypeCode});
}

class WidgetFilter {
  final int id;
  final Widget widget;
  final bool isSelected;
  final String name;
  WidgetFilter(
      {required this.id,
      required this.widget,
      required this.isSelected,
      required this.name});

  WidgetFilter copyWith(
      {int? id, Widget? widget, bool? isSelected, String? name}) {
    return WidgetFilter(
      id: id ?? this.id,
      widget: widget ?? this.widget,
      isSelected: isSelected ?? this.isSelected,
      name: name ?? this.name,
    );
  }
}
