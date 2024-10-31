import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key, required this.dataPieChart});
  final List<PieChartSectionData> dataPieChart;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: PieChart(PieChartData(
          centerSpaceRadius: 5,
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          sections: dataPieChart)),
    );
  }
}
