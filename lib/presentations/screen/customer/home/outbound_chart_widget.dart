import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutBoundChartWidget extends StatelessWidget {
  const OutBoundChartWidget({super.key, required this.dataOutBoundChart});
  final List<FlSpot> dataOutBoundChart;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      height: 250.h,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
                spots: dataOutBoundChart,
                isCurved: true,
                dotData: const FlDotData(show: true))
          ],
        ),
      ),
    );
  }
}
