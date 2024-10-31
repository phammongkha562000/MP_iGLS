import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';

import 'package:igls_new/businesses_logics/bloc/ha_driver_menu/task_history/task_history_bloc.dart';
import 'package:igls_new/data/models/ha_driver_menu/task_history/task_history_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/radio_common.dart';
import '../../../../data/shared/utils/format_number.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/table_widget/table_widget.dart';

class TaskHistoryView extends StatefulWidget {
  const TaskHistoryView({super.key});

  @override
  State<TaskHistoryView> createState() => _TaskHistoryViewState();
}

class _TaskHistoryViewState extends State<TaskHistoryView> {
  final _navigationService = getIt<NavigationService>();
  late TaskHistoryBloc _bloc;
  late GeneralBloc generalBloc;
  DateTime date = DateTime.now();
  final _filterNotifer = ValueNotifier<String>('');
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TaskHistoryBloc>(context);
    _bloc.add(TaskHistoryLoaded(
        dateTime: DateTime.now(), status: "", generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskHistoryBloc, TaskHistoryState>(
      listener: (context, state) {
        if (state is TaskHistoryFailure) {
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
      builder: (context, state) {
        if (state is TaskHistorySuccess) {
          _filterNotifer.value =
              state.eventStatus == StatusTaskHistory.newStatus
                  ? StatusTaskHistory.newStatus
                  : state.eventStatus == StatusTaskHistory.completeStatus
                      ? StatusTaskHistory.completeStatus
                      : '';
          int sumTask = 0;
          double sumCashAdvance = 0;
          double sumActual = 0;
          for (var element in state.listTask) {
            sumTask += element.taskQty ?? 0;
            sumCashAdvance += element.cashAdvanceAmt ?? 0;
            sumActual += element.actualAmt ?? 0;
          }

          return Scaffold(
            appBar: AppBarCustom(
              title: Text("4672".tr()),
              actions: [
                IconButton(
                    onPressed: () {
                      _navigationService
                          .pushNamed(routes.haTransactionReportRoute);
                    },
                    icon: Image.asset(
                      assets.icMoney,
                      scale: 2,
                    ))
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PickDatePreviousNextWidget(
                    isMonth: true,
                    onTapPrevious: () {
                      _bloc.add(TaskHistoryPreviousMonthLoaded(
                          generalBloc: generalBloc));
                    },
                    onTapNext: () {
                      _bloc.add(
                          TaskHistoryNextMonthLoaded(generalBloc: generalBloc));
                    },
                    onTapPick: (selectDate) {
                      setState(() {
                        date = selectDate;
                      });
                      _bloc.add(TaskHistoryLoaded(
                          generalBloc: generalBloc,
                          dateTime: date,
                          status: _filterNotifer.value));
                    },
                    stateDate: state.dateTime ?? DateTime.now(),
                    childFilter: ValueListenableBuilder(
                        valueListenable: _filterNotifer,
                        builder: (context, value, child) =>
                            _buildGroupRadio(groupValue: _filterNotifer.value)),
                    quantityText: '$sumTask',
                    child: _buildTable(taskList: state.listTask),
                  ),
                ),
                Expanded(
                    flex: -1,
                    child: gradientColorDecoration(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${"1284".tr()}: ',
                                style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '${"4337".tr()}: ',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: NumberFormatter.numberFormatter(
                                        sumCashAdvance),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '${"5063".tr()}: ',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: NumberFormatter.numberFormatter(
                                        sumActual),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBarCustom(
            title: Text("4672".tr()),
          ),
          body: const ItemLoading(),
        );
      },
    );
  }

  Widget _buildTable({required List<TaskHistoryResult> taskList}) {
    return TableDataWidget(
      listTableRowHeader: _headerTable(),
      listTableRowContent: taskList.isNotEmpty
          ? List.generate(
              taskList.length,
              (index) {
                final item = taskList[index];
                final isHighlight =
                    taskList[index].taskCompleteQty! != taskList[index].taskQty!
                        ? true
                        : false;
                return ColoredBox(
                  color: colorRowTable(index: index),
                  child: InkWell(
                    onTap: () async {
                      final id = item.dtId;
                      _navigationService.pushNamed(
                          routes.taskHistoryDetailRoute,
                          args: {key_params.taskHistoryDetailById: id});
                    },
                    child: Row(
                      children: [
                        CellTableWidget(
                            width: 50,
                            content: (index + 1).toString(),
                            isHighlight: isHighlight),
                        CellTableWidget(
                            width: 100,
                            content: FormatDateConstants.convertddMM(
                              item.taskDate ?? '',
                            ),
                            isHighlight: isHighlight),
                        CellTableWidget(
                            width: 150,
                            content: item.docNo ?? '',
                            isHighlight: isHighlight),
                        CellTableWidget(
                            width: 80,
                            content: item.taskQty != null
                                ? item.taskQty.toString()
                                : '',
                            isHighlight: isHighlight),
                        CellTableWidget(
                            width: 100,
                            content: item.cashAdvanceAmt == null
                                ? ""
                                : NumberFormatter.numberFormatter(
                                    item.cashAdvanceAmt ?? 0),
                            isHighlight: isHighlight),
                        CellTableWidget(
                            width: 100,
                            content: item.actualAmt == null
                                ? ""
                                : NumberFormatter.numberFormatter(
                                    item.actualAmt ?? 0),
                            isHighlight: isHighlight),
                        CellTableWidget(
                            width: 100,
                            content: item.dailyTaskStatusDesc ?? '',
                            isHighlight: isHighlight),
                        CellTableWidget(
                            width: 200,
                            content: item.taskMemo ?? '',
                            isHighlight: isHighlight),
                      ],
                    ),
                  ),
                );
              },
            )
          : [const CellTableNoDataWidget(width: 880)],
    );
  }

  List<Widget> _headerTable() {
    return const [
      HeaderTable2Widget(label: '5586', width: 50),
      HeaderTable2Widget(label: '4294', width: 100),
      HeaderTable2Widget(label: '3529', width: 150),
      HeaderTable2Widget(label: '5062', width: 80),
      HeaderTable2Widget(label: '4337', width: 100),
      HeaderTable2Widget(label: '5063', width: 100),
      HeaderTable2Widget(label: '1279', width: 100),
      HeaderTable2Widget(label: '1276', width: 200),
    ];
  }

  Widget _buildGroupRadio({required String groupValue}) {
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRadioBtn(title: '5059', value: '', groupValue: groupValue),
          _buildRadioBtn(
              title: '245',
              value: StatusTaskHistory.newStatus,
              groupValue: groupValue),
          _buildRadioBtn(
              title: '4126',
              value: StatusTaskHistory.completeStatus,
              groupValue: groupValue)
        ],
      );
    }
  }

  Widget _buildRadioBtn(
          {required String title,
          required String value,
          required String groupValue}) =>
      Expanded(
        child: RadioCommon(
            title: title,
            value: value,
            groupValue: groupValue,
            onChanged: (value) => _bloc.add(TaskHistoryFilterLoaded(
                generalBloc: generalBloc, status: value))),
      );
}
