import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            // Detailed Status
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Live Sensor Details',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.water, color: Colors.lightBlueAccent),
                    title: Text('Dissolved Oxygen'),
                    subtitle: Text('Status: OK | Last Calibrated: 2025-10-26'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.scale, color: Colors.amberAccent),
                    title: Text('Feed Level (Load Cell)'),
                    subtitle: Text('Raw Value: 12345 | Status: Nominal'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.battery_full, color: Colors.greenAccent),
                    title: Text('System Battery'),
                    subtitle: Text('Voltage: 12.8V | Status: Charging'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Historical Data - DO Trend (Last 24 Hours)
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'DO Trend (Last 24 Hours)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 240,
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Colors.transparent,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 1,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white24,
                          strokeWidth: 1,
                        ),
                        getDrawingVerticalLine: (value) => FlLine(
                          color: Colors.white12,
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          axisNameWidget: const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('Time (hrs)')
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: 4,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text('DO (mg/L)')
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          top: BorderSide(color: Colors.transparent),
                          right: BorderSide(color: Colors.transparent),
                          left: BorderSide(color: Colors.white24),
                          bottom: BorderSide(color: Colors.white24),
                        ),
                      ),
                      minX: 0,
                      maxX: 24,
                      minY: 2,
                      maxY: 10,
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.tealAccent,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.tealAccent.withOpacity(0.12),
                          ),
                          spots: const [
                            FlSpot(0, 6.0),
                            FlSpot(4, 6.3),
                            FlSpot(8, 5.8),
                            FlSpot(12, 6.5),
                            FlSpot(16, 7.2),
                            FlSpot(20, 7.0),
                            FlSpot(24, 6.8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


