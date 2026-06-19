// class ViewSingleProfileData {
//   final String id;
//   final String username;
//   final String email;
//   final String profileType;
//   final String genderProfileType;
//   final String singleProfileGenderFrom;
//   final String coupleProfileGenderFrom;
//   final String coupleProfileGenderTo;
//   final String singleFullName;
//   final String coupleFullNameFrom;
//   final String coupleFullNameTo;
//   final String created;
//   final String lastPayment;
//   final String expireDate;
//   final String lat;
//   final String lng;
//   final String city;
//   final String placeId;
//   final String mapUrl;
//   final String address;
//   final String? lat1;
//   final String? lng1;
//   final String? city1;
//   final String? placeId1;
//   final String? mapUrl1;
//   final String? address1;
//   final String? distance;
//   final String person1Name;
//   final String person2Name;
//   final String coupleMaleFemaleSwingers;
//   final String coupleMaleFemaleHookupMeetup;
//   final String coupleFemaleFemaleSwingers;
//   final String coupleFemaleFemaleHookupMeetup;
//   final String coupleMaleMaleSwingers;
//   final String coupleMaleMaleHookupMeetup;
//   final String coupleMaleSwingers;
//   final String coupleMaleHookupMeetup;
//   final String coupleFemaleSwingers;
//   final String coupleFemaleHookupMeetup;
//   final String coupleTransgenderSwingers;
//   final String coupleTransgenderHookupMeetup;
//   final String? text;
//   final String? comment;
//   final String person1Dob;
//   final int age;
//   final String? person1BodyHair;
//   final String? height1Type;
//   final String? weight1Type;
//   final String? person1Height;
//   final String? person1Weight;
//   final String? person1BodyType;
//   final String? person1EthnicBackground;
//   final String? person1Piercings;
//   final String? person1Tattoos;
//   final String? person1LanguageSpoken;
//   final String? person1Circumcised;
//   final String? person1Smoking;
//   final String? person1Drinking;
//   final String? person1IntelligenceImportance;
//   final String? person1Sexuality;
//   final String? person1RelationshipOrientation;
//   final String? person1LooksImportant;
//   final String person2Dob;
//   final int age2;
//   final String? person2BodyHair;
//   final String? height2Type;
//   final String? weight2Type;
//   final String? person2Height;
//   final String? person2Weight;
//   final String? person2BodyType;
//   final String? person2EthnicBackground;
//   final String? person2Piercings;
//   final String? person2Tattoos;
//   final String? person2LanguageSpoken;
//   final String? person2Circumcised;
//   final String? person2Smoking;
//   final String? person2Drinking;
//   final String? person2IntelligenceImportance;
//   final String? person2Sexuality;
//   final String? person2RelationshipOrientation;
//   final String? person2LooksImportant;

//   ViewSingleProfileData({
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.profileType,
//     required this.genderProfileType,
//     required this.singleProfileGenderFrom,
//     required this.coupleProfileGenderFrom,
//     required this.coupleProfileGenderTo,
//     required this.singleFullName,
//     required this.coupleFullNameFrom,
//     required this.coupleFullNameTo,
//     required this.created,
//     required this.lastPayment,
//     required this.expireDate,
//     required this.lat,
//     required this.lng,
//     required this.city,
//     required this.placeId,
//     required this.mapUrl,
//     required this.address,
//     this.lat1,
//     this.lng1,
//     this.city1,
//     this.placeId1,
//     this.mapUrl1,
//     this.address1,
//     this.distance,
//     required this.person1Name,
//     required this.person2Name,
//     required this.coupleMaleFemaleSwingers,
//     required this.coupleMaleFemaleHookupMeetup,
//     required this.coupleFemaleFemaleSwingers,
//     required this.coupleFemaleFemaleHookupMeetup,
//     required this.coupleMaleMaleSwingers,
//     required this.coupleMaleMaleHookupMeetup,
//     required this.coupleMaleSwingers,
//     required this.coupleMaleHookupMeetup,
//     required this.coupleFemaleSwingers,
//     required this.coupleFemaleHookupMeetup,
//     required this.coupleTransgenderSwingers,
//     required this.coupleTransgenderHookupMeetup,
//     this.text,
//     this.comment,
//     required this.person1Dob,
//     required this.age,
//     this.person1BodyHair,
//     this.height1Type,
//     this.weight1Type,
//     this.person1Height,
//     this.person1Weight,
//     this.person1BodyType,
//     this.person1EthnicBackground,
//     this.person1Piercings,
//     this.person1Tattoos,
//     this.person1LanguageSpoken,
//     this.person1Circumcised,
//     this.person1Smoking,
//     this.person1Drinking,
//     this.person1IntelligenceImportance,
//     this.person1Sexuality,
//     this.person1RelationshipOrientation,
//     this.person1LooksImportant,
//     required this.person2Dob,
//     required this.age2,
//     this.person2BodyHair,
//     this.height2Type,
//     this.weight2Type,
//     this.person2Height,
//     this.person2Weight,
//     this.person2BodyType,
//     this.person2EthnicBackground,
//     this.person2Piercings,
//     this.person2Tattoos,
//     this.person2LanguageSpoken,
//     this.person2Circumcised,
//     this.person2Smoking,
//     this.person2Drinking,
//     this.person2IntelligenceImportance,
//     this.person2Sexuality,
//     this.person2RelationshipOrientation,
//     this.person2LooksImportant,
//   });

