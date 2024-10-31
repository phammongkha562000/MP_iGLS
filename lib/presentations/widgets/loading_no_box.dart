import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/presentations.dart';

class LoadingNoBox extends StatelessWidget {
  const LoadingNoBox({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconCustom(
              iConURL: "assets/icons/loading.gif",
              size: MediaQuery.sizeOf(context).height * 0.1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "5042".tr(),
                style: styleTextTitle,
              ),
              const WidthSpacer(width: 0.02),
              const SpinKitThreeInOut(
                color: colors.defaultColor,
                size: 15,
              )
            ],
          ),
          const HeightSpacer(height: 0.02)
        ],
      ),
    );
  }
}
