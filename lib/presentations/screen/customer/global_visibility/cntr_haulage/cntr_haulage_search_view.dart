import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/models/customer/global_visibility/cntr_haulage/get_cntr_haulage_res.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/widgets/customer_component/customer_dropdown/contact_dropdown.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../../businesses_logics/bloc/customer/global_visibility/cntr_haulage/cntr_haulage_search/cntr_haulage_search_bloc.dart';
import '../../../../../data/models/customer/global_visibility/track_and_trace/get_unloc_res.dart';
import '../../../../../data/services/services.dart';
import '../../../../../data/shared/utils/file_utils.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;

class CNTRHaulageSearchView extends StatefulWidget {
  const CNTRHaulageSearchView({super.key});

  @override
  State<CNTRHaulageSearchView> createState() => _CNTRHaulageSearchViewState();
}

class _CNTRHaulageSearchViewState extends State<CNTRHaulageSearchView> {
  final masterBlCtrl = TextEditingController();
  final houseBlCtrl = TextEditingController();
  final carrierBcNoCtrl = TextEditingController();
  final cntrNoCtrl = TextEditingController();
  final itemCodeCtrl = TextEditingController();
  final invNoCtrl = TextEditingController();
  final cdNoCtrl = TextEditingController();
  final poNoCtrl = TextEditingController();
  TextEditingController fromDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(
          DateTime.now().subtract(const Duration(days: 1))));
  DateTime fromDateFormat = DateTime.now().subtract(const Duration(days: 1));
  TextEditingController toDateCtrl = TextEditingController(
      text: FileUtils.formatToStringFromDatetime2(DateTime.now()));
  DateTime toDateFormat = DateTime.now();

  final podCtrl = TextEditingController();
  final polCtrl = TextEditingController();
  ValueNotifier<List<TradeType>> lstTradeType = ValueNotifier([]);
  ValueNotifier<List<Status>> lstStatus = ValueNotifier([]);
  ValueNotifier<List<DayType>> lstDayType = ValueNotifier([]);
  DayType? dayTypeSelected;
  ValueNotifier<List<GetUnlocResult>> lstUnlocPod = ValueNotifier([]);
  ValueNotifier<List<GetUnlocResult>> lstUnlocPol = ValueNotifier([]);
  TradeType? tradeTypeSelected;
  Status? statusSelected;
  GetUnlocResult? unblocPodSelected;
  GetUnlocResult? unblocPolSelected;
  late CNTRHaulageSearchBloc _bloc;
  late CustomerBloc customerBloc;
  BehaviorSubject<List<GetCntrHaulageRes>> lstCntrHaulageCtrl =
      BehaviorSubject<List<GetCntrHaulageRes>>();
  final _navigationService = getIt<NavigationService>();
  String? contactSelected;
  List<WidgetFilter> lstWidget = [];
  List<WidgetFilter> lstWidgetFilter = [];
  final ValueNotifier<List<WidgetFilter>> _lstNotifier =
      ValueNotifier<List<WidgetFilter>>([]);
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    _bloc = BlocProvider.of<CNTRHaulageSearchBloc>(context);
    _bloc.add(CNTRHaulageSearchViewLoaded());
    contactSelected = customerBloc.userLoginRes?.userInfo?.defaultClient ?? '';
    lstWidget = [
      WidgetFilter(
          id: 3,
          widget: buildMasterHouseBL(),
          isSelected: false,
          name: '3604'.tr()),
      WidgetFilter(
          id: 4, widget: _buildHouseBL(), isSelected: false, name: '3606'.tr()),
      WidgetFilter(
          id: 5, widget: _buildCarrier(), isSelected: false, name: '3719'.tr()),
      WidgetFilter(
          id: 6, widget: _buildCNTRNo(), isSelected: false, name: '3645'.tr()),
      WidgetFilter(
          id: 7, widget: _buildInvNo(), isSelected: false, name: '5148'.tr()),
      WidgetFilter(
          id: 8, widget: _buildItemCode(), isSelected: false, name: '128'.tr()),
      WidgetFilter(
          id: 9, widget: _buildCdNo(), isSelected: false, name: '4572'.tr()),
      WidgetFilter(
          id: 10, widget: _buildPoNo(), isSelected: false, name: '3647'.tr()),
      WidgetFilter(
          id: 11,
          widget: _buildTradeType(),
          isSelected: false,
          name: '3762'.tr()),
      WidgetFilter(
          id: 12, widget: _buildStatus(), isSelected: false, name: '1279'.tr()),
      WidgetFilter(
          id: 13, widget: buildPod(), isSelected: false, name: '3643'.tr()),
      WidgetFilter(
          id: 14, widget: buildPol(), isSelected: false, name: '3642'.tr()),
    ];
    _lstNotifier.value = lstWidget;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text('5501'.tr()),
        ),
        body: BlocConsumer<CNTRHaulageSearchBloc, CNTRHaulageSearchState>(
          listener: (context, state) {
            if (state is CNTRHaulageSearchSuccess) {
              lstStatus.value = state.lstStatus;
              lstTradeType.value = state.lstTradeType;
              lstDayType.value = state.lstDayType;

              if (state.lstDayType.isNotEmpty) {
                dayTypeSelected = state.lstDayType
                    .where((element) => element.dateTypeCode == 'PICDATE')
                    .first;
              }
            }
            if (state is GetUnlocPodSuccess) {
              lstUnlocPod.value = state.lstUnloc;
            }
            if (state is GetUnlocPolSuccess) {
              lstUnlocPol.value = state.lstUnloc;
            }
            if (state is GetUnlocFail) {
              CustomDialog()
                  .error(context, err: state.message, btnOkOnPress: () {});
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              child: Column(
                children: [
                  buildDayType(),
                  buildTimePicker(),
                  buildContactCode(),
                  _buildDDSearch(),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: buildBtnSearch(),
      ),
    );
  }

  Widget _buildDDSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: StatefulBuilder(
        builder: (context1, setState1) => Column(
          children: [
            Row(
              children: [
                Text('5506'.tr(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _lstNotifier,
                    builder: (context, value, child) =>
                        DropdownButton<WidgetFilter>(
                      borderRadius: BorderRadius.circular(16.r),
                      elevation: 12,
                      underline: const Divider(),
                      padding: EdgeInsets.fromLTRB(32.w, 8.h, 0, 8.h),
                      focusColor: Colors.amber,
                      items: _lstNotifier.value
                          .map<DropdownMenuItem<WidgetFilter>>(
                              (WidgetFilter value) {
                        return DropdownMenuItem<WidgetFilter>(
                          value: value,
                          child: Text(
                            value.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: value.isSelected
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                        );
                      }).toList(),
                      value: null,
                      isExpanded: true,
                      onChanged: (value) {
                        log(lstWidgetFilter.length.toString());
                        value!.isSelected == false
                            ? setState1(() {
                                lstWidgetFilter.add(value);
                                _lstNotifier.value = _lstNotifier.value
                                    .map((e) => (e.id == value.id)
                                        ? e.copyWith(isSelected: !e.isSelected)
                                        : e)
                                    .toList();
                              })
                            : null;
                      },
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      setState1(() {
                        _clearSearch();
                      });
                    },
                    child: Row(
                      children: [
                        Text('1260'.tr()),
                        const Icon(Icons.close, color: Colors.red),
                      ],
                    ))
              ],
            ),
            ...lstWidgetFilter.map((e) => e.widget),
          ],
        ),
      ),
    );
  }

  buildContactCode() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: CustomerContactDropdown(
            lstContact: [...customerBloc.contactList!.map((e) => e.clientId!)],
            value: contactSelected,
            label: '1326',
            onChanged: (p0) {
              String contactCode = p0 as String;
              contactSelected = contactCode;
              // cntrHaulageBloc.add(GetCntrHaulageEvent(
              //     model: GetCntrHaulageReq(
              //         vessel: "",
              //         branchCode: "",
              //         transportType: "",
              //         contactCode: contactSelected ?? '',
              //         mBLNo: masterBlCtrl.text,
              //         bLNo: houseBlCtrl.text,
              //         carrierBCNo: carrierBcNoCtrl.text,
              //         cNTRNo: cntrNoCtrl.text,
              //         itemCode: itemCodeCtrl.text,
              //         invNo: invNoCtrl.text,
              //         cDNo: cdNoCtrl.text,
              //         pONo: poNoCtrl.text,
              //         tradeType: tradeTypeSelected?.typeCode ?? '',
              //         wOStatus: statusSelected?.statusCode ?? "",
              //         pOD: unblocPodSelected?.unlocCode ?? '',
              //         pOL: unblocPolSelected?.unlocCode ?? "",
              //         dATEF: DateFormat(constants.formatyyyyMMdd)
              //             .format(fromDateFormat),
              //         dATET: DateFormat(constants.formatyyyyMMdd)
              //             .format(toDateFormat),
              //         dateType: dayTypeSelected?.dateTypeCode ?? ''),
              //     strCompany:
              //         customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
            }),
      );
  buildMasterHouseBL() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: masterBlCtrl,
          decoration: InputDecoration(label: Text("3604".tr())),
        ),
      );
  _buildHouseBL() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: houseBlCtrl,
          decoration: InputDecoration(label: Text('3606'.tr())),
        ),
      );
  _buildCarrier() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: carrierBcNoCtrl,
          decoration: InputDecoration(label: Text('3719'.tr())),
        ),
      );
  _buildCNTRNo() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: cntrNoCtrl,
          decoration: InputDecoration(label: Text('3645'.tr())),
        ),
      );
  _buildItemCode() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: itemCodeCtrl,
          decoration: InputDecoration(label: Text('128'.tr())),
        ),
      );
  _buildInvNo() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: invNoCtrl,
          decoration: InputDecoration(label: Text('5148'.tr())),
        ),
      );
  _buildCdNo() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: cdNoCtrl,
          decoration: InputDecoration(label: Text('4572'.tr())),
        ),
      );
  _buildPoNo() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: TextFormField(
          controller: poNoCtrl,
          decoration: InputDecoration(label: Text('3647'.tr())),
        ),
      );
  buildTimePicker() => Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              pickDate(
                  date: fromDateFormat,
                  lastDate: toDateFormat,
                  context: context,
                  function: (selectDate) {
                    fromDateCtrl.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    fromDateFormat = selectDate;
                  });
            },
            child: TextFormField(
              controller: fromDateCtrl,
              enabled: false,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month),
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
                  date: toDateFormat,
                  firstDate: fromDateFormat,
                  context: context,
                  function: (selectDate) {
                    toDateCtrl.text =
                        FileUtils.formatToStringFromDatetime2(selectDate);
                    toDateFormat = selectDate;
                  });
            },
            child: TextFormField(
              controller: toDateCtrl,
              enabled: false,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month),
                  label: Text('5274'.tr())),
            ),
          )),
        ],
      ));
  Widget buildDayType() => Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ValueListenableBuilder(
          valueListenable: lstDayType,
          builder: (context, value, child) {
            return DropdownButtonFormField2(
              value: value.isNotEmpty
                  ? dayTypeSelected ??
                      value
                          .where((element) => element.dateTypeCode == 'PICDATE')
                          .first
                  : DayType(),
              isExpanded: true,
              decoration: InputDecoration(
                label: Text("5533".tr()),
              ),
              onChanged: (value) {
                dayTypeSelected = value as DayType;
              },
              menuItemStyleData:
                  MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
                return ColoredBox(
                  color: colors.defaultColor.withOpacity(0.2),
                  child: child,
                );
              }),
              dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              )),
              selectedItemBuilder: (context) {
                return value.map((e) {
                  return Text(
                    e.dateTypeName ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                }).toList();
              },
              items: value.map<DropdownMenuItem<DayType>>((DayType value) {
                return DropdownMenuItem<DayType>(
                  value: value,
                  child: Text(
                    value.dateTypeName.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
            );
          }));
  _buildTradeType() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: ValueListenableBuilder(
            valueListenable: lstTradeType,
            builder: (context, value, child) {
              return DropdownButtonFormField2(
                value: value.isNotEmpty
                    ? tradeTypeSelected ?? value[0]
                    : TradeType(),
                isExpanded: true,
                decoration: InputDecoration(
                  label: Text("3762".tr()),
                ),
                onChanged: (value) {
                  tradeTypeSelected = value as TradeType;
                },
                selectedItemBuilder: (context) {
                  return value.map((e) {
                    return Text(
                      e.typeName ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }).toList();
                },
                items:
                    value.map<DropdownMenuItem<TradeType>>((TradeType value) {
                  return DropdownMenuItem<TradeType>(
                    value: value,
                    child: Text(
                      value.typeName.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
              );
            }),
      );
  _buildStatus() => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: ValueListenableBuilder(
            valueListenable: lstStatus,
            builder: (context, value, child) {
              return DropdownButtonFormField2(
                value: value.isNotEmpty ? statusSelected ?? value[0] : Status(),
                isExpanded: true,
                decoration: InputDecoration(
                  label: Text("1279".tr()),
                ),
                onChanged: (value) {
                  statusSelected = value as Status;
                },
                selectedItemBuilder: (context) {
                  return value.map((e) {
                    return Text(
                      e.statusName ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }).toList();
                },
                items: value.map<DropdownMenuItem<Status>>((Status value) {
                  return DropdownMenuItem<Status>(
                    value: value,
                    child: Text(
                      value.statusName.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
              );
            }),
      );
  buildPod() {
    final formKey = GlobalKey<FormState>();

    return Form(
        key: formKey,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  onChanged: (value) {
                    lstUnlocPod.value = [];
                    unblocPodSelected = null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '5067'.tr();
                    }
                    return null;
                  },
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
                      unblocPodSelected = null;
                      if (formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _bloc.add(GetUnlocPodEvent(unlocCode: podCtrl.text));
                      }
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
                            borderRadius: BorderRadius.circular(10.r)),
                        margin: EdgeInsets.only(left: 4.w),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ))),
              ),
              const SizedBox(
                width: 8,
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
                                  podCtrl.text =
                                      unblocPodSelected?.unlocCode ?? '';
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
                                items: value
                                    .map<DropdownMenuItem<GetUnlocResult>>(
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
            ])));
  }

  buildPol() {
    final formKey = GlobalKey<FormState>();
    return Form(
        key: formKey,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  onChanged: (value) {
                    lstUnlocPol.value = [];
                    unblocPolSelected = null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '5067'.tr();
                    }
                    return null;
                  },
                  controller: polCtrl,
                  decoration: InputDecoration(label: Text('3642'.tr())),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      unblocPolSelected = null;
                      if (formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _bloc.add(GetUnlocPolEvent(unlocCode: polCtrl.text));
                      }
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
                            borderRadius: BorderRadius.circular(10.r)),
                        margin: EdgeInsets.only(left: 4.w),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ))),
              ),
              const SizedBox(
                width: 8,
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
                                  polCtrl.text =
                                      unblocPolSelected?.unlocCode ?? '';
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
                                items: value
                                    .map<DropdownMenuItem<GetUnlocResult>>(
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
            ])));
  }

  buildBtnSearch() => Padding(
        padding: EdgeInsets.all(8.w),
        child: ElevatedButtonWidget(
            onPressed: () {
              _navigationService
                  .pushNamed(routes.customerCNTRHaulageRoute, args: {
                key_params.cusCNTRHaulageModel: GetCntrHaulageReq(
                    vessel: "",
                    branchCode: "",
                    transportType: "",
                    contactCode: contactSelected ?? '',
                    mBLNo: masterBlCtrl.text,
                    bLNo: houseBlCtrl.text,
                    carrierBCNo: carrierBcNoCtrl.text,
                    cNTRNo: cntrNoCtrl.text,
                    itemCode: itemCodeCtrl.text,
                    invNo: invNoCtrl.text,
                    cDNo: cdNoCtrl.text,
                    pONo: poNoCtrl.text,
                    tradeType: tradeTypeSelected?.typeCode ?? '',
                    wOStatus: statusSelected?.statusCode ?? "",
                    pOD: unblocPodSelected?.unlocCode ?? '',
                    pOL: unblocPolSelected?.unlocCode ?? "",
                    dATEF: DateFormat(constants.formatyyyyMMdd)
                        .format(fromDateFormat),
                    dATET: DateFormat(constants.formatyyyyMMdd)
                        .format(toDateFormat),
                    dateType: dayTypeSelected?.dateTypeCode ?? '')
              });

              // Navigator.pop(context);
              // cntrHaulageBloc.add(GetCntrHaulageEvent(
              //     model: GetCntrHaulageReq(
              //         vessel: "",
              //         branchCode: "",
              //         transportType: "",
              //         contactCode: contactSelected ?? '',
              //         mBLNo: masterBlCtrl.text,
              //         bLNo: houseBlCtrl.text,
              //         carrierBCNo: carrierBcNoCtrl.text,
              //         cNTRNo: cntrNoCtrl.text,
              //         itemCode: itemCodeCtrl.text,
              //         invNo: invNoCtrl.text,
              //         cDNo: cdNoCtrl.text,
              //         pONo: poNoCtrl.text,
              //         tradeType: tradeTypeSelected?.typeCode ?? '',
              //         wOStatus: statusSelected?.statusCode ?? "",
              //         pOD: unblocPodSelected?.unlocCode ?? '',
              //         pOL: unblocPolSelected?.unlocCode ?? "",
              //         dATEF: DateFormat(constants.formatyyyyMMdd)
              //             .format(fromDateFormat),
              //         dATET: DateFormat(constants.formatyyyyMMdd)
              //             .format(toDateFormat),
              //         dateType: dayTypeSelected?.dateTypeCode ?? ''),
              //     strCompany:
              //         customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
            },
            text: '36'),
      );
  void _clearSearch() {
    masterBlCtrl.clear();
    houseBlCtrl.clear();
    carrierBcNoCtrl.clear();
    cntrNoCtrl.clear();
    itemCodeCtrl.clear();
    invNoCtrl.clear();
    cdNoCtrl.clear();
    poNoCtrl.clear();

    podCtrl.clear();
    polCtrl.clear();
    // fromDateCtrl = TextEditingController(
    //     text: FileUtils.formatToStringFromDatetime2(
    //         DateTime.now().subtract(const Duration(days: 1))));
    // fromDateFormat = DateTime.now().subtract(const Duration(days: 1));
    // toDateCtrl = TextEditingController(
    //     text: FileUtils.formatToStringFromDatetime2(DateTime.now()));
    // toDateFormat = DateTime.now();

    // dayTypeSelected = null;

    tradeTypeSelected = null;
    statusSelected = null;
    unblocPodSelected = null;
    unblocPolSelected = null;

    lstWidgetFilter = [];

    _lstNotifier.value = lstWidget;
  }
}

class TradeType {
  final String? typeName;
  final String? typeCode;
  TradeType({this.typeName, this.typeCode});
}

class Status {
  final String? statusName;
  final String? statusCode;
  Status({this.statusName, this.statusCode});
}

class DayType {
  final String? dateTypeName;
  final String? dateTypeCode;
  DayType({this.dateTypeName, this.dateTypeCode});
}

class WidgetFilter {
  final int id;
  final Widget widget;
  final bool isSelected;
  final String name;
  WidgetFilter(
      {required this.id,
      required this.widget,
      required this.isSelected,
      required this.name});

  WidgetFilter copyWith(
      {int? id, Widget? widget, bool? isSelected, String? name}) {
    return WidgetFilter(
      id: id ?? this.id,
      widget: widget ?? this.widget,
      isSelected: isSelected ?? this.isSelected,
      name: name ?? this.name,
    );
  }
}
