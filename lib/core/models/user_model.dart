import 'dart:convert';

import 'package:khedma/core/enums/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final UserRole role;
  final List<String> favorites;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.role,
    required this.favorites,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'].toString().toLowerCase(),
        orElse: () => UserRole.customer,
      ),
      favorites: List<String>.from(
        jsonDecode(json['favorites'] ?? '[]'),
      ),
    );
  }
}
