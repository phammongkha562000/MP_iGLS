import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/contract_logistics/transport_overview/transport_overview_detail_trip/transport_overview_detail_trip_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/to_do_trip_detail_response.dart';
import 'package:igls_new/presentations/widgets/admin_component/cell_table.dart';
import 'package:igls_new/presentations/widgets/admin_component/header_table.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:rxdart/rxdart.dart';

import '../../../../presentations.dart';

class TransportOverviewDetailTripView extends StatefulWidget {
  const TransportOverviewDetailTripView({super.key, required this.tripNo});
  final String tripNo;
  @override
  State<TransportOverviewDetailTripView> createState() =>
      _TransportOverviewDetailTripViewState();
}

class _TransportOverviewDetailTripViewState
    extends State<TransportOverviewDetailTripView> {
  BehaviorSubject<List<SimpleOrderDetail>> lstDetail =
      BehaviorSubject<List<SimpleOrderDetail>>();
  late CustomerBloc customerBloc;
  late TransportOverviewDetailTripBloc _bloc;
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<TransportOverviewDetailTripBloc>(context);
    _bloc.add(TransportOverviewDetailTripViewLoaded(
        tripNo: widget.tripNo,
        subsidiaryId: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: const Text('5539'),
      ),
      body: BlocConsumer<TransportOverviewDetailTripBloc,
          TransportOverviewDetailTripState>(
        listener: (context, state) {
          if (state is TransportOverviewDetailTripSuccess) {
            lstDetail.add(state.detail.simpleOrderDetails ?? []);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
            child: Column(children: [
              _buildTable(),
            ]),
          );
        },
      ),
    );
  }

  List<Widget> _headerTable() {
    return const [
      HeaderTable2Widget(label: '5586', width: 200),
      HeaderTable2Widget(label: '164', width: 200),
      HeaderTable2Widget(label: '122', width: 200),
      HeaderTable2Widget(label: '256', width: 200),
      HeaderTable2Widget(label: '4236', width: 200),
      HeaderTable2Widget(label: '2387', width: 200),
    ];
  }

  Widget _buildTable(/* {required List<CustomerTOSRes> tosList} */) {
    return StreamBuilder<List<SimpleOrderDetail>>(
        stream: lstDetail.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return TableDataWidget(
                  listTableRowHeader: _headerTable(),
                  listTableRowContent: [
                    ...List.generate(snapshot.data!.length, (index) {
                      // final item = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          // _navigationService
                          //     .pushNamed(routes.customerTOSDetailRoute, args: {
                          //   key_params.orderIdTOS: item.ordeId,
                          //   key_params.tripNoTOS: item.tripNo,
                          //   key_params.deliveryModeTOS: item.deliveryMode
                          // });
                        },
                        child: ColoredBox(
                          color: colorRowTable(
                              index: index,
                              color: colors.defaultColor.withOpacity(0.2)),
                          child: const Row(children: [
                            CellTableWidget(
                              width: 200,
                              content: /* item.clientRefNo ?? */ '',
                            ),
                            CellTableWidget(
                              width: 200,
                              content: /* item.deliveryMode ??  */ '',
                            ),
                            CellTableWidget(
                                width: 200,
                                content:
                                    '') /* FileUtils.convertDateForHistoryDetailItem(
                            item.etp.toString())), */
                            ,
                            CellTableWidget(
                              width: 200,
                              content: /* item.clientRefNo ?? */ '',
                            ),
                            CellTableWidget(
                              width: 200,
                              content: /* item.deliveryMode ??  */ '',
                            ),
                            CellTableWidget(width: 200, content: '')
                          ]),
                        ),
                      );
                    }),
                  ]);
            }
            return IntrinsicHeight(
              child: Column(
                children: [
                  TableDataWidget(
                    listTableRowHeader: _headerTable(),
                    listTableRowContent: const [],
                  ),
                  SizedBox(height: 200.h, child: const EmptyWidget())
                ],
              ),
            );
          }
          return IntrinsicHeight(
            child: Column(
              children: [
                TableDataWidget(
                  listTableRowHeader: _headerTable(),
                  listTableRowContent: const [],
                ),
                SizedBox(height: 200.h, child: const EmptyWidget())
              ],
            ),
          );
        });
  }
}
