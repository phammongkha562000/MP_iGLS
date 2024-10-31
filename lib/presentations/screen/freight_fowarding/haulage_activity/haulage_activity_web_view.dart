import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../widgets/app_bar_custom.dart';

class HaulageActivityWebWiew extends StatefulWidget {
  const HaulageActivityWebWiew({
    super.key,
    required this.url,
  });
  final String url;
  @override
  State<HaulageActivityWebWiew> createState() => _HaulageActivityWebWiewState();
}

class _HaulageActivityWebWiewState extends State<HaulageActivityWebWiew> {
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        appBar: AppBarCustom(
          title: Text('HaulageActivity'.tr()),
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        ));
  }
}
