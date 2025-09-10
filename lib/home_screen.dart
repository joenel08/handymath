import 'package:flutter/material.dart';
import 'package:handymath/custom_button.dart';
import 'dart:async';
import 'user_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentTextIndex = 0;
  String _displayedText = "";
  Timer? _typingTimer;

  late AnimationController _mouthController;
  late Animation<double> _mouthAnimation;

  final List<String> _introTexts = [
    "Hi there! 👋 \nWelcome to HandyMath!",
    "I'm Ms. Math. We will have so much fun learning together!",
    "Math isn't just numbers—it's a way of thinking, solving, and exploring!",
    "Don't worry if it seems tricky at first. I'm here to guide you every step of the way.",
    "We'll play with patterns, crack puzzles, and discover cool tricks!",
    "Every mistake is a chance to learn something new. So be brave and curious!",
    "Ready to become a HandyMath hero? Let's dive in! 💪📚"
  ];

  @override
  void initState() {
    super.initState();

    // Mouth bobbing animation
    _mouthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..repeat(reverse: true);
    _mouthAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _mouthController, curve: Curves.easeInOut),
    );

    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _displayedText = "";
    int charIndex = 0;
    _typingTimer?.cancel();

    // Start mouth movement
    _mouthController.repeat(reverse: true);

    _typingTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (charIndex < _introTexts[_currentTextIndex].length) {
        setState(() {
          _displayedText += _introTexts[_currentTextIndex][charIndex];
        });
        charIndex++;
      } else {
        timer.cancel();
        // Stop mouth after a short pause
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _mouthController.stop();
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() {
            _currentTextIndex = (_currentTextIndex + 1) % _introTexts.length;
          });
          _startTypingAnimation();
        });
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _mouthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          /// Full screen background
          Positioned.fill(
            child: Image.asset(
              "assets/home_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Character bottom left with mouth bobbing effect
          Positioned(
            left: 0,
            bottom: -screenHeight * 0.15,
            child: ScaleTransition(
              scale: _mouthAnimation,
              child: Image.asset(
                "assets/character.png",
                height: screenHeight * 0.75,
              ),
            ),
          ),

          /// Speech bubble above character
          Positioned(
            left: screenWidth * 0.05,
            bottom: screenHeight * 0.6,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/bubble.png",
                  width: screenWidth * 0.9,
                  fit: BoxFit.contain,
                ),
                Container(
                  width: screenWidth * 0.8 - 20, // Bubble width minus padding
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10), // 10px inside padding
                  child: Text(
                    _displayedText,
                    style: const TextStyle(
                      fontFamily: 'PencilChild',
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),

          /// Skip button
          Positioned(
            bottom: 40,
            right: 40,
            child: EmbossedButton(
              text: "Skip",
              width: 150, // optional: adjust or remove to auto-size
              color: Color(0xFF479718), // dynamic color
              onPressed: () {
                _typingTimer?.cancel();
                _mouthController.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const UserInfoScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
