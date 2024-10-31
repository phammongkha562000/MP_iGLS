import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:igls_new/presentations/common/styles.dart' as styles;
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/widgets/custom_card.dart';
import 'package:igls_new/presentations/widgets/default_button.dart';

class CardCheckinCommon extends StatelessWidget {
  const CardCheckinCommon({
    super.key,
    this.onPressed,
    this.dateTimeCheckIn,
  });
  final void Function()? onPressed;
  final String? dateTimeCheckIn;
  @override
  Widget build(BuildContext context) {
    return CardCustom(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4673'.tr(),
                  style: styles.styleTextDefault,
                ),
                Text(
                  /*  '5045'.tr()  */ dateTimeCheckIn ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: ElevatedButtonWidget(
                isPadding: false,
                text: '5045',
                backgroundColor:
                    dateTimeCheckIn == '' || dateTimeCheckIn == null
                        ? null
                        : colors.btnGreyDisable,
                onPressed: dateTimeCheckIn == '' || dateTimeCheckIn == null
                    ? onPressed
                    : null),
          ),
        ],
      ),
    );
  }
}
