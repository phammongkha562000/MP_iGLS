import 'package:igls_new/presentations/common/assets.dart' as assets;

enum Languages {
  vi('vi', assets.vi),
  en('en', assets.en);

  final String languageCode;
  final String languageFlag;
  const Languages(this.languageCode, this.languageFlag);
}
