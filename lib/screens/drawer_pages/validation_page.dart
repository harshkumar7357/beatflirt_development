// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:beatflirt/providers/validation_provider.dart';

// // class ValidationPage extends ConsumerStatefulWidget {
// //   const ValidationPage({super.key});

// //   @override
// //   ConsumerState<ValidationPage> createState() => _ValidationPageState();
// // }

// // class _ValidationPageState extends ConsumerState<ValidationPage> {
// //   final ImagePicker _picker = ImagePicker();
// //   XFile? _selfie;
// //   XFile? _idCard;

// //   Future<void> _pickImage(bool isSelfie) async {
// //     final XFile? image = await _picker.pickImage(
// //       source: ImageSource.gallery,
// //       imageQuality: 70,
// //     );
// //     if (image != null) {
// //       setState(() {
// //         if (isSelfie) {
// //           _selfie = image;
// //         } else {
// //           _idCard = image;
// //         }
// //       });
// //     }
// //   }

// //   void _submitValidation() async {
// //     if (_selfie == null || _idCard == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please select both photos')),
// //       );
// //       return;
// //     }

// //     final success = await ref.read(validationProvider.notifier).submit(
// //       selfiePath: _selfie!.path,
// //       idCardPath: _idCard!.path,
// //     );

// //     if (success && mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Validation submitted successfully!')),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final validationState = ref.watch(validationProvider);

// //     return Scaffold(
// //       backgroundColor: const Color(0xFF0F0F1A),
// //       body: CustomScrollView(
// //         physics: const BouncingScrollPhysics(),
// //         slivers: [
// //           _buildAppBar(context),
// //           if (validationState.isLoading)
// //             const SliverFillRemaining(
// //               child: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
// //             )
// //           else if (validationState.status == 'approved')
// //             _buildSuccessState()
// //           else if (validationState.status == 'pending')
// //             _buildPendingState()
// //           else
// //             _buildSubmissionForm(validationState),
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
// //         'PROFILE VALIDATION',
// //         style: TextStyle(
// //           color: Colors.white,
// //           fontWeight: FontWeight.w900,
// //           fontSize: 16,
// //           letterSpacing: 2.0,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSuccessState() {
// //     return SliverFillRemaining(
// //       hasScrollBody: false,
// //       child: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 color: Colors.green.withValues(alpha: 0.1),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(Icons.verified, color: Colors.green, size: 80),
// //             ),
// //             const SizedBox(height: 24),
// //             const Text(
// //               'Profile Verified',
// //               style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             const Text(
// //               'Your profile is fully validated.\nYou now have the blue checkmark!',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(color: Colors.white54, fontSize: 16),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPendingState() {
// //     return SliverFillRemaining(
// //       hasScrollBody: false,
// //       child: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 color: Colors.orange.withValues(alpha: 0.1),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(Icons.hourglass_top_rounded, color: Colors.orange, size: 80),
// //             ),
// //             const SizedBox(height: 24),
// //             const Text(
// //               'Review in Progress',
// //               style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             const Text(
// //               'Our team is manually checking your photos.\nThis usually takes 24-48 hours.',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(color: Colors.white54, fontSize: 16),
// //             ),
// //             const SizedBox(height: 40),
// //             TextButton(
// //               onPressed: () => ref.read(validationProvider.notifier).checkStatus(),
// //               child: const Text('Refresh Status', style: TextStyle(color: Colors.cyanAccent)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSubmissionForm(ValidationState state) {
// //     return SliverPadding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20),
// //       sliver: SliverList(
// //         delegate: SliverChildListDelegate([
// //           const SizedBox(height: 20),
// //           _buildHeaderInfo(state),
// //           const SizedBox(height: 30),
// //           _buildPhotoPicker('Your Selfie', _selfie, () => _pickImage(true)),
// //           const SizedBox(height: 20),
// //           _buildPhotoPicker('ID Card (Passport/License)', _idCard, () => _pickImage(false)),
// //           const SizedBox(height: 40),
// //           ElevatedButton(
// //             onPressed: _submitValidation,
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.cyanAccent,
// //               foregroundColor: Colors.black,
// //               minimumSize: const Size(double.infinity, 55),
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //             ),
// //             child: const Text('SUBMIT FOR REVIEW', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
// //           ),
// //           if (state.error != null)
// //             Padding(
// //               padding: const EdgeInsets.only(top: 20),
// //               child: Text(
// //                 state.error!,
// //                 style: const TextStyle(color: Colors.redAccent, fontSize: 12),
// //                 textAlign: TextAlign.center,
// //               ),
// //             ),
// //         ]),
// //       ),
// //     );
// //   }

// //   Widget _buildHeaderInfo(ValidationState state) {
// //     return Container(
// //       padding: const EdgeInsets.all(25),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(30),
// //         gradient: LinearGradient(
// //           colors: state.status == 'rejected' 
// //               ? [Colors.redAccent.withValues(alpha: 0.8), Colors.red[900]!]
// //               : [const Color(0xFF00B0FF), const Color(0xFF00E5FF)],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //       ),
// //       child: Column(
// //         children: [
// //           Icon(
// //             state.status == 'rejected' ? Icons.error_outline : Icons.verified_user, 
// //             color: Colors.white, 
// //             size: 40
// //           ),
// //           const SizedBox(height: 15),
// //           Text(
// //             state.status == 'rejected' ? 'Validation Rejected' : 'Get Verified',
// //             style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 5),
// //           Text(
// //             state.status == 'rejected' 
// //                 ? 'Reason: ${state.rejectionReason ?? "Photos were not clear"}'
// //                 : 'Increase your trust score and visibility',
// //             style: const TextStyle(color: Colors.white70, fontSize: 14),
// //             textAlign: TextAlign.center,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildPhotoPicker(String label, XFile? file, VoidCallback onTap) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
// //         const SizedBox(height: 10),
// //         GestureDetector(
// //           onTap: onTap,
// //           child: Container(
// //             height: 150,
// //             width: double.infinity,
// //             decoration: BoxDecoration(
// //               color: Colors.white.withValues(alpha: 0.05),
// //               borderRadius: BorderRadius.circular(20),
// //               border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// //             ),
// //             child: file == null
// //                 ? Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: const [
// //                       Icon(Icons.add_a_photo, color: Colors.white24, size: 40),
// //                       SizedBox(height: 10),
// //                       Text('Tap to select photo', style: TextStyle(color: Colors.white24)),
// //                     ],
// //                   )
// //                 : ClipRRect(
// //                     borderRadius: BorderRadius.circular(20),
// //                     child: Image.file(File(file.path), fit: BoxFit.cover),
// //                   ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }



// // Beat Flirt /online screen converted from https://beatflirtevent.com/online
// //
// // Required pubspec dependencies:
// //   http: ^1.2.2
// //   shared_preferences: ^2.3.2
// //   flutter_svg: ^2.0.10+1
// //   geocoding: ^3.0.0
// //   video_player: ^2.9.2
// //
// // AndroidManifest.xml needs INTERNET permission:
// //   <uses-permission android:name="android.permission.INTERNET" />

// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';
// import 'upgrade_page.dart';



// const String _webBase = 'https://beatflirtevent.com/';
// const String _apiBase = 'https://app.beatflirtevent.com/App';
// const String _apiAssetBase = 'https://app.beatflirtevent.com/assets/';

// String _webAsset(String path) => '$_webBase$path';

// String _resolveMediaUrl(String raw) {
//   final value = raw.trim();
//   if (value.isEmpty) return '';
//   if (value.startsWith('http://') || value.startsWith('https://')) return value;
//   if (value.startsWith('//')) return 'https:$value';
//   if (value.startsWith('assets/')) return '$_webBase$value';
//   if (value.startsWith('/assets/')) return '${_webBase}${value.substring(1)}';
//   if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
//   return '$_apiAssetBase$value';
// }

