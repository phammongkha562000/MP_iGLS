import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class CellTableWidget extends StatelessWidget {
  const CellTableWidget(
      {super.key,
      required this.width,
      required this.content,
      this.isAlignLeft,
      this.isHighlight,
      this.color,
      this.colorHightLight});
  final double width;
  final String content;
  final bool? isAlignLeft;
  final Color? color;
  final Color? colorHightLight;
  final bool? isHighlight;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        height: 50,
        decoration: BoxDecoration(
          border: Border(
              right: BorderSide(
            color: color ?? colors.defaultColor,
          )),
        ),
        alignment:
            isAlignLeft ?? false ? Alignment.centerLeft : Alignment.center,
        width: width,
        child: Text(
          content,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: isHighlight ?? false
                  ? colorHightLight ?? Colors.red
                  : Colors.black,
              fontWeight:
                  isHighlight ?? false ? FontWeight.bold : FontWeight.normal),
        ));
  }
}
