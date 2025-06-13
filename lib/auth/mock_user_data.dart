class MockUserData {
  static final List<Map<String, String>> _students = [
    {
      'email': 'student1@example.com',
      'password': 'password123',
    },
    {
      'email': 'student2@example.com',
      'password': '123456',
    },
  ];

  static final List<Map<String, String>> _parents = [
    {
      'email': 'parent1@example.com',
      'password': 'parentpass',
    },
    {
      'email': 'parent2@example.com',
      'password': 'mypassword',
    },
  ];

  static bool validateUser(String email, String password, String role) {
    List<Map<String, String>> users =
        role == 'Student' ? _students : _parents;

    for (var user in users) {
      if (user['email'] == email && user['password'] == password) {
        return true;
      }
    }

    return false;
  }
}
