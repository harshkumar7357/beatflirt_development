// // // lib/Api_services/api_services.dart

// // import 'dart:convert';
// // import 'package:beatflirt/model/notification_model.dart';
// // import 'package:http/http.dart' as http;

// // class ApiService {

// //   // 🔴 Replace with your real base URL found from Step 1
// //   static const String _baseUrl = 'https://beatflirtevent.com';

// //   // Future<Map<String, dynamic>> login({
// //   //   required String email,   // ← rename to 'username' if site uses username
// //   //   required String password,
// //   // }) async {

// //   //   // 🔴 Replace '/api/auth/login' with your real endpoint from Step 1
// //   //   final uri = Uri.parse('$_baseUrl/api/auth/login');

// //   //   final response = await http.post(
// //   //     uri,
// //   //     headers: {
// //   //       'Content-Type': 'application/json',
// //   //       'Accept': 'application/json',
// //   //     },
// //   //     body: jsonEncode({
// //   //       // 'email': email,
// //   //          // 🔴 Change to 'username': email  if site uses username
// //   //       'username': email,
// //   //       'password': password,
// //   //     }),
// //   //   );

// //   //   final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

// //   //   if (response.statusCode == 200 || response.statusCode == 201) {
// //   //     return responseBody;  // ✅ Must contain 'token' and 'user'
// //   //   } else {
// //   //     final message = responseBody['message']
// //   //                  ?? responseBody['error']
// //   //                  ?? 'Login failed';
// //   //     throw Exception(message);
// //   //   }
// //   // }

// // // ══════════════════════════════════════════════════
// //   // LOGIN
// //   // POST https://beatflirtevent.com/api/App/auth/login
// //   //
// //   // Confirmed Payload : { "username": "testing6", "password": "Jin@123456" }
// //   //
// //   // Confirmed Response:
// //   // {
// //   //   "status": "200",
// //   //   "message": "Sucessfully login.",
// //   //   "data": {
// //   //     "token":         "...",
// //   //     "sign":          "...",
// //   //     "userid":        "408",
// //   //     "username":      "testing6",
// //   //     "email":         "harshkmr12@gmail.com",
// //   //     "profile_type":  "single",
// //   //     "profile_image": "male.png"
// //   //   }
// //   // }
// //   // ══════════════════════════════════════════════════
// //   Future<Map<String, dynamic>> login({
// //     required String username, // ✅ API uses 'username' NOT 'email'
// //     required String password,
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/login');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         'username': username, // ✅ confirmed field name
// //         'password': password,
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;

// //     // API returns status as string "200" inside body
// //     final apiStatus = body['status']?.toString() ?? '';
// //     if (response.statusCode == 200 && apiStatus == '200') return body;
// //     throw Exception(body['message'] ?? body['error'] ?? 'Login failed');
// //   }

// //   Future<Map<String, dynamic>> registerSingle({
// //     required String email,
// //     required String password,
// //     required String username,
// //     required String singleProfileGenderFrom, // "1" | "2" | "3"
// //     required String lat,
// //     required String lng,
// //     required String cityName,
// //     required String placeId,
// //     required String mapUrl,
// //     required String formattedAddress,
// //     required String imageType,         // "male.png" | "female.png" | "transgender.png"
// //     required String genderProfileType, // "Male" | "Female" | "Transgender"
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/registration');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         "email":                      email,
// //         "password":                   password,
// //         "username":                   username,
// //         "profile_type":               "single",
// //         "single_profile_gender_from": singleProfileGenderFrom,
// //         "single_full_name":           "",
// //         "couple_profile_gender_from": "",
// //         "couple_profile_gender_to":   "",
// //         "couple_full_name_from":      "",
// //         "couple_full_name_to":        "",
// //         "lat":                        lat,
// //         "lng":                        lng,
// //         "city_name":                  cityName,
// //         "place_id":                   placeId,
// //         "map_url":                    mapUrl,
// //         "formatted_address":          formattedAddress,
// //         "image_type":                 imageType,
// //         "gender_profile_type":        genderProfileType,
// //         "filter_profile_type":        "Male",
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     if (response.statusCode == 200 || response.statusCode == 201) return body;
// //     throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
// //   }

// //   // ══════════════════════════════════════════════════
// //   // REGISTER — COUPLE
// //   // POST https://beatflirtevent.com/api/App/auth/registration
// //   //
// //   // Confirmed Payload:
// //   // {
// //   //   "email": "...",
// //   //   "password": "...",
// //   //   "username": "...",
// //   //   "profile_type": "couple",
// //   //   "single_profile_gender_from": "",
// //   //   "single_full_name": "",
// //   //   "couple_profile_gender_from": "1",  ← "1"=Male "2"=Female "3"=Transgender
// //   //   "couple_profile_gender_to": "2",    ← "1"=Male "2"=Female "3"=Transgender
// //   //   "couple_full_name_from": "",
// //   //   "couple_full_name_to": "",
// //   //   "lat": "26.9124336",
// //   //   "lng": "75.7872709",
// //   //   "city_name": "Jaipur",
// //   //   "place_id": "ChIJgeJXTN9KbDkRCS7yDDrG4Qw",
// //   //   "map_url": "https://maps.google.com/?cid=...",
// //   //   "formatted_address": "Jaipur, Rajasthan, India",
// //   //   "image_type": "male-female.png",
// //   //   "gender_profile_type": "Male | Female",
// //   //   "filter_profile_type": "Couple"
// //   // }
// //   //
// //   // Confirmed Response:
// //   // { "status": "200", "message": "Successfully register",
// //   //   "data": { "token": "...", "sign": "...", "userid": "407", "profile_type": "couple" } }
// //   // ══════════════════════════════════════════════════
// //   Future<Map<String, dynamic>> registerCouple({
// //     required String email,
// //     required String password,
// //     required String username,
// //     required String coupleProfileGenderFrom, // "1" | "2" | "3"
// //     required String coupleProfileGenderTo,   // "1" | "2" | "3"
// //     required String lat,
// //     required String lng,
// //     required String cityName,
// //     required String placeId,
// //     required String mapUrl,
// //     required String formattedAddress,
// //     required String imageType,         // e.g. "male-female.png"
// //     required String genderProfileType, // e.g. "Male | Female"
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/registration');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         "email":                      email,
// //         "password":                   password,
// //         "username":                   username,
// //         "profile_type":               "couple",
// //         "single_profile_gender_from": "",
// //         "single_full_name":           "",
// //         "couple_profile_gender_from": coupleProfileGenderFrom,
// //         "couple_profile_gender_to":   coupleProfileGenderTo,
// //         "couple_full_name_from":      "",
// //         "couple_full_name_to":        "",
// //         "lat":                        lat,
// //         "lng":                        lng,
// //         "city_name":                  cityName,
// //         "place_id":                   placeId,
// //         "map_url":                    mapUrl,
// //         "formatted_address":          formattedAddress,
// //         "image_type":                 imageType,
// //         "gender_profile_type":        genderProfileType,
// //         "filter_profile_type":        "Couple",
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     if (response.statusCode == 200 || response.statusCode == 201) return body;
// //     throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
// //   }

// //    // ══════════════════════════════════════════════════
// //   // GET ALL NOTIFICATIONS   ✅ Confirmed URL & Response
// //   // GET https://beatflirtevent.com/api/App/events/get_all_notification
// //   //
// //   // Headers: Authorization: Bearer <token>
// //   //
// //   // Confirmed Response:
// //   // {
// //   //   "status": "200",
// //   //   "data": [
// //   //     {
// //   //       "id": "551",
// //   //       "title": "Velvet Nights",
// //   //       "description": "<p>...</p>",
// //   //       "type": "user",
// //   //       "image": "https://beatflirtevent.com/api/assets/images/...",
// //   //       "video": "",
// //   //       "status": "1",
// //   //       "created": "2026-05-28",
// //   //       "notification_time": "18:39:00",
// //   //       "send_msg_time": "3 Days 9 Hours 46 Minutes",
// //   //       "event_from_date": "", "event_to_date": "",
// //   //       "event_from_time": null, "event_to_time": null,
// //   //       "event_name": "", "event_image": "",
// //   //       "notification_date_time": "2026-05-28 18:39:00"
// //   //     }, ...
// //   //   ]
// //   // }
// //   // ══════════════════════════════════════════════════
// //   // Future<List<NotificationModel>> getAllNotifications({
// //   //   required String? token,
// //   // }) async {
// //   //   final uri = Uri.parse('$_baseUrl/api/App/events/get_all_notification');

// //   //   final response = await http.get(
// //   //     uri,
// //   //     headers: {
// //   //       'Authorization': 'Bearer ${token ?? ''}',
// //   //       'Content-Type':  'application/json',
// //   //     },
// //   //   );

// //   //   final body       = jsonDecode(response.body) as Map<String, dynamic>;
// //   //   final apiStatus  = body['status']?.toString() ?? '';

// //   //   if (response.statusCode == 200 && apiStatus == '200') {
// //   //     final dataList = body['data'] as List<dynamic>? ?? [];
// //   //     return dataList
// //   //         .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
// //   //         .toList();
// //   //   }

// //   //   throw Exception(body['message'] ?? 'Failed to load notifications');
// //   // }

// //  // ─────────────────────────────────────────
// //   // GET all notifications
// //   // Endpoint: /api/App/events/get_all_notification
// //   // ─────────────────────────────────────────
// //    /// POST /api/App/events/get_all_notification
// //   /// Body: {"page": page}
// //   /// Header: Authorization: Bearer <token>
// //   ///
// //   Future<List<NotificationModel>> getAllNotifications({
// //     required String? token,
// //     int page = 1,
// //   }) async {
// //     // ── Guard: token must exist ─────────────────────
// //     if (token == null || token.trim().isEmpty) {
// //       throw Exception('Authentication token is missing. Please log in again.');
// //     }

// //     final uri = Uri.parse('$_baseUrl/api/App/events/get_all_notification');

// //     final response = await http.post(
// //       uri,
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Content-Type': 'application/json',
// //       },
// //       body: jsonEncode({'page': page}),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     final apiStatus = body['status']?.toString() ?? '';

// //     if (response.statusCode == 200 && apiStatus == '200') {
// //       final dataList = body['data'] as List<dynamic>? ?? [];
// //       return dataList
// //           .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
// //           .toList();
// //     }

// //     throw Exception(body['message'] ?? 'Failed to load notifications');
// //   }

// //   // ══════════════════════════════════════════════════
// //   // LOGOUT  ✅ Confirmed URL
// //   // POST https://beatflirtevent.com/api/App/user/logout
// //   //
// //   // Headers: Authorization: Bearer <token>
// //   // Called automatically by AuthService.logout()
// //   // ══════════════════════════════════════════════════
// //   Future<void> logout({required String token}) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/user/logout'); // ✅ confirmed URL

// //     final response = await http.post(
// //       uri,
// //       headers: {
// //         'Authorization': 'Bearer $token',  // token from AuthService.getToken()
// //         'Content-Type':  'application/json',
// //       },
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;

// //     // Only throw if it's a server error (5xx)
// //     // 401/403 means token already expired — still treat as logged out
// //     if (response.statusCode >= 500) {
// //       throw Exception(body['message'] ?? 'Logout failed');
// //     }
// //   }
// // }

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:beatflirt/model/notification_model.dart';
// import 'package:beatflirt/model/membership_model.dart';
// // import 'package:beatflirt/model/country_model.dart';

