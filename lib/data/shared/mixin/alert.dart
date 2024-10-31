import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import '../../../presentations/presentations.dart';

mixin Alert {
  void showLoadingDialog(
    BuildContext context, {
    bool barrierDismissible = false,
    String content = "LOADING...",
    TextStyle? style,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) => AlertDialog(
          content: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
              child: const LoadingNoBox()),
        ),
      );

  void showErrorDialog(
    BuildContext context, {
    bool barrierDismissible = false,
    String title = 'Thông tin',
    String content = 'Content',
    String buttonTitle = 'OK',
    VoidCallback? onButtonPressed,
    Widget? customBuilder,
  }) =>
      showPlatformDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) =>
            customBuilder ??
            PlatformAlertDialog(
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              content: Text(content),
              actions: <Widget>[
                PlatformDialogAction(
                  onPressed: onButtonPressed,
                  child: PlatformText(
                    buttonTitle,
                    style: const TextStyle(color: colors.defaultColor),
                  ),
                ),
              ],
            ),
      );

  void showInfoDialog(
    BuildContext context, {
    bool barrierDismissible = false,
    String title = 'Thông tin',
    String content = 'Content',
    String textButton = 'Ok',
    VoidCallback? onButtonPressed,
  }) =>
      showPlatformDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) => PlatformAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            PlatformDialogAction(
              onPressed: onButtonPressed,
              child: PlatformText(textButton,
                  style: const TextStyle(color: colors.defaultColor)),
            ),
          ],
        ),
      );

  void showConfirmDialog(
    BuildContext context, {
    bool barrierDismissible = false,
    String title = 'Xác Nhận',
    String content = 'Content',
    String yesText = 'Có',
    String noText = 'Không',
    VoidCallback? onYesButtonPressed,
    VoidCallback? onNoButtonPressed,
    TextStyle style = const TextStyle(color: colors.defaultColor),
  }) =>
      showPlatformDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) => PlatformAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            PlatformDialogAction(
              onPressed: onNoButtonPressed,
              child: PlatformText(
                noText,
                style: style,
              ),
            ),
            PlatformDialogAction(
              onPressed: onYesButtonPressed,
              child: PlatformText(
                yesText,
                style: style,
              ),
            )
          ],
        ),
      );

  void showCustomConfirmDialog(
    BuildContext context, {
    bool barrierDismissible = false,
    String title = 'Xác Nhận ',
    Widget content = const SizedBox.shrink(),
    String yesText = 'Có',
    String noText = 'Không',
    VoidCallback? onYesButtonPressed,
    VoidCallback? onNoButtonPressed,
  }) =>
      showPlatformDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) => PlatformAlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            PlatformDialogAction(
              onPressed: onNoButtonPressed,
              child: PlatformText(noText),
            ),
            PlatformDialogAction(
              onPressed: onYesButtonPressed,
              child: PlatformText(
                yesText,
                style: const TextStyle(color: colors.defaultColor),
              ),
            )
          ],
        ),
      );

  void showDeleteDialog(
    BuildContext context, {
    bool barrierDismissible = false,
    String title = 'Delete',
    String content = 'Content',
    String yesText = 'Delete',
    String noText = 'Cancel',
    VoidCallback? onYesButtonPressed,
    VoidCallback? onNoButtonPressed,
  }) =>
      showPlatformDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) => PlatformAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            PlatformDialogAction(
              cupertino: (_, __) =>
                  CupertinoDialogActionData(isDefaultAction: true),
              onPressed: onNoButtonPressed,
              child: PlatformText(noText),
            ),
            PlatformDialogAction(
              material: (_, __) => MaterialDialogActionData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
              cupertino: (_, __) =>
                  CupertinoDialogActionData(isDestructiveAction: true),
              onPressed: onYesButtonPressed,
              child: PlatformText(yesText),
            ),
          ],
        ),
      );
}
