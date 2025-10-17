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
        onPressed: () async {
          final timeController = TextEditingController();
          final durationController = TextEditingController(text: '10');
          bool enabled = true;
          await showDialog<void>(
            context: context,
            builder: (ctx) {
              return StatefulBuilder(
                builder: (ctx, setState) {
                  return AlertDialog(
                    title: const Text('Add Feeding Schedule'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          controller: timeController,
                          decoration: const InputDecoration(
                            labelText: 'Time Label',
                            hintText: 'e.g., 08:00 AM',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: durationController,
                          decoration: const InputDecoration(
                            labelText: 'Duration (seconds)',
                            hintText: 'e.g., 10',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            const Expanded(child: Text('Enabled')),
                            Switch(
                              value: enabled,
                              onChanged: (v) => setState(() => enabled = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          final timeLabel = timeController.text.trim();
                          final duration = int.tryParse(durationController.text.trim());
                          if (timeLabel.isEmpty || duration == null) {
                            Navigator.of(ctx).pop();
                            return;
                          }
                          ctx.read<SettingsViewModel>().addSchedule(
                                timeLabel: timeLabel,
                                durationSeconds: duration,
                                enabled: enabled,
                              );
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
          );
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
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < viewModel.feedingSchedules.length; i++) ...[
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text('${viewModel.feedingSchedules[i].timeLabel}'),
                          subtitle: Text('${viewModel.feedingSchedules[i].durationSeconds} seconds feed'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Switch(
                                value: viewModel.feedingSchedules[i].enabled,
                                onChanged: (bool v) => viewModel.toggleScheduleEnabled(i, v),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => viewModel.removeSchedule(i),
                              ),
                            ],
                          ),
                        ),
                        if (i != viewModel.feedingSchedules.length - 1) const Divider(height: 1),
                      ],
                    ],
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


