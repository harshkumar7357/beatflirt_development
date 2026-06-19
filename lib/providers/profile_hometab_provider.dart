// import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/core/services/token_services.dart';
// import '../model/profile_hometab_model.dart';
// // Adjust path if needed

// final viewSingleProfileProvider =
//     StateNotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
//         (ref) => ViewSingleProfileNotifier());

// class ViewSingleProfileNotifier extends StateNotifier<ViewSingleProfileState> {
//   ViewSingleProfileNotifier() : super(ViewSingleProfileState());

//   final TokenService _tokenService = TokenService();
//   final ApiService _apiService = ApiService();

//   Future<void> fetchProfile() async {
//     state = state.copyWith(isLoading: true, isError: false, errorMessage: '');

//     try {
//       // Get token from TokenService (same pattern used in the project)
//       final token = await _tokenService.getAccessToken();

//       if (token == null || token.isEmpty) {
//         state = state.copyWith(
//           isLoading: false,
//           isError: true,
//           errorMessage: 'Authentication token is missing. Please log in again.',
//         );
//         return;
//       }

//       print('========== FETCHING PROFILE (HOME TAB) ==========');
//       print('TOKEN length: ${token.length}');

//       // Use the existing method from ApiService (recommended)
//       final response = await _apiService.getSingleUserProfile(token: token);

//       print('FETCH STATUS: 200');
//       print('FETCH BODY: $response');

//       if (response['status'] == '200' && response['data'] != null) {
//         final data = ViewSingleProfileData.fromJson(response['data']);
//         state = state.copyWith(
//           isLoading: false,
//           data: data,
//         );
//         print('✅ Home tab profile loaded successfully');
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           isError: true,
//           errorMessage: 'Invalid response format',
//         );
//         print('❌ Invalid response format');
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         isError: true,
//         errorMessage: 'Error: $e',
//       );
//       print('❌ Error fetching profile: $e');
//     }
//   }
// }


// // import 'package:beatflirt/core/services/auth_services.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import '../model/profile_hometab_model.dart';

// // final viewSingleProfileProvider =
// //     StateNotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
// //         (ref) => ViewSingleProfileNotifier());

// // class ViewSingleProfileNotifier extends StateNotifier<ViewSingleProfileState> {
// //   ViewSingleProfileNotifier() : super(ViewSingleProfileState());

// //   // TODO: Replace with your actual token retrieval logic
// //   String get _token => AuthService.getToken().toString();

// //   Future<void> fetchProfile() async {
// //     state = state.copyWith(isLoading: true, isError: false, errorMessage: '');

// //     try {
// //       final url =
// //           Uri.parse('https://app.beatflirtevent.com/App/user/signle_user_profile');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $_token',
// //           'Content-Type': 'application/json',
// //         },
// //       );

// //       print('========== FETCHING PROFILE (HOME TAB / profile_hometab) ==========');
// //       print('URL: $url');
// //       print('TOKEN length: ${_token.length}');
// //       print('FETCH STATUS: ${response.statusCode}');
// //       print('FETCH BODY: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final Map<String, dynamic> jsonResponse = json.decode(response.body);

// //         if (jsonResponse['status'] == '200' && jsonResponse['data'] != null) {
// //           final data = ViewSingleProfileData.fromJson(jsonResponse['data']);
// //           state = state.copyWith(
// //             isLoading: false,
// //             data: data,
// //           );
// //           print('✅ Home tab profile loaded successfully');
// //         } else {
// //           state = state.copyWith(
// //             isLoading: false,
// //             isError: true,
// //             errorMessage: 'Invalid response format',
// //           );
// //           print('❌ Invalid response format');
// //         }
// //       } else {
// //         state = state.copyWith(
// //           isLoading: false,
// //           isError: true,
// //           errorMessage: 'Failed to load profile: ${response.statusCode}',
// //         );
// //         print('❌ Failed to load profile: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       state = state.copyWith(
// //         isLoading: false,
// //         isError: true,
// //         errorMessage: 'Error: $e',
// //       );
// //       print('❌ Error fetching profile: $e');
// //     }
// //   }
// // }



// // // // // // // // lib/providers/view_single_profile_provider.dart