// String _btoa(String value) => base64Encode(utf8.encode(value));

// bool _okStatus(dynamic status) => status?.toString() == '200';

// String _string(dynamic value, [String fallback = '']) {
//   if (value == null) return fallback;
//   final s = value.toString();
//   return s.isEmpty ? fallback : s;
// }

// int _int(dynamic value, [int fallback = 0]) {
//   if (value == null) return fallback;
//   if (value is int) return value;
//   return int.tryParse(value.toString()) ?? fallback;
// }

// class BeatOnlineApiException implements Exception {
//   BeatOnlineApiException(this.message);
//   final String message;

//   @override
//   String toString() => message;
// }

// class BeatOnlineApi {
//   BeatOnlineApi({
//     required this.accessToken,
//     required this.accessSign,
//     http.Client? client,
//     this.baseUrl = _apiBase,
//   }) : _client = client ?? http.Client();

//   final String accessToken;
//   final String accessSign;
//   final String baseUrl;
//   final http.Client _client;

//   Map<String, String> get _headers {
//     final h = <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     };
//     if (accessToken.isNotEmpty && accessSign.isNotEmpty) {
//       h['Access-Token'] = accessToken;
//       h['Access-Sign'] = accessSign;
//     }
//     return h;
//   }

//   Future<Map<String, dynamic>> _get(String path) async {
//     final response = await _client.get(Uri.parse('$baseUrl$path'), headers: _headers);
//     return _decode(response);
//   }

//   Future<Map<String, dynamic>> _post(String path, [Map<String, dynamic>? body]) async {
//     final response = await _client.post(
//       Uri.parse('$baseUrl$path'),
//       headers: _headers,
//       body: jsonEncode(body ?? <String, dynamic>{}),
//     );
//     return _decode(response);
//   }

//   Map<String, dynamic> _decode(http.Response response) {
//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       throw BeatOnlineApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
//     }
//     final decoded = jsonDecode(response.body);
//     if (decoded is Map<String, dynamic>) return decoded;
//     throw BeatOnlineApiException('Unexpected API response');
//   }

//   /// Website API: POST /online/get_all_online_user
//   Future<List<OnlineUser>> getOnlineUsers(OnlineFilter filter) async {
//     final json = await _post('/online/get_all_online_user', filter.toJson());
//     if (_okStatus(json['status'])) {
//       final data = json['data'];
//       if (data is List) return data.map((e) => OnlineUser.fromJson(Map<String, dynamic>.from(e))).toList();
//       return <OnlineUser>[];
//     }

//     final message = _string(json['message']);
//     if (message.toLowerCase().contains('token')) {
//       throw BeatOnlineApiException(message);
//     }
//     return <OnlineUser>[];
//   }

//   /// Website API: POST /user/create_chat_room
//   Future<void> createChatRoom({
//     required String fromUser,
//     required String toUser,
//     required String lastLogin,
//   }) async {
//     final json = await _post('/user/create_chat_room', {
//       'from_user': fromUser,
//       'to_user': toUser,
//       'last_login': lastLogin,
//     });
//     if (!_okStatus(json['status']) && _string(json['message']).toLowerCase().contains('token')) {
//       throw BeatOnlineApiException(_string(json['message'], 'Unable to create chat room'));
//     }
//   }

//   /// Common layout API used by the web header before opening this page.
//   /// It returns membership_expire; the Angular code stores it as `membership`.
//   Future<String?> checkLoginUserMembership() async {
//     final json = await _post('/user/check_login_user_membership');
//     return json['membership_expire']?.toString();
//   }

//   /// Optional common layout count API, included because the web shell calls it.
//   Future<Map<String, dynamic>> notificationAllCount() => _get('/notification/all_count');
// }

// class OnlineFilter {
//   const OnlineFilter({
//     this.searchKeyword = '',
//     this.locationText = '',
//     this.lat = '0',
//     this.lng = '0',
//     this.city = '0',
//     this.distance = '100',
//     this.page = 1,
//     this.profileTypeArray = const <String>[],
//   });

//   final String searchKeyword;
//   final String locationText;
//   final String lat;
//   final String lng;
//   final String city;
//   final String distance;
//   final int page;
//   final List<String> profileTypeArray; // Couple, Female, Male, Transgender

//   OnlineFilter copyWith({
//     String? searchKeyword,
//     String? locationText,
//     String? lat,
//     String? lng,
//     String? city,
//     String? distance,
//     int? page,
//     List<String>? profileTypeArray,
//   }) {
//     return OnlineFilter(
//       searchKeyword: searchKeyword ?? this.searchKeyword,
//       locationText: locationText ?? this.locationText,
//       lat: lat ?? this.lat,
//       lng: lng ?? this.lng,
//       city: city ?? this.city,
//       distance: distance ?? this.distance,
//       page: page ?? this.page,
//       profileTypeArray: profileTypeArray ?? this.profileTypeArray,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'search_keyword': searchKeyword,
//         'keyword': searchKeyword,
//         'lat': lat,
//         'lng': lng,
//         'city': city,
//         'page': page,
//         'distance': distance,
//         'profileTypeArray': profileTypeArray,
//       };
// }

// class OnlineUserImage {
//   OnlineUserImage({
//     required this.profileImage,
//     required this.dummyProfileImage,
//     required this.showProfileImage,
//   });

//   final String profileImage;
//   final String dummyProfileImage;
//   final bool showProfileImage;

//   factory OnlineUserImage.fromJson(Map<String, dynamic> json) => OnlineUserImage(
//       profileImage: _string(json['profile_image']),
//         dummyProfileImage: _string(json['dummy_profile_image']),
//         showProfileImage: json['show_profile_image']?.toString() != '0',
//     );
//   }

// class OnlineUserVideo {
//   OnlineUserVideo({required this.video});
//   final String video;

//   factory OnlineUserVideo.fromJson(Map<String, dynamic> json) => OnlineUserVideo(
//       video: _string(json['video']),
//     );
//   }

// class OnlineUser {
//   OnlineUser({
//     required this.raw,
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.profileType,
//     required this.genderProfileType,
//     required this.age,
//     required this.age2,
//     required this.formattedAddress,
//     required this.totalDistance,
//     required this.distance,
//     required this.lastLogin,
//     required this.likesCount,
//     required this.friendsCount,
//     required this.validationCount,
//     required this.aiMatchScore,
//     required this.aiInsight,
//     required this.images,
//     required this.videos,
//   });

//   final Map<String, dynamic> raw;
//   final String id;
//   final String username;
//   final String email;
//   final String profileType;
//   final String genderProfileType;
//   final String age;
//   final String age2;
//   final String formattedAddress;
//   final String totalDistance;
//   final String distance;
//   final String lastLogin;
//   final int likesCount;
//   final int friendsCount;
//   final int validationCount;
//   final String aiMatchScore;
//   final String aiInsight;
//   final List<OnlineUserImage> images;
//   final List<OnlineUserVideo> videos;

