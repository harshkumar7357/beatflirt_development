// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:beatflirt/providers/speed_date_provider.dart';

// // class SpeedDatePage extends ConsumerWidget {
// //   const SpeedDatePage({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final speedDateState = ref.watch(speedDateProvider);
// //     final speedDateNotifier = ref.read(speedDateProvider.notifier);

// //     return Scaffold(
// //       backgroundColor: const Color(0xFF0F0F1A),
// //       body: CustomScrollView(
// //         physics: const BouncingScrollPhysics(),
// //         slivers: [
// //           _buildAppBar(context),
// //           _buildHeroSection(speedDateNotifier),
// //           _buildSectionHeader('Active Sessions', 'Join a room and start matching'),
// //           _buildSessionList(speedDateState, speedDateNotifier),
// //           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAppBar(BuildContext context) {
// //     return SliverAppBar(
// //       floating: true,
// //       pinned: true,
// //       backgroundColor: const Color(0xFF0F0F1A),
// //       elevation: 0,
// //       leading: IconButton(
// //         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
// //         onPressed: () => Navigator.pop(context),
// //       ),
// //       centerTitle: true,
// //       title: const Text(
// //         'SPEED DATE',
// //         style: TextStyle(
// //           color: Colors.white,
// //           fontWeight: FontWeight.w900,
// //           fontSize: 16,
// //           letterSpacing: 2.0,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHeroSection(SpeedDateNotifier notifier) {
// //     return SliverToBoxAdapter(
// //       child: Container(
// //         margin: const EdgeInsets.all(20),
// //         constraints: const BoxConstraints(minHeight: 240),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(30),
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //         ),
// //         child: ClipRRect(
// //           borderRadius: BorderRadius.circular(30),
// //           child: Stack(
// //             children: [
// //               const Positioned(
// //                 right: -40,
// //                 top: -40,
// //                 child: Opacity(
// //                   opacity: 0.1,
// //                   child: FaIcon(FontAwesomeIcons.bolt, size: 220, color: Colors.white),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       'Quick Match',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 28,
// //                         fontWeight: FontWeight.w900,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     const Text(
// //                       '60 seconds to find a connection.\nAre you ready?',
// //                       style: TextStyle(color: Colors.white70, fontSize: 14),
// //                     ),
// //                     const SizedBox(height: 25),
// //                     ElevatedButton(
// //                       onPressed: () => notifier.startSpeedMatch(),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.white,
// //                         foregroundColor: const Color(0xFF4A00E0),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(15),
// //                         ),
// //                         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
// //                       ),
// //                       child: const Text(
// //                         'START MATCHING',
// //                         style: TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSectionHeader(String title, String subtitle) {
// //     return SliverToBoxAdapter(
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               title,
// //               style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             Text(
// //               subtitle,
// //               style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSessionList(SpeedDateState state, SpeedDateNotifier notifier) {
// //     final sessions = state.sessions;
    
// //     if (state.isLoading) {
// //       return const SliverToBoxAdapter(
// //         child: Padding(
// //           padding: EdgeInsets.all(20),
// //           child: Center(
// //             child: CircularProgressIndicator(color: Colors.purple),
// //           ),
// //         ),
// //       );
// //     }

// //     // Fall back to hardcoded data if API fails or returns empty
// //     if (state.error != null || sessions.isEmpty) {
// //       return SliverList(
// //         delegate: SliverChildBuilderDelegate(
// //           (context, index) {
// //             return _buildSessionCard(index, notifier);
// //           },
// //           childCount: 5,
// //         ),
// //       );
// //     }

// //     return SliverList(
// //       delegate: SliverChildBuilderDelegate(
// //         (context, index) {
// //           return _buildSessionCardFromData(sessions[index], notifier);
// //         },
// //         childCount: sessions.length,
// //       ),
// //     );
// //   }

// //   Widget _buildSessionCard(int index, SpeedDateNotifier notifier) {
// //     final types = ['VIP Lounge', 'Global Mixer', 'Casual Dating', 'Fast Friends', 'Late Night'];
// //     final counts = ['124', '89', '256', '45', '12'];
    
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withValues(alpha: 0.05),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 50,
// //             height: 50,
// //             decoration: BoxDecoration(
// //               color: Colors.purple.withValues(alpha: 0.2),
// //               borderRadius: BorderRadius.circular(15),
// //             ),
// //             child: const Center(
// //               child: FaIcon(FontAwesomeIcons.clock, color: Colors.purpleAccent, size: 20),
// //             ),
// //           ),
// //           const SizedBox(width: 15),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   types[index % types.length],
// //                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //                 Text(
// //                   '${counts[index % counts.length]} people active',
// //                   style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           TextButton(
// //             onPressed: () {},
// //             style: TextButton.styleFrom(
// //               backgroundColor: Colors.white.withValues(alpha: 0.1),
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //             ),
// //             child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSessionCardFromData(SpeedDateSession session, SpeedDateNotifier notifier) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withValues(alpha: 0.05),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 50,
// //             height: 50,
// //             decoration: BoxDecoration(
// //               color: Colors.purple.withValues(alpha: 0.2),
// //               borderRadius: BorderRadius.circular(15),
// //             ),
// //             child: const Center(
// //               child: FaIcon(FontAwesomeIcons.clock, color: Colors.purpleAccent, size: 20),
// //             ),
// //           ),
// //           const SizedBox(width: 15),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   session.name,
// //                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //                 Text(
// //                   '${session.activeCount} people active',
// //                   style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           TextButton(
// //             onPressed: () => notifier.joinSession(session.id),
// //             style: TextButton.styleFrom(
// //               backgroundColor: Colors.white.withValues(alpha: 0.1),
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //             ),
// //             child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'dart:convert';
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// // ============================================
// // MODELS
// // ============================================

// class SpeedDateImage {
//   final String profileImage;
//   final String? status;
//   final String dummyProfileImage;
//   final String showProfileImage;

//   SpeedDateImage({
//     required this.profileImage,
//     this.status,
//     required this.dummyProfileImage,
//     required this.showProfileImage,
//   });

//   factory SpeedDateImage.fromJson(Map<String, dynamic> json) {
//     return SpeedDateImage(
//       profileImage: json['profile_image']?.toString() ?? '',
//       status: json['status']?.toString(),
//       dummyProfileImage: json['dummy_profile_image']?.toString() ?? '',
//       showProfileImage: json['show_profile_image']?.toString() ?? '1',
//     );
//   }

//   String get imageUrl => showProfileImage == '1' && profileImage.isNotEmpty
//       ? profileImage
//       : dummyProfileImage;
// }

// class SpeedDate {
//   final String userId;
//   final String id;
//   final String username;
//   final String profileType;
//   final String genderProfileType;
//   final String formattedAddress;
//   final List<SpeedDateImage> images;
//   final int age;
//   final String age2;
//   final String coupleMaleFemaleSwingers;
//   final String coupleFemaleFemaleSwingers;
//   final String coupleMaleMaleSwingers;
//   final String coupleMaleSwingers;
//   final String coupleFemaleSwingers;
//   final String coupleTransgenderSwingers;
//   final String profileShowCountries;
//   final String profileShowCountriesLat;
//   final String profileShowCountriesLng;
//   final String showAge;
//   final String showGender;
//   final String showLocation;
//   final String showRelationship;
//   final String showInterestsPreferences;
//   final String showLanguagePreferences;
//   final String showOnlineStatus;
//   final String showActivityVisitCommentsLike;
//   final String type; // private, public, virtual
//   final String selectDate;
//   final String location;
//   final String details;
//   final String startTimeHours;
//   final String startTimeMinutes;
//   final String status;
//   final String created;

//   SpeedDate({
//     required this.userId,
//     required this.id,
//     required this.username,
//     required this.profileType,
//     required this.genderProfileType,
//     required this.formattedAddress,
//     required this.images,
//     required this.age,
//     required this.age2,
//     required this.coupleMaleFemaleSwingers,
//     required this.coupleFemaleFemaleSwingers,
//     required this.coupleMaleMaleSwingers,
//     required this.coupleMaleSwingers,
//     required this.coupleFemaleSwingers,
//     required this.coupleTransgenderSwingers,
//     required this.profileShowCountries,
//     required this.profileShowCountriesLat,
//     required this.profileShowCountriesLng,
//     required this.showAge,
//     required this.showGender,
//     required this.showLocation,
//     required this.showRelationship,
//     required this.showInterestsPreferences,
//     required this.showLanguagePreferences,
//     required this.showOnlineStatus,
//     required this.showActivityVisitCommentsLike,
//     required this.type,
//     required this.selectDate,
//     required this.location,
//     required this.details,
//     required this.startTimeHours,
//     required this.startTimeMinutes,
//     required this.status,
//     required this.created,
//   });

