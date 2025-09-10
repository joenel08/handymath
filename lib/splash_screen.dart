import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // Intro page with skip
import 'game_menu.dart'; // Page showing games

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    // Logo bounce animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Loading dots animation
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Redirect after 3 seconds
    Timer(const Duration(seconds: 3), _checkUserData);
  }

  Future<void> _checkUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final age = prefs.getString('ageRange');

    if (username != null && username.isNotEmpty && age != null) {
      // Use named route instead of MaterialPageRoute
      Navigator.pushReplacementNamed(context, '/game_menu');
    } else {
      // Use named route instead of MaterialPageRoute
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC107),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo
            ScaleTransition(
              scale: _logoScale,
              child: Image.asset(
                'assets/handymath_logo.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 40),
            // 3D-style loading dots
            AnimatedBuilder(
              animation: _dotsController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    double value =
                        (_dotsController.value + (index * 0.2)) % 1.0;
                    double yOffset = (value < 0.5 ? value : 1 - value) * -20;

                    return Transform.translate(
                      offset: Offset(0, yOffset),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.6),
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
