import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class HeaderTable2Widget extends StatelessWidget {
  const HeaderTable2Widget({
    super.key,
    required this.label,
    required this.width,
    this.isCustomer,
  });
  final String label;
  final double width;
  final bool? isCustomer;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isCustomer ?? false ? colors.darkLiver : colors.defaultColor,
      height: 56,
      width: width,
      alignment: Alignment.center,
      child: Text(label.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