//   factory SpeedDate.fromJson(Map<String, dynamic> json) {
//     return SpeedDate(
//       userId: json['user_id']?.toString() ?? '',
//       id: json['id']?.toString() ?? '',
//       username: json['username']?.toString() ?? '',
//       profileType: json['profile_type']?.toString() ?? '',
//       genderProfileType: json['gender_profile_type']?.toString() ?? '',
//       formattedAddress: json['formatted_address']?.toString() ?? '',
//       images: (json['image'] as List<dynamic>?)
//               ?.map((e) => SpeedDateImage.fromJson(e))
//               .toList() ??
//           [],
//       age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
//       age2: json['age2']?.toString() ?? '',
//       coupleMaleFemaleSwingers:
//           json['couple_male_female_swingers']?.toString() ?? '0',
//       coupleFemaleFemaleSwingers:
//           json['couple_female_female_swingers']?.toString() ?? '0',
//       coupleMaleMaleSwingers:
//           json['couple_male_male_swingers']?.toString() ?? '0',
//       coupleMaleSwingers: json['couple_male_swingers']?.toString() ?? '0',
//       coupleFemaleSwingers: json['couple_female_swingers']?.toString() ?? '0',
//       coupleTransgenderSwingers:
//           json['couple_transgender_swingers']?.toString() ?? '0',
//       profileShowCountries:
//           json['profile_show_countries']?.toString() ?? '0',
//       profileShowCountriesLat:
//           json['profile_show_countries_lat']?.toString() ?? '',
//       profileShowCountriesLng:
//           json['profile_show_countries_lng']?.toString() ?? '',
//       showAge: json['show_age']?.toString() ?? '1',
//       showGender: json['show_gender']?.toString() ?? '1',
//       showLocation: json['show_location']?.toString() ?? '1',
//       showRelationship: json['show_relationship']?.toString() ?? '1',
//       showInterestsPreferences:
//           json['show_interests_preferences']?.toString() ?? '1',
//       showLanguagePreferences:
//           json['show_language_preferences']?.toString() ?? '1',
//       showOnlineStatus: json['show_online_status']?.toString() ?? '1',
//       showActivityVisitCommentsLike:
//           json['show_activity_visit_comments_like']?.toString() ?? '1',
//       type: json['type']?.toString() ?? 'private',
//       selectDate: json['select_date']?.toString() ?? '',
//       location: json['location']?.toString() ?? '',
//       details: json['details']?.toString() ?? '',
//       startTimeHours: json['start_time_hours']?.toString() ?? '',
//       // startTimeMinutes: json['start_time_minuts']?.toString() ?? '',
//       startTimeMinutes: json['start_time_minutes']?.toString() ?? 
//                   json['start_time_minuts']?.toString() ?? '', // support both
//       status: json['status']?.toString() ?? '1',
//       created: json['created']?.toString() ?? '',
//     );
//   }

//   String get displayName => type == 'private' ? 'Private Place' : type == 'public' ? 'Public Place' : 'Virtual Date';

//   String get formattedTime {
//     if (startTimeHours.isNotEmpty && startTimeMinutes.isNotEmpty) {
//       return '${startTimeHours.padLeft(2, '0')}:${startTimeMinutes.padLeft(2, '0')}';
//     }
//     return '';
//   }

//   String get displayDate {
//     try {
//       final date = DateFormat('MM/dd/yyyy').parse(selectDate);
//       return DateFormat('MMM dd, yyyy').format(date);
//     } catch (e) {
//       return selectDate;
//     }
//   }

//   String get fullDateTime {
//     final dateStr = displayDate;
//     if (formattedTime.isNotEmpty) {
//       return '$dateStr - $formattedTime';
//     }
//     return dateStr;
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'couple_male_female_swingers': coupleMaleFemaleSwingers,
//       'couple_female_female_swingers': coupleFemaleFemaleSwingers,
//       'couple_male_male_swingers': coupleMaleMaleSwingers,
//       'couple_male_swingers': coupleMaleSwingers,
//       'couple_female_swingers': coupleFemaleSwingers,
//       'couple_transgender_swingers': coupleTransgenderSwingers,
//       'type': type,
//       'select_date': selectDate,
//       'location': location,
//       'details': details,
//       'start_time_hours': startTimeHours,
//       // 'start_time_minuts': startTimeMinutes,
//       'start_time_minutes': startTimeMinutes, // not minuts
//     };
//   }
// }

// // ============================================
// // API SERVICE
// // ============================================

// // class SpeedDateApiService {
// //   // static const String baseUrl = 'https://beatflirtevent.com/api/App/location';
// //   static const String baseUrl = 'https://app.beatflirtevent.com/App/location';

// //   // Add your auth token here
// //   // static const String authToken = 'YOUR_AUTH_TOKEN_HERE';
  

// //   static Future<Map<String, String>> getHeaders() async {
// //      final token = await AuthService.getToken();
// //     return {
// //       'Content-Type': 'application/json',
// //       // 'Authorization': 'Bearer $authToken',
// //       'Authorization': 'Bearer $token',
// //     };
// //   }
// class SpeedDateApiService {
//   static const String baseUrl = 'https://app.beatflirtevent.com/App/location';

//   static Future<Map<String, String>> getHeaders() async {
//     final token = await AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       throw Exception('Auth token is missing - please login again');
//     }
//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//       'access-token': token,
//     };
//   }

//   /// Fetch all speed dates (other users)
//   // static Future<List<SpeedDate>> fetchAllSpeedDates({
//   //   String searchKeyword = '',
//   //   // String lat = '0',
//   //   // String lng = '0',
//   //   String lat = '', // default to '0' if not provided
//   //   String lng = '', // default to '0' if not provided
//   //   List<String> profileTypeArray = const [],
//   // }) async {
//   //   final token = (await AuthService.getToken())?.trim() ?? '';
//   //   final response = await http.post(
//   //     Uri.parse('$baseUrl/get_all_speed_data'),
//   //     headers: await getHeaders(),
//   //     body: jsonEncode({
//   //       'token': token,
//   //       'user_type': 'other',
//   //       'search_keyword': searchKeyword,
//   //       'lat': lat,
//   //       'lng': lng,
//   //       'profileTypeArray': profileTypeArray,
//   //     }),
//   //   );

//   //   if (response.statusCode == 200) {
//   //     final data = jsonDecode(response.body);
//   //     debugPrint('Full API Response: $data'); // <--- ADD THIS
//   //     if (data['status'] == '200' || data['status'] == 200) {
//   //       // return (data['data'] as List<dynamic>)
//   //       //     .map((e) => SpeedDate.fromJson(e))
//   //       //     .toList();

//   //       List<SpeedDate> dates = (data['data'] as List<dynamic>)
//   //       .map((e) => SpeedDate.fromJson(e))
//   //       .toList();
//   //       debugPrint('Count of dates found: ${dates.length}');
//   //       return dates;
//   //     }
//   //     throw Exception('Failed to load speed dates');
//   //   }
//   //   throw Exception('Failed to load speed dates: ${response.statusCode}');
//   // }

// static Future<List<SpeedDate>> fetchAllSpeedDates({
//   String searchKeyword = '',
//   String lat = '', // Use empty string instead of '0'
//   String lng = '', 
//   List<String> profileTypeArray = const [],
// }) async {
//   final token = (await AuthService.getToken())?.trim() ?? '';
  
//   // 1. Use standard form encoding by NOT using jsonEncode in the body
//   // 2. Remove 'Content-Type': 'application/json' from headers
//   final response = await http.post(
//     Uri.parse('$baseUrl/get_all_speed_data'),
//     headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//       'access-token': token,
//     },
//     body: {
//       'token': token,
//       'user_type': 'other',
//       'search_keyword': searchKeyword,
//       'lat': lat,
//       'lng': lng,
//       // Servers often expect arrays as comma-separated strings in form-data
//       'profileTypeArray': profileTypeArray.join(','), 
//     },
//   );

