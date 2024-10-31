import 'package:igls_new/presentations/common/strings.dart' as strings;

class TradeType {
  const TradeType._(this._code);

  final String _code;
  String get code => _code;

  static const TradeType undefined = TradeType._('');
  static const TradeType exportTradeType = TradeType._(strings.exportTradeType);
  static const TradeType importTradeType = TradeType._(strings.importTradeType);

  static const List<TradeType> values = [
    exportTradeType,
    importTradeType,
  ];

  factory TradeType.from(String code) {
    switch (code) {
      case 'E':
        return exportTradeType;
      case 'I':
        return importTradeType;

      default:
        return undefined;
    }
  }

  factory TradeType.fromString(String tradeType) {
    switch (tradeType) {
      case strings.exportTradeType:
        return exportTradeType;
      case strings.importTradeType:
        return importTradeType;

      default:
        return undefined;
    }
  }

  @override
  String toString() {
    switch (_code) {
      case strings.exportTradeType:
        return strings.exportTradeType;
      case strings.importTradeType:
        return strings.importTradeType;

      default:
        return strings.unknown;
    }
  }
}