//   factory ViewSingleProfileData.fromJson(Map<String, dynamic> json) {
//     return ViewSingleProfileData(
//       id: json['id'] ?? '',
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       profileType: json['profile_type'] ?? '',
//       genderProfileType: json['gender_profile_type'] ?? '',
//       singleProfileGenderFrom: json['single_profile_gender_from'] ?? '',
//       coupleProfileGenderFrom: json['couple_profile_gender_from'] ?? '',
//       coupleProfileGenderTo: json['couple_profile_gender_to'] ?? '',
//       singleFullName: json['single_full_name'] ?? '',
//       coupleFullNameFrom: json['couple_full_name_from'] ?? '',
//       coupleFullNameTo: json['couple_full_name_to'] ?? '',
//       created: json['created'] ?? '',
//       lastPayment: json['last_payment'] ?? '',
//       expireDate: json['expire_date'] ?? '',
//       lat: json['lat'] ?? '',
//       lng: json['lng'] ?? '',
//       city: json['city'] ?? '',
//       placeId: json['place_id'] ?? '',
//       mapUrl: json['map_url'] ?? '',
//       address: json['address'] ?? '',
//       lat1: json['lat_1'],
//       lng1: json['lng_1'],
//       city1: json['city_1'],
//       placeId1: json['place_id_1'],
//       mapUrl1: json['map_url_1'],
//       address1: json['address_1'],
//       distance: json['distance'],
//       person1Name: json['person1_name'] ?? 'Person 1',
//       person2Name: json['person2_name'] ?? 'Person 2',
//       coupleMaleFemaleSwingers: json['couple_male_female_swingers'] ?? '0',
//       coupleMaleFemaleHookupMeetup:
//           json['couple_male_female_hookup_meetup'] ?? '0',
//       coupleFemaleFemaleSwingers:
//           json['couple_female_female_swingers'] ?? '0',
//       coupleFemaleFemaleHookupMeetup:
//           json['couple_female_female_hookup_meetup'] ?? '0',
//       coupleMaleMaleSwingers: json['couple_male_male_swingers'] ?? '0',
//       coupleMaleMaleHookupMeetup:
//           json['couple_male_male_hookup_meetup'] ?? '0',
//       coupleMaleSwingers: json['couple_male_swingers'] ?? '0',
//       coupleMaleHookupMeetup: json['couple_male_hookup_meetup'] ?? '0',
//       coupleFemaleSwingers: json['couple_female_swingers'] ?? '0',
//       coupleFemaleHookupMeetup: json['couple_female_hookup_meetup'] ?? '0',
//       coupleTransgenderSwingers: json['couple_transgender_swingers'] ?? '0',
//       coupleTransgenderHookupMeetup:
//           json['couple_transgender_hookup_meetup'] ?? '0',
//       text: json['text'],
//       comment: json['comment'],
//       person1Dob: json['person1_dob'] ?? '',
//       age: json['age'] ?? 0,
//       person1BodyHair: json['person1_body_hair'],
//       height1Type: json['height1_type'],
//       weight1Type: json['weight1_type'],
//       person1Height: json['person1_height'],
//       person1Weight: json['person1_weight'],
//       person1BodyType: json['person1_body_type'],
//       person1EthnicBackground: json['person1_ethnic_background'],
//       person1Piercings: json['person1_piercings'],
//       person1Tattoos: json['person1_tattoos'],
//       person1LanguageSpoken: json['person1_language_spoken'],
//       person1Circumcised: json['person1_circumcised'],
//       person1Smoking: json['person1_smoking'],
//       person1Drinking: json['person1_drinking'],
//       person1IntelligenceImportance: json['person1_intelligence_importance'],
//       person1Sexuality: json['person1_sexuality'],
//       person1RelationshipOrientation: json['person1_relationship_orientation'],
//       person1LooksImportant: json['person1_looks_important'],
//       person2Dob: json['person2_dob'] ?? '',
//       age2: json['age2'] ?? 0,
//       person2BodyHair: json['person2_body_hair'],
//       height2Type: json['height2_type'],
//       weight2Type: json['weight2_type'],
//       person2Height: json['person2_height'],
//       person2Weight: json['person2_weight'],
//       person2BodyType: json['person2_body_type'],
//       person2EthnicBackground: json['person2_ethnic_background'],
//       person2Piercings: json['person2_piercings'],
//       person2Tattoos: json['person2_tattoos'],
//       person2LanguageSpoken: json['person2_language_spoken'],
//       person2Circumcised: json['person2_circumcised'],
//       person2Smoking: json['person2_smoking'],
//       person2Drinking: json['person2_drinking'],
//       person2IntelligenceImportance: json['person2_intelligence_importance'],
//       person2Sexuality: json['person2_sexuality'],
//       person2RelationshipOrientation: json['person2_relationship_orientation'],
//       person2LooksImportant: json['person2_looks_important'],
//     );
//   }
// }

