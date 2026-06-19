// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/providers/user_list_provider.dart';
// import '../chat_screen.dart';

// class FriendsPage extends ConsumerWidget {
//   const FriendsPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(userListProvider('friends'));

//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F1A),
//       appBar: AppBar(
//         title: const Text(
//           'MY FRIENDS',
//           style: TextStyle(
//             fontWeight: FontWeight.w900,
//             color: Colors.white,
//             letterSpacing: 2.0,
//             fontSize: 16,
//           ),
//         ),
//         backgroundColor: const Color(0xFF0F0F1A),
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: state.isLoading && state.users.isEmpty
//           ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
//           : state.users.isEmpty
//               ? _buildEmptyState()
//               : RefreshIndicator(
//                   color: Colors.pinkAccent,
//                   onRefresh: () => ref.read(userListProvider('friends').notifier).fetchUsers(),
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: state.users.length,
//                     itemBuilder: (context, index) {
//                       final user = state.users[index];
//                       return _buildFriendTile(context, ref, user);
//                     },
//                   ),
//                 ),
//     );
//   }

//   Widget _buildFriendTile(BuildContext context, WidgetRef ref, UserListItem user) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         leading: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: user.isOnline ? Colors.greenAccent : Colors.transparent,
//               width: 2,
//             ),
//           ),
//           child: CircleAvatar(
//             radius: 28,
//             backgroundColor: Colors.white10,
//             backgroundImage: user.imageUrl.startsWith('assets/')
//                 ? AssetImage(user.imageUrl) as ImageProvider
//                 : NetworkImage(user.imageUrl),
//           ),
//         ),
//         title: Text(
//           user.name,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Row(
//           children: [
//             Container(
//               width: 8,
//               height: 8,
//               decoration: BoxDecoration(
//                 color: user.isOnline ? Colors.greenAccent : Colors.white24,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   if (user.isOnline)
//                     BoxShadow(
//                       color: Colors.greenAccent.withValues(alpha: 0.5),
//                       blurRadius: 4,
//                       spreadRadius: 1,
//                     ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               user.isOnline ? 'Active Now' : 'Offline',
//               style: TextStyle(
//                 color: user.isOnline ? Colors.greenAccent : Colors.white38,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.chat_bubble_outline, color: Colors.pinkAccent, size: 22),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ChatScreen(user: user, recipientId: '', recipientName: '',)),
//                 );
//               },
//             ),
//             PopupMenuButton<String>(
//               icon: const Icon(Icons.more_vert, color: Colors.white54),
//               color: const Color(0xFF1A1A2E),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//               onSelected: (value) async {
//                 if (value == 'remove') {
//                   await ref.read(userListProvider('friends').notifier).removeUser(user.id);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('${user.name} removed from friends')),
//                   );
//                 } else if (value == 'share') {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Profile link copied for ${user.name}')),
//                   );
//                 } else if (value == 'mute') {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Notifications muted for ${user.name}')),
//                   );
//                 } else if (value == 'block') {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('${user.name} has been blocked'),
//                       backgroundColor: Colors.orangeAccent,
//                     ),
//                   );
//                 } else if (value == 'report') {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Report submitted. Thank you for keeping the community safe.'),
//                       backgroundColor: Colors.orangeAccent,
//                     ),
//                   );
//                 }
//               },

//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 'profile',
//                   child: Row(
//                     children: [
//                       Icon(Icons.person_outline, color: Colors.white70, size: 20),
//                       SizedBox(width: 12),
//                       Text('View Profile', style: TextStyle(color: Colors.white70)),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'share',
//                   child: Row(
//                     children: [
//                       Icon(Icons.share_outlined, color: Colors.white70, size: 20),
//                       SizedBox(width: 12),
//                       Text('Share Profile', style: TextStyle(color: Colors.white70)),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'mute',
//                   child: Row(
//                     children: [
//                       Icon(Icons.notifications_off_outlined, color: Colors.white70, size: 20),
//                       SizedBox(width: 12),
//                       Text('Mute Notifications', style: TextStyle(color: Colors.white70)),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuDivider(height: 1),
//                 const PopupMenuItem(
//                   value: 'block',
//                   child: Row(
//                     children: [
//                       Icon(Icons.block, color: Colors.orangeAccent, size: 20),
//                       SizedBox(width: 12),
//                       Text('Block User', style: TextStyle(color: Colors.orangeAccent)),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'report',
//                   child: Row(
//                     children: [
//                       Icon(Icons.report_problem_outlined, color: Colors.orangeAccent, size: 20),
//                       SizedBox(width: 12),
//                       Text('Report User', style: TextStyle(color: Colors.orangeAccent)),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'remove',
//                   child: Row(
//                     children: [
//                       Icon(Icons.person_remove_outlined, color: Colors.redAccent, size: 20),
//                       SizedBox(width: 12),
//                       Text('Remove Friend', style: TextStyle(color: Colors.redAccent)),
//                     ],
//                   ),
//                 ),
//               ],

