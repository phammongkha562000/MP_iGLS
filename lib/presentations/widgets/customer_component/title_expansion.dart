import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleExpansionWidget extends StatelessWidget {
  const TitleExpansionWidget(
      {super.key, required this.text, this.asset, this.color});
  final String text;
  final Icon? asset;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...asset != null
            ? [
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: asset!,
                )
              ]
            : [],
        color != null
            ? Flexible(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                      color: color ?? Colors.transparent,
                      borderRadius: BorderRadius.circular(32.r)),
                  child: Text(
                    text.tr(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color != null ? Colors.white : Colors.black),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                child: Text(text.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              )
      ],
    );
  }
}
