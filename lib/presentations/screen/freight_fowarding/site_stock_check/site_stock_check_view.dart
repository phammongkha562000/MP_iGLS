import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_stock/site_stock_check/site_stock_check_bloc.dart';
import 'package:igls_new/data/models/equipment/equipment_response.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/models/setting/local_permission/local_permission_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:igls_new/presentations/widgets/dropdown_custom/dropdown_custom_widget.dart'
    as dropdown_custom;
import 'package:rxdart/rxdart.dart';
import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../presentations.dart';
import '../../../widgets/app_bar_custom.dart';

class SiteStockCheckView extends StatefulWidget {
  const SiteStockCheckView({super.key});

  @override
  State<SiteStockCheckView> createState() => _SiteStockCheckViewState();
}

class _SiteStockCheckViewState extends State<SiteStockCheckView> {
  final _navigationService = getIt<NavigationService>();
  final ValueNotifier<CySiteResponse> _cyNotifier =
      ValueNotifier<CySiteResponse>(CySiteResponse(cyCode: '', cyName: ''));
  CySiteResponse? cySelected;

  final TextEditingController _trailerNoController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  late SiteStockCheckBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  late GeneralBloc generalBloc;

  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();

  List<String> options = [];

  BehaviorSubject<List<DcLocal>> dcList = BehaviorSubject<List<DcLocal>>();
  BehaviorSubject<List<CySiteResponse>> cyList =
      BehaviorSubject<List<CySiteResponse>>();
  BehaviorSubject<List<EquipmentResponse>> equipmentList =
      BehaviorSubject<List<EquipmentResponse>>();

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<SiteStockCheckBloc>(context);
    // _bloc.add(SiteStockCheckViewLoaded(generalBloc: generalBloc));
    _bloc
      ..add(SiteStockCheckGetCY(generalBloc: generalBloc))
      ..add(SiteStockCheckGetEquipment(
          generalBloc: generalBloc,
          dcCode: generalBloc.generalUserInfo?.defaultCenter ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBarCustom(
            title: Text('4719'.tr()),
          ),
          body: BlocConsumer<SiteStockCheckBloc, SiteStockCheckState>(
              listener: (context, state) {
            if (state is SiteStockCheckSaveSuccess) {
              _reset();
              CustomDialog().success(context);
            }
            if (state is SiteStockCheckFailure) {
              CustomDialog().error(
                context,
                err: state.message,
                btnOkOnPress: () => _bloc
                    .add(SiteStockCheckViewLoaded(generalBloc: generalBloc)),
              );
            }

            if (state is SiteStockCheckGetCYSuccess) {
              cyList.add(state.cySiteList);
              if (state.cySite != null) {
                _cyNotifier.value = state.cySite!;
                cySelected = state.cySite!;
              }
            }
            if (state is SiteStockCheckGetEquipmentSuccess) {
              equipmentList.add(state.equipmentList);
            }

            if (state is SiteStockCheckGetCYFailure) {
              CustomDialog().error(context, err: state.message);
            }
            if (state is SiteStockCheckGetEquipmentFailure) {
              CustomDialog().error(context, err: state.message);
            }
          }, builder: (context, state) {
            if (state is SiteStockCheckLoading) {
              return const ItemLoading();
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(children: [
                _buidCY(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).height * 0.015,
                  ),
                  child: Row(
                    children: [
                      _buildBtn(
                          text: '5444'.tr(),
                          onPressed: () async {
                            final result = await _navigationService
                                .navigateAndDisplaySelection(
                              routes.siteStockPendingRoute,
                            );
                            if (result != null) {
                              _trailerNoController.text = result as String;
                            }
                          }),
                      SizedBox(
                        width: 8.w,
                      ),
                      _buildBtn(
                          text: '5125'.tr(),
                          onPressed: () {
                            _navigationService.pushNamed(
                              routes.siteStockCheckDetailRoute,
                              args: {
                                key_params.cyCode:
                                    _cyNotifier.value.cyCode ?? ''
                              },
                            );
                          })
                    ],
                  ),
                ),
                _buildTrailer(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.sizeOf(context).height * 0.015),
                  child: TextFormField(
                    controller: _remarkController,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: colors.textBlack),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 25.w),
                        border: InputBorder.none,
                        hintText: '${'1276'.tr()}...',
                        label: Text('1276'.tr())),
                  ),
                ),
              ]),
            );
          }),
          bottomNavigationBar: _buildBtnUpdate()),
    );
  }

  Widget _buidCY() {
    return StreamBuilder(
      stream: cyList.stream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.015),
          child: ValueListenableBuilder(
            valueListenable: _cyNotifier,
            builder: (context, value, child) =>
                DropDownButtonFormField2CYSiteWidget(
              onChanged: (value) {
                value as CySiteResponse;
                _cyNotifier.value = value;
                cySelected = value;
              },
              value: cySelected,
              hintText: '5083',
              label: '5124',
              list: snapshot.hasData ? snapshot.data ?? [] : [],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrailer() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: StreamBuilder(
              stream: equipmentList.stream,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        controller: _trailerNoController,
                        focusNode: _focusNode,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]')),
                        ],
                        style: const TextStyle(color: colors.textBlack),
                        validator: (value) =>
                            value!.isNotEmpty ? null : "5067".tr(),
                        onFieldSubmitted: (String value) {
                          RawAutocomplete.onFieldSubmitted<String>(
                              _autocompleteKey);
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.history),
                            onPressed: () {
                              _navigationService.pushNamed(
                                  routes.siteTrailerHistoryRoute,
                                  args: {
                                    key_params.trailerHistory:
                                        _trailerNoController.text
                                  });
                            },
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: '${"4012".tr()}...',
                          border: InputBorder.none,
                          label: Text.rich(TextSpan(children: [
                            TextSpan(text: '4012'.tr()),
                            const TextSpan(
                                text: ' *',
                                style: TextStyle(color: colors.textRed)),
                          ])),
                        )),
                    LayoutBuilder(
                      builder: (context, constraints) =>
                          RawAutocomplete<String>(
                        key: _autocompleteKey,
                        focusNode: _focusNode,
                        textEditingController: _trailerNoController,
                        optionsBuilder: (
                          TextEditingValue textEditingValue,
                        ) {
                          return snapshot.hasData
                              ? snapshot.data!
                                  .map((e) => e.equipmentDesc!)
                                  .toList()
                                  .where((String option) {
                                  return option.contains(textEditingValue.text);
                                }).toList()
                              : [];
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Material(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: colors.btnGreyDisable,
                                  ),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: SizedBox(
                                  height: 100,
                                  width: constraints.biggest.width,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: options.length,
                                    shrinkWrap: false,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String option =
                                          options.elementAt(index);
                                      return InkWell(
                                        onTap: () => onSelected(option),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(option),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () async {
                _navigationService.pushNamed(routes.toDoHaulageImageRoute,
                    args: {
                      key_params.trailerNoImage: _trailerNoController.text
                    });
              },
              icon: const Icon(
                Icons.photo,
                color: colors.defaultColor,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
                onPressed: () async {
                  final qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
                  qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                      context: context,
                      onCode: (code) {
                        setState(() {
                          _trailerNoController.text = code ?? '';
                        });
                      });
                },
                icon: const IconCustom(iConURL: assets.kQrCode, size: 25)),
          )
        ],
      ),
    );
  }

  DropdownMenuItem<DcLocal> dropDownMenuItemDCLocal(DcLocal item) {
    return DropdownMenuItem<DcLocal>(
        value: item,
        child: dropdown_custom
            .cardItemDropdown(assetIcon: assets.locationStock, children: [
          Text(item.dcDesc ?? "",
              style: const TextStyle(
                color: colors.defaultColor,
                fontWeight: FontWeight.bold,
              )),
        ]));
  }

  Widget buildSelectedItemDCLocal(DcLocal e) {
    return Text(e.dcDesc ?? "");
  }

  Widget _buildBtn({
    required VoidCallback onPressed,
    required String text,
  }) {
    return Expanded(
      child: ElevatedButtonWidget(
        backgroundColor: colors.defaultColor,
        height: MediaQuery.sizeOf(context).height * 0.06,
        isPadding: false,
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBtnUpdate() {
    return ElevatedButtonWidget(
      text: '5589',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          BlocProvider.of<SiteStockCheckBloc>(context).add(SiteStockCheckSave(
              generalBloc: generalBloc,
              trailerNo: _trailerNoController.text.trim(),
              cySiteCode: cySelected!.cyCode,
              remark: _remarkController.text.trim()));
        }
      },
    );
  }

  void _reset() {
    _trailerNoController.clear();
    _remarkController.clear();
  }
}
