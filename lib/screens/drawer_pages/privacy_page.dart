// Beat Flirt /privacy screen converted from:
// https://beatflirtevent.com/privacy
//
// Main class: PrivacyPage
//
// Required pubspec dependencies:
//   http: ^1.2.2
//   shared_preferences: ^2.3.2
//
// AndroidManifest.xml:
//   <uses-permission android:name="android.permission.INTERNET" />

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _apiBase = 'https://app.beatflirtevent.com/App';

bool _ok(dynamic status) => status?.toString() == '200';

int _asInt(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? fallback;
}

bool _asBool(dynamic value) => value == true || value?.toString() == '1';

String _asString(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final s = value.toString();
  return s.isEmpty ? fallback : s;
}

class BeatPrivacyApiException implements Exception {
  BeatPrivacyApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class PrivacySettingsData {
  PrivacySettingsData({
    this.profileShowEveryoneOrFriend = 1,
    this.profileShowCountries = false,
    this.profileShowCountriesLat = '',
    this.profileShowCountriesLng = '',
    this.showAge = true,
    this.showGender = true,
    this.showLocation = true,
    this.showRelationship = true,
    this.showInterestsPreferences = true,
    this.showLanguagePreferences = true,
    this.showProfileImage = true,
    this.showSearchResult = true,
    this.showOnlineStatus = true,
    this.showActivityVisitCommentsLike = true,
    this.showAppearInSearchResults = true,
    this.showProfileChatMessage = 1,
    this.showNotificationNewMessage = true,
    this.showNotificationLike = true,
    this.showNotificationValidation = true,
    this.showNotificationFriendRequest = true,
  });

  /// 1 = Public / everyone, 0 = Friends/Connections only
  int profileShowEveryoneOrFriend;
  bool profileShowCountries;
  String profileShowCountriesLat;
  String profileShowCountriesLng;

  bool showAge;
  bool showGender;
  bool showLocation;
  bool showRelationship;
  bool showInterestsPreferences;
  bool showLanguagePreferences;
  bool showProfileImage;
  bool showSearchResult;
  bool showOnlineStatus;
  bool showActivityVisitCommentsLike;
  bool showAppearInSearchResults;

  /// 1 = anyone can message me, 2 = friends/connections only
  int showProfileChatMessage;

  bool showNotificationNewMessage;
  bool showNotificationLike;
  bool showNotificationValidation;
  bool showNotificationFriendRequest;

  factory PrivacySettingsData.fromJson(Map<String, dynamic> json) {
    return PrivacySettingsData(
      profileShowEveryoneOrFriend: _asInt(json['profile_show_everyone_or_friend'], 1),
      profileShowCountries: _asBool(json['profile_show_countries']),
      profileShowCountriesLat: _asString(json['profile_show_countries_lat']),
      profileShowCountriesLng: _asString(json['profile_show_countries_lng']),
      showAge: _asBool(json['show_age']),
      showGender: _asBool(json['show_gender']),
      showLocation: _asBool(json['show_location']),
      showRelationship: _asBool(json['show_relationship']),
      showInterestsPreferences: _asBool(json['show_interests_preferences']),
      showLanguagePreferences: _asBool(json['show_language_preferences']),
      showProfileImage: _asBool(json['show_profile_image']),
      showSearchResult: _asBool(json['show_search_result']),
      showOnlineStatus: _asBool(json['show_online_status']),
      showActivityVisitCommentsLike: _asBool(json['show_activity_visit_comments_like']),
      showAppearInSearchResults: _asBool(json['show_appear_in_search_results']),
      showProfileChatMessage: _asInt(json['show_profile_chat_message'], 1),
      showNotificationNewMessage: _asBool(json['show_notification_new_message']),
      showNotificationLike: _asBool(json['show_notification_like']),
      showNotificationValidation: _asBool(json['show_notification_validation']),
      showNotificationFriendRequest: _asBool(json['show_notification_friend_request']),
    );
  }

  Map<String, dynamic> toUpdateJson() {
    int b(bool value) => value ? 1 : 0;

    return {
      'profile_show_everyone_or_friend': profileShowEveryoneOrFriend,
      'profile_show_countries': b(profileShowCountries),
      'profile_show_countries_lat': profileShowCountriesLat,
      'profile_show_countries_lng': profileShowCountriesLng,
      'show_age': b(showAge),
      'show_gender': b(showGender),
      'show_location': b(showLocation),
      'show_relationship': b(showRelationship),
      'show_interests_preferences': b(showInterestsPreferences),
      'show_language_preferences': b(showLanguagePreferences),
      'show_profile_image': b(showProfileImage),
      'show_search_result': b(showSearchResult),
      'show_online_status': b(showOnlineStatus),
      'show_activity_visit_comments_like': b(showActivityVisitCommentsLike),
      'show_appear_in_search_results': b(showAppearInSearchResults),

      // These 3 keys are included by the website update payload even though
      // the current UI uses show_profile_chat_message radio buttons.
      'show_chat_message_everyone': showProfileChatMessage == 1 ? 1 : 0,
      'show_chat_message_friend_connections': showProfileChatMessage == 2 ? 1 : 0,
      'show_chat_message_friend_od_friend': 0,

      'show_notification_new_message': b(showNotificationNewMessage),
      'show_notification_like': b(showNotificationLike),
      'show_notification_validation': b(showNotificationValidation),
      'show_notification_friend_request': b(showNotificationFriendRequest),
      'show_profile_chat_message': showProfileChatMessage,
    };
  }
}

class BeatPrivacyApi {
  BeatPrivacyApi({
    required this.accessToken,
    required this.accessSign,
    this.baseUrl = _apiBase,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String accessToken;
  final String accessSign;
  final String baseUrl;
  final http.Client _client;

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      if (accessToken.isNotEmpty) 'Access-Token': accessToken,
      if (accessSign.isNotEmpty) 'Access-Sign': accessSign,
    };
  }

