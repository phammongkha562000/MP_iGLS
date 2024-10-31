import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_overview/transport_overview/transport_overview_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_overview/transport_overview_request.dart';
import 'package:igls_new/data/models/customer/contract_logistics/transport_overview/transport_overview_response.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/presentations/widgets/admin_component/cell_table.dart';
import 'package:igls_new/presentations/widgets/admin_component/header_table.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/presentations/widgets/customer_component/title_table.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import '../../../../../data/services/services.dart';

class TransportOverviewView extends StatefulWidget {
  const TransportOverviewView({super.key});

  @override
  State<TransportOverviewView> createState() => _TransportOverviewViewState();
}

class _TransportOverviewViewState extends State<TransportOverviewView> {
  final _navigationService = getIt<NavigationService>();

  final ValueNotifier _tabNotifier = ValueNotifier<int>(1);
  late CustomerBloc customerBloc;
  late TransportOverviewBloc _bloc;
  String? contactSelected;
  final ValueNotifier _contactNotifier = ValueNotifier<String>('');
  UserDCResult? dcSelected;
  ValueNotifier<List<UserDCResult>> lstDC = ValueNotifier([]);

  BehaviorSubject<List<TransportOverStatisReportDetail>> lstBooking =
      BehaviorSubject<List<TransportOverStatisReportDetail>>();

  BehaviorSubject<List<TransportOverStatisReport>> lstToday =
      BehaviorSubject<List<TransportOverStatisReport>>();