//   debugPrint('Status Code: ${response.statusCode}');
//   debugPrint('Response Body: ${response.body}');

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     if (data['status'].toString() == '200') {
//       return (data['data'] as List).map((e) => SpeedDate.fromJson(e)).toList();
//     }
//   }
  
//   // If server returns 500, return empty list instead of crashing the UI
//   if (response.statusCode == 500) return []; 
  
//   throw Exception('Failed to load speed dates: ${response.statusCode}');
// }

//   /// Fetch my speed dates
//   static Future<List<SpeedDate>> fetchMySpeedDates({
//     String searchKeyword = '',
//     String lat = '0',
//     String lng = '0',
//     List<String> profileTypeArray = const [],
//   }) async {
//     final token = (await AuthService.getToken())?.trim() ?? '';
//     final response = await http.post(
//       Uri.parse('$baseUrl/get_all_speed_data'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         'token': token,
//         'user_type': 'me',
//         'search_keyword': searchKeyword,
//         'lat': lat,
//         'lng': lng,
//         'profileTypeArray': profileTypeArray,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == '200' || data['status'] == 200) {
//         return (data['data'] as List<dynamic>)
//             .map((e) => SpeedDate.fromJson(e))
//             .toList();
//       }
//       throw Exception('Failed to load my speed dates');
//     }
//     throw Exception('Failed to load my speed dates: ${response.statusCode}');
//   }

//   /// Save/Create a new speed date
// //   static Future<bool> saveSpeedDate(SpeedDate speedDate) async {
// //     final response = await http.post(
// //       Uri.parse('$baseUrl/save_speed_data'),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         'couple_male_female_swingers': speedDate.coupleMaleFemaleSwingers,
// //         'couple_female_female_swingers': speedDate.coupleFemaleFemaleSwingers,
// //         'couple_male_male_swingers': speedDate.coupleMaleMaleSwingers,
// //         'couple_male_swingers': speedDate.coupleMaleSwingers,
// //         'couple_female_swingers': speedDate.coupleFemaleSwingers,
// //         'couple_transgender_swingers': speedDate.coupleTransgenderSwingers,
// //         'details': speedDate.details,
// //         'lat': speedDate.profileShowCountriesLat,
// //         'lng': speedDate.profileShowCountriesLng,
// //         'location': speedDate.location,
// //         'select_date': speedDate.selectDate,
// //         'start_time_hours': speedDate.startTimeHours,
// //         'start_time_minuts': speedDate.startTimeMinutes,
// //         'type': speedDate.type,
// //       }),
// //     );

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['status'] == '200' || data['status'] == 200;
// //     }
// //     return false;
// //   }
// // }


// /// Save/Create - returns {success: bool, message: String}
//   static Future<Map<String, dynamic>> saveSpeedDate(SpeedDate speedDate) async {
//     try {
//       final headers = await getHeaders();
      
//       // FIXED TYPO: start_time_minutes (not minuts)
//       final body = {
//         'couple_male_female_swingers': speedDate.coupleMaleFemaleSwingers,
//         'couple_female_female_swingers': speedDate.coupleFemaleFemaleSwingers,
//         'couple_male_male_swingers': speedDate.coupleMaleMaleSwingers,
//         'couple_male_swingers': speedDate.coupleMaleSwingers,
//         'couple_female_swingers': speedDate.coupleFemaleSwingers,
//         'couple_transgender_swingers': speedDate.coupleTransgenderSwingers,
//         'details': speedDate.details,
//         'lat': speedDate.profileShowCountriesLat.isEmpty ? '0' : speedDate.profileShowCountriesLat,
//         'lng': speedDate.profileShowCountriesLng.isEmpty ? '0' : speedDate.profileShowCountriesLng,
//         'location': speedDate.location,
//         'select_date': speedDate.selectDate,
//         'start_time_hours': speedDate.startTimeHours,
//         'start_time_minutes': speedDate.startTimeMinutes, // <-- FIXED
//         'type': speedDate.type,
//       };

//       debugPrint('POST $baseUrl/save_speed_data');
//       debugPrint('Headers: $headers');
//       debugPrint('Body: ${jsonEncode(body)}');

//       final token = (await AuthService.getToken())?.trim() ?? '';
//       final response = await http.post(
//         Uri.parse('$baseUrl/save_speed_data'),
//         headers: headers,
//         body: jsonEncode({...body, 'token': token}),
//       ).timeout(const Duration(seconds: 30));

//       debugPrint('Status: ${response.statusCode}');
//       debugPrint('Response: ${response.body}');

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && (data['status'] == 200 || data['status'] == '200')) {
//         return {'success': true, 'message': data['message'] ?? 'Created'};
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? data['error'] ?? 'Server error ${response.statusCode}'
//         };
//       }
//     } catch (e) {
//       debugPrint('saveSpeedDate ERROR: $e');
//       return {'success': false, 'message': e.toString()};
//     }
//   }
// }
// // ============================================
// // CUSTOM WIDGETS
// // ============================================


// // ============================================
// // FIXED SpeedDateCard - No overlapping
// // Replace your existing SpeedDateCard with this
// // ============================================

// class SpeedDateCard extends StatelessWidget {
//   final SpeedDate speedDate;
//   final bool isMyDate;
//   final VoidCallback? onTap;
//   final VoidCallback? onDetailsTap;
//   final VoidCallback? onDelete;

//   const SpeedDateCard({
//     super.key,
//     required this.speedDate,
//     this.isMyDate = false,
//     this.onTap,
//     this.onDetailsTap,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final imageUrl = speedDate.images.isNotEmpty
//         ? speedDate.images.first.imageUrl
//         : '';

//     return GestureDetector(
//       onTap: onTap ?? onDetailsTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF5A1845),
//               Color(0xFF1A0A2E),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.2),
//               blurRadius: 12,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         // KEY FIX: Use ClipRRect so the bottom button
//         // respects the card's rounded corners
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // ── Scrollable content area ──────────────────
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Profile Image
//                       Container(
//                         width: 64,
//                         height: 54,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.rectangle,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: const Color(0xFFE91E63),
//                             width: 3,
//                           ),
//                           image: imageUrl.isNotEmpty
//                               ? DecorationImage(
//                                   image: NetworkImage(imageUrl),
//                                   fit: BoxFit.cover,
//                                 )
//                               : null,
//                           color: const Color(0xFF3D0B30),
//                         ),
//                         child: imageUrl.isEmpty
//                             ? const Icon(
//                                 Icons.person,
//                                 size: 40,
//                                 color: Colors.white54,
//                               )
//                             : null,
//                       ),

//                       const SizedBox(height: 6),

//                       // Username
//                       Text(
//                         speedDate.username,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       const SizedBox(height: 4),

//                       // Age badge
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFE91E63),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           'Age ${speedDate.age}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 6),

//                       // Location
//                       Text(
//                         speedDate.formattedAddress,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 10,
//                         ),
//                         textAlign: TextAlign.center,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       const SizedBox(height: 4),

//                       // Type
//                       Text(
//                         speedDate.displayName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       const SizedBox(height: 3),

//                       // Date & Time
//                       Text(
//                         speedDate.fullDateTime,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 10,
//                         ),
//                         textAlign: TextAlign.center,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       const Spacer(),

//                       // Delete button for my dates
//                       if (isMyDate && onDelete != null) ...[
//                         const SizedBox(height: 4),
//                         GestureDetector(
//                           onTap: onDelete,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: const Color(0xFFE91E63),
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.delete_outline,
//                                   color: Color(0xFFE91E63),
//                                   size: 16,
//                                 ),
//                                 SizedBox(width: 4),
//                                 Text(
//                                   'Delete',
//                                   style: TextStyle(
//                                     color: Color(0xFFE91E63),
//                                     fontSize: 11,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),

//               // ── "View Details" button pinned to the bottom ──
//               // It is INSIDE the Column, NOT a Positioned overlay,
//               // so it never overlaps the content above.
//               if (!isMyDate && onDetailsTap != null)
//                 GestureDetector(
//                   onTap: onDetailsTap,
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFE91E63),
//                       // No borderRadius needed — ClipRRect handles it
//                     ),
//                     child: const Text(
//                       'View Details',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // class SpeedDateCard extends StatelessWidget {
// //   final SpeedDate speedDate;
// //   final bool isMyDate;
// //   final VoidCallback? onTap;
// //   final VoidCallback? onDetailsTap;
// //   final VoidCallback? onDelete;

// //   const SpeedDateCard({
// //     super.key,
// //     required this.speedDate,
// //     this.isMyDate = false,
// //     this.onTap,
// //     this.onDetailsTap,
// //     this.onDelete,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final imageUrl = speedDate.images.isNotEmpty
// //         ? speedDate.images.first.imageUrl
// //         : '';

// //     final bottomPadding = !isMyDate && onDetailsTap != null ? 50.0 : 18.0;

// //     return GestureDetector(
// //       onTap: onTap ?? onDetailsTap,
// //       child: Container(
// //         decoration: BoxDecoration(
// //           gradient: const LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [
// //               Color(0xFF5A1845),
// //               Color(0xFF1A0A2E),
// //             ],
// //           ),
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withValues(alpha: 0.2),
// //               blurRadius: 12,
// //               offset: const Offset(0, 6),
// //             ),
// //           ],
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.only(
// //             left: 12,
// //             right: 12,
// //             top: 10,
// //             bottom: bottomPadding,
// //           ),
// //           child: Stack(
// //             alignment: Alignment.topCenter,
// //             children: [
// //               Align(
// //                 alignment: Alignment.topCenter,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   mainAxisSize: MainAxisSize.max,
// //                   children: [
// //                 // Profile Image
// //                 Container(
// //                   margin: const EdgeInsets.only(top: 8),
// //                   width: 64,
// //                   height: 54,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.rectangle,
// //                     borderRadius: BorderRadius.circular(16),
// //                     border: Border.all(color: const Color(0xFFE91E63), width: 3),
// //                     image: imageUrl.isNotEmpty
// //                         ? DecorationImage(
// //                             image: NetworkImage(imageUrl),
// //                             fit: BoxFit.cover,
// //                           )
// //                         : null,
// //                     color: const Color(0xFF3D0B30),
// //                   ),
// //                   child: imageUrl.isEmpty
// //                       ? const Icon(
// //                           Icons.person,
// //                           size: 40,
// //                           color: Colors.white54,
// //                         )
// //                       : null,
// //                 ),
// //                 const SizedBox(height: 5),

// //                 // Username
// //                 Text(
// //                   speedDate.username,
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 13,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                   textAlign: TextAlign.center,
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //                 const SizedBox(height: 4),

// //                 // Age badge
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 10,
// //                     vertical: 2,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFFE91E63),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Text(
// //                     'Age ${speedDate.age}',
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),

// //                 // Location
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 8),
// //                   child: Text(
// //                     speedDate.formattedAddress,
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 10,
// //                     ),
// //                     textAlign: TextAlign.center,
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),

// //                 // Type
// //                 Text(
// //                   speedDate.displayName,
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //                 const SizedBox(height: 3),

// //                 // Date
// //                 Text(
// //                   speedDate.fullDateTime,
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 10,
// //                   ),
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //                 const Spacer(),

// //                 // Delete button for my dates
// //                 if (isMyDate && onDelete != null)
// //                   IconButton(
// //                     onPressed: onDelete,
// //                     icon: const Icon(
// //                       Icons.delete_outline,
// //                       color: Color(0xFFE91E63),
// //                       size: 20,
// //                     ),
// //                     padding: EdgeInsets.zero,
// //                     constraints: const BoxConstraints(
// //                       minWidth: 0,
// //                       minHeight: 0,
// //                     ),
// //                   ),

// //                 if (isMyDate && onDelete != null) const SizedBox(height: 8),
// //               ],
// //             ),
// //               ),

// //             // Details button overlay (for non-my dates)
// //             if (!isMyDate && onDetailsTap != null)
// //               Positioned(
// //                 bottom: 0,
// //                 left: 0,
// //                 right: 0,
// //                 child: GestureDetector(
// //                   onTap: onDetailsTap,
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(vertical: 8),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFFE91E63),
// //                       borderRadius: const BorderRadius.only(
// //                         bottomLeft: Radius.circular(16),
// //                         bottomRight: Radius.circular(16),
// //                       ),
// //                     ),
// //                     child: const Text(
// //                       'View Details',
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 12,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //       ),
// //     );
// //   }

