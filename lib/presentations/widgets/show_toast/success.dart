import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/export_common.dart';

class SuccessToast extends StatelessWidget {
  const SuccessToast({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 38, 170, 106),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                assets.toastSuccess,
                color: colors.textWhite,
                height: 40,
                width: 40,
              ),
            ),
            Expanded(
              flex: 8,
              child: Text(
                "2348".tr(),
                style: const TextStyle(
                  color: colors.textWhite,
                  fontSize: sizeTextDefault,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
