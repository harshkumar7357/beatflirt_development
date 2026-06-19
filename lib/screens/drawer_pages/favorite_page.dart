// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:beatflirt/providers/user_list_provider.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// //
// // class FavoritePage extends ConsumerWidget {
// //   const FavoritePage({super.key});
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final state = ref.watch(userListProvider('favorites'));
// //
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF0F0F1A),
// //       body: CustomScrollView(
// //         physics: const BouncingScrollPhysics(),
// //         slivers: [
// //           _buildAppBar(context),
// //           _buildFavoritesHeader(state.users.length),
// //           _buildFavoritesGrid(state.users),
// //           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
// //         ],
// //       ),
// //     );
// //   }
// //
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
// //         'FAVORITES',
// //         style: TextStyle(
// //           color: Colors.white,
// //           fontWeight: FontWeight.w900,
// //           fontSize: 16,
// //           letterSpacing: 2.0,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFavoritesHeader(int count) {
// //     return SliverToBoxAdapter(
// //       child: Container(
// //         margin: const EdgeInsets.all(20),
// //         padding: const EdgeInsets.all(25),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(30),
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //         ),
// //         child: Row(
// //           children: [
// //             const CircleAvatar(
// //               radius: 30,
// //               backgroundColor: Colors.white24,
// //               child: FaIcon(FontAwesomeIcons.solidHeart, color: Colors.white, size: 25),
// //             ),
// //             const SizedBox(width: 20),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text('Saved Profiles', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
// //                   Text('$count people in your list', style: const TextStyle(color: Colors.white70, fontSize: 13)),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFavoritesGrid(List<UserListItem> users) {
// //     return SliverPadding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20),
// //       sliver: SliverGrid(
// //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           mainAxisSpacing: 15,
// //           crossAxisSpacing: 15,
// //           childAspectRatio: 0.75,
// //         ),
// //         delegate: SliverChildBuilderDelegate(
// //           (context, index) {
// //             final user = users[index % users.length];
// //             return _buildFavoriteCard(user);
// //           },
// //           childCount: 8,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFavoriteCard(UserListItem user) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white.withValues(alpha: 0.05),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// //       ),
// //       child: Stack(
// //         fit: StackFit.expand,
// //         children: [
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(20),
// //             child: Image.asset(user.imageUrl, fit: BoxFit.cover),
// //           ),
// //           Container(
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(20),
// //               gradient: LinearGradient(
// //                 begin: Alignment.topCenter,
// //                 end: Alignment.bottomCenter,
// //                 colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             bottom: 12,
// //             left: 12,
// //             right: 12,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
// //                 const SizedBox(height: 4),
// //                 Row(
// //                   children: [
// //                     const Icon(Icons.location_on, color: Colors.white70, size: 10),
// //                     const SizedBox(width: 4),
// //                     Text(user.location, style: const TextStyle(color: Colors.white70, fontSize: 10)),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Positioned(
// //             top: 10,
// //             right: 10,
// //             child: CircleAvatar(
// //               radius: 15,
// //               backgroundColor: Colors.black38,
// //               child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 16),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/providers/user_list_provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// import 'package:beatflirt/core/utils/image_utils.dart';

// class FavoritePage extends ConsumerWidget {
//   const FavoritePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(userListProvider('favorites'));

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF0F0F1A), // Deep dark
//               Color(0xFF1A1A2E), // Midnight blue tint
//               Color(0xFF0F0F1A),
//             ],
//           ),
//         ),
//         child: RefreshIndicator(
//           color: Colors.pinkAccent,
//           backgroundColor: const Color(0xFF1A1A2E),
//           onRefresh: () => ref.read(userListProvider('favorites').notifier).fetchUsers(),
//           child: CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _buildAppBar(context),
//               if (state.isLoading && state.users.isEmpty)
//                 const SliverFillRemaining(
//                   child: Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
//                 )
//               else if (state.error != null && state.users.isEmpty)
//                 SliverFillRemaining(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.error_outline, color: Colors.white54, size: 60),
//                         const SizedBox(height: 16),
//                         Text(state.error!, style: const TextStyle(color: Colors.white70)),
//                         TextButton(
//                           onPressed: () => ref.read(userListProvider('favorites').notifier).fetchUsers(),
//                           child: const Text('Retry', style: TextStyle(color: Colors.pinkAccent)),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               else ...[
//                   _buildFavoritesHeader(state.users.length),
//                   if (state.users.isEmpty)
//                     const SliverFillRemaining(
//                       hasScrollBody: false,
//                       child: Center(
//                         child: Text(
//                           'No favorites yet.',
//                           style: TextStyle(color: Colors.white54, fontSize: 16),
//                         ),
//                       ),
//                     )
//                   else
//                     _buildFavoritesGrid(state.users, ref),
//                 ],
//               const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       floating: true,
//       pinned: true,
//       backgroundColor: Colors.transparent, // Let the background gradient show through
//       surfaceTintColor: Colors.transparent,
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//         onPressed: () => Navigator.pop(context), 
//       ),
//       centerTitle: true,
//       title: const Text(
//         'FAVORITES',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w900,
//           fontSize: 16,
//           letterSpacing: 2.0,
//         ),
//       ),
//     );
//   }

