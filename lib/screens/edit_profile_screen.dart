import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, String> initialData;
  const EditProfileScreen({super.key, required this.initialData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController studentNameController;
  late TextEditingController studentIdController;
  late TextEditingController studentAgeController;
  late TextEditingController studentAddressController;

  late TextEditingController parentNameController;
  late TextEditingController parentOccupationController;
  late TextEditingController parentPhoneController;
  late TextEditingController parentEmailController;

  String selectedGender = 'Female';
  String selectedClass = '2nd Grade';

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> classOptions = ['1st Grade', '2nd Grade', '3rd Grade'];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    studentNameController = TextEditingController(text: data['studentName']);
    studentIdController = TextEditingController(text: data['studentId']);
    studentAgeController = TextEditingController(text: data['studentAge']);
    studentAddressController = TextEditingController(text: data['studentAddress']);
    selectedGender = data['studentGender'] ?? 'Female';
    selectedClass = data['studentClass'] ?? '2nd Grade';

    parentNameController = TextEditingController(text: data['parentName']);
    parentOccupationController = TextEditingController(text: data['parentOccupation']);
    parentPhoneController = TextEditingController(text: data['parentPhone']);
    parentEmailController = TextEditingController(text: data['parentEmail']);
  }

  @override
  void dispose() {
    studentNameController.dispose();
    studentIdController.dispose();
    studentAgeController.dispose();
    studentAddressController.dispose();
    parentNameController.dispose();
    parentOccupationController.dispose();
    parentPhoneController.dispose();
    parentEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.orange[200],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _sectionTitle('Student Info'),
            _buildTextField('Name', studentNameController, textCapitalization: TextCapitalization.words),
            _buildTextField('Student ID', studentIdController),
            _buildTextField('Age', studentAgeController, keyboardType: TextInputType.number),
            _buildDropdownField('Gender', selectedGender, genderOptions, (val) {
              setState(() => selectedGender = val!);
            }),
            _buildTextField('Address', studentAddressController),
            _buildDropdownField('Class', selectedClass, classOptions, (val) {
              setState(() => selectedClass = val!);
            }),

            const SizedBox(height: 20),
            _sectionTitle('Parent Info'),
            _buildTextField('Name', parentNameController, textCapitalization: TextCapitalization.words),
            _buildTextField('Occupation', parentOccupationController),
            _buildTextField('Phone', parentPhoneController, keyboardType: TextInputType.phone),
            _buildTextField('Email', parentEmailController, keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final updatedData = {
                    'studentName': studentNameController.text,
                    'studentId': studentIdController.text,
                    'studentAge': studentAgeController.text,
                    'studentGender': selectedGender,
                    'studentAddress': studentAddressController.text,
                    'studentClass': selectedClass,
                    'parentName': parentNameController.text,
                    'parentOccupation': parentOccupationController.text,
                    'parentPhone': parentPhoneController.text,
                    'parentEmail': parentEmailController.text,
                  };

                  Navigator.pop(context, updatedData);
                },
                child: const Text('Save', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, TextCapitalization textCapitalization = TextCapitalization.none}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.orange[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.orange[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
      ),
    );
  }
}
