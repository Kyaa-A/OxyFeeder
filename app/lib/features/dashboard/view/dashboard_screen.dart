import 'package:flutter/material.dart';
import '../widgets/sensor_card.dart';
import 'package:provider/provider.dart';
import '../viewmodel/dashboard_viewmodel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final status = vm.status;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OxyFeeder'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              SensorCard(
                title: 'Dissolved Oxygen',
                value: '${status.dissolvedOxygen.toStringAsFixed(1)} mg/L',
                icon: Icons.water,
              ),
              const SizedBox(height: 12),
              SensorCard(
                title: 'Feed Level',
                value: '${status.feedLevel} %',
                icon: Icons.inventory_2,
              ),
              const SizedBox(height: 12),
              SensorCard(
                title: 'Battery Status',
                value: '${status.batteryStatus} %',
                icon: Icons.battery_charging_full,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



