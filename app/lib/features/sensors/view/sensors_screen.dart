import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../viewmodel/sensors_viewmodel.dart';

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
            Consumer<SensorsViewModel>(
              builder: (context, viewModel, _) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.water, color: Colors.lightBlueAccent),
                        title: Text('Dissolved Oxygen'),
                      ),
                      ListTile(
                        dense: true,
                        title: Text('Status: OK | Last Calibrated: ${viewModel.lastCalibratedDate}'),
                        subtitle: Text('Live DO: ${viewModel.currentStatus.dissolvedOxygen.toStringAsFixed(2)} mg/L'),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.scale, color: Colors.amberAccent),
                        title: Text('Feed Level (Load Cell)'),
                      ),
                      ListTile(
                        dense: true,
                        title: Text('Raw Value: ${viewModel.feedLoadCellRawValue} | Status: Nominal'),
                        subtitle: Text('Live Feed Level: ${viewModel.currentStatus.feedLevel}%'),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.battery_full, color: Colors.greenAccent),
                        title: Text('System Battery'),
                      ),
                      ListTile(
                        dense: true,
                        title: Text('Voltage: ${viewModel.batteryVoltage} | Status: Charging'),
                        subtitle: Text('Live Battery: ${viewModel.currentStatus.batteryStatus}%'),
                      ),
                    ],
                  ),
                );
              },
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
            Consumer<SensorsViewModel>(
              builder: (context, viewModel, _) {
                return Card(
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
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white24,
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
                            interval: viewModel.historicalDoData.length > 1
                                ? (viewModel.historicalDoData.length / 6).ceilToDouble()
                                : 1,
                            getTitlesWidget: (value, meta) {
                              if (value % 1 != 0) return const SizedBox.shrink();
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
                          maxX: viewModel.historicalDoData.isEmpty
                              ? 23
                              : (viewModel.historicalDoData.length - 1).toDouble(),
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
                              spots: viewModel.historicalDoData,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