// // }

// class TabButton extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const TabButton({
//     super.key,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF2D0A3E) : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? const Color(0xFF2D0A3E) : const Color(0xFFEEEEEE),
//             width: 1,
//           ),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : const Color(0xFF666666),
//             fontSize: 13,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FilterIcon extends StatelessWidget {
//   final VoidCallback onTap;

//   const FilterIcon({super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xFFEEEEEE)),
//         ),
//         child: Icon(
//           Icons.tune,
//           size: 20,
//           color: const Color(0xFF5A1845),
//         ),
//       ),
//     );
//   }
// }

// // ============================================
// // SPEED DATE DETAILS DIALOG
// // ============================================

// class SpeedDateDetailsDialog extends StatelessWidget {
//   final SpeedDate speedDate;

//   const SpeedDateDetailsDialog({super.key, required this.speedDate});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.all(20),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF5A1845), Color(0xFF2D0A3E)],
//                 ),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   topRight: Radius.circular(16),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Speed Date Details',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ],
//               ),
//             ),

//             // Content
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildDetailRow('Details:', speedDate.details),
//                   const SizedBox(height: 12),
//                   _buildDetailRow('Location:', speedDate.location),
//                   const SizedBox(height: 12),
//                   _buildDetailRow('Date:', speedDate.displayDate),
//                   if (speedDate.formattedTime.isNotEmpty) ...[
//                     const SizedBox(height: 12),
//                     _buildDetailRow('Time:', speedDate.formattedTime),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return RichText(
//       text: TextSpan(
//         style: const TextStyle(fontSize: 14, color: Colors.black87),
//         children: [
//           TextSpan(
//             text: label,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           TextSpan(text: ' $value'),
//         ],
//       ),
//     );
//   }
// }

// // ============================================
// // CREATE SPEED DATE PAGE
// // ============================================

// class CreateSpeedDatePage extends StatefulWidget {
//   final Function(bool) onSuccess;

//   const CreateSpeedDatePage({super.key, required this.onSuccess});

//   @override
//   State<CreateSpeedDatePage> createState() => _CreateSpeedDatePageState();
// }

// class _CreateSpeedDatePageState extends State<CreateSpeedDatePage> {
//   String _selectedType = 'private'; // private, public, virtual
//   DateTime? _selectedDate;
//   String _startHours = '';
//   String _startMinutes = '';

//   // With checkboxes
//   bool _coupleFM = true;
//   bool _coupleFF = false;
//   bool _coupleMM = false;
//   bool _male = false;
//   bool _female = false;
//   bool _transgender = false;

//   // Location (for private/public)
//   final TextEditingController _locationController = TextEditingController();
//   String _locationLat = '0';
//   String _locationLng = '0';

//   // Details
//   final TextEditingController _detailsController = TextEditingController();

//   bool _isSaving = false;

//   @override
//   void dispose() {
//     _locationController.dispose();
//     _detailsController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF5A1845),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() => _selectedDate = picked);
//     }
//   }

//   // Future<void> _saveSpeedDate() async {
//   //   if (_selectedDate == null) {
//   //     _showError('Please select a date');
//   //     return;
//   //   }

//   //   if (_selectedType != 'virtual' && _locationController.text.isEmpty) {
//   //     _showError('Please enter a location');
//   //     return;
//   //   }

//   //   if (_detailsController.text.isEmpty) {
//   //     _showError('Please enter details');
//   //     return;
//   //   }

//   //   setState(() => _isSaving = true);

//   //   final speedDate = SpeedDate(
//   //     userId: '',
//   //     id: '',
//   //     username: '',
//   //     profileType: _coupleFM || _coupleFF || _coupleMM ? 'couple' : 'single',
//   //     genderProfileType: '',
//   //     formattedAddress: _locationController.text,
//   //     images: [],
//   //     age: 0,
//   //     age2: '',
//   //     coupleMaleFemaleSwingers: _coupleFM ? '1' : '0',
//   //     coupleFemaleFemaleSwingers: _coupleFF ? '1' : '0',
//   //     coupleMaleMaleSwingers: _coupleMM ? '1' : '0',
//   //     coupleMaleSwingers: _male ? '1' : '0',
//   //     coupleFemaleSwingers: _female ? '1' : '0',
//   //     coupleTransgenderSwingers: _transgender ? '1' : '0',
//   //     profileShowCountries: '0',
//   //     profileShowCountriesLat: _locationLat,
//   //     profileShowCountriesLng: _locationLng,
//   //     showAge: '1',
//   //     showGender: '1',
//   //     showLocation: '1',
//   //     showRelationship: '1',
//   //     showInterestsPreferences: '1',
//   //     showLanguagePreferences: '1',
//   //     showOnlineStatus: '1',
//   //     showActivityVisitCommentsLike: '1',
//   //     type: _selectedType,
//   //     selectDate: DateFormat('MM/dd/yyyy').format(_selectedDate!),
//   //     location: _locationController.text,
//   //     details: _detailsController.text,
//   //     startTimeHours: _startHours,
//   //     startTimeMinutes: _startMinutes,
//   //     status: '1',
//   //     created: DateFormat('yyyy-MM-dd').format(DateTime.now()),
//   //   );

//   //   try {
//   //     final success = await SpeedDateApiService.saveSpeedDate(speedDate);
//   //     setState(() => _isSaving = false);

//   //     if (success) {
//   //       widget.onSuccess(true);
//   //       Navigator.pop(context);
//   //     } else {
//   //       _showError('Failed to create speed date');
//   //     }
//   //   } catch (e) {
//   //     setState(() => _isSaving = false);
//   //     _showError('Failed to create speed date: $e');
//   //   }
//   // }
//   Future<void> _saveSpeedDate() async {
//   if (_selectedDate == null) {
//     _showError('Please select a date');
//     return;
//   }
//   if (_selectedType != 'virtual' && _locationController.text.trim().isEmpty) {
//     _showError('Please enter a location');
//     return;
//   }
//   if (_detailsController.text.trim().isEmpty) {
//     _showError('Please enter details');
//     return;
//   }

//   // Validate at least one "with" is selected
//   if (!_coupleFM && !_coupleFF && !_coupleMM && !_male && !_female && !_transgender) {
//     _showError('Please select at least one preference');
//     return;
//   }

//   setState(() => _isSaving = true);

//   final speedDate = SpeedDate(
//     userId: '',
//     id: '',
//     username: '',
//     profileType: _coupleFM || _coupleFF || _coupleMM ? 'couple' : 'single',
//     genderProfileType: '',
//     formattedAddress: _locationController.text,
//     images: [],
//     age: 0,
//     age2: '',
//     coupleMaleFemaleSwingers: _coupleFM ? '1' : '0',
//     coupleFemaleFemaleSwingers: _coupleFF ? '1' : '0',
//     coupleMaleMaleSwingers: _coupleMM ? '1' : '0',
//     coupleMaleSwingers: _male ? '1' : '0',
//     coupleFemaleSwingers: _female ? '1' : '0',
//     coupleTransgenderSwingers: _transgender ? '1' : '0',
//     profileShowCountries: '0',
//     profileShowCountriesLat: _locationLat,
//     profileShowCountriesLng: _locationLng,
//     showAge: '1',
//     showGender: '1',
//     showLocation: '1',
//     showRelationship: '1',
//     showInterestsPreferences: '1',
//     showLanguagePreferences: '1',
//     showOnlineStatus: '1',
//     showActivityVisitCommentsLike: '1',
//     type: _selectedType,
//     selectDate: DateFormat('MM/dd/yyyy').format(_selectedDate!),
//     location: _locationController.text,
//     details: _detailsController.text,
//     startTimeHours: _startHours.padLeft(2, '0'),
//     startTimeMinutes: _startMinutes.padLeft(2, '0'),
//     status: '1',
//     created: DateFormat('yyyy-MM-dd').format(DateTime.now()),
//   );

//   try {
//     final result = await SpeedDateApiService.saveSpeedDate(speedDate);
//     setState(() => _isSaving = false);

//     if (result['success'] == true) {
//       widget.onSuccess(true);
//       Navigator.pop(context);
//     } else {
//       _showError('Failed: ${result['message']}'); // NOW YOU SEE REAL ERROR
//     }
//   } catch (e) {
//     setState(() => _isSaving = false);
//     _showError('Exception: $e');
//   }
// }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red.shade400,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F0F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF2D0A3E)),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Create Speed Date',
//           style: TextStyle(
//             color: Color(0xFF2D0A3E),
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Type Selection
//                 // _buildSectionTitle('Type *'),
//                 // Row(
//                 //   children: [
//                 //     _buildRadioOption('Private Place', 'private'),
//                 //     const SizedBox(width: 16),
//                 //     _buildRadioOption('Public Place', 'public'),
//                 //     const SizedBox(width: 16),
//                 //     _buildRadioOption('Virtual Date', 'virtual'),
//                 //   ],
//                 // ),

//                 _buildSectionTitle('Type *'),
//                 Wrap(
//                   spacing: 20,
//                   runSpacing: 12,
//                   children: [
//                     _buildRadioOption('Private Place', 'private'),
//                     _buildRadioOption('Public Place', 'public'),
//                     _buildRadioOption('Virtual Date', 'virtual'),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // When (Date)
//                 _buildSectionTitle('When *'),
//                 GestureDetector(
//                   onTap: _selectDate,
//                   child: Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: const Color(0xFF5A1845)),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _selectedDate != null
//                               ? DateFormat('MM/dd/yyyy').format(_selectedDate!)
//                               : 'Select Date',
//                           style: TextStyle(
//                             color: _selectedDate != null
//                                 ? Colors.black87
//                                 : Colors.grey,
//                           ),
//                         ),
//                         const Icon(
//                           Icons.calendar_today,
//                           color: Color(0xFF5A1845),
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Start Time (only for non-virtual)
//                 if (_selectedType != 'virtual') ...[
//                   _buildSectionTitle('Start Time'),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildTimeField(
//                           'Hours',
//                           _startHours,
//                           (value) => setState(() => _startHours = value),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildTimeField(
//                           'Minutes',
//                           _startMinutes,
//                           (value) => setState(() => _startMinutes = value),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                 ],

