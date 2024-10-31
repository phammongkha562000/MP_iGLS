// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_is_empty

import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:igls_new/data/shared/utils/format_number.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    log(oldValue.toString());

    if (newValue != null && newValue.text.length > 0) {
      final String intStr = NumberFormatter.numberFormatter(
          double.tryParse(newValue.text.replaceAll(",", ""))!);
      log(newValue.toString());

      return TextEditingValue(
        text: intStr,
        selection: TextSelection.collapsed(offset: intStr.length),
      );
    } else {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }
  }
}
