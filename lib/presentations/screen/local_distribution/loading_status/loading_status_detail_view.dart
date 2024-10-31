import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:igls_new/businesses_logics/bloc/local_distribution/loading_status/loading_status_detail/loading_status_detail_bloc.dart';
import 'package:igls_new/data/models/local_distribution/loading_status/loading_status_response.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/file_utils.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/presentations.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../widgets/app_bar_custom.dart';

class LoadingStatusDetailView extends StatefulWidget {
  const LoadingStatusDetailView({
    super.key,
    required this.itemLoadingStatus,
    required this.etp,
  });
  final LoadingStatusResponse itemLoadingStatus;
  final DateTime etp;
  @override
  State<LoadingStatusDetailView> createState() =>
      _LoadingStatusDetailViewState();
}

class _LoadingStatusDetailViewState extends State<LoadingStatusDetailView> {
  final TextEditingController _loadingMemoController = TextEditingController();
  final _navigationService = getIt<NavigationService>();
  late GeneralBloc generalBloc;

  bool isPickUp = false;
  bool isLoadingStart = false;
  bool isLoadingEnd = false;
  bool isStartDelivery = false;
  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationService.pushReplacementNamed(routes.loadingStatusRoute,
          args: {key_params.etpLoadingStatus: widget.etp});
    });
    return false;
  }

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text('5140'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, widget.etp),
          ),
        ),
        body: BlocListener<LoadingStatusDetailBloc, LoadingStatusDetailState>(
          listener: (context, state) {
            if (state is LoadingStatusSaveSuccess) {
              CustomDialog().success(context);
            }
            if (state is LoadingStatusDetailFailure) {
              if (state.errorCode == constants.errorNoConnect) {
                CustomDialog().error(context,
                    err: state.message,
                    btnMessage: '5038'.tr(),
                    btnOkOnPress: () => Navigator.of(context).pop());

                return;
              }
              CustomDialog().error(context, err: state.message);
            }
          },
          child: BlocBuilder<LoadingStatusDetailBloc, LoadingStatusDetailState>(
            builder: (context, state) {
              if (state is LoadingStatusDetailSuccess) {
                isPickUp = (state.detail.pickUpTime != null &&
                        state.detail.pickUpTime != '')
                    ? true
                    : false;
                isLoadingStart = (state.detail.loadingStart != null &&
                        state.detail.loadingStart != '')
                    ? true
                    : false;
                isLoadingEnd = (state.detail.loadingEnd != null &&
                        state.detail.loadingEnd != '')
                    ? true
                    : false;
                isStartDelivery = (state.detail.deliveryTime != null &&
                        state.detail.deliveryTime != '')
                    ? true
                    : false;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(8.w),
                  child: Column(children: [
                    _buildInfo(detail: state.detail),
                    _buildTimeLine(
                        text: '5141',
                        time: (state.detail.pickUpTime != null &&
                                state.detail.pickUpTime != '')
                            ? FileUtils.converFromDateTimeToStringddMMHHmm(
                                state.detail.pickUpTime ?? '')
                            : '',
                        isFirst: true,
                        isEnable: !isPickUp,
                        onPressed: () {
                          BlocProvider.of<LoadingStatusDetailBloc>(context)
                              .add(state.detail.tripNo!.startsWith('S')
                                  ? (LoadingTripDetailUpdateStatus(
                                      generalBloc: generalBloc,
                                      tripNo: state.detail.tripNo!,
                                      eventType: EventTypeValue.pickkupEvent,
                                    ))
                                  : LoadingNormalTripUpdateStatus(
                                      generalBloc: generalBloc,
                                      orgItemNo: 0,
                                      eventType: EventTypeValue.pickkupEvent,
                                      tripNo: state.detail.tripNo ?? '',
                                    ));
                        }),
                    _buildTimeLine(
                        text: '5142',
                        time: (state.detail.loadingStart != null &&
                                state.detail.loadingStart != '')
                            ? FileUtils.converFromDateTimeToStringddMMHHmm(
                                state.detail.loadingStart!)
                            : '',
                        onPressed: () {
                          BlocProvider.of<LoadingStatusDetailBloc>(context).add(
                              LoadingStatusSave(
                                  generalBloc: generalBloc,
                                  loadingMemo: _loadingMemoController.text,
                                  loadingStart: DateTime.now().toString(),
                                  loadingEnd: null,
                                  tripNo:
                                      widget.itemLoadingStatus.tripNo ?? ''));
                          _loadingMemoController.clear();
                        },
                        isEnable: (isPickUp && !isLoadingStart) ? true : false),
                    _buildTimeLine(
                        text: '5143',
                        time: (state.detail.loadingEnd != null &&
                                state.detail.loadingEnd != '')
                            ? FileUtils.converFromDateTimeToStringddMMHHmm(
                                state.detail.loadingEnd!)
                            : '',
                        onPressed: () {
                          BlocProvider.of<LoadingStatusDetailBloc>(context).add(
                              LoadingStatusSave(
                                  generalBloc: generalBloc,
                                  loadingMemo: _loadingMemoController.text,
                                  loadingStart: FileUtils
                                      .converFromDateTimeToStringddMMyyyy2(
                                          state.detail.loadingStart ?? ''),
                                  loadingEnd: DateTime.now().toString(),
                                  tripNo:
                                      widget.itemLoadingStatus.tripNo ?? ''));
                          _loadingMemoController.clear();
                        },
                        isEnable: (isPickUp && isLoadingStart && !isLoadingEnd)
                            ? true
                            : false),
                    _buildTimeLine(
                        text: '5069',
                        time: (state.detail.deliveryTime != null &&
                                state.detail.deliveryTime != '')
                            ? FileUtils.converFromDateTimeToStringddMMHHmm(
                                state.detail.deliveryTime!)
                            : '',
                        isLast: true,
                        onPressed: () {
                          BlocProvider.of<LoadingStatusDetailBloc>(context)
                              .add(state.detail.tripNo!.startsWith('S')
                                  ? (LoadingTripDetailUpdateStatus(
                                      generalBloc: generalBloc,
                                      tripNo: state.detail.tripNo!,
                                      eventType:
                                          EventTypeValue.startDeliveryEvent,
                                    ))
                                  : LoadingNormalTripUpdateStatus(
                                      generalBloc: generalBloc,
                                      orgItemNo: 0,
                                      eventType:
                                          EventTypeValue.startDeliveryEvent,
                                      tripNo: state.detail.tripNo ?? '',
                                    ));
                        },
                        isEnable: (isPickUp &&
                                isLoadingStart &&
                                isLoadingEnd &&
                                !isStartDelivery)
                            ? true
                            : false),
                    const SizedBox(
                      height: 24,
                    ),
                    (isPickUp &&
                                isLoadingStart &&
                                isLoadingEnd &&
                                isStartDelivery) ||
                            (!isPickUp) ||
                            (isLoadingEnd && !isStartDelivery)
                        ? const SizedBox()
                        : _buildTextFieldMemo()
                  ]),
                );
              }
              return const ItemLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfo({required LoadingStatusResponse detail}) {
    return Card(
        margin: EdgeInsets.only(top: 8.h, bottom: 24.h),
        elevation: 8,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 12,
                decoration: BoxDecoration(
                    color: colors.defaultColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r))),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 12.h),
                      child: Text(
                        detail.tripNo ?? '',
                        style: const TextStyle(
                            color: colors.defaultColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    const Divider(indent: 0),
                    _rowInfo(title: '1298', content: detail.equipment ?? ''),
                    _rowInfo(
                        title: 'ETP',
                        content: FileUtils.converFromDateTimeToStringddMMyyyy(
                            detail.etp ?? '')),
                    _rowInfo(title: '1276', content: detail.loadingMemo ?? ''),
                    _rowInfo(title: '95', content: detail.qty.toString()),
                    const Divider(indent: 0),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            detail.staffName ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTimeLine(
      {required String text,
      required String time,
      required bool isEnable,
      VoidCallback? onPressed,
      bool? isFirst,
      bool? isLast}) {
    return TimelineTile(
        isFirst: isFirst ?? false,
        isLast: isLast ?? false,
        indicatorStyle: IndicatorStyle(
            indicatorXY: 0.5,
            width: 30,
            height: 30,
            indicator: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(color: colors.defaultColor, width: 3),
                    color: time != '' ? colors.defaultColor : Colors.white,
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
            const LineStyle(thickness: 3, color: colors.defaultColor),
        lineXY: 0.3,
        endChild: _buildBtn(
            text: text.tr(),
            isEnable: time == '' && isEnable ? true : false,
            onPressed: onPressed),
        startChild: Center(
            child: Text(
          time,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )));
  }

  Widget _buildBtn(
      {required String text, required bool isEnable, VoidCallback? onPressed}) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: isEnable
          ? ElevatedButtonWidget(
              text: text,
              isPadding: false,
              onPressed: onPressed,
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget _rowInfo({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 16.w),
      child: RowFlex3and7(
          child3: Text('${title.tr()}:'),
          child7: Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.w600),
          )),
    );
  }

  Widget _buildTextFieldMemo() => TextFormField(
        maxLines: 5,
        controller: _loadingMemoController,
        decoration: InputDecoration(
            label: Text('1276'.tr()),
            hintText: '${'1276'.tr()}...',
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w)),
      );
}