// class ViewSingleProfileState {
//   final bool isLoading;
//   final bool isError;
//   final String errorMessage;
//   final ViewSingleProfileData? data;

//   ViewSingleProfileState({
//     this.isLoading = false,
//     this.isError = false,
//     this.errorMessage = '',
//     this.data,
//   });

//   ViewSingleProfileState copyWith({
//     bool? isLoading,
//     bool? isError,
//     String? errorMessage,
//     ViewSingleProfileData? data,
//   }) {
//     return ViewSingleProfileState(
//       isLoading: isLoading ?? this.isLoading,
//       isError: isError ?? this.isError,
//       errorMessage: errorMessage ?? this.errorMessage,
//       data: data ?? this.data,
//     );
//   }
// }


// // import 'dart:convert';

// // class ViewSingleProfileResponse {
// //   final String status;
// //   final ViewSingleProfileData? data;

// //   ViewSingleProfileResponse({required this.status, this.data});

// //   factory ViewSingleProfileResponse.fromJson(Map<String, dynamic> json) {
// //     return ViewSingleProfileResponse(
// //       status: json['status']?.toString() ?? '',
// //       data: json['data'] != null ? ViewSingleProfileData.fromJson(json['data']) : null,
// //     );
// //   }
// // }

// // class ViewSingleProfileData {
// //   final String id;
// //   final String username;
// //   final String email;
// //   final String profileType; // "single" or "couple"
// //   final String genderProfileType;
// //   final String? singleProfileGenderFrom;
// //   final String? coupleProfileGenderFrom;
// //   final String? coupleProfileGenderTo;
// //   final String singleFullName;
// //   final String coupleFullNameFrom;
// //   final String coupleFullNameTo;
// //   final String created;
// //   final String lastPayment;
// //   final String expireDate;
// //   final String lat;
// //   final String lng;
// //   final String city;
// //   final String placeId;
// //   final String mapUrl;
// //   final String address;
// //   final String? lat1;
// //   final String? lng1;
// //   final String? city1;
// //   final String? placeId1;
// //   final String? mapUrl1;
// //   final String? address1;
// //   final String distance;
// //   final String person1Name;
// //   final String person2Name;

// //   // Couple type flags (exact keys from API/interests)
// //   final String coupleMaleFemaleSwingers;
// //   final String coupleMaleFemaleHookupMeetup;
// //   final String coupleFemaleFemaleSwingers;
// //   final String coupleFemaleFemaleHookupMeetup;
// //   final String coupleMaleMaleSwingers;
// //   final String coupleMaleMaleHookupMeetup;
// //   final String coupleMaleSwingers;
// //   final String coupleMaleHookupMeetup;
// //   final String coupleFemaleSwingers;
// //   final String coupleFemaleHookupMeetup;
// //   final String coupleTransgenderSwingers;
// //   final String coupleTransgenderHookupMeetup;

// //   final String? text;
// //   final String? comment;

// //   // Person 1 fields
// //   final String person1Dob;
// //   final int age;
// //   final String? person1BodyHair;
// //   final String? height1Type;
// //   final String? weight1Type;
// //   final String? person1Height;
// //   final String? person1Weight;
// //   final String? person1BodyType;
// //   final String? person1EthnicBackground;
// //   final String? person1Piercings;
// //   final String? person1Tattoos;
// //   final String? person1LanguageSpoken;
// //   final String? person1Circumcised;
// //   final String? person1Smoking;
// //   final String? person1Drinking;
// //   final String? person1IntelligenceImportance;
// //   final String? person1Sexuality;
// //   final String? person1RelationshipOrientation;
// //   final String? person1LooksImportant;

