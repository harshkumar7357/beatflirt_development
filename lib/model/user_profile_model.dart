class UserProfileModel {
  final String id;
  final String username;
  final String email;
  final String profileType; // "single" or "couple"
  final String genderProfileType;
  final String singleProfileGenderFrom;
  final String coupleProfileGenderFrom;
  final String coupleProfileGenderTo;
  final String singleFullName;
  final String coupleFullNameFrom;
  final String coupleFullNameTo;
  final String created;
  final String lastPayment;
  final String expireDate;
  final String? lat;
  final String? lng;
  final String? city;
  final String? placeId;
  final String? mapUrl;
  final String? address;
  final String? lat1;
  final String? lng1;
  final String? city1;
  final String? placeId1;
  final String? mapUrl1;
  final String? address1;
  final String? distance;
  final String person1Name;
  final String person2Name;

  // Couple preferences
  final String coupleMaleFemaleSwingers;
  final String coupleMaleFemaleHookupMeetup;
  final String coupleFemaleFemaleSwingers;
  final String coupleFemaleFemaleHookupMeetup;
  final String coupleMaleMaleSwingers;
  final String coupleMaleMaleHookupMeetup;
  final String coupleMaleSwingers;
  final String coupleMaleHookupMeetup;
  final String coupleFemaleSwingers;
  final String coupleFemaleHookupMeetup;
  final String coupleTransgenderSwingers;
  final String coupleTransgenderHookupMeetup;

  final String? text;
  final String? comment;

  // Person 1 details
  final String? person1Dob;
  final int age;
  final String? person1BodyHair;
  final String? height1Type;
  final String? weight1Type;
  final String? person1Height;
  final String? person1Weight;
  final String? person1BodyType;
  final String? person1EthnicBackground;
  final String? person1Piercings;
  final String? person1Tattoos;
  final String? person1LanguageSpoken;
  final String? person1Circumcised;
  final String? person1Smoking;
  final String? person1Drinking;
  final String? person1IntelligenceImportance;
  final String? person1Sexuality;
  final String? person1RelationshipOrientation;
  final String? person1LooksImportant;

  // Person 2 details (for couples)
  final String? person2Dob;
  final int age2;
  final String? person2BodyHair;
  final String? height2Type;
  final String? weight2Type;
  final String? person2Height;
  final String? person2Weight;
  final String? person2BodyType;
  final String? person2EthnicBackground;
  final String? person2Piercings;
  final String? person2Tattoos;
  final String? person2LanguageSpoken;
  final String? person2Circumcised;
  final String? person2Smoking;
  final String? person2Drinking;
  final String? person2IntelligenceImportance;
  final String? person2Sexuality;
  final String? person2RelationshipOrientation;
  final String? person2LooksImportant;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profileType,
    required this.genderProfileType,
    required this.singleProfileGenderFrom,
    required this.coupleProfileGenderFrom,
    required this.coupleProfileGenderTo,
    required this.singleFullName,
    required this.coupleFullNameFrom,
    required this.coupleFullNameTo,
    required this.created,
    required this.lastPayment,
    required this.expireDate,
    this.lat,
    this.lng,
    this.city,
    this.placeId,
    this.mapUrl,
    this.address,
    this.lat1,
    this.lng1,
    this.city1,
    this.placeId1,
    this.mapUrl1,
    this.address1,
    this.distance,
    required this.person1Name,
    required this.person2Name,
    required this.coupleMaleFemaleSwingers,
    required this.coupleMaleFemaleHookupMeetup,
    required this.coupleFemaleFemaleSwingers,
    required this.coupleFemaleFemaleHookupMeetup,
    required this.coupleMaleMaleSwingers,
    required this.coupleMaleMaleHookupMeetup,
    required this.coupleMaleSwingers,
    required this.coupleMaleHookupMeetup,
    required this.coupleFemaleSwingers,
    required this.coupleFemaleHookupMeetup,
    required this.coupleTransgenderSwingers,
    required this.coupleTransgenderHookupMeetup,
    this.text,
    this.comment,
    this.person1Dob,
    required this.age,
    this.person1BodyHair,
    this.height1Type,
    this.weight1Type,
    this.person1Height,
    this.person1Weight,
    this.person1BodyType,
    this.person1EthnicBackground,
    this.person1Piercings,
    this.person1Tattoos,
    this.person1LanguageSpoken,
    this.person1Circumcised,
    this.person1Smoking,
    this.person1Drinking,
    this.person1IntelligenceImportance,
    this.person1Sexuality,
    this.person1RelationshipOrientation,
    this.person1LooksImportant,
    this.person2Dob,
    required this.age2,
    this.person2BodyHair,
    this.height2Type,
    this.weight2Type,
    this.person2Height,
    this.person2Weight,
    this.person2BodyType,
    this.person2EthnicBackground,
    this.person2Piercings,
    this.person2Tattoos,
    this.person2LanguageSpoken,
    this.person2Circumcised,
    this.person2Smoking,
    this.person2Drinking,
    this.person2IntelligenceImportance,
    this.person2Sexuality,
    this.person2RelationshipOrientation,
    this.person2LooksImportant,
  });

  bool get isSingle => profileType == 'single';
  bool get isCouple => profileType == 'couple';

  String get displayName {
    if (isSingle) {
      return singleFullName.isNotEmpty ? singleFullName : username;
    } else {
      final name1 =
      coupleFullNameFrom.isNotEmpty ? coupleFullNameFrom : person1Name;
      final name2 =
      coupleFullNameTo.isNotEmpty ? coupleFullNameTo : person2Name;
      return '$name1 & $name2';
    }
  }

  String get genderDisplay => genderProfileType;

  String get locationDisplay {
    if (city != null && city!.isNotEmpty) {
      return address ?? city!;
    }
    return 'Location not set';
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profileType: json['profile_type']?.toString() ?? 'single',
      genderProfileType: json['gender_profile_type']?.toString() ?? '',
      singleProfileGenderFrom:
      json['single_profile_gender_from']?.toString() ?? '0',
      coupleProfileGenderFrom:
      json['couple_profile_gender_from']?.toString() ?? '0',
      coupleProfileGenderTo:
      json['couple_profile_gender_to']?.toString() ?? '0',
      singleFullName: json['single_full_name']?.toString() ?? '',
      coupleFullNameFrom: json['couple_full_name_from']?.toString() ?? '',
      coupleFullNameTo: json['couple_full_name_to']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      lastPayment: json['last_payment']?.toString() ?? '',
      expireDate: json['expire_date']?.toString() ?? '',
      lat: json['lat']?.toString(),
      lng: json['lng']?.toString(),
      city: json['city']?.toString(),
      placeId: json['place_id']?.toString(),
      mapUrl: json['map_url']?.toString(),
      address: json['address']?.toString(),
      lat1: json['lat_1']?.toString(),
      lng1: json['lng_1']?.toString(),
      city1: json['city_1']?.toString(),
      placeId1: json['place_id_1']?.toString(),
      mapUrl1: json['map_url_1']?.toString(),
      address1: json['address_1']?.toString(),
      distance: json['distance']?.toString(),
      person1Name: (json['person1_name'] != null && json['person1_name'].toString().trim().isNotEmpty) ? json['person1_name'].toString() : 'Person 1',
      person2Name: (json['person2_name'] != null && json['person2_name'].toString().trim().isNotEmpty) ? json['person2_name'].toString() : 'Person 2',
      coupleMaleFemaleSwingers:
      json['couple_male_female_swingers']?.toString() ?? '0',
      coupleMaleFemaleHookupMeetup:
      json['couple_male_female_hookup_meetup']?.toString() ?? '0',
      coupleFemaleFemaleSwingers:
      json['couple_female_female_swingers']?.toString() ?? '0',
      coupleFemaleFemaleHookupMeetup:
      json['couple_female_female_hookup_meetup']?.toString() ?? '0',
      coupleMaleMaleSwingers:
      json['couple_male_male_swingers']?.toString() ?? '0',
      coupleMaleMaleHookupMeetup:
      json['couple_male_male_hookup_meetup']?.toString() ?? '0',
      coupleMaleSwingers: json['couple_male_swingers']?.toString() ?? '0',
      coupleMaleHookupMeetup:
      json['couple_male_hookup_meetup']?.toString() ?? '0',
      coupleFemaleSwingers: json['couple_female_swingers']?.toString() ?? '0',
      coupleFemaleHookupMeetup:
      json['couple_female_hookup_meetup']?.toString() ?? '0',
      coupleTransgenderSwingers:
      json['couple_transgender_swingers']?.toString() ?? '0',
      coupleTransgenderHookupMeetup:
      json['couple_transgender_hookup_meetup']?.toString() ?? '0',
      text: json['text']?.toString(),
      comment: json['comment']?.toString(),
      person1Dob: json['person1_dob']?.toString(),
      age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      person1BodyHair: json['person1_body_hair']?.toString(),
      height1Type: json['height1_type']?.toString(),
      weight1Type: json['weight1_type']?.toString(),
      person1Height: json['person1_height']?.toString(),
      person1Weight: json['person1_weight']?.toString(),
      person1BodyType: json['person1_body_type']?.toString(),
      person1EthnicBackground: json['person1_ethnic_background']?.toString(),
      person1Piercings: json['person1_piercings']?.toString(),
      person1Tattoos: json['person1_tattoos']?.toString(),
      person1LanguageSpoken: json['person1_language_spoken']?.toString(),
      person1Circumcised: json['person1_circumcised']?.toString(),
      person1Smoking: json['person1_smoking']?.toString(),
      person1Drinking: json['person1_drinking']?.toString(),
      person1IntelligenceImportance:
      json['person1_intelligence_importance']?.toString(),
      person1Sexuality: json['person1_sexuality']?.toString(),
      person1RelationshipOrientation:
      json['person1_relationship_orientation']?.toString(),
      person1LooksImportant: json['person1_looks_important']?.toString(),
      person2Dob: json['person2_dob']?.toString(),
      age2: int.tryParse(json['age2']?.toString() ?? '0') ?? 0,
      person2BodyHair: json['person2_body_hair']?.toString(),
      height2Type: json['height2_type']?.toString(),
      weight2Type: json['weight2_type']?.toString(),
      person2Height: json['person2_height']?.toString(),
      person2Weight: json['person2_weight']?.toString(),
      person2BodyType: json['person2_body_type']?.toString(),
      person2EthnicBackground: json['person2_ethnic_background']?.toString(),
      person2Piercings: json['person2_piercings']?.toString(),
      person2Tattoos: json['person2_tattoos']?.toString(),
      person2LanguageSpoken: json['person2_language_spoken']?.toString(),
      person2Circumcised: json['person2_circumcised']?.toString(),
      person2Smoking: json['person2_smoking']?.toString(),
      person2Drinking: json['person2_drinking']?.toString(),
      person2IntelligenceImportance:
      json['person2_intelligence_importance']?.toString(),
      person2Sexuality: json['person2_sexuality']?.toString(),
      person2RelationshipOrientation:
      json['person2_relationship_orientation']?.toString(),
      person2LooksImportant: json['person2_looks_important']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile_type': profileType,
      'gender_profile_type': genderProfileType,
      'single_profile_gender_from': singleProfileGenderFrom,
      'couple_profile_gender_from': coupleProfileGenderFrom,
      'couple_profile_gender_to': coupleProfileGenderTo,
      'single_full_name': singleFullName,
      'couple_full_name_from': coupleFullNameFrom,
      'couple_full_name_to': coupleFullNameTo,
      'created': created,
      'last_payment': lastPayment,
      'expire_date': expireDate,
      'lat': lat,
      'lng': lng,
      'city': city,
      'place_id': placeId,
      'map_url': mapUrl,
      'address': address,
      'person1_name': person1Name,
      'person2_name': person2Name,
      'person1_dob': person1Dob,
      'age': age,
      'person1_body_hair': person1BodyHair,
      'person1_height': person1Height,
      'person1_weight': person1Weight,
      'person1_body_type': person1BodyType,
      'person1_ethnic_background': person1EthnicBackground,
      'person1_piercings': person1Piercings,
      'person1_tattoos': person1Tattoos,
      'person1_language_spoken': person1LanguageSpoken,
      'person1_circumcised': person1Circumcised,
      'person1_smoking': person1Smoking,
      'person1_drinking': person1Drinking,
      'person1_sexuality': person1Sexuality,
      'person1_relationship_orientation': person1RelationshipOrientation,
      'person2_dob': person2Dob,
      'age2': age2,
      'person2_body_hair': person2BodyHair,
      'person2_height': person2Height,
      'person2_weight': person2Weight,
      'person2_body_type': person2BodyType,
      'person2_ethnic_background': person2EthnicBackground,
      'person2_piercings': person2Piercings,
      'person2_tattoos': person2Tattoos,
      'person2_language_spoken': person2LanguageSpoken,
      'person2_circumcised': person2Circumcised,
      'person2_smoking': person2Smoking,
      'person2_drinking': person2Drinking,
      'person2_sexuality': person2Sexuality,
      'person2_relationship_orientation': person2RelationshipOrientation,
    };
  }

  UserProfileModel copyWith({
    String? singleFullName,
    String? coupleFullNameFrom,
    String? coupleFullNameTo,
    String? person1Height,
    String? person1Weight,
    String? person1BodyType,
    String? person1EthnicBackground,
    String? person1Smoking,
    String? person1Drinking,
    String? person1Sexuality,
    String? person1RelationshipOrientation,
    String? person2Height,
    String? person2Weight,
    String? person2BodyType,
    String? person2EthnicBackground,
    String? person2Smoking,
    String? person2Drinking,
    String? person2Sexuality,
    String? person2RelationshipOrientation,
    String? text,
    String? comment,
    String? address,
    String? city,
    String? lat,
    String? lng,
  }) {
    return UserProfileModel(
      id: id,
      username: username,
      email: email,
      profileType: profileType,
      genderProfileType: genderProfileType,
      singleProfileGenderFrom: singleProfileGenderFrom,
      coupleProfileGenderFrom: coupleProfileGenderFrom,
      coupleProfileGenderTo: coupleProfileGenderTo,
      singleFullName: singleFullName ?? this.singleFullName,
      coupleFullNameFrom: coupleFullNameFrom ?? this.coupleFullNameFrom,
      coupleFullNameTo: coupleFullNameTo ?? this.coupleFullNameTo,
      created: created,
      lastPayment: lastPayment,
      expireDate: expireDate,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      placeId: placeId,
      mapUrl: mapUrl,
      address: address ?? this.address,
      lat1: lat1,
      lng1: lng1,
      city1: city1,
      placeId1: placeId1,
      mapUrl1: mapUrl1,
      address1: address1,
      distance: distance,
      person1Name: person1Name,
      person2Name: person2Name,
      coupleMaleFemaleSwingers: coupleMaleFemaleSwingers,
      coupleMaleFemaleHookupMeetup: coupleMaleFemaleHookupMeetup,
      coupleFemaleFemaleSwingers: coupleFemaleFemaleSwingers,
      coupleFemaleFemaleHookupMeetup: coupleFemaleFemaleHookupMeetup,
      coupleMaleMaleSwingers: coupleMaleMaleSwingers,
      coupleMaleMaleHookupMeetup: coupleMaleMaleHookupMeetup,
      coupleMaleSwingers: coupleMaleSwingers,
      coupleMaleHookupMeetup: coupleMaleHookupMeetup,
      coupleFemaleSwingers: coupleFemaleSwingers,
      coupleFemaleHookupMeetup: coupleFemaleHookupMeetup,
      coupleTransgenderSwingers: coupleTransgenderSwingers,
      coupleTransgenderHookupMeetup: coupleTransgenderHookupMeetup,
      text: text ?? this.text,
      comment: comment ?? this.comment,
      person1Dob: person1Dob,
      age: age,
      person1BodyHair: person1BodyHair,
      height1Type: height1Type,
      weight1Type: weight1Type,
      person1Height: person1Height ?? this.person1Height,
      person1Weight: person1Weight ?? this.person1Weight,
      person1BodyType: person1BodyType ?? this.person1BodyType,
      person1EthnicBackground:
      person1EthnicBackground ?? this.person1EthnicBackground,
      person1Piercings: person1Piercings,
      person1Tattoos: person1Tattoos,
      person1LanguageSpoken: person1LanguageSpoken,
      person1Circumcised: person1Circumcised,
      person1Smoking: person1Smoking ?? this.person1Smoking,
      person1Drinking: person1Drinking ?? this.person1Drinking,
      person1IntelligenceImportance: person1IntelligenceImportance,
      person1Sexuality: person1Sexuality ?? this.person1Sexuality,
      person1RelationshipOrientation:
      person1RelationshipOrientation ?? this.person1RelationshipOrientation,
      person1LooksImportant: person1LooksImportant,
      person2Dob: person2Dob,
      age2: age2,
      person2BodyHair: person2BodyHair,
      height2Type: height2Type,
      weight2Type: weight2Type,
      person2Height: person2Height ?? this.person2Height,
      person2Weight: person2Weight ?? this.person2Weight,
      person2BodyType: person2BodyType ?? this.person2BodyType,
      person2EthnicBackground:
      person2EthnicBackground ?? this.person2EthnicBackground,
      person2Piercings: person2Piercings,
      person2Tattoos: person2Tattoos,
      person2LanguageSpoken: person2LanguageSpoken,
      person2Circumcised: person2Circumcised,
      person2Smoking: person2Smoking ?? this.person2Smoking,
      person2Drinking: person2Drinking ?? this.person2Drinking,
      person2IntelligenceImportance: person2IntelligenceImportance,
      person2Sexuality: person2Sexuality ?? this.person2Sexuality,
      person2RelationshipOrientation:
      person2RelationshipOrientation ?? this.person2RelationshipOrientation,
      person2LooksImportant: person2LooksImportant,
    );
  }
}
