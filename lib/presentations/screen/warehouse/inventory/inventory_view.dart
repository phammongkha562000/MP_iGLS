import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/models/ware_house/inventory/inventory_response.dart';
import 'package:igls_new/data/models/ware_house/pallet_relocation/pallet_relocation_response.dart';

import 'package:igls_new/data/models/ware_house/stock_count/item_code_response.dart';
import 'package:igls_new/data/models/ware_house/stock_count/location_stock_count_response.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../businesses_logics/bloc/ware_house/inventory/inventory_bloc.dart';
import '../../../../data/services/injection/injection_igls.dart';
import '../../../../data/services/navigator/navigation_service.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/card_custom/card_custom.dart';
import '../../../widgets/table_widget/table_widget.dart';
import '../../../widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final searchLocController = TextEditingController();
  final searchItemCodeController = TextEditingController();

  final scanLoc = TextEditingController();
  final scanItem = TextEditingController();

  LocationStockCountResponse? selectedLoc;
  ItemCodeResponse? selectedValueItemCode;
  String? selectedValueItemStatus;

  bool onPressClearLocation = false;
  bool onPressClearItemCode = false;

  final ValueNotifier<String> _locNotifer = ValueNotifier<String>('');
  final ValueNotifier<String> _itemCodeNotifer = ValueNotifier<String>('');
  final ValueNotifier<String> _itemStatusNotifer = ValueNotifier<String>('');

  final _key1 = GlobalKey<FormState>();

  final TextEditingController _grNoController = TextEditingController();
  BehaviorSubject<PalletRelocationResponse> pallet =
      BehaviorSubject<PalletRelocationResponse>();

  BehaviorSubject<List<LocationStockCountResponse>> listLoc = BehaviorSubject();
  BehaviorSubject<List<ItemCodeResponse>> listItemCode = BehaviorSubject();
  BehaviorSubject<List<ReturnModel>> listInventory = BehaviorSubject();
  BehaviorSubject<List<String>> listItem = BehaviorSubject();
  BehaviorSubject<double> totalQty = BehaviorSubject();
  BehaviorSubject<double> totalReserved = BehaviorSubject();

  final _navigationService = getIt<NavigationService>();
  late InventoryBloc _bloc;
  late GeneralBloc generalBloc;
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<InventoryBloc>(context);
    _bloc.add(InventoryLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text("93".tr()),
        actions: [
          IconButton(
              onPressed: () {
                _navigationService
                    .pushNamed(routes.inventoryBarcodeTrackingRoute);
              },
              icon: const Icon(Icons.history, color: Colors.black))
        ],
      ),
      body: BlocConsumer<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is InventorySuccess) {
            listLoc.add(state.listLoc);
            listItemCode.add(state.listItemCode);
            listItem.add(state.listItem ?? []);
            selectedValueItemStatus = state.itemStatus;
            _itemStatusNotifer.value = state.itemStatus;
          }
          if (state is InventorySearchSuccess) {
            listInventory.add(state.listInventory ?? []);
            totalQty.add(state.totalQty ?? 0);
            totalReserved.add(state.totalReserved ?? 0);
          }
          if (state is InventoryFailure) {
            _clear();
            CustomDialog().error(context, err: state.message);
          }
          if (state is GrNoSearchSuccess) {
            pallet.add(state.pallet);
          }
        },
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const ItemLoading();
          }
          return ListView(
            shrinkWrap: true,
            children: [
              _buildCardSearch(),
              _buildGRNo(),
              !listInventory.hasValue
                  ? SizedBox(
                      height: MediaQuery.sizeOf(context).width * 0.03,
                    )
                  : _buildTotal(),
              IntrinsicHeight(
                child: Column(
                  children: [
                    _buildTable(
                        list:
                            listInventory.hasValue ? listInventory.value : []),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardSearch() {
    return CardCustom(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                flex: 4,
                child: TextRichRequired(
                  label: "5160",
                  colorText: colors.defaultColor,
                  isBold: true,
                ),
              ),
              Expanded(
                flex: 7,
                child: StreamBuilder(
                  stream: listLoc.stream,
                  builder: (context, snapshot) {
                    return _chooseLocation(
                        listLocationLocal:
                            listLoc.hasValue ? listLoc.value : []);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () {
                    onPressClearLocation = true;
                    _locNotifer.value = "";
                    selectedLoc = null;
                  },
                  icon: const IconCustom(
                    iConURL: assets.clearFilter,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: TextRichRequired(
                      label: "4867",
                      colorText: colors.defaultColor,
                      isBold: true),
                ),
                Expanded(
                  flex: 7,
                  child: StreamBuilder(
                    stream: listItemCode.stream,
                    builder: (context, snapshot) {
                      return _chooseItemCode(
                          listItemCodeLocal:
                              listItemCode.hasValue ? listItemCode.value : []);
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {
                      onPressClearItemCode = true;
                      _itemCodeNotifer.value = "";
                      selectedValueItemCode = null;
                    },
                    icon: const IconCustom(
                      iConURL: assets.clearFilter,
                      size: 25,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Text(
                    "146".tr(),
                    style: styleTextTitle,
                  )),
              Expanded(
                  flex: 9,
                  child: StreamBuilder(
                    stream: listItem.stream,
                    builder: (context, snapshot) {
                      return _chooseItemStatus();
                    },
                  ))
            ],
          ),
          const HeightSpacer(height: 0.02),
          ElevatedButtonWidget(
            isPadding: false,
            text: "36",
            onPressed: () {
              _onSearchInventory();
            },
          )
        ],
      ),
    );
  }

  Widget _buildGRNo() {
    return CardCustom(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03),
      child: StreamBuilder(
        stream: pallet.stream,
        builder: (context, snapshot) {
          return Form(
            key: _key1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    flex: 4,
                    child: Text(
                      "1262".tr(),
                      style: styleTextTitle,
                    )),
                Expanded(
                    flex: 7,
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        _searchGRNo(grNo: value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '5067'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: ((snapshot.hasData &&
                                  snapshot.data!.gRNo != null))
                              ? _iconClearGR()
                              : _iconBarCodeGR()),
                      controller: _grNoController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                    )),
                Expanded(
                    flex: 2,
                    child: (snapshot.hasData && snapshot.data!.gRNo != null)
                        ? Container(
                            margin: EdgeInsets.only(left: 4.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: colors.defaultColor),
                            child: Text(
                              snapshot.data!.locCode ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textWhite),
                            ),
                          )
                        : const SizedBox())
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _iconClearGR() {
    return IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.red,
        ),
        onPressed: () {
          _grNoController.clear();
          pallet.add(PalletRelocationResponse());
        });
  }

  Widget _iconBarCodeGR() {
    return IconButton(
      icon: Image.asset(
        assets.barCode,
        scale: 3,
      ),
      onPressed: () async {
        final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
        qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
            context: context,
            onCode: (code) {
              setState(() {
                _grNoController.text = code ?? '';
                _searchGRNo(grNo: code ?? '');
              });
            });
      },
    );
  }

  void _onSearchInventory() {
    _bloc.add(InventorySearch(
      generalBloc: generalBloc,
      itemCode: _itemCodeNotifer.value,
      locCode: _locNotifer.value,
      itemStatus: _itemStatusNotifer.value,
    ));
  }

  void _searchGRNo({required String grNo}) {
    if (_key1.currentState!.validate()) {
      _bloc.add(GrNoSearch(grNo: grNo, generalBloc: generalBloc));
    }
  }

  Widget _buildTable({required List<ReturnModel> list}) {
    return TableDataWidget(
        listTableRowHeader: const [
          HeaderTable2Widget(label: '5586', width: 50),
          HeaderTable2Widget(label: '4867', width: 150),
          HeaderTable2Widget(label: '131', width: 300),
          HeaderTable2Widget(label: '180', width: 100),
          HeaderTable2Widget(label: '194', width: 100),
          HeaderTable2Widget(label: '5160', width: 70),
          HeaderTable2Widget(label: '146', width: 100),
        ],
        listTableRowContent: list.isNotEmpty
            ? List.generate(
                list.length,
                (index) {
                  return ColoredBox(
                    color: colorRowTable(index: index),
                    child: InkWell(
                      onTap: () => _navigationService.pushNamed(
                        routes.inventoryDetailRoute,
                        args: {
                          key_params.inventoryDetailBySBNo: list[index].sbno,
                          key_params.inventoryDetailByDCcode:
                              list[index].dcCode,
                          key_params.inventoryDetailByContactCode:
                              list[index].contactCode,
                        },
                      ),
                      child: Row(
                        children: [
                          CellTableWidget(
                              width: 50, content: (index + 1).toString()),
                          CellTableWidget(
                              width: 150, content: list[index].itemCode ?? ''),
                          CellTableWidget(
                              width: 300,
                              content: list[index].itemDesc.toString()),
                          CellTableWidget(
                              width: 100,
                              content: NumberFormatter.numberFormatTotalQty(
                                  list[index].balance ?? 0)),
                          CellTableWidget(
                              width: 100,
                              content: NumberFormatter.numberFormatTotalQty(
                                  list[index].reservedQty ?? 0)),
                          CellTableWidget(
                              width: 70, content: list[index].locCode ?? ''),
                          CellTableWidget(
                              width: 100,
                              content: list[index].itemStatus ?? ''),
                        ],
                      ),
                    ),
                  );
                },
              )
            : [
                const CellTableNoDataWidget(
                  width: 870,
                ),
              ]);
  }

  Widget _chooseItemCode({required List<ItemCodeResponse> listItemCodeLocal}) {
    return ValueListenableBuilder(
      valueListenable: _itemCodeNotifer,
      builder: (context, value, child) {
        return DropdownButtonFormField2<ItemCodeResponse>(
            barrierColor: dropdown_custom.bgDrawerColor(),
            validator: (value) {
              if (value == null) {
                return '5067'.tr();
              }
              return null;
            },
            decoration: dropdown_custom.customInputDecoration(),
            isExpanded: true,
            buttonStyleData: dropdown_custom.customButtonStyleData(),
            menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
            dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
            hint: Text("5168".tr()),
            items: listItemCodeLocal
                .map((item) => _dropDownMenuItemCode(item))
                .toList(),
            selectedItemBuilder: (context) {
              return listItemCodeLocal.map((e) {
                return _buildSelectedItemCode(e);
              }).toList();
            },
            value: selectedValueItemCode,
            onChanged: (value) {
              value as ItemCodeResponse;

              onPressClearItemCode = false;
              _itemCodeNotifer.value = value.itemCode!;
              selectedValueItemCode = value;
            },
            dropdownSearchData: DropdownSearchData(
              searchInnerWidgetHeight: 50,
              searchController: searchItemCodeController,
              searchInnerWidget: dropdown_custom.buildSearch(
                context,
                controller: searchItemCodeController,
                onPressed: () async {
                  final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
                  qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                      context: context,
                      onCode: (code) {
                        setState(() {
                          searchItemCodeController.text = code ?? '';
                        });
                      });
                },
              ),
              searchMatchFn: (item, searchValue) {
                ItemCodeResponse itemNew = item.value as ItemCodeResponse;
                return (itemNew.itemCode
                        .toString()
                        .toUpperCase()
                        .contains(searchValue.toUpperCase())) ||
                    (itemNew.itemDesc
                        .toString()
                        .toUpperCase()
                        .contains(searchValue.toUpperCase()));
              },
            ));
      },
    );
  }

  Widget _chooseLocation(
      {required List<LocationStockCountResponse> listLocationLocal}) {
    return ValueListenableBuilder(
      valueListenable: _locNotifer,
      builder: (context, value, child) {
        return DropdownButtonFormField2<LocationStockCountResponse>(
            barrierColor: dropdown_custom.bgDrawerColor(),
            decoration: dropdown_custom.customInputDecoration(),
            isExpanded: true,
            buttonStyleData: dropdown_custom.customButtonStyleData(),
            menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
            dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
            hint: Text(
              "5161".tr(),
              style: const TextStyle(color: colors.textGrey),
            ),
            items: listLocationLocal
                .map((item) => _dropDownMenuItemLoc(item))
                .toList(),
            selectedItemBuilder: (context) {
              return listLocationLocal.map((e) {
                return _buildSelectedItemLoc(e);
              }).toList();
            },
            value: selectedLoc,
            onChanged: (value) {
              value as LocationStockCountResponse;
              onPressClearLocation = false;
              _locNotifer.value = value.locCode!;
              selectedLoc = value;
            },
            dropdownSearchData: DropdownSearchData(
              searchInnerWidgetHeight: 50,
              searchInnerWidget: dropdown_custom.buildSearch(
                context,
                controller: searchLocController,
                onPressed: () async {
                  final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
                  qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                      context: context,
                      onCode: (code) {
                        setState(() {
                          searchLocController.text = code ?? '';
                        });
                      });
                },
              ),
              searchController: searchLocController,
              searchMatchFn: (item, searchValue) {
                LocationStockCountResponse loc =
                    item.value as LocationStockCountResponse;
                return loc.locCode
                    .toString()
                    .toUpperCase()
                    .contains(searchValue.toUpperCase().toString());
              },
            ));
      },
    );
  }

  Widget _chooseItemStatus() {
    return DropdownButtonFormField2(
      barrierColor: dropdown_custom.bgDrawerColor(),
      decoration: dropdown_custom.customInputDecoration(),
      isExpanded: true,
      buttonStyleData: dropdown_custom.customButtonStyleData(),
      menuItemStyleData: dropdown_custom.customMenuItemStyleData(),
      dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
      items: listItem.hasValue
          ? listItem.value
              .map((item) => _buildDropDownItemStatus(item))
              .toList()
          : [],
      selectedItemBuilder: (context) {
        return listItem.hasValue
            ? listItem.value.map((e) {
                return _buildSelectedItemStatus(item: e);
              }).toList()
            : [];
      },
      value: selectedValueItemStatus,
      onChanged: (value) {
        value as String;
        _itemStatusNotifer.value = value;
      },
    );
  }

  void _clear() {
    selectedLoc = null;
    selectedValueItemCode = null;
    pallet.add(PalletRelocationResponse());
  }

  Widget _buildTotal() {
    if (totalQty.value == 0.0) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).width * 0.03,
      );
    } else {
      return CardCustom(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "4211".tr(),
                      style: styleTextTitle,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      NumberFormatter.numberFormatTotalQty(totalQty.value),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "194".tr(),
                      style: styleTextTitle,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      NumberFormatter.numberFormatTotalQty(totalReserved.value)
                          .toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: colors.textRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  DropdownMenuItem<String> _buildDropDownItemStatus(String item) {
    return DropdownMenuItem<String>(
      value: item,
      child: CardItemDropdownWidget(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item,
                  style: const TextStyle(
                    color: colors.defaultColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<ItemCodeResponse> _dropDownMenuItemCode(
      ItemCodeResponse item) {
    return DropdownMenuItem<ItemCodeResponse>(
        value: item,
        child: dropdown_custom.cardItemDropdown(assetIcon: itemCode, children: [
          Text(item.itemCode ?? "",
              style: const TextStyle(
                color: colors.defaultColor,
                fontWeight: FontWeight.bold,
              )),
          Text(
            item.itemDesc ?? "",
            style: const TextStyle(color: colors.textGrey),
          ),
        ]));
  }

  Widget _buildSelectedItemCode(ItemCodeResponse e) {
    return onPressClearItemCode == true
        ? Text(
            "5168".tr(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: colors.textGrey,
            ),
          )
        : Text(
            e.itemCode ?? "",
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: colors.defaultColor,
              fontWeight: FontWeight.bold,
            ),
          );
  }

  DropdownMenuItem<LocationStockCountResponse> _dropDownMenuItemLoc(
      LocationStockCountResponse item) {
    return DropdownMenuItem<LocationStockCountResponse>(
        value: item,
        child: dropdown_custom
            .cardItemDropdown(assetIcon: assets.locationStock, children: [
          Text(item.locCode ?? "",
              style: const TextStyle(
                color: colors.defaultColor,
                fontWeight: FontWeight.bold,
              )),
        ]));
  }

  Widget _buildSelectedItemStatus({required String item}) {
    return Text(
      item,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: colors.defaultColor,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  Widget _buildSelectedItemLoc(LocationStockCountResponse e) {
    return onPressClearLocation == true
        ? Text(
            "516".tr(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: colors.textGrey,
            ),
          )
        : Text(
            e.locCode ?? "",
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: colors.defaultColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          );
  }
}
