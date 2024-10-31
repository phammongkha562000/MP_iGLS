import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class LayoutCommon {
  static EdgeInsets spaceBottomView = EdgeInsets.only(bottom: 40.h);
  static Divider divider = Divider(
    color: colors.defaultColor,
    thickness: 3.h,
    indent: 12.w,
    endIndent: 12.w,
  );
}