// import '../core/constants.dart';
// import 'package:beatflirt/model/user_membership_plan_model.dart';
// import '../model/user_profile_model.dart';

// late final http.Client _client;
// //
// // ApiService({http.Client? client}) : _client = client ?? http.Client();

// class ApiService {
//   // static const String _baseUrl = 'https://beatflirtevent.com';
//   static const String _baseUrl = 'https://app.beatflirtevent.com';

//   // ── Cookie jar for PHP session auth ─────────────────────────
//   static final Map<String, String> _cookieJar = {};

//   static void _extractCookies(http.Response response) {
//     final raw = response.headers['set-cookie'];
//     if (raw == null || raw.isEmpty) return;
//     // Cookies may be comma-separated or appear in multiple values
//     for (final segment in raw.split(',')) {
//       final c = segment
//           .trim()
//           .split(';')
//           .first
//           .trim();
//       final idx = c.indexOf('=');
//       if (idx > 0) {
//         _cookieJar[c.substring(0, idx).trim()] = c.substring(idx + 1).trim();
//       }
//     }
//   }

//   static Map<String, String> _buildHeaders({String? token}) {
//     final h = <String, String>{
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//     if (token != null && token.isNotEmpty) {
//       h['Authorization'] = 'Bearer $token';
//       h['access-token'] = token; // fallback
//     }
//     if (_cookieJar.isNotEmpty) {
//       h['Cookie'] = _cookieJar.entries
//           .map((e) => '${e.key}=${e.value}')
//           .join('; ');
//     }
//     return h;
//   }

//   // ════════════════════════════════════════════════════════════════
//   // LOGIN
//   // ════════════════════════════════════════════════════════════════
//   Future<Map<String, dynamic>> login({
//     required String username,
//     required String password,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/auth/login');
//     // final uri = Uri.parse('$_baseUrl/App/auth/login');
//       final uri = Uri.parse('https://app.beatflirtevent.com/App/auth/login');

//     debugPrint('🔵 LOGIN REQUEST → $uri');

//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'username': username,
//         'password': password,
//       }),
//     );

//     // ✅ Capture PHP session cookie from login
//     _extractCookies(response);
//     debugPrint('🟢 COOKIES AFTER LOGIN → $_cookieJar');

//     final body = jsonDecode(response.body) as Map<String, dynamic>;

//     debugPrint('🟢 LOGIN RESPONSE CODE → ${response.statusCode}');
//     debugPrint(
//         '🟢 LOGIN RESPONSE BODY → ${const JsonEncoder.withIndent("  ").convert(
//             body)}');

//     final apiStatus = body['status']?.toString() ?? '';
//     if (response.statusCode == 200 && apiStatus == '200') {
//       final data = body['data'] as Map<String, dynamic>? ?? {};
//       debugPrint('🟢 TOKEN RECEIVED → ${data['token']}');
//       debugPrint('🟢 USER ID → ${data['userid']}');
//       return body;
//     }

//     throw Exception(body['message'] ?? body['error'] ?? 'Login failed');
//   }

//   // ════════════════════════════════════════════════════════════════
//   // REGISTER — SINGLE
//   // ════════════════════════════════════════════════════════════════
//   Future<Map<String, dynamic>> registerSingle({
//     required String email,
//     required String password,
//     required String username,
//     required String singleProfileGenderFrom,
//     required String lat,
//     required String lng,
//     required String cityName,
//     required String placeId,
//     required String mapUrl,
//     required String formattedAddress,
//     required String imageType,
//     required String genderProfileType,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/auth/registration');
//     final uri = Uri.parse('$_baseUrl/App/auth/registration');

//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "email": email,
//         "password": password,
//         "username": username,
//         "profile_type": "single",
//         "single_profile_gender_from": singleProfileGenderFrom,
//         "single_full_name": "",
//         "couple_profile_gender_from": "",
//         "couple_profile_gender_to": "",
//         "couple_full_name_from": "",
//         "couple_full_name_to": "",
//         "lat": lat,
//         "lng": lng,
//         "city_name": cityName,
//         "place_id": placeId,
//         "map_url": mapUrl,
//         "formatted_address": formattedAddress,
//         "image_type": imageType,
//         "gender_profile_type": genderProfileType,
//         "filter_profile_type": "Male",
//       }),
//     );

//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     if (response.statusCode == 200 || response.statusCode == 201) return body;
//     throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
//   }

//   // ════════════════════════════════════════════════════════════════
//   // REGISTER — COUPLE
//   // ════════════════════════════════════════════════════════════════
//   Future<Map<String, dynamic>> registerCouple({
//     required String email,
//     required String password,
//     required String username,
//     required String coupleProfileGenderFrom,
//     required String coupleProfileGenderTo,
//     required String lat,
//     required String lng,
//     required String cityName,
//     required String placeId,
//     required String mapUrl,
//     required String formattedAddress,
//     required String imageType,
//     required String genderProfileType,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/auth/registration');
//     final uri = Uri.parse('$_baseUrl/App/auth/registration');

//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "email": email,
//         "password": password,
//         "username": username,
//         "profile_type": "couple",
//         "single_profile_gender_from": "",
//         "single_full_name": "",
//         "couple_profile_gender_from": coupleProfileGenderFrom,
//         "couple_profile_gender_to": coupleProfileGenderTo,
//         "couple_full_name_from": "",
//         "couple_full_name_to": "",
//         "lat": lat,
//         "lng": lng,
//         "city_name": cityName,
//         "place_id": placeId,
//         "map_url": mapUrl,
//         "formatted_address": formattedAddress,
//         "image_type": imageType,
//         "gender_profile_type": genderProfileType,
//         "filter_profile_type": "Couple",
//       }),
//     );

//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     if (response.statusCode == 200 || response.statusCode == 201) return body;
//     throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
//   }

//   // ════════════════════════════════════════════════════════════════
//   // GET ALL NOTIFICATIONS
//   // Sends token via header AND cookies (PHP session fallback)
//   // ════════════════════════════════════════════════════════════════
//   Future<List<NotificationModel>> getAllNotifications({
//     required String? token,
//     int page = 1,
//   }) async {
//     if (token == null || token
//         .trim()
//         .isEmpty) {
//       debugPrint('🔴 TOKEN IS NULL OR EMPTY');
//       throw Exception('Authentication token is missing. Please log in again.');
//     }

//     // final uri = Uri.parse('$_baseUrl/api/App/events/get_all_notification');
//     final uri = Uri.parse('$_baseUrl/App/events/get_all_notification');

//     debugPrint('🔵 NOTIFICATION REQUEST → $uri');
//     debugPrint('🔵 PAGE → $page');
//     debugPrint('🔵 HEADERS → ${_buildHeaders(token: token)}');

//     final response = await http.post(
//       uri,
//       headers: _buildHeaders(token: token),
//       body: jsonEncode({'page': page}),
//     );

//     final body = jsonDecode(response.body) as Map<String, dynamic>;

//     debugPrint('🟢 NOTIFICATION RESPONSE CODE → ${response.statusCode}');
//     debugPrint(
//         '🟢 NOTIFICATION RESPONSE BODY → ${const JsonEncoder.withIndent("  ")
//             .convert(body)}');

//     final apiStatus = body['status']?.toString() ?? '';

//     if (response.statusCode == 200 && apiStatus == '200') {
//       final dataList = body['data'] as List<dynamic>? ?? [];
//       debugPrint('🟢 NOTIFICATION COUNT → ${dataList.length}');
//       return dataList
//           .map((item) =>
//           NotificationModel.fromJson(item as Map<String, dynamic>))
//           .toList();
//     }

//     throw Exception(body['message'] ?? 'Failed to load notifications');
//   }

//   // ════════════════════════════════════════════════════════════════
//   // LOGOUT
//   // ════════════════════════════════════════════════════════════════
//   Future<void> logout({required String token}) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/user/logout');
//     final uri = Uri.parse('$_baseUrl/App/user/logout');

//     debugPrint('🔵 LOGOUT REQUEST → $uri');

//     final response = await http.post(
//       uri,
//       headers: _buildHeaders(token: token),
//     );

//     // Clear cookies on logout
//     _cookieJar.clear();

//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     debugPrint(
//         '🟢 LOGOUT RESPONSE → ${response.statusCode} | ${body['message']}');

//     if (response.statusCode >= 500) {
//       throw Exception(body['message'] ?? 'Logout failed');
//     }
//   }

//   // Headers - Add auth token here when available
//   Map<String, String> get _headers => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     // 'Authorization': 'Bearer $token', // Add token from secure storage
//   };

//   /// Fetch user profile - works for both single & couple
//   /// The API returns profile_type to differentiate
//   Future<UserProfileModel> fetchUserProfile() async {
//     try {
//       final response = await _client.get(
//         Uri.parse(AppConstants.singleProfileEndpoint),
//         headers: _headers,
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> body = json.decode(response.body);
//         if (body['status'] == '200' && body['data'] != null) {
//           return UserProfileModel.fromJson(body['data']);
//         } else {
//           throw ApiException(
//             message: 'Invalid response format',
//             statusCode: response.statusCode,
//           );
//         }
//       } else {
//         throw ApiException(
//           message: 'Failed to load profile',
//           statusCode: response.statusCode,
//         );
//       }
//     } on SocketException {
//       throw ApiException(message: 'No internet connection');
//     } on FormatException {
//       throw ApiException(message: 'Invalid response format');
//     } catch (e) {
//       if (e is ApiException) rethrow;
//       throw ApiException(message: 'Something went wrong: ${e.toString()}');
//     }
//   }

//   /// Update user profile
//   Future<UserProfileModel> updateUserProfile(
//       Map<String, dynamic> data) async {
//     try {
//       final response = await _client.post(
//         Uri.parse('${AppConstants.baseUrl}/update_profile'),
//         headers: _headers,
//         body: json.encode(data),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> body = json.decode(response.body);
//         if (body['status'] == '200' && body['data'] != null) {
//           return UserProfileModel.fromJson(body['data']);
//         }
//         throw ApiException(message: 'Update failed');
//       } else {
//         throw ApiException(
//           message: 'Failed to update profile',
//           statusCode: response.statusCode,
//         );
//       }
//     } on SocketException {
//       throw ApiException(message: 'No internet connection');
//     } catch (e) {
//       if (e is ApiException) rethrow;
//       throw ApiException(message: 'Something went wrong: ${e.toString()}');
//     }
//   }

//   /// Upload photo
//   Future<Map<String, dynamic>> uploadPhoto(File file) async {
//     try {
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse('${AppConstants.baseUrl}/upload_photo'),
//       );
//       request.headers.addAll(_headers);
//       request.files.add(
//         await http.MultipartFile.fromPath('photo', file.path),
//       );

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//       throw ApiException(message: 'Failed to upload photo');
//     } catch (e) {
//       if (e is ApiException) rethrow;
//       throw ApiException(message: 'Upload failed: ${e.toString()}');
//     }
//   }

