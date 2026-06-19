// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/providers/user_list_provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class ValidationRequestPage extends ConsumerWidget {
//   const ValidationRequestPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Reusing userListProvider with a specific key
//     final state = ref.watch(userListProvider('validation_requests'));

//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F1A),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           _buildAppBar(context),
//           _buildInfoHero(),
//           _buildRequestList(state.users, ref),
//           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       floating: true,
//       pinned: true,
//       backgroundColor: const Color(0xFF0F0F1A),
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//         onPressed: () => Navigator.pop(context),
//       ),
//       centerTitle: true,
//       title: const Text(
//         'VALIDATION REQUESTS',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w900,
//           fontSize: 16,
//           letterSpacing: 2.0,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoHero() {
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         padding: const EdgeInsets.all(25),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             colors: [Color(0xFF673AB7), Color(0xFF0F0F1A)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: const Row(
//           children: [
//             FaIcon(FontAwesomeIcons.shieldHalved, color: Colors.white, size: 40),
//             SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Review Queue', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//                   Text('Verify members to keep the community safe', style: TextStyle(color: Colors.white70, fontSize: 13)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRequestList(List<UserListItem> users, WidgetRef ref) {
//     if (users.isEmpty) {
//       return const SliverFillRemaining(
//         hasScrollBody: false,
//         child: Center(
//           child: Text(
//             'No pending validation requests.',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//         ),
//       );
//     }

//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (context, index) {
//           final user = users[index];
//           return _buildRequestCard(context, ref, user);
//         },
//         childCount: users.length,
//       ),
//     );
//   }

//   Widget _buildRequestCard(BuildContext context, WidgetRef ref, UserListItem user) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30, 
//             backgroundColor: Colors.white12,
//             backgroundImage: user.imageUrl.startsWith('http') || user.imageUrl.startsWith('data:')
//                 ? (user.imageUrl.startsWith('data:') 
//                     ? MemoryImage(const Base64Decoder().convert(user.imageUrl.split(',').last)) 
//                     : NetworkImage(user.imageUrl)) as ImageProvider
//                 : AssetImage(user.imageUrl),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.name, 
//                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'ID Verification Request', 
//                   style: TextStyle(color: Colors.white54, fontSize: 12)
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.orange.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
//             ),
//             child: const Text(
//               'PENDING',
//               style: TextStyle(
//                 color: Colors.orange,
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.2,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// Beat Flirt /validation-request screen converted from:
// https://beatflirtevent.com/validation-request
//
// Required pubspec dependencies:
//   http: ^1.2.2
//   shared_preferences: ^2.3.2
//   flutter_svg: ^2.0.10+1
//
// AndroidManifest.xml:
//   <uses-permission android:name="android.permission.INTERNET" />

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'upgrade_page.dart';

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

class BeatValidationRequestApiException implements Exception {
  BeatValidationRequestApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BeatValidationRequestApi {
  BeatValidationRequestApi({
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
      throw BeatValidationRequestApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw BeatValidationRequestApiException('Unexpected API response');
  }

  /// Website API: POST /feed/get_all_pending_validate_request
  Future<List<ValidationRequestUser>> getPendingValidationRequests() async {
    final json = await _post('/feed/get_all_pending_validate_request', {'type': 'pending'});
    if (_okStatus(json['status'])) {
      final data = json['data'];
      if (data is List) {
        return data.map((e) => ValidationRequestUser.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      return <ValidationRequestUser>[];
    }

    final message = _string(json['message']);
    if (message.toLowerCase().contains('token')) {
      throw BeatValidationRequestApiException(message);
    }
    return <ValidationRequestUser>[];
  }

  /// Website API: POST /feed/accept_validate_request
  /// status: "1" = Accept, "2" = Decline
  Future<String> acceptValidationRequest({required String id, required String status}) async {
    final json = await _post('/feed/accept_validate_request', {
      'id': id,
      'status': status,
    });
    final message = _string(json['message'], _okStatus(json['status']) ? 'Success' : 'Request failed');
    if (!_okStatus(json['status'])) throw BeatValidationRequestApiException(message);
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
      throw BeatValidationRequestApiException(_string(json['message'], 'Unable to create chat room'));
    }
  }

  /// Common layout API used by the web shell.
  Future<String?> checkLoginUserMembership() async {
    final json = await _post('/user/check_login_user_membership');
    return json['membership_expire']?.toString();
  }

  /// Optional common layout count API.
  Future<Map<String, dynamic>> notificationAllCount() => _get('/notification/all_count');
}

class ValidationRequestImage {
  ValidationRequestImage({required this.profileImage});
  final String profileImage;

  factory ValidationRequestImage.fromJson(Map<String, dynamic> json) => ValidationRequestImage(
        profileImage: _string(json['profile_image']),
      );
}

class ValidationRequestVideo {
  ValidationRequestVideo({required this.video});
  final String video;

  factory ValidationRequestVideo.fromJson(Map<String, dynamic> json) => ValidationRequestVideo(
        video: _string(json['video']),
      );
}

class ValidationRequestUser {
  ValidationRequestUser({
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
  final String message;
  final List<ValidationRequestImage> images;
  final List<ValidationRequestVideo> videos;

  factory ValidationRequestUser.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] is List ? json['image'] as List : const [];
    final videoList = json['video'] is List ? json['video'] as List : const [];
    return ValidationRequestUser(
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
      message: _string(json['message']),
      images: imageList.whereType<Map>().map((e) => ValidationRequestImage.fromJson(Map<String, dynamic>.from(e))).toList(),
      videos: videoList.whereType<Map>().map((e) => ValidationRequestVideo.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first.profileImage : '';

  bool flag(String key) => raw[key]?.toString() == '1';
}

class ValidationRequestPage extends StatefulWidget {
  const ValidationRequestPage({
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

  /// Pass your own API instance or pass accessToken/accessSign.
  /// If neither is passed, the widget reads SharedPreferences keys:
  /// Access-Token, Access-Sign, user-id, membership.
  final BeatValidationRequestApi? api;
  final String? accessToken;
  final String? accessSign;
  final String? loginUserId;
  final String? membershipValue;
  final bool autoCheckMembership;

  /// Angular validation-request page shows the locked placeholder when stored
  /// membership value is "Yes".
  final bool enforceMembershipLock;

  final void Function(BuildContext context, ValidationRequestUser user)? onOpenProfile;
  final void Function(BuildContext context, ValidationRequestUser user)? onOpenMessenger;
  final VoidCallback? onOpenMembership;

  @override
  State<ValidationRequestPage> createState() => _ValidationRequestPageState();
}

class _ValidationRequestPageState extends State<ValidationRequestPage> {
  BeatValidationRequestApi? _api;
  List<ValidationRequestUser> _items = <ValidationRequestUser>[];
  bool _booting = true;
  bool _loading = false;
  String? _error;
  String _loginUserId = '';
  String _membershipValue = '';

  static const Color _lightBg = Color(0xFFFFF4FA);
  static const Color _primary = Color(0xFF1D042A);
  static const Color _maroon = Color(0xFF560827);
  static const Color _orange = Color(0xFFFF8A00);
  static const Color _pink = Color(0xFFE91E63);
  static const Color _navy = Color(0xFF06032C);

  bool get _cardsLocked {
    if (!widget.enforceMembershipLock) return false;
    return _membershipValue == 'Yes';
  }

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

      _membershipValue = widget.membershipValue ?? prefs.getString('membership') ?? '';
      _api = widget.api ?? BeatValidationRequestApi(accessToken: token, accessSign: sign);

      if (widget.autoCheckMembership && token.isNotEmpty && sign.isNotEmpty) {
        final membershipExpire = await _api!.checkLoginUserMembership();
        if (membershipExpire != null) {
          _membershipValue = membershipExpire;
          await prefs.setString('membership', membershipExpire);
        }
      }

      if (!mounted) return;
      setState(() => _booting = false);
      await _loadRequests();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _booting = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadRequests() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await api.getPendingValidationRequests();
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

  Future<void> _acceptDecline(ValidationRequestUser user, String status) async {
    final api = _api;
    if (api == null) return;
    setState(() => _loading = true);
    try {
      final message = await api.acceptValidationRequest(id: user.id, status: status);
      _snack(message);
      await _loadRequests();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _chat(ValidationRequestUser user) async {
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

  void _openProfile(ValidationRequestUser user) {
    if (widget.onOpenProfile != null) {
      widget.onOpenProfile!(context, user);
      return;
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => BeatSingleUserProfileScreen(
    //       userId: user.id,
    //       accessToken: widget.accessToken,
    //       accessSign: widget.accessSign,
    //       loginUserId: _loginUserId,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,size: 20,),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
            text: TextSpan(
              text: 'Validation Request ',
              style: const TextStyle(color: _primary, fontSize: 22, fontWeight: FontWeight.w600),
              children: [
                if (_items.isNotEmpty) TextSpan(text: '(${_items.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          centerTitle: true,
          ),
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => _loadRequests(),
              color: _maroon,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // _header(),
                  if (_booting)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(child: CircularProgressIndicator(color: _maroon)),
                    )
                  else if (_error != null) ...[
                    _errorBox(_error!),
                  ] else if (_items.isEmpty && !_loading) ...[
                    _noData(),
                  ] else ...[
                    const SizedBox(height: 16),
                    _requestGrid(),
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

  // Widget _header() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Flexible(
  //         child: RichText(
  //           text: TextSpan(
  //             text: 'Validation Request ',
  //             style: const TextStyle(color: _primary, fontSize: 26, fontWeight: FontWeight.w600),
  //             children: [
  //               if (_items.isNotEmpty) TextSpan(text: '(${_items.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _requestGrid() {
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
            mainAxisExtent: 505,
          ),
          itemBuilder: (context, index) {
            if (_cardsLocked) return _lockedCard();
            return _requestCard(_items[index]);
          },
        );
      },
    );
  }

  Widget _requestCard(ValidationRequestUser user) {
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
              gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
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
                  const SizedBox(height: 8),
                  if (user.message.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(color: _maroon, borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        user.message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  const SizedBox(height: 8),
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
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _smallButton('Accept', _maroon, () => _acceptDecline(user, '1')),
                      const SizedBox(width: 8),
                      _smallButton('Decline', _orange, () => _acceptDecline(user, '2')),
                    ],
                  ),
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

  Widget _genderIcons(ValidationRequestUser user) {
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

  Widget _locationLine(ValidationRequestUser user) {
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

  Widget _networkImage(String rawUrl, {BoxFit fit = BoxFit.cover}) {
    final url = _resolveMediaUrl(rawUrl);
    if (url.isEmpty) {
      return Container(color: Colors.white, alignment: Alignment.center, child: const Icon(Icons.person, color: _maroon, size: 46));
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(color: Colors.white, alignment: Alignment.center, child: const Icon(Icons.person, color: _maroon, size: 46)),
      loadingBuilder: (context, child, loading) {
        if (loading == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: _maroon));
      },
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
            onPressed: () => _loadRequests(),
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
          const Text('No New Validation Requests', style: TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 24)),
          const SizedBox(height: 10),
          const Text(
            "It looks like you don't have any validation requests at the moment. Why not explore and find some interesting people?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF777777), fontSize: 16, height: 1.6),
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
              const Text('Blastergate Team!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text(
                '"You have not purchased a Blastergate membership plan. Buy membership"',
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
