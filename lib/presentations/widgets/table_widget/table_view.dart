import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/widgets/empty.dart';
import 'package:igls_new/presentations/widgets/header_table.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class TableView extends StatefulWidget {
  const TableView(
      {super.key,
      required this.headerChildren,
      required this.rowChildren,
      this.tableColumnWidth,
      this.columnWidths});
  final List<String> headerChildren;
  final List<TableRow> rowChildren;
  final TableColumnWidth? tableColumnWidth;
  final Map<int, TableColumnWidth>? columnWidths;
  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: widget.rowChildren == [] || widget.rowChildren.isEmpty
                  ? TableBorder.symmetric(
                      outside: const BorderSide(
                        color: colors.defaultColor,
                      ),
                    )
                  : TableBorder.all(
                      color: colors.defaultColor.withOpacity(0.5),
                    ),
              columnWidths: widget.columnWidths,
              defaultColumnWidth:
                  widget.tableColumnWidth ?? const IntrinsicColumnWidth(),
              children: [
                TableRow(
                    children: List.generate(
                        widget.headerChildren.length,
                        (index) => HeaderTableWidget(
                              headerText: widget.headerChildren[index],
                            ))),
                ...widget.rowChildren
              ],
            ),
          ),
          widget.rowChildren == [] || widget.rowChildren.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: colors.defaultColor)),
                  height: 200.h,
                  child: const EmptyWidget())
              : const SizedBox()
        ],
      ),
    );
  }
}
