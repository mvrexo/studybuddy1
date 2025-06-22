import 'dart:async';
import 'package:flutter/material.dart';

/// SplashScreen widget displays an animated logo over a background image,
/// then navigates to the login screen after a delay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for logo animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Bounce (scale) animation for logo
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    // Fade-in animation for logo
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animations
    _controller.forward();

    // Navigate to login screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    // Dispose animation controller to free resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image fills entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/putih1.jpg', // Background image with logo and white bg
              fit: BoxFit.cover,
            ),
          ),
          // Centered logo with bounce + fade-in animation and responsive size
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Logo size is 60% of screen height
                final logoSize = constraints.maxHeight * 0.6;
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Image.asset(
                      'assets/logobee.gif',
                      height: logoSize,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
