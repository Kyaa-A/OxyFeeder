import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for adding new schedules
          // ignore: avoid_print
          print('Add new feeding schedule');
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            // Feeding Schedule Section
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Feeding Schedule',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Consumer<SettingsViewModel>(
              builder: (context, viewModel, _) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: SwitchListTile(
                    title: Text('${viewModel.feedingSchedules.first.timeLabel} - ${viewModel.feedingSchedules.first.durationSeconds} seconds feed'),
                    value: true,
                    onChanged: (bool v) => viewModel.toggleScheduleEnabled(0, v),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Alert Thresholds Section
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Alert Thresholds',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Consumer<SettingsViewModel>(
              builder: (context, viewModel, _) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Dissolved Oxygen'),
                          subtitle: Slider(
                            value: viewModel.minDissolvedOxygen,
                            min: 2.0,
                            max: 8.0,
                            divisions: 12,
                            label: '${viewModel.minDissolvedOxygen.toStringAsFixed(1)} mg/L',
                            onChanged: viewModel.updateMinDissolvedOxygen,
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text('Feed Level'),
                          subtitle: Slider(
                            value: viewModel.lowFeedThreshold.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 20,
                            label: '${viewModel.lowFeedThreshold} %',
                            onChanged: (newValue) => viewModel.updateLowFeedThreshold(newValue.toInt()),
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text('Battery Status'),
                          subtitle: Slider(
                            value: viewModel.lowBatteryThreshold.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 20,
                            label: '${viewModel.lowBatteryThreshold} %',
                            onChanged: (newValue) => viewModel.updateLowBatteryThreshold(newValue.toInt()),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Device Management Section
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Device Management',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.bluetooth_connected, color: Colors.green),
                    title: Text('Status: Connected'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.link_off),
                    title: const Text('Disconnect from device'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Application Section
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Application',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Consumer<SettingsViewModel>(
              builder: (context, viewModel, _) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        title: const Text('Enable Notifications'),
                        value: viewModel.notificationsEnabled,
                        onChanged: viewModel.updateNotificationsEnabled,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('About'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}


