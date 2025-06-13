import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomizeHomeScreen extends StatefulWidget {
  const CustomizeHomeScreen({super.key});

  @override
  State<CustomizeHomeScreen> createState() => _CustomizeHomeScreenState();
}

class _CustomizeHomeScreenState extends State<CustomizeHomeScreen> {
  Map<String, bool> moduleVisibility = {
    'Flashcards': true,
    'Quiz': true,
    'Learning Lessons': true,
    'Lesson Planner': true,
    'Progress Tracker': true,
    'Mini Games': true,
  };

  final Map<String, Color> backgroundColors = {
    'White': Colors.white,
    'Light Blue': Colors.lightBlue.shade100,
    'Light Green': Colors.lightGreen.shade100,
    'Cream': const Color(0xFFFFFDD0),
    'Light Grey': Colors.grey.shade200,
  };

  String selectedBackgroundColor = 'White';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load module visibility
      moduleVisibility.forEach((key, value) {
        moduleVisibility[key] = prefs.getBool(key) ?? true;
      });

      // Load background color choice
      selectedBackgroundColor = prefs.getString('backgroundColor') ?? 'White';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    for (var key in moduleVisibility.keys) {
      await prefs.setBool(key, moduleVisibility[key]!);
    }
    await prefs.setString('backgroundColor', selectedBackgroundColor);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Preferences saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Home'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        color: backgroundColors[selectedBackgroundColor],
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Choose which modules to show on your dashboard:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...moduleVisibility.keys.map(
              (module) => SwitchListTile(
                title: Text(module),
                value: moduleVisibility[module]!,
                activeColor: Colors.orange,
                onChanged: (bool value) {
                  setState(() {
                    moduleVisibility[module] = value;
                  });
                },
              ),
            ),
            const Divider(height: 40, thickness: 2),
            const Text(
              'Background Color:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: backgroundColors.keys.map((colorName) {
                final isSelected = selectedBackgroundColor == colorName;
                return ChoiceChip(
                  label: Text(colorName),
                  selected: isSelected,
                  selectedColor: Colors.deepOrange,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => selectedBackgroundColor = colorName);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _savePreferences,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
