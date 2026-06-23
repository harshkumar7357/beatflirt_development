// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:beatflirt/core/services/auth_services.dart';

// const String BASE_URL = 'https://app.beatflirtevent.com/App';

// class ProfileApi {
//   static String? _token;
//   static int? currentUserId;

//   static Future<Map<String, String>> getHeaders() async {
//     final token = await AuthService.getToken();
//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       if (token != null && token.isNotEmpty) ...{
//         'Authorization': 'Bearer $token',
//         'access-token': token,
//       }
//     };
//   }

//   static Future<void> loadToken() async {
//     _token = await AuthService.getToken();
//     final userIdStr = await AuthService.getUserId();
//     if (userIdStr != null) {
//       currentUserId = int.tryParse(userIdStr);
//     }
//   }

//   // ==================== SINGLE USER PROFILE ====================
//   static Future<Map<String, dynamic>?> getSingleUserProfile(int userId) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/profile/signle_user_profile'),
//       headers: await getHeaders(),
//       body: jsonEncode({"user_id": userId.toString()}),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['status'] == "200" ? data['data'] : null;
//     }
//     return null;
//   }

//   // ==================== PROFILE IMAGES ====================
//   static Future<List<String>> getUserProfileImages(int userId) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/profile/signle_user_profile_image'),
//       headers: await getHeaders(),
//       body: jsonEncode({"user_id": userId.toString()}),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == "200" && data['data'] != null) {
//         return (data['data'] as List).map((e) => e['profile_image'].toString()).toList();
//       }
//     }
//     return [];
//   }

//   // ==================== ACTIONS ====================
//   static Future<bool> sendLike(int userId, int status) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$BASE_URL/profile/send_like'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//         "status": status.toString()
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> sendFriendRequest(int userId) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$BASE_URL/profile/send_friend_request'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString()
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> sendValidate(int userId, String message) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$BASE_URL/profile/send_validate'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//         "message": message
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> sendRemember(int userId) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$BASE_URL/profile/send_remember'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString()
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> sendNotes(int userId, String message) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$BASE_URL/profile/send_notes'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString(),
//         "message": message
//       }),
//     );
//     return res.statusCode == 200;
//   }

//   static Future<bool> blockUser(int userId) async {
//     if (currentUserId == null) return false;
//     final res = await http.post(
//       Uri.parse('$BASE_URL/profile/send_block'),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "sendor_id": currentUserId.toString(),
//         "recieved_id": userId.toString()
//       }),
//     );
//     return res.statusCode == 200;
//   }
// }

// // ============================================================
// //                 SINGLE USER PROFILE SCREEN
// // ============================================================

// class SingleUserProfileScreen extends StatefulWidget {
//   final int userId;
//   const SingleUserProfileScreen({super.key, required this.userId});

//   @override
//   State<SingleUserProfileScreen> createState() => _SingleUserProfileScreenState();
// }

// class _SingleUserProfileScreenState extends State<SingleUserProfileScreen> {
//   Map<String, dynamic>? profile;
//   List<String> images = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     setState(() => isLoading = true);
//     await ProfileApi.loadToken();
//     profile = await ProfileApi.getSingleUserProfile(widget.userId);
//     images = await ProfileApi.getUserProfileImages(widget.userId);
//     setState(() => isLoading = false);
//   }

