import 'package:flutter/material.dart';

import 'package:igls_new/presentations/common/export_common.dart';
import 'package:igls_new/presentations/common/assets.dart' as assets;

class HeaderMenu extends StatelessWidget {
  const HeaderMenu(
      {super.key,
      required this.name,
      this.isCustomerMode,
      required this.companyName});

  final String name;
  final bool? isCustomerMode;
  final String companyName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assets.kLayoutBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.05)),
            CircleAvatar(
              backgroundImage: AssetImage(isCustomerMode ?? false
                  ? assets.kIconLogoWP
                  : assets.kIconLogo),
              backgroundColor: Colors.transparent,
              maxRadius: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.01,
                  vertical: MediaQuery.sizeOf(context).height * 0.01),
              child: Text(
                companyName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: defaultColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              name,
              style: styleTextDefault,
            ),
          ],
        ),
      ),
    );
  }
}
