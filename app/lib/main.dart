import 'package:flutter/material.dart';
import 'features/navigation/view/main_nav_host.dart';

void main() {
  runApp(const OxyFeederApp());
}

class OxyFeederApp extends StatelessWidget {
  const OxyFeederApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}