//   /// Upload video
//   Future<Map<String, dynamic>> uploadVideo(File file) async {
//     try {
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse('${AppConstants.baseUrl}/upload_video'),
//       );
//       request.headers.addAll(_headers);
//       request.files.add(
//         await http.MultipartFile.fromPath('video', file.path),
//       );

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//       throw ApiException(message: 'Failed to upload video');
//     } catch (e) {
//       if (e is ApiException) rethrow;
//       throw ApiException(message: 'Upload failed: ${e.toString()}');
//     }
//   }

//   /// Fetch user photos
//   Future<List<String>> fetchPhotos() async {
//     try {
//       final response = await _client.get(
//         Uri.parse('${AppConstants.baseUrl}/get_photos'),
//         headers: _headers,
//       );

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);
//         if (body['status'] == '200' && body['data'] != null) {
//           return List<String>.from(body['data']);
//         }
//         return [];
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   /// Fetch user videos
//   Future<List<String>> fetchVideos() async {
//     try {
//       final response = await _client.get(
//         Uri.parse('${AppConstants.baseUrl}/get_videos'),
//         headers: _headers,
//       );

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);
//         if (body['status'] == '200' && body['data'] != null) {
//           return List<String>.from(body['data']);
//         }
//         return [];
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   /// Fetch albums
//   Future<List<Map<String, dynamic>>> fetchAlbums() async {
//     try {
//       final response = await _client.get(
//         Uri.parse('${AppConstants.baseUrl}/get_albums'),
//         headers: _headers,
//       );

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);
//         if (body['status'] == '200' && body['data'] != null) {
//           return List<Map<String, dynamic>>.from(body['data']);
//         }
//         return [];
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   void dispose() {
//     _client.close();
//   }

//   Future<Map<String, dynamic>> getProfile({required String token}) async {
//     // final uri = Uri.parse('$_baseUrl/api/users/profile');
//     final uri = Uri.parse('$_baseUrl/App/users/profile');
//     try {
//       final response = await http.get(
//         uri,
//         headers: _buildHeaders(token: token),
//       );
//       final body = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         return body;
//       }
//       throw Exception(body['message'] ?? 'Failed to load profile');
//     } catch (e) {
//       throw Exception('Error fetching profile: $e');
//     }
//   }

//   // ════════════════════════════════════════════════════════════════
//   // GET COUNTRIES
//   // GET /api/App/auth/getCountry
//   // ════════════════════════════════════════════════════════════════
//   // Future<List<CountryModel>> getCountries() async {
//   //   final uri = Uri.parse('$_baseUrl/api/App/auth/getCountry');
//   //   try {
//   //     final response = await http.get(uri);
//   //     if (response.statusCode == 200) {
//   //       final body = json.decode(response.body);
//   //       if (body['status'] == '200' && body['data'] != null) {
//   //         final List<dynamic> data = body['data'];
//   //         return data.map((item) => CountryModel.fromJson(item)).toList();
//   //       }
//   //     }
//   //     throw Exception('Failed to load countries');
//   //   } catch (e) {
//   //     throw Exception('Error fetching countries: $e');
//   //   }
//   // }
//   //
//   // // ════════════════════════════════════════════════════════════════
//   // // GET MEMBERSHIPS
//   // // GET /api/App/membership/get_all_membership
//   // // ════════════════════════════════════════════════════════════════
//   // Future<List<MembershipModel>> getAllMemberships() async {
//   //   final uri = Uri.parse('$_baseUrl/api/App/membership/get_all_membership');
//   //   try {
//   //     final response = await http.get(uri);
//   //     if (response.statusCode == 200) {
//   //       final body = json.decode(response.body);
//   //       if (body['status'] == '200' && body['data'] != null) {
//   //         final List<dynamic> data = body['data'];
//   //         return data.map((item) => MembershipModel.fromJson(item)).toList();
//   //       }
//   //     }
//   //     throw Exception('Failed to load memberships');
//   //   } catch (e) {
//   //     throw Exception('Error fetching memberships: $e');
//   //   }
//   // }

//   // ════════════════════════════════════════════════════════════════
//   // GET MEMBERSHIPS
//   // GET /api/App/membership/get_all_membership
//   // ════════════════════════════════════════════════════════════════
//   Future<List<MembershipModel>> getAllMemberships({String? token}) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/membership/get_all_membership');
//     final uri = Uri.parse('$_baseUrl/App/membership/get_all_membership');
//     try {
//       debugPrint('🔵 MEMBERSHIPS REQUEST → $uri');
//       debugPrint('🔵 MEMBERSHIPS TOKEN → ${token == null ? 'null' : token.length > 20 ? token.substring(0, 20) + '...' : token}');
//       final response = await http.get(uri, headers: _buildHeaders(token: token));

//       final body = json.decode(response.body);
//       debugPrint('🟢 MEMBERSHIPS RESPONSE BODY → ${body}');
//       final apiStatus = body['status']?.toString() ?? '';

//       if (response.statusCode == 200 && apiStatus == '200' && body['data'] != null) {
//         final List<dynamic> data = body['data'];
//         return data.map((item) => MembershipModel.fromJson(item)).toList();
//       }
//       throw Exception(body['message'] ?? 'Failed to load memberships');
//     } catch (e) {
//       throw Exception('Error fetching memberships: $e');
//     }
//   }

//   // ════════════════════════════════════════════════════════════════
//   // GET USER MEMBERSHIP PLAN
//   // POST /api/App/membership/get_user_membership_plan
//   // ════════════════════════════════════════════════════════════════
//   Future<UserMembershipPlanModel> getUserMembershipPlan({required String token}) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/membership/get_user_membership_plan');
//     final uri = Uri.parse('$_baseUrl/App/membership/get_user_membership_plan');
//     try {
//       // final response = await http.get(
//       //   uri,
//       //   headers: _buildHeaders(token: token),
//       // );
//       final response = await http.post(uri, headers: _buildHeaders(token: token));
//       final body = json.decode(response.body);
//       return UserMembershipPlanModel.fromJson(body);
//     } catch (e) {
//       throw Exception('Error fetching user membership plan: $e');
//     }
//   }

//   // ════════════════════════════════════════════════════════════════
//   // EVENTS & PARTIES
//   // ════════════════════════════════════════════════════════════════
//   Future<List<Map<String, dynamic>>> getEvents({required String token}) async {
//     // final uri = Uri.parse('$_baseUrl/api/events'); // Update path if moved to api/App
//     final uri = Uri.parse('$_baseUrl/App/events');
//     try {
//       final response = await http.get(
//         uri,
//         headers: _buildHeaders(token: token),
//       );
//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);
//         if (body is List) {
//           return body.cast<Map<String, dynamic>>();
//         } else if (body is Map && body['data'] is List) {
//           return (body['data'] as List).cast<Map<String, dynamic>>();
//         }
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Error fetching events: $e');
//       return [];
//     }
//   }

//   Future<Map<String, dynamic>> getFeaturedEvent({required String token}) async {
//     //  final uri = Uri.parse('$_baseUrl/api/events/featured');
//     final uri = Uri.parse('$_baseUrl/events/featured');
//     try {
//       final response = await http.get(
//         uri,
//         headers: _buildHeaders(token: token),
//       );
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       }
//       return {};
//     } catch (e) {
//       debugPrint('Error fetching featured event: $e');
//       return {};
//     }
//   }

//   Future<void> rsvpEvent({required String token, required String eventId}) async {
//     // final uri = Uri.parse('$_baseUrl/api/events/rsvp');
//     final uri = Uri.parse('$_baseUrl/events/rsvp');
//     try {
//       final response = await http.post(
//         uri,
//         headers: _buildHeaders(token: token),
//         body: jsonEncode({'eventId': eventId}),
//       );
//       if (response.statusCode != 200) {
//         throw Exception('Failed to RSVP');
//       }
//     } catch (e) {
//       throw Exception('Error in RSVP: $e');
//     }
//   }

//   // ════════════════════════════════════════════════════════════════
//   // NOTIFICATIONS (Additional methods)
//   // ════════════════════════════════════════════════════════════════
//   Future<void> markNotificationRead({
//     required String token,
//     required String notificationId,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/notifications/read/$notificationId');
//     final uri = Uri.parse('$_baseUrl/notifications/read/$notificationId');
//     try {
//       await http.put(uri, headers: _buildHeaders(token: token));
//     } catch (e) {
//       debugPrint('Error marking notification read: $e');
//     }
//   }

//   Future<void> clearNotifications({required String token}) async {
//     // final uri = Uri.parse('$_baseUrl/api/notifications/clear');
//     final uri = Uri.parse('$_baseUrl/notifications/clear');
//     try {
//       await http.delete(uri, headers: _buildHeaders(token: token));
//     } catch (e) {
//       debugPrint('Error clearing notifications: $e');
//     }
//   }

//   // ════════════════════════════════════════════════════════════════
//   // BUY/UPGRADE MEMBERSHIP
//   // POST /api/App/membership/membership_buy
//   // ════════════════════════════════════════════════════════════════
//   Future<Map<String, dynamic>> buyMembership({
//     required String token,
//     required String membershipId,
//     required String paymentId,
//     required String amount,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/membership/membership_buy');
//     final uri = Uri.parse('$_baseUrl/App/membership/membership_buy');
//     try {
//       final response = await http.post(
//         uri,
//         headers: _buildHeaders(token: token),
//         body: jsonEncode({
//           'membership_id': membershipId,
//           'payment_id': paymentId,
//           'amount': amount,
//         }),
//       );
//       return json.decode(response.body);
//     } catch (e) {
//       throw Exception('Error purchasing membership: $e');
//     }
//   }

//   // ════════════════════════════════════════════════════════════════
//   // FORGOT PASSWORD
//   // ════════════════════════════════════════════════════════════════
//   Future<Map<String, dynamic>> requestPasswordReset({
//     required String email,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/auth/forgot-password/request');
//     final uri = Uri.parse('$_baseUrl/App/auth/forgot-password/request');
//     debugPrint('🔵 RESET REQUEST → $uri');

//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email.trim()}),
//     );

//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     if (response.statusCode == 200) return body;
//     throw Exception(body['message'] ?? 'Failed to request reset token');
//   }

//   Future<Map<String, dynamic>> resetPassword({
//     required String email,
//     required String resetToken,
//     required String newPassword,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/auth/forgot-password/reset');
//     final uri = Uri.parse('$_baseUrl/App/auth/forgot-password/reset');
//     debugPrint('🔵 RESET PASSWORD → $uri');

//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': email.trim(),
//         'resetToken': resetToken.trim(),
//         'newPassword': newPassword,
//       }),
//     );

//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     if (response.statusCode == 200) return body;
//     throw Exception(body['message'] ?? 'Failed to update password');
//   }

//   // ════════════════════════════════════════════════════════════════
//   // CHAT & MESSAGING
//   // ════════════════════════════════════════════════════════════════
//   Future<List<Map<String, dynamic>>> getMessages({
//     required String token,
//     required String userId,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/messages/conversation/$userId');
//     final uri = Uri.parse('$_baseUrl/messages/conversation/$userId');
//     try {
//       final response = await http.get(uri, headers: _buildHeaders(token: token));
//       final decoded = jsonDecode(response.body);
//       if (response.statusCode == 200 && decoded is List) {
//         return decoded.cast<Map<String, dynamic>>();
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Error fetching messages: $e');
//       return [];
//     }
//   }

