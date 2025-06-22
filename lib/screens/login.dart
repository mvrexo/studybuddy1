import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dashboard.dart';

/// LoginScreen displays the login form with animated bees and logo.
class LoginScreen extends StatefulWidget {
  final bool showLogoutMessage;
  const LoginScreen({super.key, this.showLogoutMessage = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  // Controllers for email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility toggle
  bool _obscurePassword = true;

  // Animation controllers for bee movement
  late AnimationController _animationController;
  late Animation<double> _leftBeeXAnimation;
  late Animation<double> _leftBeeYAnimation;
  late Animation<double> _rightBeeXAnimation;
  late Animation<double> _rightBeeYAnimation;

  @override
  void initState() {
    super.initState();

    // Show logout message if needed
    if (widget.showLogoutMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Log out successfully')),
        );
      });
    }

    // Initialize animation controller for bees
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Bee movement animations
    _leftBeeXAnimation = Tween<double>(begin: -60, end: 160).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _leftBeeYAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutSine),
    );
    _rightBeeXAnimation = Tween<double>(begin: -60, end: 160).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _rightBeeYAnimation = Tween<double>(begin: 10, end: -10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Handles login logic and navigates to DashboardScreen
  void _handleLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(email: emailController.text),
      ),
    );
  }

  /// Navigates to forgot password screen
  void _handleForgotPassword() {
    Navigator.pushNamed(context, '/forgot_password');
  }

  /// Returns input decoration for text fields
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color.fromARGB(255, 71, 42, 32),
        fontWeight: FontWeight.w600,
        fontFamily: 'AlfaSlabOne',
      ),
      filled: true,
      fillColor: const Color(0xFFFFF5E1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/awan.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Blur effect overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo and animated bees
                  SizedBox(
                    height: 150,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Logo
                        Center(
                          child: SizedBox(
                            width: 800,
                            height: 270,
                            child: Image.asset(
                              'assets/logobee.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Left bee animation
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Positioned(
                              top: -50 + _leftBeeYAnimation.value,
                              left: _leftBeeXAnimation.value,
                              child: Transform.rotate(
                                angle: 0.1,
                                child: Image.asset(
                                  'assets/bee.gif',
                                  height: 80,
                                ),
                              ),
                            );
                          },
                        ),
                        // Right bee animation
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Positioned(
                              top: -50 + _rightBeeYAnimation.value,
                              right: _rightBeeXAnimation.value,
                              child: Transform.rotate(
                                angle: -0.1,
                                child: Image.asset(
                                  'assets/bee.gif',
                                  height: 80,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Animated welcome text
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Let’s start learning with Study Buddy!',
                        textStyle: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.brown,
                        ),
                        speed: const Duration(milliseconds: 70),
                      ),
                    ],
                    repeatForever: true,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                    isRepeatingAnimation: true,
                  ),
                  const SizedBox(height: 20),
                  // Login form container
                  Container(
                    width: 340,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Email field
                        TextField(
                          controller: emailController,
                          decoration: _inputDecoration('Email'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'AlfaSlabOne',
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Password field with visibility toggle
                        TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: _inputDecoration('Password').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.brown,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'AlfaSlabOne',
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Login button
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'AlfaSlabOne',
                            ),
                          ),
                        ),
                        // Forgot password button
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextButton.icon(
                              onPressed: _handleForgotPassword,
                              icon: const Icon(
                                Icons.lock_outline,
                                size: 14,
                                color: Colors.brown,
                              ),
                              label: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.brown,
                                  fontFamily: 'AlfaSlabOne',
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Register button
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text(
                            "Register Now",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'AlfaSlabOne',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