  List<TransportOverStatisReport> lstToday1 = [];
  bool isEnable = false;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    lstDC.value = customerBloc.cusPermission?.userDCResult ?? [];

    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
    _bloc = BlocProvider.of<TransportOverviewBloc>(context);
    dcSelected = lstDC.value
        .where((element) => (element.dCCode ==
            customerBloc.userLoginRes?.userInfo?.defaultCenter))
        .single;
    _bloc.add(TransportOverviewViewLoaded(
        content: CustomerTransportOverviewReq(
            company: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? '',
            contactCode: contactSelected ?? '',
            dcCode: dcSelected?.dCCode ?? '',
            dataType: _tabNotifier.value)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('4714'.tr()),
      ),
      body: BlocConsumer<TransportOverviewBloc, TransportOverviewState>(
        listener: (context, state) {
          if (state is TransportOverviewSuccess) {
            lstToday
                .add(state.transportOverview.transportOverStatisReport ?? []);

            isEnable = lstToday.value
                    .where((e) => (((int.parse(e.mmdd!.split('-').first) ==
                            DateTime.now().month) &&
                        (int.parse(e.mmdd!.split('-').last) ==
                            DateTime.now().day))))
                    .isNotEmpty
                ? true
                : false;

            lstBooking.add(
                state.transportOverview.transportOverStatisReportDetail ?? []);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: (isEnable)
                    ? Row(
                        children: [
                          _buildColor(
                              color: colors.ufoGreen,
                              title: '96',
                              content: lstToday.value
                                  .where((e) =>
                                      (((int.parse(e.mmdd!.split('-').first) ==
                                              DateTime.now().month) &&
                                          (int.parse(e.mmdd!.split('-').last) ==
                                              DateTime.now().day))))
                                  .first
                                  .orders
                                  .toString()),
                          _buildColor(
                              color: colors.tuftsBlue,
                              title: '2475',
                              content: lstToday.value
                                  .where((e) =>
                                      (((int.parse(e.mmdd!.split('-').first) ==
                                              DateTime.now().month) &&
                                          (int.parse(e.mmdd!.split('-').last) ==
                                              DateTime.now().day))))
                                  .first
                                  .trips
                                  .toString()),
                          _buildColor(
                              color: colors.deepLilac,
                              title: '151',
                              content: lstToday.value
                                  .where((e) =>
                                      (((int.parse(e.mmdd!.split('-').first) ==
                                              DateTime.now().month) &&
                                          (int.parse(e.mmdd!.split('-').last) ==
                                              DateTime.now().day))))
                                  .first
                                  .volume!
                                  .ceil()
                                  .toString()),
                          _buildColor(
                              color: colors.cadetGrey,
                              title: '149',
                              content: lstToday.value
                                  .where((e) =>
                                      (((int.parse(e.mmdd!.split('-').first) ==
                                              DateTime.now().month) &&
                                          (int.parse(e.mmdd!.split('-').last) ==
                                              DateTime.now().day))))
                                  .first
                                  .weight!
                                  .ceil()
                                  .toString()),
                        ],
                      )
                    : Row(
                        children: [
                          _buildColor(
                              color: colors.ufoGreen,
                              title: '96',
                              content: '0'),
                          _buildColor(
                              color: colors.tuftsBlue,
                              title: '2475',
                              content: '0'),
                          _buildColor(
                              color: colors.deepLilac,
                              title: '151',
                              content: '0'),
                          _buildColor(
                              color: colors.cadetGrey,
                              title: '149',
                              content: '0'),
                        ],
                      ),
              ),
              _buildContact(),
              _buildDC(),
              _buildTab(),
              ..._buildSummary(),
              _buildLstTransportOverview(),
              const TitleTableCustomer(title: '5292'),
              _buildTableToday()
            ]),
          );
        },
      ),
    );
  }

  List<Widget> _buildSummary() {
    return (_tabNotifier.value == 1 && lstBooking.hasValue == true)
        ? [
            _buildTextSummary(
                label: 'Pending',
                content: lstBooking.value
                    .where((element) => element.tripStatus == 'Pending')
                    .length
                    .toString()),
            _buildTextSummary(
                label: 'Loading',
                content: lstBooking.value
                    .where((element) => element.tripStatus == 'Loading')
                    .length
                    .toString()),
            _buildTextSummary(
                label: 'Start Delivery',
                content: lstBooking.value
                    .where((element) => element.tripStatus == 'Start Delivery')
                    .length
                    .toString()),
          ]
        : (_tabNotifier.value == 2 && lstBooking.hasValue == true)
            ? [
                _buildTextSummary(
                    label: 'Start Delivery',
                    content: lstBooking.value
                        .where(
                            (element) => element.tripStatus == 'Start Delivery')
                        .length
                        .toString()),
                _buildTextSummary(
                    label: 'Completed',
                    content: lstBooking.value
                        .where((element) => element.tripStatus == 'Completed')
                        .length
                        .toString()),
              ]
            : [];
  }

  Widget _buildTextSummary({required String label, required String content}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      child: Text(
        '$label: $content',
      ),
    );
  }

  Widget _buildContact() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: CustomerContactDropdown(
          lstContact:
              customerBloc.contactList!.map((e) => e.clientId!).toList(),
          value: contactSelected,
          label: '1326',
          onChanged: (p0) {
            String contactCode = p0 as String;
            contactSelected = contactCode;
            _contactNotifier.value = contactCode;
            _bloc.add(TransportOverviewViewLoaded(
                content: CustomerTransportOverviewReq(
                    company:
                        customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? '',
                    contactCode: p0,
                    dcCode: dcSelected?.dCCode ?? '',
                    dataType: _tabNotifier.value)));
          }),
    );
  }

  Widget _buildColor(
      {required Color color, required String title, required String content}) {
    return Container(
      margin: EdgeInsets.symmetric(/* vertical: 8.h,  */ horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      width: (MediaQuery.sizeOf(context).width - 48.w) / 4,
      height: MediaQuery.sizeOf(context).height * 0.12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.tr(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(content,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDC() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: ValueListenableBuilder(
            valueListenable: lstDC,
            builder: (context, value, child) {
              return DropdownButtonFormField2(
                dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                )),
                menuItemStyleData: MenuItemStyleData(
                    selectedMenuItemBuilder: (context, child) {
                  return ColoredBox(
                    color: colors.defaultColor.withOpacity(0.2),
                    child: child,
                  );
                }),
                value:
                    value.isNotEmpty ? dcSelected ?? value[0] : UserDCResult(),
                isExpanded: true,
                decoration: InputDecoration(
                  label: Text('90'.tr()),
                ),
                onChanged: (value) {
                  dcSelected = value as UserDCResult;
                  _bloc.add(TransportOverviewViewLoaded(
                      content: CustomerTransportOverviewReq(
                          company: customerBloc
                                  .userLoginRes?.userInfo?.subsidiaryId ??
                              '',
                          contactCode: contactSelected ?? '',
                          dcCode: value.dCCode ?? '',
                          dataType: _tabNotifier.value)));
                },
                selectedItemBuilder: (context) {
                  return value.map((e) {
                    return Text(
                      e.dCDesc ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }).toList();
                },
                items: value
                    .map<DropdownMenuItem<UserDCResult>>((UserDCResult value) {
                  return DropdownMenuItem<UserDCResult>(
                    value: value,
                    child: Text(
                      value.dCDesc.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
              );
            }),
      );
  Widget _buildTab() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Center(
        child: ValueListenableBuilder(
            valueListenable: _tabNotifier,
            builder: (context, value, child) {
              return CustomSlidingSegmentedControl<int>(
                fixedWidth: (MediaQuery.sizeOf(context).width - 24.w) / 4,
                initialValue: _tabNotifier.value,
                children: {
                  1: Text(
                    '5519'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _tabNotifier.value == 1
                            ? Colors.black
                            : Colors.white),
                  ),
                  2: Text(
                    textAlign: TextAlign.center,
                    '4006'.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _tabNotifier.value == 2
                            ? Colors.black
                            : Colors.white),
                  ),
                  3: Text(
                    '5520'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _tabNotifier.value == 3
                            ? Colors.black
                            : Colors.white),
                  ),
                  4: Text(
                    textAlign: TextAlign.center,
                    '5521'.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _tabNotifier.value == 4
                            ? Colors.black
                            : Colors.white),
                  )
                },
                decoration: BoxDecoration(
                  color: colors.defaultColor,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                thumbDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                      offset: const Offset(
                        0.0,
                        2.0,
                      ),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInToLinear,
                onValueChanged: (v) {
                  _tabNotifier.value = v;
                  _bloc.add(TransportOverviewViewLoaded(
                      content: CustomerTransportOverviewReq(
                          company: customerBloc
                                  .userLoginRes?.userInfo?.subsidiaryId ??
                              '',
                          contactCode: contactSelected ?? '',
                          dcCode: dcSelected?.dCCode ?? '',
                          dataType: v)));
                },
              );
            }),
      ),
    );
  }

  Widget _buildLstTransportOverview() => Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: IntrinsicHeight(
          child: Column(
            children: [
              StreamBuilder<List<TransportOverStatisReportDetail>>(
                  stream: lstBooking.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        double totalCOD = 0;
                        for (var element in snapshot.data!) {
                          totalCOD += element.codAmount!;
                        }
                        return TableDataWidget(
                            listTableRowHeader: _headerTable(),
                            listTableRowContent: (snapshot.data != null &&
                                    snapshot.data!.isNotEmpty)
                                ? [
                                    ...List.generate(snapshot.data!.length,
                                        (index) {
                                      final item = snapshot.data![index];
                                      return InkWell(
                                        onTap: () {
                                          _navigationService.pushNamed(
                                              routes
                                                  .customerTransportOverviewDetailTripRoute,
                                              args: {
                                                key_params.cusTOTripNo:
                                                    item.tripNo
                                              });
                                        },
                                        child: ColoredBox(
                                          color: colorRowTable(index: index),
                                          child: Row(children: [
                                            CellTableWidget(
                                                width: 150.w,
                                                content: item.tripNo ?? ''),
                                            CellTableWidget(
                                                width: 150.w,
                                                content: item.truckNo ?? ''),
                                            CellTableWidget(
                                                width: 200.w,
                                                content: item.shipToes ?? ''),
                                            CellTableWidget(
                                                width: 150.w,
                                                content: item.orders != null
                                                    ? item.orders.toString()
                                                    : 0.toString()),
                                            _buildStatus(
                                                status: item.tripStatus ?? ''),
                                            CellTableWidget(
                                                width: 180.w,
                                                content:
                                                    item.pickUpArrival ?? ''),
                                            CellTableWidget(
                                                width: 150.w,
                                                content:
                                                    item.startDelivery ?? ''),
                                            CellTableWidget(
                                                width: 150.w,
                                                content:
                                                    item.codAmount.toString()),
                                          ]),
                                        ),
                                      );
                                    }),
                                    Row(
                                      children: [
                                        CellTableWidget(
                                            width: 150.w,
                                            content: snapshot.data!.length
                                                .toString()),
                                        CellTableWidget(
                                            width: 150.w, content: ''),
                                        CellTableWidget(
                                            width: 200.w, content: ''),
                                        CellTableWidget(
                                            width: 150.w, content: ''),
                                        CellTableWidget(
                                            width: 200.w, content: ''),
                                        CellTableWidget(
                                            width: 180.w, content: ''),
                                        CellTableWidget(
                                            width: 150.w, content: ''),
                                        CellTableWidget(
                                            width: 150.w,
                                            content: totalCOD.toString()),
                                      ],
                                    )
                                  ]
                                : []);
                      }
                      return TableView(
                          headerChildren: _headerLstStr, rowChildren: const []);
                    }

                    return TableView(
                        headerChildren: _headerLstStr, rowChildren: const []);
                    /* if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        double totalCOD = 0;
                        for (var element in snapshot.data!) {
                          totalCOD += element.codAmount!;
                        }
                        return TableDataWidget(
                            listTableRowHeader: _headerTable(),
                            listTableRowContent: (snapshot.data != null &&
                                    snapshot.data!.isNotEmpty)
                                ? [
                                    ...List.generate(snapshot.data!.length,
                                        (index) {
                                      final item = snapshot.data![index];
                                      return InkWell(
                                        onTap: () {
                                          _navigationService.pushNamed(
                                              routes
                                                  .customerTransportOverviewDetailTripRoute,
                                              args: {
                                                key_params.cusTOTripNo:
                                                    item.tripNo
                                              });
                                        },
                                        child: ColoredBox(
                                          color: colorRowTable(index: index),
                                          child: Row(children: [
                                            CellTableWidget(
                                                width: 150.w,
                                                content: item.tripNo ?? ''),
                                            CellTableWidget(
                                                width: 150.w,
                                                content: item.truckNo ?? ''),
                                            CellTableWidget(
                                                width: 200.w,
                                                content: item.shipToes ?? ''),
                                            CellTableWidget(
                                                width: 150.w,
                                                content: item.orders != null
                                                    ? item.orders.toString()
                                                    : 0.toString()),
                                            _buildStatus(
                                                status: item.tripStatus ?? ''),
                                            CellTableWidget(
                                                width: 180.w,
                                                content:
                                                    item.pickUpArrival ?? ''),
                                            CellTableWidget(
                                                width: 150.w,
                                                content:
                                                    item.startDelivery ?? ''),
                                            CellTableWidget(
                                                width: 150.w,
                                                content:
                                                    item.codAmount.toString()),
                                          ]),
                                        ),
                                      );
                                    }),
                                    Row(
                                      children: [
                                        CellTableWidget(
                                            width: 150.w,
                                            content: snapshot.data!.length
                                                .toString()),
                                        CellTableWidget(
                                            width: 150.w, content: ''),
                                        CellTableWidget(
                                            width: 200.w, content: ''),
                                        CellTableWidget(
                                            width: 150.w, content: ''),
                                        CellTableWidget(
                                            width: 200.w, content: ''),
                                        CellTableWidget(
                                            width: 180.w, content: ''),
                                        CellTableWidget(
                                            width: 150.w, content: ''),
                                        CellTableWidget(
                                            width: 150.w,
                                            content: totalCOD.toString()),
                                      ],
                                    )
                                  ]
                                : []);
                      }
                      return IntrinsicHeight(
                        child: Column(
                          children: [
                            TableDataWidget(
                                listTableRowHeader: _headerTable(),
                                listTableRowContent: const []),
                            SizedBox(height: 200.h, child: const EmptyWidget())
                          ],
                        ),
                      );
                    } */
                    // return IntrinsicHeight(
                    //   child: Column(
                    //     children: [
                    //       TableDataWidget(
                    //           listTableRowHeader: _headerTable(),
                    //           listTableRowContent: const []),
                    //       SizedBox(height: 200.h, child: const EmptyWidget())
                    //     ],
                    //   ),
                    // );
                  })
            ],
          ),
        ),
      );
  Widget _buildStatus({required String status}) {
    return Container(
      width: 200.w,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
        color: Colors.black38,
      ))),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(getColorByStatus(status))),
          onPressed: null,
          child: Text(
            status,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color getColorByStatus(String status) {
    switch (status) {
      case 'Pending':
        return colors.mauvelous;
      case 'Loading':
        return colors.blue;
      case 'Completed':
        return colors.shamrockGreen;
      case 'Start Delivery':
        return colors.cyan;

      default:
        return colors.btnGreyDisable;
    }
  }

  final List<String> _headerLstStr = [
    '2468',
    '176',
    '141',
    '133',
    '1279',
    '5479',
    '5069',
    '3829',
  ];
  List<Widget> _headerTable() {
    return [
      HeaderTable2Widget(label: '2468', width: 150.w),
      HeaderTable2Widget(label: '176', width: 150.w),
      HeaderTable2Widget(label: '141', width: 200.w),
      HeaderTable2Widget(label: '133', width: 150.w),
      HeaderTable2Widget(label: '1279', width: 200.w),
      HeaderTable2Widget(label: '5479', width: 180.w),
      HeaderTable2Widget(label: '5069', width: 150.w),
      HeaderTable2Widget(label: '3829', width: 150.w),
    ];
  }

  List<Widget> _headerTable2() {
    return [
      HeaderTable2Widget(label: 'MM-DD', width: 150.w),
      HeaderTable2Widget(label: '96', width: 150.w),
      HeaderTable2Widget(label: '2475', width: 200.w),
      HeaderTable2Widget(label: '151', width: 150.w),
      HeaderTable2Widget(label: '149', width: 180.w),
    ];
  }

  Widget _buildTableToday() {
    return IntrinsicHeight(
      child: Column(
        children: [
          StreamBuilder<List<TransportOverStatisReport>>(
              stream: lstToday.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                    return TableDataWidget(
                        listTableRowHeader: _headerTable2(),
                        listTableRowContent:
                            (snapshot.data != null && snapshot.data!.isNotEmpty)
                                ? List.generate(snapshot.data!.length, (index) {
                                    final item = snapshot.data![index];
                                    return ColoredBox(
                                      color: colorRowTable(index: index),
                                      child: Row(children: [
                                        CellTableWidget(
                                            width: 150.w,
                                            content: item.mmdd ?? ''),
                                        CellTableWidget(
                                            width: 150.w,
                                            content: item.orders.toString()),
                                        CellTableWidget(
                                            width: 200.w,
                                            content: item.trips.toString()),
                                        CellTableWidget(
                                            width: 150.w,
                                            content: item.volume.toString()),
                                        CellTableWidget(
                                            width: 180.w,
                                            content: item.weight.toString()),
                                      ]),
                                    );
                                  })
                                : []);
                  }
                  return IntrinsicHeight(
                    child: Column(
                      children: [
                        TableDataWidget(
                            listTableRowHeader: _headerTable2(),
                            listTableRowContent: const []),
                        SizedBox(height: 200.h, child: const EmptyWidget())
                      ],
                    ),
                  );
                }
                return IntrinsicHeight(
                  child: Column(
                    children: [
                      TableDataWidget(
                          listTableRowHeader: _headerTable2(),
                          listTableRowContent: const []),
                      SizedBox(height: 200.h, child: const EmptyWidget())
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
