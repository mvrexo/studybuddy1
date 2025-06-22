import 'dart:ui';
import 'package:flutter/material.dart';

/// Forgot Password Screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  /// Handles form submission and shows a snackbar
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Add your reset password logic here

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🔑 A new password has been sent to ${emailController.text}'),
          backgroundColor: Colors.deepOrangeAccent,
        ),
      );
      emailController.clear();
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
      // AppBar styled similarly to login
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontFamily: 'AlfaSlabOne'),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 139, 107),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background image (same as login)
          Positioned.fill(
            child: Image.asset(
              'assets/awan.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Blur overlay (same as login)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
          // Centered form card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(20),
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
                      // Instruction text
                      const Text(
                        'Enter your email to receive a new password.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AlfaSlabOne',
                          color: Color.fromARGB(255, 71, 42, 32),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      // Email input field
                      TextFormField(
                        controller: emailController,
                        decoration: _inputDecoration('Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || !value.contains('@')
                                ? 'Please enter a valid email'
                                : null,
                      ),
                      const SizedBox(height: 30),
                      // Submit button
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Send New Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'AlfaSlabOne',
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Back to login button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Back to login page
                        },
                        child: const Text(
                          'Back to Login',
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
            ),
          ),
        ],
      ),
    );
  }
}
