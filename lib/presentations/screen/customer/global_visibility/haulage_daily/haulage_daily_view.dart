import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/haulage_daily/haulage_daily/haulage_daily_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_daily/haulage_daily_req.dart';
import 'package:igls_new/data/models/customer/global_visibility/haulage_daily/haulage_daily_res.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/title_expansion.dart';
import 'package:igls_new/presentations/widgets/table_widget/cell_table_view.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';

import '../../../../../data/services/services.dart';

class HaulageDailyView extends StatefulWidget {
  const HaulageDailyView({
    super.key,
    required this.content,
  });
  final CustomerHaulageDailyReq content;
  @override
  State<HaulageDailyView> createState() => _HaulageDailyViewState();
}

class _HaulageDailyViewState extends State<HaulageDailyView> {
  final _navigationService = getIt<NavigationService>();
  late HaulageDailyBloc _bloc;
  late CustomerBloc customerBloc;

  String textDetail = '5089'.tr();

  @override
  void initState() {
    _bloc = BlocProvider.of<HaulageDailyBloc>(context);
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc.add(HaulageDailySearch(
        content: widget.content,
        subsidiaryId: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HaulageDailyBloc, HaulageDailyState>(
      listener: (context, state) {
        if (state is HaulageDailyFailure) {
          CustomDialog().error(context, err: state.message);
        }
      },
      builder: (context, state) {
        if (state is HaulageDailySuccess) {
          return Scaffold(
            appBar: AppBarCustom(
              title: Text('5383'.tr()),
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                _buildTableSummary(lstSumary: state.haulageDaily.sumary ?? []),
                _buildTableDetail(lstDetail: state.details),
              ]),
            ),
          );
        }
        return Scaffold(
            appBar: AppBarCustom(
              title: Text('5383'.tr()),
            ),
            body: const ItemLoading());
      },
    );
  }

