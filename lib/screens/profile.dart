import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; // Make sure this exists

final Color themePrimary = Colors.deepOrangeAccent;
final Color themeBackground = const Color(0xFFFFF5E1); // light cream
final Color themeAccent = const Color(0xFF8B4513); // brown tone
final String fontFamily = 'AlfaSlabOne';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required String email});

  @override
  Widget build(BuildContext context) {
    double progress = 0.6; // Example progress value (60%)

    return Scaffold(
      backgroundColor: themeBackground,
      appBar: AppBar(
      title: Text(
        'Profile',
        style: TextStyle(
        fontFamily: fontFamily,
        color: Colors.white,
        ),
      ),
      backgroundColor: themePrimary, // Set to orange primary
      actions: [
        IconButton(
        icon: const Icon(Icons.edit),
        color: Colors.white,
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditProfileScreen(initialData: {},)),
          );
        },
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white), // Back icon is white
      elevation: 0,
      ),
      body: Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
        // Avatar
        Center(
          child: CircleAvatar(
          radius: 50,
          backgroundImage: const AssetImage('assets/budak.jpg'),
          backgroundColor: themePrimary.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: 20),

            // Learning Progress
            _progressSection(progress),

            const SizedBox(height: 30),

            // Student Info
            _infoSection(
              title: 'Student Info',
              items: [
                _infoRow(Icons.child_care, 'Name:', 'Amanda Sopeah'),
                _infoRow(Icons.perm_identity, 'Student ID:', 'STD1023'),
                _infoRow(Icons.cake, 'Age:', '8'),
                _infoRow(Icons.female, 'Gender:', 'Female'),
                _infoRow(Icons.home, 'Address:', '123 Happy Street, Kids City'),
                _infoRow(Icons.school, 'Class:', '2nd Grade'),
              ],
            ),

            const SizedBox(height: 20),

            // Parent Info
            _infoSection(
              title: 'Parent Info',
              items: [
                _infoRow(Icons.person, 'Father Name:', 'John Sopeah'),
                _infoRow(Icons.work, 'Father Occupation:', 'Engineer'),
                _infoRow(Icons.phone, 'Contact:', '+1 123 456 7890'),
                _infoRow(Icons.email, 'Email:', 'john.sopeah@gmail.com'),
                _infoRow(Icons.person_outline, 'Mother Name:', 'Maria Sopeah'),
                _infoRow(Icons.work_outline, 'Mother Occupation:', 'Teacher'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressSection(double progress) {
    int filledStars = (progress * 5).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Learning Progress',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: themePrimary,
            fontFamily: fontFamily,
          ),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: themePrimary.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(themePrimary),
        ),
        const SizedBox(height: 10),

        // Stars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              index < filledStars ? Icons.star : Icons.star_border,
              color: themePrimary,
              size: 28,
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          '${(progress * 100).toStringAsFixed(0)}% completed',
          style: TextStyle(
            color: themeAccent,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _infoSection({required String title, required List<Widget> items}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themePrimary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: themePrimary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themePrimary,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: themePrimary),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
              color: themeAccent,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: fontFamily,
                color: themeAccent.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
