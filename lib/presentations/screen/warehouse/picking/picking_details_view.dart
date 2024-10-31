import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/picking/picking_detail/picking_detail_bloc.dart';

import 'package:igls_new/data/models/ware_house/picking/picking_item_response.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/presentations/screen/warehouse/inventory_field.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:rxdart/rxdart.dart';

class PickingDetailView extends StatefulWidget {
  const PickingDetailView({super.key, required this.pickingItem});
  final PickingItemResponse pickingItem;
  @override
  State<PickingDetailView> createState() => _PickingDetailViewState();
}

class _PickingDetailViewState extends State<PickingDetailView> {
  final TextEditingController _grNoController = TextEditingController();
  final TextEditingController _pickingQtyController = TextEditingController();
  late GeneralBloc generalBloc;
  late PickingDetailBloc _bloc;
  BehaviorSubject<PickingItemResponse> pickingItem = BehaviorSubject();
  ValueNotifier<bool> isValidNotifier = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<PickingDetailBloc>(context);
    pickingItem.add(widget.pickingItem);
    _pickingQtyController.text = (widget.pickingItem.pKQty ?? 0).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBarCustom(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context, 1)),
                title: Text('5548'.tr())),
            body: BlocConsumer<PickingDetailBloc, PickingDetailState>(
                listener: (context, state) {
              if (state is PickingDetailFailure) {
                CustomDialog().error(context, err: state.message);
              }
              if (state is PickingDetailSaveSuccess) {
                _bloc.add(PickingSearch(
                    waveItemNo: widget.pickingItem.waveItemNo ?? 0,
                    waveNo: widget.pickingItem.waveNo ?? '',
                    generalBloc: generalBloc));
                CustomDialog().success(context);
              }
              if (state is PickingDetailSuccess) {
                pickingItem.add(state.pickingItem);
                _reset();
              }
              if (state is PickingDetailCheckGRSuccess) {
                isValidNotifier.value =
                    state.grNoResult == widget.pickingItem.gRNo ? true : false;
              }
            }, builder: (context, state) {
              if (state is PickingDetailLoading) {
                return const ItemLoading();
              }
              return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  scrollDirection: Axis.vertical,
                  child: StreamBuilder(
                    stream: pickingItem.stream,
                    builder: (context, snapshot) {
                      return (snapshot.hasData && snapshot.data != null)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                  _card1(picking: snapshot.data!),
                                  _card2(picking: snapshot.data!),
                                  _card3(picking: snapshot.data!),
                                ])
                          : const SizedBox();
                    },
                  ));
            }),
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: isValidNotifier,
              builder: (context, value, child) {
                return ElevatedButtonWidget(
                    backgroundColor: value ? null : colors.btnGreyDisable,
                    text: '37',
                    isDisabled: (!value),
                    onPressed: value
                        ? () {
                            onSave();
                          }
                        : null);
              },
            )),
      ),
    );
  }

  Widget _card1({required PickingItemResponse picking}) {
    return CardCustom(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          InventoryField(
              title: picking.itemCode ?? '', value: picking.itemDesc ?? ''),
          InventoryField(title: "132", value: picking.grade ?? ''),
          InventoryField(title: "1297", value: picking.itemStatus ?? ''),
          InventoryField(title: "4873", value: picking.qty.toString()),
          InventoryField(title: "5549", value: picking.pKPQty.toString())
        ],
      ),
    );
  }

  Widget _card2({required PickingItemResponse picking}) {
    return CardCustom(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(children: [
          InventoryField(title: "165", value: picking.locCode ?? ''),
          InventoryField(title: "148", value: picking.lotCode ?? ''),
          InventoryField(
              title: "167", value: picking.productionDateString ?? ''),
          InventoryField(title: "166", value: picking.expiredDateString ?? ""),
        ]));
  }

  Widget _card3({required PickingItemResponse picking}) {
    return CardCustom(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(children: [
          Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text("1262".tr()),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: isValidNotifier,
                    builder: (context, value, child) {
                      return TextFormField(
                          readOnly: picking.pKQty == 0 ? true : false,
                          decoration: InputDecoration(
                              enabled: picking.pKQty == 0 ? false : true,
                              fillColor: Colors.white,
                              filled: true),
                          validator: (value) {
                            if (_grNoController.text.isEmpty) {
                              return "5067".tr();
                            }
                            return null;
                          },
                          onFieldSubmitted: (newValue) {
                            checkGrNO(grNo: newValue);
                          },
                          keyboardType: TextInputType.text,
                          controller: _grNoController,
                          textCapitalization: TextCapitalization.characters);
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  icon: Image.asset(
                    assets.barCode,
                    scale: 2,
                    color: picking.pKQty == 0
                        ? colors.btnGreyDisable
                        : colors.defaultColor,
                  ),
                  onPressed: picking.pKQty == 0
                      ? null
                      : () {
                          final qrBarCodeScannerDialogPlugin =
                              QrBarCodeScannerDialog();
                          qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                              context: context,
                              onCode: (code) {
                                setState(() {
                                  _grNoController.text = code ?? '';
                                  checkGrNO(grNo: code ?? '');
                                });
                              });
                        },
                ),
              )
            ],
          ),
          Row(children: <Widget>[
            Expanded(
              flex: 4,
              child: Text("133".tr()),
            ),
            Expanded(
                flex: 7,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        decoration: InputDecoration(
                            enabled: picking.pKQty == 0 ? false : true,
                            fillColor: Colors.white,
                            filled: true),
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        controller: _pickingQtyController,
                        onFieldSubmitted: (String value) {},
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                        validator: (value) {
                          double putaway = double.tryParse(_pickingQtyController
                                  .text
                                  .replaceAll(",", "")) ??
                              0;
                          if (putaway <= 0.0 ||
                              putaway > (picking.pKQty ?? 0)) {
                            return "5550".tr();
                          }
                          return null;
                        }))),
            Expanded(
                flex: 2,
                child: Text(' / ${picking.pKQty}',
                    style: const TextStyle(fontStyle: FontStyle.normal)))
          ])
        ]));
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      _bloc.add(PickingDetailSave(
          waveNo: widget.pickingItem.waveNo ?? '',
          oOrderNo: widget.pickingItem.oOrdNo!,
          waveItemNo: widget.pickingItem.waveItemNo!,
          srItemNo: widget.pickingItem.sRItemNo!,
          sbNo: widget.pickingItem.sBNo!,
          generalBloc: generalBloc,
          qty: double.parse(_pickingQtyController.text)));
    }
  }

  void _reset() {
    _grNoController.clear();
    isValidNotifier.value = false;
    _pickingQtyController.text = (pickingItem.value.pKQty ?? 0).toString();
  }

  void checkGrNO({required String grNo}) {
    _bloc.add(PickingDetailCheckGrNo(
        grNo: grNo,
        subsidiaryId: generalBloc.generalUserInfo?.subsidiaryId ?? ''));
  }
}
