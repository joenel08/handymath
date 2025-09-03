import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'game_menu.dart';

void main() {
  runApp(const HandyMathApp());
}

class HandyMathApp extends StatelessWidget {
  const HandyMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HandyMath',
      home: SplashScreen(),
    );
  }
}
