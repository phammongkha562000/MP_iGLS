import 'package:easy_localization/easy_localization.dart';

class NumberFormatter {
  static NumberFormat formatter = NumberFormat("#,###.##");

  static String numberFormatter(double value) {
    return formatter.format(value);
  }
}