  Future<Map<String, dynamic>> _decode(http.Response response) async {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BeatPrivacyApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw BeatPrivacyApiException('Unexpected API response');
  }

  /// Website API: GET /user/privacy_details
  Future<PrivacySettingsData> getPrivacyDetails() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/user/privacy_details'),
      headers: _headers,
    );
    final json = await _decode(response);
    if (_ok(json['status']) && json['data'] is Map) {
      return PrivacySettingsData.fromJson(Map<String, dynamic>.from(json['data'] as Map));
    }
    throw BeatPrivacyApiException(_asString(json['message'], 'Unable to load privacy settings'));
  }

  /// Website API: POST /user/update_privacy
  Future<String> updatePrivacy(PrivacySettingsData data) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/user/update_privacy'),
      headers: _headers,
      body: jsonEncode(data.toUpdateJson()),
    );
    final json = await _decode(response);
    final message = _asString(json['message'], _ok(json['status']) ? 'Success' : 'Request failed');
    if (!_ok(json['status'])) throw BeatPrivacyApiException(message);
    return message;
  }
}

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({
    super.key,
    this.api,
    this.accessToken,
    this.accessSign,
  });

  final BeatPrivacyApi? api;
  final String? accessToken;
  final String? accessSign;

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  static const Color _lightBg = Color(0xFFFFF4FA);
  static const Color _primary = Color(0xFF1D042A);
  static const Color _maroon = Color(0xFF560827);
  static const Color _navy = Color(0xFF06032C);
  static const Color _pink = Color(0xFFE91E63);

  BeatPrivacyApi? _api;
  PrivacySettingsData? _settings;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _api = widget.api ??
        BeatPrivacyApi(
          accessToken: widget.accessToken ??
              prefs.getString('Access-Token') ??
              prefs.getString('auth_token') ??
              prefs.getString('token') ??
              '',
          accessSign: widget.accessSign ??
              prefs.getString('Access-Sign') ??
              prefs.getString('sign') ??
              '',
        );
    await _loadPrivacy();
  }

  Future<void> _loadPrivacy() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await api.getPrivacyDetails();
      if (!mounted) return;
      setState(() => _settings = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _savePrivacy() async {
    final api = _api;
    final settings = _settings;
    if (api == null || settings == null) return;
    setState(() => _saving = true);
    try {
      final message = await api.updatePrivacy(settings);
      _snack(message);
      await _loadPrivacy();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
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

  void _mutate(void Function(PrivacySettingsData s) update) {
    final s = _settings;
    if (s == null) return;
    setState(() => update(s));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('Privacy Settings',style:TextStyle(fontSize:22)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _primary,size:20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: _lightBg,
        elevation: 0,
        surfaceTintColor: _lightBg,
      ),
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: _maroon,
              onRefresh: _loadPrivacy,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // const Text(
                  //   'Privacy Settings',
                  //   style: TextStyle(color: _primary, fontSize: 28, fontWeight: FontWeight.w700),
                  // ),
                  // const SizedBox(height: 8),
                  const Text(
                    'You can change these selections at any time.',
                    style: TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  if (_loading && _settings == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: Center(child: CircularProgressIndicator(color: _maroon)),
                    )
                  else if (_error != null)
                    _errorBox(_error!)
                  else if (_settings != null)
                    _privacyForm(_settings!),
                ],
              ),
            ),
            if (_saving || (_loading && _settings != null))
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.04),
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 8),
                    child: const LinearProgressIndicator(color: _maroon, minHeight: 3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _privacyForm(PrivacySettingsData s) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 26, offset: Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _block(
            'Profile Visibility',
            [
              _radioTile(
                title: 'Public: Profile visible to everyone',
                value: 1,
                groupValue: s.profileShowEveryoneOrFriend,
                onChanged: (v) => _mutate((s) => s.profileShowEveryoneOrFriend = v),
              ),
              _radioTile(
                title: 'Friends/Connections Only',
                value: 0,
                groupValue: s.profileShowEveryoneOrFriend,
                onChanged: (v) => _mutate((s) => s.profileShowEveryoneOrFriend = v),
              ),
              _checkboxTile(
                title: 'Block Specific Countries/Regions',
                value: s.profileShowCountries,
                onChanged: (v) => _mutate((s) => s.profileShowCountries = v),
              ),
            ],
          ),
          _block(
            'Personal Information Privacy',
            [
              _switchTile('Age / Birthdate', s.showAge, (v) => _mutate((s) => s.showAge = v)),
              _switchTile('Gender', s.showGender, (v) => _mutate((s) => s.showGender = v)),
              _switchTile('Location / City', s.showLocation, (v) => _mutate((s) => s.showLocation = v)),
              _switchTile('Relationship Status', s.showRelationship, (v) => _mutate((s) => s.showRelationship = v)),
              _switchTile('Interests & Preferences', s.showInterestsPreferences, (v) => _mutate((s) => s.showInterestsPreferences = v)),
              _switchTile('Language Preferences', s.showLanguagePreferences, (v) => _mutate((s) => s.showLanguagePreferences = v)),
            ],
          ),
          _block(
            'Profile Picture & Cover Photo',
            [
              _switchTile('Profile Picture Visibility', s.showProfileImage, (v) => _mutate((s) => s.showProfileImage = v)),
              _switchTile('Hide from Search Results', s.showSearchResult, (v) => _mutate((s) => s.showSearchResult = v)),
            ],
          ),
          _block(
            'Activity & Status Privacy',
            [
              _switchTile('Online Status Indicator', s.showOnlineStatus, (v) => _mutate((s) => s.showOnlineStatus = v)),
              _switchTile('Recent Activity', s.showActivityVisitCommentsLike, (v) => _mutate((s) => s.showActivityVisitCommentsLike = v)),
            ],
          ),
          _block(
            'Search & Discovery',
            [
              _switchTile('Appear in Search Results', s.showAppearInSearchResults, (v) => _mutate((s) => s.showAppearInSearchResults = v)),
            ],
          ),
          _block(
            'Messaging Privacy',
            [
              _radioTile(
                title: 'Anyone can message me',
                value: 1,
                groupValue: s.showProfileChatMessage,
                onChanged: (v) => _mutate((s) => s.showProfileChatMessage = v),
              ),
              _radioTile(
                title: 'Friends / Connections only',
                value: 2,
                groupValue: s.showProfileChatMessage,
                onChanged: (v) => _mutate((s) => s.showProfileChatMessage = v),
              ),
            ],
          ),
          _block(
            'Notifications',
            [
              _switchTile('New Message', s.showNotificationNewMessage, (v) => _mutate((s) => s.showNotificationNewMessage = v)),
              _switchTile('New Like / Match', s.showNotificationLike, (v) => _mutate((s) => s.showNotificationLike = v)),
              _switchTile('New Validation', s.showNotificationValidation, (v) => _mutate((s) => s.showNotificationValidation = v)),
              _switchTile('New Friend Request', s.showNotificationFriendRequest, (v) => _mutate((s) => s.showNotificationFriendRequest = v)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _saving ? null : _savePrivacy,
            style: ElevatedButton.styleFrom(
              backgroundColor: _maroon,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Update', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _block(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Material(
        color: const Color(0xFFFFF7FC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFF1D9E8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: _maroon, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioTile({
    required String title,
    required int value,
    required int groupValue,
    required ValueChanged<int> onChanged,
  }) {
    return RadioListTile<int>(
      dense: true,
      contentPadding: EdgeInsets.zero,
      activeColor: _maroon,
      title: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 15)),
      value: value,
      groupValue: groupValue,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _checkboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      activeColor: _maroon,
      title: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 15)),
      value: value,
      onChanged: (v) => onChanged(v ?? false),
    );
  }

  Widget _switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 15))),
          Switch(
            activeColor: _pink,
            value: value,
            onChanged: onChanged,
          ),
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
            onPressed: _loadPrivacy,
            style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}


// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import '../../providers/privacy_provider.dart';

// // class PrivacyPage extends ConsumerWidget {
// //   const PrivacyPage({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final privacyState = ref.watch(privacyProvider);
// //     final privacyNotifier = ref.read(privacyProvider.notifier);

// //     return Scaffold(
// //       backgroundColor: const Color(0xFF0F0F1A), // AAA Premium Dark Background
// //       body: CustomScrollView(
// //         physics: const BouncingScrollPhysics(),
// //         slivers: [
// //           _buildAppBar(context),
// //           SliverPadding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //             sliver: SliverList(
// //               delegate: SliverChildListDelegate([
// //                 _buildInfoBox(),
// //                 const SizedBox(height: 30),
// //                 _buildSectionHeader("Visibility Settings"),
// //                 _buildSettingsCard([
// //                   _buildCustomToggle(
// //                     icon: FontAwesomeIcons.solidCircleDot,
// //                     title: "Online Status",
// //                     subtitle: "Let others know when you are active.",
// //                     value: privacyState.showOnlineStatus,
// //                     onChanged: (_) => privacyNotifier.toggleOnlineStatus(),
// //                   ),
// //                   _buildDivider(),
// //                   _buildCustomToggle(
// //                     icon: FontAwesomeIcons.eyeSlash,
// //                     title: "Incognito in Search",
// //                     subtitle: "Hide your profile from global results.",
// //                     value: privacyState.hideFromSearch,
// //                     onChanged: (_) => privacyNotifier.toggleSearchHide(),
// //                   ),
// //                   _buildDivider(),
// //                   _buildCustomToggle(
// //                     icon: FontAwesomeIcons.clockRotateLeft,
// //                     title: "Last Seen",
// //                     subtitle: "Show when you last used the app.",
// //                     value: privacyState.showLastSeen,
// //                     onChanged: (_) => privacyNotifier.toggleLastSeen(),
// //                   ),
// //                 ]),
// //                 const SizedBox(height: 30),
// //                 _buildSectionHeader("Interactions & Security"),
// //                 _buildSettingsCard([
// //                   _buildCustomToggle(
// //                     icon: FontAwesomeIcons.commentDots,
// //                     title: "Message Requests",
// //                     subtitle: "Allow messages from strangers.",
// //                     value: privacyState.allowMessagesFromStrangers,
// //                     onChanged: (_) => privacyNotifier.toggleMessages(),
// //                   ),
// //                   _buildDivider(),
// //                   _buildCustomToggle(
// //                     icon: FontAwesomeIcons.shieldHalved,
// //                     title: "Strict Profile Mode",
// //                     subtitle: "Only approved members can view details.",
// //                     value: !privacyState.showProfileToPublic,
// //                     onChanged: (_) => privacyNotifier.toggleProfilePublic(),
// //                   ),
// //                 ]),
// //                 const SizedBox(height: 40),
// //                 _buildFooter(),
// //                 const SizedBox(height: 50),
// //               ]),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAppBar(BuildContext context) {
// //     return SliverAppBar(
// //       floating: true,
// //       pinned: true,
// //       elevation: 0,
// //       backgroundColor: const Color(0xFF0F0F1A),
// //       surfaceTintColor: Colors.transparent,
// //       leading: IconButton(
// //         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
// //         onPressed: () => Navigator.pop(context),
// //       ),
// //       centerTitle: true,
// //       title: const Text(
// //         'PRIVACY CONTROL',
// //         style: TextStyle(
// //           color: Colors.white,
// //           fontWeight: FontWeight.w900,
// //           fontSize: 16,
// //           letterSpacing: 2.0,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInfoBox() {
// //     return Container(
// //       padding: const EdgeInsets.all(25),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(30),
// //         boxShadow: [
// //           BoxShadow(
// //             color: const Color(0xFF6A11CB).withValues(alpha: 0.3),
// //             blurRadius: 15,
// //             offset: const Offset(0, 8),
// //           ),
// //         ],
// //       ),
// //       child: const Row(
// //         children: [
// //           FaIcon(FontAwesomeIcons.userLock, color: Colors.white, size: 30),
// //           SizedBox(width: 20),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   "Privacy First",
// //                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
// //                 ),
// //                 SizedBox(height: 6),
// //                 Text(
// //                   "You decide who sees your activity and how you interact with others.",
// //                   style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSectionHeader(String title) {
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 10, bottom: 15),
// //       child: Text(
// //         title.toUpperCase(),
// //         style: const TextStyle(
// //           color: Colors.white,
// //           fontSize: 13,
// //           fontWeight: FontWeight.w900,
// //           letterSpacing: 1.5,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSettingsCard(List<Widget> children) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white.withValues(alpha: 0.05),
// //         borderRadius: BorderRadius.circular(30),
// //         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// //       ),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(30),
// //         child: Column(children: children),
// //       ),
// //     );
// //   }

