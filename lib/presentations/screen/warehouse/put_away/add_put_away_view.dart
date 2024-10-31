import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/general/general_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/local_distribution/put_away/add_put_away/add_put_away_bloc.dart';
import 'package:igls_new/data/models/ware_house/put_away/order_item_response.dart';
import 'package:igls_new/data/services/navigator/import_generate.dart';
import 'package:igls_new/presentations/screen/warehouse/inventory_field.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:rxdart/subjects.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class AddPutAwayView extends StatefulWidget {
  const AddPutAwayView({super.key});

  @override
  State<AddPutAwayView> createState() => _AddPutAwayViewState();
}

class _AddPutAwayViewState extends State<AddPutAwayView> {
  final _key1 = GlobalKey<FormState>();
  final _key2 = GlobalKey<FormState>();
  final focusNode = FocusNode();

  BehaviorSubject<OrderItem> lstOrderItem = BehaviorSubject<OrderItem>();

  final TextEditingController _grNoController = TextEditingController();
  final TextEditingController _pwQtyController =
      TextEditingController(text: '0');
  final TextEditingController _locCodeController = TextEditingController();
  late AddPutAwayBloc _bloc;
  late GeneralBloc generalBloc;
  ValueNotifier<bool> isSave = ValueNotifier<bool>(false);

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<AddPutAwayBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarCustom(title: Text('226'.tr())),
        body: BlocConsumer<AddPutAwayBloc, AddPutAwayState>(
          listener: (context, state) {
            if (state is AddPutAwaySuccess) {
              lstOrderItem.add(state.orderItem);
              isSave.value = true;
            }
            if (state is AddPutAwaySaveSuccess) {
              CustomDialog().success(context);
              lstOrderItem.add(state.orderItem);
              _reset();
            }
            if (state is AddPutAwayFailure) {
              CustomDialog().error(context, err: state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: StreamBuilder(
                  stream: lstOrderItem.stream,
                  builder: (context, snapshot) {
                    OrderItem? putawayItem = snapshot.data;
                    if (putawayItem == null || putawayItem.iOrdNo == null) {
                      _pwQtyController.text = '';
                      _locCodeController.text = '';
                    } else {
                      _pwQtyController.text =
                          putawayItem.qty.toString().replaceAll('.0', '');
                    }
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildCard1(),
                          _buildCard2(order: snapshot.data),
                          _buildCard3(order: snapshot.data)
                        ]);
                  }),
            );
          },
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: isSave,
          builder: (context, value, child) {
            return ElevatedButtonWidget(
                text: '37',
                isDisabled: !value,
                backgroundColor: value ? null : colors.btnGreyDisable,
                onPressed: value
                    ? () {
                        if (_key2.currentState!.validate()) {
                          _onSave();
                        }
                      }
                    : null);
          },
        ),
      ),
    );
  }

  Widget _buildCard1() {
    return CardCustom(
      child: Form(
        key: _key1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text("1262".tr()),
            ),
            Expanded(
                flex: 5,
                child: TextFormField(
                  focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    if (_key1.currentState!.validate()) {
                      _searchGRNo(grNo: value);
                    }
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
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _grNoController.clear();
                        },
                      )),
                  autofocus: true,
                  controller: _grNoController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                )),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Image.asset(
                  assets.barCode,
                  scale: 2,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard2({required OrderItem? order}) {
    return CardCustom(
      child: Column(children: <Widget>[
        InventoryField(
          title: '128',
          value: order != null ? order.itemCode ?? '' : "",
        ),
        InventoryField(
            title: '131', value: order != null ? order.itemDesc ?? '' : ""),
        InventoryField(
            title: "122", value: order != null ? order.clientRefNo ?? '' : ""),
        InventoryField(
            title: "132", value: order != null ? order.grade ?? '' : ""),
        InventoryField(
            title: "146", value: order != null ? order.itemStatus ?? '' : ""),
        InventoryField(
            title: "4864", value: order != null ? order.locCode ?? '' : ""),
      ]),
    );
  }

  Widget _buildCard3({required OrderItem? order}) {
    return CardCustom(
        child: Form(
      key: _key2,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text("133".tr()),
            ),
            Expanded(
              flex: 5,
              child: ValueListenableBuilder(
                valueListenable: isSave,
                builder: (context, value, child) {
                  return TextFormField(
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.number,
                      controller: _pwQtyController,
                      decoration: const InputDecoration(
                          fillColor: Colors.white, filled: true),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '5067'.tr();
                        }
                        var putaway = double.parse(_pwQtyController.text
                            .toString()
                            .replaceAll(",", ""));
                        if (putaway <= 0 || putaway > order!.qty!) {
                          return "157".tr();
                        }
                        return null;
                      });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: order?.grNo == null
                  ? const SizedBox()
                  : RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                          text: '  /  ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.textBlack),
                        ),
                        TextSpan(
                          text:
                              ' ${order != null ? order.qty.toString().replaceAll('.0', '') : ""}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.textBlack),
                        ),
                      ]),
                    ),
            )
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text("4865".tr()),
            ),
            Expanded(
              flex: 5,
              child: TextFormField(
                decoration: const InputDecoration(
                    fillColor: Colors.white, filled: true),
                keyboardType: TextInputType.text,
                controller: _locCodeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "5067".tr();
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Image.asset(
                  assets.barCode,
                  scale: 2,
                ),
                onPressed: () {
                  _onScanLocCode();
                },
              ),
            )
          ],
        ),
      ]),
    ));
  }

  void _onScanLocCode() {
    final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
    qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
        context: context,
        onCode: (code) {
          setState(() {
            _locCodeController.text = code ?? '';
          });
        });
  }

  void _searchGRNo({required String grNo}) {
    _bloc.add(SeachPutAwayItem(grNo: grNo.trim(), generalBloc: generalBloc));
  }

  void _onSave() {
    _bloc.add(SavePutAway(
        pwQty: double.parse(_pwQtyController.text.trim()),
        locCode: _locCodeController.text.trim(),
        grNo: _grNoController.text.trim(),
        userId: generalBloc.generalUserInfo?.userId ?? '',
        subsidiaryId: generalBloc.generalUserInfo?.subsidiaryId ?? ''));
  }

  void _reset() {
    _grNoController.text = '';
    _pwQtyController.text = '';
    _locCodeController.text = '';
    focusNode.requestFocus();
    isSave.value = false;
  }
}
