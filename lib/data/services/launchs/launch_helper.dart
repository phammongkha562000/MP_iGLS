import 'package:url_launcher/url_launcher.dart';

class LaunchHelpers {
  static void launchTel({required String tel}) =>
      launchUrl(Uri(scheme: 'tel', path: tel));

  static void launchWebsite({required String website}) => launchUrl(
        Uri.parse(website),
        mode: LaunchMode.inAppWebView,
      );
}