// //   Widget _buildCustomToggle({
// //     required FaIconData icon,
// //     required String title,
// //     required String subtitle,
// //     required bool value,
// //     required ValueChanged<bool> onChanged,
// //   }) {
// //     return SwitchListTile(
// //       secondary: Container(
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: Colors.white.withValues(alpha: 0.05),
// //           borderRadius: BorderRadius.circular(15),
// //         ),
// //         child: FaIcon(icon, size: 18, color: Colors.pinkAccent),
// //       ),
// //       title: Text(
// //         title,
// //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
// //       ),
// //       subtitle: Text(
// //         subtitle,
// //         style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5), height: 1.4),
// //       ),
// //       value: value,
// //       onChanged: onChanged,
// //       activeThumbColor: Colors.pinkAccent,
// //       activeTrackColor: Colors.pinkAccent.withValues(alpha: 0.3),
// //       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //     );
// //   }

// //   Widget _buildDivider() {
// //     return Divider(height: 1, thickness: 1, color: Colors.white.withValues(alpha: 0.05), indent: 70);
// //   }

// //   Widget _buildFooter() {
// //     return Column(
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Icon(Icons.verified_user_rounded, color: Colors.greenAccent, size: 16),
// //             const SizedBox(width: 8),
// //             Text(
// //               "Privacy Settings Encrypted",
// //               style: TextStyle(color: Colors.greenAccent.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.bold),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 15),
// //         Text(
// //           "Changes are applied instantly to your profile.\nBeat Flirt ensures your data remains secure.",
// //           textAlign: TextAlign.center,
// //           style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11, height: 1.5),
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:beatflirt/core/services/auth_services.dart';

// // ============================================
// // MODELS
// // ============================================

// class PrivacyDetails {
//   final String id;
//   final String username;
//   final String email;
//   final String profileShowEveryoneOrFriend;
//   final String profileShowCountries;
//   final String profileShowCountriesLat;
//   final String profileShowCountriesLng;
//   final String showAge;
//   final String showGender;
//   final String showLocation;
//   final String showRelationship;
//   final String showInterestsPreferences;
//   final String showLanguagePreferences;
//   final String showProfileImage;
//   final String showSearchResult;
//   final String showOnlineStatus;
//   final String showActivityVisitCommentsLike;
//   final String showAppearInSearchResults;
//   final String showProfileChatMessage;
//   final String showNotificationNewMessage;
//   final String showNotificationLike;
//   final String showNotificationValidation;
//   final String showNotificationFriendRequest;

