import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String username;
  String password;
  String email;

  Login({
    this.username,
    this.password,
    this.email,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    username: json["username"],
    password: json["password"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "email": email,
  };
}