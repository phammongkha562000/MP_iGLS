import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../widgets/app_bar_custom.dart';

class WebViewPluginView extends StatefulWidget {
  const WebViewPluginView({super.key, required this.url, required this.title});
  final String url;
  final String title;
  @override
  State<WebViewPluginView> createState() => _WebViewPluginViewState();
}

class _WebViewPluginViewState extends State<WebViewPluginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(title: Text(widget.title)),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url:  Uri.parse(widget.url)),
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
        ));
  }
}