//   Widget _buildFavoritesHeader(int count) {
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//         padding: const EdgeInsets.all(25),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFFF4081).withValues(alpha: 0.3),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             const CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white24,
//               child: FaIcon(FontAwesomeIcons.solidHeart, color: Colors.white, size: 25),
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Saved Profiles', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//                   Text('$count people in your list', style: const TextStyle(color: Colors.white70, fontSize: 13)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFavoritesGrid(List<UserListItem> users, WidgetRef ref) {
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 15,
//           crossAxisSpacing: 15,
//           childAspectRatio: 0.75,
//         ),
//         delegate: SliverChildBuilderDelegate(
//               (context, index) {
//             final user = users[index];
//             return _buildFavoriteCard(context, user, ref);
//           },
//           childCount: users.length,
//         ),
//       ),
//     );
//   }

//   Widget _buildFavoriteCard(BuildContext context, UserListItem user, WidgetRef ref) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => OtherUserProfilePage(user: user)),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(alpha: 0.05),
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//         ),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: buildUserImage(user.imageUrl),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(24),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 12,
//               left: 12,
//               right: 12,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, color: Colors.white70, size: 10),
//                       const SizedBox(width: 4),
//                       Text(user.location, style: const TextStyle(color: Colors.white70, fontSize: 10)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 10,
//               right: 10,
//               child: InkWell(
//                 onTap: () => ref.read(userListProvider('favorites').notifier).toggleFavorite(user.id),
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Colors.black45,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white24),
//                   ),
//                   child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 18),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:beatflirt/single_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'upgrade_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';



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

