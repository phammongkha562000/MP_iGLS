import 'package:flutter/material.dart';

import 'package:igls_new/presentations/common/colors.dart' as colors;

class TableNoDataWidget extends StatefulWidget {
  const TableNoDataWidget({
    super.key,
    required this.listTableRow,
    this.color,
  });
  final List<TableRow> listTableRow;
  final Color? color;
  @override
  State<TableNoDataWidget> createState() => _TableNoDataMaterialState();
}

class _TableNoDataMaterialState extends State<TableNoDataWidget> {
  final _verticalScrollController1 = ScrollController();
  final _horizontalScrollController1 = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _verticalScrollController1,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalScrollController1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                          border: TableBorder.symmetric(
                            outside: BorderSide(
                                color: widget.color ?? colors.defaultColor,
                                style: BorderStyle.solid),
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: widget.listTableRow)
                    ]))),
      ),
    );
  }
}
