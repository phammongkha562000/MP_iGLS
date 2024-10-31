import 'package:flutter/material.dart';

import 'package:igls_new/presentations/common/assets.dart' as assets;

class AvtCustom extends StatelessWidget {
  final double? size;
  const AvtCustom({
    super.key,
    this.size,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      shape: const CircleBorder(),
      child: CircleAvatar(
          radius: size ?? 50.0, child: Image.asset(assets.avtUser)),
    );
  }
}