// //   // Person 2 fields
// //   final String person2Dob;
// //   final int age2;
// //   final String? person2BodyHair;
// //   final String? height2Type;
// //   final String? weight2Type;
// //   final String? person2Height;
// //   final String? person2Weight;
// //   final String? person2BodyType;
// //   final String? person2EthnicBackground;
// //   final String? person2Piercings;
// //   final String? person2Tattoos;
// //   final String? person2LanguageSpoken;
// //   final String? person2Circumcised;
// //   final String? person2Smoking;
// //   final String? person2Drinking;
// //   final String? person2IntelligenceImportance;
// //   final String? person2Sexuality;
// //   final String? person2RelationshipOrientation;
// //   final String? person2LooksImportant;

// //   ViewSingleProfileData({
// //     required this.id,
// //     required this.username,
// //     required this.email,
// //     required this.profileType,
// //     required this.genderProfileType,
// //     this.singleProfileGenderFrom,
// //     this.coupleProfileGenderFrom,
// //     this.coupleProfileGenderTo,
// //     required this.singleFullName,
// //     required this.coupleFullNameFrom,
// //     required this.coupleFullNameTo,
// //     required this.created,
// //     required this.lastPayment,
// //     required this.expireDate,
// //     required this.lat,
// //     required this.lng,
// //     required this.city,
// //     required this.placeId,
// //     required this.mapUrl,
// //     required this.address,
// //     this.lat1,
// //     this.lng1,
// //     this.city1,
// //     this.placeId1,
// //     this.mapUrl1,
// //     this.address1,
// //     required this.distance,
// //     required this.person1Name,
// //     required this.person2Name,
// //     required this.coupleMaleFemaleSwingers,
// //     required this.coupleMaleFemaleHookupMeetup,
// //     required this.coupleFemaleFemaleSwingers,
// //     required this.coupleFemaleFemaleHookupMeetup,
// //     required this.coupleMaleMaleSwingers,
// //     required this.coupleMaleMaleHookupMeetup,
// //     required this.coupleMaleSwingers,
// //     required this.coupleMaleHookupMeetup,
// //     required this.coupleFemaleSwingers,
// //     required this.coupleFemaleHookupMeetup,
// //     required this.coupleTransgenderSwingers,
// //     required this.coupleTransgenderHookupMeetup,
// //     this.text,
// //     this.comment,
// //     required this.person1Dob,
// //     required this.age,
// //     this.person1BodyHair,
// //     this.height1Type,
// //     this.weight1Type,
// //     this.person1Height,
// //     this.person1Weight,
// //     this.person1BodyType,
// //     this.person1EthnicBackground,
// //     this.person1Piercings,
// //     this.person1Tattoos,
// //     this.person1LanguageSpoken,
// //     this.person1Circumcised,
// //     this.person1Smoking,
// //     this.person1Drinking,
// //     this.person1IntelligenceImportance,
// //     this.person1Sexuality,
// //     this.person1RelationshipOrientation,
// //     this.person1LooksImportant,
// //     required this.person2Dob,
// //     required this.age2,
// //     this.person2BodyHair,
// //     this.height2Type,
// //     this.weight2Type,
// //     this.person2Height,
// //     this.person2Weight,
// //     this.person2BodyType,
// //     this.person2EthnicBackground,
// //     this.person2Piercings,
// //     this.person2Tattoos,
// //     this.person2LanguageSpoken,
// //     this.person2Circumcised,
// //     this.person2Smoking,
// //     this.person2Drinking,
// //     this.person2IntelligenceImportance,
// //     this.person2Sexuality,
// //     this.person2RelationshipOrientation,
// //     this.person2LooksImportant,
// //   });