//   PrivacyDetails({
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.profileShowEveryoneOrFriend,
//     required this.profileShowCountries,
//     required this.profileShowCountriesLat,
//     required this.profileShowCountriesLng,
//     required this.showAge,
//     required this.showGender,
//     required this.showLocation,
//     required this.showRelationship,
//     required this.showInterestsPreferences,
//     required this.showLanguagePreferences,
//     required this.showProfileImage,
//     required this.showSearchResult,
//     required this.showOnlineStatus,
//     required this.showActivityVisitCommentsLike,
//     required this.showAppearInSearchResults,
//     required this.showProfileChatMessage,
//     required this.showNotificationNewMessage,
//     required this.showNotificationLike,
//     required this.showNotificationValidation,
//     required this.showNotificationFriendRequest,
//   });

//   factory PrivacyDetails.fromJson(Map<String, dynamic> json) {
//     return PrivacyDetails(
//       id: json['id']?.toString() ?? '',
//       username: json['username']?.toString() ?? '',
//       email: json['email']?.toString() ?? '',
//       profileShowEveryoneOrFriend: json['profile_show_everyone_or_friend']?.toString() ?? '1',
//       profileShowCountries: json['profile_show_countries']?.toString() ?? '0',
//       profileShowCountriesLat: json['profile_show_countries_lat']?.toString() ?? '',
//       profileShowCountriesLng: json['profile_show_countries_lng']?.toString() ?? '',
//       showAge: json['show_age']?.toString() ?? '1',
//       showGender: json['show_gender']?.toString() ?? '1',
//       showLocation: json['show_location']?.toString() ?? '1',
//       showRelationship: json['show_relationship']?.toString() ?? '1',
//       showInterestsPreferences: json['show_interests_preferences']?.toString() ?? '1',
//       showLanguagePreferences: json['show_language_preferences']?.toString() ?? '1',
//       showProfileImage: json['show_profile_image']?.toString() ?? '1',
//       showSearchResult: json['show_search_result']?.toString() ?? '1',
//       showOnlineStatus: json['show_online_status']?.toString() ?? '1',
//       showActivityVisitCommentsLike: json['show_activity_visit_comments_like']?.toString() ?? '1',
//       showAppearInSearchResults: json['show_appear_in_search_results']?.toString() ?? '1',
//       showProfileChatMessage: json['show_profile_chat_message']?.toString() ?? '1',
//       showNotificationNewMessage: json['show_notification_new_message']?.toString() ?? '1',
//       showNotificationLike: json['show_notification_like']?.toString() ?? '1',
//       showNotificationValidation: json['show_notification_validation']?.toString() ?? '1',
//       showNotificationFriendRequest: json['show_notification_friend_request']?.toString() ?? '1',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'profile_show_everyone_or_friend': profileShowEveryoneOrFriend,
//       'profile_show_countries': profileShowCountries,
//       'show_age': showAge,
//       'show_gender': showGender,
//       'show_location': showLocation,
//       'show_relationship': showRelationship,
//       'show_interests_preferences': showInterestsPreferences,
//       'show_language_preferences': showLanguagePreferences,
//       'show_profile_image': showProfileImage,
//       'show_search_result': showSearchResult,
//       'show_online_status': showOnlineStatus,
//       'show_activity_visit_comments_like': showActivityVisitCommentsLike,
//       'show_appear_in_search_results': showAppearInSearchResults,
//       'show_profile_chat_message': showProfileChatMessage,
//       'show_notification_new_message': showNotificationNewMessage,
//       'show_notification_like': showNotificationLike,
//       'show_notification_validation': showNotificationValidation,
//       'show_notification_friend_request': showNotificationFriendRequest,
//     };
//   }

//   PrivacyDetails copyWith({
//     String? profileShowEveryoneOrFriend,
//     String? profileShowCountries,
//     String? showAge,
//     String? showGender,
//     String? showLocation,
//     String? showRelationship,
//     String? showInterestsPreferences,
//     String? showLanguagePreferences,
//     String? showProfileImage,
//     String? showSearchResult,
//     String? showOnlineStatus,
//     String? showActivityVisitCommentsLike,
//     String? showAppearInSearchResults,
//     String? showProfileChatMessage,
//     String? showNotificationNewMessage,
//     String? showNotificationLike,
//     String? showNotificationValidation,
//     String? showNotificationFriendRequest,
//   }) {
//     return PrivacyDetails(
//       id: id,
//       username: username,
//       email: email,
//       profileShowEveryoneOrFriend: profileShowEveryoneOrFriend ?? this.profileShowEveryoneOrFriend,
//       profileShowCountries: profileShowCountries ?? this.profileShowCountries,
//       profileShowCountriesLat: profileShowCountriesLat,
//       profileShowCountriesLng: profileShowCountriesLng,
//       showAge: showAge ?? this.showAge,
//       showGender: showGender ?? this.showGender,
//       showLocation: showLocation ?? this.showLocation,
//       showRelationship: showRelationship ?? this.showRelationship,
//       showInterestsPreferences: showInterestsPreferences ?? this.showInterestsPreferences,
//       showLanguagePreferences: showLanguagePreferences ?? this.showLanguagePreferences,
//       showProfileImage: showProfileImage ?? this.showProfileImage,
//       showSearchResult: showSearchResult ?? this.showSearchResult,
//       showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
//       showActivityVisitCommentsLike: showActivityVisitCommentsLike ?? this.showActivityVisitCommentsLike,
//       showAppearInSearchResults: showAppearInSearchResults ?? this.showAppearInSearchResults,
//       showProfileChatMessage: showProfileChatMessage ?? this.showProfileChatMessage,
//       showNotificationNewMessage: showNotificationNewMessage ?? this.showNotificationNewMessage,
//       showNotificationLike: showNotificationLike ?? this.showNotificationLike,
//       showNotificationValidation: showNotificationValidation ?? this.showNotificationValidation,
//       showNotificationFriendRequest: showNotificationFriendRequest ?? this.showNotificationFriendRequest,
//     );
//   }
// }

