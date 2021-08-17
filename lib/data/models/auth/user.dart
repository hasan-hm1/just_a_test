import 'dart:convert';

class User {
  final String email;
  final String password;
  final String type;

  const User({required this.email,required  this.password,required  this.type});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'type': type,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
