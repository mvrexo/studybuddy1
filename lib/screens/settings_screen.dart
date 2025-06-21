import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.username,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.currentLanguage,
    required this.onLanguageChanged, required ThemeMode currentThemeMode, required void Function(dynamic mode) onThemeModeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final Color themePrimary = Colors.deepOrangeAccent;
  static final Color themeBackground = const Color(0xFFFFF5E1); // light cream
  static final Color themeAccent = const Color(0xFF8B4513); // brown tone
  static const String fontFamily = 'AlfaSlabOne';

  late String _selectedLanguage;
  late bool _isDarkMode;
  String _username = '';
  String _languageLabel(String langCode) => langCode == 'ms' ? 'Bahasa Melayu' : 'English';

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
    _isDarkMode = widget.isDarkMode;
    _username = widget.username;
  }

  bool get isDarkMode => _isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : themeBackground,
      appBar: AppBar(
        title: Text(
          _selectedLanguage == 'ms' ? 'Tetapan' : 'Settings',
          style: const TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
          ),
        ),
        backgroundColor: themePrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Switcher
          ListTile(
            leading: Icon(Icons.language, color: themeAccent),
            title: Text(
              _selectedLanguage == 'ms' ? 'Bahasa' : 'Language',
              style: const TextStyle(fontFamily: fontFamily),
            ),
            subtitle: Text(
              _languageLabel(_selectedLanguage),
              style: const TextStyle(fontFamily: fontFamily),
            ),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              style: const TextStyle(fontFamily: fontFamily, color: Colors.black),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(fontFamily: fontFamily))),
                DropdownMenuItem(value: 'ms', child: Text('Bahasa Melayu', style: TextStyle(fontFamily: fontFamily))),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  widget.onLanguageChanged(value);
                }
              },
            ),
          ),

          const Divider(),

          // Dark Mode Toggle
          SwitchListTile(
            secondary: Icon(Icons.brightness_6, color: themeAccent),
            title: Text(
              _selectedLanguage == 'ms' ? 'Mod Gelap' : 'Dark Mode',
              style: TextStyle(
                fontFamily: fontFamily,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: isDarkMode,
            activeColor: themePrimary,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
              widget.onDarkModeChanged(value);
            },
          ),

          const Divider(),

          // User Account
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/budak.jpg'), // Replace with user image
            ),
            title: Text(
              _selectedLanguage == 'ms' ? 'Akaun Pengguna' : 'User Account',
              style: const TextStyle(fontFamily: fontFamily),
            ),
            subtitle: Text(
              _username,
              style: const TextStyle(fontFamily: fontFamily),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: themeAccent),
              onPressed: () {
                _showUsernameDialog();
              },
            ),
          ),

          const SizedBox(height: 20),


          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            label: Text(
              _selectedLanguage == 'ms' ? 'Padam Akaun' : 'Delete Account',
              style: const TextStyle(color: Colors.red, fontFamily: fontFamily),
            ),
            onPressed: () {
              // Implement account deletion logic
            },
          ),
        ],
      ),
    );
  }

  void _showUsernameDialog() {
    TextEditingController controller = TextEditingController(text: _username);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : themeBackground,
          title: Text(
            _selectedLanguage == 'ms' ? 'Tukar Nama' : 'Change Name',
            style: const TextStyle(fontFamily: fontFamily, color: Colors.black),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: _selectedLanguage == 'ms' ? 'Nama Baharu' : 'New Name',
              labelStyle: const TextStyle(fontFamily: fontFamily),
            ),
            style: const TextStyle(fontFamily: fontFamily),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                _selectedLanguage == 'ms' ? 'Batal' : 'Cancel',
                style: const TextStyle(fontFamily: fontFamily),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themePrimary,
                textStyle: const TextStyle(fontFamily: fontFamily),
              ),
              onPressed: () {
                setState(() {
                  _username = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text(
                _selectedLanguage == 'ms' ? 'Simpan' : 'Save',
                style: const TextStyle(fontFamily: fontFamily, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
