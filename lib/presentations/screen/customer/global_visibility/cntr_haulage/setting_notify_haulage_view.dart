import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/businesses_logics/bloc/customer/global_visibility/cntr_haulage/cntr_haulage_detail/cntr_haulage_detail_bloc.dart';
import 'package:igls_new/presentations/widgets/components/validate_form_field.dart';

import '../../../../../businesses_logics/bloc/customer/customer_bloc/customer_bloc.dart';
import '../../../../../data/models/customer/contract_logistics/inbound_order_status/get_std_code_res.dart';
import '../../../../../data/models/customer/global_visibility/cntr_haulage/save_notify_setting_req.dart';
import '../../../../common/styles.dart';
import '../../../../widgets/app_bar_custom.dart';
import '../../../../widgets/customer_component/customer_dropdown/std_code_dropdown.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/dialog/custom_dialog.dart';
import '../../../../widgets/load/load_list.dart';

class SettingNotifyHaulageView extends StatefulWidget {
  const SettingNotifyHaulageView(
      {super.key,
      required this.woNo,
      required this.itemNo,
      required this.isSubscribed,
      required this.receiver});
  final String woNo;
  final int itemNo;
  final bool isSubscribed;
  final TextEditingController receiver;
  @override
  State<SettingNotifyHaulageView> createState() =>
      _SettingNotifyHaulageViewState();
}

class _SettingNotifyHaulageViewState extends State<SettingNotifyHaulageView> {
  ValueNotifier<List<GetStdCodeRes>> lstOrdStatus = ValueNotifier([]);
  GetStdCodeRes? messTypeSelected;
  late CustomerBloc customerBloc;
  late CntrHaulageDetailBloc cntrHaulageDetailBloc;
  ValueNotifier<bool> isChecked = ValueNotifier(false);
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    customerBloc = BlocProvider.of<CustomerBloc>(context);
    cntrHaulageDetailBloc = BlocProvider.of<CntrHaulageDetailBloc>(context)
      ..add(GetStdCodeNotify(
          subsidiaryId:
              customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Form(
          key: _formkey,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBarCustom(
              title: Text('5293'.tr()),
            ),
            body: BlocConsumer<CntrHaulageDetailBloc, CntrHaulageDetailState>(
              listener: (context, state) {
                if (state is UpdateNotifySettingFail) {
                  CustomDialog().error(context, err: state.message);
                }

                if (state is UpdateNotifySettingSuccess) {
                  CustomDialog()
                      .success(context)
                      .whenComplete(() => Navigator.pop(context, true));
                }
                if (state is GetStdCodeSuccess) {
                  lstOrdStatus.value = state.stdCodeRes;
                  messTypeSelected = state.stdCodeRes[0];
                }
                if (state is GetStdCodeFail) {
                  CustomDialog().error(context,
                      err: state.message,
                      btnOkOnPress: () => Navigator.pop(context));
                }
              },
              builder: (context, state) {
                if (state is DetailShowLoadingState) {
                  return const Center(child: ItemLoading());
                }
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.h, horizontal: 8.w),
                  child: Column(children: [
                    ValueListenableBuilder(
                      valueListenable: lstOrdStatus,
                      builder: (context, value, child) {
                        return CustomerSTDCodeDropdown(
                            value: value.isNotEmpty
                                ? messTypeSelected ?? value[0]
                                : GetStdCodeRes(),
                            onChanged: (p0) {
                              messTypeSelected = p0 as GetStdCodeRes;
                            },
                            label: "5294".tr(),
                            listSTD: value);
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    TextFormField(
                      validator: (value) => validateEmail(value ?? ''),
                      controller: widget.receiver,
                      decoration: InputDecoration(
                        label: Text("5296".tr()),
                      ),
                    ),
                    widget.isSubscribed != true
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: ValueListenableBuilder(
                                valueListenable: isChecked,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text("5480".tr()),
                                    value: value,
                                    onChanged: (value) {
                                      isChecked.value = value!;
                                    },
                                  );
                                }),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        children: [
                          widget.isSubscribed == true
                              ? Expanded(
                                  child: ElevatedButtonWidget(
                                  text: '24',
                                  onPressed: () {
                                    showDialogConfirm();
                                  },
                                ))
                              : const SizedBox(),
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: isChecked,
                                builder: (context, value, child) {
                                  return ElevatedButtonWidget(
                                    isDisabled: widget.isSubscribed == true
                                        ? false
                                        : !value,
                                    text: '37',
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        widget.isSubscribed == true
                                            ? saveNotifySetting()
                                            : value == true
                                                ? saveNotifySetting()
                                                : null;
                                      }
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  ]),
                );
              },
            ),
          ),
        ));
  }

  saveNotifySetting() {
    cntrHaulageDetailBloc.add(SaveNotifySettingEvent(
        model: SaveNotifySettingReq(
            wONo: widget.woNo,
            itemNo: widget.itemNo,
            notes: "",
            receiver: widget.receiver.text,
            userId: customerBloc.userLoginRes?.userInfo?.userId ?? '',
            messageType: messTypeSelected?.codeID ?? ''),
        subsidiaryId: customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? ''));
  }

  showDialogConfirm() {
    AwesomeDialog(
        padding: EdgeInsets.all(8.w),
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.rightSlide,
        dismissOnTouchOutside: false,
        btnOkText: "5301".tr(),
        btnCancelText: "26".tr(),
        autoDismiss: false,
        onDismissCallback: (type) {},
        body: Text(
          "5302".tr(),
          style: styleTextTitle,
        ),
        btnCancelOnPress: () {
          Navigator.of(context).pop();
        },
        btnOkOnPress: () {
          Navigator.of(context).pop();
          cntrHaulageDetailBloc.add(DelNotifySettingEvent(
              customerBloc: customerBloc,
              subsidiaryId:
                  customerBloc.userLoginRes?.userInfo?.subsidiaryId ?? '',
              woNo: widget.woNo,
              userId: customerBloc.userLoginRes?.userInfo?.userId ?? '',
              itemNo: widget.itemNo));
        }).show();
  }
}
