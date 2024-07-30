class User {
  int id;
  String username;
  String email;
  String? firstName;
  String? lastName;
  bool isStaff;

  User(this.id, this.username, this.email, this.firstName, this.lastName,
      this.isStaff);

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      data['id'] as int,
      data['username'] as String,
      data['email'] as String,
      data['first_name'] as String?,
      data['last_name'] as String?,
      data['is_staff'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['is_staff'] = isStaff;
    return data;
  }
}

final User initialUser = User(
  1,
  "test_user",
  "test@email.com",
  "Test",
  "User",
  false,
);
