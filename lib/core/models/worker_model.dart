import 'dart:convert';

import 'package:khedma/core/enums/worker_status.dart';

class WorkerModel {
  final String id;
  final String name;
  final String profession;
  final String specialty;
  final int experience;
  final String area;
  final int price;
  final String phone;
  final String bio;
  final double rating;
  final WorkerStatus status;
  final String avatar;
  final bool isAvailable;
  final List<String> portfolioImages;
  final List<Map<String, dynamic>> reviews;

  WorkerModel({
    required this.id,
    required this.name,
    required this.profession,
    required this.specialty,
    required this.experience,
    required this.area,
    required this.price,
    required this.phone,
    required this.bio,
    required this.rating,
    required this.status,
    required this.avatar,
    required this.isAvailable,
    required this.portfolioImages,
    required this.reviews,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      profession: json['job'] ?? '',
      specialty: json['specialty'] ?? '',
      experience: (json['experience'] ?? 0) as int,
      area: json['area'] ?? '',
      price: (json['price'] ?? 0) as int,
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      avatar: json['avatar'] ?? '',
      isAvailable: json['available'] ?? false,
      status: WorkerStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => WorkerStatus.pending,
      ),
      portfolioImages: _parseImages(json['portfolioImages']),
      reviews: _parseReviews(json['reviews']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'job': profession,
      'specialty': specialty,
      'experience': experience,
      'area': area,
      'price': price,
      'phone': phone,
      'bio': bio,
      'rating': rating,
      'status': status.name,
      'avatar': avatar,
      'available': isAvailable,
      'portfolioImages': portfolioImages,
      'reviews': reviews,
    };
  }

  static List<String> _parseImages(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value);
    return List<String>.from(jsonDecode(value));
  }

  static List<Map<String, dynamic>> _parseReviews(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return List<Map<String, dynamic>>.from(value);
    }
    return List<Map<String, dynamic>>.from(jsonDecode(value));
  }
}
