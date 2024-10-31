import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:igls_new/data/shared/global/global_contact_format.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:money_formatter/money_formatter.dart';

class NumberFormatter {
  static NumberFormat formatter = NumberFormat("#,###.##");

  static String numberFormatter(double value) {
    return formatter.format(value);
  }

  static NumberFormat _getFormatFromGlobalContactFormat() {
    switch (globalContactFormat.getFormat) {
      case "N1":
        return NumberFormat("###,###,###,##0.0", "en_US");
      case "N2":
        return NumberFormat("###,###,###,##0.00", "en_US");
      case "N3":
        return NumberFormat("###,###,###,##0.000", "en_US");
      case "N4":
        return NumberFormat("###,###,###,##0.0000", "en_US");
      case "N5":
        return NumberFormat("###,###,###,##0.00000", "en_US");
      default:
        return NumberFormat("###,###,###,##0", "en_US");
    }
  }

  static NumberFormat formatTotalQty = _getFormatFromGlobalContactFormat();

  static String numberFormatTotalQty(double value) {
    return formatTotalQty.format(value);
  }

  static CurrencyTextInputFormatter formatMoney =
      CurrencyTextInputFormatter.currency(
    locale: "en",
    decimalDigits: 0,
    symbol: "",
  );

  static String moneyFormatView(double value) {
    MoneyFormatter convertMoney = MoneyFormatter(amount: value);
    return convertMoney.output.withoutFractionDigits;
  }

  static MaskTextInputFormatter formatTrailerNo = MaskTextInputFormatter(
    mask: '51R@@@@@',
    filter: {"@": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  static NumberFormat formatABC = NumberFormat("###,###,###,###", "en_US");
  static String formatThousand(dynamic value) {
    return formatABC.format(value);
  }
}
