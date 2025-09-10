import 'package:flutter/material.dart';
import 'package:handymath/number_tracing_game.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'game_menu.dart';
// import 'number_matching_screen.dart';
// import 'number_order_screen.dart';
// import 'number_memory_screen.dart';
// import 'number_hunt_screen.dart';

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/game_menu': (context) => GameMenu(),
        '/number_tracing': (context) => NumberTracingScreen(),
        // '/number_matching': (context) => NumberMatchingScreen(),
        // '/number_order': (context) => NumberOrderScreen(),
        // '/number_memory': (context) => NumberMemoryScreen(),
        // '/number_hunt': (context) => NumberHuntScreen(),
      },
    );
  }
}