// //   factory ViewSingleProfileData.fromJson(Map<String, dynamic> json) {
// //     return ViewSingleProfileData(
// //       id: json['id']?.toString() ?? '',
// //       username: json['username']?.toString() ?? '',
// //       email: json['email']?.toString() ?? '',
// //       profileType: json['profile_type']?.toString() ?? 'single',
// //       genderProfileType: json['gender_profile_type']?.toString() ?? '',
// //       singleProfileGenderFrom: json['single_profile_gender_from']?.toString(),
// //       coupleProfileGenderFrom: json['couple_profile_gender_from']?.toString(),
// //       coupleProfileGenderTo: json['couple_profile_gender_to']?.toString(),
// //       singleFullName: json['single_full_name']?.toString() ?? '',
// //       coupleFullNameFrom: json['couple_full_name_from']?.toString() ?? '',
// //       coupleFullNameTo: json['couple_full_name_to']?.toString() ?? '',
// //       created: json['created']?.toString() ?? '',
// //       lastPayment: json['last_payment']?.toString() ?? '',
// //       expireDate: json['expire_date']?.toString() ?? '',
// //       lat: json['lat']?.toString() ?? '',
// //       lng: json['lng']?.toString() ?? '',
// //       city: json['city']?.toString() ?? '',
// //       placeId: json['place_id']?.toString() ?? '',
// //       mapUrl: json['map_url']?.toString() ?? '',
// //       address: json['address']?.toString() ?? '',
// //       lat1: json['lat_1']?.toString(),
// //       lng1: json['lng_1']?.toString(),
// //       city1: json['city_1']?.toString(),
// //       placeId1: json['place_id_1']?.toString(),
// //       mapUrl1: json['map_url_1']?.toString(),
// //       address1: json['address_1']?.toString(),
// //       distance: json['distance']?.toString() ?? '',
// //       person1Name: json['person1_name']?.toString() ?? 'Person 1',
// //       person2Name: json['person2_name']?.toString() ?? 'Person 2',
// //       coupleMaleFemaleSwingers: json['couple_male_female_swingers']?.toString() ?? '0',
// //       coupleMaleFemaleHookupMeetup: json['couple_male_female_hookup_meetup']?.toString() ?? '0',
// //       coupleFemaleFemaleSwingers: json['couple_female_female_swingers']?.toString() ?? '0',
// //       coupleFemaleFemaleHookupMeetup: json['couple_female_female_hookup_meetup']?.toString() ?? '0',
// //       coupleMaleMaleSwingers: json['couple_male_male_swingers']?.toString() ?? '0',
// //       coupleMaleMaleHookupMeetup: json['couple_male_male_hookup_meetup']?.toString() ?? '0',
// //       coupleMaleSwingers: json['couple_male_swingers']?.toString() ?? '0',
// //       coupleMaleHookupMeetup: json['couple_male_hookup_meetup']?.toString() ?? '0',
// //       coupleFemaleSwingers: json['couple_female_swingers']?.toString() ?? '0',
// //       coupleFemaleHookupMeetup: json['couple_female_hookup_meetup']?.toString() ?? '0',
// //       coupleTransgenderSwingers: json['couple_transgender_swingers']?.toString() ?? '0',
// //       coupleTransgenderHookupMeetup: json['couple_transgender_hookup_meetup']?.toString() ?? '0',
// //       text: json['text'],
// //       comment: json['comment'],
// //       person1Dob: json['person1_dob']?.toString() ?? '',
// //       age: json['age'] != null ? int.tryParse(json['age'].toString()) ?? 0 : 0,
// //       person1BodyHair: json['person1_body_hair'],
// //       height1Type: json['height1_type'],
// //       weight1Type: json['weight1_type'],
// //       person1Height: json['person1_height'],
// //       person1Weight: json['person1_weight'],
// //       person1BodyType: json['person1_body_type'],
// //       person1EthnicBackground: json['person1_ethnic_background'],
// //       person1Piercings: json['person1_piercings'],
// //       person1Tattoos: json['person1_tattoos'],
// //       person1LanguageSpoken: json['person1_language_spoken'],
// //       person1Circumcised: json['person1_circumcised'],
// //       person1Smoking: json['person1_smoking'],
// //       person1Drinking: json['person1_drinking'],
// //       person1IntelligenceImportance: json['person1_intelligence_importance'],
// //       person1Sexuality: json['person1_sexuality'],
// //       person1RelationshipOrientation: json['person1_relationship_orientation'],
// //       person1LooksImportant: json['person1_looks_important'],
// //       person2Dob: json['person2_dob']?.toString() ?? '',
// //       age2: json['age2'] != null ? int.tryParse(json['age2'].toString()) ?? 0 : 0,
// //       person2BodyHair: json['person2_body_hair'],
// //       height2Type: json['height2_type'],
// //       weight2Type: json['weight2_type'],
// //       person2Height: json['person2_height'],
// //       person2Weight: json['person2_weight'],
// //       person2BodyType: json['person2_body_type'],
// //       person2EthnicBackground: json['person2_ethnic_background'],
// //       person2Piercings: json['person2_piercings'],
// //       person2Tattoos: json['person2_tattoos'],
// //       person2LanguageSpoken: json['person2_language_spoken'],
// //       person2Circumcised: json['person2_circumcised'],
// //       person2Smoking: json['person2_smoking'],
// //       person2Drinking: json['person2_drinking'],
// //       person2IntelligenceImportance: json['person2_intelligence_importance'],
// //       person2Sexuality: json['person2_sexuality'],
// //       person2RelationshipOrientation: json['person2_relationship_orientation'],
// //       person2LooksImportant: json['person2_looks_important'],
// //     );
// //   }
// // }


