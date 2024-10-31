import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;

class ButtonTimeLine extends StatelessWidget {
  const ButtonTimeLine({
    super.key,
    required this.isEnable,
    this.onPressed,
    required this.text,
  });
  final bool isEnable;
  final VoidCallback? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: isEnable
          ? ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r))),
                  elevation: MaterialStateProperty.all(3),
                  backgroundColor: MaterialStateProperty.all(colors.btnGreen),
                  shadowColor: MaterialStateProperty.all(colors.defaultColor),
                  minimumSize: MaterialStateProperty.all(Size(220.w, 30))),
              onPressed: onPressed,
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            )
          : Center(
              child: Text(
                text.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
