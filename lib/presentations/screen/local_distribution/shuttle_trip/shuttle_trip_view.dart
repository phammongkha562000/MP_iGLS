import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/shuttle_trip/shuttle_trip/shuttle_trip_bloc.dart';
import 'package:igls_new/data/models/local_distribution/shuttle_trip/shuttle_trips_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/utils.dart';
import 'package:igls_new/presentations/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/table_widget.dart';

class ShuttleTripView extends StatefulWidget {
  const ShuttleTripView({super.key});

  @override
  State<ShuttleTripView> createState() => _ShuttleTripViewState();
}

class _ShuttleTripViewState extends State<ShuttleTripView> {
  late ShuttleTripBloc _bloc;
  DateTime selectedDay = DateTime.now();

  ShuttleTripsResponse? shuttlePending;
  final _navigationService = getIt<NavigationService>();
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<ShuttleTripBloc>(context);
    _bloc.add(ShuttleTripViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text('4884'.tr()),
      ),
      body: BlocListener<ShuttleTripBloc, ShuttleTripState>(
        listener: (context, state) {
          if (state is ShuttleTripFailure) {
            if (state.errorCode == constants.errorNullEquipDriverId) {
              CustomDialog().error(
                context,
                err: state.message,
                btnOkOnPress: () => Navigator.of(context).pop(),
              );
              return;
            }
            CustomDialog().error(context, err: state.message);
          }
        },
        child: BlocBuilder<ShuttleTripBloc, ShuttleTripState>(
          builder: (context, state) {
            if (state is ShuttleTripSuccess) {
              shuttlePending = state.shuttleTrips
                          .where((element) => element.endTime == null)
                          .isEmpty ==
                      true
                  ? null
                  : state.shuttleTrips
                      .where((element) => element.endTime == null)
                      .first;

              List<String> tripOfDate;
              // * Tạo 1 list chứa các ngày có data
              tripOfDate = [];
              if (state.shuttleTrips.isNotEmpty) {
                for (var element in state.shuttleTrips) {
                  tripOfDate.addAll({
                    FormatDateConstants.convertMMddyyyy2(element.startTime!)
                  });
                }
              } else {
                tripOfDate.clear();
              }
              String defaultLang =
                  EasyLocalization.of(context)!.currentLocale.toString();
              return Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 64.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TableCalendar(
                        locale: defaultLang,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: state.dateTime,

                        rangeStartDay: state.dateTime,
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        daysOfWeekVisible: true,
                        calendarStyle: calenderStyle(),
                        headerStyle: headerCalendarStyle(),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, day, events) {
                            var days = DateFormat("MM/dd/yyyy").format(day);
                            for (String daytime in tripOfDate) {
                              if (days == daytime) {
                                final count = state.groupShuttleTrips
                                    .where((element) =>
                                        FormatDateConstants.convertMMddyyyy3(
                                            element.first.startTime!) ==
                                        days)
                                    .first
                                    .length;
                                return Positioned(
                                    bottom: 3,
                                    right: 2,
                                    child: Container(
                                      width: 20,
                                      alignment: Alignment.center,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                          color: colors.defaultColor),
                                      child: Text('$count',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textWhite,
                                          )),
                                    ));
                              }
                            }
                            return null;
                          },
                          dowBuilder: dowBuilder,
                        ),
                        onDaySelected: (DateTime selectDay, DateTime focusDay) {
                          _bloc.add(
                            ShuttleTripChangeDate(dateTime: focusDay),
                          );
                        },

                        calendarFormat: CalendarFormat.month,
                        onFormatChanged: (format) {},
                        // !Thay đổi tháng
                        onPageChanged: (focusedDay) {
                          _bloc.add(
                            ShuttleTripChangeMonth(
                                dateTime: focusedDay, generalBloc: generalBloc),
                          );
                        },

                        selectedDayPredicate: (DateTime date) {
                          return isSameDay(selectedDay, date);
                        },
                      ),
                      _buildQtyRow(
                          date: state.dateTime,
                          qty: state.shuttleTripsByDate.length),
                      buildTable(context,
                          shuttleTripByDate: state.shuttleTripsByDate,
                          dateTime: state.dateTime),
                    ]),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.defaultColor,
        onPressed: () async {
          final result = await _navigationService.navigateAndDisplaySelection(
              routes.addShuttleTripRoute,
              args: {key_params.shuttleTripPending: shuttlePending});
          if (result != null) {
            _bloc.add(ShuttleTripViewLoaded(generalBloc: generalBloc));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQtyRow({required DateTime date, required int qty}) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 4.h),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month,
            color: colors.defaultColor,
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: FormatDateConstants.convertMMddyyyy4(date),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.defaultColor)),
                const TextSpan(
                    text: ' - ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.defaultColor)),
                TextSpan(
                    text: '$qty ',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colors.defaultColor)),
                TextSpan(
                    text: '5089'.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colors.defaultColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget? dowBuilder(context, day) {
    if (day.weekday == DateTime.sunday || day.weekday == DateTime.saturday) {
      final text = DateFormat.E().format(day);
      return Center(
        child: Text(
          text,
          style: const TextStyle(color: colors.textRed),
        ),
      );
    }
    return null;
  }

  Widget buildTable(BuildContext context,
      {required List<ShuttleTripsResponse> shuttleTripByDate,
      required DateTime dateTime}) {
    return TableDataWidget(
      listTableRowHeader: const [
        HeaderTable2Widget(label: '5586', width: 50),
        HeaderTable2Widget(label: '5152', width: 150),
        HeaderTable2Widget(label: '5153', width: 150),
        HeaderTable2Widget(label: '5147', width: 200),
        HeaderTable2Widget(label: '5151', width: 200),
        HeaderTable2Widget(label: '133', width: 100),
        HeaderTable2Widget(label: '1279', width: 100),
        HeaderTable2Widget(label: '5148', width: 200),
      ],
      listTableRowContent: shuttleTripByDate.isNotEmpty
          ? List.generate(
              shuttleTripByDate.length,
              (i) {
                final item = shuttleTripByDate[i];

                return InkWell(
                  onTap: () async {
                    final result = item.endTime == null
                        ? await _navigationService.navigateAndDisplaySelection(
                            routes.addShuttleTripRoute,
                            args: {
                                key_params.shuttleTripPending: shuttlePending
                              })
                        : await _navigationService.navigateAndDisplaySelection(
                            routes.updateShuttleTripRoute,
                            args: {
                                key_params.shuttleTrip: item,
                                key_params.dateTime: dateTime
                              });

                    if (result != null) {
                      _bloc
                          .add(ShuttleTripViewLoaded(generalBloc: generalBloc));
                    }
                  },
                  child: ColoredBox(
                    color: colorRowTable(index: i),
                    child: Row(
                      children: [
                        CellTableWidget(content: (i + 1).toString(), width: 50),
                        CellTableWidget(
                            content: FormatDateConstants.convertToddMMyyyy(
                                item.startTime ?? ''),
                            width: 150),
                        CellTableWidget(
                            content: item.endTime == null
                                ? ''
                                : FormatDateConstants.convertToddMMyyyy(
                                    item.endTime ?? ''),
                            width: 150),
                        CellTableWidget(
                            content: item.startLocDesc ?? '', width: 200),
                        CellTableWidget(
                            content: item.endLocDesc ?? '', width: 200),
                        CellTableWidget(
                            content: NumberFormatter.numberFormatTotalQty(
                                double.parse(item.qty.toString())),
                            width: 100),
                        CellTableWidget(
                            content: item.postedStatus ?? '', width: 100),
                        CellTableWidget(
                            content: item.invoiceNo ?? '', width: 200),
                      ],
                    ),
                  ),
                );
              },
            )
          : [
              const CellTableNoDataWidget(width: 1150),
            ],
    );
  }

  HeaderStyle headerCalendarStyle() {
    return HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonShowsNext: false,
        formatButtonDecoration: BoxDecoration(
          color: colors.defaultColor,
          borderRadius: BorderRadius.circular(13.0),
        ),
        formatButtonTextStyle: const TextStyle(color: Colors.white));
  }

  CalendarStyle calenderStyle() {
    return const CalendarStyle(
      isTodayHighlighted: true,
      selectedDecoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 114, 72), shape: BoxShape.circle),
      selectedTextStyle: TextStyle(color: Colors.white),
      todayDecoration:
          BoxDecoration(color: colors.defaultColor, shape: BoxShape.circle),
    );
  }
}
