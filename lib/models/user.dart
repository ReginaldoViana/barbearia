class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int age;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.age,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'age': age,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      age: json['age'],
      password: json['password'],
    );
  }
}