// class NotificationCounts {
//   final int allViewedMeCount;
//   final int allValidationRequestCount;
//   final int allOnlineUserCount;
//   final int allFriendCount;
//   final int allFriendRequestCount;
//   final int allWhoIViewedCount;
//   final int allLikesCount;
//   final int allBlockCount;
//   final int allNotesCount;
//   final int allRememberCount;
//   final int allEventNotificationCount;
//   final int allBlasterNotificationCount;
//   final int allSpeedDateCount;
//   final int allVideoCount;

//   NotificationCounts({
//     required this.allViewedMeCount,
//     required this.allValidationRequestCount,
//     required this.allOnlineUserCount,
//     required this.allFriendCount,
//     required this.allFriendRequestCount,
//     required this.allWhoIViewedCount,
//     required this.allLikesCount,
//     required this.allBlockCount,
//     required this.allNotesCount,
//     required this.allRememberCount,
//     required this.allEventNotificationCount,
//     required this.allBlasterNotificationCount,
//     required this.allSpeedDateCount,
//     required this.allVideoCount,
//   });

//   factory NotificationCounts.fromJson(Map<String, dynamic> json) {
//     return NotificationCounts(
//       allViewedMeCount: json['all_viewedme_count'] ?? 0,
//       allValidationRequestCount: json['all_validation_request_count'] ?? 0,
//       allOnlineUserCount: json['all_online_user_count'] ?? 0,
//       allFriendCount: json['all_friend_count'] ?? 0,
//       allFriendRequestCount: json['all_friend_request_count'] ?? 0,
//       allWhoIViewedCount: json['all_who_i_viewed_count'] ?? 0,
//       allLikesCount: json['all_likes_count'] ?? 0,
//       allBlockCount: json['all_block_count'] ?? 0,
//       allNotesCount: json['all_notes_count'] ?? 0,
//       allRememberCount: json['all_remember_count'] ?? 0,
//       allEventNotificationCount: json['all_event_notification_count'] ?? 0,
//       allBlasterNotificationCount: json['all_blaster_notification_count'] ?? 0,
//       allSpeedDateCount: json['all_speed_date_count'] ?? 0,
//       allVideoCount: json['all_video_count'] ?? 0,
//     );
//   }
// }

// // ============================================
// // API SERVICE
// // ============================================

// class PrivacyApiService {
//   // static const String baseUrl = 'https://beatflirtevent.com/api/App/user';
//   static const String baseUrl = 'https://app.beatflirtevent.com/App/user';
//   // static const String notificationBaseUrl = 'https://beatflirtevent.com/api/App/notification';
//   static const String notificationBaseUrl = 'https://app.beatflirtevent.com/App/notification';

//   // Build headers using stored auth token (if available)
//   static Future<Map<String, String>> getHeaders() async {
//     final token = await AuthService.getToken();
//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//     if (token != null && token.isNotEmpty) {
//       headers['Authorization'] = 'Bearer $token';
//       headers['access-token'] = token;
//     }
//     // Helpful debug output when diagnosing blank screens / API failures
//     debugPrint('🔵 PRIVACY HEADERS → $headers');
//     return headers;
//   }

//   static Future<PrivacyDetails> fetchPrivacyDetails() async {
//     final uri = Uri.parse('$baseUrl/privacy_details');
//     debugPrint('🔵 PRIVACY REQUEST → $uri');
//     final response = await http.get(uri, headers: await getHeaders());
//     debugPrint('🟢 PRIVACY RESPONSE CODE → ${response.statusCode}');
//     debugPrint('🟢 PRIVACY RESPONSE BODY → ${response.body}');

//     if (response.statusCode != 200) {
//       throw Exception('Failed to load privacy details: ${response.statusCode}');
//     }

//     final data = jsonDecode(response.body);
//     if (data == null || (data['status'] != '200' && data['status'] != 200)) {
//       throw Exception('API error: ${data ?? response.body}');
//     }

//     if (data['data'] == null) {
//       throw Exception('API returned no privacy data');
//     }

//     return PrivacyDetails.fromJson(Map<String, dynamic>.from(data['data']));
//   }

//   static Future<bool> updatePrivacyDetails(PrivacyDetails details) async {
//     final uri = Uri.parse('$baseUrl/update_privacy');
//     debugPrint('🔵 PRIVACY UPDATE REQUEST → $uri');
//     final response = await http.post(uri, headers: await getHeaders(), body: jsonEncode(details.toJson()));
//     debugPrint('🟢 PRIVACY UPDATE RESPONSE → ${response.statusCode} ${response.body}');

//     if (response.statusCode != 200) return false;
//     final data = jsonDecode(response.body);
//     return data['status'] == '200' || data['status'] == 200;
//   }

