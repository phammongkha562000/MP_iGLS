import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/booking/booking/booking_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/booking/customer_booking_request.dart';
import 'package:igls_new/data/models/customer/global_visibility/booking/customer_booking_response.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/widgets/admin_component/cell_table.dart';
import 'package:igls_new/presentations/widgets/admin_component/header_table.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_view.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../widgets/load/load_list.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key, required this.content});
  final CustomerBookingReq content;

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  late CustomerBloc customerBloc;
  late BookingBloc _bloc;
  int? length1;
  BehaviorSubject<List<CustomerBookingRes>> lstBooking =
      BehaviorSubject<List<CustomerBookingRes>>();

  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<BookingBloc>(context);
    _bloc.add(BookingSearch(
        content: widget.content,
        subsidiaryId: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('85'.tr())),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            length1 = state.lstBooking.length;
            lstBooking.add(state.lstBooking);
          }
        },
        builder: (context, state) {
          if (state is BookingLoading) {
            return const ItemLoading();
          }

          return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12.w,
              ),
              child: Column(children: [
                buildLstBooking(
                    lstBooking: lstBooking.hasValue ? lstBooking.value : [])
              ]));
        },
      ),
    );
  }

  buildLstBooking({required List<CustomerBookingRes> lstBooking}) => lstBooking
          .isEmpty
      ? const TableView(headerChildren: [
          '3718',
          '3571',
          '3719',
          '3642',
          '3643',
          '184',
          '3609',
          '5477',
          '3840',
          '4027',
          '3605',
          '4433',
          '63'
        ], rowChildren: [])
      : TableDataWidget(
          listTableRowHeader: _headerTable(),
          listTableRowContent: List.generate(lstBooking.length, (index) {
            final item = lstBooking[index];
            return ColoredBox(
              color: colorRowTable(index: index),
              child: Row(children: [
                CellTableWidget(width: 150.w, content: item.bookingNo ?? ''),
                CellTableWidget(width: 150.w, content: item.blNo ?? ''),
                CellTableWidget(width: 200.w, content: item.carrierBcNo ?? ''),
                CellTableWidget(width: 180.w, content: item.placename ?? ''),
                CellTableWidget(
                    width: 150.w, content: item.finalDestination ?? ''),
                CellTableWidget(
                    width: 150.w,
                    content: FileUtils.convertDateForHistoryDetailItem(
                        item.etd ?? '')),
                CellTableWidget(width: 150.w, content: item.carrier ?? ''),
                CellTableWidget(
                    width: 210.w, content: item.vesselorFlight ?? ''),
                CellTableWidget(width: 200.w, content: item.voyage ?? ''),
                CellTableWidget(
                    width: 150.w, content: item.cntrcount.toString()),
                CellTableWidget(width: 210.w, content: item.cargoMode ?? ''),
                CellTableWidget(
                    width: 150.w,
                    content: FileUtils.convertDateForHistoryDetailItem(
                        item.createDate ?? '')),
                CellTableWidget(width: 150.w, content: item.createUser ?? ''),
              ]),
            );
          }));

  List<Widget> _headerTable() {
    return [
      HeaderTable2Widget(label: '3718', width: 150.w),
      HeaderTable2Widget(label: '3571', width: 150.w),
      HeaderTable2Widget(label: '3719', width: 200.w),
      HeaderTable2Widget(label: '3642', width: 180.w),
      HeaderTable2Widget(label: '3643', width: 150.w),
      HeaderTable2Widget(label: '184', width: 150.w),
      HeaderTable2Widget(label: '3609', width: 150.w),
      HeaderTable2Widget(label: '5477', width: 210.w),
      HeaderTable2Widget(label: '3840', width: 200.w),
      HeaderTable2Widget(label: '4027', width: 150.w),
      HeaderTable2Widget(label: '3605', width: 210.w),
      HeaderTable2Widget(label: '4433', width: 150.w),
      HeaderTable2Widget(label: '63', width: 150.w),
    ];
  }
}
