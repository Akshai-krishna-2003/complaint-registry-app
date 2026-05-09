// main.dart
import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/features/auth/data/auth_service.dart';
import 'package:registry/src/features/auth/presentation/auth_screen.dart';
import 'package:registry/src/features/dashboard/presentation/home_screen.dart';
import 'package:registry/src/features/splash/splash_screen.dart';

void main() {
  runApp(const UniComplaintsApp());
}

class UniComplaintsApp extends StatelessWidget {
  const UniComplaintsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniComplaints',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