//   static Future<NotificationCounts> fetchNotificationCounts() async {
//     final uri = Uri.parse('$notificationBaseUrl/all_count');
//     debugPrint('🔵 NOTIFICATION COUNT REQUEST → $uri');
//     final response = await http.get(uri, headers: await getHeaders());
//     debugPrint('🟢 NOTIFICATION COUNT RESPONSE → ${response.statusCode} ${response.body}');

//     if (response.statusCode != 200) throw Exception('Failed to load notification counts: ${response.statusCode}');
//     final data = jsonDecode(response.body);
//     if (data == null || (data['status'] != '200' && data['status'] != 200) || data['data'] == null) {
//       throw Exception('Failed to load notification counts: ${data ?? response.body}');
//     }
//     return NotificationCounts.fromJson(Map<String, dynamic>.from(data['data']));
//   }
// }

// // ============================================
// // CUSTOM WIDGETS
// // ============================================

// class CustomToggleSwitch extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;
//   final Color activeColor;
//   final Color inactiveColor;

//   const CustomToggleSwitch({
//     super.key,
//     required this.value,
//     required this.onChanged,
//     this.activeColor = const Color(0xFF5A1845),
//     this.inactiveColor = const Color(0xFFD9D9D9),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onChanged(!value),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: 48,
//         height: 26,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(13),
//           color: value ? activeColor : inactiveColor,
//         ),
//         child: Stack(
//           children: [
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 200),
//               curve: Curves.easeInOut,
//               left: value ? 24 : 2,
//               top: 2,
//               child: Container(
//                 width: 22,
//                 height: 22,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 2,
//                       offset: Offset(0, 1),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SectionTitle extends StatelessWidget {
//   final String title;

//   const SectionTitle({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 24, bottom: 12),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF2D0A3E),
//         ),
//       ),
//     );
//   }
// }

// class ToggleSettingRow extends StatelessWidget {
//   final String label;
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const ToggleSettingRow({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 15,
//                 color: Color(0xFFC2185B),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           CustomToggleSwitch(
//             value: value,
//             onChanged: onChanged,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class RadioSettingOption extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const RadioSettingOption({
//     super.key,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Row(
//           children: [
//             Container(
//               width: 20,
//               height: 20,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: selected ? const Color(0xFF5A1845) : const Color(0xFFCCCCCC),
//                   width: 2,
//                 ),
//               ),
//               child: selected
//                   ? Center(
//                       child: Container(
//                         width: 10,
//                         height: 10,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFF5A1845),
//                         ),
//                       ),
//                     )
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: selected ? const Color(0xFFC2185B) : const Color(0xFF888888),
//                 fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DividerLine extends StatelessWidget {
//   const DividerLine({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Divider(
//       color: Color(0xFFEEEEEE),
//       height: 24,
//       thickness: 1,
//     );
//   }
// }

// // ============================================
// // PRIVACY SETTINGS PAGE
// // ============================================

// class PrivacySettingsPage extends StatefulWidget {
//   const PrivacySettingsPage({super.key});

//   @override
//   State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
// }

// class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
//   bool _isLoading = true;
//   bool _isSaving = false;
//   PrivacyDetails? _privacyDetails;
//   NotificationCounts? _notificationCounts;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//     try {
//       final results = await Future.wait([
//         PrivacyApiService.fetchPrivacyDetails(),
//         PrivacyApiService.fetchNotificationCounts(),
//       ]);

//       if (!mounted) return;
//       setState(() {
//         _privacyDetails = results[0] as PrivacyDetails;
//         _notificationCounts = results[1] as NotificationCounts;
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//       debugPrint('🔴 _loadData error → $e');
//       _showErrorSnackBar('Failed to load data: $e');
//     }
//   }

//   Future<void> _saveChanges() async {
//     if (_privacyDetails == null) return;
//     if (!mounted) return;
//     setState(() => _isSaving = true);
//     try {
//       final success = await PrivacyApiService.updatePrivacyDetails(_privacyDetails!);
//       if (!mounted) return;
//       setState(() => _isSaving = false);

//       if (success) {
//         _showSuccessSnackBar('Privacy settings updated successfully!');
//       } else {
//         _showErrorSnackBar('Failed to update privacy settings');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _isSaving = false);
//       debugPrint('🔴 _saveChanges error → $e');
//       _showErrorSnackBar('Failed to update: $e');
//     }
//   }

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

//   // Profile Visibility Options
//   int get _profileVisibilityOption {
//     if (_privacyDetails?.profileShowEveryoneOrFriend == '1') return 0;
//     if (_privacyDetails?.profileShowEveryoneOrFriend == '2') return 1;
//     return 0;
//   }

//   void _setProfileVisibility(int option) {
//     setState(() {
//       _privacyDetails = _privacyDetails!.copyWith(
//         profileShowEveryoneOrFriend: option.toString(),
//       );
//     });
//   }

//   // Messaging Privacy
//   int get _messagingOption {
//     if (_privacyDetails?.showProfileChatMessage == '1') return 0;
//     return 1;
//   }

//   void _setMessagingOption(int option) {
//     setState(() {
//       _privacyDetails = _privacyDetails!.copyWith(
//         showProfileChatMessage: option == 0 ? '1' : '0',
//       );
//     });
//   }

//   // Helper to convert "1"/"0" to bool
//   bool _parseBool(String value) => value == '1';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F0F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           // icon: const Icon(Icons.arrow_back, color: Color(0xFF2D0A3E)),
//           icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D0A3E), size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Privacy Settings',
//           style: TextStyle(
//             color: Color(0xFF2D0A3E),
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF5A1845),
//               ),
//             )
//           : _privacyDetails == null
//               ? Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text('Failed to load privacy settings', style: TextStyle(color: Color(0xFF2D0A3E), fontSize: 16)),
//                       const SizedBox(height: 12),
//                       ElevatedButton(
//                         onPressed: _loadData,
//                         style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D0A3E),foregroundColor: Colors.white),
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : Column(
//                   children: [
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: const EdgeInsets.all(16),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(alpha: 0.05),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'You can change these selections at any time.',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color(0xFFC2185B),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),

//                                 // Profile Visibility
//                                 _buildProfileVisibilitySection(),

//                                 const DividerLine(),

//                                 // Personal Information Privacy
//                                 _buildPersonalInfoSection(),

//                                 const DividerLine(),

//                                 // Profile Picture & Cover Photo
//                                 _buildProfilePictureSection(),

//                                 const DividerLine(),

//                                 // Activity & Status Privacy
//                                 _buildActivityStatusSection(),

//                                 const DividerLine(),

//                                 // Search & Discovery
//                                 _buildSearchDiscoverySection(),

//                                 const DividerLine(),

//                                 // Messaging Privacy
//                                 _buildMessagingSection(),

//                                 const DividerLine(),

//                                 // Notifications
//                                 _buildNotificationsSection(),

//                                 const SizedBox(height: 32),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Update Button
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF8F0F5),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, -2),
//                           ),
//                         ],
//                       ),
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _isSaving ? null : _saveChanges,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF2D0A3E),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(25),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: _isSaving
//                               ? const SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Update',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }

