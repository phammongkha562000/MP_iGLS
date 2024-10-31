// ignore_for_file: unused_import
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:tab_container/tab_container.dart';

import 'package:igls_new/businesses_logics/bloc/freight_fowarding/shipment_status/shipment_status_detail/shipment_status_detail_bloc.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/presentations.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../widgets/app_bar_custom.dart';

class ShipmentStatusDetailView extends StatefulWidget {
  const ShipmentStatusDetailView({
    super.key,
    required this.woNo,
    required this.cntrNo,
    required this.itemNo,
    required this.bcNO,
    required this.equipmentType,
  });
  final String woNo;
  final String cntrNo;
  final String itemNo;
  final String bcNO;
  final String equipmentType;
  @override
  State<ShipmentStatusDetailView> createState() =>
      _ShipmentStatusDetailViewState();
}

class _ShipmentStatusDetailViewState extends State<ShipmentStatusDetailView>
    with SingleTickerProviderStateMixin {
  final _cntrNoController = TextEditingController();
  final _sealNoController = TextEditingController();
  final _refNoController = TextEditingController();

  final _tractorPickupController = TextEditingController();
  final _trailerPickupController = TextEditingController();
  final _startPickupController = TextEditingController();
  final _endPickupController = TextEditingController();
  //
  final _tractorLoadingController = TextEditingController();
  final _trailerLoadingController = TextEditingController();
  final _startLoadingController = TextEditingController();
  final _endLoadingController = TextEditingController();
  //
  final _tractorDeliveryController = TextEditingController();
  final _trailerDeliveryController = TextEditingController();
  final _startDeliveryController = TextEditingController();
  final _endDeliveryController = TextEditingController();

  // final _tapController = TabController(length: 3, vsync: null);
  late final TabController _controller;
  late ShipmentStatusDetailBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<ShipmentStatusDetailBloc>(context);
    _bloc.add(ShipmentStatusDetailLoaded(
      generalBloc: generalBloc,
      woNo: widget.woNo,
      cntrNo: widget.cntrNo,
      itemNo: widget.itemNo,
      bcNO: widget.bcNO,
      equipmentType: widget.equipmentType,
    ));
    super.initState();
    _controller = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text("ShipmentStatus".tr()),
      ),
      body: BlocListener<ShipmentStatusDetailBloc, ShipmentStatusDetailState>(
        listener: (context, state) {
          if (state is ShipmentStatusDetailFailure) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showToastWidget(
                ErrorToast(error: state.message),
                position: StyledToastPosition.top,
                animation: StyledToastAnimation.slideFromRightFade,
                context: context,
              );
            });
          }
        },
        child: BlocBuilder<ShipmentStatusDetailBloc, ShipmentStatusDetailState>(
          builder: (context, state) {
            log("$state");
            if (state is ShipmentStatusDetailSuccess) {
              _cntrNoController.text =
                  state.listOrderEquipments![0].equipmentNo ?? "";
              _sealNoController.text =
                  state.listOrderEquipments![0].sealNo ?? "";
              _refNoController.text = state.listOrderEquipments![0].refNo ?? "";

              // log("${state.listEquipTasks}");

              return SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Column(
                          children: [
                            buildCarrierBCNo(state),
                            Card(
                              elevation: 12,
                              color: colors.bgDrawerColor,
                              shadowColor: colors.textGrey,
                              child: Column(
                                children: [
                                  buidRowInCard(
                                    textLeft: "CNTRNo",
                                    controller: _cntrNoController,
                                  ),
                                  buidRowInCard(
                                    textLeft: "SealNo",
                                    controller: _sealNoController,
                                  ),
                                  buidRowInCard(
                                    textLeft: "RefNo",
                                    controller: _refNoController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const HeightSpacer(height: 0.01),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {
                      //         log("$_tapController");
                      //         _tapController.prev();
                      //       },
                      //       icon: Icon(Icons.arrow_back),
                      //     ),
                      //     IconButton(
                      //       onPressed: () => _tapController.next(),
                      //       icon: Icon(Icons.arrow_forward),
                      //     ),
                      //   ],
                      // ),
                      // TabBar(tabs: [
                      //   Text("PickUp".tr()),
                      //   Text("Loading".tr()),
                      //   Text("Return".tr())
                      // ])

                      AspectRatio(
                        aspectRatio: 10 / 9,
                        child: TabContainer(
                          controller: _controller,
                          color: colors.textBlue100,
                          selectedTextStyle: const TextStyle(
                            fontSize: 15.0,
                          ),
                          unselectedTextStyle: const TextStyle(
                            fontSize: 13.0,
                          ),
                          // isStringTabs: false,
                          tabs: _getTabs3(context),
                          // onEnd: () {
                          //   log("a");
                          // },
                          children: [
                            formPickUp(),
                            formLoading(),
                            formDelivery(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: LoadingNoBox(),
            );
          },
        ),
      ),
      bottomNavigationBar:
          ElevatedButtonWidget(text: "update", onPressed: () {}),
    );
  }

  Widget formPickUp() {
    log("formPickup");
    return Column(
      children: [
        buidRowInCard(
          textLeft: "Tractor",
          controller: _tractorPickupController,
        ),
        buidRowInCard(
          textLeft: "Trailer",
          controller: _trailerPickupController,
        ),
        buidRowInCard(
          textLeft: "Start",
          controller: _startPickupController,
        ),
        buidRowInCard(
          textLeft: "End",
          controller: _endPickupController,
        ),
      ],
    );
  }

  Widget formLoading() {
    log("Loading");
    return Column(
      children: [
        buidRowInCard(
          textLeft: "Tractor",
          controller: _tractorLoadingController,
        ),
        buidRowInCard(
          textLeft: "Trailer",
          controller: _trailerLoadingController,
        ),
        buidRowInCard(
          textLeft: "Start",
          controller: _startLoadingController,
        ),
        buidRowInCard(
          textLeft: "End",
          controller: _endLoadingController,
        ),
      ],
    );
  }

  Widget formDelivery() {
    log("Return");
    return Column(
      children: [
        buidRowInCard(
          textLeft: "Tractor",
          controller: _tractorDeliveryController,
        ),
        buidRowInCard(
          textLeft: "Trailer",
          controller: _trailerDeliveryController,
        ),
        buidRowInCard(
          textLeft: "Start",
          controller: _startDeliveryController,
        ),
        buidRowInCard(
          textLeft: "End",
          controller: _endDeliveryController,
        ),
      ],
    );
  }

  Widget buidRowInCard({
    required String textLeft,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
      child: RowFlex3and7(
        child3: Text(
          textLeft.tr(),
          style: styleTextTitle,
        ),
        child7: TextFormField(
          controller: controller,
        ),
      ),
    );
  }

  Widget buildCarrierBCNo(ShipmentStatusDetailSuccess state) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Text(
            "${"Carrier_BC_No".tr()}: ${state.bcNo}",
            style: styleTextTitle,
          ),
        ),
        Expanded(
          flex: 3,
          child: CardCustom(
            color: Colors.blueAccent,
            child: Text(
              state.equipmentType ?? "",
              style: const TextStyle(
                color: colors.textWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _getTabs3(BuildContext context) {
    log("$context");
    return <Widget>[
      Text("PickUp".tr()),
      Text("Loading".tr()),
      Text("Return".tr())

      // Padding(
      //   padding: const EdgeInsets.all(5.0),
      //   child: Column(
      //     children: [
      //       const IconCustom(iConURL: assets.arrowDown, size: 20),
      //       Text("PickUp".tr())
      //     ],
      //   ),
      // ),
      // Padding(
      //   padding: const EdgeInsets.all(5.0),
      //   child: Column(
      //     children: [
      //       const IconCustom(iConURL: assets.arrowDown, size: 20),
      //       Text("Loading".tr())
      //     ],
      //   ),
      // ),
      // Padding(
      //   padding: const EdgeInsets.all(5.0),
      //   child: Column(
      //     children: [
      //       const IconCustom(iConURL: assets.arrowDown, size: 20),
      //       Text("Return".tr())
      //     ],
      //   ),
      // ),
    ];
  }
}
