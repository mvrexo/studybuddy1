import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studdybuddy1/screens/dashboard.dart';
import 'package:studdybuddy1/screens/notifications_screen.dart';
import 'package:studdybuddy1/screens/profile.dart';
import 'package:studdybuddy1/screens/learning_lessons.dart';
import 'package:studdybuddy1/screens/progress_tracker.dart';
import 'package:studdybuddy1/screens/lesson_planner_screen.dart';
import 'package:studdybuddy1/screens/settings_screen.dart';
import 'package:studdybuddy1/screens/login.dart';
import 'package:studdybuddy1/screens/accessibility_screen.dart';
import 'package:studdybuddy1/screens/flashcards_screen.dart';
import 'package:studdybuddy1/screens/quiz_page.dart';
// betulkan ikut laluan sebenar


class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support"), backgroundColor: const Color(0xFFEE9A4D)),
      body: const Center(child: Text("Support page coming soon...")),
    );
  }
}

class AppDrawer extends StatefulWidget {
  final bool showNotificationButton;
  final String? currentEmail;

  const AppDrawer({super.key, this.showNotificationButton = false, this.currentEmail, required String email});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String selected = 'Dashboard';
  bool expandLearning = false;
  bool expandFeatures = false;
  bool isHoveringLearning = false;
  bool isHoveringFeatures = false;

  final Color pastelPrimary = const Color(0xFFEE9A4D);
  final Color pastelSecondary = const Color(0xFFFFF5E1);
  final Color pastelHighlight = const Color(0xFFFFB74D);

  final String studentName = 'Amanda Sopeah';
  final String studentEmail = 'amandasopeah@studentmail.com';
  final String profileImage = 'assets/budak.jpg';

  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'en';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: pastelSecondary,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: pastelPrimary.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(profileImage),
                radius: 36,
              ),
              accountName: Text(
                studentName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                studentEmail,
                style: const TextStyle(color: Colors.white70),
              ),
              otherAccountsPictures: const [
                Icon(Icons.bug_report, color: Colors.white54),
              ],
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (widget.showNotificationButton)
                    _buildDrawerItem(
                      icon: Icons.notifications,
                      text: 'Notifications',
                      screen: const NotificationsScreen(),
                    ),

                  _buildDrawerItem(
                    icon: Icons.home,
                    text: 'Home',
                    screen: DashboardScreen(email: widget.currentEmail ?? ''),
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    text: 'My Profile',
                    screen: const ProfileScreen(email: ''),
                  ),

                  _buildExpandableHeader(
                    icon: Icons.folder_open,
                    text: 'Learning Modules',
                    expanded: expandLearning,
                    isHovering: isHoveringLearning,
                    onTap: () => setState(() => expandLearning = !expandLearning),
                    onHover: (hovering) {
                      if (kIsWeb || Theme.of(context).platform == TargetPlatform.windows || Theme.of(context).platform == TargetPlatform.macOS) {
                        setState(() {
                          isHoveringLearning = hovering;
                          if (hovering) expandLearning = true;
                        });
                      }
                    },
                  ),
                  if (expandLearning) ...[
                    _buildSubItem(text: 'Flashcards', screen: const FlashcardsScreen()),
                    _buildSubItem(text: 'Quiz', screen: const QuizPage()),
                    _buildSubItem(text: 'Lesson Planner', screen: const LessonPlannerScreen()),
                    _buildSubItem(text: 'Progress Tracker', screen: const ProgressTrackerScreen()),
                    _buildSubItem(text: 'Learning Lessons', screen: const LearningLessonsScreen()),
                  ],

                  _buildExpandableHeader(
                    icon: Icons.folder_special,
                    text: 'All Features',
                    expanded: expandFeatures,
                    isHovering: isHoveringFeatures,
                    onTap: () => setState(() => expandFeatures = !expandFeatures),
                    onHover: (hovering) {
                      if (kIsWeb || Theme.of(context).platform == TargetPlatform.windows || Theme.of(context).platform == TargetPlatform.macOS) {
                        setState(() {
                          isHoveringFeatures = hovering;
                          if (hovering) expandFeatures = true;
                        });
                      }
                    },
                  ),
                  if (expandFeatures) ...[
                    _buildSubItem(text: 'Accessibility', screen: const AccessibilityScreen()),
                    _buildSubItem(text: 'Support', screen: const SupportScreen()),
                    _buildSubItem(
                      text: 'Settings',
                      screen: SettingsScreen(
                        username: studentName,
                        currentLanguage: _language,
                        onLanguageChanged: (lang) => setState(() => _language = lang),
                        currentThemeMode: _themeMode,
                        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
                      ),
                    ),
                    _buildSubItem(
                     text: 'Customize Homescreen',
                     screen: const CustomizeHomeScreen(),
              ),
                  ],
                ],
              ),
            ),

            const Divider(color: Colors.orangeAccent),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Log Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pastelPrimary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
                onPressed: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required Widget screen}) {
    final isSelected = selected == text;
    return Material(
      color: isSelected ? pastelHighlight.withOpacity(0.3) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: Icon(icon, color: pastelPrimary),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? pastelPrimary : Colors.black87,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          setState(() => selected = text);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }

  Widget _buildExpandableHeader({
    required IconData icon,
    required String text,
    required bool expanded,
    required bool isHovering,
    required VoidCallback onTap,
    required ValueChanged<bool> onHover,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: ListTile(
        leading: Icon(icon, color: pastelPrimary),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: pastelPrimary)),
        trailing: Icon(expanded || isHovering ? Icons.expand_less : Icons.expand_more, color: pastelPrimary),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSubItem({required String text, required Widget screen}) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: ListTile(
        title: Text(text),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }

  void _logout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have been logged out.')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen(showLogoutMessage: true)),
      (route) => false,
    );
  }
}
