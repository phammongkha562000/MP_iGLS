import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:igls_new/presentations/common/assets.dart' as assets;

import '../common/colors.dart';

class EmptyWidget extends StatelessWidget {
  final double? scale;
  const EmptyWidget({
    super.key,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assets.kIconEmpty,
            opacity: const AlwaysStoppedAnimation<double>(0.5),
            color: textGrey,
            scale: scale ?? 1,
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          Text(
            "5058".tr().toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(126, 100, 100, 100),
            ),
          )
        ],
      ),
    );
  }
}
