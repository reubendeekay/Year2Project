import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData mainData({bool isLoaded = false}) {
  List<Color> gradientColors = [
    const Color(0xffe68823),
    const Color(0xffe68823),
  ];

  return LineChartData(
    borderData: FlBorderData(
      show: false,
    ),
    gridData: FlGridData(
        show: true,
        horizontalInterval: 1.6,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            dashArray: const [5, 5],
            color: const Color(0xff37434d).withOpacity(0.2),
            strokeWidth: 9,
          );
        },
        drawVerticalLine: false),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 5,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 8),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return 'MAR';
            case 4:
              return 'JUN';
            case 7:
              return 'SEP';
            case 10:
              return 'OCT';
          }
          return '';
        },
        margin: 5,
      ),
      leftTitles: SideTitles(
        showTitles: false,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '10k';
            case 3:
              return '30k';
            case 5:
              return '50k';
          }
          return '';
        },
        reservedSize: 25,
        margin: 12,
      ),
    ),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineTouchData: LineTouchData(
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 2,
              dashArray: [3, 3],
            ),
            FlDotData(
              show: false,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 8,
                color: [
                  Colors.black,
                  Colors.black,
                ][index],
                strokeWidth: 2,
                strokeColor: Colors.black,
              ),
            ),
          );
        }).toList();
      },
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipPadding: const EdgeInsets.all(8),
        tooltipBgColor: Color(0xff2e3747).withOpacity(0.8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((touchedSpot) {
            return LineTooltipItem(
              '\$${touchedSpot.y.round()}0.00',
              const TextStyle(color: Colors.white, fontSize: 12.0),
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
    ),
    lineBarsData: [
      LineChartBarData(
        spots: isLoaded
            ? const [
                FlSpot(0, 3),
                FlSpot(2.4, 2),
                FlSpot(4.4, 3),
                FlSpot(6.4, 3.1),
                FlSpot(8, 4),
                FlSpot(9.5, 4),
                FlSpot(11, 5),
              ]
            : const [
                FlSpot(0, 0),
                FlSpot(2.4, 0),
                FlSpot(4.4, 0),
                FlSpot(6.4, 0),
                FlSpot(8, 0),
                FlSpot(9.5, 0),
                FlSpot(11, 0)
              ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 2,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
            show: true,
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
            colors: [
              Color(0xffe68823).withOpacity(0.1),
              Color(0xffe68823).withOpacity(0),
            ]),
      ),
      LineChartBarData(
        spots: isLoaded
            ? [
                FlSpot(0, 4),
                FlSpot(2.4, 3),
                FlSpot(4.4, 5),
                FlSpot(6.4, 3.8),
                FlSpot(8, 3.8),
                FlSpot(9.5, 5),
                FlSpot(11, 5),
              ]
            : [
                FlSpot(0, 0),
                FlSpot(2.4, 0),
                FlSpot(4.4, 0),
                FlSpot(6.4, 0),
                FlSpot(8, 0),
                FlSpot(9.5, 0),
                FlSpot(11, 0)
              ],
        isCurved: true,
        colors: [
          Color(0xff4e65fe).withOpacity(0.5),
          Color(0xff4e65fe).withOpacity(0),
        ],
        barWidth: 2,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
            show: true,
            gradientFrom: Offset(0, 0),
            gradientTo: Offset(0, 1),
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.blue.withOpacity(0),
            ]),
      ),
    ],
  );
}