// // // // lib/screens/view_single_profile/view_single_profile_model.dart

// // // class ViewSingleProfileResponse {
// // //   final String status;
// // //   final ViewSingleProfileData? data;

// // //   ViewSingleProfileResponse({required this.status, this.data});

// // //   factory ViewSingleProfileResponse.fromJson(Map<String, dynamic> json) {
// // //     return ViewSingleProfileResponse(
// // //       status: json['status']?.toString() ?? '',
// // //       data: json['data'] != null
// // //           ? ViewSingleProfileData.fromJson(json['data'])
// // //           : null,
// // //     );
// // //   }
// // // }

// // // class ViewSingleProfileData {
// // //   final String id;
// // //   final String username;
// // //   final String email;
// // //   final String profileType; // "single" or "couple"
// // //   final String genderProfileType;
// // //   final String? singleProfileGenderFrom;
// // //   final String? coupleProfileGenderFrom;
// // //   final String? coupleProfileGenderTo;
// // //   final String singleFullName;
// // //   final String coupleFullNameFrom;
// // //   final String coupleFullNameTo;
// // //   final String created;
// // //   final String lastPayment;
// // //   final String expireDate;
// // //   final String lat;
// // //   final String lng;
// // //   final String city;
// // //   final String placeId;
// // //   final String mapUrl;
// // //   final String address;
// // //   final String? lat1;
// // //   final String? lng1;
// // //   final String? city1;
// // //   final String? placeId1;
// // //   final String? mapUrl1;
// // //   final String? address1;
// // //   final String distance;
// // //   final String person1Name;
// // //   final String person2Name;

// // //   // Couple type flags
// // //   final String coupleMaleFemaleSwingers;
// // //   final String coupleMaleFemaleHookupMeetup;
// // //   final String coupleFemaleFemaleSwingers;
// // //   final String coupleFemaleFemaleHookupMeetup;
// // //   final String coupleMaleMaleSwingers;
// // //   final String coupleMaleMaleHookupMeetup;
// // //   final String coupleMaleSwingers;
// // //   final String coupleMaleHookupMeetup;
// // //   final String coupleFemaleSwingers;
// // //   final String coupleFemaleHookupMeetup;
// // //   final String coupleTransgenderSwingers;
// // //   final String coupleTransgenderHookupMeetup;

// // //   final String? text;
// // //   final String? comment;

// // //   // Person 1 fields
// // //   final String person1Dob;
// // //   final int age;
// // //   final String? person1BodyHair;
// // //   final String? height1Type;
// // //   final String? weight1Type;
// // //   final String? person1Height;
// // //   final String? person1Weight;
// // //   final String? person1BodyType;
// // //   final String? person1EthnicBackground;
// // //   final String? person1Piercings;
// // //   final String? person1Tattoos;
// // //   final String? person1LanguageSpoken;
// // //   final String? person1Circumcised;
// // //   final String? person1Smoking;
// // //   final String? person1Drinking;
// // //   final String? person1IntelligenceImportance;
// // //   final String? person1Sexuality;
// // //   final String? person1RelationshipOrientation;
// // //   final String? person1LooksImportant;

// // //   // Person 2 fields
// // //   final String person2Dob;
// // //   final int age2;
// // //   final String? person2BodyHair;
// // //   final String? height2Type;
// // //   final String? weight2Type;
// // //   final String? person2Height;
// // //   final String? person2Weight;
// // //   final String? person2BodyType;
// // //   final String? person2EthnicBackground;
// // //   final String? person2Piercings;
// // //   final String? person2Tattoos;
// // //   final String? person2LanguageSpoken;
// // //   final String? person2Circumcised;
// // //   final String? person2Smoking;
// // //   final String? person2Drinking;
// // //   final String? person2IntelligenceImportance;
// // //   final String? person2Sexuality;
// // //   final String? person2RelationshipOrientation;
// // //   final String? person2LooksImportant;

