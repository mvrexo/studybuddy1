import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Your Notifications',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.deepOrange),
                    title: Text('Welcome to Study Buddy!'),
                    subtitle: Text('Thank you for joining us.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.event, color: Colors.deepOrange),
                    title: Text('Upcoming Lesson Reminder'),
                    subtitle: Text('Don\'t forget your math lesson tomorrow at 10 AM.'),
                  ),
                  // You can add more notification items here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
