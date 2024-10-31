import 'package:flutter/material.dart';

class IconCustom extends StatelessWidget {
  const IconCustom(
      {super.key, required this.iConURL, required this.size, this.color});
  final String iConURL;
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iConURL,
      width: size,
      height: size,
      color: color,
    );
  }
}
