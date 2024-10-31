// ignore_for_file: unused_field

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/todo_trip/todo_normal_trip_detail/todo_normal_trip_detail_bloc.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/launchs/launch_helper.dart';
import 'package:igls_new/presentations/screen/local_distribution/todo/button_timeline.dart';
import 'package:igls_new/data/models/local_distribution/to_do_trip/to_do_normal_trip_detail_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/enum/event_type.dart';
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/export_widget.dart';
import 'package:igls_new/presentations/widgets/load/load.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/shared/shared.dart';
import '../../../widgets/app_bar_custom.dart';

class ToDoNormalTripDetailView extends StatefulWidget {
  final String tripNo;
  final String tripNoPending;
  final bool isPendingTrip;
  const ToDoNormalTripDetailView(
      {super.key,
      required this.tripNo,
      required this.tripNoPending,
      required this.isPendingTrip});
  @override
  State<ToDoNormalTripDetailView> createState() =>
      _ToDoNormalTripDetailViewState();
}

class _ToDoNormalTripDetailViewState extends State<ToDoNormalTripDetailView> {
  final _tripNoController = TextEditingController();
  final _navigationService = getIt<NavigationService>();
  bool isPickUp = false;
  bool isStartDelivery = false;
  bool isCompleteTrip = false;
  bool isEnable = true;
  late GeneralBloc generalBloc;
  late ToDoNormalTripDetailBloc _bloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<ToDoNormalTripDetailBloc>(context);
    isEnable = (widget.isPendingTrip == false) ||
            (widget.isPendingTrip == true &&
                widget.tripNoPending == widget.tripNo)
        ? true
        : false;
    _bloc.add(ToDoNormalTripDetailViewLoaded(
        tripNo: widget.tripNo, generalBloc: generalBloc));
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.toDoTripRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: BlocListener<ToDoNormalTripDetailBloc, ToDoNormalTripDetailState>(
        listener: (context, state) {
          if (state is ToDoNormalTripDetailSuccess) {
            if (state.isSuccess == true) {
              CustomDialog().success(context);
            } else if (state.isSuccess == false) {
              CustomDialog().warning(context,
                  message:
                      '${'5050'.tr()} ${FormatDateConstants.convertyyyyMMddHHmmToHHmm(state.expectedTime.toString())}');
            }
          }
          if (state is ToDoNormalTripDetailFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        child: BlocBuilder<ToDoNormalTripDetailBloc, ToDoNormalTripDetailState>(
          builder: (context, state) {
            if (state is ToDoNormalTripDetailSuccess) {
              _tripNoController.text = state.tripNo;
              isPickUp = state.detail.tripEvents!
                      .where((element) =>
                          element.eventType == EventTypeValue.pickkupEvent)
                      .toList()
                      .isEmpty
                  ? false
                  : true;
              isStartDelivery = state.detail.tripEvents!
                      .where((element) =>
                          element.eventType ==
                          EventTypeValue.startDeliveryEvent)
                      .toList()
                      .isEmpty
                  ? false
                  : true;
              isCompleteTrip = state.detail.tripEvents!
                      .where((element) =>
                          element.eventType ==
                          EventTypeValue.completedTripEvent)
                      .toList()
                      .isEmpty
                  ? false
                  : true;
              return Scaffold(
                  appBar: AppBarCustom(
                    title: Text(state.tripNo),
                    actions: [
                      IconButton(
                          onPressed: () => _navigationService
                                  .pushNamed(routes.takePictureRoute, args: {
                                key_params.itemIdPicture: state.tripNo,
                                key_params.titleGalleryTodo: state.tripNo,
                                key_params.refNoValue: state.tripNo,
                                key_params.refNoType: "TRIP",
                                key_params.docRefType: "TRIPD",
                                key_params.allowEdit: true
                              }),
                          icon: const Icon(Icons.photo))
                    ],
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _listOrder(
                          detail: state.detail,
                          groupList: state.groupList,
                          tripNo: state.tripNo),
                      isEnable
                          ? const Divider(
                              thickness: 2,
                              color: colors.defaultColor,
                            )
                          : const SizedBox(),
                      isEnable
                          ? Row(
                              children: [
                                _buildTimeLine(
                                    text: '139',
                                    time: state.detail.tripEvents!
                                            .where((element) =>
                                                element.eventType ==
                                                EventTypeValue.pickkupEvent)
                                            .toList()
                                            .isEmpty
                                        ? ''
                                        : state.detail.tripEvents!
                                                .where((element) =>
                                                    element.eventType ==
                                                    EventTypeValue.pickkupEvent)
                                                .single
                                                .eventDateVal ??
                                            '',
                                    onPressed: () =>
                                        _bloc.add(ToDoNormalTripUpdateStatus(
                                          generalBloc: generalBloc,
                                          orgItemNo: 0,
                                          eventType:
                                              EventTypeValue.pickkupEvent,
                                          tripNo: state.tripNo,
                                        )),
                                    isEnable: !isPickUp,
                                    isFirst: true),
                                _buildTimeLine(
                                    text: '5069',
                                    time: state.detail.tripEvents!
                                            .where((element) =>
                                                element.eventType ==
                                                EventTypeValue
                                                    .startDeliveryEvent)
                                            .toList()
                                            .isEmpty
                                        ? ''
                                        : state.detail.tripEvents!
                                                .where((element) =>
                                                    element.eventType ==
                                                    EventTypeValue
                                                        .startDeliveryEvent)
                                                .single
                                                .eventDateVal ??
                                            '',
                                    onPressed: () =>
                                        _bloc.add(ToDoNormalTripUpdateStatus(
                                          generalBloc: generalBloc,
                                          orgItemNo: 0,
                                          eventType:
                                              EventTypeValue.startDeliveryEvent,
                                          tripNo: state.tripNo,
                                        )),
                                    isEnable: (isPickUp && !isStartDelivery)
                                        ? true
                                        : false),
                                _buildTimeLine(
                                    text: '5071',
                                    time: state.detail.tripEvents!
                                            .where((element) =>
                                                element.eventType ==
                                                EventTypeValue
                                                    .completedTripEvent)
                                            .toList()
                                            .isEmpty
                                        ? ''
                                        : state.detail.tripEvents!
                                                .where((element) =>
                                                    element.eventType ==
                                                    EventTypeValue
                                                        .completedTripEvent)
                                                .single
                                                .eventDateVal ??
                                            '',
                                    isEnable: (isPickUp &&
                                            isStartDelivery &&
                                            !isCompleteTrip)
                                        ? true
                                        : false,
                                    onPressed: () =>
                                        _bloc.add(ToDoNormalTripUpdateStatus(
                                          generalBloc: generalBloc,
                                          orgItemNo: 0,
                                          eventType:
                                              EventTypeValue.completedTripEvent,
                                          tripNo: state.tripNo,
                                        )),
                                    isLast: true),
                              ],
                            ).paddingAll(8.w)
                          : const SizedBox(),

                      //I'm here btn
                      isEnable
                          ? isStartDelivery
                              ? ElevatedButtonWidget(
                                      borderRadius: 32.r,
                                      text: '5070',
                                      onPressed: !isCompleteTrip
                                          ? () {
                                              _bloc.add(
                                                  ToDoNormalTripUpdateStatus(
                                                      generalBloc: generalBloc,
                                                      eventType: EventTypeValue
                                                          .updatePositionEvent
                                                          .toString(),
                                                      tripNo: state.tripNo,
                                                      orgItemNo: 0));
                                            }
                                          : null,
                                      backgroundColor: !isCompleteTrip
                                          ? null
                                          : colors.btnGreyDisable)
                                  .paddingFromLTRB(8.w, 8.h, 8.w, 16.h)
                              : const SizedBox()
                          : const SizedBox()
                    ],
                  ));
            }
            return Scaffold(
              appBar: AppBarCustom(),
              body: const ItemLoading(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeLine(
      {required String text,
      required String time,
      required bool isEnable,
      VoidCallback? onPressed,
      bool? isFirst,
      bool? isLast}) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: (MediaQuery.sizeOf(context).width - 20.w) / 3,
      child: TimelineTile(
          axis: TimelineAxis.horizontal,
          isFirst: isFirst ?? false,
          isLast: isLast ?? false,
          indicatorStyle: IndicatorStyle(
              indicatorXY: 0.5,
              width: 30,
              height: 30,
              indicator: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: colors.btnGreen, width: 3),
                      color: time != '' ? colors.btnGreen : Colors.white,
                      shape: BoxShape.circle),
                  child: time != ''
                      ? const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        )
                      : null)),
          alignment: TimelineAlign.manual,
          beforeLineStyle:
              const LineStyle(thickness: 3, color: colors.btnGreen),
          lineXY: 0.3,
          endChild: ButtonTimeLine(
              text: text.tr(),
              isEnable: time == '' && isEnable ? true : false,
              onPressed: onPressed),
          startChild: Center(
              child: Text(
            FormatDateConstants.convertddMMHHmm(time),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))),
    );
  }