//   Future<Map<String, dynamic>> sendMessage({
//     required String token,
//     required String receiverId,
//     required String content,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/messages/send');
//     final uri = Uri.parse('$_baseUrl/messages/send');
//     final response = await http.post(
//       uri,
//       headers: _buildHeaders(token: token),
//       body: jsonEncode({
//         'receiverId': receiverId,
//         'content': content,
//       }),
//     );

//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       return body;
//     }
//     throw Exception(body['message'] ?? 'Failed to send message');
//   }

//   // ════════════════════════════════════════════════════════════════
//   // CHATROOMS
//   // ════════════════════════════════════════════════════════════════
//   Future<List<Map<String, dynamic>>> getChatrooms({
//     required String token,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/chatrooms');
//     final uri = Uri.parse('$_baseUrl/chatrooms');
//     try {
//       final response = await http.get(uri, headers: _buildHeaders(token: token));
//       final decoded = jsonDecode(response.body);
//       if (response.statusCode == 200 && decoded is List) {
//         return decoded.cast<Map<String, dynamic>>();
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Error fetching chatrooms: $e');
//       return [];
//     }
//   }

//   Future<Map<String, dynamic>> createChatroom({
//     required String token,
//     required String name,
//     required String category,
//     String description = '',
//     bool isPrivate = false,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/chatrooms');
//     final uri = Uri.parse('$_baseUrl/chatrooms');
//     final response = await http.post(
//       uri,
//       headers: _buildHeaders(token: token),
//       body: jsonEncode({
//         'name': name,
//         'category': category,
//         'description': description,
//         'isPrivate': isPrivate,
//       }),
//     );

//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       return body;
//     }
//     throw Exception(body['message'] ?? 'Failed to create chatroom');
//   }

//   Future<void> updatePrivacy({
//     required String token,
//     required Map<String, dynamic> privacy,
//   }) async {
//     // final uri = Uri.parse('$_baseUrl/api/App/user/update_privacy'); // Assuming endpoint
//     final uri = Uri.parse('$_baseUrl/App/user/update_privacy');
//     final response = await http.post(
//       uri,
//       headers: _buildHeaders(token: token),
//       body: jsonEncode({'privacy': privacy}),
//     );

//     final body = jsonDecode(response.body) as Map<String, dynamic>;
//     if (response.statusCode != 200) {
//       throw ApiException(
//         message: body['message'] ?? 'Failed to update privacy',
//         statusCode: response.statusCode,
//       );
//     }
//   }
//   // ════════════════════════════════════════════════════════════════
// // CHECK LOGIN USER MEMBERSHIP
// // POST https://app.beatflirtevent.com/App/user/check_login_user_membership
// //
// // 🔹 Response when NOT purchased:
// //    {"status":"404","membership_expire":"Yes"}
// // 🔹 Response when purchased:
// //    {"status":"200","membership_expire":"No"}
// // ════════════════════════════════════════════════════════════════
// Future<Map<String, dynamic>> checkLoginUserMembership({
//   required String token,
// }) async {
//   final uri = Uri.parse('https://app.beatflirtevent.com/App/user/check_login_user_membership');

//   debugPrint('🔵 MEMBERSHIP CHECK REQUEST → $uri');

//   final response = await http.post(
//     uri,
//     headers: _buildHeaders(token: token),
//   );

//   final body = jsonDecode(response.body) as Map<String, dynamic>;

//   debugPrint('🟢 MEMBERSHIP CHECK RESPONSE → $body');

//   return body;
// }

// }

// class ApiException implements Exception {
//   final String message;
//   final int? statusCode;

//   ApiException({required this.message, this.statusCode});

//   @override
//   String toString() => 'ApiException: $message (Code: $statusCode)';
// }

// // import 'dart:convert';
// // import 'package:flutter/foundation.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:beatflirt/model/notification_model.dart';

// // class ApiService {
// //   // ✅ FIXED: plain URL — no markdown brackets
// //   static const String _baseUrl = 'https://beatflirtevent.com';

// //   // ════════════════════════════════════════════════════════════════
// //   // LOGIN
// //   // POST /api/App/auth/login
// //   // ════════════════════════════════════════════════════════════════
// //   Future<Map<String, dynamic>> login({
// //     required String username,
// //     required String password,
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/login');

// //     debugPrint('🔵 LOGIN REQUEST → $uri');
// //     debugPrint('🔵 BODY → {"username": "$username", "password": "***"}');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         'username': username,
// //         'password': password,
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;

// //     debugPrint('🟢 LOGIN RESPONSE CODE → ${response.statusCode}');
// //     debugPrint('🟢 LOGIN RESPONSE BODY → ${const JsonEncoder.withIndent("  ").convert(body)}');

// //     final apiStatus = body['status']?.toString() ?? '';
// //     if (response.statusCode == 200 && apiStatus == '200') {
// //       final data = body['data'] as Map<String, dynamic>? ?? {};
// //       debugPrint('🟢 TOKEN RECEIVED → ${data['token']}');
// //       debugPrint('🟢 USER ID → ${data['userid']}');
// //       return body;
// //     }

// //     throw Exception(body['message'] ?? body['error'] ?? 'Login failed');
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // REGISTER — SINGLE
// //   // ════════════════════════════════════════════════════════════════
// //   Future<Map<String, dynamic>> registerSingle({
// //     required String email,
// //     required String password,
// //     required String username,
// //     required String singleProfileGenderFrom,
// //     required String lat,
// //     required String lng,
// //     required String cityName,
// //     required String placeId,
// //     required String mapUrl,
// //     required String formattedAddress,
// //     required String imageType,
// //     required String genderProfileType,
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/registration');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         "email": email,
// //         "password": password,
// //         "username": username,
// //         "profile_type": "single",
// //         "single_profile_gender_from": singleProfileGenderFrom,
// //         "single_full_name": "",
// //         "couple_profile_gender_from": "",
// //         "couple_profile_gender_to": "",
// //         "couple_full_name_from": "",
// //         "couple_full_name_to": "",
// //         "lat": lat,
// //         "lng": lng,
// //         "city_name": cityName,
// //         "place_id": placeId,
// //         "map_url": mapUrl,
// //         "formatted_address": formattedAddress,
// //         "image_type": imageType,
// //         "gender_profile_type": genderProfileType,
// //         "filter_profile_type": "Male",
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     if (response.statusCode == 200 || response.statusCode == 201) return body;
// //     throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // REGISTER — COUPLE
// //   // ════════════════════════════════════════════════════════════════
// //   Future<Map<String, dynamic>> registerCouple({
// //     required String email,
// //     required String password,
// //     required String username,
// //     required String coupleProfileGenderFrom,
// //     required String coupleProfileGenderTo,
// //     required String lat,
// //     required String lng,
// //     required String cityName,
// //     required String placeId,
// //     required String mapUrl,
// //     required String formattedAddress,
// //     required String imageType,
// //     required String genderProfileType,
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/registration');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         "email": email,
// //         "password": password,
// //         "username": username,
// //         "profile_type": "couple",
// //         "single_profile_gender_from": "",
// //         "single_full_name": "",
// //         "couple_profile_gender_from": coupleProfileGenderFrom,
// //         "couple_profile_gender_to": coupleProfileGenderTo,
// //         "couple_full_name_from": "",
// //         "couple_full_name_to": "",
// //         "lat": lat,
// //         "lng": lng,
// //         "city_name": cityName,
// //         "place_id": placeId,
// //         "map_url": mapUrl,
// //         "formatted_address": formattedAddress,
// //         "image_type": imageType,
// //         "gender_profile_type": genderProfileType,
// //         "filter_profile_type": "Couple",
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     if (response.statusCode == 200 || response.statusCode == 201) return body;
// //     throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // GET ALL NOTIFICATIONS
// //   // POST /api/App/events/get_all_notification
// //   // ════════════════════════════════════════════════════════════════
// //   Future<List<NotificationModel>> getAllNotifications({
// //     required String? token,
// //     int page = 1,
// //   }) async {
// //     if (token == null || token.trim().isEmpty) {
// //       debugPrint('🔴 TOKEN IS NULL OR EMPTY — aborting request');
// //       throw Exception('Authentication token is missing. Please log in again.');
// //     }

// //     final uri = Uri.parse('$_baseUrl/api/App/events/get_all_notification');

// //     debugPrint('🔵 NOTIFICATION REQUEST → $uri');
// //     debugPrint('🔵 PAGE → $page');
// //     debugPrint('🔵 TOKEN (first 20 chars) → ${token.substring(0, token.length > 20 ? 20 : token.length)}...');

// //     // ── BODY includes token because many PHP backends strip the Authorization header ──
// //     final requestBody = jsonEncode({
// //       'page': page,
// //       'token': token,        // ← ADDED: backup token for broken header parsing
// //     });

// //     final headers = {
// //       'Authorization': 'Bearer $token',
// //       'Content-Type': 'application/json',
// //     };

// //     debugPrint('🔵 HEADERS → $headers');
// //     debugPrint('🔵 BODY → $requestBody');

// //     final response = await http.post(
// //       uri,
// //       headers: headers,
// //       body: requestBody,
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;

// //     debugPrint('🟢 NOTIFICATION RESPONSE CODE → ${response.statusCode}');
// //     debugPrint('🟢 NOTIFICATION RESPONSE BODY → ${const JsonEncoder.withIndent("  ").convert(body)}');

// //     final apiStatus = body['status']?.toString() ?? '';

// //     if (response.statusCode == 200 && apiStatus == '200') {
// //       final dataList = body['data'] as List<dynamic>? ?? [];
// //       debugPrint('🟢 NOTIFICATION COUNT → ${dataList.length}');
// //       return dataList
// //           .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
// //           .toList();
// //     }

// //     throw Exception(body['message'] ?? 'Failed to load notifications');
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // LOGOUT
// //   // POST /api/App/user/logout
// //   // ════════════════════════════════════════════════════════════════
// //   Future<void> logout({required String token}) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/user/logout');

// //     debugPrint('🔵 LOGOUT REQUEST → $uri');

// //     final response = await http.post(
// //       uri,
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Content-Type': 'application/json',
// //       },
// //       // Also send token in body for the same header-stripping reason
// //       body: jsonEncode({'token': token}),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     debugPrint('🟢 LOGOUT RESPONSE → ${response.statusCode} | ${body['message']}');

// //     if (response.statusCode >= 500) {
// //       throw Exception(body['message'] ?? 'Logout failed');
// //     }
// //   }
// // }

// // import 'dart:convert';
// // import 'package:flutter/foundation.dart'; // for debugPrint
// // import 'package:http/http.dart' as http;
// // import 'package:beatflirt/model/notification_model.dart';

// // class ApiService {
// //   // ✅ FIXED: removed accidental markdown brackets
// //   static const String _baseUrl = 'https://beatflirtevent.com';

// //   // ════════════════════════════════════════════════════════════════
// //   // LOGIN
// //   // POST /api/App/auth/login
// //   // ════════════════════════════════════════════════════════════════
// //   Future<Map<String, dynamic>> login({
// //     required String username,
// //     required String password,
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/login');

// //     debugPrint('🔵 LOGIN REQUEST → $uri');
// //     debugPrint('🔵 BODY → {"username": "$username", "password": "***"}');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         'username': username,
// //         'password': password,
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;

// //     debugPrint('🟢 LOGIN RESPONSE CODE → ${response.statusCode}');
// //     debugPrint('🟢 LOGIN RESPONSE BODY → ${const JsonEncoder.withIndent("  ").convert(body)}');

