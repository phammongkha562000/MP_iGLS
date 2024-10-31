import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/strings.dart' as strings;

class RangeDateSearch {
  const RangeDateSearch._(this._code);

  final int _code;
  int get code => _code;

  static const RangeDateSearch undefined = RangeDateSearch._(0);
  static const RangeDateSearch today = RangeDateSearch._(1);
  static const RangeDateSearch sevenDay = RangeDateSearch._(2);
  static const RangeDateSearch thirtyDay = RangeDateSearch._(3);
  static const RangeDateSearch ninetyDay = RangeDateSearch._(4);
  static const RangeDateSearch frv = RangeDateSearch._(5);
  static const List<RangeDateSearch> values = [
    today,
    sevenDay,
    thirtyDay,
    ninetyDay,
    // frv
  ];

  factory RangeDateSearch.from(int code) {
    switch (code) {
      case 1:
        return today;
      case 2:
        return sevenDay;
      case 3:
        return thirtyDay;
      case 4:
        return ninetyDay;
      case 5:
        return frv;
      default:
        return undefined;
    }
  }

  @override
  String toString() {
    switch (_code) {
      case 1:
        return constants.rd1Day;
      case 2:
        return constants.rd7Day;
      case 3:
        return constants.rd30Day;
      case 4:
        return constants.rd90Day;
      case 5:
        return constants.rdFRV;
      default:
        return strings.unknown;
    }
  }

  static int rangeDate({required int rangeDate}) {
    switch (rangeDate) {
      case 1:
        return 0;
      case 2:
        return 7;
      case 3:
        return 30;
      case 4:
        return 90;
      case 5:
        return 365;
      default:
        return 0;
    }
  }
}
