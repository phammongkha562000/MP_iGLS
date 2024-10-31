import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igls_new/businesses_logics/bloc/ware_house/pallet_relocation/pallet_relocation_bloc.dart';
import 'package:igls_new/data/models/ware_house/pallet_relocation/pallet_relocation_response.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/screen/warehouse/inventory_field.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../presentations.dart';
import '../../../widgets/app_bar_custom.dart';

class PalletRelocationView extends StatefulWidget {
  const PalletRelocationView({super.key});

  @override
  State<PalletRelocationView> createState() => _PalletRelocationViewState();
}

class _PalletRelocationViewState extends State<PalletRelocationView> {
  final _formKey = GlobalKey<FormState>();
  final _key1 = GlobalKey<FormState>();
  final focusNode = FocusNode();

  late PalletRelocationBloc _bloc;
  late GeneralBloc generalBloc;

  final _grController = TextEditingController();
  final _newLocController = TextEditingController();
  ValueNotifier<bool> isSave = ValueNotifier<bool>(false);

  BehaviorSubject<PalletRelocationResponse> pallet =
      BehaviorSubject<PalletRelocationResponse>();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<PalletRelocationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarCustom(title: Text('4883'.tr())),
        body: BlocConsumer<PalletRelocationBloc, PalletRelocationState>(
          listener: (context, state) {
            if (state is PalletRelocationSuccess) {
              pallet.add(state.pallet);
              isSave.value = state.pallet.gRNo != null ? true : false;
            }
            if (state is PalletRelocationSaveSuccess) {
              CustomDialog().success(context);
              pallet.add(state.pallet);
              _reset();
            }
            if (state is PalletRelocationFailure) {
              CustomDialog().error(context, err: state.message);
              pallet.add(PalletRelocationResponse());
            }
          },
          builder: (context, state) {
            return StreamBuilder(
              stream: pallet.stream,
              builder: (context, snapshot) {
                PalletRelocationResponse? pallet = snapshot.data;
                if (pallet == null || pallet.iOrdNo == null) {
                  _newLocController.text = '';
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      CardCustom(
                        child: Form(
                          key: _key1,
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text('1262'.tr())),
                              Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    controller: _grController,
                                    autofocus: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '5067'.tr();
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      if (_key1.currentState!.validate()) {
                                        _searchGrNo();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      }
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
                                            _grController.clear();
                                          },
                                        )),
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                      onPressed: () {
                                        final qrBarCodeScannerDialogPlugin =
                                            QrBarCodeScannerDialog();
                                        qrBarCodeScannerDialogPlugin
                                            .getScannedQrBarCode(
                                                context: context,
                                                onCode: (code) {
                                                  setState(() {
                                                    _grController.text =
                                                        code ?? '';
                                                  });
                                                  _searchGrNo();
                                                });
                                      },
                                      icon: Image.asset(assets.barCode,
                                          scale: 2)))
                            ],
                          ),
                        ),
                      ),
                      CardCustom(
                        child: Column(
                          children: [
                            InventoryField(
                                title: '179',
                                value: snapshot.hasData
                                    ? pallet!.balanceQty != null
                                        ? pallet.balanceQty.toString()
                                        : '0'
                                    : ''),
                            InventoryField(
                                title: '180',
                                value: snapshot.hasData
                                    ? pallet!.gRQty != null
                                        ? pallet.gRQty.toString()
                                        : '0'
                                    : ''),
                            InventoryField(
                                title: '132',
                                value: snapshot.hasData
                                    ? pallet!.grade ?? ''
                                    : ''),
                            InventoryField(
                                title: '146',
                                value: snapshot.hasData
                                    ? pallet!.itemStatus ?? ''
                                    : ''),
                          ],
                        ),
                      ),
                      CardCustom(
                        child: Column(
                          children: [
                            InventoryField(
                                title: '165',
                                value: snapshot.hasData
                                    ? pallet?.locCode ?? ''
                                    : ''),
                            InventoryField(
                                title: '148',
                                value: snapshot.hasData
                                    ? pallet?.lotCode ?? ''
                                    : ''),
                            InventoryField(
                                title: '167',
                                value: snapshot.hasData
                                    ? (pallet?.productionDateString != '' &&
                                            pallet?.productionDateString != null
                                        ? FormatDateConstants.convertMMddyyyy3(
                                            pallet!.productionDateString!)
                                        : '')
                                    : ''),
                            InventoryField(
                                title: '166',
                                value: (pallet?.expiredDateString != '' &&
                                        pallet?.expiredDateString != null
                                    ? FormatDateConstants.convertMMddyyyy3(
                                        pallet!.expiredDateString!)
                                    : '')),
                          ],
                        ),
                      ),
                      CardCustom(
                        child: Form(
                          key: _formKey,
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text('4865'.tr())),
                              Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '5067'.tr();
                                      }
                                      return null;
                                    },
                                    controller: _newLocController,
                                    decoration: const InputDecoration(
                                        fillColor: Colors.white, filled: true),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                      onPressed: () => _onScanNewLoc(),
                                      icon: Image.asset(
                                        assets.barCode,
                                        scale: 2,
                                      )))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: isSave,
            builder: (context, value, child) {
              return ElevatedButtonWidget(
                text: '37',
                isDisabled: !value,
                onPressed: value
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _onSave();
                        }
                      }
                    : null,
                backgroundColor: value ? null : colors.btnGreyDisable,
              );
            }),
      ),
    );
  }

  void _reset() {
    _grController.clear();
    _newLocController.clear();
    isSave.value = false;
    focusNode.requestFocus();
  }

  void _searchGrNo() async {
    _bloc.add(PalletRelocationSearch(
        grNo: _grController.text, generalBloc: generalBloc));
  }

  void _onScanNewLoc() async {
    final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
    qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
        context: context,
        onCode: (code) {
          setState(() {
            _newLocController.text = code ?? '';
          });
        });
  }

  void _onSave() {
    _bloc.add(PalletRelocationSave(
        locCode: _newLocController.text, generalBloc: generalBloc));
  }
}
