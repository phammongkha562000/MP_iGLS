import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

import '../../../../businesses_logics/bloc/forgot_password/forgot_password_bloc.dart';

class WebViewForgotPasswordView extends StatefulWidget {
  final String username;
  final int tabMode;
  const WebViewForgotPasswordView({
    super.key,
    required this.username,
    required this.tabMode,
  });

  @override
  State<WebViewForgotPasswordView> createState() =>
      _WebViewForgotPasswordViewState();
}

class _WebViewForgotPasswordViewState extends State<WebViewForgotPasswordView> {
  InAppWebViewController? webView;
  String url = "";

  double progress = 0;

  late ForgotPasswordBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<ForgotPasswordBloc>(context);
    _bloc.add(ForgotPasswordViewLoaded(
        username: widget.username, tabMode: widget.tabMode));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: Text('5450'.tr())),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ForgotPasswordSuccess) {
            url = state.url;
            log(url);
            return Column(
              children: [
                Container(
                    child: progress < 1.0
                        ? Column(
                            children: [
                              LinearProgressIndicator(
                                value: progress,
                                color: colors.darkLiver,
                              ),
                              Text(
                                "${"5042".tr()} ${progress * 100}"
                                "%",
                              ),
                            ],
                          )
                        : Container()),
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url:  Uri.parse(url)),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onReceivedServerTrustAuthRequest:
                        (controller, challenge) async {
                      return ServerTrustAuthResponse(
                          action: ServerTrustAuthResponseAction.PROCEED);
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
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
