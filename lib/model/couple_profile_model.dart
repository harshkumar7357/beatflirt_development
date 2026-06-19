class CoupleProfileModel {
  final String id;
  final String coupleName;
  final PartnerProfile? partner1;
  final PartnerProfile? partner2;
  final String? bio;
  final List<String> interests;
  final List<String> photos;
  final List<String> videos;
  final List<String> lookingFor;
  final int ageDifference;
  final String? location;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final bool isVerified;
  final bool isPremium;
  final bool isOnline;
  final DateTime? lastActive;
  final List<dynamic> upcomingEvents;
  final int mutualConnections;
  final double? compatibilityScore;
  final String? profileStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CoupleProfileModel({
    required this.id,
    required this.coupleName,
    this.partner1,
    this.partner2,
    this.bio,
    this.interests = const [],
    this.photos = const [],
    this.videos = const [],
    this.lookingFor = const [],
    this.ageDifference = 0,
    this.location,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.isVerified = false,
    this.isPremium = false,
    this.isOnline = false,
    this.lastActive,
    this.upcomingEvents = const [],
    this.mutualConnections = 0,
    this.compatibilityScore,
    this.profileStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory CoupleProfileModel.fromJson(Map<String, dynamic> json) {
    return CoupleProfileModel(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      coupleName: json['couple_name'] ?? json['name'] ?? 'Couple',
      partner1: json['partner_1'] != null || json['partner1'] != null
          ? PartnerProfile.fromJson(json['partner_1'] ?? json['partner1'])
          : null,
      partner2: json['partner_2'] != null || json['partner2'] != null
          ? PartnerProfile.fromJson(json['partner_2'] ?? json['partner2'])
          : null,
      bio: json['bio'] ?? json['description'] ?? json['about'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : json['interests_list'] != null
              ? List<String>.from(json['interests_list'])
              : [],
      photos: json['photos'] != null
          ? List<String>.from(json['photos'])
          : json['images'] != null
              ? List<String>.from(json['images'])
              : [],
      videos: json['videos'] != null
          ? List<String>.from(json['videos'])
          : [],
      lookingFor: json['looking_for'] != null
          ? List<String>.from(json['looking_for'])
          : json['lookingFor'] != null
              ? List<String>.from(json['lookingFor'])
              : [],
      ageDifference: json['age_difference'] ?? json['ageDifference'] ?? 0,
      location: json['location'] ?? json['address'],
      city: json['city'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      isPremium: json['is_premium'] ?? json['isPremium'] ?? false,
      isOnline: json['is_online'] ?? json['isOnline'] ?? false,
      lastActive: json['last_active'] != null
          ? DateTime.tryParse(json['last_active'].toString())
          : null,
      upcomingEvents: json['upcoming_events'] ?? json['events'] ?? [],
      mutualConnections: json['mutual_connections'] ?? json['mutualConnections'] ?? 0,
      compatibilityScore: json['compatibility_score']?.toDouble() ?? json['compatibilityScore']?.toDouble(),
      profileStatus: json['profile_status'] ?? json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couple_name': coupleName,
      'partner_1': partner1?.toJson(),
      'partner_2': partner2?.toJson(),
      'bio': bio,
      'interests': interests,
      'photos': photos,
      'videos': videos,
      'looking_for': lookingFor,
      'age_difference': ageDifference,
      'location': location,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'is_verified': isVerified,
      'is_premium': isPremium,
      'is_online': isOnline,
      'last_active': lastActive?.toIso8601String(),
      'upcoming_events': upcomingEvents,
      'mutual_connections': mutualConnections,
      'compatibility_score': compatibilityScore,
      'profile_status': profileStatus,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CoupleProfileModel copyWith({
    String? id,
    String? coupleName,
    PartnerProfile? partner1,
    PartnerProfile? partner2,
    String? bio,
    List<String>? interests,
    List<String>? photos,
    List<String>? videos,
    List<String>? lookingFor,
    int? ageDifference,
    String? location,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    bool? isVerified,
    bool? isPremium,
    bool? isOnline,
    DateTime? lastActive,
    List<dynamic>? upcomingEvents,
    int? mutualConnections,
    double? compatibilityScore,
    String? profileStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoupleProfileModel(
      id: id ?? this.id,
      coupleName: coupleName ?? this.coupleName,
      partner1: partner1 ?? this.partner1,
      partner2: partner2 ?? this.partner2,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      photos: photos ?? this.photos,
      videos: videos ?? this.videos,
      lookingFor: lookingFor ?? this.lookingFor,
      ageDifference: ageDifference ?? this.ageDifference,
      location: location ?? this.location,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      mutualConnections: mutualConnections ?? this.mutualConnections,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      profileStatus: profileStatus ?? this.profileStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PartnerProfile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String? profilePhoto;
  final String? bio;
  final List<String> interests;
  final bool isVerified;
  final bool isOnline;
  final String? zodiacSign;
  final String? occupation;
  final String? education;
  final String? height;
  final String? bodyType;
  final String? ethnicity;

  PartnerProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.profilePhoto,
    this.bio,
    this.interests = const [],
    this.isVerified = false,
    this.isOnline = false,
    this.zodiacSign,
    this.occupation,
    this.education,
    this.height,
    this.bodyType,
    this.ethnicity,
  });

  factory PartnerProfile.fromJson(Map<String, dynamic> json) {
    return PartnerProfile(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      name: json['name'] ?? json['first_name'] ?? 'Partner',
      age: json['age'] ?? json['user_age'] ?? 0,
      gender: json['gender'] ?? 'Not specified',
      profilePhoto: json['profile_photo'] ?? json['profilePhoto'] ?? json['photo'] ?? json['avatar'],
      bio: json['bio'] ?? json['description'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : [],
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      isOnline: json['is_online'] ?? json['isOnline'] ?? false,
      zodiacSign: json['zodiac_sign'] ?? json['zodiacSign'],
      occupation: json['occupation'],
      education: json['education'],
      height: json['height'],
      bodyType: json['body_type'] ?? json['bodyType'],
      ethnicity: json['ethnicity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'profile_photo': profilePhoto,
      'bio': bio,
      'interests': interests,
      'is_verified': isVerified,
      'is_online': isOnline,
      'zodiac_sign': zodiacSign,
      'occupation': occupation,
      'education': education,
      'height': height,
      'body_type': bodyType,
      'ethnicity': ethnicity,
    };
  }

  PartnerProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? profilePhoto,
    String? bio,
    List<String>? interests,
    bool? isVerified,
    bool? isOnline,
    String? zodiacSign,
    String? occupation,
    String? education,
    String? height,
    String? bodyType,
    String? ethnicity,
  }) {
    return PartnerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      height: height ?? this.height,
      bodyType: bodyType ?? this.bodyType,
      ethnicity: ethnicity ?? this.ethnicity,
    );
  }
}