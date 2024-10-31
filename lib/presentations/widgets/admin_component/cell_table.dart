import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class CellTableWidget extends StatelessWidget {
  const CellTableWidget(
      {super.key,
      required this.width,
      required this.content,
      this.isAlignLeft,
      this.isBold,
      this.onTap});
  final double width;
  final String content;
  final bool? isAlignLeft;
  final bool? isBold;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          decoration: BoxDecoration(
              border: Border(
                  right:
                      BorderSide(color: colors.defaultColor.withOpacity(0.5)))),
          alignment:
              isAlignLeft ?? false ? Alignment.centerLeft : Alignment.center,
          width: width,
          child: Text(content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: onTap != null ? colors.defaultColor : Colors.black,
                  fontStyle:
                      onTap != null ? FontStyle.italic : FontStyle.normal,
                  fontWeight:
                      isBold ?? false ? FontWeight.bold : FontWeight.normal))),
    );
  }
}
