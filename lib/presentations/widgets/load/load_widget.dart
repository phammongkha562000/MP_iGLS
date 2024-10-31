import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class SpinKitLoading extends StatelessWidget {
  const SpinKitLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SpinKitWave(
      color: colors.defaultColor,
      size: 40.0,
    ));
  }
}
