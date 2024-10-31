import 'package:flutter/material.dart';
import 'package:igls_new/presentations/widgets/spacer_width.dart';

class RowFlex5and5 extends StatelessWidget {
  const RowFlex5and5({
    super.key,
    required this.left,
    required this.right,
    this.crossAxisAlignment,
    this.spacer,
    this.widthSpacer,
  });

  final Widget left;
  final Widget right;

  final double? widthSpacer;
  final bool? spacer;

  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: left,
        ),
        spacer == true
            ? WidthSpacer(width: widthSpacer ?? 0.02)
            : const SizedBox(),
        Expanded(
          flex: 5,
          child: right,
        ),
      ],
    );
  }
}