// // // // // // // import 'package:flutter/cupertino.dart';
// // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // import 'package:http/http.dart' as http;
// // // // // // // import 'dart:convert';
// // // // // // // import '../core/services/auth_services.dart';
// // // // // // // import '../model/profile_hometab_model.dart';
// // // // // // // // import '../screens/view_single_profile/view_single_profile_model.dart';

// // // // // // // class ViewSingleProfileState {
// // // // // // //   final bool isLoading;
// // // // // // //   final bool isError;
// // // // // // //   final String errorMessage;
// // // // // // //   final ViewSingleProfileData? data;

// // // // // // //   const ViewSingleProfileState({
// // // // // // //     this.isLoading = false,
// // // // // // //     this.isError = false,
// // // // // // //     this.errorMessage = '',
// // // // // // //     this.data,
// // // // // // //   });

// // // // // // //   ViewSingleProfileState copyWith({
// // // // // // //     bool? isLoading,
// // // // // // //     bool? isError,
// // // // // // //     String? errorMessage,
// // // // // // //     ViewSingleProfileData? data,
// // // // // // //   }) {
// // // // // // //     return ViewSingleProfileState(
// // // // // // //       isLoading: isLoading ?? this.isLoading,
// // // // // // //       isError: isError ?? this.isError,
// // // // // // //       errorMessage: errorMessage ?? this.errorMessage,
// // // // // // //       data: data ?? this.data,
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // class ViewSingleProfileNotifier extends StateNotifier<ViewSingleProfileState> {
// // // // // // //   ViewSingleProfileNotifier() : super(const ViewSingleProfileState());

// // // // // // //   final String _baseUrl = 'https://app.beatflirtevent.com/App/user/signle_user_profile';

// // // // // // //   // Future<void> fetchProfile() async {
// // // // // // //   //   state = const ViewSingleProfileState(isLoading: true);
// // // // // // //   //
// // // // // // //   //   try {
// // // // // // //   //     final response = await http.get(Uri.parse(_baseUrl));
// // // // // // //   //
// // // // // // //   //     if (response.statusCode == 200) {
// // // // // // //   //       final Map<String, dynamic> jsonData = json.decode(response.body);
// // // // // // //   //       final profileResponse = ViewSingleProfileResponse.fromJson(jsonData);
// // // // // // //   //
// // // // // // //   //       if (profileResponse.data != null && profileResponse.status == '200') {
// // // // // // //   //         state = ViewSingleProfileState(data: profileResponse.data);
// // // // // // //   //       } else {
// // // // // // //   //         state = const ViewSingleProfileState(isError: true, errorMessage: 'Failed to load profile');
// // // // // // //   //       }
// // // // // // //   //     } else {
// // // // // // //   //       state = ViewSingleProfileState(
// // // // // // //   //           isError: true,
// // // // // // //   //           errorMessage: 'Server error: ${response.statusCode}'
// // // // // // //   //       );
// // // // // // //   //     }
// // // // // // //   //   } catch (e) {
// // // // // // //   //     state = ViewSingleProfileState(
// // // // // // //   //         isError: true,
// // // // // // //   //         errorMessage: e.toString()
// // // // // // //   //     );
// // // // // // //   //   }
// // // // // // //   // }
// // // // // // //   Future<void> fetchProfile() async {
// // // // // // //     state = const ViewSingleProfileState(isLoading: true);
// // // // // // //     // final String? token = 'YOUR_AUTH_TOKEN_HERE'; // Replace with your actual token variable
// // // // // // //       final String? token = await AuthService.getToken();
// // // // // // //     final response = await http.get(
// // // // // // //       Uri.parse(_baseUrl),
// // // // // // //       headers: {
// // // // // // //         'Content-Type': 'application/json',
// // // // // // //         if (token != null) 'Authorization': 'Bearer $token', // Or however your API expects it
// // // // // // //       },
// // // // // // //     );
// // // // // // //     try {
// // // // // // //       final response = await http.get(Uri.parse(_baseUrl));

// // // // // // //       // --- DEBUG PRINTS ---
// // // // // // //       print('🚀 API Status Code: ${response.statusCode}');
// // // // // // //       print('📦 API Response Body: ${response.body}');
// // // // // // //       // --------------------

