import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:igls_new/data/models/customer/home/os_get_today_respone.dart';

class ReportBoardWidget extends StatefulWidget {
  const ReportBoardWidget({super.key, required this.dataReport});
  final OsTodayRes dataReport;
  @override
  State<ReportBoardWidget> createState() => _ReportBoardMaterialState();
}

class _ReportBoardMaterialState extends State<ReportBoardWidget> {
  @override
  Widget build(BuildContext context) {
    OSGetTodayResult oSTodayResult =
        widget.dataReport.oSGetTodayResult ?? OSGetTodayResult();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SizedBox(
        height: 150,
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          children: [
            dataToday(
                title: "245",
                per: null,
                value1: null,
                value2: null,
                color: const Color(0xff00c0ef)),
            dataToday(
              title: "246",
              per:
                  double.parse(oSTodayResult.table10?[0].pER.toString() ?? '0'),
              value1: oSTodayResult.table10?[0].oORDQTY,
              value2: oSTodayResult.table10?[0].gIQTY,
              color: const Color(0xff00a65a),
            ),
            dataToday(
                title: "247",
                per: double.parse(
                    oSTodayResult.table11?[0].pER.toString() ?? '0'),
                value1: oSTodayResult.table11?[0].uSEDQTY,
                value2: oSTodayResult.table11?[0].aLLQTY,
                color: const Color(0xfff39c12)),
            dataToday(
                title: "249",
                per: double.parse(
                    oSTodayResult.table14?[0].pER.toString() ?? '0'),
                value1: oSTodayResult.table14?[0].tORDQTY,
                value2: oSTodayResult.table14?[0].cOMPLETEQTY,
                color: const Color(0xffdd4b39)),
            dataToday(
                title: "5373",
                per: null,
                value1: null,
                value2: null,
                color: const Color(0xff00c0ef)),
            dataToday(
              title: "5374",
              per: null,
              value1: null,
              value2: null,
              color: const Color(0xff00a65a),
            ),
            dataToday(
                title: "5375",
                per: 2,
                value1: null,
                value2: null,
                color: const Color(0xfff39c12)),
          ],
        ),
      ),
    );
  }

  Widget dataToday(
          {required String title,
          required double? per,
          required int? value1,
          required int? value2,
          required Color color}) =>
      Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(16),
        width: 130,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${value1 ?? 0} / ${value2 ?? 0}",
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  per != null ? "$per%" : "0%",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
}
