import 'package:igls_new/presentations/common/strings.dart' as strings;

class TripType {
  const TripType._(this._code);

  final String _code;
  String get code => _code;

  static const TripType undefined = TripType._('');
  static const TripType normalTrip = TripType._(strings.normalTripType);
  static const TripType simpleTrip = TripType._(strings.simpleTripType);

  static const List<TripType> values = [
    normalTrip,
    simpleTrip,
  ];

  factory TripType.from(String code) {
    switch (code) {
      case strings.normalTripType:
        return normalTrip;
      case strings.simpleTripType:
        return simpleTrip;

      default:
        return undefined;
    }
  }

  factory TripType.fromString(String tripType) {
    switch (tripType) {
      case strings.normalTripType:
        return normalTrip;
      case strings.simpleTripType:
        return simpleTrip;

      default:
        return undefined;
    }
  }

  @override
  String toString() {
    switch (_code) {
      case strings.normalTripType:
        return strings.normalTripType;
      case strings.simpleTripType:
        return strings.simpleTripType;

      default:
        return strings.unknown;
    }
  }
}
