import 'package:igls_new/presentations/common/constants.dart' as constants;
import 'package:igls_new/presentations/common/strings.dart' as strings;

class WorkingStatusTrailer {
  const WorkingStatusTrailer._(this._code);

  final String _code;
  String get code => _code;

  static const WorkingStatusTrailer undefined = WorkingStatusTrailer._('');
  static const WorkingStatusTrailer normal =
      WorkingStatusTrailer._(constants.traillerNORL);
  static const WorkingStatusTrailer notWorking =
      WorkingStatusTrailer._(constants.traillerNOTW);
  static const WorkingStatusTrailer forRent =
      WorkingStatusTrailer._(constants.traillerFORRENT);

  factory WorkingStatusTrailer.from(String code) {
    switch (code) {
      case constants.traillerNORL:
        return normal;
      case constants.traillerNOTW:
        return notWorking;
      case constants.traillerFORRENT:
        return forRent;
      default:
        return undefined;
    }
  }

  @override
  String toString() {
    switch (_code) {
      case constants.traillerNORL:
        return constants.traillerNormal;
      case constants.traillerNOTW:
        return constants.traillerNotWorking;
      case constants.traillerFORRENT:
        return constants.traillerForRent;
      default:
        return strings.unknown;
    }
  }
}