//   Future<void> _performAction(String action, Future<bool> Function() apiCall) async {
//     final success = await apiCall();
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('$action successful'), backgroundColor: Colors.green),
//       );
//       _loadProfile();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('$action failed')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F5F5),
//       appBar: AppBar(title: const Text('Profile')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : profile == null
//               ? const Center(child: Text('Profile not found'))
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       // Profile Card
//                       Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF2D1B3D),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Column(
//                           children: [
//                             if (images.isNotEmpty)
//                               ClipRRect(
//                                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
//                                 child: Image.network(images[0], height: 280, width: double.infinity, fit: BoxFit.cover),
//                               ),
//                             Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(profile!['username'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                                   Text('${profile!['age']} | 0 Years', style: const TextStyle(color: Colors.white70)),
//                                   Text(profile!['gender_profile_type'] ?? '', style: const TextStyle(color: Colors.white70)),
//                                   Text(profile!['address'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                               child: Column(
//                                 children: [
//                                   _buildSidebarItem('Already Friends', 5, Icons.people),
//                                   _buildSidebarItem('Like', 3, Icons.thumb_up),
//                                   _buildSidebarItem('Validate Pending', 4, Icons.verified),
//                                   _buildSidebarItem('Already remember', 3, Icons.favorite),
//                                   _buildSidebarItem('Notes', 3, Icons.note),
//                                   _buildSidebarItem('Block User', 0, Icons.block, isDestructive: true),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Swingers & HookUps
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Swingers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 _buildGenderIcon('♂♀', profile!['couple_male_female_swingers'] == "1"),
//                                 _buildGenderIcon('♀♀', profile!['couple_female_female_swingers'] == "1"),
//                                 _buildGenderIcon('♂♂', profile!['couple_male_male_swingers'] == "1"),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             const Text('HookUps/Meetups', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 _buildGenderIcon('♂♀', profile!['couple_male_female_hookup_meetup'] == "1"),
//                                 _buildGenderIcon('♀♀', profile!['couple_female_female_hookup_meetup'] == "1"),
//                                 _buildGenderIcon('♂♂', profile!['couple_male_male_hookup_meetup'] == "1"),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Questions
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildQuestionBubble('Age', '${profile!['age']} Years'),
//                             _buildQuestionBubble('Tattoos', profile!['person1_tattoos'] ?? 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Body Hair', 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Weight', 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Height', 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Smoking', profile!['person1_smoking'] ?? 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Drinking', profile!['person1_drinking'] ?? 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Body Type', profile!['person1_body_type'] ?? 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Language Spoken', 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Ethnic Background', 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Piercings', 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Circumcised', 'Im not comfortable sharing that'),
//                             _buildQuestionBubble('Sexuality', 'Im not comfortable sharing that'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   Widget _buildSidebarItem(String title, int count, IconData icon, {bool isDestructive = false}) {
//     return ListTile(
//       leading: Icon(icon, color: isDestructive ? Colors.red : Colors.white70),
//       title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : Colors.white)),
//       trailing: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
//         child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//       onTap: () {
//         if (title == 'Like') _performAction('Like', () => ProfileApi.sendLike(widget.userId, 1));
//         if (title == 'Block User') _performAction('Block', () => ProfileApi.blockUser(widget.userId));
//         if (title == 'Already Friends') _performAction('Friend Request', () => ProfileApi.sendFriendRequest(widget.userId));
//         if (title == 'Validate Pending') _performAction('Validate', () => ProfileApi.sendValidate(widget.userId, "Verified"));
//         if (title == 'Already remember') _performAction('Remember', () => ProfileApi.sendRemember(widget.userId));
//         if (title == 'Notes') _performAction('Note', () => ProfileApi.sendNotes(widget.userId, "Nice profile!"));
//       },
//     );
//   }

//   Widget _buildQuestionBubble(String question, String answer) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(color: const Color(0xFF2D1B3D), borderRadius: BorderRadius.circular(20)),
//             child: Text(question, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
//               child: Text(answer, style: const TextStyle(color: Colors.black87)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGenderIcon(String label, bool active) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: active ? const Color(0xFFE91E63).withOpacity(0.15) : Colors.grey[200],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(label, style: TextStyle(fontSize: 18, color: active ? const Color(0xFFE91E63) : Colors.grey)),
//     );
//   }
// }

// Beat Flirt single-user-profile screen converted from:
// https://beatflirtevent.com/single-user-profile?user_id=NDI0
//
// Required pubspec dependencies:
//   http: ^1.2.2
//   shared_preferences: ^2.3.2
//   flutter_svg: ^2.0.10+1
//   video_player: ^2.9.2
//
// AndroidManifest.xml:
//   <uses-permission android:name="android.permission.INTERNET" />

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:beatflirt/screens/drawer_pages/blocklist_page.dart';

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

String _decodeUserId(String value) {
  if (value.isEmpty) return value;
  try {
    return utf8.decode(base64Decode(value));
  } catch (_) {
    return value;
  }
}

bool _okStatus(dynamic status) => status?.toString() == '200';

String _s(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.isEmpty ? fallback : text;
}

int _i(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? fallback;
}