//   factory OnlineUser.fromJson(Map<String, dynamic> json) {
//     final imageList = json['image'] is List ? json['image'] as List : const [];
//     final videoList = json['video'] is List ? json['video'] as List : const [];
//     return OnlineUser(
//       raw: json,
//       id: _string(json['id']),
//       username: _string(json['username']),
//       email: _string(json['email']),
//       profileType: _string(json['profile_type']),
//       genderProfileType: _string(json['gender_profile_type']),
//       age: _string(json['age'], '21'),
//       age2: _string(json['age2']),
//       formattedAddress: _string(json['formatted_address']),
//       totalDistance: _string(json['total_distance']),
//       distance: _string(json['distance']),
//       lastLogin: _string(json['last_login']),
//       likesCount: _int(json['likes_count']),
//       friendsCount: _int(json['friends_count']),
//       validationCount: _int(json['validation_count']),
//       aiMatchScore: _string(json['ai_match_score']),
//       aiInsight: _string(json['ai_insight']),
//       images: imageList
//           .whereType<Map>()
//           .map((e) => OnlineUserImage.fromJson(Map<String, dynamic>.from(e)))
//           .toList(),
//       videos: videoList
//           .whereType<Map>()
//           .map((e) => OnlineUserVideo.fromJson(Map<String, dynamic>.from(e)))
//           .toList(),
//     );
//   }

//   bool get hasVisibleProfileImage => images.isNotEmpty && images.first.showProfileImage;
//   String get primaryImage {
//     if (images.isEmpty) return '';
//     return images.first.showProfileImage ? images.first.profileImage : images.first.dummyProfileImage;
//   }

//   bool get showOnlineStatus => raw['show_online_status']?.toString() == '1';
//   bool get showAge => raw['show_age']?.toString() != '0';
//   bool get showGender => raw['show_gender']?.toString() != '0';
//   bool get showLocation => raw['show_location']?.toString() != '0';
//   bool get showChatIcon => raw['show_chat_icon']?.toString() != '0';
//   bool get isOnline => lastLogin != '0';

//   bool flag(String key) => raw[key]?.toString() == '1';
// }

// class ValidationPage extends StatefulWidget {
//   const ValidationPage({
//     super.key,
//     this.api,
//     this.accessToken,
//     this.accessSign,
//     this.loginUserId,
//     this.membershipValue,
//     this.autoCheckMembership = true,
//     this.enforceMembershipLock = true,
//     this.onOpenProfile,
//     this.onOpenMessenger,
//     this.onOpenMembership,
//   });

//   /// Pass your own API instance or pass accessToken/accessSign.
//   /// If neither is passed, the widget reads SharedPreferences keys:
//   /// Access-Token, Access-Sign, user-id, membership.
//   final BeatOnlineApi? api;
//   final String? accessToken;
//   final String? accessSign;
//   final String? loginUserId;
//   final String? membershipValue;

//   /// The Angular app checks /user/check_login_user_membership in the shell header.
//   /// Keep true when using this as a standalone Flutter screen.
//   final bool autoCheckMembership;

//   /// The website stores membership_expire as `membership`. The Angular online
//   /// page shows all cards when this value is "No"; otherwise it locks cards
//   /// after the first four.
//   final bool enforceMembershipLock;

//   final void Function(BuildContext context, OnlineUser user)? onOpenProfile;
//   final void Function(BuildContext context, OnlineUser user)? onOpenMessenger;
//   final VoidCallback? onOpenMembership;
//   @override
//   State<ValidationPage> createState() => _ValidationPageState();
// }

// class _ValidationPageState extends State<ValidationPage> {
//   BeatOnlineApi? _api;
//   OnlineFilter _filter = const OnlineFilter();
//   List<OnlineUser> _friends = <OnlineUser>[];
//   bool _booting = true;
//   bool _loading = false;
//   bool _noMoreData = false;
//   String? _error;
//   String _loginUserId = '';
//   String _membershipValue = '';

//   static const Color _lightBg = Color(0xFFFFF4FA);
//   static const Color _primary = Color(0xFF1D042A);
//   static const Color _maroon = Color(0xFF560827);
//   static const Color _pink = Color(0xFFE91E63);
//   static const Color _navy = Color(0xFF06032C);


//   bool _isLockedIndex(int index) {
//     if (!widget.enforceMembershipLock) return false;
//     // The Angular online page shows full cards when stored membership == "No".
//     // Otherwise only the first 4 are visible and the rest are premium locked.
//     return _membershipValue != 'No' && index > 3;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _bootstrap();
//   }

//   Future<void> _bootstrap() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = widget.accessToken ?? prefs.getString('Access-Token') ?? '';
//       final sign = widget.accessSign ?? prefs.getString('Access-Sign') ?? '';
//       _loginUserId = widget.loginUserId ?? prefs.getString('user-id') ?? '';
//       _membershipValue = widget.membershipValue ?? prefs.getString('membership') ?? '';
//       _api = widget.api ?? BeatOnlineApi(accessToken: token, accessSign: sign);

//       if (widget.autoCheckMembership && token.isNotEmpty && sign.isNotEmpty) {
//         final membershipExpire = await _api!.checkLoginUserMembership();
//         if (membershipExpire != null) {
//           _membershipValue = membershipExpire;
//           await prefs.setString('membership', membershipExpire);
//         }
//       }

//       if (!mounted) return;
//       setState(() => _booting = false);
//       await _loadFriends();
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _booting = false;
//         _error = e.toString();
//       });
//     }
//   }

//   Future<void> _loadFriends({bool reset = true}) async {
//     final api = _api;
//     if (api == null) return;
//     final nextPage = reset ? 1 : _filter.page;
//     setState(() {
//       _loading = true;
//       _error = null;
//       if (reset) _noMoreData = false;
//       _filter = _filter.copyWith(page: nextPage);
//     });
//     try {
//       final data = await api.getOnlineUsers(_filter);
//       if (!mounted) return;
//       setState(() {
//         if (nextPage == 1) {
//           _friends = data;
//         } else {
//           _friends = [..._friends, ...data];
//         }
//         _noMoreData = data.length < 12;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _error = e.toString());
//     } finally {
//       if (mounted) setState(() => _loading = false);
//       }
//     }

//   Future<void> _loadMore() async {
//     if (_loading || _noMoreData) return;
//     setState(() => _filter = _filter.copyWith(page: _filter.page + 1));
//     await _loadFriends(reset: false);
//   }

//   Future<void> _resetFilter() async {
//     setState(() {
//       _filter = const OnlineFilter();
//       _noMoreData = false;
//     });
//     await _loadFriends();
//   }

//   void _snack(String message, {bool error = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
//       ),
//     );
//   }

