import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;

class ErrorToast extends StatelessWidget {
  const ErrorToast({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
      child: Container(
        height: 65,
        width: double.infinity,
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                assets.toastError,
                color: colors.textWhite,
                height: 40,
                width: 40,
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "2349".tr(),
                      style: const TextStyle(
                        color: colors.textWhite,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      error.tr(),
                      style: const TextStyle(
                        color: colors.textWhite,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
