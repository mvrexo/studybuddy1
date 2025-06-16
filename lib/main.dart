import 'package:flutter/material.dart';
import 'package:studdybuddy1/screens/login.dart';
import 'package:studdybuddy1/screens/sign_up.dart';
import 'package:studdybuddy1/screens/splash_screen.dart';
import 'package:studdybuddy1/screens/forgot_password.dart';
import 'calendar_screen.dart'; // Make sure this file has a proper widget class

final Color themePrimary = Colors.deepOrangeAccent;
final Color themeBackground = const Color(0xFFFFF5E1); // light cream
final Color themeAccent = const Color(0xFF8B4513); // brown tone
final String fontFamily = 'AlfaSlabOne';

void main() {
  runApp(const StudyBuddyApp());
}

class StudyBuddyApp extends StatelessWidget {
  const StudyBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themePrimary,
          primary: themePrimary,
          secondary: themePrimary,
          // ignore: deprecated_member_use
          background: themeBackground,
        ),
        scaffoldBackgroundColor: themeBackground,
        fontFamily: fontFamily,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeAccent,
            fontFamily: fontFamily,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: themeAccent,
            fontFamily: fontFamily,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: themePrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: fontFamily,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/calendar': (context) => const CalendarScreen(),
      },
    );
  }
}