//   Future<void> _chat(OnlineUser user) async {
//     final api = _api;
//     if (api == null) return;
//     setState(() => _loading = true);
//     try {
//       await api.createChatRoom(fromUser: _loginUserId, toUser: user.id, lastLogin: user.lastLogin);
//       if (!mounted) return;
//       if (widget.onOpenMessenger != null) {
//         widget.onOpenMessenger!(context, user);
//       } else {
//         Navigator.pushNamed(context, '/messenger', arguments: {'userid': _btoa(user.email)});
//       }
//     } catch (e) {
//       _snack(e.toString(), error: true);
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _openProfile(OnlineUser user) {
//     if (widget.onOpenProfile != null) {
//       widget.onOpenProfile!(context, user);
//       return;
//     }
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (_) => BeatSingleUserProfileScreen(
//     //       userId: user.id,
//     //       accessToken: widget.accessToken,
//     //       accessSign: widget.accessSign,
//     //       loginUserId: _loginUserId,
//     //     ),
//     //   ),
//     // );
//   }

//   Future<void> _openFilterSheet() async {
//     final searchController = TextEditingController(text: _filter.searchKeyword);
//     final locationController = TextEditingController(text: _filter.locationText);
//     var draft = _filter;
//     var resolvingLocation = false;

//     final result = await showModalBottomSheet<OnlineFilter>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             Future<void> submit() async {
//               setModalState(() => resolvingLocation = true);
//               var lat = '0';
//               var lng = '0';
//               var city = '0';
//               final locationText = locationController.text.trim();
//               if (locationText.isNotEmpty) {
//                 try {
//                   final locations = await locationFromAddress(locationText);
//                   if (locations.isNotEmpty) {
//                     lat = locations.first.latitude.toString();
//                     lng = locations.first.longitude.toString();
//                     city = locationText;
//                   }
//                 } catch (_) {
//                   // Keep original web fallback: 0/0 when no Google place is selected.
//                 }
//               }
//               if (!mounted) return;
//               Navigator.pop(
//                 context,
//                 draft.copyWith(
//                   searchKeyword: searchController.text.trim(),
//                   locationText: locationText,
//                   lat: lat,
//                   lng: lng,
//                   city: city,
//                   distance: draft.distance,
//                   page: 1,
//                 ),
//               );
//             }

//             Widget checkbox(String label, String value, Color dotColor) {
//               final checked = draft.profileTypeArray.contains(value);
//               return InkWell(
//                 onTap: () {
//                   final next = List<String>.from(draft.profileTypeArray);
//                   checked ? next.remove(value) : next.add(value);
//                   setModalState(() => draft = draft.copyWith(profileTypeArray: next));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     children: [
//                       Checkbox(
//                         value: checked,
//                         activeColor: Colors.white,
//                         checkColor: _maroon,
//                         side: const BorderSide(color: Colors.white),
//                         onChanged: (v) {
//                           final next = List<String>.from(draft.profileTypeArray);
//                           v == true ? next.add(value) : next.remove(value);
//                           setModalState(() => draft = draft.copyWith(profileTypeArray: next.toSet().toList()));
//                         },
//                       ),
//                       Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
//                       const SizedBox(width: 6),
//                       Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             Widget distanceDropdown() {
//               return DropdownButtonFormField<String>(
//                 value: draft.distance,
//                 dropdownColor: Colors.white,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: '50', child: Text('50 km')),
//                   DropdownMenuItem(value: '100', child: Text('100 km')),
//                   DropdownMenuItem(value: '200', child: Text('200 km')),
//                   DropdownMenuItem(value: '500', child: Text('500 km')),
//                   DropdownMenuItem(value: '1000', child: Text('1000 km')),
//                 ],
//                 onChanged: (value) => setModalState(() => draft = draft.copyWith(distance: value ?? '100')),
//               );
//             }

//             return Padding(
//               padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//               child: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [_maroon, _navy],
//                   ),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//                 ),
//                 padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
//                 child: SafeArea(
//                   top: false,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Center(
//                           child: Container(
//                             width: 42,
//                             height: 4,
//                             margin: const EdgeInsets.only(bottom: 12),
//                             decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(20)),
//                             ),
//                           ),
//                         checkbox('Couples', 'Couple', Colors.red),
//                         checkbox('Females', 'Female', Colors.pink),
//                         checkbox('Males', 'Male', Colors.orange),
//                         checkbox('Transgenders', 'Transgender', Colors.yellow),
//                         const SizedBox(height: 8),
//                         _filterTextField(searchController, 'Search Username...'),
//                         const SizedBox(height: 8),
//                         _filterTextField(locationController, 'Search Location...'),
//                         const SizedBox(height: 8),
//                         distanceDropdown(),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.black,
//                             elevation: 0,
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                           onPressed: resolvingLocation ? null : submit,
//                           child: resolvingLocation
//                                     ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
//                                     : const Text('Find', style: TextStyle(fontWeight: FontWeight.w600)),
//                                   ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: OutlinedButton(
//                                 style: OutlinedButton.styleFrom(
//                                   foregroundColor: Colors.white,
//                                   side: const BorderSide(color: Colors.white),
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                                 ),
//                                 onPressed: resolvingLocation
//                                     ? null
//                                     : () {
//                                         Navigator.pop(context, const OnlineFilter());
//                                       },
//                                 child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600)),
//                                   ),
//                                 ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );

//     searchController.dispose();
//     locationController.dispose();

//     if (result != null) {
//       setState(() => _filter = result);
//       await _loadFriends();
//     }
//   }

//   Widget _filterTextField(TextEditingController controller, String hint) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(fontSize: 13),
//       decoration: InputDecoration(
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.white,
//         isDense: true,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _lightBg,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             RefreshIndicator(
//               onRefresh: () => _loadFriends(),
//               color: _maroon,
//               child: ListView(
//                 padding: const EdgeInsets.all(20),
//                 children: [
//                   _header(),
//                   if (_booting) const Padding(
//                       padding: EdgeInsets.only(top: 80),
//                     child: Center(child: CircularProgressIndicator(color: _maroon)),
//                   ) else if (_error != null) ...[
//                     _errorBox(_error!),
//                   ] else if (_friends.isEmpty && !_loading) ...[
//                     _noData(),
//                   ] else ...[
//                     const SizedBox(height: 16),
//                     _friendGrid(),
//                     if (_friends.isNotEmpty && !_noMoreData) ...[
//                       const SizedBox(height: 18),
//                       Center(child: _loadMoreButton()),
//                     ],
//                   ],
//                 ],
//               ),
//             ),
//             if (_loading && !_booting)
//               Positioned.fill(
//                 child: IgnorePointer(
//                   child: Container(
//                     color: Colors.black.withOpacity(0.04),
//                     alignment: Alignment.topCenter,
//                     padding: const EdgeInsets.only(top: 8),
//                     child: const LinearProgressIndicator(minHeight: 3, color: _maroon),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _header() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RichText(
//             text: TextSpan(
//                   text: 'Online ',
//                   style: const TextStyle(color: _primary, fontSize: 26, fontWeight: FontWeight.w600),
//               children: [
//                     if (_friends.isNotEmpty)
//                       TextSpan(text: '(${_friends.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                   ],
//                     ),
//                   ),
//               const SizedBox(height: 4),
//               Text(
//                 'Finding users within ${_filter.distance} km radius',
//                 style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
//             ),
//             ],
//           ),
//         ),
//         InkWell(
//           onTap: _openFilterSheet,
//           borderRadius: BorderRadius.circular(8),
//           child: Container(
//             padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
//             child: SvgPicture.network(
//               _webAsset('assets/img/icons/filter.svg'),
//               width: 20,
//               height: 20,
//                 placeholderBuilder: (_) => const Icon(Icons.filter_alt, size: 20, color: _maroon),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _friendGrid() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final width = constraints.maxWidth;
//         final columns = width >= 920 ? 4 : width >= 620 ? 2 : 1;
//         return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: _friends.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: columns,
//             crossAxisSpacing: 18,
//             mainAxisSpacing: 20,
//             mainAxisExtent: 505,
//           ),
//           itemBuilder: (context, index) {
//             final user = _friends[index];
//             if (_isLockedIndex(index)) {
//               return _lockedCard();
//             }
//             return _friendCard(user);
//           },
//         );
//       },
//     );
//   }

//   Widget _friendCard(OnlineUser user) {
//     final imageCount = user.hasVisibleProfileImage ? user.images.length : 0;
//     final videoCount = user.videos.length;

//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.topCenter,
//       children: [
//         GestureDetector(
//           onTap: () => _openProfile(user),
//           child: Container(
//             margin: const EdgeInsets.only(top: 60),
//             height: 425,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: const LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [_maroon, _navy],
//               ),
//             boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 40, offset: Offset(0, 20))],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 64, 16, 12),
//               child: Column(
//                 children: [
//                   InkWell(
//                     onTap: () => _openProfile(user),
//                     child: Text(
//                       user.username,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 const SizedBox(height: 6),
//                 if (user.showOnlineStatus) _onlineStatus(user),
//                 if (user.showAge) ...[
//                   const SizedBox(height: 6),
//                   Text(
//                     user.age2.isNotEmpty ? 'Age ${user.age} | ${user.age2}' : 'Age ${user.age}',
//                     style: const TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                 ],
//                   const SizedBox(height: 8),
//                   _genderIcons(user),
//                   const SizedBox(height: 8),
//                 if (user.showGender)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                     decoration: BoxDecoration(color: _pink, borderRadius: BorderRadius.circular(12)),
//                     child: Text(
//                       user.genderProfileType,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ),
//                 if (user.aiInsight.isNotEmpty) ...[
//                   const SizedBox(height: 8),
//                   Text(
//                     user.aiInsight,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
//                   ),
//                 ],
//                   const SizedBox(height: 12),
//                 if (user.showLocation) _locationLine(user),
//                   const SizedBox(height: 10),
//                 if (_loginUserId != user.id && user.showChatIcon)
//                     InkWell(
//                       onTap: () => _chat(user),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(4),
//                         child: Image.network(
//                           _webAsset('assets/img/icons/chat.jpg'),
//                           width: 30,
//                           height: 30,
//                         errorBuilder: (_, __, ___) => const Icon(Icons.chat_bubble, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   const Spacer(),
//                 _actionBar(user, imageCount, videoCount),
//               ],
//             ),
//           ),
//         ),
//         ),
//         if (user.aiMatchScore.isNotEmpty)
//           Positioned(
//             top: 70,
//             right: 12,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//               decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), borderRadius: BorderRadius.circular(16)),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.bolt, color: Colors.amber, size: 14),
//                   const SizedBox(width: 3),
//                   Text('${user.aiMatchScore}% Match', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
//                 ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: 0,
//           child: GestureDetector(
//             onTap: () => _openProfile(user),
//             child: Container(
//               width: 110,
//               height: 110,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: _pink, width: 4),
//                 color: Colors.white,
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: _networkImage(user.primaryImage, fit: BoxFit.cover),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _onlineStatus(OnlineUser user) {
//     final asset = user.isOnline ? 'assets/img/icons/online.svg' : 'assets/img/icons/offline.svg';
//     return SvgPicture.network(
//       _webAsset(asset),
//       width: 20,
//       height: 20,
//       placeholderBuilder: (_) => Icon(user.isOnline ? Icons.circle : Icons.circle_outlined, color: user.isOnline ? Colors.greenAccent : Colors.white70, size: 16),
//     );
//   }

//   Widget _lockedCard() {
//     return GestureDetector(
//       onTap: _showMembershipDialog,
//       child: Container(
//         margin: const EdgeInsets.only(top: 60),
//         height: 425,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
//           boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 40, offset: Offset(0, 20))],
//         ),
//         child: Center(
//           child: Container(
//             width: 240,
//             height: 300,
//             padding: const EdgeInsets.all(20),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(4),
//               child: Image.network(
//                 _webAsset('assets/img/lock.png'),
//                 fit: BoxFit.contain,
//                 errorBuilder: (_, __, ___) => const Icon(Icons.lock, color: Colors.white, size: 54),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _genderIcons(OnlineUser user) {
//     final icons = <String>[];
//     if (user.flag('couple_male_female_swingers')) icons.add('assets/img/icon/male-female.png');
//     if (user.flag('couple_female_female_swingers')) icons.add('assets/img/icon/female-female.png');
//     if (user.flag('couple_male_male_swingers')) icons.add('assets/img/icon/male-male.png');
//     if (user.flag('couple_male_swingers')) icons.add('assets/img/icon/male.png');
//     if (user.flag('couple_female_swingers')) icons.add('assets/img/icon/female.png');
//     if (user.flag('couple_transgender_swingers')) icons.add('assets/img/icon/transgender.png');

//     if (icons.isEmpty) return const SizedBox(height: 20);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: icons
//           .map(
//             (path) => Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 3),
//               child: Image.network(
//             _webAsset(path),
//                 width: 22,
//                 height: 22,
//                 errorBuilder: (_, __, ___) => const SizedBox(width: 22, height: 22),
//           ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   Widget _locationLine(OnlineUser user) {
//     final distanceText = '${user.totalDistance} ${user.distance}'.trim();
//     final parts = <String>[
//       if (user.formattedAddress.isNotEmpty) user.formattedAddress,
//       if (distanceText.isNotEmpty) distanceText,
//     ];
//     final text = parts.join(' | ');
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Icon(Icons.location_on, color: Colors.white, size: 20),
//         const SizedBox(width: 4),
//         Flexible(
//           child: Text(
//             text.trim(),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _smallButton(String text, Color color, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(5),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//         decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
//         child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
//             ),
//     );
//   }

//   Widget _actionBar(OnlineUser user, int imageCount, int videoCount) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _actionItem('assets/img/icons/camera.svg', '$imageCount', imageCount > 0 ? () => _showImages(user) : null),
//           _actionItem('assets/img/icons/like.svg', '${user.likesCount}', null),
//           _actionItem('assets/img/icons/people.svg', '${user.friendsCount}', null),
//           _actionIconItem(Icons.verified_outlined, '${user.validationCount}', null),
//           _actionItem('assets/img/icons/video.svg', '$videoCount', videoCount > 0 ? () => _showVideos(user) : null),
//       ],
//       ),
//     );
//   }

//   Widget _actionIconItem(IconData icon, String count, VoidCallback? onTap) {
//     final child = Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, color: Colors.white, size: 22),
//         const SizedBox(height: 3),
//         Text(count, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
//       ],
//     );
//     if (onTap == null) return Opacity(opacity: 0.92, child: child);
//     return InkWell(onTap: onTap, child: child);
//   }

//   Widget _actionItem(String iconPath, String count, VoidCallback? onTap) {
//     final child = Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SvgPicture.network(
//           _webAsset(iconPath),
//           width: 22,
//           height: 22,
//           placeholderBuilder: (_) => const Icon(Icons.circle, color: Colors.white, size: 18),
//         ),
//         const SizedBox(height: 3),
//         Text(count, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
//       ],
//     );
//     if (onTap == null) return Opacity(opacity: 0.92, child: child);
//     return InkWell(onTap: onTap, child: child);
//   }

//   Widget _networkImage(String rawUrl, {BoxFit fit = BoxFit.cover}) {
//     final url = _resolveMediaUrl(rawUrl);
//     if (url.isEmpty) {
//       return Container(
//         color: Colors.white,
//         alignment: Alignment.center,
//         child: const Icon(Icons.person, color: _maroon, size: 46),
//       );
//     }
//     return Image.network(
//       url,
//       fit: fit,
//       errorBuilder: (_, __, ___) => Container(
//           color: Colors.white,
//           alignment: Alignment.center,
//         child: const Icon(Icons.person, color: _maroon, size: 46),
//           ),
//       loadingBuilder: (context, child, loading) {
//         if (loading == null) return child;
//         return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: _maroon));
//       },
//     );
//   }

//   void _showImages(OnlineUser user) {
//     if (user.images.isEmpty || !user.hasVisibleProfileImage) return;
//     showDialog(
//       context: context,
//       builder: (_) => _MediaDialog(
//         title: user.username,
//         itemCount: user.images.length,
//         itemBuilder: (context, index) => InteractiveViewer(
//           child: Image.network(
//             _resolveMediaUrl(user.images[index].profileImage),
//             fit: BoxFit.contain,
//             errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white, size: 60),
//           ),
//         ),
//           ),
//         );
//   }

//   void _showVideos(OnlineUser user) {
//     if (user.videos.isEmpty) return;
//     showDialog(
//       context: context,
//       builder: (_) => _MediaDialog(
//         title: user.username,
//         itemCount: user.videos.length,
//         itemBuilder: (context, index) => _NetworkVideoPlayer(url: _resolveMediaUrl(user.videos[index].video)),
//       ),
//     );
//   }

//   Widget _loadMoreButton() {
//     return ElevatedButton(
//       onPressed: _loading ? null : () => _loadMore(),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: _maroon,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//       ),
//       child: _loading
//           ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//           : const Text('Load More', style: TextStyle(fontWeight: FontWeight.w600)),
//     );
//   }

//   Widget _errorBox(String message) {
//     return Container(
//       margin: const EdgeInsets.only(top: 30),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
//       child: Column(
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 42),
//           const SizedBox(height: 10),
//           Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
//           const SizedBox(height: 14),
//           ElevatedButton(
//             onPressed: () => _loadFriends(),
//             style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _noData() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 30),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 30, offset: Offset(0, 10))],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: const BoxDecoration(color: Color(0x1A01529C), shape: BoxShape.circle),
//             child: const Icon(Icons.person_off_outlined, size: 62, color: _maroon),
//           ),
//           const SizedBox(height: 25),
//           const Text('No New Online', style: TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 24)),
//           const SizedBox(height: 10),
//           const Text(
//             "It looks like you don't have any Online User at the moment. Why not explore and find some interesting people?",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Color(0xFF777777), fontSize: 16, height: 1.6),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showMembershipDialog() {
//     showDialog<void>(
//       context: context,
//       builder: (_) => Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//             gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
//             ),
//             padding: const EdgeInsets.all(22),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//               const Text('Beat Flirt Team!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 12),
//                 const Text(
//                 '"You have not purchased a Beat Flirt membership plan. Buy membership"',
//                   textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white, fontSize: 15),
//                 ),
//                 const SizedBox(height: 18),
//                 ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     if (widget.onOpenMembership != null) {
//                       widget.onOpenMembership!();
//                     } else {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const UpgradePage()),
//                     );
//                     }
//                   },
//                   child: const Text('Purchase'),
//                 ),
//               ],
//           ),
//             ),
//           ),
//         );
//   }
// }

// class _MediaDialog extends StatefulWidget {
//   const _MediaDialog({required this.title, required this.itemCount, required this.itemBuilder});

//   final String title;
//   final int itemCount;
//   final IndexedWidgetBuilder itemBuilder;

//   @override
//   State<_MediaDialog> createState() => _MediaDialogState();
// }

// class _MediaDialogState extends State<_MediaDialog> {
//   final PageController _pageController = PageController();
//   int _index = 0;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog.fullscreen(
//       backgroundColor: Colors.black,
//       child: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       widget.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Text('${_index + 1}/${widget.itemCount}', style: const TextStyle(color: Colors.white70)),
//                   IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: widget.itemCount,
//                 onPageChanged: (v) => setState(() => _index = v),
//                 itemBuilder: widget.itemBuilder,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NetworkVideoPlayer extends StatefulWidget {
//   const _NetworkVideoPlayer({required this.url});

//   final String url;

//   @override
//   State<_NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
// }

// class _NetworkVideoPlayerState extends State<_NetworkVideoPlayer> {
//   VideoPlayerController? _controller;
//   Future<void>? _init;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
//     _init = _controller!.initialize();
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<void>(
//       future: _init,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return const Center(child: CircularProgressIndicator(color: Colors.white));
//         }
//         if (snapshot.hasError || _controller == null) {
//           return const Center(child: Icon(Icons.videocam_off, color: Colors.white, size: 64));
//         }
//         final controller = _controller!;
//         return Center(
//           child: GestureDetector(
//             onTap: () {
//               setState(() => controller.value.isPlaying ? controller.pause() : controller.play());
//             },
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
//                 if (!controller.value.isPlaying)
//                   Container(
//                     width: 74,
//                     height: 74,
//                     decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), shape: BoxShape.circle),
//                     child: const Icon(Icons.play_arrow, color: Colors.white, size: 52),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }



// Beat Flirt /validation screen converted from:
// https://beatflirtevent.com/validation
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


const String _webBase = 'https://beatflirtevent.com/';
const String _apiBase = 'https://app.beatflirtevent.com/App';
const String _apiAssetBase = 'https://app.beatflirtevent.com/assets/';

String _webAsset(String path) => '$_webBase$path';

String _resolveMediaUrl(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return '';
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  if (value.startsWith('//')) return 'https:$value';
  if (value.startsWith('assets/')) return '$_webBase$value';
  if (value.startsWith('/assets/')) return '$_webBase${value.substring(1)}';
  if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
  return '$_apiAssetBase$value';
}

String _btoa(String value) => base64Encode(utf8.encode(value));

bool _okStatus(dynamic status) => status?.toString() == '200';

String _string(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final s = value.toString();
  return s.isEmpty ? fallback : s;
}

int _int(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? fallback;
}

String _longDate(dynamic value) {
  final raw = _string(value);
  if (raw.isEmpty) return '';
  final date = DateTime.tryParse(raw);
  if (date == null) return raw;

  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

class BeatValidationApiException implements Exception {
  BeatValidationApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BeatValidationApi {
  BeatValidationApi({
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
    final response = await _client.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> _post(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BeatValidationApiException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;

    throw BeatValidationApiException('Unexpected API response');
  }

  /// Website API:
  /// POST /location/get_all_validation_data
  Future<List<ValidationUser>> getValidationData(
    ValidationFilter filter,
  ) async {
    final json = await _post(
      '/location/get_all_validation_data',
      filter.toJson(),
    );

    if (_okStatus(json['status'])) {
      final data = json['data'];

      if (data is List) {
        return data
            .map((e) => ValidationUser.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      return <ValidationUser>[];
    }

    final message = _string(json['message']);

    if (message.toLowerCase().contains('token')) {
      throw BeatValidationApiException(message);
    }

    return <ValidationUser>[];
  }

  /// Website API:
  /// POST /user/create_chat_room
  Future<void> createChatRoom({
    required String fromUser,
    required String toUser,
    required String lastLogin,
  }) async {
    final json = await _post('/user/create_chat_room', {
      'from_user': fromUser,
      'to_user': toUser,
      'last_login': lastLogin,
    });

    if (!_okStatus(json['status']) &&
        _string(json['message']).toLowerCase().contains('token')) {
      throw BeatValidationApiException(
        _string(json['message'], 'Unable to create chat room'),
      );
    }
  }

  /// Website shell API:
  /// POST /user/check_login_user_membership
  Future<String?> checkLoginUserMembership() async {
    final json = await _post('/user/check_login_user_membership');
    return json['membership_expire']?.toString();
  }

  /// Optional common count API:
  /// GET /notification/all_count
  Future<Map<String, dynamic>> notificationAllCount() {
    return _get('/notification/all_count');
  }
}

class ValidationFilter {
  const ValidationFilter({
    this.type = 'me',
    this.searchKeyword = '',
    this.locationText = '',
    this.lat = '0',
    this.lng = '0',
    this.city = '0',
    this.profileTypeArray = const <String>[],
  });

  /// me = Who did I validate?
  /// other = Who validated me
  final String type;
  final String searchKeyword;
  final String locationText;
  final String lat;
  final String lng;
  final String city;
  final List<String> profileTypeArray;

  ValidationFilter copyWith({
    String? type,
    String? searchKeyword,
    String? locationText,
    String? lat,
    String? lng,
    String? city,
    List<String>? profileTypeArray,
  }) {
    return ValidationFilter(
      type: type ?? this.type,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      locationText: locationText ?? this.locationText,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      profileTypeArray: profileTypeArray ?? this.profileTypeArray,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'search_keyword': searchKeyword,
        'keyword': searchKeyword,
        'lat': lat,
        'lng': lng,
        'city': city,
        'profileTypeArray': profileTypeArray,
      };
}

class ValidationUserImage {
  ValidationUserImage({
    required this.profileImage,
  });

  final String profileImage;

  factory ValidationUserImage.fromJson(Map<String, dynamic> json) {
    return ValidationUserImage(
      profileImage: _string(json['profile_image']),
    );
  }
}

class ValidationUserVideo {
  ValidationUserVideo({
    required this.video,
  });

  final String video;

  factory ValidationUserVideo.fromJson(Map<String, dynamic> json) {
    return ValidationUserVideo(
      video: _string(json['video']),
    );
  }
}

class ValidationUser {
  ValidationUser({
    required this.raw,
    required this.id,
    required this.username,
    required this.email,
    required this.profileType,
    required this.genderProfileType,
    required this.age,
    required this.age2,
    required this.formattedAddress,
    required this.totalDistance,
    required this.distance,
    required this.lastLogin,
    required this.validateUsername,
    required this.validationDate,
    required this.message,
    required this.images,
    required this.videos,
  });

  final Map<String, dynamic> raw;

  final String id;
  final String username;
  final String email;
  final String profileType;
  final String genderProfileType;

  final String age;
  final String age2;

  final String formattedAddress;
  final String totalDistance;
  final String distance;

  final String lastLogin;

  final String validateUsername;
  final String validationDate;
  final String message;

  final List<ValidationUserImage> images;
  final List<ValidationUserVideo> videos;

  factory ValidationUser.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] is List ? json['image'] as List : const [];
    final videoList = json['video'] is List ? json['video'] as List : const [];

    return ValidationUser(
      raw: json,
      id: _string(json['id']),
      username: _string(json['username']),
      email: _string(json['email']),
      profileType: _string(json['profile_type']),
      genderProfileType: _string(json['gender_profile_type']),
      age: _string(json['age'], '21'),
      age2: _string(json['age2']),
      formattedAddress: _string(json['formatted_address']),
      totalDistance: _string(json['total_distance']),
      distance: _string(json['distance']),
      lastLogin: _string(json['last_login']),
      validateUsername: _string(json['validate_username']),
      validationDate: _longDate(json['validation_date']),
      message: _string(json['message']),
      images: imageList
          .whereType<Map>()
          .map(
            (e) => ValidationUserImage.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
      videos: videoList
          .whereType<Map>()
          .map(
            (e) => ValidationUserVideo.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }

  String get primaryImage {
    if (images.isEmpty) return '';
    return images.first.profileImage;
  }

  bool flag(String key) => raw[key]?.toString() == '1';
}

class ValidationPage extends StatefulWidget {
  const ValidationPage({
    super.key,
    this.api,
    this.accessToken,
    this.accessSign,
    this.loginUserId,
    this.membershipValue,
    this.autoCheckMembership = true,
    this.enforceMembershipLock = true,
    this.onOpenProfile,
    this.onOpenMessenger,
    this.onOpenMembership,
  });

  /// You can pass your API object directly,
  /// or pass token/sign and let this widget create the API service.
  final BeatValidationApi? api;

  final String? accessToken;
  final String? accessSign;
  final String? loginUserId;
  final String? membershipValue;

  final bool autoCheckMembership;

  /// Angular validation page shows real cards when membership storage is "Yes".
  /// If false, it shows the premium placeholder.
  final bool enforceMembershipLock;

  final void Function(BuildContext context, ValidationUser user)? onOpenProfile;
  final void Function(BuildContext context, ValidationUser user)?
      onOpenMessenger;
  final VoidCallback? onOpenMembership;

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  static const Color _lightBg = Color(0xFFFFF4FA);
  static const Color _primary = Color(0xFF1D042A);
  static const Color _maroon = Color(0xFF560827);
  static const Color _pink = Color(0xFFE91E63);
  static const Color _navy = Color(0xFF06032C);

  BeatValidationApi? _api;

  ValidationFilter _filter = const ValidationFilter();

  List<ValidationUser> _items = <ValidationUser>[];

  bool _booting = true;
  bool _loading = false;

  String? _error;

  String _loginUserId = '';
  String _membershipValue = '';

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool get _cardsLocked {
    if (!widget.enforceMembershipLock) return false;
    return _membershipValue == 'Yes';
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
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

      _membershipValue = widget.membershipValue ??
          prefs.getString('membership') ??
          prefs.getString('membership_expire') ??
          prefs.getString('membershipValue') ??
          '';

      _api = widget.api ??
          BeatValidationApi(
            accessToken: token,
            accessSign: sign,
          );

      if (widget.autoCheckMembership &&
          token.isNotEmpty &&
          sign.isNotEmpty) {
        final membershipExpire = await _api!.checkLoginUserMembership();

        if (membershipExpire != null) {
          _membershipValue = membershipExpire;
          await prefs.setString('membership', membershipExpire);
        }
      }

      if (!mounted) return;

      setState(() {
        _booting = false;
      });

      await _loadValidations();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _booting = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadValidations() async {
    final api = _api;
    if (api == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await api.getValidationData(_filter);

      if (!mounted) return;

      setState(() {
        _items = data;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
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

  Future<void> _chat(ValidationUser user) async {
    final api = _api;
    if (api == null) return;

    setState(() {
      _loading = true;
    });

    try {
      await api.createChatRoom(
        fromUser: _loginUserId,
        toUser: user.id,
        lastLogin: user.lastLogin,
      );

      if (!mounted) return;

      if (widget.onOpenMessenger != null) {
        widget.onOpenMessenger!(context, user);
      } else {
        Navigator.pushNamed(
          context,
          '/messenger',
          arguments: {
            'userid': _btoa(user.email),
          },
        );
      }
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _openProfile(ValidationUser user) {
    if (widget.onOpenProfile != null) {
      widget.onOpenProfile!(context, user);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BeatSingleUserProfileScreen(
          userId: user.id,
          accessToken: widget.accessToken,
          accessSign: widget.accessSign,
          loginUserId: _loginUserId,
        ),
      ),
    );
  }

  Future<void> _openFilterSheet() async {
    _searchController.text = _filter.searchKeyword;
    _locationController.text = _filter.locationText;

    var draft = _filter;
    var resolvingLocation = false;

    final result = await showModalBottomSheet<ValidationFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> submit() async {
              setModalState(() {
                resolvingLocation = true;
              });

              var lat = '0';
              var lng = '0';
              var city = '0';

              final locationText = _locationController.text.trim();

              if (locationText.isNotEmpty) {
                try {
                  final locations = await locationFromAddress(locationText);

                  if (locations.isNotEmpty) {
                    lat = locations.first.latitude.toString();
                    lng = locations.first.longitude.toString();
                    city = locationText;
                  }
                } catch (_) {
                  lat = '0';
                  lng = '0';
                  city = '0';
                }
              }

              if (!mounted) return;

              Navigator.pop(
                context,
                draft.copyWith(
                  searchKeyword: _searchController.text.trim(),
                  locationText: locationText,
                  lat: lat,
                  lng: lng,
                  city: city,
                ),
              );
            }

            Widget radio(String label, String value) {
              return InkWell(
                onTap: () {
                  setModalState(() {
                    draft = draft.copyWith(type: value);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: value,
                        groupValue: draft.type,
                        activeColor: Colors.white,
                        fillColor: MaterialStateProperty.all(Colors.white),
                        onChanged: (v) {
                          setModalState(() {
                            draft = draft.copyWith(type: v);
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            Widget checkbox(String label, String value, Color dotColor) {
              final checked = draft.profileTypeArray.contains(value);

              return InkWell(
                onTap: () {
                  final next = List<String>.from(draft.profileTypeArray);

                  if (checked) {
                    next.remove(value);
                  } else {
                    next.add(value);
                  }

                  setModalState(() {
                    draft = draft.copyWith(
                      profileTypeArray: next.toSet().toList(),
                    );
                  });
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
                          final next = List<String>.from(
                            draft.profileTypeArray,
                          );

                          if (v == true) {
                            next.add(value);
                          } else {
                            next.remove(value);
                          }

                          setModalState(() {
                            draft = draft.copyWith(
                              profileTypeArray: next.toSet().toList(),
                            );
                          });
                        },
                      ),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_maroon, _navy],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
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
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        radio('Who did I validate?', 'me'),
                        radio('Who validated me', 'other'),
                        const Divider(color: Colors.white54),
                        checkbox('Couples', 'Couple', Colors.red),
                        checkbox('Females', 'Female', Colors.pink),
                        checkbox('Males', 'Male', Colors.orange),
                        checkbox('Transgenders', 'Transgender', Colors.yellow),
                        const SizedBox(height: 8),
                        _filterTextField(
                          _searchController,
                          'Search Username...',
                        ),
                        const SizedBox(height: 8),
                        _filterTextField(
                          _locationController,
                          'Search Location...',
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: resolvingLocation ? null : submit,
                          child: resolvingLocation
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Ok',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
      setState(() {
        _filter = result;
      });

      await _loadValidations();
    }
  }

  Widget _filterTextField(
    TextEditingController controller,
    String hint,
  ) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: _header(),
        title:  RichText(
            text: TextSpan(
              text: 'Validations ',
              style: const TextStyle(
                color: _primary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              children: [
                if (_items.isNotEmpty)
                  TextSpan(
                    text: '(${_items.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,size:20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadValidations,
              color: _maroon,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _header(),
                  if (_booting)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: CircularProgressIndicator(color: _maroon),
                      ),
                    )
                  else if (_error != null) ...[
                    _errorBox(_error!),
                  ] else if (_items.isEmpty && !_loading) ...[
                    _noData(),
                  ] else ...[
                    const SizedBox(height: 16),
                    _validationGrid(),
                  ],
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
                    child: const LinearProgressIndicator(
                      minHeight: 3,
                      color: _maroon,
                    ),
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
        //       text: 'Validations ',
        //       style: const TextStyle(
        //         color: _primary,
        //         fontSize: 26,
        //         fontWeight: FontWeight.w600,
        //       ),
        //       children: [
        //         if (_items.isNotEmpty)
        //           TextSpan(
        //             text: '(${_items.length})',
        //             style: const TextStyle(
        //               fontSize: 18,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //       ],
        //     ),
        //   ),
        // ),
        InkWell(
          onTap: _openFilterSheet,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.network(
              _webAsset('assets/img/icons/filter.svg'),
              width: 20,
              height: 20,
              placeholderBuilder: (_) {
                return const Icon(
                  Icons.filter_alt,
                  size: 20,
                  color: _maroon,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _validationGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 920
            ? 4
            : width >= 620
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 20,
            mainAxisExtent: 505,
          ),
          itemBuilder: (context, index) {
            if (_cardsLocked) return _lockedCard();
            return _validationCard(_items[index]);
          },
        );
      },
    );
  }

  Widget _validationCard(ValidationUser user) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        GestureDetector(
          onTap: () => _openProfile(user),
          child: Container(
            margin: const EdgeInsets.only(top: 60),
            height: 425,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_maroon, _navy],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D000000),
                  blurRadius: 40,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 64, 16, 12),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _openProfile(user),
                    child: Text(
                      user.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.age2.isNotEmpty
                        ? 'Age ${user.age} | ${user.age2}'
                        : 'Age ${user.age}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _genderIcons(user),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _pink,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.genderProfileType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _locationLine(user),
                  const SizedBox(height: 10),
                  if (_loginUserId != user.id)
                    InkWell(
                      onTap: () => _chat(user),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          _webAsset('assets/img/icons/chat.jpg'),
                          width: 30,
                          height: 30,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.chat_bubble,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                  const Spacer(),
                  _validationInfo(user),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => _openProfile(user),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _pink,
                  width: 4,
                ),
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: _networkImage(
                user.primaryImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _validationInfo(ValidationUser user) {
    return Column(
      children: [
        if (user.validateUsername.isNotEmpty ||
            user.validationDate.isNotEmpty)
          Text.rich(
            TextSpan(
              text: 'By ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: user.validateUsername,
                  style: const TextStyle(
                    color: Color(0xFFD05473),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      user.validationDate.isNotEmpty ? ' ${user.validationDate}' : '',
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 8),
        if (user.message.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: _maroon,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              user.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _lockedCard() {
    return GestureDetector(
      onTap: _showMembershipDialog,
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        height: 425,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_maroon, _navy],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D000000),
              blurRadius: 40,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 240,
            height: 300,
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                _webAsset('assets/img/celebrity/bg-logo.jpg'),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 54,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderIcons(ValidationUser user) {
    final icons = <String>[];

    if (user.flag('couple_male_female_swingers')) {
      icons.add('assets/img/icons/couple-logo.svg');
    }
    if (user.flag('couple_female_female_swingers')) {
      icons.add('assets/img/icons/female-logo.svg');
    }
    if (user.flag('couple_male_male_swingers')) {
      icons.add('assets/img/icons/male-logo.svg');
    }
    if (user.flag('couple_male_swingers')) {
      icons.add('assets/img/icons/single-male.svg');
    }
    if (user.flag('couple_female_swingers')) {
      icons.add('assets/img/icons/single-female.svg');
    }
    if (user.flag('couple_transgender_swingers')) {
      icons.add('assets/img/icons/transgender-logo.svg');
    }

    if (icons.isEmpty) return const SizedBox(height: 20);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: icons.map((path) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SvgPicture.network(
            _webAsset(path),
            width: 20,
            height: 20,
            placeholderBuilder: (_) {
              return const SizedBox(width: 20, height: 20);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _locationLine(ValidationUser user) {
    final distanceText = '${user.totalDistance} ${user.distance}'.trim();

    final parts = <String>[
      if (user.formattedAddress.isNotEmpty) user.formattedAddress,
      if (distanceText.isNotEmpty) distanceText,
    ];

    final text = parts.join(' | ');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _networkImage(
    String rawUrl, {
    BoxFit fit = BoxFit.cover,
  }) {
    final url = _resolveMediaUrl(rawUrl);

    if (url.isEmpty) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const Icon(
          Icons.person,
          color: _maroon,
          size: 46,
        ),
      );
    }

    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) {
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const Icon(
            Icons.person,
            color: _maroon,
            size: 46,
          ),
        );
      },
      loadingBuilder: (context, child, loading) {
        if (loading == null) return child;

        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: _maroon,
          ),
        );
      },
    );
  }

  Widget _errorBox(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _loadValidations,
            style: ElevatedButton.styleFrom(
              backgroundColor: _maroon,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _noData() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 80,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0x1A01529C),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_off_outlined,
              size: 62,
              color: _maroon,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'No Validations',
            style: TextStyle(
              color: _primary,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "It looks like you don't have any validations at the moment. Why not explore and find some interesting people?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showMembershipDialog() {
    showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_maroon, _navy],
              ),
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Beat Flirt Team!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '"You have not purchased a Beat Flirt membership plan. Buy membership"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _maroon,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);

                    if (widget.onOpenMembership != null) {
                      widget.onOpenMembership!();
                    } else {
                      Navigator.pushNamed(context, '/membership');
                    }
                  },
                  child: const Text('Purchase'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}