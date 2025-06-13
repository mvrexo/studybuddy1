import 'package:flutter/material.dart';
import 'package:studdybuddy1/screens/login.dart';
import 'package:studdybuddy1/screens/sign_up.dart';
import 'package:studdybuddy1/screens/splash_screen.dart';
import 'package:studdybuddy1/screens/forgot_password.dart';
import 'calendar_screen.dart'; // Make sure this file has a proper widget class

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
          seedColor: Colors.orange,
          primary: Colors.orange,
          secondary: Colors.deepOrangeAccent,
          // ignore: deprecated_member_use
          background: const Color.fromARGB(255, 255, 248, 235),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF5E1),
        fontFamily: 'ComicSans',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 237, 190, 175),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 90, 50, 30),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 245, 139, 107),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
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
