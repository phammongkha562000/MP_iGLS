import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class HeaderTableWidget extends StatelessWidget {
  const HeaderTableWidget(
      {super.key, required this.headerText,  this.color});
  final String headerText;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 56,
      color: color ?? colors.defaultColor,
      child: Text(
        headerText.tr(),
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}
