import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class CardItemDropdownWidget extends StatelessWidget {
  const CardItemDropdownWidget(
      {super.key, required this.child, this.borderRadius});
  final Widget child;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: colors.bgDrawerColor,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: child,
        ));
  }
}
