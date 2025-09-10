import 'package:flutter/material.dart';
import 'package:handymath/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_menu.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedAgeRange;

  Future<void> _saveData() async {
    if (_selectedAgeRange != null && _nameController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ageRange', _selectedAgeRange!);
      await prefs.setString('username', _nameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GameMenu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/age_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          /// Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/character_think.png',
                    height: 200,
                  ),
                  // const SizedBox(height: 20),

                  Text(
                    "Let's get to know you!",
                    style: const TextStyle(
                      fontFamily: 'PencilChild',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(height: 30),

                  /// Age Range Selection Title
                  Text(
                    "Select your age range:",
                    style: const TextStyle(
                      fontFamily: 'PencilChild',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),

                  /// Age Range Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAgeButton("4-5", "4-5 years"),
                      _buildAgeButton("6-7", "6-7 years"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Name TextField - Removed floating label effect
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontFamily: 'PencilChild',
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none, // Remove default border
                        hintText: "Enter your name",
                        hintStyle: TextStyle(
                          fontFamily: 'PencilChild',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Continue Button
                  EmbossedButton(
                    text: "Continue",
                    onPressed: _saveData,
                    // radius: 25,
                    depth: 120,
                    width: 200,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeButton(String value, String label) {
    bool isSelected = _selectedAgeRange == value;
    Color buttonColor =
        value == "4-5" ? const Color(0xFF4CAF50) : const Color(0xFF2196F3);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAgeRange = value;
        });
      },
      child: SizedBox(
        width: 140,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Embossed Button as the box
                EmbossedButton(
                  text: value,
                  width: 120,
                  color: buttonColor,
                  onPressed: () {
                    setState(() {
                      _selectedAgeRange = value;
                    });
                  },
                ),

                // Image checkmark when selected - positioned at top right
                if (isSelected)
                  Positioned(
                    // top: 5,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/checkmark.png', // Replace with your checkmark image path
                        width: 20,
                        height: 20,
                        color: buttonColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'PencilChild',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
