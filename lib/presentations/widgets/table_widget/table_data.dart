import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;

class TableDataWidget extends StatefulWidget {
  const TableDataWidget(
      {super.key,
      required this.listTableRowHeader,
      required this.listTableRowContent,
      this.color,
      this.isPaddingBot,
      this.verticalScrollController,
      this.horizontalScrollController});
  final List<Widget> listTableRowHeader;
  final List<Widget> listTableRowContent;
  final Color? color;
  final bool? isPaddingBot;
  final ScrollController? verticalScrollController;
  final ScrollController? horizontalScrollController;
  @override
  State<TableDataWidget> createState() => _TableDataMaterialState();
}

class _TableDataMaterialState extends State<TableDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Scrollbar(
          // thickness: 0,
          controller: widget.horizontalScrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.horizontalScrollController,
            child: Column(
              children: [
                Row(children: widget.listTableRowHeader),
                Expanded(
                  child: Scrollbar(
                    controller: widget.verticalScrollController,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          bottom: widget.isPaddingBot ?? true ? 40.h : 0),
                      scrollDirection: Axis.vertical,
                      controller: widget.verticalScrollController,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                  color: widget.color ?? colors.defaultColor,
                                ),
                                bottom: BorderSide(
                                  color: widget.color ?? colors.defaultColor,
                                )),
                          ),
                          child: Column(children: widget.listTableRowContent)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color colorRowTable({required int index, Color? color}) {
  return index % 2 != 0
      ? color ?? colors.defaultColor.withOpacity(0.1)
      : Colors.white.withOpacity(0.1);
}
