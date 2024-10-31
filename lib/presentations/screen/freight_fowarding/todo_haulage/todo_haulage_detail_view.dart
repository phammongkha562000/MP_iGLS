import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/freight_fowarding/todo_haulage/todo_haulage_detail/todo_haulage_detail_bloc.dart';
import 'package:igls_new/data/models/freight_fowarding/to_do_haulage/todo_haulage_detail_response.dart';
import 'package:igls_new/data/models/equipment/equipment_response.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/export_common.dart';
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/widgets/dialog/custom_dialog.dart';
import 'package:igls_new/presentations/widgets/export_widget.dart';
import 'package:igls_new/presentations/widgets/layout_common.dart';
import 'package:igls_new/presentations/widgets/load/load.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../enum/trade_type.dart';
import '../../../widgets/app_bar_custom.dart';

class ToDoHaulageDetailView extends StatefulWidget {
  const ToDoHaulageDetailView({
    super.key,
    required this.woTaskId,
    required this.wOTaskIdPending,
    required this.isPending,
  });
  final int woTaskId;
  final int wOTaskIdPending;
  final bool isPending;
  @override
  State<ToDoHaulageDetailView> createState() => _ToDoHaulageDetailViewState();
}

class _ToDoHaulageDetailViewState extends State<ToDoHaulageDetailView> {
  final TextEditingController _cntrTempController = TextEditingController();
  final TextEditingController _sealTempController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _navigationService = getIt<NavigationService>();
  final TextEditingController _scanController = TextEditingController();
  final TextEditingController _cntrController = TextEditingController();
  final TextEditingController _sealController = TextEditingController();
  late ToDoHaulageDetailBloc _bloc;
  final GlobalKey _autocompleteKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  bool isEnable = true;
  List<String> textBtnList = [];
  List<String> iconBtnList = [];
  late GeneralBloc generalBloc;

  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<ToDoHaulageDetailBloc>(context);
    _bloc.add(ToDoHaulageDetailViewLoaded(
        woTaskId: widget.woTaskId, generalBloc: generalBloc));
    isEnable = (widget.isPending == false) ||
            (widget.isPending == true &&
                widget.wOTaskIdPending == widget.woTaskId)
        ? true
        : false;
    super.initState();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.toDoHaulageRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      onPopInvoked: (bool didPop) async => _back(context),
      child: BlocConsumer<ToDoHaulageDetailBloc, ToDoHaulageDetailState>(
        listener: (context, state) {
          if (state is ToDoHaulageDetailSuccess) {
            if (state.isSuccess == true) {
              CustomDialog().success(context);
              return;
            } else if (state.isSuccess == false) {
              if (state.expectedTime == null) {
                CustomDialog().error(context, err: '5049');
                return;
              }
              CustomDialog().warning(context,
                  message:
                      '${'5050'.tr()} ${FormatDateConstants.convertyyyyMMddHHmmToHHmm(state.expectedTime.toString())}');
            }
          }

          if (state is ToDoHaulageDetailFailure) {
            CustomDialog().error(context, err: state.message);
            _bloc.add(ToDoHaulageDetailViewLoaded(
                woTaskId: widget.woTaskId, generalBloc: generalBloc));
          }
        },
        builder: (context, state) {
          if (state is ToDoHaulageDetailSuccess) {
            _noteController.text = state.detail.driverMemo ?? '';
            textBtnList =
                _getTextBTN(woEquipMode: state.detail.woEquipMode ?? '');
            iconBtnList =
                _getIconBTN(woEquipMode: state.detail.woEquipMode ?? '');
            _cntrController.text = state.detail.cntnNo ?? '';
            _sealController.text = state.detail.sealNo ?? '';

            return Scaffold(
              appBar: AppBarCustom(
                centerTitle: false,
                title: Text(
                  state.detail.woNo ?? '',
                ),
                actions: [
                  IconButton(
                      onPressed: () => _navigationService
                              .pushNamed(routes.takePictureRoute, args: {
                            key_params.itemIdPicture: state.detail.refNo,
                            key_params.titleGalleryTodo: state.detail.woNo,
                            key_params.refNoValue:
                                state.detail.woTaskId.toString(),
                            key_params.refNoType: "FETASKD",
                            key_params.docRefType: "WO",
                            key_params.allowEdit: true
                          }),
                      icon: const Icon(Icons.photo))
                ],
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      Navigator.pop(context, state.detail.woTaskId),
                ),
              ),
              body: SingleChildScrollView(
                padding: LayoutCommon.spaceBottomView,
                child: CardCustom(
                  elevation: 5,
                  radius: 32.r,
                  child: Column(children: [
                    ..._headerInfo(detail: state.detail),
                    _divider(),
                    _buildCntrNoAndSealNoTrailer(state, context),
                    isEnable
                        ? Column(
                            children: [
                              _divider(),
                              ..._proccessLine(
                                  detail: state.detail,
                                  isTransfer: state.isTransfer,
                                  task: state.detail),
                            ],
                          )
                        : const SizedBox(),
                    _divider(),
                    _groupTaskNote(),
                  ]),
                ),
              ),
            );
          }
          return Scaffold(
              appBar: AppBarCustom(
                title: Text("5051".tr()),
              ),
              body: const ItemLoading());
        },
      ),
    );
  }

  _showTrailerNo(BuildContext context,
      {required List<EquipmentResponse> equipmentList,
      required String trailerNo}) async {
    final formKey = GlobalKey<FormState>();

    _scanController.text = trailerNo;
    AwesomeDialog(
      dismissOnTouchOutside: false,
      padding: EdgeInsets.all(16.w),
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      btnCancelColor: colors.textRed,
      btnOkColor: colors.textGreen,
      btnOkText: "5589".tr(),
      btnCancelText: "26".tr(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Row(children: [
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _scanController,
                      focusNode: _focusNode,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'))
                      ],
                      onFieldSubmitted: (String value) {
                        RawAutocomplete.onFieldSubmitted<String>(
                            _autocompleteKey);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          CustomDialog().error(context, err: '5067');
                          return '5067';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text(
                          "4012".tr(),
                          style: styleLabelInput,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _scanController.clear();
                            },
                            icon: const IconCustom(
                              iConURL: assets.toastError,
                              size: 25,
                            )),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) =>
                          RawAutocomplete<String>(
                        key: _autocompleteKey,
                        focusNode: _focusNode,
                        textEditingController: _scanController,
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
                            child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(4.r)),
                              ),
                              elevation: 4.0,
                              child: SizedBox(
                                height: 100.h,
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
                                        padding: EdgeInsets.all(16.w),
                                        child: Text(option),
                                      ),
                                    );
                                  },
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
                  flex: 2,
                  child: IconButton(
                    icon: const IconCustom(iConURL: assets.kQrCode, size: 25),
                    onPressed: () async {
                      final qrBarCodeScannerDialogPlugin =
                          QrBarCodeScannerDialog();
                      qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                          context: context,
                          onCode: (code) {
                            setState(() {
                              _scanController.text = code ?? '';
                            });
                          });
                    },
                  ))
            ]),
            const HeightSpacer(height: 0.01),
          ],
        ),
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (formKey.currentState!.validate()) {
          _bloc.add(ToDoHaulageUpdateTrailer(
              trailer: _scanController.text, generalBloc: generalBloc));
        }
      },
    ).show();
  }

  Widget _buildCntrNoAndSealNoTrailer(
      ToDoHaulageDetailSuccess state, BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(0.3),
                1: FlexColumnWidth(0.6),
                2: FlexColumnWidth(0.3),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                _buildRowUpdate(
                    isRequired:
                        state.detail.transportType == 'O' ? true : false,
                    label: '3645',
                    content: state.detail.cntnNo ?? '',
                    onPressed: (state.detail.cntnNo != '' &&
                                state.detail.cntnNo != null) &&
                            state.detail.tradeType == 'I'
                        ? null
                        : () => _showCNTR(context,
                            cntr: state.detail.cntnNo ?? '',
                            seal: state.detail.sealNo ?? '')),
                _buildRowUpdate(
                    label: '3659',
                    content: state.detail.sealNo ?? '',
                    onPressed: () => _showSeal(context,
                        cntr: state.detail.cntnNo ?? '',
                        seal: state.detail.sealNo ?? '')),
                _buildRowUpdate(
                  isRequired: true,
                  label: '4012',
                  content: state.detail.secEquipmentCode ?? '',
                  onPressed: () => _showTrailerNo(context,
                      trailerNo: state.detail.secEquipmentCode ?? '',
                      equipmentList: state.equipmentList),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  _showCNTR(BuildContext context,
      {required String cntr, required String seal}) {
    final formKey = GlobalKey<FormState>();

    if (cntr != '') {
      _cntrTempController.text = cntr;
    }
    return AwesomeDialog(
      dismissOnTouchOutside: false,
      padding: EdgeInsets.all(16.w),
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      btnCancelColor: colors.textRed,
      btnOkColor: colors.textGreen,
      btnOkText: "5589".tr(),
      btnCancelText: "26".tr(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextFormField(
                    maxLength: 11,
                    controller: _cntrTempController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value!.length < 4 ||
                          RegExp(r'^[a-zA-Z]*$')
                                  .hasMatch(value.substring(0, 4)) !=
                              true) {
                        return '4 ký tự đầu phải là chữ cái';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text(
                        '3645'.tr(),
                        style: styleLabelInput,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _cntrTempController.clear();
                          },
                          icon: const IconCustom(
                            iConURL: assets.toastError,
                            size: 25,
                          )),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: const IconCustom(iConURL: assets.kQrCode, size: 25),
                      onPressed: () async {
                        final qrBarCodeScannerDialogPlugin =
                            QrBarCodeScannerDialog();
                        qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (code) {
                              setState(() {
                                _cntrTempController.text = code ?? '';
                              });
                            });
                      },
                    ))
              ],
            ),
          ],
        ),
      ),
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkOnPress: () {
        if (formKey.currentState!.validate()) {
          _bloc.add(ToDoHaulageUpdateContainerSealNo(
              cntr: _cntrTempController.text,
              seal: _sealController.text,
              generalBloc: generalBloc));
          Navigator.of(context).pop();
        }

        // if ((_cntrTempController.text.isEmpty &&
        //         _sealController.text.isEmpty) ==
        //     true) {
        //   CustomDialog().error(context, err: '5067');
        // } else {
        //   _bloc.add(ToDoHaulageUpdateContainerSealNo(
        //       cntr: _cntrTempController.text,
        //       seal: _sealController.text,
        //       generalBloc: generalBloc));
        // }
      },
      autoDismiss: false,
      onDismissCallback: (type) {},
    ).show();
  }

  _showSeal(BuildContext context,
      {required String cntr, required String seal}) {
    // _cntrController.text = cntr;
    // _sealController.text = seal;
    if (seal != '') {
      _sealTempController.text = seal;
    }
    return AwesomeDialog(
        dismissOnTouchOutside: false,
        padding: EdgeInsets.all(16.w),
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.rightSlide,
        btnCancelColor: colors.textRed,
        btnOkColor: colors.textGreen,
        btnOkText: "5589".tr(),
        btnCancelText: "26".tr(),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextFormField(
                    controller: _sealTempController,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 25,
                    decoration: InputDecoration(
                        label: Text(
                          "3659".tr(),
                          style: styleLabelInput,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _sealTempController.clear();
                            },
                            icon: const IconCustom(
                              iConURL: assets.toastError,
                              size: 25,
                            ))),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: const IconCustom(iConURL: assets.kQrCode, size: 25),
                      onPressed: () async {
                        final qrBarCodeScannerDialogPlugin =
                            QrBarCodeScannerDialog();
                        qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (code) {
                              setState(() {
                                _sealTempController.text = code ?? '';
                              });
                            });
                      },
                    ))
              ],
            ),
          ],
        ),
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          if ((_cntrController.text.isEmpty &&
                  _sealTempController.text.isEmpty) ==
              true) {
            CustomDialog().error(context, err: '5067');
          } else {
            _bloc.add(ToDoHaulageUpdateContainerSealNo(
                cntr: _cntrController.text,
                seal: _sealTempController.text,
                generalBloc: generalBloc));
          }
        }).show();
  }

  TableRow _buildRowUpdate(
      {required String content,
      bool? isRequired,
      required String label,
      required VoidCallback? onPressed}) {
    return TableRow(
      children: <Widget>[
        Text(
          isRequired ?? false ? '${label.tr()} *' : label.tr(),
          style: TextStyle(color: (content == '') ? Colors.red : Colors.black),
        ),
        InkWell(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.h),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: colors.textWhite),
            child: Text(content == '' ? '${'5185'.tr()}...' : content,
                style: TextStyle(
                    fontStyle:
                        content == '' ? FontStyle.italic : FontStyle.normal,
                    fontWeight:
                        content == '' ? FontWeight.normal : FontWeight.bold,
                    color:
                        content == '' ? colors.textGrey : colors.defaultColor)),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: onPressed != null
                    ? colors.defaultColor
                    : Colors.transparent,
              ),
              onPressed: onPressed,
            ),
            (label == '4012' && content != '')
                ? IconButton(
                    onPressed: () => _navigationService.pushNamed(
                        routes.toDoHaulageImageRoute,
                        args: {key_params.trailerNoImage: content}),
                    icon: const Icon(
                      Icons.photo,
                      color: colors.defaultColor,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }

  List<Widget> _headerInfo({required HaulageToDoDetail detail}) => [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                '5047'.tr(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                detail.woNo ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                detail.contactCode ?? '',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.americanYellow,
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('4595'.tr())),
              Expanded(
                flex: 4,
                child: Text(
                  detail.woEquipMode ?? '',
                  style: styleTextTitle,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${detail.taskModeOrginal ?? ''}-${TradeType.from(detail.tradeType ?? "")}',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                '1291'.tr(),
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(
                detail.equipmentType ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  '4017'.tr(),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  detail.taskMemo ?? '',
                  style: const TextStyle(
                      color: colors.textRed, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        )
      ];

  Widget _divider() => Divider(
        color: colors.defaultColor,
        height: 20.h,
      );

  List<Widget> _proccessLine(
      {required HaulageToDoDetail detail,
      required bool isTransfer,
      required HaulageToDoDetail task}) {
    final isPickup = detail.actualStart != '' ? true : false;
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeline(
              content: detail.actualStart ?? '',
              isFirst: true,
              isPickUp: isPickup),
          _buildTimeline(
              content: detail.actualEnd ?? '',
              isFirst: false,
              isPickUp: isPickup,
              trailer: detail.secEquipmentCode,
              transportType: detail.transportType,
              cntrNo: detail.cntnNo ?? ''),
        ],
      ),
      detail.actualStart != ''
          ? const SizedBox()
          : ElevatedButtonWidget(
              isPadding: false,
              backgroundColor:
                  isTransfer ? colors.defaultColor : colors.btnGreyDisable,
              text: '4377'.tr(),
              onPressed: isTransfer
                  ? () => _navigationService.pushNamed(routes.planTransferRoute,
                      args: {key_params.taskTodoHaulage: task})
                  : null)
    ];
  }

  Widget _buildTimeline(
      {required String content,
      required bool isFirst,
      required bool isPickUp,
      String? transportType,
      String? cntrNo,
      String? trailer}) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: !isFirst,
        afterLineStyle:
            LineStyle(color: isPickUp ? colors.textGrey : colors.textBlack),
        beforeLineStyle:
            LineStyle(color: isPickUp ? colors.textGrey : colors.textBlack),
        alignment: TimelineAlign.manual,
        lineXY: 0.0,
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          padding: EdgeInsets.all(8.w),
          indicator: Image.asset(
            isFirst ? iconBtnList[0] : iconBtnList[1],
            color: (content == '' && isFirst && !isPickUp)
                ? colors.textBlack
                : (content == '' && !isPickUp
                    ? colors.textGrey
                    : (content != '' && isPickUp
                        ? colors.textGrey
                        : colors.textBlack)),
          ),
        ),
        endChild: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: ElevatedButtonWidget(
            isPadding: false,
            borderRadius: 32.r,
            backgroundColor: (content == '' && isFirst && !isPickUp)
                ? colors.textGreen
                : (content == '' && !isPickUp
                    ? colors.textGrey
                    : (content != '' && isPickUp
                        ? colors.textGrey
                        : colors.textGreen)),
            onPressed: content != ''
                ? null
                : (isFirst
                    ? () {
                        //pickup
                        _bloc.add(
                          ToDoHaulageUpdateWorkOrderStatus(
                              eventType: 'PU',
                              pickUpTime: DateTime.now(),
                              generalBloc: generalBloc),
                        );
                      }
                    : isPickUp
                        ? () {
                            //complete
                            if (trailer == '' ||
                                (transportType == 'O' && cntrNo == '')) {
                              CustomDialog().error(context,
                                  err: transportType == 'O'
                                      ? '5437'.tr()
                                      : '5229'.tr());
                            } else {
                              _bloc.add(
                                ToDoHaulageUpdateWorkOrderStatus(
                                    generalBloc: generalBloc, eventType: 'CO'),
                              );
                            }
                          }
                        : null),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                content != ''
                    ? FormatDateConstants.convertddMMyyyyHHmm2(
                        content,
                      )
                    : (isFirst ? textBtnList[0] : textBtnList[1]),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _groupTaskNote() => Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.text,
              textAlignVertical: TextAlignVertical.center,
              controller: _noteController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      _noteController.clear();
                    },
                    icon: const IconCustom(
                      iConURL: assets.toastError,
                      size: 25,
                      color: colors.textRed,
                    )),
                label: Text('5056'.tr()),
              ),
            )),
            const WidthSpacer(width: 0.02),
            ElevatedButtonWidget(
              isPadding: false,
              borderRadius: 32.r,
              fontSize: 14,
              width: 0.25,
              text: '5057'.tr(),
              onPressed: () {
                _bloc.add(ToDoHaulageUpdateNote(
                    note: _noteController.text, generalBloc: generalBloc));
              },
            )
          ],
        ),
      );

  List<String> _getTextBTN({required String woEquipMode}) {
    switch (woEquipMode) {
      case 'LH':
      case 'LR':
        return [
          '${'5209'.tr()}\n(${'5182'.tr()})',
          '${'5210'.tr()}\n(${'5186'.tr()})',
        ];
      case 'HH':
      case 'HR':
        return [
          '${'5209'.tr()}\n(${'5183'.tr()})',
          '${'5210'.tr()}\n(${'5184'.tr()})',
        ];
    }
    return ['5209'.tr(), '5210'.tr()];
  }

  List<String> _getIconBTN({required String woEquipMode}) {
    switch (woEquipMode) {
      case 'LH':
      case 'LR':
        return [assets.icPort, assets.icStock];
      case 'HH':
      case 'HR':
        return [
          assets.icStock,
          assets.icPort,
        ];
    }
    return [assets.icPort, assets.icStock];
  }
}
