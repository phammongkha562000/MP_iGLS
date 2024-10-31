import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class TextRichRequired extends StatelessWidget {
  const TextRichRequired({super.key, required this.label, this.colorText});
  final String label;
  final Color? colorText;
  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      TextSpan(
          text: label.tr(),
          style: TextStyle(
              color: colorText ?? Colors.black, fontWeight: FontWeight.bold)),
      const TextSpan(
          text: ' *',
          style: TextStyle(color: colors.textRed, fontWeight: FontWeight.bold)),
    ]));
  }
}
