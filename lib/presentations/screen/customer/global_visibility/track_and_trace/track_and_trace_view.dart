import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/track_and_trace/track_and_trace/track_and_trace_bloc.dart';
import 'package:igls_new/data/models/customer/global_visibility/track_and_trace/get_track_and_trace_req.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../data/models/customer/global_visibility/track_and_trace/get_unloc_res.dart';
import '../../../../../data/models/customer/global_visibility/track_and_trace/track_and_trace_status_res.dart';
import '../../../../../data/shared/utils/file_utils.dart';
import '../../../../widgets/admin_component/header_table.dart';
import '../../../../widgets/app_bar_custom.dart';
import '../../../../widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/dialog/custom_dialog.dart';
import '../../../../widgets/load/load_list.dart';
import '../../../../widgets/pick_date_previous_next.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import '../../../../widgets/table_widget/table_data.dart';

class TrackAndTraceView extends StatefulWidget {
  const TrackAndTraceView({super.key});

  @override
  State<TrackAndTraceView> createState() => _TrackAndTraceViewState();
}

class _TrackAndTraceViewState extends State<TrackAndTraceView> {
  final masterBLCtrl = TextEditingController();
  final houseBLCtrl = TextEditingController();
  final bkNoCtrl = TextEditingController();
  final cntrNoCtrl = TextEditingController();
  final vesselCtrl = TextEditingController();
  final podCtrl = TextEditingController();
  final polCtrl = TextEditingController();
  final fromDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(
          DateTime.now().subtract(const Duration(days: 1))));
  final toDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(DateTime.now()));
  ValueNotifier<List<TrackAndTraceStatusRes>> lstStatus = ValueNotifier([]);
  ValueNotifier<List<GetUnlocResult>> lstUnlocPod = ValueNotifier([]);
  ValueNotifier<List<GetUnlocResult>> lstUnlocPol = ValueNotifier([]);
  BehaviorSubject<List<TrackAndTraceStatusRes>> lstTrackTrace =
      BehaviorSubject<List<TrackAndTraceStatusRes>>();
  TrackAndTraceStatusRes? statusSelected;
  GetUnlocResult? unblocPodSelected;
  GetUnlocResult? unblocPolSelected;
  String? contactSelected;
  late CustomerBloc customerBloc;
  late TrackAndTraceBloc trackAndTraceBloc;
  @override
  void initState() {
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    trackAndTraceBloc = BlocProvider.of<TrackAndTraceBloc>(context)
      ..add(TrackAndTraceLoaded(customerBloc: customerBloc));
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBarCustom(
              title: Text('3641'.tr()),
              actions: [_iconSearch()],
            ),
            body: BlocConsumer<TrackAndTraceBloc, TrackAndTraceState>(
                listener: (context, state) {
              if (state is TrackAndTraceLoadedSuccess) {
                lstStatus.value = state.lstStatus;
              }
              if (state is TrackAndTraceLoadedFail) {
                CustomDialog().error(context, err: state.message,
                    btnOkOnPress: () {
                  Navigator.pop(context);
                });
              }
              if (state is GetUnlocPodSuccessState) {
                lstUnlocPod.value = state.lstUnloc;
              }
              if (state is GetUnlocPolSuccessState) {
                lstUnlocPol.value = state.lstUnloc;
              }
              if (state is GetUnlocFailState) {
                CustomDialog()
                    .error(context, err: state.message, btnOkOnPress: () {});
              }
              if (state is GetTrackAndTraceSuccessState) {
                lstTrackTrace.add(state.lstTrackTrace);
              }
              if (state is GetTrackAndTraceFailState) {}
            }, builder: (context, state) {
              if (state is ShowLoadingState) {
                return const Center(child: ItemLoading());
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(children: [
                  buildLstTrackTrace(),
                ]),
              );
            })));
  }

  Widget _iconSearch() {
    return IconButton(
      icon: const Icon(Icons.search, color: Colors.black),
      onPressed: () async {
        await showModalBottomSheet(
          // backgroundColor: colors.bgDrawerColor,
          builder: (buildContext) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '36'.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shrinkWrap: true,
                        children: [
                          buildMasterHouseBL(),
                          buildBkCNTRNo(),
                          buildTimePicker(),
                          buildVesselStatus(),
                          buildPod(),
                          buildPol(),
                          buildContractCode()
                        ]),
                  ),
                  buildBtnSearch()
                ],
              ),
            );
          },
          context: context,
        );
      },
    );
  }

  buildMasterHouseBL() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: masterBLCtrl,
                decoration: InputDecoration(label: Text('3604'.tr())),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextFormField(
                controller: houseBLCtrl,
                decoration: InputDecoration(label: Text('3606'.tr())),
              ),
            ),
          ],
        ),
      );
  buildBkCNTRNo() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: bkNoCtrl,
                decoration: InputDecoration(label: Text('3644'.tr())),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextFormField(
                controller: cntrNoCtrl,
                decoration: InputDecoration(label: Text('3645'.tr())),
              ),
            ),
          ],
        ),
      );
  buildTimePicker() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              pickDate(
                  lastDate: DateTime.now(),
                  date: DateTime.now(),
                  context: context,
                  function: (selectDate) {
                    fromDateCtrl.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                  });
            },
            child: TextFormField(
              controller: fromDateCtrl,
              enabled: false,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                  label: Text('5273'.tr())),
            ),
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              pickDate(
                  lastDate: DateTime.now(),
                  date: DateTime.now(),
                  context: context,
                  function: (selectDate) {
                    toDateCtrl.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                  });
            },
            child: TextFormField(
              controller: toDateCtrl,
              enabled: false,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                  label: Text('5274'.tr())),
            ),
          )),
        ],
      ));
  buildVesselStatus() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: vesselCtrl,
                decoration: InputDecoration(label: Text('3608'.tr())),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            ValueListenableBuilder(
                valueListenable: lstStatus,
                builder: (context, value, child) {
                  return Expanded(
                    child: DropdownButtonFormField2(
                      value: value.isNotEmpty
                          ? statusSelected ?? value[0]
                          : TrackAndTraceStatusRes(),
                      isExpanded: true,
                      decoration: InputDecoration(
                        label: Text('1279'.tr()),
                      ),
                      onChanged: (value) {
                        statusSelected = value as TrackAndTraceStatusRes;
                      },
                      selectedItemBuilder: (context) {
                        return value.map((e) {
                          return Text(
                            e.statusDesc ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          );
                        }).toList();
                      },
                      items: value
                          .map<DropdownMenuItem<TrackAndTraceStatusRes>>(
                              (TrackAndTraceStatusRes value) {
                        return DropdownMenuItem<TrackAndTraceStatusRes>(
                          value: value,
                          child: Text(
                            value.statusDesc.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                })
          ],
        ),
      );
  buildPod() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: podCtrl,
            decoration: InputDecoration(
              label: Text('3643'.tr()),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                trackAndTraceBloc
                    .add(GetUnlocPodEvent(unlocCode: podCtrl.text));
              },
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            colors.defaultColor,
                            Colors.blue.shade100
                          ]),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))),
        ),
        Expanded(
            flex: 4,
            child: ValueListenableBuilder(
                valueListenable: lstUnlocPod,
                builder: (context, value, child) {
                  return value.isNotEmpty
                      ? DropdownButtonFormField2(
                          value: value.isNotEmpty
                              ? unblocPodSelected ?? value[0]
                              : GetUnlocResult(),
                          isExpanded: true,
                          onChanged: (value) {
                            unblocPodSelected = value as GetUnlocResult;
                          },
                          selectedItemBuilder: (context) {
                            return value.map((e) {
                              return Text(
                                e.placeName ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              );
                            }).toList();
                          },
                          items: value.map<DropdownMenuItem<GetUnlocResult>>(
                              (GetUnlocResult value) {
                            return DropdownMenuItem<GetUnlocResult>(
                              value: value,
                              child: Text(
                                value.placeName.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                        )
                      : const SizedBox();
                }))
      ]));
  buildPol() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: polCtrl,
            decoration: InputDecoration(label: Text('3642'.tr())),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                trackAndTraceBloc
                    .add(GetUnlocPolEvent(unlocCode: polCtrl.text));
              },
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            colors.defaultColor,
                            Colors.blue.shade100
                          ]),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))),
        ),
        Expanded(
            flex: 4,
            child: ValueListenableBuilder(
                valueListenable: lstUnlocPol,
                builder: (context, value, child) {
                  return value.isNotEmpty
                      ? DropdownButtonFormField2(
                          value: value.isNotEmpty
                              ? unblocPolSelected ?? value[0]
                              : GetUnlocResult(),
                          isExpanded: true,
                          onChanged: (value) {
                            unblocPolSelected = value as GetUnlocResult;
                          },
                          selectedItemBuilder: (context) {
                            return value.map((e) {
                              return Text(
                                e.placeName ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              );
                            }).toList();
                          },
                          items: value.map<DropdownMenuItem<GetUnlocResult>>(
                              (GetUnlocResult value) {
                            return DropdownMenuItem<GetUnlocResult>(
                              value: value,
                              child: Text(
                                value.placeName.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                        )
                      : const SizedBox();
                }))
      ]));
  buildContractCode() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomerContactDropdown(
            lstContact: [...customerBloc.contactList!.map((e) => e.clientId!)],
            value: contactSelected,
            label: '1326',
            onChanged: (p0) {
              String contactCode = p0 as String;
              contactSelected = contactCode;
              trackAndTraceBloc.add(GetTrackAndTraceEvent(
                  model: GetTrackAndTraceReq(
                      mblNo: masterBLCtrl.text,
                      blNo: houseBLCtrl.text,
                      bookingNo: bkNoCtrl.text,
                      cntrNo: cntrNoCtrl.text,
                      vessel: vesselCtrl.text,
                      transitStatusCode: statusSelected?.statusCode ?? '',
                      origin: unblocPodSelected?.unlocCode ?? '',
                      destination: unblocPolSelected?.unlocCode ?? '',
                      contactCode: contactSelected ?? '',
                      etdF: fromDateCtrl.text,
                      etdT: toDateCtrl.text),
                  strCompany:
                      customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
            }),
      );
  buildBtnSearch() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButtonWidget(
            onPressed: () {
              trackAndTraceBloc.add(GetTrackAndTraceEvent(
                  model: GetTrackAndTraceReq(
                      mblNo: masterBLCtrl.text,
                      blNo: houseBLCtrl.text,
                      bookingNo: bkNoCtrl.text,
                      cntrNo: cntrNoCtrl.text,
                      vessel: vesselCtrl.text,
                      transitStatusCode: statusSelected?.statusCode ?? '',
                      origin: unblocPodSelected?.unlocCode ?? '',
                      destination: unblocPolSelected?.unlocCode ?? '',
                      contactCode: contactSelected ?? '',
                      etdF: fromDateCtrl.text,
                      etdT: toDateCtrl.text),
                  strCompany:
                      customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
              Navigator.pop(context);
            },
            text: '36'.tr()),
      );
  buildLstTrackTrace() => StreamBuilder<List<TrackAndTraceStatusRes>>(
      stream: lstTrackTrace.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            // return TableDataWidget(
            //     listTableRowHeader: _headerTable(),
            //     listTableRowContent:
            //         List.generate(snapshot.data!.length, (index) {
            //       final item = snapshot.data![index];
            //       return ColoredBox(
            //         color: colorRowTable(index: index),
            //         child: Row(children: [
            //           CellTableWidget(
            //             width: 150,
            //             content: item.clientRefNo ?? '',
            //           ),
            //           CellTableWidget(
            //             width: 210,
            //             content: FileUtils.convertDateForHistoryDetailItem(
            //                 item.receiptDate ?? ''),
            //           ),
            //           CellTableWidget(
            //             width: 210,
            //             content: FileUtils.convertDateForHistoryDetailItem(
            //                 item.eTA ?? ''),
            //           ),
            //           CellTableWidget(
            //             width: 150,
            //             content: item.orderTypeDesc ?? '',
            //           ),
            //           CellTableWidget(
            //             width: 120,
            //             content: item.ordStatusName ?? '',
            //           ),
            //           CellTableWidget(
            //             width: 100,
            //             content: item.dCCode ?? '',
            //           ),
            //           CellTableWidget(
            //             width: 150,
            //             content: item.qty.toString(),
            //           ),
            //           CellTableWidget(
            //               width: 150, content: item.gRQty.toString()),
            //           CellTableWidget(
            //             width: 210,
            //             content: FileUtils.convertDateForHistoryDetailItem(
            //                 item.createDate.toString()),
            //           ),
            //         ]),
            //       );
            //     }));
          }
          return Expanded(
            child: Column(
              children: [
                TableDataWidget(
                    listTableRowHeader: _headerTable(),
                    listTableRowContent: const []),
                Expanded(
                  child: Text(
                    "5058".tr(),
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          );
        }
        return TableDataWidget(
            listTableRowHeader: _headerTable(), listTableRowContent: const []);
      });
  List<Widget> _headerTable() {
    return [
      HeaderTable2Widget(label: '3604'.tr(), width: 150),
      HeaderTable2Widget(label: '3606'.tr(), width: 210),
      HeaderTable2Widget(label: '3718'.tr(), width: 210),
      HeaderTable2Widget(label: '3668'.tr(), width: 150),
      HeaderTable2Widget(label: '3642'.tr(), width: 120),
      HeaderTable2Widget(label: '3643'.tr(), width: 100),
      HeaderTable2Widget(label: '3609'.tr(), width: 150),
      HeaderTable2Widget(label: '${"3608".tr()}/${"3994".tr()}', width: 150),
      HeaderTable2Widget(label: '3840'.tr(), width: 210),
      HeaderTable2Widget(label: '4027'.tr(), width: 210),
      HeaderTable2Widget(label: '3648'.tr(), width: 210),
      HeaderTable2Widget(label: '3582'.tr(), width: 210),
      HeaderTable2Widget(label: '3605'.tr(), width: 210),
      HeaderTable2Widget(label: '62'.tr(), width: 210),
    ];
  }
}
