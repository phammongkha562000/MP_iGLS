import 'package:flutter/material.dart';

class RowFlex4and6 extends StatelessWidget {
  const RowFlex4and6({
    super.key,
    required this.child4,
    required this.child6,
  }) ;

  final Widget child4;
  final Widget child6;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: child4,
        ),
        Expanded(
          flex: 6,
          child: child6,
        ),
      ],
    );
  }
}
