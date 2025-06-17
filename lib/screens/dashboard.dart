import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:studdybuddy1/screens/mind_map_screen.dart';
import 'package:studdybuddy1/screens/mini_games.dart';
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
import 'package:studdybuddy1/screens/widgets/app_drawer.dart';

const Color kThemePrimary = Colors.deepOrangeAccent;
const Color kThemeBackground = Color(0xFFFFF5E1);
const Color kThemeAccent = Color(0xFF8B4513);
const String kFontFamily = 'AlfaSlabOne';

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
        {
          'title': 'Mini Games',
          'icon': Icons.videogame_asset,
          'route': const MiniGamesScreen(),
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
            onThemeModeChanged: (value) {},
            currentLanguage: 'en',
            onLanguageChanged: (String value) {},
            isDarkMode: false,
            onDarkModeChanged: (bool value) {},
          ),
        },
      ];

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });

    if (index == 1) {
      _showFeedbackDialog(context);
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
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _handleFeatureTap(context, feature['route'] as Widget?),
        child: Container(
          width: 130,
          height: 130,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kThemePrimary.withOpacity(0.7), width: 2),
            boxShadow: [
              BoxShadow(
                  color: kThemePrimary.withOpacity(0.18),
                  blurRadius: 7,
                  offset: const Offset(2, 2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature['icon'] as IconData, size: 44, color: kThemePrimary),
              const SizedBox(height: 10),
              Text(
                feature['title'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: kThemeAccent,
                  fontFamily: kFontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildModuleCard(Map<String, Object?> module) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => module['route'] as Widget),
          );
        },
        child: Container(
          width: 130,
          height: 130,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kThemePrimary.withOpacity(0.7), width: 2),
            boxShadow: [
              BoxShadow(
                  color: kThemePrimary.withOpacity(0.18),
                  blurRadius: 7,
                  offset: const Offset(2, 2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                module['icon'] as IconData,
                size: 44,
                color: kThemePrimary,
              ),
              const SizedBox(height: 10),
              Text(
                module['title'] as String,
                style: TextStyle(
                  color: kThemeAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: kFontFamily,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, Object?>> items,
      {bool wrap = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kThemePrimary,
                fontFamily: kFontFamily)),
        const SizedBox(height: 14),
        wrap
            ? Wrap(
                spacing: 16,
                runSpacing: 16,
                children: items
                    .map((item) => _buildFeatureCard(item))
                    .toList(),
              )
            : SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, index) =>
                      buildModuleCard(items[index]),
                ),
              ),
        const SizedBox(height: 26),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: kThemePrimary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kThemePrimary.withOpacity(0.13),
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
            color: kThemePrimary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: kThemePrimary.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(color: kThemeAccent, fontFamily: kFontFamily),
          weekendTextStyle: TextStyle(color: kThemePrimary, fontFamily: kFontFamily),
          todayTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontFamily: kFontFamily),
          selectedTextStyle: TextStyle(color: Colors.white, fontFamily: kFontFamily),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: kThemePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: kFontFamily,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: kThemePrimary),
          rightChevronIcon: Icon(Icons.chevron_right, color: kThemePrimary),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
              color: kThemePrimary, fontWeight: FontWeight.w600, fontFamily: kFontFamily),
          weekendStyle: TextStyle(
              color: kThemePrimary.withOpacity(0.7), fontFamily: kFontFamily),
        ),
        daysOfWeekHeight: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: kThemeBackground,
        appBar: AppBar(
          title: Text('Dashboard',
              style: TextStyle(
                  fontFamily: kFontFamily, color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: kThemePrimary,
          actions: [
            IconButton(
              tooltip: 'Support',
              icon: const Icon(Icons.support_agent),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const SupportScreen())),
            ),
            IconButton(
              tooltip: 'Notifications',
              icon: const Icon(Icons.notifications),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            ),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfileScreen(email: widget.email))),
            ),
          ],
        ),
        drawer: AppDrawer(
          email: widget.email,
          extraItems: [
            DrawerItem(
              icon: Icons.videogame_asset,
              title: 'Mini Games',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MiniGamesScreen()),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
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
                  color: kThemeBackground.withOpacity(0.4),
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
                        color: kThemePrimary,
                        fontFamily: kFontFamily,
                      ),
                    ),
                    const SizedBox(height: 12),
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
          selectedItemColor: kThemePrimary,
          unselectedItemColor: kThemeAccent,
          onTap: _onBottomNavTap,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
          ],
        ),
      );
    });
  }
}

class DrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
