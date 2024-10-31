import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:igls_new/presentations/presentations.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;

class CustomDialog {
  Future showCustomDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(8)),
      width: 250,
      body: const LoadingNoBox(),
    ).show();
  }

  Future showCustomDialogAutoClose(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(8)),
      width: 250,
      body: const LoadingNoBox(),
      autoHide: const Duration(seconds: 3),
    ).show();
  }

  void hideCustomDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(8)),
      width: 250,
      body: const LoadingNoBox(),
    ).dismiss();
  }

  Future success(
    BuildContext context, {
    String? success,
    Function? ok,
    Function? cancel,
  }) {
    return AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      customHeader: const IconCustom(iConURL: assets.gifSuccess, size: 100),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            success == null || success == "" ? "2348".tr() : success.tr(),
            style: const TextStyle(
              color: colors.textBlack,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const HeightSpacer(height: 0.01)
        ],
      ),
      autoHide: const Duration(seconds: 2),
      btnOkColor: colors.defaultColor,
      btnOkOnPress: ok as void Function()?,
      btnCancelColor: colors.textRed,
      btnCancelOnPress: cancel as void Function()?,
    ).show();
  }

  Future warning(BuildContext context,
      {String? message,
      Function()? ok,
      Function()? cancel,
      VoidCallback? whenComplete,
      bool? isOk,
      bool? isCancel}) {
    return AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      customHeader: const IconCustom(iConURL: assets.gifWarning, size: 100),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message == null || message == "" ? "warning".tr() : message.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: colors.textBlack,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const HeightSpacer(height: 0.01)
        ],
      ),
      btnOkColor: colors.defaultColor,
      btnCancelText: '26'.tr(),
      btnOkText: isOk ?? true ? '4171'.tr() : null,
      btnCancelColor: colors.warningColor,
      btnCancelOnPress: isCancel ?? true ? cancel ?? () {} : null,
      btnOkOnPress: (isOk ?? true ? ok : null),
    ).show().whenComplete(whenComplete ?? () {});
  }

  Future error(BuildContext context,
      {String? err,
      Function? cancel,
      Function()? btnOkOnPress,
      String? btnMessage}) {
    return AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      customHeader: const IconCustom(iConURL: assets.gifError, size: 100),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "2359".tr(),
            style: const TextStyle(
              color: colors.textRed,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const HeightSpacer(height: 0.01),
          err == null || err == ""
              ? Container()
              : Text(
                  err.tr(),
                  style: styleTextError,
                  textAlign: TextAlign.center,
                ),
          const HeightSpacer(height: 0.01)
        ],
      ),
      btnOkText: btnMessage ?? '26'.tr(),
      btnOkColor: colors.textRed,
      btnOkOnPress: btnOkOnPress ?? () {},
    ).show();
  }
}

Future chooseServer(
  BuildContext context, {
  String? message,
}) {
  return AwesomeDialog(
    context: context,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    customHeader: const IconCustom(iConURL: assets.gifWarning, size: 100),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message == null || message == "" ? "warning".tr() : message.tr(),
          style: const TextStyle(
            color: colors.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const HeightSpacer(height: 0.01)
      ],
    ),
    btnOkColor: colors.defaultColor,
    btnCancelColor: colors.warningColor,
    btnCancelOnPress: () {},
  ).show();
}
