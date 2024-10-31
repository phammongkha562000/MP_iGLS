// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/global/global_app.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/services/launchs/launch_helper.dart';

import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/widgets/layout_common.dart';
import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../widgets/app_bar_custom.dart';

class SimpleTripTodoDetailView extends StatefulWidget {
  const SimpleTripTodoDetailView({
    super.key,
    required this.trip,
  });
  final HistoryTrip trip;

  @override
  State<SimpleTripTodoDetailView> createState() =>
      _SimpleTripTodoDetailViewState();
}

class _SimpleTripTodoDetailViewState extends State<SimpleTripTodoDetailView> {
  final _navigationService = getIt<NavigationService>();
  late HistoryTodoDetailSimpleBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<HistoryTodoDetailSimpleBloc>(context);
    _bloc.add(HistoryTodoDetailSimpleLoaded(
      generalBloc: generalBloc,
      tripNo: widget.trip.tripNo ?? '',
      tripClass: widget.trip.driverTripTypeDesc ?? '',
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryTodoDetailSimpleBloc,
        HistoryTodoDetailSimpleState>(
      listener: (context, state) {
        if (state is HistoryTodoDetailSimpleFailure) {
          CustomDialog().error(context, err: state.message);
        }
      },
      child: BlocBuilder<HistoryTodoDetailSimpleBloc,
          HistoryTodoDetailSimpleState>(
        builder: (context, state) {
          if (state is HistoryTodoDetailSimpleSuccess) {
            return Scaffold(
              appBar: AppBarCustom(
                title: Text(state.simpleTodoDetal!.tripNo ?? ""),
                actions: [
                  IconButton(
                      onPressed: () => _navigationService
                              .pushNamed(routes.takePictureRoute, args: {
                            key_params.itemIdPicture: widget.trip.tripNo,
                            key_params.titleGalleryTodo: widget.trip.tripNo,
                            key_params.refNoValue: widget.trip.tripNo,
                            key_params.refNoType: "TRIP",
                            key_params.docRefType: "TRIPD",
                            key_params.allowEdit: true
                          }),
                      icon: const Icon(Icons.photo))
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [buildFirstCard(state), listSimpleOrder(state)],
                ),
              ),
              floatingActionButton: (globalApp.isAllowance ?? false)
                  ? FloatingActionButton.extended(
                      label: Text(
                        '5484'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _navigationService.pushNamed(
                            routes.driverClosingHistoryDetailRoute,
                            args: {
                              key_params.dDCId: widget.trip.dDCId,
                              key_params.etpAllowance:
                                  state.simpleTodoDetal?.etp
                            });
                      },
                    )
                  : const SizedBox(),
            );
          }
          return Scaffold(
              appBar: AppBarCustom(
                title: Text("${'5042'.tr()} . . ."),
              ),
              body: const ItemLoading());
        },
      ),
    );
  }

  ListView listSimpleOrder(HistoryTodoDetailSimpleSuccess state) {
    return ListView.builder(
      padding: LayoutCommon.spaceBottomView,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: state.listSimpleOrderDetail!.length,
      itemBuilder: (context, index) {
        final item = state.listSimpleOrderDetail![index];
        return CardCustom(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.orderNo ?? "",
                    style: styleTextTitle,
                  ),
                  getTextDeliveryResult(
                    item.deliveryResult!,
                  ),
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
                            key_params.itemIdPicture: item.orderNo,
                            key_params.titleGalleryTodo: item.orderNo,
                            key_params.refNoValue: item.orderId.toString(),
                            key_params.refNoType: "EORD",
                            key_params.docRefType: "EXORD",
                            key_params.allowEdit: true
                          });
                        },
                        icon: const Icon(Icons.photo)),
                  ),
                ],
              ),
              12.ph,
              buildCardPickUp(state, item),
              const IconCustom(
                iConURL: assets.arrowDown,
                size: 40,
              ),
              buildCardShipTo(item, context)
              // IconCustom(iConURL: , size: size)
            ],
          ),
        );
      },
    );
  }

  Widget buildCardShipTo(SimpleOrderDetail item, BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    "141".tr(),
                    style: styleTextTitle,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    FormatDateConstants.convertMMddyyyyHHmm(
                        item.orderCompletedDate ?? ""),
                    textAlign: TextAlign.right,
                    style: styleTextTitle,
                  ),
                ),
              ],
            ),
          ),
          12.ph,
          Expanded(
            flex: 0,
            child: Text(
              item.shipTo ?? "",
              style: styleTextTitle,
              textAlign: TextAlign.center,
            ),
          ),
          12.ph,
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: IconCustom(
                  iConURL: assets.location,
                  size: 40,
                ),
              ),
              Expanded(
                flex: 8,
                child: Text(
                  item.shipToAddress ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ).paddingAll(MediaQuery.sizeOf(context).width * 0.02),
          12.ph,
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: IconCustom(
                  iConURL: assets.phone,
                  size: 30,
                ),
              ),
              Expanded(
                flex: 8,
                child: InkWell(
                  onTap: () => item.shipToTel == null || item.shipToTel == ""
                      ? null
                      : LaunchHelpers.launchTel(tel: "${item.shipToTel}"),
                  child: Text(
                    item.shipToTel ?? "",
                    style: TextStyle(
                      color: colors.textBlue100,
                    ),
                  ),
                ),
              ),
            ],
          ).paddingAll(MediaQuery.sizeOf(context).width * 0.02),
        ],
      ),
    );
  }

  CardCustom buildFirstCard(HistoryTodoDetailSimpleSuccess state) {
    return CardCustom(
      child: Column(
        children: [
          itemRow(
            title: "5586",
            content: FormatDateConstants.convertddMMyyyyHHmm2(
                state.simpleTodoDetal!.pickUpArrival ?? ""),
          ),
          itemRow(
            title: "5090",
            content: FormatDateConstants.convertddMMyyyyHHmm2(
                state.simpleTodoDetal!.startTime ?? ""),
          ).paddingSymmetric(vertical: 12.h),
          itemRow(
            title: "4236",
            content: FormatDateConstants.convertddMMyyyyHHmm2(
                state.simpleTodoDetal!.completeTime ?? ""),
          ),
          12.ph,
          itemRow(
            title: "179",
            content: state.simpleTodoDetal == null
                ? ""
                : state.listSimpleOrderDetail!.length.toString(),
          ),
          12.ph,
          itemRow(
            title: "5091",
            content: state.tripClass ?? "",
          ),
        ],
      ),
    );
  }

  Widget buildCardPickUp(
      HistoryTodoDetailSimpleSuccess state, SimpleOrderDetail item) {
    return Card(
      child: Column(
        children: [
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    "139".tr(),
                    style: styleTextTitle,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                      FormatDateConstants.convertMMddyyyyHHmm(
                          state.simpleTodoDetal!.pickUpArrival ?? ""),
                      textAlign: TextAlign.right,
                      style: styleTextTitle),
                ),
              ],
            ),
          ),
          12.ph,
          Expanded(
            flex: 0,
            child: Text(
              item.pickName ?? "",
              style: styleTextTitle,
              textAlign: TextAlign.center,
            ),
          ),
          12.ph,
          Padding(
            padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: IconCustom(
                    iConURL: assets.location,
                    size: 40,
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    "${item.pickAdd1} ${item.pickAddr2} ${item.pickAddr3} ",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.ph,
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: IconCustom(
                  iConURL: assets.phone,
                  size: 30,
                ),
              ),
              Expanded(
                flex: 8,
                child: InkWell(
                  onTap: () => item.pickTel == null || item.pickTel == ""
                      ? null
                      : LaunchHelpers.launchTel(tel: "${item.pickTel}"),
                  child: Text(
                    item.pickTel ?? "",
                    style: TextStyle(
                      color: colors.textBlue100,
                    ),
                  ),
                ),
              ),
            ],
          ).paddingAll(MediaQuery.sizeOf(context).width * 0.02),
        ],
      ),
    );
  }

  Widget itemRow({
    required String title,
    required String content,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            title.tr(),
            style: styleTextTitle,
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget getTextDeliveryResult(String type) {
    String deliveryResult = '';
    Color color = Colors.transparent;
    switch (type) {
      case 'S':
        deliveryResult = "Completed";
        color = colors.textGreen;
        // color = Colors.ge;
        break;
      case 'F':
        deliveryResult = "Fail";
        color = colors.textRed;
        break;
      case 'P':
        deliveryResult = "PartialCompleted";
        color = colors.americanYellow;
        break;
      default:
    }
    return Text(
      deliveryResult,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: sizeTextDefault,
      ),
    );
  }
}
