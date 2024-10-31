import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:igls_new/presentations/common/assets.dart' as assets;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/export_widget.dart';

class StatusDialogWidget extends StatelessWidget {
  const StatusDialogWidget({
    super.key,
    required this.text,
    required this.status,
  });

  final String text;
  final bool status;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -30,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: status ? colors.textGreen : colors.textRed,
              child: IconCustom(
                  iConURL: status ? assets.kSuccessDialog : assets.kErrorDialog,
                  size: 50),
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            height: MediaQuery.sizeOf(context).height * 0.28,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  text.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: colors.textDarkBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
