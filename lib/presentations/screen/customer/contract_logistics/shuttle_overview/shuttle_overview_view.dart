import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/shuttle_overview/shuttle_overview/shuttle_overview_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/customer/contract_logistics/shuttle_overview/shuttle_overview_response.dart';
import 'package:igls_new/data/models/customer/home/customer_permission_res.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../widgets/admin_component/cell_table.dart';
import '../../../../widgets/admin_component/header_table.dart';
import '../../../../widgets/table_widget/table_data.dart';

class ShuttleOverviewView extends StatefulWidget {
  const ShuttleOverviewView({super.key});

  @override
  State<ShuttleOverviewView> createState() => _ShuttleOverviewViewState();
}

class _ShuttleOverviewViewState extends State<ShuttleOverviewView> {
  String? contactSelected;
  final ValueNotifier _contactNotifier = ValueNotifier<String>('');
  UserDCResult? dcSelected;
  ValueNotifier<List<UserDCResult>> lstDC = ValueNotifier([]);

  BehaviorSubject<List<List<GetShuttleOverView1>>> lstTripByTruck =
      BehaviorSubject<List<List<GetShuttleOverView1>>>();
  BehaviorSubject<List<GetShuttleOverView2>> lstToday =
      BehaviorSubject<List<GetShuttleOverView2>>();
  BehaviorSubject<List<GetShuttleOverView3>> lstDaily =
      BehaviorSubject<List<GetShuttleOverView3>>();
  late CustomerBloc customerBloc;
  late ShuttleOverviewBloc _bloc;

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<ShuttleOverviewBloc>(context);
    lstDC.value = customerBloc.cusPermission?.userDCResult ?? [];
    dcSelected = lstDC.value
        .where((element) => (element.dCCode ==
            customerBloc.userLoginRes?.userInfo?.defaultCenter))
        .single;
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
    _bloc.add(ShuttlerOverviewViewLoaded(
        contactCode: contactSelected ?? '',
        dcCode: dcSelected?.dCCode ?? '',
        subsidiaryId: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('4889'.tr()),
      ),
      body: BlocConsumer<ShuttleOverviewBloc, ShuttleOverviewState>(
        listener: (context, state) {
          if (state is ShuttleOverviewSuccess) {
            if (state.shuttleOverview.getShuttleOverView1 != null &&
                state.shuttleOverview.getShuttleOverView1 != []) {
              final menuGroupBy = groupBy(
                state.shuttleOverview.getShuttleOverView1!,
                (GetShuttleOverView1 elm) => elm.equipmentCode,
              );
              final menuGroupByList =
                  menuGroupBy.entries.map((entry) => entry.value).toList();
              lstTripByTruck.add(menuGroupByList);
            }

            lstToday.add(state.shuttleOverview.getShuttleOverView2 ?? []);
            lstDaily.add(state.shuttleOverview.getShuttleOverView3 ?? []);
          }
          if (state is ShuttleOverviewFailure) {
            CustomDialog().error(context, err: state.message, btnOkOnPress: () {
              Navigator.pop(context);
            });
          }
        },
        builder: (context, state) {
          if (state is ShuttleOverviewLoading) {
            return const ItemLoading();
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContact(),
                _buildDC(),
                _buildTitle1(title: '5289'),
                _buildTripsByTruck(),
                _buildTitle(title: '5290'),
                _buildTodaySummary(),
                _buildTitle(title: '5291'),
                _buildDailySummary()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 0, 8.h),
      child: Text(
        title.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildTitle1({required String title}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 0, 6.h),
      child: Text(
        title.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildDC() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
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
                  _bloc.add(ShuttlerOverviewViewLoaded(
                      contactCode: contactSelected ?? '',
                      dcCode: dcSelected?.dCCode ?? '',
                      subsidiaryId:
                          customerBloc.userLoginRes?.userInfo?.subsidiaryId ??
                              ''));
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
  Widget _buildContact() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: CustomerContactDropdown(
          lstContact:
              customerBloc.contactList!.map((e) => e.clientId!).toList(),
          value: contactSelected,
          label: '1326',
          onChanged: (p0) {
            String contactCode = p0 as String;
            contactSelected = contactCode;
            _contactNotifier.value = contactCode;
            _bloc.add(ShuttlerOverviewViewLoaded(
                contactCode: contactSelected ?? '',
                dcCode: dcSelected?.dCCode ?? '',
                subsidiaryId:
                    customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
          }),
    );
  }

  Widget _buildTripsByTruck() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: StreamBuilder<List<List<GetShuttleOverView1>>>(
          stream: lstTripByTruck.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Card(
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          child: ExpansionTile(
                            leading: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: const BoxDecoration(
                                    color: colors.amber,
                                    shape: BoxShape.circle),
                                child: Text(
                                  item.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            subtitle: Text(item[0].staffName ?? ''),
                            title: Text(
                              item[0].equipmentCode ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            collapsedBackgroundColor: colors.defaultColor,
                            collapsedIconColor: Colors.white,
                            collapsedTextColor: Colors.white,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: item.length,
                                itemBuilder: (context, index) {
                                  final item2 = item[index];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            item2.startTime ?? '',
                                            textAlign: TextAlign.center,
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            item2.endTime ?? '-',
                                            textAlign: TextAlign.center,
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.w),
                                          child: TextButton(
                                            style: const ButtonStyle(
                                                elevation:
                                                    MaterialStatePropertyAll(
                                                        10),
                                                shadowColor:
                                                    MaterialStatePropertyAll(
                                                        colors.darkLiver),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        colors.defaultColor)),
                                            child: Text(
                                              '30'.tr(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              _showDialogWidget(context,
                                                  item: item2);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    color: Colors.blueGrey.shade100,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
              return const SizedBox(
                child: EmptyWidget(),
              );
            }
            return const SizedBox(
              child: EmptyWidget(),
            );
          }),
    );
  }

  Widget _buildTodaySummary() {
    return IntrinsicHeight(
      child: Column(
        children: [
          StreamBuilder<List<GetShuttleOverView2>>(
            stream: lstToday.stream,
            builder: (context, snapshot) {
              snapshot.hasData
                  ? TableDataWidget(
                      listTableRowHeader: _headerTableToday(),
                      listTableRowContent: (snapshot.data != null &&
                              snapshot.data!.isNotEmpty)
                          ? List.generate(snapshot.data!.length, (index) {
                              final item = snapshot.data![index];
                              return ColoredBox(
                                color: colorRowTable(index: index),
                                child: Row(children: [
                                  CellTableWidget(
                                      width: 150.w,
                                      content: item.equipmentCode ?? ''),
                                  CellTableWidget(
                                      width: 150.w,
                                      content: item.staffName ?? ''),
                                  CellTableWidget(
                                      width: 200.w,
                                      content: item.firstTime ?? ''),
                                  CellTableWidget(
                                      width: 150.w,
                                      content: item.latestTime ?? ''),
                                  CellTableWidget(
                                      width: 180.w,
                                      content: FileUtils
                                          .convertDateForHistoryDetailItem(
                                              item.trips.toString())),
                                  CellTableWidget(
                                      width: 150.w,
                                      content: item.avgTripMinute.toString()),
                                ]),
                              );
                            })
                          : [])
                  : TableView(
                      tableColumnWidth: FixedColumnWidth(
                          (MediaQuery.sizeOf(context).width - 16.w) /
                              _headerLstStr.length),
                      headerChildren: _headerLstStr,
                      rowChildren: const []);

              /* if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return  TableDataWidget(
                      listTableRowHeader: _headerTableToday(),
                      listTableRowContent: (snapshot.data != null &&
                              snapshot.data!.isNotEmpty)
                          ? List.generate(snapshot.data!.length, (index) {
                              final item = snapshot.data![index];
                              return ColoredBox(
                                color: colorRowTable(index: index),
                                child: Row(children: [
                                  CellTableWidget(
                                      width: 150.w,
                                      content: item.equipmentCode ?? ''),
                                  CellTableWidget(
                                      width: 150.w,
                                      content: item.staffName ?? ''),
                                  CellTableWidget(
                                      width: 200.w,
                                      content: item.firstTime ?? ''),
                                  CellTableWidget(
                                      width: 150.w,
                                      content: item.latestTime ?? ''),
                                  CellTableWidget(
                                      width: 180.w,
                                      content: FileUtils
                                          .convertDateForHistoryDetailItem(
                                              item.trips.toString())),
                                  CellTableWidget(
                                      width: 150.w,
                                      content: item.avgTripMinute.toString()),
                                ]),
                              );
                            })
                          : []);
                }
                return IntrinsicHeight(
                  child: Column(
                    children: [
                      TableDataWidget(
                          listTableRowHeader: _headerTableToday(),
                          listTableRowContent: const []),
                      SizedBox(height: 200.h, child: const EmptyWidget())
                    ],
                  ),
                );
              } */
              return TableView(
                  tableColumnWidth: FixedColumnWidth(
                      (MediaQuery.sizeOf(context).width - 16.w) /
                          _headerLstStr.length),
                  headerChildren: _headerLstStr,
                  rowChildren: const []);
            },
          ),
        ],
      ),
    );
  }

  final List<String> _headerLstStr = [
    '176',
    '1321',
    '5510',
    '5511',
    '2475',
    '5512',
  ];
  final List<String> _headerDailyLstStr = [
    '239',
    '4870',
    '2475',
    '5513',
    '5514',
  ];
  Widget _buildDailySummary() {
    return IntrinsicHeight(
      child: Column(
        children: [
          StreamBuilder<List<GetShuttleOverView3>>(
            stream: lstDaily.stream,
            builder: (context, snapshot) {
              (snapshot.hasData)
                  ? TableDataWidget(
                      listTableRowHeader: _headerTableDaily(),
                      listTableRowContent:
                          (snapshot.data != null && snapshot.data!.isNotEmpty)
                              ? List.generate(snapshot.data!.length, (index) {
                                  final item = snapshot.data![index];
                                  return ColoredBox(
                                    color: colorRowTable(index: index),
                                    child: Row(children: [
                                      CellTableWidget(
                                          width: 150.w,
                                          content: item.dates ?? ''),
                                      CellTableWidget(
                                          width: 150.w,
                                          content: item.trucks.toString()),
                                      CellTableWidget(
                                          width: 200.w,
                                          content: item.trips.toString()),
                                      CellTableWidget(
                                          width: 150.w,
                                          content: item.avgTrips.toString()),
                                      CellTableWidget(
                                          width: 150.w,
                                          content: item.avgTripHour.toString()),
                                    ]),
                                  );
                                })
                              : [])
                  : TableView(
                      tableColumnWidth: FixedColumnWidth(
                          (MediaQuery.sizeOf(context).width - 16.w) /
                              _headerDailyLstStr.length),
                      headerChildren: _headerDailyLstStr,
                      rowChildren: const []);
              /* if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return TableDataWidget(
                      listTableRowHeader: _headerTableDaily(),
                      listTableRowContent:
                          (snapshot.data != null && snapshot.data!.isNotEmpty)
                              ? List.generate(snapshot.data!.length, (index) {
                                  final item = snapshot.data![index];
                                  return ColoredBox(
                                    color: colorRowTable(index: index),
                                    child: Row(children: [
                                      CellTableWidget(
                                          width: 150.w,
                                          content: item.dates ?? ''),
                                      CellTableWidget(
                                          width: 150.w,
                                          content: item.trucks.toString()),
                                      CellTableWidget(
                                          width: 200.w,
                                          content: item.trips.toString()),
                                      CellTableWidget(
                                          width: 150.w,
                                          content: item.avgTrips.toString()),
                                      CellTableWidget(
                                          width: 150.w,
                                          content: item.avgTripHour.toString()),
                                    ]),
                                  );
                                })
                              : []);
                }
                return IntrinsicHeight(
                  child: Column(
                    children: [
                      TableDataWidget(
                          listTableRowHeader: _headerTableDaily(),
                          listTableRowContent: const []),
                      SizedBox(height: 200.h, child: const EmptyWidget())
                    ],
                  ),
                );
              } */
              return TableView(
                  tableColumnWidth: FixedColumnWidth(
                      (MediaQuery.sizeOf(context).width - 16.w) /
                          _headerDailyLstStr.length),
                  headerChildren: _headerDailyLstStr,
                  rowChildren: const []);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _headerTableToday() {
    return [
      HeaderTable2Widget(label: '176', width: 150.w),
      HeaderTable2Widget(label: '1321', width: 150.w),
      HeaderTable2Widget(label: '5510', width: 200.w),
      HeaderTable2Widget(label: '5511', width: 150.w),
      HeaderTable2Widget(label: '2475', width: 180.w),
      HeaderTable2Widget(label: '5512', width: 150.w),
    ];
  }

  List<Widget> _headerTableDaily() {
    return [
      HeaderTable2Widget(label: '239', width: 150.w),
      HeaderTable2Widget(label: '4870', width: 150.w),
      HeaderTable2Widget(label: '2475', width: 200.w),
      HeaderTable2Widget(label: '5513', width: 150.w),
      HeaderTable2Widget(label: '5514', width: 150.w),
    ];
  }

  Future _showDialogWidget(BuildContext context,
          {required GetShuttleOverView1 item}) =>
      AwesomeDialog(
        context: context,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        dialogType: DialogType.info,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRowDetail(label: '5148', content: item.invoiceNo ?? ''),
              _buildRowDetail(label: '133', content: item.qty.toString()),
              _buildRowDetail(label: '153', content: item.itemNote ?? ''),
              _buildRowDetail(label: '5150', content: item.tripMode ?? ''),
              (item.sLat != '' && item.sLon != '')
                  ? SizedBox(
                      height: 200.w,
                      width: double.infinity,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          zoom: 16.0,
                          target: LatLng(double.parse(item.sLat ?? ''),
                              double.parse(item.sLon ?? '')),
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          // _controller.complete(controller);
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('source'),
                            position: LatLng(double.parse(item.sLat ?? ''),
                                double.parse(item.sLon ?? '')),
                          ),
                        },
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        btnCancelText: "26".tr(),
        btnCancelColor: Colors.blue,
        btnCancelOnPress: () {},
        btnOkColor: colors.textRed,
      ).show();

  Widget _buildRowDetail({required String label, required String content}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${label.tr()}:'),
          Text(content, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
