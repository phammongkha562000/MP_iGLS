import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:igls_new/presentations/common/export_common.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key, required this.version}) ;

  final String version;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${"All right reserved 2022 - MP Logistics".tr()} $version",
            style: styleBottom(),
          ),
        ],
      ),
    );
  }

  TextStyle styleBottom() {
    return const TextStyle(
      fontStyle: FontStyle.italic,
      color: defaultColor,
    );
  }
}
