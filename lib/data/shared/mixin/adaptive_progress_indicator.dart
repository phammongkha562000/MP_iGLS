import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({
    super.key,
    this.strokeWidth,
  });

  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return (Platform.isAndroid)
        ? CircularProgressIndicator(strokeWidth: strokeWidth ?? 4)
        : const CupertinoActivityIndicator();
  }
}
