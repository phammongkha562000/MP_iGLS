import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/freight_fowarding/site_trailer_check/site_trailer/site_trailer_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/site_stock_check/cy_site_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/enum/working_status_trailer.dart';
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/components/drop_down_button_form_field2_widget.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/equipment/equipment_response.dart';
import '../../../widgets/app_bar_custom.dart';

class SiteTrailerView extends StatefulWidget {
  const SiteTrailerView({super.key});

  @override
  State<SiteTrailerView> createState() => _SiteTrailerViewState();
}

class _SiteTrailerViewState extends State<SiteTrailerView> {
  final _navigationService = getIt<NavigationService>();
  final _trailerNoController = TextEditingController();
  final _cntrController = TextEditingController();
  final _remarkController = TextEditingController();
  final ValueNotifier<bool> _cntrStatusNotifer = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _tireNotifer = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _ledNotifer = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _barriesNotifer = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _continerLockerNotifer = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _landingGearNotifer = ValueNotifier<bool>(true);
  final ValueNotifier<String> _workingStatusNotifier =
      ValueNotifier<String>(WorkingStatusTrailer.normal.code);
  final ValueNotifier<CySiteResponse> _cyNotifier =
      ValueNotifier<CySiteResponse>(CySiteResponse(cyCode: '', cyName: ''));

  CySiteResponse? cySelected;
  final _formKey = GlobalKey<FormState>();

