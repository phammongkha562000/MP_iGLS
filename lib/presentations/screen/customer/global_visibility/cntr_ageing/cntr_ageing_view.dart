import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/cntr_ageing/cntr_ageing_bloc.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../../data/models/customer/global_visibility/cntr_ageing/get_cntr_ageing_req.dart';
import '../../../../../data/models/customer/global_visibility/cntr_ageing/get_cntr_ageing_res.dart';
import '../../../../../data/services/injection/injection_igls.dart';
import '../../../../../data/services/navigator/navigation_service.dart';
import '../../../../../data/shared/utils/file_utils.dart';
import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;

import '../../../../widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import '../../../../widgets/table_widget/header_table.dart';
import '../../../../widgets/table_widget/table_data.dart';

class CntrAgeingView extends StatefulWidget {
  const CntrAgeingView({super.key});

  @override
  State<CntrAgeingView> createState() => _CntrAgeingViewState();
}

class _CntrAgeingViewState extends State<CntrAgeingView> {
  late CustomerBloc customerBloc;
  late CntrAgeingBloc cntrAgeingBloc;
  BehaviorSubject<List<GetCntrAgeingRes>> lstCntrAgeingCtrl =
      BehaviorSubject<List<GetCntrAgeingRes>>();
  List<String> tradetype = ["I", "E"];
  List<String> reportType = ["ALL", "REMAINED", "OVERDUE"];
  late ValueNotifier<String> _tradeTypeNotifer;
  late ValueNotifier<String> _reportTypeNotifer;
  List<BarChartGroupData> barGroups = [];
  double maxY = 0;
  final _navigationService = getIt<NavigationService>();
  String? contactSelected;

  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    cntrAgeingBloc = BlocProvider.of<CntrAgeingBloc>(context)
      ..add(GetWoCntrAgeingEvent(
          subsidiaryId: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? '',
          model: GetCntrAgeingReq(
              contactCode: customerBloc.userLoginRes?.userInfo?.defaultClient,
              reportType: reportType[0],
              tradeType: tradetype[0])));
    _tradeTypeNotifer = ValueNotifier<String>(tradetype[0]);
    _reportTypeNotifer = ValueNotifier<String>(reportType[0]);
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCustom(
        title: Text('5257'.tr()),
      ),
      body: BlocConsumer<CntrAgeingBloc, CntrAgeingState>(
          listener: (context, state) {
        if (state is GetWoCntrAgeingSuccess) {
          lstCntrAgeingCtrl.add(state.lstWoCntrAgeing);
          for (var element in state.lstBarChartData) {
            for (var element in element.barRods) {
              if (element.toY > maxY) {
                maxY = element.toY;
              }
            }
          }
          setState(() {
            barGroups = state.lstBarChartData;
          });
        }
        if (state is GetWoCntrAgeingFail) {
          CustomDialog()
              .error(context, err: state.message, btnOkOnPress: () {});
        }
      }, builder: (context, state) {
        if (state is ShowLoadingState) {
          return const Center(child: ItemLoading());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8.w, 20.h, 8.w, 0),
          child: IntrinsicHeight(
            child: Column(children: [
              _buildRadioTradeType(),
              _buildRadioReportType(),
              _buildContractCode(),
              _buildChart(),
              buildLstCntrAgeing()
            ]),
          ),
        );
      }),
    );
  }

  Widget _buildRadioTradeType() {
    return ValueListenableBuilder(
        valueListenable: _tradeTypeNotifer,
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3762'.tr(),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                        title: Text('5079'.tr()),
                        value: tradetype[0],
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        groupValue: value,
                        onChanged: (newValue) {
                          _tradeTypeNotifer.value = newValue ?? '';
                          getWoCntrAgeing();
                        }),
                  ),
                  Expanded(
                      child: RadioListTile<String>(
                          title: Text('5080'.tr()),
                          contentPadding: EdgeInsets.zero,
                          value: tradetype[1],
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          groupValue: value,
                          onChanged: (newValue) {
                            _tradeTypeNotifer.value = newValue ?? '';
                            getWoCntrAgeing();
                          }))
                ],
              ),
              const SizedBox(
                height: 15,
              )
            ],
          );
        });
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        handleBuiltInTouches: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );
  Widget _buildChart() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: SizedBox(
            height: 280,
            width: 1200,
            child: BarChart(
              BarChartData(
                  maxY: maxY + 2,
                  minY: 0,
                  barGroups: barGroups,
                  gridData: const FlGridData(show: false),
                  barTouchData: barTouchData,
                  borderData: FlBorderData(
                    border: const Border(
                      top: BorderSide(
                        color: Colors.white,
                      ),
                      left: BorderSide(),
                      right: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  )),
              // Optional
            ),
          ),
        ),
      );
  Widget _buildRadioReportType() {
    return ValueListenableBuilder(
        valueListenable: _reportTypeNotifer,
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2469'.tr(),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                        title: Text('5059'.tr()),
                        value: reportType[0],
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        groupValue: value,
                        onChanged: (newValue) {
                          _reportTypeNotifer.value = newValue ?? '';
                          getWoCntrAgeing();
                        }),
                  ),
                  Expanded(
                      flex: 1,
                      child: RadioListTile<String>(
                          title: Text('5287'.tr()),
                          contentPadding: EdgeInsets.zero,
                          value: reportType[1],
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          groupValue: value,
                          onChanged: (newValue) {
                            _reportTypeNotifer.value = newValue ?? '';
                            getWoCntrAgeing();
                          })),
                  Expanded(
                      child: RadioListTile<String>(
                          title: Text('5286'.tr()),
                          contentPadding: EdgeInsets.zero,
                          value: reportType[2],
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          groupValue: value,
                          onChanged: (newValue) {
                            _reportTypeNotifer.value = newValue ?? '';
                            getWoCntrAgeing();
                          })),
                ],
              ),
              const SizedBox(
                height: 15,
              )
            ],
          );
        });
  }

  _buildContractCode() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: CustomerContactDropdown(
            lstContact: [...customerBloc.contactList!.map((e) => e.clientId!)],
            value: contactSelected,
            label: '1326',
            onChanged: (p0) {
              String contactCode = p0 as String;
              contactSelected = contactCode;
              getWoCntrAgeing();
            }),
      );
  getWoCntrAgeing() {
    cntrAgeingBloc.add(GetWoCntrAgeingEvent(
        subsidiaryId: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? '',
        model: GetCntrAgeingReq(
            contactCode: contactSelected ?? '',
            reportType: _reportTypeNotifer.value,
            tradeType: _tradeTypeNotifer.value)));
  }

  buildLstCntrAgeing() => StreamBuilder<List<GetCntrAgeingRes>>(
      stream: lstCntrAgeingCtrl.stream,
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
                      _navigationService.navigateAndDisplaySelection(
                          routes.customerCNTRHaulageDetailRoute,
                          args: {
                            key_params.woNo: item.wONo,
                            key_params.woItemNo: item.woItemNo,
                            key_params.statusCntrHaulage: item.wOStatus
                          });
                    },
                    child: ColoredBox(
                      color: colorRowTable(index: index),
                      child: Row(children: [
                        CellTableWidget(
                          width: 150.w,
                          content: item.bLNo ?? '',
                        ),
                        CellTableWidget(
                          width: 150.w,
                          content: item.bCNo ?? '',
                        ),
                        CellTableWidget(
                          width: 200.w,
                          content: item.carrier ?? '',
                        ),
                        CellTableWidget(
                          width: 150.w,
                          content: item.cNTRType ?? '',
                        ),
                        CellTableWidget(
                          width: 180.w,
                          content: item.cNTRNo ?? '',
                        ),
                        CellTableWidget(
                          width: 150.w,
                          content: item.cDNo ?? '',
                        ),
                        CellTableWidget(
                          width: 150.w,
                          content: item.cDDate ?? '',
                        ),
                        CellTableWidget(
                            width: 150.w, content: item.pickupDate ?? ''),
                        CellTableWidget(
                          width: 210.w,
                          content: FileUtils.convertDateForHistoryDetailItem(
                              item.deliveryDate ?? ''),
                        ),
                        CellTableWidget(
                          width: 200.w,
                          content: FileUtils.convertDateForHistoryDetailItem(
                              item.dueDate ?? ''),
                        ),
                        CellTableWidget(
                            width: 100.w, content: item.remained.toString()),
                        CellTableWidget(
                            width: 100.w, content: item.overs.toString()),
                      ]),
                    ),
                  );
                }));
          }
          return Expanded(
            child: Column(
              children: [
                TableDataWidget(
                    listTableRowHeader: _headerTable(),
                    listTableRowContent: const []),
                SizedBox(
                    height: 200.h,
                    child: const EmptyWidget(
                      scale: 2,
                    ))
              ],
            ),
          );
        }
        return TableDataWidget(
            listTableRowHeader: _headerTable(), listTableRowContent: const []);
      });
  List<Widget> _headerTable() {
    return [
      HeaderTable2Widget(label: '3571', width: 150.w),
      HeaderTable2Widget(label: '5066', width: 150.w),
      HeaderTable2Widget(label: '3609', width: 200.w),
      HeaderTable2Widget(label: '4746', width: 150.w),
      HeaderTable2Widget(label: '3645', width: 180.w),
      HeaderTable2Widget(label: '4572', width: 150.w),
      HeaderTable2Widget(label: '5466', width: 150.w),
      HeaderTable2Widget(label: '5473', width: 150.w),
      HeaderTable2Widget(label: '4006', width: 210.w),
      HeaderTable2Widget(label: '3921', width: 200.w),
      HeaderTable2Widget(label: '3595', width: 100.w),
      HeaderTable2Widget(label: '5472', width: 100.w),
    ];
  }
}
