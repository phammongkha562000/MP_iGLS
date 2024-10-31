import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/global/global_app.dart';

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/widgets/layout_common.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/services.dart';
import '../../../widgets/app_bar_custom.dart';

class NormalTripTodoDetailView extends StatefulWidget {
  const NormalTripTodoDetailView({
    super.key,
    required this.trip,
  });
  final HistoryTrip trip;

  @override
  State<NormalTripTodoDetailView> createState() =>
      _NormalTripTodoDetailViewState();
}

class _NormalTripTodoDetailViewState extends State<NormalTripTodoDetailView> {
  final _navigationService = getIt<NavigationService>();
  late GeneralBloc generalBloc;
  late HistoryTodoDetailNormalBloc _bloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<HistoryTodoDetailNormalBloc>(context);
    _bloc.add(HistoryTodoDetailNormalLoaded(
        tripNoNormal: widget.trip.tripNo ?? '', generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryTodoDetailNormalBloc,
        HistoryTodoDetailNormalState>(
      listener: (context, state) {
        if (state is HistoryTodoDetailNormalFailure) {
          CustomDialog().error(context, err: state.message);
        }
      },
      child: BlocBuilder<HistoryTodoDetailNormalBloc,
          HistoryTodoDetailNormalState>(
        builder: (context, state) {
          if (state is HistoryTodoDetailNormalSuccess) {
            return Scaffold(
              appBar: AppBarCustom(
                title: Text(state.tripNormal.tripNo ?? ""),
                actions: [
                  IconButton(
                      onPressed: () => _navigationService
                              .pushNamed(routes.takePictureRoute, args: {
                            key_params.itemIdPicture: state.tripNormal.tripNo,
                            key_params.titleGalleryTodo:
                                state.tripNormal.tripNo,
                            key_params.refNoValue: state.tripNormal.tripNo,
                            key_params.refNoType: "TRIP",
                            key_params.docRefType: "TRIPD",
                            key_params.allowEdit: true
                          }),
                      icon: const Icon(Icons.photo))
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    (state.tripNormal.markerStepInfos?.isNotEmpty == true)
                        ? buildFirstCard(state)
                        : const SizedBox(),
                    (state.listGroupByOrder?.isNotEmpty == true)
                        ? listNormalOrder(state)
                        : const SizedBox(),
                  ],
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
                            routes
                                .driverClosingHistoryDetailRoute /* routes.manualDriverClosingRoute */,
                            args: {
                              // key_params.tripHistory: widget.trip,
                              key_params.dDCId: widget.trip.dDCId,
                              key_params.etpAllowance: state.tripNormal.etp
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

  ListView listNormalOrder(HistoryTodoDetailNormalSuccess state) {
    return ListView.builder(
      padding: LayoutCommon.spaceBottomView,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: state.listGroupByOrder!.length,
      itemBuilder: (context, index) {
        final item = state.listGroupByOrder![index];
        return CardCustom(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item[0].clientRefNo.toString(),
                    style: styleTextTitle,
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
                            key_params.itemIdPicture:
                                item.first.orderId.toString(),
                            key_params.titleGalleryTodo:
                                item.first.clientRefNo.toString(),
                            key_params.refNoValue:
                                item.first.orderId.toString(),
                            key_params.refNoType: "ORD",
                            key_params.docRefType: "OT",
                            key_params.allowEdit: true
                          });
                        },
                        icon: const Icon(Icons.photo)),
                  ),
                ],
              ),
              const HeightSpacer(height: 0.01),
              item.where((element) => element.routeType == 'PIC').isEmpty
                  ? const SizedBox()
                  : buildCardPickUp(
                      itemPickUp: item
                          .where((element) => element.routeType == 'PIC')
                          .first),
              const IconCustom(
                iConURL: assets.arrowDown,
                size: 40,
              ),
              item.where((element) => element.routeType == 'SHP').isEmpty
                  ? const SizedBox()
                  : buildCardShipTo(
                      itemShipTo: item
                          .where((element) => element.routeType == 'SHP')
                          .first),
            ],
          ),
        );
      },
    );
  }

  Widget buildCardPickUp({required TripPlanOrder itemPickUp}) {
    return Card(
      child: Column(
        children: [
          Container(
            color: Colors.blue[100],
            child: Padding(
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
                ],
              ),
            ),
          ),
          const HeightSpacer(height: 0.01),
          Expanded(
            flex: 0,
            child: Text(
              itemPickUp.orgName ?? "",
              style: styleTextTitle,
              textAlign: TextAlign.center,
            ),
          ),
          const HeightSpacer(height: 0.01),
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
                    "${itemPickUp.orgAddr1} ${itemPickUp.orgAddr2}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const HeightSpacer(height: 0.01),
        ],
      ),
    );
  }

  Widget buildCardShipTo({required TripPlanOrder itemShipTo}) {
    return Card(
      child: Column(
        children: [
          Container(
            color: Colors.blue[100],
            child: Padding(
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
                ],
              ),
            ),
          ),
          const HeightSpacer(height: 0.01),
          Expanded(
            flex: 0,
            child: Text(
              itemShipTo.orgName ?? "",
              style: styleTextTitle,
              textAlign: TextAlign.center,
            ),
          ),
          const HeightSpacer(height: 0.01),
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
                    "${itemShipTo.orgAddr1} ${itemShipTo.orgAddr2}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const HeightSpacer(height: 0.01),
        ],
      ),
    );
  }

  ListView listTripPlanOrder(HistoryTodoDetailNormalSuccess state) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: state.listTripPlanOrder!.length,
      itemBuilder: (context, index) {
        final itemPlanOrder = state.listTripPlanOrder![index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemPlanOrder.orgName ?? "",
                  style: styleTextTitle,
                ),
                const HeightSpacer(height: 0.01),
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: IconCustom(iConURL: assets.kFile, size: 24),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(itemPlanOrder.clientRefNo ?? ''),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: IconCustom(iConURL: assets.location, size: 40),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(
                            "${itemPlanOrder.orgAddr1} ${itemPlanOrder.orgAddr2}"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  CardCustom buildFirstCard(HistoryTodoDetailNormalSuccess state) {
    return CardCustom(
      child: Column(
        children: [
          buildItemFirstCard(
            title: "5586",
            content: FormatDateConstants.convertddMMyyyyHHmm2(state
                    .tripNormal.markerStepInfos!
                    .where((element) =>
                        element.eventType == EventTypeValue.startDeliveryEvent)
                    .first
                    .eventDate ??
                ''),
          ),
          const HeightSpacer(height: 0.01),
          buildItemFirstCard(
            title: "5090",
            content: FormatDateConstants.convertddMMyyyyHHmm2(state
                    .tripNormal.markerStepInfos!
                    .where((element) =>
                        element.eventType == EventTypeValue.completedTripEvent)
                    .first
                    .eventDate ??
                ''),
          ),
          const HeightSpacer(height: 0.01),
          buildItemFirstCard(
            title: "2500",
            content: state.tripNormal.tripTypeDesc ?? "",
          ),
          const HeightSpacer(height: 0.01),
          buildItemFirstCard(
            title: "2489",
            content: state.tripNormal.tripStatus ?? "",
          ),
          const HeightSpacer(height: 0.01),
          buildItemFirstCard(
            title: "2499",
            content: state.tripNormal.driverId ?? "",
          ),
          const HeightSpacer(height: 0.01),
        ],
      ),
    );
  }

  Row buildItemFirstCard({
    required String title,
    required String content,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title.tr(),
            style: styleTextTitle,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