class BeatFavoriteApiException implements Exception {
  BeatFavoriteApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BeatFavoriteApi {
  BeatFavoriteApi({
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
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

    if (accessToken.isNotEmpty) {
      headers['Access-Token'] = accessToken;
      headers['access-token'] = accessToken;
      headers['Authorization'] = 'Bearer $accessToken';
    }
    if (accessSign.isNotEmpty) {
      headers['Access-Sign'] = accessSign;
    }

    return headers;
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
      throw BeatFavoriteApiException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;

    throw BeatFavoriteApiException('Unexpected API response');
  }

  /// Website API:
  /// POST /feed/get_all_remember_request
  Future<List<FavoriteUser>> getFavorites(FavoriteFilter filter) async {
    final json = await _post(
      '/feed/get_all_remember_request',
      filter.toJson(),
    );

    if (_okStatus(json['status'])) {
      final data = json['data'];
      if (data is List) {
        return data
            .map((e) => FavoriteUser.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return <FavoriteUser>[];
    }

    final message = _string(json['message']);
    if (message.toLowerCase().contains('token')) {
      throw BeatFavoriteApiException(message);
    }

    return <FavoriteUser>[];
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
      throw BeatFavoriteApiException(
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

  /// Optional shell count API:
  /// GET /notification/all_count
  Future<Map<String, dynamic>> notificationAllCount() {
    return _get('/notification/all_count');
  }
}

class FavoriteFilter {
  const FavoriteFilter({
    this.type = 'me',
    this.searchKeyword = '',
    this.locationText = '',
    this.lat = '0',
    this.lng = '0',
    this.city = '0',
    this.profileTypeArray = const <String>[],
  });

  /// me = Who did I favourite?
  /// other = Who favourited me
  final String type;
  final String searchKeyword;
  final String locationText;
  final String lat;
  final String lng;
  final String city;
  final List<String> profileTypeArray;

  FavoriteFilter copyWith({
    String? type,
    String? searchKeyword,
    String? locationText,
    String? lat,
    String? lng,
    String? city,
    List<String>? profileTypeArray,
  }) {
    return FavoriteFilter(
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

class FavoriteUserImage {
  FavoriteUserImage({
    required this.profileImage,
  });

  final String profileImage;

  factory FavoriteUserImage.fromJson(Map<String, dynamic> json) {
    return FavoriteUserImage(
      profileImage: _string(json['profile_image']),
    );
  }
}

class FavoriteUserVideo {
  FavoriteUserVideo({
    required this.video,
  });

  final String video;

  factory FavoriteUserVideo.fromJson(Map<String, dynamic> json) {
    return FavoriteUserVideo(
      video: _string(json['video']),
    );
  }
}

class FavoriteUser {
  FavoriteUser({
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
    required this.likesCount,
    required this.friendsCount,
    required this.validationCount,
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

  final int likesCount;
  final int friendsCount;
  final int validationCount;

  final List<FavoriteUserImage> images;
  final List<FavoriteUserVideo> videos;

  factory FavoriteUser.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] is List ? json['image'] as List : const [];
    final videoList = json['video'] is List ? json['video'] as List : const [];

    return FavoriteUser(
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
      likesCount: _int(json['likes_count']),
      friendsCount: _int(json['friends_count']),
      validationCount: _int(json['validation_count']),
      images: imageList
          .whereType<Map>()
          .map(
            (e) => FavoriteUserImage.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
      videos: videoList
          .whereType<Map>()
          .map(
            (e) => FavoriteUserVideo.fromJson(
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

class FavoritePage extends StatefulWidget {
  const FavoritePage({
    super.key,
    this.api,
    this.accessToken,
    this.accessSign,
    this.loginUserId,
    this.membershipValue,
    this.autoCheckMembership = true,
    this.lockCardsWhenMembershipValueIsYes = true,
    this.onOpenProfile,
    this.onOpenMessenger,
    this.onOpenMembership,
  });

  /// You can pass your API object directly,
  /// or pass token/sign and let this widget create the API service.
  final BeatFavoriteApi? api;

  final String? accessToken;
  final String? accessSign;
  final String? loginUserId;
  final String? membershipValue;

  final bool autoCheckMembership;

  /// Same logic used by the Angular website for this page:
  /// membership == "Yes" shows locked/premium card.
  final bool lockCardsWhenMembershipValueIsYes;

  final void Function(BuildContext context, FavoriteUser user)? onOpenProfile;
  final void Function(BuildContext context, FavoriteUser user)? onOpenMessenger;
  final VoidCallback? onOpenMembership;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  static const Color _lightBg = Color(0xFFFFF4FA);
  static const Color _primary = Color(0xFF1D042A);
  static const Color _maroon = Color(0xFF560827);
  static const Color _pink = Color(0xFFE91E63);
  static const Color _navy = Color(0xFF06032C);

  BeatFavoriteApi? _api;

  FavoriteFilter _filter = const FavoriteFilter();

  List<FavoriteUser> _users = <FavoriteUser>[];

  bool _booting = true;
  bool _loading = false;

  String? _error;

  String _loginUserId = '';
  String _membershipValue = '';

  final _filterSearchController = TextEditingController();
  final _filterLocationController = TextEditingController();

  bool get _lockedByMembership {
    if (!widget.lockCardsWhenMembershipValueIsYes) return false;
    return _membershipValue == 'Yes';
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
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
      _membershipValue =
          widget.membershipValue ?? prefs.getString('membership') ?? '';

      _api = widget.api ??
          BeatFavoriteApi(
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

      await _loadFavorites();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _booting = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadFavorites() async {
    final api = _api;
    if (api == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await api.getFavorites(_filter);

      if (!mounted) return;

      setState(() {
        _users = data;
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

  void _showSnack(String message, {bool error = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  Future<void> _openChat(FavoriteUser user) async {
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
      _showSnack(e.toString(), error: true);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _openProfile(FavoriteUser user) {
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
    _filterSearchController.text = _filter.searchKeyword;
    _filterLocationController.text = _filter.locationText;

    var draft = _filter;
    var resolvingLocation = false;

    final result = await showModalBottomSheet<FavoriteFilter>(
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

              final locationText = _filterLocationController.text.trim();

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
                  searchKeyword: _filterSearchController.text.trim(),
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
                        radio('Who did I favourite?', 'me'),
                        radio('Who favourited me', 'other'),
                        const Divider(color: Colors.white54),
                        checkbox('Couples', 'Couple', Colors.red),
                        checkbox('Females', 'Female', Colors.pink),
                        checkbox('Males', 'Male', Colors.orange),
                        checkbox('Transgenders', 'Transgender', Colors.yellow),
                        const SizedBox(height: 8),
                        _filterTextField(
                          _filterSearchController,
                          'Search Username...',
                        ),
                        const SizedBox(height: 8),
                        _filterTextField(
                          _filterLocationController,
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

      await _loadFavorites();
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
        leading:IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: _primary, size: 20),
        ),
        title:RichText(
            text: TextSpan(
              text: 'Favourites ',
              style: const TextStyle(
                color: _primary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              children: [
                if (_users.isNotEmpty)
                  TextSpan(
                    text: '(${_users.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          centerTitle:true,
        ),
      
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadFavorites,
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
                  ] else if (_users.isEmpty && !_loading) ...[
                    _noData(),
                  ] else ...[
                    const SizedBox(height: 16),
                    _favoriteGrid(),
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
        // IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: const Icon(Icons.arrow_back_ios, color: _primary, size: 20),
        // ),
        // Flexible(
        //   child: RichText(
        //     text: TextSpan(
        //       text: 'Favourites ',
        //       style: const TextStyle(
        //         color: _primary,
        //         fontSize: 26,
        //         fontWeight: FontWeight.w600,
        //       ),
        //       children: [
        //         if (_users.isNotEmpty)
        //           TextSpan(
        //             text: '(${_users.length})',
        //             style: const TextStyle(
        //               fontSize: 18,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //       ],
        //     ),
        //   ),
        // ),
        if (!_lockedByMembership)
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

  Widget _favoriteGrid() {
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
          itemCount: _users.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 20,
            mainAxisExtent: 505,
          ),
          itemBuilder: (context, index) {
            final user = _users[index];

            if (_lockedByMembership) {
              return _lockedCard();
            }

            return _favoriteCard(user);
          },
        );
      },
    );
  }

  Widget _favoriteCard(FavoriteUser user) {
    final imageCount = user.images.length;
    final videoCount = user.videos.length;

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
                      onTap: () => _openChat(user),
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
                  _actionBar(user, imageCount, videoCount),
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

  Widget _genderIcons(FavoriteUser user) {
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

  Widget _locationLine(FavoriteUser user) {
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

  Widget _actionBar(
    FavoriteUser user,
    int imageCount,
    int videoCount,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionItem(
            'assets/img/icons/camera.svg',
            '$imageCount',
            imageCount > 0 ? () => _showImages(user) : null,
          ),
          _actionItem(
            'assets/img/icons/like.svg',
            '${user.likesCount}',
            null,
          ),
          _actionItem(
            'assets/img/icons/people.svg',
            '${user.friendsCount}',
            null,
          ),
          _actionItem(
            'assets/img/icons/share.svg',
            '${user.validationCount}',
            null,
          ),
          _actionItem(
            'assets/img/icons/video.svg',
            '$videoCount',
            videoCount > 0 ? () => _showVideos(user) : null,
          ),
        ],
      ),
    );
  }

  Widget _actionItem(
    String iconPath,
    String count,
    VoidCallback? onTap,
  ) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.network(
          _webAsset(iconPath),
          width: 22,
          height: 22,
          placeholderBuilder: (_) {
            return const Icon(
              Icons.circle,
              color: Colors.white,
              size: 18,
            );
          },
        ),
        const SizedBox(height: 3),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    if (onTap == null) {
      return Opacity(opacity: 0.92, child: child);
    }

    return InkWell(
      onTap: onTap,
      child: child,
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

  void _showImages(FavoriteUser user) {
    if (user.images.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) {
        return _MediaDialog(
          title: user.username,
          itemCount: user.images.length,
          itemBuilder: (context, index) {
            return InteractiveViewer(
              child: Image.network(
                _resolveMediaUrl(user.images[index].profileImage),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 60,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showVideos(FavoriteUser user) {
    if (user.videos.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) {
        return _MediaDialog(
          title: user.username,
          itemCount: user.videos.length,
          itemBuilder: (context, index) {
            return _NetworkVideoPlayer(
              url: _resolveMediaUrl(user.videos[index].video),
            );
          },
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
            onPressed: _loadFavorites,
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
            'No Record Found',
            style: TextStyle(
              color: _primary,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "You haven't added any profiles to your favourites yet. Start exploring and save your favourite connections!",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UpgradePage()),
                      );
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

class _MediaDialog extends StatefulWidget {
  const _MediaDialog({
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  });

  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<_MediaDialog> createState() => _MediaDialogState();
}

class _MediaDialogState extends State<_MediaDialog> {
  final PageController _pageController = PageController();

  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${_index + 1}/${widget.itemCount}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.itemCount,
                onPageChanged: (v) {
                  setState(() {
                    _index = v;
                  });
                },
                itemBuilder: widget.itemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkVideoPlayer extends StatefulWidget {
  const _NetworkVideoPlayer({
    required this.url,
  });

  final String url;

  @override
  State<_NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<_NetworkVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _init;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );

    _init = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError || _controller == null) {
          return const Center(
            child: Icon(
              Icons.videocam_off,
              color: Colors.white,
              size: 64,
            ),
          );
        }

        final controller = _controller!;

        return Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
                if (!controller.value.isPlaying)
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}