import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onUsernameChanged;
  final VoidCallback onDeleteAccount;

  const SettingsScreen({
    super.key,
    required this.username,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.onUsernameChanged,
    required this.onDeleteAccount,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final Color themePrimary = Colors.deepOrangeAccent;
  static final Color themeBackground = const Color(0xFFFFF5E1);
  static final Color themeAccent = const Color(0xFF8B4513);
  static final Color darkModeBackground = const Color(0xFF23272F);
  static const String fontFamily = 'AlfaSlabOne';

  late String _selectedLanguage;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
    _isDarkMode = widget.isDarkMode;
  }

  bool get isDarkMode => _isDarkMode;

  String _languageLabel(String langCode) =>
      langCode == 'ms' ? 'Bahasa Melayu' : 'English';

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    const double iconSize = 28.0;

    return Scaffold(
      backgroundColor: isDarkMode ? darkModeBackground : themeBackground,
      appBar: AppBar(
        title: Text(
          _selectedLanguage == 'ms' ? 'Tetapan' : 'Settings',
          style: TextStyle(fontFamily: fontFamily, color: Colors.white),
        ),
        backgroundColor: themePrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section (navigate to new page)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: themeAccent,
              radius: iconSize / 2,
              child: Icon(Icons.person, color: Colors.white, size: iconSize * 0.75),
            ),
            title: Text(
              _selectedLanguage == 'ms' ? 'Akaun' : 'Account',
              style: TextStyle(fontFamily: fontFamily, color: textColor),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AccountPage(
                    isDarkMode: isDarkMode,
                    language: _selectedLanguage,
                    onDeleteAccount: widget.onDeleteAccount,
                  ),
                ),
              );
            },
          ),

          const Divider(),

          // Language Switcher (navigate to new page)
          ListTile(
            leading: Icon(Icons.language, color: themeAccent, size: iconSize),
            title: Text(
              _selectedLanguage == 'ms' ? 'Bahasa' : 'Language',
              style: TextStyle(fontFamily: fontFamily, color: textColor),
            ),
            subtitle: Text(
              _languageLabel(_selectedLanguage),
              style: TextStyle(fontFamily: fontFamily, color: textColor),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () async {
              final selected = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (_) => LanguagePage(
                    isDarkMode: isDarkMode,
                    currentLanguage: _selectedLanguage,
                  ),
                ),
              );
              if (selected != null && selected != _selectedLanguage) {
                setState(() {
                  _selectedLanguage = selected;
                });
                widget.onLanguageChanged(selected);
              }
            },
          ),

          const Divider(),

          // Dark Mode Toggle
          SwitchListTile(
            secondary: Icon(Icons.brightness_6, color: themeAccent, size: iconSize),
            title: Text(
              _selectedLanguage == 'ms' ? 'Mod Gelap' : 'Dark Mode',
              style: TextStyle(fontFamily: fontFamily, color: textColor),
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

          // App Info Section
          ListTile(
            leading: Icon(Icons.info, color: themeAccent, size: iconSize),
            title: Text(
              _selectedLanguage == 'ms' ? 'Versi Aplikasi' : 'App Version',
              style: TextStyle(fontFamily: fontFamily, color: textColor),
            ),
            subtitle: Text(
              '1.0.0',
              style: TextStyle(fontFamily: fontFamily, color: textColor),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  final bool isDarkMode;
  final String language;
  final VoidCallback onDeleteAccount;

  static final Color themePrimary = Colors.deepOrangeAccent;
  static final Color themeBackground = const Color(0xFFFFF5E1);
  static final Color darkModeBackground = const Color(0xFF23272F);
  static const String fontFamily = 'AlfaSlabOne';

  const AccountPage({
    super.key,
    required this.isDarkMode,
    required this.language,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? darkModeBackground : themeBackground,
      appBar: AppBar(
        backgroundColor: themePrimary,
        title: Text(
          language == 'ms' ? 'Akaun' : 'Account',
          style: const TextStyle(fontFamily: fontFamily, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            onPressed: () async {
              final confirmed = await _showConfirmDeleteDialog(context);
              if (confirmed) {
                onDeleteAccount();
              }
            },
            label: Text(
              language == 'ms' ? 'Padam Akaun Saya' : 'Delete My Account',
              style: const TextStyle(
                  fontFamily: fontFamily, color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmDeleteDialog(BuildContext context) async {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor:
                isDarkMode ? darkModeBackground : themeBackground,
            title: Text(
              language == 'ms' ? 'Pengesahan' : 'Confirmation',
              style: TextStyle(fontFamily: fontFamily, color: textColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language == 'ms'
                      ? 'Adakah anda pasti mahu memadam akaun ini?'
                      : 'Are you sure you want to delete your account?',
                  style: TextStyle(fontFamily: fontFamily, color: textColor),
                ),
                const SizedBox(height: 12),
                Text(
                  language == 'ms'
                      ? 'Memadam akaun anda akan memadam maklumat akaun dan gambar profil anda.'
                      : 'Deleting your account will remove your account info and profile photo.',
                  style: TextStyle(
                      fontFamily: fontFamily,
                      color: textColor,
                      fontSize: 13),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  language == 'ms' ? 'Tidak' : 'No',
                  style: const TextStyle(fontFamily: fontFamily),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  language == 'ms' ? 'Ya' : 'Yes',
                  style: const TextStyle(
                      fontFamily: fontFamily, color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class LanguagePage extends StatelessWidget {
  final bool isDarkMode;
  final String currentLanguage;

  static final Color themeBackground = const Color(0xFFFFF5E1);
  static final Color darkModeBackground = const Color(0xFF23272F);
  static final Color themePrimary = Colors.deepOrangeAccent;
  static const String fontFamily = 'AlfaSlabOne';

  const LanguagePage({
    super.key,
    required this.isDarkMode,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: isDarkMode ? darkModeBackground : themeBackground,
      appBar: AppBar(
        backgroundColor: themePrimary,
        title: Text(
          currentLanguage == 'ms' ? 'Bahasa' : 'Language',
          style: const TextStyle(fontFamily: fontFamily, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          RadioListTile<String>(
            value: 'en',
            groupValue: currentLanguage,
            title: const Text('English', style: TextStyle(fontFamily: fontFamily)),
            activeColor: themePrimary,
            onChanged: (value) {
              Navigator.pop(context, value);
            },
          ),
          RadioListTile<String>(
            value: 'ms',
            groupValue: currentLanguage,
            title: const Text('Bahasa Melayu', style: TextStyle(fontFamily: fontFamily)),
            activeColor: themePrimary,
            onChanged: (value) {
              Navigator.pop(context, value);
            },
          ),
        ],
      ),
    );
  }
}
