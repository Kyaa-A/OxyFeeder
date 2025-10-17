import 'package:flutter/material.dart';
import 'features/navigation/view/main_nav_host.dart';
import 'package:provider/provider.dart';
import 'features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'features/settings/viewmodel/settings_viewmodel.dart';
import 'features/sensors/viewmodel/sensors_viewmodel.dart';
import 'core/services/mock_bluetooth_service.dart';

void main() {
  runApp(const OxyFeederApp());
}

class OxyFeederApp extends StatelessWidget {
  const OxyFeederApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MockBluetoothService>(
          create: (_) => MockBluetoothService(),
          dispose: (_, svc) => svc.dispose(),
        ),
        ChangeNotifierProvider<DashboardViewModel>(
          create: (ctx) => DashboardViewModel(ctx.read<MockBluetoothService>()),
        ),
        ChangeNotifierProvider<SettingsViewModel>(
          create: (_) => SettingsViewModel(),
        ),
        ChangeNotifierProvider<SensorsViewModel>(
          create: (ctx) => SensorsViewModel(ctx.read<MockBluetoothService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const MainNavHost(),
      ),
    );
  }
}



