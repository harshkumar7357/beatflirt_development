import 'dart:convert';

class NewUserResponse {
  final String status;
  final String totalUserCount;
  final List<UserModel> data;

  NewUserResponse({
    required this.status,
    required this.totalUserCount,
    required this.data,
  });

  factory NewUserResponse.fromJson(Map<String, dynamic> json) {
    return NewUserResponse(
      status: json['status'] ?? '',
      totalUserCount: json['total_user_count'] ?? '0',
      data: (json['data'] as List?)
          ?.map((i) => UserModel.fromJson(i))
          .toList() ??
          [],
    );
  }
}

class UserModel {
  final String id;
  final String username;
  final String genderProfileType;
  final String cityName;
  final int age;
  final String aiMatchScore;
  final String aiInsight;
  final String formattedAddress;
  final int totalDistance;
  final String profileImage;

  UserModel({
    required this.id,
    required this.username,
    required this.genderProfileType,
    required this.cityName,
    required this.age,
    required this.aiMatchScore,
    required this.aiInsight,
    required this.formattedAddress,
    required this.totalDistance,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['image'] != null && json['image'].isNotEmpty) {
      imageUrl = json['image'][0]['profile_image'] ?? '';
    }

    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      genderProfileType: json['gender_profile_type'] ?? '',
      cityName: json['city_name'] ?? '',
      age: json['age'] is int ? json['age'] : int.tryParse(json['age'].toString()) ?? 0,
      aiMatchScore: json['ai_match_score'] ?? '0',
      aiInsight: json['ai_insight'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      totalDistance: json['total_distance'] is int
          ? json['total_distance']
          : int.tryParse(json['total_distance'].toString()) ?? 0,
      profileImage: imageUrl,
    );
  }
}
