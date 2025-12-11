import 'package:flutter/material.dart';
import '../widgets/sensor_card.dart';
import 'package:provider/provider.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import '../../../core/services/real_bluetooth_service.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onNavigateToSensors;

  const DashboardScreen({super.key, this.onNavigateToSensors});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final status = vm.status;
    final bleService = context.read<RealBluetoothService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('OxyFeeder'),
        actions: [
          // Connection status indicator and reconnect button
          StreamBuilder<BleConnectionState>(
            stream: bleService.connectionStateStream,
            initialData: bleService.currentState,
            builder: (context, snapshot) {
              final state = snapshot.data ?? BleConnectionState.disconnected;
              return Row(
                children: [
                  // Status indicator
                  Icon(
                    state.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                    color: state.isConnected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  // Reconnect button
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      bleService.reconnect();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reconnecting... ${state.message}')),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              // Connection status banner
              StreamBuilder<BleConnectionState>(
                stream: bleService.connectionStateStream,
                initialData: bleService.currentState,
                builder: (context, snapshot) {
                  final state = snapshot.data ?? BleConnectionState.disconnected;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: state.isConnected ? Colors.green.shade900 : Colors.orange.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          state.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_searching,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SensorCard(
                title: 'Dissolved Oxygen',
                value: '${status.dissolvedOxygen.toStringAsFixed(1)} mg/L',
                icon: Icons.water,
                onTap: onNavigateToSensors,
              ),
              const SizedBox(height: 12),
              SensorCard(
                title: 'Feed Level',
                value: '${status.feedLevel} %',
                icon: Icons.inventory_2,
                onTap: onNavigateToSensors,
              ),
              const SizedBox(height: 12),
              SensorCard(
                title: 'Battery Status',
                value: '${status.batteryStatus} %',
                icon: Icons.battery_charging_full,
                onTap: onNavigateToSensors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