//                 // With Selection
//                 _buildSectionTitle('With *'),
//                 _buildCheckbox('♀♂ Couple F/M', _coupleFM, (v) => setState(() => _coupleFM = v)),
//                 _buildCheckbox('♀♀ Couple F/F', _coupleFF, (v) => setState(() => _coupleFF = v)),
//                 _buildCheckbox('♂♂ Couple M/M', _coupleMM, (v) => setState(() => _coupleMM = v)),
//                 _buildCheckbox('♂ Male', _male, (v) => setState(() => _male = v)),
//                 _buildCheckbox('♀ Female', _female, (v) => setState(() => _female = v)),
//                 _buildCheckbox('⚧ Transgender', _transgender, (v) => setState(() => _transgender = v)),
//                 const SizedBox(height: 24),

//                 // Where (for private/public)
//                 if (_selectedType != 'virtual') ...[
//                   _buildSectionTitle('Where *'),
//                   TextField(
//                     controller: _locationController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Location',
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Color(0xFF5A1845)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Color(0xFF5A1845), width: 2),
//                       ),
//                       contentPadding: const EdgeInsets.all(14),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],

//                 // Details
//                 _buildSectionTitle('Details *'),
//                 TextField(
//                   controller: _detailsController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     hintText: 'Leave a comment here',
//                     hintStyle: const TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Color(0xFF5A1845)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Color(0xFF5A1845), width: 2),
//                     ),
//                     contentPadding: const EdgeInsets.all(14),
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // Submit Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isSaving ? null : _saveSpeedDate,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF2D0A3E),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: _isSaving
//                         ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Text(
//                             'Post Speed Date',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF2D0A3E),
//         ),
//       ),
//     );
//   }

//   // Widget _buildRadioOption(String label, String value) {
//   //   final isSelected = _selectedType == value;
//   //   return Expanded(
//   //     child: GestureDetector(
//   //       onTap: () => setState(() => _selectedType = value),
//   //       child: Row(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           Container(
//   //             width: 20,
//   //             height: 20,
//   //             decoration: BoxDecoration(
//   //               shape: BoxShape.circle,
//   //               border: Border.all(
//   //                 color: isSelected ? const Color(0xFF5A1845) : const Color(0xFFCCCCCC),
//   //                 width: 2,
//   //               ),
//   //             ),
//   //             child: isSelected
//   //                 ? Center(
//   //                     child: Container(
//   //                       width: 10,
//   //                       height: 10,
//   //                       decoration: const BoxDecoration(
//   //                         shape: BoxShape.circle,
//   //                         color: Color(0xFF5A1845),
//   //                       ),
//   //                     ),
//   //                   )
//   //                 : null,
//   //           ),
//   //           const SizedBox(width: 8),
//   //           Text(
//   //             label,
//   //             style: TextStyle(
//   //               overflow: TextOverflow.ellipsis,
//   //               fontSize: 13,
//   //               color: isSelected ? const Color(0xFFC2185B) : const Color(0xFF666666),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildRadioOption(String label, String value) {
//   final isSelected = _selectedType == value;
//   return GestureDetector(
//     onTap: () => setState(() => _selectedType = value),
//     child: Row(
//       mainAxisSize: MainAxisSize.min, // <-- KEY FIX
//       children: [
//         Container(
//           width: 20,
//           height: 20,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: isSelected ? const Color(0xFF5A1845) : const Color(0xFFCCCCCC),
//               width: 2,
//             ),
//           ),
//           child: isSelected
//               ? Center(
//                   child: Container(
//                     width: 10,
//                     height: 10,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Color(0xFF5A1845),
//                     ),
//                   ),
//                 )
//               : null,
//         ),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             color: isSelected ? const Color(0xFFC2185B) : const Color(0xFF666666),
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//           ),
//         ),
//       ],
//     ),
//   );
// }

//   Widget _buildCheckbox(String label, bool value, ValueChanged<bool> onChanged) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Checkbox(
//             value: value,
//             onChanged: (v) => onChanged(v ?? false),
//             activeColor: const Color(0xFF5A1845),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFFC2185B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeField(
//     String hint,
//     String value,
//     ValueChanged<String> onChanged,
//   ) {
//     return TextField(
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.grey),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFF5A1845), width: 2),
//         ),
//         contentPadding: const EdgeInsets.all(14),
//       ),
//       onChanged: onChanged,
//       maxLength: 2,
//     );
//   }
// }

// // ============================================
// // MAIN SPEED DATE PAGE
// // ============================================

// class SpeedDatePage extends StatefulWidget {
//   const SpeedDatePage({super.key});

//   @override
//   State<SpeedDatePage> createState() => _SpeedDatePageState();
// }

// class _SpeedDatePageState extends State<SpeedDatePage> {
//   int _selectedTab = 0; // 0: All, 1: View All, 2: My Speed Dates
//   List<SpeedDate> _allSpeedDates = [];
//   List<SpeedDate> _mySpeedDates = [];
//   bool _isLoading = true;
//   String _searchKeyword = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   // Future<void> _loadData() async {
//   //   setState(() => _isLoading = true);
//   //   try {
//   //     final results = await Future.wait([
//   //       SpeedDateApiService.fetchAllSpeedDates(searchKeyword: _searchKeyword),
//   //       SpeedDateApiService.fetchMySpeedDates(searchKeyword: _searchKeyword),
//   //     ]);

//   //     setState(() {
//   //       _allSpeedDates = results[0];
//   //       _mySpeedDates = results[1];
//   //       _isLoading = false;
//   //     });
//   //   } catch (e) {
//   //     setState(() => _isLoading = false);
//   //     _showErrorSnackBar('Failed to load data: $e');
//   //   }
//   // }
//   Future<void> _loadData() async {
//   setState(() => _isLoading = true);
  
//   try {
//     // Load them separately so if one fails, the other still works
//     final allDates = await SpeedDateApiService.fetchAllSpeedDates(searchKeyword: _searchKeyword)
//         .catchError((e) {
//           debugPrint('Error fetching all dates: $e');
//           return <SpeedDate>[]; // Return empty list on error
//         });

//     final myDates = await SpeedDateApiService.fetchMySpeedDates(searchKeyword: _searchKeyword)
//         .catchError((e) {
//           debugPrint('Error fetching my dates: $e');
//           return <SpeedDate>[];
//         });

//     setState(() {
//       _allSpeedDates = allDates;
//       _mySpeedDates = myDates;
//       _isLoading = false;
//     });
//   } catch (e) {
//     setState(() => _isLoading = false);
//     _showErrorSnackBar('Unexpected error: $e');
//   }
// }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red.shade400,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green.shade600,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   List<SpeedDate> get _currentList {
//     if (_selectedTab == 2) return _mySpeedDates;
//     return _allSpeedDates;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F0F5),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5A1845),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Speed Date',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: Icon(
//               Icons.location_on,
//               color: Colors.yellow.shade700,
//               size: 20,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Tabs and Search
//           Container(
//             color: const Color(0xFFF8F0F5),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Title with count
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Speed Date (${_currentList.length})',
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2D0A3E),
//                       ),
//                     ),
//                     FilterIcon(onTap: () {
//                       // TODO: Implement filter
//                     }),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // Tab Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TabButton(
//                         label: 'Speed Date',
//                         isSelected: _selectedTab == 0,
//                         onTap: () => setState(() => _selectedTab = 0),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: TabButton(
//                         label: 'View All Speed Date',
//                         isSelected: _selectedTab == 1,
//                         onTap: () => setState(() => _selectedTab = 1),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: TabButton(
//                         label: 'View My Speed Date',
//                         isSelected: _selectedTab == 2,
//                         onTap: () => setState(() => _selectedTab = 2),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Content
//           Expanded(
//             child: _isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       color: Color(0xFF5A1845),
//                     ),
//                   )
//                 : _currentList.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.event_busy,
//                               size: 80,
//                               color: Colors.grey.shade400,
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               _selectedTab == 2
//                                   ? 'No speed dates created yet'
//                                   : 'No speed dates available',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                             if (_selectedTab == 2) ...[
//                               const SizedBox(height: 24),
//                               ElevatedButton(
//                                 onPressed: () => _navigateToCreate(),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF2D0A3E),
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 32,
//                                     vertical: 14,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   'Create Speed Date',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       )
//                     : GridView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           // childAspectRatio: 0.70,
//                           childAspectRatio: 0.62, 
//                           crossAxisSpacing: 8,
//                           mainAxisSpacing: 8,
//                         ),
//                         itemCount: _currentList.length,
//                         itemBuilder: (context, index) {
//                           final speedDate = _currentList[index];
//                           return SpeedDateCard(
//                             speedDate: speedDate,
//                             isMyDate: _selectedTab == 2,
//                             onDetailsTap: () => _showDetails(speedDate),
//                             onDelete: _selectedTab == 2
//                                 ? () => _deleteSpeedDate(speedDate)
//                                 : null,
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),

//       // Floating Action Button for creating new speed date
//       floatingActionButton: FloatingActionButton(
//         onPressed: _navigateToCreate,
//         backgroundColor: const Color(0xFFE91E63),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   void _navigateToCreate() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateSpeedDatePage(
//           onSuccess: (success) {
//             if (success) {
//               _loadData();
//               _showSuccessSnackBar('Speed date created successfully!');
//             }
//           },
//         ),
//       ),
//     );
//   }

