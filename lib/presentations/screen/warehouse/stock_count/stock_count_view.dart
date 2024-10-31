import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:igls_new/businesses_logics/bloc/ware_house/stock_count/stock_count_bloc.dart';
import 'package:igls_new/data/shared/global/global_stock_count.dart';
import 'package:igls_new/data/shared/utils/format_number.dart';

import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/header_table.dart';
import 'package:igls_new/presentations/widgets/table_widget/table_data.dart';
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/models.dart';
import '../../../widgets/app_bar_custom.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/strings.dart' as strings;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import '../../../widgets/dropdown_custom/dropdown_custom.dart'
    as dropdown_custom;

class StockCountView extends StatefulWidget {
  const StockCountView({super.key});

  @override
  State<StockCountView> createState() => _StockCountViewState();
}

class _StockCountViewState extends State<StockCountView> {
  final _formKeyStock = GlobalKey<FormState>();
  final List<int> listRound = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final _countDTController = TextEditingController();
  final _dateController = TextEditingController();
  final _qtyController = TextEditingController();
  final _memoController = TextEditingController();
  late int round;
  final ValueNotifier<String> _locationNotifer = ValueNotifier<String>('');
  final ValueNotifier<ItemCodeResponse> _itemCodeNotifer =
      ValueNotifier<ItemCodeResponse>(
          ItemCodeResponse(itemCode: '', itemDesc: '', itemId: ''));
  final defaultDate =
      DateFormat(constants.formatyyyyMMdd).format(DateTime.now());

  final scanLocation = TextEditingController();
  final scanItem = TextEditingController();

  final _itemDescController = TextEditingController();

  bool onPressCopyLoc = false;
  bool onPressCopyItemCode = false;

  String? selectedValueLocation;
  ItemCodeResponse? selectedValueItemCode;

  String? uomSelected;

  final searchLocController = TextEditingController();
  final searchItemCodeController = TextEditingController();
  late StockCountBloc _bloc;
  late GeneralBloc generalBloc;

