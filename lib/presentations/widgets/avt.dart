import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/services/extension/extensions.dart';
import 'package:igls_new/data/shared/global/global_user.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/assets.dart' as assets;

class Avt extends StatelessWidget {
  const Avt({
    super.key,
    required this.companyName,
    required this.avt,
  });
  final String companyName;
  final String avt;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            height: size.height * 0.12,
            width: size.height * 0.12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(64.r),
              child: avt != ''
                  ? Image.network(
                      '${constants.urlMPI}$avt',
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(assets.avtUser);
                      },
                    )
                  : Image.asset(assets.avtUser),
            )),
        Text(
          globalUser.getFullname.toString(),
          style: const TextStyle(
            fontSize: 18,
            color: colors.defaultColor,
            fontWeight: FontWeight.bold,
          ),
        ).paddingSymmetric(vertical: size.height * 0.02),
        Text(companyName.toUpperCase())
      ],
    ).paddingAll(size.width * 0.02);
  }
}
