import 'package:igls_new/data/services/navigator/import_generate.dart';

String? validateEmail(String value) {
  if (value.isEmpty) {
    return '5067'.tr();
  }
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return '2427'.tr();
  }
  return null;
}