//   Widget _buildProfileVisibilitySection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle(title: 'Profile Visibility'),
//         RadioSettingOption(
//           label: 'Public: Profile visible to everyone',
//           selected: _profileVisibilityOption == 0,
//           onTap: () => _setProfileVisibility(0),
//         ),
//         RadioSettingOption(
//           label: 'Friends/Connections Only',
//           selected: _profileVisibilityOption == 1,
//           onTap: () => _setProfileVisibility(1),
//         ),
//         // Block Countries checkbox could be added here
//       ],
//     );
//   }

//   Widget _buildPersonalInfoSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle(title: 'Personal Information Privacy'),
//         ToggleSettingRow(
//           label: 'Age / Birthdate',
//           value: _parseBool(_privacyDetails!.showAge),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showAge: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'Gender',
//           value: _parseBool(_privacyDetails!.showGender),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showGender: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'Location / City',
//           value: _parseBool(_privacyDetails!.showLocation),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showLocation: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'Relationship Status',
//           value: _parseBool(_privacyDetails!.showRelationship),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showRelationship: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'Interests & Preferences',
//           value: _parseBool(_privacyDetails!.showInterestsPreferences),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showInterestsPreferences: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'Language Preferences',
//           value: _parseBool(_privacyDetails!.showLanguagePreferences),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showLanguagePreferences: value ? '1' : '0');
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildProfilePictureSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle(title: 'Profile Picture & Cover Photo'),
//         ToggleSettingRow(
//           label: 'Profile Picture Visibility',
//           value: _parseBool(_privacyDetails!.showProfileImage),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showProfileImage: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'Hide from Search Results',
//           value: _parseBool(_privacyDetails!.showSearchResult),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showSearchResult: value ? '1' : '0');
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildActivityStatusSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle(title: 'Activity & Status Privacy'),
//         ToggleSettingRow(
//           label: 'Online Status Indicator',
//           value: _parseBool(_privacyDetails!.showOnlineStatus),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showOnlineStatus: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'Recent Activity',
//           value: _parseBool(_privacyDetails!.showActivityVisitCommentsLike),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showActivityVisitCommentsLike: value ? '1' : '0');
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchDiscoverySection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle(title: 'Search & Discovery'),
//         ToggleSettingRow(
//           label: 'Appear in Search Results',
//           value: _parseBool(_privacyDetails!.showAppearInSearchResults),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showAppearInSearchResults: value ? '1' : '0');
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildMessagingSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle(title: 'Messaging Privacy'),
//         RadioSettingOption(
//           label: 'Anyone can message me',
//           selected: _messagingOption == 0,
//           onTap: () => _setMessagingOption(0),
//         ),
//         RadioSettingOption(
//           label: 'Friends / Connections only',
//           selected: _messagingOption == 1,
//           onTap: () => _setMessagingOption(1),
//         ),
//       ],
//     );
//   }

//   Widget _buildNotificationsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionTitle(title: 'Notifications'),
//         ToggleSettingRow(
//           label: 'New Message',
//           value: _parseBool(_privacyDetails!.showNotificationNewMessage),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showNotificationNewMessage: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'New Like / Match',
//           value: _parseBool(_privacyDetails!.showNotificationLike),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showNotificationLike: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'New Validation',
//           value: _parseBool(_privacyDetails!.showNotificationValidation),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showNotificationValidation: value ? '1' : '0');
//           }),
//         ),
//         ToggleSettingRow(
//           label: 'New Friend Request',
//           value: _parseBool(_privacyDetails!.showNotificationFriendRequest),
//           onChanged: (value) => setState(() {
//             _privacyDetails = _privacyDetails!.copyWith(showNotificationFriendRequest: value ? '1' : '0');
//           }),
//         ),
//       ],
//     );
//   }
// }
