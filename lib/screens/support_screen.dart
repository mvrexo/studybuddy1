import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & Help'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Frequently Asked Questions (FAQ)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 16),
            _buildFAQItem('How do I use flashcards?', 'Go to the Flashcards section and tap a card to flip it.'),
            _buildFAQItem('Can I reset my progress?', 'Yes, go to the Progress Tracker and select "Reset Progress".'),
            _buildFAQItem('How do I change language?', 'Open Settings and choose your preferred language.'),
            const SizedBox(height: 30),
            const Text(
              'Need More Help?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.deepOrange),
              title: const Text('Email us at support@studybuddy.com'),
              onTap: () {}, // you can integrate mailto: if needed
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.deepOrange),
              title: Text('Call us at +6012-3456789'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
