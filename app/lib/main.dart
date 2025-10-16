import 'package:flutter/material.dart';
import 'features/navigation/view/main_nav_host.dart';
import 'package:provider/provider.dart';
import 'features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'features/settings/viewmodel/settings_viewmodel.dart';

void main() {
  runApp(const OxyFeederApp());
}

class OxyFeederApp extends StatelessWidget {
  const OxyFeederApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardViewModel>(
          create: (_) => DashboardViewModel(),
        ),
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



