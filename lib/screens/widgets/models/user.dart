class User {
  String username;
  String email;
  String password;
  int age;
  String parentName;
  String parentContact;
  UserProgress progress;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.age,
    required this.parentName,
    required this.parentContact,
    required this.progress,
  });
}

class UserProgress {
  int level;
  List<String> lessonsCompleted;

  UserProgress({
    required this.level,
    required this.lessonsCompleted,
  });
}