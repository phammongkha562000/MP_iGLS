import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/shipment_status/shipment_status_bloc.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';

import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/presentations.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../widgets/app_bar_custom.dart';

class ShipmentStatusView extends StatefulWidget {
  const ShipmentStatusView({super.key});

  @override
  State<ShipmentStatusView> createState() => _ShipmentStatusViewState();
}

class _ShipmentStatusViewState extends State<ShipmentStatusView> {
  final _navigationService = getIt<NavigationService>();
  final _blNoController = TextEditingController();
  final _cntrNoController = TextEditingController();
  late ShipmentStatusBloc _bloc;
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<ShipmentStatusBloc>(context);
    _bloc.add(
        ShipmentStatusLoaded(date: DateTime.now(), generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShipmentStatusBloc, ShipmentStatusState>(
      listener: (context, state) {
        if (state is ShipmentStatusLoading) {
          CustomDialog().showCustomDialog(context);
          return;
        } else if (state is ShipmentStatusSuccess) {
          CustomDialog().hideCustomDialog(context);
        }
        if (state is ShipmentStatusFailure) {
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
      child: BlocBuilder<ShipmentStatusBloc, ShipmentStatusState>(
        builder: (context, state) {
          if (state is ShipmentStatusSuccess) {
            final total = state.listShipmentStatus!.length;
            return Scaffold(
              appBar: AppBarCustom(
                title: Text("Shipment Status".tr()),
                actions: [
                  buildSearch(context),
                ],
              ),
              body: PickDatePreviousNextWidget(
                onTapPrevious: () {
                  BlocProvider.of<ShipmentStatusBloc>(context)
                      .add(ShipmentStatusPreviousDate(
                    generalBloc: generalBloc,
                    blNo: _blNoController.text,
                    cntrNo: _cntrNoController.text,
                  ));
                },
                onTapNext: () {
                  BlocProvider.of<ShipmentStatusBloc>(context)
                      .add(ShipmentStatusNextDate(
                    generalBloc: generalBloc,
                    blNo: _blNoController.text,
                    cntrNo: _cntrNoController.text,
                  ));
                },
                onTapPick: (selectedDate) {
                  BlocProvider.of<ShipmentStatusBloc>(context)
                      .add(ShipmentStatusPickDate(
                    generalBloc: generalBloc,
                    pickDate: selectedDate,
                    blNo: _blNoController.text,
                    cntrNo: _cntrNoController.text,
                  ));
                },
                stateDate: state.date,
                quantityText: total <= 0
                    ? "${"sum".tr()} $total ${"record".tr()}"
                    : "${"sum".tr()} $total ${"records".tr()}",
                child: Expanded(
                  child: state.listShipmentStatus!.isEmpty
                      ? const Center(
                          child: EmptyWidget(),
                        )
                      : ListView.builder(
                          itemCount: state.listShipmentStatus!.length,
                          itemBuilder: (context, index) {
                            final item = state.listShipmentStatus![index];

                            String datePickUp = item.startPickupDate == null
                                ? ""
                                : FormatDateConstants.convertddMM(
                                    item.startPickupDate!);
                            String dateLoading = item.startLoadingDate == null
                                ? ""
                                : FormatDateConstants.convertddMM(
                                    item.startLoadingDate!);
                            String dateDelivery = item.startDeliveryDate == null
                                ? ""
                                : FormatDateConstants.convertddMM(
                                    item.startDeliveryDate!);

                            String pickUpStartHour =
                                item.startPickupDate == null
                                    ? ""
                                    : FormatDateConstants.convertHHmm(
                                        item.startPickupDate!);

                            String pickUpEndHour = item.startPickupDate == null
                                ? ""
                                : FormatDateConstants.convertHHmm(
                                    item.endPickupDate ?? "");

                            String loadingStartHour =
                                item.startLoadingDate == null
                                    ? ""
                                    : FormatDateConstants.convertHHmm(
                                        item.startLoadingDate!);
                            String loadingEndHour = item.endLoadingDate == null
                                ? ""
                                : FormatDateConstants.convertHHmm(
                                    item.endLoadingDate!);

                            String deliveveryStartHour =
                                item.startDeliveryDate == null
                                    ? ""
                                    : FormatDateConstants.convertHHmm(
                                        item.startDeliveryDate!);
                            String deliveveryEndHour =
                                item.endDeliveryDate == null
                                    ? ""
                                    : FormatDateConstants.convertHHmm(
                                        item.endDeliveryDate!);

                            var colorCard = item.tradeType == "I"
                                ? colors.defaultColor
                                : colors.textAmber;
                            var colorCardText = item.tradeType == "I"
                                ? colors.textWhite
                                : colors.defaultColor;
                            var itemFirst = item.tradeType == "I"
                                ? item.blNo
                                : item.carrierBcNo;

                            return Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.sizeOf(context).width * 0.02),
                              child: InkWell(
                                onTap: () {
                                  final woNo = item.woNo;
                                  final cntrNo = item.equipmentNo;
                                  String itemNo = item.itemNo.toString();
                                  String bcNo = item.carrierBcNo.toString();
                                  String equipmentType =
                                      item.equipmentType.toString();
                                  log("$woNo \n$cntrNo \n$itemNo");
                                  _navigationService.pushNamed(
                                    routes.shipmentStatusDetailRoute,
                                    args: {
                                      key_params.woNobyShipmentStatus: woNo,
                                      key_params.cntrNobyShipmentStatus: cntrNo,
                                      key_params.itemNobyShipmentStatus: itemNo,
                                      key_params.bcNobyShipmentStatus: bcNo,
                                      key_params.equipmentTypeShipmentStatus:
                                          equipmentType,
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      // color: colorCard,
                                      border: Border.all(color: colorCard)),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: colorCard,
                                        child: Row(
                                          children: [
                                            buildItemRow1(
                                              text: itemFirst ?? "",
                                              colorCard: colorCardText,
                                            ),
                                            buildItemRow1(
                                              text: item.equipmentType ?? "",
                                              colorCard: colorCardText,
                                            ),
                                            buildItemRow1(
                                              text: item.equipmentNo ?? "",
                                              colorCard: colorCardText,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const HeightSpacer(height: 0.02),
                                      Row(
                                        children: [
                                          buildcell(
                                            iCon: assets.container,
                                            colorCard: colorCard,
                                            startTime: pickUpStartHour,
                                            endTime: pickUpEndHour,
                                            date: datePickUp,
                                          ),
                                          buildcell(
                                            iCon: assets.forklift,
                                            colorCard: colorCard,
                                            date: dateLoading,
                                            startTime: loadingStartHour,
                                            endTime: loadingEndHour,
                                          ),
                                          buildcell(
                                            iCon: assets.containercar,
                                            colorCard: colorCard,
                                            date: dateDelivery,
                                            startTime: deliveveryStartHour,
                                            endTime: deliveveryEndHour,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBarCustom(
              title: Text("Shipment Status".tr()),
              actions: const [
                Icon(Icons.search),
              ],
            ),
            body: const ItemLoading(),
          );
        },
      ),
    );
  }

  IconButton buildSearch(BuildContext context) {
    return IconButton(
        onPressed: () {
          void clearText() {
            _blNoController.clear();
            _cntrNoController.clear();
          }

          AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            animType: AnimType.rightSlide,
            title: 'Search Information',
            btnCancelColor: colors.textRed,
            btnOkColor: colors.textGreen,
            btnOkText: "search".tr(),
            body: Column(
              children: [
                Text(
                  "search_information".tr(),
                  style: styleTextTitle,
                ),
                const HeightSpacer(height: 0.02),
                TextFormField(
                  controller: _blNoController,
                  decoration: InputDecoration(
                    label: Text(
                      "BLNo".tr(),
                      style: styleLabelInput,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          clearText();
                        },
                        icon: const IconCustom(
                          iConURL: assets.toastError,
                          size: 25,
                        )),
                  ),
                ),
                const HeightSpacer(height: 0.01),
                TextFormField(
                  controller: _cntrNoController,
                  decoration: InputDecoration(
                      label: Text(
                        "3645".tr(),
                        style: styleLabelInput,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            clearText();
                          },
                          icon: const IconCustom(
                            iConURL: assets.toastError,
                            size: 25,
                          ))),
                ),
              ],
            ),
            // btnCancelOnPress: () {},
            btnOkOnPress: () {
              BlocProvider.of<ShipmentStatusBloc>(context)
                  .add(ShipmentStatusLoaded(
                generalBloc: generalBloc,
                date: DateTime.now(),
                blNo: _blNoController.text,
                cntrNo: _cntrNoController.text,
              ));
            },
          ).show();
        },
        icon: const Icon(Icons.search));
  }

  Widget buildItemRow1({
    required String text,
    required Color colorCard,
  }) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: styleRow1(colorCard),
        ),
      ),
    );
  }

  Widget buildcell({
    required String iCon,
    required Color colorCard,
    String? startTime,
    String? endTime,
    String? date,
  }) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: colorCard)),
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.02),
          child: Column(
            children: [
              date == ""
                  ? const Text("")
                  : Text(
                      date ?? "",
                      style: const TextStyle(
                        color: colors.textBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const HeightSpacer(height: 0.01),
              IconCustom(iConURL: iCon, size: 60),
              const HeightSpacer(height: 0.01),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.textGreen,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: startTime == ""
                            ? Text(
                                "-- : --",
                                textAlign: TextAlign.center,
                                style: styleTime(),
                              )
                            : Text(
                                startTime ?? "-- : --",
                                textAlign: TextAlign.center,
                                style: styleTime(),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.textGreen,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: endTime == ""
                            ? Text(
                                "-- : --",
                                textAlign: TextAlign.center,
                                style: styleTime(),
                              )
                            : Text(
                                endTime ?? "-- : --",
                                textAlign: TextAlign.center,
                                style: styleTime(),
                              ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle styleTime() {
    return const TextStyle(
      color: colors.textWhite,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle styleRow1(Color cororCardText) {
    return TextStyle(
      color: cororCardText,
      fontSize: sizeTextDefault,
      fontWeight: FontWeight.bold,
    );
  }
}
