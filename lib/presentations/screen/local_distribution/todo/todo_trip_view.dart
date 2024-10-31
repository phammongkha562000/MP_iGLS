import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigator.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/widgets/card_checkin_common.dart';
import 'package:igls_new/presentations/widgets/layout_common.dart';

import 'package:sprintf/sprintf.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class ToDoTripView extends StatefulWidget {
  const ToDoTripView({
    super.key,
  });

  @override
  State<ToDoTripView> createState() => _ToDoTripViewState();
}

class _ToDoTripViewState extends State<ToDoTripView> {
  final _navigationService = getIt<NavigationService>();
  late ToDoTripBloc _bloc;
  late GeneralBloc generalBloc;
  bool isAdd = true;
  bool isUpdate = true;
  bool isPending = false;
  String tripNoPending = '';

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<ToDoTripBloc>(context);
    _bloc.add(ToDoTripViewLoaded(generalBloc: generalBloc));
    _verticalScrollController1.addListener(() {
      if (_verticalScrollController1.position.pixels ==
          _verticalScrollController1.position.maxScrollExtent) {
        log("paging");
        _bloc.add(TodoTripPaging(generalBloc: generalBloc));
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

  final _verticalScrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: BlocConsumer<ToDoTripBloc, ToDoTripState>(
        listener: (context, state) {
          if (state is ToDoTripSuccess) {
            if (state.isSuccess == true) {
              CustomDialog().success(context);
              return;
            }
          }
          if (state is ToDoTripFailure) {
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
          if (state is ToDoTripSuccess) {
            _checkTripPending(list: state.normalTripList);
            _checkTripPending(list: state.simpleTripList);
            _checkTripPending(list: state.normalTripPending);
            _checkTripPending(list: state.simpleTripPending);

            return Scaffold(
              appBar: AppBarCustom(
                title: Text('3998'.tr()),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _navigationService
                        .pushNamedAndRemoveUntil(routes.homePageRoute)),
              ),
              body: Column(
                children: [
                  CardCheckinCommon(
                    dateTimeCheckIn: state.dateCheckIn,
                    onPressed: () {
                      _bloc.add(ToDoTripCheckIn(generalBloc: generalBloc));
                    },
                  ),
                  Expanded(
                      flex: 4,
                      child: Scrollbar(
                        controller: _verticalScrollController1,
                        child: SingleChildScrollView(
                          padding: LayoutCommon.spaceBottomView,
                          controller: _verticalScrollController1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _countTrip(
                                      text: '245',
                                      count: state.normalTripPending.length +
                                          state.simpleTripPending.length),
                                  state.normalTripPending.isEmpty &&
                                          state.simpleTripPending.isEmpty
                                      ? const EmptyWidget()
                                      : Column(
                                          children: [
                                            ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: state
                                                  .normalTripPending.length,
                                              itemBuilder: (context, index) {
                                                return _normalTripWidget(
                                                    equipmentNo:
                                                        state.equipmentNo,
                                                    url: state.url,
                                                    userID: state.userID,
                                                    serverWcf: state.serverWcf,
                                                    normalTrip:
                                                        state.normalTripPending[
                                                            index]);
                                              },
                                            ),
                                            ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: state
                                                  .simpleTripPending.length,
                                              itemBuilder: (context, index) {
                                                return _simpleTripWidget(
                                                    simpleTrip:
                                                        state.simpleTripPending[
                                                            index]);
                                              },
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              _countTrip(
                                  text: '5046',
                                  count: state.quantity -
                                      (state.normalTripPending.length +
                                          state.simpleTripPending
                                              .length) /*  state.normalTripList.length +
                                      state.simpleTripList.length */
                                  ),
                              state.normalTripList.isEmpty &&
                                      state.simpleTripList.isEmpty
                                  ? const EmptyWidget()
                                  : Column(
                                      children: [
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              state.normalTripList.length,
                                          itemBuilder: (context, index) {
                                            return _normalTripWidget(
                                                equipmentNo: state.equipmentNo,
                                                url: state.url,
                                                userID: state.userID,
                                                serverWcf: state.serverWcf,
                                                normalTrip: state
                                                    .normalTripList[index]);
                                          },
                                        ),
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              state.simpleTripList.length,
                                          itemBuilder: (context, index) {
                                            return _simpleTripWidget(
                                                simpleTrip: state
                                                    .simpleTripList[index]);
                                          },
                                        ),
                                      ],
                                    ),
                              state.isPagingLoading
                                  ? const PagingLoading()
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      )),
                ],
              ),
              floatingActionButton:
                  /*  state.dateCheckIn == '' || state.dateCheckIn == null
                      ? const SizedBox()
                      :  */
                  state.isAddTrip
                      ? isPending == false
                          ? FloatingActionButton(
                              onPressed: () async {
                                final result = await _navigationService
                                    .navigateAndDisplaySelection(
                                        routes.addToDoTripRoute,
                                        args: {key_params.allowEdit: true});
                                if (result != null) {
                                  _bloc.add(ToDoTripViewLoaded(
                                      generalBloc: generalBloc));
                                }
                              },
                              backgroundColor: colors.defaultColor,
                              child: const Icon(Icons.add),
                            )
                          : const SizedBox()
                      : null,
            );
          }
          return Scaffold(
              appBar: AppBarCustom(title: Text('3998'.tr())),
              body: const ItemLoading());
        },
      ),
    );
  }

  void _checkTripPending({required List<dynamic> list}) {
    for (var element in list) {
      if (element.tripStatus == 'PICKUP_ARRIVAL' ||
          element.tripStatus == 'START_DELIVERY') {
        isPending = true;
        tripNoPending = element.tripNo ?? '';
      }
    }
  }

  Widget _normalTripWidget(
      {required TodoResult normalTrip,
      required String url,
      required String userID,
      required String equipmentNo,
      required String serverWcf}) {
    return InkWell(
      onTap: normalTrip.tripNo!.startsWith('S')
          ? () async {
              final result = await _navigationService
                  .navigateAndDisplaySelection(routes.toDoTripDetailRoute,
                      args: {
                    key_params.tripNo: normalTrip.tripNo,
                    key_params.isPendingTodoTrip: isPending,
                    key_params.tripNoPending: tripNoPending
                  });
              if (result != null) {
                isPending = false;
                _bloc.add(ToDoTripViewLoaded(generalBloc: generalBloc));
              }
            }
          : () async {
              final result = await _navigationService
                  .navigateAndDisplaySelection(routes.toDoNormalTripDetailRoute,
                      args: {
                    key_params.tripNo: normalTrip.tripNo,
                    key_params.isPendingTodoTrip: isPending,
                    key_params.tripNoPending: tripNoPending
                  });
              if (result != null) {
                isPending = false;
                _bloc.add(ToDoTripViewLoaded(generalBloc: generalBloc));
              }
            },
      child: CardCustom(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            gradientColorDecoration(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    normalTrip.contactCode ?? '',
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                  Text(normalTrip.tripNo ?? '',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(colors.textAmber)),
                      child: Text(
                        '5068'.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      onPressed: () async {
                        final urlWeb = sprintf(url,
                            [userID, equipmentNo, normalTrip.tripNo, userID]);
                        final urlWeb2 = '$serverWcf$urlWeb';

                        final result = await _navigationService
                            .navigateAndDisplaySelection(
                                routes.webViewCheckListRoute,
                                args: {
                              key_params.urlCheckList: urlWeb2,
                              key_params.tripNo: normalTrip.tripNo
                            });
                        if (result != null) {
                          isPending = false;
                          _bloc.add(
                              ToDoTripViewLoaded(generalBloc: generalBloc));
                        }
                      })
                ],
              ).paddingSymmetric(vertical: 8.h, horizontal: 12.w),
            ),
            Column(
              children: [
                _rowIconText(icon: Icons.home, text: normalTrip.picName ?? ''),
                _rowIconText(
                    icon: Icons.location_on, text: normalTrip.picAddress ?? ''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_rounded),
                        const WidthSpacer(width: 0.01),
                        Text(
                            '${FormatDateConstants.convertHHmm(normalTrip.etp ?? '')} - ${FormatDateConstants.convertddMMyyyy(normalTrip.etp!)}'),
                      ],
                    ),
                    Text(TodoResult.getStatusDescription(
                        normalTrip.tripStatus ?? '')),
                    Image.asset(
                      TodoResult.getIconBasedOnStatus(
                        normalTrip.tripStatus ?? '',
                      ),
                      scale: 4,
                    )
                  ],
                ).paddingAll(2.w),
              ],
            ).paddingAll(8.w)
          ],
        ),
      ),
    );
  }

  Widget _simpleTripWidget({required TodoResult simpleTrip}) => InkWell(
        onTap: () async {
          final result = await _navigationService
              .navigateAndDisplaySelection(routes.editTodoTripRoute, args: {
            key_params.tripNo: simpleTrip.tripNo,
            key_params.contactCode: simpleTrip.contactCode,
            key_params.isPendingTodoTrip: isPending,
            key_params.tripNoPending: tripNoPending,
          });
          if (result != null) {
            isPending = false;
            _bloc.add(ToDoTripViewLoaded(generalBloc: generalBloc));
          }
        },
        child: CardCustom(
          padding: EdgeInsets.zero,
          child: Column(children: [
            ColoredBox(
              color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(simpleTrip.tripNo ?? '',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(
                    simpleTrip.contactCode!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ).paddingSymmetric(vertical: 8.h, horizontal: 12.w),
            ),
            Column(
              children: [
                _rowIconText(
                    icon: Icons.import_export_outlined,
                    text: simpleTrip.driverTripTypeDesc ?? ''),
                _rowIconText(
                    icon: Icons.event_note, text: simpleTrip.tripMemo ?? ''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_rounded),
                        const WidthSpacer(width: 0.01),
                        Text(
                            '${FormatDateConstants.convertHHmm(simpleTrip.etp ?? '')} - ${FormatDateConstants.convertddMMyyyy(simpleTrip.etp ?? '')}'),
                      ],
                    ),
                    Text(TodoResult.getStatusDescription(
                        simpleTrip.tripStatus ?? '')),
                    Image.asset(
                      TodoResult.getIconBasedOnStatus(
                        simpleTrip.tripStatus ?? '',
                      ),
                      scale: 4,
                    ),
                  ],
                ),
              ],
            ).paddingAll(8.w)
          ]),
        ),
      );
  Widget _rowIconText({required IconData icon, required String text}) => Row(
        children: [
          Icon(icon),
          const WidthSpacer(width: 0.01),
          Expanded(child: Text(text))
        ],
      ).paddingAll(2.w);
  Widget _countTrip({required int count, required String text}) => Text(
        '${text.tr()} ($count)',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ).paddingOnly(top: 12.h, left: 12.w);
}
