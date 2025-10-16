import 'package:flutter/material.dart';
import '../widgets/sensor_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OxyFeeder'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: const <Widget>[
              SensorCard(
                title: 'Dissolved Oxygen',
                value: '7.8 mg/L',
                icon: Icons.water,
              ),
              SizedBox(height: 12),
              SensorCard(
                title: 'Feed Level',
                value: '62 %',
                icon: Icons.inventory_2,
              ),
              SizedBox(height: 12),
              SensorCard(
                title: 'Battery Status',
                value: '85 %',
                icon: Icons.battery_charging_full,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



