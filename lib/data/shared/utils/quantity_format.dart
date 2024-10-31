import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:igls_new/data/shared/utils/number_forrmatter.dart';

class QuantityInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    log(oldValue.toString());

    final String intStr = NumberFormatter.numberFormatter(
        double.tryParse(newValue.text.replaceAll(",", "")) ?? 0);
    log(newValue.toString());

    return TextEditingValue(
      text: intStr,
      selection: TextSelection.collapsed(offset: intStr.length),
    );
  }
}
