import 'package:flutter/material.dart';
import 'features/navigation/view/main_nav_host.dart';
import 'package:provider/provider.dart';
import 'features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'features/settings/viewmodel/settings_viewmodel.dart';
import 'features/sensors/viewmodel/sensors_viewmodel.dart';
// import 'core/services/mock_bluetooth_service.dart'; // Phase 2 (mock data)
import 'core/services/real_bluetooth_service.dart'; // Phase 3 (real hardware)

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OxyFeederApp());
}

class OxyFeederApp extends StatelessWidget {
  const OxyFeederApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ============================================================
        // PHASE 3: RealBluetoothService (real hardware)
        // ============================================================
        Provider<RealBluetoothService>(
          create: (_) => RealBluetoothService(),
          dispose: (_, svc) => svc.dispose(),
        ),
        ChangeNotifierProvider<DashboardViewModel>(
          create: (ctx) => DashboardViewModel(ctx.read<RealBluetoothService>()),
        ),
        ChangeNotifierProvider<SensorsViewModel>(
          create: (ctx) => SensorsViewModel(ctx.read<RealBluetoothService>()),
        ),

        // ============================================================
        // PHASE 2: MockBluetoothService (simulated data) - DISABLED
        // ============================================================
        // To use mock data instead of real hardware:
        // 1. Comment out the RealBluetoothService provider above
        // 2. Uncomment the lines below
        // 3. Update the import at the top of this file
        // ============================================================
        // Provider<MockBluetoothService>(
        //   create: (_) => MockBluetoothService(),
        //   dispose: (_, svc) => svc.dispose(),
        // ),
        // ChangeNotifierProvider<DashboardViewModel>(
        //   create: (ctx) => DashboardViewModel(ctx.read<MockBluetoothService>()),
        // ),
        // ChangeNotifierProvider<SensorsViewModel>(
        //   create: (ctx) => SensorsViewModel(ctx.read<MockBluetoothService>()),
        // ),

        // Settings ViewModel (no bluetooth dependency)
        ChangeNotifierProvider<SettingsViewModel>(
          create: (_) => SettingsViewModel(),
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