// //     final apiStatus = body['status']?.toString() ?? '';
// //     if (response.statusCode == 200 && apiStatus == '200') {
// //       final data = body['data'] as Map<String, dynamic>? ?? {};
// //       debugPrint('🟢 TOKEN RECEIVED → ${data['token']}');
// //       debugPrint('🟢 USER ID → ${data['userid']}');
// //       return body;
// //     }

// //     throw Exception(body['message'] ?? body['error'] ?? 'Login failed');
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // REGISTER — SINGLE
// //   // ════════════════════════════════════════════════════════════════
// //   Future<Map<String, dynamic>> registerSingle({
// //     required String email,
// //     required String password,
// //     required String username,
// //     required String singleProfileGenderFrom,
// //     required String lat,
// //     required String lng,
// //     required String cityName,
// //     required String placeId,
// //     required String mapUrl,
// //     required String formattedAddress,
// //     required String imageType,
// //     required String genderProfileType,
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/registration');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         "email": email,
// //         "password": password,
// //         "username": username,
// //         "profile_type": "single",
// //         "single_profile_gender_from": singleProfileGenderFrom,
// //         "single_full_name": "",
// //         "couple_profile_gender_from": "",
// //         "couple_profile_gender_to": "",
// //         "couple_full_name_from": "",
// //         "couple_full_name_to": "",
// //         "lat": lat,
// //         "lng": lng,
// //         "city_name": cityName,
// //         "place_id": placeId,
// //         "map_url": mapUrl,
// //         "formatted_address": formattedAddress,
// //         "image_type": imageType,
// //         "gender_profile_type": genderProfileType,
// //         "filter_profile_type": "Male",
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     if (response.statusCode == 200 || response.statusCode == 201) return body;
// //     throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // REGISTER — COUPLE
// //   // ════════════════════════════════════════════════════════════════
// //   Future<Map<String, dynamic>> registerCouple({
// //     required String email,
// //     required String password,
// //     required String username,
// //     required String coupleProfileGenderFrom,
// //     required String coupleProfileGenderTo,
// //     required String lat,
// //     required String lng,
// //     required String cityName,
// //     required String placeId,
// //     required String mapUrl,
// //     required String formattedAddress,
// //     required String imageType,
// //     required String genderProfileType,
// //   }) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/auth/registration');

// //     final response = await http.post(
// //       uri,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         "email": email,
// //         "password": password,
// //         "username": username,
// //         "profile_type": "couple",
// //         "single_profile_gender_from": "",
// //         "single_full_name": "",
// //         "couple_profile_gender_from": coupleProfileGenderFrom,
// //         "couple_profile_gender_to": coupleProfileGenderTo,
// //         "couple_full_name_from": "",
// //         "couple_full_name_to": "",
// //         "lat": lat,
// //         "lng": lng,
// //         "city_name": cityName,
// //         "place_id": placeId,
// //         "map_url": mapUrl,
// //         "formatted_address": formattedAddress,
// //         "image_type": imageType,
// //         "gender_profile_type": genderProfileType,
// //         "filter_profile_type": "Couple",
// //       }),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     if (response.statusCode == 200 || response.statusCode == 201) return body;
// //     throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // GET ALL NOTIFICATIONS
// //   // POST /api/App/events/get_all_notification
// //   // Body: {"page": page}
// //   // Header: Authorization: Bearer <token>
// //   // ════════════════════════════════════════════════════════════════
// //   Future<List<NotificationModel>> getAllNotifications({
// //     required String? token,
// //     int page = 1,
// //   }) async {
// //     // ── Guard: token must exist ─────────────────────
// //     if (token == null || token.trim().isEmpty) {
// //       debugPrint('🔴 TOKEN IS NULL OR EMPTY — aborting request');
// //       throw Exception('Authentication token is missing. Please log in again.');
// //     }

// //     final uri = Uri.parse('$_baseUrl/api/App/events/get_all_notification');
// //     debugPrint('🔵 NOTIFICATION REQUEST → $uri');
// //     debugPrint('🔵 PAGE → $page');
// //     debugPrint('🔵 TOKEN → ${token.substring(0, token.length > 20 ? 20 : token.length)}...');

// //     final response = await http.post(
// //       uri,
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Content-Type': 'application/json',
// //       },
// //       body: jsonEncode({'page': page}),
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;

// //     debugPrint('🟢 NOTIFICATION RESPONSE CODE → ${response.statusCode}');
// //     debugPrint('🟢 NOTIFICATION RESPONSE BODY → ${const JsonEncoder.withIndent("  ").convert(body)}');

// //     final apiStatus = body['status']?.toString() ?? '';

// //     if (response.statusCode == 200 && apiStatus == '200') {
// //       final dataList = body['data'] as List<dynamic>? ?? [];
// //       debugPrint('🟢 NOTIFICATION COUNT → ${dataList.length}');
// //       return dataList
// //           .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
// //           .toList();
// //     }

// //     throw Exception(body['message'] ?? 'Failed to load notifications');
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // LOGOUT
// //   // POST /api/App/user/logout
// //   // ════════════════════════════════════════════════════════════════
// //   Future<void> logout({required String token}) async {
// //     final uri = Uri.parse('$_baseUrl/api/App/user/logout');

// //     debugPrint('🔵 LOGOUT REQUEST → $uri');

// //     final response = await http.post(
// //       uri,
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Content-Type': 'application/json',
// //       },
// //     );

// //     final body = jsonDecode(response.body) as Map<String, dynamic>;
// //     debugPrint('🟢 LOGOUT RESPONSE → ${response.statusCode} | ${body['message']}');

// //     if (response.statusCode >= 500) {
// //       throw Exception(body['message'] ?? 'Logout failed');
// //     }
// //   }
// // }

import 'dart:convert';
import 'dart:io';

import 'package:beatflirt/core/services/token_services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:beatflirt/model/notification_model.dart';
import 'package:beatflirt/model/membership_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:beatflirt/model/country_model.dart';
// import 'package:dio/dio.dart';
import '../core/constants.dart';
import 'package:beatflirt/model/user_membership_plan_model.dart';
import '../model/user_model.dart';
import '../model/user_profile_model.dart';
import '../core/services/auth_services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import '../screens/login_page.dart';
// import '../core/celebrity_app_const.dart' as celeb_const;

class ApiService {
  static const String _baseUrl = 'https://app.beatflirtevent.com';

  // ── HTTP client (initialized with constructor or fallback) ──────────
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ── Cookie jar for PHP session auth ─────────────────────────────────
  static final Map<String, String> _cookieJar = {};

  static void _extractCookies(http.Response response) {
    final raw = response.headers['set-cookie'];
    if (raw == null || raw.isEmpty) return;
    for (final segment in raw.split(',')) {
      final c = segment.trim().split(';').first.trim();
      final idx = c.indexOf('=');
      if (idx > 0) {
        _cookieJar[c.substring(0, idx).trim()] = c.substring(idx + 1).trim();
      }
    }
  }

  static Map<String, String> _buildHeaders({String? token}) {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
      h['access-token'] = token; // fallback
    }
    if (_cookieJar.isNotEmpty) {
      h['Cookie'] = _cookieJar.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');
    }
    return h;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  TOKEN-EXPIRY HANDLER — redirects to login
  // ═══════════════════════════════════════════════════════════════════

  /// Called when the server indicates the token is expired/invalid.
  /// Clears local session and navigates to the login screen.
  static Future<void> _handleAuthExpired() async {
    debugPrint('🔴 TOKEN EXPIRED — redirecting to login');
    try {
      await AuthService.logout();
    } catch (e) {
      debugPrint('⚠️ Logout during expiry handling failed: $e');
    }
    // Use GetX navigation to clear the entire stack and go to LoginPage
    try {
      Get.offAll(() => const LoginPage());
    } catch (e) {
      debugPrint('⚠️ Navigation to login failed: $e');
    }
  }