// // //   ViewSingleProfileData({
// // //     required this.id,
// // //     required this.username,
// // //     required this.email,
// // //     required this.profileType,
// // //     required this.genderProfileType,
// // //     this.singleProfileGenderFrom,
// // //     this.coupleProfileGenderFrom,
// // //     this.coupleProfileGenderTo,
// // //     required this.singleFullName,
// // //     required this.coupleFullNameFrom,
// // //     required this.coupleFullNameTo,
// // //     required this.created,
// // //     required this.lastPayment,
// // //     required this.expireDate,
// // //     required this.lat,
// // //     required this.lng,
// // //     required this.city,
// // //     required this.placeId,
// // //     required this.mapUrl,
// // //     required this.address,
// // //     this.lat1,
// // //     this.lng1,
// // //     this.city1,
// // //     this.placeId1,
// // //     this.mapUrl1,
// // //     this.address1,
// // //     required this.distance,
// // //     required this.person1Name,
// // //     required this.person2Name,
// // //     required this.coupleMaleFemaleSwingers,
// // //     required this.coupleMaleFemaleHookupMeetup,
// // //     required this.coupleFemaleFemaleSwingers,
// // //     required this.coupleFemaleFemaleHookupMeetup,
// // //     required this.coupleMaleMaleSwingers,
// // //     required this.coupleMaleMaleHookupMeetup,
// // //     required this.coupleMaleSwingers,
// // //     required this.coupleMaleHookupMeetup,
// // //     required this.coupleFemaleSwingers,
// // //     required this.coupleFemaleHookupMeetup,
// // //     required this.coupleTransgenderSwingers,
// // //     required this.coupleTransgenderHookupMeetup,
// // //     this.text,
// // //     this.comment,
// // //     required this.person1Dob,
// // //     required this.age,
// // //     this.person1BodyHair,
// // //     this.height1Type,
// // //     this.weight1Type,
// // //     this.person1Height,
// // //     this.person1Weight,
// // //     this.person1BodyType,
// // //     this.person1EthnicBackground,
// // //     this.person1Piercings,
// // //     this.person1Tattoos,
// // //     this.person1LanguageSpoken,
// // //     this.person1Circumcised,
// // //     this.person1Smoking,
// // //     this.person1Drinking,
// // //     this.person1IntelligenceImportance,
// // //     this.person1Sexuality,
// // //     this.person1RelationshipOrientation,
// // //     this.person1LooksImportant,
// // //     required this.person2Dob,
// // //     required this.age2,
// // //     this.person2BodyHair,
// // //     this.height2Type,
// // //     this.weight2Type,
// // //     this.person2Height,
// // //     this.person2Weight,
// // //     this.person2BodyType,
// // //     this.person2EthnicBackground,
// // //     this.person2Piercings,
// // //     this.person2Tattoos,
// // //     this.person2LanguageSpoken,
// // //     this.person2Circumcised,
// // //     this.person2Smoking,
// // //     this.person2Drinking,
// // //     this.person2IntelligenceImportance,
// // //     this.person2Sexuality,
// // //     this.person2RelationshipOrientation,
// // //     this.person2LooksImportant,
// // //   });