// // // // // // //       if (response.statusCode == 200) {
// // // // // // //         final Map<String, dynamic> jsonData = json.decode(response.body);
// // // // // // //         final profileResponse = ViewSingleProfileResponse.fromJson(jsonData);

// // // // // // //         if (profileResponse.data != null && profileResponse.status == '200') {
// // // // // // //           state = ViewSingleProfileState(data: profileResponse.data);
// // // // // // //         } else {
// // // // // // //           state = const ViewSingleProfileState(isError: true, errorMessage: 'Failed to load profile data');
// // // // // // //         }
// // // // // // //       } else {
// // // // // // //         state = ViewSingleProfileState(
// // // // // // //             isError: true,
// // // // // // //             errorMessage: 'Server error: ${response.statusCode}'
// // // // // // //         );
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       print('❌ Exception caught: $e');
// // // // // // //       state = ViewSingleProfileState(
// // // // // // //           isError: true,
// // // // // // //           errorMessage: e.toString()
// // // // // // //       );
// // // // // // //     }
// // // // // // //   }

// // // // // // //   void clearProfile() {
// // // // // // //     state = const ViewSingleProfileState();
// // // // // // //   }
// // // // // // // }

// // // // // // // final viewSingleProfileProvider = StateNotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
// // // // // // //       (ref) => ViewSingleProfileNotifier(),
// // // // // // // );

// // // // // // import 'package:flutter/foundation.dart'; // for debugPrint
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import 'package:http/http.dart' as http;
// // // // // // import 'dart:convert';

// // // // // // import '../core/services/auth_services.dart';
// // // // // // import '../Api_services/api_service.dart';
// // // // // // import '../model/profile_hometab_model.dart';

// // // // // // class ViewSingleProfileState {
// // // // // //   final bool isLoading;
// // // // // //   final bool isError;
// // // // // //   final String errorMessage;
// // // // // //   final ViewSingleProfileData? data;

// // // // // //   const ViewSingleProfileState({
// // // // // //     this.isLoading = false,
// // // // // //     this.isError = false,
// // // // // //     this.errorMessage = '',
// // // // // //     this.data,
// // // // // //   });