//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(30),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.05),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(Icons.people_outline, size: 80, color: Colors.white.withValues(alpha: 0.1)),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'NO FRIENDS YET',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w900,
//               color: Colors.white24,
//               letterSpacing: 2,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Start connecting with people near you!',
//             style: TextStyle(color: Colors.white12, fontSize: 13),
//           ),
//         ],
//       ),
//     );
//   }
// }



// Beat Flirt /friend screen converted from https://beatflirtevent.com/friend
//
// Required pubspec dependencies:
//   http: ^1.2.2
//   shared_preferences: ^2.3.2
//   flutter_svg: ^2.0.10+1
//   geocoding: ^3.0.0
//   video_player: ^2.9.2
//
// AndroidManifest.xml needs INTERNET permission:
//   <uses-permission android:name="android.permission.INTERNET" />

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'upgrade_page.dart';

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
  if (value.startsWith('/assets/')) return '${_webBase}${value.substring(1)}';
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

class BeatApiException implements Exception {
  BeatApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BeatFriendApi {
  BeatFriendApi({
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
      throw BeatApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw BeatApiException('Unexpected API response');
  }

  /// Website API: POST /feed/get_all_friend_request
  Future<List<FriendUser>> getAllFriendRequest(FriendFilter filter) async {
    final json = await _post('/feed/get_all_friend_request', filter.toJson());
    if (_okStatus(json['status'])) {
      final data = json['data'];
      if (data is List) return data.map((e) => FriendUser.fromJson(Map<String, dynamic>.from(e))).toList();
      return <FriendUser>[];
    }

    final message = _string(json['message']);
    if (message.toLowerCase().contains('token')) {
      throw BeatApiException(message);
    }
    return <FriendUser>[];
  }

  /// Website API: POST /feed/accept_friend_request
  /// status: "1" = Accept, "2" = Decline
  Future<String> acceptFriendRequest({required String senderId, required String status}) async {
    final json = await _post('/feed/accept_friend_request', {
      'sendor_id': senderId,
      'status': status,
    });
    final message = _string(json['message'], _okStatus(json['status']) ? 'Success' : 'Request failed');
    if (!_okStatus(json['status'])) throw BeatApiException(message);
    return message;
  }

  /// Website API: POST /user/create_chat_room
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
    if (!_okStatus(json['status']) && _string(json['message']).toLowerCase().contains('token')) {
      throw BeatApiException(_string(json['message'], 'Unable to create chat room'));
    }
  }

  /// Common layout API used by the web header before opening this page.
  /// It returns membership_expire; the Angular code stores it as `membership`.
  Future<String?> checkLoginUserMembership() async {
    final json = await _post('/user/check_login_user_membership');
    return json['membership_expire']?.toString();
  }

  /// Optional common layout count API, included because the web shell calls it.
  Future<Map<String, dynamic>> notificationAllCount() => _get('/notification/all_count');
}

class FriendFilter {
  const FriendFilter({
    this.type = 'all',
    this.searchKeyword = '',
    this.locationText = '',
    this.lat = '0',
    this.lng = '0',
    this.city = '0',
    this.profileTypeArray = const <String>[],
  });

  final String type; // send, pending, denied, latest, all
  final String searchKeyword;
  final String locationText;
  final String lat;
  final String lng;
  final String city;
  final List<String> profileTypeArray; // Couple, Female, Male, Transgender

  FriendFilter copyWith({
    String? type,
    String? searchKeyword,
    String? locationText,
    String? lat,
    String? lng,
    String? city,
    List<String>? profileTypeArray,
  }) {
    return FriendFilter(
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
        // Initial Angular request sends search_keyword; filter submit sends keyword.
        // Sending both keeps the screen compatible with the current backend.
        'search_keyword': searchKeyword,
        'keyword': searchKeyword,
        'lat': lat,
        'lng': lng,
        'city': city,
        'profileTypeArray': profileTypeArray,
      };
}

class FriendUserImage {
  FriendUserImage({required this.profileImage});
  final String profileImage;

  factory FriendUserImage.fromJson(Map<String, dynamic> json) => FriendUserImage(
        profileImage: _string(json['profile_image']),
      );
}

class FriendUserVideo {
  FriendUserVideo({required this.video});
  final String video;