// // //   factory ViewSingleProfileData.fromJson(Map<String, dynamic> json) {
// // //     return ViewSingleProfileData(
// // //       id: json['id']?.toString() ?? '',
// // //       username: json['username']?.toString() ?? '',
// // //       email: json['email']?.toString() ?? '',
// // //       profileType: json['profile_type']?.toString() ?? 'single',
// // //       genderProfileType: json['gender_profile_type']?.toString() ?? '',
// // //       singleProfileGenderFrom: json['single_profile_gender_from']?.toString(),
// // //       coupleProfileGenderFrom: json['couple_profile_gender_from']?.toString(),
// // //       coupleProfileGenderTo: json['couple_profile_gender_to']?.toString(),
// // //       singleFullName: json['single_full_name']?.toString() ?? '',
// // //       coupleFullNameFrom: json['couple_full_name_from']?.toString() ?? '',
// // //       coupleFullNameTo: json['couple_full_name_to']?.toString() ?? '',
// // //       created: json['created']?.toString() ?? '',
// // //       lastPayment: json['last_payment']?.toString() ?? '',
// // //       expireDate: json['expire_date']?.toString() ?? '',
// // //       lat: json['lat']?.toString() ?? '',
// // //       lng: json['lng']?.toString() ?? '',
// // //       city: json['city']?.toString() ?? '',
// // //       placeId: json['place_id']?.toString() ?? '',
// // //       mapUrl: json['map_url']?.toString() ?? '',
// // //       address: json['address']?.toString() ?? '',
// // //       lat1: json['lat_1']?.toString(),
// // //       lng1: json['lng_1']?.toString(),
// // //       city1: json['city_1']?.toString(),
// // //       placeId1: json['place_id_1']?.toString(),
// // //       mapUrl1: json['map_url_1']?.toString(),
// // //       address1: json['address_1']?.toString(),
// // //       distance: json['distance']?.toString() ?? '',
// // //       person1Name: json['person1_name']?.toString() ?? 'Person 1',
// // //       person2Name: json['person2_name']?.toString() ?? 'Person 2',
// // //       coupleMaleFemaleSwingers: json['couple_male_female_swingers']?.toString() ?? '0',
// // //       coupleMaleFemaleHookupMeetup: json['couple_male_female_hookup_meetup']?.toString() ?? '0',
// // //       coupleFemaleFemaleSwingers: json['couple_female_female_swingers']?.toString() ?? '0',
// // //       coupleFemaleFemaleHookupMeetup: json['couple_female_female_hookup_meetup']?.toString() ?? '0',
// // //       coupleMaleMaleSwingers: json['couple_male_male_swingers']?.toString() ?? '0',
// // //       coupleMaleMaleHookupMeetup: json['couple_male_male_hookup_meetup']?.toString() ?? '0',
// // //       coupleMaleSwingers: json['couple_male_swingers']?.toString() ?? '0',
// // //       coupleMaleHookupMeetup: json['couple_male_hookup_meetup']?.toString() ?? '0',
// // //       coupleFemaleSwingers: json['couple_female_swingers']?.toString() ?? '0',
// // //       coupleFemaleHookupMeetup: json['couple_female_hookup_meetup']?.toString() ?? '0',
// // //       coupleTransgenderSwingers: json['couple_transgender_swingers']?.toString() ?? '0',
// // //       coupleTransgenderHookupMeetup: json['couple_transgender_hookup_meetup']?.toString() ?? '0',
// // //       text: json['text'],
// // //       comment: json['comment'],
// // //       person1Dob: json['person1_dob']?.toString() ?? '',
// // //       age: json['age'] != null ? int.tryParse(json['age'].toString()) ?? 0 : 0,
// // //       person1BodyHair: json['person1_body_hair'],
// // //       height1Type: json['height1_type'],
// // //       weight1Type: json['weight1_type'],
// // //       person1Height: json['person1_height'],
// // //       person1Weight: json['person1_weight'],
// // //       person1BodyType: json['person1_body_type'],
// // //       person1EthnicBackground: json['person1_ethnic_background'],
// // //       person1Piercings: json['person1_piercings'],
// // //       person1Tattoos: json['person1_tattoos'],
// // //       person1LanguageSpoken: json['person1_language_spoken'],
// // //       person1Circumcised: json['person1_circumcised'],
// // //       person1Smoking: json['person1_smoking'],
// // //       person1Drinking: json['person1_drinking'],
// // //       person1IntelligenceImportance: json['person1_intelligence_importance'],
// // //       person1Sexuality: json['person1_sexuality'],
// // //       person1RelationshipOrientation: json['person1_relationship_orientation'],
// // //       person1LooksImportant: json['person1_looks_important'],
// // //       person2Dob: json['person2_dob']?.toString() ?? '',
// // //       age2: json['age2'] != null ? int.tryParse(json['age2'].toString()) ?? 0 : 0,
// // //       person2BodyHair: json['person2_body_hair'],
// // //       height2Type: json['height2_type'],
// // //       weight2Type: json['weight2_type'],
// // //       person2Height: json['person2_height'],
// // //       person2Weight: json['person2_weight'],
// // //       person2BodyType: json['person2_body_type'],
// // //       person2EthnicBackground: json['person2_ethnic_background'],
// // //       person2Piercings: json['person2_piercings'],
// // //       person2Tattoos: json['person2_tattoos'],
// // //       person2LanguageSpoken: json['person2_language_spoken'],
// // //       person2Circumcised: json['person2_circumcised'],
// // //       person2Smoking: json['person2_smoking'],
// // //       person2Drinking: json['person2_drinking'],
// // //       person2IntelligenceImportance: json['person2_intelligence_importance'],
// // //       person2Sexuality: json['person2_sexuality'],
// // //       person2RelationshipOrientation: json['person2_relationship_orientation'],
// // //       person2LooksImportant: json['person2_looks_important'],
// // //     );
// // //   }
// // // }
