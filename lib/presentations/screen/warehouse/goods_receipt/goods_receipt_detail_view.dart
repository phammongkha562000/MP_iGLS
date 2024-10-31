import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:igls_new/businesses_logics/bloc/ware_house/goods_receipt/goods_receipt_detail/goods_receipt_detail_bloc.dart';

import 'package:igls_new/data/shared/utils/file_utils.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/widgets/text_rich_required.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/models.dart';
import '../../../widgets/app_bar_custom.dart';
import '../../../widgets/dropdown_custom/dropdown_custom.dart'
    as dropdown_custom;

class GoodsReceiptDetailView extends StatefulWidget {
  const GoodsReceiptDetailView(
      {super.key, required this.goodsReceipt, required this.iOrderNo});
  final int iOrderNo;
  final GoodReceiptOrderResponse goodsReceipt;
  @override
  State<GoodsReceiptDetailView> createState() => _GoodsReceiptDetailViewState();
}

final _lotCodeController = TextEditingController();
final _grQuantityController = TextEditingController();
final _prodDateController = TextEditingController();
final _expDateController = TextEditingController();
final _isProdDateNotifer = ValueNotifier<bool>(false);
final _isExpDateNotifer = ValueNotifier<bool>(false);
final _isSplit = ValueNotifier<bool>(false);
final _skuNotifer = ValueNotifier<String>('');
final _gradeNotifer = ValueNotifier<String>('');
final _statusNotifer = ValueNotifier<String>('');
final _locCodeNotifer = ValueNotifier<String>('');
final _formKey = GlobalKey<FormState>();
String? selectedLocation;
final _searchLocController = TextEditingController();
late GeneralBloc generalBloc;
late GoodsReceiptDetailBloc _bloc;
late GoodReceiptOrderResponse goodsReceipt;

class _GoodsReceiptDetailViewState extends State<GoodsReceiptDetailView> {
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<GoodsReceiptDetailBloc>(context);
    _bloc.add(GoodsReceiptDetailViewLoaded(
        iOrderNo: widget.iOrderNo, generalBloc: generalBloc));
    goodsReceipt = widget.goodsReceipt;
    _isProdDateNotifer.value = false;
    _isExpDateNotifer.value = false;
    _isSplit.value = false;
    _lotCodeController.clear();
    _prodDateController.text = goodsReceipt.productionDate != null
        ? FileUtils.formatToDateTimeFromString(goodsReceipt.productionDate!)
            .toString()
            .split(' ')
            .first
        : '';
    _expDateController.text = goodsReceipt.expiredDate != null
        ? FileUtils.formatToDateTimeFromString(goodsReceipt.expiredDate!)
            .toString()
            .split(' ')
            .first
        : '';

    _gradeNotifer.value = goodsReceipt.grade ?? '';
    _statusNotifer.value = goodsReceipt.itemStatus ?? '';

