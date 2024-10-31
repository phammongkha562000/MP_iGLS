import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_overview/haulage_overview/haulage_overview_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_overview/haulage_overview_req.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_overview/haulage_overview_res.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/title_expansion.dart';
import 'package:igls_new/presentations/widgets/table_widget/cell_table_view.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';

import '../../../../../data/services/services.dart';
import '../../../../widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class HaulageOverviewView extends StatefulWidget {
  const HaulageOverviewView({super.key, required this.model});
  final CustomerHaulageOverviewReq model;

  @override
  State<HaulageOverviewView> createState() => _HaulageOverviewViewState();
}

class _HaulageOverviewViewState extends State<HaulageOverviewView> {
  late HaulageOverviewBloc _bloc;
  late CustomerBloc customerBloc;
  final ValueNotifier _tabNotifier = ValueNotifier<int>(1);
  final _navigationService = getIt<NavigationService>();

  @override
  void initState() {
    _bloc = BlocProvider.of<HaulageOverviewBloc>(context);
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc.add(HaulageOverviewSearch(model: widget.model));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HaulageOverviewBloc, HaulageOverviewState>(
      listener: (context, state) {
        if (state is HaulageOverviewFailure) {
          CustomDialog().error(context,
              err: state.message,
              btnOkOnPress: () =>
                  _bloc.add(HaulageOverviewSearch(model: widget.model)));
        }
      },
      builder: (context, state) {
        if (state is HaulageOverviewSuccess) {
          CustomerHaulageOverviewRes haOverview = state.haulageOverview;
          return Scaffold(
            appBar: AppBarCustom(
              title: Text('4718'.tr()),
            ),
            body: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: _buildTab(),
                      ),
                      ..._tabNotifier.value == 2
                          ? [
                              _buildTableImport(
                                  lstImport: haOverview
                                                  .haulageOverViewImports !=
                                              null &&
                                          haOverview.haulageOverViewImports !=
                                              []
                                      ? haOverview.haulageOverViewImports!
                                          .where(
                                              (element) => element.atPort == 1)
                                          .toList()
                                      : []),
                              _buildTableImport2(
                                  lstImport: haOverview
                                                  .haulageOverViewImports !=
                                              null &&
                                          haOverview.haulageOverViewImports !=
                                              []
                                      ? haOverview.haulageOverViewImports!
                                          .where((element) =>
                                              element.pickUpStaging == 1)
                                          .toList()
                                      : []),
                              _buildTableImport3(
                                  lstImport: haOverview
                                                  .haulageOverViewImports !=
                                              null &&
                                          haOverview.haulageOverViewImports !=
                                              []
                                      ? haOverview.haulageOverViewImports!
                                          .where(
                                              (element) => element.staging == 1)
                                          .toList()
                                      : []),
                            ]
                          : [
                              //export
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: Row(
                                  children: [
                                    _buildColor(
                                        color: colors.ufoGreen,
                                        title: '5389',
                                        subTitle:
                                            '${'5390'.tr()}: ${haOverview.haulageOverViewSummaryArrivals?[0].arrival.toString()}/${haOverview.haulageOverViewSummaryArrivals?[0].planed.toString()}',
                                        content:
                                            '${haOverview.haulageOverViewSummaryArrivals![0].percents.toString()}%'),
                                    _buildColor(
                                        color: colors.tuftsBlue,
                                        title: '4213',
                                        subTitle:
                                            '${'5391'.tr()}:  ${haOverview.haulageOverViewSummaryLoadings?[0].loadEnd.toString()}/${haOverview.haulageOverViewSummaryLoadings?[0].planed.toString()}',
                                        content:
                                            '${haOverview.haulageOverViewSummaryLoadings![0].percents.toString()}%'),
                                  ],
                                ),
                              ),

                              _buildTableExport(
                                  lstPickUp:
                                      haOverview.haulageOverViewPickups ?? []),

                              _buildTableExport2(
                                  lstDetail: haOverview
                                          .transportOverStatisReportDetails ??
                                      []),
                            ]
                    ]),
              ),
            ),
          );
        }
        return Scaffold(
            appBar: AppBarCustom(title: Text('4718'.tr())),
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
  //         value: contactSelected,
  //         label: '1326',
  //         onChanged: (p0) {
  //           String contactCode = p0 as String;
  //           contactSelected = contactCode;
  //           _contactNotifier.value = contactCode;
  //         }),
  //   );
  // }

  // Widget _buildDate() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     child: InkWell(
  //       onTap: () {
  //         pickDate(
  //             date: date,
  //             context: context,
  //             function: (selectDate) {
  //               _dateController.text =
  //                   FileUtils.formatToStringFromDatetime2(selectDate);
  //               date = selectDate;
  //             });
  //       },
  //       child: TextFormField(
  //         controller: _dateController,
  //         enabled: false,
  //         decoration: InputDecoration(
  //             label: Text('3849'.tr()),
  //             suffixIcon:
  //                 const Icon(Icons.calendar_month, color: colors.defaultColor)),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildBtnSearch() {
  //   return Padding(
  //     padding: EdgeInsets.all(8.w),
  //     child: ElevatedButtonWidget(
  //         onPressed: () {
  //           BlocProvider.of<HaulageOverviewBloc>(context).add(
  //               HaulageOverviewSearch(
  //                   dataType: _tabNotifier.value == 1 ? 'E' : 'I',
  //                   customerBloc: customerBloc,
  //                   date: FileUtils.formatToStringNoFlashFromDatetime(date),
  //                   contactCode: contactSelected ?? ''));
  //           Navigator.of(context).pop();
  //         },
  //         text: '36'),
  //   );
  // }

  Widget _buildTab() {
    return ValueListenableBuilder(
        valueListenable: _tabNotifier,
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CustomSlidingSegmentedControl<int>(
              fixedWidth: MediaQuery.sizeOf(context).width / 4,
              initialValue: _tabNotifier.value,
              children: {
                1: Text(
                  '5080'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _tabNotifier.value == 2
                          ? Colors.white
                          : Colors.black),
                ),
                2: Text(
                  textAlign: TextAlign.center,
                  '5079'.tr(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _tabNotifier.value == 1
                          ? Colors.white
                          : Colors.black),
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

                _bloc.add(HaulageOverviewSearch(
                    model: CustomerHaulageOverviewReq(
                        company: widget.model.company,
                        contactCode: widget.model.contactCode,
                        branchCode: widget.model.branchCode,
                        dataType: _tabNotifier.value == 1 ? 'E' : 'I',
                        date: widget.model.date)));
              },
            ),
          );
        });
  }

  Widget _buildColor(
      {required Color color,
      required String title,
      required String content,
      String? subTitle}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      padding: EdgeInsets.all(12.w),
      width: (MediaQuery.sizeOf(context).width - 36.w) * .5,
      height: MediaQuery.sizeOf(context).height * 0.15,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.tr(),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subTitle != null
              ? Text(
                  subTitle,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                )
              : const SizedBox(),
          Text(content,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTableImport({required List<HaulageOverViewImport> lstImport}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: TitleExpansionWidget(
            color: colors.ufoGreen,
            text:
                '${'5386'.tr()}: ${lstImport.where((element) => element.atPort == 1).toList().length.toString()}'),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.w),
            child: TableView(
                tableColumnWidth: lstImport == [] || lstImport.isEmpty
                    ? FixedColumnWidth(
                        (MediaQuery.sizeOf(context).width - 16.w) /
                            _headerImport.length)
                    : null,
                rowChildren: lstImport == [] || lstImport.isEmpty
                    ? []
                    : List.generate(lstImport.length, (i) {
                        final item = lstImport[i];

                        return TableRow(
                          decoration:
                              BoxDecoration(color: colorRowTable(index: i)),
                          children: [
                            CellTableView(text: item.blNo ?? ''),
                            CellTableView(
                              text: item.cntrNo ?? '',
                              onTap: () {
                                _navigationService.pushNamed(
                                    routes.customerHaulageOverviewCNTRRoute,
                                    args: {
                                      key_params.woNoHaulageOverview: item.woNo,
                                      key_params.woItemNoHaulageOverview:
                                          item.woItemNo,
                                      key_params.cusBLCarrier: item.blNo
                                    });
                              },
                            ),
                            CellTableView(text: item.premitDone ?? ''),
                            CellTableView(
                                text: FileUtils.convertDateForHistoryDetailItem(
                                    item.pickUp ?? ''))
                          ],
                        );
                      }),
                headerChildren: _headerImport),
          )
          // IntrinsicHeight(
          //   child: lstImport.isEmpty
          //       ? Padding(
          //           padding: EdgeInsets.only(bottom: 8.h),
          //           child: TableView(
          //               tableColumnWidth: FixedColumnWidth(
          //                   (MediaQuery.sizeOf(context).width - 16.w) / 4),
          //               headerChildren: const [
          //                 '3571',
          //                 '3645',
          //                 '3578',
          //                 '5398',
          //               ],
          //               rowChildren: const []),
          //         )
          //       : Row(children: [
          //           TableDataWidget(
          //               color: colors.defaultColor,
          //               listTableRowHeader: _headerTableImport(),
          //               listTableRowContent:
          //                   List.generate(lstImport.length, (index) {
          //                 final item = lstImport[index];
          //                 return InkWell(
          //                   onTap: () {
          //                     _navigationService.pushNamed(
          //                         routes.customerHaulageOverviewCNTRRoute,
          //                         args: {
          //                           key_params.woNoHaulageOverview: item.woNo,
          //                           key_params.woItemNoHaulageOverview:
          //                               item.woItemNo,
          //                           /*  key_params.cusBLCarrier:
          //                                         item.!.contains('I-')
          //                                             ? item.blNo
          //                                             : item.carrierBcNo */
          //                         });
          //                   },
          //                   child: ColoredBox(
          //                     color: colorRowTable(
          //                         index: index,
          //                         color: colors.defaultColor.withOpacity(0.2)),
          //                     child: Row(children: [
          //                       CellTableWidget(
          //                           width: 200, content: item.blNo ?? ''),
          //                       CellTableWidget(
          //                           width: 200, content: item.cntrNo ?? ''),
          //                       CellTableWidget(
          //                           width: 200, content: item.premitDone ?? ''),
          //                       CellTableWidget(
          //                           width: 200,
          //                           content: FileUtils
          //                               .convertDateForHistoryDetailItem(
          //                                   item.pickUp ?? '')),
          //                     ]),
          //                   ),
          //                 );
          //               }))
          //         ]),
          // )
        ]);
  }

  final List<String> _headerImport = [
    '3571',
    '3645',
    '3578',
    '5398',
  ];
  final List<String> _headerImport2 = [
    '3573',
    '3571',
    '3645',
    '4011',
  ];
  final List<String> _headerImport3 = [
    '5090',
    '3571',
    '3645',
    '139',
  ];

  Widget _buildTableImport2({required List<HaulageOverViewImport> lstImport}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: TitleExpansionWidget(
          color: colors.tuftsBlue,
          text:
              '${'5387'.tr()}: ${lstImport.where((element) => element.pickUpStaging == 1).toList().length.toString()}',
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.w),
            child: TableView(
                tableColumnWidth: lstImport == [] || lstImport.isEmpty
                    ? FixedColumnWidth(
                        (MediaQuery.sizeOf(context).width - 16.w) /
                            _headerImport2.length)
                    : null,
                rowChildren: lstImport == [] || lstImport.isEmpty
                    ? []
                    : List.generate(lstImport.length, (i) {
                        final item = lstImport[i];

                        return TableRow(
                          decoration:
                              BoxDecoration(color: colorRowTable(index: i)),
                          children: [
                            CellTableView(
                                text: FileUtils.convertDateForHistoryDetailItem(
                                    item.pickUp ?? '')),
                            CellTableView(text: item.blNo ?? ''),
                            CellTableView(
                              text: item.cntrNo ?? '',
                              onTap: () {
                                _navigationService.pushNamed(
                                    routes.customerHaulageOverviewCNTRRoute,
                                    args: {
                                      key_params.woNoHaulageOverview: item.woNo,
                                      key_params.woItemNoHaulageOverview:
                                          item.woItemNo,
                                      key_params.cusBLCarrier: item.blNo
                                    });
                              },
                            ),
                            CellTableView(text: item.pickUpTractor ?? ''),
                          ],
                        );
                      }),
                headerChildren: _headerImport2),
          )
          /* IntrinsicHeight(
            child: lstImport.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: TableView(
                        tableColumnWidth: FixedColumnWidth(
                            (MediaQuery.sizeOf(context).width - 16.w) / 4),
                        headerChildren: const [
                          '3573',
                          '3571',
                          '3645',
                          '4011',
                        ],
                        rowChildren: const []),
                  )
                : Row(children: [
                    TableDataWidget(
                        color: colors.defaultColor,
                        listTableRowHeader: _headerTableImport2(),
                        listTableRowContent: lstImport.isEmpty
                            ? [
                                const CellTableNoDataWidget(width: 800),
                              ]
                            : List.generate(lstImport.length, (index) {
                                final item = lstImport[index];
                                return InkWell(
                                  onTap: () {
                                    _navigationService.pushNamed(
                                        routes.customerHaulageOverviewCNTRRoute,
                                        args: {
                                          key_params.woNoHaulageOverview:
                                              item.woNo,
                                          key_params.woItemNoHaulageOverview:
                                              item.woItemNo
                                        });
                                  },
                                  child: ColoredBox(
                                    color: colorRowTable(
                                        index: index,
                                        color: colors.defaultColor
                                            .withOpacity(0.2)),
                                    child: Row(children: [
                                      CellTableWidget(
                                          width: 200,
                                          content: FileUtils
                                              .convertDateForHistoryDetailItem(
                                                  item.pickUp ?? '')),
                                      CellTableWidget(
                                          width: 200, content: item.blNo ?? ''),
                                      CellTableWidget(
                                          width: 200,
                                          content: item.cntrNo ?? ''),
                                      CellTableWidget(
                                          width: 200,
                                          content: item.pickUpTractor ?? ''),
                                    ]),
                                  ),
                                );
                              }))
                  ]),
          ) */
        ]);
  }

  Widget _buildTableImport3({required List<HaulageOverViewImport> lstImport}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: TitleExpansionWidget(
            color: colors.amber,
            text:
                '${'5388'.tr()}: ${lstImport.where((element) => element.staging == 1).toList().length.toString()}'),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.w),
            child: TableView(
                tableColumnWidth: lstImport == [] || lstImport.isEmpty
                    ? FixedColumnWidth(
                        (MediaQuery.sizeOf(context).width - 16.w) /
                            _headerImport3.length)
                    : null,
                rowChildren: lstImport == [] || lstImport.isEmpty
                    ? []
                    : List.generate(lstImport.length, (i) {
                        final item = lstImport[i];

                        return TableRow(
                          decoration:
                              BoxDecoration(color: colorRowTable(index: i)),
                          children: [
                            CellTableView(text: item.eta ?? ''),
                            CellTableView(text: item.blNo ?? ''),
                            CellTableView(
                              text: item.cntrNo ?? '',
                              onTap: () {
                                _navigationService.pushNamed(
                                    routes.customerHaulageOverviewCNTRRoute,
                                    args: {
                                      key_params.woNoHaulageOverview: item.woNo,
                                      key_params.woItemNoHaulageOverview:
                                          item.woItemNo,
                                      key_params.cusBLCarrier: item.blNo
                                    });
                              },
                            ),
                            CellTableView(
                                text: FileUtils.convertDateForHistoryDetailItem(
                                    item.pickUp ?? '')),
                          ],
                        );
                      }),
                headerChildren: _headerImport3),
          )
          /* IntrinsicHeight(
            child: lstImport.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: TableView(
                        tableColumnWidth: FixedColumnWidth(
                            (MediaQuery.sizeOf(context).width - 16.w) / 4),
                        headerChildren: const [
                          '5090',
                          '3571',
                          '3645',
                          '139',
                        ],
                        rowChildren: const []),
                  )
                : Row(children: [
                    TableDataWidget(
                        color: colors.defaultColor,
                        listTableRowHeader: _headerTableImport3(),
                        listTableRowContent: lstImport.isEmpty
                            ? [
                                const CellTableNoDataWidget(width: 800),
                              ]
                            : List.generate(lstImport.length, (index) {
                                final item = lstImport[index];
                                return InkWell(
                                  onTap: () {
                                    _navigationService.pushNamed(
                                        routes.customerHaulageOverviewCNTRRoute,
                                        args: {
                                          key_params.woNoHaulageOverview:
                                              item.woNo,
                                          key_params.woItemNoHaulageOverview:
                                              item.woItemNo
                                        });
                                  },
                                  child: ColoredBox(
                                    color: colorRowTable(
                                        index: index,
                                        color: colors.defaultColor
                                            .withOpacity(0.2)),
                                    child: Row(children: [
                                      CellTableWidget(
                                          width: 200, content: item.eta ?? ''),
                                      CellTableWidget(
                                          width: 200, content: item.blNo ?? ''),
                                      CellTableWidget(
                                          width: 200,
                                          content: item.cntrNo ?? ''),
                                      CellTableWidget(
                                          width: 200,
                                          content: FileUtils
                                              .convertDateForHistoryDetailItem(
                                                  item.pickUp ?? '')),
                                    ]),
                                  ),
                                );
                              }))
                  ]),
          ) */
        ]);
  }

  Widget _buildTableExport({required List<HaulageOverViewPickup> lstPickUp}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: const TitleExpansionWidget(
          text: '5392',
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.w),
            child: TableView(
              rowChildren: lstPickUp == [] || lstPickUp.isEmpty
                  ? []
                  : List.generate(lstPickUp.length, (i) {
                      final item = lstPickUp[i];

                      return TableRow(
                        decoration:
                            BoxDecoration(color: colorRowTable(index: i)),
                        children: [
                          CellTableView(text: item.podCountryName ?? ''),
                          CellTableView(text: item.podName ?? ''),
                          CellTableView(text: item.carrier ?? ''),
                          CellTableView(text: item.carrierBcNo ?? ''),
                          CellTableView(text: item.cntrType ?? ''),
                          CellTableView(
                            text: item.cntrNo ?? '',
                            onTap: () {
                              _navigationService.pushNamed(
                                  routes.customerHaulageOverviewCNTRRoute,
                                  args: {
                                    key_params.woNoHaulageOverview: item.woNo,
                                    key_params.woItemNoHaulageOverview:
                                        item.woItemNo,
                                    key_params.cusBLCarrier: item.carrierBcNo
                                  });
                            },
                          ),
                          CellTableView(text: item.pickUpArrival ?? ''),
                          CellTableView(text: item.pickUpTractor ?? ''),
                          CellTableView(text: item.driverName ?? ''),
                        ],
                      );
                    }),
              headerChildren: const [
                '53',
                '5393',
                '5394',
                '3719',
                '5395',
                '3645',
                '5479',
                '4011',
                '4188',
              ],
            ),
          )
        ]);
  }

  Widget _buildTableExport2(
      {required List<TransportOverStatisReportDetails> lstDetail}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: const TitleExpansionWidget(
          text: '5409',
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.w),
            child: TableView(
              rowChildren: lstDetail == [] || lstDetail.isEmpty
                  ? []
                  : List.generate(lstDetail.length, (i) {
                      final item = lstDetail[i];

                      return TableRow(
                        decoration:
                            BoxDecoration(color: colorRowTable(index: i)),
                        children: [
                          CellTableView(text: item.podCountryName ?? ''),
                          CellTableView(text: item.podName ?? ''),
                          CellTableView(text: item.carrier ?? ''),
                          CellTableView(text: item.carrierBcNo ?? ''),
                          CellTableView(text: item.cntrType ?? ''),
                          CellTableView(
                            text: item.cntrNo ?? '',
                            onTap: () {
                              _navigationService.pushNamed(
                                  routes.customerHaulageOverviewCNTRRoute,
                                  args: {
                                    key_params.woNoHaulageOverview: item.woNo,
                                    key_params.woItemNoHaulageOverview:
                                        item.woItemNo
                                  });
                            },
                          ),
                          CellTableView(text: item.loadStart ?? ''),
                          CellTableView(text: item.loadEnd ?? ''),
                        ],
                      );
                    }),
              headerChildren: const [
                '53',
                '5393',
                '5394',
                '3719',
                '4320',
                '3645',
                '5396',
                '5397',
              ],
            ),
          )
        ]);
  }

  // List<Widget> _headerTableImport() {
  //   return const [
  //     HeaderTable2Widget(label: '3571', width: 200),
  //     HeaderTable2Widget(label: '3645', width: 200),
  //     HeaderTable2Widget(label: '3578', width: 200),
  //     HeaderTable2Widget(label: '5398', width: 200),
  //   ];
  // }

  // List<Widget> _headerTableImport2() {
  //   return const [
  //     HeaderTable2Widget(label: '3573', width: 200),
  //     HeaderTable2Widget(label: '3571', width: 200),
  //     HeaderTable2Widget(label: '3645', width: 200),
  //     HeaderTable2Widget(label: '4011', width: 200),
  //   ];
  // }

  // List<Widget> _headerTableImport3() {
  //   return const [
  //     HeaderTable2Widget(label: '5090', width: 200),
  //     HeaderTable2Widget(label: '3571', width: 200),
  //     HeaderTable2Widget(label: '3645', width: 200),
  //     HeaderTable2Widget(label: '139', width: 200),
  //   ];
  // }

  // List<Widget> _headerTableExport() {
  //   return const [
  //     HeaderTable2Widget(label: '53', width: 200),
  //     HeaderTable2Widget(label: '5393', width: 200),
  //     HeaderTable2Widget(label: '5394', width: 200),
  //     HeaderTable2Widget(label: '3719', width: 200),
  //     HeaderTable2Widget(label: '5395', width: 200),
  //     HeaderTable2Widget(label: '3645', width: 200),
  //     HeaderTable2Widget(label: '5479', width: 200),
  //     HeaderTable2Widget(label: '4011', width: 200),
  //     HeaderTable2Widget(label: '4188', width: 200),
  //   ];
  // }

  // List<Widget> _headerTableExport2() {
  //   return const [
  //     HeaderTable2Widget(label: '53', width: 200),
  //     HeaderTable2Widget(label: '5393', width: 200),
  //     HeaderTable2Widget(label: '5394', width: 200),
  //     HeaderTable2Widget(label: '3719', width: 200),
  //     HeaderTable2Widget(label: '4320', width: 200),
  //     HeaderTable2Widget(label: '3645', width: 200),
  //     HeaderTable2Widget(label: '5396', width: 200),
  //     HeaderTable2Widget(label: '5397', width: 200),
  //   ];
  // }
}