  factory FriendUserVideo.fromJson(Map<String, dynamic> json) => FriendUserVideo(
        video: _string(json['video']),
      );
}

class FriendUser {
  FriendUser({
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
  final List<FriendUserImage> images;
  final List<FriendUserVideo> videos;

  factory FriendUser.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] is List ? json['image'] as List : const [];
    final videoList = json['video'] is List ? json['video'] as List : const [];
    return FriendUser(
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
          .map((e) => FriendUserImage.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      videos: videoList
          .whereType<Map>()
          .map((e) => FriendUserVideo.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first.profileImage : '';

  bool flag(String key) => raw[key]?.toString() == '1';
}

class FriendsPage extends StatefulWidget {
  const FriendsPage({
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
    this.onFindFriends,
  });

  /// Pass your own API instance or pass accessToken/accessSign.
  /// If neither is passed, the widget reads SharedPreferences keys:
  /// Access-Token, Access-Sign, user-id, membership.
  final BeatFriendApi? api;
  final String? accessToken;
  final String? accessSign;
  final String? loginUserId;
  final String? membershipValue;

  /// The Angular app checks /user/check_login_user_membership in the shell header.
  /// Keep true when using this as a standalone Flutter screen.
  final bool autoCheckMembership;

  /// The website stores membership_expire as `membership`; current Angular logic
  /// locks cards when that value is "Yes".
  final bool lockCardsWhenMembershipValueIsYes;

  final void Function(BuildContext context, FriendUser user)? onOpenProfile;
  final void Function(BuildContext context, FriendUser user)? onOpenMessenger;
  final VoidCallback? onOpenMembership;
  final VoidCallback? onFindFriends;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  BeatFriendApi? _api;
  FriendFilter _filter = const FriendFilter();
  List<FriendUser> _friends = <FriendUser>[];
  bool _booting = true;
  bool _loading = false;
  String? _error;
  String _loginUserId = '';
  String _membershipValue = '';

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  static const Color _lightBg = Color(0xFFFFF4FA);
  static const Color _primary = Color(0xFF1D042A);
  static const Color _maroon = Color(0xFF560827);
  static const Color _pink = Color(0xFFE91E63);
  static const Color _navy = Color(0xFF06032C);

  bool get _pendingMode => _filter.type == 'pending';

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
      _membershipValue = widget.membershipValue ?? prefs.getString('membership') ?? '';
      _api = widget.api ?? BeatFriendApi(accessToken: token, accessSign: sign);

      if (widget.autoCheckMembership && token.isNotEmpty && sign.isNotEmpty) {
        final membershipExpire = await _api!.checkLoginUserMembership();
        if (membershipExpire != null) {
          _membershipValue = membershipExpire;
          await prefs.setString('membership', membershipExpire);
        }
      }

      if (!mounted) return;
      setState(() => _booting = false);
      await _loadFriends();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _booting = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadFriends() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await api.getAllFriendRequest(_filter);
      if (!mounted) return;
      setState(() => _friends = data);
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

  Future<void> _acceptDecline(FriendUser user, String status) async {
    final api = _api;
    if (api == null) return;
    setState(() => _loading = true);
    try {
      final message = await api.acceptFriendRequest(senderId: user.id, status: status);
      _snack(message);
      await _loadFriends();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _chat(FriendUser user) async {
    final api = _api;
    if (api == null) return;
    setState(() => _loading = true);
    try {
      await api.createChatRoom(fromUser: _loginUserId, toUser: user.id, lastLogin: user.lastLogin);
      if (!mounted) return;
      if (widget.onOpenMessenger != null) {
        widget.onOpenMessenger!(context, user);
      } else {
        Navigator.pushNamed(context, '/messenger', arguments: {'userid': _btoa(user.email)});
      }
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openProfile(FriendUser user) {
    if (widget.onOpenProfile != null) {
      widget.onOpenProfile!(context, user);
      return;
    }
    final route = user.profileType == 'couple' ? '/couple-user-profile' : '/single-user-profile';
    Navigator.pushNamed(context, route, arguments: {'user_id': _btoa(user.id)});
  }

  Future<void> _openFilterSheet() async {
    _searchController.text = _filter.searchKeyword;
    _locationController.text = _filter.locationText;
    var draft = _filter;
    var resolvingLocation = false;

    final result = await showModalBottomSheet<FriendFilter>(
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
                  // Keep original web fallback: 0/0 when no Google place is selected.
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

            Widget radio(String label, String value) => InkWell(
                  onTap: () => setModalState(() => draft = draft.copyWith(type: value)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: value,
                          groupValue: draft.type,
                          activeColor: Colors.white,
                          fillColor: MaterialStateProperty.all(Colors.white),
                          onChanged: (v) => setModalState(() => draft = draft.copyWith(type: v)),
                        ),
                        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ),
                );

            Widget checkbox(String label, String value, Color dotColor) {
              final checked = draft.profileTypeArray.contains(value);
              return InkWell(
                onTap: () {
                  final next = List<String>.from(draft.profileTypeArray);
                  checked ? next.remove(value) : next.add(value);
                  setModalState(() => draft = draft.copyWith(profileTypeArray: next));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_maroon, _navy],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
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
                        const Text('Request Status', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 0,
                          children: [
                            radio('Send', 'send'),
                            radio('Pending', 'pending'),
                            radio('Denied', 'denied'),
                            radio('Latest', 'latest'),
                            radio('All', 'all'),
                          ],
                        ),
                        const Divider(color: Colors.white30, height: 16),
                        const Text('Profile Types', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 0,
                          children: [
                            checkbox('Couples', 'Couple', Colors.red),
                            checkbox('Females', 'Female', Colors.pink),
                            checkbox('Males', 'Male', Colors.orange),
                            checkbox('Trans', 'Transgender', Colors.yellow),
                          ],
                        ),
                        const Divider(color: Colors.white30, height: 16),
                        Row(
                          children: [
                            Expanded(child: _filterTextField(_searchController, 'Username...')),
                            const SizedBox(width: 8),
                            Expanded(child: _filterTextField(_locationController, 'Location...')),
                          ],
                        ),
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
      await _loadFriends();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Friends'),
        // title: _header(),
        title: RichText(
            text: TextSpan(
              text: 'Friends ',
              style: const TextStyle(color: _primary, fontSize: 22, fontWeight: FontWeight.w600),
              children: [
                if (_friends.isNotEmpty)
                  TextSpan(text: '(${_friends.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadFriends,
              color: _maroon,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _header(),
                  if (_booting) const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: CircularProgressIndicator(color: _maroon)),
                  ) else if (_error != null) ...[
                    _errorBox(_error!),
                  ] else if (_friends.isEmpty && !_loading) ...[
                    _noData(),
                  ] else ...[
                    const SizedBox(height: 16),
                    _friendGrid(),
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
      mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Flexible(
        //   child: RichText(
        //     text: TextSpan(
        //       text: 'Friends ',
        //       style: const TextStyle(color: _primary, fontSize: 26, fontWeight: FontWeight.w600),
        //       children: [
        //         if (_friends.isNotEmpty)
        //           TextSpan(text: '(${_friends.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        //       ],
        //     ),
        //   ),
        // ),
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
              placeholderBuilder: (_) => const Icon(Icons.filter_alt, size: 20, color: _maroon),
            ),
          ),
        ),
      ],
    );
  }

  Widget _friendGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 920 ? 4 : width >= 620 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _friends.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 20,
            mainAxisExtent: 505,
          ),
          itemBuilder: (context, index) {
            final user = _friends[index];
            if (_lockedByMembership) {
              return _lockedCard();
            }
            return _friendCard(user);
          },
        );
      },
    );
  }

  Widget _friendCard(FriendUser user) {
    final imageCount = user.images.length;
    final videoCount = user.videos.length;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
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
            boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 40, offset: Offset(0, 20))],
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
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.age2.isNotEmpty ? 'Age ${user.age} | ${user.age2}' : 'Age ${user.age}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 8),
                _genderIcons(user),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: _pink, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    user.genderProfileType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
                        errorBuilder: (_, __, ___) => const Icon(Icons.chat_bubble, color: Colors.white),
                      ),
                    ),
                  ),
                if (_pendingMode) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _smallButton('Accept', _maroon, () => _acceptDecline(user, '1')),
                      const SizedBox(width: 8),
                      _smallButton('Decline', const Color(0xFFFF8A00), () => _acceptDecline(user, '2')),
                    ],
                  ),
                ],
                const Spacer(),
                _actionBar(user, imageCount, videoCount),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => _showImages(user),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _pink, width: 4),
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: _networkImage(user.primaryImage, fit: BoxFit.cover),
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
          gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
          boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 40, offset: Offset(0, 20))],
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
                errorBuilder: (_, __, ___) => const Icon(Icons.lock, color: Colors.white, size: 54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderIcons(FriendUser user) {
    final icons = <String>[];
    if (user.flag('couple_male_female_swingers')) icons.add('assets/img/icons/couple-logo.svg');
    if (user.flag('couple_female_female_swingers')) icons.add('assets/img/icons/female-logo.svg');
    if (user.flag('couple_male_male_swingers')) icons.add('assets/img/icons/male-logo.svg');
    if (user.flag('couple_male_swingers')) icons.add('assets/img/icons/single-male.svg');
    if (user.flag('couple_female_swingers')) icons.add('assets/img/icons/single-female.svg');
    if (user.flag('couple_transgender_swingers')) icons.add('assets/img/icons/transgender-logo.svg');

    if (icons.isEmpty) return const SizedBox(height: 20);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: icons
          .map(
            (path) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: SvgPicture.network(
                _webAsset(path),
                width: 20,
                height: 20,
                placeholderBuilder: (_) => const SizedBox(width: 20, height: 20),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _locationLine(FriendUser user) {
    final distanceText = '${user.totalDistance} ${user.distance}'.trim();
    final parts = <String>[
      if (user.formattedAddress.isNotEmpty) user.formattedAddress,
      if (distanceText.isNotEmpty) distanceText,
    ];
    final text = parts.join(' | ');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: Colors.white, size: 20),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _smallButton(String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _actionBar(FriendUser user, int imageCount, int videoCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionItem('assets/img/icons/camera.svg', '$imageCount', imageCount > 0 ? () => _showImages(user) : null),
          _actionItem('assets/img/icons/like.svg', '${user.likesCount}', null),
          _actionItem('assets/img/icons/people.svg', '${user.friendsCount}', null),
          _actionItem('assets/img/icons/share.svg', '${user.validationCount}', null),
          _actionItem('assets/img/icons/video.svg', '$videoCount', videoCount > 0 ? () => _showVideos(user) : null),
        ],
      ),
    );
  }

  Widget _actionItem(String iconPath, String count, VoidCallback? onTap) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.network(
          _webAsset(iconPath),
          width: 22,
          height: 22,
          placeholderBuilder: (_) => const Icon(Icons.circle, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 3),
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
    if (onTap == null) return Opacity(opacity: 0.92, child: child);
    return InkWell(onTap: onTap, child: child);
  }

  Widget _networkImage(String rawUrl, {BoxFit fit = BoxFit.cover}) {
    final url = _resolveMediaUrl(rawUrl);
    if (url.isEmpty) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const Icon(Icons.person, color: _maroon, size: 46),
      );
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const Icon(Icons.person, color: _maroon, size: 46),
      ),
      loadingBuilder: (context, child, loading) {
        if (loading == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: _maroon));
      },
    );
  }

  void _showImages(FriendUser user) {
    if (user.images.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => _MediaDialog(
        title: user.username,
        itemCount: user.images.length,
        itemBuilder: (context, index) => InteractiveViewer(
          child: Image.network(
            _resolveMediaUrl(user.images[index].profileImage),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white, size: 60),
          ),
        ),
      ),
    );
  }

  void _showVideos(FriendUser user) {
    if (user.videos.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => _MediaDialog(
        title: user.username,
        itemCount: user.videos.length,
        itemBuilder: (context, index) => _NetworkVideoPlayer(url: _resolveMediaUrl(user.videos[index].video)),
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
            onPressed: _loadFriends,
            style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _noData() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 30, offset: Offset(0, 10))],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(color: Color(0x1A01529C), shape: BoxShape.circle),
            child: const Icon(Icons.person_off_outlined, size: 62, color: _maroon),
          ),
          const SizedBox(height: 25),
          const Text('No New Friend', style: TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 24)),
          const SizedBox(height: 10),
          const Text(
            "It looks like you don't have any incoming friend at the moment. Why not explore and find some interesting people?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF777777), fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: widget.onFindFriends ?? () => Navigator.pushNamed(context, '/online'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _maroon,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
            icon: const Icon(Icons.search, size: 20),
            label: const Text('Find Friends'),
          ),
        ],
      ),
    );
  }

  void _showMembershipDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Beat Flirt Team!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text(
                '"You have not purchased a Beat Flirt membership plan. Buy membership"',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
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
      ),
    );
  }
}

class _MediaDialog extends StatefulWidget {
  const _MediaDialog({required this.title, required this.itemCount, required this.itemBuilder});

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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text('${_index + 1}/${widget.itemCount}', style: const TextStyle(color: Colors.white70)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.itemCount,
                onPageChanged: (v) => setState(() => _index = v),
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
  const _NetworkVideoPlayer({required this.url});

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
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
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
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snapshot.hasError || _controller == null) {
          return const Center(child: Icon(Icons.videocam_off, color: Colors.white, size: 64));
        }
        final controller = _controller!;
        return Center(
          child: GestureDetector(
            onTap: () {
              setState(() => controller.value.isPlaying ? controller.pause() : controller.play());
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
                if (!controller.value.isPlaying)
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 52),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
