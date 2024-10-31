import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import 'package:igls_new/data/services/navigator/route_path.dart' as routes;

import '../../../widgets/app_bar_custom.dart';

class WebViewCheckListView extends StatefulWidget {
  const WebViewCheckListView(
      {super.key, required this.url, required this.title});
  final String url;
  final String title;
  @override
  State<WebViewCheckListView> createState() => _WebViewCheckListViewState();
}

class _WebViewCheckListViewState extends State<WebViewCheckListView> {
  InAppWebViewController? webView;
  String url = "";

  double progress = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _back(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routes.toDoTripRoute);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async => _back(context),
      // onPopInvokedWithResult: (didPop, result) => _back(context),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: Column(
          children: [
            Container(
                child: progress < 1.0
                    ? Column(
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            color: colors.defaultColor,
                          ),
                        ],
                      )
                    : Container()),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url:  Uri.parse(widget.url)),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url?.toString() ?? '';
                  });
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    this.url = url?.toString() ?? '';
                  });
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future getImage({required String tripNo}) async {
  //   var status = await Permission.camera.status;
  //   if (status.isGranted) {
  //     XFile? pickedFile = await ImagePicker().pickImage(
  //         source: ImageSource.camera,
  //         imageQuality: 100,
  //         maxHeight: 100000,
  //         maxWidth: 100000);
  //     if (pickedFile != null) {
  //       List<XFile> files = [];
  //       files.add(pickedFile);

  //       _navigationService.pushNamed(routes.displayPictureRoute, args: {
  //         key_params.pictureFile: files,
  //         key_params.refNoValue: tripNo,
  //         key_params.refNoType: "",
  //         key_params.docRefType: "",
  //       });
  //     }
  //   } else {
  //     openAppSettings();
  //   }
  // }
}
