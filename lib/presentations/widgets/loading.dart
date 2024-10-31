import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../common/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          color: const Color.fromARGB(162, 245, 244, 242),
        ),
        width: MediaQuery.sizeOf(context).width * 0.6,
        height: MediaQuery.sizeOf(context).width * 0.3,
        child: Row(
          children: [
            const Expanded(
              flex: 5,
              child: SpinKitCircle(
                color: defaultColor,
                size: 80.0,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                "${'5042'.tr()} . . .",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
