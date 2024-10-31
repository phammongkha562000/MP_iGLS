import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/mpi/timesheets/timesheets_bloc.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/date_time_extension.dart';
import 'package:igls_new/data/shared/utils/datetime_format.dart';
import 'package:igls_new/data/shared/utils/format_date_local.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/date_previous_next/date_previous_next.dart';
import 'package:igls_new/presentations/widgets/dot_line/dot_line_widget.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class TimesheetsView extends StatefulWidget {
  const TimesheetsView({super.key});

  @override
  State<TimesheetsView> createState() => _TimesheetsViewState();
}

class _TimesheetsViewState extends State<TimesheetsView> {
  final _navigationService = getIt<NavigationService>();
  final ScrollController _scrollController = ScrollController();
  late TimesheetsBloc _bloc;
  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TimesheetsBloc>(context);
    _bloc.userInfo = generalBloc.generalUserInfo;

    _bloc.add(const TimesheetsViewLoaded());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(TimesheetsPaging());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('5674'.tr()),
      ),
      body: BlocListener<TimesheetsBloc, TimesheetsState>(
        listener: (context, state) {
          if (state is TimesheetsFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        child: BlocBuilder<TimesheetsBloc, TimesheetsState>(
          builder: (context, state) {
            if (state is TimesheetsSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatePreviousNextView(
                    fromDate: state.fromDate,
                    toDate: state.toDate,
                    onTapPrevious: () {
                      _bloc.add(TimesheetsChangeDate(
                        fromDate:
                            state.fromDate.subtract(const Duration(days: 1)),
                      ));
                    },
                    onPickFromDate: (selectedDate) {
                      _bloc.add(TimesheetsChangeDate(
                        fromDate: selectedDate,
                      ));
                    },
                    onPickToDate: (selectedDate) {
                      _bloc.add(TimesheetsChangeDate(
                        toDate: selectedDate,
                      ));
                    },
                    onTapNext: () {
                      _bloc.add(TimesheetsChangeDate(
                        toDate: state.toDate.add(const Duration(days: 1)),
                      ));
                    },
                  ),
                  ColoredBox(
                    color: colors.darkLiver,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        children: [
                          _buildText(
                              text: "239".tr(),
                              flex: 4,
                              isTitle: true,
                              color: colors.textWhite),
                          _buildText(
                              text: '5675'.tr(),
                              isTitle: true,
                              color: colors.textWhite),
                          _buildText(
                              text: '5676'.tr(),
                              isTitle: true,
                              color: colors.textWhite),
                          _buildText(
                              text: '4330'.tr(),
                              isTitle: true,
                              color: colors.textWhite),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _bloc.add(const TimesheetsChangeDate());
                      },
                      child: state.isLoading
                          ? const ItemLoading()
                          : state.timesheetsList.isEmpty
                              ? ListView(children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.8,
                                      child: const EmptyWidget())
                                ])
                              : ListView.separated(
                                  controller: _scrollController,
                                  padding: EdgeInsets.only(bottom: 48.h),
                                  itemCount: state.timesheetsList.length,
                                  itemBuilder: (context, index) {
                                    final item = state.timesheetsList[index];
                                    return InkWell(
                                      onTap: () async {
                                        final result = await _navigationService
                                            .navigateAndDisplaySelection(
                                                routes.mpiTimesheetsDetailRoute,
                                                args: {
                                              key_params.timesheets: item
                                            });
                                        if (result != null) {
                                          _bloc.add(TimesheetsViewLoaded(
                                              fromDate: state.fromDate,
                                              toDate: state.toDate));
                                        }
                                      },
                                      child: ColoredBox(
                                        color: index % 2 == 1
                                            ? colors.defaultColor
                                                .withOpacity(0.1)
                                            : Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.h),
                                          child: Row(
                                            children: [
                                              _buildText(
                                                flex: 4,
                                                text: FormatDateLocal
                                                    .format_dd_MM_yyyy(
                                                  item.createDate.toString(),
                                                ),
                                              ),
                                              _buildText(
                                                text: FormatDateConstants
                                                    .convertUTCTime(
                                                        item.startTime ?? 0),
                                              ),
                                              _buildText(
                                                text: FormatDateConstants
                                                    .convertUTCTime(
                                                        item.endTime ?? 0),
                                              ),
                                              _buildText(
                                                  text:
                                                      item.workHour.toString(),
                                                  isTitle: true,
                                                  color: FormatDateConstants
                                                                  .convertUTCtoDateTime(
                                                                      item.startTime!)
                                                              .convertToDayName ==
                                                          'CN'
                                                      ? Colors.black
                                                      : /* FormatDateConstants
                                                                      .convertUTCtoDateTime(item
                                                                          .endTime!)
                                                                  .convertToDayName ==
                                                              '7'
                                                          ? (item.workHour! < 4
                                                              ? Colors.red
                                                              : Colors.black)
                                                          : */
                                                      item.workHour! < 8
                                                          ? Colors.red
                                                          : Colors.black),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return DottedLine(
                                      dashWidth: 5,
                                      dashSpace: 2.0,
                                      color: colors.btnGreen.withOpacity(0.5),
                                    );
                                  },
                                ),
                    ),
                  ),
                  state.isPagingLoading
                      ? const PagingLoading()
                      : const SizedBox()
                ],
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }
}

Widget _buildText(
    {required String text, int? flex, bool? isTitle, Color? color}) {
  return Expanded(
    flex: flex ?? 3,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontWeight: isTitle ?? false ? FontWeight.bold : FontWeight.normal,
          color: color ?? colors.textBlack),
    ),
  );
}