//   void _showDetails(SpeedDate speedDate) {
//     showDialog(
//       context: context,
//       builder: (context) => SpeedDateDetailsDialog(speedDate: speedDate),
//     );
//   }

//   Future<void> _deleteSpeedDate(SpeedDate speedDate) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Speed Date'),
//         content: const Text('Are you sure you want to delete this speed date?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       // TODO: Implement delete API
//       _showSuccessSnackBar('Speed date deleted');
//       _loadData();
//     }
//   }
// }


// Beat Flirt /speed-date screen converted from:
// https://beatflirtevent.com/speed-date
//
// Main class: SpeedDatePage
//
// Required pubspec dependencies:
//   http: ^1.2.2
//   shared_preferences: ^2.3.2
//   flutter_svg: ^2.0.10+1
//   geocoding: ^3.0.0
//
// AndroidManifest.xml:
//   <uses-permission android:name="android.permission.INTERNET" />

import 'dart:convert';

import 'package:beatflirt/single_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'beat_single_user_profile_screen.dart';

const String _webBase = 'https://beatflirtevent.com/';
const String _apiBase = 'https://app.beatflirtevent.com/App';
const String _apiAssetBase = 'https://app.beatflirtevent.com/assets/';

String _webAsset(String path) => '$_webBase$path';

String _resolveMediaUrl(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return '';
  if (value.startsWith('http://') || value.startsWith('https://')) return value;
  if (value.startsWith('//')) return 'https:$value';
  if (value.startsWith('assets/')) return '$_webBase$value';
  if (value.startsWith('/assets/')) return '$_webBase${value.substring(1)}';
  if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
  return '$_apiAssetBase$value';
}

bool _ok(dynamic status) => status?.toString() == '200';

String _s(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.isEmpty ? fallback : text;
}

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return value
      .split(RegExp(r'[_\s-]+'))
      .where((e) => e.isNotEmpty)
      .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
      .join(' ');
}

