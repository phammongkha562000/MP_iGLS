import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class CellTableNoDataWidget extends StatefulWidget {
  const CellTableNoDataWidget({
    super.key,
    required this.width,
  });
  final double width;

  @override
  State<CellTableNoDataWidget> createState() => _CellTableNoDataMaterialState();
}

class _CellTableNoDataMaterialState extends State<CellTableNoDataWidget> {
  bool? isAlignLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
          color: colors.defaultColor.withOpacity(0.5),
        ))),
        width: widget.width,
        child: Text(
          '5058'.tr().toUpperCase(),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: colors.btnGreyDisable),
        ));
  }
}