double? _d(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

class BeatProfileApiException implements Exception {
  BeatProfileApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BeatSingleProfileApi {
  BeatSingleProfileApi({
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

  Future<Map<String, dynamic>> _post(String path, [Map<String, dynamic>? body]) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BeatProfileApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw BeatProfileApiException('Unexpected API response');
  }

  Future<bool> checkUserBlocked({required String profileUserId, required String loginUserId}) async {
    final json = await _post('/profile/check_user_blocked', {
      'profile_user_id': profileUserId,
      'login_user_id': loginUserId,
    });
    return _okStatus(json['status']) && json['data']?.toString() == '1';
  }

  Future<SingleUserProfile> getProfile(String userId) async {
    final json = await _post('/profile/signle_user_profile', {'user_id': userId});
    if (_okStatus(json['status'])) {
      return SingleUserProfile(Map<String, dynamic>.from(json['data'] as Map));
    }
    throw BeatProfileApiException(_s(json['message'], 'Unable to load profile'));
  }

  Future<List<ProfileImage>> getProfileImages(String userId) async {
    final json = await _post('/profile/signle_user_profile_image', {'user_id': userId});
    if (!_okStatus(json['status'])) return <ProfileImage>[];
    final data = json['data'];
    if (data is! List) return <ProfileImage>[];
    return data.whereType<Map>().map((e) => ProfileImage(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<ProfileAlbum>> getAlbums(String userId) async {
    final json = await _post('/profile/get_all_album', {'user_id': userId});
    if (!_okStatus(json['status'])) return <ProfileAlbum>[];
    final data = json['data'];
    if (data is! List) return <ProfileAlbum>[];
    return data.whereType<Map>().map((e) => ProfileAlbum(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<ProfileVideo>> getApprovedVideos(String userId) async {
    final json = await _post('/profile/signle_user_profile_approve_video', {'user_id': userId});
    if (!_okStatus(json['status'])) return <ProfileVideo>[];
    final data = json['data'];
    if (data is! List) return <ProfileVideo>[];
    return data.whereType<Map>().map((e) => ProfileVideo(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<AlbumMedia>> getAlbumMedia({required String albumId, required String userId}) async {
    final json = await _post('/profile/get_album_image', {
      'album_id': albumId,
      'user_id': userId,
    });
    if (!_okStatus(json['status'])) return <AlbumMedia>[];
    final data = json['data'];
    if (data is! List) return <AlbumMedia>[];
    return data.whereType<Map>().map((e) => AlbumMedia(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> insertWhoIViewed({required String loginUserId, required String profileUserId}) async {
    await _post('/profile/who_i_viewed_insert', {
      'login_user_id': loginUserId,
      'profile_user_id': profileUserId,
    });
  }

  Future<ProfileInteractionState> getInteractionState({required String profileUserId, required String loginUserId}) async {
    Future<Map<String, dynamic>> call(String path) => _post(path, {
          'recieved_id': profileUserId,
          'login_user_id': loginUserId,
        });

    final friend = await call('/profile/view_friend_request');
    final like = await call('/profile/view_like_request');
    final validate = await call('/profile/view_validate_request');
    final remember = await call('/profile/view_remember_request');
    final notes = await call('/profile/view_notes_request');

    return ProfileInteractionState(
      friendCount: _count(friend),
      friendStatus: _requestStatus(friend),
      likeCount: _count(like),
      likeStatus: _requestStatus(like),
      validateCount: _count(validate),
      validateStatus: _requestStatus(validate),
      rememberCount: _count(remember),
      rememberStatus: _requestStatus(remember),
      notesCount: _count(notes),
      notesStatus: _requestStatus(notes),
    );
  }

  static int _count(Map<String, dynamic> json) {
    if (!_okStatus(json['status']) || json['data'] is! Map) return 0;
    return _i((json['data'] as Map)['all_request_count']);
  }

  static String _requestStatus(Map<String, dynamic> json) {
    if (!_okStatus(json['status']) || json['data'] is! Map) return '';
    return _s((json['data'] as Map)['request_status']);
  }

  Future<String> sendFriendRequest({required String senderId, required String receivedId}) {
    return _action('/profile/send_friend_request', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
    });
  }

  Future<String> sendLike({required String senderId, required String receivedId, required String status}) {
    return _action('/profile/send_like', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
      'status': status,
    });
  }

  Future<String> sendValidate({required String senderId, required String receivedId, required String message}) {
    return _action('/profile/send_validate', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
      'message': message,
    });
  }

  Future<String> deleteValidate({required String senderId, required String receivedId}) {
    return _action('/profile/delete_validate', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
    });
  }

  Future<String> sendRemember({required String senderId, required String receivedId}) {
    return _action('/profile/send_remember', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
    });
  }

  Future<String> sendNotes({required String senderId, required String receivedId, required String message}) {
    return _action('/profile/send_notes', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
      'message': message,
    });
  }

  Future<String?> viewSentNotes({required String senderId, required String receivedId}) async {
    final json = await _post('/profile/view_send_notes', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
    });
    if (_okStatus(json['status']) && json['data'] is Map) {
      return _s((json['data'] as Map)['message']);
    }
    return null;
  }

  Future<String> sendBlock({required String senderId, required String receivedId}) {
    return _action('/profile/send_block', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
    });
  }

  Future<String> _action(String path, Map<String, dynamic> body) async {
    final json = await _post(path, body);
    final message = _s(json['message'], _okStatus(json['status']) ? 'Success' : 'Request failed');
    if (!_okStatus(json['status'])) throw BeatProfileApiException(message);
    return message;
  }
}

class SingleUserProfile {
  SingleUserProfile(this.raw);

  final Map<String, dynamic> raw;

  String get id => _s(raw['id']);
  String get username => _s(raw['username']);
  String get genderProfileType => _s(raw['gender_profile_type'], 'Couple');
  String get address => _s(raw['address']);
  String get address1 => _s(raw['address_1']);
  String get distanceUnit => _s(raw['distance'], 'Km');
  String get text => _s(raw['text']);
  String get comment => _s(raw['comment']);

  String get firstAge => _s(raw['person1_age'], _s(raw['age'], '0'));
  String get secondAge => _s(raw['person2_age'], _s(raw['age2']));

  String get displayAgeLine {
    if (secondAge.isNotEmpty) return '$firstAge | $secondAge Years';
    return '$firstAge Years';
  }

  String value(String key, [String fallback = 'Im not comfortable sharing that']) => _s(raw[key], fallback);
  String valueWithType(String key, String typeKey) {
    final base = value(key);
    final unit = _s(raw[typeKey]);
    return unit.isEmpty || base == 'Im not comfortable sharing that' ? base : '$base $unit';
  }

  bool flag(String key) => raw[key]?.toString() == '1';
}

class ProfileImage {
  ProfileImage(this.raw);
  final Map<String, dynamic> raw;
  String get profileImage => _s(raw['profile_image']);
}

class ProfileAlbum {
  ProfileAlbum(this.raw);
  final Map<String, dynamic> raw;
  String get id => _s(raw['id']);
  String get name => _s(raw['album_name']);
  String get image => _s(raw['image']);
}

class AlbumMedia {
  AlbumMedia(this.raw);
  final Map<String, dynamic> raw;
  bool get isImage => raw['image_status']?.toString() == '1';
  bool get isVideo => raw['video_status']?.toString() == '1';
  String get image => _s(raw['image']);
  String get video => _s(raw['video']);
}

class ProfileVideo {
  ProfileVideo(this.raw);
  final Map<String, dynamic> raw;
  String get profileVideo => _s(raw['profile_video']);
}

class ProfileInteractionState {
  const ProfileInteractionState({
    this.friendCount = 0,
    this.friendStatus = '',
    this.likeCount = 0,
    this.likeStatus = '',
    this.validateCount = 0,
    this.validateStatus = '',
    this.rememberCount = 0,
    this.rememberStatus = '',
    this.notesCount = 0,
    this.notesStatus = '',
  });

  final int friendCount;
  final String friendStatus;
  final int likeCount;
  final String likeStatus;
  final int validateCount;
  final String validateStatus;
  final int rememberCount;
  final String rememberStatus;
  final int notesCount;
  final String notesStatus;
}

class BeatSingleUserProfileScreen extends StatefulWidget {
  const BeatSingleUserProfileScreen({
    super.key,
    this.api,
    this.userId,
    this.encodedUserId,
    this.accessToken,
    this.accessSign,
    this.loginUserId,
    this.showBackButton = true,
    this.onOpenBlockedList,
  });

  /// Pass either raw userId: "424" or encodedUserId: "NDI0".
  final String? userId;
  final String? encodedUserId;

  /// If api is not passed, this screen reads Access-Token, Access-Sign and user-id
  /// from SharedPreferences, same keys used by the Angular website session storage.
  final BeatSingleProfileApi? api;
  final String? accessToken;
  final String? accessSign;
  final String? loginUserId;
  final bool showBackButton;
  final VoidCallback? onOpenBlockedList;

  @override
  State<BeatSingleUserProfileScreen> createState() => _BeatSingleUserProfileScreenState();
}

class _BeatSingleUserProfileScreenState extends State<BeatSingleUserProfileScreen> {
  static const Color _lightBg = Color(0xFFFFF4FA);
  static const Color _maroon = Color(0xFF560827);
  static const Color _navy = Color(0xFF06032C);
  static const Color _pink = Color(0xFFE91E63);
  static const Color _optionPanelColor = Color(0xFF3F0628);

  BeatSingleProfileApi? _api;
  String _userId = '';
  String _loginUserId = '';

  SingleUserProfile? _profile;
  List<ProfileImage> _images = <ProfileImage>[];
  List<ProfileAlbum> _albums = <ProfileAlbum>[];
  List<ProfileVideo> _videos = <ProfileVideo>[];
  ProfileInteractionState _interaction = const ProfileInteractionState();

  bool _loading = true;
  bool _busy = false;
  bool _blocked = false;
  String? _error;
  int _totalDistance = 0;

  @override
  void initState() {
    super.initState();
    _bootstrap();
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

      _userId = widget.userId ?? _decodeUserId(widget.encodedUserId ?? '');
      if (_userId.isEmpty) throw BeatProfileApiException('Missing profile user id');

      _api = widget.api ??
          BeatSingleProfileApi(
            accessToken: token,
            accessSign: sign,
          );
      await _load();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _load() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final blocked = await api.checkUserBlocked(profileUserId: _userId, loginUserId: _loginUserId);
      final profile = await api.getProfile(_userId);
      final images = await api.getProfileImages(_userId);
      final albums = await api.getAlbums(_userId);
      final videos = await api.getApprovedVideos(_userId);
      var interaction = const ProfileInteractionState();
      if (_userId != _loginUserId) {
        try {
          await api.insertWhoIViewed(loginUserId: _loginUserId, profileUserId: _userId);
        } catch (_) {}
        interaction = await api.getInteractionState(profileUserId: _userId, loginUserId: _loginUserId);
      }

      if (!mounted) return;
      setState(() {
        _blocked = blocked;
        _profile = profile;
        _images = images;
        _albums = albums;
        _videos = videos;
        _interaction = interaction;
        _totalDistance = _calculateDistance(profile);
      });
      if (blocked) _showBlockedDialog();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int _calculateDistance(SingleUserProfile profile) {
    final lat = _d(profile.raw['lat']);
    final lng = _d(profile.raw['lng']);
    final lat1 = _d(profile.raw['lat_1']);
    final lng1 = _d(profile.raw['lng_1']);
    if (lat == null || lng == null || lat1 == null || lng1 == null) return _i(profile.raw['total_distance']);
    if (lat == lat1 && lng == lng1) return 0;
    final b = math.pi * lat / 180;
    final g = math.pi * lat1 / 180;
    final re = math.pi * (lng - lng1) / 180;
    var x = math.sin(b) * math.sin(g) + math.cos(b) * math.cos(g) * math.cos(re);
    if (x > 1) x = 1;
    x = math.acos(x) * 180 / math.pi * 60 * 1.1515;
    if (profile.distanceUnit.toLowerCase() == 'km') x *= 1.609344;
    if (profile.distanceUnit.toLowerCase() == 'mi') x *= .8684;
    return x.truncate();
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

  Future<void> _runAction(Future<String> Function(BeatSingleProfileApi api) action) async {
    final api = _api;
    if (api == null) return;
    setState(() => _busy = true);
    try {
      final message = await action(api);
      _snack(message);
      _interaction = await api.getInteractionState(profileUserId: _userId, loginUserId: _loginUserId);
      if (mounted) setState(() {});
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _handleFriendAction() {
    final status = _interaction.friendStatus;
    if (status == 'accepted') return;
    _runAction((api) => api.sendFriendRequest(senderId: _loginUserId, receivedId: _userId));
  }

  void _handleLikeAction() {
    final status = _interaction.likeStatus == 'Like' ? '1' : '0';
    _runAction((api) => api.sendLike(senderId: _loginUserId, receivedId: _userId, status: status));
  }

  void _handleRememberAction() {
    _runAction((api) => api.sendRemember(senderId: _loginUserId, receivedId: _userId));
  }

  Future<void> _showValidateDialog() async {
    final username = _profile?.username ?? '';
    final initialText = 'I hereby certify that the profile from is $username for real';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _TextInputDialog(title: 'Validation', initialText: initialText),
    );
    if (result != null) {
      _runAction((api) => api.sendValidate(senderId: _loginUserId, receivedId: _userId, message: result));
    }
  }

  Future<void> _showNotesDialog() async {
    final initialText = 'I like you profile HANDSOME';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _TextInputDialog(title: 'Notes', initialText: initialText),
    );
    if (result != null) {
      _runAction((api) => api.sendNotes(senderId: _loginUserId, receivedId: _userId, message: result));
    }
  }

  Future<void> _confirmBlock() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: const Text(
          'The user has been blocked. If you wish to unblock the member, you can do so from the contact/block list',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (ok == true) {
      _runAction((api) => api.sendBlock(senderId: _loginUserId, receivedId: _userId));
      widget.onOpenBlockedList?.call();
    }
  }

  void _showBlockedDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: const Text(
            'The user has been blocked. If you wish to unblock the member, you can do so from the contact/block list',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                if (widget.onOpenBlockedList != null) {
                  widget.onOpenBlockedList!();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BlocklistPage(),
                    ),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black ,size:20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: _maroon,
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // if (widget.showBackButton)
                  //   Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: IconButton(
                  //       onPressed: () => Navigator.maybePop(context),
                  //       icon: const Icon(Icons.arrow_back_ios_new, color: _maroon),
                  //     ),
                  //   ),
                  if (_loading && _profile == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: Center(child: CircularProgressIndicator(color: _maroon)),
                    )
                  else if (_error != null)
                    _errorBox(_error!)
                  else if (_profile != null)
                    _profileLayout(_profile!),
                ],
              ),
            ),
            if (_busy || (_loading && _profile != null))
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.04),
                    alignment: Alignment.topCenter,
                    child: const LinearProgressIndicator(minHeight: 3, color: _maroon),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _profileLayout(SingleUserProfile profile) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 820;
          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _leftProfileCard(profile),
                const SizedBox(height: 18),
                _rightDetails(profile),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 285, child: _leftProfileCard(profile)),
              const SizedBox(width: 24),
              Expanded(child: _rightDetails(profile)),
            ],
          );
        },
      ),
    );
  }

  Widget _leftProfileCard(SingleUserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: _images.isEmpty ? null : _showAllImages,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AspectRatio(
                aspectRatio: 1,
                child: _image(_images.isNotEmpty ? _images.first.profileImage : '', fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            profile.username,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _meta(profile.displayAgeLine),
          _meta(profile.genderProfileType),
          if (profile.address.isNotEmpty) _meta(profile.address),
          if (profile.address1.isNotEmpty) _meta('${profile.address1} | $_totalDistance ${profile.distanceUnit}'),
          const SizedBox(height: 10),
          if (_userId != _loginUserId) _optionPanel(),
          const SizedBox(height: 14),
          _bottomInfo(profile),
        ],
      ),
    );
  }

  Widget _meta(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _optionPanel() {
    return Container(
      color: _optionPanelColor,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          if (_interaction.friendStatus.isNotEmpty)
            _optionRow(
              icon: Icons.people_alt_outlined,
              text: _friendText(_interaction.friendStatus),
              count: _interaction.friendCount,
              onTap: _handleFriendAction,
            ),
          if (_interaction.likeStatus.isNotEmpty)
            _optionRow(
              icon: _interaction.likeStatus == 'Like' ? Icons.thumb_up_alt_outlined : Icons.thumb_down_alt_outlined,
              text: _interaction.likeStatus,
              count: _interaction.likeCount,
              onTap: _handleLikeAction,
            ),
          if (_interaction.validateStatus.isNotEmpty)
            _optionRow(
              icon: Icons.person_search_outlined,
              text: _validateText(_interaction.validateStatus),
              count: _interaction.validateCount,
              onTap: _showValidateDialog,
            ),
          if (_interaction.rememberStatus.isNotEmpty)
            _optionRow(
              icon: Icons.favorite_border,
              text: _rememberText(_interaction.rememberStatus),
              count: _interaction.rememberCount,
              onTap: _handleRememberAction,
            ),
          if (_interaction.notesStatus.isNotEmpty)
            _optionRow(
              icon: Icons.article_outlined,
              text: 'Notes',
              count: _interaction.notesCount,
              onTap: _showNotesDialog,
            ),
          _optionRow(icon: Icons.person_off_outlined, text: 'Block User', count: null, onTap: _confirmBlock),
        ],
      ),
    );
  }

  String _friendText(String status) {
    switch (status) {
      case 'nothere':
        return 'Friend Request';
      case 'accepted':
        return 'Request Accepted';
      case 'pending':
        return 'Request Pending';
      case 'request_pending':
        return 'Confirm';
      case 'already_friend':
        return 'Already Friends';
      default:
        return status;
    }
  }

  String _validateText(String status) {
    switch (status) {
      case 'no_request':
        return 'Validate';
      case 'accepted':
        return 'Validate Accepted';
      case 'pending':
        return 'Validate Pending';
      default:
        return status;
    }
  }

  String _rememberText(String status) {
    switch (status) {
      case 'accepted':
        return 'Remember';
      case 'pending':
        return 'Already remember';
      default:
        return status;
    }
  }

  Widget _optionRow({required IconData icon, required String text, required int? count, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))),
            if (count != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Text('$count', style: const TextStyle(color: Colors.black, fontSize: 11)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bottomInfo(SingleUserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasAny(profile, const [
            'couple_male_female_swingers',
            'couple_female_female_swingers',
            'couple_male_male_swingers',
            'couple_male_swingers',
            'couple_female_swingers',
            'couple_transgender_swingers',
          ]))
            _interestBlock(profile, 'Swingers', const {
              'couple_male_female_swingers': 'assets/img/icon/female-male.png',
              'couple_female_female_swingers': 'assets/img/icon/female-female.png',
              'couple_male_male_swingers': 'assets/img/icon/male-male.png',
              'couple_male_swingers': 'assets/img/icon/male.png',
              'couple_female_swingers': 'assets/img/icon/female.png',
              'couple_transgender_swingers': 'assets/img/icon/transgender.png',
            }),
          if (_hasAny(profile, const [
            'couple_male_female_hookup_meetup',
            'couple_female_female_hookup_meetup',
            'couple_male_male_hookup_meetup',
            'couple_male_hookup_meetup',
            'couple_female_hookup_meetup',
            'couple_transgender_hookup_meetup',
          ]))
            _interestBlock(profile, 'HookUps/Meetups', const {
              'couple_male_female_hookup_meetup': 'assets/img/icon/female-male.png',
              'couple_female_female_hookup_meetup': 'assets/img/icon/female-female.png',
              'couple_male_male_hookup_meetup': 'assets/img/icon/male-male.png',
              'couple_male_hookup_meetup': 'assets/img/icon/male.png',
              'couple_female_hookup_meetup': 'assets/img/icon/female.png',
              'couple_transgender_hookup_meetup': 'assets/img/icon/transgender.png',
            }),
          if (profile.text.isNotEmpty || profile.comment.isNotEmpty) ...[
            const Text('Bio', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('${profile.text}\n${profile.comment}'.trim(), style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.35)),
          ],
        ],
      ),
    );
  }

  bool _hasAny(SingleUserProfile profile, List<String> keys) => keys.any(profile.flag);

  Widget _interestBlock(SingleUserProfile profile, String title, Map<String, String> flags) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: flags.entries
                .where((entry) => profile.flag(entry.key))
                .map((entry) => Image.network(_webAsset(entry.value), width: 24, height: 24, errorBuilder: (_, __, ___) => const SizedBox()))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _rightDetails(SingleUserProfile profile) {
    final isCouple = profile.raw['profile_type']?.toString().toLowerCase() == 'couple';
    final details = <_DetailItem>[];

    void addDetail(String label, String key, {String? typeKey}) {
      final val1 = typeKey != null 
          ? profile.valueWithType('person1_$key', typeKey) 
          : profile.value('person1_$key');
          
      if (isCouple) {
        final val2 = typeKey != null 
            ? profile.valueWithType('person2_$key', typeKey.replaceAll('1', '2')) 
            : profile.value('person2_$key');
        details.add(_DetailItem(label, val1, value2: val2));
      } else {
        details.add(_DetailItem(label, val1));
      }
    }

    addDetail('Tattoos', 'tattoos');
    addDetail('Body Hair', 'body_hair');
    addDetail('Weight', 'weight', typeKey: 'weight1_type');
    addDetail('Height', 'height', typeKey: 'height1_type');
    addDetail('Smoking', 'smoking');
    addDetail('Drinking', 'drinking');
    addDetail('Body Type', 'body_type');
    addDetail('Language Spoken', 'language_spoken');
    addDetail('Ethnic Background', 'ethnic_background');
    addDetail('Piercings', 'piercings');
    addDetail('Intelligence as importance', 'intelligence_importance');
    addDetail('Looks are Important', 'looks_important');
    addDetail('Relationship Orientation', 'relationship_orientation');
    addDetail('Circumcised', 'circumcised');
    addDetail('Sexuality', 'sexuality');

    bool isMeaningful(String? val) {
      if (val == null) return false;
      final clean = val.trim().toLowerCase();
      if (clean.isEmpty) return false;
      if (clean.contains('not comfortable sharing') || clean == 'n/a' || clean == 'null') return false;
      return true;
    }

    final filteredDetails = details.where((item) {
      if (isCouple) {
        return isMeaningful(item.value) || isMeaningful(item.value2);
      } else {
        return isMeaningful(item.value);
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _agePill(profile),
        const SizedBox(height: 14),
        ...filteredDetails.map((item) => _detailRow(profile, item)),
        const SizedBox(height: 18),
        _mediaButtons(),
      ],
    );
  }

  Widget _agePill(SingleUserProfile profile) {
    final isCouple = profile.raw['profile_type']?.toString().toLowerCase() == 'couple';
    final genders = profile.genderProfileType.split('|').map((e) => e.trim()).toList();
    final firstGender = genders.isNotEmpty ? genders[0] : '';
    final secondGender = genders.length > 1 ? genders[1] : '';

    if (isCouple) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6DFF0)),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Age',
              style: TextStyle(
                color: _maroon,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _genderCircleFor(firstGender),
                      const SizedBox(width: 8),
                      Text(
                        '${profile.firstAge} Years',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      _genderCircleFor(secondGender),
                      const SizedBox(width: 8),
                      Text(
                        '${profile.secondAge} Years',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6DFF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Age',
              style: TextStyle(
                color: _maroon,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _genderCircleFor(firstGender.isNotEmpty ? firstGender : profile.genderProfileType),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              '${profile.firstAge} Years',
              style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(SingleUserProfile profile, _DetailItem item) {
    final isCouple = profile.raw['profile_type']?.toString().toLowerCase() == 'couple';
    final genders = profile.genderProfileType.split('|').map((e) => e.trim()).toList();
    final firstGender = genders.isNotEmpty ? genders[0] : '';
    final secondGender = genders.length > 1 ? genders[1] : '';

    Widget buildPersonValue(String value, String gender) {
      final isUnshared = value.trim().toLowerCase().contains('not comfortable sharing') || value.trim().isEmpty;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _genderCircleFor(gender),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isUnshared ? 'N/A' : value,
              style: TextStyle(
                color: isUnshared ? Colors.black54 : Colors.black,
                fontSize: 13,
                fontWeight: isUnshared ? FontWeight.w500 : FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    }

    if (isCouple) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6DFF0)),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.label,
              style: TextStyle(
                color: _maroon,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: buildPersonValue(item.value, firstGender)),
                const SizedBox(width: 12),
                Expanded(child: buildPersonValue(item.value2 ?? 'N/A', secondGender)),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6DFF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item.label,
              style: TextStyle(
                color: _maroon,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _genderCircleFor(firstGender.isNotEmpty ? firstGender : profile.genderProfileType),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              item.value,
              style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderCircleFor(String gender) {
    final asset = _genderAsset(gender);
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_maroon, _navy],
        ),
      ),
      alignment: Alignment.center,
      child: asset == null
          ? const SizedBox.shrink()
          : SvgPicture.network(
              _webAsset(asset),
              width: 18,
              height: 18,
              placeholderBuilder: (_) => const SizedBox(width: 18, height: 18),
            ),
    );
  }

  String? _genderAsset(String gender) {
    if (gender == 'Female') return 'assets/img/icons/female.svg';
    if (gender == 'Male') return 'assets/img/icons/male.svg';
    if (gender == 'Transgender') return 'assets/img/icons/transgender.svg';
    return null;
  }

  Widget _mediaButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _mediaButton(Icons.photo_library_outlined, 'Photos', _images.length, _images.isEmpty ? null : _showAllImages),
        _mediaButton(Icons.collections_bookmark_outlined, 'Albums', _albums.length, _albums.isEmpty ? null : _showAlbums),
        _mediaButton(Icons.videocam_outlined, 'Videos', _videos.length, _videos.isEmpty ? null : _showAllVideos),
      ],
    );
  }

  Widget _mediaButton(IconData icon, String label, int count, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey.shade300 : _maroon,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: onTap == null ? Colors.black54 : Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('$label ($count)', style: TextStyle(color: onTap == null ? Colors.black54 : Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _image(String rawUrl, {BoxFit fit = BoxFit.cover}) {
    final url = _resolveMediaUrl(rawUrl);
    if (url.isEmpty) {
      return Container(color: Colors.white, alignment: Alignment.center, child: const Icon(Icons.person, color: _maroon, size: 52));
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(color: Colors.white, alignment: Alignment.center, child: const Icon(Icons.broken_image, color: _maroon, size: 48)),
      loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator(color: _maroon, strokeWidth: 2)),
    );
  }

  void _showAllImages() {
    showDialog(
      context: context,
      builder: (_) => _ProfileMediaDialog(
        title: 'Photos',
        itemCount: _images.length,
        itemBuilder: (context, index) => InteractiveViewer(
          child: Image.network(
            _resolveMediaUrl(_images[index].profileImage),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white, size: 60),
          ),
        ),
      ),
    );
  }

  void _showAllVideos() {
    showDialog(
      context: context,
      builder: (_) => _ProfileMediaDialog(
        title: 'Videos',
        itemCount: _videos.length,
        itemBuilder: (context, index) => _NetworkVideoPlayer(url: _resolveMediaUrl(_videos[index].profileVideo)),
      ),
    );
  }

  void _showAlbums() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: _albums.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .86),
            itemBuilder: (context, index) {
              final album = _albums[index];
              return InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  await _openAlbum(album);
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                      Expanded(child: _image(album.image, fit: BoxFit.cover)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openAlbum(ProfileAlbum album) async {
    final api = _api;
    if (api == null) return;
    setState(() => _busy = true);
    try {
      final media = await api.getAlbumMedia(albumId: album.id, userId: _userId);
      if (!mounted) return;
      if (media.isEmpty) {
        _snack('No Record Found.....', error: true);
        return;
      }
      showDialog(
        context: context,
        builder: (_) => _ProfileMediaDialog(
          title: album.name,
          itemCount: media.length,
          itemBuilder: (context, index) {
            final item = media[index];
            if (item.isVideo) return _NetworkVideoPlayer(url: _resolveMediaUrl(item.video));
            return InteractiveViewer(
              child: Image.network(
                _resolveMediaUrl(item.image),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white, size: 60),
              ),
            );
          },
        ),
      );
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
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
            onPressed: _load,
            style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  _DetailItem(this.label, this.value, {this.value2});
  final String label;
  final String value;
  final String? value2;
}

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({required this.title, required this.initialText});
  final String title;
  final String initialText;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.title, style: const TextStyle(color: Colors.black)),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF560827),
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _ProfileMediaDialog extends StatefulWidget {
  const _ProfileMediaDialog({required this.title, required this.itemCount, required this.itemBuilder});

  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<_ProfileMediaDialog> createState() => _ProfileMediaDialogState();
}

class _ProfileMediaDialogState extends State<_ProfileMediaDialog> {
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
                    child: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
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
            onTap: () => setState(() => controller.value.isPlaying ? controller.pause() : controller.play()),
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
