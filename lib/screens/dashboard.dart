import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studdybuddy1/screens/mind_map_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:studdybuddy1/screens/profile.dart';
import 'package:studdybuddy1/screens/learning_lessons.dart';
import 'package:studdybuddy1/screens/progress_tracker.dart';
import 'package:studdybuddy1/screens/settings_screen.dart';
import 'package:studdybuddy1/screens/accessibility_screen.dart';
import 'package:studdybuddy1/screens/notifications_screen.dart';
import 'package:studdybuddy1/screens/lesson_planner_screen.dart';
import 'package:studdybuddy1/screens/flashcards_screen.dart';
import 'package:studdybuddy1/screens/quiz_page.dart';
import 'package:studdybuddy1/screens/support_screen.dart';
import 'package:studdybuddy1/screens/widgets/app_drawer.dart' hide SupportScreen;

class DashboardScreen extends StatefulWidget {
  final String email;

  const DashboardScreen({super.key, required this.email});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedBottomIndex = 0;
  String userName = "";

  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _extractNameFromEmail();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  void _extractNameFromEmail() {
    final parts = widget.email.split('@');
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      setState(() {
        userName = parts[0][0].toUpperCase() + parts[0].substring(1);
      });
    }
  }

  // Pastel Theme Colors
  final Color _pastelBackground = const Color(0xFFFDF6F0);
  final Color _pastelPrimary = const Color.fromARGB(255, 221, 136, 71);
  final Color _pastelSecondary = const Color.fromARGB(255, 235, 255, 209);
  final Color _pastelText = const Color.fromARGB(255, 66, 63, 63);

  List<Map<String, Object?>> get learningModules => [
        {
          'title': 'Flashcards',
          'icon': Icons.style,
          'route': const FlashcardsScreen()
        },
        {'title': 'Quiz', 'icon': Icons.quiz, 'route': const QuizPage()},
        {
          'title': 'Learning Lessons',
          'icon': Icons.menu_book,
          'route': const LearningLessonsScreen()
        },
        {
          'title': 'Lesson Planner',
          'icon': Icons.event_note,
          'route': const LessonPlannerScreen()
        },
        {
          'title': 'Progress Tracker',
          'icon': Icons.show_chart,
          'route': const ProgressTrackerScreen()
        },
        {
          'title': 'Mind Map',
          'icon': Icons.psychology,
          'route': const MindMapScreen()
        },
      ];

List<Map<String, Object>> get appFeatures => [
  {
    'title': 'Accessibility',
    'icon': Icons.accessibility_new,
    'route': const AccessibilityScreen(),
  },
  {
    'title': 'Settings',
    'icon': Icons.settings,
    'route': SettingsScreen(
      username: 'User',
      currentThemeMode: ThemeMode.system,
      onThemeModeChanged: (ThemeMode value) {
     
      },
      currentLanguage: 'en',
      onLanguageChanged: (String value) {
      
      },
    ),
  },
  {
    'title': 'Support',
    'icon': Icons.support_agent,
    'route': const SupportScreen(),
  },
];
  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });

    if (index == 1) {
      _showFeedbackDialog(context);
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CustomizeHomeScreen()),
      );
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();
    int rating = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Rate the App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < rating ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  );
                }),
              ),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Your feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                feedbackController.dispose();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (rating == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a rating.')),
                  );
                  return;
                }
                if (mounted) {
                  print('Rating: $rating');
                  print('Feedback: ${feedbackController.text}');
                }
                Navigator.pop(context);
                feedbackController.dispose();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback!')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFeatureTap(BuildContext context, Widget? route) {
    if (route != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => route));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feature coming soon!')),
      );
    }
  }

  Widget _buildFeatureCard(Map<String, Object?> feature) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _handleFeatureTap(context, feature['route'] as Widget?),
        child: Container(
          width: 130,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _pastelPrimary.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(color: _pastelPrimary.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature['icon'] as IconData, size: 40, color: _pastelPrimary),
              const SizedBox(height: 10),
              Text(
                feature['title'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _pastelPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildModuleCard(Map<String, Object?> module) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => module['route'] as Widget),
      );
    },
    child: Card(
      color: _pastelPrimary,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              module['icon'] as IconData,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              module['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildSection(String title, List<Map<String, Object?>> items, {bool wrap = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: _pastelPrimary)),
        const SizedBox(height: 14),
        wrap
            ? Wrap(spacing: 16, runSpacing: 16, children: items.map(_buildFeatureCard).toList())
            : SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, index) => _buildFeatureCard(items[index]),
                ),
              ),
        const SizedBox(height: 26),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: _pastelSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _pastelPrimary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: _pastelPrimary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: _pastelPrimary.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(color: _pastelText),
          weekendTextStyle: TextStyle(color: _pastelPrimary),
          todayTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          selectedTextStyle: const TextStyle(color: Colors.white),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: _pastelPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: _pastelPrimary),
          rightChevronIcon: Icon(Icons.chevron_right, color: _pastelPrimary),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: _pastelPrimary, fontWeight: FontWeight.w600),
          weekendStyle: TextStyle(color: _pastelPrimary.withOpacity(0.7)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: _pastelBackground,
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: _pastelPrimary,
          actions: [
            IconButton(
              tooltip: 'Notifications',
              icon: const Icon(Icons.notifications),
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            ),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person),
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(email: widget.email))),
            ),
          ],
        ),
        drawer: AppDrawer(email: widget.email),
        body: Stack(
          children: [
            // Background blur + pastel overlay
            Positioned.fill(
              child: Image.asset(
                'assets/cartoonbg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Container(
                  color: _pastelSecondary.withOpacity(0.4),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Amanda Sopeah!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: _pastelPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Calendar widget
                    _buildTableCalendar(),
                    const SizedBox(height: 20),

                    _buildSection('All Modules', learningModules),

                    _buildSection('All Features', appFeatures, wrap: true),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomIndex,
          selectedItemColor: _pastelPrimary,
          unselectedItemColor: const Color.fromARGB(255, 77, 71, 71),
          onTap: _onBottomNavTap,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: 'Customize'),
          ],
        ),
      );
    });
  }
}

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
      for (var key in moduleVisibility.keys) {
        moduleVisibility[key] = prefs.getBool(key) ?? true;
      }
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
      backgroundColor: backgroundColors[selectedBackgroundColor],
      appBar: AppBar(
        title: const Text('Customize Home'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Hide/Show Modules:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...moduleVisibility.keys.map((module) {
            return SwitchListTile(
              title: Text(module),
              value: moduleVisibility[module]!,
              onChanged: (val) {
                setState(() => moduleVisibility[module] = val);
              },
              activeColor: Colors.orange,
            );
          }),
          const Divider(height: 30),
          const Text(
            'Background Themes:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: backgroundColors.entries.map((entry) {
              return ChoiceChip(
                label: Text(entry.key),
                selected: selectedBackgroundColor == entry.key,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => selectedBackgroundColor = entry.key);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
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
    );
  }
}

