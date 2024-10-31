import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class ItemLoading extends StatelessWidget {
  const ItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Opacity(
          opacity: 0.1,
          child: ModalBarrier(dismissible: false, color: Colors.white),
        ),
        Center(
            child: SpinKitWave(
          color: colors.defaultColor,
          size: 40.0,
        ))
      ],
    );
  }
}
