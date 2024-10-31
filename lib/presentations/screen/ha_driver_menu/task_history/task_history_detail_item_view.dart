import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/businesses_logics/bloc/ha_driver_menu/task_history/task_history_detail_item/task_history_detail_item_bloc.dart';
import 'package:igls_new/data/services/injection/injection_igls.dart';
import 'package:igls_new/data/services/navigator/navigation_service.dart';
import 'package:igls_new/data/services/navigator/route_path.dart' as routes;
import 'package:igls_new/data/shared/mixin/alert.dart';
import 'package:igls_new/data/shared/utils/file_utils.dart';

import 'package:igls_new/data/shared/utils/format_number.dart';
import 'package:igls_new/data/shared/utils/formatdate.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/key_params.dart' as key_params;
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/widgets/layout_common.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../businesses_logics/bloc/general/general_bloc.dart';
import '../../../../data/models/models.dart';
import '../../../widgets/app_bar_custom.dart';

class TaskHistoryDetailItemView extends StatefulWidget {
  const TaskHistoryDetailItemView({
    super.key,
    required this.dailyTask,
    required this.dtdId,
  });
  final DailyTask dailyTask;
  final int dtdId;

  @override
  State<TaskHistoryDetailItemView> createState() =>
      _TaskHistoryDetailItemViewState();
}

