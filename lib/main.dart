import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: BlackoutApp()));
}

class BlackoutApp extends StatelessWidget {
  const BlackoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLACKOUT – Silent Breach',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