  Widget _listOrder(
      {required ToDoNormalTripDetailResponse detail,
      required List<List<OrgTrip>> groupList,
      required String tripNo}) {
    return Expanded(
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                thickness: 2.w,
              ),
          itemCount: groupList.length,
          itemBuilder: (context, index) {
            final bool isCompleted = groupList[index]
                        .where((element) =>
                            element.eventDate != '' &&
                            element.eventDate != null)
                        .length ==
                    groupList[index].length
                ? true
                : false;
            return ExpansionTile(
              iconColor: colors.defaultColor,
              backgroundColor: isCompleted ? colors.whiteSmoke : Colors.white,
              title: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.home),
                      onPressed: null,
                      padding: EdgeInsets.fromLTRB(0, 8.h, 8.w, 8.h)),
                  Expanded(
                    child: Text(
                      groupList[index].first.orgPicName ?? '',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: null,
                        icon: const Icon(Icons.pin_drop),
                        padding: EdgeInsets.fromLTRB(0, 8.h, 8.w, 8.h),
                      ),
                      Expanded(
                        child: Text(groupList[index].first.picToAddr != ''
                            ? groupList[index].first.picToAddr!.trim()
                            : ''),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: groupList[index].first.picTel == null ||
                                  groupList[index].first.picTel == ''
                              ? null
                              : () {
                                  // call tel
                                  LaunchHelpers.launchTel(
                                      tel: groupList[index].first.picTel!);
                                },
                          icon: const Icon(Icons.call)),
                      InkWell(
                          onTap: groupList[index].first.picTel == null ||
                                  groupList[index].first.picTel == ''
                              ? null
                              : () {
                                  // call tel
                                  LaunchHelpers.launchTel(
                                      tel: groupList[index].first.picTel!);
                                },
                          child: Text('${groupList[index].first.picTel}')),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_drop_down_circle),
              children: [
                _listItem(
                    list: groupList[index],
                    item: detail,
                    pickUp: isPickUp,
                    startDelivery: isStartDelivery,
                    completeTrip: isCompleteTrip,
                    tripNo: tripNo)
              ],
            );
          }),
    );
  }

  Widget _listItem({
    required List<OrgTrip> list,
    required ToDoNormalTripDetailResponse item,
    required bool pickUp,
    required bool startDelivery,
    required bool completeTrip,
    required String tripNo,
  }) =>
      ListView.builder(
          padding:
              EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.05),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) => _item(
              item: list[index],
              tripNo: tripNo,
              pickUp: pickUp,
              startDelivery: startDelivery,
              completeTrip: completeTrip,
              completeOrder:
                  list[index].eventDate == '' || list[index].eventDate == null
                      ? false
                      : true));

  Widget _item(
      {required OrgTrip item,
      required bool pickUp,
      required bool startDelivery,
      required String tripNo,
      required bool completeOrder,
      required bool completeTrip}) {
    return Container(
      padding: EdgeInsets.only(left: 4.w, bottom: 4.h, right: 4.w),
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colors.defaultColor),
        color: pickUp && startDelivery && !completeOrder
            ? Colors.white
            : colors.whiteSmoke,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowIconText(
            text: item.clientRefNo == ''
                ? '${item.orderNo}'
                : '${item.orderNo} / ${item.clientRefNo ?? ''}',
            widget: const IconButton(
              onPressed: null,
              icon: Icon(Icons.file_copy),
            ),
          ),
          _rowIconText(
            text: '${item.orgShpName}',
            widget: const IconButton(
              onPressed: null,
              icon: Icon(Icons.home),
            ),
          ),
          _rowIconText(
              text: '${item.shipToAddr}',
              isMap: (item.picLat == '' ||
                      item.picLon == '' ||
                      item.shpLat == '' ||
                      item.shpLon == '' ||
                      item.picLat == null ||
                      item.picLon == null ||
                      item.shpLat == null ||
                      item.shpLon == null)
                  ? false
                  : true,
              onPressed: (item.picLat == '' ||
                      item.picLon == '' ||
                      item.shpLat == '' ||
                      item.shpLon == '' ||
                      item.picLat == null ||
                      item.picLon == null ||
                      item.shpLat == null ||
                      item.shpLon == null)
                  ? null
                  : () {
                      //google map
                      _navigationService.pushNamed(routes.mapViewRoute, args: {
                        key_params.picLat: double.parse(
                            item.picLat == '' ? '0' : item.picLat ?? '0'),
                        key_params.picLon: double.parse(
                            item.picLon == '' ? '0' : item.picLon ?? '0'),
                        key_params.shpLat: double.parse(
                            item.shpLat == '' ? '0' : item.shpLat ?? '0'),
                        key_params.shpLon: double.parse(
                            item.shpLon == '' ? '0' : item.shpLon ?? '0')
                      });
                    },
              widget: const IconButton(
                  onPressed: null, icon: Icon(Icons.pin_drop))),
          Row(
            children: [
              IconButton(
                onPressed: item.shpTel == null || item.shpTel == ''
                    ? null
                    : () {
                        LaunchHelpers.launchTel(tel: item.shpTel!);
                      },
                icon: const Icon(Icons.call),
              ),
              const WidthSpacer(width: 0.01),
              InkWell(
                  onTap: item.shpTel == null || item.shpTel == ''
                      ? null
                      : () {
                          LaunchHelpers.launchTel(tel: item.shpTel!);
                        },
                  child: Text(
                    '${item.shpTel}',
                  )),
            ],
          ).paddingAll(2.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.defaultColor,
                ),
                child: IconButton(
                    color: Colors.white,
                    onPressed: () async {
                      _navigationService
                          .pushNamed(routes.takePictureRoute, args: {
                        key_params.itemIdPicture: item.ordeId.toString(),
                        key_params.titleGalleryTodo: item.orderNo.toString(),
                        key_params.refNoValue: item.ordeId.toString(),
                        key_params.refNoType: "ORD",
                        key_params.docRefType: "OT",
                        key_params.allowEdit: true
                      });
                    },
                    icon: const Icon(Icons.photo)),
              ).paddingAll(8.w),
              pickUp && startDelivery && !completeOrder && !completeTrip
                  ? ElevatedButtonWidget(
                      borderRadius: 32.r,
                      isPadding: false,
                      backgroundColor: colors.btnGreen,
                      width: 0.4,
                      text: '5055'.tr(),
                      onPressed: pickUp && startDelivery && !completeOrder
                          ? () => _bloc.add(ToDoNormalTripUpdateOrgItemStatus(
                              generalBloc: generalBloc,
                              orgItemNo: int.parse(item.routeItemNo ?? '0'),
                              eventType: EventTypeValue.updateOrderStatus,
                              tripNo: tripNo))
                          : null,
                    )
                  : pickUp && startDelivery && completeOrder
                      ? _rowStatus(
                          text: '4126',
                          dateTime: item.eta ?? '',
                          icon: const Icon(
                            Icons.check,
                            color: colors.textGreen,
                          ),
                        )
                      : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  Widget _rowIconText(
          {required String text,
          FontWeight? fontWeight,
          double? fontSize,
          bool? isMap,
          VoidCallback? onPressed,
          Widget? widget}) =>
      Row(
        children: [
          widget ?? const SizedBox(),
          const WidthSpacer(width: 0.01),
          Expanded(
              child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.normal,
                fontSize: fontSize ?? 14),
          )),
          isMap ?? false
              ? IconButton(
                  onPressed: onPressed,
                  icon: Image.asset(
                    assets.kGoogleMap,
                    width: 40.w,
                  ),
                  style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all(colors.defaultColor),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all(Colors.amber),
                      elevation: MaterialStateProperty.all(3)),
                )
              : const SizedBox()
        ],
      );

  Widget _rowStatus(
          {required String text,
          required String dateTime,
          required Icon icon}) =>
      Row(
        children: [
          icon,
          const WidthSpacer(width: 0.02),
          // 10.pw,
          Text(
            text.tr(),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ).paddingAll(MediaQuery.sizeOf(context).width * 0.02);
}