  void clearText() {
    _dateController.clear();
    _qtyController.clear();
    _memoController.clear();
  }

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<StockCountBloc>(context);
    _bloc.add(StockCountViewLoaded(round: 1, generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _countDTController.text = defaultDate;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text("3725".tr()),
        ),
        body: BlocConsumer<StockCountBloc, StockCountState>(
          listener: (context, state) {
            if (state is StockCountSuccess) {
              if (state.saveSuccess == true || state.deleteSucess == true) {
                CustomDialog().success(context);
                clearText();
              }
            }
            if (state is StockCountFailure) {
              CustomDialog().error(context, err: state.message);
              clearText();
            }
          },
          builder: (context, state) {
            if (state is StockCountSuccess) {
              round = state.round;
              uomSelected = state.uomLst.first.codeId;
              return SingleChildScrollView(
                child: Form(
                  key: _formKeyStock,
                  child: Column(
                    children: [
                      CardCustom(
                        child: Column(
                          children: [
                            _buildItem(
                                title: "5169",
                                controller: _countDTController,
                                enable: false),
                            _buildPadding(child: _buildTeam()),
                            _buildLocation(state: state),
                            _buildPadding(child: _buildItemCode(state)),
                            _showItemDesc(),
                            _buildPadding(child: _buildDate(context)),
                            _buildQty(context),
                            _buildPadding(child: _buildUOM(state: state)),
                            _buildItem(
                                title: "1276", controller: _memoController),
                          ],
                        ),
                      ),
                      ElevatedButtonWidget(
                          text: "37",
                          onPressed: () {
                            if (_formKeyStock.currentState!.validate()) {
                              _bloc.add(StockCountSave(
                                  generalBloc: generalBloc,
                                  itemCode: _itemCodeNotifer.value.itemCode!,
                                  locCode: _locationNotifer.value,
                                  quantity: double.parse(_qtyController.text),
                                  round: round,
                                  yyyymm: _dateController.text,
                                  memo: _memoController.text,
                                  uom: uomSelected ?? ''));
                            }
                          }),
                      const HeightSpacer(height: 0.005),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.sizeOf(context).width * 0.02,
                            0,
                            MediaQuery.sizeOf(context).width * 0.02,
                            40.h),
                        child: state.stockCountList.isEmpty
                            ? _buildTableNodata(context)
                            : _buildTable(
                                context,
                                list: state.stockCountList,
                                itemCodeList: state.itemCodeList,
                                totalQty: NumberFormatter.numberFormatTotalQty(
                                    state.totalQty),
                                totalRows:
                                    state.stockCountList.length.toString(),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildPadding({required Widget child}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: child,
      );
  Widget _buildUOM({required StockCountSuccess state}) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(
              "UOM".tr(),
              style: styleTextTitle,
            )),
        Expanded(
          flex: 7,
          child: DropdownButtonFormField2<String>(
            barrierColor: dropdown_custom.bgDrawerColor(),
            decoration: dropdown_custom.customInputDecoration(),
            isExpanded: true,
            buttonStyleData: dropdown_custom.customButtonStyleData(),
            menuItemStyleData: MenuItemStyleData(
              selectedMenuItemBuilder: (context, child) {
                return ColoredBox(
                  color: colors.defaultColor.withOpacity(0.2),
                  child: child,
                );
              },
            ),
            dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
            hint: Text("UOM".tr()),
            items: state.uomLst.map((item) => _dropDownMenuOUM(item)).toList(),
            value: uomSelected,
            onChanged: (value) {
              uomSelected = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _showItemDesc() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "131".tr(),
            style: styleTextTitle,
          ),
        ),
        Expanded(
          flex: 7,
          child: TextFormField(
            decoration:
                const InputDecoration(fillColor: Colors.white, filled: true),
            enabled: false,
            controller: _itemDescController,
            style: const TextStyle(color: colors.textBlack, fontSize: 13),
            minLines: 1,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildLocation({required StockCountSuccess state}) {
    return Row(
      children: [
        const Expanded(
          flex: 3,
          child: TextRichRequired(
              label: "5161", colorText: colors.defaultColor, isBold: true),
        ),
        Expanded(
          flex: 7,
          child: ValueListenableBuilder(
            valueListenable: _locationNotifer,
            builder: (context, value, child) {
              return Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: DropdownButtonFormField2<String>(
                        barrierColor: dropdown_custom.bgDrawerColor(),
                        validator: (value) {
                          if (value == null) {
                            return '5067'.tr();
                          }
                          return null;
                        },
                        decoration: dropdown_custom.customInputDecoration(),
                        isExpanded: true,
                        buttonStyleData:
                            dropdown_custom.customButtonStyleData(),
                        menuItemStyleData:
                            dropdown_custom.customMenuItemStyleData(),
                        dropdownStyleData:
                            dropdown_custom.customDropdownStyleData(context),
                        hint: Text("5161".tr()),
                        items: state.locationList
                            .map((item) => _dropDownMenuLocation(item))
                            .toList(),
                        value: onPressCopyLoc
                            ? selectedValueLocation =
                                globalStockCount.getLastLocation
                            : selectedValueLocation,
                        onChanged: (value) {
                          _locationNotifer.value = value.toString();
                          if (globalStockCount.getLastLocation == null) {
                            if (onPressCopyLoc) {
                              _locationNotifer.value =
                                  globalStockCount.getLastLocation;
                            }
                            selectedValueLocation = value as String;
                            globalStockCount.setLastLocation =
                                selectedValueLocation;
                          } else {
                            selectedValueLocation = value as String;
                            globalStockCount.setLastLocation =
                                selectedValueLocation;
                          }
                        },
                        dropdownSearchData: DropdownSearchData(
                          searchInnerWidgetHeight: 50,
                          searchController: searchLocController,
                          searchInnerWidget: dropdown_custom.buildSearch(
                            context,
                            controller: searchLocController,
                            onPressed: () async {
                              final qrBarCodeScannerDialogPlugin =
                                  QrBarCodeScannerDialog();
                              qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                                  context: context,
                                  onCode: (code) {
                                    setState(() {
                                      searchLocController.text = code ?? '';
                                    });
                                  });
                            },
                          ),
                          searchMatchFn: (item, searchValue) {
                            return (item.value
                                .toString()
                                .toUpperCase()
                                .contains(searchValue.toUpperCase()));
                          },
                        ),
                        selectedItemBuilder: (context) {
                          return state.locationList.map((e) {
                            return Text(
                              e.locDesc ?? '',
                              textAlign: TextAlign.left,
                            );
                          }).toList();
                        },
                      )),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {
                        onPressCopyLoc = true;
                        if (globalStockCount.getLastLocation != null) {
                          _locationNotifer.value =
                              globalStockCount.getLastLocation;
                        } else {
                          showToastWidget(
                            ErrorToast(
                              error: '5049'.tr(),
                            ),
                            position: StyledToastPosition.top,
                            animation: StyledToastAnimation.slideFromRightFade,
                            context: context,
                          );
                        }
                        Timer(
                            const Duration(seconds: 1),
                            () => setState(() {
                                  onPressCopyLoc = false;
                                }));
                      },
                      icon: Icon(Icons.content_copy_sharp, size: 24.w),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _dropDownMenuOUM(StdCode item) {
    return DropdownMenuItem<String>(
      value: item.codeId,
      child: Text(item.codeDesc ?? ""),
    );
  }

  DropdownMenuItem<String> _dropDownMenuLocation(
      LocationStockCountResponse item) {
    return DropdownMenuItem<String>(
      value: item.locCode,
      child: dropdown_custom.cardItemDropdown(
        assetIcon: assets.locationStock,
        children: [
          Text(item.locCode ?? ""),
        ],
      ),
    );
  }

  Widget _buildItemCode(StockCountSuccess state) {
    return Row(
      children: [
        const Expanded(
          flex: 3,
          child: TextRichRequired(
              label: "128", colorText: colors.defaultColor, isBold: true),
        ),
        Expanded(
          flex: 7,
          child: ValueListenableBuilder(
            valueListenable: _itemCodeNotifer,
            builder: (context, value, child) {
              return Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: DropdownButtonFormField2<ItemCodeResponse>(
                      barrierColor: dropdown_custom.bgDrawerColor(),
                      validator: (value) {
                        if (value == null) {
                          return '5067'.tr();
                        }
                        return null;
                      },
                      isExpanded: true,
                      decoration: dropdown_custom.customInputDecoration(),
                      buttonStyleData: dropdown_custom.customButtonStyleData(),
                      menuItemStyleData:
                          dropdown_custom.customMenuItemStyleData(),
                      dropdownStyleData:
                          dropdown_custom.customDropdownStyleData(context),
                      hint: Text("128".tr()),
                      items: state.itemCodeList
                          .map((item) => _dropDownMenuItemCode(item))
                          .toList(),
                      value: onPressCopyItemCode
                          ? selectedValueItemCode = _itemCodeNotifer.value
                          : selectedValueItemCode,
                      onChanged: (value) {
                        value as ItemCodeResponse;
                        _itemCodeNotifer.value = value;
                        if (globalStockCount.getLastItemCode == null) {
                          if (onPressCopyItemCode) {
                            value = state.itemCodeList
                                .where((element) =>
                                    element.itemCode ==
                                    globalStockCount.getLastItemCode)
                                .single;
                            _itemCodeNotifer.value = value;
                          }
                          selectedValueItemCode = value;
                          globalStockCount.setLastItemCode =
                              selectedValueItemCode!.itemCode;
                          _itemDescController.text = value.itemDesc!;
                        } else {
                          selectedValueItemCode = value;
                          globalStockCount.setLastItemCode =
                              selectedValueItemCode!.itemCode;
                          _itemDescController.text = value.itemDesc!;
                        }
                      },
                      dropdownSearchData: DropdownSearchData(
                        searchInnerWidgetHeight: 50,
                        searchController: searchItemCodeController,
                        searchInnerWidget: dropdown_custom.buildSearch(
                          context,
                          controller: searchItemCodeController,
                          onPressed: () async {
                            final qrBarCodeScannerDialogPlugin =
                                QrBarCodeScannerDialog();
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
                          ItemCodeResponse itemCode =
                              item.value as ItemCodeResponse;

                          return (itemCode.itemCode
                                  .toString()
                                  .toUpperCase()
                                  .contains(searchValue.toUpperCase())) ||
                              (TiengViet.parse(itemCode.itemDesc.toString())
                                  .toUpperCase()
                                  .contains(TiengViet.parse(searchValue)
                                      .toUpperCase()));
                        },
                      ),
                      selectedItemBuilder: (context) {
                        return state.itemCodeList.map((e) {
                          return Text(
                            e.itemCode ?? '',
                            textAlign: TextAlign.left,
                          );
                        }).toList();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {
                        onPressCopyItemCode = true;
                        if (globalStockCount.getLastItemCode != null) {
                          _itemCodeNotifer.value = state.itemCodeList
                              .where((element) =>
                                  element.itemCode ==
                                  globalStockCount.getLastItemCode)
                              .single;
                          _itemDescController.text =
                              _itemCodeNotifer.value.itemDesc!;
                        } else {
                          _itemDescController.text = "5058".tr();
                          showToastWidget(
                            ErrorToast(
                              error: '5049'.tr(),
                            ),
                            position: StyledToastPosition.top,
                            animation: StyledToastAnimation.slideFromRightFade,
                            context: context,
                          );
                        }
                        Timer(
                            const Duration(seconds: 1),
                            () => setState(() {
                                  onPressCopyItemCode = false;
                                }));
                      },
                      icon: Icon(Icons.content_copy_sharp, size: 24.w),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<ItemCodeResponse> _dropDownMenuItemCode(
      ItemCodeResponse item) {
    return DropdownMenuItem<ItemCodeResponse>(
        value: item,
        child: dropdown_custom.cardItemDropdown(
          assetIcon: assets.itemCode,
          children: [
            Text(item.itemCode ?? "",
                style: const TextStyle(
                  color: colors.defaultColor,
                  fontWeight: FontWeight.bold,
                )),
            Text(
              item.itemDesc ?? "",
              style: const TextStyle(color: colors.textGrey),
            ),
          ],
        ));
  }

  Widget _buildItem({
    required String title,
    required TextEditingController controller,
    bool? enable,
    TextInputType? textInputType,
    List<TextInputFormatter>? textInputFormat,
    String? Function(String?)? validate,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title.tr(),
            style: styleTextTitle,
          ),
        ),
        Expanded(
          flex: 7,
          child: TextFormField(
            keyboardType: textInputType,
            inputFormatters: textInputFormat,
            validator: (value) {
              validate;
              return null;
            },
            controller: controller,
            enabled: enable ?? true,
            style: TextStyle(
              color: enable ?? true ? colors.textBlack : colors.textGrey,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              fillColor: enable ?? true
                  ? Colors.white
                  : colors.btnGreyDisable.withOpacity(0.1),
              filled: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeam() {
    return Row(
      children: [
        const Expanded(
            flex: 3,
            child: TextRichRequired(
                label: "4848", colorText: colors.defaultColor, isBold: true)),
        Expanded(
          flex: 7,
          child: DropdownButtonFormField2(
            value: round,
            barrierColor: dropdown_custom.bgDrawerColor(),
            items: listRound.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
            onChanged: (newValue) {
              round = newValue as int;
              _bloc.add(StockCountViewLoaded(
                round: round,
                generalBloc: generalBloc,
              ));
            },
            isExpanded: true,
            decoration: dropdown_custom.customInputDecoration(),
            buttonStyleData: dropdown_custom.customButtonStyleData(),
            menuItemStyleData: MenuItemStyleData(
              selectedMenuItemBuilder: (context, child) {
                return ColoredBox(
                  color: colors.defaultColor.withOpacity(0.2),
                  child: child,
                );
              },
            ),
            dropdownStyleData: dropdown_custom.customDropdownStyleData(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQty(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            flex: 3,
            child: TextRichRequired(
              label: "133",
              colorText: colors.defaultColor,
              isBold: true,
            )),
        Expanded(
          flex: 7,
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return '5067'.tr();
              } else if (double.parse(value) <= 0) {
                return strings.erGreaterThan0.tr();
              }
              return null;
            },
            controller: _qtyController,
            decoration:
                const InputDecoration(fillColor: Colors.white, filled: true),
          ),
        ),
      ],
    );
  }

  Widget _buildTableNodata(BuildContext context) {
    return Column(
      children: [
        const ColoredBox(
          color: colors.defaultColor,
          child: Row(
            children: [
              HeaderTableWidget(headerText: ''),
              Expanded(
                flex: 2,
                child: HeaderTableWidget(headerText: "5160"),
              ),
              Expanded(
                flex: 3,
                child: HeaderTableWidget(headerText: '128'),
              ),
              Expanded(
                flex: 3,
                child: HeaderTableWidget(headerText: "131"),
              ),
              Expanded(
                flex: 3,
                child: HeaderTableWidget(headerText: '133'),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              )
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.r),
              bottomRight: Radius.circular(8.r),
            ),
            border: Border.all(
              color: colors.defaultColor,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.sizeOf(context).width * 0.02),
            child: const EmptyWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildDate(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(
              "239".tr(),
              style: styleTextTitle,
            )),
        Expanded(
          flex: 7,
          child: InkWell(
            onTap: () => pickDate(
              context: context,
              isMonth: true,
              date: DateTime.now(),
              firstDate: DateTime(2010),
              lastDate: DateTime(
                DateTime.now().year,
                DateTime.now().month,
              ),
              function: (selectedDate) {
                final dateFormat = DateFormat('yyyyMM').format(selectedDate);
                setState(() {
                  _dateController.text = dateFormat;
                });
              },
            ),
            child: TextFormField(
              controller: _dateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                enabled: false,
                filled: true,
                hintText: "YYYYMM",
                suffixIcon: Icon(Icons.calendar_month),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(
    BuildContext context, {
    required List<StockCountResponse> list,
    required List<ItemCodeResponse> itemCodeList,
    required String totalQty,
    required String totalRows,
  }) {
    return Column(
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(0.72),
            1: FlexColumnWidth(0.13),
            2: FlexColumnWidth(0.1),
          },
          children: [
            TableRow(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "5176".tr(),
                        style: styleTextTitle,
                      ),
                      const WidthSpacer(width: 0.02),
                      Text(
                        totalRows,
                        style: styleTextDefault,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.sizeOf(context).width * 0.02),
                    child: Text(
                      "4211".tr(),
                      style: styleTextTitle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              Text(
                totalQty,
                textAlign: TextAlign.center,
                style: styleTextDefault,
              ),
              const Text(""),
            ])
          ],
        ),
        const HeightSpacer(height: 0.01),
        Table(
          border: TableBorder.all(
            color: colors.defaultColor.withOpacity(0.5),
          ),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(0.15),
            1: FlexColumnWidth(0.20),
            2: FlexColumnWidth(0.30),
            3: FlexColumnWidth(0.18),
            4: FlexColumnWidth(0.15),
            5: FlexColumnWidth(0.1),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(
                color: colors.defaultColor,
              ),
              children: [
                HeaderTableWidget(headerText: "5160"),
                HeaderTableWidget(headerText: '128'),
                HeaderTableWidget(headerText: '131'),
                HeaderTableWidget(headerText: 'UOM'),
                HeaderTableWidget(headerText: '133'),
                HeaderTableWidget(headerText: ''),
              ],
            ),
            ...List.generate(
              list.length,
              (i) {
                final item = list[i];
                return TableRow(
                  decoration: BoxDecoration(color: colorRowTable(index: i)),
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        child: Text(
                          item.locCode.toString(),
                          textAlign: TextAlign.center,
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        child: Text(
                          item.itemCode.toString(),
                          textAlign: TextAlign.center,
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        child: Text(
                          itemCodeList
                                  .where((element) =>
                                      element.itemCode == item.itemCode)
                                  .single
                                  .itemDesc ??
                              "",
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        child: Text(
                          item.uom ?? '',
                          textAlign: TextAlign.center,
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        child: Text(
                          NumberFormatter.numberFormatTotalQty(item.qty!),
                          textAlign: TextAlign.center,
                        )),
                    IconButton(
                        onPressed: () {
                          showDeleteDialog(context, item);
                        },
                        icon: IconCustom(iConURL: assets.delete, size: 20.w)),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Future showDeleteDialog(
    BuildContext context,
    StockCountResponse item,
  ) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      btnOkOnPress: () {
        _bloc.add(DeleteStockCount(id: item.id!, generalBloc: generalBloc));
      },
      btnCancelOnPress: () {},
      btnCancelText: '26'.tr(),
      btnOkText: '4171'.tr(),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Column(
        children: [
          Text(
            "24".tr(),
            style: const TextStyle(
              color: colors.defaultColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).show();
  }
}
