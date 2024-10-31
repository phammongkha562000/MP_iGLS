import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InBoundChartWidget extends StatelessWidget {
  const InBoundChartWidget({super.key, required this.dataInBoundChart});
  final List<FlSpot> dataInBoundChart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
                spots: dataInBoundChart,
                isCurved: true,
                dotData: const FlDotData(show: true))
          ],
        ),
      ),
    );
  }
}