// // // // // //   ViewSingleProfileState copyWith({
// // // // // //     bool? isLoading,
// // // // // //     bool? isError,
// // // // // //     String? errorMessage,
// // // // // //     ViewSingleProfileData? data,
// // // // // //   }) {
// // // // // //     return ViewSingleProfileState(
// // // // // //       isLoading: isLoading ?? this.isLoading,
// // // // // //       isError: isError ?? this.isError,
// // // // // //       errorMessage: errorMessage ?? this.errorMessage,
// // // // // //       data: data ?? this.data,
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class ViewSingleProfileNotifier extends StateNotifier<ViewSingleProfileState> {
// // // // // //   ViewSingleProfileNotifier() : super(const ViewSingleProfileState());

// // // // // //   // Exact URL spelling from prior working probes/edit tab
// // // // // //   final String baseUrl = 'https://app.beatflirtevent.com/App/user/signle_user_profile';

// // // // // //   Future<void> fetchProfile() async {
// // // // // //     state = const ViewSingleProfileState(isLoading: true);

// // // // // //     final String? token = await AuthService.getToken();

// // // // // //     if (token == null || token.isEmpty) {
// // // // // //       debugPrint('❌ No token from AuthService.getToken()');
// // // // // //       state = const ViewSingleProfileState(
// // // // // //         isError: true,
// // // // // //         errorMessage: 'User token not found. Please log in again.',
// // // // // //       );
// // // // // //       return;
// // // // // //     }

// // // // // //     // Use the EXACT same successful pattern as my_profile_edit_tab.dart savers + load
// // // // // //     // POST + full _buildHeaders replica (Bearer + access-token + cookies) + form-urlencoded + token variants in BODY
// // // // // //     final headers = ApiService.buildAuthHeaders(token: token);
// // // // // //     headers['Content-Type'] = 'application/x-www-form-urlencoded';
// // // // // //     headers['Accept'] = 'application/json';

// // // // // //     final body = {
// // // // // //       'token': token,
// // // // // //       'Authtoken': token,
// // // // // //     };

// // // // // //     debugPrint('========== FETCHING VIEW SINGLE PROFILE ==========');
// // // // // //     debugPrint('URL: $baseUrl');
// // // // // //     debugPrint('TOKEN length: ${token.length}');

// // // // // //     try {
// // // // // //       final response = await http.post(
// // // // // //         Uri.parse(baseUrl),
// // // // // //         headers: headers,
// // // // // //         body: body,
// // // // // //       );

// // // // // //       // --- DEBUG PRINTS (keep for troubleshooting) ---
// // // // // //       debugPrint('🚀 API Status Code: ${response.statusCode}');
// // // // // //       debugPrint('📦 API Response Body: ${response.body}');
// // // // // //       // --------------------

// // // // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // // // //         final Map<String, dynamic> jsonData = json.decode(response.body);
// // // // // //         final profileResponse = ViewSingleProfileResponse.fromJson(jsonData);

// // // // // //         if (profileResponse.data != null &&
// // // // // //             (profileResponse.status == '200' || profileResponse.status == 'success')) {
// // // // // //           state = ViewSingleProfileState(data: profileResponse.data);
// // // // // //           debugPrint('✅ Profile loaded successfully into state');
// // // // // //         } else {
// // // // // //           state = const ViewSingleProfileState(
// // // // // //             isError: true,
// // // // // //             errorMessage: 'Failed to load profile data (invalid response)',
// // // // // //           );
// // // // // //         }
// // // // // //       } else {
// // // // // //         state = ViewSingleProfileState(
// // // // // //           isError: true,
// // // // // //           errorMessage: 'Server error: ${response.statusCode}',
// // // // // //         );
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint('❌ Exception caught: $e');
// // // // // //       state = ViewSingleProfileState(
// // // // // //         isError: true,
// // // // // //         errorMessage: e.toString(),
// // // // // //       );
// // // // // //     }
// // // // // //   }

// // // // // //   void clearProfile() {
// // // // // //     state = const ViewSingleProfileState();
// // // // // //   }
// // // // // // }

// // // // // // final viewSingleProfileProvider =
// // // // // //     StateNotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
// // // // // //   (ref) => ViewSingleProfileNotifier(),
// // // // // // );

// // // // // import 'package:flutter/foundation.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'dart:convert';

// // // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // // import 'package:beatflirt/Api_services/api_service.dart';
// // // // // import '../model/profile_hometab_model.dart'; // adjust path as needed

// // // // // // State for the profile view (home tab)
// // // // // class ViewSingleProfileState {
// // // // //   final bool isLoading;
// // // // //   final bool isError;
// // // // //   final String errorMessage;
// // // // //   final ViewSingleProfileData? data;

// // // // //   const ViewSingleProfileState({
// // // // //     this.isLoading = false,
// // // // //     this.isError = false,
// // // // //     this.errorMessage = '',
// // // // //     this.data,
// // // // //   });

// // // // //   ViewSingleProfileState copyWith({
// // // // //     bool? isLoading,
// // // // //     bool? isError,
// // // // //     String? errorMessage,
// // // // //     ViewSingleProfileData? data,
// // // // //   }) {
// // // // //     return ViewSingleProfileState(
// // // // //       isLoading: isLoading ?? this.isLoading,
// // // // //       isError: isError ?? this.isError,
// // // // //       errorMessage: errorMessage ?? this.errorMessage,
// // // // //       data: data ?? this.data,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class ViewSingleProfileNotifier extends Notifier<ViewSingleProfileState> {
// // // // //   @override
// // // // //   ViewSingleProfileState build() {
// // // // //     return const ViewSingleProfileState();
// // // // //   }

// // // // //   Future<void> fetchProfile() async {
// // // // //     final String? token = await AuthService.getToken();

// // // // //     if (token == null || token.isEmpty) {
// // // // //       state = state.copyWith(
// // // // //         isLoading: false,
// // // // //         isError: true,
// // // // //         errorMessage: 'Authentication token not found. Please log in again.',
// // // // //       );
// // // // //       return;
// // // // //     }

// // // // //     state = state.copyWith(isLoading: true, isError: false, errorMessage: '');

// // // // //     // Exact URL spelling from API
// // // // //     const url = 'https://app.beatflirtevent.com/App/user/signle_user_profile';

// // // // //     try {
// // // // //       // FIXED: Use the public buildAuthHeaders (this resolves the compile error)
// // // // //       final headers = ApiService.buildAuthHeaders(token: token);
// // // // //       headers['Content-Type'] = 'application/x-www-form-urlencoded';
// // // // //       headers['Accept'] = 'application/json';

// // // // //       final body = {
// // // // //         'token': token,
// // // // //         'Authtoken': token,
// // // // //       };

// // // // //       debugPrint('========== FETCHING PROFILE (HOME TAB / profile_hometab) ==========');
// // // // //       debugPrint('URL: $url');
// // // // //       debugPrint('TOKEN length: ${token.length}');

// // // // //       final response = await http.post(
// // // // //         Uri.parse(url),
// // // // //         headers: headers,
// // // // //         body: body,
// // // // //       );

// // // // //       debugPrint('FETCH STATUS: ${response.statusCode}');
// // // // //       debugPrint('FETCH BODY: ${response.body}');

// // // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         if (decoded is Map<String, dynamic>) {
// // // // //           final status = decoded['status']?.toString();
// // // // //           if (status == '200' || status == 'success') {
// // // // //             final profileData = ViewSingleProfileData.fromJson(decoded);
// // // // //             state = state.copyWith(
// // // // //               isLoading: false,
// // // // //               data: profileData,
// // // // //             );
// // // // //             debugPrint('✅ Home tab profile loaded successfully');
// // // // //             return;
// // // // //           }
// // // // //         }
// // // // //         // fallback parse
// // // // //         try {
// // // // //           final profileData = ViewSingleProfileData.fromJson(decoded);
// // // // //           state = state.copyWith(isLoading: false, data: profileData);
// // // // //           return;
// // // // //         } catch (_) {}
// // // // //       }

// // // // //       // If we reach here, the response was not successfully parsed
// // // // //       String msg = 'Failed to load profile';
// // // // //       try {
// // // // //         final errorBody = jsonDecode(response.body);
// // // // //         if (errorBody is Map) {
// // // // //           msg = errorBody['message']?.toString() ?? msg;
// // // // //         }
// // // // //       } catch (_) {}
// // // // //       state = state.copyWith(
// // // // //         isLoading: false,
// // // // //         isError: true,
// // // // //         errorMessage: msg,
// // // // //       );
// // // // //     } catch (e) {
// // // // //       debugPrint('FETCH PROFILE ERROR: $e');
// // // // //       state = state.copyWith(
// // // // //         isLoading: false,
// // // // //         isError: true,
// // // // //         errorMessage: 'Network error: $e',
// // // // //       );
// // // // //     }
// // // // //   }
// // // // // }

// // // // // final viewSingleProfileProvider =
// // // // //     NotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
// // // // //         ViewSingleProfileNotifier.new);

// // // // import 'package:flutter/foundation.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';

// // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // import 'package:beatflirt/Api_services/api_service.dart';
// // // // import '../model/profile_hometab_model.dart'; // adjust path as needed

// // // // // State for the profile view (home tab)
// // // // class ViewSingleProfileState {
// // // //   final bool isLoading;
// // // //   final bool isError;
// // // //   final String errorMessage;
// // // //   final ViewSingleProfileData? data;

// // // //   const ViewSingleProfileState({
// // // //     this.isLoading = false,
// // // //     this.isError = false,
// // // //     this.errorMessage = '',
// // // //     this.data,
// // // //   });

// // // //   ViewSingleProfileState copyWith({
// // // //     bool? isLoading,
// // // //     bool? isError,
// // // //     String? errorMessage,
// // // //     ViewSingleProfileData? data,
// // // //   }) {
// // // //     return ViewSingleProfileState(
// // // //       isLoading: isLoading ?? this.isLoading,
// // // //       isError: isError ?? this.isError,
// // // //       errorMessage: errorMessage ?? this.errorMessage,
// // // //       data: data ?? this.data,
// // // //     );
// // // //   }
// // // // }

// // // // class ViewSingleProfileNotifier extends Notifier<ViewSingleProfileState> {
// // // //   @override
// // // //   ViewSingleProfileState build() {
// // // //     return const ViewSingleProfileState();
// // // //   }

// // // //   Future<void> fetchProfile() async {
// // // //     final String? token = await AuthService.getToken();

// // // //     if (token == null || token.isEmpty) {
// // // //       state = state.copyWith(
// // // //         isLoading: false,
// // // //         isError: true,
// // // //         errorMessage: 'Authentication token not found. Please log in again.',
// // // //       );
// // // //       return;
// // // //     }

// // // //     state = state.copyWith(isLoading: true, isError: false, errorMessage: '');

// // // //     // Exact URL spelling from API
// // // //     const url = 'https://app.beatflirtevent.com/App/user/signle_user_profile';

// // // //     try {
// // // //       // FIXED: Use the public buildAuthHeaders (this resolves the compile error)
// // // //       final headers = ApiService.buildAuthHeaders(token: token);
// // // //       headers['Content-Type'] = 'application/x-www-form-urlencoded';
// // // //       headers['Accept'] = 'application/json';

// // // //       final body = {'token': token, 'Authtoken': token};

// // // //       debugPrint(
// // // //         '========== FETCHING PROFILE (HOME TAB / profile_hometab) ==========',
// // // //       );
// // // //       debugPrint('URL: $url');
// // // //       debugPrint('TOKEN length: ${token.length}');

// // // //       final response = await http.post(
// // // //         Uri.parse(url),
// // // //         headers: headers,
// // // //         body: body,
// // // //       );

// // // //       debugPrint('FETCH STATUS: ${response.statusCode}');
// // // //       debugPrint('FETCH BODY: ${response.body}');

// // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         if (decoded is Map<String, dynamic>) {
// // // //           final status = decoded['status']?.toString();
// // // //           if (status == '200' || status == 'success') {
// // // //             // The API returns {"status": "200", "data": { profile fields }}
// // // //             // So extract the inner data object for the model
// // // //             final profileJson = decoded['data'] is Map
// // // //                 ? Map<String, dynamic>.from(decoded['data'])
// // // //                 : decoded;
// // // //             final profileData = ViewSingleProfileData.fromJson(profileJson);
// // // //             state = state.copyWith(isLoading: false, data: profileData);
// // // //             debugPrint('✅ Home tab profile loaded successfully');
// // // //             return;
// // // //           }
// // // //         }
// // // //         // fallback parse
// // // //         try {
// // // //           final profileJson = decoded['data'] is Map
// // // //               ? Map<String, dynamic>.from(decoded['data'])
// // // //               : decoded;
// // // //           final profileData = ViewSingleProfileData.fromJson(profileJson);
// // // //           state = state.copyWith(isLoading: false, data: profileData);
// // // //           return;
// // // //         } catch (_) {}
// // // //       }

// // // //       String msg = decoded is Map
// // // //           ? (decoded['message']?.toString() ?? 'Unknown error')
// // // //           : 'Failed to load profile';
// // // //       // If we got 200 but couldn't parse the data shape, it's likely a response format issue
// // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // //         msg =
// // // //             'Invalid response format from server. Expected {"status":"200", "data": {...}}';
// // // //       }
// // // //       state = state.copyWith(
// // // //         isLoading: false,
// // // //         isError: true,
// // // //         errorMessage: msg,
// // // //       );
// // // //     } catch (e) {
// // // //       debugPrint('FETCH PROFILE ERROR: $e');
// // // //       state = state.copyWith(
// // // //         isLoading: false,
// // // //         isError: true,
// // // //         errorMessage: 'Network error: $e',
// // // //       );
// // // //     }
// // // //   }
// // // // }

// // // // final viewSingleProfileProvider =
// // // //     NotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
// // // //       ViewSingleProfileNotifier.new,
// // // //     );

// // // import 'package:flutter/foundation.dart';

// // // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // // import 'package:http/http.dart' as http;

// // // import 'dart:convert';

// // // import 'package:beatflirt/core/services/auth_services.dart';

// // // import 'package:beatflirt/Api_services/api_service.dart';

// // // import '../model/profile_hometab_model.dart'; // adjust path as needed

// // // // State for the profile view (home tab)

// // // class ViewSingleProfileState {
// // //   final bool isLoading;

// // //   final bool isError;

// // //   final String errorMessage;

// // //   final ViewSingleProfileData? data;

// // //   const ViewSingleProfileState({
// // //     this.isLoading = false,

// // //     this.isError = false,

// // //     this.errorMessage = '',

// // //     this.data,
// // //   });

// // //   ViewSingleProfileState copyWith({
// // //     bool? isLoading,

// // //     bool? isError,

// // //     String? errorMessage,

// // //     ViewSingleProfileData? data,
// // //   }) {
// // //     return ViewSingleProfileState(
// // //       isLoading: isLoading ?? this.isLoading,
// // //       isError: isError ?? this.isError,
// // //       errorMessage: errorMessage ?? this.errorMessage,
// // //       data: data ?? this.data,
// // //     );
// // //   }
// // // }

// // // class ViewSingleProfileNotifier extends Notifier<ViewSingleProfileState> {
// // //   @override
// // //   ViewSingleProfileState build() {
// // //     return const ViewSingleProfileState();
// // //   }

// // //   Future<void> fetchProfile() async {
// // //     final String? token = await AuthService.getToken();

// // //     if (token == null || token.isEmpty) {
// // //       state = state.copyWith(
// // //         isLoading: false,

// // //         isError: true,

// // //         errorMessage: 'Authentication token not found. Please log in again.',
// // //       );
// // //       return;
// // //     }

// // //     state = state.copyWith(isLoading: true, isError: false, errorMessage: '');
// // //     // Exact URL spelling from API

// // //     const url = 'https://app.beatflirtevent.com/App/user/signle_user_profile';

// // //     try {
// // //       // FIXED: Use the public buildAuthHeaders (this resolves the compile error)

// // //       final headers = ApiService.buildAuthHeaders(token: token);

// // //       headers['Content-Type'] = 'application/x-www-form-urlencoded';

// // //       headers['Accept'] = 'application/json';
// // //       final body = {'token': token, 'Authtoken': token};
// // //       debugPrint(
// // //         '========== FETCHING PROFILE (HOME TAB / profile_hometab) ==========',
// // //       );

// // //       debugPrint('URL: $url');

// // //       debugPrint('TOKEN length: ${token.length}');

// // //       final response = await http.post(
// // //         Uri.parse(url),

// // //         headers: headers,

// // //         body: body,
// // //       );
// // //       debugPrint('FETCH STATUS: ${response.statusCode}');

// // //       debugPrint('FETCH BODY: ${response.body}');

// // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // //         final decoded = jsonDecode(response.body);

// // //         if (decoded is Map<String, dynamic>) {
// // //           final status = decoded['status']?.toString();

// // //           if (status == '200' || status == 'success') {
// // //             final profileData = ViewSingleProfileData.fromJson(decoded);

// // //             state = state.copyWith(isLoading: false, data: profileData);
// // //             debugPrint('✅ Home tab profile loaded successfully');

// // //             return;
// // //           }
// // //         }
// // //         // fallback parse

// // //         try {
// // //           final profileData = ViewSingleProfileData.fromJson(decoded);

// // //           state = state.copyWith(isLoading: false, data: profileData);
// // //           return;
// // //         } catch (_) {}
// // //       }
// // //       // If we reach here, the response was not successfully parsed

// // //       String msg = 'Failed to load profile';

// // //       try {
// // //         final errorBody = jsonDecode(response.body);

// // //         if (errorBody is Map) {
// // //           msg = errorBody['message']?.toString() ?? msg;
// // //         }
// // //       } catch (_) {}

// // //       state = state.copyWith(
// // //         isLoading: false,

// // //         isError: true,

// // //         errorMessage: msg,
// // //       );
// // //     } catch (e) {
// // //       debugPrint('FETCH PROFILE ERROR: $e');

// // //       state = state.copyWith(
// // //         isLoading: false,

// // //         isError: true,

// // //         errorMessage: 'Network error: $e',
// // //       );
// // //     }
// // //   }
// // // }

// // // final viewSingleProfileProvider =
// // //     NotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
// // //       ViewSingleProfileNotifier.new,
// // //     );
