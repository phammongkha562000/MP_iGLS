import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/colors.dart';

class CardCustom extends StatelessWidget {
  const CardCustom(
      {super.key,
      this.child,
      this.padding,
      this.color,
      this.margin,
      this.elevation,
      this.radius});

  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.03),
      elevation: elevation ?? 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular((radius ?? 24).r),
      ),
      color: color ?? bgDrawerColor,
      child: Padding(
        padding:
            padding ?? EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.03),
        child: child,
      ),
    );
  }
}