    _grQuantityController.text = goodsReceipt.grQty.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBarCustom(
            title: Text(goodsReceipt.clientRefNo.toString()),
          ),
          body: BlocListener<GoodsReceiptDetailBloc, GoodsReceiptDetailState>(
            listener: (context, state) {
              if (state is GoodsReceiptDetailSuccess) {
                if (state.saveSuccess == true) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    showToastWidget(
                      const SuccessToast(),
                      position: StyledToastPosition.top,
                      animation: StyledToastAnimation.slideFromRightFade,
                      context: context,
                    );
                  });

                  Navigator.pop(context, goodsReceipt);
                }
              }
              if (state is GoodsReceiptDetailFailure) {
                CustomDialog().error(context, err: state.message);
              }
            },
            child: BlocBuilder<GoodsReceiptDetailBloc, GoodsReceiptDetailState>(
              builder: (context, state) {
                if (state is GoodsReceiptDetailSuccess) {
                  state.skuResponse.isNotEmpty
                      ? _skuNotifer.value = state.skuResponse
                              .where((element) =>
                                  element.skuId == goodsReceipt.skuid)
                              .single
                              .skuDesc ??
                          ''
                      : null;
                  _locCodeNotifer.value = goodsReceipt.iOrdType == 'INORMAL'
                      ? state.locationList
                              .where((element) => element.locCode == 'RD1')
                              .single
                              .locCode ??
                          ''
                      : (goodsReceipt.locCode == null ||
                              goodsReceipt.locCode == ''
                          ? state.locationList.first.locCode!
                          : goodsReceipt.locCode ?? '');
                  selectedLocation = goodsReceipt.iOrdType == 'INORMAL'
                      ? state.locationList
                              .where((element) => element.locCode == 'RD1')
                              .single
                              .locCode ??
                          ''
                      : (goodsReceipt.locCode == null ||
                              goodsReceipt.locCode == ''
                          ? state.locationList.first.locCode!
                          : goodsReceipt.locCode ?? '');
                  return GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
                      child: Column(children: [
                        _buildRow(
                            title: '128'.tr(),
                            content: goodsReceipt.itemCode.toString()),
                        _buildRow(
                            title: '131'.tr(),
                            content: goodsReceipt.itemDesc.toString()),
                        _buildRow(
                            title: '179'.tr(),
                            content:
                                goodsReceipt.qty.toString().split('.').first,
                            textAlign: TextAlign.right),
                        _buildTextFiledValidate(
                            title: '178'.tr(),
                            controller: _grQuantityController),
                        _buildRowDropDown(
                            title: '132'.tr(),
                            listString: state.stdCodeGrade
                                .map((e) => e.codeId!)
                                .toList(),
                            valueDropdown: _gradeNotifer.value),
                        ValueListenableBuilder(
                          valueListenable: _statusNotifer,
                          builder: (context, value, child) => _buildRowDropDown(
                            title: '1279'.tr(),
                            listString: state.stdCodeStatus
                                .map((e) => e.codeId!)
                                .toList(),
                            valueDropdown: _statusNotifer.value,
                            onChange: (item) => _statusNotifer.value = item,
                          ),
                        ),
                        _buildLocation(state),
                        _buildTextFiled(
                            title: '148'.tr(), controller: _lotCodeController),
                        ValueListenableBuilder(
                          valueListenable: _isProdDateNotifer,
                          builder: (context, value, child) => _buildRowSwitch(
                              date: goodsReceipt.productionDate ?? '',
                              controller: _prodDateController,
                              isBool: _isProdDateNotifer.value,
                              onChangeSwitch: (item) {
                                _isProdDateNotifer.value = item;
                                _isProdDateNotifer.value == false
                                    ? _prodDateController.text = (goodsReceipt
                                                .productionDate !=
                                            null)
                                        ? FileUtils.formatToDateTimeFromString(
                                                goodsReceipt.productionDate!)
                                            .toString()
                                            .split(' ')
                                            .first
                                        : ''
                                    : null;
                              },
                              onTapPickDate: (selectedDate) =>
                                  _prodDateController.text =
                                      selectedDate.toString().split(' ').first,
                              title: '167'.tr()),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isExpDateNotifer,
                          builder: (context, value, child) => _buildRowSwitch(
                            date: goodsReceipt.expiredDate ?? '',
                            controller: _expDateController,
                            isBool: _isExpDateNotifer.value,
                            title: '166'.tr(),
                            onChangeSwitch: (item) {
                              _isExpDateNotifer.value = item;
                              _isExpDateNotifer.value == false
                                  ? _expDateController.text = (goodsReceipt
                                              .expiredDate !=
                                          null)
                                      ? FileUtils.formatToDateTimeFromString(
                                              goodsReceipt.expiredDate!)
                                          .toString()
                                          .split(' ')
                                          .first
                                      : ''
                                  : null;
                            },
                            onTapPickDate: (selectedDate) =>
                                _expDateController.text =
                                    selectedDate.toString().split(' ').first,
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _skuNotifer,
                          builder: (context, value, child) =>
                              ValueListenableBuilder(
                            valueListenable: _isSplit,
                            builder: (context, value, child) => _buildRowSwitch(
                                valueDropdown: _skuNotifer.value,
                                isBool: _isSplit.value,
                                listString: state.skuResponse
                                    .map((e) => e.skuDesc!)
                                    .toList(),
                                title: '2430'.tr(),
                                onChangeSwitch: (item) {
                                  _isSplit.value = item;
                                },
                                onChangeDropdown: (item) =>
                                    _skuNotifer.value = item),
                          ),
                        ),
                        const HeightSpacer(height: 0.05),
                        ValueListenableBuilder(
                          valueListenable: _skuNotifer,
                          builder: (context, value, child) => _buildButtonSave(
                              sku: state.skuResponse
                                  .where((element) =>
                                      element.skuDesc == _skuNotifer.value)
                                  .first),
                        )
                      ]),
                    ),
                  );
                }
                return const ItemLoading();
              },
            ),
          ),
        ));
  }

  Widget _buildLocation(GoodsReceiptDetailSuccess state) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: TextRichRequired(
              label: "5160",
              colorText: colors.defaultColor,
              isBold: true,
            ),
          ),
          Expanded(
            flex: 2,
            child: ValueListenableBuilder(
              valueListenable: _locCodeNotifer,
              builder: (context, value, child) {
                return DropdownButtonFormField2<String>(
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
                  dropdownStyleData:
                      dropdown_custom.customDropdownStyleData(context),
                  hint: Text("5161".tr()),
                  items: state.locationList
                      .map((item) => _dropDownMenuLocation(item))
                      .toList(),
                  value: selectedLocation,
                  onChanged: (value) {
                    _locCodeNotifer.value = value.toString();
                  },
                  dropdownSearchData: DropdownSearchData(
                    searchInnerWidgetHeight: 50,
                    searchController: _searchLocController,
                    searchInnerWidget: dropdown_custom.buildSearch(
                      context,
                      controller: _searchLocController,
                      onPressed: () async {
                        final qrBarCodeScannerDialogPlugin =
                            QrBarCodeScannerDialog();
                        qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (code) {
                              setState(() {
                                _searchLocController.text = code ?? '';
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
                );
              },
            ),
          ),
        ],
      ),
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

  Widget _buildButtonSave({required SkuResponse sku}) => ElevatedButtonWidget(
      isPaddingBottom: true,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _bloc.add(GoodsReceiptDetailSave(
              goodsReceiptDetail: goodsReceipt,
              grQty: double.parse(_grQuantityController.text),
              grade: _gradeNotifer.value,
              status: _statusNotifer.value,
              locCode: _locCodeNotifer.value,
              propDate: _prodDateController.text,
              expDate: _expDateController.text,
              lotCode: _lotCodeController.text,
              sku: sku,
              isSplit: _isSplit.value,
              generalBloc: generalBloc));
        }
      },
      text: '37');
  Widget _buildRow(
          {required String title,
          required String content,
          TextAlign? textAlign}) =>
      Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextTitle(
                title: title,
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: textAlign != null
                    ? EdgeInsets.symmetric(horizontal: 8.w)
                    : EdgeInsets.zero,
                child: Text(
                  content,
                  textAlign: textAlign ?? TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      );
  Widget _buildRowDropDown(
          {required String title,
          required List<String> listString,
          required String valueDropdown,
          Function(String item)? onChange}) =>
      Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextTitle(
                title: title,
              ),
            ),
            Expanded(
                flex: 4,
                child: DropdownButton(
                  value: valueDropdown,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  underline: const Divider(
                    height: 4,
                    color: colors.btnGreyDisable,
                  ),
                  onChanged: (value) => onChange!(value as String),
                  items:
                      listString.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
          ],
        ),
      );
  Widget _buildTextFiled(
          {required String title, required TextEditingController controller}) =>
      Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextTitle(
                title: title,
              ),
            ),
            Expanded(
                flex: 4,
                child: TextField(
                  decoration: InputDecoration(hintText: '${'148'.tr()} ...'),
                  controller: controller,
                )),
          ],
        ),
      );
  Widget _buildTextFiledValidate(
          {required String title, required TextEditingController controller}) =>
      Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextTitle(title: title),
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                ],
                decoration: InputDecoration(
                    hintText: '${'178'.tr()}...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _grQuantityController.clear();
                      },
                      icon: const IconCustom(
                        iConURL: toastError,
                        size: 25,
                        color: Colors.red,
                      ),
                    )),
                onChanged: (value) {
                  if (value == '.' || value == 0.toString()) {
                    controller.text = '';
                  }
                },
                validator: (value) {
                  if (value == '') {
                    return '5067'.tr();
                  } else {
                    var grQty = double.parse(_grQuantityController.text
                        .toString()
                        .replaceAll(",", ""));
                    if (grQty <= 0) {
                      return '${'178'.tr()} ${'5175'.tr()}';
                    } else if (grQty > goodsReceipt.grQty!) {
                      return '${'178'.tr()} ${'5177'.tr()}';
                    }
                    return null;
                  }
                },
                controller: controller,
              ),
            ),
          ],
        ),
      );
  Widget _buildRowSwitch(
          {required bool isBool,
          required String title,
          List<String>? listString,
          Function(String item)? onChangeDropdown,
          Function(bool item)? onChangeSwitch,
          String? date,
          TextEditingController? controller,
          dynamic onTapPickDate,
          String? valueDropdown}) =>
      Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: _buildTextTitle(
                title: title,
              ),
            ),
            Expanded(
                flex: 1,
                child: Switch(
                    value: isBool,
                    onChanged: (bool value) {
                      onChangeSwitch!(value);
                    })),
            Expanded(
                flex: controller != null ? 6 : 7,
                child: controller != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: TextField(
                          enabled: false,
                          controller: controller,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: DropdownButton(
                          value: valueDropdown,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          underline: const Divider(
                            height: 4,
                            color: colors.btnGreyDisable,
                          ),
                          onChanged: isBool
                              ? (String? value) => onChangeDropdown!(value!)
                              : null,
                          items: listString!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )),
            Expanded(
                flex: controller != null ? 1 : 0,
                child: controller != null
                    ? IconButton(
                        onPressed: isBool
                            ? () {
                                DateTime dateTime = date == ''
                                    ? DateTime.now()
                                    : FileUtils.formatToDateTimeFromString(
                                        date!);
                                pickDate(
                                    context: context,
                                    date: dateTime,
                                    function: (selectedDate) {
                                      onTapPickDate(selectedDate);
                                    });
                              }
                            : null,
                        icon: const Icon(
                          Icons.calendar_month,
                        ))
                    : const SizedBox())
          ],
        ),
      );
  Widget _buildTextTitle({required String title}) =>
      Text(title, style: styleTextTitle);
}
