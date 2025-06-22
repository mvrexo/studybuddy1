import 'package:flutter/material.dart';

/// NotificationsScreen displays a list of notifications to the user.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Notification: Welcome message
                  ListTile(
                    leading: Icon(
                      Icons.info,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      'Welcome to Study Buddy!',
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Thank you for joining us.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  // Notification: Upcoming lesson reminder
                  ListTile(
                    leading: Icon(
                      Icons.event,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      'Upcoming Lesson Reminder',
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Don\'t forget your math lesson tomorrow at 10 AM.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  // Add more notification items here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
