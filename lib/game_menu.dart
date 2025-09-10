import 'package:flutter/material.dart';
import 'package:handymath/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<GameMenu> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  String? ageRange;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ageRange = prefs.getString('ageRange');
      username = prefs.getString('username');
    });
  }

  // List of games for 4-5 year olds
  final List<Map<String, dynamic>> numberGames = [
    {
      'title': 'Number Tracing',
      'icon': 'assets/tracing_logo.png',
      'color': const Color(0xFF4CAF50),
      'description': 'Practice writing numbers',
      'route': '/number_tracing',
    },
    {
      'title': 'Number Matching',
      'icon': 'assets/matching_logo.png',
      'color': const Color.fromARGB(255, 243, 177, 33),
      'description': 'Match numbers to quantities',
      'route': '/number_matching',
    },
    {
      'title': 'Number Order',
      'icon': 'assets/number_order.png',
      'color': const Color(0xFF9C27B0),
      'description': 'Put numbers in correct order',
      'route': '/number_order',
    },
    {
      'title': 'Number Memory',
      'icon': 'assets/number_memory.png',
      'color': const Color(0xFF009688),
      'description': 'Find matching number pairs',
      'route': '/number_memory',
    },
    {
      'title': 'Number Hunt',
      'icon': 'assets/number_hunt.png',
      'color': const Color(0xFFF44336),
      'description': 'Find hidden numbers',
      'route': '/number_hunt',
    },
  ];

  void _navigateToGame(String route) {
    // Replace with your navigation logic
    Navigator.pushNamed(context, route);
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) => _SettingsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ageRange == null || username == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70, // Increase AppBar height if needed
        actions: [
          Container(
            // Add margin around the entire button
            margin: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
            // Constrain the button size to prevent overflow
            constraints: const BoxConstraints(
              minWidth: 50,
              minHeight: 50,
            ),
            child: EmbossedButton(
              imagePath: 'assets/settings_icon.png',
              onPressed: _openSettings,
              depth: 120,
              color: Colors.blue,
              radius: 15,
              imageSize: 24, // Smaller image size for AppBar
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/game_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Animated Teacher Character
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: TweenAnimationBuilder(
                    tween: Tween(begin: 0.9, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Image.asset(
                          'assets/character_half.png',
                          // height: 200,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Game Grid Title
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Hello $username! Choose a game below and enjoy...",
                style: const TextStyle(
                  fontFamily: 'PencilChild',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Game Grid with Embossed Buttons
            Expanded(
              flex: 3,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: numberGames.length,
                itemBuilder: (context, index) {
                  final game = numberGames[index];
                  return EmbossedButton(
                    imagePath: game['icon'],
                    text: game['title'],
                    onPressed: () => _navigateToGame(game['route']),
                    depth: 120,
                    // radius: 25,
                    imageSize: 80,
                    color: game['color'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Dialog (unchanged)
class _SettingsDialog extends StatefulWidget {
  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog> {
  double _volume = 0.8;
  double _brightness = 0.7;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Settings",
              style: TextStyle(
                  fontFamily: 'PencilChild',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSettingItem(
              icon: Icons.volume_up,
              title: "Volume",
              child: Slider(
                value: _volume,
                onChanged: (value) => setState(() => _volume = value),
              ),
            ),
            _buildSettingItem(
              icon: Icons.brightness_6,
              title: "Brightness",
              child: Slider(
                value: _brightness,
                onChanged: (value) => setState(() => _brightness = value),
              ),
            ),
            _buildSettingItem(
              icon: Icons.vibration,
              title: "Vibration",
              child: Switch(
                value: _vibration,
                onChanged: (value) => setState(() => _vibration = value),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontFamily: 'PencilChild',
                  fontSize: 18,
                ),
              ),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'PencilChild', fontSize: 16)),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
