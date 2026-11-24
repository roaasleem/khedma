import 'dart:convert';

import 'package:khedma/core/enums/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String password;
  final UserRole role;
  final List<String> favorites;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.password,
    required this.role,
    required this.favorites,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final favoritesData = json['favorites'];

    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      password: json['password'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'].toString().toLowerCase(),
        orElse: () => UserRole.customer,
      ),
      favorites: favoritesData is List
          ? List<String>.from(favoritesData)
          : favoritesData is String
          ? List<String>.from(jsonDecode(favoritesData))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'password': password,
      'role': role.name,
      'favorites': favorites,
    };
  }
}
