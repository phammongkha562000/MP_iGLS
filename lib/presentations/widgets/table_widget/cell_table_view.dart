import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class CellTableView extends StatelessWidget {
  const CellTableView({
    super.key,
    required this.text,
    this.isNoData,
    this.onTap,
    this.isBold,
  });
  final String text;
  final bool? isNoData;
  final VoidCallback? onTap;
  final bool? isBold;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: text.length > 50 ? 200 : null,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        child: Text(text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isBold ?? false ? FontWeight.bold : FontWeight.normal,
              fontStyle: onTap != null ? FontStyle.italic : FontStyle.normal,
              color: isNoData ?? false
                  ? colors.btnGreyDisable
                  : onTap != null
                      ? colors.defaultColor
                      : Colors.black,
            )),
      ),
    );
  }
}
