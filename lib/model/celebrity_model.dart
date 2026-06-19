class CelebrityImage {
  final String profileImage;
  final String? status;

  CelebrityImage({required this.profileImage, this.status});

  factory CelebrityImage.fromJson(Map<String, dynamic> json) {
    return CelebrityImage(
      profileImage: json['profile_image'] ?? '',
      status: json['status']?.toString(),
    );
  }
}

class CelebrityModel {
  final String id;
  final String username;
  final String? lastLogin;
  final String userId;
  final List<CelebrityImage> images;
  final bool showPreferences;
  final bool showAge;
  final bool showHeight;
  final bool showWeight;
  final String? facePicture;
  final String? shirtlessPicture;
  final String? fullBodyPicture;
  final String? validationPicture;
  final String? bbcType;
  final List<String> preferences;
  final List<String> profileControl;
  final String? stateOfResidence;
  final String? lat;
  final String? lng;
  final String? cityName;
  final String? contactNumber;
  final String? updatedEmail;
  final String? screenName;
  final String? lifeStyleNickname;
  final String? lifeStyleWebsite;
  final String? age;
  final String? heightFeet;
  final String? heightInch;
  final String? weight;
  final String? selfDescription;
  final String? status;
  final String? created;

  CelebrityModel({
    required this.id,
    required this.username,
    this.lastLogin,
    required this.userId,
    required this.images,
    this.showPreferences = true,
    this.showAge = true,
    this.showHeight = true,
    this.showWeight = true,
    this.facePicture,
    this.shirtlessPicture,
    this.fullBodyPicture,
    this.validationPicture,
    this.bbcType,
    this.preferences = const [],
    this.profileControl = const [],
    this.stateOfResidence,
    this.lat,
    this.lng,
    this.cityName,
    this.contactNumber,
    this.updatedEmail,
    this.screenName,
    this.lifeStyleNickname,
    this.lifeStyleWebsite,
    this.age,
    this.heightFeet,
    this.heightInch,
    this.weight,
    this.selfDescription,
    this.status,
    this.created,
  });

  String get profileImage {
    if (images.isNotEmpty) {
      return images[0].profileImage;
    }
    return 'https://app.beatflirtevent.com/assets/img/male.png';
  }

  factory CelebrityModel.fromJson(Map<String, dynamic> json) {
    List<CelebrityImage> imagesList = [];
    if (json['image'] != null) {
      imagesList = (json['image'] as List)
          .map((e) => CelebrityImage.fromJson(e))
          .toList();
    }

    List<String> prefsList = [];
    if (json['preferences'] != null) {
      prefsList = List<String>.from(json['preferences']);
    }

    List<String> profileControlList = [];
    if (json['profile_control'] != null) {
      profileControlList = List<String>.from(json['profile_control']);
    }

    return CelebrityModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      lastLogin: json['last_login']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      images: imagesList,
      showPreferences: json['show_preferences'] == 1,
      showAge: json['show_age'] == 1,
      showHeight: json['show_height'] == 1,
      showWeight: json['show_weight'] == 1,
      facePicture: json['face_picture'],
      shirtlessPicture: json['shirtless_picture'],
      fullBodyPicture: json['full_body_picture\t'] ?? json['full_body_picture'],
      validationPicture: json['validation_picture'],
      bbcType: json['bbc_type'],
      preferences: prefsList,
      profileControl: profileControlList,
      stateOfResidence: json['state_of_residence'],
      lat: json['lat'],
      lng: json['lng'],
      cityName: json['city_name'],
      contactNumber: json['contact_number'],
      updatedEmail: json['updated_email'],
      screenName: json['screen_name'],
      lifeStyleNickname: json['life_style_nickname'],
      lifeStyleWebsite: json['life_style_website'],
      age: json['age']?.toString(),
      heightFeet: json['height_feet']?.toString(),
      heightInch: json['height_inch']?.toString(),
      weight: json['weight']?.toString(),
      selfDescription: json['self_description'],
      status: json['status']?.toString(),
      created: json['created'],
    );
  }
}

class TermsConditionModel {
  final String id;
  final String title;
  final String description;
  final String status;

  TermsConditionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class CalendarSlot {
  final String? username;
  final String? date;
  final String? startTime;
  final String? endTime;

  CalendarSlot({this.username, this.date, this.startTime, this.endTime});

  factory CalendarSlot.fromJson(Map<String, dynamic> json) {
    return CalendarSlot(
      username: json['username'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
