import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login.dart';

/// Sign Up Screen for Study Buddy app
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Animation controllers for bee images
  late AnimationController _animationController;
  late Animation<double> _leftBeeXAnimation;
  late Animation<double> _leftBeeYAnimation;
  late Animation<double> _rightBeeXAnimation;
  late Animation<double> _rightBeeYAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
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
    // Dispose controllers
    _animationController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Handles sign up logic and shows a snackbar
  void _signUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Account created for ${usernameController.text}!'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
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
                        // Left animated bee
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
                        // Right animated bee
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
                  // Animated title text
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Create your Study Buddy account!',
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
                  // Sign up form container
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Username field
                          TextFormField(
                            controller: usernameController,
                            decoration: _inputDecoration('Username'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter your username'
                                : null,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'AlfaSlabOne',
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Email field
                          TextFormField(
                            controller: emailController,
                            decoration: _inputDecoration('Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value == null || !value.contains('@')
                                ? 'Enter a valid email'
                                : null,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'AlfaSlabOne',
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Password field with visibility toggle
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            decoration: _inputDecoration('Password').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.brown,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) => value == null || value.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'AlfaSlabOne',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Sign Up button
                          ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'AlfaSlabOne',
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Login navigation button
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              'Already have an account? Login',
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
