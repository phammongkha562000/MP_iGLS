import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:timeline_tile/timeline_tile.dart';
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../widgets/app_bar_custom.dart';

class UpdateTodoSimpleTripView extends StatefulWidget {
  final String tripNo;
  final String contactCode;
  final String tripNoPending;
  final bool isPendingTrip;
  const UpdateTodoSimpleTripView({
    super.key,
    required this.tripNo,
    required this.contactCode,
    required this.tripNoPending,
    required this.isPendingTrip,
  });
  @override
  State<UpdateTodoSimpleTripView> createState() =>
      _UpdateTodoSimpleTripViewState();
}

class _UpdateTodoSimpleTripViewState extends State<UpdateTodoSimpleTripView> {
  final _localController = TextEditingController();
  final _memoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _navigationService = getIt<NavigationService>();
  String? tripClassCode;
  bool isPickUp = false;
  bool isStartDelivery = false;
  bool isComplete = false;
  bool isEnable = true;

  late UpdateTodoTripBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<UpdateTodoTripBloc>(context);
    isEnable = (widget.isPendingTrip == false) ||
            (widget.isPendingTrip == true &&
                widget.tripNoPending == widget.tripNo)
        ? true
        : false;
    log('enable: $isEnable');
    _bloc.add(UpdateTodoTripViewLoaded(
        contactCode: widget.contactCode,
        tripNo: widget.tripNo,
        generalBloc: generalBloc));
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
    return Form(
      key: _formKey,
      child: PopScope(
        onPopInvoked: (bool didPop) async => _back(context),
        // onPopInvokedWithResult: (didPop, result) => _back(context),
        child: Scaffold(
          appBar: AppBarCustom(
            title: Text(widget.tripNo),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _navigationService
                  .pushNamedAndRemoveUntil(routes.toDoTripRoute),
            ),
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
          ),
          body: BlocListener<UpdateTodoTripBloc, UpdateTodoTripState>(
            listener: (context, state) {
              if (state is UpdateTodoTripSuccess) {
                if (state.isSuccess == true) {
                  CustomDialog().success(context);
                } else if (state.isSuccess == false) {
                  CustomDialog().warning(context,
                      message:
                          '${'5050'.tr()} ${FormatDateConstants.convertyyyyMMddHHmmToHHmm(state.expectedTime.toString())}');
                }
              }
              if (state is UpdateTodoTripFailure) {
                if (state.errorCode == constants.errorNoConnect) {
                  CustomDialog().error(context,
                      btnMessage: '5038'.tr(),
                      err: state.message,
                      btnOkOnPress: () => _bloc.add(UpdateTodoTripViewLoaded(
                          generalBloc: generalBloc,
                          tripNo: widget.tripNo,
                          contactCode: widget.contactCode)));
                  return;
                }
                CustomDialog().error(context, err: state.message);
              }
            },
            child: BlocBuilder<UpdateTodoTripBloc, UpdateTodoTripState>(
              builder: (context, state) {
                if (state is UpdateTodoTripSuccess) {
                  _memoController.text = state.detail.tripMemo ?? '';

                  _localController.text = widget.contactCode;
                  isPickUp = state.detail.pickUpArrival != null &&
                          state.detail.pickUpArrival != ''
                      ? true
                      : false;
                  isStartDelivery = state.detail.startTime != null &&
                          state.detail.startTime != ''
                      ? true
                      : false;
                  isComplete = state.detail.completeTime != null &&
                          state.detail.completeTime != ''
                      ? true
                      : false;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardCustom(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                enabled: false,
                                controller: _localController,
                                decoration:
                                    InputDecoration(label: Text('1272'.tr())),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 25),
                                    label: Text('1276'.tr())),
                                maxLines: 3,
                                minLines: 1,
                                controller: _memoController,
                              ),
                            ),
                            isEnable
                                ? ElevatedButtonWidget(
                                    isPadding: false,
                                    text: '5589',
                                    onPressed: () => _onUpdateMemo(),
                                  )
                                : const SizedBox()
                          ],
                        )),
                        isEnable
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    _buildTimeLine(
                                        text: '139',
                                        time: state.detail.pickUpArrival ?? '',
                                        onPressed: () => _onStatusTrip(
                                            eventType:
                                                EventTypeValue.pickkupEvent),
                                        isEnable: !isPickUp,
                                        isFirst: true),
                                    _buildTimeLine(
                                        text: '5069',
                                        time: state.detail.startTime ?? '',
                                        onPressed: () => _onStatusTrip(
                                            eventType: EventTypeValue
                                                .startDeliveryEvent),
                                        isEnable: (isPickUp && !isStartDelivery)
                                            ? true
                                            : false),
                                    _buildTimeLine(
                                        text: '5071',
                                        time: state.detail.completeTime ?? '',
                                        isEnable: (isPickUp &&
                                                isStartDelivery &&
                                                !isComplete)
                                            ? true
                                            : false,
                                        onPressed: () => _onStatusTrip(
                                            eventType: EventTypeValue
                                                .completedTripEvent),
                                        isLast: true),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  );
                }
                return const ItemLoading();
              },
            ),
          ),
        ),
      ),
    );
  }

  _onUpdateMemo() {
    if (_formKey.currentState!.validate()) {
      _bloc.add(UpdateTodoTripSubmit(
          generalBloc: generalBloc,
          tripMemo: _memoController.text.trim(),
          contactName: _localController.text));
    }
  }

  _onStatusTrip({required String eventType}) {
    _bloc.add(UpdateTodoTripStepStatus(
        eventType: eventType, generalBloc: generalBloc));
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
      width: (MediaQuery.sizeOf(context).width - 16) / 3,
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
          endChild: _buildBtn(
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

  Widget _buildBtn(
      {required String text, required bool isEnable, VoidCallback? onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: isEnable
          ? ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r))),
                  elevation: MaterialStateProperty.all(5),
                  backgroundColor: MaterialStateProperty.all(colors.btnGreen),
                  shadowColor: MaterialStateProperty.all(colors.defaultColor),
                  minimumSize: MaterialStateProperty.all(const Size(220, 30))),
              onPressed: onPressed,
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            )
          : Center(
              child: Text(
                text.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