  final List<String> _headerDetail = [
    '5474',
    '4595',
    '3645',
    '4011',
    '5475',
    '4580',
    '4015',
    '4016',
  ];
  Widget _buildTableDetail({required List<HaulageDailyDetail> lstDetail}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: TitleExpansionWidget(
            text: '${'5051'.tr()} - ${textDetail.tr()}',
            asset: const Icon(Icons.equalizer)),
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 8.w),
              child: TableView(
                headerChildren: _headerDetail,
                rowChildren: lstDetail == [] || lstDetail.isEmpty
                    ? []
                    : List.generate(lstDetail.length, (i) {
                        final item = lstDetail[i];

                        return TableRow(
                          decoration: BoxDecoration(
                              color: i % 2 != 0
                                  ? colors.defaultColor.withOpacity(0.1)
                                  : Colors.white),
                          children: [
                            CellTableView(
                                text: item.blNo == ''
                                    ? item.carrierBcNo ?? ''
                                    : item.blNo ?? ''),
                            CellTableView(text: item.mode ?? ''),
                            CellTableView(
                                text: item.cntrNo ?? '',
                                onTap: item.cntrNo != null && item.cntrNo != ''
                                    ? () {
                                        _navigationService.pushNamed(
                                            routes
                                                .customerHaulageDailyCNTRRoute,
                                            args: {
                                              key_params.woNoHaulageDaily:
                                                  item.woNo,
                                              key_params.woItemNoHaulageDaily:
                                                  item.woItemNo,
                                              key_params.cusBLCarrier:
                                                  item.mode!.contains('I-')
                                                      ? item.blNo
                                                      : item.carrierBcNo
                                            });
                                      }
                                    : null),
                            CellTableView(text: item.tractor ?? ''),
                            CellTableView(text: item.staffName ?? ''),
                            CellTableView(text: item.staffMobileNo ?? ''),
                            CellTableView(
                                text: FileUtils
                                    .converFromDateTimeToStringddMMyyyyHHmm(
                                        item.actualStart ?? '')),
                            CellTableView(
                                text: FileUtils
                                    .converFromDateTimeToStringddMMyyyyHHmm(
                                        item.actualEnd ?? '')),
                          ],
                        );
                      }),

                /* IntrinsicHeight(
            child: Row(
              children: [
                lstDetail.isEmpty
                    ? Expanded(
                        child: Column(
                          children: [
                            TableDataWidget(
                                isPaddingBot: false,
                                listTableRowHeader: _headerTableDetail(),
                                listTableRowContent: const []),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: colors.defaultColor)),
                                height: 200.h,
                                child: const EmptyWidget())
                          ],
                        ),
                      )
                    : TableDataWidget(
                        listTableRowHeader: _headerTableDetail(),
                        listTableRowContent:
                            List.generate(lstDetail.length, (index) {
                          final item = lstDetail[index];
                          return InkWell(
                            onTap: item.cntrNo != null && item.cntrNo != ''
                                ? () {
                                    _navigationService.pushNamed(
                                        routes.customerHaulageDailyCNTRRoute,
                                        args: {
                                          key_params.woNoHaulageDaily:
                                              item.woNo,
                                          key_params.woItemNoHaulageDaily:
                                              item.woItemNo
                                        });
                                  }
                                : null,
                            child: ColoredBox(
                              color: colorRowTable(
                                  index: index,
                                  color: colors.defaultColor.withOpacity(0.2)),
                              child: Row(children: [
                                CellTableWidget(
                                    width: 200,
                                    content: item.blNo == ''
                                        ? item.carrierBcNo ?? ''
                                        : item.blNo ?? ''),
                                CellTableWidget(
                                    width: 200, content: item.mode ?? ''),
                                CellTableWidget(
                                    width: 200, content: item.cntrNo ?? ''),
                                CellTableWidget(
                                    width: 200, content: item.tractor ?? ''),
                                CellTableWidget(
                                    width: 200, content: item.staffName ?? ''),
                                CellTableWidget(
                                    width: 200,
                                    content: item.staffMobileNo ?? ''),
                                CellTableWidget(
                                    width: 200,
                                    content: FileUtils
                                        .converFromDateTimeToStringddMMyyyyHHmm(
                                            item.actualStart ?? '')),
                                CellTableWidget(
                                    width: 200,
                                    content: FileUtils
                                        .converFromDateTimeToStringddMMyyyyHHmm(
                                            item.actualEnd ?? '')),
                              ]),
                            ),
                          );
                        })),
              ],
            ),
          ), */
              ))
        ]);
  }

  Widget _buildTableSummary({required List<HaulageDailySumary> lstSumary}) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: const TitleExpansionWidget(
            text: '145', asset: Icon(Icons.gamepad_sharp)),
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 8.w),
              child: TableView(
                tableColumnWidth: FixedColumnWidth(
                    (MediaQuery.sizeOf(context).width - 16.w) / 5),
                rowChildren: lstSumary == [] || lstSumary.isEmpty
                    ? []
                    : List.generate(lstSumary.length, (i) {
                        final item = lstSumary[i];

                        return TableRow(
                          children: [
                            CellTableView(text: item.contactCode ?? ''),
                            CellTableView(
                              text: item.trips.toString(),
                              onTap: () {
                                textDetail = '5089';
                                _bloc.add(
                                    const HaulageDailyFilterDetail(status: 0));
                              },
                            ),
                            CellTableView(
                              text: item.done.toString(),
                              onTap: () {
                                textDetail = '5153';

                                _bloc.add(
                                    const HaulageDailyFilterDetail(status: 1));
                              },
                            ),
                            CellTableView(
                              text: item.progress.toString(),
                              onTap: () {
                                textDetail = '245';

                                _bloc.add(
                                    const HaulageDailyFilterDetail(status: 2));
                              },
                            ),
                            CellTableView(text: item.rate.toString()),
                          ],
                        );
                      }),
                headerChildren: [
                  '3597',
                  '5089',
                  '5153',
                  '245',
                  '${'3539'.tr()} (%)'
                ],
              )
              /*  child: Table(
                border: lstSumary == [] || lstSumary.isEmpty
                    ? TableBorder.symmetric(
                        outside: const BorderSide(
                          color: colors.defaultColor,
                        ),
                      )
                    : TableBorder.all(
                        color: colors.defaultColor.withOpacity(0.5),
                      ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                defaultColumnWidth: lstSumary == [] || lstSumary.isEmpty
                    ? FixedColumnWidth(
                        (MediaQuery.sizeOf(context).width - 16.w) / 5)
                    : const IntrinsicColumnWidth(),
                children: [
                  TableRow(
                      decoration: const BoxDecoration(
                        color: colors.defaultColor,
                      ),
                      children: [
                        const HeaderTableWidget(headerText: '3597'),
                        const HeaderTableWidget(headerText: '5089'),
                        const HeaderTableWidget(headerText: '5153'),
                        const HeaderTableWidget(headerText: '245'),
                        HeaderTableWidget(headerText: '${'3539'.tr()} (%)'),
                      ]),
                  ...lstSumary == [] || lstSumary.isEmpty
                      ? List.generate(1, (i) {
                          return TableRow(children: [
                            const SizedBox(),
                            const SizedBox(),
                            _buildText(text: ''),
                            const SizedBox(),
                            const SizedBox(),
                          ]);
                        })
                      : List.generate(
                          lstSumary.length,
                          (i) {
                            final item = lstSumary[i];

                            return TableRow(
                              children: [
                                _buildText(text: item.contactCode ?? ''),
                                _buildText(
                                  text: item.trips.toString(),
                                  onTap: () {
                                    textDetail = '5089';
                                    _bloc.add(const HaulageDailyFilterDetail(
                                        status: 0));
                                  },
                                ),
                                _buildText(
                                  text: item.done.toString(),
                                  onTap: () {
                                    textDetail = '5153';

                                    _bloc.add(const HaulageDailyFilterDetail(
                                        status: 1));
                                  },
                                ),
                                _buildText(
                                  text: item.progress.toString(),
                                  onTap: () {
                                    textDetail = '245';

                                    _bloc.add(const HaulageDailyFilterDetail(
                                        status: 2));
                                  },
                                ),
                                _buildText(text: item.rate.toString()),
                              ],
                            );
                          },
                        ),
                ]), */
              ),
          // IntrinsicHeight(
          //   child: Row(
          //     children: [
          //       lstSumary.isEmptycnt
          //           ? Expanded(
          //               child: Column(
          //                 children: [
          //                   TableDataWidget(
          //                       listTableRowHeader: _headerTable(),
          //                       listTableRowContent: const []),
          //                   SizedBox(height: 200.h, child: const EmptyWidget())
          //                 ],
          //               ),
          //             )
          //           : TableDataWidget(
          //               listTableRowHeader: _headerTable(),
          //               listTableRowContent:
          //                   List.generate(lstSumary.length, (index) {
          //                 final item = lstSumary[index];
          //                 return ColoredBox(
          //                   color: colorRowTable(
          //                       index: index,
          //                       color: colors.defaultColor.withOpacity(0.2)),
          //                   child: Row(children: [
          //                     CellTableWidget(
          //                       width: 150,
          //                       content: item.contactCode ?? '',
          //                     ),
          //                     CellTableWidget(
          //                       width: 210,
          //                       content: item.trips.toString(),
          //                     ),
          //                     CellTableWidget(
          //                         width: 210, content: item.done.toString()),
          //                     CellTableWidget(
          //                         width: 150,
          //                         content: item.progress.toString()),
          //                     CellTableWidget(
          //                         width: 100, content: item.rate.toString()),
          //                   ]),
          //                 );
          //               })),
          //     ],
          //   ),
          // ),
        ]);
  }

  // List<Widget> _headerTable() {
  //   return const [
  //     HeaderTable2Widget(label: '1326', width: 150),
  //     HeaderTable2Widget(label: '2475', width: 210),
  //     HeaderTable2Widget(label: '5153', width: 210),
  //     HeaderTable2Widget(label: '4125', width: 150),
  //     HeaderTable2Widget(label: '5384', width: 100),
  //   ];
  // }

  // List<Widget> _headerTableDetail() {
  //   return const [
  //     HeaderTable2Widget(label: '5474', width: 200),
  //     HeaderTable2Widget(label: '4595', width: 200),
  //     HeaderTable2Widget(label: '3645', width: 200),
  //     HeaderTable2Widget(label: '4011', width: 200),
  //     HeaderTable2Widget(label: '5475', width: 200),
  //     HeaderTable2Widget(label: '4580', width: 200),
  //     HeaderTable2Widget(label: '4015', width: 200),
  //     HeaderTable2Widget(label: '4016', width: 200),
  //   ];
  // }
}
