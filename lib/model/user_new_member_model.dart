class ProfileImage {
  final String showProfileImage; // "1" or "0"
  final String profileImage;
  final String dummyProfileImage;

  ProfileImage({
    required this.showProfileImage,
    required this.profileImage,
    required this.dummyProfileImage,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      showProfileImage: json['show_profile_image'] ?? '0',
      profileImage: json['profile_image'] ?? '',
      dummyProfileImage: json['dummy_profile_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_profile_image': showProfileImage,
      'profile_image': profileImage,
      'dummy_profile_image': dummyProfileImage,
    };
  }
}

class ProfileVideo {
  final String id;
  final String videoUrl;

  ProfileVideo({
    required this.id,
    required this.videoUrl,
  });

  factory ProfileVideo.fromJson(Map<String, dynamic> json) {
    return ProfileVideo(
      id: json['id']?.toString() ?? '',
      videoUrl: json['video_url'] ?? json['video'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_url': videoUrl,
    };
  }
}

class UserModel {
  final String id;
  final String username;
  final String profileType; // "single" or "couple"
  final String genderProfileType; // e.g., "Couple (F/M)"
  final String showOnlineStatus; // "1" or "0"
  final String lastLogin; // timestamp or string
  final String showAge; // "1" or "0"
  final String age;
  final String age2; // partner age for couples
  final String? aiMatchScore; // e.g., "90"
  final String? aiInsight; // text insight
  final String formattedAddress;
  final String totalDistance;
  final String distance; // e.g., "miles" or "km"
  final List<ProfileImage> images;
  final List<ProfileVideo> videos;
  final String showGender; // "1" or "0"
  final String showLocation; // "1" or "0"
  final String showChatIcon; // "1" or "0"
  final int likesCount;
  final int friendCount;

  // Swingers attributes
  final String coupleMaleFemaleSwingers;
  final String coupleFemaleFemaleSwingers;
  final String coupleMaleMaleSwingers;
  final String coupleMaleSwingers;
  final String coupleFemaleSwingers;
  final String coupleTransgenderSwingers;

  UserModel({
    required this.id,
    required this.username,
    required this.profileType,
    required this.genderProfileType,
    required this.showOnlineStatus,
    required this.lastLogin,
    required this.showAge,
    required this.age,
    required this.age2,
    this.aiMatchScore,
    this.aiInsight,
    required this.formattedAddress,
    required this.totalDistance,
    required this.distance,
    required this.images,
    required this.videos,
    required this.showGender,
    required this.showLocation,
    required this.showChatIcon,
    required this.likesCount,
    required this.friendCount,
    required this.coupleMaleFemaleSwingers,
    required this.coupleFemaleFemaleSwingers,
    required this.coupleMaleMaleSwingers,
    required this.coupleMaleSwingers,
    required this.coupleFemaleSwingers,
    required this.coupleTransgenderSwingers,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var rawImages = json['image'] as List? ?? [];
    List<ProfileImage> parsedImages = rawImages
        .map((img) => ProfileImage.fromJson(Map<String, dynamic>.from(img)))
        .toList();

    // Fallback if images list is empty but profile_image is present
    if (parsedImages.isEmpty) {
      parsedImages.add(ProfileImage(
        showProfileImage: json['show_profile_image'] ?? '1',
        profileImage: json['profile_image'] ?? '',
        dummyProfileImage: 'assets/img/lock.png',
      ));
    }

    var rawVideos = json['video'] as List? ?? [];
    List<ProfileVideo> parsedVideos = rawVideos
        .map((vid) => ProfileVideo.fromJson(Map<String, dynamic>.from(vid)))
        .toList();

    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? 'Anonymous',
      profileType: json['profile_type'] ?? 'single',
      genderProfileType: json['gender_profile_type'] ?? '',
      showOnlineStatus: json['show_online_status'] ?? '0',
      lastLogin: json['last_login']?.toString() ?? '0',
      showAge: json['show_age'] ?? '0',
      age: json['age']?.toString() ?? '21',
      age2: json['age2']?.toString() ?? '',
      aiMatchScore: json['ai_match_score']?.toString(),
      aiInsight: json['ai_insight'],
      formattedAddress: json['formatted_address'] ?? '',
      totalDistance: json['total_distance']?.toString() ?? '0',
      distance: json['distance'] ?? 'km',
      images: parsedImages,
      videos: parsedVideos,
      showGender: json['show_gender'] ?? '1',
      showLocation: json['show_location'] ?? '1',
      showChatIcon: json['show_chat_icon'] ?? '1',
      likesCount: int.tryParse(json['likes_count']?.toString() ?? '0') ?? 0,
      friendCount: int.tryParse(json['friend_count']?.toString() ?? '0') ?? 0,
      coupleMaleFemaleSwingers: json['couple_male_female_swingers'] ?? '0',
      coupleFemaleFemaleSwingers: json['couple_female_female_swingers'] ?? '0',
      coupleMaleMaleSwingers: json['couple_male_male_swingers'] ?? '0',
      coupleMaleSwingers: json['couple_male_swingers'] ?? '0',
      coupleFemaleSwingers: json['couple_female_swingers'] ?? '0',
      coupleTransgenderSwingers: json['couple_transgender_swingers'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_type': profileType,
      'gender_profile_type': genderProfileType,
      'show_online_status': showOnlineStatus,
      'last_login': lastLogin,
      'show_age': showAge,
      'age': age,
      'age2': age2,
      'ai_match_score': aiMatchScore,
      'ai_insight': aiInsight,
      'formatted_address': formattedAddress,
      'total_distance': totalDistance,
      'distance': distance,
      'image': images.map((img) => img.toJson()).toList(),
      'video': videos.map((vid) => vid.toJson()).toList(),
      'show_gender': showGender,
      'show_location': showLocation,
      'show_chat_icon': showChatIcon,
      'likes_count': likesCount,
      'friend_count': friendCount,
      'couple_male_female_swingers': coupleMaleFemaleSwingers,
      'couple_female_female_swingers': coupleFemaleFemaleSwingers,
      'couple_male_male_swingers': coupleMaleMaleSwingers,
      'couple_male_swingers': coupleMaleSwingers,
      'couple_female_swingers': coupleFemaleSwingers,
      'couple_transgender_swingers': coupleTransgenderSwingers,
    };
  }
}
