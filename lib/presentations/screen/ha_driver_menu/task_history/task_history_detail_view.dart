import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/ha_driver_menu/task_history/task_history_detail/task_history_detail_bloc.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/layout_common.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/models.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../../data/shared/shared.dart';
import '../../../widgets/app_bar_custom.dart';

class TaskHistoryDetailView extends StatefulWidget {
  const TaskHistoryDetailView({
    super.key,
    required this.id,
  });
  final int id;

  @override
  State<TaskHistoryDetailView> createState() => _TaskHistoryDetailViewState();
}

class _TaskHistoryDetailViewState extends State<TaskHistoryDetailView> {
  final _navigationService = getIt<NavigationService>();
  late TaskHistoryDetailBloc _bloc;
  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TaskHistoryDetailBloc>(context);
    _bloc.add(TaskHistoryDetailLoaded(id: widget.id, generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text("5051".tr()),
      ),
      body: BlocListener<TaskHistoryDetailBloc, TaskHistoryDetailState>(
        listener: (context, state) {
          if (state is TaskHistoryDetailFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        child: BlocBuilder<TaskHistoryDetailBloc, TaskHistoryDetailState>(
          builder: (context, state) {
            if (state is TaskHistoryDetailSuccess) {
              var date = DateFormatLocal.formatddMMyyyy(
                  state.dailyTask.createDate.toString());

              return Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: _buildCardInfo(
                          dailyTask: state.dailyTask, date: date)),
                  LayoutCommon.divider,
                  Expanded(
                    child: _buildListDetail(
                        listDetail: state.listDetail,
                        dailyTask: state.dailyTask),
                  ),
                ],
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildCardInfo({required DailyTask dailyTask, required String date}) {
    var colorStatus = dailyTask.dailyTaskStatus == "NEW"
        ? colors.textRed
        : dailyTask.dailyTaskStatus == "COMPLETE"
            ? colors.textGreen
            : colors.defaultColor;
    return CardCustom(
      elevation: 5,
      radius: 32,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        Text(date,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.description),
                      Text(dailyTask.docNo ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Text(
                dailyTask.dailyTaskStatus ?? "",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: sizeTextDefault,
                    color: colorStatus,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: ColoredBox(
              color: colors.textWhite,
              child: Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(0.4),
                  1: FlexColumnWidth(0.6),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Text(
                          "4337".tr(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Text(
                            dailyTask.cashAdvanceAmt == null
                                ? ""
                                : NumberFormatter.numberFormatter(
                                    dailyTask.cashAdvanceAmt ?? 0),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Text(
                          "5063".tr(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Text(
                            dailyTask.actualAmt == null
                                ? ""
                                : NumberFormatter.numberFormatter(
                                    dailyTask.actualAmt ?? 0),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListDetail(
      {required List<ListDetail> listDetail, required DailyTask dailyTask}) {
    return ListView.builder(
      padding: LayoutCommon.spaceBottomView,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: listDetail.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            final dtdId = listDetail[index].dtdId;
            final result = await _navigationService.navigateAndDisplaySelection(
                routes.taskHistoryDetailItemRoute,
                args: {
                  key_params.taskHistoryDetailItemByDtdId: dtdId,
                  key_params.listDetailHistory: listDetail,
                  key_params.dailyTask: dailyTask,
                });
            if (result != null) {
              _bloc.add(TaskHistoryDetailLoaded(
                  id: dailyTask.dtId!, generalBloc: generalBloc));
            }
          },
          child: CardCustom(
            elevation: 5,
            radius: 32,
            child: Column(
              children: [
                _buildText(
                    title: "1272",
                    content: listDetail[index].contactCode ?? ""),
                _buildText(
                    title: "4595",
                    content: listDetail[index].taskMode ?? "",
                    isBold: true),
                _buildText(
                    title: "5210",
                    content: listDetail[index].actualEnd != null
                        ? FileUtils.convertDateForHistoryDetailItem(
                            listDetail[index].actualEnd ?? '')
                        : '',
                    isBold: true),
                _buildText(
                    title: "3645",
                    content: listDetail[index].cntrNo ?? '',
                    isBold: true),
                _buildText(
                    title: "4012",
                    content: listDetail[index].secEquipmentCode ?? '',
                    isBold: true),
                _buildText(
                    title: "3773", content: listDetail[index].bcNo ?? ""),
                _buildText(title: "3571", content: listDetail[index].blNo ?? "")
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildText(
      {required String title, required String content, bool? isBold}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title.tr(),
              style: TextStyle(
                  color: isBold == true
                      ? (content == '' ? colors.textRed : colors.defaultColor)
                      : colors.defaultColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              content,
              style: isBold ?? false
                  ? (content == '' ? styleWarning : styleBlackBold)
                  : styleTextListView,
            ),
          ),
        ],
      ),
    );
  }
}