class _TaskHistoryDetailItemViewState extends State<TaskHistoryDetailItemView>
    with Alert {
  final TextEditingController _cntrTempController = TextEditingController();
  final TextEditingController _sealTempController = TextEditingController();
  final _navigationService = getIt<NavigationService>();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();
  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationService.pushReplacementNamed(routes.taskHistoryDetailRoute,
          args: {key_params.taskHistoryDetailById: widget.dailyTask.dtId});
    });
    return false;
  }

  late GeneralBloc generalBloc;
  late TaskHistoryDetailItemBloc _bloc;

  List<String> iconBtnList = [];
  @override
  void initState() {
    generalBloc = BlocProvider.of<GeneralBloc>(context);
    _bloc = BlocProvider.of<TaskHistoryDetailItemBloc>(context);
    _bloc.add(TaskHistoryDetailItemLoaded(
        dtdId: widget.dtdId, generalBloc: generalBloc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      onPopInvoked: (bool didPop) async => _back(context),
      child:
          BlocListener<TaskHistoryDetailItemBloc, TaskHistoryDetailItemState>(
        listener: (context, state) {
          if (state is TaskHistoryDetailItemSuccess) {
            if (state.saveSuccess == true) {
              CustomDialog().success(context);
            }
            if (state.checkEquipment == false) {
              CustomDialog().error(context, err: '5049');
            }
          }

          if (state is TaskHistoryDetailItemFailure) {
            CustomDialog().error(context, err: state.message);
          }
        },
        child:
            BlocBuilder<TaskHistoryDetailItemBloc, TaskHistoryDetailItemState>(
          builder: (context, state) {
            if (state is TaskHistoryDetailItemSuccess) {
              final woId = state.detailItem.woTaskId;
              iconBtnList =
                  _getIconBTN(woEquipMode: state.detailItem.taskMode ?? '');
              return Scaffold(
                  appBar: AppBarCustom(
                    title: Text("5051".tr()),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          Navigator.pop(context, state.detailItem.dtdId),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            _navigationService
                                .pushNamed(routes.takePictureRoute, args: {
                              key_params.titleGalleryTodo:
                                  state.detailItem.woNo,
                              key_params.refNoValue:
                                  state.detailItem.woTaskId.toString(),
                              key_params.refNoType: "FETASKD",
                              key_params.docRefType: "WO",
                              key_params.allowEdit:
                                  widget.dailyTask.dailyTaskStatus == 'COMPLETE'
                                      ? false
                                      : true
                            });
                          },
                          icon: const Icon(Icons.photo_library_sharp))
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: CardCustom(
                          elevation: 5,
                          radius: 32,
                          child: Column(
                            children: [
                              _buildDocNoAndStatus(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.sizeOf(context).height *
                                            0.007),
                                child: _taskMemo(state),
                              ),
                              _driverNote(state)
                            ],
                          ),
                        ),
                      ),
                      LayoutCommon.divider,
                      Expanded(
                        child: ListView(
                          padding: LayoutCommon.spaceBottomView,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [
                            CardCustom(
                              elevation: 5,
                              radius: 32,
                              child: Column(
                                children: [
                                  _buildItemNormal(
                                      label: "1272",
                                      value:
                                          state.detailItem.contactCode ?? ""),

                                  state.detailItem.tradeType == 'E'
                                      ? _buildItemNormal(
                                          label: "3719",
                                          value: state.detailItem.bcNo ?? "",
                                        )
                                      : _buildItemNormal(
                                          label: "3571",
                                          value: state.detailItem.blNo ?? ""),
                                  _buildItemNormal(
                                      label: "4595",
                                      value: state.detailItem.taskMode ?? ""),
                                  state.detailItem.tradeType == 'I' &&
                                          (state.detailItem.cntrNo != null &&
                                              state.detailItem.cntrNo != '')
                                      ? _buildItemNormal(
                                          label: "3645",
                                          isRequired:
                                              state.detailItem.transportType ==
                                                      'O'
                                                  ? true
                                                  : false,
                                          value: state.detailItem.cntrNo ?? '')
                                      : _buildItemWithButton(
                                          label: "3645",
                                          value: state.detailItem.cntrNo ?? "",
                                          type: 3,
                                          woId: woId!,
                                          state: state,
                                          isCNTR: true,
                                          isRequired:
                                              state.detailItem.transportType ==
                                                      'O'
                                                  ? true
                                                  : false),
                                  //update 6/6/23
                                  _buildItemWithButton(
                                      label: "3659",
                                      value: state.detailItem.sealNo ?? "",
                                      type: 3,
                                      woId: woId!,
                                      state: state,
                                      isCNTR: false),

                                  _buildItemWithButton(
                                      label: "4012",
                                      value:
                                          state.detailItem.secEquipmentCode ??
                                              "",
                                      type: 4,
                                      woId: woId,
                                      state: state,
                                      isRequired: true),
                                  _buildItemNormal(
                                    label: "5211",
                                    value: state.detailItem.pickUpPlace ?? "",
                                  ),
                                  _buildItemNormal(
                                    label: "3924",
                                    value: state.detailItem.deliveryPlace ?? "",
                                  ),
                                  _buildItemNormal(
                                    label: "5212",
                                    value: state.detailItem.returnPlace ?? "",
                                  ),

                                  ..._proccessLine(
                                    detail: state.detailItem,
                                  ),
                                ],
                              ),
                            ),
                            CardCustom(
                              elevation: 5,
                              radius: 32,
                              child: Column(
                                children: [
                                  _buildItemNormal(
                                      label: "4338",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem
                                                      .portProcessingFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "4529",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.tollFee ?? 0.0)),
                                  _buildItemNormal(
                                      label: "5074",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.trafficFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "5075",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.cntrCleanFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "5076",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem
                                                      .cntrProcessingFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "4599",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.workerFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "4339",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.liftOnFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "4340",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.liftOffFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "4325",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.cntrDepositFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "4341",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.othersFee ??
                                                  0.0)),
                                  _buildItemNormal(
                                      label: "1284",
                                      value:
                                          NumberFormatter.numberFormatTotalQty(
                                              state.detailItem.totalFee ??
                                                  0.0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            }
            return Scaffold(
              appBar: AppBarCustom(
                title: Text("5051".tr()),
                actions: const [
                  IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.photo_library_sharp,
                        color: Colors.white,
                      ))
                ],
              ),
              body: const ItemLoading(),
            );
          },
        ),
      ),
    );
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

  List<Widget> _proccessLine({required HistoryDetailItem detail}) {
    final isPickup =
        (detail.actualStart != '' && detail.actualStart != null) ? true : false;
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeline(
              content: detail.actualStart ?? '',
              isFirst: true,
              detail: detail,
              isPickUp: isPickup),
          _buildTimeline(
              detail: detail,
              content: detail.actualEnd ?? '',
              isFirst: false,
              isPickUp: isPickup),
        ],
      ),
    ];
  }

  Widget _buildTimeline(
      {required String content,
      required HistoryDetailItem detail,
      required bool isFirst,
      required bool isPickUp}) {
    return SizedBox(
      height: (MediaQuery.sizeOf(context).height * 0.1),
      child: TimelineTile(
          isFirst: isFirst,
          isLast: !isFirst,
          afterLineStyle: const LineStyle(color: colors.textGrey),
          beforeLineStyle: const LineStyle(color: colors.textGrey),
          alignment: TimelineAlign.manual,
          lineXY: 0.3,
          indicatorStyle: IndicatorStyle(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(8.w),
              indicator: Image.asset(isFirst ? iconBtnList[0] : iconBtnList[1],
                  color: colors.textGrey)),
          endChild: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: ElevatedButtonWidget(
              isPadding: false,
              borderRadius: 32.r,
              onPressed: isFirst
                  ? () {
                      //pickup
                      _showDatePicker(
                          value: detail.actualStart == null
                              ? "+"
                              : "${detail.actualStart}",
                          type: 2,
                          woId: detail.woTaskId!,
                          actualStart: detail.actualStart != null &&
                                  detail.actualStart!.isNotEmpty
                              ? FileUtils.convertMiliSecondToDateTime(
                                  detail.actualStart!)
                              : null,
                          actualEnd: detail.actualEnd != null &&
                                  detail.actualEnd!.isNotEmpty
                              ? FileUtils.convertMiliSecondToDateTime(
                                  detail.actualEnd!)
                              : null);
                    }
                  : isPickUp
                      ? ((detail.secEquipmentCode != '' &&
                                  detail.secEquipmentCode != null) &&
                              ((detail.transportType != 'O') ||
                                  (detail.transportType == 'O' &&
                                      detail.cntrNo != null &&
                                      detail.cntrNo != '')))
                          ? () {
                              //complete
                              _showDatePicker(
                                  value: detail.actualEnd == null
                                      ? "+"
                                      : "${detail.actualEnd}",
                                  type: 1,
                                  woId: detail.woTaskId!,
                                  actualStart: detail.actualStart != null &&
                                          detail.actualStart!.isNotEmpty
                                      ? FileUtils.convertMiliSecondToDateTime(
                                          detail.actualStart!)
                                      : null,
                                  actualEnd: detail.actualEnd != null &&
                                          detail.actualEnd!.isNotEmpty
                                      ? FileUtils.convertMiliSecondToDateTime(
                                          detail.actualEnd!)
                                      : null);
                            }
                          : () {
                              CustomDialog().error(context,
                                  err: detail.transportType == 'O'
                                      ? '5437'.tr()
                                      : '5229'.tr());
                            }
                      : () {
                          CustomDialog().error(context, err: '5231'.tr());
                        },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  content != ''
                      ? FileUtils.convertDateForHistoryDetailItem(content)
                      : (isFirst ? "5209".tr() : "5210".tr()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          startChild: Text(
            '${isFirst ? '5209'.tr() : '5210'.tr()} *',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: content == '' ? colors.textRed : colors.defaultColor),
          )),
    );
  }

  Widget _buildDocNoAndStatus() {
    var colorStatus = widget.dailyTask.dailyTaskStatus == "NEW"
        ? colors.textRed
        : widget.dailyTask.dailyTaskStatus == "COMPLETE"
            ? colors.textGreen
            : colors.defaultColor;

    var date =
        DateFormatLocal.formatddMMyyyy(widget.dailyTask.taskDate.toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month),
                  Text(date,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.description),
                Text(widget.dailyTask.docNo ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        Text(
          widget.dailyTask.dailyTaskStatus ?? "",
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: sizeTextDefault,
              color: colorStatus,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _taskMemo(TaskHistoryDetailItemSuccess state) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "4017".tr(),
            style: styleTextTitle,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(state.detailItem.taskMemo ?? ""),
        ),
      ],
    );
  }

  Widget _driverNote(TaskHistoryDetailItemSuccess state) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "5056".tr(),
            style: styleTextTitle,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            state.detailItem.driverMemo ?? "",
            style: styleTextListView,
          ),
        ),
      ],
    );
  }

  Widget _buildItemWithButton({
    required String label,
    required String value,
    required int type,
    required int woId,
    required TaskHistoryDetailItemSuccess state,
    bool? isRequired,
    bool? isCNTR,
  }) {
    // type = 1: ActualEnd
    // type = 2: ActualStart
    // type = 4: trailerNo
    var formatDate = value;
    if (value != "+") {
      if (type == 1 || type == 2) {
        if (formatDate.isNotEmpty) {
          formatDate = FileUtils.convertDateForHistoryDetailItem(value);
        } else {
          formatDate = "+";
        }
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).width * 0.015),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              isRequired ?? false
                  ? '${label.split(" ").join().tr()} *'
                  : label.split(" ").join().tr(),
              style: (value == '' || value == '+')
                  ? const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)
                  : styleTextTitle,
            ),
          ),
          Expanded(
            flex: type == 4 ? 5 : 6,
            child: InkWell(
              onTap: () {
                switch (type) {
                  case 3: //cntr
                    isCNTR ?? false
                        ? _showCNTRNo(
                            lable: label,
                            value: value,
                            type: type,
                            woId: woId,
                            state: state)
                        : _showSealNo(
                            label: label,
                            value: value,
                            type: type,
                            woId: woId,
                            state: state);
                    break;
                  case 4: //trailer
                    _showTrailerNo(
                        label: label,
                        value: value,
                        type: type,
                        woId: woId,
                        equipmentList: state.equipmentList);
                    break;
                  default:
                    null;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                decoration: BoxDecoration(
                    color: colors.textWhite,
                    borderRadius: BorderRadius.all(Radius.circular(32.r))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate == '' ? '${'5185'.tr()}...' : formatDate,
                      style: TextStyle(
                        fontStyle: formatDate == ''
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: formatDate == ''
                            ? colors.textGrey
                            : colors.defaultColor,
                        fontWeight: formatDate == ''
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.edit)
                  ],
                ),
              ),
            ),
          ),
          type == 4
              ? Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () {
                      _navigationService.pushNamed(routes.toDoHaulageImageRoute,
                          args: {key_params.trailerNoImage: value});
                    },
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }

  _showCNTRNo({
    required String lable,
    required String value,
    required int type,
    required int woId,
    required TaskHistoryDetailItemSuccess state,
  }) async {
    if (value != '') {
      _cntrTempController.text = value;
    }
    final formKeyCNTR = GlobalKey<FormState>();
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      body: Form(
        key: formKeyCNTR,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      controller: _cntrTempController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'))
                      ],
                      maxLength: 11,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        label: Text(
                          '3645'.tr(),
                          style: styleLabelInput,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              // clearText();
                              _cntrTempController.clear();
                            },
                            icon: const IconCustom(
                              iConURL: assets.toastError,
                              size: 25,
                            )),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          return;
                        }
                      },
                      validator: (value) {
                        if (value!.length < 4 ||
                            RegExp(r'^[a-zA-Z]*$')
                                    .hasMatch(value.substring(0, 4)) !=
                                true) {
                          return '4 ký tự đầu phải là chữ cái';
                        }
                        if (value.isEmpty) {
                          return '5067'.tr();
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
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
                      icon: const IconCustom(iConURL: assets.kQrCode, size: 25),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      btnOkOnPress: () {
        if (formKeyCNTR.currentState!.validate()) {
          _bloc.add(UpdateWordOrderWithDataLoaded(
              generalBloc: generalBloc,
              woTaskId: woId,
              dataChange: _cntrTempController.text.trim().toUpperCase(),
              type: type,
              sealNo: state.detailItem.sealNo ?? ''));
          Navigator.of(context).pop();
        }
      },
      btnOkText: "5589".tr(),
      btnCancelText: "26".tr(),
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      dismissOnBackKeyPress: false,
      autoDismiss: false,
      onDismissCallback: (type) {},
    ).show();
  }

  _showSealNo({
    required String label,
    required String value,
    required int type,
    required int woId,
    required TaskHistoryDetailItemSuccess state,
  }) async {
    if (value != '') {
      _sealTempController.text = value;
    }
    final formKeySealNo = GlobalKey<FormState>();
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      body: Form(
        key: formKeySealNo,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      controller: _sealTempController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'))
                      ],
                      maxLength: 25,
                      decoration: InputDecoration(
                        label: Text(
                          label.split(" ").join().tr(),
                          style: styleLabelInput,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              // clearText();
                              _sealTempController.clear();
                            },
                            icon: const IconCustom(
                              iConURL: assets.toastError,
                              size: 25,
                            )),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          return;
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          CustomDialog().error(context, err: '5067');
                          return '5067'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
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
                      icon: const IconCustom(iConURL: assets.kQrCode, size: 25),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      btnOkOnPress: () {
        if (formKeySealNo.currentState!.validate()) {
          _bloc.add(UpdateWordOrderWithDataLoaded(
              generalBloc: generalBloc,
              woTaskId: woId,
              dataChange: state.detailItem.cntrNo ?? '',
              type: type,
              sealNo: _sealTempController.text));
        }
      },
      btnOkText: "5589".tr(),
      btnCancelText: "26".tr(),
      btnCancelOnPress: () {},
      dismissOnBackKeyPress: false,
    ).show();
  }

  _showTrailerNo(
      {required String label,
      required String value,
      required int type,
      required int woId,
      required List<EquipmentResponse> equipmentList}) async {
    final trailerController = TextEditingController(text: value);
    final formKey = GlobalKey<FormState>();
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: trailerController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            label: Text(
                              "4012".tr(),
                              style: styleLabelInput,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  trailerController.clear();
                                },
                                icon: const IconCustom(
                                  iConURL: assets.toastError,
                                  size: 25,
                                )),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'))
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              CustomDialog().error(context, err: '5067');
                              return '5067'.tr();
                            }
                            return null;
                          },
                          onFieldSubmitted: (String value) {
                            RawAutocomplete.onFieldSubmitted<String>(
                                _autocompleteKey);
                          },
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) =>
                              RawAutocomplete<String>(
                            key: _autocompleteKey,
                            focusNode: _focusNode,
                            textEditingController: trailerController,
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
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(4.0)),
                                  ),
                                  elevation: 4.0,
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
                      onPressed: () async {
                        final qrBarCodeScannerDialogPlugin =
                            QrBarCodeScannerDialog();
                        qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (code) {
                              setState(() {
                                trailerController.text = code ?? '';
                              });
                            });
                      },
                      icon: const IconCustom(iConURL: assets.kQrCode, size: 25),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      btnOkText: "5589".tr(),
      btnCancelText: "26".tr(),
      btnOkOnPress: () {
        if (formKey.currentState!.validate()) {
          _bloc.add(UpdateWordOrderWithDataLoaded(
              generalBloc: generalBloc,
              woTaskId: woId,
              dataChange: trailerController.text.trim().toUpperCase(),
              type: type,
              sealNo: ''));
        }
      },
      btnCancelOnPress: () {},
    ).show();
  }

  // Future<dynamic> showScanQR() {}
  Future<dynamic> _showDatePicker(
      {required String value,
      required int type,
      required int woId,
      required DateTime? actualStart,
      required DateTime? actualEnd}) {
    final actualStartInit = actualStart;
    final actualEndInit = actualEnd;
    log('sInit: $actualStartInit');
    log('eInit: $actualEndInit');
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoTheme(
        data: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryContrastingColor: Colors.red,
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
              color: colors.defaultColor,
              fontSize: 18,
            ),
          ),
        ),
        child: CupertinoActionSheet(
          actions: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                maximumDate: DateTime.now(),
                backgroundColor: Colors.white,
                use24hFormat: true,
                initialDateTime: value == "+"
                    ? DateTime.now().subtract(const Duration(seconds: 5))
                    : DateTime.parse(FileUtils.convertMiliSecondToDate(value)),
                onDateTimeChanged: (val) {
                  if (type == 1) {
                    actualEnd = val;
                  } else {
                    actualStart = val;
                  }
                },
              ),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              // type == 2
              //     ? _bloc.add(
              //         UpdateTimeStart(
              //             woTaskId: woId,
              //             timeStartChange:
              //                 FileUtils.formatDateTime(actualStart)))
              //     : _bloc.add(
              //         UpdateTimeEnd(
              //             woTaskId: woId,
              //             timeEndChange: FileUtils.formatDateTime(actualEnd)));
              // *=========================================
              final start1 = actualStart != null
                  ? actualStart!
                      .add(const Duration(minutes: constants.minuteComplete))
                  : DateTime.now();
              final end1 = actualEnd ?? DateTime.now();
              log('as1: $actualStart');
              log('ae1: $actualEnd');
              log('as2: $start1');
              log('ae2: $end1');
              if (actualStartInit == actualEndInit) {
                type == 1
                    ? CustomDialog().error(context, err: 'EnterStartTime')
                    : {
                        _bloc.add(UpdateWordOrderWithDataLoaded(
                          generalBloc: generalBloc,
                          sealNo: '',
                          woTaskId: woId,
                          dataChange: type == 2
                              ? FileUtils.formatDateTime(
                                  actualStart ?? DateTime.now())
                              : FileUtils.formatDateTime(actualEnd!),
                          type: type,
                        )),
                        Navigator.pop(context)
                      };
              } else if (actualStartInit != actualEndInit) {
                // log('check ${end1!.isAfter(start1)}');
                if (actualEndInit != null) {
                  if (end1.isAfter(start1) == false) {
                    CustomDialog().error(
                      context,
                      err:
                          '${'5213'.tr()} ${constants.minuteComplete} ${'5157'.tr()} ${'5214'.tr()}',
                    );
                  } else {
                    _bloc.add(UpdateWordOrderWithDataLoaded(
                      generalBloc: generalBloc,
                      sealNo: '',
                      woTaskId: woId,
                      dataChange: type == 2
                          ? FileUtils.formatDateTime(actualStart!)
                          : FileUtils.formatDateTime(actualEnd!),
                      type: type,
                    ));
                    Navigator.pop(context);
                  }
                } else {
                  if (type == 2) {
                    _bloc.add(UpdateWordOrderWithDataLoaded(
                      generalBloc: generalBloc,
                      sealNo: '',
                      woTaskId: woId,
                      dataChange: type == 2
                          ? FileUtils.formatDateTime(actualStart!)
                          : FileUtils.formatDateTime(actualEnd!),
                      type: type,
                    ));
                    Navigator.pop(context);
                  } else if (type == 1) {
                    if (end1.isAfter(start1) == false) {
                      CustomDialog().error(
                        context,
                        err:
                            '${'5213'.tr()} ${constants.minuteComplete} ${'5157'.tr()} ${'5214'.tr()}',
                      );
                    } else {
                      _bloc.add(UpdateWordOrderWithDataLoaded(
                        generalBloc: generalBloc,
                        sealNo: '',
                        woTaskId: woId,
                        dataChange: type == 2
                            ? FileUtils.formatDateTime(
                                actualStart ?? DateTime.now())
                            : FileUtils.formatDateTime(
                                actualEnd ?? DateTime.now()),
                        type: type,
                      ));
                      Navigator.pop(context);
                    }
                  }
                }
              }
            },
            child: Text(
              "5589".tr(),
              style: const TextStyle(color: colors.defaultColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemNormal({
    required String label,
    required String value,
    bool? isRequired,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).width * 0.007),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              isRequired ?? false
                  ? '${label.split(" ").join().tr()} *'
                  : label.split(" ").join().tr(),
              // style: TextStyle(color: colors.defaultColor),
              style: styleTextTitle,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                  color: colors.textBlack, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
