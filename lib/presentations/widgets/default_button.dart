// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget(
      {super.key,
      this.borderRadius,
      this.text,
      this.textStyle,
      this.onPressed,
      this.fontSize,
      this.backgroundColor,
      this.width,
      this.height,
      this.child,
      this.isPadding,
      this.isPaddingBottom,
      this.isShadow,
      this.isDisabled = false});

  final double? borderRadius;
  final String? text;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final double? fontSize;
  final Color? backgroundColor;
  final Widget? child;
  final bool? isPadding;
  final bool? isShadow;
  final bool? isPaddingBottom;
  final bool? isDisabled;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          margin: isPadding ?? true
              ? EdgeInsets.fromLTRB(
                  45.w, 0, 45.w, isPaddingBottom ?? false ? 36.h : 16.h)
              : EdgeInsets.zero,
          height: height ?? MediaQuery.sizeOf(context).height * 0.06,
          width: width != null
              ? MediaQuery.sizeOf(context).width * width!
              : MediaQuery.sizeOf(context).width * 1,
          decoration: BoxDecoration(
              color: backgroundColor,
              gradient: isDisabled == true
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[colors.textGrey, Colors.white])
                  : backgroundColor != null
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                              colors.defaultColor,
                              Colors.blue.shade100
                            ]),
              borderRadius: BorderRadius.circular(borderRadius ?? 32.r),
              boxShadow: isShadow == false
                  ? null
                  : const [
                      BoxShadow(
                          color: colors.textGrey,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4, 4))
                    ]),
          alignment: Alignment.center,
          child: text != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(text!.tr(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: fontSize ?? 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                )
              : child),
    );
  }
}