  late SiteTrailerBloc _bloc;
  late GeneralBloc generalBloc;

  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);

    _bloc = BlocProvider.of<SiteTrailerBloc>(context);
    _bloc.add(SiteTrailerViewLoaded(generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBarCustom(title: Text('4676'.tr())),
          body: BlocConsumer<SiteTrailerBloc, SiteTrailerState>(
            listener: (context, state) {
              if (state is SiteTrailerSaveSuccess) {
                _reset();
                CustomDialog().success(context);
                _bloc.add(SiteTrailerViewLoaded(generalBloc: generalBloc));
              }
              if (state is SiteTrailerFailure) {
                CustomDialog().error(
                  context,
                  err: state.message,
                  btnOkOnPress: () => _bloc
                      .add(SiteTrailerViewLoaded(generalBloc: generalBloc)),
                );
              }
            },
            builder: (context, state) {
              if (state is SiteTrailerSuccess) {
                if (state.cySite != null) {
                  _cyNotifier.value = state.cySite!;
                  cySelected = state.cySite!;
                }

                return GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.sizeOf(context).height * 0.015),
                        child: ValueListenableBuilder(
                          valueListenable: _cyNotifier,
                          builder: (context, value, child) =>
                              DropDownButtonFormField2CYSiteWidget(
                            onChanged: (value) {
                              value as CySiteResponse;
                              _cyNotifier.value = value;
                              cySelected = value;
                              _bloc.add(SiteTrailerPickCysite(
                                  generalBloc: generalBloc,
                                  cySiteCode: value.cyCode));
                            },
                            value: cySelected,
                            hintText: '5083',
                            label: '5124',
                            list: state.cySiteList,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.sizeOf(context).height * 0.015),
                        child: Row(
                          children: [
                            _buildBtn(
                                text: '5444'.tr(),
                                onPressed: () async {
                                  final result = await _navigationService
                                      .navigateAndDisplaySelection(
                                    routes.siteTrailerPendingRoute,
                                    args: {key_params.cyPending: state.cySite},
                                  );
                                  if (result != null) {
                                    _trailerNoController.text =
                                        result as String;
                                  }
                                }),
                            SizedBox(
                              width: 8.w,
                            ),
                            _buildBtn(
                                text: '5125'.tr(),
                                onPressed: () {
                                  _navigationService.pushNamed(
                                    routes.siteTrailerDetailRoute,
                                    args: {
                                      key_params.cyName: state.cySite == null
                                          ? ''
                                          : state.cySite!.cyName
                                    },
                                  );
                                })
                          ],
                        ),
                      ),

                      _buildTrailer(equipmentList: state.equipmentList),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.sizeOf(context).height * 0.015),
                        child: ValueListenableBuilder(
                          builder: (context, value, child) => _buildRadioGroup(
                              title: '5126'.tr(),
                              groupValue: _cntrStatusNotifer.value,
                              reverse: true,
                              title1: '5127'.tr(),
                              title2: '5128'.tr(),
                              onChanged: (newValue) {
                                _cntrStatusNotifer.value =
                                    !_cntrStatusNotifer.value;
                              }),
                          valueListenable: _cntrStatusNotifer,
                        ),
                      ),
                      //cntr no
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.sizeOf(context).height * 0.015),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: ValueListenableBuilder(
                                valueListenable: _cntrStatusNotifer,
                                builder: (context, value, child) =>
                                    TextFormField(
                                  maxLength: 11,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z0-9]'))
                                  ],
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  controller: _cntrController,
                                  style:
                                      const TextStyle(color: colors.textBlack),
                                  validator: (value) => _cntrStatusNotifer.value
                                      ? value!.isNotEmpty
                                          ? null
                                          : "5067".tr()
                                      : null,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: '${"3645".tr()}...',
                                      label: Text('3645'.tr())),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: IconButton(
                                  onPressed: () async {
                                    final qrBarCodeScannerDialogPlugin =
                                        QrBarCodeScannerDialog();
                                    qrBarCodeScannerDialogPlugin
                                        .getScannedQrBarCode(
                                            context: context,
                                            onCode: (code) {
                                              setState(() {
                                                _cntrController.text =
                                                    code ?? '';
                                              });
                                            });
                                  },
                                  icon: const IconCustom(
                                      iConURL: assets.kQrCode, size: 25)),
                            )
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                          builder: (context, value, child) =>
                              _buildRadioGroupWorkingStatus(
                                  title: '5569',
                                  title1: '5572',
                                  title2: '5570',
                                  title3: '5571',
                                  groupValue: _workingStatusNotifier.value,
                                  onChanged: (newValue) =>
                                      _workingStatusNotifier.value = newValue!),
                          valueListenable: _workingStatusNotifier),
                      ValueListenableBuilder(
                        builder: (context, value, child) => _buildRadioGroup(
                            title: '5129',
                            groupValue: _tireNotifer.value,
                            onChanged: (newValue) =>
                                _tireNotifer.value = !_tireNotifer.value),
                        valueListenable: _tireNotifer,
                      ),
                      ValueListenableBuilder(
                        builder: (context, value, child) => _buildRadioGroup(
                            title: '5130',
                            groupValue: _ledNotifer.value,
                            onChanged: (newValue) =>
                                _ledNotifer.value = !_ledNotifer.value),
                        valueListenable: _ledNotifer,
                      ),
                      ValueListenableBuilder(
                          builder: (context, value, child) => _buildRadioGroup(
                              title: '5131',
                              groupValue: _barriesNotifer.value,
                              onChanged: (newValue) => _barriesNotifer.value =
                                  !_barriesNotifer.value),
                          valueListenable: _barriesNotifer),
                      ValueListenableBuilder(
                          builder: (context, value, child) => _buildRadioGroup(
                              title: '5132',
                              groupValue: _continerLockerNotifer.value,
                              onChanged: (newValue) => _continerLockerNotifer
                                  .value = !_continerLockerNotifer.value),
                          valueListenable: _continerLockerNotifer),
                      ValueListenableBuilder(
                          builder: (context, value, child) => _buildRadioGroup(
                              title: '5133',
                              groupValue: _landingGearNotifer.value,
                              onChanged: (newValue) => _landingGearNotifer
                                  .value = !_landingGearNotifer.value),
                          valueListenable: _landingGearNotifer),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.sizeOf(context).height * 0.015),
                        child: TextFormField(
                          controller: _remarkController,
                          maxLines: 5,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: colors.textBlack),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 25),
                              border: InputBorder.none,
                              hintText: '${'1276'.tr()}...',
                              label: Text('1276'.tr())),
                        ),
                      ),
                    ]),
                  ),
                );
              }
              return const ItemLoading();
            },
          ),
          bottomNavigationBar: _buildBtnUpdate()),
    );
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

  Widget _buildTrailer({required List<EquipmentResponse> equipmentList}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                    controller: _trailerNoController,
                    focusNode: _focusNode,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
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
                          _navigationService
                              .pushNamed(routes.siteTrailerHistoryRoute, args: {
                            key_params.trailerHistory: _trailerNoController.text
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
                  builder: (context, constraints) => RawAutocomplete<String>(
                    key: _autocompleteKey,
                    focusNode: _focusNode,
                    textEditingController: _trailerNoController,
                    optionsBuilder: (
                      TextEditingValue textEditingValue,
                    ) {
                      return equipmentList
                          .map((e) => e.equipmentDesc!)
                          .toList()
                          .where((String option) {
                        return option.contains(textEditingValue.text);
                      }).toList();
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
                                itemBuilder: (BuildContext context, int index) {
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
                ),
              ],
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

  _buildBtnUpdate() {
    return ElevatedButtonWidget(
      isPaddingBottom: true,
      text: '5589',
      onPressed: () {
        log(_trailerNoController.text);
        if (_formKey.currentState!.validate()) {
          _bloc.add(SiteTrailerSave(
              generalBloc: generalBloc,
              barriers: _status(check: _barriesNotifer.value),
              cntrStatus: _statusCNTR(check: _cntrStatusNotifer.value),
              containerLocker: _status(check: _continerLockerNotifer.value),
              landingGear: _status(check: _landingGearNotifer.value),
              ledStatus: _status(check: _ledNotifer.value),
              remark: _remarkController.text,
              trailerNo: _trailerNoController.text,
              tireStatus: _status(check: _tireNotifer.value),
              cntrNo: _cntrController.text,
              cySiteName: cySelected!.cyName,
              workingStatus: _workingStatusNotifier.value));
        }
      },
    );
  }

  String _status({required bool check}) => check ? "Ok" : "Not Good";

  String _statusCNTR({required bool check}) => check ? "Loaded" : "Empty";
  Widget _buildRadioGroup(
      {required bool groupValue,
      required String title,
      String? title1,
      String? title2,
      bool? reverse,
      required void Function(bool?)? onChanged}) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(title.tr())),
        Expanded(
          flex: reverse ?? false ? 4 : 3,
          child: RadioListTile<bool>(
              title: Text((title1 ?? '5134').tr()),
              value: true,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              groupValue: groupValue,
              onChanged: onChanged),
        ),
        Expanded(
            flex: reverse ?? false ? 4 : 5,
            child: RadioListTile<bool>(
                title: Text((title2 ?? '5135').tr()),
                contentPadding: EdgeInsets.zero,
                value: false,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                groupValue: groupValue,
                onChanged: onChanged))
      ],
    );
  }

  Widget _buildRadioGroupWorkingStatus(
      {required String groupValue,
      required String title,
      required String title1,
      required String title2,
      required String title3,
      required void Function(String?)? onChanged}) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(title.tr())),
        Expanded(
          flex: 3,
          child: RadioListTile<String>(
              title: Text(title1.tr()),
              value: WorkingStatusTrailer.forRent.code,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              groupValue: groupValue,
              onChanged: onChanged),
        ),
        Expanded(
            flex: 3,
            child: RadioListTile<String>(
                title: Text(title2.tr()),
                contentPadding: EdgeInsets.zero,
                value: WorkingStatusTrailer.normal.code,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                groupValue: groupValue,
                onChanged: onChanged)),
        Expanded(
            flex: 3,
            child: RadioListTile<String>(
                title: Text(title3.tr()),
                contentPadding: EdgeInsets.zero,
                value: WorkingStatusTrailer.notWorking.code,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                groupValue: groupValue,
                onChanged: onChanged))
      ],
    );
  }

  void _reset() {
    _trailerNoController.text = '';
    _cntrController.text = '';
    _remarkController.text = '';
    _cntrStatusNotifer.value = true;
    _tireNotifer.value = true;
    _ledNotifer.value = true;
    _barriesNotifer.value = true;
    _continerLockerNotifer.value = true;
    _landingGearNotifer.value = true;
    _workingStatusNotifier.value = WorkingStatusTrailer.normal.code;
  }
}
