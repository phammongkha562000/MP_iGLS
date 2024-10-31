import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/launchs/launch_helper.dart';

import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/screen/local_distribution/todo/button_timeline.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/common/assets.dart' as assets;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../widgets/app_bar_custom.dart';

class TodoSimpleTripDetailView extends StatefulWidget {
  const TodoSimpleTripDetailView(
      {super.key,
      required this.tripNo,
      required this.tripNoPending,
      required this.isPendingTrip});
  final String tripNo;
  final String tripNoPending;
  final bool isPendingTrip;

  @override
  State<TodoSimpleTripDetailView> createState() =>
      _TodoSimpleTripDetailViewState();
}

late TodoSimpleTripDetailBloc _bloc;
late GeneralBloc generalBloc;
final _navigationService = getIt<NavigationService>();

class _TodoSimpleTripDetailViewState extends State<TodoSimpleTripDetailView> {
  final ValueNotifier<String> _failReason = ValueNotifier<String>('1');
  bool isEnable = true;
  bool isPickUp = false;
  bool isStartDelivery = false;
  bool isCompleteTrip = false;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TodoSimpleTripDetailBloc>(context);
    _bloc.add(TodoSimpleTripDetailViewLoaded(
        generalBloc: generalBloc, tripNo: widget.tripNo));
    isEnable = (widget.isPendingTrip == false) ||
            (widget.isPendingTrip == true &&
                widget.tripNoPending == widget.tripNo)
        ? true
        : false;
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
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text(widget.tripNo),
          actions: [
            IconButton(
                onPressed: () => _navigationService
                        .pushNamed(routes.takePictureRoute, args: {
                      key_params.itemIdPicture: widget.tripNo,
                      key_params.titleGalleryTodo: widget.tripNo,
                      key_params.refNoValue: widget.tripNo,
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
        body: BlocConsumer<TodoSimpleTripDetailBloc, TodoSimpleTripDetailState>(
          listener: (context, state) {
            if (state is TodoSimpleTripDetailSuccess) {
              if (state.isSuccess == true) {
                CustomDialog().success(context);
              } else if (state.isSuccess == false) {
                CustomDialog().warning(context,
                    isOk: false,
                    message:
                        '${'5050'.tr()} ${FormatDateConstants.convertyyyyMMddHHmmToHHmm(state.expectedTime.toString())}');
              }
            }
            if (state is TodoSimpleTripDetailFailure) {
              CustomDialog().error(context, err: state.message);
            }
          },
          builder: (context, state) {
            if (state is TodoSimpleTripDetailSuccess) {
              isPickUp = state.detail.pickUpArrival == '' ? false : true;
              isStartDelivery = state.detail.startTime == '' ? false : true;
              isCompleteTrip = state.detail.completeTime == '' ? false : true;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _listGroup(
                    pickUpArrival: state.detail.pickUpArrival ?? '',
                    completeTime: state.detail.completeTime ?? '',
                    startTime: state.detail.startTime ?? '',
                    tripNo: state.detail.tripNo ?? '',
                    listReason: state.listReason!,
                    listGroup: state.listGroup,
                  ),
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
                                time: state.detail.pickUpArrival ?? '',
                                onPressed: () => _bloc.add(
                                    TodoSimpleTripDetailUpdateStatus(
                                        tripNo: state.detail.tripNo!,
                                        eventType: EventTypeValue.pickkupEvent,
                                        generalBloc: generalBloc)),
                                isEnable: !isPickUp,
                                isFirst: true),
                            _buildTimeLine(
                                text: '5069',
                                time: state.detail.startTime ?? '',
                                onPressed: () => _bloc.add(
                                    TodoSimpleTripDetailUpdateStatus(
                                        tripNo: state.detail.tripNo!,
                                        eventType:
                                            EventTypeValue.startDeliveryEvent,
                                        generalBloc: generalBloc)),
                                isEnable: (isPickUp && !isStartDelivery)
                                    ? true
                                    : false),
                            _buildTimeLine(
                                text: '5071',
                                time: state.detail.completeTime ?? '',
                                isEnable: (isPickUp &&
                                        isStartDelivery &&
                                        !isCompleteTrip)
                                    ? true
                                    : false,
                                onPressed: () {
                                  _bloc.add(TodoSimpleTripDetailUpdateStatus(
                                    generalBloc: generalBloc,
                                    tripNo: state.detail.tripNo!,
                                    eventType:
                                        EventTypeValue.completedTripEvent,
                                    deliveryResult:
                                        DeliveryResult.fullSuccessResult,
                                  ));
                                },
                                isLast: true),
                          ],
                        ).paddingSymmetric(vertical: 8.h, horizontal: 8.w)
                      : const SizedBox(),
                  //I'm here
                  isEnable
                      ? isStartDelivery
                          ? ElevatedButtonWidget(
                                  borderRadius: 32.r,
                                  text: '5070'.tr(),
                                  onPressed: state.detail.completeTime == ''
                                      ? () {
                                          _bloc.add(
                                              TodoSimpleTripDetailUpdateStepTripStatus(
                                                  generalBloc: generalBloc,
                                                  orderId: state
                                                          .detail
                                                          .simpleOrderDetails![
                                                              0]
                                                          .orderId ??
                                                      '',
                                                  eventType: EventTypeValue
                                                      .updatePositionEvent
                                                      .toString(),
                                                  tripNo:
                                                      state.detail.tripNo!));
                                        }
                                      : null,
                                  backgroundColor:
                                      state.detail.completeTime == ''
                                          ? null
                                          : colors.btnGreyDisable)
                              .paddingFromLTRB(8.w, 8.h, 8.w, 16.h)
                          : const SizedBox()
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

  Widget _listGroup({
    required List<List<SimpleOrderDetail>> listGroup,
    required String pickUpArrival,
    required String startTime,
    required String completeTime,
    required String tripNo,
    required List<StdCode> listReason,
  }) =>
      Expanded(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(thickness: 2),
          shrinkWrap: true,
          itemCount: listGroup.length,
          itemBuilder: (context, index) {
            List<SimpleOrderDetail> listASC = listGroup[index];
            listASC.sort((a, b) => a.seqNo!.compareTo(b.seqNo!));
            final bool isCompleted = listGroup[index]
                        .where((element) => element.deliveryResult != '')
                        .length ==
                    listGroup[index].length
                ? false
                : true;
            return ExpansionTile(
              backgroundColor: isCompleted ? colors.whiteSmoke : Colors.white,
              tilePadding: EdgeInsets.symmetric(horizontal: 8.w),
              title: Row(
                children: [
                  const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.home),
                  ),
                  6.pw,
                  Expanded(
                    child: Text(
                      listGroup[index].first.pickName ?? '',
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
                      const IconButton(
                          onPressed: null, icon: Icon(Icons.pin_drop)),
                      6.pw,
                      Expanded(
                        child: Text(
                          '${listGroup[index].first.pickAdd1} ${listGroup[index].first.pickAddr2} ${listGroup[index].first.pickAddr3}'
                              .trim(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: listGroup[index].first.pickTel == null ||
                                  listGroup[index].first.pickTel == ''
                              ? null
                              : () {
                                  //call tel
                                  LaunchHelpers.launchTel(
                                      tel: listGroup[index].first.pickTel!);
                                },
                          icon: const Icon(Icons.call)),
                      6.pw,
                      InkWell(
                        onTap: listGroup[index].first.pickTel == null ||
                                listGroup[index].first.pickTel == ''
                            ? null
                            : () {
                                //call tel
                                LaunchHelpers.launchTel(
                                    tel: listGroup[index].first.pickTel!);
                              },
                        child: Text('${listGroup[index].first.pickTel}'),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_drop_down_circle),
              children: <Widget>[
                _listItem(
                  pickUpArrival: pickUpArrival,
                  completeTime: completeTime,
                  startTime: startTime,
                  tripNo: tripNo,
                  listReason: listReason,
                  list: listASC,
                ),
              ],
            );
          },
        ),
      );

  Widget _listItem({
    required List<SimpleOrderDetail> list,
    required String pickUpArrival,
    required String startTime,
    required String completeTime,
    required String tripNo,
    required List<StdCode> listReason,
  }) =>
      ListView.separated(
          padding:
              EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.05),
          separatorBuilder: (context, index) => const Divider(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) => _item(
                item: list[index],
                pickUpArrival: pickUpArrival,
                completeTime: completeTime,
                startTime: startTime,
                tripNo: tripNo,
                listReason: listReason,
              ));

  Widget _item({
    required SimpleOrderDetail item,
    required String pickUpArrival,
    required String startTime,
    required String completeTime,
    required String tripNo,
    required List<StdCode> listReason,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 4.w, bottom: 4.h, right: 4.w),
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colors.defaultColor),
        color: item.deliveryResult != '' ? colors.whiteSmoke : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowIconText(
            widget: const IconButton(
              onPressed: null,
              icon: Icon(Icons.file_copy),
            ),
            text: item.otherRefNo1 == ''
                ? '${item.orderNo}'
                : '${item.orderNo ?? ''} / ${item.otherRefNo1 ?? ''}',
          ),
          _rowIconText(
            text: '${item.shipTo}',
            widget: const IconButton(
              onPressed: null,
              icon: Icon(Icons.home),
            ),
          ),
          _rowIconText(
              text: '${item.shipToAddress}',
              isMap: (item.pickupLat == null ||
                      item.pickupLon == null ||
                      item.shipToLat == null ||
                      item.shipToLon == null ||
                      item.pickupLat == 0 ||
                      item.pickupLon == 0 ||
                      item.shipToLat == 0 ||
                      item.shipToLon == 0)
                  ? false
                  : true,
              onPressed: (item.pickupLat == null ||
                      item.pickupLon == null ||
                      item.shipToLat == null ||
                      item.shipToLon == null ||
                      item.pickupLat == 0 ||
                      item.pickupLon == 0 ||
                      item.shipToLat == 0 ||
                      item.shipToLon == 0)
                  ? null
                  : () {
                      //google map
                      _navigationService.pushNamed(routes.mapViewRoute, args: {
                        key_params.picLat: item.pickupLat,
                        key_params.picLon: item.pickupLon,
                        key_params.shpLat: item.shipToLat,
                        key_params.shpLon: item.shipToLon
                      });
                    },
              widget: const IconButton(
                  onPressed: null, icon: Icon(Icons.pin_drop))),
          _rowIconText(
              text: '${item.shipToTel}',
              widget: IconButton(
                  onPressed: item.shipToTel == null || item.shipToTel == ''
                      ? null
                      : () {
                          LaunchHelpers.launchTel(tel: item.shipToTel!);
                        },
                  icon: const Icon(Icons.call))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _rowIconText(
                  text: (item.eta == null || item.eta == '')
                      ? ''
                      : '${FormatDateConstants.convertHHmm(item.eta ?? '')} - ${FormatDateConstants.convertddMMyyyy(item.eta ?? '')}',
                  widget: const Text(
                    'ETA: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ).paddingAll(8.w),
                ),
              ),
              Expanded(
                child: _rowIconText(
                  text: (item.etd == null || item.etd == '')
                      ? ''
                      : '${FormatDateConstants.convertHHmm(item.etd ?? '')} - ${FormatDateConstants.convertddMMyyyy(item.etd ?? '')}',
                  widget: const Text(
                    'ETD: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ).paddingAll(8.w),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.defaultColor,
                  ),
                  child: IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        _navigationService
                            .pushNamed(routes.takePictureRoute, args: {
                          key_params.itemIdPicture: item.orderNo,
                          key_params.titleGalleryTodo: item.orderNo,
                          key_params.refNoValue: item.orderId.toString(),
                          key_params.refNoType: "EORD",
                          key_params.docRefType: "EXORD",
                          key_params.allowEdit: true
                        });
                      },
                      icon: const Icon(Icons.photo)),
                ).paddingAll(8.w),
              ),
              Expanded(
                flex: 6,
                child: (pickUpArrival != '' &&
                        startTime != '' &&
                        item.orderCompletedDate == '')
                    ? Row(children: [
                        _buildBtnItem(
                            color: colors.btnGreen,
                            label: '2348',
                            onPressed: () =>
                                _onPressedSuccess(item: item, tripNo: tripNo)),
                        _buildBtnItem(
                            color: colors.textAmber,
                            label: '5072',
                            onPressed: () =>
                                _onPressedPartial(item: item, tripNo: tripNo)),
                        _buildBtnItem(
                            color: colors.textRed,
                            label: '2349'.tr(),
                            onPressed: () => _onPressedFail(
                                item: item,
                                listReason: listReason,
                                tripNo: tripNo))
                      ])
                    : _buildStatusOrder(
                        item: item,
                        pickUpArrival: pickUpArrival,
                        startTime: startTime),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBtnItem(
      {required String label,
      required VoidCallback onPressed,
      required Color color}) {
    return Expanded(
      child: ElevatedButtonWidget(
              isPadding: false,
              borderRadius: 32.r,
              backgroundColor: color,
              height: MediaQuery.sizeOf(context).height * 0.05,
              text: label.tr(),
              fontSize: 14,
              onPressed: onPressed)
          .paddingSymmetric(horizontal: 4.w),
    );
  }

//with order
  _onPressedSuccess(
          {required String tripNo, required SimpleOrderDetail item}) =>
      _bloc.add(TodoSimpleTripDetailUpdateOrderStatus(
          generalBloc: generalBloc,
          tripNo: tripNo,
          orderId: item.orderId!,
          eventType: EventTypeValue.updateOrderStatus,
          deliveryResult: DeliveryResult.fullSuccessResult,
          itemNo: int.parse(item.routeItemNo!),
          failReason: ''));
  _onPressedPartial(
          {required String tripNo, required SimpleOrderDetail item}) =>
      _bloc.add(TodoSimpleTripDetailUpdateOrderStatus(
          generalBloc: generalBloc,
          orderId: item.orderId!,
          eventType: EventTypeValue.updateOrderStatus,
          tripNo: tripNo,
          deliveryResult: DeliveryResult.apartSuccessResult,
          itemNo: int.parse(item.routeItemNo!),
          failReason: ""));
  _onPressedFail(
          {required List<StdCode> listReason,
          required String tripNo,
          required SimpleOrderDetail item}) =>
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return ValueListenableBuilder(
              valueListenable: _failReason,
              builder: (BuildContext context2, String value, Widget? child) {
                return AlertDialog(
                  title: Text('4061'.tr()),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                  content: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.1,
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      child: DropdownButton<String>(
                        value: _failReason.value,
                        onChanged: (newValue) async {
                          _failReason.value = newValue!;
                        },
                        items: listReason
                            .map<DropdownMenuItem<String>>((StdCode value) {
                          return DropdownMenuItem<String>(
                            value: value.codeId,
                            child: Text(value.codeDesc!),
                          );
                        }).toList(),
                      )),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('26'.tr()),
                    ),
                    TextButton(
                      onPressed: () {
                        _bloc.add(TodoSimpleTripDetailUpdateOrderStatus(
                            generalBloc: generalBloc,
                            eventType: EventTypeValue.updateOrderStatus,
                            tripNo: tripNo,
                            deliveryResult: DeliveryResult.failResult,
                            failReason: _failReason.value,
                            itemNo: int.parse(item.routeItemNo!),
                            orderId: item.orderId!));
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '5589'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            );
          });
  Widget _buildStatusOrder(
          {required String pickUpArrival,
          required String startTime,
          required SimpleOrderDetail item}) =>
      pickUpArrival != '' && startTime != '' && item.orderCompletedDate != ''
          ? _rowStatusOrder(
              color: item.deliveryResult == 'S'
                  ? colors.textGreen
                  : item.deliveryResult == 'P'
                      ? colors.textAmber
                      : item.deliveryResult == 'F'
                          ? colors.textRed
                          : colors.textGreen,
              text: item.deliveryResult == 'S'
                  ? '2348'.tr()
                  : item.deliveryResult == 'P'
                      ? '5072'.tr()
                      : item.deliveryResult == 'F'
                          ? '2349'.tr()
                          : '2348'.tr(),
              dateTime: item.orderCompletedDate!,
              iconData: item.deliveryResult == 'S'
                  ? Icons.check
                  : item.deliveryResult == 'P'
                      ? Icons.warning
                      : item.deliveryResult == 'F'
                          ? Icons.cancel
                          : Icons.check,
            )
          : const SizedBox();

  Widget _rowStatusOrder(
      {required String text,
      required IconData iconData,
      required Color color,
      required String dateTime}) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
        ),
        6.pw,
        Text(
            '${text.tr()} - ${FormatDateConstants.convertddMMyyyyHHmm2(dateTime)}',
            style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      ],
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
            style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.normal,
                fontSize: fontSize ?? 14),
          )),
          isMap ?? false
              ? IconButton(
                  onPressed: onPressed,
                  icon: Image.asset(
                    assets.kGoogleMap,
                    width: 50.w,
                  ))
              : const SizedBox()
        ],
      );
}
