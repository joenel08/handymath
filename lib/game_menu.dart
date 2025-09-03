import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<GameMenu> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  int? age;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      age = prefs.getInt('age');
      username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (age == null || username == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Welcome $username!")),
      body: Center(
        child: Text(
          "Games for $age-year-olds coming soon!",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
