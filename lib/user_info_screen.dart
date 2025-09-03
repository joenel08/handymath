import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_menu.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedAge;

  Future<void> _saveData() async {
    if (_selectedAge != null && _nameController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('age', _selectedAge!);
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
                image: AssetImage("assets/age_bg.png"), // your full-screen bg
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
                    'assets/character.gif',
                    height: 200,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Let's get to know you!",
                    style: const TextStyle(
                      fontFamily: 'PencilChild',
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(height: 30),

                  /// Age Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedAge,
                      hint: Text(
                        "Select your age:",
                        style: const TextStyle(
                          fontFamily: 'PencilChild',
                          fontSize: 22,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      underline: const SizedBox(),
                      isExpanded: true,
                      items: [3, 4, 5, 6].map((age) {
                        return DropdownMenuItem(
                          value: age,
                          child: Text(
                            "$age years old",
                            style: const TextStyle(
                              fontFamily: 'PencilChild',
                              fontSize: 22,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedAge = val),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Name TextField
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontFamily: 'PencilChild', // Font for input text
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      labelText: "Enter your name",
                      labelStyle: const TextStyle(
                        fontFamily: 'PencilChild', // Font for label
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveData,
                      child: Text(
                        "Continue",
                        style: const TextStyle(
                          fontFamily: 'PencilChild',
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