String _mediumDate(dynamic value) {
  final raw = _s(value);
  if (raw.isEmpty) return '';
  DateTime? date = DateTime.tryParse(raw);
  if (date == null && raw.contains('/')) {
    final parts = raw.split('/');
    if (parts.length >= 3) {
      final m = int.tryParse(parts[0]);
      final d = int.tryParse(parts[1]);
      final y = int.tryParse(parts[2]);
      if (m != null && d != null && y != null) date = DateTime(y, m, d);
    }
  }
  if (date == null) return raw;
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

String _apiDate(DateTime date) {
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  return '$mm/$dd/${date.year}';
}

List<String> _splitDates(String value) {
  if (value.trim().isEmpty) return <String>[];
  return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}

class BeatSpeedDateApiException implements Exception {
  BeatSpeedDateApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BeatSpeedDateApi {
  BeatSpeedDateApi({
    required this.accessToken,
    required this.accessSign,
    http.Client? client,
    this.baseUrl = _apiBase,
  }) : _client = client ?? http.Client();

  final String accessToken;
  final String accessSign;
  final String baseUrl;
  final http.Client _client;

  Map<String, String> get _headers {
    final h = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (accessToken.isNotEmpty) {
      h['Access-Token'] = accessToken;
      h['access-token'] = accessToken;
      h['Authorization'] = 'Bearer $accessToken';
    }
    if (accessSign.isNotEmpty) {
      h['Access-Sign'] = accessSign;
    }
    return h;
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final response = await _client.get(Uri.parse('$baseUrl$path'), headers: _headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> _post(String path, [Map<String, dynamic>? body]) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BeatSpeedDateApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw BeatSpeedDateApiException('Unexpected API response');
  }

  /// Website API: POST /location/get_all_speed_data
  Future<List<SpeedDateItem>> getSpeedDates(SpeedDateFilter filter) async {
    final json = await _post('/location/get_all_speed_data', filter.toJson());
    if (_ok(json['status'])) {
      final data = json['data'];
      if (data is List) return data.whereType<Map>().map((e) => SpeedDateItem.fromJson(Map<String, dynamic>.from(e))).toList();
      return <SpeedDateItem>[];
    }
    final message = _s(json['message']);
    if (message.toLowerCase().contains('token')) throw BeatSpeedDateApiException(message);
    return <SpeedDateItem>[];
  }

  /// Website API: POST /location/save_speed_data
  Future<String> saveSpeedDate(Map<String, dynamic> body) async {
    final json = await _post('/location/save_speed_data', body);
    final message = _s(json['message'], _ok(json['status']) ? 'Success' : 'Request failed');
    if (!_ok(json['status'])) throw BeatSpeedDateApiException(message);
    return message;
  }

  /// Website API: POST /location/delete_my_speed_date
  Future<String> deleteSpeedDate(String speedDateId) async {
    final json = await _post('/location/delete_my_speed_date', {'speed_date_id': speedDateId});
    final message = _s(json['message'], _ok(json['status']) ? 'Success' : 'Request failed');
    if (!_ok(json['status'])) throw BeatSpeedDateApiException(message);
    return message;
  }

  /// Common shell API.
  Future<String?> checkLoginUserMembership() async {
    final json = await _post('/user/check_login_user_membership');
    return json['membership_expire']?.toString();
  }

  Future<Map<String, dynamic>> notificationAllCount() => _get('/notification/all_count');
}

class SpeedDateFilter {
  const SpeedDateFilter({
    this.userType = 'other',
    this.searchKeyword = '',
    this.locationText = '',
    this.lat = '0',
    this.lng = '0',
    this.city = '0',
    this.profileTypeArray = const <String>[],
  });

  /// other = View All Speed Date, me = View My Speed Date
  final String userType;
  final String searchKeyword;
  final String locationText;
  final String lat;
  final String lng;
  final String city;
  final List<String> profileTypeArray;

  SpeedDateFilter copyWith({
    String? userType,
    String? searchKeyword,
    String? locationText,
    String? lat,
    String? lng,
    String? city,
    List<String>? profileTypeArray,
  }) {
    return SpeedDateFilter(
      userType: userType ?? this.userType,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      locationText: locationText ?? this.locationText,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      profileTypeArray: profileTypeArray ?? this.profileTypeArray,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_type': userType,
        'search_keyword': searchKeyword,
        'keyword': searchKeyword,
        'lat': lat,
        'lng': lng,
        'city': city,
        'profileTypeArray': profileTypeArray,
      };
}

class SpeedDateImage {
  SpeedDateImage({
    required this.profileImage,
    required this.dummyProfileImage,
    required this.showProfileImage,
  });

  final String profileImage;
  final String dummyProfileImage;
  final bool showProfileImage;

  factory SpeedDateImage.fromJson(Map<String, dynamic> json) => SpeedDateImage(
        profileImage: _s(json['profile_image']),
        dummyProfileImage: _s(json['dummy_profile_image']),
        showProfileImage: json['show_profile_image']?.toString() != '0',
      );
}

class SpeedDateItem {
  SpeedDateItem({
    required this.raw,
    required this.id,
    required this.userId,
    required this.username,
    required this.profileType,
    required this.age,
    required this.showAge,
    required this.showLocation,
    required this.formattedAddress,
    required this.type,
    required this.selectDate,
    required this.startHour,
    required this.startMinute,
    required this.details,
    required this.images,
  });

  final Map<String, dynamic> raw;
  final String id;
  final String userId;
  final String username;
  final String profileType;
  final String age;
  final bool showAge;
  final bool showLocation;
  final String formattedAddress;
  final String type;
  final String selectDate;
  final String startHour;
  final String startMinute;
  final String details;
  final List<SpeedDateImage> images;

  factory SpeedDateItem.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] is List ? json['image'] as List : const [];
    return SpeedDateItem(
      raw: json,
      id: _s(json['id']),
      userId: _s(json['user_id'], _s(json['id'])),
      username: _s(json['username']),
      profileType: _s(json['profile_type']),
      age: _s(json['age']),
      showAge: json['show_age']?.toString() != '0',
      showLocation: json['show_location']?.toString() != '0',
      formattedAddress: _s(json['formatted_address'], _s(json['location'])),
      type: _s(json['type']),
      selectDate: _s(json['select_date']),
      startHour: _s(json['start_time_hours']),
      startMinute: _s(json['start_time_minuts']),
      details: _s(json['details']),
      images: imageList.whereType<Map>().map((e) => SpeedDateImage.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  String get primaryImage {
    if (images.isEmpty) return '';
    final img = images.first;
    return img.showProfileImage ? img.profileImage : img.dummyProfileImage;
  }

  String get placeType => '${_titleCase(type)} Place';

  String get dateText {
    final dates = _splitDates(selectDate).map(_mediumDate).where((e) => e.isNotEmpty).toList();
    return dates.join(' - ');
  }

  String get timeText {
    if (startHour.isEmpty) return '';
    return '$startHour:$startMinute';
  }

  bool flag(String key) => raw[key]?.toString() == '1';
}

class SpeedDatePage extends StatefulWidget {
  const SpeedDatePage({
    super.key,
    this.api,
    this.accessToken,
    this.accessSign,
    this.loginUserId,
    this.membershipValue,
    this.autoCheckMembership = true,
    this.enforceMembershipLock = true,
    this.onOpenProfile,
    this.onOpenMembership,
  });

  final BeatSpeedDateApi? api;
  final String? accessToken;
  final String? accessSign;
  final String? loginUserId;
  final String? membershipValue;
  final bool autoCheckMembership;

  /// Angular page shows real speed-date cards when membership storage is not "Yes".
  final bool enforceMembershipLock;

  final void Function(BuildContext context, SpeedDateItem item)? onOpenProfile;
  final VoidCallback? onOpenMembership;

  @override
  State<SpeedDatePage> createState() => _SpeedDatePageState();
}

class _SpeedDatePageState extends State<SpeedDatePage> {
  static const Color _lightBg = Color(0xFFFFF4FA);
  static const Color _primary = Color(0xFF1D042A);
  static const Color _maroon = Color(0xFF560827);
  static const Color _navy = Color(0xFF06032C);
  static const Color _pink = Color(0xFFE91E63);

  BeatSpeedDateApi? _api;
  SpeedDateFilter _filter = const SpeedDateFilter();
  List<SpeedDateItem> _items = <SpeedDateItem>[];

  bool _booting = true;
  bool _loading = false;
  String? _error;
  String _loginUserId = '';
  String _membershipValue = '';
  int _tabIndex = 1; // 0 = post, 1 = all, 2 = mine

  // Post form state
  String _postType = 'private';
  final _postLocationController = TextEditingController();
  final _postDetailsController = TextEditingController();
  final _filterSearchController = TextEditingController();
  final _filterLocationController = TextEditingController();
  String _postLat = '';
  String _postLng = '';
  List<DateTime> _selectedDates = <DateTime>[DateTime.now()];
  String _selectedHour = '';
  String _selectedMinute = '';
  final Set<String> _postTypes = <String>{'couple_male_female_swingers'};

  bool get _cardsLocked => widget.enforceMembershipLock && _membershipValue == 'Yes';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _postLocationController.dispose();
    _postDetailsController.dispose();
    _filterSearchController.dispose();
    _filterLocationController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = widget.accessToken ??
          prefs.getString('Access-Token') ??
          prefs.getString('access_token') ??
          prefs.getString('accessToken') ??
          prefs.getString('token') ??
          prefs.getString('auth_token') ??
          '';
      final sign = widget.accessSign ??
          prefs.getString('Access-Sign') ??
          prefs.getString('access_sign') ??
          prefs.getString('accessSign') ??
          prefs.getString('sign') ??
          '';
      _loginUserId = widget.loginUserId ??
          prefs.getString('user-id') ??
          prefs.getString('user_id') ??
          '';
      _membershipValue = widget.membershipValue ?? prefs.getString('membership') ?? '';
      _api = widget.api ?? BeatSpeedDateApi(accessToken: token, accessSign: sign);

      if (widget.autoCheckMembership && token.isNotEmpty && sign.isNotEmpty) {
        final membershipExpire = await _api!.checkLoginUserMembership();
        if (membershipExpire != null) {
          _membershipValue = membershipExpire;
          await prefs.setString('membership', membershipExpire);
        }
      }

      if (!mounted) return;
      setState(() => _booting = false);
      await _loadSpeedDates();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _booting = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadSpeedDates() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await api.getSpeedDates(_filter);
      if (!mounted) return;
      setState(() => _items = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  void _changeTab(int index) {
    setState(() {
      _tabIndex = index;
      if (index == 1) _filter = _filter.copyWith(userType: 'other');
      if (index == 2) _filter = _filter.copyWith(userType: 'me');
    });
    if (index != 0) _loadSpeedDates();
  }

  Future<void> _openFilterSheet() async {
    _filterSearchController.text = _filter.searchKeyword;
    _filterLocationController.text = _filter.locationText;
    var draft = _filter;
    var resolvingLocation = false;

    final result = await showModalBottomSheet<SpeedDateFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> submit() async {
              setModalState(() => resolvingLocation = true);
              var lat = '0';
              var lng = '0';
              var city = '0';
              final locationText = _filterLocationController.text.trim();
              if (locationText.isNotEmpty) {
                try {
                  final locations = await locationFromAddress(locationText);
                  if (locations.isNotEmpty) {
                    lat = locations.first.latitude.toString();
                    lng = locations.first.longitude.toString();
                    city = locationText;
                  }
                } catch (_) {}
              }
              if (!mounted) return;
              Navigator.pop(
                context,
                draft.copyWith(
                  searchKeyword: _filterSearchController.text.trim(),
                  locationText: locationText,
                  lat: lat,
                  lng: lng,
                  city: city,
                ),
              );
            }

            Widget checkbox(String label, String value, Color dotColor) {
              final checked = draft.profileTypeArray.contains(value);
              return InkWell(
                onTap: () {
                  final next = List<String>.from(draft.profileTypeArray);
                  checked ? next.remove(value) : next.add(value);
                  setModalState(() => draft = draft.copyWith(profileTypeArray: next.toSet().toList()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: checked,
                        activeColor: Colors.white,
                        checkColor: _maroon,
                        side: const BorderSide(color: Colors.white),
                        onChanged: (v) {
                          final next = List<String>.from(draft.profileTypeArray);
                          v == true ? next.add(value) : next.remove(value);
                          setModalState(() => draft = draft.copyWith(profileTypeArray: next.toSet().toList()));
                        },
                      ),
                      Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      const SizedBox(width: 6),
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 42,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        checkbox('Couples', 'Couple', Colors.red),
                        checkbox('Females', 'Female', Colors.pink),
                        checkbox('Males', 'Male', Colors.orange),
                        checkbox('Transgenders', 'Transgender', Colors.yellow),
                        const SizedBox(height: 8),
                        _filterTextField(_filterSearchController, 'Search Username...'),
                        const SizedBox(height: 8),
                        _filterTextField(_filterLocationController, 'Search Location...'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: resolvingLocation ? null : submit,
                          child: resolvingLocation
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Ok', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() => _filter = result);
      await _loadSpeedDates();
    }
  }

  Widget _filterTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      ),
    );
  }

  Future<void> _pickDate() async {
    if (_selectedDates.length >= 3) {
      _snack('You can select up to 3 dates', error: true);
      return;
    }
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: _maroon)),
        child: child!,
      ),
    );
    if (date == null) return;
    if (_selectedDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day)) return;
    setState(() => _selectedDates.add(date));
  }

  Future<void> _postSpeedDate() async {
    final api = _api;
    if (api == null) return;
    if (_selectedDates.isEmpty) {
      _snack('Please select date', error: true);
      return;
    }
    if (_postDetailsController.text.trim().isEmpty) {
      _snack('All field are required!', error: true);
      return;
    }
    if (_postType == 'virtual' && (_selectedHour.isEmpty || _selectedMinute.isEmpty)) {
      _snack('All field are required!', error: true);
      return;
    }
    if ((_postType == 'private' || _postType == 'public') && _postLocationController.text.trim().isEmpty) {
      _snack('All field are required!', error: true);
      return;
    }

    var location = _postLocationController.text.trim();
    var lat = _postLat;
    var lng = _postLng;
    if (location.isNotEmpty && (lat.isEmpty || lng.isEmpty)) {
      try {
        final positions = await locationFromAddress(location);
        if (positions.isNotEmpty) {
          lat = positions.first.latitude.toString();
          lng = positions.first.longitude.toString();
        }
      } catch (_) {}
    }

    final body = <String, dynamic>{
      'type': _postType,
      'select_date': _selectedDates.map(_apiDate).join(','),
      'lat': lat,
      'lng': lng,
      'location': location,
      'details': _postDetailsController.text.trim(),
      'start_time_hours': _selectedHour,
      'start_time_minuts': _selectedMinute,
      'couple_male_female_swingers': _postTypes.contains('couple_male_female_swingers') ? 1 : 0,
      'couple_female_female_swingers': _postTypes.contains('couple_female_female_swingers') ? 1 : 0,
      'couple_male_male_swingers': _postTypes.contains('couple_male_male_swingers') ? 1 : 0,
      'couple_male_swingers': _postTypes.contains('couple_male_swingers') ? 1 : 0,
      'couple_female_swingers': _postTypes.contains('couple_female_swingers') ? 1 : 0,
      'couple_transgender_swingers': _postTypes.contains('couple_transgender_swingers') ? 1 : 0,
    };

    setState(() => _loading = true);
    try {
      final message = await api.saveSpeedDate(body);
      _snack(message);
      setState(() {
        _tabIndex = 2;
        _filter = _filter.copyWith(userType: 'me');
        _postType = 'private';
        _selectedDates = <DateTime>[DateTime.now()];
        _selectedHour = '';
        _selectedMinute = '';
        _postLocationController.clear();
        _postDetailsController.clear();
        _postLat = '';
        _postLng = '';
        _postTypes
          ..clear()
          ..add('couple_male_female_swingers');
      });
      await _loadSpeedDates();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteSpeedDate(SpeedDateItem item) async {
    final api = _api;
    if (api == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Speed Date'),
        content: const Text('Are you sure Want to delete?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _loading = true);
    try {
      final message = await api.deleteSpeedDate(item.id);
      _snack(message);
      await _loadSpeedDates();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openProfile(SpeedDateItem item) {
    if (widget.onOpenProfile != null) {
      widget.onOpenProfile!(context, item);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BeatSingleUserProfileScreen(
          userId: item.userId,
          accessToken: widget.accessToken,
          accessSign: widget.accessSign,
          loginUserId: _loginUserId,
        ),
      ),
    );
  }

  void _showDetails(SpeedDateItem item) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Speed Date Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
              const SizedBox(height: 14),
              _detailLine('Details:', item.details),
              _detailLine('Location:', item.formattedAddress),
              _detailLine('Date:', item.dateText),
              if (item.timeText.isNotEmpty) _detailLine('Time:', item.timeText),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _showInfo(String type) {
    final text = switch (type) {
      'private' => 'You prefer the privacy of meeting your Date in a private environment such as your home or a hotel room.',
      'public' => 'You prefer to meet your Date somewhere public like a bar, restaurant or hotel lobby to start your encounter.',
      'virtual' => 'Meet new people online quickly and easily. For a one-to-one Date, connect with each other using our Beat Flirt Message with its video chat function. If you prefer to include more than one member in your Date, we recommend using our Live Stream function.',
      _ => '',
    };
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Information'),
        content: Text(text),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: TextSpan(
              text: 'Speed Date ',
              style: const TextStyle(color: _primary, fontSize: 22, fontWeight: FontWeight.w600),
              children: [
                if (_items.isNotEmpty && _tabIndex != 0)
                  TextSpan(text: '(${_items.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: _primary, size: 20),
        ),
      ),
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => _tabIndex == 0 ? Future.value() : _loadSpeedDates(),
              color: _maroon,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _header(),
                  const SizedBox(height: 18),
                  _tabs(),
                  const SizedBox(height: 18),
                  if (_booting)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(child: CircularProgressIndicator(color: _maroon)),
                    )
                  else if (_error != null)
                    _errorBox(_error!)
                  else if (_tabIndex == 0)
                    _postForm()
                  else
                    _listContent(),
                ],
              ),
            ),
            if (_loading && !_booting)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.04),
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 8),
                    child: const LinearProgressIndicator(minHeight: 3, color: _maroon),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Flexible(
        //   child: RichText(
        //     text: TextSpan(
        //       text: 'Speed Date ',
        //       style: const TextStyle(color: _primary, fontSize: 26, fontWeight: FontWeight.w600),
        //       children: [
        //         if (_items.isNotEmpty && _tabIndex != 0)
        //           TextSpan(text: '(${_items.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        //       ],
        //     ),
        //   ),
        // ),
        if (_tabIndex != 0 && !_cardsLocked)
          InkWell(
            onTap: _openFilterSheet,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: SvgPicture.network(
                _webAsset('assets/img/icons/filter.svg'),
                width: 20,
                height: 20,
                placeholderBuilder: (_) => const Icon(Icons.filter_alt, color: _maroon, size: 20),
              ),
            ),
          ),
      ],
    );
  }

  Widget _tabs() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(child: _tabButton('Post Date', 0)),
          Expanded(child: _tabButton('All Dates', 1)),
          Expanded(child: _tabButton('My Dates', 2)),
        ],
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    final selected = _tabIndex == index;
    return InkWell(
      onTap: () => _changeTab(index),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _pink : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _postForm() {
    if (_cardsLocked) return _membershipBox();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 20)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _requiredLabel('Type'),
          _speedTypeRadios(),
          const SizedBox(height: 18),
          _requiredLabel('When'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._selectedDates.map((d) => Chip(
                    label: Text(_apiDate(d)),
                    onDeleted: _selectedDates.length <= 1 ? null : () => setState(() => _selectedDates.remove(d)),
                  )),
              ActionChip(label: const Text('Select dates'), onPressed: _pickDate),
            ],
          ),
          if (_postType == 'virtual') ...[
            const SizedBox(height: 18),
            _requiredLabel('Start Time'),
            Row(
              children: [
                Expanded(child: _timeDropdown('Hours', _selectedHour, List.generate(24, (i) => i.toString()), (v) => setState(() => _selectedHour = v ?? ''))),
                const SizedBox(width: 10),
                Expanded(child: _timeDropdown('Minutes', _selectedMinute, List.generate(12, (i) => (i * 5).toString().padLeft(2, '0')), (v) => setState(() => _selectedMinute = v ?? ''))),
              ],
            ),
          ],
          const SizedBox(height: 18),
          _requiredLabel('With'),
          _withCheckboxes(),
          if (_postType != 'virtual') ...[
            const SizedBox(height: 18),
            _requiredLabel('Where'),
            TextField(
              controller: _postLocationController,
              decoration: _inputDecoration('Enter Location'),
            ),
          ],
          const SizedBox(height: 18),
          _requiredLabel('Details'),
          TextField(
            controller: _postDetailsController,
            maxLines: 4,
            decoration: _inputDecoration('Leave a comment here'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _postSpeedDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: _maroon,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('Post Speed Date', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _requiredLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 14),
          children: [TextSpan(text: text), const TextSpan(text: ' *', style: TextStyle(color: _pink))],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _maroon)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _maroon)),
    );
  }

  Widget _speedTypeRadios() {
    Widget item(String label, String value) => InkWell(
          onTap: () => setState(() => _postType = value),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(value: value, groupValue: _postType, activeColor: _maroon, onChanged: (v) => setState(() => _postType = v ?? 'private')),
              Text(label),
              const SizedBox(width: 2),
              InkWell(onTap: () => _showInfo(value), child: const Icon(Icons.info_outline, size: 16, color: _maroon)),
            ],
          ),
        );
    return Wrap(spacing: 8, children: [item('Private Place', 'private'), item('Public Place', 'public'), item('Virtual Date', 'virtual')]);
  }

  Widget _timeDropdown(String hint, String value, List<String> values, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: _inputDecoration(hint),
      items: values.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _withCheckboxes() {
    const options = <String, String>{
      'couple_male_female_swingers': 'Couple F/M',
      'couple_female_female_swingers': 'Couple F/F',
      'couple_male_male_swingers': 'Couple M/M',
      'couple_male_swingers': 'Male',
      'couple_female_swingers': 'Female',
      'couple_transgender_swingers': 'Transgender',
    };
    const icons = <String, String>{
      'couple_male_female_swingers': 'assets/img/icon/female-male.png',
      'couple_female_female_swingers': 'assets/img/icon/female-female.png',
      'couple_male_male_swingers': 'assets/img/icon/male-male.png',
      'couple_male_swingers': 'assets/img/icon/male.png',
      'couple_female_swingers': 'assets/img/icon/female.png',
      'couple_transgender_swingers': 'assets/img/icon/transgender.png',
    };
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: options.entries.map((entry) {
        final checked = _postTypes.contains(entry.key);
        return InkWell(
          onTap: () => setState(() => checked ? _postTypes.remove(entry.key) : _postTypes.add(entry.key)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(value: checked, activeColor: _maroon, onChanged: (v) => setState(() => v == true ? _postTypes.add(entry.key) : _postTypes.remove(entry.key))),
                Image.network(_webAsset(icons[entry.key]!), width: 20, height: 20, errorBuilder: (_, __, ___) => const SizedBox(width: 20, height: 20)),
                const SizedBox(width: 4),
                Text(entry.value),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _listContent() {
    if (_loading && _items.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator(color: _maroon)));
    if (_items.isEmpty) return _noData(_filter.userType == 'me' ? 'No Speed Dates posted by you.' : 'No Record Found!');

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 920 ? 4 : width >= 620 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 20,
            mainAxisExtent: _filter.userType == 'me' ? 430 : 455,
          ),
          itemBuilder: (context, index) {
            if (_cardsLocked) return _lockedCard();
            final item = _items[index];
            return _filter.userType == 'me' ? _mySpeedDateCard(item) : _speedDateCard(item);
          },
        );
      },
    );
  }

  Widget _speedDateCard(SpeedDateItem item) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _openProfile(item),
            child: _profileImage(item.primaryImage, size: 112),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => _openProfile(item),
            child: Text(item.username, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          if (item.showAge && item.age.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Age ${item.age}', style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
          const SizedBox(height: 10),
          Expanded(child: _speedDetails(item)),
          InkWell(
            onTap: () => _showDetails(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: _pink, borderRadius: BorderRadius.circular(20)),
              child: const Text('View Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mySpeedDateCard(SpeedDateItem item) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        children: [
          _profileImage(item.primaryImage, size: 112),
          const SizedBox(height: 10),
          Text(item.username, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Expanded(child: _speedDetails(item)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(onTap: () => _showDetails(item), child: const Text('Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
              IconButton(onPressed: () => _deleteSpeedDate(item), icon: const Icon(Icons.delete, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _speedDetails(SpeedDateItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.showLocation && item.formattedAddress.isNotEmpty) _infoLine(Icons.location_on, item.formattedAddress),
        _infoLine(Icons.place, item.placeType),
        if (item.dateText.isNotEmpty) _infoLine(Icons.calendar_today, item.dateText),
        if (item.timeText.isNotEmpty) _infoLine(Icons.access_time, item.timeText),
      ],
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(width: 5),
          Flexible(child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
        boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 36, offset: Offset(0, 18))],
      );

  Widget _profileImage(String raw, {required double size}) {
    final url = _resolveMediaUrl(raw);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: _pink, width: 4), color: Colors.white),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty
          ? const Icon(Icons.person, color: _maroon, size: 54)
          : Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, color: _maroon, size: 54)),
    );
  }

  Widget _lockedCard() {
    return InkWell(
      onTap: _showMembershipDialog,
      child: Container(
        decoration: _cardDecoration(),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(_webAsset('assets/img/lock.png'), width: 58, height: 90, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.lock, color: Colors.white, size: 58)),
            const SizedBox(height: 12),
            const Text('Upgrade to view', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _membershipBox() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Beat Flirt Team!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const Text('"You have not purchased a Beat Flirt membership plan. Buy membership"', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
            onPressed: widget.onOpenMembership ?? () => Navigator.pushNamed(context, '/membership'),
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  void _showMembershipDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(backgroundColor: Colors.transparent, child: _membershipBox()),
    );
  }

  Widget _noData(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 30, offset: Offset(0, 10))]),
      child: Column(
        children: [
          Container(width: 120, height: 120, decoration: const BoxDecoration(color: Color(0x1A01529C), shape: BoxShape.circle), child: const Icon(Icons.event_busy, size: 62, color: _maroon)),
          const SizedBox(height: 25),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 22)),
        ],
      ),
    );
  }

  Widget _errorBox(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 42),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _loadSpeedDates,
            style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
