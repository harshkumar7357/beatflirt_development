// Beat Flirt /friend-request screen converted from:
// https://beatflirtevent.com/friend-request
//
// Required pubspec dependencies:
//   http: ^1.2.2
//   shared_preferences: ^2.3.2
//   flutter_svg: ^2.0.10+1
//
// AndroidManifest.xml:
//   <uses-permission android:name="android.permission.INTERNET" />

import 'dart:convert';

import 'package:beatflirt/single_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


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

class BeatFriendRequestApiException implements Exception {
  BeatFriendRequestApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BeatFriendRequestApi {
  BeatFriendRequestApi({
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
      throw BeatFriendRequestApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw BeatFriendRequestApiException('Unexpected API response');
  }

  /// Website API: POST /feed/get_all_friend_request
  Future<List<FriendRequestUser>> getPendingFriendRequests() async {
    final json = await _post('/feed/get_all_friend_request', {
      'type': 'pending',
      'search_keyword': '',
      'lat': '0',
      'lng': '0',
      'profileTypeArray': <String>[],
    });
    if (_okStatus(json['status'])) {
      final data = json['data'];
      if (data is List) {
        return data.map((e) => FriendRequestUser.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      return <FriendRequestUser>[];
    }

    final message = _string(json['message']);
    if (message.toLowerCase().contains('token')) {
      throw BeatFriendRequestApiException(message);
    }
    return <FriendRequestUser>[];
  }

  /// Website API: POST /feed/accept_friend_request
  /// status: "1" = Accept, "2" = Decline
  Future<String> acceptFriendRequest({required String id, required String status}) async {
    final json = await _post('/feed/accept_friend_request', {
      'id': id,
      'status': status,
    });
    final message = _string(json['message'], _okStatus(json['status']) ? 'Success' : 'Request failed');
    if (!_okStatus(json['status'])) throw BeatFriendRequestApiException(message);
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
      throw BeatFriendRequestApiException(_string(json['message'], 'Unable to create chat room'));
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

class FriendRequestImage {
  FriendRequestImage({required this.profileImage});
  final String profileImage;

  factory FriendRequestImage.fromJson(Map<String, dynamic> json) => FriendRequestImage(
        profileImage: _string(json['profile_image']),
      );
}

class FriendRequestVideo {
  FriendRequestVideo({required this.video});
  final String video;

  factory FriendRequestVideo.fromJson(Map<String, dynamic> json) => FriendRequestVideo(
        video: _string(json['video']),
      );
}

class FriendRequestUser {
  FriendRequestUser({
    required this.raw,
    required this.id,
    required this.friendRequestId,
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
  final String friendRequestId;
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
  final List<FriendRequestImage> images;
  final List<FriendRequestVideo> videos;

  factory FriendRequestUser.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] is List ? json['image'] as List : const [];
    final videoList = json['video'] is List ? json['video'] as List : const [];
    return FriendRequestUser(
      raw: json,
      id: _string(json['id']),
      friendRequestId: _string(json['friend_request_id'], _string(json['id'])),
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
      images: imageList.whereType<Map>().map((e) => FriendRequestImage.fromJson(Map<String, dynamic>.from(e))).toList(),
      videos: videoList.whereType<Map>().map((e) => FriendRequestVideo.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first.profileImage : '';

  bool flag(String key) => raw[key]?.toString() == '1';
}

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({
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
  final BeatFriendRequestApi? api;
  final String? accessToken;
  final String? accessSign;
  final String? loginUserId;
  final String? membershipValue;
  final bool autoCheckMembership;

  /// Angular friend-request page shows the locked placeholder when stored
  /// membership value is "Yes".
  final bool enforceMembershipLock;

  final void Function(BuildContext context, FriendRequestUser user)? onOpenProfile;
  final void Function(BuildContext context, FriendRequestUser user)? onOpenMessenger;
  final VoidCallback? onOpenMembership;

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  BeatFriendRequestApi? _api;
  List<FriendRequestUser> _items = <FriendRequestUser>[];
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
      _api = widget.api ?? BeatFriendRequestApi(accessToken: token, accessSign: sign);

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
      final data = await api.getPendingFriendRequests();
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

  Future<void> _acceptDecline(FriendRequestUser user, String status) async {
    final api = _api;
    if (api == null) return;
    setState(() => _loading = true);
    try {
      final message = await api.acceptFriendRequest(id: user.friendRequestId, status: status);
      _snack(message);
      await _loadRequests();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _chat(FriendRequestUser user) async {
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

  void _openProfile(FriendRequestUser user) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(onPressed: (){
          Navigator.pop(context);
        },
         icon: Icon(Icons.arrow_back_ios_new, color: _primary, size: 20)
        ),
        // title:  Text("Blocked User List", style: TextStyle(color: _primary, fontSize: 20, fontWeight: FontWeight.w600)),
        title: RichText(
            text: TextSpan(
              text: 'Friend Request ',
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
  //             text: 'Friend Request ',
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

  Widget _requestCard(FriendRequestUser user) {
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
                  const SizedBox(height: 12),
                  _actionBar(user),
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
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.white, width: 1)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _actionBar(FriendRequestUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionItem('assets/img/icons/camera.svg', '${user.images.length}'),
        _actionItem('assets/img/icons/like.svg', '${user.likesCount}'),
        _actionItem('assets/img/icons/people.svg', '${user.friendsCount}'),
        _actionItem('assets/img/icons/share.svg', '${user.validationCount}'),
        _actionItem('assets/img/icons/video.svg', '${user.videos.length}'),
      ],
    );
  }

  Widget _actionItem(String iconPath, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.network(
          _webAsset(iconPath),
          // width: 21,
          // height: 21,
          width: 15,
          height: 15,
          placeholderBuilder: (_) => const Icon(Icons.circle, size: 16, color: Colors.white),
        ),
        const SizedBox(height: 3),
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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

  Widget _genderIcons(FriendRequestUser user) {
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

  Widget _locationLine(FriendRequestUser user) {
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
          Padding(padding: EdgeInsets.all(14),child:  Text('No New Friend Requests', style: TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 24))),
          const SizedBox(height: 10),
          const Text(
            "It looks like you don't have any incoming friend requests at the moment. Why not explore and find some interesting people?",
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
                    Navigator.pushNamed(context, '/membership');
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


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:beatflirt/core/services/auth_services.dart';


// class FriendRequestModel {
//   final String friendRequestId;
//   final String id;
//   final String username;
//   final String genderProfileType;
//   final String cityName;
//   final int totalDistance;
//   final String formattedAddress;
//   final String imageUrl;
//   final int age;
//   final int age2;
//   final String singleProfileGenderFrom;
//   final String profileType;

//   FriendRequestModel({
//     required this.friendRequestId,
//     required this.id,
//     required this.username,
//     required this.genderProfileType,
//     required this.cityName,
//     required this.totalDistance,
//     required this.formattedAddress,
//     required this.imageUrl,
//     required this.age,
//     required this.age2,
//     required this.singleProfileGenderFrom,
//     required this.profileType,
//   });

//   factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
//     String imageUrl = '';
//     if (json['image'] != null && json['image'].isNotEmpty) {
//       imageUrl = json['image'][0]['profile_image'] ?? '';
//     }
//     return FriendRequestModel(
//       friendRequestId: json['friend_request_id']?.toString() ?? '',
//       id: json['id']?.toString() ?? '',
//       username: json['username'] ?? 'Unknown',
//       genderProfileType: json['gender_profile_type'] ?? '',
//       cityName: json['city_name'] ?? '',
//       totalDistance: json['total_distance'] ?? 0,
//       formattedAddress: json['formatted_address'] ?? '',
//       imageUrl: imageUrl,
//       age: json['age'] ?? 0,
//       age2: json['age2'] ?? 0,
//       singleProfileGenderFrom: json['single_profile_gender_from']?.toString() ?? '0',
//       profileType: json['profile_type'] ?? 'single',
//     );
//   }

//   String get displayGender {
//     // Map gender based on single_profile_gender_from and gender_profile_type
//     if (profileType == 'couple') {
//       return 'Male | Female';
//     }
//     if (singleProfileGenderFrom == '2') {
//       return 'Male | Female';
//     } else if (singleProfileGenderFrom == '1') {
//       return 'Female | Male';
//     }
//     return genderProfileType.isNotEmpty ? genderProfileType : 'Male | Female';
//   }

//   String get displayAge {
//     if (age2 > 0) {
//       return 'Age $age | $age2';
//     }
//     return 'Age $age';
//   }
// }

// class FriendRequestsPage extends StatefulWidget {
//   const FriendRequestsPage({super.key});

//   @override
//   State<FriendRequestsPage> createState() => _FriendRequestsPageState();
// }

// class _FriendRequestsPageState extends State<FriendRequestsPage> {
//   List<FriendRequestModel> friendRequests = [];
//   bool isLoading = true;
//   String errorMessage = '';
//   Set<String> processingIds = {}; // Track which requests are being processed

//   @override
//   void initState() {
//     super.initState();
//     fetchFriendRequests();
//   }

//   Future<void> fetchFriendRequests() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     final String? token = await AuthService.getToken();
//     const String apiUrl = 'https://app.beatflirtevent.com/App/feed/get_all_friend_request';
//     final Map<String, dynamic> payload = {
//       "type": "pending",
//       "search_keyword": "",
//       "lat": "0",
//       "lng": "0",
//       "profileTypeArray": []
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           if (token != null && token.isNotEmpty) ...{
//             'Authorization': 'Bearer $token',
//             'access-token': token,
//           },
//         },
//         body: jsonEncode(payload),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
        
//         if (responseData['status'] == '200' && responseData['data'] != null) {
//           final List<dynamic> dataList = responseData['data'];
//           setState(() {
//             friendRequests = dataList
//                 .map((item) => FriendRequestModel.fromJson(item))
//                 .toList();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             errorMessage = 'No friend requests found';
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load friend requests. Status: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error fetching data: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<bool> _acceptOrDeclineRequest(String friendRequestId, int status) async {
//     final String? token = await AuthService.getToken();
//     const String apiUrl = 'https://app.beatflirtevent.com/App/feed/accept_friend_request';
//     final Map<String, dynamic> payload = {
//       "id": friendRequestId,
//       "status": status.toString(),
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           if (token != null && token.isNotEmpty) ...{
//             'Authorization': 'Bearer $token',
//             'access-token': token,
//           },
//         },
//         body: jsonEncode(payload),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         // Assuming the API returns status 200 on success
//         return responseData['status'] == '200' || response.statusCode == 200;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Error in accept/decline: $e');
//       return false;
//     }
//   }

//   Future<void> _handleAccept(FriendRequestModel request, int index) async {
//     // Show loading state for this specific card
//     setState(() {
//       processingIds.add(request.friendRequestId);
//     });

//     // Call the accept API (status = 1 for accept)
//     final bool success = await _acceptOrDeclineRequest(request.friendRequestId, 1);

//     setState(() {
//       processingIds.remove(request.friendRequestId);
//     });

//     if (success) {
//       setState(() {
//         friendRequests.removeAt(index);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Accepted friend request from ${request.username}'),
//           backgroundColor: const Color(0xFF4A0E4E),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to accept request. Please try again.'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<void> _handleDecline(FriendRequestModel request, int index) async {
//     // Show loading state for this specific card
//     setState(() {
//       processingIds.add(request.friendRequestId);
//     });

//     // Call the decline API (status = 2 for decline)
//     final bool success = await _acceptOrDeclineRequest(request.friendRequestId, 2);

//     setState(() {
//       processingIds.remove(request.friendRequestId);
//     });

//     if (success) {
//       setState(() {
//         friendRequests.removeAt(index);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Declined friend request from ${request.username}'),
//           backgroundColor: Colors.grey[700],
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to decline request. Please try again.'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   String _getLocationText(FriendRequestModel request) {
//     String address = request.formattedAddress.isNotEmpty 
//         ? request.formattedAddress 
//         : request.cityName;
//     return '$address | ${request.totalDistance} km';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F0F5), // Light pinkish background matching screenshot
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF8F0F5),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D1B4E),size: 20,),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Friend Request',
//           style: TextStyle(
//             color: Color(0xFF2D1B4E),
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF4A0E4E),
//               ),
//             )
//           : errorMessage.isNotEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.error_outline, size: 60, color: Colors.grey),
//                       const SizedBox(height: 16),
//                       Text(
//                         errorMessage,
//                         style: const TextStyle(color: Colors.grey, fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ),
//                       // const SizedBox(height: 20),
//                       // ElevatedButton(
//                       //   onPressed: fetchFriendRequests,
//                       //   style: ElevatedButton.styleFrom(
//                       //     backgroundColor: const Color(0xFF4A0E4E),
//                       //     foregroundColor: Colors.white,
//                       //   ),
//                       //   child: const Text('Retry'),
//                       // ),
//                     ],
//                   ),
//                 )
//               : friendRequests.isEmpty
//                   ? const Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.people_outline, size: 80, color: Colors.grey),
//                           SizedBox(height: 16),
//                           Text(
//                             'No pending friend requests',
//                             style: TextStyle(fontSize: 18, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Column(
//                       children: [
//                         // Header with count
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                           child: Row(
//                             children: [
//                               Text(
//                                 'Friend Request (${friendRequests.length})',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF2D1B4E),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.builder(
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                             itemCount: friendRequests.length,
//                             itemBuilder: (context, index) {
//                               final request = friendRequests[index];
//                               return _buildFriendRequestCard(request, index);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//     );
//   }

//   Widget _buildFriendRequestCard(FriendRequestModel request, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 24),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           // Main Card
//           Container(
//             margin: const EdgeInsets.only(top: 50),
//             decoration: BoxDecoration(
//               color: const Color(0xFF4A0E4E), // Dark purple/maroon
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 15,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Name
//                   Text(
//                     request.username,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Age Badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE91E63), // Pink
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       request.displayAge,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Gender
//                   Text(
//                     request.displayGender,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Location
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         color: Colors.white70,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 6),
//                       Flexible(
//                         child: Text(
//                           _getLocationText(request),
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 14,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Heart/Bubble Icon
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFE91E63),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.favorite,
//                           color: Colors.white,
//                           size: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFE91E63),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.chat_bubble,
//                           color: Colors.white,
//                           size: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   // Action Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: processingIds.contains(request.friendRequestId)
//                               ? null
//                               : () => _handleAccept(request, index),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4A0E4E),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               side: const BorderSide(color: Colors.white, width: 1.5),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: processingIds.contains(request.friendRequestId)
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Accept',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: processingIds.contains(request.friendRequestId)
//                               ? null
//                               : () => _handleDecline(request, index),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             side: const BorderSide(color: Colors.white, width: 1.5),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: processingIds.contains(request.friendRequestId)
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Decline',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Profile Image (overlapping on top)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Container(
//                 width: 110,
//                 height: 110,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: const Color(0xFFE91E63), // Pink border
//                     width: 4,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ClipOval(
//                   child: request.imageUrl.isNotEmpty
//                       ? Image.network(
//                           request.imageUrl,
//                           fit: BoxFit.cover,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 color: Color(0xFFE91E63),
//                                 strokeWidth: 2,
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               color: Colors.grey[300],
//                               child: const Icon(
//                                 Icons.person,
//                                 size: 50,
//                                 color: Colors.grey,
//                               ),
//                             );
//                           },
//                         )
//                       : Container(
//                           color: Colors.grey[300],
//                           child: const Icon(
//                             Icons.person,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Usage example in your existing project:
// // Navigator.push(
// //   context,
// //   MaterialPageRoute(builder: (context) => const FriendRequestsPage()),
// // );


// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_riverpod/legacy.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:beatflirt/core/services/auth_services.dart';


// // /// ------------------------------------------------------------
// // /// BEAT FLIRT - FRIEND REQUEST SCREEN (Single File + Riverpod)
// // /// ------------------------------------------------------------
// // /// Dependencies needed in pubspec.yaml:
// // ///
// // /// dependencies:
// // ///   flutter:
// // ///     sdk: flutter
// // ///   http: ^1.2.2
// // ///   flutter_riverpod: ^2.6.1
// // ///
// // /// If your accept/decline endpoint is different, change only this:
// // /// acceptDeclinePath: '/App/feed/accept_friend_request'
// // ///
// // /// If backend expects '/feed/accept_friend_request' instead of
// // /// '/App/feed/accept_friend_request', just pass that path from the widget.
// // /// ------------------------------------------------------------

// // class BeatFlirtFriendRequestApp extends StatelessWidget {
// //   const BeatFlirtFriendRequestApp({
// //     super.key,
// //     this.bearerToken = '',
// //     this.baseUrl = 'https://app.beatflirtevent.com',
// //     this.acceptDeclinePath = '/App/feed/accept_friend_request',
// //     this.currentUsername = 'davidbrown',
// //     this.currentLocation = 'Ukkadam, Coimbatore, Tamil Nadu, India',
// //     this.currentUserImageUrl,
// //   });

// //   final String bearerToken;
// //   final String baseUrl;
// //   final String acceptDeclinePath;
// //   final String currentUsername;
// //   final String currentLocation;
// //   final String? currentUserImageUrl;

// //   @override
// //   Widget build(BuildContext context) {
// //     return ProviderScope(
// //       child: MaterialApp(
// //         debugShowCheckedModeBanner: false,
// //         theme: BeatFlirtTheme.theme,
// //         home: FriendRequestPage(
// //           bearerToken: bearerToken,
// //           baseUrl: baseUrl,
// //           acceptDeclinePath: acceptDeclinePath,
// //           currentUsername: currentUsername,
// //           currentLocation: currentLocation,
// //           currentUserImageUrl: currentUserImageUrl,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class FriendRequestPage extends ConsumerWidget {
// //   const FriendRequestPage({
// //     super.key,
// //     this.bearerToken = '',
// //     this.baseUrl = 'https://app.beatflirtevent.com',
// //     this.acceptDeclinePath = '/App/feed/accept_friend_request',
// //     this.currentUsername = 'davidbrown',
// //     this.currentLocation = 'Ukkadam, Coimbatore, Tamil Nadu, India',
// //     this.currentUserImageUrl,
// //   });

// //   final String bearerToken;
// //   final String baseUrl;
// //   final String acceptDeclinePath;
// //   final String currentUsername;
// //   final String currentLocation;
// //   final String? currentUserImageUrl;

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final config = FriendRequestConfig(
// //       bearerToken: bearerToken,
// //       baseUrl: baseUrl,
// //       acceptDeclinePath: acceptDeclinePath,
// //     );

// //     final state = ref.watch(friendRequestControllerProvider(config));
// //     final controller = ref.read(friendRequestControllerProvider(config).notifier);

// //     return Scaffold(
// //       backgroundColor: BeatFlirtTheme.screenBackground,
// //       body: SafeArea(
// //         child: RefreshIndicator(
// //           color: BeatFlirtTheme.hotPink,
// //           onRefresh: controller.loadRequests,
// //           child: CustomScrollView(
// //             physics: const AlwaysScrollableScrollPhysics(),
// //             slivers: [
// //               SliverToBoxAdapter(
// //                 child: Column(
// //                   children: [
// //                     Container(
// //                       decoration: const BoxDecoration(
// //                         color: BeatFlirtTheme.softSurface,
// //                         borderRadius: BorderRadius.only(
// //                           bottomLeft: Radius.circular(28),
// //                           bottomRight: Radius.circular(28),
// //                         ),
// //                       ),
// //                       child: Column(
// //                         children: [
// //                           _TopHeader(
// //                             username: currentUsername,
// //                             userImageUrl: currentUserImageUrl,
// //                           ),
// //                           _LocationStrip(location: currentLocation),
// //                           Padding(
// //                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
// //                             child: _BodySection(
// //                               state: state,
// //                               onRetry: controller.loadRequests,
// //                               onAccept: (item) async {
// //                                 final messenger = ScaffoldMessenger.of(context);
// //                                 try {
// //                                   final message = await controller.updateRequestStatus(
// //                                     item: item,
// //                                     status: '1',
// //                                   );
// //                                   messenger.showSnackBar(
// //                                     SnackBar(content: Text(message)),
// //                                   );
// //                                 } catch (e) {
// //                                   messenger.showSnackBar(
// //                                     SnackBar(content: Text(e.toString())),
// //                                   );
// //                                 }
// //                               },
// //                               onDecline: (item) async {
// //                                 final messenger = ScaffoldMessenger.of(context);
// //                                 try {
// //                                   final message = await controller.updateRequestStatus(
// //                                     item: item,
// //                                     status: '2',
// //                                   );
// //                                   messenger.showSnackBar(
// //                                     SnackBar(content: Text(message)),
// //                                   );
// //                                 } catch (e) {
// //                                   messenger.showSnackBar(
// //                                     SnackBar(content: Text(e.toString())),
// //                                   );
// //                                 }
// //                               },
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 28),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _TopHeader extends StatelessWidget {
// //   const _TopHeader({
// //     required this.username,
// //     required this.userImageUrl,
// //   });

// //   final String username;
// //   final String? userImageUrl;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
// //       child: Row(
// //         children: [
// //           const Icon(
// //             Icons.menu_rounded,
// //             size: 40,
// //             color: BeatFlirtTheme.headerIcon,
// //           ),
// //           const SizedBox(width: 14),
// //           CircleAvatar(
// //             radius: 24,
// //             backgroundColor: Colors.white,
// //             backgroundImage: (userImageUrl != null && userImageUrl!.isNotEmpty)
// //                 ? NetworkImage(userImageUrl!)
// //                 : null,
// //             child: (userImageUrl == null || userImageUrl!.isEmpty)
// //                 ? const Icon(Icons.person, color: Colors.black54)
// //                 : null,
// //           ),
// //           const SizedBox(width: 14),
// //           Expanded(
// //             child: Text(
// //               username,
// //               maxLines: 1,
// //               overflow: TextOverflow.ellipsis,
// //               style: const TextStyle(
// //                 color: BeatFlirtTheme.headerText,
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.w700,
// //                 letterSpacing: -0.2,
// //               ),
// //             ),
// //           ),
// //           const Icon(
// //             Icons.notifications_active_rounded,
// //             color: BeatFlirtTheme.bellYellow,
// //             size: 28,
// //           ),
// //           const SizedBox(width: 18),
// //           const Icon(
// //             Icons.logout_rounded,
// //             color: BeatFlirtTheme.hotPink,
// //             size: 28,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _LocationStrip extends StatelessWidget {
// //   const _LocationStrip({required this.location});

// //   final String location;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: double.infinity,
// //       color: BeatFlirtTheme.maroonStrip,
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(
// //             Icons.location_on_rounded,
// //             color: BeatFlirtTheme.locationYellow,
// //             size: 28,
// //           ),
// //           const SizedBox(width: 8),
// //           Flexible(
// //             child: Text(
// //               location,
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(
// //                 color: BeatFlirtTheme.locationYellow,
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.w700,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _BodySection extends StatelessWidget {
// //   const _BodySection({
// //     required this.state,
// //     required this.onRetry,
// //     required this.onAccept,
// //     required this.onDecline,
// //   });

// //   final FriendRequestState state;
// //   final Future<void> Function() onRetry;
// //   final Future<void> Function(FriendRequestItem item) onAccept;
// //   final Future<void> Function(FriendRequestItem item) onDecline;

// //   @override
// //   Widget build(BuildContext context) {
// //     if (state.isLoading) {
// //       return const SizedBox(
// //         height: 620,
// //         child: Center(
// //           child: CircularProgressIndicator(color: BeatFlirtTheme.hotPink),
// //         ),
// //       );
// //     }

// //     if (state.errorMessage != null) {
// //       return Padding(
// //         padding: const EdgeInsets.all(18),
// //         child: Container(
// //           width: double.infinity,
// //           constraints: const BoxConstraints(minHeight: 560),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(26),
// //           ),
// //           child: Center(
// //             child: Padding(
// //               padding: const EdgeInsets.all(24),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   const Icon(
// //                     Icons.error_outline_rounded,
// //                     size: 48,
// //                     color: Colors.red,
// //                   ),
// //                   const SizedBox(height: 12),
// //                   Text(
// //                     state.errorMessage!,
// //                     textAlign: TextAlign.center,
// //                     style: const TextStyle(
// //                       fontSize: 15,
// //                       color: Colors.black87,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 18),
// //                   ElevatedButton(
// //                     onPressed: onRetry,
// //                     child: const Text('Retry'),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       );
// //     }

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(10, 24, 10, 0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 18),
// //             child: Text(
// //               'Friend Request (${state.requests.length})',
// //               style: const TextStyle(
// //                 fontSize: 32,
// //                 height: 1.1,
// //                 fontWeight: FontWeight.w800,
// //                 color: BeatFlirtTheme.titleText,
// //                 letterSpacing: -0.6,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 26),
// //           if (state.requests.isEmpty)
// //             Container(
// //               width: double.infinity,
// //               margin: const EdgeInsets.symmetric(horizontal: 8),
// //               padding: const EdgeInsets.all(28),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(30),
// //               ),
// //               child: const Column(
// //                 children: [
// //                   Icon(
// //                     Icons.people_outline_rounded,
// //                     size: 60,
// //                     color: BeatFlirtTheme.maroonStrip,
// //                   ),
// //                   SizedBox(height: 12),
// //                   Text(
// //                     'No pending friend requests',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.w700,
// //                       color: BeatFlirtTheme.titleText,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             )
// //           else
// //             ListView.separated(
// //               itemCount: state.requests.length,
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               padding: const EdgeInsets.symmetric(horizontal: 8),
// //               separatorBuilder: (_, __) => const SizedBox(height: 30),
// //               itemBuilder: (context, index) {
// //                 final item = state.requests[index];
// //                 final isCurrentItemProcessing =
// //                     state.processingRequestId == item.friendRequestId;

// //                 return _FriendRequestCard(
// //                   item: item,
// //                   isAccepting: isCurrentItemProcessing &&
// //                       state.processingStatus == FriendRequestAction.accept,
// //                   isDeclining: isCurrentItemProcessing &&
// //                       state.processingStatus == FriendRequestAction.decline,
// //                   onAccept: () => onAccept(item),
// //                   onDecline: () => onDecline(item),
// //                 );
// //               },
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _FriendRequestCard extends StatelessWidget {
// //   const _FriendRequestCard({
// //     required this.item,
// //     required this.isAccepting,
// //     required this.isDeclining,
// //     required this.onAccept,
// //     required this.onDecline,
// //   });

// //   final FriendRequestItem item;
// //   final bool isAccepting;
// //   final bool isDeclining;
// //   final VoidCallback onAccept;
// //   final VoidCallback onDecline;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       clipBehavior: Clip.none,
// //       children: [
// //         Container(
// //           width: double.infinity,
// //           margin: const EdgeInsets.only(top: 82),
// //           padding: const EdgeInsets.fromLTRB(22, 110, 22, 30),
// //           decoration: BoxDecoration(
// //             gradient: const LinearGradient(
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //               colors: [
// //                 BeatFlirtTheme.cardGradientTop,
// //                 BeatFlirtTheme.cardGradientBottom,
// //               ],
// //             ),
// //             borderRadius: BorderRadius.circular(36),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.12),
// //                 blurRadius: 24,
// //                 offset: const Offset(0, 12),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             children: [
// //               Text(
// //                 item.username,
// //                 textAlign: TextAlign.center,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 28,
// //                   fontWeight: FontWeight.w800,
// //                   letterSpacing: -0.4,
// //                 ),
// //               ),
// //               const SizedBox(height: 14),
// //               Container(
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
// //                 decoration: BoxDecoration(
// //                   color: BeatFlirtTheme.hotPink,
// //                   borderRadius: BorderRadius.circular(30),
// //                 ),
// //                 child: Text(
// //                   'Age ${item.age}',
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.w700,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 28),
// //               Text(
// //                 item.genderProfileType,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 17,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Padding(
// //                     padding: EdgeInsets.only(top: 1),
// //                     child: Icon(
// //                       Icons.location_on_rounded,
// //                       color: Colors.white,
// //                       size: 28,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 6),
// //                   Flexible(
// //                     child: Text(
// //                       item.locationText,
// //                       textAlign: TextAlign.center,
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w700,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 18),
// //               const _HeartBubbleIcon(),
// //               const SizedBox(height: 22),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       onPressed: (isAccepting || isDeclining) ? null : onAccept,
// //                       style: BeatFlirtTheme.outlineButtonStyle,
// //                       child: isAccepting
// //                           ? const SizedBox(
// //                               width: 20,
// //                               height: 20,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                           : const Text('Accept'),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 18),
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       onPressed: (isAccepting || isDeclining) ? null : onDecline,
// //                       style: BeatFlirtTheme.outlineButtonStyle,
// //                       child: isDeclining
// //                           ? const SizedBox(
// //                               width: 20,
// //                               height: 20,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                           : const Text('Decline'),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //         Positioned(
// //           left: 0,
// //           right: 0,
// //           top: 0,
// //           child: Center(
// //             child: Container(
// //               width: 172,
// //               height: 172,
// //               padding: const EdgeInsets.all(5),
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(28),
// //                 border: Border.all(color: BeatFlirtTheme.hotPink, width: 6),
// //                 color: BeatFlirtTheme.hotPink.withOpacity(0.06),
// //               ),
// //               child: ClipRRect(
// //                 borderRadius: BorderRadius.circular(22),
// //                 child: item.profileImage.isNotEmpty
// //                     ? Image.network(
// //                         item.profileImage,
// //                         fit: BoxFit.cover,
// //                         errorBuilder: (_, __, ___) => Container(
// //                           color: Colors.white10,
// //                           child: const Icon(
// //                             Icons.person,
// //                             size: 70,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                       )
// //                     : Container(
// //                         color: Colors.white10,
// //                         child: const Icon(
// //                           Icons.person,
// //                           size: 70,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _HeartBubbleIcon extends StatelessWidget {
// //   const _HeartBubbleIcon();

// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: 54,
// //       height: 54,
// //       child: Stack(
// //         clipBehavior: Clip.none,
// //         children: [
// //           Positioned(
// //             left: 2,
// //             bottom: 0,
// //             child: Icon(
// //               Icons.chat_bubble_rounded,
// //               color: BeatFlirtTheme.hotPink.withOpacity(0.88),
// //               size: 38,
// //             ),
// //           ),
// //           Positioned(
// //             right: 0,
// //             top: 2,
// //             child: Container(
// //               width: 28,
// //               height: 28,
// //               decoration: const BoxDecoration(
// //                 color: Color(0xFFFFE5EF),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(
// //                 Icons.favorite_rounded,
// //                 size: 18,
// //                 color: BeatFlirtTheme.hotPink,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class BeatFlirtTheme {
// //   static const Color screenBackground = Color(0xFF120033);
// //   static const Color softSurface = Color(0xFFF8EFF4);
// //   static const Color titleText = Color(0xFF24073B);
// //   static const Color headerText = Color(0xFF373A40);
// //   static const Color headerIcon = Color(0xFF472433);
// //   static const Color maroonStrip = Color(0xFF5B0027);
// //   static const Color locationYellow = Color(0xFFFFEA00);
// //   static const Color bellYellow = Color(0xFFFFB300);
// //   static const Color hotPink = Color(0xFFFF237D);
// //   static const Color cardGradientTop = Color(0xFF70063A);
// //   static const Color cardGradientBottom = Color(0xFF10003C);

// //   static final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
// //     foregroundColor: Colors.white,
// //     side: const BorderSide(color: Colors.white, width: 2),
// //     minimumSize: const Size.fromHeight(66),
// //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //     textStyle: const TextStyle(
// //       fontSize: 18,
// //       fontWeight: FontWeight.w700,
// //     ),
// //   );

// //   static ThemeData get theme {
// //     return ThemeData(
// //       useMaterial3: false,
// //       scaffoldBackgroundColor: screenBackground,
// //       colorScheme: ColorScheme.fromSeed(
// //         seedColor: hotPink,
// //         brightness: Brightness.dark,
// //       ),
// //       snackBarTheme: const SnackBarThemeData(
// //         behavior: SnackBarBehavior.floating,
// //       ),
// //       elevatedButtonTheme: ElevatedButtonThemeData(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: hotPink,
// //           foregroundColor: Colors.white,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //         ),
// //       ),
// //       outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
// //     );
// //   }
// // }

// // enum FriendRequestAction { accept, decline }

// // class FriendRequestState {
// //   const FriendRequestState({
// //     this.isLoading = false,
// //     this.errorMessage,
// //     this.requests = const [],
// //     this.processingRequestId,
// //     this.processingStatus,
// //   });

// //   final bool isLoading;
// //   final String? errorMessage;
// //   final List<FriendRequestItem> requests;
// //   final String? processingRequestId;
// //   final FriendRequestAction? processingStatus;

// //   FriendRequestState copyWith({
// //     bool? isLoading,
// //     String? errorMessage,
// //     List<FriendRequestItem>? requests,
// //     String? processingRequestId,
// //     FriendRequestAction? processingStatus,
// //     bool clearError = false,
// //     bool clearProcessing = false,
// //   }) {
// //     return FriendRequestState(
// //       isLoading: isLoading ?? this.isLoading,
// //       errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
// //       requests: requests ?? this.requests,
// //       processingRequestId: clearProcessing
// //           ? null
// //           : (processingRequestId ?? this.processingRequestId),
// //       processingStatus: clearProcessing
// //           ? null
// //           : (processingStatus ?? this.processingStatus),
// //     );
// //   }
// // }

// // class FriendRequestController extends StateNotifier<FriendRequestState> {
// //   FriendRequestController(this._service)
// //       : super(const FriendRequestState(isLoading: true));

// //   final FriendRequestApiService _service;

// //   Future<void> loadRequests() async {
// //     state = state.copyWith(isLoading: true, clearError: true);

// //     try {
// //       final items = await _service.getPendingFriendRequests();
// //       state = state.copyWith(
// //         isLoading: false,
// //         requests: items,
// //         clearError: true,
// //       );
// //     } catch (e) {
// //       state = state.copyWith(
// //         isLoading: false,
// //         errorMessage: e.toString(),
// //       );
// //     }
// //   }

// //   Future<String> updateRequestStatus({
// //     required FriendRequestItem item,
// //     required String status,
// //   }) async {
// //     final action = status == '1'
// //         ? FriendRequestAction.accept
// //         : FriendRequestAction.decline;

// //     state = state.copyWith(
// //       processingRequestId: item.friendRequestId,
// //       processingStatus: action,
// //     );

// //     try {
// //       final apiMessage = await _service.acceptOrDeclineFriendRequest(
// //         friendRequestId: item.friendRequestId,
// //         status: status,
// //       );

// //       final updatedList = [...state.requests]
// //         ..removeWhere((e) => e.friendRequestId == item.friendRequestId);

// //       state = state.copyWith(
// //         requests: updatedList,
// //         clearProcessing: true,
// //       );

// //       if (apiMessage.trim().isNotEmpty) return apiMessage;
// //       return status == '1'
// //           ? '${item.username} accepted successfully'
// //           : '${item.username} declined successfully';
// //     } catch (e) {
// //       state = state.copyWith(clearProcessing: true);
// //       throw Exception(e.toString().replaceFirst('Exception: ', ''));
// //     }
// //   }
// // }

// // final friendRequestControllerProvider = StateNotifierProvider.autoDispose
// //     .family<FriendRequestController, FriendRequestState, FriendRequestConfig>(
// //   (ref, config) {
// //     final service = FriendRequestApiService(
// //       baseUrl: config.baseUrl,
// //       bearerToken: config.bearerToken,
// //       acceptDeclinePath: config.acceptDeclinePath,
// //     );

// //     ref.onDispose(service.dispose);

// //     final controller = FriendRequestController(service);
// //     Future.microtask(controller.loadRequests);
// //     return controller;
// //   },
// // );

// // class FriendRequestConfig {
// //   const FriendRequestConfig({
// //     required this.bearerToken,
// //     required this.baseUrl,
// //     required this.acceptDeclinePath,
// //   });

// //   final String bearerToken;
// //   final String baseUrl;
// //   final String acceptDeclinePath;

// //   @override
// //   bool operator ==(Object other) {
// //     return identical(this, other) ||
// //         other is FriendRequestConfig &&
// //             other.bearerToken == bearerToken &&
// //             other.baseUrl == baseUrl &&
// //             other.acceptDeclinePath == acceptDeclinePath;
// //   }

// //   @override
// //   int get hashCode => Object.hash(bearerToken, baseUrl, acceptDeclinePath);
// // }

// // class FriendRequestApiService {
// //   FriendRequestApiService({
// //     required this.baseUrl,
// //     required this.bearerToken,
// //     required this.acceptDeclinePath,
// //     http.Client? client,
// //   }) : _client = client ?? http.Client();

// //   final String baseUrl;
// //   final String bearerToken;
// //   final String acceptDeclinePath;
// //   final http.Client _client;

// //   static const String pendingRequestPath =
// //       '/App/feed/get_all_friend_request';

// //   Future<Map<String, String>> _getHeaders() async {
// //     final token = await AuthService.getToken();
// //     final activeToken = (token != null && token.isNotEmpty) ? token : bearerToken;
// //     return {
// //       'Authorization': 'Bearer $activeToken',
// //       'Content-Type': 'application/json',
// //       'Accept': 'application/json',
// //     };
// //   }

// //   Future<List<FriendRequestItem>> getPendingFriendRequests() async {
// //     final response = await _client.post(
// //       Uri.parse('$baseUrl$pendingRequestPath'),
// //       headers: await _getHeaders(),
// //       body: jsonEncode({
// //         'type': 'pending',
// //         'search_keyword': '',
// //         'lat': '0',
// //         'lng': '0',
// //         'profileTypeArray': <String>[],
// //       }),
// //     );

// //     if (response.statusCode != 200) {
// //       throw Exception(
// //         'Failed to fetch friend requests. HTTP ${response.statusCode}: ${response.body}',
// //       );
// //     }

// //     final Map<String, dynamic> jsonMap = jsonDecode(response.body);
// //     final parsed = FriendRequestListResponse.fromJson(jsonMap);

// //     if (parsed.status != '200') {
// //       throw Exception('API returned status ${parsed.status}');
// //     }

// //     return parsed.data;
// //   }

// //   Future<String> acceptOrDeclineFriendRequest({
// //     required String friendRequestId,
// //     required String status,
// //   }) async {
// //     final response = await _client.post(
// //       Uri.parse('$baseUrl$acceptDeclinePath'),
// //       headers: await _getHeaders(),
// //       body: jsonEncode({
// //         'id': friendRequestId,
// //         'status': status,
// //       }),
// //     );

// //     if (response.statusCode != 200) {
// //       throw Exception(
// //         'Failed to update friend request. HTTP ${response.statusCode}: ${response.body}',
// //       );
// //     }

// //     final dynamic decoded = jsonDecode(response.body);

// //     if (decoded is Map<String, dynamic>) {
// //       final rawStatus = (decoded['status'] ?? '').toString().trim();
// //       final message = (decoded['message'] ?? decoded['msg'] ?? '').toString();

// //       final isSuccess = rawStatus.isEmpty ||
// //           rawStatus == '200' ||
// //           rawStatus == '1' ||
// //           rawStatus.toLowerCase() == 'true' ||
// //           rawStatus.toLowerCase() == 'success';

// //       if (!isSuccess) {
// //         throw Exception(message.isEmpty ? 'Request update failed' : message);
// //       }

// //       return message;
// //     }

// //     return '';
// //   }

// //   void dispose() => _client.close();
// // }

// // class FriendRequestListResponse {
// //   const FriendRequestListResponse({
// //     required this.status,
// //     required this.data,
// //   });

// //   final String status;
// //   final List<FriendRequestItem> data;

// //   factory FriendRequestListResponse.fromJson(Map<String, dynamic> json) {
// //     return FriendRequestListResponse(
// //       status: (json['status'] ?? '').toString(),
// //       data: (json['data'] as List<dynamic>? ?? [])
// //           .map((e) => FriendRequestItem.fromJson(e as Map<String, dynamic>))
// //           .toList(),
// //     );
// //   }
// // }

// // class FriendRequestItem {
// //   const FriendRequestItem({
// //     required this.friendRequestId,
// //     required this.id,
// //     required this.email,
// //     required this.username,
// //     required this.genderProfileType,
// //     required this.profileType,
// //     required this.cityName,
// //     required this.formattedAddress,
// //     required this.distanceUnit,
// //     required this.totalDistance,
// //     required this.age,
// //     required this.images,
// //   });

// //   final String friendRequestId;
// //   final String id;
// //   final String email;
// //   final String username;
// //   final String genderProfileType;
// //   final String profileType;
// //   final String cityName;
// //   final String formattedAddress;
// //   final String distanceUnit;
// //   final int totalDistance;
// //   final int age;
// //   final List<ProfileImageItem> images;

// //   String get profileImage => images.isNotEmpty ? images.first.profileImage : '';

// //   String get locationText {
// //     final location = formattedAddress.isNotEmpty ? formattedAddress : cityName;
// //     if (location.isEmpty) return 'Unknown location';
// //     return '$location | $totalDistance $distanceUnit';
// //   }

// //   factory FriendRequestItem.fromJson(Map<String, dynamic> json) {
// //     return FriendRequestItem(
// //       friendRequestId: (json['friend_request_id'] ?? '').toString(),
// //       id: (json['id'] ?? '').toString(),
// //       email: (json['email'] ?? '').toString(),
// //       username: (json['username'] ?? '').toString(),
// //       genderProfileType: (json['gender_profile_type'] ?? '').toString(),
// //       profileType: (json['profile_type'] ?? '').toString(),
// //       cityName: (json['city_name'] ?? '').toString(),
// //       formattedAddress: (json['formatted_address'] ?? '').toString(),
// //       distanceUnit: (json['distance'] ?? '').toString(),
// //       totalDistance: _toInt(json['total_distance']),
// //       age: _toInt(json['age']),
// //       images: (json['image'] as List<dynamic>? ?? [])
// //           .map((e) => ProfileImageItem.fromJson(e as Map<String, dynamic>))
// //           .toList(),
// //     );
// //   }

// //   static int _toInt(dynamic value) {
// //     if (value == null) return 0;
// //     if (value is int) return value;
// //     return int.tryParse(value.toString()) ?? 0;
// //   }
// // }

// // class ProfileImageItem {
// //   const ProfileImageItem({
// //     required this.profileImage,
// //     this.status,
// //   });

// //   final String profileImage;
// //   final String? status;

// //   factory ProfileImageItem.fromJson(Map<String, dynamic> json) {
// //     return ProfileImageItem(
// //       profileImage: (json['profile_image'] ?? '').toString(),
// //       status: json['status']?.toString(),
// //     );
// //   }
// // }

// // /*
// // ------------------------- HOW TO USE -------------------------

// // Option 1: Use full app wrapper

// // runApp(
// //   BeatFlirtFriendRequestApp(
// //     bearerToken: 'YOUR_BEARER_TOKEN',
// //     currentUsername: 'davidbrown',
// //     currentLocation: 'Ukkadam, Coimbatore, Tamil Nadu, India',
// //     currentUserImageUrl: 'https://your-image-url.com/profile.png',
// //   ),
// // );

// // Option 2: Use inside your existing app

// // void main() {
// //   runApp(
// //     const ProviderScope(
// //       child: MyApp(),
// //     ),
// //   );
// // }

// // MaterialApp(
// //   theme: BeatFlirtTheme.theme,
// //   home: FriendRequestPage(
// //     bearerToken: 'YOUR_BEARER_TOKEN',
// //     currentUsername: 'davidbrown',
// //     currentLocation: 'Ukkadam, Coimbatore, Tamil Nadu, India',
// //     currentUserImageUrl: 'https://your-image-url.com/profile.png',
// //   ),
// // )

// // --------------------------------------------------------------
// // */



// // // import 'dart:convert';

// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;

// // // /// Friend Request screen in a single file.
// // // ///
// // // /// Assumptions used:
// // // /// - Pending list API:
// // // ///   POST https://app.beatflirtevent.com/App/feed/get_all_friend_request
// // // /// - Accept / Decline API:
// // // ///   POST https://app.beatflirtevent.com/App/feed/accept_friend_request
// // // ///   body: {"id": "<friend_request_id>", "status": "1" or "2"}
// // // /// - Auth: Bearer token
// // // ///
// // // /// status = "1" => Accept
// // // /// status = "2" => Decline
// // // class FriendRequestPage extends StatefulWidget {
// // //   const FriendRequestPage({
// // //     super.key,
// // //     required this.bearerToken,
// // //     this.baseUrl = 'https://app.beatflirtevent.com',
// // //     this.currentUsername = 'davidbrown',
// // //     this.currentLocation = 'Ukkadam, Coimbatore, Tamil Nadu, India',
// // //     this.currentUserImageUrl,
// // //   });

// // //   final String bearerToken;
// // //   final String baseUrl;
// // //   final String currentUsername;
// // //   final String currentLocation;
// // //   final String? currentUserImageUrl;

// // //   @override
// // //   State<FriendRequestPage> createState() => _FriendRequestPageState();
// // // }

// // // class _FriendRequestPageState extends State<FriendRequestPage> {
// // //   late final FriendRequestApiService _service;

// // //   bool _isLoading = true;
// // //   bool _isActionLoading = false;
// // //   String? _errorMessage;
// // //   List<FriendRequestItem> _requests = [];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _service = FriendRequestApiService(
// // //       baseUrl: widget.baseUrl,
// // //       bearerToken: widget.bearerToken,
// // //     );
// // //     _loadRequests();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _service.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> _loadRequests() async {
// // //     setState(() {
// // //       _isLoading = true;
// // //       _errorMessage = null;
// // //     });

// // //     try {
// // //       final data = await _service.getPendingFriendRequests();
// // //       if (!mounted) return;
// // //       setState(() {
// // //         _requests = data;
// // //       });
// // //     } catch (e) {
// // //       if (!mounted) return;
// // //       setState(() {
// // //         _errorMessage = e.toString();
// // //       });
// // //     } finally {
// // //       if (!mounted) return;
// // //       setState(() {
// // //         _isLoading = false;
// // //       });
// // //     }
// // //   }

// // //   Future<void> _updateRequestStatus({
// // //     required FriendRequestItem item,
// // //     required String status,
// // //   }) async {
// // //     setState(() => _isActionLoading = true);

// // //     try {
// // //       await _service.acceptOrDeclineFriendRequest(
// // //         friendRequestId: item.friendRequestId,
// // //         status: status,
// // //       );

// // //       if (!mounted) return;

// // //       setState(() {
// // //         _requests.removeWhere(
// // //           (request) => request.friendRequestId == item.friendRequestId,
// // //         );
// // //       });

// // //       final actionText = status == '1' ? 'accepted' : 'declined';
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('${item.username} $actionText successfully')),
// // //       );
// // //     } catch (e) {
// // //       if (!mounted) return;
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Action failed: $e')),
// // //       );
// // //     } finally {
// // //       if (!mounted) return;
// // //       setState(() => _isActionLoading = false);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFF120033),
// // //       body: SafeArea(
// // //         child: RefreshIndicator(
// // //           onRefresh: _loadRequests,
// // //           child: CustomScrollView(
// // //             physics: const AlwaysScrollableScrollPhysics(),
// // //             slivers: [
// // //               SliverToBoxAdapter(
// // //                 child: Container(
// // //                   decoration: const BoxDecoration(
// // //                     color: Color(0xFFF8EFF4),
// // //                     borderRadius: BorderRadius.only(
// // //                       bottomLeft: Radius.circular(28),
// // //                       bottomRight: Radius.circular(28),
// // //                     ),
// // //                   ),
// // //                   child: Column(
// // //                     children: [
// // //                       _buildTopHeader(),
// // //                       _buildLocationBar(),
// // //                       Padding(
// // //                         padding: const EdgeInsets.fromLTRB(10, 22, 10, 28),
// // //                         child: _buildMainContent(),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildTopHeader() {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
// // //       child: Row(
// // //         children: [
// // //           const Icon(Icons.menu, size: 38, color: Color(0xFF43202E)),
// // //           const SizedBox(width: 14),
// // //           CircleAvatar(
// // //             radius: 24,
// // //             backgroundColor: Colors.white,
// // //             backgroundImage: widget.currentUserImageUrl != null &&
// // //                     widget.currentUserImageUrl!.isNotEmpty
// // //                 ? NetworkImage(widget.currentUserImageUrl!)
// // //                 : null,
// // //             child: widget.currentUserImageUrl == null ||
// // //                     widget.currentUserImageUrl!.isEmpty
// // //                 ? const Icon(Icons.person, color: Colors.black54)
// // //                 : null,
// // //           ),
// // //           const SizedBox(width: 14),
// // //           Expanded(
// // //             child: Text(
// // //               widget.currentUsername,
// // //               style: const TextStyle(
// // //                 fontSize: 22,
// // //                 fontWeight: FontWeight.w700,
// // //                 color: Color(0xFF37383E),
// // //               ),
// // //             ),
// // //           ),
// // //           const Icon(Icons.notifications_active,
// // //               color: Color(0xFFFFB700), size: 28),
// // //           const SizedBox(width: 18),
// // //           const Icon(Icons.logout, color: Color(0xFFE63D84), size: 28),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildLocationBar() {
// // //     return Container(
// // //       width: double.infinity,
// // //       color: const Color(0xFF5A0028),
// // //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           const Icon(Icons.location_on, color: Colors.yellow, size: 28),
// // //           const SizedBox(width: 8),
// // //           Flexible(
// // //             child: Text(
// // //               widget.currentLocation,
// // //               textAlign: TextAlign.center,
// // //               style: const TextStyle(
// // //                 color: Colors.yellow,
// // //                 fontSize: 15,
// // //                 fontWeight: FontWeight.w700,
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildMainContent() {
// // //     if (_isLoading) {
// // //       return const SizedBox(
// // //         height: 560,
// // //         child: Center(child: CircularProgressIndicator()),
// // //       );
// // //     }

// // //     if (_errorMessage != null) {
// // //       return SizedBox(
// // //         height: 560,
// // //         child: Center(
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(24),
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 const Icon(Icons.error_outline, color: Colors.red, size: 48),
// // //                 const SizedBox(height: 12),
// // //                 Text(
// // //                   _errorMessage!,
// // //                   textAlign: TextAlign.center,
// // //                   style: const TextStyle(
// // //                     fontSize: 15,
// // //                     color: Colors.black87,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 ElevatedButton(
// // //                   onPressed: _loadRequests,
// // //                   child: const Text('Retry'),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       );
// // //     }

// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Padding(
// // //           padding: const EdgeInsets.symmetric(horizontal: 16),
// // //           child: Text(
// // //             'Friend Request (${_requests.length})',
// // //             style: const TextStyle(
// // //               fontSize: 30,
// // //               fontWeight: FontWeight.w800,
// // //               color: Color(0xFF26093E),
// // //             ),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 22),
// // //         if (_requests.isEmpty)
// // //           Container(
// // //             width: double.infinity,
// // //             margin: const EdgeInsets.symmetric(horizontal: 8),
// // //             padding: const EdgeInsets.all(32),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(28),
// // //             ),
// // //             child: const Column(
// // //               children: [
// // //                 Icon(Icons.people_outline,
// // //                     size: 56, color: Color(0xFF5A0028)),
// // //                 SizedBox(height: 12),
// // //                 Text(
// // //                   'No pending friend requests',
// // //                   style: TextStyle(
// // //                     fontSize: 18,
// // //                     fontWeight: FontWeight.w700,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           )
// // //         else
// // //           ListView.separated(
// // //             itemCount: _requests.length,
// // //             shrinkWrap: true,
// // //             physics: const NeverScrollableScrollPhysics(),
// // //             separatorBuilder: (_, __) => const SizedBox(height: 22),
// // //             itemBuilder: (context, index) {
// // //               final item = _requests[index];
// // //               return _FriendRequestCard(
// // //                 item: item,
// // //                 isLoading: _isActionLoading,
// // //                 onAccept: () => _updateRequestStatus(item: item, status: '1'),
// // //                 onDecline: () => _updateRequestStatus(item: item, status: '2'),
// // //               );
// // //             },
// // //           ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // class _FriendRequestCard extends StatelessWidget {
// // //   const _FriendRequestCard({
// // //     required this.item,
// // //     required this.onAccept,
// // //     required this.onDecline,
// // //     required this.isLoading,
// // //   });

// // //   final FriendRequestItem item;
// // //   final VoidCallback onAccept;
// // //   final VoidCallback onDecline;
// // //   final bool isLoading;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(horizontal: 8),
// // //       padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
// // //       decoration: BoxDecoration(
// // //         gradient: const LinearGradient(
// // //           begin: Alignment.topCenter,
// // //           end: Alignment.bottomCenter,
// // //           colors: [Color(0xFF70063A), Color(0xFF11003D)],
// // //         ),
// // //         borderRadius: BorderRadius.circular(34),
// // //         boxShadow: const [
// // //           BoxShadow(
// // //             color: Colors.black12,
// // //             blurRadius: 20,
// // //             offset: Offset(0, 12),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Container(
// // //             width: 170,
// // //             height: 170,
// // //             padding: const EdgeInsets.all(5),
// // //             decoration: BoxDecoration(
// // //               borderRadius: BorderRadius.circular(28),
// // //               border: Border.all(color: const Color(0xFFFF237D), width: 5),
// // //             ),
// // //             child: ClipRRect(
// // //               borderRadius: BorderRadius.circular(22),
// // //               child: item.profileImage.isNotEmpty
// // //                   ? Image.network(
// // //                       item.profileImage,
// // //                       fit: BoxFit.cover,
// // //                       errorBuilder: (_, __, ___) => Container(
// // //                         color: Colors.white10,
// // //                         child: const Icon(Icons.person,
// // //                             color: Colors.white, size: 70),
// // //                       ),
// // //                     )
// // //                   : Container(
// // //                       color: Colors.white10,
// // //                       child: const Icon(Icons.person,
// // //                           color: Colors.white, size: 70),
// // //                     ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 22),
// // //           Text(
// // //             item.username,
// // //             textAlign: TextAlign.center,
// // //             style: const TextStyle(
// // //               fontSize: 28,
// // //               fontWeight: FontWeight.w800,
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 14),
// // //           Container(
// // //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
// // //             decoration: BoxDecoration(
// // //               color: const Color(0xFFFF1D70),
// // //               borderRadius: BorderRadius.circular(28),
// // //             ),
// // //             child: Text(
// // //               'Age ${item.age}',
// // //               style: const TextStyle(
// // //                 color: Colors.white,
// // //                 fontSize: 16,
// // //                 fontWeight: FontWeight.w700,
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 30),
// // //           Text(
// // //             item.genderProfileType,
// // //             style: const TextStyle(
// // //               color: Colors.white,
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.w700,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 14),
// // //           Row(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               const Padding(
// // //                 padding: EdgeInsets.only(top: 1),
// // //                 child: Icon(Icons.location_on, color: Colors.white, size: 28),
// // //               ),
// // //               const SizedBox(width: 6),
// // //               Flexible(
// // //                 child: Text(
// // //                   item.locationText,
// // //                   textAlign: TextAlign.center,
// // //                   style: const TextStyle(
// // //                     color: Colors.white,
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.w700,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 18),
// // //           const Icon(Icons.favorite, color: Color(0xFFFF7EA7), size: 38),
// // //           const SizedBox(height: 20),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: OutlinedButton(
// // //                   onPressed: isLoading ? null : onAccept,
// // //                   style: OutlinedButton.styleFrom(
// // //                     side: const BorderSide(color: Colors.white, width: 2),
// // //                     padding: const EdgeInsets.symmetric(vertical: 14),
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(10),
// // //                     ),
// // //                   ),
// // //                   child: isLoading
// // //                       ? const SizedBox(
// // //                           width: 20,
// // //                           height: 20,
// // //                           child: CircularProgressIndicator(
// // //                             strokeWidth: 2,
// // //                             color: Colors.white,
// // //                           ),
// // //                         )
// // //                       : const Text(
// // //                           'Accept',
// // //                           style: TextStyle(
// // //                             fontSize: 18,
// // //                             fontWeight: FontWeight.w700,
// // //                             color: Colors.white,
// // //                           ),
// // //                         ),
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 20),
// // //               Expanded(
// // //                 child: OutlinedButton(
// // //                   onPressed: isLoading ? null : onDecline,
// // //                   style: OutlinedButton.styleFrom(
// // //                     side: const BorderSide(color: Colors.white, width: 2),
// // //                     padding: const EdgeInsets.symmetric(vertical: 14),
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(10),
// // //                     ),
// // //                   ),
// // //                   child: const Text(
// // //                     'Decline',
// // //                     style: TextStyle(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.w700,
// // //                       color: Colors.white,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class FriendRequestApiService {
// // //   FriendRequestApiService({
// // //     required this.baseUrl,
// // //     required this.bearerToken,
// // //     http.Client? client,
// // //   }) : _client = client ?? http.Client();

// // //   final String baseUrl;
// // //   final String bearerToken;
// // //   final http.Client _client;

// // //   static const String pendingRequestPath =
// // //       '/App/feed/get_all_friend_request';
// // //   static const String acceptDeclinePath =
// // //       '/App/feed/accept_friend_request';

// // //   Future<List<FriendRequestItem>> getPendingFriendRequests() async {
// // //     final uri = Uri.parse('$baseUrl$pendingRequestPath');

// // //     final response = await _client.post(
// // //       uri,
// // //       headers: _headers,
// // //       body: jsonEncode({
// // //         'type': 'pending',
// // //         'search_keyword': '',
// // //         'lat': '0',
// // //         'lng': '0',
// // //         'profileTypeArray': <String>[],
// // //       }),
// // //     );

// // //     if (response.statusCode != 200) {
// // //       throw Exception(
// // //         'Failed to fetch requests. HTTP ${response.statusCode}: ${response.body}',
// // //       );
// // //     }

// // //     final Map<String, dynamic> jsonMap = jsonDecode(response.body);
// // //     final apiResponse = FriendRequestListResponse.fromJson(jsonMap);

// // //     if (apiResponse.status != '200') {
// // //       throw Exception('API returned status ${apiResponse.status}');
// // //     }

// // //     return apiResponse.data;
// // //   }

// // //   Future<void> acceptOrDeclineFriendRequest({
// // //     required String friendRequestId,
// // //     required String status,
// // //   }) async {
// // //     final uri = Uri.parse('$baseUrl$acceptDeclinePath');

// // //     final response = await _client.post(
// // //       uri,
// // //       headers: _headers,
// // //       body: jsonEncode({
// // //         'id': friendRequestId,
// // //         'status': status,
// // //       }),
// // //     );

// // //     if (response.statusCode != 200) {
// // //       throw Exception(
// // //         'Failed to update request. HTTP ${response.statusCode}: ${response.body}',
// // //       );
// // //     }

// // //     final dynamic decoded = jsonDecode(response.body);

// // //     if (decoded is Map<String, dynamic>) {
// // //       final statusValue = (decoded['status'] ?? '').toString();
// // //       final message = (decoded['message'] ?? decoded['msg'] ?? 'Something went wrong')
// // //           .toString();

// // //       if (statusValue.isNotEmpty &&
// // //           statusValue != '200' &&
// // //           statusValue != '1' &&
// // //           statusValue.toLowerCase() != 'true') {
// // //         throw Exception(message);
// // //       }
// // //     }
// // //   }

// // //   Map<String, String> get _headers => {
// // //         'Authorization': 'Bearer $bearerToken',
// // //         'Content-Type': 'application/json',
// // //         'Accept': 'application/json',
// // //       };

// // //   void dispose() {
// // //     _client.close();
// // //   }
// // // }

// // // class FriendRequestListResponse {
// // //   FriendRequestListResponse({
// // //     required this.status,
// // //     required this.data,
// // //   });

// // //   final String status;
// // //   final List<FriendRequestItem> data;

// // //   factory FriendRequestListResponse.fromJson(Map<String, dynamic> json) {
// // //     return FriendRequestListResponse(
// // //       status: (json['status'] ?? '').toString(),
// // //       data: (json['data'] as List<dynamic>? ?? [])
// // //           .map((e) => FriendRequestItem.fromJson(e as Map<String, dynamic>))
// // //           .toList(),
// // //     );
// // //   }
// // // }

// // // class FriendRequestItem {
// // //   FriendRequestItem({
// // //     required this.friendRequestId,
// // //     required this.id,
// // //     required this.email,
// // //     required this.username,
// // //     required this.genderProfileType,
// // //     required this.profileType,
// // //     required this.cityName,
// // //     required this.formattedAddress,
// // //     required this.distanceUnit,
// // //     required this.totalDistance,
// // //     required this.age,
// // //     required this.images,
// // //   });

// // //   final String friendRequestId;
// // //   final String id;
// // //   final String email;
// // //   final String username;
// // //   final String genderProfileType;
// // //   final String profileType;
// // //   final String cityName;
// // //   final String formattedAddress;
// // //   final String distanceUnit;
// // //   final int totalDistance;
// // //   final int age;
// // //   final List<ProfileImageItem> images;

// // //   String get profileImage => images.isNotEmpty ? images.first.profileImage : '';

// // //   String get locationText {
// // //     final location = formattedAddress.isNotEmpty ? formattedAddress : cityName;
// // //     if (location.isEmpty) return 'Unknown location';
// // //     return '$location | $totalDistance $distanceUnit';
// // //   }

// // //   factory FriendRequestItem.fromJson(Map<String, dynamic> json) {
// // //     return FriendRequestItem(
// // //       friendRequestId: (json['friend_request_id'] ?? '').toString(),
// // //       id: (json['id'] ?? '').toString(),
// // //       email: (json['email'] ?? '').toString(),
// // //       username: (json['username'] ?? '').toString(),
// // //       genderProfileType: (json['gender_profile_type'] ?? '').toString(),
// // //       profileType: (json['profile_type'] ?? '').toString(),
// // //       cityName: (json['city_name'] ?? '').toString(),
// // //       formattedAddress: (json['formatted_address'] ?? '').toString(),
// // //       distanceUnit: (json['distance'] ?? '').toString(),
// // //       totalDistance: _toInt(json['total_distance']),
// // //       age: _toInt(json['age']),
// // //       images: (json['image'] as List<dynamic>? ?? [])
// // //           .map((e) => ProfileImageItem.fromJson(e as Map<String, dynamic>))
// // //           .toList(),
// // //     );
// // //   }

// // //   static int _toInt(dynamic value) {
// // //     if (value == null) return 0;
// // //     if (value is int) return value;
// // //     return int.tryParse(value.toString()) ?? 0;
// // //   }
// // // }

// // // class ProfileImageItem {
// // //   ProfileImageItem({
// // //     required this.profileImage,
// // //     this.status,
// // //   });

// // //   final String profileImage;
// // //   final String? status;

// // //   factory ProfileImageItem.fromJson(Map<String, dynamic> json) {
// // //     return ProfileImageItem(
// // //       profileImage: (json['profile_image'] ?? '').toString(),
// // //       status: json['status']?.toString(),
// // //     );
// // //   }
// // // }

// // // /*
// // // USAGE:

// // // 1) Add dependency in pubspec.yaml

// // // dependencies:
// // //   flutter:
// // //     sdk: flutter
// // //   http: ^1.2.2

// // // 2) Open this page:

// // // MaterialApp(
// // //   debugShowCheckedModeBanner: false,
// // //   home: FriendRequestPage(
// // //     bearerToken: 'YOUR_BEARER_TOKEN',
// // //     currentUsername: 'davidbrown',
// // //     currentLocation: 'Ukkadam, Coimbatore, Tamil Nadu, India',
// // //     currentUserImageUrl: 'https://your-image-url.com/profile.png',
// // //   ),
// // // )

// // // */


// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:beatflirt/providers/user_list_provider.dart';
// // // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // // import 'package:beatflirt/screens/drawer_pages/friends_page.dart';

// // // // class FriendRequestPage extends ConsumerWidget {
// // // //   const FriendRequestPage({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final state = ref.watch(userListProvider('friend_requests'));

// // // //     return Scaffold(
// // // //       backgroundColor: const Color(0xFF0F0F1A),
// // // //       body: CustomScrollView(
// // // //         physics: const BouncingScrollPhysics(),
// // // //         slivers: [
// // // //           _buildAppBar(context),
// // // //           _buildRequestHeader(state.users.length),
// // // //           _buildRequestList(context, ref, state.users),
// // // //           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildAppBar(BuildContext context) {
// // // //     return SliverAppBar(
// // // //       floating: true,
// // // //       pinned: true,
// // // //       backgroundColor: const Color(0xFF0F0F1A),
// // // //       elevation: 0,
// // // //       leading: IconButton(
// // // //         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
// // // //         onPressed: () => Navigator.pop(context),
// // // //       ),
// // // //       centerTitle: true,
// // // //       title: const Text(
// // // //         'FRIEND REQUESTS',
// // // //         style: TextStyle(
// // // //           color: Colors.white,
// // // //           fontWeight: FontWeight.w900,
// // // //           fontSize: 16,
// // // //           letterSpacing: 2.0,
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildRequestHeader(int count) {
// // // //     return SliverToBoxAdapter(
// // // //       child: Container(
// // // //         margin: const EdgeInsets.all(20),
// // // //         padding: const EdgeInsets.all(25),
// // // //         decoration: BoxDecoration(
// // // //           borderRadius: BorderRadius.circular(30),
// // // //           gradient: const LinearGradient(
// // // //             colors: [Color(0xFF2196F3), Color(0xFF0F0F1A)],
// // // //             begin: Alignment.topLeft,
// // // //             end: Alignment.bottomRight,
// // // //           ),
// // // //         ),
// // // //         child: Row(
// // // //           children: [
// // // //             const CircleAvatar(
// // // //               radius: 30,
// // // //               backgroundColor: Colors.white24,
// // // //               child: FaIcon(FontAwesomeIcons.userCheck, color: Colors.white, size: 25),
// // // //             ),
// // // //             const SizedBox(width: 20),
// // // //             Expanded(
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   const Text('Pending Items', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
// // // //                   Text('$count people want to connect', style: const TextStyle(color: Colors.white70, fontSize: 13)),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildRequestList(BuildContext context, WidgetRef ref, List<UserListItem> users) {
// // // //     if (users.isEmpty) {
// // // //       return const SliverFillRemaining(
// // // //         hasScrollBody: false,
// // // //         child: Center(
// // // //           child: Text(
// // // //             'No pending requests right now.',
// // // //             style: TextStyle(color: Colors.white54, fontSize: 16),
// // // //           ),
// // // //         ),
// // // //       );
// // // //     }

// // // //     return SliverList(
// // // //       delegate: SliverChildBuilderDelegate(
// // // //         (context, index) {
// // // //           final user = users[index];
// // // //           return _buildRequestCard(context, ref, user);
// // // //         },
// // // //         childCount: users.length,
// // // //       ),
// // // //     );
// // // //   }




// // // //   Widget _buildRequestCard(BuildContext context, WidgetRef ref, UserListItem user) {
// // // //     return Container(
// // // //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// // // //       padding: const EdgeInsets.all(15),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white.withValues(alpha: 0.05),
// // // //         borderRadius: BorderRadius.circular(20),
// // // //         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           CircleAvatar(
// // // //             radius: 30,
// // // //             backgroundImage: user.imageUrl.startsWith('assets/')
// // // //                 ? AssetImage(user.imageUrl) as ImageProvider
// // // //                 : NetworkImage(user.imageUrl),
// // // //           ),
// // // //           const SizedBox(width: 15),
// // // //           Expanded(
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
// // // //                 Text('Wants to be your friend', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           Column(
// // // //             children: [
// // // //               ElevatedButton(
// // // //                 onPressed: () async {
// // // //                   await ref.read(userListProvider('friend_requests').notifier).acceptFriendRequest(user.id);
// // // //                   ref.read(userListProvider('friends').notifier).fetchUsers();
// // // //                   if (context.mounted) {
// // // //                     Navigator.pushReplacement(
// // // //                       context,
// // // //                       MaterialPageRoute(builder: (context) => const FriendsPage()),
// // // //                     );
// // // //                   }
// // // //                 },
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: Colors.blue,
// // // //                   foregroundColor: Colors.white,
// // // //                   minimumSize: const Size(80, 32),
// // // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // // //                 ),
// // // //                 child: const Text('Accept', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
// // // //               ),
// // // //               const SizedBox(height: 5),
// // // //               TextButton(
// // // //                 onPressed: () async {
// // // //                   await ref.read(userListProvider('friend_requests').notifier).declineFriendRequest(user.id);
// // // //                 },
// // // //                 style: TextButton.styleFrom(minimumSize: const Size(80, 32)),
// // // //                 child: const Text('Decline', style: TextStyle(color: Colors.white54, fontSize: 11)),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

