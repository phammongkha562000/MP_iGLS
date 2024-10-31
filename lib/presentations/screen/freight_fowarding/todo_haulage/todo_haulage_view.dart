import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/todo_haulage/todo_haulage/todo_haulage_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/todo_haulahe_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/widgets/card_checkin_common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/widgets/layout_common.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class ToDoHaulageView extends StatefulWidget {
  const ToDoHaulageView({super.key});

  @override
  State<ToDoHaulageView> createState() => _ToDoHaulageViewState();
}

class _ToDoHaulageViewState extends State<ToDoHaulageView> {
  final _navigationService = getIt<NavigationService>();
  late ToDoHaulageBloc _bloc;
  bool isPending = false;
  int wOTaskIdPending = 0;
  late GeneralBloc generalBloc;

  BehaviorSubject<List<TodoHaulageResult>> haulageLst = BehaviorSubject();
  BehaviorSubject<List<TodoHaulageResult>> haulagePendingLst =
      BehaviorSubject();
  int quantityPending = 0;
  int quantity = 0;
  BehaviorSubject<String> timeCheckIn = BehaviorSubject();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<ToDoHaulageBloc>(context);
    _bloc.add(ToDoHaulageViewLoaded(generalBloc: generalBloc));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(TodoHaulagePaging(generalBloc: generalBloc));
      }
    });
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.homePageRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: Scaffold(
        appBar: AppBarCustom(
            title: Text('4021'.tr()),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _navigationService
                    .pushNamedAndRemoveUntil(routes.homePageRoute);
              },
            )),
        body: BlocConsumer<ToDoHaulageBloc, ToDoHaulageState>(
          listener: (context, state) {
            if (state is ToDoHaulageSuccess) {
              if (state.isSuccess == true) {
                CustomDialog().success(context);
              }
            }
            if (state is ToDoHaulageFailure) {
              if (state.errorCode == constants.errorNullEquipDriverId) {
                CustomDialog().error(context,
                    err: state.message.tr(),
                    btnOkOnPress: () => Navigator.of(context).pop());

                return;
              }
              CustomDialog().error(context, err: state.message);
            }
            if (state is ToDoHaulageSuccess) {
              quantity = state.quantity;
              haulagePendingLst.add(state.listToDo
                  .where((elm) =>
                      (elm.woTaskStatus == constants.woTaskStatusStart))
                  .toList());
              haulageLst.add(state.listToDo
                  .where((elm) =>
                      (elm.woTaskStatus != constants.woTaskStatusStart))
                  .toList());
              quantityPending = haulagePendingLst.value.length;
              _checkTripPending(
                  list: state.listToDo
                      .where((elm) =>
                          (elm.woTaskStatus != constants.woTaskStatusStart))
                      .toList());
              _checkTripPending(
                  list: state.listToDo
                      .where((elm) =>
                          (elm.woTaskStatus == constants.woTaskStatusStart))
                      .toList());
              timeCheckIn.add(state.dateTime ?? '');
            }
          },
          builder: (context, state) {
            if (state is ToDoHaulageLoading) {
              return const ItemLoading();
            }
            return Column(
              children: [
                StreamBuilder(
                  stream: timeCheckIn.stream,
                  builder: (context, snapshot) => CardCheckinCommon(
                    dateTimeCheckIn: snapshot.data,
                    onPressed: () {
                      _bloc.add(ToDoHaulageCheckIn(generalBloc: generalBloc));
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream: haulagePendingLst.stream,
                          builder: (context, snapshot) => _countTrip(
                              text: '245',
                              count: (!snapshot.hasData ||
                                      snapshot.data == null ||
                                      snapshot.data == [] ||
                                      snapshot.data!.isEmpty)
                                  ? 0
                                  : snapshot.data!.length),
                        ),
                        StreamBuilder(
                          stream: haulagePendingLst.stream,
                          builder: (context, snapshot) {
                            return (!snapshot.hasData ||
                                    snapshot.data == null ||
                                    snapshot.data == [] ||
                                    snapshot.data!.isEmpty)
                                ? const EmptyWidget()
                                : Column(
                                    children: [
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            haulagePendingLst.value.length,
                                        itemBuilder: (context, index) {
                                          return _cardTask(
                                              item: haulagePendingLst
                                                  .value[index]);
                                        },
                                      ),
                                    ],
                                  );
                          },
                        ),
                        StreamBuilder(
                          stream: haulageLst.stream,
                          builder: (context, snapshot) => _countTrip(
                              text: '5046',
                              count: (!snapshot.hasData ||
                                      snapshot.data == null ||
                                      snapshot.data == [] ||
                                      snapshot.data!.isEmpty)
                                  ? 0
                                  : quantity - quantityPending),
                        ),
                        StreamBuilder(
                          stream: haulageLst.stream,
                          builder: (context, snapshot) {
                            return (!snapshot.hasData ||
                                    snapshot.data == null ||
                                    snapshot.data == [] ||
                                    snapshot.data!.isEmpty)
                                ? const EmptyWidget()
                                : ListView.builder(
                                    padding: LayoutCommon.spaceBottomView,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: haulageLst.value.length,
                                    itemBuilder: (context, index) => _cardTask(
                                        item: haulageLst.value[index]),
                                  );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                (state is ToDoHaulagePagingLoading)
                    ? const PagingLoading()
                    : const SizedBox()
              ],
            );
          },
        ),
      ),
    );
  }

  void _checkTripPending({required List<TodoHaulageResult> list}) {
    for (var element in list) {
      if (element.woTaskStatus == 'STARTED') {
        isPending = true;
        wOTaskIdPending = element.woTaskId ?? 0;
      }
    }
  }

  Widget _countTrip({required int count, required String text}) => Padding(
        padding: EdgeInsets.only(top: 12.h, left: 12.w),
        child: Text(
          '${text.tr()} ($count)',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      );
  Widget _cardTask({required TodoHaulageResult item}) => InkWell(
        onTap: () async {
          final result = await _navigationService.navigateAndDisplaySelection(
              routes.toDoHaulageDetailRoute,
              args: {
                key_params.woTaskId: item.woTaskId,
                key_params.isPendingTodoHaulage: isPending,
                key_params.wOTaskIdPending: wOTaskIdPending
              });
          if (result != null) {
            isPending = false;
            _bloc.add(ToDoHaulageViewLoaded(generalBloc: generalBloc));
          }
        },
        child: CardCustom(
          elevation: 8,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 2, child: Text('5047'.tr())),
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.woNo ?? '',
                      style: styleLeftItem(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.contactCode ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: colors.textAmber,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              _heightSpacer(),
              Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Expanded(flex: 2, child: Text('4595'.tr())),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.woEquipMode ?? '',
                      style: styleLeftItem(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${item.taskModeOrginal ?? ''}-${item.tradeType == 'E' ? TradeType.exportTradeType.toString() : TradeType.importTradeType.toString()}',
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      FormatDateConstants.convertddMMHHmm(item.taskDate ?? ''),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              _heightSpacer(),
              Row(
                children: [
                  Expanded(flex: 2, child: Text('1291'.tr())),
                  Expanded(
                    flex: 7,
                    child: Text(
                      item.equipmentType ?? '',
                      style: styleLeftItem(),
                    ),
                  )
                ],
              ),
              _heightSpacer(),
              Row(
                children: [
                  Expanded(flex: 2, child: Text('3645'.tr())),
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.cntrNo ?? '',
                      style: styleLeftItem(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.woTaskStatus ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
  HeightSpacer _heightSpacer() => const HeightSpacer(height: 0.02);
  TextStyle styleLeftItem() => const TextStyle(fontWeight: FontWeight.bold);
}
