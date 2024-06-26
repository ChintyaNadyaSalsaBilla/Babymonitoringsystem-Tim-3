import 'package:babymonitoringsystem/onboarding.dart';
import 'package:babymonitoringsystem/spalshscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
      title: 'Aplikasi Flutter',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => OnboardingPage1(),
      },
    );
  }
}