  /// Inspects an API response and triggers [_handleAuthExpired] if the
  /// token appears to be expired or invalid.
  static void _maybeHandleAuthExpiry(
    http.Response response,
    Map<String, dynamic>? body,
  ) {
    final statusCode = response.statusCode;
    final apiStatus = body?['status']?.toString() ?? '';
    final message = (body?['message'] ?? body?['error'] ?? '')
        .toString()
        .toLowerCase();

    final bool expired =
        statusCode == 401 ||
        apiStatus == '401' ||
        apiStatus == '403' ||
        (message.contains('token') && message.contains('expired')) ||
        message.contains('invalid token') ||
        message.contains('token is invalid') ||
        message.contains('token has expired');

    if (expired) {
      _handleAuthExpired();
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // LOGIN
  // ═══════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/auth/login');
    debugPrint('🔵 LOGIN REQUEST → $uri');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    // ✅ Capture PHP session cookie from login
    _extractCookies(response);
    debugPrint('🟢 COOKIES AFTER LOGIN → $_cookieJar');

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint('🟢 LOGIN RESPONSE CODE → ${response.statusCode}');
    debugPrint(
      '🟢 LOGIN RESPONSE BODY → '
      '${const JsonEncoder.withIndent("  ").convert(body)}',
    );

    final apiStatus = body['status']?.toString() ?? '';
    if (response.statusCode == 200 && apiStatus == '200') {
      final data = body['data'] as Map<String, dynamic>? ?? {};
      debugPrint('🟢 TOKEN RECEIVED → ${data['token']}');
      debugPrint('🟢 USER ID → ${data['userid']}');
      return body;
    }

    throw Exception(body['message'] ?? body['error'] ?? 'Login failed');
  }

  // ═══════════════════════════════════════════════════════════════════
  // REGISTER — SINGLE
  // ═══════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> registerSingle({
    required String email,
    required String password,
    required String username,
    required String singleProfileGenderFrom,
    required String lat,
    required String lng,
    required String cityName,
    required String placeId,
    required String mapUrl,
    required String formattedAddress,
    required String imageType,
    required String genderProfileType,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/auth/registration');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
        "username": username,
        "profile_type": "single",
        "single_profile_gender_from": singleProfileGenderFrom,
        "single_full_name": "",
        "couple_profile_gender_from": "",
        "couple_profile_gender_to": "",
        "couple_full_name_from": "",
        "couple_full_name_to": "",
        "lat": lat,
        "lng": lng,
        "city_name": cityName,
        "place_id": placeId,
        "map_url": mapUrl,
        "formatted_address": formattedAddress,
        "image_type": imageType,
        "gender_profile_type": genderProfileType,
        "filter_profile_type": "Male",
      }),
    );
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 || response.statusCode == 201) return body;
    throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
  }

  // ═══════════════════════════════════════════════════════════════════
  // REGISTER — COUPLE
  // ═══════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> registerCouple({
    required String email,
    required String password,
    required String username,
    required String coupleProfileGenderFrom,
    required String coupleProfileGenderTo,
    required String lat,
    required String lng,
    required String cityName,
    required String placeId,
    required String mapUrl,
    required String formattedAddress,
    required String imageType,
    required String genderProfileType,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/auth/registration');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
        "username": username,
        "profile_type": "couple",
        "single_profile_gender_from": "",
        "single_full_name": "",
        "couple_profile_gender_from": coupleProfileGenderFrom,
        "couple_profile_gender_to": coupleProfileGenderTo,
        "couple_full_name_from": "",
        "couple_full_name_to": "",
        "lat": lat,
        "lng": lng,
        "city_name": cityName,
        "place_id": placeId,
        "map_url": mapUrl,
        "formatted_address": formattedAddress,
        "image_type": imageType,
        "gender_profile_type": genderProfileType,
        "filter_profile_type": "Couple",
      }),
    );
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 || response.statusCode == 201) return body;
    throw Exception(body['message'] ?? body['error'] ?? 'Registration failed');
  }

  // ═══════════════════════════════════════════════════════════════════
  // GET ALL NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════

  Future<List<NotificationModel>> getAllNotifications({
    required String? token,
    int page = 1,
  }) async {
    if (token == null || token.trim().isEmpty) {
      debugPrint('🔴 TOKEN IS NULL OR EMPTY');
      throw Exception('Authentication token is missing. Please log in again.');
    }

    final uri = Uri.parse('$_baseUrl/App/events/get_all_notification');
    debugPrint('🔵 NOTIFICATION REQUEST → $uri');
    debugPrint('🔵 PAGE → $page');
    debugPrint('🔵 HEADERS → ${_buildHeaders(token: token)}');

    final response = await http.post(
      uri,
      headers: _buildHeaders(token: token),
      body: jsonEncode({'page': page}),
    );

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    // ✅ CHECK TOKEN EXPIRY
    _maybeHandleAuthExpiry(response, body);

    debugPrint('🟢 NOTIFICATION RESPONSE CODE → ${response.statusCode}');
    debugPrint(
      '🟢 NOTIFICATION RESPONSE BODY → '
      '${const JsonEncoder.withIndent("  ").convert(body)}',
    );

    final apiStatus = body['status']?.toString() ?? '';
    if (response.statusCode == 200 && apiStatus == '200') {
      final dataList = body['data'] as List<dynamic>? ?? [];
      debugPrint('🟢 NOTIFICATION COUNT → ${dataList.length}');
      return dataList
          .map(
            (item) => NotificationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    throw Exception(body['message'] ?? 'Failed to load notifications');
  }

  // ═══════════════════════════════════════════════════════════════════
  // LOGOUT
  // ═══════════════════════════════════════════════════════════════════

  Future<void> logout({required String token}) async {
    final uri = Uri.parse('$_baseUrl/App/user/logout');
    debugPrint('🔵 LOGOUT REQUEST → $uri');

    final response = await http.post(uri, headers: _buildHeaders(token: token));

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    // ✅ CHECK TOKEN EXPIRY (in case the server rejects the logout itself)
    _maybeHandleAuthExpiry(response, body);

    // Clear cookies on logout
    _cookieJar.clear();
    debugPrint(
      '🟢 LOGOUT RESPONSE → ${response.statusCode} | ${body['message']}',
    );

    if (response.statusCode >= 500) {
      throw Exception(body['message'] ?? 'Logout failed');
    }
  }

  // ── Headers for profile/photo/video methods (instance-level) ──────
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Fetch user profile - works for both single & couple
  Future<UserProfileModel> fetchUserProfile() async {
    try {
      final token = await AuthService.getToken();
      final response = await _client.post(
        Uri.parse(AppConstants.singleProfileEndpoint),
        headers: _buildHeaders(token: token),
        body: json.encode({}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;
        if (body['status'] == '200' && body['data'] != null) {
          return UserProfileModel.fromJson(body['data']);
        } else {
          throw ApiException(
            message: 'Invalid response format',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message: 'Failed to load profile',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on FormatException {
      throw ApiException(message: 'Invalid response format');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Something went wrong: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final token = await AuthService.getToken();
      final response = await _client.post(
        Uri.parse('${AppConstants.baseUrl}/update_profile'),
        headers: _buildHeaders(token: token),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;
        if (body['status'] == '200' && body['data'] != null) {
          return UserProfileModel.fromJson(body['data']);
        }
        throw ApiException(message: 'Update failed');
      } else {
        throw ApiException(
          message: 'Failed to update profile',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Something went wrong: ${e.toString()}');
    }
  }

  /// Upload photo
  Future<Map<String, dynamic>> uploadPhoto(File file) async {
    try {
      final token = await AuthService.getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/upload_photo'),
      );
      request.headers.addAll(_buildHeaders(token: token));
      request.files.add(await http.MultipartFile.fromPath('photo', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      throw ApiException(message: 'Failed to upload photo');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Upload failed: ${e.toString()}');
    }
  }

  /// Upload video
  Future<Map<String, dynamic>> uploadVideo(File file) async {
    try {
      final token = await AuthService.getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/upload_video'),
      );
      request.headers.addAll(_buildHeaders(token: token));
      request.files.add(await http.MultipartFile.fromPath('video', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      throw ApiException(message: 'Failed to upload video');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Upload failed: ${e.toString()}');
    }
  }

  /// Fetch user photos
  Future<List<String>> fetchPhotos() async {
    try {
      final token = await AuthService.getToken();
      final response = await _client.get(
        Uri.parse('${AppConstants.baseUrl}/get_photos'),
        headers: _buildHeaders(token: token),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;
        if (body['status'] == '200' && body['data'] != null) {
          return List<String>.from(body['data'] as List<dynamic>);
        }
        return [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Fetch user videos
  Future<List<String>> fetchVideos() async {
    try {
      final token = await AuthService.getToken();
      final response = await _client.get(
        Uri.parse('${AppConstants.baseUrl}/get_videos'),
        headers: _buildHeaders(token: token),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;
        if (body['status'] == '200' && body['data'] != null) {
          return List<String>.from(body['data'] as List<dynamic>);
        }
        return [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Fetch albums
  Future<List<Map<String, dynamic>>> fetchAlbums() async {
    try {
      final token = await AuthService.getToken();
      final response = await _client.get(
        Uri.parse('${AppConstants.baseUrl}/get_albums'),
        headers: _buildHeaders(token: token),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;
        if (body['status'] == '200' && body['data'] != null) {
          return List<Map<String, dynamic>>.from(body['data'] as List<dynamic>);
        }
        return [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  void dispose() {
    _client.close();
  }

  Future<Map<String, dynamic>> getProfile({required String token}) async {
    final uri = Uri.parse('$_baseUrl/App/users/profile');
    try {
      final response = await http.get(
        uri,
        headers: _buildHeaders(token: token),
      );

      final Map<String, dynamic>? body =
          jsonDecode(response.body) as Map<String, dynamic>?;

      // ✅ CHECK TOKEN EXPIRY
      _maybeHandleAuthExpiry(response, body);

      if (response.statusCode == 200 && body != null) {
        return body;
      }
      throw Exception(body?['message'] ?? 'Failed to load profile');
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // GET MEMBERSHIPS
  // ═══════════════════════════════════════════════════════════════════

  Future<List<MembershipModel>> getAllMemberships({String? token}) async {
    final uri = Uri.parse('$_baseUrl/App/membership/get_all_membership');
    try {
      debugPrint('🔵 MEMBERSHIPS REQUEST → $uri');
      debugPrint(
        '🔵 MEMBERSHIPS TOKEN → ${token == null
            ? 'null'
            : token.length > 20
            ? token.substring(0, 20) + '...'
            : token}',
      );
      final response = await http.get(
        uri,
        headers: _buildHeaders(token: token),
      );

      final Map<String, dynamic>? body =
          json.decode(response.body) as Map<String, dynamic>?;
      debugPrint('🟢 MEMBERSHIPS RESPONSE BODY → $body');

      // ✅ CHECK TOKEN EXPIRY
      _maybeHandleAuthExpiry(response, body);

      final apiStatus = body?['status']?.toString() ?? '';
      if (response.statusCode == 200 &&
          apiStatus == '200' &&
          body != null &&
          body['data'] != null) {
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data.map((item) => MembershipModel.fromJson(item)).toList();
      }
      throw Exception(body?['message'] ?? 'Failed to load memberships');
    } catch (e) {
      throw Exception('Error fetching memberships: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // GET USER MEMBERSHIP PLAN
  // ═══════════════════════════════════════════════════════════════════

  Future<UserMembershipPlanModel> getUserMembershipPlan({
    required String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/membership/get_user_membership_plan');
    try {
      final response = await http.post(
        uri,
        headers: _buildHeaders(token: token),
      );

      final Map<String, dynamic>? body =
          json.decode(response.body) as Map<String, dynamic>?;

      // ✅ CHECK TOKEN EXPIRY
      _maybeHandleAuthExpiry(response, body);

      if (body == null) throw Exception('Empty response from server');
      return UserMembershipPlanModel.fromJson(body);
    } catch (e) {
      throw Exception('Error fetching user membership plan: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // EVENTS & PARTIES
  // ═══════════════════════════════════════════════════════════════════

  Future<List<Map<String, dynamic>>> getEvents({required String token}) async {
    final uri = Uri.parse('$_baseUrl/App/events');
    try {
      final response = await http.get(
        uri,
        headers: _buildHeaders(token: token),
      );

      final dynamic body = json.decode(response.body);

      // ✅ CHECK TOKEN EXPIRY
      _maybeHandleAuthExpiry(
        response,
        body is Map<String, dynamic> ? body : null,
      );

      if (body is List) {
        return body.cast<Map<String, dynamic>>();
      } else if (body is Map<String, dynamic> && body['data'] is List) {
        return (body['data'] as List<dynamic>).cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching events: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getFeaturedEvent({required String token}) async {
    final uri = Uri.parse('$_baseUrl/App/events/featured');
    try {
      final response = await http.get(
        uri,
        headers: _buildHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic>? body =
            json.decode(response.body) as Map<String, dynamic>?;

        // ✅ CHECK TOKEN EXPIRY
        _maybeHandleAuthExpiry(response, body);

        if (body != null) return body;
      }
      return {};
    } catch (e) {
      debugPrint('Error fetching featured event: $e');
      return {};
    }
  }

  Future<void> rsvpEvent({
    required String token,
    required String eventId,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/events/rsvp');
    try {
      final response = await http.post(
        uri,
        headers: _buildHeaders(token: token),
        body: jsonEncode({'eventId': eventId}),
      );

      final Map<String, dynamic>? body =
          jsonDecode(response.body) as Map<String, dynamic>?;

      // ✅ CHECK TOKEN EXPIRY
      _maybeHandleAuthExpiry(response, body);

      if (response.statusCode != 200) {
        throw Exception('Failed to RSVP');
      }
    } catch (e) {
      throw Exception('Error in RSVP: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // NOTIFICATIONS (Additional methods)
  // ═══════════════════════════════════════════════════════════════════

  Future<void> markNotificationRead({
    required String token,
    required String notificationId,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/notifications/read/$notificationId');
    try {
      final response = await http.put(
        uri,
        headers: _buildHeaders(token: token),
      );
      final Map<String, dynamic>? body = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>?
          : null;
      _maybeHandleAuthExpiry(response, body);
    } catch (e) {
      debugPrint('Error marking notification read: $e');
    }
  }

  Future<void> clearNotifications({required String token}) async {
    final uri = Uri.parse('$_baseUrl/App/notifications/clear');
    try {
      final response = await http.delete(
        uri,
        headers: _buildHeaders(token: token),
      );
      final Map<String, dynamic>? body = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>?
          : null;
      _maybeHandleAuthExpiry(response, body);
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // BUY/UPGRADE MEMBERSHIP
  // ═══════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> buyMembership({
    required String token,
    required String membershipId,
    required String paymentId,
    required String amount,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/membership/membership_buy');
    try {
      final response = await http.post(
        uri,
        headers: _buildHeaders(token: token),
        body: jsonEncode({
          'membership_id': membershipId,
          'payment_id': paymentId,
          'amount': amount,
        }),
      );

      final Map<String, dynamic>? body =
          json.decode(response.body) as Map<String, dynamic>?;

      // ✅ CHECK TOKEN EXPIRY
      _maybeHandleAuthExpiry(response, body);

      if (body == null) throw Exception('Empty response');
      return body;
    } catch (e) {
      throw Exception('Error purchasing membership: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // FORGOT PASSWORD
  // ═══════════════════════════════════════════════════════════════════
 // --- 1. Request Password Reset (Forgot Password) ---
  Future<Map<String, dynamic>> requestPasswordReset({required String usernameOrEmail}) async {
    final url = Uri.parse('$_baseUrl/App/auth/forgot_password');
    
    // Beat Flirt API requires plain text and Base64-encoded text (username_boat)
    final trimmedInput = usernameOrEmail.trim();
    final usernameBoat = base64Encode(utf8.encode(trimmedInput));
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': trimmedInput,
        'username_boat': usernameBoat,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final status = (data['status'] ?? '').toString();
      
      // Beat Flirt backend returns status "200" inside JSON on success
      if (status == '200') {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to request password reset');
      }
    } else {
      throw Exception('Server error: Status ${response.statusCode}');
    }
  }

  // --- 2. Reset Password (Called when user clicks the email verification link) ---
  Future<Map<String, dynamic>> resetPassword({
    required String usernameOrEmail,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/App/auth/reset_password');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': usernameOrEmail.trim(),
        'password': newPassword.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final status = (data['status'] ?? '').toString();
      
      if (status == '200') {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to reset password');
      }
    } else {
      throw Exception('Server error: Status ${response.statusCode}');
    }
  }
  // Future<Map<String, dynamic>> requestPasswordReset({
  //   required String email,
  // }) async {
  //   final uri = Uri.parse('$_baseUrl/App/auth/forgot-password/request');
  //   debugPrint('🔵 RESET REQUEST → $uri');

  //   final response = await http.post(
  //     uri,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email.trim()}),
  //   );

  //   final Map<String, dynamic> body =
  //       jsonDecode(response.body) as Map<String, dynamic>;
  //   if (response.statusCode == 200) return body;
  //   throw Exception(body['message'] ?? 'Failed to request reset token');
  // }

  // Future<Map<String, dynamic>> resetPassword({
  //   required String email,
  //   required String resetToken,
  //   required String newPassword,
  // }) async {
  //   final uri = Uri.parse('$_baseUrl/App/auth/forgot-password/reset');
  //   debugPrint('🔵 RESET PASSWORD → $uri');

  //   final response = await http.post(
  //     uri,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'email': email.trim(),
  //       'resetToken': resetToken.trim(),
  //       'newPassword': newPassword,
  //     }),
  //   );

  //   final Map<String, dynamic> body =
  //       jsonDecode(response.body) as Map<String, dynamic>;
  //   if (response.statusCode == 200) return body;
  //   throw Exception(body['message'] ?? 'Failed to update password');
  // }

  // ═══════════════════════════════════════════════════════════════════
  // CHAT & MESSAGING
  // ═══════════════════════════════════════════════════════════════════

  Future<List<Map<String, dynamic>>> getMessages({
    required String token,
    required String userId,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/messages/conversation/$userId');
    try {
      final response = await http.get(
        uri,
        headers: _buildHeaders(token: token),
      );

      final dynamic decoded = jsonDecode(response.body);

      // ✅ CHECK TOKEN EXPIRY
      _maybeHandleAuthExpiry(
        response,
        decoded is Map<String, dynamic> ? decoded : null,
      );

      if (response.statusCode == 200 && decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required String token,
    required String receiverId,
    required String content,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/messages/send');
    final response = await http.post(
      uri,
      headers: _buildHeaders(token: token),
      body: jsonEncode({'receiverId': receiverId, 'content': content}),
    );

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    // ✅ CHECK TOKEN EXPIRY
    _maybeHandleAuthExpiry(response, body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return body;
    }
    throw Exception(body['message'] ?? 'Failed to send message');
  }

  // ═══════════════════════════════════════════════════════════════════
  // CHATROOMS
  // ═══════════════════════════════════════════════════════════════════

  Future<List<Map<String, dynamic>>> getChatrooms({
    required String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/chatrooms');
    try {
      final response = await http.get(
        uri,
        headers: _buildHeaders(token: token),
      );

      final dynamic decoded = jsonDecode(response.body);

      // ✅ CHECK TOKEN EXPIRY
      _maybeHandleAuthExpiry(
        response,
        decoded is Map<String, dynamic> ? decoded : null,
      );

      if (response.statusCode == 200 && decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching chatrooms: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createChatroom({
    required String token,
    required String name,
    required String category,
    String description = '',
    bool isPrivate = false,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/chatrooms');
    final response = await http.post(
      uri,
      headers: _buildHeaders(token: token),
      body: jsonEncode({
        'name': name,
        'category': category,
        'description': description,
        'isPrivate': isPrivate,
      }),
    );

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    // ✅ CHECK TOKEN EXPIRY
    _maybeHandleAuthExpiry(response, body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return body;
    }
    throw Exception(body['message'] ?? 'Failed to create chatroom');
  }

  Future<void> updatePrivacy({
    required String token,
    required Map<String, dynamic> privacy,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/user/update_privacy');
    final response = await http.post(
      uri,
      headers: _buildHeaders(token: token),
      body: jsonEncode({'privacy': privacy}),
    );

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    // ✅ CHECK TOKEN EXPIRY
    _maybeHandleAuthExpiry(response, body);

    if (response.statusCode != 200) {
      throw ApiException(
        message: body['message'] ?? 'Failed to update privacy',
        statusCode: response.statusCode,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // CHECK LOGIN USER MEMBERSHIP
  // ═══════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> checkLoginUserMembership({
    required String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/user/check_login_user_membership');
    debugPrint('🔵 MEMBERSHIP CHECK REQUEST → $uri');

    final response = await http.post(uri, headers: _buildHeaders(token: token));

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    // ✅ CHECK TOKEN EXPIRY
    _maybeHandleAuthExpiry(response, body);

    debugPrint('🟢 MEMBERSHIP CHECK RESPONSE → $body');
    return body;
  }
  // ═══════════════════════════════════════════════════════════════════
  // ACCOUNT PAGE APIS
  // ═══════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getSingleUserProfile({
    required String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/user/signle_user_profile');
    debugPrint('🔵 PROFILE REQUEST → $uri');

    final response = await http.post(uri, headers: _buildHeaders(token: token));

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    _maybeHandleAuthExpiry(response, body);

    debugPrint('🟢 PROFILE RESPONSE → ${response.statusCode} | $body');
    return body;
  }

  Future<Map<String, dynamic>> getUserMembershipPlanRaw({
    required String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/membership/get_user_membership_plan');
    debugPrint('🔵 USER PLAN REQUEST → $uri');

    final response = await http.post(uri, headers: _buildHeaders(token: token));

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    _maybeHandleAuthExpiry(response, body);

    debugPrint('🟢 USER PLAN RESPONSE → ${response.statusCode} | $body');
    return body;
  }

  Future<Map<String, dynamic>> deleteAccount({required String token}) async {
    final uri = Uri.parse('$_baseUrl/App/user/delete_account');
    debugPrint('🔵 DELETE ACCOUNT → $uri');

    // Backend says GET, but to stay consistent with other auth-protected calls,
    // try POST first; many CI APIs accept both. If your server strictly needs GET,
    // change this back to http.get.
    final response = await http.post(uri, headers: _buildHeaders(token: token));

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    _maybeHandleAuthExpiry(response, body);

    debugPrint('🟢 DELETE ACCOUNT RESPONSE → ${response.statusCode} | $body');
    return body;
  }

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final uri = Uri.parse('$_baseUrl/App/user/change_password');
    final response = await http.post(
      uri,
      headers: _buildHeaders(token: token),
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    _maybeHandleAuthExpiry(response, body);

    return body;
  }

  // ═══════════════════════════════════════════════════════════════════
  // EVENTS & PARTIES — GET ALL EVENTS
  // ═══════════════════════════════════════════════════════════════════
  //
  // Backend: POST /App/events/get_all_events
  // Payload: { event_type, seach_date, keyword, lat, lng }   (note: "seach_date" — backend typo)
  //
  // Tries JSON body first. If the server replies with "Please Provide ..." style
  // errors (which usually means it parsed the body as empty), falls back to
  // application/x-www-form-urlencoded body with the same fields.
  Future<Map<String, dynamic>> getAllEvents({
    required String token,
    String eventType =
        'public', // 'public' for Events tab, 'private' for Parties tab
    String searchDate = '',
    String keyword = '',
    String lat = '0',
    String lng = '0',
  }) async {
    final uri = Uri.parse('$_baseUrl/App/events/get_all_events');

    final payload = <String, String>{
      'event_type': eventType,
      'seach_date': searchDate, // backend uses misspelling "seach_date"
      'keyword': keyword,
      'lat': lat,
      'lng': lng,
    };

    debugPrint('🔵 EVENTS REQUEST → $uri');
    debugPrint('🔵 EVENTS PAYLOAD → $payload');

    // 1) Try JSON
    http.Response response = await http.post(
      uri,
      headers: _buildHeaders(token: token),
      body: jsonEncode(payload),
    );

    Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    // 2) Fallback: form-encoded
    final msg = (body['message'] ?? '').toString().toLowerCase();
    final apiStatus = body['status']?.toString() ?? '';
    if (apiStatus != '200' &&
        (msg.contains('provide') || msg.contains('required'))) {
      debugPrint('🟡 EVENTS JSON body rejected, retrying as form-encoded');
      final formHeaders = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        if (token.isNotEmpty) 'access-token': token,
        if (ApiService._cookieJar.isNotEmpty)
          'Cookie': ApiService._cookieJar.entries
              .map((e) => '${e.key}=${e.value}')
              .join('; '),
      };
      response = await http.post(uri, headers: formHeaders, body: payload);
      body = jsonDecode(response.body) as Map<String, dynamic>;
    }

    _maybeHandleAuthExpiry(response, body);

    debugPrint(
      '🟢 EVENTS RESPONSE → ${response.statusCode} | status=${body['status']}',
    );
    return body;
  }

  Future<NewUserResponse?> fetchNewMembers() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/App/online/get_all_new_user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "type": "all",
          "search_keyword": "",
          "lat": "0",
          "lng": "0",
          "distance": 100,
          "page": 1,
          "profileTypeArray": [],
        }),
      );

      if (response.statusCode == 200) {
        return NewUserResponse.fromJson(jsonDecode(response.body));
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  /// PUBLIC method - use this everywhere for auth headers
  /// Replicates the _buildHeaders logic with Bearer + access-token + cookies
  static Map<String, String> buildAuthHeaders({String? token}) {
    return _buildHeaders(token: token);
  }

  static void setCookies(Map<String, String> cookies) {
    _cookieJar.clear();
    _cookieJar.addAll(cookies);
  }

  static void clearCookies() {
    _cookieJar.clear();
  }

  final TokenService _tokenService = TokenService();

  /// Build headers with authentication tokens
  Future<Map<String, String>> _getHeaders() async {
    final token = await _tokenService.getAccessToken();
    final sign = await _tokenService.getAccessSign();

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null && sign != null) {
      headers['Access-Token'] = token;
      headers['Access-Sign'] = sign;
    }

    return headers;
  }



  //   static final ApiService _instance = ApiService._internal();
  //   factory ApiService() => _instance;

  //   late Dio _dio;
  //   String? _accessToken;
  //   String? _accessSign;

  //   ApiService._internal() : _client = http.Client() {
  //     _dio = Dio(
  //       BaseOptions(
  //         baseUrl: 'https://app.beatflirtevent.com/App',
  //         connectTimeout: const Duration(seconds: 30),
  //         receiveTimeout: const Duration(seconds: 30),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     );

  //     _dio.interceptors.add(
  //       InterceptorsWrapper(
  //         onRequest: (options, handler) {
  //           if (_accessToken != null) {
  //             options.headers['Authorization'] = 'Bearer $_accessToken';
  //           }
  //           if (_accessSign != null) {
  //             options.headers['Access-Sign'] = _accessSign;
  //           }
  //           return handler.next(options);
  //         },
  //         onError: (error, handler) {
  //           return handler.next(error);
  //         },
  //       ),
  //     );
  //   }

  //   void setTokens({String? accessToken, String? accessSign}) {
  //     _accessToken = accessToken;
  //     _accessSign = accessSign;
  //   }

  //   void clearTokens() {
  //     _accessToken = null;
  //     _accessSign = null;
  //   }

  //   bool get isAuthenticated => _accessToken != null && _accessSign != null;

  //   // GET request
  //   Future<ApiResponse> get(String endpoint,
  //       {Map<String, dynamic>? queryParams}) async {
  //     try {
  //       final response = await _dio.get(
  //         endpoint,
  //         queryParameters: queryParams,
  //       );
  //       return ApiResponse.fromDioResponse(response);
  //     } on DioException catch (e) {
  //       return ApiResponse.fromDioError(e);
  //     }
  //   }

  //   // POST request
  //   Future<ApiResponse> post(String endpoint,
  //       {Map<String, dynamic>? data}) async {
  //     try {
  //       final response = await _dio.post(
  //         endpoint,
  //         data: data,
  //       );
  //       return ApiResponse.fromDioResponse(response);
  //     } on DioException catch (e) {
  //       return ApiResponse.fromDioError(e);
  //     }
  //   }

  //   // PUT request
  //   Future<ApiResponse> put(String endpoint,
  //       {Map<String, dynamic>? data}) async {
  //     try {
  //       final response = await _dio.put(
  //         endpoint,
  //         data: data,
  //       );
  //       return ApiResponse.fromDioResponse(response);
  //     } on DioException catch (e) {
  //       return ApiResponse.fromDioError(e);
  //     }
  //   }

  //   // DELETE request
  //   Future<ApiResponse> delete(String endpoint) async {
  //     try {
  //       final response = await _dio.delete(endpoint);
  //       return ApiResponse.fromDioResponse(response);
  //     } on DioException catch (e) {
  //       return ApiResponse.fromDioError(e);
  //     }
  //   }

  //   // Upload file
  //   Future<ApiResponse> uploadFile(
  //     String endpoint,
  //     String filePath, {
  //     String fieldName = 'file',
  //     Map<String, dynamic>? extraData,
  //   }) async {
  //     try {
  //       final formData = FormData.fromMap({
  //         fieldName: await MultipartFile.fromFile(filePath),
  //         if (extraData != null) ...extraData,
  //       });
  //       final response = await _dio.post(
  //         endpoint,
  //         data: formData,
  //         options: Options(
  //           headers: {'Content-Type': 'multipart/form-data'},
  //         ),
  //       );
  //       return ApiResponse.fromDioResponse(response);
  //     } on DioException catch (e) {
  //       return ApiResponse.fromDioError(e);
  //     }
  //   }

  //   // Upload multiple files
  //   Future<ApiResponse> uploadMultipleFiles(
  //     String endpoint,
  //     List<String> filePaths, {
  //     String fieldName = 'files[]',
  //     Map<String, dynamic>? extraData,
  //   }) async {
  //     try {
  //       final formData = FormData.fromMap({
  //         for (int i = 0; i < filePaths.length; i++)
  //           '$fieldName': await MultipartFile.fromFile(filePaths[i]),
  //         if (extraData != null) ...extraData,
  //       });
  //       final response = await _dio.post(
  //         endpoint,
  //         data: formData,
  //         options: Options(
  //           headers: {'Content-Type': 'multipart/form-data'},
  //         ),
  //       );
  //       return ApiResponse.fromDioResponse(response);
  //     } on DioException catch (e) {
  //       return ApiResponse.fromDioError(e);
  //     }
  //   }
  // }

  // /// Generic API Response wrapper
  // class ApiResponse {
  //   final int status;
  //   final dynamic data;
  //   final String? message;
  //   final bool isSuccess;

  //   ApiResponse({
  //     required this.status,
  //     this.data,
  //     this.message,
  //     required this.isSuccess,
  //   });

  //   factory ApiResponse.fromDioResponse(Response response) {
  //     final body = response.data;
  //     if (body is Map) {
  //       return ApiResponse(
  //         status: body['status'] ?? response.statusCode ?? 200,
  //         data: body['data'] ?? body,
  //         message: body['message'],
  //         isSuccess: (body['status'] == 200 || body['status'] == '200'),
  //       );
  //     }
  //     return ApiResponse(
  //       status: response.statusCode ?? 200,
  //       data: body,
  //       isSuccess: response.statusCode == 200,
  //     );
  //   }

  //   factory ApiResponse.fromDioError(DioException error) {
  //     return ApiResponse(
  //       status: error.response?.statusCode ?? 500,
  //       data: null,
  //       message: error.message ?? 'Something went wrong',
  //       isSuccess: false,
  //     );
  //   }

  // static const String _tokenKey = 'access_token';
  // static const String _signKey = 'access_sign'; // from app code
  //  // Headers with token
  // Future<Map<String, String>> _getHeaders({bool withToken = true}) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString(_tokenKey) ?? '';
  //   final sign = prefs.getString(_signKey) ?? '';

  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //   };
  //   if (withToken && token.isNotEmpty) {
  //     headers['Authorization'] = 'Bearer $token'; // guess, or may be different
  //     // from app, perhaps custom, or query param, but try header
  //     // alternatively send in body for some
  //   }
  //   return headers;
  // }

  //  // Get single user profile (used for couple too?) - GET /user/signle_user_profile
  // Future<Map<String, dynamic>> _getSingleUserProfile() async {
  //   final url = Uri.parse('$_baseUrl/App/user/signle_user_profile');
  //   final response = await http.get(
  //     url,
  //     headers: await _getHeaders(),
  //   );
  //   return jsonDecode(response.body);
  // }

  // // Get profile main image
  // Future<Map<String, dynamic>> getSingleUserProfileImage() async {
  //   final url = Uri.parse('$_baseUrl/App/user/signle_user_profile_image');
  //   final response = await http.get(url, headers: await _getHeaders());
  //   return jsonDecode(response.body);
  // }

  // // Approved images for profile
  // Future<Map<String, dynamic>> getApproveProfileImages() async {
  //   final url = Uri.parse('$_baseUrl/App/user/signle_user_profile_approve_image');
  //   final response = await http.get(url, headers: await _getHeaders());
  //   return jsonDecode(response.body);
  // }

  // // Pending images
  // Future<Map<String, dynamic>> getPendingProfileImages() async {
  //   final url = Uri.parse('$_baseUrl/App/user/signle_user_profile_pending_image');
  //   final response = await http.get(url, headers: await _getHeaders());
  //   return jsonDecode(response.body);
  // }

  // // Approved videos
  // Future<Map<String, dynamic>> getApproveProfileVideos() async {
  //   final url = Uri.parse('$_baseUrl/App/user/signle_user_profile_approve_video');
  //   final response = await http.get(url, headers: await _getHeaders());
  //   return jsonDecode(response.body);
  // }

  // // Pending videos
  // Future<Map<String, dynamic>> getPendingProfileVideos() async {
  //   final url = Uri.parse('$_baseUrl/App/user/signle_user_profile_pending_video');
  //   final response = await http.get(url, headers: await _getHeaders());
  //   return jsonDecode(response.body);
  // }

  // // Get all albums
  // Future<Map<String, dynamic>> getAllAlbums() async {
  //   final url = Uri.parse('$_baseUrl/App/user/get_all_album');
  //   final response = await http.get(url, headers: await _getHeaders());
  //   return jsonDecode(response.body);
  // }

  // // Get approved album images (perhaps per album or all)
  // Future<Map<String, dynamic>> getAllApproveAlbumImages() async {
  //   final url = Uri.parse('$_baseUrl/App/user/get_all_approve_album_image');
  //   final response = await http.get(url, headers: await _getHeaders());
  //   return jsonDecode(response.body);
  // }

  // // Get pending album images
  // Future<Map<String, dynamic>> getAllPendingAlbumImages() async {
  //   final url = Uri.parse('$_baseUrl/App/user/get_all_pending_album_image');
  //   final response = await http.get(url, headers: await _getHeaders());
  //   return jsonDecode(response.body);
  // }

  // // Example: Delete profile image - you may need to adjust endpoint based on actual
  // // From component: deleteProfileImage(id)
  // Future<Map<String, dynamic>> deleteProfileImage(String id) async {
  //   final url = Uri.parse('$_baseUrl/App/user/delete_profile_image'); // guessed
  //   final response = await http.post(
  //     url,
  //     headers: await _getHeaders(),
  //     body: jsonEncode({'id': id}),
  //   );
  //   return jsonDecode(response.body);
  // }

  // // Set as main profile pic
  // Future<Map<String, dynamic>> setProfilePicture(String id) async {
  //   final url = Uri.parse('$_baseUrl/App/user/set_profile_picture'); // guessed
  //   final response = await http.post(
  //     url,
  //     headers: await _getHeaders(),
  //     body: jsonEncode({'id': id}),
  //   );
  //   return jsonDecode(response.body);
  // }

  // // Delete video
  // Future<Map<String, dynamic>> deleteProfileVideo(String id) async {
  //   final url = Uri.parse('$_baseUrl/App/user/delete_profile_video'); // guessed
  //   final response = await http.post(
  //     url,
  //     headers: await _getHeaders(),
  //     body: jsonEncode({'id': id}),
  //   );
  //   return jsonDecode(response.body);
  // }

  // // Upload album image - this would be multipart for real file
  // // For demo, we use base64 or assume
  // Future<Map<String, dynamic>> uploadAlbumImage(String albumId, String imageBase64) async {
  //   final url = Uri.parse('$_baseUrl/App/user/upload_album_image'); // guessed
  //   final response = await http.post(
  //     url,
  //     headers: await _getHeaders(),
  //     body: jsonEncode({
  //       'album_id': albumId,
  //       'image': imageBase64,
  //     }),
  //   );
  //   return jsonDecode(response.body);
  // }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Code: $statusCode)';
}
