import 'package:flutter/material.dart';

class RowFlex333 extends StatelessWidget {
  const RowFlex333({
    super.key,
    this.child1,
    this.child2,
    this.child3,
  }) ;

  final Widget? child1;
  final Widget? child2;
  final Widget? child3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: child1 ?? Container(),
        ),
        Expanded(
          flex: 3,
          child: child2 ?? Container(),
        ),
        Expanded(
          flex: 3,
          child: child3 ?? Container(),
        ),
      ],
    );
  }
}
