import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class ExpansionTileWidget extends StatelessWidget {
  const ExpansionTileWidget(
      {super.key, required this.listWidget, this.initiallyExpanded});
  final List<Widget> listWidget;
  final bool? initiallyExpanded;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: ExpansionTile(
              initiallyExpanded: initiallyExpanded ?? false,
              collapsedTextColor: colors.defaultColor,
              iconColor: colors.defaultColor,
              textColor: colors.defaultColor,
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r),
              ),
              title: Text(
                '36'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(children: listWidget))
              ])),
    );
  }
}
