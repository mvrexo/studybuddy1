import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ThemeMode currentThemeMode;
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.username,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguage;
  late ThemeMode _selectedThemeMode;
  String _username = '';
  String _languageLabel(String langCode) => langCode == 'ms' ? 'Bahasa Melayu' : 'English';

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
    _selectedThemeMode = widget.currentThemeMode;
    _username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedLanguage == 'ms' ? 'Tetapan' : 'Settings'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Switcher
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(_selectedLanguage == 'ms' ? 'Bahasa' : 'Language'),
            subtitle: Text(_languageLabel(_selectedLanguage)),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ms', child: Text('Bahasa Melayu')),
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

          // Theme Mode
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(_selectedLanguage == 'ms' ? 'Mod Tema' : 'Theme Mode'),
            subtitle: Column(
              children: ThemeMode.values.map((mode) {
                return RadioListTile<ThemeMode>(
                  title: Text(mode == ThemeMode.system
                      ? (_selectedLanguage == 'ms' ? 'Ikut Sistem' : 'System Default')
                      : mode == ThemeMode.dark
                          ? (_selectedLanguage == 'ms' ? 'Mod Gelap' : 'Dark Mode')
                          : (_selectedLanguage == 'ms' ? 'Mod Cerah' : 'Light Mode')),
                  value: mode,
                  groupValue: _selectedThemeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      setState(() {
                        _selectedThemeMode = value;
                      });
                      widget.onThemeModeChanged(value);
                    }
                  },
                );
              }).toList(),
            ),
          ),

          const Divider(),

          // User Account
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/default_avatar.png'), // Replace with user image
            ),
            title: Text(_selectedLanguage == 'ms' ? 'Akaun Pengguna' : 'User Account'),
            subtitle: Text(_username),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showUsernameDialog();
              },
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(_selectedLanguage == 'ms' ? 'Log Keluar' : 'Log Out'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              // Implement logout logic
            },
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            label: Text(
              _selectedLanguage == 'ms' ? 'Padam Akaun' : 'Delete Account',
              style: const TextStyle(color: Colors.red),
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
          title: Text(_selectedLanguage == 'ms' ? 'Tukar Nama' : 'Change Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: _selectedLanguage == 'ms' ? 'Nama Baharu' : 'New Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_selectedLanguage == 'ms' ? 'Batal' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _username = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text(_selectedLanguage == 'ms' ? 'Simpan' : 'Save'),
            ),
          ],
        );
      },
    );
  }
}
