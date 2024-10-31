import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/cntr_haulage/cntr_haulage_detail/cntr_haulage_detail_bloc.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/customer_component/title_expansion.dart';
import '../../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../../data/services/injection/injection_igls.dart';
import '../../../../../data/services/navigator/navigation_service.dart';
import '../../../../widgets/app_bar_custom.dart';
import '../../../../widgets/table_widget/header_table.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class CNTRHaulageDetailView extends StatefulWidget {
  const CNTRHaulageDetailView(
      {super.key,
      required this.woNo,
      required this.woItemNo,
      required this.status,
      required this.blCarrierNo});
  final String woNo;
  final String blCarrierNo;
  final int woItemNo;
  final String status;
  @override
  State<CNTRHaulageDetailView> createState() => _CNTRHaulageDetailViewState();
}

class _CNTRHaulageDetailViewState extends State<CNTRHaulageDetailView> {
  late CustomerBloc customerBloc;
  late CntrHaulageDetailBloc cntrHaulageDetailBloc;
  TextEditingController blCarrierNoCtrl = TextEditingController();
  TextEditingController polPodCtrl = TextEditingController();
  TextEditingController tradeTypeCtrl = TextEditingController();
  TextEditingController cdDateCtrl = TextEditingController();
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController cusRefNoCtrl = TextEditingController();
  TextEditingController vesselOrFlightCtrl = TextEditingController();
  TextEditingController cdNoCtrl = TextEditingController();
  TextEditingController tractorTrailerCtrl = TextEditingController();
  ValueNotifier<bool> isSubscribed = ValueNotifier(false);
  final _navigationService = getIt<NavigationService>();
  TextEditingController desCtrl = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    cntrHaulageDetailBloc = BlocProvider.of<CntrHaulageDetailBloc>(context)
      ..add(DetailCntrHauLageLoad(
          woNo: widget.woNo,
          woItemNo: widget.woItemNo.toString(),
          subsidiaryId:
              customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBarCustom(
              title: Text('5404'.tr()),
            ),
            body: BlocConsumer<CntrHaulageDetailBloc, CntrHaulageDetailState>(
                listener: (context, state) {
              if (state is DetailCntrHaulageLoadSuccess) {
                desCtrl.text = state.email;
                blCarrierNoCtrl.text = widget.blCarrierNo;
                polPodCtrl.text =
                    "${state.lstWOCDetail[0].pOL ?? ''}/${state.lstWOCDetail[0].pOD ?? ''} ";
                tradeTypeCtrl.text = state.lstWOCDetail[0].tradeType ?? '';
                cdDateCtrl.text = state.lstWOCDetail[0].cDDate ?? '';
                pickUpCtrl.text = state.lstWOCDetail[0].pickDate ?? '';
                cusRefNoCtrl.text = state.lstWOCDetail[0].custRefNo ?? '';
                vesselOrFlightCtrl.text =
                    state.lstWOCDetail[0].vesselorFlight ?? '';
                cdNoCtrl.text = state.lstWOCDetail[0].cDNo ?? '';
                tractorTrailerCtrl.text =
                    "${state.lstWOCDetail[0].tractor ?? ''}/${state.lstWOCDetail[0].trailer ?? ''}";
                if (state.notifyRes.id == 0) {
                  isSubscribed.value = false;
                } else {
                  isSubscribed.value = true;
                }
              }
              if (state is DetailCntrHaulageLoadFail) {
                CustomDialog().error(context, err: state.message,
                    btnOkOnPress: () {
                  Navigator.pop(context);
                });
              }
            }, builder: (context, state) {
              if (state is ShowLoadingState) {
                return const Center(child: ItemLoading());
              }
              return SingleChildScrollView(
                child: Column(
                  children: [buildGeneral(), buildItem(), buildDocuments()],
                ),
              );
            })));
  }

  buildGeneral() => ExpansionTile(
          initiallyExpanded: true,
          title: const TitleExpansionWidget(
              text: '5404', asset: Icon(Icons.gamepad_sharp)),
          childrenPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: blCarrierNoCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("${"3673".tr()} / ${"3609".tr()}"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: polPodCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("3923".tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: tradeTypeCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("3762".tr()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: cdDateCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("3578".tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: pickUpCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("139".tr()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: cusRefNoCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("1275".tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: vesselOrFlightCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("${"3608".tr()}/${"3994".tr()}"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: cdNoCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("4572".tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: tractorTrailerCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text("${"4011".tr()}/${"4012".tr()}"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  widget.status == "COMPLETE"
                      ? const SizedBox()
                      : ValueListenableBuilder<bool>(
                          valueListenable: isSubscribed,
                          builder: (context, value, child) {
                            return Expanded(
                                child: GestureDetector(
                              onTap: () async {
                                final result = await _navigationService
                                    .navigateAndDisplaySelection(
                                        routes.customerNotifySetting,
                                        args: {
                                      key_params.woNo: widget.woNo,
                                      key_params.woItemNo: widget.woItemNo,
                                      key_params.isSubscribed:
                                          isSubscribed.value,
                                      key_params.receiver: desCtrl
                                    });
                                if (result != null) {
                                  cntrHaulageDetailBloc.add(
                                      DetailCntrHauLageLoad(
                                          woNo: widget.woNo,
                                          woItemNo: widget.woItemNo.toString(),
                                          subsidiaryId: customerBloc
                                                  .userLoginRes
                                                  ?.userInfo
                                                  ?.subsidiaryId ??
                                              ''));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                    color: value == true
                                        ? colors.defaultColor
                                        : colors.textGreen,
                                    borderRadius: BorderRadius.circular(24.r)),
                                child: value == true
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.check,
                                            color: colors.textWhite,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "5406".tr(),
                                            style: const TextStyle(
                                                color: colors.textWhite,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "5293".tr(),
                                        style: const TextStyle(
                                            color: colors.textWhite,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ));
                          })
                ],
              ),
            ),
          ]);
  buildItem() => ExpansionTile(
          initiallyExpanded: true,
          title: const TitleExpansionWidget(
              text: '144', asset: Icon(Icons.assignment_rounded)),
          children: [
            emptyDataWidget(_headerTableItem())

            // IntrinsicHeight(
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: StreamBuilder<List<Items>>(
            //         stream: lstItemCtrl.stream,
            //         builder: (context, snapshot) {
            //           if (snapshot.hasData) {
            //             if (snapshot.data != null &&
            //                 snapshot.data!.isNotEmpty) {
            //               return SingleChildScrollView(
            //                 scrollDirection: Axis.horizontal,
            //                 child: Column(
            //                   children: [
            //                     Row(children: _headerTableItem()),
            //                     Expanded(
            //                       child: Scrollbar(
            //                         child: SingleChildScrollView(
            //                           scrollDirection: Axis.vertical,
            //                           child: Column(
            //                             children: List.generate(
            //                                 snapshot.data!.length, (index) {
            //                               final item = snapshot.data![index];
            //                               return ColoredBox(
            //                                 color: colorRowTable(index: index),
            //                                 child: Row(children: [
            //                                   CellTableWidget(
            //                                     width: 120,
            //                                     content: item.itemCode ?? '',
            //                                   ),
            //                                   CellTableWidget(
            //                                     width: 230,
            //                                     content: item.itemDesc ?? '',
            //                                   ),
            //                                   CellTableWidget(
            //                                     width: 100,
            //                                     content: item.grade ?? '',
            //                                   ),
            //                                   CellTableWidget(
            //                                     width: 150,
            //                                     content: item.lotCode ?? '',
            //                                   ),
            //                                   CellTableWidget(
            //                                     width: 150,
            //                                     content:
            //                                         item.productionDate ?? '',
            //                                   ),
            //                                   CellTableWidget(
            //                                     width: 150,
            //                                     content: item.expiredDate ?? '',
            //                                   ),
            //                                   CellTableWidget(
            //                                     width: 150,
            //                                     content: item.qty.toString(),
            //                                   ),
            //                                   CellTableWidget(
            //                                       width: 150,
            //                                       content:
            //                                           item.gRQty.toString()),
            //                                 ]),
            //                               );
            //                             }),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               );
            //             }
            //             return emptyDataWidget(_headerTableItem());
            //           }
            //           return emptyDataWidget(_headerTableItem());
            //         },
            //       )),
            //     ],
            //   ),
            // ),
          ]);
  buildDocuments() => ExpansionTile(
      initiallyExpanded: true,
      title: const TitleExpansionWidget(
          text: '5278', asset: Icon(Icons.edit_document)),
      children: [emptyDataWidget(_headerTableDocuments())]);
  List<Widget> _headerTableItem() {
    return [
      HeaderTable2Widget(label: '128'.tr(), width: 120.w),
      HeaderTable2Widget(label: '131'.tr(), width: 230.w),
      HeaderTable2Widget(label: '133'.tr(), width: 100.w),
      HeaderTable2Widget(label: 'PO No', width: 150.w),
      HeaderTable2Widget(label: 'CustomerPo No'.tr(), width: 150.w),
      HeaderTable2Widget(label: 'CINV No'.tr(), width: 150.w),
    ];
  }

  List<Widget> _headerTableDocuments() {
    return [
      HeaderTable2Widget(label: '5279'.tr(), width: 400.w),
      HeaderTable2Widget(label: '63'.tr(), width: 250.w),
    ];
  }

  emptyDataWidget(List<Widget> headerTable) => Column(children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: headerTable)),
        Padding(
          padding: EdgeInsets.all(8.w),
          child: const EmptyWidget(),
        )
      ]);
  // Widget _buildTitleExpansion({required String text, required Icon assets}) {
  //   return Row(
  //     children: [
  //       assets,
  //       Padding(
  //         padding: EdgeInsets.only(left: 16.w),
  //         child: Text(text.tr()),
  //       )
  //     ],
  //   );
  // }
}
