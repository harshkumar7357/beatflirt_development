import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:beatflirt/providers/profile_hometab_provider.dart'; // for refreshing home tab after save

// ==================== DATA MODELS ====================

class ProfileOption {
  final String id;
  final String value;
  final String label;

  const ProfileOption({
    required this.id,
    required this.value,
    required this.label,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'value': value, 'label': label};
  }
}

class ProfileOptions {
  static const String notComfortableValue = 'Im not comfortable sharing that';
  static const String notComfortableLabel = "I'm not comfortable sharing that.";

  static const ProfileOption notComfortable = ProfileOption(
    id: 'not_comfortable',
    value: notComfortableValue,
    label: notComfortableLabel,
  );

  static const List<ProfileOption> tattoos = [
    notComfortable,
    ProfileOption(id: 'none', value: 'None', label: 'None'),
    ProfileOption(id: 'one', value: 'One', label: 'One'),
    ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
    ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
    ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
  ];

  static const List<ProfileOption> heightTypes = [
    ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
    ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
  ];

  static const List<ProfileOption> weightTypes = [
    ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
    ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
  ];

  static const List<ProfileOption> bodyTypes = [
    notComfortable,
    ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
    ProfileOption(id: 'average', value: 'Average', label: 'Average'),
    ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
    ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
    ProfileOption(id: 'huggable_and_heavy', value: 'Huggable and Heavy', label: 'Huggable and Heavy'),
    ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
    ProfileOption(id: 'more_of_me_to_love', value: 'More of me to love', label: 'More of me to love'),
    ProfileOption(id: 'nicely_shaped', value: 'Nicely Shaped', label: 'Nicely Shaped'),
    ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
  ];

  static const List<ProfileOption> smoking = [
    notComfortable,
    ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
    ProfileOption(id: 'no', value: 'No', label: 'No'),
    ProfileOption(id: 'occasionally', value: 'Occasionally', label: 'Occasionally'),
  ];

  static const List<ProfileOption> drinking = [
    notComfortable,
    ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
    ProfileOption(id: 'no', value: 'No', label: 'No'),
    ProfileOption(id: 'occasionally', value: 'Occasionally', label: 'Occasionally'),
  ];

  static const List<ProfileOption> ethnicBackgrounds = [
    notComfortable,
    ProfileOption(id: 'other', value: 'Other', label: 'Other'),
    ProfileOption(id: 'american', value: 'American', label: 'American'),
    ProfileOption(id: 'argentine_argentinian', value: 'Argentine/Argentinian', label: 'Argentine/Argentinian'),
    ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
    ProfileOption(id: 'black_african_american', value: 'Black/African - American', label: 'Black/African - American'),
    ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
    ProfileOption(id: 'british', value: 'British', label: 'British'),
    ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
    ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
    ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
    ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
    ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
    ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
    ProfileOption(id: 'french', value: 'French', label: 'French'),
    ProfileOption(id: 'german', value: 'German', label: 'German'),
    ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
    ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
    ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
    ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
    ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
    ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
    ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
    ProfileOption(id: 'new_zealander_kiwi', value: 'New Zealander/Kiwi', label: 'New Zealander/Kiwi'),
    ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
    ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
    ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
    ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
    ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
    ProfileOption(id: 'south_african', value: 'South African', label: 'South African'),
    ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
    ProfileOption(id: 'sri_lankan', value: 'Sri Lankan', label: 'Sri Lankan'),
    ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
    ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
  ];

  static const List<ProfileOption> importanceLevels = [
    notComfortable,
    ProfileOption(id: 'no', value: 'No', label: 'No'),
    ProfileOption(id: 'low_importance', value: 'Low Importance', label: 'Low Importance'),
    ProfileOption(id: 'medium_importance', value: 'Medium Importance', label: 'Medium Importance'),
    ProfileOption(id: 'very_important', value: 'Very Important', label: 'Very Important'),
  ];

  static const List<ProfileOption> sexualities = [
    notComfortable,
    ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
    ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
    ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
    ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
    ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
    ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
    ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
    ProfileOption(id: 'transsexual', value: 'Transsexual', label: 'Transsexual'),
  ];

  static const List<ProfileOption> relationshipOrientations = [
    notComfortable,
    ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
    ProfileOption(id: 'open_minded', value: 'Open-Minded', label: 'Open-Minded'),
    ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
    ProfileOption(id: 'polyamorous', value: 'Polyamorous', label: 'Polyamorous'),
  ];

  static const List<ProfileOption> circumcised = [
    notComfortable,
    ProfileOption(id: 'no', value: 'No', label: 'No'),
    ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
  ];

  static const List<ProfileOption> piercings = [
    notComfortable,
    ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
    ProfileOption(id: 'no', value: 'No', label: 'No'),
  ];

  static const List<ProfileOption> bodyHair = [
    notComfortable,
    ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
    ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
    ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
    ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
  ];

  static const Map<String, List<ProfileOption>> groups = {
    'tattoos': tattoos,
    'height_types': heightTypes,
    'weight_types': weightTypes,
    'body_types': bodyTypes,
    'smoking': smoking,
    'drinking': drinking,
    'ethnic_backgrounds': ethnicBackgrounds,
    'importance_levels': importanceLevels,
    'sexualities': sexualities,
    'relationship_orientations': relationshipOrientations,
    'circumcised': circumcised,
    'piercings': piercings,
    'body_hair': bodyHair,
  };
}

class ProfileFieldOptions {
  static const Map<String, String> fieldGroupMap = {
    'bodyType': 'body_types',
    'ethnic': 'ethnic_backgrounds',
    'sexuality': 'sexualities',
    'orientation': 'relationship_orientations',
    'tattoos': 'tattoos',
    'piercings': 'piercings',
    'smoking': 'smoking',
    'drinking': 'drinking',
    'bodyHair': 'body_hair',
    'looks': 'importance_levels',
    'intelligence': 'importance_levels',
    'circumcised': 'circumcised',
    'person1_tattoos': 'tattoos',
    'person2_tattoos': 'tattoos',
    'person1_height_type': 'height_types',
    'person2_height_type': 'height_types',
    'person1_weight_type': 'weight_types',
    'person2_weight_type': 'weight_types',
    'person1_body_type': 'body_types',
    'person2_body_type': 'body_types',
    'person1_smoking': 'smoking',
    'person2_smoking': 'smoking',
    'person1_drinking': 'drinking',
    'person2_drinking': 'drinking',
    'person1_ethnic_background': 'ethnic_backgrounds',
    'person2_ethnic_background': 'ethnic_backgrounds',
    'person1_looks_important': 'importance_levels',
    'person2_looks_important': 'importance_levels',
    'person1_intelligence_importance': 'importance_levels',
    'person2_intelligence_importance': 'importance_levels',
    'person1_sexuality': 'sexualities',
    'person2_sexuality': 'sexualities',
    'person1_relationship_orientation': 'relationship_orientations',
    'person2_relationship_orientation': 'relationship_orientations',
    'person1_circumcised': 'circumcised',
    'person2_circumcised': 'circumcised',
    'person1_piercings': 'piercings',
    'person2_piercings': 'piercings',
  };

  static List<ProfileOption> getOptionsForField(String fieldName) {
    final groupKey = fieldGroupMap[fieldName];
    if (groupKey == null) return [];
    return ProfileOptions.groups[groupKey] ?? [];
  }
}

// ==================== STATE ====================

class ProfileEditState {
  final bool isProfileDetailsTab;
  final Map<String, bool> swingersOptions;
  final Map<String, bool> hookupOptions;
  final bool isSwingersExpanded;
  final bool isHookupExpanded;
  final String aboutMe;
  final String lookingFor;
  final Map<String, String> partner1;
  final Map<String, String> partner2;
  final List<String> partner1Languages;
  final List<String> partner2Languages;
  final bool isLoading;
  final Map<String, dynamic>? linkedPartner;
  final String? loadError; // NEW: surface load errors to UI
  final String profileType; // "single" or "couple"
  final String person1Name;
  final String person2Name;
  final String userId;
  final String username;

  const ProfileEditState({
    this.isProfileDetailsTab = false,
    required this.swingersOptions,
    required this.hookupOptions,
    this.isSwingersExpanded = true,
    this.isHookupExpanded = true,
    this.aboutMe = '',
    this.lookingFor = '',
    required this.partner1,
    required this.partner2,
    required this.partner1Languages,
    required this.partner2Languages,
    this.isLoading = false,
    this.linkedPartner,
    this.loadError,
    this.profileType = 'single',
    this.person1Name = '',
    this.person2Name = '',
    this.userId = '',
    this.username = '',
  });

  ProfileEditState copyWith({
    bool? isProfileDetailsTab,
    Map<String, bool>? swingersOptions,
    Map<String, bool>? hookupOptions,
    bool? isSwingersExpanded,
    bool? isHookupExpanded,
    String? aboutMe,
    String? lookingFor,
    Map<String, String>? partner1,
    Map<String, String>? partner2,
    List<String>? partner1Languages,
    List<String>? partner2Languages,
    bool? isLoading,
    Map<String, dynamic>? linkedPartner,
    String? loadError,
    String? profileType,
    String? person1Name,
    String? person2Name,
    String? userId,
    String? username,
  }) {
    return ProfileEditState(
      isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
      swingersOptions: swingersOptions ?? this.swingersOptions,
      hookupOptions: hookupOptions ?? this.hookupOptions,
      isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
      isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
      aboutMe: aboutMe ?? this.aboutMe,
      lookingFor: lookingFor ?? this.lookingFor,
      partner1: partner1 ?? this.partner1,
      partner2: partner2 ?? this.partner2,
      partner1Languages: partner1Languages ?? this.partner1Languages,
      partner2Languages: partner2Languages ?? this.partner2Languages,
      isLoading: isLoading ?? this.isLoading,
      linkedPartner: linkedPartner ?? this.linkedPartner,
      loadError: loadError, // nullable — pass null to clear, pass a string to set
      profileType: profileType ?? this.profileType,
      person1Name: person1Name ?? this.person1Name ?? '',
      person2Name: person2Name ?? this.person2Name ?? '',
      userId: userId ?? this.userId ?? '',
      username: username ?? this.username ?? '',
    );
  }
}

// ==================== API HELPERS ====================

const String baseApiUrl = 'https://app.beatflirtevent.com/App/user';

// FIX #1: The original URL had a typo "signle" — keep it if that's the actual endpoint,
// but also try the correct spelling as a fallback.
const List<String> profileUrls = [
  '$baseApiUrl/signle_user_profile',
  '$baseApiUrl/single_user_profile', // fallback: correct spelling
];

Map<String, String> apiHeaders({bool json = false}) {
  final h = ApiService.buildAuthHeaders();
  if (!json) {
    h['Content-Type'] = 'application/x-www-form-urlencoded';
  }
  return h;
}

bool _isHtmlError(String body) {
  final lower = body.toLowerCase();
  return lower.contains('404') ||
      lower.contains('not found') ||
      lower.contains('the page you requested');
}

bool _isTokenError(String body) {
  final lower = body.toLowerCase();
  return lower.contains('token') &&
      (lower.contains('required') ||
          lower.contains('missing') ||
          lower.contains('invalid') ||
          lower.contains('provide'));
}

Map<String, dynamic>? _tryDecode(String body) {
  try {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
  } catch (_) {}
  return null;
}

// ==================== PERMANENT getProfile ====================

Future<Map<String, dynamic>> getProfile({required String token}) async {
  debugPrint('========== GET PROFILE START ==========');
  debugPrint('Using token length: ${token.length}');

  final attempts = <Future<http.Response> Function()>[
    // 0. POST JSON (as used successfully by home tab)
    () => http.post(
      Uri.parse(profileUrls[0]),
      headers: {
        'Authorization': 'Bearer $token',
        'access-token': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({}),
    ),
    // 1. POST form
    () => http.post(
      Uri.parse(profileUrls[0]),
      headers: apiHeaders(),
      body: {'token': token},
    ),
    () => http.post(
      Uri.parse(profileUrls[0]),
      headers: apiHeaders(),
      body: {'Authtoken': token},
    ),
    // 2. Bearer header
    () => http.get(
      Uri.parse(profileUrls[0]),
      headers: {...apiHeaders(), 'Authorization': 'Bearer $token'},
    ),
    // 3. Custom header
    () => http.get(
      Uri.parse(profileUrls[0]),
      headers: {...apiHeaders(), 'token': token},
    ),
    () => http.get(
      Uri.parse(profileUrls[0]),
      headers: {...apiHeaders(), 'Authtoken': token},
    ),
    // 4. Query param fallback
    () => http.get(
      Uri.parse('${profileUrls[0]}?token=$token'),
      headers: apiHeaders(),
    ),
  ];

  String? lastErrorBody;

  for (int i = 0; i < attempts.length; i++) {
    try {
      final response = await attempts[i]();
      debugPrint('ATTEMPT ${i + 1} → ${response.statusCode}');
      debugPrint('ATTEMPT ${i + 1} BODY: ${response.body}');
      if (response.statusCode < 200 || response.statusCode >= 300) continue;
      if (_isHtmlError(response.body)) continue;
      if (_isTokenError(response.body)) continue;

      final decoded = _tryDecode(response.body);
      if (decoded != null) {
        debugPrint('✅ SUCCESS on attempt ${i + 1}');
        debugPrint('RESPONSE KEYS: ${decoded.keys.toList()}');
        debugPrint('========== GET PROFILE END ==========');
        return decoded;
      }
      lastErrorBody = response.body;
    } catch (e) {
      debugPrint('ATTEMPT ${i + 1} ERROR: $e');
    }
  }

  throw Exception(
    'Failed to load profile. No authentication method worked. '
    'Last response body snippet: ${lastErrorBody?.substring(0, (lastErrorBody?.length ?? 0).clamp(0, 200)) ?? "N/A"}',
  );
}

// ==================== UPDATE PROFILE ====================

const List<String> updateProfileCandidateUrls = [
  '$baseApiUrl/update_profile',
  '$baseApiUrl/update_user_profile',
  '$baseApiUrl/update_profile_details',
  '$baseApiUrl/save_profile',
  '$baseApiUrl/profile_update',
  '$baseApiUrl/edit_profile',
  '$baseApiUrl/update_user',
];

Map<String, String> buildProfileFormBody({
  required String token,
  required Map<String, dynamic> updates,
}) {
  final partner1Traits = Map<String, dynamic>.from(updates['partner1Traits'] ?? {});
  final partner1Languages = List<dynamic>.from(updates['partner1Languages'] ?? []);
  final swingersOptions = Map<String, dynamic>.from(updates['swingersOptions'] ?? {});
  final hookupOptions = Map<String, dynamic>.from(updates['hookupOptions'] ?? {});

  return {
    'token': token,
    'Authtoken': token,
    'aboutMe': updates['aboutMe']?.toString() ?? '',
    'lookingFor': updates['lookingFor']?.toString() ?? '',
    'partner1Traits': jsonEncode(partner1Traits),
    'partner1Languages': jsonEncode(partner1Languages),
    'swingersOptions': jsonEncode(swingersOptions),
    'hookupOptions': jsonEncode(hookupOptions),
    'text': updates['aboutMe']?.toString() ?? '',
    'comment': updates['lookingFor']?.toString() ?? '',
    'person1_dob': partner1Traits['dateOfBirth']?.toString() ?? '',
    'person1_height': partner1Traits['height']?.toString() ?? '',
    'height1_type': partner1Traits['heightType']?.toString() ?? '',
    'person1_weight': partner1Traits['weight']?.toString() ?? '',
    'weight1_type': partner1Traits['weightType']?.toString() ?? '',
    'person1_body_type': partner1Traits['bodyType']?.toString() ?? '',
    'person1_ethnic_background': partner1Traits['ethnic']?.toString() ?? '',
    'person1_sexuality': partner1Traits['sexuality']?.toString() ?? '',
    'person1_relationship_orientation': partner1Traits['orientation']?.toString() ?? '',
    'person1_tattoos': partner1Traits['tattoos']?.toString() ?? '',
    'person1_piercings': partner1Traits['piercings']?.toString() ?? '',
    'person1_smoking': partner1Traits['smoking']?.toString() ?? '',
    'person1_drinking': partner1Traits['drinking']?.toString() ?? '',
    'person1_body_hair': jsonEncode([partner1Traits['bodyHair']?.toString() ?? '']),
    'person1_looks_important': partner1Traits['looks']?.toString() ?? '',
    'person1_intelligence_importance': partner1Traits['intelligence']?.toString() ?? '',
    'person1_circumcised': partner1Traits['circumcised']?.toString() ?? '',
    'person1_language_spoken': jsonEncode(partner1Languages),
  };
}

// ----------------------------------------------------------------------------
// PROFILE DETAILS SAVER
// ----------------------------------------------------------------------------

class ProfileDetailsSaver {
  static const String singleUrl =
      'https://app.beatflirtevent.com/App/user/edit_single_profile_details';
  static const String coupleUrl =
      'https://app.beatflirtevent.com/App/user/edit_couple_profile_details';

  static Future<bool> save({
    required String token,
    required ProfileEditState state,
  }) async {
    final isCouple = state.profileType.toLowerCase() == 'couple' || state.linkedPartner != null;
    final url = isCouple ? coupleUrl : singleUrl;

    debugPrint('========== SAVING PROFILE DETAILS ==========');
    debugPrint('URL: $url');
    debugPrint('IS COUPLE: $isCouple');

    final payload = _buildPayload(state);
    final headers = ApiService.buildAuthHeaders(token: token);
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    headers['Accept'] = 'application/json';

    final body = {...payload, 'token': token, 'Authtoken': token};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      debugPrint('PROFILE SAVE STATUS: ${response.statusCode}');
      debugPrint('PROFILE SAVE RESPONSE: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (state.userId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          final cacheKey = 'cached_profile_details_${state.userId}';
          
          final cacheData = <String, dynamic>{
            'aboutMe': state.aboutMe,
            'lookingFor': state.lookingFor,
            'person1Name': state.person1Name,
            'person2Name': state.person2Name,
            'partner1Languages': state.partner1Languages,
            'partner2Languages': state.partner2Languages,
          };
          
          state.partner1.forEach((key, value) {
            cacheData['partner1_$key'] = value;
          });
          
          state.partner2.forEach((key, value) {
            cacheData['partner2_$key'] = value;
          });

          await prefs.setString(cacheKey, jsonEncode(cacheData));
          debugPrint('✅ Saved profile details cache locally under key $cacheKey');
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('PROFILE SAVE ERROR: $e');
      return false;
    }
  }

  static String _formatToIso(String? dobStr) {
    if (dobStr == null || dobStr.trim().isEmpty) return '';
    final text = dobStr.trim();
    if (RegExp(r'^\d{4}-\d{1,2}-\d{1,2}$').hasMatch(text)) {
      return text;
    }
    final dmyMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);
    if (dmyMatch != null) {
      final day = dmyMatch.group(1)!.padLeft(2, '0');
      final month = dmyMatch.group(2)!.padLeft(2, '0');
      final year = dmyMatch.group(3)!;
      return '$year-$month-$day';
    }
    return text;
  }

  static Map<String, String> _buildPayload(ProfileEditState state) {
    final p1 = state.partner1;
    final p2 = state.partner2;
    final isCouple = state.profileType.toLowerCase() == 'couple' || state.linkedPartner != null;

    final payload = <String, String>{
      'text': state.aboutMe,
      'comment': state.lookingFor,
      'person1_name': state.person1Name,
      'person1_dob': _formatToIso(p1['dateOfBirth']),
      'person1_height': p1['height'] ?? '',
      'height1_type': p1['heightType'] ?? '',
      'person1_weight': p1['weight'] ?? '',
      'weight1_type': p1['weightType'] ?? '',
      'person1_body_type': p1['bodyType'] ?? '',
      'person1_ethnic_background': p1['ethnic'] ?? '',
      'person1_sexuality': p1['sexuality'] ?? '',
      'person1_relationship_orientation': p1['orientation'] ?? '',
      'person1_tattoos': p1['tattoos'] ?? '',
      'person1_piercings': p1['piercings'] ?? '',
      'person1_smoking': p1['smoking'] ?? '',
      'person1_drinking': p1['drinking'] ?? '',
      'person1_body_hair': jsonEncode([p1['bodyHair'] ?? '']),
      'person1_looks_important': p1['looks'] ?? '',
      'person1_intelligence_importance': p1['intelligence'] ?? '',
      'person1_circumcised': p1['circumcised'] ?? '',
      'person1_language_spoken': jsonEncode(state.partner1Languages),
    };

    if (isCouple) {
      payload.addAll({
        'person2_name': state.person2Name,
        'person2_dob': _formatToIso(p2['dateOfBirth']),
        'person2_height': p2['height'] ?? '',
        'height2_type': p2['heightType'] ?? '',
        'person2_weight': p2['weight'] ?? '',
        'weight2_type': p2['weightType'] ?? '',
        'person2_body_type': p2['bodyType'] ?? '',
        'person2_ethnic_background': p2['ethnic'] ?? '',
        'person2_sexuality': p2['sexuality'] ?? '',
        'person2_relationship_orientation': p2['orientation'] ?? '',
        'person2_tattoos': p2['tattoos'] ?? '',
        'person2_piercings': p2['piercings'] ?? '',
        'person2_smoking': p2['smoking'] ?? '',
        'person2_drinking': p2['drinking'] ?? '',
        'person2_body_hair': jsonEncode([p2['bodyHair'] ?? '']),
        'person2_looks_important': p2['looks'] ?? '',
        'person2_intelligence_importance': p2['intelligence'] ?? '',
        'person2_circumcised': p2['circumcised'] ?? '',
        'person2_language_spoken': jsonEncode(state.partner2Languages),
      });
    }

    return payload;
  }
}

// ----------------------------------------------------------------------------
// INTERESTS SAVER
// ----------------------------------------------------------------------------

class ProfileInterestsSaver {
  static const String singleUrl =
      'https://app.beatflirtevent.com/App/user/edit_single_profile_interest';
  static const String coupleUrl =
      'https://app.beatflirtevent.com/App/user/edit_single_profile_interest';

  static Future<bool> save({
    required String token,
    required ProfileEditState state,
  }) async {
    final isCouple = state.profileType.toLowerCase() == 'couple' || state.linkedPartner != null;
    final url = isCouple ? coupleUrl : singleUrl;
    final payload = _buildInterestsPayload(state);

    debugPrint('========== SAVING INTERESTS ==========');
    debugPrint('URL: $url');
    debugPrint('IS COUPLE: $isCouple');
    debugPrint('PAYLOAD: $payload');

    final headers = ApiService.buildAuthHeaders(token: token);
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';

    final body = {...payload, 'token': token, 'Authtoken': token};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      debugPrint('INTERESTS SAVE STATUS: ${response.statusCode}');
      debugPrint('INTERESTS SAVE BODY: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            final status = decoded['status']?.toString();
            final message = decoded['message']?.toString() ?? '';
            if (status == '200' || message.toLowerCase().contains('success')) {
              debugPrint('✅ Interests saved successfully');
              return true;
            }
          }
        } catch (_) {}
        // If we got a 2xx, treat as success
        debugPrint('⚠️ Got 2xx for interests save, treating as ok.');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('INTERESTS SAVE ERROR: $e');
      return false;
    }
  }

  static Map<String, String> _buildInterestsPayload(ProfileEditState state) {
    final s = state.swingersOptions;
    final h = state.hookupOptions;

    return {
      'couple_male_female_swingers': (s['Couple Female/Male'] ?? false) ? '1' : '0',
      'couple_male_female_hookup_meetup': (h['Couple Female/Male'] ?? false) ? '1' : '0',
      'couple_female_female_swingers': (s['Couple Female/Female'] ?? false) ? '1' : '0',
      'couple_female_female_hookup_meetup': (h['Couple Female/Female'] ?? false) ? '1' : '0',
      'couple_male_male_swingers': (s['Couple Male/Male'] ?? false) ? '1' : '0',
      'couple_male_male_hookup_meetup': (h['Couple Male/Male'] ?? false) ? '1' : '0',
      'couple_female_swingers': (s['Female'] ?? false) ? '1' : '0',
      'couple_female_hookup_meetup': (h['Female'] ?? false) ? '1' : '0',
      'couple_male_swingers': (s['Male'] ?? false) ? '1' : '0',
      'couple_male_hookup_meetup': (h['Male'] ?? false) ? '1' : '0',
      'couple_transgender_swingers': (s['Transgender'] ?? false) ? '1' : '0',
      'couple_transgender_hookup_meetup': (h['Transgender'] ?? false) ? '1' : '0',
    };
  }
}

// ==================== DEFAULT DATA ====================

Map<String, String> defaultPartnerTraits() {
  return {
    'dateOfBirth': '',
    'height': '',
    'heightType': '',
    'weight': '',
    'weightType': '',
    'bodyType': ProfileOptions.notComfortableValue,
    'ethnic': ProfileOptions.notComfortableValue,
    'sexuality': ProfileOptions.notComfortableValue,
    'orientation': ProfileOptions.notComfortableValue,
    'tattoos': ProfileOptions.notComfortableValue,
    'piercings': ProfileOptions.notComfortableValue,
    'smoking': ProfileOptions.notComfortableValue,
    'drinking': ProfileOptions.notComfortableValue,
    'bodyHair': ProfileOptions.notComfortableValue,
    'looks': ProfileOptions.notComfortableValue,
    'intelligence': ProfileOptions.notComfortableValue,
    'circumcised': ProfileOptions.notComfortableValue,
  };
}

// ==================== NOTIFIER (FIXED LOADING) ====================

// FIX #3: Mapping from FLAT backend field names → local trait keys
// The save endpoints send flat fields like 'person1_body_type'.
// The PHP backend typically returns the SAME flat fields, NOT nested objects.
// This map bridges that gap.
const Map<String, String> _flatToLocalP1 = {
  'person1_dob': 'dateOfBirth',
  'person1_height': 'height',
  'height1_type': 'heightType',
  'person1_weight': 'weight',
  'weight1_type': 'weightType',
  'person1_body_type': 'bodyType',
  'person1_ethnic_background': 'ethnic',
  'person1_sexuality': 'sexuality',
  'person1_relationship_orientation': 'orientation',
  'person1_tattoos': 'tattoos',
  'person1_piercings': 'piercings',
  'person1_smoking': 'smoking',
  'person1_drinking': 'drinking',
  'person1_body_hair': 'bodyHair',
  'person1_looks_important': 'looks',
  'person1_intelligence_importance': 'intelligence',
  'person1_circumcised': 'circumcised',
};

const Map<String, String> _flatToLocalP2 = {
  'person2_dob': 'dateOfBirth',
  'person2_height': 'height',
  'height2_type': 'heightType',
  'person2_weight': 'weight',
  'weight2_type': 'weightType',
  'person2_body_type': 'bodyType',
  'person2_ethnic_background': 'ethnic',
  'person2_sexuality': 'sexuality',
  'person2_relationship_orientation': 'orientation',
  'person2_tattoos': 'tattoos',
  'person2_piercings': 'piercings',
  'person2_smoking': 'smoking',
  'person2_drinking': 'drinking',
  'person2_body_hair': 'bodyHair',
  'person2_looks_important': 'looks',
  'person2_intelligence_importance': 'intelligence',
  'person2_circumcised': 'circumcised',
};

// FIX #3: Flat interest fields → local map keys
const Map<String, String> _flatSwingersFields = {
  'couple_male_female_swingers': 'Couple Female/Male',
  'couple_female_female_swingers': 'Couple Female/Female',
  'couple_male_male_swingers': 'Couple Male/Male',
  'couple_female_swingers': 'Female',
  'couple_male_swingers': 'Male',
  'couple_transgender_swingers': 'Transgender',
};

const Map<String, String> _flatHookupFields = {
  'couple_male_female_hookup_meetup': 'Couple Female/Male',
  'couple_female_female_hookup_meetup': 'Couple Female/Female',
  'couple_male_male_hookup_meetup': 'Couple Male/Male',
  'couple_female_hookup_meetup': 'Female',
  'couple_male_hookup_meetup': 'Male',
  'couple_transgender_hookup_meetup': 'Transgender',
};

/// Parse a value that might be a JSON-encoded array of strings.
/// E.g., '["Bikini"]' → 'Bikini', 'Natural' → 'Natural'
String _parseBodyHairValue(dynamic raw) {
  if (raw == null) return ProfileOptions.notComfortableValue;
  if (raw is String) {
    // Try JSON decode first
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded.first.toString();
      }
    } catch (_) {}
    // Plain string
    return raw;
  }
  if (raw is List && raw.isNotEmpty) {
    return raw.first.toString();
  }
  return raw.toString();
}

/// Parse list value that might be JSON-encoded
List<String> _parseLanguageList(dynamic raw) {
  if (raw == null) return [];
  if (raw is List) return raw.map((e) => e.toString()).toList();
  if (raw is String) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.map((e) => e.toString()).toList();
    } catch (_) {}
  }
  return [];
}

class ProfileEditNotifier extends Notifier<ProfileEditState> {
  @override
  ProfileEditState build() {
    Future.microtask(() => loadProfile());
    return ProfileEditState(
      swingersOptions: {
        'Couple Female/Male': true,
        'Couple Female/Female': true,
        'Couple Male/Male': true,
        'Female': true,
        'Male': true,
        'Transgender': true,
      },
      hookupOptions: {
        'Couple Female/Male': true,
        'Couple Female/Female': true,
        'Couple Male/Male': true,
        'Female': true,
        'Male': true,
        'Transgender': false,
      },
      partner1: defaultPartnerTraits(),
      partner2: defaultPartnerTraits(),
      partner1Languages: [],
      partner2Languages: [],
      profileType: 'single',
      username: '',
    );
  }

  Future<void> loadProfile() async {
    debugPrint('========== LOAD PROFILE ==========');
    state = state.copyWith(isLoading: true, loadError: null);

    try {
      final String? token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ No token from AuthService.getToken()');
        state = state.copyWith(isLoading: false, loadError: 'No auth token found');
        return;
      }

      final data = await getProfile(token: token);
      debugPrint('FULL PROFILE DATA: ${jsonEncode(data)}');
      debugPrint('RAW PROFILE DATA KEYS: ${data.keys.toList()}');

      // Flexible user extraction
      final user =
          data['user'] ??
          data['data']?['user'] ??
          data['profile'] ??
          data['data'] ??
          data;

      if (user is Map) {
        final userMap = Map<String, dynamic>.from(user);

        // ── PARSE PERSON 1 TRAITS ──────────────────────────────────
        final mergedTraits = defaultPartnerTraits();

        // Strategy 1: Try nested partner1Traits (ideal case)
        final backendTraits = Map<String, dynamic>.from(
          userMap['partner1Traits'] ?? {},
        );
        backendTraits.forEach((key, value) {
          if (mergedTraits.containsKey(key)) {
            if (key == 'bodyHair') {
              mergedTraits[key] = _parseBodyHairValue(value);
            } else {
              mergedTraits[key] = value.toString();
            }
          }
        });

        // Strategy 2 (THE FIX): Also parse FLAT fields from the response
        // because the PHP backend returns the same flat keys we saved
        _flatToLocalP1.forEach((flatKey, localKey) {
          if (userMap.containsKey(flatKey) && userMap[flatKey] != null) {
            final raw = userMap[flatKey];
            if (localKey == 'bodyHair') {
              mergedTraits[localKey] = _parseBodyHairValue(raw);
            } else {
              final strVal = raw.toString();
              if (strVal.isNotEmpty) {
                mergedTraits[localKey] = strVal;
              }
            }
          }
        });

        // Strategy 3: Also check 'data' wrapper for flat fields
        final innerData = data['data'] is Map ? Map<String, dynamic>.from(data['data']) : null;
        if (innerData != null) {
          _flatToLocalP1.forEach((flatKey, localKey) {
            if (innerData.containsKey(flatKey) && innerData[flatKey] != null) {
              final raw = innerData[flatKey];
              if (localKey == 'bodyHair') {
                mergedTraits[localKey] = _parseBodyHairValue(raw);
              } else {
                final strVal = raw.toString();
                if (strVal.isNotEmpty) {
                  mergedTraits[localKey] = strVal;
                }
              }
            }
          });
        }

        debugPrint('MERGED P1 TRAITS: $mergedTraits');

        // ── PARSE PERSON 1 LANGUAGES ───────────────────────────────
        final p1Langs = _parseLanguageList(
          userMap['partner1Languages'] ??
          userMap['person1_language_spoken'] ??
          innerData?['person1_language_spoken'] ??
          [],
        );

        // ── PARSE PERSON 2 (LINKED PARTNER) ────────────────────────
        final linked = userMap['partnerId'];
        Map<String, String> p2Traits = defaultPartnerTraits();
        List<String> p2Langs = [];
        Map<String, dynamic>? linkedMap;

        if (linked is Map) {
          linkedMap = Map<String, dynamic>.from(linked);

          // Try nested
          final lpTraits = Map<String, dynamic>.from(
            linkedMap['partner1Traits'] ?? {},
          );
          lpTraits.forEach((key, value) {
            if (p2Traits.containsKey(key)) {
              if (key == 'bodyHair') {
                p2Traits[key] = _parseBodyHairValue(value);
              } else {
                p2Traits[key] = value.toString();
              }
            }
          });

          // Try flat fields from linked partner object
          _flatToLocalP1.forEach((flatKey, localKey) {
            if (linkedMap!.containsKey(flatKey) && linkedMap[flatKey] != null) {
              final raw = linkedMap[flatKey];
              if (localKey == 'bodyHair') {
                p2Traits[localKey] = _parseBodyHairValue(raw);
              } else {
                final strVal = raw.toString();
                if (strVal.isNotEmpty) p2Traits[localKey] = strVal;
              }
            }
          });

          p2Langs = _parseLanguageList(
            linkedMap['partner1Languages'] ??
            linkedMap['person1_language_spoken'] ??
            [],
          );
        } else {
          // Try flat P2 fields from top-level response
          _flatToLocalP2.forEach((flatKey, localKey) {
            if (userMap.containsKey(flatKey) && userMap[flatKey] != null) {
              final raw = userMap[flatKey];
              if (localKey == 'bodyHair') {
                p2Traits[localKey] = _parseBodyHairValue(raw);
              } else {
                final strVal = raw.toString();
                if (strVal.isNotEmpty) p2Traits[localKey] = strVal;
              }
            }
          });
          p2Langs = _parseLanguageList(userMap['person2_language_spoken'] ?? []);
        }

        // Also check innerData for P2 flat fields
        if (innerData != null) {
          _flatToLocalP2.forEach((flatKey, localKey) {
            if (innerData.containsKey(flatKey) && innerData[flatKey] != null) {
              final raw = innerData[flatKey];
              if (localKey == 'bodyHair') {
                p2Traits[localKey] = _parseBodyHairValue(raw);
              } else {
                final strVal = raw.toString();
                if (strVal.isNotEmpty) p2Traits[localKey] = strVal;
              }
            }
          });
        }

        debugPrint('MERGED P2 TRAITS: $p2Traits');

        // ── PARSE INTERESTS ────────────────────────────────────────
        final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
        final mergedHookup = Map<String, bool>.from(state.hookupOptions);

        // Strategy 1: Nested objects
        final backendSwingers = Map<String, dynamic>.from(
          userMap['swingersOptions'] ?? {},
        );
        backendSwingers.forEach((key, value) {
          if (mergedSwingers.containsKey(key)) {
            mergedSwingers[key] = value == true || value == '1' || value == 1;
          }
        });

        final backendHookup = Map<String, dynamic>.from(
          userMap['hookupOptions'] ?? {},
        );
        backendHookup.forEach((key, value) {
          if (mergedHookup.containsKey(key)) {
            mergedHookup[key] = value == true || value == '1' || value == 1;
          }
        });

        // Strategy 2 (THE FIX): Parse FLAT interest fields
        _flatSwingersFields.forEach((flatKey, localKey) {
          if (userMap.containsKey(flatKey)) {
            final val = userMap[flatKey];
            mergedSwingers[localKey] = val == true || val == '1' || val == 1;
          }
        });
        _flatHookupFields.forEach((flatKey, localKey) {
          if (userMap.containsKey(flatKey)) {
            final val = userMap[flatKey];
            mergedHookup[localKey] = val == true || val == '1' || val == 1;
          }
        });

        // Also check innerData for flat interest fields
        if (innerData != null) {
          _flatSwingersFields.forEach((flatKey, localKey) {
            if (innerData.containsKey(flatKey)) {
              final val = innerData[flatKey];
              mergedSwingers[localKey] = val == true || val == '1' || val == 1;
            }
          });
          _flatHookupFields.forEach((flatKey, localKey) {
            if (innerData.containsKey(flatKey)) {
              final val = innerData[flatKey];
              mergedHookup[localKey] = val == true || val == '1' || val == 1;
            }
          });
        }

        debugPrint('MERGED SWINGERS: $mergedSwingers');
        debugPrint('MERGED HOOKUP: $mergedHookup');

        final String userId = userMap['id']?.toString() ?? innerData?['id']?.toString() ?? '';
        final String username = userMap['username']?.toString() ?? innerData?['username']?.toString() ?? '';

        String person1Name = userMap['person1_name']?.toString() ?? 
                             userMap['single_full_name']?.toString() ?? 
                             userMap['couple_full_name_from']?.toString() ?? 
                             innerData?['person1_name']?.toString() ?? 
                             '';
        String person2Name = userMap['person2_name']?.toString() ?? 
                             userMap['couple_full_name_to']?.toString() ?? 
                             innerData?['person2_name']?.toString() ?? 
                             '';

        String aboutMe = userMap['aboutMe']?.toString() ??
            userMap['text']?.toString() ??
            innerData?['text']?.toString() ??
            '';

        String lookingFor = userMap['lookingFor']?.toString() ??
            userMap['comment']?.toString() ??
            innerData?['comment']?.toString() ??
            '';

        List<String> localP1Langs = List<String>.from(p1Langs);
        List<String> localP2Langs = List<String>.from(p2Langs);

        // ── FALLBACK FROM LOCAL CACHE ──────────────────────────────
        if (userId.isNotEmpty) {
          try {
            final prefs = await SharedPreferences.getInstance();
            final cacheKey = 'cached_profile_details_$userId';
            final cachedStr = prefs.getString(cacheKey);
            if (cachedStr != null && cachedStr.isNotEmpty) {
              final cachedMap = jsonDecode(cachedStr);
              if (cachedMap is Map<String, dynamic>) {
                debugPrint('Found cached profile details for user $userId: $cachedStr');
                
                void fallbackField(Map<String, String> traits, String traitKey, String cachedValueKey) {
                  final currentVal = traits[traitKey];
                  final cachedVal = cachedMap[cachedValueKey]?.toString();
                  if ((currentVal == null || currentVal.isEmpty || currentVal == ProfileOptions.notComfortableValue) &&
                      cachedVal != null && cachedVal.isNotEmpty) {
                    traits[traitKey] = cachedVal;
                  }
                }

                if (aboutMe.isEmpty && cachedMap['aboutMe'] != null) {
                  aboutMe = cachedMap['aboutMe'].toString();
                }
                if (lookingFor.isEmpty && cachedMap['lookingFor'] != null) {
                  lookingFor = cachedMap['lookingFor'].toString();
                }
                if (person1Name.isEmpty && cachedMap['person1Name'] != null) {
                  person1Name = cachedMap['person1Name'].toString();
                }
                if (person2Name.isEmpty && cachedMap['person2Name'] != null) {
                  person2Name = cachedMap['person2Name'].toString();
                }

                // Fallback for traits
                mergedTraits.forEach((key, val) {
                  fallbackField(mergedTraits, key, 'partner1_$key');
                });
                p2Traits.forEach((key, val) {
                  fallbackField(p2Traits, key, 'partner2_$key');
                });

                // Fallback for languages
                if (localP1Langs.isEmpty && cachedMap['partner1Languages'] != null) {
                  localP1Langs = List<String>.from(cachedMap['partner1Languages']);
                }
                if (localP2Langs.isEmpty && cachedMap['partner2Languages'] != null) {
                  localP2Langs = List<String>.from(cachedMap['partner2Languages']);
                }
              }
            }
          } catch (e) {
            debugPrint('Error merging local cache: $e');
          }
        }

        // ── APPLY ALL PARSED DATA ──────────────────────────────────
        state = state.copyWith(
          aboutMe: aboutMe,
          lookingFor: lookingFor,
          partner1: mergedTraits,
          partner1Languages: localP1Langs,
          swingersOptions: mergedSwingers,
          hookupOptions: mergedHookup,
          partner2: p2Traits,
          partner2Languages: localP2Langs,
          linkedPartner: linkedMap,
          profileType: userMap['profile_type']?.toString() ?? 'single',
          person1Name: person1Name,
          person2Name: person2Name,
          userId: userId,
          username: username,
        );

        debugPrint('✅ Profile loaded successfully');
      } else {
        debugPrint('⚠️ No usable user data found in response. Full data: $data');
        state = state.copyWith(
          loadError: 'Unexpected response format from server',
        );
      }
    } catch (e, stack) {
      debugPrint('❌ Error loading profile: $e');
      debugPrint(stack.toString());
      state = state.copyWith(
        loadError: 'Failed to load profile: ${e.toString().substring(0, (e.toString().length).clamp(0, 100))}',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> saveProfile() async {
    final String? token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Error',
        'User token not found',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      if (state.isProfileDetailsTab) {
        final success = await ProfileDetailsSaver.save(
          token: token,
          state: state,
        );

        if (success) {
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // FIX #4: Reload profile from the API so the edit form shows
          // the latest saved data (instead of trying to refresh a separate
          // view provider that may not even be imported).
          await loadProfile();

          // Also refresh the home/view tab if the provider is available
          try {
            ref.read(viewSingleProfileProvider.notifier).fetchProfile();
          } catch (_) {
            debugPrint('⚠️ Could not refresh viewSingleProfileProvider (may not be registered)');
          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to update profile. Check console logs for details.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // INTERESTS TAB
        final success = await ProfileInterestsSaver.save(
          token: token,
          state: state,
        );

        if (success) {
          Get.snackbar(
            'Success',
            'Interests saved successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Reload to confirm data was persisted
          await loadProfile();

          try {
            ref.read(viewSingleProfileProvider.notifier).fetchProfile();
          } catch (_) {
            debugPrint('⚠️ Could not refresh viewSingleProfileProvider');
          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to save interests. Check console logs for details.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving: $e');
      Get.snackbar(
        'Error',
        'Failed to save: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ==================== UPDATE METHODS (unchanged) ====================

  void toggleProfileTab(bool isProfile) {
    state = state.copyWith(isProfileDetailsTab: isProfile);
  }

  void toggleSwingersExpanded() {
    state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
  }

  void toggleHookupExpanded() {
    state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
  }

  void updateSwingersOption(String label, bool value) {
    final newOptions = Map<String, bool>.from(state.swingersOptions);
    newOptions[label] = value;
    state = state.copyWith(swingersOptions: newOptions);
  }

  void updateHookupOption(String label, bool value) {
    final newOptions = Map<String, bool>.from(state.hookupOptions);
    newOptions[label] = value;
    state = state.copyWith(hookupOptions: newOptions);
  }

  void updateAboutMe(String value) {
    state = state.copyWith(aboutMe: value);
  }

  void updateLookingFor(String value) {
    state = state.copyWith(lookingFor: value);
  }

  void updatePartner1(String key, String value) {
    final newPartner = Map<String, String>.from(state.partner1);
    newPartner[key] = value;
    state = state.copyWith(partner1: newPartner);
  }

  void updatePartner2(String key, String value) {
    final newPartner = Map<String, String>.from(state.partner2);
    newPartner[key] = value;
    state = state.copyWith(partner2: newPartner);
  }

  void updatePartner1Languages(List<String> langs) {
    state = state.copyWith(partner1Languages: langs);
  }

  void updatePartner2Languages(List<String> langs) {
    state = state.copyWith(partner2Languages: langs);
  }
}

final profileEditProvider =
    NotifierProvider<ProfileEditNotifier, ProfileEditState>(
      ProfileEditNotifier.new,
    );

// ==================== WIDGET + ALL UI CODE ====================

class MyProfileEditTab extends ConsumerWidget {
  const MyProfileEditTab({super.key});

  static const List<String> languageOptions = [
    'English', 'Hindi', 'German', 'French', 'Spanish', 'Italian',
    'Portuguese', 'Chinese (Mandarin)', 'Japanese', 'Korean', 'Russian',
    'Arabic', 'Bengali', 'Urdu', 'Turkish', 'Dutch', 'Swedish', 'Polish',
    'Greek', 'Hebrew', 'Thai', 'Vietnamese', 'Indonesian', 'Malay', 'Filipino',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileEditProvider);
    final notifier = ref.read(profileEditProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
        final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.62,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E0F2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loading indicator
              if (profileState.isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: LinearProgressIndicator(color: Colors.pink),
                ),

              // FIX #6: Show load error in UI if present
              if (profileState.loadError != null && profileState.loadError!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            profileState.loadError!,
                            style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                          ),
                        ),
                        InkWell(
                          onTap: () => notifier.loadProfile(),
                          child: Text(
                            'RETRY',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              sectionHeader(profileState, notifier),
              const SizedBox(height: 16),

              if (profileState.isProfileDetailsTab)
                buildProfileDetailsContent(context, width, profileState, notifier)
              else
                buildInterestsContent(optionWidth, profileState, notifier),

              const SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    onPressed: profileState.isLoading
                        ? null
                        : () => notifier.saveProfile(),
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF220027),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: profileState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            profileState.isProfileDetailsTab
                                ? 'Save Profile'
                                : 'Save Interest',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  // ==================== UI HELPER METHODS ====================

  Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF19001F), Color(0xFF490040)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => notifier.toggleProfileTab(false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: !state.isProfileDetailsTab
                    ? const Color(0xFFFF2D87)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'INTERESTS',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => notifier.toggleProfileTab(true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: state.isProfileDetailsTab
                    ? const Color(0xFFFF2D87)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'PROFILE DETAILS',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInterestsContent(
    double optionWidth,
    ProfileEditState state,
    ProfileEditNotifier notifier,
  ) {
    final isCouple = state.profileType.toLowerCase() == 'couple';
    final displayName = isCouple
        ? ((state.person1Name.isNotEmpty && state.person2Name.isNotEmpty)
            ? '${state.person1Name} & ${state.person2Name}'
            : (state.person1Name.isNotEmpty
                ? state.person1Name
                : (state.username.isNotEmpty ? state.username : 'Couple Profile')))
        : (state.person1Name.isNotEmpty
            ? state.person1Name
            : (state.username.isNotEmpty ? state.username : 'Single Profile'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayName,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 34, height: 1.05)),
        const SizedBox(height: 8),
        Text('What are you looking for? Select all that apply',
          style: TextStyle(color: Colors.grey[700], fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        interestGroup(
          title: 'Swingers',
          expanded: state.isSwingersExpanded,
          onToggle: notifier.toggleSwingersExpanded,
          options: state.swingersOptions,
          optionWidth: optionWidth,
          onChanged: (label, value) => notifier.updateSwingersOption(label, value),
        ),
        const SizedBox(height: 12),
        interestGroup(
          title: 'Hookup / Meetup',
          expanded: state.isHookupExpanded,
          onToggle: notifier.toggleHookupExpanded,
          options: state.hookupOptions,
          optionWidth: optionWidth,
          onChanged: (label, value) => notifier.updateHookupOption(label, value),
        ),
      ],
    );
  }

  Widget buildProfileDetailsContent(
    BuildContext context,
    double width,
    ProfileEditState state,
    ProfileEditNotifier notifier,
  ) {
    final bool stacked = width < 760;
    final bool isCouple = state.profileType.toLowerCase() == 'couple' || state.linkedPartner != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldLabel('INTRODUCE YOURSELF'),
        const SizedBox(height: 6),
        simpleTextField(
          label: 'About Me',
          initialValue: state.aboutMe,
          onChanged: notifier.updateAboutMe,
        ),
        const SizedBox(height: 10),
        textFieldLabel('LOOKING FOR'),
        const SizedBox(height: 6),
        simpleTextField(
          label: 'Looking For',
          initialValue: state.lookingFor,
          maxLines: 2,
          onChanged: notifier.updateLookingFor,
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text('About Yourselves',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        if (isCouple)
          stacked
              ? Column(
                  children: [
                    partnerPanel(
                      context: context, title: 'Partner 1', data: state.partner1,
                      languages: state.partner1Languages,
                      onFieldChanged: notifier.updatePartner1,
                      onLanguagesChanged: notifier.updatePartner1Languages,
                      readOnly: false,
                    ),
                    const SizedBox(height: 12),
                    partnerPanel(
                      context: context, title: 'Partner 2', data: state.partner2,
                      languages: state.partner2Languages,
                      onFieldChanged: notifier.updatePartner2,
                      onLanguagesChanged: notifier.updatePartner2Languages,
                      readOnly: false,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: partnerPanel(
                      context: context, title: 'Partner 1', data: state.partner1,
                      languages: state.partner1Languages,
                      onFieldChanged: notifier.updatePartner1,
                      onLanguagesChanged: notifier.updatePartner1Languages,
                      readOnly: false,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: partnerPanel(
                      context: context, title: 'Partner 2', data: state.partner2,
                      languages: state.partner2Languages,
                      onFieldChanged: notifier.updatePartner2,
                      onLanguagesChanged: notifier.updatePartner2Languages,
                      readOnly: false,
                    )),
                  ],
                )
        else
          partnerPanel(
            context: context, title: 'Partner 1', data: state.partner1,
            languages: state.partner1Languages,
            onFieldChanged: notifier.updatePartner1,
            onLanguagesChanged: notifier.updatePartner1Languages,
            readOnly: false,
          ),
      ],
    );
  }

  Widget partnerPanel({
    required BuildContext context,
    required String title,
    required Map<String, String> data,
    required List<String> languages,
    required void Function(String, String) onFieldChanged,
    required void Function(List<String>) onLanguagesChanged,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF19001F), Color(0xFF490040)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 10),
        dateOfBirthField(
          context: context, label: 'DATE OF BIRTH', data: data,
          keyName: 'dateOfBirth', onFieldChanged: onFieldChanged, readOnly: readOnly,
        ),
        heightInputField(data: data, onFieldChanged: onFieldChanged, readOnly: readOnly),
        weightInputField(data: data, onFieldChanged: onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('BODY TYPE', data, 'bodyType', ProfileOptions.bodyTypes, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('ETHNIC BACKGROUND', data, 'ethnic', ProfileOptions.ethnicBackgrounds, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('SEXUALITY', data, 'sexuality', ProfileOptions.sexualities, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('RELATIONSHIP ORIENTATION', data, 'orientation', ProfileOptions.relationshipOrientations, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('TATTOOS', data, 'tattoos', ProfileOptions.tattoos, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('PIERCINGS', data, 'piercings', ProfileOptions.piercings, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('SMOKING', data, 'smoking', ProfileOptions.smoking, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('DRINKING', data, 'drinking', ProfileOptions.drinking, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('BODY HAIR', data, 'bodyHair', ProfileOptions.bodyHair, onFieldChanged, readOnly: readOnly),
        languagesField(context, 'LANGUAGES SPOKEN', languages, onLanguagesChanged, readOnly: readOnly),
        profileOptionDropdownField('LOOKS IMPORTANCE', data, 'looks', ProfileOptions.importanceLevels, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('INTELLIGENCE IMPORTANCE', data, 'intelligence', ProfileOptions.importanceLevels, onFieldChanged, readOnly: readOnly),
        profileOptionDropdownField('CIRCUMCISED', data, 'circumcised', ProfileOptions.circumcised, onFieldChanged, readOnly: readOnly),
      ],
    );
  }

  // ==================== REMAINING UI WIDGETS ====================

  Widget dateOfBirthField({
    required BuildContext context,
    required String label,
    required Map<String, String> data,
    required String keyName,
    required void Function(String, String) onFieldChanged,
    bool readOnly = false,
  }) {
    final currentValue = data[keyName] ?? '';
    String displayValue = currentValue.trim().isEmpty ? 'dd/mm/yyyy' : currentValue;
    if (RegExp(r'^\d{4}-\d{1,2}-\d{1,2}$').hasMatch(displayValue)) {
      final parts = displayValue.split('-');
      displayValue = '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldLabel(label),
          const SizedBox(height: 4),
          InkWell(
            onTap: readOnly ? null : () async {
              final now = DateTime.now();
              final parsedDate = parseProfileDate(currentValue);
              DateTime initialDate = parsedDate ?? DateTime(now.year - 18, now.month, now.day);
              if (initialDate.isAfter(now)) initialDate = now;
              if (initialDate.isBefore(DateTime(1900))) initialDate = DateTime(1900);

              final pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: now,
              );
              if (pickedDate == null) return;
              onFieldChanged(keyName, formatProfileDate(pickedDate));
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 42,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayValue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: currentValue.trim().isEmpty ? Colors.grey[600] : Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 17, color: Colors.black87),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget heightInputField({
    required Map<String, String> data,
    required void Function(String, String) onFieldChanged,
    bool readOnly = false,
  }) {
    final selectedType = (data['heightType'] ?? '').trim().isEmpty ? null : data['heightType'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldLabel('HEIGHT'),
          const SizedBox(height: 2),
          Row(
            children: [
              unitRadioButton(label: 'FT', value: 'FT', groupValue: selectedType, readOnly: readOnly, onChanged: (value) => onFieldChanged('heightType', value)),
              const SizedBox(width: 18),
              unitRadioButton(label: 'CM', value: 'CM', groupValue: selectedType, readOnly: readOnly, onChanged: (value) => onFieldChanged('heightType', value)),
            ],
          ),
          const SizedBox(height: 4),
          TextFormField(
            key: ValueKey('height-$readOnly'),
            initialValue: data['height'] ?? '',
            readOnly: readOnly,
            onChanged: readOnly ? null : (value) => onFieldChanged('height', value),
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            decoration: profileInputDecoration(hintText: "Ex. (5'7 OR 170)", readOnly: readOnly),
          ),
        ],
      ),
    );
  }

  Widget weightInputField({
    required Map<String, String> data,
    required void Function(String, String) onFieldChanged,
    bool readOnly = false,
  }) {
    final selectedType = (data['weightType'] ?? '').trim().isEmpty ? null : data['weightType'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldLabel('WEIGHT'),
          const SizedBox(height: 2),
          Row(
            children: [
              unitRadioButton(label: 'LBS', value: 'LBS', groupValue: selectedType, readOnly: readOnly, onChanged: (value) => onFieldChanged('weightType', value)),
              const SizedBox(width: 18),
              unitRadioButton(label: 'KG', value: 'KG', groupValue: selectedType, readOnly: readOnly, onChanged: (value) => onFieldChanged('weightType', value)),
            ],
          ),
          const SizedBox(height: 4),
          TextFormField(
            key: ValueKey('weight-$readOnly'),
            initialValue: data['weight'] ?? '',
            readOnly: readOnly,
            onChanged: readOnly ? null : (value) => onFieldChanged('weight', value),
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            decoration: profileInputDecoration(hintText: 'Ex. (150 LBS OR 68 KG)', readOnly: readOnly),
          ),
        ],
      ),
    );
  }

  Widget unitRadioButton({
    required String label,
    required String value,
    required String? groupValue,
    required void Function(String) onChanged,
    bool readOnly = false,
  }) {
    return InkWell(
      onTap: readOnly ? null : () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: readOnly ? null : (selectedValue) { if (selectedValue != null) onChanged(selectedValue); },
            activeColor: const Color(0xFF5A002B),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF5A002B))),
        ],
      ),
    );
  }

  InputDecoration profileInputDecoration({required String hintText, bool readOnly = false}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE8E0F2))),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2)),
      ),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF5A002B))),
      fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
      filled: true,
    );
  }

  DateTime? parseProfileDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final text = value.trim();
    final dmyMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);
    if (dmyMatch != null) {
      final day = int.tryParse(dmyMatch.group(1)!);
      final month = int.tryParse(dmyMatch.group(2)!);
      final year = int.tryParse(dmyMatch.group(3)!);
      if (day != null && month != null && year != null) return DateTime(year, month, day);
    }
    final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
    if (isoMatch != null) {
      final year = int.tryParse(isoMatch.group(1)!);
      final month = int.tryParse(isoMatch.group(2)!);
      final day = int.tryParse(isoMatch.group(3)!);
      if (day != null && month != null && year != null) return DateTime(year, month, day);
    }
    return DateTime.tryParse(text);
  }

  String formatProfileDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  ProfileOption? findProfileOption(String? currentValue, List<ProfileOption> options) {
    if (currentValue == null || currentValue.trim().isEmpty) return null;
    final normalizedCurrent = normalize(currentValue);
    for (final option in options) {
      if (normalize(option.id) == normalizedCurrent ||
          normalize(option.value) == normalizedCurrent ||
          normalize(option.label) == normalizedCurrent) {
        return option;
      }
    }
    if (normalizedCurrent == normalize('Bisexual')) {
      return firstProfileOptionWhere(options, (e) => e.value == 'Bi-sexual');
    }
    if (normalizedCurrent == normalize('Occasionally')) {
      return firstProfileOptionWhere(options, (e) => e.value == 'Occasionally');
    }
    if (normalizedCurrent == normalize('Low')) {
      return firstProfileOptionWhere(options, (e) => e.value == 'Low Importance');
    }
    if (normalizedCurrent == normalize('Medium')) {
      return firstProfileOptionWhere(options, (e) => e.value == 'Medium Importance');
    }
    if (normalizedCurrent == normalize('High')) {
      return firstProfileOptionWhere(options, (e) => e.value == 'Very Important');
    }
    return null;
  }

  ProfileOption? firstProfileOptionWhere(List<ProfileOption> options, bool Function(ProfileOption) test) {
    for (final option in options) { if (test(option)) return option; }
    return null;
  }

  String normalize(String value) {
    return value.trim().toLowerCase().replaceAll('.', '').replaceAll('-', '').replaceAll('_', '').replaceAll(' ', '');
  }

  String? defaultProfileOptionValue(List<ProfileOption> options) {
    if (options.isEmpty) return null;
    for (final option in options) { if (option.id == 'not_comfortable') return option.value; }
    return options.first.value;
  }

  Widget profileOptionDropdownField(
    String label,
    Map<String, String> data,
    String key,
    List<ProfileOption> options,
    void Function(String, String) onFieldChanged, {
    bool readOnly = false,
  }) {
    final currentValue = data[key];
    final selectedOption = findProfileOption(currentValue, options);
    final validValue = selectedOption?.value ?? defaultProfileOptionValue(options);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldLabel(label),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            key: ValueKey('$label-$key-$readOnly'),
            initialValue: validValue,
            isExpanded: true,
            iconSize: 18,
            style: const TextStyle(fontSize: 12, color: Colors.black87, overflow: TextOverflow.ellipsis),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option.value,
                child: Text(option.label, maxLines: 1, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            selectedItemBuilder: (context) {
              return options.map((option) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(option.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                );
              }).toList();
            },
            onChanged: readOnly ? null : (value) { if (value != null) onFieldChanged(key, value); },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE8E0F2))),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2)),
              ),
              fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
              filled: readOnly,
            ),
          ),
        ],
      ),
    );
  }

  Widget simpleTextField({
    required String label,
    required String initialValue,
    required void Function(String) onChanged,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TextFormField(
      // Stable key — do NOT include live value to avoid focus loss
      key: ValueKey('$label-$readOnly'),
      initialValue: initialValue,
      maxLines: maxLines,
      onChanged: onChanged,
      readOnly: readOnly,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE8E0F2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE8E0F2))),
      ),
    );
  }

  Widget textFieldLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.2));
  }

  Widget languagesField(
    BuildContext context,
    String label,
    List<String> selectedValues,
    void Function(List<String>) onSaved, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldLabel(label),
          const SizedBox(height: 4),
          InkWell(
            onTap: readOnly ? null : () => openLanguageSelector(context, selectedValues, onSaved),
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE8E0F2))),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2)),
                ),
                fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
                filled: true,
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black87),
              ),
              child: selectedValues.isEmpty
                  ? Text(ProfileOptions.notComfortableLabel, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12))
                  : Wrap(
                      spacing: 6, runSpacing: 6,
                      children: selectedValues.map((lang) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD4DDF2)),
                        ),
                        child: Text(lang, style: const TextStyle(fontSize: 11)),
                      )).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openLanguageSelector(
    BuildContext context,
    List<String> selectedValues,
    void Function(List<String>) onSaved,
  ) async {
    final temp = [...selectedValues];
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Select Languages', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 10),
                      ...languageOptions.map((lang) => CheckboxListTile(
                        dense: true,
                        value: temp.contains(lang),
                        onChanged: (checked) {
                          setModalState(() {
                            if (checked == true) { if (!temp.contains(lang)) temp.add(lang); }
                            else { temp.remove(lang); }
                          });
                        },
                        title: Text(lang),
                        controlAffinity: ListTileControlAffinity.leading,
                      )),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () { onSaved(temp); Navigator.pop(context); },
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget interestGroup({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Map<String, bool> options,
    required double optionWidth,
    required void Function(String label, bool value) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFECE4F4)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF19001F), Color(0xFF490040)]),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(10),
                  bottom: expanded ? Radius.zero : const Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, height: 1.0)),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFFEACD71),
                    child: Icon(
                      expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 16, color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                spacing: 8, runSpacing: 8,
                children: options.entries.map((entry) => OptionChip(
                  label: entry.key, selected: entry.value, width: optionWidth,
                  onTap: () => onChanged(entry.key, !entry.value),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== OPTION CHIP ====================

class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.width,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF1EBF8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
            ),
            Checkbox(
              value: selected,
              onChanged: (_) => onTap(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              activeColor: const Color(0xFF47003D),
              side: const BorderSide(color: Color(0xFFE0D4EE)),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_home_tab.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:beatflirt/core/services/auth_services.dart'; // adjust path if needed
// import 'package:beatflirt/Api_services/api_service.dart';
// // import 'package:beatflirt/providers/profile_hometab_provider.dart'; // for refreshing home tab after save

// // ==================== DATA MODELS ====================

// class ProfileOption {
//   final String id;
//   final String value;
//   final String label;

//   const ProfileOption({
//     required this.id,
//     required this.value,
//     required this.label,
//   });

//   Map<String, dynamic> toJson() {
//     return {'id': id, 'value': value, 'label': label};
//   }
// }

// class ProfileOptions {
//   static const String notComfortableValue = 'Im not comfortable sharing that';
//   static const String notComfortableLabel = "I'm not comfortable sharing that.";

//   static const ProfileOption notComfortable = ProfileOption(
//     id: 'not_comfortable',
//     value: notComfortableValue,
//     label: notComfortableLabel,
//   );

//   static const List<ProfileOption> tattoos = [
//     notComfortable,
//     ProfileOption(id: 'none', value: 'None', label: 'None'),
//     ProfileOption(id: 'one', value: 'One', label: 'One'),
//     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
//     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
//     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
//   ];

//   static const List<ProfileOption> heightTypes = [
//     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
//     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
//   ];

//   static const List<ProfileOption> weightTypes = [
//     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
//     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
//   ];

//   static const List<ProfileOption> bodyTypes = [
//     notComfortable,
//     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
//     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
//     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
//     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
//     ProfileOption(
//       id: 'huggable_and_heavy',
//       value: 'Huggable and Heavy',
//       label: 'Huggable and Heavy',
//     ),
//     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
//     ProfileOption(
//       id: 'more_of_me_to_love',
//       value: 'More of me to love',
//       label: 'More of me to love',
//     ),
//     ProfileOption(
//       id: 'nicely_shaped',
//       value: 'Nicely Shaped',
//       label: 'Nicely Shaped',
//     ),
//     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
//   ];

//   static const List<ProfileOption> smoking = [
//     notComfortable,
//     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
//     ProfileOption(id: 'no', value: 'No', label: 'No'),
//     ProfileOption(
//       id: 'occasionally',
//       value: 'Occasionally',
//       label: 'Occasionally',
//     ),
//   ];

//   static const List<ProfileOption> drinking = [
//     notComfortable,
//     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
//     ProfileOption(id: 'no', value: 'No', label: 'No'),
//     ProfileOption(
//       id: 'occasionally',
//       value: 'Occasionally',
//       label: 'Occasionally',
//     ),
//   ];

//   static const List<ProfileOption> ethnicBackgrounds = [
//     notComfortable,
//     ProfileOption(id: 'other', value: 'Other', label: 'Other'),
//     ProfileOption(id: 'american', value: 'American', label: 'American'),
//     ProfileOption(
//       id: 'argentine_argentinian',
//       value: 'Argentine/Argentinian',
//       label: 'Argentine/Argentinian',
//     ),
//     ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
//     ProfileOption(
//       id: 'black_african_american',
//       value: 'Black/African - American',
//       label: 'Black/African - American',
//     ),
//     ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
//     ProfileOption(id: 'british', value: 'British', label: 'British'),
//     ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
//     ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
//     ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
//     ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
//     ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
//     ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
//     ProfileOption(id: 'french', value: 'French', label: 'French'),
//     ProfileOption(id: 'german', value: 'German', label: 'German'),
//     ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
//     ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
//     ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
//     ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
//     ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
//     ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
//     ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
//     ProfileOption(
//       id: 'new_zealander_kiwi',
//       value: 'New Zealander/Kiwi',
//       label: 'New Zealander/Kiwi',
//     ),
//     ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
//     ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
//     ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
//     ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
//     ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
//     ProfileOption(
//       id: 'south_african',
//       value: 'South African',
//       label: 'South African',
//     ),
//     ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
//     ProfileOption(id: 'sri_lankan', value: 'Sri Lankan', label: 'Sri Lankan'),
//     ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
//     ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
//   ];

//   static const List<ProfileOption> importanceLevels = [
//     notComfortable,
//     ProfileOption(id: 'no', value: 'No', label: 'No'),
//     ProfileOption(
//       id: 'low_importance',
//       value: 'Low Importance',
//       label: 'Low Importance',
//     ),
//     ProfileOption(
//       id: 'medium_importance',
//       value: 'Medium Importance',
//       label: 'Medium Importance',
//     ),
//     ProfileOption(
//       id: 'very_important',
//       value: 'Very Important',
//       label: 'Very Important',
//     ),
//   ];

//   static const List<ProfileOption> sexualities = [
//     notComfortable,
//     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
//     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
//     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
//     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
//     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
//     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
//     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
//     ProfileOption(
//       id: 'transsexual',
//       value: 'Transsexual',
//       label: 'Transsexual',
//     ),
//   ];

//   static const List<ProfileOption> relationshipOrientations = [
//     notComfortable,
//     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
//     ProfileOption(
//       id: 'open_minded',
//       value: 'Open-Minded',
//       label: 'Open-Minded',
//     ),
//     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
//     ProfileOption(
//       id: 'polyamorous',
//       value: 'Polyamorous',
//       label: 'Polyamorous',
//     ),
//   ];

//   static const List<ProfileOption> circumcised = [
//     notComfortable,
//     ProfileOption(id: 'no', value: 'No', label: 'No'),
//     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
//   ];

//   static const List<ProfileOption> piercings = [
//     notComfortable,
//     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
//     ProfileOption(id: 'no', value: 'No', label: 'No'),
//   ];

//   static const List<ProfileOption> bodyHair = [
//     notComfortable,
//     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
//     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
//     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
//     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
//   ];

//   static const Map<String, List<ProfileOption>> groups = {
//     'tattoos': tattoos,
//     'height_types': heightTypes,
//     'weight_types': weightTypes,
//     'body_types': bodyTypes,
//     'smoking': smoking,
//     'drinking': drinking,
//     'ethnic_backgrounds': ethnicBackgrounds,
//     'importance_levels': importanceLevels,
//     'sexualities': sexualities,
//     'relationship_orientations': relationshipOrientations,
//     'circumcised': circumcised,
//     'piercings': piercings,
//     'body_hair': bodyHair,
//   };
// }

// class ProfileFieldOptions {
//   static const Map<String, String> fieldGroupMap = {
//     'bodyType': 'body_types',
//     'ethnic': 'ethnic_backgrounds',
//     'sexuality': 'sexualities',
//     'orientation': 'relationship_orientations',
//     'tattoos': 'tattoos',
//     'piercings': 'piercings',
//     'smoking': 'smoking',
//     'drinking': 'drinking',
//     'bodyHair': 'body_hair',
//     'looks': 'importance_levels',
//     'intelligence': 'importance_levels',
//     'circumcised': 'circumcised',
//     'person1_tattoos': 'tattoos',
//     'person2_tattoos': 'tattoos',
//     'person1_height_type': 'height_types',
//     'person2_height_type': 'height_types',
//     'person1_weight_type': 'weight_types',
//     'person2_weight_type': 'weight_types',
//     'person1_body_type': 'body_types',
//     'person2_body_type': 'body_types',
//     'person1_smoking': 'smoking',
//     'person2_smoking': 'smoking',
//     'person1_drinking': 'drinking',
//     'person2_drinking': 'drinking',
//     'person1_ethnic_background': 'ethnic_backgrounds',
//     'person2_ethnic_background': 'ethnic_backgrounds',
//     'person1_looks_important': 'importance_levels',
//     'person2_looks_important': 'importance_levels',
//     'person1_intelligence_importance': 'importance_levels',
//     'person2_intelligence_importance': 'importance_levels',
//     'person1_sexuality': 'sexualities',
//     'person2_sexuality': 'sexualities',
//     'person1_relationship_orientation': 'relationship_orientations',
//     'person2_relationship_orientation': 'relationship_orientations',
//     'person1_circumcised': 'circumcised',
//     'person2_circumcised': 'circumcised',
//     'person1_piercings': 'piercings',
//     'person2_piercings': 'piercings',
//   };

//   static List<ProfileOption> getOptionsForField(String fieldName) {
//     final groupKey = fieldGroupMap[fieldName];
//     if (groupKey == null) return [];
//     return ProfileOptions.groups[groupKey] ?? [];
//   }
// }

// // ==================== STATE ====================

// class ProfileEditState {
//   final bool isProfileDetailsTab;
//   final Map<String, bool> swingersOptions;
//   final Map<String, bool> hookupOptions;
//   final bool isSwingersExpanded;
//   final bool isHookupExpanded;
//   final String aboutMe;
//   final String lookingFor;
//   final Map<String, String> partner1;
//   final Map<String, String> partner2;
//   final List<String> partner1Languages;
//   final List<String> partner2Languages;
//   final bool isLoading;
//   final Map<String, dynamic>? linkedPartner;

//   const ProfileEditState({
//     this.isProfileDetailsTab = false,
//     required this.swingersOptions,
//     required this.hookupOptions,
//     this.isSwingersExpanded = true,
//     this.isHookupExpanded = true,
//     this.aboutMe = '',
//     this.lookingFor = '',
//     required this.partner1,
//     required this.partner2,
//     required this.partner1Languages,
//     required this.partner2Languages,
//     this.isLoading = false,
//     this.linkedPartner,
//   });

//   ProfileEditState copyWith({
//     bool? isProfileDetailsTab,
//     Map<String, bool>? swingersOptions,
//     Map<String, bool>? hookupOptions,
//     bool? isSwingersExpanded,
//     bool? isHookupExpanded,
//     String? aboutMe,
//     String? lookingFor,
//     Map<String, String>? partner1,
//     Map<String, String>? partner2,
//     List<String>? partner1Languages,
//     List<String>? partner2Languages,
//     bool? isLoading,
//     Map<String, dynamic>? linkedPartner,
//   }) {
//     return ProfileEditState(
//       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
//       swingersOptions: swingersOptions ?? this.swingersOptions,
//       hookupOptions: hookupOptions ?? this.hookupOptions,
//       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
//       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
//       aboutMe: aboutMe ?? this.aboutMe,
//       lookingFor: lookingFor ?? this.lookingFor,
//       partner1: partner1 ?? this.partner1,
//       partner2: partner2 ?? this.partner2,
//       partner1Languages: partner1Languages ?? this.partner1Languages,
//       partner2Languages: partner2Languages ?? this.partner2Languages,
//       isLoading: isLoading ?? this.isLoading,
//       linkedPartner: linkedPartner ?? this.linkedPartner,
//     );
//   }
// }

// // ==================== API HELPERS (CLEAN & PERMANENT) ====================

// const String baseApiUrl = 'https://app.beatflirtevent.com/App/user';

// // Fixed spelling + fallback
// const List<String> profileUrls = ['$baseApiUrl/signle_user_profile'];

// Map<String, String> apiHeaders({bool json = false}) {
//   // Delegate to shared builder (will use last token if needed, but callers should pass)
//   final h = ApiService.buildAuthHeaders();
//   if (!json) {
//     h['Content-Type'] = 'application/x-www-form-urlencoded';
//   }
//   return h;
// }

// bool _isHtmlError(String body) {
//   final lower = body.toLowerCase();
//   return lower.contains('404') ||
//       lower.contains('not found') ||
//       lower.contains('the page you requested');
// }

// bool _isTokenError(String body) {
//   final lower = body.toLowerCase();
//   return lower.contains('token') &&
//       (lower.contains('required') ||
//           lower.contains('missing') ||
//           lower.contains('invalid') ||
//           lower.contains('provide'));
// }

// Map<String, dynamic>? _tryDecode(String body) {
//   try {
//     final decoded = jsonDecode(body);
//     if (decoded is Map<String, dynamic>) return decoded;
//   } catch (_) {}
//   return null;
// }

// // ==================== PERMANENT getProfile ====================

// Future<Map<String, dynamic>> getProfile({required String token}) async {
//   debugPrint('========== GET PROFILE START ==========');
//   debugPrint('Using token length: ${token.length}');

//   // Common successful patterns for this style of backend
//   final attempts = <Future<http.Response> Function()>[
//     // 1. POST form - most reliable for many PHP backends
//     () => http.post(
//       Uri.parse(profileUrls[0]),
//       headers: apiHeaders(),
//       body: {'token': token},
//     ),
//     () => http.post(
//       Uri.parse(profileUrls[0]),
//       headers: apiHeaders(),
//       body: {'Authtoken': token},
//     ),

//     // 2. Bearer header (modern)
//     () => http.get(
//       Uri.parse(profileUrls[0]),
//       headers: {...apiHeaders(), 'Authorization': 'Bearer $token'},
//     ),

//     // 3. Custom header
//     () => http.get(
//       Uri.parse(profileUrls[0]),
//       headers: {...apiHeaders(), 'token': token},
//     ),
//     () => http.get(
//       Uri.parse(profileUrls[0]),
//       headers: {...apiHeaders(), 'Authtoken': token},
//     ),

//     // 4. Query param fallback
//     () => http.get(
//       Uri.parse('${profileUrls[0]}?token=$token'),
//       headers: apiHeaders(),
//     ),
//   ];

//   for (int i = 0; i < attempts.length; i++) {
//     try {
//       final response = await attempts[i]();

//       debugPrint('ATTEMPT ${i + 1} → ${response.statusCode}');

//       if (response.statusCode < 200 || response.statusCode >= 300) continue;
//       if (_isHtmlError(response.body)) continue;
//       if (_isTokenError(response.body)) continue;

//       final decoded = _tryDecode(response.body);
//       if (decoded != null) {
//         debugPrint('✅ SUCCESS on attempt ${i + 1}');
//         debugPrint('========== GET PROFILE END ==========');
//         return decoded;
//       }
//     } catch (e) {
//       debugPrint('ATTEMPT ${i + 1} ERROR: $e');
//     }
//   }

//   throw Exception(
//     'Failed to load profile. No authentication method worked. '
//     'Run AuthService.probeAuth() in debug mode and check the [PROBE] logs.',
//   );
// }

// // ==================== UPDATE PROFILE (kept probing for now) ====================

// // We keep the candidate list for updates because the correct endpoint is still unknown.
// const List<String> updateProfileCandidateUrls = [
//   '$baseApiUrl/update_profile',
//   '$baseApiUrl/update_user_profile',
//   '$baseApiUrl/update_profile_details',
//   '$baseApiUrl/save_profile',
//   '$baseApiUrl/profile_update',
//   '$baseApiUrl/edit_profile',
//   '$baseApiUrl/update_user',
// ];

// Map<String, String> buildProfileFormBody({
//   required String token,
//   required Map<String, dynamic> updates,
// }) {
//   final partner1Traits = Map<String, dynamic>.from(
//     updates['partner1Traits'] ?? {},
//   );
//   final partner1Languages = List<dynamic>.from(
//     updates['partner1Languages'] ?? [],
//   );
//   final swingersOptions = Map<String, dynamic>.from(
//     updates['swingersOptions'] ?? {},
//   );
//   final hookupOptions = Map<String, dynamic>.from(
//     updates['hookupOptions'] ?? {},
//   );

//   return {
//     'token': token,
//     'Authtoken': token,
//     'aboutMe': updates['aboutMe']?.toString() ?? '',
//     'lookingFor': updates['lookingFor']?.toString() ?? '',
//     'partner1Traits': jsonEncode(partner1Traits),
//     'partner1Languages': jsonEncode(partner1Languages),
//     'swingersOptions': jsonEncode(swingersOptions),
//     'hookupOptions': jsonEncode(hookupOptions),
//     'text': updates['aboutMe']?.toString() ?? '',
//     'comment': updates['lookingFor']?.toString() ?? '',
//     'person1_dob': partner1Traits['dateOfBirth']?.toString() ?? '',
//     'person1_height': partner1Traits['height']?.toString() ?? '',
//     'height1_type': partner1Traits['heightType']?.toString() ?? '',
//     'person1_weight': partner1Traits['weight']?.toString() ?? '',
//     'weight1_type': partner1Traits['weightType']?.toString() ?? '',
//     'person1_body_type': partner1Traits['bodyType']?.toString() ?? '',
//     'person1_ethnic_background': partner1Traits['ethnic']?.toString() ?? '',
//     'person1_sexuality': partner1Traits['sexuality']?.toString() ?? '',
//     'person1_relationship_orientation':
//         partner1Traits['orientation']?.toString() ?? '',
//     'person1_tattoos': partner1Traits['tattoos']?.toString() ?? '',
//     'person1_piercings': partner1Traits['piercings']?.toString() ?? '',
//     'person1_smoking': partner1Traits['smoking']?.toString() ?? '',
//     'person1_drinking': partner1Traits['drinking']?.toString() ?? '',
//     'person1_body_hair': partner1Traits['bodyHair']?.toString() ?? '',
//     'person1_looks_important': partner1Traits['looks']?.toString() ?? '',
//     'person1_intelligence_importance':
//         partner1Traits['intelligence']?.toString() ?? '',
//     'person1_circumcised': partner1Traits['circumcised']?.toString() ?? '',
//     'person1_language_spoken': jsonEncode(partner1Languages),
//   };
// }

// // ----------------------------------------------------------------------------
// // PROFILE DETAILS SAVER
// // ----------------------------------------------------------------------------
// class ProfileDetailsSaver {
//   static const String singleUrl =
//       'https://app.beatflirtevent.com/App/user/edit_single_profile_details';
//   static const String coupleUrl =
//       'https://app.beatflirtevent.com/App/user/edit_couple_profile_details';

//   static Future<bool> save({
//     required String token,
//     required ProfileEditState state,
//   }) async {
//     final isCouple = state.linkedPartner != null;
//     final url = isCouple ? coupleUrl : singleUrl;

//     final payload = _buildPayload(state);

//     debugPrint('========== SAVING PROFILE DETAILS ==========');
//     debugPrint('URL: $url');
//     debugPrint('IS COUPLE: $isCouple');
//     debugPrint('TOKEN length: ${token.length}');

//     final headers = ApiService.buildAuthHeaders(token: token);
//     headers['Content-Type'] = 'application/x-www-form-urlencoded';
//     headers['Accept'] = 'application/json';

//     final body = {...payload, 'token': token, 'Authtoken': token};

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );

//       debugPrint('SAVE STATUS: ${response.statusCode}');
//       debugPrint('SAVE BODY: ${response.body}');

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         try {
//           final decoded = jsonDecode(response.body);
//           if (decoded is Map<String, dynamic>) {
//             final status = decoded['status']?.toString();
//             final message = decoded['message']?.toString() ?? '';
//             if (status == '200' || message.toLowerCase().contains('success')) {
//               debugPrint('✅ Profile details saved successfully');
//               return true;
//             }
//           }
//         } catch (_) {}
//       }
//       return false;
//     } catch (e) {
//       debugPrint('SAVE ERROR: $e');
//       return false;
//     }
//   }

//   static Map<String, String> _buildPayload(ProfileEditState state) {
//     final p1 = state.partner1;
//     final p2 = state.partner2;
//     final isCouple = state.linkedPartner != null;

//     final payload = <String, String>{
//       'text': state.aboutMe,
//       'comment': state.lookingFor,
//       'person1_name': '',
//       'person1_dob': p1['dateOfBirth'] ?? '',
//       'person1_height': p1['height'] ?? '',
//       'height1_type': p1['heightType'] ?? '',
//       'person1_weight': p1['weight'] ?? '',
//       'weight1_type': p1['weightType'] ?? '',
//       'person1_body_type': p1['bodyType'] ?? '',
//       'person1_ethnic_background': p1['ethnic'] ?? '',
//       'person1_sexuality': p1['sexuality'] ?? '',
//       'person1_relationship_orientation': p1['orientation'] ?? '',
//       'person1_tattoos': p1['tattoos'] ?? '',
//       'person1_piercings': p1['piercings'] ?? '',
//       'person1_smoking': p1['smoking'] ?? '',
//       'person1_drinking': p1['drinking'] ?? '',
//       'person1_body_hair': jsonEncode([p1['bodyHair'] ?? '']),
//       'person1_looks_important': p1['looks'] ?? '',
//       'person1_intelligence_importance': p1['intelligence'] ?? '',
//       'person1_circumcised': p1['circumcised'] ?? '',
//       'person1_language_spoken': jsonEncode(state.partner1Languages),
//     };

//     if (isCouple) {
//       payload.addAll({
//         'person2_name': '',
//         'person2_dob': p2['dateOfBirth'] ?? '',
//         'person2_height': p2['height'] ?? '',
//         'height2_type': p2['heightType'] ?? '',
//         'person2_weight': p2['weight'] ?? '',
//         'weight2_type': p2['weightType'] ?? '',
//         'person2_body_type': p2['bodyType'] ?? '',
//         'person2_ethnic_background': p2['ethnic'] ?? '',
//         'person2_sexuality': p2['sexuality'] ?? '',
//         'person2_relationship_orientation': p2['orientation'] ?? '',
//         'person2_tattoos': p2['tattoos'] ?? '',
//         'person2_piercings': p2['piercings'] ?? '',
//         'person2_smoking': p2['smoking'] ?? '',
//         'person2_drinking': p2['drinking'] ?? '',
//         'person2_body_hair': jsonEncode([p2['bodyHair'] ?? '']),
//         'person2_looks_important': p2['looks'] ?? '',
//         'person2_intelligence_importance': p2['intelligence'] ?? '',
//         'person2_circumcised': p2['circumcised'] ?? '',
//         'person2_language_spoken': jsonEncode(state.partner2Languages),
//       });
//     }

//     return payload;
//   }
// }

// // ----------------------------------------------------------------------------
// // INTERESTS SAVER
// // ----------------------------------------------------------------------------
// class ProfileInterestsSaver {
//   static const String singleUrl =
//       'https://app.beatflirtevent.com/App/user/edit_single_profile_interest';
//   static const String coupleUrl =
//       'https://app.beatflirtevent.com/App/user/edit_single_profile_interest'; // same URL for couple as per spec

//   static Future<bool> save({
//     required String token,
//     required ProfileEditState state,
//   }) async {
//     final isCouple = state.linkedPartner != null;
//     final url = isCouple ? coupleUrl : singleUrl;

//     final payload = _buildInterestsPayload(state);

//     debugPrint('========== SAVING INTERESTS ==========');
//     debugPrint('URL: $url');
//     debugPrint('IS COUPLE: $isCouple');

//     final headers = ApiService.buildAuthHeaders(token: token);
//     headers['Content-Type'] = 'application/x-www-form-urlencoded';
//     headers['Accept'] = 'application/json';

//     final body = {...payload, 'token': token, 'Authtoken': token};

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );

//       debugPrint('INTERESTS SAVE STATUS: ${response.statusCode}');
//       debugPrint('INTERESTS SAVE BODY: ${response.body}');

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         try {
//           final decoded = jsonDecode(response.body);
//           if (decoded is Map<String, dynamic>) {
//             final status = decoded['status']?.toString();
//             final message = decoded['message']?.toString() ?? '';
//             if (status == '200' || message.toLowerCase().contains('success')) {
//               debugPrint('✅ Interests saved successfully');
//               return true;
//             }
//           }
//         } catch (_) {}
//       }
//       return false;
//     } catch (e) {
//       debugPrint('INTERESTS SAVE ERROR: $e');
//       return false;
//     }
//   }

//   static Map<String, String> _buildInterestsPayload(ProfileEditState state) {
//     final s = state.swingersOptions;
//     final h = state.hookupOptions;

//     return {
//       'couple_male_female_swingers': (s['Couple Female/Male'] ?? false)
//           ? '1'
//           : '0',
//       'couple_male_female_hookup_meetup': (h['Couple Female/Male'] ?? false)
//           ? '1'
//           : '0',
//       'couple_female_female_swingers': (s['Couple Female/Female'] ?? false)
//           ? '1'
//           : '0',
//       'couple_female_female_hookup_meetup': (h['Couple Female/Female'] ?? false)
//           ? '1'
//           : '0',
//       'couple_male_male_swingers': (s['Couple Male/Male'] ?? false) ? '1' : '0',
//       'couple_male_male_hookup_meetup': (h['Couple Male/Male'] ?? false)
//           ? '1'
//           : '0',
//       'couple_female_swingers': (s['Female'] ?? false) ? '1' : '0',
//       'couple_female_hookup_meetup': (h['Female'] ?? false) ? '1' : '0',
//       'couple_male_swingers': (s['Male'] ?? false) ? '1' : '0',
//       'couple_male_hookup_meetup': (h['Male'] ?? false) ? '1' : '0',
//       'couple_transgender_swingers': (s['Transgender'] ?? false) ? '1' : '0',
//       'couple_transgender_hookup_meetup': (h['Transgender'] ?? false)
//           ? '1'
//           : '0',
//     };
//   }
// }

// // ==================== DEFAULT DATA ====================

// Map<String, String> defaultPartnerTraits() {
//   return {
//     'dateOfBirth': '',
//     'height': '',
//     'heightType': '',
//     'weight': '',
//     'weightType': '',
//     'bodyType': ProfileOptions.notComfortableValue,
//     'ethnic': ProfileOptions.notComfortableValue,
//     'sexuality': ProfileOptions.notComfortableValue,
//     'orientation': ProfileOptions.notComfortableValue,
//     'tattoos': ProfileOptions.notComfortableValue,
//     'piercings': ProfileOptions.notComfortableValue,
//     'smoking': ProfileOptions.notComfortableValue,
//     'drinking': ProfileOptions.notComfortableValue,
//     'bodyHair': ProfileOptions.notComfortableValue,
//     'looks': ProfileOptions.notComfortableValue,
//     'intelligence': ProfileOptions.notComfortableValue,
//     'circumcised': ProfileOptions.notComfortableValue,
//   };
// }

// // ==================== NOTIFIER (CLEAN & PERMANENT) ====================

// class ProfileEditNotifier extends Notifier<ProfileEditState> {
//   @override
//   ProfileEditState build() {
//     Future.microtask(() => loadProfile());
//     return ProfileEditState(
//       swingersOptions: {
//         'Couple Female/Male': true,
//         'Couple Female/Female': true,
//         'Couple Male/Male': true,
//         'Female': true,
//         'Male': true,
//         'Transgender': true,
//       },
//       hookupOptions: {
//         'Couple Female/Male': true,
//         'Couple Female/Female': true,
//         'Couple Male/Male': true,
//         'Female': true,
//         'Male': true,
//         'Transgender': false,
//       },
//       partner1: defaultPartnerTraits(),
//       partner2: defaultPartnerTraits(),
//       partner1Languages: [],
//       partner2Languages: [],
//     );
//   }

//   Future<void> loadProfile() async {
//     debugPrint('========== LOAD PROFILE ==========');
//     state = state.copyWith(isLoading: true);

//     try {
//       final String? token = await AuthService.getToken();

//       if (token == null || token.isEmpty) {
//         debugPrint('❌ No token from AuthService.getToken()');
//         state = state.copyWith(isLoading: false);
//         return;
//       }

//       // Optional: uncomment for discovery
//       // await AuthService.probeAuth();

//       final data = await getProfile(token: token);
//       debugPrint('RAW PROFILE DATA KEYS: ${data.keys.toList()}');

//       // Flexible user extraction
//       final user =
//           data['user'] ??
//           data['data']?['user'] ??
//           data['profile'] ??
//           data['data'] ??
//           data;

//       if (user is Map) {
//         final userMap = Map<String, dynamic>.from(user);

//         final mergedTraits = defaultPartnerTraits();
//         final backendTraits = Map<String, dynamic>.from(
//           userMap['partner1Traits'] ?? {},
//         );

//         backendTraits.forEach((key, value) {
//           if (mergedTraits.containsKey(key)) {
//             mergedTraits[key] = value.toString();
//           }
//         });

//         final linked = userMap['partnerId'];
//         Map<String, String> p2Traits = defaultPartnerTraits();
//         List<String> p2Langs = [];
//         Map<String, dynamic>? linkedMap;

//         if (linked is Map) {
//           linkedMap = Map<String, dynamic>.from(linked);
//           final lpTraits = Map<String, dynamic>.from(
//             linkedMap['partner1Traits'] ?? {},
//           );
//           lpTraits.forEach((key, value) {
//             if (p2Traits.containsKey(key)) p2Traits[key] = value.toString();
//           });
//           p2Langs = List<String>.from(linkedMap['partner1Languages'] ?? []);
//         }

//         final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
//         final backendSwingers = Map<String, dynamic>.from(
//           userMap['swingersOptions'] ?? {},
//         );
//         backendSwingers.forEach((key, value) {
//           if (mergedSwingers.containsKey(key))
//             mergedSwingers[key] = value == true;
//         });

//         final mergedHookup = Map<String, bool>.from(state.hookupOptions);
//         final backendHookup = Map<String, dynamic>.from(
//           userMap['hookupOptions'] ?? {},
//         );
//         backendHookup.forEach((key, value) {
//           if (mergedHookup.containsKey(key)) mergedHookup[key] = value == true;
//         });

//         state = state.copyWith(
//           aboutMe: userMap['aboutMe']?.toString() ?? '',
//           lookingFor: userMap['lookingFor']?.toString() ?? '',
//           partner1: mergedTraits,
//           partner1Languages: List<String>.from(
//             userMap['partner1Languages'] ?? [],
//           ),
//           swingersOptions: mergedSwingers,
//           hookupOptions: mergedHookup,
//           partner2: p2Traits,
//           partner2Languages: p2Langs,
//           linkedPartner: linkedMap,
//         );

//         debugPrint('✅ Profile loaded successfully');
//       } else {
//         debugPrint('⚠️ No usable user data found in response: $data');
//       }
//     } catch (e, stack) {
//       debugPrint('❌ Error loading profile: $e');
//       debugPrint(stack.toString());
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }

//   Future<void> saveProfile() async {
//     final String? token = await AuthService.getToken();

//     if (token == null || token.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'User token not found',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     state = state.copyWith(isLoading: true);

//     try {
//       if (state.isProfileDetailsTab) {
//         final success = await ProfileDetailsSaver.save(
//           token: token,
//           state: state,
//         );

//         if (success) {
//           Get.snackbar(
//             'Success',
//             'Profile updated successfully',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//           // Refresh the home tab (view profile) with the latest data from server
//           try {
//             ref.read(viewSingleProfileProvider.notifier).fetchProfile();
//           } catch (_) {}
//         } else {
//           Get.snackbar(
//             'Error',
//             'Failed to update profile. Check console.',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//         }
//       } else {
//         // INTERESTS TAB
//         final success = await ProfileInterestsSaver.save(
//           token: token,
//           state: state,
//         );

//         if (success) {
//           Get.snackbar(
//             'Success',
//             'Interests saved successfully',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//           // Refresh the home tab (view profile) with the latest data
//           try {
//             ref.read(viewSingleProfileProvider.notifier).fetchProfile();
//           } catch (_) {}
//         } else {
//           Get.snackbar(
//             'Error',
//             'Failed to save interests. Check console.',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('Error saving: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to save: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }

//   // All the update methods below are unchanged (they were fine)
//   void toggleProfileTab(bool isProfile) {
//     state = state.copyWith(isProfileDetailsTab: isProfile);
//   }

//   void toggleSwingersExpanded() {
//     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
//   }

//   void toggleHookupExpanded() {
//     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
//   }

//   void updateSwingersOption(String label, bool value) {
//     final newOptions = Map<String, bool>.from(state.swingersOptions);
//     newOptions[label] = value;
//     state = state.copyWith(swingersOptions: newOptions);
//   }

//   void updateHookupOption(String label, bool value) {
//     final newOptions = Map<String, bool>.from(state.hookupOptions);
//     newOptions[label] = value;
//     state = state.copyWith(hookupOptions: newOptions);
//   }

//   void updateAboutMe(String value) {
//     state = state.copyWith(aboutMe: value);
//   }

//   void updateLookingFor(String value) {
//     state = state.copyWith(lookingFor: value);
//   }

//   void updatePartner1(String key, String value) {
//     final newPartner = Map<String, String>.from(state.partner1);
//     newPartner[key] = value;
//     state = state.copyWith(partner1: newPartner);
//   }

//   void updatePartner2(String key, String value) {
//     final newPartner = Map<String, String>.from(state.partner2);
//     newPartner[key] = value;
//     state = state.copyWith(partner2: newPartner);
//   }

//   void updatePartner1Languages(List<String> langs) {
//     state = state.copyWith(partner1Languages: langs);
//   }

//   void updatePartner2Languages(List<String> langs) {
//     state = state.copyWith(partner2Languages: langs);
//   }
// }

// final profileEditProvider =
//     NotifierProvider<ProfileEditNotifier, ProfileEditState>(
//       ProfileEditNotifier.new,
//     );

// // ==================== WIDGET + ALL UI CODE (cleaned of artifacts) ====================

// class MyProfileEditTab extends ConsumerWidget {
//   const MyProfileEditTab({super.key});

//   static const List<String> languageOptions = [
//     'English',
//     'Hindi',
//     'German',
//     'French',
//     'Spanish',
//     'Italian',
//     'Portuguese',
//     'Chinese (Mandarin)',
//     'Japanese',
//     'Korean',
//     'Russian',
//     'Arabic',
//     'Bengali',
//     'Urdu',
//     'Turkish',
//     'Dutch',
//     'Swedish',
//     'Polish',
//     'Greek',
//     'Hebrew',
//     'Thai',
//     'Vietnamese',
//     'Indonesian',
//     'Malay',
//     'Filipino',
//   ];

//   void saveInterests() {
//     Get.snackbar(
//       'Success',
//       'Interests saved successfully',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.transparent,
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(12),
//       borderRadius: 10,
//       duration: const Duration(seconds: 2),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profileState = ref.watch(profileEditProvider);
//     final notifier = ref.read(profileEditProvider.notifier);

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final double width = constraints.maxWidth;
//         final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
//         final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;

//         return Container(
//           width: double.infinity,
//           constraints: BoxConstraints(
//             minHeight: MediaQuery.of(context).size.height * 0.62,
//           ),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: const Color(0xFFE8E0F2)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (profileState.isLoading)
//                 const Padding(
//                   padding: EdgeInsets.only(bottom: 10),
//                   child: LinearProgressIndicator(color: Colors.pink),
//                 ),
//               sectionHeader(profileState, notifier),
//               const SizedBox(height: 16),
//               if (profileState.isProfileDetailsTab)
//                 buildProfileDetailsContent(
//                   context,
//                   width,
//                   profileState,
//                   notifier,
//                 )
//               else
//                 buildInterestsContent(optionWidth, profileState, notifier),
//               const SizedBox(height: 18),
//               Center(
//                 child: SizedBox(
//                   width: 170,
//                   child: ElevatedButton(
//                     onPressed: profileState.isLoading
//                         ? null
//                         : () => notifier.saveProfile(),
//                     style: ElevatedButton.styleFrom(
//                       elevation: 4,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       backgroundColor: const Color(0xFF220027),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(22),
//                       ),
//                     ),
//                     child: profileState.isLoading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : Text(
//                             profileState.isProfileDetailsTab
//                                 ? 'Save Profile'
//                                 : 'Save Interest',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 6),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ==================== ALL THE UI HELPER METHODS (kept from original, cleaned) ====================

//   Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
//     return Container(
//       height: 38,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF19001F), Color(0xFF490040)],
//         ),
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Row(
//         children: [
//           InkWell(
//             borderRadius: BorderRadius.circular(16),
//             onTap: () => notifier.toggleProfileTab(false),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//               decoration: BoxDecoration(
//                 color: !state.isProfileDetailsTab
//                     ? const Color(0xFFFF2D87)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Text(
//                 'INTERESTS',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//           const Spacer(),
//           InkWell(
//             borderRadius: BorderRadius.circular(16),
//             onTap: () => notifier.toggleProfileTab(true),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//               decoration: BoxDecoration(
//                 color: state.isProfileDetailsTab
//                     ? const Color(0xFFFF2D87)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Text(
//                 'PROFILE DETAILS',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildInterestsContent(
//     double optionWidth,
//     ProfileEditState state,
//     ProfileEditNotifier notifier,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'davidbrown',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 34,
//             height: 1.05,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'What are you looking for? Select all that apply',
//           style: TextStyle(
//             color: Colors.grey[700],
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 16),
//         interestGroup(
//           title: 'Swingers',
//           expanded: state.isSwingersExpanded,
//           onToggle: notifier.toggleSwingersExpanded,
//           options: state.swingersOptions,
//           optionWidth: optionWidth,
//           onChanged: (label, value) =>
//               notifier.updateSwingersOption(label, value),
//         ),
//         const SizedBox(height: 12),
//         interestGroup(
//           title: 'Hookup / Meetup',
//           expanded: state.isHookupExpanded,
//           onToggle: notifier.toggleHookupExpanded,
//           options: state.hookupOptions,
//           optionWidth: optionWidth,
//           onChanged: (label, value) =>
//               notifier.updateHookupOption(label, value),
//         ),
//       ],
//     );
//   }

//   Widget buildProfileDetailsContent(
//     BuildContext context,
//     double width,
//     ProfileEditState state,
//     ProfileEditNotifier notifier,
//   ) {
//     final bool stacked = width < 760;
//     final bool isCouple = state.linkedPartner != null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         textFieldLabel('INTRODUCE YOURSELF'),
//         const SizedBox(height: 6),
//         simpleTextField(
//           label: 'About Me',
//           initialValue: state.aboutMe,
//           onChanged: notifier.updateAboutMe,
//         ),
//         const SizedBox(height: 10),
//         textFieldLabel('LOOKING FOR'),
//         const SizedBox(height: 6),
//         simpleTextField(
//           label: 'Looking For',
//           initialValue: state.lookingFor,
//           maxLines: 2,
//           onChanged: notifier.updateLookingFor,
//         ),
//         const SizedBox(height: 14),
//         const Center(
//           child: Text(
//             'About Yourselves',
//             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
//           ),
//         ),
//         const SizedBox(height: 12),
//         if (isCouple)
//           if (stacked)
//             Column(
//               children: [
//                 partnerPanel(
//                   context: context,
//                   title: 'Partner 1',
//                   data: state.partner1,
//                   languages: state.partner1Languages,
//                   onFieldChanged: notifier.updatePartner1,
//                   onLanguagesChanged: notifier.updatePartner1Languages,
//                   readOnly: false,
//                 ),
//                 const SizedBox(height: 12),
//                 partnerPanel(
//                   context: context,
//                   title: 'Partner 2',
//                   data: state.partner2,
//                   languages: state.partner2Languages,
//                   onFieldChanged: notifier.updatePartner2,
//                   onLanguagesChanged: notifier.updatePartner2Languages,
//                   readOnly: false,
//                 ),
//               ],
//             )
//           else
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: partnerPanel(
//                     context: context,
//                     title: 'Partner 1',
//                     data: state.partner1,
//                     languages: state.partner1Languages,
//                     onFieldChanged: notifier.updatePartner1,
//                     onLanguagesChanged: notifier.updatePartner1Languages,
//                     readOnly: false,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: partnerPanel(
//                     context: context,
//                     title: 'Partner 2',
//                     data: state.partner2,
//                     languages: state.partner2Languages,
//                     onFieldChanged: notifier.updatePartner2,
//                     onLanguagesChanged: notifier.updatePartner2Languages,
//                     readOnly: false,
//                   ),
//                 ),
//               ],
//             )
//         else
//           partnerPanel(
//             context: context,
//             title: 'Partner 1',
//             data: state.partner1,
//             languages: state.partner1Languages,
//             onFieldChanged: notifier.updatePartner1,
//             onLanguagesChanged: notifier.updatePartner1Languages,
//             readOnly: false,
//           ),
//       ],
//     );
//   }

//   // ... (I am keeping the rest of the UI methods exactly as in your original code but cleaned of * artifacts)

//   Widget partnerPanel({
//     required BuildContext context,
//     required String title,
//     required Map<String, String> data,
//     required List<String> languages,
//     required void Function(String, String) onFieldChanged,
//     required void Function(List<String>) onLanguagesChanged,
//     bool readOnly = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 34,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF19001F), Color(0xFF490040)],
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         dateOfBirthField(
//           context: context,
//           label: 'DATE OF BIRTH',
//           data: data,
//           keyName: 'dateOfBirth',
//           onFieldChanged: onFieldChanged,
//           readOnly: readOnly,
//         ),
//         heightInputField(
//           data: data,
//           onFieldChanged: onFieldChanged,
//           readOnly: readOnly,
//         ),
//         weightInputField(
//           data: data,
//           onFieldChanged: onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'BODY TYPE',
//           data,
//           'bodyType',
//           ProfileOptions.bodyTypes,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'ETHNIC BACKGROUND',
//           data,
//           'ethnic',
//           ProfileOptions.ethnicBackgrounds,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'SEXUALITY',
//           data,
//           'sexuality',
//           ProfileOptions.sexualities,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'RELATIONSHIP ORIENTATION',
//           data,
//           'orientation',
//           ProfileOptions.relationshipOrientations,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'TATTOOS',
//           data,
//           'tattoos',
//           ProfileOptions.tattoos,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'PIERCINGS',
//           data,
//           'piercings',
//           ProfileOptions.piercings,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'SMOKING',
//           data,
//           'smoking',
//           ProfileOptions.smoking,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'DRINKING',
//           data,
//           'drinking',
//           ProfileOptions.drinking,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'BODY HAIR',
//           data,
//           'bodyHair',
//           ProfileOptions.bodyHair,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         languagesField(
//           context,
//           'LANGUAGES SPOKEN',
//           languages,
//           onLanguagesChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'LOOKS IMPORTANCE',
//           data,
//           'looks',
//           ProfileOptions.importanceLevels,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'INTELLIGENCE IMPORTANCE',
//           data,
//           'intelligence',
//           ProfileOptions.importanceLevels,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//         profileOptionDropdownField(
//           'CIRCUMCISED',
//           data,
//           'circumcised',
//           ProfileOptions.circumcised,
//           onFieldChanged,
//           readOnly: readOnly,
//         ),
//       ],
//     );
//   }

//   // All the remaining helper widgets (dateOfBirthField, heightInputField, etc.) are included below exactly as you had them, just without the * characters.

//   // For brevity in this response, the remaining ~200 lines of UI widgets (dateOfBirthField, heightInputField, weightInputField, unitRadioButton, profileInputDecoration, parseProfileDate, formatProfileDate, findProfileOption, normalize, defaultProfileOptionValue, profileOptionDropdownField, dropdownField, simpleTextField, textFieldLabel, languagesField, openLanguageSelector, interestGroup, OptionChip) are copied from your original code with only the * artifacts removed.

//   // You can copy the full cleaned file from the workspace or I can expand it if needed.

//   // To make this complete, I'll include the key remaining methods here.

//   Widget dateOfBirthField({
//     required BuildContext context,
//     required String label,
//     required Map<String, String> data,
//     required String keyName,
//     required void Function(String, String) onFieldChanged,
//     bool readOnly = false,
//   }) {
//     final currentValue = data[keyName] ?? '';
//     final displayValue = currentValue.trim().isEmpty
//         ? 'dd/mm/yyyy'
//         : currentValue;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           textFieldLabel(label),
//           const SizedBox(height: 4),
//           InkWell(
//             onTap: readOnly
//                 ? null
//                 : () async {
//                     final now = DateTime.now();
//                     final parsedDate = parseProfileDate(currentValue);

//                     DateTime initialDate =
//                         parsedDate ??
//                         DateTime(now.year - 18, now.month, now.day);

//                     if (initialDate.isAfter(now)) {
//                       initialDate = now;
//                     }
//                     if (initialDate.isBefore(DateTime(1900))) {
//                       initialDate = DateTime(1900);
//                     }

//                     final pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: initialDate,
//                       firstDate: DateTime(1900),
//                       lastDate: now,
//                     );

//                     if (pickedDate == null) return;
//                     onFieldChanged(keyName, formatProfileDate(pickedDate));
//                   },
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               height: 42,
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: readOnly
//                       ? const Color(0xFFF2F2F2)
//                       : const Color(0xFFE8E0F2),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       displayValue,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: currentValue.trim().isEmpty
//                             ? Colors.grey[600]
//                             : Colors.black87,
//                       ),
//                     ),
//                   ),
//                   const Icon(
//                     Icons.calendar_today_outlined,
//                     size: 17,
//                     color: Colors.black87,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget heightInputField({
//     required Map<String, String> data,
//     required void Function(String, String) onFieldChanged,
//     bool readOnly = false,
//   }) {
//     final selectedType = (data['heightType'] ?? '').trim().isEmpty
//         ? null
//         : data['heightType'];

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           textFieldLabel('HEIGHT'),
//           const SizedBox(height: 2),
//           Row(
//             children: [
//               unitRadioButton(
//                 label: 'FT',
//                 value: 'FT',
//                 groupValue: selectedType,
//                 readOnly: readOnly,
//                 onChanged: (value) => onFieldChanged('heightType', value),
//               ),
//               const SizedBox(width: 18),
//               unitRadioButton(
//                 label: 'CM',
//                 value: 'CM',
//                 groupValue: selectedType,
//                 readOnly: readOnly,
//                 onChanged: (value) => onFieldChanged('heightType', value),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           TextFormField(
//             // Stable key — do not include live value
//             key: ValueKey('height-$readOnly'),
//             initialValue: data['height'] ?? '',
//             readOnly: readOnly,
//             onChanged: readOnly
//                 ? null
//                 : (value) => onFieldChanged('height', value),
//             keyboardType: TextInputType.text,
//             style: const TextStyle(fontSize: 12, color: Colors.black87),
//             decoration: profileInputDecoration(
//               hintText: "Ex. (5'7 OR 170)",
//               readOnly: readOnly,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget weightInputField({
//     required Map<String, String> data,
//     required void Function(String, String) onFieldChanged,
//     bool readOnly = false,
//   }) {
//     final selectedType = (data['weightType'] ?? '').trim().isEmpty
//         ? null
//         : data['weightType'];

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           textFieldLabel('WEIGHT'),
//           const SizedBox(height: 2),
//           Row(
//             children: [
//               unitRadioButton(
//                 label: 'LBS',
//                 value: 'LBS',
//                 groupValue: selectedType,
//                 readOnly: readOnly,
//                 onChanged: (value) => onFieldChanged('weightType', value),
//               ),
//               const SizedBox(width: 18),
//               unitRadioButton(
//                 label: 'KG',
//                 value: 'KG',
//                 groupValue: selectedType,
//                 readOnly: readOnly,
//                 onChanged: (value) => onFieldChanged('weightType', value),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           TextFormField(
//             // Stable key — do not include live value
//             key: ValueKey('weight-$readOnly'),
//             initialValue: data['weight'] ?? '',
//             readOnly: readOnly,
//             onChanged: readOnly
//                 ? null
//                 : (value) => onFieldChanged('weight', value),
//             keyboardType: TextInputType.number,
//             style: const TextStyle(fontSize: 12, color: Colors.black87),
//             decoration: profileInputDecoration(
//               hintText: 'Ex. (150 LBS OR 68 KG)',
//               readOnly: readOnly,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget unitRadioButton({
//     required String label,
//     required String value,
//     required String? groupValue,
//     required void Function(String) onChanged,
//     bool readOnly = false,
//   }) {
//     return InkWell(
//       onTap: readOnly ? null : () => onChanged(value),
//       borderRadius: BorderRadius.circular(8),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Radio<String>(
//             value: value,
//             groupValue: groupValue,
//             onChanged: readOnly
//                 ? null
//                 : (selectedValue) {
//                     if (selectedValue == null) return;
//                     onChanged(selectedValue);
//                   },
//             activeColor: const Color(0xFF5A002B),
//             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             visualDensity: VisualDensity.compact,
//           ),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF5A002B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   InputDecoration profileInputDecoration({
//     required String hintText,
//     bool readOnly = false,
//   }) {
//     return InputDecoration(
//       hintText: hintText,
//       hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
//       isDense: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(
//           color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2),
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFF5A002B)),
//       ),
//       fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
//       filled: true,
//     );
//   }

//   DateTime? parseProfileDate(String? value) {
//     if (value == null || value.trim().isEmpty) return null;
//     final text = value.trim();

//     final dmyMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);
//     if (dmyMatch != null) {
//       final day = int.tryParse(dmyMatch.group(1)!);
//       final month = int.tryParse(dmyMatch.group(2)!);
//       final year = int.tryParse(dmyMatch.group(3)!);
//       if (day != null && month != null && year != null) {
//         return DateTime(year, month, day);
//       }
//     }

//     final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
//     if (isoMatch != null) {
//       final year = int.tryParse(isoMatch.group(1)!);
//       final month = int.tryParse(isoMatch.group(2)!);
//       final day = int.tryParse(isoMatch.group(3)!);
//       if (day != null && month != null && year != null) {
//         return DateTime(year, month, day);
//       }
//     }
//     return DateTime.tryParse(text);
//   }

//   String formatProfileDate(DateTime date) {
//     final day = date.day.toString().padLeft(2, '0');
//     final month = date.month.toString().padLeft(2, '0');
//     final year = date.year.toString();
//     return '$day/$month/$year';
//   }

//   ProfileOption? findProfileOption(
//     String? currentValue,
//     List<ProfileOption> options,
//   ) {
//     if (currentValue == null || currentValue.trim().isEmpty) return null;
//     final normalizedCurrent = normalize(currentValue);

//     for (final option in options) {
//       if (normalize(option.id) == normalizedCurrent ||
//           normalize(option.value) == normalizedCurrent ||
//           normalize(option.label) == normalizedCurrent) {
//         return option;
//       }
//     }

//     if (normalizedCurrent == normalize('Bisexual')) {
//       return firstProfileOptionWhere(options, (e) => e.value == 'Bi-sexual');
//     }
//     if (normalizedCurrent == normalize('Occasionally')) {
//       return firstProfileOptionWhere(options, (e) => e.value == 'Occasionally');
//     }
//     if (normalizedCurrent == normalize('Low')) {
//       return firstProfileOptionWhere(
//         options,
//         (e) => e.value == 'Low Importance',
//       );
//     }
//     if (normalizedCurrent == normalize('Medium')) {
//       return firstProfileOptionWhere(
//         options,
//         (e) => e.value == 'Medium Importance',
//       );
//     }
//     if (normalizedCurrent == normalize('High')) {
//       return firstProfileOptionWhere(
//         options,
//         (e) => e.value == 'Very Important',
//       );
//     }
//     return null;
//   }

//   ProfileOption? firstProfileOptionWhere(
//     List<ProfileOption> options,
//     bool Function(ProfileOption) test,
//   ) {
//     for (final option in options) {
//       if (test(option)) return option;
//     }
//     return null;
//   }

//   String normalize(String value) {
//     return value
//         .trim()
//         .toLowerCase()
//         .replaceAll('.', '')
//         .replaceAll('-', '')
//         .replaceAll('_', '')
//         .replaceAll(' ', '');
//   }

//   String? defaultProfileOptionValue(List<ProfileOption> options) {
//     if (options.isEmpty) return null;
//     for (final option in options) {
//       if (option.id == 'not_comfortable') return option.value;
//     }
//     return options.first.value;
//   }

//   Widget profileOptionDropdownField(
//     String label,
//     Map<String, String> data,
//     String key,
//     List<ProfileOption> options,
//     void Function(String, String) onFieldChanged, {
//     bool readOnly = false,
//   }) {
//     final currentValue = data[key];
//     final selectedOption = findProfileOption(currentValue, options);
//     final validValue =
//         selectedOption?.value ?? defaultProfileOptionValue(options);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           textFieldLabel(label),
//           const SizedBox(height: 4),
//           DropdownButtonFormField<String>(
//             key: ValueKey(
//               '$label-$key-$readOnly',
//             ), // stabilized key (removed live value)
//             initialValue: validValue,
//             isExpanded: true,
//             iconSize: 18,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.black87,
//               overflow: TextOverflow.ellipsis,
//             ),
//             items: options.map((option) {
//               return DropdownMenuItem<String>(
//                 value: option.value,
//                 child: Text(
//                   option.label,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               );
//             }).toList(),
//             selectedItemBuilder: (context) {
//               return options.map((option) {
//                 return Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     option.label,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 );
//               }).toList();
//             },
//             onChanged: readOnly
//                 ? null
//                 : (value) {
//                     if (value == null) return;
//                     onFieldChanged(key, value);
//                   },
//             decoration: InputDecoration(
//               isDense: true,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 10,
//                 vertical: 8,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(
//                   color: readOnly
//                       ? const Color(0xFFF2F2F2)
//                       : const Color(0xFFE8E0F2),
//                 ),
//               ),
//               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
//               filled: readOnly,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget simpleTextField({
//     required String label,
//     required String initialValue,
//     required void Function(String) onChanged,
//     int maxLines = 1,
//     bool readOnly = false,
//   }) {
//     return TextFormField(
//       // Stable key — do NOT include the live value here.
//       // Including $initialValue caused the TextFormField to be treated as a
//       // completely new widget on every keystroke → focus lost + keyboard dismiss.
//       key: ValueKey('$label-$readOnly'),
//       initialValue: initialValue,
//       maxLines: maxLines,
//       onChanged: onChanged,
//       readOnly: readOnly,
//       style: const TextStyle(fontSize: 12),
//       decoration: InputDecoration(
//         hintText: label,
//         isDense: true,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 10,
//           vertical: 10,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//         ),
//       ),
//     );
//   }

//   Widget textFieldLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 11,
//         fontWeight: FontWeight.w800,
//         letterSpacing: 0.2,
//       ),
//     );
//   }

//   Widget languagesField(
//     BuildContext context,
//     String label,
//     List<String> selectedValues,
//     void Function(List<String>) onSaved, {
//     bool readOnly = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           textFieldLabel(label),
//           const SizedBox(height: 4),
//           InkWell(
//             onTap: readOnly
//                 ? null
//                 : () => openLanguageSelector(context, selectedValues, onSaved),
//             borderRadius: BorderRadius.circular(8),
//             child: InputDecorator(
//               decoration: InputDecoration(
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 8,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(
//                     color: readOnly
//                         ? const Color(0xFFF2F2F2)
//                         : const Color(0xFFE8E0F2),
//                   ),
//                 ),
//                 fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
//                 filled: true,
//                 suffixIcon: const Icon(
//                   Icons.keyboard_arrow_down_rounded,
//                   size: 20,
//                   color: Colors.black87,
//                 ),
//               ),
//               child: selectedValues.isEmpty
//                   ? Text(
//                       ProfileOptions.notComfortableLabel,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                     )
//                   : Wrap(
//                       spacing: 6,
//                       runSpacing: 6,
//                       children: selectedValues
//                           .map(
//                             (lang) => Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 3,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFF0F4FF),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: const Color(0xFFD4DDF2),
//                                 ),
//                               ),
//                               child: Text(
//                                 lang,
//                                 style: const TextStyle(fontSize: 11),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> openLanguageSelector(
//     BuildContext context,
//     List<String> selectedValues,
//     void Function(List<String>) onSaved,
//   ) async {
//     final temp = [...selectedValues];

//     await showModalBottomSheet<void>(
//       context: context,
//       builder: (context) {
//         return SingleChildScrollView(
//           child: StatefulBuilder(
//             builder: (context, setModalState) {
//               return SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Select Languages',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       ...languageOptions.map(
//                         (lang) => CheckboxListTile(
//                           dense: true,
//                           value: temp.contains(lang),
//                           onChanged: (checked) {
//                             setModalState(() {
//                               if (checked == true) {
//                                 if (!temp.contains(lang)) temp.add(lang);
//                               } else {
//                                 temp.remove(lang);
//                               }
//                             });
//                           },
//                           title: Text(lang),
//                           controlAffinity: ListTileControlAffinity.leading,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             onSaved(temp);
//                             Navigator.pop(context);
//                           },
//                           child: const Text('Done'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget interestGroup({
//     required String title,
//     required bool expanded,
//     required VoidCallback onToggle,
//     required Map<String, bool> options,
//     required double optionWidth,
//     required void Function(String label, bool value) onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: const Color(0xFFECE4F4)),
//       ),
//       child: Column(
//         children: [
//           InkWell(
//             onTap: onToggle,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//             child: Container(
//               height: 40,
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF19001F), Color(0xFF490040)],
//                 ),
//                 borderRadius: BorderRadius.vertical(
//                   top: const Radius.circular(10),
//                   bottom: expanded ? Radius.zero : const Radius.circular(10),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.w800,
//                         height: 1.0,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   CircleAvatar(
//                     radius: 12,
//                     backgroundColor: const Color(0xFFEACD71),
//                     child: Icon(
//                       expanded
//                           ? Icons.keyboard_arrow_up
//                           : Icons.keyboard_arrow_down,
//                       size: 16,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (expanded)
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: options.entries
//                     .map(
//                       (entry) => OptionChip(
//                         label: entry.key,
//                         selected: entry.value,
//                         width: optionWidth,
//                         onTap: () => onChanged(entry.key, !entry.value),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // ==================== OPTION CHIP (clean) ====================

// class OptionChip extends StatelessWidget {
//   const OptionChip({
//     super.key,
//     required this.label,
//     required this.selected,
//     required this.width,
//     required this.onTap,
//   });

//   final String label;
//   final bool selected;
//   final double width;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: width,
//         height: 42,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xFFF1EBF8)),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 label,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Checkbox(
//               value: selected,
//               onChanged: (_) => onTap(),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               activeColor: const Color(0xFF47003D),
//               side: const BorderSide(color: Color(0xFFE0D4EE)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // import 'package:beatflirt/core/services/auth_services.dart'; // adjust path if needed
// // import 'package:beatflirt/Api_services/api_service.dart';


// // // ==================== DATA MODELS ====================

// // class ProfileOption {
// //   final String id;
// //   final String value;
// //   final String label;

// //   const ProfileOption({
// //     required this.id,
// //     required this.value,
// //     required this.label,
// //   });

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'value': value,
// //       'label': label,
// //     };
// //   }
// // }

// // class ProfileOptions {
// //   static const String notComfortableValue = 'Im not comfortable sharing that';
// //   static const String notComfortableLabel = "I'm not comfortable sharing that.";

// //   static const ProfileOption notComfortable = ProfileOption(
// //     id: 'not_comfortable',
// //     value: notComfortableValue,
// //     label: notComfortableLabel,
// //   );

// //   static const List<ProfileOption> tattoos = [
// //     notComfortable,
// //     ProfileOption(id: 'none', value: 'None', label: 'None'),
// //     ProfileOption(id: 'one', value: 'One', label: 'One'),
// //     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
// //     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
// //     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
// //   ];

// //   static const List<ProfileOption> heightTypes = [
// //     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
// //     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
// //   ];

// //   static const List<ProfileOption> weightTypes = [
// //     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
// //     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
// //   ];

// //   static const List<ProfileOption> bodyTypes = [
// //     notComfortable,
// //     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
// //     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
// //     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
// //     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
// //     ProfileOption(
// //       id: 'huggable_and_heavy',
// //       value: 'Huggable and Heavy',
// //       label: 'Huggable and Heavy',
// //     ),
// //     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
// //     ProfileOption(
// //       id: 'more_of_me_to_love',
// //       value: 'More of me to love',
// //       label: 'More of me to love',
// //     ),
// //     ProfileOption(
// //       id: 'nicely_shaped',
// //       value: 'Nicely Shaped',
// //       label: 'Nicely Shaped',
// //     ),
// //     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
// //   ];

// //   static const List<ProfileOption> smoking = [
// //     notComfortable,
// //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// //     ProfileOption(
// //       id: 'occasionally',
// //       value: 'Occasionally',
// //       label: 'Occasionally',
// //     ),
// //   ];

// //   static const List<ProfileOption> drinking = [
// //     notComfortable,
// //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// //     ProfileOption(
// //       id: 'occasionally',
// //       value: 'Occasionally',
// //       label: 'Occasionally',
// //     ),
// //   ];

// //   static const List<ProfileOption> ethnicBackgrounds = [
// //     notComfortable,
// //     ProfileOption(id: 'other', value: 'Other', label: 'Other'),
// //     ProfileOption(id: 'american', value: 'American', label: 'American'),
// //     ProfileOption(id: 'argentine_argentinian', value: 'Argentine/Argentinian', label: 'Argentine/Argentinian'),
// //     ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
// //     ProfileOption(id: 'black_african_american', value: 'Black/African - American', label: 'Black/African - American'),
// //     ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
// //     ProfileOption(id: 'british', value: 'British', label: 'British'),
// //     ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
// //     ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
// //     ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
// //     ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
// //     ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
// //     ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
// //     ProfileOption(id: 'french', value: 'French', label: 'French'),
// //     ProfileOption(id: 'german', value: 'German', label: 'German'),
// //     ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
// //     ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
// //     ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
// //     ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
// //     ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
// //     ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
// //     ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
// //     ProfileOption(id: 'new_zealander_kiwi', value: 'New Zealander/Kiwi', label: 'New Zealander/Kiwi'),
// //     ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
// //     ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
// //     ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
// //     ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
// //     ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
// //     ProfileOption(id: 'south_african', value: 'South African', label: 'South African'),
// //     ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
// //     ProfileOption(id: 'sri_lankan', value: 'Sri Lankan', label: 'Sri Lankan'),
// //     ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
// //     ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
// //   ];

// //   static const List<ProfileOption> importanceLevels = [
// //     notComfortable,
// //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// //     ProfileOption(id: 'low_importance', value: 'Low Importance', label: 'Low Importance'),
// //     ProfileOption(id: 'medium_importance', value: 'Medium Importance', label: 'Medium Importance'),
// //     ProfileOption(id: 'very_important', value: 'Very Important', label: 'Very Important'),
// //   ];

// //   static const List<ProfileOption> sexualities = [
// //     notComfortable,
// //     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
// //     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
// //     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
// //     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
// //     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
// //     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
// //     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
// //     ProfileOption(id: 'transsexual', value: 'Transsexual', label: 'Transsexual'),
// //   ];

// //   static const List<ProfileOption> relationshipOrientations = [
// //     notComfortable,
// //     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
// //     ProfileOption(id: 'open_minded', value: 'Open-Minded', label: 'Open-Minded'),
// //     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
// //     ProfileOption(id: 'polyamorous', value: 'Polyamorous', label: 'Polyamorous'),
// //   ];

// //   static const List<ProfileOption> circumcised = [
// //     notComfortable,
// //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// //   ];

// //   static const List<ProfileOption> piercings = [
// //     notComfortable,
// //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// //   ];

// //   static const List<ProfileOption> bodyHair = [
// //     notComfortable,
// //     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
// //     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
// //     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
// //     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
// //   ];

// //   static const Map<String, List<ProfileOption>> groups = {
// //     'tattoos': tattoos,
// //     'height_types': heightTypes,
// //     'weight_types': weightTypes,
// //     'body_types': bodyTypes,
// //     'smoking': smoking,
// //     'drinking': drinking,
// //     'ethnic_backgrounds': ethnicBackgrounds,
// //     'importance_levels': importanceLevels,
// //     'sexualities': sexualities,
// //     'relationship_orientations': relationshipOrientations,
// //     'circumcised': circumcised,
// //     'piercings': piercings,
// //     'body_hair': bodyHair,
// //   };
// // }

// // class ProfileFieldOptions {
// //   static const Map<String, String> fieldGroupMap = {
// //     'bodyType': 'body_types',
// //     'ethnic': 'ethnic_backgrounds',
// //     'sexuality': 'sexualities',
// //     'orientation': 'relationship_orientations',
// //     'tattoos': 'tattoos',
// //     'piercings': 'piercings',
// //     'smoking': 'smoking',
// //     'drinking': 'drinking',
// //     'bodyHair': 'body_hair',
// //     'looks': 'importance_levels',
// //     'intelligence': 'importance_levels',
// //     'circumcised': 'circumcised',
// //     'person1_tattoos': 'tattoos',
// //     'person2_tattoos': 'tattoos',
// //     'person1_height_type': 'height_types',
// //     'person2_height_type': 'height_types',
// //     'person1_weight_type': 'weight_types',
// //     'person2_weight_type': 'weight_types',
// //     'person1_body_type': 'body_types',
// //     'person2_body_type': 'body_types',
// //     'person1_smoking': 'smoking',
// //     'person2_smoking': 'smoking',
// //     'person1_drinking': 'drinking',
// //     'person2_drinking': 'drinking',
// //     'person1_ethnic_background': 'ethnic_backgrounds',
// //     'person2_ethnic_background': 'ethnic_backgrounds',
// //     'person1_looks_important': 'importance_levels',
// //     'person2_looks_important': 'importance_levels',
// //     'person1_intelligence_importance': 'importance_levels',
// //     'person2_intelligence_importance': 'importance_levels',
// //     'person1_sexuality': 'sexualities',
// //     'person2_sexuality': 'sexualities',
// //     'person1_relationship_orientation': 'relationship_orientations',
// //     'person2_relationship_orientation': 'relationship_orientations',
// //     'person1_circumcised': 'circumcised',
// //     'person2_circumcised': 'circumcised',
// //     'person1_piercings': 'piercings',
// //     'person2_piercings': 'piercings',
// //   };

// //   static List<ProfileOption> getOptionsForField(String fieldName) {
// //     final groupKey = fieldGroupMap[fieldName];
// //     if (groupKey == null) return [];
// //     return ProfileOptions.groups[groupKey] ?? [];
// //   }
// // }

// // // ==================== STATE ====================

// // class ProfileEditState {
// //   final bool isProfileDetailsTab;
// //   final Map<String, bool> swingersOptions;
// //   final Map<String, bool> hookupOptions;
// //   final bool isSwingersExpanded;
// //   final bool isHookupExpanded;
// //   final String aboutMe;
// //   final String lookingFor;
// //   final Map<String, String> partner1;
// //   final Map<String, String> partner2;
// //   final List<String> partner1Languages;
// //   final List<String> partner2Languages;
// //   final bool isLoading;
// //   final Map<String, dynamic>? linkedPartner;

// //   const ProfileEditState({
// //     this.isProfileDetailsTab = false,
// //     required this.swingersOptions,
// //     required this.hookupOptions,
// //     this.isSwingersExpanded = true,
// //     this.isHookupExpanded = true,
// //     this.aboutMe = '',
// //     this.lookingFor = '',
// //     required this.partner1,
// //     required this.partner2,
// //     required this.partner1Languages,
// //     required this.partner2Languages,
// //     this.isLoading = false,
// //     this.linkedPartner,
// //   });

// //   ProfileEditState copyWith({
// //     bool? isProfileDetailsTab,
// //     Map<String, bool>? swingersOptions,
// //     Map<String, bool>? hookupOptions,
// //     bool? isSwingersExpanded,
// //     bool? isHookupExpanded,
// //     String? aboutMe,
// //     String? lookingFor,
// //     Map<String, String>? partner1,
// //     Map<String, String>? partner2,
// //     List<String>? partner1Languages,
// //     List<String>? partner2Languages,
// //     bool? isLoading,
// //     Map<String, dynamic>? linkedPartner,
// //   }) {
// //     return ProfileEditState(
// //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// //       swingersOptions: swingersOptions ?? this.swingersOptions,
// //       hookupOptions: hookupOptions ?? this.hookupOptions,
// //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// //       aboutMe: aboutMe ?? this.aboutMe,
// //       lookingFor: lookingFor ?? this.lookingFor,
// //       partner1: partner1 ?? this.partner1,
// //       partner2: partner2 ?? this.partner2,
// //       partner1Languages: partner1Languages ?? this.partner1Languages,
// //       partner2Languages: partner2Languages ?? this.partner2Languages,
// //       isLoading: isLoading ?? this.isLoading,
// //       linkedPartner: linkedPartner ?? this.linkedPartner,
// //     );
// //   }
// // }

// // // ==================== API HELPERS (CLEAN & PERMANENT) ====================

// // const String baseApiUrl = 'https://app.beatflirtevent.com/App/user';

// // // Fixed spelling + fallback
// // const List<String> profileUrls = [
// //   '$baseApiUrl/single_user_profile',
// //   '$baseApiUrl/signle_user_profile', // fallback for old typo
// // ];

// // Map<String, String> apiHeaders({bool json = false}) {
// //   // Delegate to shared builder (will use last token if needed, but callers should pass)
// //   final h = ApiService.buildAuthHeaders();
// //   if (!json) {
// //     h['Content-Type'] = 'application/x-www-form-urlencoded';
// //   }
// //   return h;
// // }

// // bool _isHtmlError(String body) {
// //   final lower = body.toLowerCase();
// //   return lower.contains('404') ||
// //       lower.contains('not found') ||
// //       lower.contains('the page you requested');
// // }

// // bool _isTokenError(String body) {
// //   final lower = body.toLowerCase();
// //   return lower.contains('token') &&
// //       (lower.contains('required') ||
// //           lower.contains('missing') ||
// //           lower.contains('invalid') ||
// //           lower.contains('provide'));
// // }

// // Map<String, dynamic>? _tryDecode(String body) {
// //   try {
// //     final decoded = jsonDecode(body);
// //     if (decoded is Map<String, dynamic>) return decoded;
// //   } catch (_) {}
// //   return null;
// // }

// // // ==================== PERMANENT getProfile ====================

// // Future<Map<String, dynamic>> getProfile({required String token}) async {
// //   debugPrint('========== GET PROFILE START ==========');
// //   debugPrint('Using token length: ${token.length}');

// //   // Common successful patterns for this style of backend
// //   final attempts = <Future<http.Response> Function()>[
// //     // 1. POST form - most reliable for many PHP backends
// //     () => http.post(
// //           Uri.parse(profileUrls[0]),
// //           headers: apiHeaders(),
// //           body: {'token': token},
// //         ),
// //     () => http.post(
// //           Uri.parse(profileUrls[0]),
// //           headers: apiHeaders(),
// //           body: {'Authtoken': token},
// //         ),

// //     // 2. Bearer header (modern)
// //     () => http.get(
// //           Uri.parse(profileUrls[0]),
// //           headers: {...apiHeaders(), 'Authorization': 'Bearer $token'},
// //         ),

// //     // 3. Custom header
// //     () => http.get(
// //           Uri.parse(profileUrls[0]),
// //           headers: {...apiHeaders(), 'token': token},
// //         ),
// //     () => http.get(
// //           Uri.parse(profileUrls[0]),
// //           headers: {...apiHeaders(), 'Authtoken': token},
// //         ),

// //     // 4. Query param fallback
// //     () => http.get(
// //           Uri.parse('${profileUrls[0]}?token=$token'),
// //           headers: apiHeaders(),
// //         ),
// //   ];

// //   for (int i = 0; i < attempts.length; i++) {
// //     try {
// //       final response = await attempts[i]();

// //       debugPrint('ATTEMPT ${i + 1} → ${response.statusCode}');

// //       if (response.statusCode < 200 || response.statusCode >= 300) continue;
// //       if (_isHtmlError(response.body)) continue;
// //       if (_isTokenError(response.body)) continue;

// //       final decoded = _tryDecode(response.body);
// //       if (decoded != null) {
// //         debugPrint('✅ SUCCESS on attempt ${i + 1}');
// //         debugPrint('========== GET PROFILE END ==========');
// //         return decoded;
// //       }
// //     } catch (e) {
// //       debugPrint('ATTEMPT ${i + 1} ERROR: $e');
// //     }
// //   }

// //   throw Exception(
// //     'Failed to load profile. No authentication method worked. '
// //     'Run AuthService.probeAuth() in debug mode and check the [PROBE] logs.',
// //   );
// // }

// // // ==================== UPDATE PROFILE (kept probing for now) ====================

// // // We keep the candidate list for updates because the correct endpoint is still unknown.
// // const List<String> updateProfileCandidateUrls = [
// //   '$baseApiUrl/update_profile',
// //   '$baseApiUrl/update_user_profile',
// //   '$baseApiUrl/update_profile_details',
// //   '$baseApiUrl/save_profile',
// //   '$baseApiUrl/profile_update',
// //   '$baseApiUrl/edit_profile',
// //   '$baseApiUrl/update_user',
// // ];

// // Map<String, String> buildProfileFormBody({
// //   required String token,
// //   required Map<String, dynamic> updates,
// // }) {
// //   final partner1Traits = Map<String, dynamic>.from(updates['partner1Traits'] ?? {});
// //   final partner1Languages = List<dynamic>.from(updates['partner1Languages'] ?? []);
// //   final swingersOptions = Map<String, dynamic>.from(updates['swingersOptions'] ?? {});
// //   final hookupOptions = Map<String, dynamic>.from(updates['hookupOptions'] ?? {});

// //   return {
// //     'token': token,
// //     'Authtoken': token,
// //     'aboutMe': updates['aboutMe']?.toString() ?? '',
// //     'lookingFor': updates['lookingFor']?.toString() ?? '',
// //     'partner1Traits': jsonEncode(partner1Traits),
// //     'partner1Languages': jsonEncode(partner1Languages),
// //     'swingersOptions': jsonEncode(swingersOptions),
// //     'hookupOptions': jsonEncode(hookupOptions),
// //     'text': updates['aboutMe']?.toString() ?? '',
// //     'comment': updates['lookingFor']?.toString() ?? '',
// //     'person1_dob': partner1Traits['dateOfBirth']?.toString() ?? '',
// //     'person1_height': partner1Traits['height']?.toString() ?? '',
// //     'height1_type': partner1Traits['heightType']?.toString() ?? '',
// //     'person1_weight': partner1Traits['weight']?.toString() ?? '',
// //     'weight1_type': partner1Traits['weightType']?.toString() ?? '',
// //     'person1_body_type': partner1Traits['bodyType']?.toString() ?? '',
// //     'person1_ethnic_background': partner1Traits['ethnic']?.toString() ?? '',
// //     'person1_sexuality': partner1Traits['sexuality']?.toString() ?? '',
// //     'person1_relationship_orientation': partner1Traits['orientation']?.toString() ?? '',
// //     'person1_tattoos': partner1Traits['tattoos']?.toString() ?? '',
// //     'person1_piercings': partner1Traits['piercings']?.toString() ?? '',
// //     'person1_smoking': partner1Traits['smoking']?.toString() ?? '',
// //     'person1_drinking': partner1Traits['drinking']?.toString() ?? '',
// //     'person1_body_hair': partner1Traits['bodyHair']?.toString() ?? '',
// //     'person1_looks_important': partner1Traits['looks']?.toString() ?? '',
// //     'person1_intelligence_importance': partner1Traits['intelligence']?.toString() ?? '',
// //     'person1_circumcised': partner1Traits['circumcised']?.toString() ?? '',
// //     'person1_language_spoken': jsonEncode(partner1Languages),
// //   };
// // }

// // // ----------------------------------------------------------------------------
// // // PROFILE DETAILS SAVER 
// // // ----------------------------------------------------------------------------
// // class ProfileDetailsSaver {
// //   static const String singleUrl = 'https://app.beatflirtevent.com/App/user/edit_single_profile_details';
// //   static const String coupleUrl = 'https://app.beatflirtevent.com/App/user/edit_couple_profile_details';

// //   static Future<bool> save({
// //     required String token,
// //     required ProfileEditState state,
// //   }) async {
// //     final isCouple = state.linkedPartner != null;
// //     final url = isCouple ? coupleUrl : singleUrl;

// //     final payload = _buildPayload(state);

// //     debugPrint('========== SAVING PROFILE DETAILS ==========');
// //     debugPrint('URL: $url');
// //     debugPrint('IS COUPLE: $isCouple');
// //     debugPrint('TOKEN length: ${token.length}');

// //     final headers = ApiService.buildAuthHeaders(token: token);
// //     headers['Content-Type'] = 'application/x-www-form-urlencoded';
// //     headers['Accept'] = 'application/json';

// //     final body = {
// //       ...payload,
// //       'token': token,
// //       'Authtoken': token,
// //     };

// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: headers,
// //         body: body,
// //       );

// //       debugPrint('SAVE STATUS: ${response.statusCode}');
// //       debugPrint('SAVE BODY: ${response.body}');

// //       if (response.statusCode >= 200 && response.statusCode < 300) {
// //         try {
// //           final decoded = jsonDecode(response.body);
// //           if (decoded is Map<String, dynamic>) {
// //             final status = decoded['status']?.toString();
// //             final message = decoded['message']?.toString() ?? '';
// //             if (status == '200' || message.toLowerCase().contains('success')) {
// //               debugPrint('✅ Profile details saved successfully');
// //               return true;
// //             }
// //           }
// //         } catch (_) {}
// //       }
// //       return false;
// //     } catch (e) {
// //       debugPrint('SAVE ERROR: $e');
// //       return false;
// //     }
// //   }

// //   static Map<String, String> _buildPayload(ProfileEditState state) {
// //     final p1 = state.partner1;
// //     final p2 = state.partner2;
// //     final isCouple = state.linkedPartner != null;

// //     final payload = <String, String>{
// //       'text': state.aboutMe,
// //       'comment': state.lookingFor,
// //       'person1_name': '',
// //       'person1_dob': p1['dateOfBirth'] ?? '',
// //       'person1_height': p1['height'] ?? '',
// //       'height1_type': p1['heightType'] ?? '',
// //       'person1_weight': p1['weight'] ?? '',
// //       'weight1_type': p1['weightType'] ?? '',
// //       'person1_body_type': p1['bodyType'] ?? '',
// //       'person1_ethnic_background': p1['ethnic'] ?? '',
// //       'person1_sexuality': p1['sexuality'] ?? '',
// //       'person1_relationship_orientation': p1['orientation'] ?? '',
// //       'person1_tattoos': p1['tattoos'] ?? '',
// //       'person1_piercings': p1['piercings'] ?? '',
// //       'person1_smoking': p1['smoking'] ?? '',
// //       'person1_drinking': p1['drinking'] ?? '',
// //       'person1_body_hair': jsonEncode([p1['bodyHair'] ?? '']),
// //       'person1_looks_important': p1['looks'] ?? '',
// //       'person1_intelligence_importance': p1['intelligence'] ?? '',
// //       'person1_circumcised': p1['circumcised'] ?? '',
// //       'person1_language_spoken': jsonEncode(state.partner1Languages),
// //     };

// //     if (isCouple) {
// //       payload.addAll({
// //         'person2_name': '',
// //         'person2_dob': p2['dateOfBirth'] ?? '',
// //         'person2_height': p2['height'] ?? '',
// //         'height2_type': p2['heightType'] ?? '',
// //         'person2_weight': p2['weight'] ?? '',
// //         'weight2_type': p2['weightType'] ?? '',
// //         'person2_body_type': p2['bodyType'] ?? '',
// //         'person2_ethnic_background': p2['ethnic'] ?? '',
// //         'person2_sexuality': p2['sexuality'] ?? '',
// //         'person2_relationship_orientation': p2['orientation'] ?? '',
// //         'person2_tattoos': p2['tattoos'] ?? '',
// //         'person2_piercings': p2['piercings'] ?? '',
// //         'person2_smoking': p2['smoking'] ?? '',
// //         'person2_drinking': p2['drinking'] ?? '',
// //         'person2_body_hair': jsonEncode([p2['bodyHair'] ?? '']),
// //         'person2_looks_important': p2['looks'] ?? '',
// //         'person2_intelligence_importance': p2['intelligence'] ?? '',
// //         'person2_circumcised': p2['circumcised'] ?? '',
// //         'person2_language_spoken': jsonEncode(state.partner2Languages),
// //       });
// //     }

// //     return payload;
// //   }
// // }

// // // ----------------------------------------------------------------------------
// // // INTERESTS SAVER 
// // // ----------------------------------------------------------------------------
// // class ProfileInterestsSaver {
// //   static const String singleUrl = 'https://app.beatflirtevent.com/App/user/edit_single_profile_interest';
// //   static const String coupleUrl = 'https://app.beatflirtevent.com/App/user/edit_single_profile_interest'; // same URL for couple as per spec

// //   static Future<bool> save({
// //     required String token,
// //     required ProfileEditState state,
// //   }) async {
// //     final isCouple = state.linkedPartner != null;
// //     final url = isCouple ? coupleUrl : singleUrl;

// //     final payload = _buildInterestsPayload(state);

// //     debugPrint('========== SAVING INTERESTS ==========');
// //     debugPrint('URL: $url');
// //     debugPrint('IS COUPLE: $isCouple');

// //     final headers = ApiService.buildAuthHeaders(token: token);
// //     headers['Content-Type'] = 'application/x-www-form-urlencoded';
// //     headers['Accept'] = 'application/json';

// //     final body = {
// //       ...payload,
// //       'token': token,
// //       'Authtoken': token,
// //     };

// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: headers,
// //         body: body,
// //       );

// //       debugPrint('INTERESTS SAVE STATUS: ${response.statusCode}');
// //       debugPrint('INTERESTS SAVE BODY: ${response.body}');

// //       if (response.statusCode >= 200 && response.statusCode < 300) {
// //         try {
// //           final decoded = jsonDecode(response.body);
// //           if (decoded is Map<String, dynamic>) {
// //             final status = decoded['status']?.toString();
// //             final message = decoded['message']?.toString() ?? '';
// //             if (status == '200' || message.toLowerCase().contains('success')) {
// //               debugPrint('✅ Interests saved successfully');
// //               return true;
// //             }
// //           }
// //         } catch (_) {}
// //       }
// //       return false;
// //     } catch (e) {
// //       debugPrint('INTERESTS SAVE ERROR: $e');
// //       return false;
// //     }
// //   }

// //   static Map<String, String> _buildInterestsPayload(ProfileEditState state) {
// //     final s = state.swingersOptions;
// //     final h = state.hookupOptions;

// //     return {
// //       'couple_male_female_swingers': (s['Couple Female/Male'] ?? false) ? '1' : '0',
// //       'couple_male_female_hookup_meetup': (h['Couple Female/Male'] ?? false) ? '1' : '0',
// //       'couple_female_female_swingers': (s['Couple Female/Female'] ?? false) ? '1' : '0',
// //       'couple_female_female_hookup_meetup': (h['Couple Female/Female'] ?? false) ? '1' : '0',
// //       'couple_male_male_swingers': (s['Couple Male/Male'] ?? false) ? '1' : '0',
// //       'couple_male_male_hookup_meetup': (h['Couple Male/Male'] ?? false) ? '1' : '0',
// //       'couple_female_swingers': (s['Female'] ?? false) ? '1' : '0',
// //       'couple_female_hookup_meetup': (h['Female'] ?? false) ? '1' : '0',
// //       'couple_male_swingers': (s['Male'] ?? false) ? '1' : '0',
// //       'couple_male_hookup_meetup': (h['Male'] ?? false) ? '1' : '0',
// //       'couple_transgender_swingers': (s['Transgender'] ?? false) ? '1' : '0',
// //       'couple_transgender_hookup_meetup': (h['Transgender'] ?? false) ? '1' : '0',
// //     };
// //   }
// // }

// // // ==================== DEFAULT DATA ====================

// // Map<String, String> defaultPartnerTraits() {
// //   return {
// //     'dateOfBirth': '',
// //     'height': '',
// //     'heightType': '',
// //     'weight': '',
// //     'weightType': '',
// //     'bodyType': ProfileOptions.notComfortableValue,
// //     'ethnic': ProfileOptions.notComfortableValue,
// //     'sexuality': ProfileOptions.notComfortableValue,
// //     'orientation': ProfileOptions.notComfortableValue,
// //     'tattoos': ProfileOptions.notComfortableValue,
// //     'piercings': ProfileOptions.notComfortableValue,
// //     'smoking': ProfileOptions.notComfortableValue,
// //     'drinking': ProfileOptions.notComfortableValue,
// //     'bodyHair': ProfileOptions.notComfortableValue,
// //     'looks': ProfileOptions.notComfortableValue,
// //     'intelligence': ProfileOptions.notComfortableValue,
// //     'circumcised': ProfileOptions.notComfortableValue,
// //   };
// // }

// // // ==================== NOTIFIER (CLEAN & PERMANENT) ====================

// // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// //   @override
// //   ProfileEditState build() {
// //     Future.microtask(() => loadProfile());
// //     return ProfileEditState(
// //       swingersOptions: {
// //         'Couple Female/Male': true,
// //         'Couple Female/Female': true,
// //         'Couple Male/Male': true,
// //         'Female': true,
// //         'Male': true,
// //         'Transgender': true,
// //       },
// //       hookupOptions: {
// //         'Couple Female/Male': true,
// //         'Couple Female/Female': true,
// //         'Couple Male/Male': true,
// //         'Female': true,
// //         'Male': true,
// //         'Transgender': false,
// //       },
// //       partner1: defaultPartnerTraits(),
// //       partner2: defaultPartnerTraits(),
// //       partner1Languages: [],
// //       partner2Languages: [],
// //     );
// //   }

// //   Future<void> loadProfile() async {
// //     debugPrint('========== LOAD PROFILE ==========');
// //     state = state.copyWith(isLoading: true);

// //     try {
// //       final String? token = await AuthService.getToken();

// //       if (token == null || token.isEmpty) {
// //         debugPrint('❌ No token from AuthService.getToken()');
// //         state = state.copyWith(isLoading: false);
// //         return;
// //       }

// //       // Optional: uncomment for discovery
// //       // await AuthService.probeAuth();

// //       final data = await getProfile(token: token);
// //       debugPrint('RAW PROFILE DATA KEYS: ${data.keys.toList()}');

// //       // Flexible user extraction
// //       final user = data['user'] ??
// //           data['data']?['user'] ??
// //           data['profile'] ??
// //           data['data'] ??
// //           data;

// //       if (user is Map) {
// //         final userMap = Map<String, dynamic>.from(user);

// //         final mergedTraits = defaultPartnerTraits();
// //         final backendTraits = Map<String, dynamic>.from(userMap['partner1Traits'] ?? {});

// //         backendTraits.forEach((key, value) {
// //           if (mergedTraits.containsKey(key)) {
// //             mergedTraits[key] = value.toString();
// //           }
// //         });

// //         final linked = userMap['partnerId'];
// //         Map<String, String> p2Traits = defaultPartnerTraits();
// //         List<String> p2Langs = [];
// //         Map<String, dynamic>? linkedMap;

// //         if (linked is Map) {
// //           linkedMap = Map<String, dynamic>.from(linked);
// //           final lpTraits = Map<String, dynamic>.from(linkedMap['partner1Traits'] ?? {});
// //           lpTraits.forEach((key, value) {
// //             if (p2Traits.containsKey(key)) p2Traits[key] = value.toString();
// //           });
// //           p2Langs = List<String>.from(linkedMap['partner1Languages'] ?? []);
// //         }

// //         final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
// //         final backendSwingers = Map<String, dynamic>.from(userMap['swingersOptions'] ?? {});
// //         backendSwingers.forEach((key, value) {
// //           if (mergedSwingers.containsKey(key)) mergedSwingers[key] = value == true;
// //         });

// //         final mergedHookup = Map<String, bool>.from(state.hookupOptions);
// //         final backendHookup = Map<String, dynamic>.from(userMap['hookupOptions'] ?? {});
// //         backendHookup.forEach((key, value) {
// //           if (mergedHookup.containsKey(key)) mergedHookup[key] = value == true;
// //         });

// //         state = state.copyWith(
// //           aboutMe: userMap['aboutMe']?.toString() ?? '',
// //           lookingFor: userMap['lookingFor']?.toString() ?? '',
// //           partner1: mergedTraits,
// //           partner1Languages: List<String>.from(userMap['partner1Languages'] ?? []),
// //           swingersOptions: mergedSwingers,
// //           hookupOptions: mergedHookup,
// //           partner2: p2Traits,
// //           partner2Languages: p2Langs,
// //           linkedPartner: linkedMap,
// //         );

// //         debugPrint('✅ Profile loaded successfully');
// //       } else {
// //         debugPrint('⚠️ No usable user data found in response: $data');
// //       }
// //     } catch (e, stack) {
// //       debugPrint('❌ Error loading profile: $e');
// //       debugPrint(stack.toString());
// //     } finally {
// //       state = state.copyWith(isLoading: false);
// //     }
// //   }

// //   Future<void> saveProfile() async {
// //     final String? token = await AuthService.getToken();

// //     if (token == null || token.isEmpty) {
// //       Get.snackbar('Error', 'User token not found',
// //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// //       return;
// //     }

// //     state = state.copyWith(isLoading: true);

// //     try {
// //       if (state.isProfileDetailsTab) {
// //         final success = await ProfileDetailsSaver.save(
// //           token: token,
// //           state: state,
// //         );

// //         if (success) {
// //           Get.snackbar('Success', 'Profile updated successfully',
// //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// //         } else {
// //           Get.snackbar('Error', 'Failed to update profile. Check console.',
// //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// //         }
// //       } else {
// //         // INTERESTS TAB
// //         final success = await ProfileInterestsSaver.save(
// //           token: token,
// //           state: state,
// //         );

// //         if (success) {
// //           Get.snackbar('Success', 'Interests saved successfully',
// //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// //         } else {
// //           Get.snackbar('Error', 'Failed to save interests. Check console.',
// //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('Error saving: $e');
// //       Get.snackbar('Error', 'Failed to save: $e',
// //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// //     } finally {
// //       state = state.copyWith(isLoading: false);
// //     }
// //   }

// //   // All the update methods below are unchanged (they were fine)
// //   void toggleProfileTab(bool isProfile) {
// //     state = state.copyWith(isProfileDetailsTab: isProfile);
// //   }

// //   void toggleSwingersExpanded() {
// //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// //   }

// //   void toggleHookupExpanded() {
// //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// //   }

// //   void updateSwingersOption(String label, bool value) {
// //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// //     newOptions[label] = value;
// //     state = state.copyWith(swingersOptions: newOptions);
// //   }

// //   void updateHookupOption(String label, bool value) {
// //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// //     newOptions[label] = value;
// //     state = state.copyWith(hookupOptions: newOptions);
// //   }

// //   void updateAboutMe(String value) {
// //     state = state.copyWith(aboutMe: value);
// //   }

// //   void updateLookingFor(String value) {
// //     state = state.copyWith(lookingFor: value);
// //   }

// //   void updatePartner1(String key, String value) {
// //     final newPartner = Map<String, String>.from(state.partner1);
// //     newPartner[key] = value;
// //     state = state.copyWith(partner1: newPartner);
// //   }

// //   void updatePartner2(String key, String value) {
// //     final newPartner = Map<String, String>.from(state.partner2);
// //     newPartner[key] = value;
// //     state = state.copyWith(partner2: newPartner);
// //   }

// //   void updatePartner1Languages(List<String> langs) {
// //     state = state.copyWith(partner1Languages: langs);
// //   }

// //   void updatePartner2Languages(List<String> langs) {
// //     state = state.copyWith(partner2Languages: langs);
// //   }
// // }

// // final profileEditProvider =
// //     NotifierProvider<ProfileEditNotifier, ProfileEditState>(ProfileEditNotifier.new);

// // // ==================== WIDGET + ALL UI CODE (cleaned of artifacts) ====================

// // class MyProfileEditTab extends ConsumerWidget {
// //   const MyProfileEditTab({super.key});

// //   static const List<String> languageOptions = [
// //     'English',
// //     'Hindi',
// //     'German',
// //     'French',
// //     'Spanish',
// //     'Italian',
// //     'Portuguese',
// //     'Chinese (Mandarin)',
// //     'Japanese',
// //     'Korean',
// //     'Russian',
// //     'Arabic',
// //     'Bengali',
// //     'Urdu',
// //     'Turkish',
// //     'Dutch',
// //     'Swedish',
// //     'Polish',
// //     'Greek',
// //     'Hebrew',
// //     'Thai',
// //     'Vietnamese',
// //     'Indonesian',
// //     'Malay',
// //     'Filipino',
// //   ];

// //   void saveInterests() {
// //     Get.snackbar(
// //       'Success',
// //       'Interests saved successfully',
// //       snackPosition: SnackPosition.TOP,
// //       backgroundColor: Colors.transparent,
// //       colorText: Colors.white,
// //       margin: const EdgeInsets.all(12),
// //       borderRadius: 10,
// //       duration: const Duration(seconds: 2),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final profileState = ref.watch(profileEditProvider);
// //     final notifier = ref.read(profileEditProvider.notifier);

// //     return LayoutBuilder(
// //       builder: (context, constraints) {
// //         final double width = constraints.maxWidth;
// //         final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
// //         final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;

// //         return Container(
// //           width: double.infinity,
// //           constraints: BoxConstraints(
// //             minHeight: MediaQuery.of(context).size.height * 0.62,
// //           ),
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(14),
// //             border: Border.all(color: const Color(0xFFE8E0F2)),
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               if (profileState.isLoading)
// //                 const Padding(
// //                   padding: EdgeInsets.only(bottom: 10),
// //                   child: LinearProgressIndicator(color: Colors.pink),
// //                 ),
// //               sectionHeader(profileState, notifier),
// //               const SizedBox(height: 16),
// //               if (profileState.isProfileDetailsTab)
// //                 buildProfileDetailsContent(context, width, profileState, notifier)
// //               else
// //                 buildInterestsContent(optionWidth, profileState, notifier),
// //               const SizedBox(height: 18),
// //               Center(
// //                 child: SizedBox(
// //                   width: 170,
// //                   child: ElevatedButton(
// //                     onPressed: profileState.isLoading
// //                         ? null
// //                         : () => notifier.saveProfile(),
// //                     style: ElevatedButton.styleFrom(
// //                       elevation: 4,
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                       backgroundColor: const Color(0xFF220027),
// //                       foregroundColor: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(22),
// //                       ),
// //                     ),
// //                     child: profileState.isLoading
// //                         ? const SizedBox(
// //                             height: 20,
// //                             width: 20,
// //                             child: CircularProgressIndicator(
// //                               color: Colors.white,
// //                               strokeWidth: 2,
// //                             ),
// //                           )
// //                         : Text(
// //                             profileState.isProfileDetailsTab ? 'Save Profile' : 'Save Interest',
// //                             style: const TextStyle(
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 6),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // ==================== ALL THE UI HELPER METHODS (kept from original, cleaned) ====================

// //   Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
// //     return Container(
// //       height: 38,
// //       padding: const EdgeInsets.symmetric(horizontal: 8),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// //         ),
// //         borderRadius: BorderRadius.circular(22),
// //       ),
// //       child: Row(
// //         children: [
// //           InkWell(
// //             borderRadius: BorderRadius.circular(16),
// //             onTap: () => notifier.toggleProfileTab(false),
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// //               decoration: BoxDecoration(
// //                 color: !state.isProfileDetailsTab ? const Color(0xFFFF2D87) : Colors.transparent,
// //                 borderRadius: BorderRadius.circular(16),
// //               ),
// //               child: const Text(
// //                 'INTERESTS',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 11,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const Spacer(),
// //           InkWell(
// //             borderRadius: BorderRadius.circular(16),
// //             onTap: () => notifier.toggleProfileTab(true),
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// //               decoration: BoxDecoration(
// //                 color: state.isProfileDetailsTab ? const Color(0xFFFF2D87) : Colors.transparent,
// //                 borderRadius: BorderRadius.circular(16),
// //               ),
// //               child: const Text(
// //                 'PROFILE DETAILS',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildInterestsContent(
// //       double optionWidth,
// //       ProfileEditState state,
// //       ProfileEditNotifier notifier,
// //       ) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text(
// //           'davidbrown',
// //           style: TextStyle(
// //             fontWeight: FontWeight.w700,
// //             fontSize: 34,
// //             height: 1.05,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           'What are you looking for? Select all that apply',
// //           style: TextStyle(
// //             color: Colors.grey[700],
// //             fontSize: 14,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         interestGroup(
// //           title: 'Swingers',
// //           expanded: state.isSwingersExpanded,
// //           onToggle: notifier.toggleSwingersExpanded,
// //           options: state.swingersOptions,
// //           optionWidth: optionWidth,
// //           onChanged: (label, value) => notifier.updateSwingersOption(label, value),
// //         ),
// //         const SizedBox(height: 12),
// //         interestGroup(
// //           title: 'Hookup / Meetup',
// //           expanded: state.isHookupExpanded,
// //           onToggle: notifier.toggleHookupExpanded,
// //           options: state.hookupOptions,
// //           optionWidth: optionWidth,
// //           onChanged: (label, value) => notifier.updateHookupOption(label, value),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget buildProfileDetailsContent(
// //       BuildContext context,
// //       double width,
// //       ProfileEditState state,
// //       ProfileEditNotifier notifier,
// //       ) {
// //     final bool stacked = width < 760;
// //     final bool isCouple = state.linkedPartner != null;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         textFieldLabel('INTRODUCE YOURSELF'),
// //         const SizedBox(height: 6),
// //         simpleTextField(
// //           label: 'About Me',
// //           initialValue: state.aboutMe,
// //           onChanged: notifier.updateAboutMe,
// //         ),
// //         const SizedBox(height: 10),
// //         textFieldLabel('LOOKING FOR'),
// //         const SizedBox(height: 6),
// //         simpleTextField(
// //           label: 'Looking For',
// //           initialValue: state.lookingFor,
// //           maxLines: 2,
// //           onChanged: notifier.updateLookingFor,
// //         ),
// //         const SizedBox(height: 14),
// //         const Center(
// //           child: Text(
// //             'About Yourselves',
// //             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //         if (isCouple)
// //           if (stacked)
// //             Column(
// //               children: [
// //                 partnerPanel(
// //                   context: context,
// //                   title: 'Partner 1',
// //                   data: state.partner1,
// //                   languages: state.partner1Languages,
// //                   onFieldChanged: notifier.updatePartner1,
// //                   onLanguagesChanged: notifier.updatePartner1Languages,
// //                   readOnly: false,
// //                 ),
// //                 const SizedBox(height: 12),
// //                 partnerPanel(
// //                   context: context,
// //                   title: 'Partner 2',
// //                   data: state.partner2,
// //                   languages: state.partner2Languages,
// //                   onFieldChanged: notifier.updatePartner2,
// //                   onLanguagesChanged: notifier.updatePartner2Languages,
// //                   readOnly: false,
// //                 ),
// //               ],
// //             )
// //           else
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Expanded(
// //                   child: partnerPanel(
// //                     context: context,
// //                     title: 'Partner 1',
// //                     data: state.partner1,
// //                     languages: state.partner1Languages,
// //                     onFieldChanged: notifier.updatePartner1,
// //                     onLanguagesChanged: notifier.updatePartner1Languages,
// //                     readOnly: false,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: partnerPanel(
// //                     context: context,
// //                     title: 'Partner 2',
// //                     data: state.partner2,
// //                     languages: state.partner2Languages,
// //                     onFieldChanged: notifier.updatePartner2,
// //                     onLanguagesChanged: notifier.updatePartner2Languages,
// //                     readOnly: false,
// //                   ),
// //                 ),
// //               ],
// //             )
// //         else
// //           partnerPanel(
// //             context: context,
// //             title: 'Partner 1',
// //             data: state.partner1,
// //             languages: state.partner1Languages,
// //             onFieldChanged: notifier.updatePartner1,
// //             onLanguagesChanged: notifier.updatePartner1Languages,
// //             readOnly: false,
// //           ),
// //       ],
// //     );
// //   }

// //   // ... (I am keeping the rest of the UI methods exactly as in your original code but cleaned of * artifacts)

// //   Widget partnerPanel({
// //     required BuildContext context,
// //     required String title,
// //     required Map<String, String> data,
// //     required List<String> languages,
// //     required void Function(String, String) onFieldChanged,
// //     required void Function(List<String>) onLanguagesChanged,
// //     bool readOnly = false,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Container(
// //           height: 34,
// //           alignment: Alignment.center,
// //           decoration: BoxDecoration(
// //             gradient: const LinearGradient(
// //               colors: [Color(0xFF19001F), Color(0xFF490040)],
// //             ),
// //             borderRadius: BorderRadius.circular(10),
// //           ),
// //           child: Text(
// //             title,
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontWeight: FontWeight.w700,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 10),
// //         dateOfBirthField(
// //           context: context,
// //           label: 'DATE OF BIRTH',
// //           data: data,
// //           keyName: 'dateOfBirth',
// //           onFieldChanged: onFieldChanged,
// //           readOnly: readOnly,
// //         ),
// //         heightInputField(data: data, onFieldChanged: onFieldChanged, readOnly: readOnly),
// //         weightInputField(data: data, onFieldChanged: onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('BODY TYPE', data, 'bodyType', ProfileOptions.bodyTypes, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('ETHNIC BACKGROUND', data, 'ethnic', ProfileOptions.ethnicBackgrounds, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('SEXUALITY', data, 'sexuality', ProfileOptions.sexualities, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('RELATIONSHIP ORIENTATION', data, 'orientation', ProfileOptions.relationshipOrientations, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('TATTOOS', data, 'tattoos', ProfileOptions.tattoos, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('PIERCINGS', data, 'piercings', ProfileOptions.piercings, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('SMOKING', data, 'smoking', ProfileOptions.smoking, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('DRINKING', data, 'drinking', ProfileOptions.drinking, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('BODY HAIR', data, 'bodyHair', ProfileOptions.bodyHair, onFieldChanged, readOnly: readOnly),
// //         languagesField(context, 'LANGUAGES SPOKEN', languages, onLanguagesChanged, readOnly: readOnly),
// //         profileOptionDropdownField('LOOKS IMPORTANCE', data, 'looks', ProfileOptions.importanceLevels, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('INTELLIGENCE IMPORTANCE', data, 'intelligence', ProfileOptions.importanceLevels, onFieldChanged, readOnly: readOnly),
// //         profileOptionDropdownField('CIRCUMCISED', data, 'circumcised', ProfileOptions.circumcised, onFieldChanged, readOnly: readOnly),
// //       ],
// //     );
// //   }

// //   // All the remaining helper widgets (dateOfBirthField, heightInputField, etc.) are included below exactly as you had them, just without the * characters.

// //   // For brevity in this response, the remaining ~200 lines of UI widgets (dateOfBirthField, heightInputField, weightInputField, unitRadioButton, profileInputDecoration, parseProfileDate, formatProfileDate, findProfileOption, normalize, defaultProfileOptionValue, profileOptionDropdownField, dropdownField, simpleTextField, textFieldLabel, languagesField, openLanguageSelector, interestGroup, OptionChip) are copied from your original code with only the * artifacts removed.

// //   // You can copy the full cleaned file from the workspace or I can expand it if needed.

// //   // To make this complete, I'll include the key remaining methods here.

// //   Widget dateOfBirthField({
// //     required BuildContext context,
// //     required String label,
// //     required Map<String, String> data,
// //     required String keyName,
// //     required void Function(String, String) onFieldChanged,
// //     bool readOnly = false,
// //   }) {
// //     final currentValue = data[keyName] ?? '';
// //     final displayValue = currentValue.trim().isEmpty ? 'dd/mm/yyyy' : currentValue;

// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           textFieldLabel(label),
// //           const SizedBox(height: 4),
// //           InkWell(
// //             onTap: readOnly
// //                 ? null
// //                 : () async {
// //                     final now = DateTime.now();
// //                     final parsedDate = parseProfileDate(currentValue);

// //                     DateTime initialDate = parsedDate ?? DateTime(now.year - 18, now.month, now.day);

// //                     if (initialDate.isAfter(now)) {
// //                       initialDate = now;
// //                     }
// //                     if (initialDate.isBefore(DateTime(1900))) {
// //                       initialDate = DateTime(1900);
// //                     }

// //                     final pickedDate = await showDatePicker(
// //                       context: context,
// //                       initialDate: initialDate,
// //                       firstDate: DateTime(1900),
// //                       lastDate: now,
// //                     );

// //                     if (pickedDate == null) return;
// //                     onFieldChanged(keyName, formatProfileDate(pickedDate));
// //                   },
// //             borderRadius: BorderRadius.circular(8),
// //             child: Container(
// //               height: 42,
// //               width: double.infinity,
// //               padding: const EdgeInsets.symmetric(horizontal: 10),
// //               decoration: BoxDecoration(
// //                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// //                 borderRadius: BorderRadius.circular(8),
// //                 border: Border.all(
// //                   color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2),
// //                 ),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Text(
// //                       displayValue,
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         color: currentValue.trim().isEmpty ? Colors.grey[600] : Colors.black87,
// //                       ),
// //                     ),
// //                   ),
// //                   const Icon(
// //                     Icons.calendar_today_outlined,
// //                     size: 17,
// //                     color: Colors.black87,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget heightInputField({
// //     required Map<String, String> data,
// //     required void Function(String, String) onFieldChanged,
// //     bool readOnly = false,
// //   }) {
// //     final selectedType = (data['heightType'] ?? '').trim().isEmpty ? null : data['heightType'];

// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           textFieldLabel('HEIGHT'),
// //           const SizedBox(height: 2),
// //           Row(
// //             children: [
// //               unitRadioButton(
// //                 label: 'FT',
// //                 value: 'FT',
// //                 groupValue: selectedType,
// //                 readOnly: readOnly,
// //                 onChanged: (value) => onFieldChanged('heightType', value),
// //               ),
// //               const SizedBox(width: 18),
// //               unitRadioButton(
// //                 label: 'CM',
// //                 value: 'CM',
// //                 groupValue: selectedType,
// //                 readOnly: readOnly,
// //                 onChanged: (value) => onFieldChanged('heightType', value),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 4),
// //           TextFormField(
// //             // Stable key — do not include live value
// //             key: ValueKey('height-$readOnly'),
// //             initialValue: data['height'] ?? '',
// //             readOnly: readOnly,
// //             onChanged: readOnly ? null : (value) => onFieldChanged('height', value),
// //             keyboardType: TextInputType.text,
// //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// //             decoration: profileInputDecoration(
// //               hintText: "Ex. (5'7 OR 170)",
// //               readOnly: readOnly,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget weightInputField({
// //     required Map<String, String> data,
// //     required void Function(String, String) onFieldChanged,
// //     bool readOnly = false,
// //   }) {
// //     final selectedType = (data['weightType'] ?? '').trim().isEmpty ? null : data['weightType'];

// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           textFieldLabel('WEIGHT'),
// //           const SizedBox(height: 2),
// //           Row(
// //             children: [
// //               unitRadioButton(
// //                 label: 'LBS',
// //                 value: 'LBS',
// //                 groupValue: selectedType,
// //                 readOnly: readOnly,
// //                 onChanged: (value) => onFieldChanged('weightType', value),
// //               ),
// //               const SizedBox(width: 18),
// //               unitRadioButton(
// //                 label: 'KG',
// //                 value: 'KG',
// //                 groupValue: selectedType,
// //                 readOnly: readOnly,
// //                 onChanged: (value) => onFieldChanged('weightType', value),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 4),
// //           TextFormField(
// //             // Stable key — do not include live value
// //             key: ValueKey('weight-$readOnly'),
// //             initialValue: data['weight'] ?? '',
// //             readOnly: readOnly,
// //             onChanged: readOnly ? null : (value) => onFieldChanged('weight', value),
// //             keyboardType: TextInputType.number,
// //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// //             decoration: profileInputDecoration(
// //               hintText: 'Ex. (150 LBS OR 68 KG)',
// //               readOnly: readOnly,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget unitRadioButton({
// //     required String label,
// //     required String value,
// //     required String? groupValue,
// //     required void Function(String) onChanged,
// //     bool readOnly = false,
// //   }) {
// //     return InkWell(
// //       onTap: readOnly ? null : () => onChanged(value),
// //       borderRadius: BorderRadius.circular(8),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Radio<String>(
// //             value: value,
// //             groupValue: groupValue,
// //             onChanged: readOnly
// //                 ? null
// //                 : (selectedValue) {
// //                     if (selectedValue == null) return;
// //                     onChanged(selectedValue);
// //                   },
// //             activeColor: const Color(0xFF5A002B),
// //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //             visualDensity: VisualDensity.compact,
// //           ),
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               fontSize: 12,
// //               fontWeight: FontWeight.w800,
// //               color: Color(0xFF5A002B),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   InputDecoration profileInputDecoration({
// //     required String hintText,
// //     bool readOnly = false,
// //   }) {
// //     return InputDecoration(
// //       hintText: hintText,
// //       hintStyle: TextStyle(
// //         color: Colors.grey[600],
// //         fontSize: 12,
// //       ),
// //       isDense: true,
// //       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// //       border: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8),
// //         borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //       ),
// //       enabledBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8),
// //         borderSide: BorderSide(
// //           color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2),
// //         ),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8),
// //         borderSide: const BorderSide(color: Color(0xFF5A002B)),
// //       ),
// //       fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// //       filled: true,
// //     );
// //   }

// //   DateTime? parseProfileDate(String? value) {
// //     if (value == null || value.trim().isEmpty) return null;
// //     final text = value.trim();

// //     final dmyMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);
// //     if (dmyMatch != null) {
// //       final day = int.tryParse(dmyMatch.group(1)!);
// //       final month = int.tryParse(dmyMatch.group(2)!);
// //       final year = int.tryParse(dmyMatch.group(3)!);
// //       if (day != null && month != null && year != null) {
// //         return DateTime(year, month, day);
// //       }
// //     }

// //     final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
// //     if (isoMatch != null) {
// //       final year = int.tryParse(isoMatch.group(1)!);
// //       final month = int.tryParse(isoMatch.group(2)!);
// //       final day = int.tryParse(isoMatch.group(3)!);
// //       if (day != null && month != null && year != null) {
// //         return DateTime(year, month, day);
// //       }
// //     }
// //     return DateTime.tryParse(text);
// //   }

// //   String formatProfileDate(DateTime date) {
// //     final day = date.day.toString().padLeft(2, '0');
// //     final month = date.month.toString().padLeft(2, '0');
// //     final year = date.year.toString();
// //     return '$day/$month/$year';
// //   }

// //   ProfileOption? findProfileOption(String? currentValue, List<ProfileOption> options) {
// //     if (currentValue == null || currentValue.trim().isEmpty) return null;
// //     final normalizedCurrent = normalize(currentValue);

// //     for (final option in options) {
// //       if (normalize(option.id) == normalizedCurrent ||
// //           normalize(option.value) == normalizedCurrent ||
// //           normalize(option.label) == normalizedCurrent) {
// //         return option;
// //       }
// //     }

// //     if (normalizedCurrent == normalize('Bisexual')) {
// //       return firstProfileOptionWhere(options, (e) => e.value == 'Bi-sexual');
// //     }
// //     if (normalizedCurrent == normalize('Occasionally')) {
// //       return firstProfileOptionWhere(options, (e) => e.value == 'Occasionally');
// //     }
// //     if (normalizedCurrent == normalize('Low')) {
// //       return firstProfileOptionWhere(options, (e) => e.value == 'Low Importance');
// //     }
// //     if (normalizedCurrent == normalize('Medium')) {
// //       return firstProfileOptionWhere(options, (e) => e.value == 'Medium Importance');
// //     }
// //     if (normalizedCurrent == normalize('High')) {
// //       return firstProfileOptionWhere(options, (e) => e.value == 'Very Important');
// //     }
// //     return null;
// //   }

// //   ProfileOption? firstProfileOptionWhere(List<ProfileOption> options, bool Function(ProfileOption) test) {
// //     for (final option in options) {
// //       if (test(option)) return option;
// //     }
// //     return null;
// //   }

// //   String normalize(String value) {
// //     return value.trim().toLowerCase().replaceAll('.', '').replaceAll('-', '').replaceAll('_', '').replaceAll(' ', '');
// //   }

// //   String? defaultProfileOptionValue(List<ProfileOption> options) {
// //     if (options.isEmpty) return null;
// //     for (final option in options) {
// //       if (option.id == 'not_comfortable') return option.value;
// //     }
// //     return options.first.value;
// //   }

// //   Widget profileOptionDropdownField(
// //     String label,
// //     Map<String, String> data,
// //     String key,
// //     List<ProfileOption> options,
// //     void Function(String, String) onFieldChanged, {
// //     bool readOnly = false,
// //   }) {
// //     final currentValue = data[key];
// //     final selectedOption = findProfileOption(currentValue, options);
// //     final validValue = selectedOption?.value ?? defaultProfileOptionValue(options);

// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           textFieldLabel(label),
// //           const SizedBox(height: 4),
// //           DropdownButtonFormField<String>(
// //             key: ValueKey('$label-$key-$readOnly'), // stabilized key (removed live value)
// //             initialValue: validValue,
// //             isExpanded: true,
// //             iconSize: 18,
// //             style: const TextStyle(fontSize: 12, color: Colors.black87, overflow: TextOverflow.ellipsis),
// //             items: options.map((option) {
// //               return DropdownMenuItem<String>(
// //                 value: option.value,
// //                 child: Text(option.label, maxLines: 1, overflow: TextOverflow.ellipsis),
// //               );
// //             }).toList(),
// //             selectedItemBuilder: (context) {
// //               return options.map((option) {
// //                 return Align(
// //                   alignment: Alignment.centerLeft,
// //                   child: Text(option.label, maxLines: 1, overflow: TextOverflow.ellipsis),
// //                 );
// //               }).toList();
// //             },
// //             onChanged: readOnly
// //                 ? null
// //                 : (value) {
// //                     if (value == null) return;
// //                     onFieldChanged(key, value);
// //                   },
// //             decoration: InputDecoration(
// //               isDense: true,
// //               contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //               ),
// //               enabledBorder: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //                 borderSide: BorderSide(
// //                   color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2),
// //                 ),
// //               ),
// //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// //               filled: readOnly,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget simpleTextField({
// //     required String label,
// //     required String initialValue,
// //     required void Function(String) onChanged,
// //     int maxLines = 1,
// //     bool readOnly = false,
// //   }) {
// //     return TextFormField(
// //       // Stable key — do NOT include the live value here.
// //       // Including $initialValue caused the TextFormField to be treated as a
// //       // completely new widget on every keystroke → focus lost + keyboard dismiss.
// //       key: ValueKey('$label-$readOnly'),
// //       initialValue: initialValue,
// //       maxLines: maxLines,
// //       onChanged: onChanged,
// //       readOnly: readOnly,
// //       style: const TextStyle(fontSize: 12),
// //       decoration: InputDecoration(
// //         hintText: label,
// //         isDense: true,
// //         contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget textFieldLabel(String text) {
// //     return Text(
// //       text,
// //       style: const TextStyle(
// //         fontSize: 11,
// //         fontWeight: FontWeight.w800,
// //         letterSpacing: 0.2,
// //       ),
// //     );
// //   }

// //   Widget languagesField(
// //     BuildContext context,
// //     String label,
// //     List<String> selectedValues,
// //     void Function(List<String>) onSaved, {
// //     bool readOnly = false,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           textFieldLabel(label),
// //           const SizedBox(height: 4),
// //           InkWell(
// //             onTap: readOnly ? null : () => openLanguageSelector(context, selectedValues, onSaved),
// //             borderRadius: BorderRadius.circular(8),
// //             child: InputDecorator(
// //               decoration: InputDecoration(
// //                 isDense: true,
// //                 contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                   borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //                 ),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                   borderSide: BorderSide(
// //                     color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2),
// //                   ),
// //                 ),
// //                 fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// //                 filled: true,
// //                 suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black87),
// //               ),
// //               child: selectedValues.isEmpty
// //                   ? Text(
// //                       ProfileOptions.notComfortableLabel,
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
// //                     )
// //                   : Wrap(
// //                       spacing: 6,
// //                       runSpacing: 6,
// //                       children: selectedValues
// //                           .map(
// //                             (lang) => Container(
// //                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //                               decoration: BoxDecoration(
// //                                 color: const Color(0xFFF0F4FF),
// //                                 borderRadius: BorderRadius.circular(12),
// //                                 border: Border.all(color: const Color(0xFFD4DDF2)),
// //                               ),
// //                               child: Text(lang, style: const TextStyle(fontSize: 11)),
// //                             ),
// //                           )
// //                           .toList(),
// //                     ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> openLanguageSelector(
// //     BuildContext context,
// //     List<String> selectedValues,
// //     void Function(List<String>) onSaved,
// //   ) async {
// //     final temp = [...selectedValues];

// //     await showModalBottomSheet<void>(
// //       context: context,
// //       builder: (context) {
// //         return StatefulBuilder(
// //           builder: (context, setModalState) {
// //             return SafeArea(
// //               child: Padding(
// //                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     const Text('Select Languages', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
// //                     const SizedBox(height: 10),
// //                     ...languageOptions.map(
// //                       (lang) => CheckboxListTile(
// //                         dense: true,
// //                         value: temp.contains(lang),
// //                         onChanged: (checked) {
// //                           setModalState(() {
// //                             if (checked == true) {
// //                               if (!temp.contains(lang)) temp.add(lang);
// //                             } else {
// //                               temp.remove(lang);
// //                             }
// //                           });
// //                         },
// //                         title: Text(lang),
// //                         controlAffinity: ListTileControlAffinity.leading,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           onSaved(temp);
// //                           Navigator.pop(context);
// //                         },
// //                         child: const Text('Done'),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   Widget interestGroup({
// //     required String title,
// //     required bool expanded,
// //     required VoidCallback onToggle,
// //     required Map<String, bool> options,
// //     required double optionWidth,
// //     required void Function(String label, bool value) onChanged,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: const Color(0xFFECE4F4)),
// //       ),
// //       child: Column(
// //         children: [
// //           InkWell(
// //             onTap: onToggle,
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
// //             child: Container(
// //               height: 40,
// //               padding: const EdgeInsets.symmetric(horizontal: 14),
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(colors: [Color(0xFF19001F), Color(0xFF490040)]),
// //                 borderRadius: BorderRadius.vertical(
// //                   top: const Radius.circular(10),
// //                   bottom: expanded ? Radius.zero : const Radius.circular(10),
// //                 ),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Text(
// //                       title,
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 30,
// //                         fontWeight: FontWeight.w800,
// //                         height: 1.0,
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   CircleAvatar(
// //                     radius: 12,
// //                     backgroundColor: const Color(0xFFEACD71),
// //                     child: Icon(
// //                       expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
// //                       size: 16,
// //                       color: Colors.black87,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           if (expanded)
// //             Padding(
// //               padding: const EdgeInsets.all(10),
// //               child: Wrap(
// //                 spacing: 8,
// //                 runSpacing: 8,
// //                 children: options.entries
// //                     .map(
// //                       (entry) => OptionChip(
// //                         label: entry.key,
// //                         selected: entry.value,
// //                         width: optionWidth,
// //                         onTap: () => onChanged(entry.key, !entry.value),
// //                       ),
// //                     )
// //                     .toList(),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ==================== OPTION CHIP (clean) ====================

// // class OptionChip extends StatelessWidget {
// //   const OptionChip({
// //     super.key,
// //     required this.label,
// //     required this.selected,
// //     required this.width,
// //     required this.onTap,
// //   });

// //   final String label;
// //   final bool selected;
// //   final double width;
// //   final VoidCallback onTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(8),
// //       child: Container(
// //         width: width,
// //         height: 42,
// //         padding: const EdgeInsets.symmetric(horizontal: 10),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(8),
// //           border: Border.all(color: const Color(0xFFF1EBF8)),
// //         ),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: Text(
// //                 label,
// //                 overflow: TextOverflow.ellipsis,
// //                 style: const TextStyle(
// //                   color: Colors.black87,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ),
// //             Checkbox(
// //               value: selected,
// //               onChanged: (_) => onTap(),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(4),
// //               ),
// //               activeColor: const Color(0xFF47003D),
// //               side: const BorderSide(color: Color(0xFFE0D4EE)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }



// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';

// // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // // import 'package:beatflirt/Api_services/api_service.dart'; // Use the provided ApiService

// // // // // -----------------------------------------------------------------------------
// // // // // PROFILE OPTIONS (kept from your code)
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileOption {
// // // //   final String id;
// // // //   final String value;
// // // //   final String label;

// // // //   const ProfileOption({
// // // //     required this.id,
// // // //     required this.value,
// // // //     required this.label,
// // // //   });

// // // //   Map<String, dynamic> toJson() => {'id': id, 'value': value, 'label': label};
// // // // }

// // // // class ProfileOptions {
// // // //   static const String notComfortableValue = 'Im not comfortable sharing that';
// // // //   static const String notComfortableLabel = "I'm not comfortable sharing that.";

// // // //   static const ProfileOption notComfortable = ProfileOption(
// // // //     id: 'not_comfortable',
// // // //     value: notComfortableValue,
// // // //     label: notComfortableLabel,
// // // //   );

// // // //   static const List<ProfileOption> tattoos = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'none', value: 'None', label: 'None'),
// // // //     ProfileOption(id: 'one', value: 'One', label: 'One'),
// // // //     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
// // // //     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
// // // //     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
// // // //   ];

// // // //   static const List<ProfileOption> heightTypes = [
// // // //     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
// // // //     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
// // // //   ];

// // // //   static const List<ProfileOption> weightTypes = [
// // // //     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
// // // //     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
// // // //   ];

// // // //   static const List<ProfileOption> bodyTypes = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
// // // //     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
// // // //     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
// // // //     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
// // // //     ProfileOption(id: 'huggable_and_heavy', value: 'Huggable and Heavy', label: 'Huggable and Heavy'),
// // // //     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
// // // //     ProfileOption(id: 'more_of_me_to_love', value: 'More of me to love', label: 'More of me to love'),
// // // //     ProfileOption(id: 'nicely_shaped', value: 'Nicely Shaped', label: 'Nicely Shaped'),
// // // //     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
// // // //   ];

// // // //   static const List<ProfileOption> smoking = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'occasionally', value: 'Occasionally', label: 'Occasionally'),
// // // //   ];

// // // //   static const List<ProfileOption> drinking = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'occasionally', value: 'Occasionally', label: 'Occasionally'),
// // // //   ];

// // // //   static const List<ProfileOption> ethnicBackgrounds = [ /* ... full list as you provided ... */ notComfortable /* truncated for brevity, use your full list */ ];

// // // //   static const List<ProfileOption> importanceLevels = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'low_importance', value: 'Low Importance', label: 'Low Importance'),
// // // //     ProfileOption(id: 'medium_importance', value: 'Medium Importance', label: 'Medium Importance'),
// // // //     ProfileOption(id: 'very_important', value: 'Very Important', label: 'Very Important'),
// // // //   ];

// // // //   static const List<ProfileOption> sexualities = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
// // // //     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
// // // //     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
// // // //     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
// // // //     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
// // // //     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
// // // //     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
// // // //     ProfileOption(id: 'transsexual', value: 'Transsexual', label: 'Transsexual'),
// // // //   ];

// // // //   static const List<ProfileOption> relationshipOrientations = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
// // // //     ProfileOption(id: 'open_minded', value: 'Open-Minded', label: 'Open-Minded'),
// // // //     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
// // // //     ProfileOption(id: 'polyamorous', value: 'Polyamorous', label: 'Polyamorous'),
// // // //   ];

// // // //   static const List<ProfileOption> circumcised = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //   ];

// // // //   static const List<ProfileOption> piercings = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //   ];

// // // //   static const List<ProfileOption> bodyHair = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
// // // //     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
// // // //     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
// // // //     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
// // // //   ];

// // // //   static const Map<String, List<ProfileOption>> groups = {
// // // //     'tattoos': tattoos,
// // // //     'height_types': heightTypes,
// // // //     'weight_types': weightTypes,
// // // //     'body_types': bodyTypes,
// // // //     'smoking': smoking,
// // // //     'drinking': drinking,
// // // //     'ethnic_backgrounds': ethnicBackgrounds,
// // // //     'importance_levels': importanceLevels,
// // // //     'sexualities': sexualities,
// // // //     'relationship_orientations': relationshipOrientations,
// // // //     'circumcised': circumcised,
// // // //     'piercings': piercings,
// // // //     'body_hair': bodyHair,
// // // //   };
// // // // }

// // // // class ProfileFieldOptions {
// // // //   static const Map<String, String> fieldGroupMap = { /* your full map */ };

// // // //   static List<ProfileOption> getOptionsForField(String fieldName) {
// // // //     final groupKey = fieldGroupMap[fieldName];
// // // //     if (groupKey == null) return [];
// // // //     return ProfileOptions.groups[groupKey] ?? [];
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // STATE
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileEditState {
// // // //   final bool isProfileDetailsTab;
// // // //   final Map<String, bool> swingersOptions;
// // // //   final Map<String, bool> hookupOptions;
// // // //   final bool isSwingersExpanded;
// // // //   final bool isHookupExpanded;
// // // //   final String aboutMe;
// // // //   final String lookingFor;
// // // //   final Map<String, String> partner1;
// // // //   final Map<String, String> partner2;
// // // //   final List<String> partner1Languages;
// // // //   final List<String> partner2Languages;
// // // //   final bool isLoading;
// // // //   final Map<String, dynamic>? linkedPartner;

// // // //   const ProfileEditState({
// // // //     this.isProfileDetailsTab = false,
// // // //     required this.swingersOptions,
// // // //     required this.hookupOptions,
// // // //     this.isSwingersExpanded = true,
// // // //     this.isHookupExpanded = true,
// // // //     this.aboutMe = '',
// // // //     this.lookingFor = '',
// // // //     required this.partner1,
// // // //     required this.partner2,
// // // //     required this.partner1Languages,
// // // //     required this.partner2Languages,
// // // //     this.isLoading = false,
// // // //     this.linkedPartner,
// // // //   });

// // // //   ProfileEditState copyWith({
// // // //     bool? isProfileDetailsTab,
// // // //     Map<String, bool>? swingersOptions,
// // // //     Map<String, bool>? hookupOptions,
// // // //     bool? isSwingersExpanded,
// // // //     bool? isHookupExpanded,
// // // //     String? aboutMe,
// // // //     String? lookingFor,
// // // //     Map<String, String>? partner1,
// // // //     Map<String, String>? partner2,
// // // //     List<String>? partner1Languages,
// // // //     List<String>? partner2Languages,
// // // //     bool? isLoading,
// // // //     Map<String, dynamic>? linkedPartner,
// // // //   }) {
// // // //     return ProfileEditState(
// // // //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// // // //       swingersOptions: swingersOptions ?? this.swingersOptions,
// // // //       hookupOptions: hookupOptions ?? this.hookupOptions,
// // // //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// // // //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// // // //       aboutMe: aboutMe ?? this.aboutMe,
// // // //       lookingFor: lookingFor ?? this.lookingFor,
// // // //       partner1: partner1 ?? this.partner1,
// // // //       partner2: partner2 ?? this.partner2,
// // // //       partner1Languages: partner1Languages ?? this.partner1Languages,
// // // //       partner2Languages: partner2Languages ?? this.partner2Languages,
// // // //       isLoading: isLoading ?? this.isLoading,
// // // //       linkedPartner: linkedPartner ?? this.linkedPartner,
// // // //     );
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // CLEAN PROFILE DETAILS SAVE USING YOUR ApiService HEADERS
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileDetailsSaver {
// // // //   static const String singleUrl = 'https://app.beatflirtevent.com/App/user/edit_single_profile_details';
// // // //   static const String coupleUrl = 'https://app.beatflirtevent.com/App/user/edit_couple_profile_details';

// // // //   static Future<bool> save({
// // // //     required String token,
// // // //     required ProfileEditState state,
// // // //   }) async {
// // // //     final isCouple = state.linkedPartner != null;
// // // //     final url = isCouple ? coupleUrl : singleUrl;

// // // //     final payload = _buildPayload(state);

// // // //     debugPrint('========== SAVING PROFILE DETAILS ==========');
// // // //     debugPrint('URL: $url');
// // // //     debugPrint('IS COUPLE: $isCouple');
// // // //     debugPrint('TOKEN length: ${token.length}');

// // // //     // Build headers exactly like in your ApiService (manual to avoid private access)
// // // //     final headers = <String, String>{
// // // //       'Content-Type': 'application/x-www-form-urlencoded',
// // // //       'Accept': 'application/json',
// // // //     };
// // // //     if (token.isNotEmpty) {
// // // //       headers['Authorization'] = 'Bearer $token';
// // // //       headers['access-token'] = token;
// // // //     }

// // // //     // Add token variants in body for maximum compatibility
// // // //     final body = {
// // // //       ...payload,
// // // //       'token': token,
// // // //       'Authtoken': token,
// // // //     };

// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse(url),
// // // //         headers: headers,
// // // //         body: body,
// // // //       );

// // // //       debugPrint('SAVE STATUS: ${response.statusCode}');
// // // //       debugPrint('SAVE BODY: ${response.body}');

// // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // //         try {
// // // //           final decoded = jsonDecode(response.body);
// // // //           if (decoded is Map<String, dynamic>) {
// // // //             final status = decoded['status']?.toString();
// // // //             final message = decoded['message']?.toString() ?? '';
// // // //             if (status == '200' || message.toLowerCase().contains('success')) {
// // // //               debugPrint('✅ Profile details saved successfully');
// // // //               return true;
// // // //             }
// // // //           }
// // // //         } catch (_) {}
// // // //       }
// // // //       return false;
// // // //     } catch (e) {
// // // //       debugPrint('SAVE ERROR: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Map<String, String> _buildPayload(ProfileEditState state) {
// // // //     final p1 = state.partner1;
// // // //     final p2 = state.partner2;
// // // //     final isCouple = state.linkedPartner != null;

// // // //     final payload = <String, String>{
// // // //       'text': state.aboutMe,
// // // //       'comment': state.lookingFor,
// // // //       'person1_name': '',
// // // //       'person1_dob': p1['dateOfBirth'] ?? '',
// // // //       'person1_height': p1['height'] ?? '',
// // // //       'height1_type': p1['heightType'] ?? '',
// // // //       'person1_weight': p1['weight'] ?? '',
// // // //       'weight1_type': p1['weightType'] ?? '',
// // // //       'person1_body_type': p1['bodyType'] ?? '',
// // // //       'person1_ethnic_background': p1['ethnic'] ?? '',
// // // //       'person1_sexuality': p1['sexuality'] ?? '',
// // // //       'person1_relationship_orientation': p1['orientation'] ?? '',
// // // //       'person1_tattoos': p1['tattoos'] ?? '',
// // // //       'person1_piercings': p1['piercings'] ?? '',
// // // //       'person1_smoking': p1['smoking'] ?? '',
// // // //       'person1_drinking': p1['drinking'] ?? '',
// // // //       'person1_body_hair': jsonEncode([p1['bodyHair'] ?? '']),
// // // //       'person1_looks_important': p1['looks'] ?? '',
// // // //       'person1_intelligence_importance': p1['intelligence'] ?? '',
// // // //       'person1_circumcised': p1['circumcised'] ?? '',
// // // //       'person1_language_spoken': jsonEncode(state.partner1Languages),
// // // //     };

// // // //     if (isCouple) {
// // // //       payload.addAll({
// // // //         'person2_name': '',
// // // //         'person2_dob': p2['dateOfBirth'] ?? '',
// // // //         'person2_height': p2['height'] ?? '',
// // // //         'height2_type': p2['heightType'] ?? '',
// // // //         'person2_weight': p2['weight'] ?? '',
// // // //         'weight2_type': p2['weightType'] ?? '',
// // // //         'person2_body_type': p2['bodyType'] ?? '',
// // // //         'person2_ethnic_background': p2['ethnic'] ?? '',
// // // //         'person2_sexuality': p2['sexuality'] ?? '',
// // // //         'person2_relationship_orientation': p2['orientation'] ?? '',
// // // //         'person2_tattoos': p2['tattoos'] ?? '',
// // // //         'person2_piercings': p2['piercings'] ?? '',
// // // //         'person2_smoking': p2['smoking'] ?? '',
// // // //         'person2_drinking': p2['drinking'] ?? '',
// // // //         'person2_body_hair': jsonEncode([p2['bodyHair'] ?? '']),
// // // //         'person2_looks_important': p2['looks'] ?? '',
// // // //         'person2_intelligence_importance': p2['intelligence'] ?? '',
// // // //         'person2_circumcised': p2['circumcised'] ?? '',
// // // //         'person2_language_spoken': jsonEncode(state.partner2Languages),
// // // //       });
// // // //     }

// // // //     return payload;
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // NOTIFIER
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // // //   @override
// // // //   ProfileEditState build() {
// // // //     Future.microtask(() => loadProfile());
// // // //     return ProfileEditState(
// // // //       swingersOptions: {
// // // //         'Couple Female/Male': true,
// // // //         'Couple Female/Female': true,
// // // //         'Couple Male/Male': true,
// // // //         'Female': true,
// // // //         'Male': true,
// // // //         'Transgender': true,
// // // //       },
// // // //       hookupOptions: {
// // // //         'Couple Female/Male': true,
// // // //         'Couple Female/Female': true,
// // // //         'Couple Male/Male': true,
// // // //         'Female': true,
// // // //         'Male': true,
// // // //         'Transgender': false,
// // // //       },
// // // //       partner1: defaultPartnerTraits(),
// // // //       partner2: defaultPartnerTraits(),
// // // //       partner1Languages: [],
// // // //       partner2Languages: [],
// // // //     );
// // // //   }

// // // //   Future<void> loadProfile() async {
// // // //     final String? token = await AuthService.getToken();
// // // //     if (token == null || token.isEmpty) {
// // // //       debugPrint('No token found');
// // // //       return;
// // // //     }
// // // //     state = state.copyWith(isLoading: true);
// // // //     try {
// // // //       // You can call ApiService().getSingleUserProfile(token: token) here if you want to load data
// // // //       // For now we keep it light since you are focusing on save.
// // // //     } catch (e) {
// // // //       debugPrint('Error loading profile: $e');
// // // //     } finally {
// // // //       state = state.copyWith(isLoading: false);
// // // //     }
// // // //   }

// // // //   Future<void> saveProfile() async {
// // // //     final String? token = await AuthService.getToken();

// // // //     if (token == null || token.isEmpty) {
// // // //       Get.snackbar('Error', 'User token not found',
// // // //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // // //       return;
// // // //     }

// // // //     state = state.copyWith(isLoading: true);

// // // //     try {
// // // //       if (state.isProfileDetailsTab) {
// // // //         final success = await ProfileDetailsSaver.save(
// // // //           token: token,
// // // //           state: state,
// // // //         );

// // // //         if (success) {
// // // //           Get.snackbar('Success', 'Profile updated successfully',
// // // //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// // // //         } else {
// // // //           Get.snackbar('Error', 'Failed to update profile. Check console for "Please Provide Token" or other errors.',
// // // //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // // //         }
// // // //       } else {
// // // //         Get.snackbar('Success', 'Interests saved successfully',
// // // //             snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error saving profile: $e');
// // // //       Get.snackbar('Error', 'Failed to update profile: $e',
// // // //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // // //     } finally {
// // // //       state = state.copyWith(isLoading: false);
// // // //     }
// // // //   }

// // // //   // All toggle / update methods - fully implemented
// // // //   void toggleProfileTab(bool isProfile) {
// // // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // // //   }

// // // //   void toggleSwingersExpanded() {
// // // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // // //   }

// // // //   void toggleHookupExpanded() {
// // // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // // //   }

// // // //   void updateSwingersOption(String label, bool value) {
// // // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // // //     newOptions[label] = value;
// // // //     state = state.copyWith(swingersOptions: newOptions);
// // // //   }

// // // //   void updateHookupOption(String label, bool value) {
// // // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // // //     newOptions[label] = value;
// // // //     state = state.copyWith(hookupOptions: newOptions);
// // // //   }

// // // //   void updateAboutMe(String value) {
// // // //     state = state.copyWith(aboutMe: value);
// // // //   }

// // // //   void updateLookingFor(String value) {
// // // //     state = state.copyWith(lookingFor: value);
// // // //   }

// // // //   void updatePartner1(String key, String value) {
// // // //     final newPartner = Map<String, String>.from(state.partner1);
// // // //     newPartner[key] = value;
// // // //     state = state.copyWith(partner1: newPartner);
// // // //   }

// // // //   void updatePartner2(String key, String value) {
// // // //     final newPartner = Map<String, String>.from(state.partner2);
// // // //     newPartner[key] = value;
// // // //     state = state.copyWith(partner2: newPartner);
// // // //   }

// // // //   void updatePartner1Languages(List<String> langs) {
// // // //     state = state.copyWith(partner1Languages: langs);
// // // //   }

// // // //   void updatePartner2Languages(List<String> langs) {
// // // //     state = state.copyWith(partner2Languages: langs);
// // // //   }

// // // //   Map<String, String> defaultPartnerTraits() {
// // // //     return {
// // // //       'dateOfBirth': '',
// // // //       'height': '',
// // // //       'heightType': '',
// // // //       'weight': '',
// // // //       'weightType': '',
// // // //       'bodyType': ProfileOptions.notComfortableValue,
// // // //       'ethnic': ProfileOptions.notComfortableValue,
// // // //       'sexuality': ProfileOptions.notComfortableValue,
// // // //       'orientation': ProfileOptions.notComfortableValue,
// // // //       'tattoos': ProfileOptions.notComfortableValue,
// // // //       'piercings': ProfileOptions.notComfortableValue,
// // // //       'smoking': ProfileOptions.notComfortableValue,
// // // //       'drinking': ProfileOptions.notComfortableValue,
// // // //       'bodyHair': ProfileOptions.notComfortableValue,
// // // //       'looks': ProfileOptions.notComfortableValue,
// // // //       'intelligence': ProfileOptions.notComfortableValue,
// // // //       'circumcised': ProfileOptions.notComfortableValue,
// // // //     };
// // // //   }
// // // // }

// // // // final profileEditProvider = NotifierProvider<ProfileEditNotifier, ProfileEditState>(ProfileEditNotifier.new);

// // // // // -----------------------------------------------------------------------------
// // // // // WIDGET
// // // // // -----------------------------------------------------------------------------

// // // // class MyProfileEditTab extends ConsumerWidget {
// // // //   const MyProfileEditTab({super.key});

// // // //   static const List<String> languageOptions = [
// // // //     'English',
// // // //     'Hindi',
// // // //     'German',
// // // //     'French',
// // // //     'Spanish',
// // // //   ];

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final profileState = ref.watch(profileEditProvider);
// // // //     final notifier = ref.read(profileEditProvider.notifier);

// // // //     return LayoutBuilder(
// // // //       builder: (context, constraints) {
// // // //         final double width = constraints.maxWidth;
// // // //         final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
// // // //         final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;

// // // //         return Container(
// // // //           width: double.infinity,
// // // //           constraints: BoxConstraints(
// // // //             minHeight: MediaQuery.of(context).size.height * 0.62,
// // // //           ),
// // // //           padding: const EdgeInsets.all(16),
// // // //           decoration: BoxDecoration(
// // // //             color: Colors.white,
// // // //             borderRadius: BorderRadius.circular(14),
// // // //             border: Border.all(color: const Color(0xFFE8E0F2)),
// // // //           ),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               if (profileState.isLoading)
// // // //                 const Padding(
// // // //                   padding: EdgeInsets.only(bottom: 10),
// // // //                   child: LinearProgressIndicator(color: Colors.pink),
// // // //                 ),
// // // //               sectionHeader(profileState, notifier),
// // // //               const SizedBox(height: 16),
// // // //               if (profileState.isProfileDetailsTab)
// // // //                 buildProfileDetailsContent(
// // // //                   context,
// // // //                   width,
// // // //                   profileState,
// // // //                   notifier,
// // // //                 )
// // // //               else
// // // //                 buildInterestsContent(optionWidth, profileState, notifier),
// // // //               const SizedBox(height: 18),
// // // //               Center(
// // // //                 child: SizedBox(
// // // //                   width: 170,
// // // //                   child: ElevatedButton(
// // // //                     onPressed: profileState.isLoading
// // // //                         ? null
// // // //                         : () => notifier.saveProfile(),
// // // //                     style: ElevatedButton.styleFrom(
// // // //                       elevation: 4,
// // // //                       padding: const EdgeInsets.symmetric(vertical: 12),
// // // //                       backgroundColor: const Color(0xFF220027),
// // // //                       foregroundColor: Colors.white,
// // // //                       shape: RoundedRectangleBorder(
// // // //                         borderRadius: BorderRadius.circular(22),
// // // //                       ),
// // // //                     ),
// // // //                     child: profileState.isLoading
// // // //                         ? const SizedBox(
// // // //                             height: 20,
// // // //                             width: 20,
// // // //                             child: CircularProgressIndicator(
// // // //                               color: Colors.white,
// // // //                               strokeWidth: 2,
// // // //                             ),
// // // //                           )
// // // //                         : Text(
// // // //                             profileState.isProfileDetailsTab
// // // //                                 ? 'Save Profile'
// // // //                                 : 'Save Interest',
// // // //                             style: const TextStyle(
// // // //                               fontWeight: FontWeight.w700,
// // // //                               fontSize: 12,
// // // //                             ),
// // // //                           ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(height: 6),
// // // //             ],
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }

// // // //   Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
// // // //     return Container(
// // // //       height: 38,
// // // //       padding: const EdgeInsets.symmetric(horizontal: 8),
// // // //       decoration: BoxDecoration(
// // // //         gradient: const LinearGradient(
// // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // //         ),
// // // //         borderRadius: BorderRadius.circular(22),
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           InkWell(
// // // //             borderRadius: BorderRadius.circular(16),
// // // //             onTap: () => notifier.toggleProfileTab(false),
// // // //             child: Container(
// // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // //               decoration: BoxDecoration(
// // // //                 color: !state.isProfileDetailsTab
// // // //                     ? const Color(0xFFFF2D87)
// // // //                     : Colors.transparent,
// // // //                 borderRadius: BorderRadius.circular(16),
// // // //               ),
// // // //               child: const Text(
// // // //                 'INTERESTS',
// // // //                 style: TextStyle(
// // // //                   color: Colors.white,
// // // //                   fontSize: 11,
// // // //                   fontWeight: FontWeight.w700,
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //           const Spacer(),
// // // //           InkWell(
// // // //             borderRadius: BorderRadius.circular(16),
// // // //             onTap: () => notifier.toggleProfileTab(true),
// // // //             child: Container(
// // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // //               decoration: BoxDecoration(
// // // //                 color: state.isProfileDetailsTab
// // // //                     ? const Color(0xFFFF2D87)
// // // //                     : Colors.transparent,
// // // //                 borderRadius: BorderRadius.circular(16),
// // // //               ),
// // // //               child: const Text(
// // // //                 'PROFILE DETAILS',
// // // //                 style: TextStyle(
// // // //                   color: Colors.white,
// // // //                   fontSize: 12,
// // // //                   fontWeight: FontWeight.w700,
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget buildInterestsContent(
// // // //     double optionWidth,
// // // //     ProfileEditState state,
// // // //     ProfileEditNotifier notifier,
// // // //   ) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         const Text(
// // // //           'davidbrown',
// // // //           style: TextStyle(
// // // //             fontWeight: FontWeight.w700,
// // // //             fontSize: 34,
// // // //             height: 1.05,
// // // //           ),
// // // //         ),
// // // //         const SizedBox(height: 8),
// // // //         Text(
// // // //           'What are you looking for? Select all that apply',
// // // //           style: TextStyle(
// // // //             color: Colors.grey[700],
// // // //             fontSize: 14,
// // // //             fontWeight: FontWeight.w500,
// // // //           ),
// // // //         ),
// // // //         const SizedBox(height: 16),
// // // //         interestGroup(
// // // //           title: 'Swingers',
// // // //           expanded: state.isSwingersExpanded,
// // // //           onToggle: notifier.toggleSwingersExpanded,
// // // //           options: state.swingersOptions,
// // // //           optionWidth: optionWidth,
// // // //           onChanged: (label, value) =>
// // // //               notifier.updateSwingersOption(label, value),
// // // //         ),
// // // //         const SizedBox(height: 12),
// // // //         interestGroup(
// // // //           title: 'Hookup / Meetup',
// // // //           expanded: state.isHookupExpanded,
// // // //           onToggle: notifier.toggleHookupExpanded,
// // // //           options: state.hookupOptions,
// // // //           optionWidth: optionWidth,
// // // //           onChanged: (label, value) =>
// // // //               notifier.updateHookupOption(label, value),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget buildProfileDetailsContent(
// // // //     BuildContext context,
// // // //     double width,
// // // //     ProfileEditState state,
// // // //     ProfileEditNotifier notifier,
// // // //   ) {
// // // //     final bool stacked = width < 760;
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         textFieldLabel('INTRODUCE YOURSELF'),
// // // //         const SizedBox(height: 6),
// // // //         simpleTextField(
// // // //           label: 'About Me',
// // // //           initialValue: state.aboutMe,
// // // //           onChanged: notifier.updateAboutMe,
// // // //         ),
// // // //         const SizedBox(height: 10),
// // // //         textFieldLabel('LOOKING FOR'),
// // // //         const SizedBox(height: 6),
// // // //         simpleTextField(
// // // //           label: 'Looking For',
// // // //           initialValue: state.lookingFor,
// // // //           maxLines: 2,
// // // //           onChanged: notifier.updateLookingFor,
// // // //         ),
// // // //         const SizedBox(height: 14),
// // // //         const Center(
// // // //           child: Text(
// // // //             'About Yourselves',
// // // //             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
// // // //           ),
// // // //         ),
// // // //         const SizedBox(height: 12),
// // // //         if (stacked)
// // // //           Column(
// // // //             children: [
// // // //               partnerPanel(
// // // //                 context: context,
// // // //                 title: 'Partner 1',
// // // //                 data: state.partner1,
// // // //                 languages: state.partner1Languages,
// // // //                 onFieldChanged: notifier.updatePartner1,
// // // //                 onLanguagesChanged: notifier.updatePartner1Languages,
// // // //               ),
// // // //               const SizedBox(height: 12),
// // // //               partnerPanel(
// // // //                 context: context,
// // // //                 title: 'Partner 2',
// // // //                 data: state.partner2,
// // // //                 languages: state.partner2Languages,
// // // //                 onFieldChanged: notifier.updatePartner2,
// // // //                 onLanguagesChanged: notifier.updatePartner2Languages,
// // // //                 readOnly: true,
// // // //               ),
// // // //             ],
// // // //           )
// // // //         else
// // // //           Row(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               Expanded(
// // // //                 child: partnerPanel(
// // // //                   context: context,
// // // //                   title: 'Partner 1',
// // // //                   data: state.partner1,
// // // //                   languages: state.partner1Languages,
// // // //                   onFieldChanged: notifier.updatePartner1,
// // // //                   onLanguagesChanged: notifier.updatePartner1Languages,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 12),
// // // //               Expanded(
// // // //                 child: partnerPanel(
// // // //                   context: context,
// // // //                   title: 'Partner 2',
// // // //                   data: state.partner2,
// // // //                   languages: state.partner2Languages,
// // // //                   onFieldChanged: notifier.updatePartner2,
// // // //                   onLanguagesChanged: notifier.updatePartner2Languages,
// // // //                   readOnly: true,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget partnerPanel({
// // // //     required BuildContext context,
// // // //     required String title,
// // // //     required Map<String, String> data,
// // // //     required List<String> languages,
// // // //     required void Function(String, String) onFieldChanged,
// // // //     required void Function(List<String>) onLanguagesChanged,
// // // //     bool readOnly = false,
// // // //   }) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         Container(
// // // //           height: 34,
// // // //           alignment: Alignment.center,
// // // //           decoration: BoxDecoration(
// // // //             gradient: const LinearGradient(
// // // //               colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // //             ),
// // // //             borderRadius: BorderRadius.circular(10),
// // // //           ),
// // // //           child: Text(
// // // //             title,
// // // //             style: const TextStyle(
// // // //               color: Colors.white,
// // // //               fontWeight: FontWeight.w700,
// // // //             ),
// // // //           ),
// // // //         ),
// // // //         const SizedBox(height: 10),
// // // //         dateOfBirthField(
// // // //           context: context,
// // // //           label: 'DATE OF BIRTH',
// // // //           data: data,
// // // //           keyName: 'dateOfBirth',
// // // //           onFieldChanged: onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         heightInputField(
// // // //           data: data,
// // // //           onFieldChanged: onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         weightInputField(
// // // //           data: data,
// // // //           onFieldChanged: onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'BODY TYPE',
// // // //           data,
// // // //           'bodyType',
// // // //           ProfileOptions.bodyTypes,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'ETHNIC BACKGROUND',
// // // //           data,
// // // //           'ethnic',
// // // //           ProfileOptions.ethnicBackgrounds,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'SEXUALITY',
// // // //           data,
// // // //           'sexuality',
// // // //           ProfileOptions.sexualities,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'RELATIONSHIP ORIENTATION',
// // // //           data,
// // // //           'orientation',
// // // //           ProfileOptions.relationshipOrientations,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'TATTOOS',
// // // //           data,
// // // //           'tattoos',
// // // //           ProfileOptions.tattoos,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'PIERCINGS',
// // // //           data,
// // // //           'piercings',
// // // //           ProfileOptions.piercings,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'SMOKING',
// // // //           data,
// // // //           'smoking',
// // // //           ProfileOptions.smoking,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'DRINKING',
// // // //           data,
// // // //           'drinking',
// // // //           ProfileOptions.drinking,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'BODY HAIR',
// // // //           data,
// // // //           'bodyHair',
// // // //           ProfileOptions.bodyHair,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         languagesField(
// // // //           context,
// // // //           'LANGUAGES SPOKEN',
// // // //           languages,
// // // //           onLanguagesChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'LOOKS IMPORTANCE',
// // // //           data,
// // // //           'looks',
// // // //           ProfileOptions.importanceLevels,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'INTELLIGENCE IMPORTANCE',
// // // //           data,
// // // //           'intelligence',
// // // //           ProfileOptions.importanceLevels,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //         profileOptionDropdownField(
// // // //           'CIRCUMCISED',
// // // //           data,
// // // //           'circumcised',
// // // //           ProfileOptions.circumcised,
// // // //           onFieldChanged,
// // // //           readOnly: readOnly,
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:get/get.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';

// // // import 'package:beatflirt/core/services/auth_services.dart';

// // // // -----------------------------------------------------------------------------
// // // // PROFILE OPTIONS (kept from your code, with expanded languages)
// // // // -----------------------------------------------------------------------------

// // // class ProfileOption {
// // //   final String id;
// // //   final String value;
// // //   final String label;

// // //   const ProfileOption({
// // //     required this.id,
// // //     required this.value,
// // //     required this.label,
// // //   });

// // //   Map<String, dynamic> toJson() => {'id': id, 'value': value, 'label': label};
// // // }

// // // class ProfileOptions {
// // //   static const String notComfortableValue = 'Im not comfortable sharing that';
// // //   static const String notComfortableLabel = "I'm not comfortable sharing that.";

// // //   static const ProfileOption notComfortable = ProfileOption(
// // //     id: 'not_comfortable',
// // //     value: notComfortableValue,
// // //     label: notComfortableLabel,
// // //   );

// // //   static const List<ProfileOption> tattoos = [
// // //     notComfortable,
// // //     ProfileOption(id: 'none', value: 'None', label: 'None'),
// // //     ProfileOption(id: 'one', value: 'One', label: 'One'),
// // //     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
// // //     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
// // //     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
// // //   ];

// // //   static const List<ProfileOption> heightTypes = [
// // //     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
// // //     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
// // //   ];

// // //   static const List<ProfileOption> weightTypes = [
// // //     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
// // //     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
// // //   ];

// // //   static const List<ProfileOption> bodyTypes = [
// // //     notComfortable,
// // //     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
// // //     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
// // //     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
// // //     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
// // //     ProfileOption(id: 'huggable_and_heavy', value: 'Huggable and Heavy', label: 'Huggable and Heavy'),
// // //     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
// // //     ProfileOption(id: 'more_of_me_to_love', value: 'More of me to love', label: 'More of me to love'),
// // //     ProfileOption(id: 'nicely_shaped', value: 'Nicely Shaped', label: 'Nicely Shaped'),
// // //     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
// // //   ];

// // //   static const List<ProfileOption> smoking = [
// // //     notComfortable,
// // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // //     ProfileOption(id: 'occasionally', value: 'Occasionally', label: 'Occasionally'),
// // //   ];

// // //   static const List<ProfileOption> drinking = [
// // //     notComfortable,
// // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // //     ProfileOption(id: 'occasionally', value: 'Occasionally', label: 'Occasionally'),
// // //   ];

// // //   static const List<ProfileOption> ethnicBackgrounds = [
// // //     notComfortable,
// // //     ProfileOption(id: 'other', value: 'Other', label: 'Other'),
// // //     ProfileOption(id: 'american', value: 'American', label: 'American'),
// // //     ProfileOption(id: 'argentine_argentinian', value: 'Argentine/Argentinian', label: 'Argentine/Argentinian'),
// // //     ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
// // //     ProfileOption(id: 'black_african_american', value: 'Black/African - American', label: 'Black/African - American'),
// // //     ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
// // //     ProfileOption(id: 'british', value: 'British', label: 'British'),
// // //     ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
// // //     ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
// // //     ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
// // //     ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
// // //     ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
// // //     ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
// // //     ProfileOption(id: 'french', value: 'French', label: 'French'),
// // //     ProfileOption(id: 'german', value: 'German', label: 'German'),
// // //     ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
// // //     ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
// // //     ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
// // //     ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
// // //     ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
// // //     ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
// // //     ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
// // //     ProfileOption(id: 'new_zealander_kiwi', value: 'New Zealander/Kiwi', label: 'New Zealander/Kiwi'),
// // //     ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
// // //     ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
// // //     ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
// // //     ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
// // //     ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
// // //     ProfileOption(id: 'south_african', value: 'South African', label: 'South African'),
// // //     ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
// // //     ProfileOption(id: 'sri_lankan', value: 'Sri Lankan', label: 'Sri Lankan'),
// // //     ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
// // //     ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
// // //   ];

// // //   static const List<ProfileOption> importanceLevels = [
// // //     notComfortable,
// // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // //     ProfileOption(id: 'low_importance', value: 'Low Importance', label: 'Low Importance'),
// // //     ProfileOption(id: 'medium_importance', value: 'Medium Importance', label: 'Medium Importance'),
// // //     ProfileOption(id: 'very_important', value: 'Very Important', label: 'Very Important'),
// // //   ];

// // //   static const List<ProfileOption> sexualities = [
// // //     notComfortable,
// // //     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
// // //     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
// // //     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
// // //     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
// // //     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
// // //     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
// // //     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
// // //     ProfileOption(id: 'transsexual', value: 'Transsexual', label: 'Transsexual'),
// // //   ];

// // //   static const List<ProfileOption> relationshipOrientations = [
// // //     notComfortable,
// // //     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
// // //     ProfileOption(id: 'open_minded', value: 'Open-Minded', label: 'Open-Minded'),
// // //     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
// // //     ProfileOption(id: 'polyamorous', value: 'Polyamorous', label: 'Polyamorous'),
// // //   ];

// // //   static const List<ProfileOption> circumcised = [
// // //     notComfortable,
// // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // //   ];

// // //   static const List<ProfileOption> piercings = [
// // //     notComfortable,
// // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // //   ];

// // //   static const List<ProfileOption> bodyHair = [
// // //     notComfortable,
// // //     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
// // //     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
// // //     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
// // //     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
// // //   ];

// // //   static const Map<String, List<ProfileOption>> groups = {
// // //     'tattoos': tattoos,
// // //     'height_types': heightTypes,
// // //     'weight_types': weightTypes,
// // //     'body_types': bodyTypes,
// // //     'smoking': smoking,
// // //     'drinking': drinking,
// // //     'ethnic_backgrounds': ethnicBackgrounds,
// // //     'importance_levels': importanceLevels,
// // //     'sexualities': sexualities,
// // //     'relationship_orientations': relationshipOrientations,
// // //     'circumcised': circumcised,
// // //     'piercings': piercings,
// // //     'body_hair': bodyHair,
// // //   };
// // // }

// // // class ProfileFieldOptions {
// // //   static const Map<String, String> fieldGroupMap = {
// // //     'bodyType': 'body_types',
// // //     'ethnic': 'ethnic_backgrounds',
// // //     'sexuality': 'sexualities',
// // //     'orientation': 'relationship_orientations',
// // //     'tattoos': 'tattoos',
// // //     'piercings': 'piercings',
// // //     'smoking': 'smoking',
// // //     'drinking': 'drinking',
// // //     'bodyHair': 'body_hair',
// // //     'looks': 'importance_levels',
// // //     'intelligence': 'importance_levels',
// // //     'circumcised': 'circumcised',
// // //     'person1_tattoos': 'tattoos',
// // //     'person2_tattoos': 'tattoos',
// // //     'person1_height_type': 'height_types',
// // //     'person2_height_type': 'height_types',
// // //     'person1_weight_type': 'weight_types',
// // //     'person2_weight_type': 'weight_types',
// // //     'person1_body_type': 'body_types',
// // //     'person2_body_type': 'body_types',
// // //     'person1_smoking': 'smoking',
// // //     'person2_smoking': 'smoking',
// // //     'person1_drinking': 'drinking',
// // //     'person2_drinking': 'drinking',
// // //     'person1_ethnic_background': 'ethnic_backgrounds',
// // //     'person2_ethnic_background': 'ethnic_backgrounds',
// // //     'person1_looks_important': 'importance_levels',
// // //     'person2_looks_important': 'importance_levels',
// // //     'person1_intelligence_importance': 'importance_levels',
// // //     'person2_intelligence_importance': 'importance_levels',
// // //     'person1_sexuality': 'sexualities',
// // //     'person2_sexuality': 'sexualities',
// // //     'person1_relationship_orientation': 'relationship_orientations',
// // //     'person2_relationship_orientation': 'relationship_orientations',
// // //     'person1_circumcised': 'circumcised',
// // //     'person2_circumcised': 'circumcised',
// // //     'person1_piercings': 'piercings',
// // //     'person2_piercings': 'piercings',
// // //   };

// // //   static List<ProfileOption> getOptionsForField(String fieldName) {
// // //     final groupKey = fieldGroupMap[fieldName];
// // //     if (groupKey == null) return [];
// // //     return ProfileOptions.groups[groupKey] ?? [];
// // //   }
// // // }

// // // // -----------------------------------------------------------------------------
// // // // STATE
// // // // -----------------------------------------------------------------------------

// // // class ProfileEditState {
// // //   final bool isProfileDetailsTab;
// // //   final Map<String, bool> swingersOptions;
// // //   final Map<String, bool> hookupOptions;
// // //   final bool isSwingersExpanded;
// // //   final bool isHookupExpanded;
// // //   final String aboutMe;
// // //   final String lookingFor;
// // //   final Map<String, String> partner1;
// // //   final Map<String, String> partner2;
// // //   final List<String> partner1Languages;
// // //   final List<String> partner2Languages;
// // //   final bool isLoading;
// // //   final Map<String, dynamic>? linkedPartner;

// // //   const ProfileEditState({
// // //     this.isProfileDetailsTab = false,
// // //     required this.swingersOptions,
// // //     required this.hookupOptions,
// // //     this.isSwingersExpanded = true,
// // //     this.isHookupExpanded = true,
// // //     this.aboutMe = '',
// // //     this.lookingFor = '',
// // //     required this.partner1,
// // //     required this.partner2,
// // //     required this.partner1Languages,
// // //     required this.partner2Languages,
// // //     this.isLoading = false,
// // //     this.linkedPartner,
// // //   });

// // //   ProfileEditState copyWith({
// // //     bool? isProfileDetailsTab,
// // //     Map<String, bool>? swingersOptions,
// // //     Map<String, bool>? hookupOptions,
// // //     bool? isSwingersExpanded,
// // //     bool? isHookupExpanded,
// // //     String? aboutMe,
// // //     String? lookingFor,
// // //     Map<String, String>? partner1,
// // //     Map<String, String>? partner2,
// // //     List<String>? partner1Languages,
// // //     List<String>? partner2Languages,
// // //     bool? isLoading,
// // //     Map<String, dynamic>? linkedPartner,
// // //   }) {
// // //     return ProfileEditState(
// // //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// // //       swingersOptions: swingersOptions ?? this.swingersOptions,
// // //       hookupOptions: hookupOptions ?? this.hookupOptions,
// // //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// // //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// // //       aboutMe: aboutMe ?? this.aboutMe,
// // //       lookingFor: lookingFor ?? this.lookingFor,
// // //       partner1: partner1 ?? this.partner1,
// // //       partner2: partner2 ?? this.partner2,
// // //       partner1Languages: partner1Languages ?? this.partner1Languages,
// // //       partner2Languages: partner2Languages ?? this.partner2Languages,
// // //       isLoading: isLoading ?? this.isLoading,
// // //       linkedPartner: linkedPartner ?? this.linkedPartner,
// // //     );
// // //   }
// // // }

// // // // -----------------------------------------------------------------------------
// // // // PROFILE DETAILS SAVER (existing, unchanged for details)
// // // // -----------------------------------------------------------------------------

// // // class ProfileDetailsSaver {
// // //   static const String singleUrl = 'https://app.beatflirtevent.com/App/user/edit_single_profile_details';
// // //   static const String coupleUrl = 'https://app.beatflirtevent.com/App/user/edit_couple_profile_details';

// // //   static Future<bool> save({
// // //     required String token,
// // //     required ProfileEditState state,
// // //   }) async {
// // //     final isCouple = state.linkedPartner != null;
// // //     final url = isCouple ? coupleUrl : singleUrl;

// // //     final payload = _buildPayload(state);

// // //     debugPrint('========== SAVING PROFILE DETAILS ==========');
// // //     debugPrint('URL: $url');
// // //     debugPrint('IS COUPLE: $isCouple');
// // //     debugPrint('TOKEN length: ${token.length}');

// // //     final headers = <String, String>{
// // //       'Content-Type': 'application/x-www-form-urlencoded',
// // //       'Accept': 'application/json',
// // //     };
// // //     if (token.isNotEmpty) {
// // //       headers['Authorization'] = 'Bearer $token';
// // //       headers['access-token'] = token;
// // //     }

// // //     final body = {
// // //       ...payload,
// // //       'token': token,
// // //       'Authtoken': token,
// // //     };

// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse(url),
// // //         headers: headers,
// // //         body: body,
// // //       );

// // //       debugPrint('SAVE STATUS: ${response.statusCode}');
// // //       debugPrint('SAVE BODY: ${response.body}');

// // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // //         try {
// // //           final decoded = jsonDecode(response.body);
// // //           if (decoded is Map<String, dynamic>) {
// // //             final status = decoded['status']?.toString();
// // //             final message = decoded['message']?.toString() ?? '';
// // //             if (status == '200' || message.toLowerCase().contains('success')) {
// // //               debugPrint('✅ Profile details saved successfully');
// // //               return true;
// // //             }
// // //           }
// // //         } catch (_) {}
// // //       }
// // //       return false;
// // //     } catch (e) {
// // //       debugPrint('SAVE ERROR: $e');
// // //       return false;
// // //     }
// // //   }

// // //   static Map<String, String> _buildPayload(ProfileEditState state) {
// // //     final p1 = state.partner1;
// // //     final p2 = state.partner2;
// // //     final isCouple = state.linkedPartner != null;

// // //     final payload = <String, String>{
// // //       'text': state.aboutMe,
// // //       'comment': state.lookingFor,
// // //       'person1_name': '',
// // //       'person1_dob': p1['dateOfBirth'] ?? '',
// // //       'person1_height': p1['height'] ?? '',
// // //       'height1_type': p1['heightType'] ?? '',
// // //       'person1_weight': p1['weight'] ?? '',
// // //       'weight1_type': p1['weightType'] ?? '',
// // //       'person1_body_type': p1['bodyType'] ?? '',
// // //       'person1_ethnic_background': p1['ethnic'] ?? '',
// // //       'person1_sexuality': p1['sexuality'] ?? '',
// // //       'person1_relationship_orientation': p1['orientation'] ?? '',
// // //       'person1_tattoos': p1['tattoos'] ?? '',
// // //       'person1_piercings': p1['piercings'] ?? '',
// // //       'person1_smoking': p1['smoking'] ?? '',
// // //       'person1_drinking': p1['drinking'] ?? '',
// // //       'person1_body_hair': jsonEncode([p1['bodyHair'] ?? '']),
// // //       'person1_looks_important': p1['looks'] ?? '',
// // //       'person1_intelligence_importance': p1['intelligence'] ?? '',
// // //       'person1_circumcised': p1['circumcised'] ?? '',
// // //       'person1_language_spoken': jsonEncode(state.partner1Languages),
// // //     };

// // //     if (isCouple) {
// // //       payload.addAll({
// // //         'person2_name': '',
// // //         'person2_dob': p2['dateOfBirth'] ?? '',
// // //         'person2_height': p2['height'] ?? '',
// // //         'height2_type': p2['heightType'] ?? '',
// // //         'person2_weight': p2['weight'] ?? '',
// // //         'weight2_type': p2['weightType'] ?? '',
// // //         'person2_body_type': p2['bodyType'] ?? '',
// // //         'person2_ethnic_background': p2['ethnic'] ?? '',
// // //         'person2_sexuality': p2['sexuality'] ?? '',
// // //         'person2_relationship_orientation': p2['orientation'] ?? '',
// // //         'person2_tattoos': p2['tattoos'] ?? '',
// // //         'person2_piercings': p2['piercings'] ?? '',
// // //         'person2_smoking': p2['smoking'] ?? '',
// // //         'person2_drinking': p2['drinking'] ?? '',
// // //         'person2_body_hair': jsonEncode([p2['bodyHair'] ?? '']),
// // //         'person2_looks_important': p2['looks'] ?? '',
// // //         'person2_intelligence_importance': p2['intelligence'] ?? '',
// // //         'person2_circumcised': p2['circumcised'] ?? '',
// // //         'person2_language_spoken': jsonEncode(state.partner2Languages),
// // //       });
// // //     }

// // //     return payload;
// // //   }
// // // }

// // // // -----------------------------------------------------------------------------
// // // // INTERESTS SAVER (NEW)
// // // // -----------------------------------------------------------------------------

// // // class ProfileInterestsSaver {
// // //   static const String singleUrl = 'https://app.beatflirtevent.com/App/user/edit_single_profile_interest';
// // //   static const String coupleUrl = 'https://app.beatflirtevent.com/App/user/edit_single_profile_interest'; // as per user (same for couple)

// // //   static Future<bool> save({
// // //     required String token,
// // //     required ProfileEditState state,
// // //   }) async {
// // //     final isCouple = state.linkedPartner != null;
// // //     final url = isCouple ? coupleUrl : singleUrl;

// // //     final payload = _buildInterestsPayload(state);

// // //     debugPrint('========== SAVING INTERESTS ==========');
// // //     debugPrint('URL: $url');
// // //     debugPrint('IS COUPLE: $isCouple');

// // //     final headers = <String, String>{
// // //       'Content-Type': 'application/x-www-form-urlencoded',
// // //       'Accept': 'application/json',
// // //     };
// // //     if (token.isNotEmpty) {
// // //       headers['Authorization'] = 'Bearer $token';
// // //       headers['access-token'] = token;
// // //     }

// // //     final body = {
// // //       ...payload,
// // //       'token': token,
// // //       'Authtoken': token,
// // //     };

// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse(url),
// // //         headers: headers,
// // //         body: body,
// // //       );

// // //       debugPrint('INTERESTS SAVE STATUS: ${response.statusCode}');
// // //       debugPrint('INTERESTS SAVE BODY: ${response.body}');

// // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // //         try {
// // //           final decoded = jsonDecode(response.body);
// // //           if (decoded is Map<String, dynamic>) {
// // //             final status = decoded['status']?.toString();
// // //             final message = decoded['message']?.toString() ?? '';
// // //             if (status == '200' || message.toLowerCase().contains('success')) {
// // //               debugPrint('✅ Interests saved successfully');
// // //               return true;
// // //             }
// // //           }
// // //         } catch (_) {}
// // //       }
// // //       return false;
// // //     } catch (e) {
// // //       debugPrint('INTERESTS SAVE ERROR: $e');
// // //       return false;
// // //     }
// // //   }

// // //   static Map<String, String> _buildInterestsPayload(ProfileEditState state) {
// // //     final s = state.swingersOptions;
// // //     final h = state.hookupOptions;

// // //     return {
// // //       'couple_male_female_swingers': (s['Couple Female/Male'] ?? false) ? '1' : '0',
// // //       'couple_male_female_hookup_meetup': (h['Couple Female/Male'] ?? false) ? '1' : '0',
// // //       'couple_female_female_swingers': (s['Couple Female/Female'] ?? false) ? '1' : '0',
// // //       'couple_female_female_hookup_meetup': (h['Couple Female/Female'] ?? false) ? '1' : '0',
// // //       'couple_male_male_swingers': (s['Couple Male/Male'] ?? false) ? '1' : '0',
// // //       'couple_male_male_hookup_meetup': (h['Couple Male/Male'] ?? false) ? '1' : '0',
// // //       'couple_female_swingers': (s['Female'] ?? false) ? '1' : '0',
// // //       'couple_female_hookup_meetup': (h['Female'] ?? false) ? '1' : '0',
// // //       'couple_male_swingers': (s['Male'] ?? false) ? '1' : '0',
// // //       'couple_male_hookup_meetup': (h['Male'] ?? false) ? '1' : '0',
// // //       'couple_transgender_swingers': (s['Transgender'] ?? false) ? '1' : '0',
// // //       'couple_transgender_hookup_meetup': (h['Transgender'] ?? false) ? '1' : '0',
// // //     };
// // //   }
// // // }

// // // // -----------------------------------------------------------------------------
// // // // NOTIFIER
// // // // -----------------------------------------------------------------------------

// // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // //   @override
// // //   ProfileEditState build() {
// // //     Future.microtask(() => loadProfile());
// // //     return ProfileEditState(
// // //       swingersOptions: {
// // //         'Couple Female/Male': true,
// // //         'Couple Female/Female': true,
// // //         'Couple Male/Male': true,
// // //         'Female': true,
// // //         'Male': true,
// // //         'Transgender': true,
// // //       },
// // //       hookupOptions: {
// // //         'Couple Female/Male': true,
// // //         'Couple Female/Female': true,
// // //         'Couple Male/Male': true,
// // //         'Female': true,
// // //         'Male': true,
// // //         'Transgender': false,
// // //       },
// // //       partner1: defaultPartnerTraits(),
// // //       partner2: defaultPartnerTraits(),
// // //       partner1Languages: [],
// // //       partner2Languages: [],
// // //     );
// // //   }

// // //   Future<void> loadProfile() async {
// // //     final String? token = await AuthService.getToken();
// // //     if (token == null || token.isEmpty) {
// // //       debugPrint('No token found');
// // //       return;
// // //     }
// // //     state = state.copyWith(isLoading: true);
// // //     try {
// // //       // TODO: Add real load if needed
// // //     } catch (e) {
// // //       debugPrint('Error loading profile: $e');
// // //     } finally {
// // //       state = state.copyWith(isLoading: false);
// // //     }
// // //   }

// // //   Future<void> saveProfile() async {
// // //     final String? token = await AuthService.getToken();

// // //     if (token == null || token.isEmpty) {
// // //       Get.snackbar('Error', 'User token not found',
// // //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // //       return;
// // //     }

// // //     state = state.copyWith(isLoading: true);

// // //     try {
// // //       if (state.isProfileDetailsTab) {
// // //         final success = await ProfileDetailsSaver.save(
// // //           token: token,
// // //           state: state,
// // //         );

// // //         if (success) {
// // //           Get.snackbar('Success', 'Profile updated successfully',
// // //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// // //         } else {
// // //           Get.snackbar('Error', 'Failed to update profile. Check console.',
// // //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // //         }
// // //       } else {
// // //         // INTERESTS TAB - NEW API
// // //         final success = await ProfileInterestsSaver.save(
// // //           token: token,
// // //           state: state,
// // //         );

// // //         if (success) {
// // //           Get.snackbar('Success', 'Interests saved successfully',
// // //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// // //         } else {
// // //           Get.snackbar('Error', 'Failed to save interests. Check console.',
// // //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error saving: $e');
// // //       Get.snackbar('Error', 'Failed to save: $e',
// // //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // //     } finally {
// // //       state = state.copyWith(isLoading: false);
// // //     }
// // //   }

// // //   void toggleProfileTab(bool isProfile) {
// // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // //   }

// // //   void toggleSwingersExpanded() {
// // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // //   }

// // //   void toggleHookupExpanded() {
// // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // //   }

// // //   void updateSwingersOption(String label, bool value) {
// // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // //     newOptions[label] = value;
// // //     state = state.copyWith(swingersOptions: newOptions);
// // //   }

// // //   void updateHookupOption(String label, bool value) {
// // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // //     newOptions[label] = value;
// // //     state = state.copyWith(hookupOptions: newOptions);
// // //   }

// // //   void updateAboutMe(String value) {
// // //     state = state.copyWith(aboutMe: value);
// // //   }

// // //   void updateLookingFor(String value) {
// // //     state = state.copyWith(lookingFor: value);
// // //   }

// // //   void updatePartner1(String key, String value) {
// // //     final newPartner = Map<String, String>.from(state.partner1);
// // //     newPartner[key] = value;
// // //     state = state.copyWith(partner1: newPartner);
// // //   }

// // //   void updatePartner2(String key, String value) {
// // //     final newPartner = Map<String, String>.from(state.partner2);
// // //     newPartner[key] = value;
// // //     state = state.copyWith(partner2: newPartner);
// // //   }

// // //   void updatePartner1Languages(List<String> langs) {
// // //     state = state.copyWith(partner1Languages: langs);
// // //   }

// // //   void updatePartner2Languages(List<String> langs) {
// // //     state = state.copyWith(partner2Languages: langs);
// // //   }

// // //   Map<String, String> defaultPartnerTraits() {
// // //     return {
// // //       'dateOfBirth': '',
// // //       'height': '',
// // //       'heightType': '',
// // //       'weight': '',
// // //       'weightType': '',
// // //       'bodyType': ProfileOptions.notComfortableValue,
// // //       'ethnic': ProfileOptions.notComfortableValue,
// // //       'sexuality': ProfileOptions.notComfortableValue,
// // //       'orientation': ProfileOptions.notComfortableValue,
// // //       'tattoos': ProfileOptions.notComfortableValue,
// // //       'piercings': ProfileOptions.notComfortableValue,
// // //       'smoking': ProfileOptions.notComfortableValue,
// // //       'drinking': ProfileOptions.notComfortableValue,
// // //       'bodyHair': ProfileOptions.notComfortableValue,
// // //       'looks': ProfileOptions.notComfortableValue,
// // //       'intelligence': ProfileOptions.notComfortableValue,
// // //       'circumcised': ProfileOptions.notComfortableValue,
// // //     };
// // //   }
// // // }

// // // final profileEditProvider = NotifierProvider<ProfileEditNotifier, ProfileEditState>(ProfileEditNotifier.new);

// // // // -----------------------------------------------------------------------------
// // // // WIDGET
// // // // -----------------------------------------------------------------------------

// // // class MyProfileEditTab extends ConsumerWidget {
// // //   const MyProfileEditTab({super.key});

// // //   static const List<String> languageOptions = [
// // //     'English',
// // //     'Hindi',
// // //     'German',
// // //     'French',
// // //     'Spanish',
// // //     'Italian',
// // //     'Portuguese',
// // //     'Chinese (Mandarin)',
// // //     'Japanese',
// // //     'Korean',
// // //     'Russian',
// // //     'Arabic',
// // //     'Bengali',
// // //     'Urdu',
// // //     'Turkish',
// // //     'Dutch',
// // //     'Swedish',
// // //     'Polish',
// // //     'Greek',
// // //     'Hebrew',
// // //     'Thai',
// // //     'Vietnamese',
// // //     'Indonesian',
// // //     'Malay',
// // //     'Filipino',
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final profileState = ref.watch(profileEditProvider);
// // //     final notifier = ref.read(profileEditProvider.notifier);

// // //     return LayoutBuilder(
// // //       builder: (context, constraints) {
// // //         final double width = constraints.maxWidth;
// // //         final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
// // //         final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;

// // //         return Container(
// // //           width: double.infinity,
// // //           constraints: BoxConstraints(
// // //             minHeight: MediaQuery.of(context).size.height * 0.62,
// // //           ),
// // //           padding: const EdgeInsets.all(16),
// // //           decoration: BoxDecoration(
// // //             color: Colors.white,
// // //             borderRadius: BorderRadius.circular(14),
// // //             border: Border.all(color: const Color(0xFFE8E0F2)),
// // //           ),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               if (profileState.isLoading)
// // //                 const Padding(
// // //                   padding: EdgeInsets.only(bottom: 10),
// // //                   child: LinearProgressIndicator(color: Colors.pink),
// // //                 ),
// // //               sectionHeader(profileState, notifier),
// // //               const SizedBox(height: 16),
// // //               if (profileState.isProfileDetailsTab)
// // //                 buildProfileDetailsContent(context, width, profileState, notifier)
// // //               else
// // //                 buildInterestsContent(optionWidth, profileState, notifier),
// // //               const SizedBox(height: 18),
// // //               Center(
// // //                 child: SizedBox(
// // //                   width: 170,
// // //                   child: ElevatedButton(
// // //                     onPressed: profileState.isLoading ? null : () => notifier.saveProfile(),
// // //                     style: ElevatedButton.styleFrom(
// // //                       elevation: 4,
// // //                       padding: const EdgeInsets.symmetric(vertical: 12),
// // //                       backgroundColor: const Color(0xFF220027),
// // //                       foregroundColor: Colors.white,
// // //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
// // //                     ),
// // //                     child: profileState.isLoading
// // //                         ? const SizedBox(
// // //                             height: 20,
// // //                             width: 20,
// // //                             child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
// // //                           )
// // //                         : Text(
// // //                             profileState.isProfileDetailsTab ? 'Save Profile' : 'Save Interest',
// // //                             style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
// // //                           ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 6),
// // //             ],
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
// // //     return Container(
// // //       height: 38,
// // //       padding: const EdgeInsets.symmetric(horizontal: 8),
// // //       decoration: BoxDecoration(
// // //         gradient: const LinearGradient(colors: [Color(0xFF19001F), Color(0xFF490040)]),
// // //         borderRadius: BorderRadius.circular(22),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           InkWell(
// // //             borderRadius: BorderRadius.circular(16),
// // //             onTap: () => notifier.toggleProfileTab(false),
// // //             child: Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // //               decoration: BoxDecoration(
// // //                 color: !state.isProfileDetailsTab ? const Color(0xFFFF2D87) : Colors.transparent,
// // //                 borderRadius: BorderRadius.circular(16),
// // //               ),
// // //               child: const Text('INTERESTS', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
// // //             ),
// // //           ),
// // //           const Spacer(),
// // //           InkWell(
// // //             borderRadius: BorderRadius.circular(16),
// // //             onTap: () => notifier.toggleProfileTab(true),
// // //             child: Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // //               decoration: BoxDecoration(
// // //                 color: state.isProfileDetailsTab ? const Color(0xFFFF2D87) : Colors.transparent,
// // //                 borderRadius: BorderRadius.circular(16),
// // //               ),
// // //               child: const Text('PROFILE DETAILS', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget buildInterestsContent(double optionWidth, ProfileEditState state, ProfileEditNotifier notifier) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         const Text('davidbrown', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 34, height: 1.05)),
// // //         const SizedBox(height: 8),
// // //         Text('What are you looking for? Select all that apply', style: TextStyle(color: Colors.grey[700], fontSize: 14, fontWeight: FontWeight.w500)),
// // //         const SizedBox(height: 16),
// // //         interestGroup(
// // //           title: 'Swingers',
// // //           expanded: state.isSwingersExpanded,
// // //           onToggle: notifier.toggleSwingersExpanded,
// // //           options: state.swingersOptions,
// // //           optionWidth: optionWidth,
// // //           onChanged: (label, value) => notifier.updateSwingersOption(label, value),
// // //         ),
// // //         const SizedBox(height: 12),
// // //         interestGroup(
// // //           title: 'Hookup / Meetup',
// // //           expanded: state.isHookupExpanded,
// // //           onToggle: notifier.toggleHookupExpanded,
// // //           options: state.hookupOptions,
// // //           optionWidth: optionWidth,
// // //           onChanged: (label, value) => notifier.updateHookupOption(label, value),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget buildProfileDetailsContent(BuildContext context, double width, ProfileEditState state, ProfileEditNotifier notifier) {
// // //     final bool stacked = width < 760;
// // //     final bool isCouple = state.linkedPartner != null;

// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         textFieldLabel('INTRODUCE YOURSELF'),
// // //         const SizedBox(height: 6),
// // //         simpleTextField(label: 'About Me', initialValue: state.aboutMe, onChanged: notifier.updateAboutMe),
// // //         const SizedBox(height: 10),
// // //         textFieldLabel('LOOKING FOR'),
// // //         const SizedBox(height: 6),
// // //         simpleTextField(label: 'Looking For', initialValue: state.lookingFor, maxLines: 2, onChanged: notifier.updateLookingFor),
// // //         const SizedBox(height: 14),
// // //         const Center(child: Text('About Yourselves', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700))),
// // //         const SizedBox(height: 12),
// // //         if (isCouple)
// // //           if (stacked)
// // //             Column(
// // //               children: [
// // //                 partnerPanel(context: context, title: 'Partner 1', data: state.partner1, languages: state.partner1Languages, onFieldChanged: notifier.updatePartner1, onLanguagesChanged: notifier.updatePartner1Languages, readOnly: false),
// // //                 const SizedBox(height: 12),
// // //                 partnerPanel(context: context, title: 'Partner 2', data: state.partner2, languages: state.partner2Languages, onFieldChanged: notifier.updatePartner2, onLanguagesChanged: notifier.updatePartner2Languages, readOnly: false),
// // //               ],
// // //             )
// // //           else
// // //             Row(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Expanded(child: partnerPanel(context: context, title: 'Partner 1', data: state.partner1, languages: state.partner1Languages, onFieldChanged: notifier.updatePartner1, onLanguagesChanged: notifier.updatePartner1Languages, readOnly: false)),
// // //                 const SizedBox(width: 12),
// // //                 Expanded(child: partnerPanel(context: context, title: 'Partner 2', data: state.partner2, languages: state.partner2Languages, onFieldChanged: notifier.updatePartner2, onLanguagesChanged: notifier.updatePartner2Languages, readOnly: false)),
// // //               ],
// // //             )
// // //         else
// // //           partnerPanel(context: context, title: 'Partner 1', data: state.partner1, languages: state.partner1Languages, onFieldChanged: notifier.updatePartner1, onLanguagesChanged: notifier.updatePartner1Languages, readOnly: false),
// // //       ],
// // //     );
// // //   }

// // //   Widget partnerPanel({
// // //     required BuildContext context,
// // //     required String title,
// // //     required Map<String, String> data,
// // //     required List<String> languages,
// // //     required void Function(String, String) onFieldChanged,
// // //     required void Function(List<String>) onLanguagesChanged,
// // //     bool readOnly = false,
// // //   }) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Container(
// // //           height: 34,
// // //           alignment: Alignment.center,
// // //           decoration: BoxDecoration(
// // //             gradient: const LinearGradient(colors: [Color(0xFF19001F), Color(0xFF490040)]),
// // //             borderRadius: BorderRadius.circular(10),
// // //           ),
// // //           child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
// // //         ),
// // //         const SizedBox(height: 10),
// // //         dateOfBirthField(context: context, label: 'DATE OF BIRTH', data: data, keyName: 'dateOfBirth', onFieldChanged: onFieldChanged, readOnly: readOnly),
// // //         heightInputField(data: data, onFieldChanged: onFieldChanged, readOnly: readOnly),
// // //         weightInputField(data: data, onFieldChanged: onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('BODY TYPE', data, 'bodyType', ProfileOptions.bodyTypes, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('ETHNIC BACKGROUND', data, 'ethnic', ProfileOptions.ethnicBackgrounds, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('SEXUALITY', data, 'sexuality', ProfileOptions.sexualities, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('RELATIONSHIP ORIENTATION', data, 'orientation', ProfileOptions.relationshipOrientations, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('TATTOOS', data, 'tattoos', ProfileOptions.tattoos, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('PIERCINGS', data, 'piercings', ProfileOptions.piercings, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('SMOKING', data, 'smoking', ProfileOptions.smoking, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('DRINKING', data, 'drinking', ProfileOptions.drinking, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('BODY HAIR', data, 'bodyHair', ProfileOptions.bodyHair, onFieldChanged, readOnly: readOnly),
// // //         languagesField(context, 'LANGUAGES SPOKEN', languages, onLanguagesChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('LOOKS IMPORTANCE', data, 'looks', ProfileOptions.importanceLevels, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('INTELLIGENCE IMPORTANCE', data, 'intelligence', ProfileOptions.importanceLevels, onFieldChanged, readOnly: readOnly),
// // //         profileOptionDropdownField('CIRCUMCISED', data, 'circumcised', ProfileOptions.circumcised, onFieldChanged, readOnly: readOnly),
// // //       ],
// // //     );
// // //   }

// // //   Widget dateOfBirthField({
// // //     required BuildContext context,
// // //     required String label,
// // //     required Map<String, String> data,
// // //     required String keyName,
// // //     required void Function(String, String) onFieldChanged,
// // //     bool readOnly = false,
// // //   }) {
// // //     final currentValue = data[keyName] ?? '';
// // //     final displayValue = currentValue.trim().isEmpty
// // //         ? 'dd/mm/yyyy'
// // //         : currentValue;

// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 8),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           textFieldLabel(label),
// // //           const SizedBox(height: 4),
// // //           InkWell(
// // //             onTap: readOnly
// // //                 ? null
// // //                 : () async {
// // //                     final now = DateTime.now();
// // //                     final parsedDate = parseProfileDate(currentValue);
// // //                     DateTime initialDate =
// // //                         parsedDate ??
// // //                         DateTime(now.year - 18, now.month, now.day);
// // //                     if (initialDate.isAfter(now)) initialDate = now;
// // //                     if (initialDate.isBefore(DateTime(1900)))
// // //                       initialDate = DateTime(1900);
// // //                     final pickedDate = await showDatePicker(
// // //                       context: context,
// // //                       initialDate: initialDate,
// // //                       firstDate: DateTime(1900),
// // //                       lastDate: now,
// // //                     );
// // //                     if (pickedDate == null) return;
// // //                     onFieldChanged(keyName, formatProfileDate(pickedDate));
// // //                   },
// // //             borderRadius: BorderRadius.circular(8),
// // //             child: Container(
// // //               height: 42,
// // //               width: double.infinity,
// // //               padding: const EdgeInsets.symmetric(horizontal: 10),
// // //               decoration: BoxDecoration(
// // //                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 border: Border.all(
// // //                   color: readOnly
// // //                       ? const Color(0xFFF2F2F2)
// // //                       : const Color(0xFFE8E0F2),
// // //                 ),
// // //               ),
// // //               child: Row(
// // //                 children: [
// // //                   Expanded(
// // //                     child: Text(
// // //                       displayValue,
// // //                       maxLines: 1,
// // //                       overflow: TextOverflow.ellipsis,
// // //                       style: TextStyle(
// // //                         fontSize: 12,
// // //                         color: currentValue.trim().isEmpty
// // //                             ? Colors.grey[600]
// // //                             : Colors.black87,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const Icon(
// // //                     Icons.calendar_today_outlined,
// // //                     size: 17,
// // //                     color: Colors.black87,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget heightInputField({
// // //     required Map<String, String> data,
// // //     required void Function(String, String) onFieldChanged,
// // //     bool readOnly = false,
// // //   }) {
// // //     final selectedType = (data['heightType'] ?? '').trim().isEmpty
// // //         ? null
// // //         : data['heightType'];
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 8),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           textFieldLabel('HEIGHT'),
// // //           const SizedBox(height: 2),
// // //           Row(
// // //             children: [
// // //               unitRadioButton(
// // //                 label: 'FT',
// // //                 value: 'FT',
// // //                 groupValue: selectedType,
// // //                 readOnly: readOnly,
// // //                 onChanged: (value) => onFieldChanged('heightType', value),
// // //               ),
// // //               const SizedBox(width: 18),
// // //               unitRadioButton(
// // //                 label: 'CM',
// // //                 value: 'CM',
// // //                 groupValue: selectedType,
// // //                 readOnly: readOnly,
// // //                 onChanged: (value) => onFieldChanged('heightType', value),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 4),
// // //           TextFormField(
// // //             key: ValueKey('height-${data['height'] ?? ''}-$readOnly'),
// // //             initialValue: data['height'] ?? '',
// // //             readOnly: readOnly,
// // //             onChanged: readOnly
// // //                 ? null
// // //                 : (value) => onFieldChanged('height', value),
// // //             keyboardType: TextInputType.text,
// // //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// // //             decoration: profileInputDecoration(
// // //               hintText: "Ex. (5'7 OR 170)",
// // //               readOnly: readOnly,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget weightInputField({
// // //     required Map<String, String> data,
// // //     required void Function(String, String) onFieldChanged,
// // //     bool readOnly = false,
// // //   }) {
// // //     final selectedType = (data['weightType'] ?? '').trim().isEmpty
// // //         ? null
// // //         : data['weightType'];
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 8),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           textFieldLabel('WEIGHT'),
// // //           const SizedBox(height: 2),
// // //           Row(
// // //             children: [
// // //               unitRadioButton(
// // //                 label: 'LBS',
// // //                 value: 'LBS',
// // //                 groupValue: selectedType,
// // //                 readOnly: readOnly,
// // //                 onChanged: (value) => onFieldChanged('weightType', value),
// // //               ),
// // //               const SizedBox(width: 18),
// // //               unitRadioButton(
// // //                 label: 'KG',
// // //                 value: 'KG',
// // //                 groupValue: selectedType,
// // //                 readOnly: readOnly,
// // //                 onChanged: (value) => onFieldChanged('weightType', value),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 4),
// // //           TextFormField(
// // //             key: ValueKey('weight-${data['weight'] ?? ''}-$readOnly'),
// // //             initialValue: data['weight'] ?? '',
// // //             readOnly: readOnly,
// // //             onChanged: readOnly
// // //                 ? null
// // //                 : (value) => onFieldChanged('weight', value),
// // //             keyboardType: TextInputType.number,
// // //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// // //             decoration: profileInputDecoration(
// // //               hintText: 'Ex. (150 LBS OR 68 KG)',
// // //               readOnly: readOnly,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget unitRadioButton({
// // //     required String label,
// // //     required String value,
// // //     required String? groupValue,
// // //     required void Function(String) onChanged,
// // //     bool readOnly = false,
// // //   }) {
// // //     return InkWell(
// // //       onTap: readOnly ? null : () => onChanged(value),
// // //       borderRadius: BorderRadius.circular(8),
// // //       child: Row(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Radio<String>(
// // //             value: value,
// // //             groupValue: groupValue,
// // //             onChanged: readOnly
// // //                 ? null
// // //                 : (selectedValue) {
// // //                     if (selectedValue != null) onChanged(selectedValue);
// // //                   },
// // //             activeColor: const Color(0xFF5A002B),
// // //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // //             visualDensity: VisualDensity.compact,
// // //           ),
// // //           Text(
// // //             label,
// // //             style: const TextStyle(
// // //               fontSize: 12,
// // //               fontWeight: FontWeight.w800,
// // //               color: Color(0xFF5A002B),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   InputDecoration profileInputDecoration({
// // //     required String hintText,
// // //     bool readOnly = false,
// // //   }) {
// // //     return InputDecoration(
// // //       hintText: hintText,
// // //       hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
// // //       isDense: true,
// // //       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// // //       border: OutlineInputBorder(
// // //         borderRadius: BorderRadius.circular(8),
// // //         borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // //       ),
// // //       enabledBorder: OutlineInputBorder(
// // //         borderRadius: BorderRadius.circular(8),
// // //         borderSide: BorderSide(
// // //           color: readOnly ? const Color(0xFFF2F2F2) : const Color(0xFFE8E0F2),
// // //         ),
// // //       ),
// // //       focusedBorder: OutlineInputBorder(
// // //         borderRadius: BorderRadius.circular(8),
// // //         borderSide: const BorderSide(color: Color(0xFF5A002B)),
// // //       ),
// // //       fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // //       filled: true,
// // //     );
// // //   }

// // //   DateTime? parseProfileDate(String? value) {
// // //     if (value == null || value.trim().isEmpty) return null;
// // //     final text = value.trim();
// // //     final dmyMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);
// // //     if (dmyMatch != null) {
// // //       final day = int.tryParse(dmyMatch.group(1)!);
// // //       final month = int.tryParse(dmyMatch.group(2)!);
// // //       final year = int.tryParse(dmyMatch.group(3)!);
// // //       if (day != null && month != null && year != null)
// // //         return DateTime(year, month, day);
// // //     }
// // //     final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
// // //     if (isoMatch != null) {
// // //       final year = int.tryParse(isoMatch.group(1)!);
// // //       final month = int.tryParse(isoMatch.group(2)!);
// // //       final day = int.tryParse(isoMatch.group(3)!);
// // //       if (day != null && month != null && year != null)
// // //         return DateTime(year, month, day);
// // //     }
// // //     return DateTime.tryParse(text);
// // //   }

// // //   String formatProfileDate(DateTime date) {
// // //     final day = date.day.toString().padLeft(2, '0');
// // //     final month = date.month.toString().padLeft(2, '0');
// // //     final year = date.year.toString();
// // //     return '$day/$month/$year';
// // //   }

// // //   ProfileOption? findProfileOption(
// // //     String? currentValue,
// // //     List<ProfileOption> options,
// // //   ) {
// // //     if (currentValue == null || currentValue.trim().isEmpty) return null;
// // //     final normalizedCurrent = normalize(currentValue);
// // //     for (final option in options) {
// // //       if (normalize(option.id) == normalizedCurrent ||
// // //           normalize(option.value) == normalizedCurrent ||
// // //           normalize(option.label) == normalizedCurrent) {
// // //         return option;
// // //       }
// // //     }
// // //     if (normalizedCurrent == normalize('Bisexual'))
// // //       return firstProfileOptionWhere(options, (e) => e.value == 'Bi-sexual');
// // //     if (normalizedCurrent == normalize('Occasionally'))
// // //       return firstProfileOptionWhere(options, (e) => e.value == 'Occasionally');
// // //     if (normalizedCurrent == normalize('Low'))
// // //       return firstProfileOptionWhere(
// // //         options,
// // //         (e) => e.value == 'Low Importance',
// // //       );
// // //     if (normalizedCurrent == normalize('Medium'))
// // //       return firstProfileOptionWhere(
// // //         options,
// // //         (e) => e.value == 'Medium Importance',
// // //       );
// // //     if (normalizedCurrent == normalize('High'))
// // //       return firstProfileOptionWhere(
// // //         options,
// // //         (e) => e.value == 'Very Important',
// // //       );
// // //     return null;
// // //   }

// // //   ProfileOption? firstProfileOptionWhere(
// // //     List<ProfileOption> options,
// // //     bool Function(ProfileOption) test,
// // //   ) {
// // //     for (final option in options) {
// // //       if (test(option)) return option;
// // //     }
// // //     return null;
// // //   }

// // //   String normalize(String value) {
// // //     return value
// // //         .trim()
// // //         .toLowerCase()
// // //         .replaceAll('.', '')
// // //         .replaceAll('-', '')
// // //         .replaceAll('_', '')
// // //         .replaceAll(' ', '');
// // //   }

// // //   String? defaultProfileOptionValue(List<ProfileOption> options) {
// // //     if (options.isEmpty) return null;
// // //     for (final option in options) {
// // //       if (option.id == 'not_comfortable') return option.value;
// // //     }
// // //     return options.first.value;
// // //   }

// // //   Widget profileOptionDropdownField(
// // //     String label,
// // //     Map<String, String> data,
// // //     String key,
// // //     List<ProfileOption> options,
// // //     void Function(String, String) onFieldChanged, {
// // //     bool readOnly = false,
// // //   }) {
// // //     final currentValue = data[key];
// // //     final selectedOption = findProfileOption(currentValue, options);
// // //     final validValue =
// // //         selectedOption?.value ?? defaultProfileOptionValue(options);

// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 8),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           textFieldLabel(label),
// // //           const SizedBox(height: 4),
// // //           DropdownButtonFormField<String>(
// // //             key: ValueKey('$label-$key-$validValue-$readOnly'),
// // //             initialValue: validValue,
// // //             isExpanded: true,
// // //             iconSize: 18,
// // //             style: const TextStyle(
// // //               fontSize: 12,
// // //               color: Colors.black87,
// // //               overflow: TextOverflow.ellipsis,
// // //             ),
// // //             items: options
// // //                 .map(
// // //                   (option) => DropdownMenuItem<String>(
// // //                     value: option.value,
// // //                     child: Text(
// // //                       option.label,
// // //                       maxLines: 1,
// // //                       overflow: TextOverflow.ellipsis,
// // //                     ),
// // //                   ),
// // //                 )
// // //                 .toList(),
// // //             selectedItemBuilder: (context) => options
// // //                 .map(
// // //                   (option) => Align(
// // //                     alignment: Alignment.centerLeft,
// // //                     child: Text(
// // //                       option.label,
// // //                       maxLines: 1,
// // //                       overflow: TextOverflow.ellipsis,
// // //                     ),
// // //                   ),
// // //                 )
// // //                 .toList(),
// // //             onChanged: readOnly
// // //                 ? null
// // //                 : (value) {
// // //                     if (value != null) onFieldChanged(key, value);
// // //                   },
// // //             decoration: InputDecoration(
// // //               isDense: true,
// // //               contentPadding: const EdgeInsets.symmetric(
// // //                 horizontal: 10,
// // //                 vertical: 8,
// // //               ),
// // //               border: OutlineInputBorder(
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // //               ),
// // //               enabledBorder: OutlineInputBorder(
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 borderSide: BorderSide(
// // //                   color: readOnly
// // //                       ? const Color(0xFFF2F2F2)
// // //                       : const Color(0xFFE8E0F2),
// // //                 ),
// // //               ),
// // //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// // //               filled: readOnly,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget simpleTextField({
// // //     required String label,
// // //     required String initialValue,
// // //     required void Function(String) onChanged,
// // //     int maxLines = 1,
// // //     bool readOnly = false,
// // //   }) {
// // //     return TextFormField(
// // //       key: ValueKey('$label-$initialValue-$readOnly'),
// // //       initialValue: initialValue,
// // //       maxLines: maxLines,
// // //       onChanged: onChanged,
// // //       readOnly: readOnly,
// // //       style: const TextStyle(fontSize: 12),
// // //       decoration: InputDecoration(
// // //         hintText: label,
// // //         isDense: true,
// // //         contentPadding: const EdgeInsets.symmetric(
// // //           horizontal: 10,
// // //           vertical: 10,
// // //         ),
// // //         border: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(8),
// // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // //         ),
// // //         enabledBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(8),
// // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget textFieldLabel(String text) {
// // //     return Text(
// // //       text,
// // //       style: const TextStyle(
// // //         fontSize: 11,
// // //         fontWeight: FontWeight.w800,
// // //         letterSpacing: 0.2,
// // //       ),
// // //     );
// // //   }

// // //   Widget languagesField(
// // //     BuildContext context,
// // //     String label,
// // //     List<String> selectedValues,
// // //     void Function(List<String>) onSaved, {
// // //     bool readOnly = false,
// // //   }) {
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 8),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           textFieldLabel(label),
// // //           const SizedBox(height: 4),
// // //           InkWell(
// // //             onTap: readOnly
// // //                 ? null
// // //                 : () => openLanguageSelector(context, selectedValues, onSaved),
// // //             borderRadius: BorderRadius.circular(8),
// // //             child: Container(
// // //               width: double.infinity,
// // //               constraints: const BoxConstraints(minHeight: 42),
// // //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// // //               decoration: BoxDecoration(
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 border: Border.all(
// // //                   color: readOnly
// // //                       ? const Color(0xFFF2F2F2)
// // //                       : const Color(0xFFE8E0F2),
// // //                 ),
// // //                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // //               ),
// // //               child: Row(
// // //                 children: [
// // //                   Expanded(
// // //                     child: selectedValues.isEmpty
// // //                         ? Text(
// // //                             ProfileOptions.notComfortableLabel,
// // //                             maxLines: 1,
// // //                             overflow: TextOverflow.ellipsis,
// // //                             style: TextStyle(
// // //                               color: Colors.grey[600],
// // //                               fontSize: 12,
// // //                             ),
// // //                           )
// // //                         : Wrap(
// // //                             spacing: 6,
// // //                             runSpacing: 6,
// // //                             children: selectedValues
// // //                                 .map(
// // //                                   (lang) => Container(
// // //                                     padding: const EdgeInsets.symmetric(
// // //                                       horizontal: 8,
// // //                                       vertical: 3,
// // //                                     ),
// // //                                     decoration: BoxDecoration(
// // //                                       color: const Color(0xFFF0F4FF),
// // //                                       borderRadius: BorderRadius.circular(12),
// // //                                       border: Border.all(
// // //                                         color: const Color(0xFFD4DDF2),
// // //                                       ),
// // //                                     ),
// // //                                     child: Text(
// // //                                       lang,
// // //                                       style: const TextStyle(fontSize: 11),
// // //                                     ),
// // //                                   ),
// // //                                 )
// // //                                 .toList(),
// // //                           ),
// // //                   ),
// // //                   const SizedBox(width: 8),
// // //                   const Icon(
// // //                     Icons.keyboard_arrow_down_rounded,
// // //                     size: 20,
// // //                     color: Colors.black87,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Future<void> openLanguageSelector(
// // //     BuildContext context,
// // //     List<String> selectedValues,
// // //     void Function(List<String>) onSaved,
// // //   ) async {
// // //     final temp = [...selectedValues];
// // //     await showModalBottomSheet<void>(
// // //       context: context,
// // //       builder: (context) {
// // //         return StatefulBuilder(
// // //           builder: (context, setModalState) {
// // //             return SafeArea(
// // //               child: Padding(
// // //                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
// // //                 child: Column(
// // //                   mainAxisSize: MainAxisSize.min,
// // //                   children: [
// // //                     const Text(
// // //                       'Select Languages',
// // //                       style: TextStyle(
// // //                         fontWeight: FontWeight.w700,
// // //                         fontSize: 16,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 10),
// // //                     ...languageOptions.map(
// // //                       (lang) => CheckboxListTile(
// // //                         dense: true,
// // //                         value: temp.contains(lang),
// // //                         onChanged: (checked) {
// // //                           setModalState(() {
// // //                             if (checked == true) {
// // //                               if (!temp.contains(lang)) temp.add(lang);
// // //                             } else {
// // //                               temp.remove(lang);
// // //                             }
// // //                           });
// // //                         },
// // //                         title: Text(lang),
// // //                         controlAffinity: ListTileControlAffinity.leading,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     SizedBox(
// // //                       width: double.infinity,
// // //                       child: ElevatedButton(
// // //                         onPressed: () {
// // //                           onSaved(temp);
// // //                           Navigator.pop(context);
// // //                         },
// // //                         child: const Text('Done'),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             );
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }

// // //   Widget interestGroup({
// // //     required String title,
// // //     required bool expanded,
// // //     required VoidCallback onToggle,
// // //     required Map<String, bool> options,
// // //     required double optionWidth,
// // //     required void Function(String label, bool value) onChanged,
// // //   }) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(10),
// // //         border: Border.all(color: const Color(0xFFECE4F4)),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           InkWell(
// // //             onTap: onToggle,
// // //             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
// // //             child: Container(
// // //               height: 40,
// // //               padding: const EdgeInsets.symmetric(horizontal: 14),
// // //               decoration: BoxDecoration(
// // //                 gradient: const LinearGradient(
// // //                   colors: [Color(0xFF19001F), Color(0xFF490040)],
// // //                 ),
// // //                 borderRadius: BorderRadius.vertical(
// // //                   top: const Radius.circular(10),
// // //                   bottom: expanded ? Radius.zero : const Radius.circular(10),
// // //                 ),
// // //               ),
// // //               child: Row(
// // //                 children: [
// // //                   Expanded(
// // //                     child: Text(
// // //                       title,
// // //                       maxLines: 1,
// // //                       overflow: TextOverflow.ellipsis,
// // //                       style: const TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 30,
// // //                         fontWeight: FontWeight.w800,
// // //                         height: 1.0,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 8),
// // //                   CircleAvatar(
// // //                     radius: 12,
// // //                     backgroundColor: const Color(0xFFEACD71),
// // //                     child: Icon(
// // //                       expanded
// // //                           ? Icons.keyboard_arrow_up
// // //                           : Icons.keyboard_arrow_down,
// // //                       size: 16,
// // //                       color: Colors.black87,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           if (expanded)
// // //             Padding(
// // //               padding: const EdgeInsets.all(10),
// // //               child: Wrap(
// // //                 spacing: 8,
// // //                 runSpacing: 8,
// // //                 children: options.entries
// // //                     .map(
// // //                       (entry) => OptionChip(
// // //                         label: entry.key,
// // //                         selected: entry.value,
// // //                         width: optionWidth,
// // //                         onTap: () => onChanged(entry.key, !entry.value),
// // //                       ),
// // //                     )
// // //                     .toList(),
// // //               ),
// // //             ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // // -----------------------------------------------------------------------------
// // // // OPTION CHIP
// // // // -----------------------------------------------------------------------------

// // // class OptionChip extends StatelessWidget {
// // //   const OptionChip({
// // //     super.key,
// // //     required this.label,
// // //     required this.selected,
// // //     required this.width,
// // //     required this.onTap,
// // //   });

// // //   final String label;
// // //   final bool selected;
// // //   final double width;
// // //   final VoidCallback onTap;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return InkWell(
// // //       onTap: onTap,
// // //       borderRadius: BorderRadius.circular(8),
// // //       child: Container(
// // //         width: width,
// // //         height: 42,
// // //         padding: const EdgeInsets.symmetric(horizontal: 10),
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(8),
// // //           border: Border.all(color: const Color(0xFFF1EBF8)),
// // //         ),
// // //         child: Row(
// // //           children: [
// // //             Expanded(
// // //               child: Text(
// // //                 label,
// // //                 overflow: TextOverflow.ellipsis,
// // //                 style: const TextStyle(
// // //                   color: Colors.black87,
// // //                   fontWeight: FontWeight.w500,
// // //                 ),
// // //               ),
// // //             ),
// // //             Checkbox(
// // //               value: selected,
// // //               onChanged: (_) => onTap(),
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(4),
// // //               ),
// // //               activeColor: const Color(0xFF47003D),
// // //               side: const BorderSide(color: Color(0xFFE0D4EE)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }







// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';

// // // // import 'package:beatflirt/core/services/auth_services.dart';

// // // // // -----------------------------------------------------------------------------
// // // // // PROFILE OPTIONS
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileOption {
// // // //   final String id;
// // // //   final String value;
// // // //   final String label;

// // // //   const ProfileOption({
// // // //     required this.id,
// // // //     required this.value,
// // // //     required this.label,
// // // //   });

// // // //   Map<String, dynamic> toJson() {
// // // //     return {'id': id, 'value': value, 'label': label};
// // // //   }
// // // // }

// // // // class ProfileOptions {
// // // //   static const String notComfortableValue = 'Im not comfortable sharing that';
// // // //   static const String notComfortableLabel = "I'm not comfortable sharing that.";

// // // //   static const ProfileOption notComfortable = ProfileOption(
// // // //     id: 'not_comfortable',
// // // //     value: notComfortableValue,
// // // //     label: notComfortableLabel,
// // // //   );

// // // //   static const List<ProfileOption> tattoos = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'none', value: 'None', label: 'None'),
// // // //     ProfileOption(id: 'one', value: 'One', label: 'One'),
// // // //     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
// // // //     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
// // // //     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
// // // //   ];

// // // //   static const List<ProfileOption> heightTypes = [
// // // //     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
// // // //     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
// // // //   ];

// // // //   static const List<ProfileOption> weightTypes = [
// // // //     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
// // // //     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
// // // //   ];

// // // //   static const List<ProfileOption> bodyTypes = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
// // // //     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
// // // //     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
// // // //     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
// // // //     ProfileOption(
// // // //       id: 'huggable_and_heavy',
// // // //       value: 'Huggable and Heavy',
// // // //       label: 'Huggable and Heavy',
// // // //     ),
// // // //     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
// // // //     ProfileOption(
// // // //       id: 'more_of_me_to_love',
// // // //       value: 'More of me to love',
// // // //       label: 'More of me to love',
// // // //     ),
// // // //     ProfileOption(
// // // //       id: 'nicely_shaped',
// // // //       value: 'Nicely Shaped',
// // // //       label: 'Nicely Shaped',
// // // //     ),
// // // //     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
// // // //   ];

// // // //   static const List<ProfileOption> smoking = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(
// // // //       id: 'occasionally',
// // // //       value: 'Occasionally',
// // // //       label: 'Occasionally',
// // // //     ),
// // // //   ];

// // // //   static const List<ProfileOption> drinking = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(
// // // //       id: 'occasionally',
// // // //       value: 'Occasionally',
// // // //       label: 'Occasionally',
// // // //     ),
// // // //   ];

// // // //   static const List<ProfileOption> ethnicBackgrounds = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'other', value: 'Other', label: 'Other'),
// // // //     ProfileOption(id: 'american', value: 'American', label: 'American'),
// // // //     ProfileOption(
// // // //       id: 'argentine_argentinian',
// // // //       value: 'Argentine/Argentinian',
// // // //       label: 'Argentine/Argentinian',
// // // //     ),
// // // //     ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
// // // //     ProfileOption(
// // // //       id: 'black_african_american',
// // // //       value: 'Black/African - American',
// // // //       label: 'Black/African - American',
// // // //     ),
// // // //     ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
// // // //     ProfileOption(id: 'british', value: 'British', label: 'British'),
// // // //     ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
// // // //     ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
// // // //     ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
// // // //     ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
// // // //     ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
// // // //     ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
// // // //     ProfileOption(id: 'french', value: 'French', label: 'French'),
// // // //     ProfileOption(id: 'german', value: 'German', label: 'German'),
// // // //     ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
// // // //     ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
// // // //     ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
// // // //     ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
// // // //     ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
// // // //     ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
// // // //     ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
// // // //     ProfileOption(
// // // //       id: 'new_zealander_kiwi',
// // // //       value: 'New Zealander/Kiwi',
// // // //       label: 'New Zealander/Kiwi',
// // // //     ),
// // // //     ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
// // // //     ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
// // // //     ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
// // // //     ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
// // // //     ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
// // // //     ProfileOption(
// // // //       id: 'south_african',
// // // //       value: 'South African',
// // // //       label: 'South African',
// // // //     ),
// // // //     ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
// // // //     ProfileOption(id: 'sri_lankan', value: 'Sri Lankan', label: 'Sri Lankan'),
// // // //     ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
// // // //     ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
// // // //   ];

// // // //   static const List<ProfileOption> importanceLevels = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(
// // // //       id: 'low_importance',
// // // //       value: 'Low Importance',
// // // //       label: 'Low Importance',
// // // //     ),
// // // //     ProfileOption(
// // // //       id: 'medium_importance',
// // // //       value: 'Medium Importance',
// // // //       label: 'Medium Importance',
// // // //     ),
// // // //     ProfileOption(
// // // //       id: 'very_important',
// // // //       value: 'Very Important',
// // // //       label: 'Very Important',
// // // //     ),
// // // //   ];

// // // //   static const List<ProfileOption> sexualities = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
// // // //     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
// // // //     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
// // // //     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
// // // //     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
// // // //     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
// // // //     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
// // // //     ProfileOption(
// // // //       id: 'transsexual',
// // // //       value: 'Transsexual',
// // // //       label: 'Transsexual',
// // // //     ),
// // // //   ];

// // // //   static const List<ProfileOption> relationshipOrientations = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
// // // //     ProfileOption(
// // // //       id: 'open_minded',
// // // //       value: 'Open-Minded',
// // // //       label: 'Open-Minded',
// // // //     ),
// // // //     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
// // // //     ProfileOption(
// // // //       id: 'polyamorous',
// // // //       value: 'Polyamorous',
// // // //       label: 'Polyamorous',
// // // //     ),
// // // //   ];

// // // //   static const List<ProfileOption> circumcised = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //   ];

// // // //   static const List<ProfileOption> piercings = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //   ];

// // // //   static const List<ProfileOption> bodyHair = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
// // // //     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
// // // //     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
// // // //     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
// // // //   ];

// // // //   static const Map<String, List<ProfileOption>> groups = {
// // // //     'tattoos': tattoos,
// // // //     'height_types': heightTypes,
// // // //     'weight_types': weightTypes,
// // // //     'body_types': bodyTypes,
// // // //     'smoking': smoking,
// // // //     'drinking': drinking,
// // // //     'ethnic_backgrounds': ethnicBackgrounds,
// // // //     'importance_levels': importanceLevels,
// // // //     'sexualities': sexualities,
// // // //     'relationship_orientations': relationshipOrientations,
// // // //     'circumcised': circumcised,
// // // //     'piercings': piercings,
// // // //     'body_hair': bodyHair,
// // // //   };
// // // // }

// // // // class ProfileFieldOptions {
// // // //   static const Map<String, String> fieldGroupMap = {
// // // //     'bodyType': 'body_types',
// // // //     'ethnic': 'ethnic_backgrounds',
// // // //     'sexuality': 'sexualities',
// // // //     'orientation': 'relationship_orientations',
// // // //     'tattoos': 'tattoos',
// // // //     'piercings': 'piercings',
// // // //     'smoking': 'smoking',
// // // //     'drinking': 'drinking',
// // // //     'bodyHair': 'body_hair',
// // // //     'looks': 'importance_levels',
// // // //     'intelligence': 'importance_levels',
// // // //     'circumcised': 'circumcised',
// // // //     'person1_tattoos': 'tattoos',
// // // //     'person2_tattoos': 'tattoos',
// // // //     'person1_height_type': 'height_types',
// // // //     'person2_height_type': 'height_types',
// // // //     'person1_weight_type': 'weight_types',
// // // //     'person2_weight_type': 'weight_types',
// // // //     'person1_body_type': 'body_types',
// // // //     'person2_body_type': 'body_types',
// // // //     'person1_smoking': 'smoking',
// // // //     'person2_smoking': 'smoking',
// // // //     'person1_drinking': 'drinking',
// // // //     'person2_drinking': 'drinking',
// // // //     'person1_ethnic_background': 'ethnic_backgrounds',
// // // //     'person2_ethnic_background': 'ethnic_backgrounds',
// // // //     'person1_looks_important': 'importance_levels',
// // // //     'person2_looks_important': 'importance_levels',
// // // //     'person1_intelligence_importance': 'importance_levels',
// // // //     'person2_intelligence_importance': 'importance_levels',
// // // //     'person1_sexuality': 'sexualities',
// // // //     'person2_sexuality': 'sexualities',
// // // //     'person1_relationship_orientation': 'relationship_orientations',
// // // //     'person2_relationship_orientation': 'relationship_orientations',
// // // //     'person1_circumcised': 'circumcised',
// // // //     'person2_circumcised': 'circumcised',
// // // //     'person1_piercings': 'piercings',
// // // //     'person2_piercings': 'piercings',
// // // //   };

// // // //   static List<ProfileOption> getOptionsForField(String fieldName) {
// // // //     final groupKey = fieldGroupMap[fieldName];
// // // //     if (groupKey == null) return [];
// // // //     return ProfileOptions.groups[groupKey] ?? [];
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // STATE
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileEditState {
// // // //   final bool isProfileDetailsTab;
// // // //   final Map<String, bool> swingersOptions;
// // // //   final Map<String, bool> hookupOptions;
// // // //   final bool isSwingersExpanded;
// // // //   final bool isHookupExpanded;
// // // //   final String aboutMe;
// // // //   final String lookingFor;
// // // //   final Map<String, String> partner1;
// // // //   final Map<String, String> partner2;
// // // //   final List<String> partner1Languages;
// // // //   final List<String> partner2Languages;
// // // //   final bool isLoading;
// // // //   final Map<String, dynamic>? linkedPartner;

// // // //   const ProfileEditState({
// // // //     this.isProfileDetailsTab = false,
// // // //     required this.swingersOptions,
// // // //     required this.hookupOptions,
// // // //     this.isSwingersExpanded = true,
// // // //     this.isHookupExpanded = true,
// // // //     this.aboutMe = '',
// // // //     this.lookingFor = '',
// // // //     required this.partner1,
// // // //     required this.partner2,
// // // //     required this.partner1Languages,
// // // //     required this.partner2Languages,
// // // //     this.isLoading = false,
// // // //     this.linkedPartner,
// // // //   });

// // // //   ProfileEditState copyWith({
// // // //     bool? isProfileDetailsTab,
// // // //     Map<String, bool>? swingersOptions,
// // // //     Map<String, bool>? hookupOptions,
// // // //     bool? isSwingersExpanded,
// // // //     bool? isHookupExpanded,
// // // //     String? aboutMe,
// // // //     String? lookingFor,
// // // //     Map<String, String>? partner1,
// // // //     Map<String, String>? partner2,
// // // //     List<String>? partner1Languages,
// // // //     List<String>? partner2Languages,
// // // //     bool? isLoading,
// // // //     Map<String, dynamic>? linkedPartner,
// // // //   }) {
// // // //     return ProfileEditState(
// // // //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// // // //       swingersOptions: swingersOptions ?? this.swingersOptions,
// // // //       hookupOptions: hookupOptions ?? this.hookupOptions,
// // // //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// // // //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// // // //       aboutMe: aboutMe ?? this.aboutMe,
// // // //       lookingFor: lookingFor ?? this.lookingFor,
// // // //       partner1: partner1 ?? this.partner1,
// // // //       partner2: partner2 ?? this.partner2,
// // // //       partner1Languages: partner1Languages ?? this.partner1Languages,
// // // //       partner2Languages: partner2Languages ?? this.partner2Languages,
// // // //       isLoading: isLoading ?? this.isLoading,
// // // //       linkedPartner: linkedPartner ?? this.linkedPartner,
// // // //     );
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // NEW CLEAN API SERVICE (based on your exact spec)
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileApiService {
// // // //   static const String singleUrl =
// // // //       'https://app.beatflirtevent.com/App/user/edit_single_profile_details';
// // // //   static const String coupleUrl =
// // // //       'https://app.beatflirtevent.com/App/user/edit_couple_profile_details';

// // // //   static Map<String, String> headers(String token) => {
// // // //     'Accept': 'application/json',
// // // //     'Authorization': 'Bearer $token',
// // // //     'Authtoken': token,
// // // //     'Token': token,
// // // //     'token': token,
// // // //     'X-Auth-Token': token,
// // // //     'X-API-KEY': token,
// // // //     'access_token': token,
// // // //   };

// // // //   static Future<bool> saveProfileDetails({
// // // //     required String token,
// // // //     required ProfileEditState state,
// // // //   }) async {
// // // //     final isCouple = state.linkedPartner != null;
// // // //     final url = isCouple ? coupleUrl : singleUrl;

// // // //     final payload = _buildPayload(state);

// // // //     debugPrint('========== SAVING PROFILE DETAILS ==========');
// // // //     debugPrint('URL: $url');
// // // //     debugPrint('IS COUPLE: $isCouple');

// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse(url),
// // // //         headers: headers(token),
// // // //         body: _buildPayload(state),
// // // //       );

// // // //       debugPrint('SAVE STATUS: ${response.statusCode}');
// // // //       debugPrint('SAVE BODY: ${response.body}');

// // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // //         try {
// // // //           final decoded = jsonDecode(response.body);
// // // //           if (decoded is Map<String, dynamic>) {
// // // //             final status = decoded['status']?.toString();
// // // //             final message = decoded['message']?.toString() ?? '';
// // // //             if (status == '200' || message.toLowerCase().contains('success')) {
// // // //               debugPrint('✅ SUCCESS');
// // // //               return true;
// // // //             }
// // // //           }
// // // //         } catch (_) {}
// // // //       }
// // // //       return false;
// // // //     } catch (e) {
// // // //       debugPrint('SAVE ERROR: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Map<String, String> _buildPayload(ProfileEditState state) {
// // // //     final p1 = state.partner1;
// // // //     final p2 = state.partner2;
// // // //     final isCouple = state.linkedPartner != null;

// // // //     final payload = <String, String>{
// // // //       'text': state.aboutMe,
// // // //       'comment': state.lookingFor,
// // // //       'person1_name': '',
// // // //       'person1_dob': p1['dateOfBirth'] ?? '',
// // // //       'person1_height': p1['height'] ?? '',
// // // //       'height1_type': p1['heightType'] ?? '',
// // // //       'person1_weight': p1['weight'] ?? '',
// // // //       'weight1_type': p1['weightType'] ?? '',
// // // //       'person1_body_type': p1['bodyType'] ?? '',
// // // //       'person1_ethnic_background': p1['ethnic'] ?? '',
// // // //       'person1_sexuality': p1['sexuality'] ?? '',
// // // //       'person1_relationship_orientation': p1['orientation'] ?? '',
// // // //       'person1_tattoos': p1['tattoos'] ?? '',
// // // //       'person1_piercings': p1['piercings'] ?? '',
// // // //       'person1_smoking': p1['smoking'] ?? '',
// // // //       'person1_drinking': p1['drinking'] ?? '',
// // // //       'person1_body_hair': jsonEncode([p1['bodyHair'] ?? '']),
// // // //       'person1_looks_important': p1['looks'] ?? '',
// // // //       'person1_intelligence_importance': p1['intelligence'] ?? '',
// // // //       'person1_circumcised': p1['circumcised'] ?? '',
// // // //       'person1_language_spoken': jsonEncode(state.partner1Languages),
// // // //     };

// // // //     if (isCouple) {
// // // //       payload.addAll({
// // // //         'person2_name': '',
// // // //         'person2_dob': p2['dateOfBirth'] ?? '',
// // // //         'person2_height': p2['height'] ?? '',
// // // //         'height2_type': p2['heightType'] ?? '',
// // // //         'person2_weight': p2['weight'] ?? '',
// // // //         'weight2_type': p2['weightType'] ?? '',
// // // //         'person2_body_type': p2['bodyType'] ?? '',
// // // //         'person2_ethnic_background': p2['ethnic'] ?? '',
// // // //         'person2_sexuality': p2['sexuality'] ?? '',
// // // //         'person2_relationship_orientation': p2['orientation'] ?? '',
// // // //         'person2_tattoos': p2['tattoos'] ?? '',
// // // //         'person2_piercings': p2['piercings'] ?? '',
// // // //         'person2_smoking': p2['smoking'] ?? '',
// // // //         'person2_drinking': p2['drinking'] ?? '',
// // // //         'person2_body_hair': jsonEncode([p2['bodyHair'] ?? '']),
// // // //         'person2_looks_important': p2['looks'] ?? '',
// // // //         'person2_intelligence_importance': p2['intelligence'] ?? '',
// // // //         'person2_circumcised': p2['circumcised'] ?? '',
// // // //         'person2_language_spoken': jsonEncode(state.partner2Languages),
// // // //       });
// // // //     }

// // // //     return payload;
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // NOTIFIER
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // // //   @override
// // // //   ProfileEditState build() {
// // // //     Future.microtask(() => loadProfile());
// // // //     return ProfileEditState(
// // // //       swingersOptions: {
// // // //         'Couple Female/Male': true,
// // // //         'Couple Female/Female': true,
// // // //         'Couple Male/Male': true,
// // // //         'Female': true,
// // // //         'Male': true,
// // // //         'Transgender': true,
// // // //       },
// // // //       hookupOptions: {
// // // //         'Couple Female/Male': true,
// // // //         'Couple Female/Female': true,
// // // //         'Couple Male/Male': true,
// // // //         'Female': true,
// // // //         'Male': true,
// // // //         'Transgender': false,
// // // //       },
// // // //       partner1: defaultPartnerTraits(),
// // // //       partner2: defaultPartnerTraits(),
// // // //       partner1Languages: [],
// // // //       partner2Languages: [],
// // // //     );
// // // //   }

// // // //   Future<void> loadProfile() async {
// // // //     final String? token = await AuthService.getToken();
// // // //     if (token == null || token.isEmpty) {
// // // //       debugPrint('No token found');
// // // //       return;
// // // //     }
// // // //     state = state.copyWith(isLoading: true);
// // // //     try {
// // // //       // TODO: Add real GET endpoint here if you have one for loading profile data.
// // // //       // For now this is a no-op so the UI doesn't break.
// // // //       debugPrint(
// // // //         'LOAD: No GET endpoint provided yet. Using default/empty state.',
// // // //       );
// // // //     } catch (e) {
// // // //       debugPrint('Error loading profile: $e');
// // // //     } finally {
// // // //       state = state.copyWith(isLoading: false);
// // // //     }
// // // //   }

// // // //   Future<void> saveProfile() async {
// // // //     final String? token = await AuthService.getToken();

// // // //     if (token == null || token.isEmpty) {
// // // //       Get.snackbar(
// // // //         'Error',
// // // //         'User token not found',
// // // //         snackPosition: SnackPosition.TOP,
// // // //         backgroundColor: Colors.red,
// // // //         colorText: Colors.white,
// // // //       );
// // // //       return;
// // // //     }

// // // //     state = state.copyWith(isLoading: true);

// // // //     try {
// // // //       if (state.isProfileDetailsTab) {
// // // //         // === NEW CLEAN API CALL ===
// // // //         final success = await ProfileApiService.saveProfileDetails(
// // // //           token: token,
// // // //           state: state,
// // // //         );

// // // //         if (success) {
// // // //           Get.snackbar(
// // // //             'Success',
// // // //             'Profile updated successfully',
// // // //             snackPosition: SnackPosition.TOP,
// // // //             backgroundColor: Colors.green,
// // // //             colorText: Colors.white,
// // // //           );
// // // //         } else {
// // // //           Get.snackbar(
// // // //             'Error',
// // // //             'Failed to update profile. Check logs.',
// // // //             snackPosition: SnackPosition.TOP,
// // // //             backgroundColor: Colors.red,
// // // //             colorText: Colors.white,
// // // //           );
// // // //         }
// // // //       } else {
// // // //         // Interests tab (add separate API later if needed)
// // // //         Get.snackbar(
// // // //           'Success',
// // // //           'Interests saved successfully',
// // // //           snackPosition: SnackPosition.TOP,
// // // //           backgroundColor: Colors.green,
// // // //           colorText: Colors.white,
// // // //         );
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error saving: $e');
// // // //       Get.snackbar(
// // // //         'Error',
// // // //         'Failed to update profile: $e',
// // // //         snackPosition: SnackPosition.TOP,
// // // //         backgroundColor: Colors.red,
// // // //         colorText: Colors.white,
// // // //       );
// // // //     } finally {
// // // //       state = state.copyWith(isLoading: false);
// // // //     }
// // // //   }

// // // //   void toggleProfileTab(bool isProfile) {
// // // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // // //   }

// // // //   void toggleSwingersExpanded() {
// // // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // // //   }

// // // //   void toggleHookupExpanded() {
// // // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // // //   }

// // // //   void updateSwingersOption(String label, bool value) {
// // // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // // //     newOptions[label] = value;
// // // //     state = state.copyWith(swingersOptions: newOptions);
// // // //   }

// // // //   void updateHookupOption(String label, bool value) {
// // // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // // //     newOptions[label] = value;
// // // //     state = state.copyWith(hookupOptions: newOptions);
// // // //   }

// // // //   void updateAboutMe(String value) {
// // // //     state = state.copyWith(aboutMe: value);
// // // //   }

// // // //   void updateLookingFor(String value) {
// // // //     state = state.copyWith(lookingFor: value);
// // // //   }

// // // //   void updatePartner1(String key, String value) {
// // // //     final newPartner = Map<String, String>.from(state.partner1);
// // // //     newPartner[key] = value;
// // // //     state = state.copyWith(partner1: newPartner);
// // // //   }

// // // //   void updatePartner2(String key, String value) {
// // // //     final newPartner = Map<String, String>.from(state.partner2);
// // // //     newPartner[key] = value;
// // // //     state = state.copyWith(partner2: newPartner);
// // // //   }

// // // //   void updatePartner1Languages(List<String> langs) {
// // // //     state = state.copyWith(partner1Languages: langs);
// // // //   }

// // // //   void updatePartner2Languages(List<String> langs) {
// // // //     state = state.copyWith(partner2Languages: langs);
// // // //   }

// // // //   Map<String, String> defaultPartnerTraits() {
// // // //     return {
// // // //       'dateOfBirth': '',
// // // //       'height': '',
// // // //       'heightType': '',
// // // //       'weight': '',
// // // //       'weightType': '',
// // // //       'bodyType': ProfileOptions.notComfortableValue,
// // // //       'ethnic': ProfileOptions.notComfortableValue,
// // // //       'sexuality': ProfileOptions.notComfortableValue,
// // // //       'orientation': ProfileOptions.notComfortableValue,
// // // //       'tattoos': ProfileOptions.notComfortableValue,
// // // //       'piercings': ProfileOptions.notComfortableValue,
// // // //       'smoking': ProfileOptions.notComfortableValue,
// // // //       'drinking': ProfileOptions.notComfortableValue,
// // // //       'bodyHair': ProfileOptions.notComfortableValue,
// // // //       'looks': ProfileOptions.notComfortableValue,
// // // //       'intelligence': ProfileOptions.notComfortableValue,
// // // //       'circumcised': ProfileOptions.notComfortableValue,
// // // //     };
// // // //   }
// // // // }

// // // // final profileEditProvider =
// // // //     NotifierProvider<ProfileEditNotifier, ProfileEditState>(
// // // //       ProfileEditNotifier.new,
// // // //     );






// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';

// // // // import 'package:beatflirt/core/services/auth_services.dart';

// // // // // -----------------------------------------------------------------------------
// // // // // PROFILE OPTIONS (unchanged - your existing data)
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileOption {
// // // //   final String id;
// // // //   final String value;
// // // //   final String label;

// // // //   const ProfileOption({
// // // //     required this.id,
// // // //     required this.value,
// // // //     required this.label,
// // // //   });

// // // //   Map<String, dynamic> toJson() {
// // // //     return {
// // // //       'id': id,
// // // //       'value': value,
// // // //       'label': label,
// // // //     };
// // // //   }
// // // // }

// // // // class ProfileOptions {
// // // //   static const String notComfortableValue = 'Im not comfortable sharing that';
// // // //   static const String notComfortableLabel = "I'm not comfortable sharing that.";

// // // //   static const ProfileOption notComfortable = ProfileOption(
// // // //     id: 'not_comfortable',
// // // //     value: notComfortableValue,
// // // //     label: notComfortableLabel,
// // // //   );

// // // //   static const List<ProfileOption> tattoos = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'none', value: 'None', label: 'None'),
// // // //     ProfileOption(id: 'one', value: 'One', label: 'One'),
// // // //     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
// // // //     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
// // // //     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
// // // //   ];

// // // //   static const List<ProfileOption> heightTypes = [
// // // //     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
// // // //     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
// // // //   ];

// // // //   static const List<ProfileOption> weightTypes = [
// // // //     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
// // // //     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
// // // //   ];

// // // //   static const List<ProfileOption> bodyTypes = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
// // // //     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
// // // //     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
// // // //     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
// // // //     ProfileOption(id: 'huggable_and_heavy', value: 'Huggable and Heavy', label: 'Huggable and Heavy'),
// // // //     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
// // // //     ProfileOption(id: 'more_of_me_to_love', value: 'More of me to love', label: 'More of me to love'),
// // // //     ProfileOption(id: 'nicely_shaped', value: 'Nicely Shaped', label: 'Nicely Shaped'),
// // // //     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
// // // //   ];

// // // //   static const List<ProfileOption> smoking = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'occasionally', value: 'Occasionally', label: 'Occasionally'),
// // // //   ];

// // // //   static const List<ProfileOption> drinking = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'occasionally', value: 'Occasionally', label: 'Occasionally'),
// // // //   ];

// // // //   static const List<ProfileOption> ethnicBackgrounds = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'other', value: 'Other', label: 'Other'),
// // // //     ProfileOption(id: 'american', value: 'American', label: 'American'),
// // // //     ProfileOption(id: 'argentine_argentinian', value: 'Argentine/Argentinian', label: 'Argentine/Argentinian'),
// // // //     ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
// // // //     ProfileOption(id: 'black_african_american', value: 'Black/African - American', label: 'Black/African - American'),
// // // //     ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
// // // //     ProfileOption(id: 'british', value: 'British', label: 'British'),
// // // //     ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
// // // //     ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
// // // //     ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
// // // //     ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
// // // //     ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
// // // //     ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
// // // //     ProfileOption(id: 'french', value: 'French', label: 'French'),
// // // //     ProfileOption(id: 'german', value: 'German', label: 'German'),
// // // //     ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
// // // //     ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
// // // //     ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
// // // //     ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
// // // //     ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
// // // //     ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
// // // //     ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
// // // //     ProfileOption(id: 'new_zealander_kiwi', value: 'New Zealander/Kiwi', label: 'New Zealander/Kiwi'),
// // // //     ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
// // // //     ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
// // // //     ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
// // // //     ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
// // // //     ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
// // // //     ProfileOption(id: 'south_african', value: 'South African', label: 'South African'),
// // // //     ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
// // // //     ProfileOption(id: 'sri_lankan', value: 'Sri Lankan', label: 'Sri Lankan'),
// // // //     ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
// // // //     ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
// // // //   ];

// // // //   static const List<ProfileOption> importanceLevels = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'low_importance', value: 'Low Importance', label: 'Low Importance'),
// // // //     ProfileOption(id: 'medium_importance', value: 'Medium Importance', label: 'Medium Importance'),
// // // //     ProfileOption(id: 'very_important', value: 'Very Important', label: 'Very Important'),
// // // //   ];

// // // //   static const List<ProfileOption> sexualities = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
// // // //     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
// // // //     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
// // // //     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
// // // //     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
// // // //     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
// // // //     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
// // // //     ProfileOption(id: 'transsexual', value: 'Transsexual', label: 'Transsexual'),
// // // //   ];

// // // //   static const List<ProfileOption> relationshipOrientations = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
// // // //     ProfileOption(id: 'open_minded', value: 'Open-Minded', label: 'Open-Minded'),
// // // //     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
// // // //     ProfileOption(id: 'polyamorous', value: 'Polyamorous', label: 'Polyamorous'),
// // // //   ];

// // // //   static const List<ProfileOption> circumcised = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //   ];

// // // //   static const List<ProfileOption> piercings = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // //   ];

// // // //   static const List<ProfileOption> bodyHair = [
// // // //     notComfortable,
// // // //     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
// // // //     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
// // // //     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
// // // //     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
// // // //   ];

// // // //   static const Map<String, List<ProfileOption>> groups = {
// // // //     'tattoos': tattoos,
// // // //     'height_types': heightTypes,
// // // //     'weight_types': weightTypes,
// // // //     'body_types': bodyTypes,
// // // //     'smoking': smoking,
// // // //     'drinking': drinking,
// // // //     'ethnic_backgrounds': ethnicBackgrounds,
// // // //     'importance_levels': importanceLevels,
// // // //     'sexualities': sexualities,
// // // //     'relationship_orientations': relationshipOrientations,
// // // //     'circumcised': circumcised,
// // // //     'piercings': piercings,
// // // //     'body_hair': bodyHair,
// // // //   };
// // // // }

// // // // class ProfileFieldOptions {
// // // //   static const Map<String, String> fieldGroupMap = {
// // // //     'bodyType': 'body_types',
// // // //     'ethnic': 'ethnic_backgrounds',
// // // //     'sexuality': 'sexualities',
// // // //     'orientation': 'relationship_orientations',
// // // //     'tattoos': 'tattoos',
// // // //     'piercings': 'piercings',
// // // //     'smoking': 'smoking',
// // // //     'drinking': 'drinking',
// // // //     'bodyHair': 'body_hair',
// // // //     'looks': 'importance_levels',
// // // //     'intelligence': 'importance_levels',
// // // //     'circumcised': 'circumcised',
// // // //     'person1_tattoos': 'tattoos',
// // // //     'person2_tattoos': 'tattoos',
// // // //     'person1_height_type': 'height_types',
// // // //     'person2_height_type': 'height_types',
// // // //     'person1_weight_type': 'weight_types',
// // // //     'person2_weight_type': 'weight_types',
// // // //     'person1_body_type': 'body_types',
// // // //     'person2_body_type': 'body_types',
// // // //     'person1_smoking': 'smoking',
// // // //     'person2_smoking': 'smoking',
// // // //     'person1_drinking': 'drinking',
// // // //     'person2_drinking': 'drinking',
// // // //     'person1_ethnic_background': 'ethnic_backgrounds',
// // // //     'person2_ethnic_background': 'ethnic_backgrounds',
// // // //     'person1_looks_important': 'importance_levels',
// // // //     'person2_looks_important': 'importance_levels',
// // // //     'person1_intelligence_importance': 'importance_levels',
// // // //     'person2_intelligence_importance': 'importance_levels',
// // // //     'person1_sexuality': 'sexualities',
// // // //     'person2_sexuality': 'sexualities',
// // // //     'person1_relationship_orientation': 'relationship_orientations',
// // // //     'person2_relationship_orientation': 'relationship_orientations',
// // // //     'person1_circumcised': 'circumcised',
// // // //     'person2_circumcised': 'circumcised',
// // // //     'person1_piercings': 'piercings',
// // // //     'person2_piercings': 'piercings',
// // // //   };

// // // //   static List<ProfileOption> getOptionsForField(String fieldName) {
// // // //     final groupKey = fieldGroupMap[fieldName];
// // // //     if (groupKey == null) return [];
// // // //     return ProfileOptions.groups[groupKey] ?? [];
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // STATE
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileEditState {
// // // //   final bool isProfileDetailsTab;
// // // //   final Map<String, bool> swingersOptions;
// // // //   final Map<String, bool> hookupOptions;
// // // //   final bool isSwingersExpanded;
// // // //   final bool isHookupExpanded;
// // // //   final String aboutMe;
// // // //   final String lookingFor;
// // // //   final Map<String, String> partner1;
// // // //   final Map<String, String> partner2;
// // // //   final List<String> partner1Languages;
// // // //   final List<String> partner2Languages;
// // // //   final bool isLoading;
// // // //   final Map<String, dynamic>? linkedPartner;

// // // //   const ProfileEditState({
// // // //     this.isProfileDetailsTab = false,
// // // //     required this.swingersOptions,
// // // //     required this.hookupOptions,
// // // //     this.isSwingersExpanded = true,
// // // //     this.isHookupExpanded = true,
// // // //     this.aboutMe = '',
// // // //     this.lookingFor = '',
// // // //     required this.partner1,
// // // //     required this.partner2,
// // // //     required this.partner1Languages,
// // // //     required this.partner2Languages,
// // // //     this.isLoading = false,
// // // //     this.linkedPartner,
// // // //   });

// // // //   ProfileEditState copyWith({
// // // //     bool? isProfileDetailsTab,
// // // //     Map<String, bool>? swingersOptions,
// // // //     Map<String, bool>? hookupOptions,
// // // //     bool? isSwingersExpanded,
// // // //     bool? isHookupExpanded,
// // // //     String? aboutMe,
// // // //     String? lookingFor,
// // // //     Map<String, String>? partner1,
// // // //     Map<String, String>? partner2,
// // // //     List<String>? partner1Languages,
// // // //     List<String>? partner2Languages,
// // // //     bool? isLoading,
// // // //     Map<String, dynamic>? linkedPartner,
// // // //   }) {
// // // //     return ProfileEditState(
// // // //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// // // //       swingersOptions: swingersOptions ?? this.swingersOptions,
// // // //       hookupOptions: hookupOptions ?? this.hookupOptions,
// // // //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// // // //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// // // //       aboutMe: aboutMe ?? this.aboutMe,
// // // //       lookingFor: lookingFor ?? this.lookingFor,
// // // //       partner1: partner1 ?? this.partner1,
// // // //       partner2: partner2 ?? this.partner2,
// // // //       partner1Languages: partner1Languages ?? this.partner1Languages,
// // // //       partner2Languages: partner2Languages ?? this.partner2Languages,
// // // //       isLoading: isLoading ?? this.isLoading,
// // // //       linkedPartner: linkedPartner ?? this.linkedPartner,
// // // //     );
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // NEW CLEAN API INTEGRATION (as per your exact spec)
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileApiService {
// // // //   static const String _singleUrl = 'https://app.beatflirtevent.com/App/user/edit_single_profile_details';
// // // //   static const String _coupleUrl = 'https://app.beatflirtevent.com/App/user/edit_couple_profile_details';

// // // //   static Map<String, String> _headers() => {
// // // //         'Accept': 'application/json',
// // // //       };

// // // //   /// Call this when user clicks "Save Profile" in the PROFILE DETAILS tab
// // // //   static Future<bool> saveProfileDetails({
// // // //     required String token,
// // // //     required ProfileEditState state,
// // // //   }) async {
// // // //     final isCouple = state.linkedPartner != null;

// // // //     final url = isCouple ? _coupleUrl : _singleUrl;

// // // //     final payload = _buildPayload(state);

// // // //     debugPrint('========== SAVING PROFILE DETAILS ==========');
// // // //     debugPrint('URL: $url');
// // // //     debugPrint('IS COUPLE: $isCouple');
// // // //     debugPrint('PAYLOAD KEYS: ${payload.keys.toList()}');

// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse(url),
// // // //         headers: _headers(),
// // // //         body: {
// // // //           ...payload,
// // // //           'token': token,           // Add token in multiple common ways
// // // //           'Authtoken': token,
// // // //         },
// // // //       );

// // // //       debugPrint('SAVE STATUS: ${response.statusCode}');
// // // //       debugPrint('SAVE BODY: ${response.body}');

// // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // //         try {
// // // //           final decoded = jsonDecode(response.body);
// // // //           if (decoded is Map) {
// // // //             final status = decoded['status']?.toString();
// // // //             final message = decoded['message']?.toString() ?? '';

// // // //             if (status == '200' || status == 'success' || message.toLowerCase().contains('success')) {
// // // //               debugPrint('✅ Profile details saved successfully');
// // // //               return true;
// // // //             }
// // // //           }
// // // //         } catch (_) {
// // // //           // If not JSON but 200, still consider success
// // // //           if (response.body.toLowerCase().contains('success')) {
// // // //             return true;
// // // //           }
// // // //         }
// // // //       }

// // // //       return false;
// // // //     } catch (e) {
// // // //       debugPrint('SAVE PROFILE DETAILS ERROR: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Map<String, String> _buildPayload(ProfileEditState state) {
// // // //     final p1 = state.partner1;
// // // //     final p2 = state.partner2;

// // // //     final isCouple = state.linkedPartner != null;

// // // //     final payload = <String, String>{
// // // //       'text': state.aboutMe,
// // // //       'comment': state.lookingFor,

// // // //       // Person 1
// // // //       'person1_name': '', // Add name field in UI/state if needed later
// // // //       'person1_dob': p1['dateOfBirth'] ?? '',
// // // //       'person1_height': p1['height'] ?? '',
// // // //       'height1_type': p1['heightType'] ?? '',
// // // //       'person1_weight': p1['weight'] ?? '',
// // // //       'weight1_type': p1['weightType'] ?? '',
// // // //       'person1_body_type': p1['bodyType'] ?? '',
// // // //       'person1_ethnic_background': p1['ethnic'] ?? '',
// // // //       'person1_sexuality': p1['sexuality'] ?? '',
// // // //       'person1_relationship_orientation': p1['orientation'] ?? '',
// // // //       'person1_tattoos': p1['tattoos'] ?? '',
// // // //       'person1_piercings': p1['piercings'] ?? '',
// // // //       'person1_smoking': p1['smoking'] ?? '',
// // // //       'person1_drinking': p1['drinking'] ?? '',
// // // //       'person1_body_hair': jsonEncode([p1['bodyHair'] ?? '']),   // as array per your spec
// // // //       'person1_looks_important': p1['looks'] ?? '',
// // // //       'person1_intelligence_importance': p1['intelligence'] ?? '',
// // // //       'person1_circumcised': p1['circumcised'] ?? '',
// // // //       'person1_language_spoken': jsonEncode(state.partner1Languages),
// // // //     };

// // // //     if (isCouple) {
// // // //       payload.addAll({
// // // //         'person2_name': '',
// // // //         'person2_dob': p2['dateOfBirth'] ?? '',
// // // //         'person2_height': p2['height'] ?? '',
// // // //         'height2_type': p2['heightType'] ?? '',
// // // //         'person2_weight': p2['weight'] ?? '',
// // // //         'weight2_type': p2['weightType'] ?? '',
// // // //         'person2_body_type': p2['bodyType'] ?? '',
// // // //         'person2_ethnic_background': p2['ethnic'] ?? '',
// // // //         'person2_sexuality': p2['sexuality'] ?? '',
// // // //         'person2_relationship_orientation': p2['orientation'] ?? '',
// // // //         'person2_tattoos': p2['tattoos'] ?? '',
// // // //         'person2_piercings': p2['piercings'] ?? '',
// // // //         'person2_smoking': p2['smoking'] ?? '',
// // // //         'person2_drinking': p2['drinking'] ?? '',
// // // //         'person2_body_hair': jsonEncode([p2['bodyHair'] ?? '']),
// // // //         'person2_looks_important': p2['looks'] ?? '',
// // // //         'person2_intelligence_importance': p2['intelligence'] ?? '',
// // // //         'person2_circumcised': p2['circumcised'] ?? '',
// // // //         'person2_language_spoken': jsonEncode(state.partner2Languages),
// // // //       });
// // // //     }

// // // //     return payload;
// // // //   }
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // NOTIFIER (API logic cleaned and updated)
// // // // // -----------------------------------------------------------------------------

// // // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // // //   @override
// // // //   ProfileEditState build() {
// // // //     Future.microtask(() => loadProfile());
// // // //     return ProfileEditState(
// // // //       swingersOptions: {
// // // //         'Couple Female/Male': true,
// // // //         'Couple Female/Female': true,
// // // //         'Couple Male/Male': true,
// // // //         'Female': true,
// // // //         'Male': true,
// // // //         'Transgender': true,
// // // //       },
// // // //       hookupOptions: {
// // // //         'Couple Female/Male': true,
// // // //         'Couple Female/Female': true,
// // // //         'Couple Male/Male': true,
// // // //         'Female': true,
// // // //         'Male': true,
// // // //         'Transgender': false,
// // // //       },
// // // //       partner1: defaultPartnerTraits(),
// // // //       partner2: defaultPartnerTraits(),
// // // //       partner1Languages: [],
// // // //       partner2Languages: [],
// // // //     );
// // // //   }

// // // //   // You can keep or replace loadProfile later.
// // // //   // For now it stays (you can remove the old getProfile call if you want).
// // // //   Future<void> loadProfile() async {
// // // //     final String? token = await AuthService.getToken();
// // // //     if (token == null || token.isEmpty) {
// // // //       debugPrint('No token found');
// // // //       return;
// // // //     }

// // // //     state = state.copyWith(isLoading: true);

// // // //     try {
// // // //       // TODO: Replace this with your real GET profile API when you have the URL
// // // //       // For now we keep the old call or you can hardcode test data
// // // //       debugPrint('LOAD PROFILE: Using old get (replace with real GET when available)');

// // // //       // Placeholder - in real app you would call a GET endpoint here
// // // //       // For testing you can temporarily hardcode data here.

// // // //     } catch (e) {
// // // //       debugPrint('Error loading profile: $e');
// // // //     } finally {
// // // //       state = state.copyWith(isLoading: false);
// // // //     }
// // // //   }

// // // //   Future<void> saveProfile() async {
// // // //     final String? token = await AuthService.getToken();

// // // //     if (token == null || token.isEmpty) {
// // // //       Get.snackbar('Error', 'User token not found',
// // // //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // // //       return;
// // // //     }

// // // //     state = state.copyWith(isLoading: true);

// // // //     try {
// // // //       if (state.isProfileDetailsTab) {
// // // //         // === NEW API INTEGRATION - PROFILE DETAILS ===
// // // //         final success = await ProfileApiService.saveProfileDetails(
// // // //           token: token,
// // // //           state: state,
// // // //         );

// // // //         if (success) {
// // // //           Get.snackbar('Success', 'Profile updated successfully',
// // // //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// // // //         } else {
// // // //           Get.snackbar('Error', 'Failed to update profile. Please try again.',
// // // //               snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // // //         }
// // // //       } else {
// // // //         // Interests tab - you can add separate API later if needed
// // // //         Get.snackbar('Success', 'Interests saved successfully',
// // // //             snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error saving profile: $e');
// // // //       Get.snackbar('Error', 'Failed to update profile: $e',
// // // //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
// // // //     } finally {
// // // //       state = state.copyWith(isLoading: false);
// // // //     }
// // // //   }

// // // //   // All the UI state update methods (unchanged)
// // // //   void toggleProfileTab(bool isProfile) {
// // // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // // //   }

// // // //   void toggleSwingersExpanded() {
// // // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // // //   }

// // // //   void toggleHookupExpanded() {
// // // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // // //   }

// // // //   void updateSwingersOption(String label, bool value) {
// // // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // // //     newOptions[label] = value;
// // // //     state = state.copyWith(swingersOptions: newOptions);
// // // //   }

// // // //   void updateHookupOption(String label, bool value) {
// // // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // // //     newOptions[label] = value;
// // // //     state = state.copyWith(hookupOptions: newOptions);
// // // //   }

// // // //   void updateAboutMe(String value) {
// // // //     state = state.copyWith(aboutMe: value);
// // // //   }

// // // //   void updateLookingFor(String value) {
// // // //     state = state.copyWith(lookingFor: value);
// // // //   }

// // // //   void updatePartner1(String key, String value) {
// // // //     final newPartner = Map<String, String>.from(state.partner1);
// // // //     newPartner[key] = value;
// // // //     state = state.copyWith(partner1: newPartner);
// // // //   }

// // // //   void updatePartner2(String key, String value) {
// // // //     final newPartner = Map<String, String>.from(state.partner2);
// // // //     newPartner[key] = value;
// // // //     state = state.copyWith(partner2: newPartner);
// // // //   }

// // // //   void updatePartner1Languages(List<String> langs) {
// // // //     state = state.copyWith(partner1Languages: langs);
// // // //   }

// // // //   void updatePartner2Languages(List<String> langs) {
// // // //     state = state.copyWith(partner2Languages: langs);
// // // //   }

// // // //   Map<String, String> defaultPartnerTraits() {
// // // //     return {
// // // //       'dateOfBirth': '',
// // // //       'height': '',
// // // //       'heightType': '',
// // // //       'weight': '',
// // // //       'weightType': '',
// // // //       'bodyType': ProfileOptions.notComfortableValue,
// // // //       'ethnic': ProfileOptions.notComfortableValue,
// // // //       'sexuality': ProfileOptions.notComfortableValue,
// // // //       'orientation': ProfileOptions.notComfortableValue,
// // // //       'tattoos': ProfileOptions.notComfortableValue,
// // // //       'piercings': ProfileOptions.notComfortableValue,
// // // //       'smoking': ProfileOptions.notComfortableValue,
// // // //       'drinking': ProfileOptions.notComfortableValue,
// // // //       'bodyHair': ProfileOptions.notComfortableValue,
// // // //       'looks': ProfileOptions.notComfortableValue,
// // // //       'intelligence': ProfileOptions.notComfortableValue,
// // // //       'circumcised': ProfileOptions.notComfortableValue,
// // // //     };
// // // //   }
// // // // }

// // // // final profileEditProvider = NotifierProvider<ProfileEditNotifier, ProfileEditState>(ProfileEditNotifier.new);

// // // // // -----------------------------------------------------------------------------
// // // // // WIDGET + UI (mostly unchanged, only save logic updated via notifier)
// // // // // -----------------------------------------------------------------------------

// // // // class MyProfileEditTab extends ConsumerWidget {
// // // //   const MyProfileEditTab({super.key});

// // // //   static const List<String> languageOptions = ['English', 'Hindi', 'German', 'French', 'Spanish'];

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final profileState = ref.watch(profileEditProvider);
// // // //     final notifier = ref.read(profileEditProvider.notifier);

// // // //     return LayoutBuilder(builder: (context, constraints) {
// // // //       final double width = constraints.maxWidth;
// // // //       final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
// // // //       final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;

// // // //       return Container(
// // // //         width: double.infinity,
// // // //         constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.62),
// // // //         padding: const EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.white,
// // // //           borderRadius: BorderRadius.circular(14),
// // // //           border: Border.all(color: const Color(0xFFE8E0F2)),
// // // //         ),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             if (profileState.isLoading)
// // // //               const Padding(
// // // //                 padding: EdgeInsets.only(bottom: 10),
// // // //                 child: LinearProgressIndicator(color: Colors.pink),
// // // //               ),
// // // //             sectionHeader(profileState, notifier),
// // // //             const SizedBox(height: 16),
// // // //             if (profileState.isProfileDetailsTab)
// // // //               buildProfileDetailsContent(context, width, profileState, notifier)
// // // //             else
// // // //               buildInterestsContent(optionWidth, profileState, notifier),
// // // //             const SizedBox(height: 18),
// // // //             Center(
// // // //               child: SizedBox(
// // // //                 width: 170,
// // // //                 child: ElevatedButton(
// // // //                   onPressed: profileState.isLoading ? null : () => notifier.saveProfile(),
// // // //                   style: ElevatedButton.styleFrom(
// // // //                     elevation: 4,
// // // //                     padding: const EdgeInsets.symmetric(vertical: 12),
// // // //                     backgroundColor: const Color(0xFF220027),
// // // //                     foregroundColor: Colors.white,
// // // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
// // // //                   ),
// // // //                   child: profileState.isLoading
// // // //                       ? const SizedBox(
// // // //                           height: 20, width: 20,
// // // //                           child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
// // // //                         )
// // // //                       : Text(
// // // //                           profileState.isProfileDetailsTab ? 'Save Profile' : 'Save Interest',
// // // //                           style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
// // // //                         ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 6),
// // // //           ],
// // // //         ),
// // // //       );
// // // //     });
// // // //   }

// // // //   // All UI helper methods below are kept exactly as in your original code (cleaned of artifacts)

// // // //   Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) { /* ... same as before ... */ 
// // // //     return Container(
// // // //       height: 38,
// // // //       padding: const EdgeInsets.symmetric(horizontal: 8),
// // // //       decoration: BoxDecoration(
// // // //         gradient: const LinearGradient(colors: [Color(0xFF19001F), Color(0xFF490040)]),
// // // //         borderRadius: BorderRadius.circular(22),
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           InkWell(
// // // //             borderRadius: BorderRadius.circular(16),
// // // //             onTap: () => notifier.toggleProfileTab(false),
// // // //             child: Container(
// // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // //               decoration: BoxDecoration(
// // // //                 color: !state.isProfileDetailsTab ? const Color(0xFFFF2D87) : Colors.transparent,
// // // //                 borderRadius: BorderRadius.circular(16),
// // // //               ),
// // // //               child: const Text('INTERESTS', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
// // // //             ),
// // // //           ),
// // // //           const Spacer(),
// // // //           InkWell(
// // // //             borderRadius: BorderRadius.circular(16),
// // // //             onTap: () => notifier.toggleProfileTab(true),
// // // //             child: Container(
// // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // //               decoration: BoxDecoration(
// // // //                 color: state.isProfileDetailsTab ? const Color(0xFFFF2D87) : Colors.transparent,
// // // //                 borderRadius: BorderRadius.circular(16),
// // // //               ),
// // // //               child: const Text('PROFILE DETAILS', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget buildInterestsContent(double optionWidth, ProfileEditState state, ProfileEditNotifier notifier) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         const Text('davidbrown', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 34, height: 1.05)),
// // // //         const SizedBox(height: 8),
// // // //         Text('What are you looking for? Select all that apply',
// // // //             style: TextStyle(color: Colors.grey[700], fontSize: 14, fontWeight: FontWeight.w500)),
// // // //         const SizedBox(height: 16),
// // // //         interestGroup(
// // // //           title: 'Swingers',
// // // //           expanded: state.isSwingersExpanded,
// // // //           onToggle: notifier.toggleSwingersExpanded,
// // // //           options: state.swingersOptions,
// // // //           optionWidth: optionWidth,
// // // //           onChanged: (label, value) => notifier.updateSwingersOption(label, value),
// // // //         ),
// // // //         const SizedBox(height: 12),
// // // //         interestGroup(
// // // //           title: 'Hookup / Meetup',
// // // //           expanded: state.isHookupExpanded,
// // // //           onToggle: notifier.toggleHookupExpanded,
// // // //           options: state.hookupOptions,
// // // //           optionWidth: optionWidth,
// // // //           onChanged: (label, value) => notifier.updateHookupOption(label, value),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget buildProfileDetailsContent(BuildContext context, double width, ProfileEditState state, ProfileEditNotifier notifier) {
// // // //     final bool stacked = width < 760;
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         textFieldLabel('INTRODUCE YOURSELF'),
// // // //         const SizedBox(height: 6),
// // // //         simpleTextField(label: 'About Me', initialValue: state.aboutMe, onChanged: notifier.updateAboutMe),
// // // //         const SizedBox(height: 10),
// // // //         textFieldLabel('LOOKING FOR'),
// // // //         const SizedBox(height: 6),
// // // //         simpleTextField(label: 'Looking For', initialValue: state.lookingFor, maxLines: 2, onChanged: notifier.updateLookingFor),
// // // //         const SizedBox(height: 14),
// // // //         const Center(child: Text('About Yourselves', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700))),
// // // //         const SizedBox(height: 12),
// // // //         if (stacked)
// // // //           Column(children: [
// // // //             partnerPanel(context: context, title: 'Partner 1', data: state.partner1, languages: state.partner1Languages,
// // // //                 onFieldChanged: notifier.updatePartner1, onLanguagesChanged: notifier.updatePartner1Languages),
// // // //             const SizedBox(height: 12),
// // // //             partnerPanel(context: context, title: 'Partner 2', data: state.partner2, languages: state.partner2Languages,
// // // //                 onFieldChanged: notifier.updatePartner2, onLanguagesChanged: notifier.updatePartner2Languages, readOnly: true),
// // // //           ])
// // // //         else
// // // //           Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // // //             Expanded(child: partnerPanel(context: context, title: 'Partner 1', data: state.partner1, languages: state.partner1Languages,
// // // //                 onFieldChanged: notifier.updatePartner1, onLanguagesChanged: notifier.updatePartner1Languages)),
// // // //             const SizedBox(width: 12),
// // // //             Expanded(child: partnerPanel(context: context, title: 'Partner 2', data: state.partner2, languages: state.partner2Languages,
// // // //                 onFieldChanged: notifier.updatePartner2, onLanguagesChanged: notifier.updatePartner2Languages, readOnly: true)),
// // // //           ]),
// // // //       ],
// // // //     );
// // // //   }

// // // //   // All remaining UI methods (partnerPanel, dateOfBirthField, heightInputField, etc.) are identical to your previous code.
// // // //   // I kept them the same for compatibility.

// // // //   Widget partnerPanel({required BuildContext context, required String title, required Map<String, String> data,
// // // //       required List<String> languages, required void Function(String, String) onFieldChanged,
// // // //       required void Function(List<String>) onLanguagesChanged, bool readOnly = false}) {
// // // //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // // //       Container(
// // // //         height: 34,
// // // //         alignment: Alignment.center,
// // // //         decoration: BoxDecoration(
// // // //           gradient: const LinearGradient(colors: [Color(0xFF19001F), Color(0xFF490040)]),
// // // //           borderRadius: BorderRadius.circular(10),
// // // //         ),
// // // //         child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
// // // //       ),
// // // //       const SizedBox(height: 10),
// // // //       dateOfBirthField(context: context, label: 'DATE OF BIRTH', data: data, keyName: 'dateOfBirth', onFieldChanged: onFieldChanged, readOnly: readOnly),
// // // //       heightInputField(data: data, onFieldChanged: onFieldChanged, readOnly: readOnly),
// // // //       weightInputField(data: data, onFieldChanged: onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('BODY TYPE', data, 'bodyType', ProfileOptions.bodyTypes, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('ETHNIC BACKGROUND', data, 'ethnic', ProfileOptions.ethnicBackgrounds, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('SEXUALITY', data, 'sexuality', ProfileOptions.sexualities, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('RELATIONSHIP ORIENTATION', data, 'orientation', ProfileOptions.relationshipOrientations, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('TATTOOS', data, 'tattoos', ProfileOptions.tattoos, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('PIERCINGS', data, 'piercings', ProfileOptions.piercings, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('SMOKING', data, 'smoking', ProfileOptions.smoking, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('DRINKING', data, 'drinking', ProfileOptions.drinking, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('BODY HAIR', data, 'bodyHair', ProfileOptions.bodyHair, onFieldChanged, readOnly: readOnly),
// // // //       languagesField(context, 'LANGUAGES SPOKEN', languages, onLanguagesChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('LOOKS IMPORTANCE', data, 'looks', ProfileOptions.importanceLevels, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('INTELLIGENCE IMPORTANCE', data, 'intelligence', ProfileOptions.importanceLevels, onFieldChanged, readOnly: readOnly),
// // // //       profileOptionDropdownField('CIRCUMCISED', data, 'circumcised', ProfileOptions.circumcised, onFieldChanged, readOnly: readOnly),
// // // //     ]);
// // // //   }

// // // //   // The rest of the UI widgets (dateOfBirthField, heightInputField, weightInputField, unitRadioButton, profileInputDecoration,
// // // //   // parseProfileDate, formatProfileDate, findProfileOption, normalize, profileOptionDropdownField, simpleTextField,
// // // //   // textFieldLabel, languagesField, openLanguageSelector, interestGroup, OptionChip) are exactly the same as your last paste.
// // // //   // They were already working, so I left them unchanged to save space.

// // // //   // If you need the full file with every single method expanded, let me know and I'll paste the complete version.
// // // // }

// // // // // -----------------------------------------------------------------------------
// // // // // OPTION CHIP (unchanged)
// // // // // -----------------------------------------------------------------------------

// // // // class OptionChip extends StatelessWidget {
// // // //   const OptionChip({super.key, required this.label, required this.selected, required this.width, required this.onTap});

// // // //   final String label;
// // // //   final bool selected;
// // // //   final double width;
// // // //   final VoidCallback onTap;

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return InkWell(
// // // //       onTap: onTap,
// // // //       borderRadius: BorderRadius.circular(8),
// // // //       child: Container(
// // // //         width: width,
// // // //         height: 42,
// // // //         padding: const EdgeInsets.symmetric(horizontal: 10),
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.white,
// // // //           borderRadius: BorderRadius.circular(8),
// // // //           border: Border.all(color: const Color(0xFFF1EBF8)),
// // // //         ),
// // // //         child: Row(
// // // //           children: [
// // // //             Expanded(child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500))),
// // // //             Checkbox(
// // // //               value: selected,
// // // //               onChanged: (_) => onTap(),
// // // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
// // // //               activeColor: const Color(0xFF47003D),
// // // //               side: const BorderSide(color: Color(0xFFE0D4EE)),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // NOTE: All the other widget methods (dateOfBirthField, heightInputField, etc.) from your original code are kept exactly as they were.
// // // // // The only changes are:
// // // // // 1. Removed old shotgun getProfile / updateProfile probing logic
// // // // // 2. Added clean ProfileApiService with your exact URLs, payload structure, and response check
// // // // // 3. saveProfile() now calls the new clean API when on Profile Details tab


// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:get/get.dart';
// // // // // // import '../core/services/auth_services.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'dart:convert';
// // // // // import 'package:beatflirt/core/services/auth_services.dart';

// // // // // // -----------------------------------------------------------------------------
// // // // // // PROFILE OPTIONS
// // // // // // -----------------------------------------------------------------------------

// // // // // class ProfileOption {
// // // // //   final String id;
// // // // //   final String value;
// // // // //   final String label;

// // // // //   const ProfileOption({
// // // // //     required this.id,
// // // // //     required this.value,
// // // // //     required this.label,
// // // // //   });

// // // // //   Map<String, dynamic> toJson() {
// // // // //     return {
// // // // //       'id': id,
// // // // //       'value': value,
// // // // //       'label': label,
// // // // //     };
// // // // //   }
// // // // // }

// // // // // class ProfileOptions {
// // // // //   static const String notComfortableValue = 'Im not comfortable sharing that';
// // // // //   static const String notComfortableLabel =
// // // // //       "I'm not comfortable sharing that.";

// // // // //   static const ProfileOption notComfortable = ProfileOption(
// // // // //     id: 'not_comfortable',
// // // // //     value: notComfortableValue,
// // // // //     label: notComfortableLabel,
// // // // //   );

// // // // //   static const List<ProfileOption> tattoos = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'none', value: 'None', label: 'None'),
// // // // //     ProfileOption(id: 'one', value: 'One', label: 'One'),
// // // // //     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
// // // // //     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
// // // // //     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
// // // // //   ];

// // // // //   static const List<ProfileOption> heightTypes = [
// // // // //     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
// // // // //     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
// // // // //   ];

// // // // //   static const List<ProfileOption> weightTypes = [
// // // // //     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
// // // // //     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
// // // // //   ];

// // // // //   static const List<ProfileOption> bodyTypes = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
// // // // //     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
// // // // //     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
// // // // //     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
// // // // //     ProfileOption(
// // // // //       id: 'huggable_and_heavy',
// // // // //       value: 'Huggable and Heavy',
// // // // //       label: 'Huggable and Heavy',
// // // // //     ),
// // // // //     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
// // // // //     ProfileOption(
// // // // //       id: 'more_of_me_to_love',
// // // // //       value: 'More of me to love',
// // // // //       label: 'More of me to love',
// // // // //     ),
// // // // //     ProfileOption(
// // // // //       id: 'nicely_shaped',
// // // // //       value: 'Nicely Shaped',
// // // // //       label: 'Nicely Shaped',
// // // // //     ),
// // // // //     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
// // // // //   ];

// // // // //   static const List<ProfileOption> smoking = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // //     ProfileOption(
// // // // //       id: 'occasionally',
// // // // //       value: 'Occasionaly',
// // // // //       label: 'Occasionally',
// // // // //     ),
// // // // //   ];

// // // // //   static const List<ProfileOption> drinking = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // //     ProfileOption(
// // // // //       id: 'occasionally',
// // // // //       value: 'Occasionaly',
// // // // //       label: 'Occasionally',
// // // // //     ),
// // // // //   ];

// // // // //   static const List<ProfileOption> ethnicBackgrounds = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'other', value: 'Other', label: 'Other'),
// // // // //     ProfileOption(id: 'american', value: 'American', label: 'American'),
// // // // //     ProfileOption(
// // // // //       id: 'argentine_argentinian',
// // // // //       value: 'Argentine/Argentinian',
// // // // //       label: 'Argentine/Argentinian',
// // // // //     ),
// // // // //     ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
// // // // //     ProfileOption(
// // // // //       id: 'black_african_american',
// // // // //       value: 'Black/African - American',
// // // // //       label: 'Black/African - American',
// // // // //     ),
// // // // //     ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
// // // // //     ProfileOption(id: 'british', value: 'British', label: 'British'),
// // // // //     ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
// // // // //     ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
// // // // //     ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
// // // // //     ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
// // // // //     ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
// // // // //     ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
// // // // //     ProfileOption(id: 'french', value: 'French', label: 'French'),
// // // // //     ProfileOption(id: 'german', value: 'German', label: 'German'),
// // // // //     ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
// // // // //     ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
// // // // //     ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
// // // // //     ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
// // // // //     ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
// // // // //     ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
// // // // //     ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
// // // // //     ProfileOption(
// // // // //       id: 'new_zealander_kiwi',
// // // // //       value: 'New Zealander/Kiwi',
// // // // //       label: 'New Zealander/Kiwi',
// // // // //     ),
// // // // //     ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
// // // // //     ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
// // // // //     ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
// // // // //     ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
// // // // //     ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
// // // // //     ProfileOption(
// // // // //       id: 'south_african',
// // // // //       value: 'South African',
// // // // //       label: 'South African',
// // // // //     ),
// // // // //     ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
// // // // //     ProfileOption(
// // // // //       id: 'sri_lankan',
// // // // //       value: 'Sri Lankan',
// // // // //       label: 'Sri Lankan',
// // // // //     ),
// // // // //     ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
// // // // //     ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
// // // // //   ];

// // // // //   static const List<ProfileOption> importanceLevels = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // //     ProfileOption(
// // // // //       id: 'low_importance',
// // // // //       value: 'Low Importance',
// // // // //       label: 'Low Importance',
// // // // //     ),
// // // // //     ProfileOption(
// // // // //       id: 'medium_importance',
// // // // //       value: 'Medium Importance',
// // // // //       label: 'Medium Importance',
// // // // //     ),
// // // // //     ProfileOption(
// // // // //       id: 'very_important',
// // // // //       value: 'Very Important',
// // // // //       label: 'Very Important',
// // // // //     ),
// // // // //   ];

// // // // //   static const List<ProfileOption> sexualities = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
// // // // //     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
// // // // //     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
// // // // //     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
// // // // //     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
// // // // //     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
// // // // //     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
// // // // //     ProfileOption(
// // // // //       id: 'transsexual',
// // // // //       value: 'Transsexual',
// // // // //       label: 'Transsexual',
// // // // //     ),
// // // // //   ];

// // // // //   static const List<ProfileOption> relationshipOrientations = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
// // // // //     ProfileOption(
// // // // //       id: 'open_minded',
// // // // //       value: 'Open-Minded',
// // // // //       label: 'Open-Minded',
// // // // //     ),
// // // // //     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
// // // // //     ProfileOption(
// // // // //       id: 'polyamorous',
// // // // //       value: 'Polyamorous',
// // // // //       label: 'Polyamorous',
// // // // //     ),
// // // // //   ];

// // // // //   static const List<ProfileOption> circumcised = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // //   ];

// // // // //   static const List<ProfileOption> piercings = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // //   ];

// // // // //   static const List<ProfileOption> bodyHair = [
// // // // //     notComfortable,
// // // // //     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
// // // // //     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
// // // // //     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
// // // // //     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
// // // // //   ];

// // // // //   static const Map<String, List<ProfileOption>> groups = {
// // // // //     'tattoos': tattoos,
// // // // //     'height_types': heightTypes,
// // // // //     'weight_types': weightTypes,
// // // // //     'body_types': bodyTypes,
// // // // //     'smoking': smoking,
// // // // //     'drinking': drinking,
// // // // //     'ethnic_backgrounds': ethnicBackgrounds,
// // // // //     'importance_levels': importanceLevels,
// // // // //     'sexualities': sexualities,
// // // // //     'relationship_orientations': relationshipOrientations,
// // // // //     'circumcised': circumcised,
// // // // //     'piercings': piercings,
// // // // //     'body_hair': bodyHair,
// // // // //   };
// // // // // }

// // // // // class ProfileFieldOptions {
// // // // //   static const Map<String, String> fieldGroupMap = {
// // // // //     'bodyType': 'body_types',
// // // // //     'ethnic': 'ethnic_backgrounds',
// // // // //     'sexuality': 'sexualities',
// // // // //     'orientation': 'relationship_orientations',
// // // // //     'tattoos': 'tattoos',
// // // // //     'piercings': 'piercings',
// // // // //     'smoking': 'smoking',
// // // // //     'drinking': 'drinking',
// // // // //     'bodyHair': 'body_hair',
// // // // //     'looks': 'importance_levels',
// // // // //     'intelligence': 'importance_levels',
// // // // //     'circumcised': 'circumcised',

// // // // //     'person1_tattoos': 'tattoos',
// // // // //     'person2_tattoos': 'tattoos',
// // // // //     'person1_height_type': 'height_types',
// // // // //     'person2_height_type': 'height_types',
// // // // //     'person1_weight_type': 'weight_types',
// // // // //     'person2_weight_type': 'weight_types',
// // // // //     'person1_body_type': 'body_types',
// // // // //     'person2_body_type': 'body_types',
// // // // //     'person1_smoking': 'smoking',
// // // // //     'person2_smoking': 'smoking',
// // // // //     'person1_drinking': 'drinking',
// // // // //     'person2_drinking': 'drinking',
// // // // //     'person1_ethnic_background': 'ethnic_backgrounds',
// // // // //     'person2_ethnic_background': 'ethnic_backgrounds',
// // // // //     'person1_looks_important': 'importance_levels',
// // // // //     'person2_looks_important': 'importance_levels',
// // // // //     'person1_intelligence_importance': 'importance_levels',
// // // // //     'person2_intelligence_importance': 'importance_levels',
// // // // //     'person1_sexuality': 'sexualities',
// // // // //     'person2_sexuality': 'sexualities',
// // // // //     'person1_relationship_orientation': 'relationship_orientations',
// // // // //     'person2_relationship_orientation': 'relationship_orientations',
// // // // //     'person1_circumcised': 'circumcised',
// // // // //     'person2_circumcised': 'circumcised',
// // // // //     'person1_piercings': 'piercings',
// // // // //     'person2_piercings': 'piercings',
// // // // //   };

// // // // //   static List<ProfileOption> getOptionsForField(String fieldName) {
// // // // //     final groupKey = fieldGroupMap[fieldName];

// // // // //     if (groupKey == null) {
// // // // //       return [];
// // // // //     }

// // // // //     return ProfileOptions.groups[groupKey] ?? [];
// // // // //   }
// // // // // }

// // // // // // -----------------------------------------------------------------------------
// // // // // // STATE
// // // // // // -----------------------------------------------------------------------------

// // // // // class ProfileEditState {
// // // // //   final bool isProfileDetailsTab;
// // // // //   final Map<String, bool> swingersOptions;
// // // // //   final Map<String, bool> hookupOptions;
// // // // //   final bool isSwingersExpanded;
// // // // //   final bool isHookupExpanded;
// // // // //   final String aboutMe;
// // // // //   final String lookingFor;
// // // // //   final Map<String, String> partner1;
// // // // //   final Map<String, String> partner2;
// // // // //   final List<String> partner1Languages;
// // // // //   final List<String> partner2Languages;
// // // // //   final bool isLoading;
// // // // //   final Map<String, dynamic>? linkedPartner;

// // // // //   const ProfileEditState({
// // // // //     this.isProfileDetailsTab = false,
// // // // //     required this.swingersOptions,
// // // // //     required this.hookupOptions,
// // // // //     this.isSwingersExpanded = true,
// // // // //     this.isHookupExpanded = true,
// // // // //     this.aboutMe = '',
// // // // //     this.lookingFor = '',
// // // // //     required this.partner1,
// // // // //     required this.partner2,
// // // // //     required this.partner1Languages,
// // // // //     required this.partner2Languages,
// // // // //     this.isLoading = false,
// // // // //     this.linkedPartner,
// // // // //   });

// // // // //   ProfileEditState copyWith({
// // // // //     bool? isProfileDetailsTab,
// // // // //     Map<String, bool>? swingersOptions,
// // // // //     Map<String, bool>? hookupOptions,
// // // // //     bool? isSwingersExpanded,
// // // // //     bool? isHookupExpanded,
// // // // //     String? aboutMe,
// // // // //     String? lookingFor,
// // // // //     Map<String, String>? partner1,
// // // // //     Map<String, String>? partner2,
// // // // //     List<String>? partner1Languages,
// // // // //     List<String>? partner2Languages,
// // // // //     bool? isLoading,
// // // // //     Map<String, dynamic>? linkedPartner,
// // // // //   }) {
// // // // //     return ProfileEditState(
// // // // //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// // // // //       swingersOptions: swingersOptions ?? this.swingersOptions,
// // // // //       hookupOptions: hookupOptions ?? this.hookupOptions,
// // // // //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// // // // //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// // // // //       aboutMe: aboutMe ?? this.aboutMe,
// // // // //       lookingFor: lookingFor ?? this.lookingFor,
// // // // //       partner1: partner1 ?? this.partner1,
// // // // //       partner2: partner2 ?? this.partner2,
// // // // //       partner1Languages: partner1Languages ?? this.partner1Languages,
// // // // //       partner2Languages: partner2Languages ?? this.partner2Languages,
// // // // //       isLoading: isLoading ?? this.isLoading,
// // // // //       linkedPartner: linkedPartner ?? this.linkedPartner,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // -----------------------------------------------------------------------------
// // // // // // NOTIFIER
// // // // // // -----------------------------------------------------------------------------

// // // // // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // // // // //
// // // // // //
// // // // // //   Map<String, String> defaultPartnerTraits() {
// // // // // //     return {
// // // // // //       'dateOfBirth': '',
// // // // // //       'height': '',
// // // // // //       'heightType': '',
// // // // // //       'weight': '',
// // // // // //       'weightType': '',
// // // // // //       'bodyType': ProfileOptions.notComfortableValue,
// // // // // //       'ethnic': ProfileOptions.notComfortableValue,
// // // // // //       'sexuality': ProfileOptions.notComfortableValue,
// // // // // //       'orientation': ProfileOptions.notComfortableValue,
// // // // // //       'tattoos': ProfileOptions.notComfortableValue,
// // // // // //       'piercings': ProfileOptions.notComfortableValue,
// // // // // //       'smoking': ProfileOptions.notComfortableValue,
// // // // // //       'drinking': ProfileOptions.notComfortableValue,
// // // // // //       'bodyHair': ProfileOptions.notComfortableValue,
// // // // // //       'looks': ProfileOptions.notComfortableValue,
// // // // // //       'intelligence': ProfileOptions.notComfortableValue,
// // // // // //       'circumcised': ProfileOptions.notComfortableValue,
// // // // // //     };
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   ProfileEditState build() {
// // // // // //     Future.microtask(() => loadProfile());
// // // // // //
// // // // // //     return ProfileEditState(
// // // // // //       swingersOptions: {
// // // // // //         'Couple Female/Male': true,
// // // // // //         'Couple Female/Female': true,
// // // // // //         'Couple Male/Male': true,
// // // // // //         'Female': true,
// // // // // //         'Male': true,
// // // // // //         'Transgender': true,
// // // // // //       },
// // // // // //       hookupOptions: {
// // // // // //         'Couple Female/Male': true,
// // // // // //         'Couple Female/Female': true,
// // // // // //         'Couple Male/Male': true,
// // // // // //         'Female': true,
// // // // // //         'Male': true,
// // // // // //         'Transgender': false,
// // // // // //       },
// // // // // //       partner1: defaultPartnerTraits(),
// // // // // //       partner2: defaultPartnerTraits(),
// // // // // //       partner1Languages: [],
// // // // // //       partner2Languages: [],
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Future<void> loadProfile() async {
// // // // // //     final String? token = await AuthService.getToken();
// // // // // //     if (token == null) return;
// // // // // //
// // // // // //     state = state.copyWith(isLoading: true);
// // // // // //
// // // // // //     try {
// // // // // //       // final data = await apiServices.getProfile(token: token);
// // // // // //       final data = await AuthSerivce.getProfile(token:token);
// // // // // //       final user = data['user'];
// // // // // //
// // // // // //       if (user != null) {
// // // // // //         final mergedTraits = defaultPartnerTraits();
// // // // // //         final backendTraits =
// // // // // //         Map<String, dynamic>.from(user['partner1Traits'] ?? {});
// // // // // //
// // // // // //         backendTraits.forEach((key, value) {
// // // // // //           if (mergedTraits.containsKey(key)) {
// // // // // //             mergedTraits[key] = value.toString();
// // // // // //           }
// // // // // //         });
// // // // // //
// // // // // //         final linked = user['partnerId'];
// // // // // //
// // // // // //         final Map<String, String> p2Traits = defaultPartnerTraits();
// // // // // //         List<String> p2Langs = [];
// // // // // //         Map<String, dynamic>? linkedMap;
// // // // // //
// // // // // //         if (linked is Map) {
// // // // // //           linkedMap = Map<String, dynamic>.from(linked);
// // // // // //
// // // // // //           final lpTraits =
// // // // // //           Map<String, dynamic>.from(linkedMap['partner1Traits'] ?? {});
// // // // // //
// // // // // //           lpTraits.forEach((key, value) {
// // // // // //             if (p2Traits.containsKey(key)) {
// // // // // //               p2Traits[key] = value.toString();
// // // // // //             }
// // // // // //           });
// // // // // //
// // // // // //           p2Langs = List<String>.from(linkedMap['partner1Languages'] ?? []);
// // // // // //         }
// // // // // //
// // // // // //         final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
// // // // // //         final backendSwingers =
// // // // // //         Map<String, dynamic>.from(user['swingersOptions'] ?? {});
// // // // // //
// // // // // //         backendSwingers.forEach((key, value) {
// // // // // //           if (mergedSwingers.containsKey(key)) {
// // // // // //             mergedSwingers[key] = value == true;
// // // // // //           }
// // // // // //         });
// // // // // //
// // // // // //         final mergedHookup = Map<String, bool>.from(state.hookupOptions);
// // // // // //         final backendHookup =
// // // // // //         Map<String, dynamic>.from(user['hookupOptions'] ?? {});
// // // // // //
// // // // // //         backendHookup.forEach((key, value) {
// // // // // //           if (mergedHookup.containsKey(key)) {
// // // // // //             mergedHookup[key] = value == true;
// // // // // //           }
// // // // // //         });
// // // // // //
// // // // // //         state = state.copyWith(
// // // // // //           aboutMe: user['aboutMe'] ?? '',
// // // // // //           lookingFor: user['lookingFor'] ?? '',
// // // // // //           partner1: mergedTraits,
// // // // // //           partner1Languages:
// // // // // //           List<String>.from(user['partner1Languages'] ?? []),
// // // // // //           swingersOptions: mergedSwingers,
// // // // // //           hookupOptions: mergedHookup,
// // // // // //           partner2: p2Traits,
// // // // // //           partner2Languages: p2Langs,
// // // // // //           linkedPartner: linkedMap,
// // // // // //         );
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint('Error loading profile: $e');
// // // // // //     } finally {
// // // // // //       state = state.copyWith(isLoading: false);
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   Future<void> saveProfile() async {
// // // // // //     final token = await AuthService.getToken();
// // // // // //     if (token == null) return;
// // // // // //
// // // // // //     state = state.copyWith(isLoading: true);
// // // // // //
// // // // // //     try {
// // // // // //       final updates = {
// // // // // //         'aboutMe': state.aboutMe,
// // // // // //         'lookingFor': state.lookingFor,
// // // // // //         'partner1Traits': state.partner1,
// // // // // //         'partner1Languages': state.partner1Languages,
// // // // // //         'swingersOptions': state.swingersOptions,
// // // // // //         'hookupOptions': state.hookupOptions,
// // // // // //       };
// // // // // //
// // // // // //       // await apiServices.updateProfile(token: token, updates: updates);
// // // // // //
// // // // // //       Get.snackbar(
// // // // // //         'Success',
// // // // // //         'Profile updated successfully',
// // // // // //         snackPosition: SnackPosition.TOP,
// // // // // //         backgroundColor: Colors.green,
// // // // // //         colorText: Colors.white,
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       Get.snackbar(
// // // // // //         'Error',
// // // // // //         'Failed to update profile: $e',
// // // // // //         snackPosition: SnackPosition.TOP,
// // // // // //         backgroundColor: Colors.red,
// // // // // //         colorText: Colors.white,
// // // // // //       );
// // // // // //     } finally {
// // // // // //       state = state.copyWith(isLoading: false);
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   void toggleProfileTab(bool isProfile) {
// // // // // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // // // // //   }
// // // // // //
// // // // // //   void toggleSwingersExpanded() {
// // // // // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // // // // //   }
// // // // // //
// // // // // //   void toggleHookupExpanded() {
// // // // // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // // // // //   }
// // // // // //
// // // // // //   void updateSwingersOption(String label, bool value) {
// // // // // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // // // // //     newOptions[label] = value;
// // // // // //     state = state.copyWith(swingersOptions: newOptions);
// // // // // //   }
// // // // // //
// // // // // //   void updateHookupOption(String label, bool value) {
// // // // // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // // // // //     newOptions[label] = value;
// // // // // //     state = state.copyWith(hookupOptions: newOptions);
// // // // // //   }
// // // // // //
// // // // // //   void updateAboutMe(String value) {
// // // // // //     state = state.copyWith(aboutMe: value);
// // // // // //   }
// // // // // //
// // // // // //   void updateLookingFor(String value) {
// // // // // //     state = state.copyWith(lookingFor: value);
// // // // // //   }
// // // // // //
// // // // // //   void updatePartner1(String key, String value) {
// // // // // //     final newPartner = Map<String, String>.from(state.partner1);
// // // // // //     newPartner[key] = value;
// // // // // //     state = state.copyWith(partner1: newPartner);
// // // // // //   }
// // // // // //
// // // // // //   void updatePartner2(String key, String value) {
// // // // // //     final newPartner = Map<String, String>.from(state.partner2);
// // // // // //     newPartner[key] = value;
// // // // // //     state = state.copyWith(partner2: newPartner);
// // // // // //   }
// // // // // //
// // // // // //   void updatePartner1Languages(List<String> langs) {
// // // // // //     state = state.copyWith(partner1Languages: langs);
// // // // // //   }
// // // // // //
// // // // // //   void updatePartner2Languages(List<String> langs) {
// // // // // //     state = state.copyWith(partner2Languages: langs);
// // // // // //   }
// // // // // // }
// // // // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //   // API URLS
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //
// // // // // //   static const String _getProfileUrl =
// // // // // //       'https://app.beatflirtevent.com/App/user/signle_user_profile';
// // // // // //
// // // // // //   // IMPORTANT:
// // // // // //   // If your backend update profile endpoint is different, replace this URL.
// // // // // //   static const String _updateProfileUrl =
// // // // // //       'https://app.beatflirtevent.com/App/user/update_profile';
// // // // // //
// // // // // //   Map<String, String> _authHeaders(String token) {
// // // // // //     return {
// // // // // //       'Accept': 'application/json',
// // // // // //       'Content-Type': 'application/json',
// // // // // //       'Authorization': 'Bearer $token',
// // // // // //
// // // // // //       // Keeping these because your backend may be PHP/custom and may expect token.
// // // // // //       'token': token,
// // // // // //       'Token': token,
// // // // // //       'Authtoken': token,
// // // // // //     };
// // // // // //   }
// // // // // //
// // // // // //   Future<Map<String, dynamic>> _getProfile({
// // // // // //     required String token,
// // // // // //   }) async {
// // // // // //     final response = await http.get(
// // // // // //       Uri.parse(_getProfileUrl),
// // // // // //       headers: _authHeaders(token),
// // // // // //     );
// // // // // //
// // // // // //     debugPrint('GET PROFILE STATUS: ${response.statusCode}');
// // // // // //     debugPrint('GET PROFILE BODY: ${response.body}');
// // // // // //
// // // // // //     if (response.statusCode < 200 || response.statusCode >= 300) {
// // // // // //       throw Exception('Failed to load profile: ${response.statusCode}');
// // // // // //     }
// // // // // //
// // // // // //     final decoded = jsonDecode(response.body);
// // // // // //
// // // // // //     if (decoded is Map<String, dynamic>) {
// // // // // //       return decoded;
// // // // // //     }
// // // // // //
// // // // // //     throw Exception('Invalid profile response');
// // // // // //   }
// // // // // //   //
// // // // // //   // Future<void> _updateProfile({
// // // // // //   //   required String token,
// // // // // //   //   required Map<String, dynamic> updates,
// // // // // //   // }) async {
// // // // // //   //   final response = await http.post(
// // // // // //   //     Uri.parse(_updateProfileUrl),
// // // // // //   //     headers: _authHeaders(token),
// // // // // //   //     body: jsonEncode(updates),
// // // // // //   //   );
// // // // // //   //
// // // // // //   //   debugPrint('UPDATE PROFILE STATUS: ${response.statusCode}');
// // // // // //   //   debugPrint('UPDATE PROFILE BODY: ${response.body}');
// // // // // //   //
// // // // // //   //   if (response.statusCode < 200 || response.statusCode >= 300) {
// // // // // //   //     throw Exception('Failed to update profile: ${response.statusCode}');
// // // // // //   //   }
// // // // // //   // }
// // // // // //   Future<void> _updateProfile({
// // // // // //     required String token,
// // // // // //     required Map<String, dynamic> updates,
// // // // // //   }) async {
// // // // // //     final possibleUrls = [
// // // // // //       'https://app.beatflirtevent.com/App/user/update_profile',
// // // // // //       'https://app.beatflirtevent.com/App/user/update_user_profile',
// // // // // //       'https://app.beatflirtevent.com/App/user/update_profile_details',
// // // // // //       'https://app.beatflirtevent.com/App/user/update_profile_detail',
// // // // // //       'https://app.beatflirtevent.com/App/user/save_profile',
// // // // // //       'https://app.beatflirtevent.com/App/user/save_profile_details',
// // // // // //       'https://app.beatflirtevent.com/App/user/profile_update',
// // // // // //       'https://app.beatflirtevent.com/App/user/user_profile_update',
// // // // // //       'https://app.beatflirtevent.com/App/user/edit_profile',
// // // // // //       'https://app.beatflirtevent.com/App/user/edit_user_profile',
// // // // // //       'https://app.beatflirtevent.com/App/user/update_user',
// // // // // //       'https://app.beatflirtevent.com/App/user/update_user_details',
// // // // // //       'https://app.beatflirtevent.com/App/user/save_user_profile',
// // // // // //       'https://app.beatflirtevent.com/App/user/profile_details',
// // // // // //       'https://app.beatflirtevent.com/App/user/signle_user_profile',
// // // // // //     ];
// // // // // //
// // // // // //     for (final url in possibleUrls) {
// // // // // //       try {
// // // // // //         final response = await http.post(
// // // // // //           Uri.parse(url),
// // // // // //           headers: {
// // // // // //             'Accept': 'application/json',
// // // // // //             'Authorization': 'Bearer $token',
// // // // // //             'token': token,
// // // // // //             'Token': token,
// // // // // //             'Authtoken': token,
// // // // // //           },
// // // // // //           body: {
// // // // // //             'token': token,
// // // // // //             'probe': '1',
// // // // // //           },
// // // // // //         );
// // // // // //
// // // // // //         final bodyPreview = response.body.length > 300
// // // // // //             ? response.body.substring(0, 300)
// // // // // //             : response.body;
// // // // // //
// // // // // //         debugPrint('-------------------------------');
// // // // // //         debugPrint('PROBE UPDATE URL: $url');
// // // // // //         debugPrint('STATUS: ${response.statusCode}');
// // // // // //         debugPrint('BODY: $bodyPreview');
// // // // // //
// // // // // //         final isHtml404 = response.body.contains('404 Page Not Found') ||
// // // // // //             response.body.contains('The page you requested was not found');
// // // // // //
// // // // // //         if (response.statusCode != 404 && !isHtml404) {
// // // // // //           debugPrint('✅ POSSIBLE UPDATE ENDPOINT FOUND: $url');
// // // // // //         }
// // // // // //       } catch (e) {
// // // // // //         debugPrint('PROBE ERROR for $url: $e');
// // // // // //       }
// // // // // //     }
// // // // // //
// // // // // //     throw Exception(
// // // // // //       'Update profile endpoint not found. Check console logs for POSSIBLE UPDATE ENDPOINT FOUND.',
// // // // // //     );
// // // // // //   }


// // // // // // ---------------------------------------------------------------------------
// // // // // // API URLS
// // // // // // ---------------------------------------------------------------------------


// // // // // static const String getProfileUrl =
// // // // //     'https://app.beatflirtevent.com/App/user/signle_user_profile';

// // // // // // We do not know the real update URL yet.
// // // // // // This list will probe possible endpoints and print logs.
// // // // // static const List<String> updateProfileCandidateUrls = [
// // // // //   'https://app.beatflirtevent.com/App/user/update_profile',
// // // // //   'https://app.beatflirtevent.com/App/user/update_user_profile',
// // // // //   'https://app.beatflirtevent.com/App/user/update_profile_details',
// // // // //   'https://app.beatflirtevent.com/App/user/update_profile_detail',
// // // // //   'https://app.beatflirtevent.com/App/user/save_profile',
// // // // //   'https://app.beatflirtevent.com/App/user/save_profile_details',
// // // // //   'https://app.beatflirtevent.com/App/user/profile_update',
// // // // //   'https://app.beatflirtevent.com/App/user/user_profile_update',
// // // // //   'https://app.beatflirtevent.com/App/user/edit_profile',
// // // // //   'https://app.beatflirtevent.com/App/user/edit_user_profile',
// // // // //   'https://app.beatflirtevent.com/App/user/update_user',
// // // // //   'https://app.beatflirtevent.com/App/user/update_user_details',
// // // // //   'https://app.beatflirtevent.com/App/user/save_user_profile',
// // // // //   'https://app.beatflirtevent.com/App/user/profile_details',
// // // // //   'https://app.beatflirtevent.com/App/user/saveProfileDetails',
// // // // //   'https://app.beatflirtevent.com/App/user/updateProfileDetails',
// // // // //   'https://app.beatflirtevent.com/App/user/update_profile_data',
// // // // //   'https://app.beatflirtevent.com/App/user/save_profile_data',
// // // // // ];

// // // // // Map<String, String> apiHeaders({
// // // // //   bool json = false,
// // // // // }) {
// // // // //   return {
// // // // //     'Accept': 'application/json',
// // // // //     if (json) 'Content-Type': 'application/json',
// // // // //   };
// // // // // }

// // // // // bool isHtml404(String body) {
// // // // //   return body.contains('404 Page Not Found') ||
// // // // //       body.contains('The page you requested was not found');
// // // // // }

// // // // // String extractErrorFromHtml(String body) {
// // // // //   try {
// // // // //     var clean = body.replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false), '');
// // // // //     clean = clean.replaceAll(RegExp(r'<script[^>]*>[\s\S]*?</script>', caseSensitive: false), '');
// // // // //     clean = clean.replaceAll(RegExp(r'<[^>]*>'), ' ');
// // // // //     clean = clean.replaceAll(RegExp(r'\s+'), ' ').trim();
// // // // //     if (clean.isEmpty) return 'Empty HTML Response';
// // // // //     return clean.length > 250 ? '${clean.substring(0, 250)}...' : clean;
// // // // //   } catch (e) {
// // // // //     return 'Failed to parse error: $e';
// // // // //   }
// // // // // }

// // // // // bool isTokenMissingBody(String body) {
// // // // //   final lower = body.toLowerCase();
// // // // //   return lower.contains('please provide token') ||
// // // // //       lower.contains('provide token') ||
// // // // //       lower.contains('token required');
// // // // // }

// // // // // Map<String, dynamic>? decodeMapResponse(String body) {
// // // // //   try {
// // // // //     final decoded = jsonDecode(body);
// // // // //     if (decoded is Map<String, dynamic>) {
// // // // //       return decoded;
// // // // //     }
// // // // //   } catch (_) {}

// // // // //   return null;
// // // // // }

// // // // // // ---------------------------------------------------------------------------
// // // // // // GET PROFILE
// // // // // // ---------------------------------------------------------------------------

// // // // // Future<Map<String, dynamic>> getProfile({
// // // // //   required String token,
// // // // // }) async {
// // // // //   debugPrint('-------------------------------');
// // // // //   debugPrint('TOKEN DEBUG length: ${token.length}');
// // // // //   debugPrint(
// // // // //     'TOKEN DEBUG preview: ${token.length > 12 ? token.substring(0, 12) : token}',
// // // // //   );

// // // // //   final uri = Uri.parse(getProfileUrl);

// // // // //   final attempts = <Future<http.Response> Function()>[
// // // // //     // Most likely for your PHP/CodeIgniter backend
// // // // //         () => http.post(
// // // // //       uri,
// // // // //       headers: apiHeaders(),
// // // // //       body: {
// // // // //         'token': token,
// // // // //       },
// // // // //     ),

// // // // //         () => http.post(
// // // // //       uri,
// // // // //       headers: apiHeaders(),
// // // // //       body: {
// // // // //         'Authtoken': token,
// // // // //       },
// // // // //     ),

// // // // //         () => http.post(
// // // // //       uri,
// // // // //       headers: apiHeaders(),
// // // // //       body: {
// // // // //         'Token': token,
// // // // //       },
// // // // //     ),

// // // // //     // Header variants
// // // // //         () => http.get(
// // // // //       uri,
// // // // //       headers: {
// // // // //         ...apiHeaders(),
// // // // //         'token': token,
// // // // //       },
// // // // //     ),

// // // // //         () => http.get(
// // // // //       uri,
// // // // //       headers: {
// // // // //         ...apiHeaders(),
// // // // //         'Token': token,
// // // // //       },
// // // // //     ),

// // // // //         () => http.get(
// // // // //       uri,
// // // // //       headers: {
// // // // //         ...apiHeaders(),
// // // // //         'Authtoken': token,
// // // // //       },
// // // // //     ),

// // // // //         () => http.get(
// // // // //       uri,
// // // // //       headers: {
// // // // //         ...apiHeaders(),
// // // // //         'Authorization': 'Bearer $token',
// // // // //       },
// // // // //     ),

// // // // //     // Query variants
// // // // //         () => http.get(
// // // // //       Uri.parse('$getProfileUrl?token=$token'),
// // // // //       headers: apiHeaders(),
// // // // //     ),

// // // // //         () => http.get(
// // // // //       Uri.parse('$getProfileUrl?Authtoken=$token'),
// // // // //       headers: apiHeaders(),
// // // // //     ),
// // // // //   ];

// // // // //   for (int i = 0; i < attempts.length; i++) {
// // // // //     final response = await attempts[i]();

// // // // //     final displayBody = (response.body.contains('<html') ||
// // // // //             response.body.contains('<!DOCTYPE') ||
// // // // //             isHtml404(response.body))
// // // // //         ? '[HTML Error: ${extractErrorFromHtml(response.body)}]'
// // // // //         : response.body;

// // // // //     debugPrint('-------------------------------');
// // // // //     debugPrint('GET PROFILE ATTEMPT: ${i + 1}');
// // // // //     debugPrint('GET PROFILE STATUS: ${response.statusCode}');
// // // // //     debugPrint('GET PROFILE BODY: $displayBody');

// // // // //     if (response.statusCode < 200 || response.statusCode >= 300) {
// // // // //       continue;
// // // // //     }

// // // // //     if (isHtml404(response.body)) {
// // // // //       continue;
// // // // //     }

// // // // //     if (isTokenMissingBody(response.body)) {
// // // // //       continue;
// // // // //     }

// // // // //     final decoded = decodeMapResponse(response.body);

// // // // //     if (decoded != null) {
// // // // //       return decoded;
// // // // //     }
// // // // //   }

// // // // //   throw Exception(
// // // // //     'Profile API token failed. Backend did not accept token from headers/body/query.',
// // // // //   );
// // // // // }

// // // // // // ---------------------------------------------------------------------------
// // // // // // UPDATE PROFILE PROBE
// // // // // // ---------------------------------------------------------------------------

// // // // // Map<String, String> buildProfileFormBody({
// // // // //   required String token,
// // // // //   required Map<String, dynamic> updates,
// // // // // }) {
// // // // //   final partner1Traits =
// // // // //   Map<String, dynamic>.from(updates['partner1Traits'] ?? {});

// // // // //   final partner1Languages =
// // // // //   List<dynamic>.from(updates['partner1Languages'] ?? []);

// // // // //   final swingersOptions =
// // // // //   Map<String, dynamic>.from(updates['swingersOptions'] ?? {});

// // // // //   final hookupOptions =
// // // // //   Map<String, dynamic>.from(updates['hookupOptions'] ?? {});

// // // // //   return {
// // // // //     // token variants
// // // // //     'token': token,
// // // // //     'Token': token,
// // // // //     'Authtoken': token,

// // // // //     // app style fields
// // // // //     'aboutMe': updates['aboutMe']?.toString() ?? '',
// // // // //     'lookingFor': updates['lookingFor']?.toString() ?? '',
// // // // //     'partner1Traits': jsonEncode(partner1Traits),
// // // // //     'partner1Languages': jsonEncode(partner1Languages),
// // // // //     'swingersOptions': jsonEncode(swingersOptions),
// // // // //     'hookupOptions': jsonEncode(hookupOptions),

// // // // //     // angular/original form fields
// // // // //     'text': updates['aboutMe']?.toString() ?? '',
// // // // //     'comment': updates['lookingFor']?.toString() ?? '',

// // // // //     'person1_dob': partner1Traits['dateOfBirth']?.toString() ?? '',
// // // // //     'person1_height': partner1Traits['height']?.toString() ?? '',
// // // // //     'height1_type': partner1Traits['heightType']?.toString() ?? '',
// // // // //     'person1_weight': partner1Traits['weight']?.toString() ?? '',
// // // // //     'weight1_type': partner1Traits['weightType']?.toString() ?? '',

// // // // //     'person1_body_type': partner1Traits['bodyType']?.toString() ?? '',
// // // // //     'person1_ethnic_background':
// // // // //     partner1Traits['ethnic']?.toString() ?? '',
// // // // //     'person1_sexuality': partner1Traits['sexuality']?.toString() ?? '',
// // // // //     'person1_relationship_orientation':
// // // // //     partner1Traits['orientation']?.toString() ?? '',
// // // // //     'person1_tattoos': partner1Traits['tattoos']?.toString() ?? '',
// // // // //     'person1_piercings': partner1Traits['piercings']?.toString() ?? '',
// // // // //     'person1_smoking': partner1Traits['smoking']?.toString() ?? '',
// // // // //     'person1_drinking': partner1Traits['drinking']?.toString() ?? '',
// // // // //     'person1_body_hair': partner1Traits['bodyHair']?.toString() ?? '',
// // // // //     'person1_looks_important': partner1Traits['looks']?.toString() ?? '',
// // // // //     'person1_intelligence_importance':
// // // // //     partner1Traits['intelligence']?.toString() ?? '',
// // // // //     'person1_circumcised': partner1Traits['circumcised']?.toString() ?? '',
// // // // //     'person1_language_spoken': jsonEncode(partner1Languages),
// // // // //   };
// // // // // }

// // // // // Future<void> updateProfile({
// // // // //   required String token,
// // // // //   required Map<String, dynamic> updates,
// // // // // }) async {
// // // // //   final formBody = buildProfileFormBody(
// // // // //     token: token,
// // // // //     updates: updates,
// // // // //   );

// // // // //   for (final url in updateProfileCandidateUrls) {
// // // // //     try {
// // // // //       final response = await http.post(
// // // // //         Uri.parse(url),
// // // // //         headers: apiHeaders(),
// // // // //         body: formBody,
// // // // //       );

// // // // //       final displayBody = (response.body.contains('<html') ||
// // // // //               response.body.contains('<!DOCTYPE') ||
// // // // //               isHtml404(response.body))
// // // // //           ? '[HTML Error: ${extractErrorFromHtml(response.body)}]'
// // // // //           : (response.body.length > 500
// // // // //               ? response.body.substring(0, 500)
// // // // //               : response.body);

// // // // //       debugPrint('-------------------------------');
// // // // //       debugPrint('PROBE UPDATE URL: $url');
// // // // //       debugPrint('STATUS: ${response.statusCode}');
// // // // //       debugPrint('BODY: $displayBody');

// // // // //       final html404 = isHtml404(response.body);
// // // // //       final tokenMissing = isTokenMissingBody(response.body);

// // // // //       if (response.statusCode >= 200 &&
// // // // //           response.statusCode < 300 &&
// // // // //           !html404 &&
// // // // //           !tokenMissing) {
// // // // //         debugPrint('✅ POSSIBLE UPDATE ENDPOINT FOUND: $url');

// // // // //         final decoded = decodeMapResponse(response.body);

// // // // //         if (decoded != null) {
// // // // //           final status = decoded['status']?.toString().toLowerCase();
// // // // //           final message = decoded['message']?.toString() ?? '';

// // // // //           debugPrint('UPDATE DECODED STATUS: $status');
// // // // //           debugPrint('UPDATE DECODED MESSAGE: $message');

// // // // //           if (status == 'success' ||
// // // // //               status == 'true' ||
// // // // //               status == '200' ||
// // // // //               decoded['success'] == true) {
// // // // //             return;
// // // // //           }
// // // // //         }

// // // // //         // If backend returns non-standard success text, still allow it.
// // // // //         return;
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('PROBE ERROR for $url: $e');
// // // // //     }
// // // // //   }

// // // // //   throw Exception(
// // // // //     'Update profile endpoint not found. Open console and check PROBE UPDATE URL logs.',
// // // // //   );
// // // // // }
// // // // //   // ---------------------------------------------------------------------------
// // // // //   // DEFAULT DATA
// // // // //   // ---------------------------------------------------------------------------

// // // // //   Map<String, String> defaultPartnerTraits() {
// // // // //     return {
// // // // //       'dateOfBirth': '',

// // // // //       'height': '',
// // // // //       'heightType': '',

// // // // //       'weight': '',
// // // // //       'weightType': '',

// // // // //       'bodyType': ProfileOptions.notComfortableValue,
// // // // //       'ethnic': ProfileOptions.notComfortableValue,
// // // // //       'sexuality': ProfileOptions.notComfortableValue,
// // // // //       'orientation': ProfileOptions.notComfortableValue,
// // // // //       'tattoos': ProfileOptions.notComfortableValue,
// // // // //       'piercings': ProfileOptions.notComfortableValue,
// // // // //       'smoking': ProfileOptions.notComfortableValue,
// // // // //       'drinking': ProfileOptions.notComfortableValue,
// // // // //       'bodyHair': ProfileOptions.notComfortableValue,
// // // // //       'looks': ProfileOptions.notComfortableValue,
// // // // //       'intelligence': ProfileOptions.notComfortableValue,
// // // // //       'circumcised': ProfileOptions.notComfortableValue,
// // // // //     };
// // // // //   }

// // // // //   @override
// // // // //   ProfileEditState build() {
// // // // //     Future.microtask(() => loadProfile());

// // // // //     return ProfileEditState(
// // // // //       swingersOptions: {
// // // // //         'Couple Female/Male': true,
// // // // //         'Couple Female/Female': true,
// // // // //         'Couple Male/Male': true,
// // // // //         'Female': true,
// // // // //         'Male': true,
// // // // //         'Transgender': true,
// // // // //       },
// // // // //       hookupOptions: {
// // // // //         'Couple Female/Male': true,
// // // // //         'Couple Female/Female': true,
// // // // //         'Couple Male/Male': true,
// // // // //         'Female': true,
// // // // //         'Male': true,
// // // // //         'Transgender': false,
// // // // //       },
// // // // //       partner1: defaultPartnerTraits(),
// // // // //       partner2: defaultPartnerTraits(),
// // // // //       partner1Languages: [],
// // // // //       partner2Languages: [],
// // // // //     );
// // // // //   }

// // // // //   // ---------------------------------------------------------------------------
// // // // //   // LOAD PROFILE
// // // // //   // ---------------------------------------------------------------------------
// // // // //   //
// // // // //   // Future<void> loadProfile() async {
// // // // //   //   final String? token = await AuthService.getToken();
// // // // //   //
// // // // //   //   if (token == null || token.isEmpty) {
// // // // //   //     debugPrint('No token found');
// // // // //   //     return;
// // // // //   //   }
// // // // //   //
// // // // //   //   state = state.copyWith(isLoading: true);
// // // // //   //
// // // // //   //   try {
// // // // //   //     final data = await _getProfile(token: token);
// // // // //   //     final user = data['user'];
// // // // //   //
// // // // //   //     if (user != null) {
// // // // //   //       final mergedTraits = defaultPartnerTraits();
// // // // //   //
// // // // //   //       final backendTraits =
// // // // //   //       Map<String, dynamic>.from(user['partner1Traits'] ?? {});
// // // // //   //
// // // // //   //       backendTraits.forEach((key, value) {
// // // // //   //         if (mergedTraits.containsKey(key)) {
// // // // //   //           mergedTraits[key] = value.toString();
// // // // //   //         }
// // // // //   //       });
// // // // //   //
// // // // //   //       final linked = user['partnerId'];
// // // // //   //
// // // // //   //       final Map<String, String> p2Traits = defaultPartnerTraits();
// // // // //   //       List<String> p2Langs = [];
// // // // //   //       Map<String, dynamic>? linkedMap;
// // // // //   //
// // // // //   //       if (linked is Map) {
// // // // //   //         linkedMap = Map<String, dynamic>.from(linked);
// // // // //   //
// // // // //   //         final lpTraits =
// // // // //   //         Map<String, dynamic>.from(linkedMap['partner1Traits'] ?? {});
// // // // //   //
// // // // //   //         lpTraits.forEach((key, value) {
// // // // //   //           if (p2Traits.containsKey(key)) {
// // // // //   //             p2Traits[key] = value.toString();
// // // // //   //           }
// // // // //   //         });
// // // // //   //
// // // // //   //         p2Langs = List<String>.from(linkedMap['partner1Languages'] ?? []);
// // // // //   //       }
// // // // //   //
// // // // //   //       final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
// // // // //   //       final backendSwingers =
// // // // //   //       Map<String, dynamic>.from(user['swingersOptions'] ?? {});
// // // // //   //
// // // // //   //       backendSwingers.forEach((key, value) {
// // // // //   //         if (mergedSwingers.containsKey(key)) {
// // // // //   //           mergedSwingers[key] = value == true;
// // // // //   //         }
// // // // //   //       });
// // // // //   //
// // // // //   //       final mergedHookup = Map<String, bool>.from(state.hookupOptions);
// // // // //   //       final backendHookup =
// // // // //   //       Map<String, dynamic>.from(user['hookupOptions'] ?? {});
// // // // //   //
// // // // //   //       backendHookup.forEach((key, value) {
// // // // //   //         if (mergedHookup.containsKey(key)) {
// // // // //   //           mergedHookup[key] = value == true;
// // // // //   //         }
// // // // //   //       });
// // // // //   //
// // // // //   //       state = state.copyWith(
// // // // //   //         aboutMe: user['aboutMe'] ?? '',
// // // // //   //         lookingFor: user['lookingFor'] ?? '',
// // // // //   //         partner1: mergedTraits,
// // // // //   //         partner1Languages:
// // // // //   //         List<String>.from(user['partner1Languages'] ?? []),
// // // // //   //         swingersOptions: mergedSwingers,
// // // // //   //         hookupOptions: mergedHookup,
// // // // //   //         partner2: p2Traits,
// // // // //   //         partner2Languages: p2Langs,
// // // // //   //         linkedPartner: linkedMap,
// // // // //   //       );
// // // // //   //     }
// // // // //   //   } catch (e) {
// // // // //   //     debugPrint('Error loading profile: $e');
// // // // //   //   } finally {
// // // // //   //     state = state.copyWith(isLoading: false);
// // // // //   //   }
// // // // //   // }
// // // // // Future<void> loadProfile() async {
// // // // //   final String? token = await AuthService.getToken();

// // // // //   if (token == null || token.isEmpty) {
// // // // //     debugPrint('No token found');
// // // // //     return;
// // // // //   }

// // // // //   state = state.copyWith(isLoading: true);

// // // // //   try {
// // // // //     final data = await getProfile(token: token);

// // // // //     debugPrint('PROFILE FINAL DATA: $data');

// // // // //     final user = data['user'];

// // // // //     if (user != null) {
// // // // //       final mergedTraits = defaultPartnerTraits();

// // // // //       final backendTraits =
// // // // //       Map<String, dynamic>.from(user['partner1Traits'] ?? {});

// // // // //       backendTraits.forEach((key, value) {
// // // // //         if (mergedTraits.containsKey(key)) {
// // // // //           mergedTraits[key] = value.toString();
// // // // //         }
// // // // //       });

// // // // //       final linked = user['partnerId'];

// // // // //       final Map<String, String> p2Traits = defaultPartnerTraits();
// // // // //       List<String> p2Langs = [];
// // // // //       Map<String, dynamic>? linkedMap;

// // // // //       if (linked is Map) {
// // // // //         linkedMap = Map<String, dynamic>.from(linked);

// // // // //         final lpTraits =
// // // // //         Map<String, dynamic>.from(linkedMap['partner1Traits'] ?? {});

// // // // //         lpTraits.forEach((key, value) {
// // // // //           if (p2Traits.containsKey(key)) {
// // // // //             p2Traits[key] = value.toString();
// // // // //           }
// // // // //         });

// // // // //         p2Langs = List<String>.from(linkedMap['partner1Languages'] ?? []);
// // // // //       }

// // // // //       final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
// // // // //       final backendSwingers =
// // // // //       Map<String, dynamic>.from(user['swingersOptions'] ?? {});

// // // // //       backendSwingers.forEach((key, value) {
// // // // //         if (mergedSwingers.containsKey(key)) {
// // // // //           mergedSwingers[key] = value == true;
// // // // //         }
// // // // //       });

// // // // //       final mergedHookup = Map<String, bool>.from(state.hookupOptions);
// // // // //       final backendHookup =
// // // // //       Map<String, dynamic>.from(user['hookupOptions'] ?? {});

// // // // //       backendHookup.forEach((key, value) {
// // // // //         if (mergedHookup.containsKey(key)) {
// // // // //           mergedHookup[key] = value == true;
// // // // //         }
// // // // //       });

// // // // //       state = state.copyWith(
// // // // //         aboutMe: user['aboutMe'] ?? '',
// // // // //         lookingFor: user['lookingFor'] ?? '',
// // // // //         partner1: mergedTraits,
// // // // //         partner1Languages:
// // // // //         List<String>.from(user['partner1Languages'] ?? []),
// // // // //         swingersOptions: mergedSwingers,
// // // // //         hookupOptions: mergedHookup,
// // // // //         partner2: p2Traits,
// // // // //         partner2Languages: p2Langs,
// // // // //         linkedPartner: linkedMap,
// // // // //       );
// // // // //     } else {
// // // // //       debugPrint('PROFILE API returned no user key: $data');
// // // // //     }
// // // // //   } catch (e) {
// // // // //     debugPrint('Error loading profile: $e');
// // // // //   } finally {
// // // // //     state = state.copyWith(isLoading: false);
// // // // //   }
// // // // // }
// // // // //   // ---------------------------------------------------------------------------
// // // // //   // SAVE PROFILE
// // // // //   // ---------------------------------------------------------------------------

// // // // //   // Future<void> saveProfile() async {
// // // // //   //   final String? token = await AuthService.getToken();
// // // // //   //
// // // // //   //   if (token == null || token.isEmpty) {
// // // // //   //     Get.snackbar(
// // // // //   //       'Error',
// // // // //   //       'User token not found',
// // // // //   //       snackPosition: SnackPosition.TOP,
// // // // //   //       backgroundColor: Colors.red,
// // // // //   //       colorText: Colors.white,
// // // // //   //     );
// // // // //   //     return;
// // // // //   //   }
// // // // //   //
// // // // //   //   state = state.copyWith(isLoading: true);
// // // // //   //
// // // // //   //   try {
// // // // //   //     final updates = {
// // // // //   //       'aboutMe': state.aboutMe,
// // // // //   //       'lookingFor': state.lookingFor,
// // // // //   //       'partner1Traits': state.partner1,
// // // // //   //       'partner1Languages': state.partner1Languages,
// // // // //   //       'swingersOptions': state.swingersOptions,
// // // // //   //       'hookupOptions': state.hookupOptions,
// // // // //   //     };
// // // // //   //
// // // // //   //     await _updateProfile(
// // // // //   //       token: token,
// // // // //   //       updates: updates,
// // // // //   //     );
// // // // //   //
// // // // //   //     Get.snackbar(
// // // // //   //       'Success',
// // // // //   //       'Profile updated successfully',
// // // // //   //       snackPosition: SnackPosition.TOP,
// // // // //   //       backgroundColor: Colors.green,
// // // // //   //       colorText: Colors.white,
// // // // //   //     );
// // // // //   //   } catch (e) {
// // // // //   //     Get.snackbar(
// // // // //   //       'Error',
// // // // //   //       'Failed to update profile: $e',
// // // // //   //       snackPosition: SnackPosition.TOP,
// // // // //   //       backgroundColor: Colors.red,
// // // // //   //       colorText: Colors.white,
// // // // //   //     );
// // // // //   //   } finally {
// // // // //   //     state = state.copyWith(isLoading: false);
// // // // //   //   }
// // // // //   // }
// // // // // Future<void> saveProfile() async {
// // // // //   final String? token = await AuthService.getToken();

// // // // //   if (token == null || token.isEmpty) {
// // // // //     Get.snackbar(
// // // // //       'Error',
// // // // //       'User token not found',
// // // // //       snackPosition: SnackPosition.TOP,
// // // // //       backgroundColor: Colors.red,
// // // // //       colorText: Colors.white,
// // // // //     );
// // // // //     return;
// // // // //   }

// // // // //   state = state.copyWith(isLoading: true);

// // // // //   try {
// // // // //     final updates = {
// // // // //       'aboutMe': state.aboutMe,
// // // // //       'lookingFor': state.lookingFor,
// // // // //       'partner1Traits': state.partner1,
// // // // //       'partner1Languages': state.partner1Languages,
// // // // //       'swingersOptions': state.swingersOptions,
// // // // //       'hookupOptions': state.hookupOptions,
// // // // //     };

// // // // //     await updateProfile(
// // // // //       token: token,
// // // // //       updates: updates,
// // // // //     );

// // // // //     Get.snackbar(
// // // // //       'Success',
// // // // //       'Profile updated successfully',
// // // // //       snackPosition: SnackPosition.TOP,
// // // // //       backgroundColor: Colors.green,
// // // // //       colorText: Colors.white,
// // // // //     );
// // // // //   } catch (e) {
// // // // //     debugPrint('Error saving profile: $e');
// // // // //     Get.snackbar(
// // // // //       'Error',
// // // // //       'Failed to update profile: $e',
// // // // //       snackPosition: SnackPosition.TOP,
// // // // //       backgroundColor: Colors.red,
// // // // //       colorText: Colors.white,
// // // // //     );
// // // // //   } finally {
// // // // //     state = state.copyWith(isLoading: false);
// // // // //   }
// // // // // }

// // // // //   // ---------------------------------------------------------------------------
// // // // //   // UI STATE METHODS
// // // // //   // ---------------------------------------------------------------------------

// // // // //   void toggleProfileTab(bool isProfile) {
// // // // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // // // //   }

// // // // //   void toggleSwingersExpanded() {
// // // // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // // // //   }

// // // // //   void toggleHookupExpanded() {
// // // // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // // // //   }

// // // // //   void updateSwingersOption(String label, bool value) {
// // // // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // // // //     newOptions[label] = value;
// // // // //     state = state.copyWith(swingersOptions: newOptions);
// // // // //   }

// // // // //   void updateHookupOption(String label, bool value) {
// // // // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // // // //     newOptions[label] = value;
// // // // //     state = state.copyWith(hookupOptions: newOptions);
// // // // //   }

// // // // //   void updateAboutMe(String value) {
// // // // //     state = state.copyWith(aboutMe: value);
// // // // //   }

// // // // //   void updateLookingFor(String value) {
// // // // //     state = state.copyWith(lookingFor: value);
// // // // //   }

// // // // //   void updatePartner1(String key, String value) {
// // // // //     final newPartner = Map<String, String>.from(state.partner1);
// // // // //     newPartner[key] = value;
// // // // //     state = state.copyWith(partner1: newPartner);
// // // // //   }

// // // // //   void updatePartner2(String key, String value) {
// // // // //     final newPartner = Map<String, String>.from(state.partner2);
// // // // //     newPartner[key] = value;
// // // // //     state = state.copyWith(partner2: newPartner);
// // // // //   }

// // // // //   void updatePartner1Languages(List<String> langs) {
// // // // //     state = state.copyWith(partner1Languages: langs);
// // // // //   }

// // // // //   void updatePartner2Languages(List<String> langs) {
// // // // //     state = state.copyWith(partner2Languages: langs);
// // // // //   }
// // // // // }

// // // // // // -----------------------------------------------------------------------------
// // // // // // PROVIDER
// // // // // // -----------------------------------------------------------------------------

// // // // // final profileEditProvider =
// // // // // NotifierProvider<ProfileEditNotifier, ProfileEditState>(
// // // // //   ProfileEditNotifier.new,
// // // // // );

// // // // // // -----------------------------------------------------------------------------
// // // // // // WIDGET
// // // // // // -----------------------------------------------------------------------------

// // // // // class MyProfileEditTab extends ConsumerWidget {
// // // // //   const MyProfileEditTab({super.key});

// // // // //   static const List<String> languageOptions = [
// // // // //     'English',
// // // // //     'Hindi',
// // // // //     'German',
// // // // //     'French',
// // // // //     'Spanish',
// // // // //   ];

// // // // //   void saveInterests() {
// // // // //     Get.snackbar(
// // // // //       'Success',
// // // // //       'Interests saved successfully',
// // // // //       snackPosition: SnackPosition.TOP,
// // // // //       backgroundColor: Colors.transparent,
// // // // //       colorText: Colors.white,
// // // // //       margin: const EdgeInsets.all(12),
// // // // //       borderRadius: 10,
// // // // //       duration: const Duration(seconds: 2),
// // // // //     );
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final profileState = ref.watch(profileEditProvider);
// // // // //     final notifier = ref.read(profileEditProvider.notifier);

// // // // //     return LayoutBuilder(
// // // // //       builder: (context, constraints) {
// // // // //         final double width = constraints.maxWidth;
// // // // //         final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
// // // // //         final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;

// // // // //         return Container(
// // // // //           width: double.infinity,
// // // // //           constraints: BoxConstraints(
// // // // //             minHeight: MediaQuery.of(context).size.height * 0.62,
// // // // //           ),
// // // // //           padding: const EdgeInsets.all(16),
// // // // //           decoration: BoxDecoration(
// // // // //             color: Colors.white,
// // // // //             borderRadius: BorderRadius.circular(14),
// // // // //             border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // //           ),
// // // // //           child: Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               if (profileState.isLoading)
// // // // //                 const Padding(
// // // // //                   padding: EdgeInsets.only(bottom: 10),
// // // // //                   child: LinearProgressIndicator(color: Colors.pink),
// // // // //                 ),
// // // // //               sectionHeader(profileState, notifier),
// // // // //               const SizedBox(height: 16),
// // // // //               if (profileState.isProfileDetailsTab)
// // // // //                 buildProfileDetailsContent(
// // // // //                   context,
// // // // //                   width,
// // // // //                   profileState,
// // // // //                   notifier,
// // // // //                 )
// // // // //               else
// // // // //                 buildInterestsContent(
// // // // //                   optionWidth,
// // // // //                   profileState,
// // // // //                   notifier,
// // // // //                 ),
// // // // //               const SizedBox(height: 18),
// // // // //               Center(
// // // // //                 child: SizedBox(
// // // // //                   width: 170,
// // // // //                   child: ElevatedButton(
// // // // //                     onPressed: profileState.isLoading
// // // // //                         ? null
// // // // //                         : () => notifier.saveProfile(),
// // // // //                     style: ElevatedButton.styleFrom(
// // // // //                       elevation: 4,
// // // // //                       padding: const EdgeInsets.symmetric(vertical: 12),
// // // // //                       backgroundColor: const Color(0xFF220027),
// // // // //                       foregroundColor: Colors.white,
// // // // //                       shape: RoundedRectangleBorder(
// // // // //                         borderRadius: BorderRadius.circular(22),
// // // // //                       ),
// // // // //                     ),
// // // // //                     child: profileState.isLoading
// // // // //                         ? const SizedBox(
// // // // //                       height: 20,
// // // // //                       width: 20,
// // // // //                       child: CircularProgressIndicator(
// // // // //                         color: Colors.white,
// // // // //                         strokeWidth: 2,
// // // // //                       ),
// // // // //                     )
// // // // //                         : Text(
// // // // //                       profileState.isProfileDetailsTab
// // // // //                           ? 'Save Profile'
// // // // //                           : 'Save Interest',
// // // // //                       style: const TextStyle(
// // // // //                         fontWeight: FontWeight.w700,
// // // // //                         fontSize: 12,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(height: 6),
// // // // //             ],
// // // // //           ),
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }

// // // // //   Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
// // // // //     return Container(
// // // // //       height: 38,
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // //       decoration: BoxDecoration(
// // // // //         gradient: const LinearGradient(
// // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // //         ),
// // // // //         borderRadius: BorderRadius.circular(22),
// // // // //       ),
// // // // //       child: Row(
// // // // //         children: [
// // // // //           InkWell(
// // // // //             borderRadius: BorderRadius.circular(16),
// // // // //             onTap: () => notifier.toggleProfileTab(false),
// // // // //             child: Container(
// // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // //               decoration: BoxDecoration(
// // // // //                 color: !state.isProfileDetailsTab
// // // // //                     ? const Color(0xFFFF2D87)
// // // // //                     : Colors.transparent,
// // // // //                 borderRadius: BorderRadius.circular(16),
// // // // //               ),
// // // // //               child: const Text(
// // // // //                 'INTERESTS',
// // // // //                 style: TextStyle(
// // // // //                   color: Colors.white,
// // // // //                   fontSize: 11,
// // // // //                   fontWeight: FontWeight.w700,
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           const Spacer(),
// // // // //           InkWell(
// // // // //             borderRadius: BorderRadius.circular(16),
// // // // //             onTap: () => notifier.toggleProfileTab(true),
// // // // //             child: Container(
// // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // //               decoration: BoxDecoration(
// // // // //                 color: state.isProfileDetailsTab
// // // // //                     ? const Color(0xFFFF2D87)
// // // // //                     : Colors.transparent,
// // // // //                 borderRadius: BorderRadius.circular(16),
// // // // //               ),
// // // // //               child: const Text(
// // // // //                 'PROFILE DETAILS',
// // // // //                 style: TextStyle(
// // // // //                   color: Colors.white,
// // // // //                   fontSize: 12,
// // // // //                   fontWeight: FontWeight.w700,
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget buildInterestsContent(
// // // // //       double optionWidth,
// // // // //       ProfileEditState state,
// // // // //       ProfileEditNotifier notifier,
// // // // //       ) {
// // // // //     return Column(
// // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //       children: [
// // // // //         const Text(
// // // // //           'davidbrown',
// // // // //           style: TextStyle(
// // // // //             fontWeight: FontWeight.w700,
// // // // //             fontSize: 34,
// // // // //             height: 1.05,
// // // // //           ),
// // // // //         ),
// // // // //         const SizedBox(height: 8),
// // // // //         Text(
// // // // //           'What are you looking for? Select all that apply',
// // // // //           style: TextStyle(
// // // // //             color: Colors.grey[700],
// // // // //             fontSize: 14,
// // // // //             fontWeight: FontWeight.w500,
// // // // //           ),
// // // // //         ),
// // // // //         const SizedBox(height: 16),
// // // // //         interestGroup(
// // // // //           title: 'Swingers',
// // // // //           expanded: state.isSwingersExpanded,
// // // // //           onToggle: notifier.toggleSwingersExpanded,
// // // // //           options: state.swingersOptions,
// // // // //           optionWidth: optionWidth,
// // // // //           onChanged: (label, value) =>
// // // // //               notifier.updateSwingersOption(label, value),
// // // // //         ),
// // // // //         const SizedBox(height: 12),
// // // // //         interestGroup(
// // // // //           title: 'Hookup / Meetup',
// // // // //           expanded: state.isHookupExpanded,
// // // // //           onToggle: notifier.toggleHookupExpanded,
// // // // //           options: state.hookupOptions,
// // // // //           optionWidth: optionWidth,
// // // // //           onChanged: (label, value) => notifier.updateHookupOption(label, value),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   Widget buildProfileDetailsContent(
// // // // //       BuildContext context,
// // // // //       double width,
// // // // //       ProfileEditState state,
// // // // //       ProfileEditNotifier notifier,
// // // // //       ) {
// // // // //     final bool stacked = width < 760;

// // // // //     return Column(
// // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //       children: [
// // // // //         textFieldLabel('INTRODUCE YOURSELF'),
// // // // //         const SizedBox(height: 6),
// // // // //         simpleTextField(
// // // // //           label: 'About Me',
// // // // //           initialValue: state.aboutMe,
// // // // //           onChanged: notifier.updateAboutMe,
// // // // //         ),
// // // // //         const SizedBox(height: 10),
// // // // //         textFieldLabel('LOOKING FOR'),
// // // // //         const SizedBox(height: 6),
// // // // //         simpleTextField(
// // // // //           label: 'Looking For',
// // // // //           initialValue: state.lookingFor,
// // // // //           maxLines: 2,
// // // // //           onChanged: notifier.updateLookingFor,
// // // // //         ),
// // // // //         const SizedBox(height: 14),
// // // // //         const Center(
// // // // //           child: Text(
// // // // //             'About Yourselves',
// // // // //             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
// // // // //           ),
// // // // //         ),
// // // // //         const SizedBox(height: 12),
// // // // //         if (stacked)
// // // // //           Column(
// // // // //             children: [
// // // // //               partnerPanel(
// // // // //                 context: context,
// // // // //                 title: 'Partner 1',
// // // // //                 data: state.partner1,
// // // // //                 languages: state.partner1Languages,
// // // // //                 onFieldChanged: notifier.updatePartner1,
// // // // //                 onLanguagesChanged: notifier.updatePartner1Languages,
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               partnerPanel(
// // // // //                 context: context,
// // // // //                 title: 'Partner 2',
// // // // //                 data: state.partner2,
// // // // //                 languages: state.partner2Languages,
// // // // //                 onFieldChanged: notifier.updatePartner2,
// // // // //                 onLanguagesChanged: notifier.updatePartner2Languages,
// // // // //                 readOnly: true,
// // // // //               ),
// // // // //             ],
// // // // //           )
// // // // //         else
// // // // //           Row(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               Expanded(
// // // // //                 child: partnerPanel(
// // // // //                   context: context,
// // // // //                   title: 'Partner 1',
// // // // //                   data: state.partner1,
// // // // //                   languages: state.partner1Languages,
// // // // //                   onFieldChanged: notifier.updatePartner1,
// // // // //                   onLanguagesChanged: notifier.updatePartner1Languages,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 12),
// // // // //               Expanded(
// // // // //                 child: partnerPanel(
// // // // //                   context: context,
// // // // //                   title: 'Partner 2',
// // // // //                   data: state.partner2,
// // // // //                   languages: state.partner2Languages,
// // // // //                   onFieldChanged: notifier.updatePartner2,
// // // // //                   onLanguagesChanged: notifier.updatePartner2Languages,
// // // // //                   readOnly: true,
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   Widget partnerPanel({
// // // // //     required BuildContext context,
// // // // //     required String title,
// // // // //     required Map<String, String> data,
// // // // //     required List<String> languages,
// // // // //     required void Function(String, String) onFieldChanged,
// // // // //     required void Function(List<String>) onLanguagesChanged,
// // // // //     bool readOnly = false,
// // // // //   }) {
// // // // //     return Column(
// // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //       children: [
// // // // //         Container(
// // // // //           height: 34,
// // // // //           alignment: Alignment.center,
// // // // //           decoration: BoxDecoration(
// // // // //             gradient: const LinearGradient(
// // // // //               colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // //             ),
// // // // //             borderRadius: BorderRadius.circular(10),
// // // // //           ),
// // // // //           child: Text(
// // // // //             title,
// // // // //             style: const TextStyle(
// // // // //               color: Colors.white,
// // // // //               fontWeight: FontWeight.w700,
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //         const SizedBox(height: 10),
// // // // //         dateOfBirthField(
// // // // //           context: context,
// // // // //           label: 'DATE OF BIRTH',
// // // // //           data: data,
// // // // //           keyName: 'dateOfBirth',
// // // // //           onFieldChanged: onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         heightInputField(
// // // // //           data: data,
// // // // //           onFieldChanged: onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         weightInputField(
// // // // //           data: data,
// // // // //           onFieldChanged: onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'BODY TYPE',
// // // // //           data,
// // // // //           'bodyType',
// // // // //           ProfileOptions.bodyTypes,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'ETHNIC BACKGROUND',
// // // // //           data,
// // // // //           'ethnic',
// // // // //           ProfileOptions.ethnicBackgrounds,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'SEXUALITY',
// // // // //           data,
// // // // //           'sexuality',
// // // // //           ProfileOptions.sexualities,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'RELATIONSHIP ORIENTATION',
// // // // //           data,
// // // // //           'orientation',
// // // // //           ProfileOptions.relationshipOrientations,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'TATTOOS',
// // // // //           data,
// // // // //           'tattoos',
// // // // //           ProfileOptions.tattoos,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'PIERCINGS',
// // // // //           data,
// // // // //           'piercings',
// // // // //           ProfileOptions.piercings,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'SMOKING',
// // // // //           data,
// // // // //           'smoking',
// // // // //           ProfileOptions.smoking,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'DRINKING',
// // // // //           data,
// // // // //           'drinking',
// // // // //           ProfileOptions.drinking,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'BODY HAIR',
// // // // //           data,
// // // // //           'bodyHair',
// // // // //           ProfileOptions.bodyHair,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         languagesField(
// // // // //           context,
// // // // //           'LANGUAGES SPOKEN',
// // // // //           languages,
// // // // //           onLanguagesChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'LOOKS IMPORTANCE',
// // // // //           data,
// // // // //           'looks',
// // // // //           ProfileOptions.importanceLevels,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'INTELLIGENCE IMPORTANCE',
// // // // //           data,
// // // // //           'intelligence',
// // // // //           ProfileOptions.importanceLevels,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //         profileOptionDropdownField(
// // // // //           'CIRCUMCISED',
// // // // //           data,
// // // // //           'circumcised',
// // // // //           ProfileOptions.circumcised,
// // // // //           onFieldChanged,
// // // // //           readOnly: readOnly,
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   Widget dateOfBirthField({
// // // // //     required BuildContext context,
// // // // //     required String label,
// // // // //     required Map<String, String> data,
// // // // //     required String keyName,
// // // // //     required void Function(String, String) onFieldChanged,
// // // // //     bool readOnly = false,
// // // // //   }) {
// // // // //     final currentValue = data[keyName] ?? '';
// // // // //     final displayValue =
// // // // //     currentValue.trim().isEmpty ? 'dd/mm/yyyy' : currentValue;

// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           textFieldLabel(label),
// // // // //           const SizedBox(height: 4),
// // // // //           InkWell(
// // // // //             onTap: readOnly
// // // // //                 ? null
// // // // //                 : () async {
// // // // //               final now = DateTime.now();
// // // // //               final parsedDate = parseProfileDate(currentValue);

// // // // //               DateTime initialDate =
// // // // //                   parsedDate ?? DateTime(now.year - 18, now.month, now.day);

// // // // //               if (initialDate.isAfter(now)) {
// // // // //                 initialDate = now;
// // // // //               }

// // // // //               if (initialDate.isBefore(DateTime(1900))) {
// // // // //                 initialDate = DateTime(1900);
// // // // //               }

// // // // //               final pickedDate = await showDatePicker(
// // // // //                 context: context,
// // // // //                 initialDate: initialDate,
// // // // //                 firstDate: DateTime(1900),
// // // // //                 lastDate: now,
// // // // //               );

// // // // //               if (pickedDate == null) return;

// // // // //               onFieldChanged(keyName, formatProfileDate(pickedDate));
// // // // //             },
// // // // //             borderRadius: BorderRadius.circular(8),
// // // // //             child: Container(
// // // // //               height: 42,
// // // // //               width: double.infinity,
// // // // //               padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // //               decoration: BoxDecoration(
// // // // //                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // //                 borderRadius: BorderRadius.circular(8),
// // // // //                 border: Border.all(
// // // // //                   color: readOnly
// // // // //                       ? const Color(0xFFF2F2F2)
// // // // //                       : const Color(0xFFE8E0F2),
// // // // //                 ),
// // // // //               ),
// // // // //               child: Row(
// // // // //                 children: [
// // // // //                   Expanded(
// // // // //                     child: Text(
// // // // //                       displayValue,
// // // // //                       maxLines: 1,
// // // // //                       overflow: TextOverflow.ellipsis,
// // // // //                       style: TextStyle(
// // // // //                         fontSize: 12,
// // // // //                         color: currentValue.trim().isEmpty
// // // // //                             ? Colors.grey[600]
// // // // //                             : Colors.black87,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const Icon(
// // // // //                     Icons.calendar_today_outlined,
// // // // //                     size: 17,
// // // // //                     color: Colors.black87,
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget heightInputField({
// // // // //     required Map<String, String> data,
// // // // //     required void Function(String, String) onFieldChanged,
// // // // //     bool readOnly = false,
// // // // //   }) {
// // // // //     final selectedType = (data['heightType'] ?? '').trim().isEmpty
// // // // //         ? null
// // // // //         : data['heightType'];

// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           textFieldLabel('HEIGHT'),
// // // // //           const SizedBox(height: 2),
// // // // //           Row(
// // // // //             children: [
// // // // //               unitRadioButton(
// // // // //                 label: 'FT',
// // // // //                 value: 'FT',
// // // // //                 groupValue: selectedType,
// // // // //                 readOnly: readOnly,
// // // // //                 onChanged: (value) => onFieldChanged('heightType', value),
// // // // //               ),
// // // // //               const SizedBox(width: 18),
// // // // //               unitRadioButton(
// // // // //                 label: 'CM',
// // // // //                 value: 'CM',
// // // // //                 groupValue: selectedType,
// // // // //                 readOnly: readOnly,
// // // // //                 onChanged: (value) => onFieldChanged('heightType', value),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 4),
// // // // //           TextFormField(
// // // // //             key: ValueKey('height-${data['height'] ?? ''}-$readOnly'),
// // // // //             initialValue: data['height'] ?? '',
// // // // //             readOnly: readOnly,
// // // // //             onChanged: readOnly
// // // // //                 ? null
// // // // //                 : (value) {
// // // // //               onFieldChanged('height', value);
// // // // //             },
// // // // //             keyboardType: TextInputType.text,
// // // // //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// // // // //             decoration: profileInputDecoration(
// // // // //               hintText: "Ex. (5'7 OR 170)",
// // // // //               readOnly: readOnly,
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget weightInputField({
// // // // //     required Map<String, String> data,
// // // // //     required void Function(String, String) onFieldChanged,
// // // // //     bool readOnly = false,
// // // // //   }) {
// // // // //     final selectedType = (data['weightType'] ?? '').trim().isEmpty
// // // // //         ? null
// // // // //         : data['weightType'];

// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           textFieldLabel('WEIGHT'),
// // // // //           const SizedBox(height: 2),
// // // // //           Row(
// // // // //             children: [
// // // // //               unitRadioButton(
// // // // //                 label: 'LBS',
// // // // //                 value: 'LBS',
// // // // //                 groupValue: selectedType,
// // // // //                 readOnly: readOnly,
// // // // //                 onChanged: (value) => onFieldChanged('weightType', value),
// // // // //               ),
// // // // //               const SizedBox(width: 18),
// // // // //               unitRadioButton(
// // // // //                 label: 'KG',
// // // // //                 value: 'KG',
// // // // //                 groupValue: selectedType,
// // // // //                 readOnly: readOnly,
// // // // //                 onChanged: (value) => onFieldChanged('weightType', value),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 4),
// // // // //           TextFormField(
// // // // //             key: ValueKey('weight-${data['weight'] ?? ''}-$readOnly'),
// // // // //             initialValue: data['weight'] ?? '',
// // // // //             readOnly: readOnly,
// // // // //             onChanged: readOnly
// // // // //                 ? null
// // // // //                 : (value) {
// // // // //               onFieldChanged('weight', value);
// // // // //             },
// // // // //             keyboardType: TextInputType.number,
// // // // //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// // // // //             decoration: profileInputDecoration(
// // // // //               hintText: 'Ex. (150 LBS OR 68 KG)',
// // // // //               readOnly: readOnly,
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget unitRadioButton({
// // // // //     required String label,
// // // // //     required String value,
// // // // //     required String? groupValue,
// // // // //     required void Function(String) onChanged,
// // // // //     bool readOnly = false,
// // // // //   }) {
// // // // //     return InkWell(
// // // // //       onTap: readOnly ? null : () => onChanged(value),
// // // // //       borderRadius: BorderRadius.circular(8),
// // // // //       child: Row(
// // // // //         mainAxisSize: MainAxisSize.min,
// // // // //         children: [
// // // // //           Radio<String>(
// // // // //             value: value,
// // // // //             groupValue: groupValue,
// // // // //             onChanged: readOnly
// // // // //                 ? null
// // // // //                 : (selectedValue) {
// // // // //               if (selectedValue == null) return;
// // // // //               onChanged(selectedValue);
// // // // //             },
// // // // //             activeColor: const Color(0xFF5A002B),
// // // // //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // // // //             visualDensity: VisualDensity.compact,
// // // // //           ),
// // // // //           Text(
// // // // //             label,
// // // // //             style: const TextStyle(
// // // // //               fontSize: 12,
// // // // //               fontWeight: FontWeight.w800,
// // // // //               color: Color(0xFF5A002B),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   InputDecoration profileInputDecoration({
// // // // //     required String hintText,
// // // // //     bool readOnly = false,
// // // // //   }) {
// // // // //     return InputDecoration(
// // // // //       hintText: hintText,
// // // // //       hintStyle: TextStyle(
// // // // //         color: Colors.grey[600],
// // // // //         fontSize: 12,
// // // // //       ),
// // // // //       isDense: true,
// // // // //       contentPadding: const EdgeInsets.symmetric(
// // // // //         horizontal: 10,
// // // // //         vertical: 12,
// // // // //       ),
// // // // //       border: OutlineInputBorder(
// // // // //         borderRadius: BorderRadius.circular(8),
// // // // //         borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // //       ),
// // // // //       enabledBorder: OutlineInputBorder(
// // // // //         borderRadius: BorderRadius.circular(8),
// // // // //         borderSide: BorderSide(
// // // // //           color: readOnly
// // // // //               ? const Color(0xFFF2F2F2)
// // // // //               : const Color(0xFFE8E0F2),
// // // // //         ),
// // // // //       ),
// // // // //       focusedBorder: OutlineInputBorder(
// // // // //         borderRadius: BorderRadius.circular(8),
// // // // //         borderSide: const BorderSide(color: Color(0xFF5A002B)),
// // // // //       ),
// // // // //       fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // //       filled: true,
// // // // //     );
// // // // //   }

// // // // //   DateTime? parseProfileDate(String? value) {
// // // // //     if (value == null || value.trim().isEmpty) return null;

// // // // //     final text = value.trim();

// // // // //     final dmyMatch =
// // // // //     RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);

// // // // //     if (dmyMatch != null) {
// // // // //       final day = int.tryParse(dmyMatch.group(1)!);
// // // // //       final month = int.tryParse(dmyMatch.group(2)!);
// // // // //       final year = int.tryParse(dmyMatch.group(3)!);

// // // // //       if (day != null && month != null && year != null) {
// // // // //         return DateTime(year, month, day);
// // // // //       }
// // // // //     }

// // // // //     final isoMatch =
// // // // //     RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);

// // // // //     if (isoMatch != null) {
// // // // //       final year = int.tryParse(isoMatch.group(1)!);
// // // // //       final month = int.tryParse(isoMatch.group(2)!);
// // // // //       final day = int.tryParse(isoMatch.group(3)!);

// // // // //       if (day != null && month != null && year != null) {
// // // // //         return DateTime(year, month, day);
// // // // //       }
// // // // //     }

// // // // //     return DateTime.tryParse(text);
// // // // //   }

// // // // //   String formatProfileDate(DateTime date) {
// // // // //     final day = date.day.toString().padLeft(2, '0');
// // // // //     final month = date.month.toString().padLeft(2, '0');
// // // // //     final year = date.year.toString();

// // // // //     return '$day/$month/$year';
// // // // //   }

// // // // //   ProfileOption? findProfileOption(
// // // // //       String? currentValue,
// // // // //       List<ProfileOption> options,
// // // // //       ) {
// // // // //     if (currentValue == null || currentValue.trim().isEmpty) {
// // // // //       return null;
// // // // //     }

// // // // //     final normalizedCurrent = normalize(currentValue);

// // // // //     for (final option in options) {
// // // // //       if (normalize(option.id) == normalizedCurrent ||
// // // // //           normalize(option.value) == normalizedCurrent ||
// // // // //           normalize(option.label) == normalizedCurrent) {
// // // // //         return option;
// // // // //       }
// // // // //     }

// // // // //     if (normalizedCurrent == normalize('Bisexual')) {
// // // // //       return firstProfileOptionWhere(
// // // // //         options,
// // // // //             (e) => e.value == 'Bi-sexual',
// // // // //       );
// // // // //     }

// // // // //     if (normalizedCurrent == normalize('Occasionally')) {
// // // // //       return firstProfileOptionWhere(
// // // // //         options,
// // // // //             (e) => e.value == 'Occasionaly',
// // // // //       );
// // // // //     }

// // // // //     if (normalizedCurrent == normalize('Low')) {
// // // // //       return firstProfileOptionWhere(
// // // // //         options,
// // // // //             (e) => e.value == 'Low Importance',
// // // // //       );
// // // // //     }

// // // // //     if (normalizedCurrent == normalize('Medium')) {
// // // // //       return firstProfileOptionWhere(
// // // // //         options,
// // // // //             (e) => e.value == 'Medium Importance',
// // // // //       );
// // // // //     }

// // // // //     if (normalizedCurrent == normalize('High')) {
// // // // //       return firstProfileOptionWhere(
// // // // //         options,
// // // // //             (e) => e.value == 'Very Important',
// // // // //       );
// // // // //     }

// // // // //     return null;
// // // // //   }

// // // // //   ProfileOption? firstProfileOptionWhere(
// // // // //       List<ProfileOption> options,
// // // // //       bool Function(ProfileOption option) test,
// // // // //       ) {
// // // // //     for (final option in options) {
// // // // //       if (test(option)) return option;
// // // // //     }

// // // // //     return null;
// // // // //   }

// // // // //   String normalize(String value) {
// // // // //     return value
// // // // //         .trim()
// // // // //         .toLowerCase()
// // // // //         .replaceAll('.', '')
// // // // //         .replaceAll('-', '')
// // // // //         .replaceAll('_', '')
// // // // //         .replaceAll(' ', '');
// // // // //   }

// // // // //   String? defaultProfileOptionValue(List<ProfileOption> options) {
// // // // //     if (options.isEmpty) return null;

// // // // //     for (final option in options) {
// // // // //       if (option.id == 'not_comfortable') {
// // // // //         return option.value;
// // // // //       }
// // // // //     }

// // // // //     return options.first.value;
// // // // //   }

// // // // //   Widget profileOptionDropdownField(
// // // // //       String label,
// // // // //       Map<String, String> data,
// // // // //       String key,
// // // // //       List<ProfileOption> options,
// // // // //       void Function(String, String) onFieldChanged, {
// // // // //         bool readOnly = false,
// // // // //       }) {
// // // // //     final currentValue = data[key];
// // // // //     final selectedOption = findProfileOption(currentValue, options);
// // // // //     final validValue =
// // // // //         selectedOption?.value ?? defaultProfileOptionValue(options);

// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           textFieldLabel(label),
// // // // //           const SizedBox(height: 4),
// // // // //           DropdownButtonFormField<String>(
// // // // //             key: ValueKey('$label-$key-$validValue-$readOnly'),
// // // // //             initialValue: validValue,
// // // // //             isExpanded: true,
// // // // //             iconSize: 18,
// // // // //             style: const TextStyle(
// // // // //               fontSize: 12,
// // // // //               color: Colors.black87,
// // // // //               overflow: TextOverflow.ellipsis,
// // // // //             ),
// // // // //             items: options.map((option) {
// // // // //               return DropdownMenuItem<String>(
// // // // //                 value: option.value,
// // // // //                 child: Text(
// // // // //                   option.label,
// // // // //                   maxLines: 1,
// // // // //                   overflow: TextOverflow.ellipsis,
// // // // //                 ),
// // // // //               );
// // // // //             }).toList(),
// // // // //             selectedItemBuilder: (context) {
// // // // //               return options.map((option) {
// // // // //                 return Align(
// // // // //                   alignment: Alignment.centerLeft,
// // // // //                   child: Text(
// // // // //                     option.label,
// // // // //                     maxLines: 1,
// // // // //                     overflow: TextOverflow.ellipsis,
// // // // //                   ),
// // // // //                 );
// // // // //               }).toList();
// // // // //             },
// // // // //             onChanged: readOnly
// // // // //                 ? null
// // // // //                 : (value) {
// // // // //               if (value == null) return;
// // // // //               onFieldChanged(key, value);
// // // // //             },
// // // // //             decoration: InputDecoration(
// // // // //               isDense: true,
// // // // //               contentPadding: const EdgeInsets.symmetric(
// // // // //                 horizontal: 10,
// // // // //                 vertical: 8,
// // // // //               ),
// // // // //               border: OutlineInputBorder(
// // // // //                 borderRadius: BorderRadius.circular(8),
// // // // //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // //               ),
// // // // //               enabledBorder: OutlineInputBorder(
// // // // //                 borderRadius: BorderRadius.circular(8),
// // // // //                 borderSide: BorderSide(
// // // // //                   color: readOnly
// // // // //                       ? const Color(0xFFF2F2F2)
// // // // //                       : const Color(0xFFE8E0F2),
// // // // //                 ),
// // // // //               ),
// // // // //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// // // // //               filled: readOnly,
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget dropdownField(
// // // // //       String label,
// // // // //       Map<String, String> data,
// // // // //       String key,
// // // // //       List<String> options,
// // // // //       void Function(String, String) onFieldChanged, {
// // // // //         bool readOnly = false,
// // // // //       }) {
// // // // //     final currentValue = data[key];
// // // // //     final validValue = currentValue != null && options.contains(currentValue)
// // // // //         ? currentValue
// // // // //         : options.isNotEmpty
// // // // //         ? options[0]
// // // // //         : null;

// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           textFieldLabel(label),
// // // // //           const SizedBox(height: 4),
// // // // //           DropdownButtonFormField<String>(
// // // // //             key: ValueKey('$label-$key-$validValue-$readOnly'),
// // // // //             initialValue: validValue,
// // // // //             isExpanded: true,
// // // // //             iconSize: 18,
// // // // //             style: const TextStyle(
// // // // //               fontSize: 12,
// // // // //               color: Colors.black87,
// // // // //               overflow: TextOverflow.ellipsis,
// // // // //             ),
// // // // //             items: options
// // // // //                 .map(
// // // // //                   (e) => DropdownMenuItem<String>(
// // // // //                 value: e,
// // // // //                 child: Text(
// // // // //                   e,
// // // // //                   maxLines: 1,
// // // // //                   overflow: TextOverflow.ellipsis,
// // // // //                 ),
// // // // //               ),
// // // // //             )
// // // // //                 .toList(),
// // // // //             selectedItemBuilder: (context) {
// // // // //               return options
// // // // //                   .map(
// // // // //                     (e) => Align(
// // // // //                   alignment: Alignment.centerLeft,
// // // // //                   child: Text(
// // // // //                     e,
// // // // //                     maxLines: 1,
// // // // //                     overflow: TextOverflow.ellipsis,
// // // // //                   ),
// // // // //                 ),
// // // // //               )
// // // // //                   .toList();
// // // // //             },
// // // // //             onChanged: readOnly
// // // // //                 ? null
// // // // //                 : (value) {
// // // // //               if (value == null) return;
// // // // //               onFieldChanged(key, value);
// // // // //             },
// // // // //             decoration: InputDecoration(
// // // // //               isDense: true,
// // // // //               contentPadding: const EdgeInsets.symmetric(
// // // // //                 horizontal: 10,
// // // // //                 vertical: 8,
// // // // //               ),
// // // // //               border: OutlineInputBorder(
// // // // //                 borderRadius: BorderRadius.circular(8),
// // // // //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // //               ),
// // // // //               enabledBorder: OutlineInputBorder(
// // // // //                 borderRadius: BorderRadius.circular(8),
// // // // //                 borderSide: BorderSide(
// // // // //                   color: readOnly
// // // // //                       ? const Color(0xFFF2F2F2)
// // // // //                       : const Color(0xFFE8E0F2),
// // // // //                 ),
// // // // //               ),
// // // // //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// // // // //               filled: readOnly,
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget simpleTextField({
// // // // //     required String label,
// // // // //     required String initialValue,
// // // // //     required void Function(String) onChanged,
// // // // //     int maxLines = 1,
// // // // //     bool readOnly = false,
// // // // //   }) {
// // // // //     return TextFormField(
// // // // //       key: ValueKey('$label-$initialValue-$readOnly'),
// // // // //       initialValue: initialValue,
// // // // //       maxLines: maxLines,
// // // // //       onChanged: onChanged,
// // // // //       readOnly: readOnly,
// // // // //       style: const TextStyle(fontSize: 12),
// // // // //       decoration: InputDecoration(
// // // // //         hintText: label,
// // // // //         isDense: true,
// // // // //         contentPadding: const EdgeInsets.symmetric(
// // // // //           horizontal: 10,
// // // // //           vertical: 10,
// // // // //         ),
// // // // //         border: OutlineInputBorder(
// // // // //           borderRadius: BorderRadius.circular(8),
// // // // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // //         ),
// // // // //         enabledBorder: OutlineInputBorder(
// // // // //           borderRadius: BorderRadius.circular(8),
// // // // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget textFieldLabel(String text) {
// // // // //     return Text(
// // // // //       text,
// // // // //       style: const TextStyle(
// // // // //         fontSize: 11,
// // // // //         fontWeight: FontWeight.w800,
// // // // //         letterSpacing: 0.2,
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget languagesField(
// // // // //       BuildContext context,
// // // // //       String label,
// // // // //       List<String> selectedValues,
// // // // //       void Function(List<String>) onSaved, {
// // // // //         bool readOnly = false,
// // // // //       }) {
// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           textFieldLabel(label),
// // // // //           const SizedBox(height: 4),
// // // // //           InkWell(
// // // // //             onTap: readOnly
// // // // //                 ? null
// // // // //                 : () => openLanguageSelector(context, selectedValues, onSaved),
// // // // //             borderRadius: BorderRadius.circular(8),
// // // // //             child: Container(
// // // // //               width: double.infinity,
// // // // //               constraints: const BoxConstraints(minHeight: 42),
// // // // //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// // // // //               decoration: BoxDecoration(
// // // // //                 borderRadius: BorderRadius.circular(8),
// // // // //                 border: Border.all(
// // // // //                   color: readOnly
// // // // //                       ? const Color(0xFFF2F2F2)
// // // // //                       : const Color(0xFFE8E0F2),
// // // // //                 ),
// // // // //                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // //               ),
// // // // //               child: Row(
// // // // //                 children: [
// // // // //                   Expanded(
// // // // //                     child: selectedValues.isEmpty
// // // // //                         ? Text(
// // // // //                       ProfileOptions.notComfortableLabel,
// // // // //                       maxLines: 1,
// // // // //                       overflow: TextOverflow.ellipsis,
// // // // //                       style: TextStyle(
// // // // //                         color: Colors.grey[600],
// // // // //                         fontSize: 12,
// // // // //                       ),
// // // // //                     )
// // // // //                         : Wrap(
// // // // //                       spacing: 6,
// // // // //                       runSpacing: 6,
// // // // //                       children: selectedValues
// // // // //                           .map(
// // // // //                             (lang) => Container(
// // // // //                           padding: const EdgeInsets.symmetric(
// // // // //                             horizontal: 8,
// // // // //                             vertical: 3,
// // // // //                           ),
// // // // //                           decoration: BoxDecoration(
// // // // //                             color: const Color(0xFFF0F4FF),
// // // // //                             borderRadius: BorderRadius.circular(12),
// // // // //                             border: Border.all(
// // // // //                               color: const Color(0xFFD4DDF2),
// // // // //                             ),
// // // // //                           ),
// // // // //                           child: Text(
// // // // //                             lang,
// // // // //                             style: const TextStyle(fontSize: 11),
// // // // //                           ),
// // // // //                         ),
// // // // //                       )
// // // // //                           .toList(),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(width: 8),
// // // // //                   const Icon(
// // // // //                     Icons.keyboard_arrow_down_rounded,
// // // // //                     size: 20,
// // // // //                     color: Colors.black87,
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Future<void> openLanguageSelector(
// // // // //       BuildContext context,
// // // // //       List<String> selectedValues,
// // // // //       void Function(List<String>) onSaved,
// // // // //       ) async {
// // // // //     final temp = [...selectedValues];

// // // // //     await showModalBottomSheet<void>(
// // // // //       context: context,
// // // // //       builder: (context) {
// // // // //         return StatefulBuilder(
// // // // //           builder: (context, setModalState) {
// // // // //             return SafeArea(
// // // // //               child: Padding(
// // // // //                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
// // // // //                 child: Column(
// // // // //                   mainAxisSize: MainAxisSize.min,
// // // // //                   children: [
// // // // //                     const Text(
// // // // //                       'Select Languages',
// // // // //                       style: TextStyle(
// // // // //                         fontWeight: FontWeight.w700,
// // // // //                         fontSize: 16,
// // // // //                       ),
// // // // //                     ),
// // // // //                     const SizedBox(height: 10),
// // // // //                     ...languageOptions.map(
// // // // //                           (lang) => CheckboxListTile(
// // // // //                         dense: true,
// // // // //                         value: temp.contains(lang),
// // // // //                         onChanged: (checked) {
// // // // //                           setModalState(() {
// // // // //                             if (checked == true) {
// // // // //                               if (!temp.contains(lang)) temp.add(lang);
// // // // //                             } else {
// // // // //                               temp.remove(lang);
// // // // //                             }
// // // // //                           });
// // // // //                         },
// // // // //                         title: Text(lang),
// // // // //                         controlAffinity: ListTileControlAffinity.leading,
// // // // //                       ),
// // // // //                     ),
// // // // //                     const SizedBox(height: 8),
// // // // //                     SizedBox(
// // // // //                       width: double.infinity,
// // // // //                       child: ElevatedButton(
// // // // //                         onPressed: () {
// // // // //                           onSaved(temp);
// // // // //                           Navigator.pop(context);
// // // // //                         },
// // // // //                         child: const Text('Done'),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             );
// // // // //           },
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }

// // // // //   Widget interestGroup({
// // // // //     required String title,
// // // // //     required bool expanded,
// // // // //     required VoidCallback onToggle,
// // // // //     required Map<String, bool> options,
// // // // //     required double optionWidth,
// // // // //     required void Function(String label, bool value) onChanged,
// // // // //   }) {
// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(10),
// // // // //         border: Border.all(color: const Color(0xFFECE4F4)),
// // // // //       ),
// // // // //       child: Column(
// // // // //         children: [
// // // // //           InkWell(
// // // // //             onTap: onToggle,
// // // // //             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
// // // // //             child: Container(
// // // // //               height: 40,
// // // // //               padding: const EdgeInsets.symmetric(horizontal: 14),
// // // // //               decoration: BoxDecoration(
// // // // //                 gradient: const LinearGradient(
// // // // //                   colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // //                 ),
// // // // //                 borderRadius: BorderRadius.vertical(
// // // // //                   top: const Radius.circular(10),
// // // // //                   bottom: expanded ? Radius.zero : const Radius.circular(10),
// // // // //                 ),
// // // // //               ),
// // // // //               child: Row(
// // // // //                 children: [
// // // // //                   Expanded(
// // // // //                     child: Text(
// // // // //                       title,
// // // // //                       maxLines: 1,
// // // // //                       overflow: TextOverflow.ellipsis,
// // // // //                       style: const TextStyle(
// // // // //                         color: Colors.white,
// // // // //                         fontSize: 30,
// // // // //                         fontWeight: FontWeight.w800,
// // // // //                         height: 1.0,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(width: 8),
// // // // //                   CircleAvatar(
// // // // //                     radius: 12,
// // // // //                     backgroundColor: const Color(0xFFEACD71),
// // // // //                     child: Icon(
// // // // //                       expanded
// // // // //                           ? Icons.keyboard_arrow_up
// // // // //                           : Icons.keyboard_arrow_down,
// // // // //                       size: 16,
// // // // //                       color: Colors.black87,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           if (expanded)
// // // // //             Padding(
// // // // //               padding: const EdgeInsets.all(10),
// // // // //               child: Wrap(
// // // // //                 spacing: 8,
// // // // //                 runSpacing: 8,
// // // // //                 children: options.entries
// // // // //                     .map(
// // // // //                       (entry) => OptionChip(
// // // // //                     label: entry.key,
// // // // //                     selected: entry.value,
// // // // //                     width: optionWidth,
// // // // //                     onTap: () => onChanged(entry.key, !entry.value),
// // // // //                   ),
// // // // //                 )
// // // // //                     .toList(),
// // // // //               ),
// // // // //             ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // -----------------------------------------------------------------------------
// // // // // // OPTION CHIP
// // // // // // -----------------------------------------------------------------------------

// // // // // class OptionChip extends StatelessWidget {
// // // // //   const OptionChip({
// // // // //     super.key,
// // // // //     required this.label,
// // // // //     required this.selected,
// // // // //     required this.width,
// // // // //     required this.onTap,
// // // // //   });

// // // // //   final String label;
// // // // //   final bool selected;
// // // // //   final double width;
// // // // //   final VoidCallback onTap;

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return InkWell(
// // // // //       onTap: onTap,
// // // // //       borderRadius: BorderRadius.circular(8),
// // // // //       child: Container(
// // // // //         width: width,
// // // // //         height: 42,
// // // // //         padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // //         decoration: BoxDecoration(
// // // // //           color: Colors.white,
// // // // //           borderRadius: BorderRadius.circular(8),
// // // // //           border: Border.all(color: const Color(0xFFF1EBF8)),
// // // // //         ),
// // // // //         child: Row(
// // // // //           children: [
// // // // //             Expanded(
// // // // //               child: Text(
// // // // //                 label,
// // // // //                 overflow: TextOverflow.ellipsis,
// // // // //                 style: const TextStyle(
// // // // //                   color: Colors.black87,
// // // // //                   fontWeight: FontWeight.w500,
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //             Checkbox(
// // // // //               value: selected,
// // // // //               onChanged: (_) => onTap(),
// // // // //               shape: RoundedRectangleBorder(
// // // // //                 borderRadius: BorderRadius.circular(4),
// // // // //               ),
// // // // //               activeColor: const Color(0xFF47003D),
// // // // //               side: const BorderSide(color: Color(0xFFE0D4EE)),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }


// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import 'package:get/get.dart';
// // // // // //
// // // // // // import 'package:beatflirt/Api_services/api_services.dart';
// // // // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // // //
// // // // // // // -----------------------------------------------------------------------------
// // // // // // // PROFILE OPTIONS
// // // // // // // -----------------------------------------------------------------------------
// // // // // //
// // // // // // class ProfileOption {
// // // // // //   final String id;
// // // // // //   final String value;
// // // // // //   final String label;
// // // // // //
// // // // // //   const ProfileOption({
// // // // // //     required this.id,
// // // // // //     required this.value,
// // // // // //     required this.label,
// // // // // //   });
// // // // // //
// // // // // //   Map<String, dynamic> toJson() {
// // // // // //     return {
// // // // // //       'id': id,
// // // // // //       'value': value,
// // // // // //       'label': label,
// // // // // //     };
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // class ProfileOptions {
// // // // // //   static const String notComfortableValue = 'Im not comfortable sharing that';
// // // // // //   static const String notComfortableLabel =
// // // // // //       "I'm not comfortable sharing that.";
// // // // // //
// // // // // //   static const ProfileOption notComfortable = ProfileOption(
// // // // // //     id: 'not_comfortable',
// // // // // //     value: notComfortableValue,
// // // // // //     label: notComfortableLabel,
// // // // // //   );
// // // // // //
// // // // // //   static const List<ProfileOption> tattoos = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'none', value: 'None', label: 'None'),
// // // // // //     ProfileOption(id: 'one', value: 'One', label: 'One'),
// // // // // //     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
// // // // // //     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
// // // // // //     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> heightTypes = [
// // // // // //     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
// // // // // //     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> weightTypes = [
// // // // // //     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
// // // // // //     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> bodyTypes = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
// // // // // //     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
// // // // // //     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
// // // // // //     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
// // // // // //     ProfileOption(
// // // // // //       id: 'huggable_and_heavy',
// // // // // //       value: 'Huggable and Heavy',
// // // // // //       label: 'Huggable and Heavy',
// // // // // //     ),
// // // // // //     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
// // // // // //     ProfileOption(
// // // // // //       id: 'more_of_me_to_love',
// // // // // //       value: 'More of me to love',
// // // // // //       label: 'More of me to love',
// // // // // //     ),
// // // // // //     ProfileOption(
// // // // // //       id: 'nicely_shaped',
// // // // // //       value: 'Nicely Shaped',
// // // // // //       label: 'Nicely Shaped',
// // // // // //     ),
// // // // // //     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> smoking = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // //     ProfileOption(
// // // // // //       id: 'occasionally',
// // // // // //       value: 'Occasionaly',
// // // // // //       label: 'Occasionally',
// // // // // //     ),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> drinking = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // //     ProfileOption(
// // // // // //       id: 'occasionally',
// // // // // //       value: 'Occasionaly',
// // // // // //       label: 'Occasionally',
// // // // // //     ),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> ethnicBackgrounds = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'other', value: 'Other', label: 'Other'),
// // // // // //     ProfileOption(id: 'american', value: 'American', label: 'American'),
// // // // // //     ProfileOption(
// // // // // //       id: 'argentine_argentinian',
// // // // // //       value: 'Argentine/Argentinian',
// // // // // //       label: 'Argentine/Argentinian',
// // // // // //     ),
// // // // // //     ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
// // // // // //     ProfileOption(
// // // // // //       id: 'black_african_american',
// // // // // //       value: 'Black/African - American',
// // // // // //       label: 'Black/African - American',
// // // // // //     ),
// // // // // //     ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
// // // // // //     ProfileOption(id: 'british', value: 'British', label: 'British'),
// // // // // //     ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
// // // // // //     ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
// // // // // //     ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
// // // // // //     ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
// // // // // //     ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
// // // // // //     ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
// // // // // //     ProfileOption(id: 'french', value: 'French', label: 'French'),
// // // // // //     ProfileOption(id: 'german', value: 'German', label: 'German'),
// // // // // //     ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
// // // // // //     ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
// // // // // //     ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
// // // // // //     ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
// // // // // //     ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
// // // // // //     ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
// // // // // //     ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
// // // // // //     ProfileOption(
// // // // // //       id: 'new_zealander_kiwi',
// // // // // //       value: 'New Zealander/Kiwi',
// // // // // //       label: 'New Zealander/Kiwi',
// // // // // //     ),
// // // // // //     ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
// // // // // //     ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
// // // // // //     ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
// // // // // //     ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
// // // // // //     ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
// // // // // //     ProfileOption(
// // // // // //       id: 'south_african',
// // // // // //       value: 'South African',
// // // // // //       label: 'South African',
// // // // // //     ),
// // // // // //     ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
// // // // // //     ProfileOption(
// // // // // //       id: 'sri_lankan',
// // // // // //       value: 'Sri Lankan',
// // // // // //       label: 'Sri Lankan',
// // // // // //     ),
// // // // // //     ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
// // // // // //     ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> importanceLevels = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // //     ProfileOption(
// // // // // //       id: 'low_importance',
// // // // // //       value: 'Low Importance',
// // // // // //       label: 'Low Importance',
// // // // // //     ),
// // // // // //     ProfileOption(
// // // // // //       id: 'medium_importance',
// // // // // //       value: 'Medium Importance',
// // // // // //       label: 'Medium Importance',
// // // // // //     ),
// // // // // //     ProfileOption(
// // // // // //       id: 'very_important',
// // // // // //       value: 'Very Important',
// // // // // //       label: 'Very Important',
// // // // // //     ),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> sexualities = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
// // // // // //     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
// // // // // //     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
// // // // // //     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
// // // // // //     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
// // // // // //     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
// // // // // //     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
// // // // // //     ProfileOption(
// // // // // //       id: 'transsexual',
// // // // // //       value: 'Transsexual',
// // // // // //       label: 'Transsexual',
// // // // // //     ),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> relationshipOrientations = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
// // // // // //     ProfileOption(
// // // // // //       id: 'open_minded',
// // // // // //       value: 'Open-Minded',
// // // // // //       label: 'Open-Minded',
// // // // // //     ),
// // // // // //     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
// // // // // //     ProfileOption(
// // // // // //       id: 'polyamorous',
// // // // // //       value: 'Polyamorous',
// // // // // //       label: 'Polyamorous',
// // // // // //     ),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> circumcised = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> piercings = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // //   ];
// // // // // //
// // // // // //   static const List<ProfileOption> bodyHair = [
// // // // // //     notComfortable,
// // // // // //     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
// // // // // //     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
// // // // // //     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
// // // // // //     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
// // // // // //   ];
// // // // // //
// // // // // //   static const Map<String, List<ProfileOption>> groups = {
// // // // // //     'tattoos': tattoos,
// // // // // //     'height_types': heightTypes,
// // // // // //     'weight_types': weightTypes,
// // // // // //     'body_types': bodyTypes,
// // // // // //     'smoking': smoking,
// // // // // //     'drinking': drinking,
// // // // // //     'ethnic_backgrounds': ethnicBackgrounds,
// // // // // //     'importance_levels': importanceLevels,
// // // // // //     'sexualities': sexualities,
// // // // // //     'relationship_orientations': relationshipOrientations,
// // // // // //     'circumcised': circumcised,
// // // // // //     'piercings': piercings,
// // // // // //     'body_hair': bodyHair,
// // // // // //   };
// // // // // // }
// // // // // //
// // // // // // class ProfileFieldOptions {
// // // // // //   static const Map<String, String> fieldGroupMap = {
// // // // // //     'bodyType': 'body_types',
// // // // // //     'ethnic': 'ethnic_backgrounds',
// // // // // //     'sexuality': 'sexualities',
// // // // // //     'orientation': 'relationship_orientations',
// // // // // //     'tattoos': 'tattoos',
// // // // // //     'piercings': 'piercings',
// // // // // //     'smoking': 'smoking',
// // // // // //     'drinking': 'drinking',
// // // // // //     'bodyHair': 'body_hair',
// // // // // //     'looks': 'importance_levels',
// // // // // //     'intelligence': 'importance_levels',
// // // // // //     'circumcised': 'circumcised',
// // // // // //
// // // // // //     'person1_tattoos': 'tattoos',
// // // // // //     'person2_tattoos': 'tattoos',
// // // // // //     'person1_height_type': 'height_types',
// // // // // //     'person2_height_type': 'height_types',
// // // // // //     'person1_weight_type': 'weight_types',
// // // // // //     'person2_weight_type': 'weight_types',
// // // // // //     'person1_body_type': 'body_types',
// // // // // //     'person2_body_type': 'body_types',
// // // // // //     'person1_smoking': 'smoking',
// // // // // //     'person2_smoking': 'smoking',
// // // // // //     'person1_drinking': 'drinking',
// // // // // //     'person2_drinking': 'drinking',
// // // // // //     'person1_ethnic_background': 'ethnic_backgrounds',
// // // // // //     'person2_ethnic_background': 'ethnic_backgrounds',
// // // // // //     'person1_looks_important': 'importance_levels',
// // // // // //     'person2_looks_important': 'importance_levels',
// // // // // //     'person1_intelligence_importance': 'importance_levels',
// // // // // //     'person2_intelligence_importance': 'importance_levels',
// // // // // //     'person1_sexuality': 'sexualities',
// // // // // //     'person2_sexuality': 'sexualities',
// // // // // //     'person1_relationship_orientation': 'relationship_orientations',
// // // // // //     'person2_relationship_orientation': 'relationship_orientations',
// // // // // //     'person1_circumcised': 'circumcised',
// // // // // //     'person2_circumcised': 'circumcised',
// // // // // //     'person1_piercings': 'piercings',
// // // // // //     'person2_piercings': 'piercings',
// // // // // //   };
// // // // // //
// // // // // //   static List<ProfileOption> getOptionsForField(String fieldName) {
// // // // // //     final groupKey = fieldGroupMap[fieldName];
// // // // // //
// // // // // //     if (groupKey == null) {
// // // // // //       return [];
// // // // // //     }
// // // // // //
// // // // // //     return ProfileOptions.groups[groupKey] ?? [];
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // // -----------------------------------------------------------------------------
// // // // // // // STATE
// // // // // // // -----------------------------------------------------------------------------
// // // // // //
// // // // // // class ProfileEditState {
// // // // // //   final bool isProfileDetailsTab;
// // // // // //   final Map<String, bool> swingersOptions;
// // // // // //   final Map<String, bool> hookupOptions;
// // // // // //   final bool isSwingersExpanded;
// // // // // //   final bool isHookupExpanded;
// // // // // //   final String aboutMe;
// // // // // //   final String lookingFor;
// // // // // //   final Map<String, String> partner1;
// // // // // //   final Map<String, String> partner2;
// // // // // //   final List<String> partner1Languages;
// // // // // //   final List<String> partner2Languages;
// // // // // //   final bool isLoading;
// // // // // //   final Map<String, dynamic>? linkedPartner;
// // // // // //
// // // // // //   const ProfileEditState({
// // // // // //     this.isProfileDetailsTab = false,
// // // // // //     required this.swingersOptions,
// // // // // //     required this.hookupOptions,
// // // // // //     this.isSwingersExpanded = true,
// // // // // //     this.isHookupExpanded = true,
// // // // // //     this.aboutMe = '',
// // // // // //     this.lookingFor = '',
// // // // // //     required this.partner1,
// // // // // //     required this.partner2,
// // // // // //     required this.partner1Languages,
// // // // // //     required this.partner2Languages,
// // // // // //     this.isLoading = false,
// // // // // //     this.linkedPartner,
// // // // // //   });
// // // // // //
// // // // // //   ProfileEditState copyWith({
// // // // // //     bool? isProfileDetailsTab,
// // // // // //     Map<String, bool>? swingersOptions,
// // // // // //     Map<String, bool>? hookupOptions,
// // // // // //     bool? isSwingersExpanded,
// // // // // //     bool? isHookupExpanded,
// // // // // //     String? aboutMe,
// // // // // //     String? lookingFor,
// // // // // //     Map<String, String>? partner1,
// // // // // //     Map<String, String>? partner2,
// // // // // //     List<String>? partner1Languages,
// // // // // //     List<String>? partner2Languages,
// // // // // //     bool? isLoading,
// // // // // //     Map<String, dynamic>? linkedPartner,
// // // // // //   }) {
// // // // // //     return ProfileEditState(
// // // // // //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// // // // // //       swingersOptions: swingersOptions ?? this.swingersOptions,
// // // // // //       hookupOptions: hookupOptions ?? this.hookupOptions,
// // // // // //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// // // // // //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// // // // // //       aboutMe: aboutMe ?? this.aboutMe,
// // // // // //       lookingFor: lookingFor ?? this.lookingFor,
// // // // // //       partner1: partner1 ?? this.partner1,
// // // // // //       partner2: partner2 ?? this.partner2,
// // // // // //       partner1Languages: partner1Languages ?? this.partner1Languages,
// // // // // //       partner2Languages: partner2Languages ?? this.partner2Languages,
// // // // // //       isLoading: isLoading ?? this.isLoading,
// // // // // //       linkedPartner: linkedPartner ?? this.linkedPartner,
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // // -----------------------------------------------------------------------------
// // // // // // // NOTIFIER
// // // // // // // -----------------------------------------------------------------------------
// // // // // //
// // // // // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // // // // //   final ApiServices apiServices = ApiServices();
// // // // // //
// // // // // //   Map<String, String> defaultPartnerTraits() {
// // // // // //     return {
// // // // // //       'dateOfBirth': '',
// // // // // //
// // // // // //       'height': '',
// // // // // //       'heightType': '',
// // // // // //
// // // // // //       'weight': '',
// // // // // //       'weightType': '',
// // // // // //
// // // // // //       'bodyType': ProfileOptions.notComfortableValue,
// // // // // //       'ethnic': ProfileOptions.notComfortableValue,
// // // // // //       'sexuality': ProfileOptions.notComfortableValue,
// // // // // //       'orientation': ProfileOptions.notComfortableValue,
// // // // // //       'tattoos': ProfileOptions.notComfortableValue,
// // // // // //       'piercings': ProfileOptions.notComfortableValue,
// // // // // //       'smoking': ProfileOptions.notComfortableValue,
// // // // // //       'drinking': ProfileOptions.notComfortableValue,
// // // // // //       'bodyHair': ProfileOptions.notComfortableValue,
// // // // // //       'looks': ProfileOptions.notComfortableValue,
// // // // // //       'intelligence': ProfileOptions.notComfortableValue,
// // // // // //       'circumcised': ProfileOptions.notComfortableValue,
// // // // // //     };
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   ProfileEditState build() {
// // // // // //     Future.microtask(() => loadProfile());
// // // // // //
// // // // // //     return ProfileEditState(
// // // // // //       swingersOptions: {
// // // // // //         'Couple Female/Male': true,
// // // // // //         'Couple Female/Female': true,
// // // // // //         'Couple Male/Male': true,
// // // // // //         'Female': true,
// // // // // //         'Male': true,
// // // // // //         'Transgender': true,
// // // // // //       },
// // // // // //       hookupOptions: {
// // // // // //         'Couple Female/Male': true,
// // // // // //         'Couple Female/Female': true,
// // // // // //         'Couple Male/Male': true,
// // // // // //         'Female': true,
// // // // // //         'Male': true,
// // // // // //         'Transgender': false,
// // // // // //       },
// // // // // //       partner1: defaultPartnerTraits(),
// // // // // //       partner2: defaultPartnerTraits(),
// // // // // //       partner1Languages: [],
// // // // // //       partner2Languages: [],
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Future<void> loadProfile() async {
// // // // // //     final token = await AuthService.getToken();
// // // // // //     if (token == null) return;
// // // // // //
// // // // // //     state = state.copyWith(isLoading: true);
// // // // // //
// // // // // //     try {
// // // // // //       final data = await apiServices.getProfile(token: token);
// // // // // //       final user = data['user'];
// // // // // //
// // // // // //       if (user != null) {
// // // // // //         final mergedTraits = defaultPartnerTraits();
// // // // // //         final backendTraits =
// // // // // //         Map<String, dynamic>.from(user['partner1Traits'] ?? {});
// // // // // //
// // // // // //         backendTraits.forEach((key, value) {
// // // // // //           if (mergedTraits.containsKey(key)) {
// // // // // //             mergedTraits[key] = value.toString();
// // // // // //           }
// // // // // //         });
// // // // // //
// // // // // //         final linked = user['partnerId'];
// // // // // //
// // // // // //         final Map<String, String> p2Traits = defaultPartnerTraits();
// // // // // //         List<String> p2Langs = [];
// // // // // //         Map<String, dynamic>? linkedMap;
// // // // // //
// // // // // //         if (linked is Map) {
// // // // // //           linkedMap = Map<String, dynamic>.from(linked);
// // // // // //
// // // // // //           final lpTraits =
// // // // // //           Map<String, dynamic>.from(linkedMap['partner1Traits'] ?? {});
// // // // // //
// // // // // //           lpTraits.forEach((key, value) {
// // // // // //             if (p2Traits.containsKey(key)) {
// // // // // //               p2Traits[key] = value.toString();
// // // // // //             }
// // // // // //           });
// // // // // //
// // // // // //           p2Langs = List<String>.from(linkedMap['partner1Languages'] ?? []);
// // // // // //         }
// // // // // //
// // // // // //         final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
// // // // // //         final backendSwingers =
// // // // // //         Map<String, dynamic>.from(user['swingersOptions'] ?? {});
// // // // // //
// // // // // //         backendSwingers.forEach((key, value) {
// // // // // //           if (mergedSwingers.containsKey(key)) {
// // // // // //             mergedSwingers[key] = value == true;
// // // // // //           }
// // // // // //         });
// // // // // //
// // // // // //         final mergedHookup = Map<String, bool>.from(state.hookupOptions);
// // // // // //         final backendHookup =
// // // // // //         Map<String, dynamic>.from(user['hookupOptions'] ?? {});
// // // // // //
// // // // // //         backendHookup.forEach((key, value) {
// // // // // //           if (mergedHookup.containsKey(key)) {
// // // // // //             mergedHookup[key] = value == true;
// // // // // //           }
// // // // // //         });
// // // // // //
// // // // // //         state = state.copyWith(
// // // // // //           aboutMe: user['aboutMe'] ?? '',
// // // // // //           lookingFor: user['lookingFor'] ?? '',
// // // // // //           partner1: mergedTraits,
// // // // // //           partner1Languages:
// // // // // //           List<String>.from(user['partner1Languages'] ?? []),
// // // // // //           swingersOptions: mergedSwingers,
// // // // // //           hookupOptions: mergedHookup,
// // // // // //           partner2: p2Traits,
// // // // // //           partner2Languages: p2Langs,
// // // // // //           linkedPartner: linkedMap,
// // // // // //         );
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint('Error loading profile: $e');
// // // // // //     } finally {
// // // // // //       state = state.copyWith(isLoading: false);
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   Future<void> saveProfile() async {
// // // // // //     final token = await AuthService.getToken();
// // // // // //     if (token == null) return;
// // // // // //
// // // // // //     state = state.copyWith(isLoading: true);
// // // // // //
// // // // // //     try {
// // // // // //       final updates = {
// // // // // //         'aboutMe': state.aboutMe,
// // // // // //         'lookingFor': state.lookingFor,
// // // // // //         'partner1Traits': state.partner1,
// // // // // //         'partner1Languages': state.partner1Languages,
// // // // // //         'swingersOptions': state.swingersOptions,
// // // // // //         'hookupOptions': state.hookupOptions,
// // // // // //       };
// // // // // //
// // // // // //       await apiServices.updateProfile(token: token, updates: updates);
// // // // // //
// // // // // //       Get.snackbar(
// // // // // //         'Success',
// // // // // //         'Profile updated successfully',
// // // // // //         snackPosition: SnackPosition.TOP,
// // // // // //         backgroundColor: Colors.green,
// // // // // //         colorText: Colors.white,
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       Get.snackbar(
// // // // // //         'Error',
// // // // // //         'Failed to update profile: $e',
// // // // // //         snackPosition: SnackPosition.TOP,
// // // // // //         backgroundColor: Colors.red,
// // // // // //         colorText: Colors.white,
// // // // // //       );
// // // // // //     } finally {
// // // // // //       state = state.copyWith(isLoading: false);
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   void toggleProfileTab(bool isProfile) {
// // // // // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // // // // //   }
// // // // // //
// // // // // //   void toggleSwingersExpanded() {
// // // // // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // // // // //   }
// // // // // //
// // // // // //   void toggleHookupExpanded() {
// // // // // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // // // // //   }
// // // // // //
// // // // // //   void updateSwingersOption(String label, bool value) {
// // // // // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // // // // //     newOptions[label] = value;
// // // // // //     state = state.copyWith(swingersOptions: newOptions);
// // // // // //   }
// // // // // //
// // // // // //   void updateHookupOption(String label, bool value) {
// // // // // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // // // // //     newOptions[label] = value;
// // // // // //     state = state.copyWith(hookupOptions: newOptions);
// // // // // //   }
// // // // // //
// // // // // //   void updateAboutMe(String value) {
// // // // // //     state = state.copyWith(aboutMe: value);
// // // // // //   }
// // // // // //
// // // // // //   void updateLookingFor(String value) {
// // // // // //     state = state.copyWith(lookingFor: value);
// // // // // //   }
// // // // // //
// // // // // //   void updatePartner1(String key, String value) {
// // // // // //     final newPartner = Map<String, String>.from(state.partner1);
// // // // // //     newPartner[key] = value;
// // // // // //     state = state.copyWith(partner1: newPartner);
// // // // // //   }
// // // // // //
// // // // // //   void updatePartner2(String key, String value) {
// // // // // //     final newPartner = Map<String, String>.from(state.partner2);
// // // // // //     newPartner[key] = value;
// // // // // //     state = state.copyWith(partner2: newPartner);
// // // // // //   }
// // // // // //
// // // // // //   void updatePartner1Languages(List<String> langs) {
// // // // // //     state = state.copyWith(partner1Languages: langs);
// // // // // //   }
// // // // // //
// // // // // //   void updatePartner2Languages(List<String> langs) {
// // // // // //     state = state.copyWith(partner2Languages: langs);
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // // -----------------------------------------------------------------------------
// // // // // // // PROVIDER
// // // // // // // -----------------------------------------------------------------------------
// // // // // //
// // // // // // final profileEditProvider =
// // // // // // NotifierProvider<ProfileEditNotifier, ProfileEditState>(
// // // // // //   ProfileEditNotifier.new,
// // // // // // );
// // // // // //
// // // // // // // -----------------------------------------------------------------------------
// // // // // // // WIDGET
// // // // // // // -----------------------------------------------------------------------------
// // // // // //
// // // // // // class MyProfileEditTab extends ConsumerWidget {
// // // // // //   const MyProfileEditTab({super.key});
// // // // // //
// // // // // //   static const List<String> languageOptions = [
// // // // // //     'English',
// // // // // //     'Hindi',
// // // // // //     'German',
// // // // // //     'French',
// // // // // //     'Spanish',
// // // // // //   ];
// // // // // //
// // // // // //   void saveInterests() {
// // // // // //     Get.snackbar(
// // // // // //       'Success',
// // // // // //       'Interests saved successfully',
// // // // // //       snackPosition: SnackPosition.TOP,
// // // // // //       backgroundColor: Colors.transparent,
// // // // // //       colorText: Colors.white,
// // // // // //       margin: const EdgeInsets.all(12),
// // // // // //       borderRadius: 10,
// // // // // //       duration: const Duration(seconds: 2),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final profileState = ref.watch(profileEditProvider);
// // // // // //     final notifier = ref.read(profileEditProvider.notifier);
// // // // // //
// // // // // //     return LayoutBuilder(
// // // // // //       builder: (context, constraints) {
// // // // // //         final double width = constraints.maxWidth;
// // // // // //         final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
// // // // // //         final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;
// // // // // //
// // // // // //         return Container(
// // // // // //           width: double.infinity,
// // // // // //           constraints: BoxConstraints(
// // // // // //             minHeight: MediaQuery.of(context).size.height * 0.62,
// // // // // //           ),
// // // // // //           padding: const EdgeInsets.all(16),
// // // // // //           decoration: BoxDecoration(
// // // // // //             color: Colors.white,
// // // // // //             borderRadius: BorderRadius.circular(14),
// // // // // //             border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // // //           ),
// // // // // //           child: Column(
// // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //             children: [
// // // // // //               if (profileState.isLoading)
// // // // // //                 const Padding(
// // // // // //                   padding: EdgeInsets.only(bottom: 10),
// // // // // //                   child: LinearProgressIndicator(color: Colors.pink),
// // // // // //                 ),
// // // // // //               sectionHeader(profileState, notifier),
// // // // // //               const SizedBox(height: 16),
// // // // // //               if (profileState.isProfileDetailsTab)
// // // // // //                 buildProfileDetailsContent(
// // // // // //                   context,
// // // // // //                   width,
// // // // // //                   profileState,
// // // // // //                   notifier,
// // // // // //                 )
// // // // // //               else
// // // // // //                 buildInterestsContent(
// // // // // //                   optionWidth,
// // // // // //                   profileState,
// // // // // //                   notifier,
// // // // // //                 ),
// // // // // //               const SizedBox(height: 18),
// // // // // //               Center(
// // // // // //                 child: SizedBox(
// // // // // //                   width: 170,
// // // // // //                   child: ElevatedButton(
// // // // // //                     onPressed: profileState.isLoading
// // // // // //                         ? null
// // // // // //                         : () => notifier.saveProfile(),
// // // // // //                     style: ElevatedButton.styleFrom(
// // // // // //                       elevation: 4,
// // // // // //                       padding: const EdgeInsets.symmetric(vertical: 12),
// // // // // //                       backgroundColor: const Color(0xFF220027),
// // // // // //                       foregroundColor: Colors.white,
// // // // // //                       shape: RoundedRectangleBorder(
// // // // // //                         borderRadius: BorderRadius.circular(22),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                     child: profileState.isLoading
// // // // // //                         ? const SizedBox(
// // // // // //                       height: 20,
// // // // // //                       width: 20,
// // // // // //                       child: CircularProgressIndicator(
// // // // // //                         color: Colors.white,
// // // // // //                         strokeWidth: 2,
// // // // // //                       ),
// // // // // //                     )
// // // // // //                         : Text(
// // // // // //                       profileState.isProfileDetailsTab
// // // // // //                           ? 'Save Profile'
// // // // // //                           : 'Save Interest',
// // // // // //                       style: const TextStyle(
// // // // // //                         fontWeight: FontWeight.w700,
// // // // // //                         fontSize: 12,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               const SizedBox(height: 6),
// // // // // //             ],
// // // // // //           ),
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
// // // // // //     return Container(
// // // // // //       height: 38,
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // //       decoration: BoxDecoration(
// // // // // //         gradient: const LinearGradient(
// // // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // //         ),
// // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           InkWell(
// // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // //             onTap: () => notifier.toggleProfileTab(false),
// // // // // //             child: Container(
// // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 color: !state.isProfileDetailsTab
// // // // // //                     ? const Color(0xFFFF2D87)
// // // // // //                     : Colors.transparent,
// // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // //               ),
// // // // // //               child: const Text(
// // // // // //                 'INTERESTS',
// // // // // //                 style: TextStyle(
// // // // // //                   color: Colors.white,
// // // // // //                   fontSize: 11,
// // // // // //                   fontWeight: FontWeight.w700,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           const Spacer(),
// // // // // //           InkWell(
// // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // //             onTap: () => notifier.toggleProfileTab(true),
// // // // // //             child: Container(
// // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 color: state.isProfileDetailsTab
// // // // // //                     ? const Color(0xFFFF2D87)
// // // // // //                     : Colors.transparent,
// // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // //               ),
// // // // // //               child: const Text(
// // // // // //                 'PROFILE DETAILS',
// // // // // //                 style: TextStyle(
// // // // // //                   color: Colors.white,
// // // // // //                   fontSize: 12,
// // // // // //                   fontWeight: FontWeight.w700,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget buildInterestsContent(
// // // // // //       double optionWidth,
// // // // // //       ProfileEditState state,
// // // // // //       ProfileEditNotifier notifier,
// // // // // //       ) {
// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         const Text(
// // // // // //           'davidbrown',
// // // // // //           style: TextStyle(
// // // // // //             fontWeight: FontWeight.w700,
// // // // // //             fontSize: 34,
// // // // // //             height: 1.05,
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 8),
// // // // // //         Text(
// // // // // //           'What are you looking for? Select all that apply',
// // // // // //           style: TextStyle(
// // // // // //             color: Colors.grey[700],
// // // // // //             fontSize: 14,
// // // // // //             fontWeight: FontWeight.w500,
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 16),
// // // // // //         interestGroup(
// // // // // //           title: 'Swingers',
// // // // // //           expanded: state.isSwingersExpanded,
// // // // // //           onToggle: notifier.toggleSwingersExpanded,
// // // // // //           options: state.swingersOptions,
// // // // // //           optionWidth: optionWidth,
// // // // // //           onChanged: (label, value) =>
// // // // // //               notifier.updateSwingersOption(label, value),
// // // // // //         ),
// // // // // //         const SizedBox(height: 12),
// // // // // //         interestGroup(
// // // // // //           title: 'Hookup / Meetup',
// // // // // //           expanded: state.isHookupExpanded,
// // // // // //           onToggle: notifier.toggleHookupExpanded,
// // // // // //           options: state.hookupOptions,
// // // // // //           optionWidth: optionWidth,
// // // // // //           onChanged: (label, value) => notifier.updateHookupOption(label, value),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget buildProfileDetailsContent(
// // // // // //       BuildContext context,
// // // // // //       double width,
// // // // // //       ProfileEditState state,
// // // // // //       ProfileEditNotifier notifier,
// // // // // //       ) {
// // // // // //     final bool stacked = width < 760;
// // // // // //
// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         textFieldLabel('INTRODUCE YOURSELF'),
// // // // // //         const SizedBox(height: 6),
// // // // // //         simpleTextField(
// // // // // //           label: 'About Me',
// // // // // //           initialValue: state.aboutMe,
// // // // // //           onChanged: notifier.updateAboutMe,
// // // // // //         ),
// // // // // //         const SizedBox(height: 10),
// // // // // //         textFieldLabel('LOOKING FOR'),
// // // // // //         const SizedBox(height: 6),
// // // // // //         simpleTextField(
// // // // // //           label: 'Looking For',
// // // // // //           initialValue: state.lookingFor,
// // // // // //           maxLines: 2,
// // // // // //           onChanged: notifier.updateLookingFor,
// // // // // //         ),
// // // // // //         const SizedBox(height: 14),
// // // // // //         const Center(
// // // // // //           child: Text(
// // // // // //             'About Yourselves',
// // // // // //             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 12),
// // // // // //         if (stacked)
// // // // // //           Column(
// // // // // //             children: [
// // // // // //               partnerPanel(
// // // // // //                 context: context,
// // // // // //                 title: 'Partner 1',
// // // // // //                 data: state.partner1,
// // // // // //                 languages: state.partner1Languages,
// // // // // //                 onFieldChanged: notifier.updatePartner1,
// // // // // //                 onLanguagesChanged: notifier.updatePartner1Languages,
// // // // // //               ),
// // // // // //               const SizedBox(height: 12),
// // // // // //               partnerPanel(
// // // // // //                 context: context,
// // // // // //                 title: 'Partner 2',
// // // // // //                 data: state.partner2,
// // // // // //                 languages: state.partner2Languages,
// // // // // //                 onFieldChanged: notifier.updatePartner2,
// // // // // //                 onLanguagesChanged: notifier.updatePartner2Languages,
// // // // // //                 readOnly: true,
// // // // // //               ),
// // // // // //             ],
// // // // // //           )
// // // // // //         else
// // // // // //           Row(
// // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //             children: [
// // // // // //               Expanded(
// // // // // //                 child: partnerPanel(
// // // // // //                   context: context,
// // // // // //                   title: 'Partner 1',
// // // // // //                   data: state.partner1,
// // // // // //                   languages: state.partner1Languages,
// // // // // //                   onFieldChanged: notifier.updatePartner1,
// // // // // //                   onLanguagesChanged: notifier.updatePartner1Languages,
// // // // // //                 ),
// // // // // //               ),
// // // // // //               const SizedBox(width: 12),
// // // // // //               Expanded(
// // // // // //                 child: partnerPanel(
// // // // // //                   context: context,
// // // // // //                   title: 'Partner 2',
// // // // // //                   data: state.partner2,
// // // // // //                   languages: state.partner2Languages,
// // // // // //                   onFieldChanged: notifier.updatePartner2,
// // // // // //                   onLanguagesChanged: notifier.updatePartner2Languages,
// // // // // //                   readOnly: true,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget partnerPanel({
// // // // // //     required BuildContext context,
// // // // // //     required String title,
// // // // // //     required Map<String, String> data,
// // // // // //     required List<String> languages,
// // // // // //     required void Function(String, String) onFieldChanged,
// // // // // //     required void Function(List<String>) onLanguagesChanged,
// // // // // //     bool readOnly = false,
// // // // // //   }) {
// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         Container(
// // // // // //           height: 34,
// // // // // //           alignment: Alignment.center,
// // // // // //           decoration: BoxDecoration(
// // // // // //             gradient: const LinearGradient(
// // // // // //               colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // //             ),
// // // // // //             borderRadius: BorderRadius.circular(10),
// // // // // //           ),
// // // // // //           child: Text(
// // // // // //             title,
// // // // // //             style: const TextStyle(
// // // // // //               color: Colors.white,
// // // // // //               fontWeight: FontWeight.w700,
// // // // // //             ),
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 10),
// // // // // //
// // // // // //         dateOfBirthField(
// // // // // //           context: context,
// // // // // //           label: 'DATE OF BIRTH',
// // // // // //           data: data,
// // // // // //           keyName: 'dateOfBirth',
// // // // // //           onFieldChanged: onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         heightInputField(
// // // // // //           data: data,
// // // // // //           onFieldChanged: onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         weightInputField(
// // // // // //           data: data,
// // // // // //           onFieldChanged: onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'BODY TYPE',
// // // // // //           data,
// // // // // //           'bodyType',
// // // // // //           ProfileOptions.bodyTypes,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'ETHNIC BACKGROUND',
// // // // // //           data,
// // // // // //           'ethnic',
// // // // // //           ProfileOptions.ethnicBackgrounds,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'SEXUALITY',
// // // // // //           data,
// // // // // //           'sexuality',
// // // // // //           ProfileOptions.sexualities,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'RELATIONSHIP ORIENTATION',
// // // // // //           data,
// // // // // //           'orientation',
// // // // // //           ProfileOptions.relationshipOrientations,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'TATTOOS',
// // // // // //           data,
// // // // // //           'tattoos',
// // // // // //           ProfileOptions.tattoos,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'PIERCINGS',
// // // // // //           data,
// // // // // //           'piercings',
// // // // // //           ProfileOptions.piercings,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'SMOKING',
// // // // // //           data,
// // // // // //           'smoking',
// // // // // //           ProfileOptions.smoking,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'DRINKING',
// // // // // //           data,
// // // // // //           'drinking',
// // // // // //           ProfileOptions.drinking,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'BODY HAIR',
// // // // // //           data,
// // // // // //           'bodyHair',
// // // // // //           ProfileOptions.bodyHair,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         languagesField(
// // // // // //           context,
// // // // // //           'LANGUAGES SPOKEN',
// // // // // //           languages,
// // // // // //           onLanguagesChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'LOOKS IMPORTANCE',
// // // // // //           data,
// // // // // //           'looks',
// // // // // //           ProfileOptions.importanceLevels,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'INTELLIGENCE IMPORTANCE',
// // // // // //           data,
// // // // // //           'intelligence',
// // // // // //           ProfileOptions.importanceLevels,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //
// // // // // //         profileOptionDropdownField(
// // // // // //           'CIRCUMCISED',
// // // // // //           data,
// // // // // //           'circumcised',
// // // // // //           ProfileOptions.circumcised,
// // // // // //           onFieldChanged,
// // // // // //           readOnly: readOnly,
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //   // UPDATED DATE OF BIRTH FIELD
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //
// // // // // //   Widget dateOfBirthField({
// // // // // //     required BuildContext context,
// // // // // //     required String label,
// // // // // //     required Map<String, String> data,
// // // // // //     required String keyName,
// // // // // //     required void Function(String, String) onFieldChanged,
// // // // // //     bool readOnly = false,
// // // // // //   }) {
// // // // // //     final currentValue = data[keyName] ?? '';
// // // // // //     final displayValue =
// // // // // //     currentValue.trim().isEmpty ? 'dd/mm/yyyy' : currentValue;
// // // // // //
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           textFieldLabel(label),
// // // // // //           const SizedBox(height: 4),
// // // // // //           InkWell(
// // // // // //             onTap: readOnly
// // // // // //                 ? null
// // // // // //                 : () async {
// // // // // //               final now = DateTime.now();
// // // // // //               final parsedDate = parseProfileDate(currentValue);
// // // // // //
// // // // // //               DateTime initialDate =
// // // // // //                   parsedDate ?? DateTime(now.year - 18, now.month, now.day);
// // // // // //
// // // // // //               if (initialDate.isAfter(now)) {
// // // // // //                 initialDate = now;
// // // // // //               }
// // // // // //
// // // // // //               if (initialDate.isBefore(DateTime(1900))) {
// // // // // //                 initialDate = DateTime(1900);
// // // // // //               }
// // // // // //
// // // // // //               final pickedDate = await showDatePicker(
// // // // // //                 context: context,
// // // // // //                 initialDate: initialDate,
// // // // // //                 firstDate: DateTime(1900),
// // // // // //                 lastDate: now,
// // // // // //               );
// // // // // //
// // // // // //               if (pickedDate == null) return;
// // // // // //
// // // // // //               onFieldChanged(keyName, formatProfileDate(pickedDate));
// // // // // //             },
// // // // // //             borderRadius: BorderRadius.circular(8),
// // // // // //             child: Container(
// // // // // //               height: 42,
// // // // // //               width: double.infinity,
// // // // // //               padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // //                 border: Border.all(
// // // // // //                   color: readOnly
// // // // // //                       ? const Color(0xFFF2F2F2)
// // // // // //                       : const Color(0xFFE8E0F2),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               child: Row(
// // // // // //                 children: [
// // // // // //                   Expanded(
// // // // // //                     child: Text(
// // // // // //                       displayValue,
// // // // // //                       maxLines: 1,
// // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // //                       style: TextStyle(
// // // // // //                         fontSize: 12,
// // // // // //                         color: currentValue.trim().isEmpty
// // // // // //                             ? Colors.grey[600]
// // // // // //                             : Colors.black87,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   const Icon(
// // // // // //                     Icons.calendar_today_outlined,
// // // // // //                     size: 17,
// // // // // //                     color: Colors.black87,
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //   // UPDATED HEIGHT FIELD
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //
// // // // // //   Widget heightInputField({
// // // // // //     required Map<String, String> data,
// // // // // //     required void Function(String, String) onFieldChanged,
// // // // // //     bool readOnly = false,
// // // // // //   }) {
// // // // // //     final selectedType = (data['heightType'] ?? '').trim().isEmpty
// // // // // //         ? null
// // // // // //         : data['heightType'];
// // // // // //
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           textFieldLabel('HEIGHT'),
// // // // // //           const SizedBox(height: 2),
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               unitRadioButton(
// // // // // //                 label: 'FT',
// // // // // //                 value: 'FT',
// // // // // //                 groupValue: selectedType,
// // // // // //                 readOnly: readOnly,
// // // // // //                 onChanged: (value) => onFieldChanged('heightType', value),
// // // // // //               ),
// // // // // //               const SizedBox(width: 18),
// // // // // //               unitRadioButton(
// // // // // //                 label: 'CM',
// // // // // //                 value: 'CM',
// // // // // //                 groupValue: selectedType,
// // // // // //                 readOnly: readOnly,
// // // // // //                 onChanged: (value) => onFieldChanged('heightType', value),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 4),
// // // // // //           TextFormField(
// // // // // //             key: ValueKey('height-${data['height'] ?? ''}-$readOnly'),
// // // // // //             initialValue: data['height'] ?? '',
// // // // // //             readOnly: readOnly,
// // // // // //             onChanged: readOnly
// // // // // //                 ? null
// // // // // //                 : (value) {
// // // // // //               onFieldChanged('height', value);
// // // // // //             },
// // // // // //             keyboardType: TextInputType.text,
// // // // // //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// // // // // //             decoration: profileInputDecoration(
// // // // // //               hintText: "Ex. (5'7 OR 170)",
// // // // // //               readOnly: readOnly,
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //   // UPDATED WEIGHT FIELD
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //
// // // // // //   Widget weightInputField({
// // // // // //     required Map<String, String> data,
// // // // // //     required void Function(String, String) onFieldChanged,
// // // // // //     bool readOnly = false,
// // // // // //   }) {
// // // // // //     final selectedType = (data['weightType'] ?? '').trim().isEmpty
// // // // // //         ? null
// // // // // //         : data['weightType'];
// // // // // //
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           textFieldLabel('WEIGHT'),
// // // // // //           const SizedBox(height: 2),
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               unitRadioButton(
// // // // // //                 label: 'LBS',
// // // // // //                 value: 'LBS',
// // // // // //                 groupValue: selectedType,
// // // // // //                 readOnly: readOnly,
// // // // // //                 onChanged: (value) => onFieldChanged('weightType', value),
// // // // // //               ),
// // // // // //               const SizedBox(width: 18),
// // // // // //               unitRadioButton(
// // // // // //                 label: 'KG',
// // // // // //                 value: 'KG',
// // // // // //                 groupValue: selectedType,
// // // // // //                 readOnly: readOnly,
// // // // // //                 onChanged: (value) => onFieldChanged('weightType', value),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 4),
// // // // // //           TextFormField(
// // // // // //             key: ValueKey('weight-${data['weight'] ?? ''}-$readOnly'),
// // // // // //             initialValue: data['weight'] ?? '',
// // // // // //             readOnly: readOnly,
// // // // // //             onChanged: readOnly
// // // // // //                 ? null
// // // // // //                 : (value) {
// // // // // //               onFieldChanged('weight', value);
// // // // // //             },
// // // // // //             keyboardType: TextInputType.number,
// // // // // //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// // // // // //             decoration: profileInputDecoration(
// // // // // //               hintText: 'Ex. (150 LBS OR 68 KG)',
// // // // // //               readOnly: readOnly,
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget unitRadioButton({
// // // // // //     required String label,
// // // // // //     required String value,
// // // // // //     required String? groupValue,
// // // // // //     required void Function(String) onChanged,
// // // // // //     bool readOnly = false,
// // // // // //   }) {
// // // // // //     return InkWell(
// // // // // //       onTap: readOnly ? null : () => onChanged(value),
// // // // // //       borderRadius: BorderRadius.circular(8),
// // // // // //       child: Row(
// // // // // //         mainAxisSize: MainAxisSize.min,
// // // // // //         children: [
// // // // // //           Radio<String>(
// // // // // //             value: value,
// // // // // //             groupValue: groupValue,
// // // // // //             onChanged: readOnly
// // // // // //                 ? null
// // // // // //                 : (selectedValue) {
// // // // // //               if (selectedValue == null) return;
// // // // // //               onChanged(selectedValue);
// // // // // //             },
// // // // // //             activeColor: const Color(0xFF5A002B),
// // // // // //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // // // // //             visualDensity: VisualDensity.compact,
// // // // // //           ),
// // // // // //           Text(
// // // // // //             label,
// // // // // //             style: const TextStyle(
// // // // // //               fontSize: 12,
// // // // // //               fontWeight: FontWeight.w800,
// // // // // //               color: Color(0xFF5A002B),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   InputDecoration profileInputDecoration({
// // // // // //     required String hintText,
// // // // // //     bool readOnly = false,
// // // // // //   }) {
// // // // // //     return InputDecoration(
// // // // // //       hintText: hintText,
// // // // // //       hintStyle: TextStyle(
// // // // // //         color: Colors.grey[600],
// // // // // //         fontSize: 12,
// // // // // //       ),
// // // // // //       isDense: true,
// // // // // //       contentPadding: const EdgeInsets.symmetric(
// // // // // //         horizontal: 10,
// // // // // //         vertical: 12,
// // // // // //       ),
// // // // // //       border: OutlineInputBorder(
// // // // // //         borderRadius: BorderRadius.circular(8),
// // // // // //         borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // //       ),
// // // // // //       enabledBorder: OutlineInputBorder(
// // // // // //         borderRadius: BorderRadius.circular(8),
// // // // // //         borderSide: BorderSide(
// // // // // //           color: readOnly
// // // // // //               ? const Color(0xFFF2F2F2)
// // // // // //               : const Color(0xFFE8E0F2),
// // // // // //         ),
// // // // // //       ),
// // // // // //       focusedBorder: OutlineInputBorder(
// // // // // //         borderRadius: BorderRadius.circular(8),
// // // // // //         borderSide: const BorderSide(color: Color(0xFF5A002B)),
// // // // // //       ),
// // // // // //       fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // // //       filled: true,
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   DateTime? parseProfileDate(String? value) {
// // // // // //     if (value == null || value.trim().isEmpty) return null;
// // // // // //
// // // // // //     final text = value.trim();
// // // // // //
// // // // // //     final dmyMatch =
// // // // // //     RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);
// // // // // //
// // // // // //     if (dmyMatch != null) {
// // // // // //       final day = int.tryParse(dmyMatch.group(1)!);
// // // // // //       final month = int.tryParse(dmyMatch.group(2)!);
// // // // // //       final year = int.tryParse(dmyMatch.group(3)!);
// // // // // //
// // // // // //       if (day != null && month != null && year != null) {
// // // // // //         return DateTime(year, month, day);
// // // // // //       }
// // // // // //     }
// // // // // //
// // // // // //     final isoMatch =
// // // // // //     RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
// // // // // //
// // // // // //     if (isoMatch != null) {
// // // // // //       final year = int.tryParse(isoMatch.group(1)!);
// // // // // //       final month = int.tryParse(isoMatch.group(2)!);
// // // // // //       final day = int.tryParse(isoMatch.group(3)!);
// // // // // //
// // // // // //       if (day != null && month != null && year != null) {
// // // // // //         return DateTime(year, month, day);
// // // // // //       }
// // // // // //     }
// // // // // //
// // // // // //     return DateTime.tryParse(text);
// // // // // //   }
// // // // // //
// // // // // //   String formatProfileDate(DateTime date) {
// // // // // //     final day = date.day.toString().padLeft(2, '0');
// // // // // //     final month = date.month.toString().padLeft(2, '0');
// // // // // //     final year = date.year.toString();
// // // // // //
// // // // // //     return '$day/$month/$year';
// // // // // //   }
// // // // // //
// // // // // //   ProfileOption? findProfileOption(
// // // // // //       String? currentValue,
// // // // // //       List<ProfileOption> options,
// // // // // //       ) {
// // // // // //     if (currentValue == null || currentValue.trim().isEmpty) {
// // // // // //       return null;
// // // // // //     }
// // // // // //
// // // // // //     final normalizedCurrent = normalize(currentValue);
// // // // // //
// // // // // //     for (final option in options) {
// // // // // //       if (normalize(option.id) == normalizedCurrent ||
// // // // // //           normalize(option.value) == normalizedCurrent ||
// // // // // //           normalize(option.label) == normalizedCurrent) {
// // // // // //         return option;
// // // // // //       }
// // // // // //     }
// // // // // //
// // // // // //     if (normalizedCurrent == normalize('Bisexual')) {
// // // // // //       return firstProfileOptionWhere(
// // // // // //         options,
// // // // // //             (e) => e.value == 'Bi-sexual',
// // // // // //       );
// // // // // //     }
// // // // // //
// // // // // //     if (normalizedCurrent == normalize('Occasionally')) {
// // // // // //       return firstProfileOptionWhere(
// // // // // //         options,
// // // // // //             (e) => e.value == 'Occasionaly',
// // // // // //       );
// // // // // //     }
// // // // // //
// // // // // //     if (normalizedCurrent == normalize('Low')) {
// // // // // //       return firstProfileOptionWhere(
// // // // // //         options,
// // // // // //             (e) => e.value == 'Low Importance',
// // // // // //       );
// // // // // //     }
// // // // // //
// // // // // //     if (normalizedCurrent == normalize('Medium')) {
// // // // // //       return firstProfileOptionWhere(
// // // // // //         options,
// // // // // //             (e) => e.value == 'Medium Importance',
// // // // // //       );
// // // // // //     }
// // // // // //
// // // // // //     if (normalizedCurrent == normalize('High')) {
// // // // // //       return firstProfileOptionWhere(
// // // // // //         options,
// // // // // //             (e) => e.value == 'Very Important',
// // // // // //       );
// // // // // //     }
// // // // // //
// // // // // //     return null;
// // // // // //   }
// // // // // //
// // // // // //   ProfileOption? firstProfileOptionWhere(
// // // // // //       List<ProfileOption> options,
// // // // // //       bool Function(ProfileOption option) test,
// // // // // //       ) {
// // // // // //     for (final option in options) {
// // // // // //       if (test(option)) return option;
// // // // // //     }
// // // // // //
// // // // // //     return null;
// // // // // //   }
// // // // // //
// // // // // //   String normalize(String value) {
// // // // // //     return value
// // // // // //         .trim()
// // // // // //         .toLowerCase()
// // // // // //         .replaceAll('.', '')
// // // // // //         .replaceAll('-', '')
// // // // // //         .replaceAll('_', '')
// // // // // //         .replaceAll(' ', '');
// // // // // //   }
// // // // // //
// // // // // //   String? defaultProfileOptionValue(List<ProfileOption> options) {
// // // // // //     if (options.isEmpty) return null;
// // // // // //
// // // // // //     for (final option in options) {
// // // // // //       if (option.id == 'not_comfortable') {
// // // // // //         return option.value;
// // // // // //       }
// // // // // //     }
// // // // // //
// // // // // //     return options.first.value;
// // // // // //   }
// // // // // //
// // // // // //   Widget profileOptionDropdownField(
// // // // // //       String label,
// // // // // //       Map<String, String> data,
// // // // // //       String key,
// // // // // //       List<ProfileOption> options,
// // // // // //       void Function(String, String) onFieldChanged, {
// // // // // //         bool readOnly = false,
// // // // // //       }) {
// // // // // //     final currentValue = data[key];
// // // // // //     final selectedOption = findProfileOption(currentValue, options);
// // // // // //     final validValue =
// // // // // //         selectedOption?.value ?? defaultProfileOptionValue(options);
// // // // // //
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           textFieldLabel(label),
// // // // // //           const SizedBox(height: 4),
// // // // // //           DropdownButtonFormField<String>(
// // // // // //             key: ValueKey('$label-$key-$validValue-$readOnly'),
// // // // // //             initialValue: validValue,
// // // // // //             isExpanded: true,
// // // // // //             iconSize: 18,
// // // // // //             style: const TextStyle(
// // // // // //               fontSize: 12,
// // // // // //               color: Colors.black87,
// // // // // //               overflow: TextOverflow.ellipsis,
// // // // // //             ),
// // // // // //             items: options.map((option) {
// // // // // //               return DropdownMenuItem<String>(
// // // // // //                 value: option.value,
// // // // // //                 child: Text(
// // // // // //                   option.label,
// // // // // //                   maxLines: 1,
// // // // // //                   overflow: TextOverflow.ellipsis,
// // // // // //                 ),
// // // // // //               );
// // // // // //             }).toList(),
// // // // // //             selectedItemBuilder: (context) {
// // // // // //               return options.map((option) {
// // // // // //                 return Align(
// // // // // //                   alignment: Alignment.centerLeft,
// // // // // //                   child: Text(
// // // // // //                     option.label,
// // // // // //                     maxLines: 1,
// // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // //                   ),
// // // // // //                 );
// // // // // //               }).toList();
// // // // // //             },
// // // // // //             onChanged: readOnly
// // // // // //                 ? null
// // // // // //                 : (value) {
// // // // // //               if (value == null) return;
// // // // // //               onFieldChanged(key, value);
// // // // // //             },
// // // // // //             decoration: InputDecoration(
// // // // // //               isDense: true,
// // // // // //               contentPadding: const EdgeInsets.symmetric(
// // // // // //                 horizontal: 10,
// // // // // //                 vertical: 8,
// // // // // //               ),
// // // // // //               border: OutlineInputBorder(
// // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // //               ),
// // // // // //               enabledBorder: OutlineInputBorder(
// // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // //                 borderSide: BorderSide(
// // // // // //                   color: readOnly
// // // // // //                       ? const Color(0xFFF2F2F2)
// // // // // //                       : const Color(0xFFE8E0F2),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// // // // // //               filled: readOnly,
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget dropdownField(
// // // // // //       String label,
// // // // // //       Map<String, String> data,
// // // // // //       String key,
// // // // // //       List<String> options,
// // // // // //       void Function(String, String) onFieldChanged, {
// // // // // //         bool readOnly = false,
// // // // // //       }) {
// // // // // //     final currentValue = data[key];
// // // // // //     final validValue = currentValue != null && options.contains(currentValue)
// // // // // //         ? currentValue
// // // // // //         : options.isNotEmpty
// // // // // //         ? options[0]
// // // // // //         : null;
// // // // // //
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           textFieldLabel(label),
// // // // // //           const SizedBox(height: 4),
// // // // // //           DropdownButtonFormField<String>(
// // // // // //             key: ValueKey('$label-$key-$validValue-$readOnly'),
// // // // // //             initialValue: validValue,
// // // // // //             isExpanded: true,
// // // // // //             iconSize: 18,
// // // // // //             style: const TextStyle(
// // // // // //               fontSize: 12,
// // // // // //               color: Colors.black87,
// // // // // //               overflow: TextOverflow.ellipsis,
// // // // // //             ),
// // // // // //             items: options
// // // // // //                 .map(
// // // // // //                   (e) => DropdownMenuItem<String>(
// // // // // //                 value: e,
// // // // // //                 child: Text(
// // // // // //                   e,
// // // // // //                   maxLines: 1,
// // // // // //                   overflow: TextOverflow.ellipsis,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             )
// // // // // //                 .toList(),
// // // // // //             selectedItemBuilder: (context) {
// // // // // //               return options
// // // // // //                   .map(
// // // // // //                     (e) => Align(
// // // // // //                   alignment: Alignment.centerLeft,
// // // // // //                   child: Text(
// // // // // //                     e,
// // // // // //                     maxLines: 1,
// // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               )
// // // // // //                   .toList();
// // // // // //             },
// // // // // //             onChanged: readOnly
// // // // // //                 ? null
// // // // // //                 : (value) {
// // // // // //               if (value == null) return;
// // // // // //               onFieldChanged(key, value);
// // // // // //             },
// // // // // //             decoration: InputDecoration(
// // // // // //               isDense: true,
// // // // // //               contentPadding: const EdgeInsets.symmetric(
// // // // // //                 horizontal: 10,
// // // // // //                 vertical: 8,
// // // // // //               ),
// // // // // //               border: OutlineInputBorder(
// // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // //               ),
// // // // // //               enabledBorder: OutlineInputBorder(
// // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // //                 borderSide: BorderSide(
// // // // // //                   color: readOnly
// // // // // //                       ? const Color(0xFFF2F2F2)
// // // // // //                       : const Color(0xFFE8E0F2),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// // // // // //               filled: readOnly,
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget simpleTextField({
// // // // // //     required String label,
// // // // // //     required String initialValue,
// // // // // //     required void Function(String) onChanged,
// // // // // //     int maxLines = 1,
// // // // // //     bool readOnly = false,
// // // // // //   }) {
// // // // // //     return TextFormField(
// // // // // //       key: ValueKey('$label-$initialValue-$readOnly'),
// // // // // //       initialValue: initialValue,
// // // // // //       maxLines: maxLines,
// // // // // //       onChanged: onChanged,
// // // // // //       readOnly: readOnly,
// // // // // //       style: const TextStyle(fontSize: 12),
// // // // // //       decoration: InputDecoration(
// // // // // //         hintText: label,
// // // // // //         isDense: true,
// // // // // //         contentPadding: const EdgeInsets.symmetric(
// // // // // //           horizontal: 10,
// // // // // //           vertical: 10,
// // // // // //         ),
// // // // // //         border: OutlineInputBorder(
// // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // //         ),
// // // // // //         enabledBorder: OutlineInputBorder(
// // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget textFieldLabel(String text) {
// // // // // //     return Text(
// // // // // //       text,
// // // // // //       style: const TextStyle(
// // // // // //         fontSize: 11,
// // // // // //         fontWeight: FontWeight.w800,
// // // // // //         letterSpacing: 0.2,
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //   // UPDATED LANGUAGES SPOKEN FIELD
// // // // // //   // ---------------------------------------------------------------------------
// // // // // //
// // // // // //   Widget languagesField(
// // // // // //       BuildContext context,
// // // // // //       String label,
// // // // // //       List<String> selectedValues,
// // // // // //       void Function(List<String>) onSaved, {
// // // // // //         bool readOnly = false,
// // // // // //       }) {
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           textFieldLabel(label),
// // // // // //           const SizedBox(height: 4),
// // // // // //           InkWell(
// // // // // //             onTap: readOnly
// // // // // //                 ? null
// // // // // //                 : () => openLanguageSelector(context, selectedValues, onSaved),
// // // // // //             borderRadius: BorderRadius.circular(8),
// // // // // //             child: Container(
// // // // // //               width: double.infinity,
// // // // // //               constraints: const BoxConstraints(minHeight: 42),
// // // // // //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // //                 border: Border.all(
// // // // // //                   color: readOnly
// // // // // //                       ? const Color(0xFFF2F2F2)
// // // // // //                       : const Color(0xFFE8E0F2),
// // // // // //                 ),
// // // // // //                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // // //               ),
// // // // // //               child: Row(
// // // // // //                 children: [
// // // // // //                   Expanded(
// // // // // //                     child: selectedValues.isEmpty
// // // // // //                         ? Text(
// // // // // //                       ProfileOptions.notComfortableLabel,
// // // // // //                       maxLines: 1,
// // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // //                       style: TextStyle(
// // // // // //                         color: Colors.grey[600],
// // // // // //                         fontSize: 12,
// // // // // //                       ),
// // // // // //                     )
// // // // // //                         : Wrap(
// // // // // //                       spacing: 6,
// // // // // //                       runSpacing: 6,
// // // // // //                       children: selectedValues
// // // // // //                           .map(
// // // // // //                             (lang) => Container(
// // // // // //                           padding: const EdgeInsets.symmetric(
// // // // // //                             horizontal: 8,
// // // // // //                             vertical: 3,
// // // // // //                           ),
// // // // // //                           decoration: BoxDecoration(
// // // // // //                             color: const Color(0xFFF0F4FF),
// // // // // //                             borderRadius: BorderRadius.circular(12),
// // // // // //                             border: Border.all(
// // // // // //                               color: const Color(0xFFD4DDF2),
// // // // // //                             ),
// // // // // //                           ),
// // // // // //                           child: Text(
// // // // // //                             lang,
// // // // // //                             style: const TextStyle(fontSize: 11),
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                       )
// // // // // //                           .toList(),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   const SizedBox(width: 8),
// // // // // //                   const Icon(
// // // // // //                     Icons.keyboard_arrow_down_rounded,
// // // // // //                     size: 20,
// // // // // //                     color: Colors.black87,
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Future<void> openLanguageSelector(
// // // // // //       BuildContext context,
// // // // // //       List<String> selectedValues,
// // // // // //       void Function(List<String>) onSaved,
// // // // // //       ) async {
// // // // // //     final temp = [...selectedValues];
// // // // // //
// // // // // //     await showModalBottomSheet<void>(
// // // // // //       context: context,
// // // // // //       builder: (context) {
// // // // // //         return StatefulBuilder(
// // // // // //           builder: (context, setModalState) {
// // // // // //             return SafeArea(
// // // // // //               child: Padding(
// // // // // //                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
// // // // // //                 child: Column(
// // // // // //                   mainAxisSize: MainAxisSize.min,
// // // // // //                   children: [
// // // // // //                     const Text(
// // // // // //                       'Select Languages',
// // // // // //                       style: TextStyle(
// // // // // //                         fontWeight: FontWeight.w700,
// // // // // //                         fontSize: 16,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                     const SizedBox(height: 10),
// // // // // //                     ...languageOptions.map(
// // // // // //                           (lang) => CheckboxListTile(
// // // // // //                         dense: true,
// // // // // //                         value: temp.contains(lang),
// // // // // //                         onChanged: (checked) {
// // // // // //                           setModalState(() {
// // // // // //                             if (checked == true) {
// // // // // //                               if (!temp.contains(lang)) temp.add(lang);
// // // // // //                             } else {
// // // // // //                               temp.remove(lang);
// // // // // //                             }
// // // // // //                           });
// // // // // //                         },
// // // // // //                         title: Text(lang),
// // // // // //                         controlAffinity: ListTileControlAffinity.leading,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                     const SizedBox(height: 8),
// // // // // //                     SizedBox(
// // // // // //                       width: double.infinity,
// // // // // //                       child: ElevatedButton(
// // // // // //                         onPressed: () {
// // // // // //                           onSaved(temp);
// // // // // //                           Navigator.pop(context);
// // // // // //                         },
// // // // // //                         child: const Text('Done'),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             );
// // // // // //           },
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget interestGroup({
// // // // // //     required String title,
// // // // // //     required bool expanded,
// // // // // //     required VoidCallback onToggle,
// // // // // //     required Map<String, bool> options,
// // // // // //     required double optionWidth,
// // // // // //     required void Function(String label, bool value) onChanged,
// // // // // //   }) {
// // // // // //     return Container(
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(10),
// // // // // //         border: Border.all(color: const Color(0xFFECE4F4)),
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         children: [
// // // // // //           InkWell(
// // // // // //             onTap: onToggle,
// // // // // //             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
// // // // // //             child: Container(
// // // // // //               height: 40,
// // // // // //               padding: const EdgeInsets.symmetric(horizontal: 14),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 gradient: const LinearGradient(
// // // // // //                   colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // //                 ),
// // // // // //                 borderRadius: BorderRadius.vertical(
// // // // // //                   top: const Radius.circular(10),
// // // // // //                   bottom: expanded ? Radius.zero : const Radius.circular(10),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               child: Row(
// // // // // //                 children: [
// // // // // //                   Expanded(
// // // // // //                     child: Text(
// // // // // //                       title,
// // // // // //                       maxLines: 1,
// // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // //                       style: const TextStyle(
// // // // // //                         color: Colors.white,
// // // // // //                         fontSize: 30,
// // // // // //                         fontWeight: FontWeight.w800,
// // // // // //                         height: 1.0,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   const SizedBox(width: 8),
// // // // // //                   CircleAvatar(
// // // // // //                     radius: 12,
// // // // // //                     backgroundColor: const Color(0xFFEACD71),
// // // // // //                     child: Icon(
// // // // // //                       expanded
// // // // // //                           ? Icons.keyboard_arrow_up
// // // // // //                           : Icons.keyboard_arrow_down,
// // // // // //                       size: 16,
// // // // // //                       color: Colors.black87,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           if (expanded)
// // // // // //             Padding(
// // // // // //               padding: const EdgeInsets.all(10),
// // // // // //               child: Wrap(
// // // // // //                 spacing: 8,
// // // // // //                 runSpacing: 8,
// // // // // //                 children: options.entries
// // // // // //                     .map(
// // // // // //                       (entry) => OptionChip(
// // // // // //                     label: entry.key,
// // // // // //                     selected: entry.value,
// // // // // //                     width: optionWidth,
// // // // // //                     onTap: () => onChanged(entry.key, !entry.value),
// // // // // //                   ),
// // // // // //                 )
// // // // // //                     .toList(),
// // // // // //               ),
// // // // // //             ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // // -----------------------------------------------------------------------------
// // // // // // // OPTION CHIP
// // // // // // // -----------------------------------------------------------------------------
// // // // // //
// // // // // // class OptionChip extends StatelessWidget {
// // // // // //   const OptionChip({
// // // // // //     super.key,
// // // // // //     required this.label,
// // // // // //     required this.selected,
// // // // // //     required this.width,
// // // // // //     required this.onTap,
// // // // // //   });
// // // // // //
// // // // // //   final String label;
// // // // // //   final bool selected;
// // // // // //   final double width;
// // // // // //   final VoidCallback onTap;
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return InkWell(
// // // // // //       onTap: onTap,
// // // // // //       borderRadius: BorderRadius.circular(8),
// // // // // //       child: Container(
// // // // // //         width: width,
// // // // // //         height: 42,
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: Colors.white,
// // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // //           border: Border.all(color: const Color(0xFFF1EBF8)),
// // // // // //         ),
// // // // // //         child: Row(
// // // // // //           children: [
// // // // // //             Expanded(
// // // // // //               child: Text(
// // // // // //                 label,
// // // // // //                 overflow: TextOverflow.ellipsis,
// // // // // //                 style: const TextStyle(
// // // // // //                   color: Colors.black87,
// // // // // //                   fontWeight: FontWeight.w500,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //             Checkbox(
// // // // // //               value: selected,
// // // // // //               onChanged: (_) => onTap(),
// // // // // //               shape: RoundedRectangleBorder(
// // // // // //                 borderRadius: BorderRadius.circular(4),
// // // // // //               ),
// // // // // //               activeColor: const Color(0xFF47003D),
// // // // // //               side: const BorderSide(color: Color(0xFFE0D4EE)),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // import 'package:get/get.dart';
// // // // // // //
// // // // // // // import 'package:beatflirt/Api_services/api_services.dart';
// // // // // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // // // //
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // // // PROFILE OPTIONS
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // //
// // // // // // // class ProfileOption {
// // // // // // //   final String id;
// // // // // // //   final String value;
// // // // // // //   final String label;
// // // // // // //
// // // // // // //   const ProfileOption({
// // // // // // //     required this.id,
// // // // // // //     required this.value,
// // // // // // //     required this.label,
// // // // // // //   });
// // // // // // //
// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'id': id,
// // // // // // //       'value': value,
// // // // // // //       'label': label,
// // // // // // //     };
// // // // // // //   }
// // // // // // // }
// // // // // // //
// // // // // // // class ProfileOptions {
// // // // // // //   static const String notComfortableValue = 'Im not comfortable sharing that';
// // // // // // //   static const String notComfortableLabel =
// // // // // // //       "I'm not comfortable sharing that.";
// // // // // // //
// // // // // // //   static const ProfileOption notComfortable = ProfileOption(
// // // // // // //     id: 'not_comfortable',
// // // // // // //     value: notComfortableValue,
// // // // // // //     label: notComfortableLabel,
// // // // // // //   );
// // // // // // //
// // // // // // //   static const List<ProfileOption> tattoos = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'none', value: 'None', label: 'None'),
// // // // // // //     ProfileOption(id: 'one', value: 'One', label: 'One'),
// // // // // // //     ProfileOption(id: 'a_few', value: 'A Few', label: 'A Few'),
// // // // // // //     ProfileOption(id: 'inked', value: 'Inked', label: 'Inked'),
// // // // // // //     ProfileOption(id: 'everywhere', value: 'Everywhere', label: 'Everywhere'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> heightTypes = [
// // // // // // //     ProfileOption(id: 'ft', value: 'FT', label: 'FT'),
// // // // // // //     ProfileOption(id: 'cm', value: 'CM', label: 'CM'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> weightTypes = [
// // // // // // //     ProfileOption(id: 'lbs', value: 'LBS', label: 'LBS(Pounds)'),
// // // // // // //     ProfileOption(id: 'kg', value: 'KG', label: 'Kilogram'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> bodyTypes = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'athletic', value: 'Athletic', label: 'Athletic'),
// // // // // // //     ProfileOption(id: 'average', value: 'Average', label: 'Average'),
// // // // // // //     ProfileOption(id: 'bbw', value: 'BBW', label: 'BBW'),
// // // // // // //     ProfileOption(id: 'curvy', value: 'Curvy', label: 'Curvy'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'huggable_and_heavy',
// // // // // // //       value: 'Huggable and Heavy',
// // // // // // //       label: 'Huggable and Heavy',
// // // // // // //     ),
// // // // // // //     ProfileOption(id: 'muscular', value: 'Muscular', label: 'Muscular'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'more_of_me_to_love',
// // // // // // //       value: 'More of me to love',
// // // // // // //       label: 'More of me to love',
// // // // // // //     ),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'nicely_shaped',
// // // // // // //       value: 'Nicely Shaped',
// // // // // // //       label: 'Nicely Shaped',
// // // // // // //     ),
// // // // // // //     ProfileOption(id: 'slim', value: 'Slim', label: 'Slim'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> smoking = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'occasionally',
// // // // // // //       value: 'Occasionaly',
// // // // // // //       label: 'Occasionally',
// // // // // // //     ),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> drinking = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'occasionally',
// // // // // // //       value: 'Occasionaly',
// // // // // // //       label: 'Occasionally',
// // // // // // //     ),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> ethnicBackgrounds = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'other', value: 'Other', label: 'Other'),
// // // // // // //     ProfileOption(id: 'american', value: 'American', label: 'American'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'argentine_argentinian',
// // // // // // //       value: 'Argentine/Argentinian',
// // // // // // //       label: 'Argentine/Argentinian',
// // // // // // //     ),
// // // // // // //     ProfileOption(id: 'australian', value: 'Australian', label: 'Australian'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'black_african_american',
// // // // // // //       value: 'Black/African - American',
// // // // // // //       label: 'Black/African - American',
// // // // // // //     ),
// // // // // // //     ProfileOption(id: 'brazilian', value: 'Brazilian', label: 'Brazilian'),
// // // // // // //     ProfileOption(id: 'british', value: 'British', label: 'British'),
// // // // // // //     ProfileOption(id: 'canadian', value: 'Canadian', label: 'Canadian'),
// // // // // // //     ProfileOption(id: 'chilean', value: 'Chilean', label: 'Chilean'),
// // // // // // //     ProfileOption(id: 'chinese', value: 'Chinese', label: 'Chinese'),
// // // // // // //     ProfileOption(id: 'egyptian', value: 'Egyptian', label: 'Egyptian'),
// // // // // // //     ProfileOption(id: 'filipino', value: 'Filipino', label: 'Filipino'),
// // // // // // //     ProfileOption(id: 'fijian', value: 'Fijian', label: 'Fijian'),
// // // // // // //     ProfileOption(id: 'french', value: 'French', label: 'French'),
// // // // // // //     ProfileOption(id: 'german', value: 'German', label: 'German'),
// // // // // // //     ProfileOption(id: 'indian', value: 'Indian', label: 'Indian'),
// // // // // // //     ProfileOption(id: 'iranian', value: 'Iranian', label: 'Iranian'),
// // // // // // //     ProfileOption(id: 'iraqi', value: 'Iraqi', label: 'Iraqi'),
// // // // // // //     ProfileOption(id: 'italian', value: 'Italian', label: 'Italian'),
// // // // // // //     ProfileOption(id: 'japanese', value: 'Japanese', label: 'Japanese'),
// // // // // // //     ProfileOption(id: 'kenyan', value: 'Kenyan', label: 'Kenyan'),
// // // // // // //     ProfileOption(id: 'mexican', value: 'Mexican', label: 'Mexican'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'new_zealander_kiwi',
// // // // // // //       value: 'New Zealander/Kiwi',
// // // // // // //       label: 'New Zealander/Kiwi',
// // // // // // //     ),
// // // // // // //     ProfileOption(id: 'nigerian', value: 'Nigerian', label: 'Nigerian'),
// // // // // // //     ProfileOption(id: 'pakistani', value: 'Pakistani', label: 'Pakistani'),
// // // // // // //     ProfileOption(id: 'peruvian', value: 'Peruvian', label: 'Peruvian'),
// // // // // // //     ProfileOption(id: 'russian', value: 'Russian', label: 'Russian'),
// // // // // // //     ProfileOption(id: 'saudi', value: 'Saudi', label: 'Saudi'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'south_african',
// // // // // // //       value: 'South African',
// // // // // // //       label: 'South African',
// // // // // // //     ),
// // // // // // //     ProfileOption(id: 'spanish', value: 'Spanish', label: 'Spanish'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'sri_lankan',
// // // // // // //       value: 'Sri Lankan',
// // // // // // //       label: 'Sri Lankan',
// // // // // // //     ),
// // // // // // //     ProfileOption(id: 'thai', value: 'Thai', label: 'Thai'),
// // // // // // //     ProfileOption(id: 'turkish', value: 'Turkish', label: 'Turkish'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> importanceLevels = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'low_importance',
// // // // // // //       value: 'Low Importance',
// // // // // // //       label: 'Low Importance',
// // // // // // //     ),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'medium_importance',
// // // // // // //       value: 'Medium Importance',
// // // // // // //       label: 'Medium Importance',
// // // // // // //     ),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'very_important',
// // // // // // //       value: 'Very Important',
// // // // // // //       label: 'Very Important',
// // // // // // //     ),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> sexualities = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'bi_curious', value: 'Bi-curious', label: 'Bi-curious'),
// // // // // // //     ProfileOption(id: 'bi_sexual', value: 'Bi-sexual', label: 'Bi-sexual'),
// // // // // // //     ProfileOption(id: 'gay', value: 'Gay', label: 'Gay'),
// // // // // // //     ProfileOption(id: 'lesbian', value: 'Lesbian', label: 'Lesbian'),
// // // // // // //     ProfileOption(id: 'pansexual', value: 'Pansexual', label: 'Pansexual'),
// // // // // // //     ProfileOption(id: 'polymorous', value: 'Polymorous', label: 'Polymorous'),
// // // // // // //     ProfileOption(id: 'straight', value: 'Straight', label: 'Straight'),
// // // // // // //     ProfileOption(id: 'transsexual', value: 'Transsexual', label: 'Transsexual'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> relationshipOrientations = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'monogamous', value: 'Monogamous', label: 'Monogamous'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'open_minded',
// // // // // // //       value: 'Open-Minded',
// // // // // // //       label: 'Open-Minded',
// // // // // // //     ),
// // // // // // //     ProfileOption(id: 'swinger', value: 'Swinger', label: 'Swinger'),
// // // // // // //     ProfileOption(
// // // // // // //       id: 'polyamorous',
// // // // // // //       value: 'Polyamorous',
// // // // // // //       label: 'Polyamorous',
// // // // // // //     ),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> circumcised = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const List<ProfileOption> piercings = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'yes', value: 'Yes', label: 'Yes'),
// // // // // // //     ProfileOption(id: 'no', value: 'No', label: 'No'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   // These were not visible in your Angular HTML because they came from:
// // // // // // //   // body_hair_source1 / body_hair_source2.
// // // // // // //   // Update this list if your backend has different body hair options.
// // // // // // //   static const List<ProfileOption> bodyHair = [
// // // // // // //     notComfortable,
// // // // // // //     ProfileOption(id: 'bikini', value: 'Bikini', label: 'Bikini'),
// // // // // // //     ProfileOption(id: 'arm_chest', value: 'Arm, Chest', label: 'Arm, Chest'),
// // // // // // //     ProfileOption(id: 'trimmed', value: 'Trimmed', label: 'Trimmed'),
// // // // // // //     ProfileOption(id: 'natural', value: 'Natural', label: 'Natural'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   static const Map<String, List<ProfileOption>> groups = {
// // // // // // //     'tattoos': tattoos,
// // // // // // //     'height_types': heightTypes,
// // // // // // //     'weight_types': weightTypes,
// // // // // // //     'body_types': bodyTypes,
// // // // // // //     'smoking': smoking,
// // // // // // //     'drinking': drinking,
// // // // // // //     'ethnic_backgrounds': ethnicBackgrounds,
// // // // // // //     'importance_levels': importanceLevels,
// // // // // // //     'sexualities': sexualities,
// // // // // // //     'relationship_orientations': relationshipOrientations,
// // // // // // //     'circumcised': circumcised,
// // // // // // //     'piercings': piercings,
// // // // // // //     'body_hair': bodyHair,
// // // // // // //   };
// // // // // // // }
// // // // // // //
// // // // // // // class ProfileFieldOptions {
// // // // // // //   static const Map<String, String> fieldGroupMap = {
// // // // // // //     'bodyType': 'body_types',
// // // // // // //     'ethnic': 'ethnic_backgrounds',
// // // // // // //     'sexuality': 'sexualities',
// // // // // // //     'orientation': 'relationship_orientations',
// // // // // // //     'tattoos': 'tattoos',
// // // // // // //     'piercings': 'piercings',
// // // // // // //     'smoking': 'smoking',
// // // // // // //     'drinking': 'drinking',
// // // // // // //     'bodyHair': 'body_hair',
// // // // // // //     'looks': 'importance_levels',
// // // // // // //     'intelligence': 'importance_levels',
// // // // // // //     'circumcised': 'circumcised',
// // // // // // //
// // // // // // //     'person1_tattoos': 'tattoos',
// // // // // // //     'person2_tattoos': 'tattoos',
// // // // // // //     'person1_height_type': 'height_types',
// // // // // // //     'person2_height_type': 'height_types',
// // // // // // //     'person1_weight_type': 'weight_types',
// // // // // // //     'person2_weight_type': 'weight_types',
// // // // // // //     'person1_body_type': 'body_types',
// // // // // // //     'person2_body_type': 'body_types',
// // // // // // //     'person1_smoking': 'smoking',
// // // // // // //     'person2_smoking': 'smoking',
// // // // // // //     'person1_drinking': 'drinking',
// // // // // // //     'person2_drinking': 'drinking',
// // // // // // //     'person1_ethnic_background': 'ethnic_backgrounds',
// // // // // // //     'person2_ethnic_background': 'ethnic_backgrounds',
// // // // // // //     'person1_looks_important': 'importance_levels',
// // // // // // //     'person2_looks_important': 'importance_levels',
// // // // // // //     'person1_intelligence_importance': 'importance_levels',
// // // // // // //     'person2_intelligence_importance': 'importance_levels',
// // // // // // //     'person1_sexuality': 'sexualities',
// // // // // // //     'person2_sexuality': 'sexualities',
// // // // // // //     'person1_relationship_orientation': 'relationship_orientations',
// // // // // // //     'person2_relationship_orientation': 'relationship_orientations',
// // // // // // //     'person1_circumcised': 'circumcised',
// // // // // // //     'person2_circumcised': 'circumcised',
// // // // // // //     'person1_piercings': 'piercings',
// // // // // // //     'person2_piercings': 'piercings',
// // // // // // //   };
// // // // // // //
// // // // // // //   static List<ProfileOption> getOptionsForField(String fieldName) {
// // // // // // //     final groupKey = fieldGroupMap[fieldName];
// // // // // // //
// // // // // // //     if (groupKey == null) {
// // // // // // //       return [];
// // // // // // //     }
// // // // // // //
// // // // // // //     return ProfileOptions.groups[groupKey] ?? [];
// // // // // // //   }
// // // // // // // }
// // // // // // //
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // // // STATE
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // //
// // // // // // // class ProfileEditState {
// // // // // // //   final bool isProfileDetailsTab;
// // // // // // //   final Map<String, bool> swingersOptions;
// // // // // // //   final Map<String, bool> hookupOptions;
// // // // // // //   final bool isSwingersExpanded;
// // // // // // //   final bool isHookupExpanded;
// // // // // // //   final String aboutMe;
// // // // // // //   final String lookingFor;
// // // // // // //   final Map<String, String> partner1;
// // // // // // //   final Map<String, String> partner2;
// // // // // // //   final List<String> partner1Languages;
// // // // // // //   final List<String> partner2Languages;
// // // // // // //   final bool isLoading;
// // // // // // //   final Map<String, dynamic>? linkedPartner;
// // // // // // //
// // // // // // //   const ProfileEditState({
// // // // // // //     this.isProfileDetailsTab = false,
// // // // // // //     required this.swingersOptions,
// // // // // // //     required this.hookupOptions,
// // // // // // //     this.isSwingersExpanded = true,
// // // // // // //     this.isHookupExpanded = true,
// // // // // // //     this.aboutMe = '',
// // // // // // //     this.lookingFor = '',
// // // // // // //     required this.partner1,
// // // // // // //     required this.partner2,
// // // // // // //     required this.partner1Languages,
// // // // // // //     required this.partner2Languages,
// // // // // // //     this.isLoading = false,
// // // // // // //     this.linkedPartner,
// // // // // // //   });
// // // // // // //
// // // // // // //   ProfileEditState copyWith({
// // // // // // //     bool? isProfileDetailsTab,
// // // // // // //     Map<String, bool>? swingersOptions,
// // // // // // //     Map<String, bool>? hookupOptions,
// // // // // // //     bool? isSwingersExpanded,
// // // // // // //     bool? isHookupExpanded,
// // // // // // //     String? aboutMe,
// // // // // // //     String? lookingFor,
// // // // // // //     Map<String, String>? partner1,
// // // // // // //     Map<String, String>? partner2,
// // // // // // //     List<String>? partner1Languages,
// // // // // // //     List<String>? partner2Languages,
// // // // // // //     bool? isLoading,
// // // // // // //     Map<String, dynamic>? linkedPartner,
// // // // // // //   }) {
// // // // // // //     return ProfileEditState(
// // // // // // //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// // // // // // //       swingersOptions: swingersOptions ?? this.swingersOptions,
// // // // // // //       hookupOptions: hookupOptions ?? this.hookupOptions,
// // // // // // //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// // // // // // //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// // // // // // //       aboutMe: aboutMe ?? this.aboutMe,
// // // // // // //       lookingFor: lookingFor ?? this.lookingFor,
// // // // // // //       partner1: partner1 ?? this.partner1,
// // // // // // //       partner2: partner2 ?? this.partner2,
// // // // // // //       partner1Languages: partner1Languages ?? this.partner1Languages,
// // // // // // //       partner2Languages: partner2Languages ?? this.partner2Languages,
// // // // // // //       isLoading: isLoading ?? this.isLoading,
// // // // // // //       linkedPartner: linkedPartner ?? this.linkedPartner,
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // //
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // // // NOTIFIER
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // //
// // // // // // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // // // // // //   // final ApiServices apiService = ApiServices();
// // // // // // //
// // // // // // //   Map<String, String> _defaultPartnerTraits() {
// // // // // // //     return {
// // // // // // //       'dateOfBirth': '',
// // // // // // //       'height': '',
// // // // // // //       'weight': '',
// // // // // // //
// // // // // // //       'bodyType': ProfileOptions.notComfortableValue,
// // // // // // //       'ethnic': ProfileOptions.notComfortableValue,
// // // // // // //       'sexuality': ProfileOptions.notComfortableValue,
// // // // // // //       'orientation': ProfileOptions.notComfortableValue,
// // // // // // //       'tattoos': ProfileOptions.notComfortableValue,
// // // // // // //       'piercings': ProfileOptions.notComfortableValue,
// // // // // // //       'smoking': ProfileOptions.notComfortableValue,
// // // // // // //       'drinking': ProfileOptions.notComfortableValue,
// // // // // // //       'bodyHair': ProfileOptions.notComfortableValue,
// // // // // // //       'looks': ProfileOptions.notComfortableValue,
// // // // // // //       'intelligence': ProfileOptions.notComfortableValue,
// // // // // // //       'circumcised': ProfileOptions.notComfortableValue,
// // // // // // //     };
// // // // // // //   }
// // // // // // //
// // // // // // //   @override
// // // // // // //   ProfileEditState build() {
// // // // // // //     Future.microtask(() => loadProfile());
// // // // // // //
// // // // // // //     return ProfileEditState(
// // // // // // //       swingersOptions: {
// // // // // // //         'Couple Female/Male': true,
// // // // // // //         'Couple Female/Female': true,
// // // // // // //         'Couple Male/Male': true,
// // // // // // //         'Female': true,
// // // // // // //         'Male': true,
// // // // // // //         'Transgender': true,
// // // // // // //       },
// // // // // // //       hookupOptions: {
// // // // // // //         'Couple Female/Male': true,
// // // // // // //         'Couple Female/Female': true,
// // // // // // //         'Couple Male/Male': true,
// // // // // // //         'Female': true,
// // // // // // //         'Male': true,
// // // // // // //         'Transgender': false,
// // // // // // //       },
// // // // // // //       partner1: _defaultPartnerTraits(),
// // // // // // //       partner2: _defaultPartnerTraits(),
// // // // // // //       partner1Languages: [],
// // // // // // //       partner2Languages: [],
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> loadProfile() async {
// // // // // // //     final token = await AuthService.getToken();
// // // // // // //     if (token == null) return;
// // // // // // //
// // // // // // //     state = state.copyWith(isLoading: true);
// // // // // // //
// // // // // // //     try {
// // // // // // //       final data = await apiServices.getProfile(token: token);
// // // // // // //       final user = data['user'];
// // // // // // //
// // // // // // //       if (user != null) {
// // // // // // //         final mergedTraits = _defaultPartnerTraits();
// // // // // // //         final backendTraits =
// // // // // // //         Map<String, dynamic>.from(user['partner1Traits'] ?? {});
// // // // // // //
// // // // // // //         backendTraits.forEach((key, value) {
// // // // // // //           if (mergedTraits.containsKey(key)) {
// // // // // // //             mergedTraits[key] = value.toString();
// // // // // // //           }
// // // // // // //         });
// // // // // // //
// // // // // // //         final linked = user['partnerId'];
// // // // // // //
// // // // // // //         final Map<String, String> p2Traits = _defaultPartnerTraits();
// // // // // // //         List<String> p2Langs = [];
// // // // // // //
// // // // // // //         if (linked != null) {
// // // // // // //           final lpTraits =
// // // // // // //           Map<String, dynamic>.from(linked['partner1Traits'] ?? {});
// // // // // // //
// // // // // // //           lpTraits.forEach((key, value) {
// // // // // // //             if (p2Traits.containsKey(key)) {
// // // // // // //               p2Traits[key] = value.toString();
// // // // // // //             }
// // // // // // //           });
// // // // // // //
// // // // // // //           p2Langs = List<String>.from(linked['partner1Languages'] ?? []);
// // // // // // //         }
// // // // // // //
// // // // // // //         final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
// // // // // // //         final backendSwingers =
// // // // // // //         Map<String, dynamic>.from(user['swingersOptions'] ?? {});
// // // // // // //
// // // // // // //         backendSwingers.forEach((key, value) {
// // // // // // //           if (mergedSwingers.containsKey(key)) {
// // // // // // //             mergedSwingers[key] = value == true;
// // // // // // //           }
// // // // // // //         });
// // // // // // //
// // // // // // //         final mergedHookup = Map<String, bool>.from(state.hookupOptions);
// // // // // // //         final backendHookup =
// // // // // // //         Map<String, dynamic>.from(user['hookupOptions'] ?? {});
// // // // // // //
// // // // // // //         backendHookup.forEach((key, value) {
// // // // // // //           if (mergedHookup.containsKey(key)) {
// // // // // // //             mergedHookup[key] = value == true;
// // // // // // //           }
// // // // // // //         });
// // // // // // //
// // // // // // //         state = state.copyWith(
// // // // // // //           aboutMe: user['aboutMe'] ?? '',
// // // // // // //           lookingFor: user['lookingFor'] ?? '',
// // // // // // //           partner1: mergedTraits,
// // // // // // //           partner1Languages:
// // // // // // //           List<String>.from(user['partner1Languages'] ?? []),
// // // // // // //           swingersOptions: mergedSwingers,
// // // // // // //           hookupOptions: mergedHookup,
// // // // // // //           partner2: p2Traits,
// // // // // // //           partner2Languages: p2Langs,
// // // // // // //           linkedPartner: linked is Map<String, dynamic> ? linked : null,
// // // // // // //         );
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint('Error loading profile: $e');
// // // // // // //     } finally {
// // // // // // //       state = state.copyWith(isLoading: false);
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> saveProfile() async {
// // // // // // //     final token = await AuthService.getToken();
// // // // // // //     if (token == null) return;
// // // // // // //
// // // // // // //     state = state.copyWith(isLoading: true);
// // // // // // //
// // // // // // //     try {
// // // // // // //       final updates = {
// // // // // // //         'aboutMe': state.aboutMe,
// // // // // // //         'lookingFor': state.lookingFor,
// // // // // // //         'partner1Traits': state.partner1,
// // // // // // //         'partner1Languages': state.partner1Languages,
// // // // // // //         'swingersOptions': state.swingersOptions,
// // // // // // //         'hookupOptions': state.hookupOptions,
// // // // // // //       };
// // // // // // //
// // // // // // //       await apiServices.updateProfile(token: token, updates: updates);
// // // // // // //
// // // // // // //       Get.snackbar(
// // // // // // //         'Success',
// // // // // // //         'Profile updated successfully',
// // // // // // //         snackPosition: SnackPosition.TOP,
// // // // // // //         backgroundColor: Colors.green,
// // // // // // //         colorText: Colors.white,
// // // // // // //       );
// // // // // // //     } catch (e) {
// // // // // // //       Get.snackbar(
// // // // // // //         'Error',
// // // // // // //         'Failed to update profile: $e',
// // // // // // //         snackPosition: SnackPosition.TOP,
// // // // // // //         backgroundColor: Colors.red,
// // // // // // //         colorText: Colors.white,
// // // // // // //       );
// // // // // // //     } finally {
// // // // // // //       state = state.copyWith(isLoading: false);
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   void toggleProfileTab(bool isProfile) {
// // // // // // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // // // // // //   }
// // // // // // //
// // // // // // //   void toggleSwingersExpanded() {
// // // // // // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // // // // // //   }
// // // // // // //
// // // // // // //   void toggleHookupExpanded() {
// // // // // // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // // // // // //   }
// // // // // // //
// // // // // // //   void updateSwingersOption(String label, bool value) {
// // // // // // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // // // // // //     newOptions[label] = value;
// // // // // // //     state = state.copyWith(swingersOptions: newOptions);
// // // // // // //   }
// // // // // // //
// // // // // // //   void updateHookupOption(String label, bool value) {
// // // // // // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // // // // // //     newOptions[label] = value;
// // // // // // //     state = state.copyWith(hookupOptions: newOptions);
// // // // // // //   }
// // // // // // //
// // // // // // //   void updateAboutMe(String value) {
// // // // // // //     state = state.copyWith(aboutMe: value);
// // // // // // //   }
// // // // // // //
// // // // // // //   void updateLookingFor(String value) {
// // // // // // //     state = state.copyWith(lookingFor: value);
// // // // // // //   }
// // // // // // //
// // // // // // //   void updatePartner1(String key, String value) {
// // // // // // //     final newPartner = Map<String, String>.from(state.partner1);
// // // // // // //     newPartner[key] = value;
// // // // // // //     state = state.copyWith(partner1: newPartner);
// // // // // // //   }
// // // // // // //
// // // // // // //   void updatePartner2(String key, String value) {
// // // // // // //     final newPartner = Map<String, String>.from(state.partner2);
// // // // // // //     newPartner[key] = value;
// // // // // // //     state = state.copyWith(partner2: newPartner);
// // // // // // //   }
// // // // // // //
// // // // // // //   void updatePartner1Languages(List<String> langs) {
// // // // // // //     state = state.copyWith(partner1Languages: langs);
// // // // // // //   }
// // // // // // //
// // // // // // //   void updatePartner2Languages(List<String> langs) {
// // // // // // //     state = state.copyWith(partner2Languages: langs);
// // // // // // //   }
// // // // // // // }
// // // // // // //
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // // // PROVIDER
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // //
// // // // // // // final profileEditProvider =
// // // // // // // NotifierProvider<ProfileEditNotifier, ProfileEditState>(
// // // // // // //   ProfileEditNotifier.new,
// // // // // // // );
// // // // // // //
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // // // WIDGET
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // //
// // // // // // // class MyProfileEditTab extends ConsumerWidget {
// // // // // // //   const MyProfileEditTab({super.key});
// // // // // // //
// // // // // // //   static const List<String> languageOptions = [
// // // // // // //     'English',
// // // // // // //     'Hindi',
// // // // // // //     'German',
// // // // // // //     'French',
// // // // // // //     'Spanish',
// // // // // // //   ];
// // // // // // //   Widget dateOfBirthField({
// // // // // // //     required BuildContext context,
// // // // // // //     required String label,
// // // // // // //     required Map<String, String> data,
// // // // // // //     required String keyName,
// // // // // // //     required void Function(String, String) onFieldChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //   }) {
// // // // // // //     final currentValue = data[keyName] ?? '';
// // // // // // //     final displayValue = currentValue.trim().isEmpty ? 'dd/mm/yyyy' : currentValue;
// // // // // // //
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           textFieldLabel(label),
// // // // // // //           const SizedBox(height: 4),
// // // // // // //           InkWell(
// // // // // // //             onTap: readOnly
// // // // // // //                 ? null
// // // // // // //                 : () async {
// // // // // // //               final now = DateTime.now();
// // // // // // //               final parsedDate = parseProfileDate(currentValue);
// // // // // // //
// // // // // // //               final pickedDate = await showDatePicker(
// // // // // // //                 context: context,
// // // // // // //                 initialDate: parsedDate ?? DateTime(now.year - 18, now.month, now.day),
// // // // // // //                 firstDate: DateTime(1900),
// // // // // // //                 lastDate: now,
// // // // // // //               );
// // // // // // //
// // // // // // //               if (pickedDate == null) return;
// // // // // // //
// // // // // // //               onFieldChanged(keyName, formatProfileDate(pickedDate));
// // // // // // //             },
// // // // // // //             borderRadius: BorderRadius.circular(8),
// // // // // // //             child: Container(
// // // // // // //               height: 42,
// // // // // // //               width: double.infinity,
// // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // //                 border: Border.all(
// // // // // // //                   color: readOnly
// // // // // // //                       ? const Color(0xFFF2F2F2)
// // // // // // //                       : const Color(0xFFE8E0F2),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               child: Row(
// // // // // // //                 children: [
// // // // // // //                   Expanded(
// // // // // // //                     child: Text(
// // // // // // //                       displayValue,
// // // // // // //                       maxLines: 1,
// // // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // // //                       style: TextStyle(
// // // // // // //                         fontSize: 12,
// // // // // // //                         color: currentValue.trim().isEmpty
// // // // // // //                             ? Colors.grey[600]
// // // // // // //                             : Colors.black87,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   const Icon(
// // // // // // //                     Icons.calendar_today_outlined,
// // // // // // //                     size: 17,
// // // // // // //                     color: Colors.black87,
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget heightInputField({
// // // // // // //     required Map<String, String> data,
// // // // // // //     required void Function(String, String) onFieldChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //   }) {
// // // // // // //     final selectedType = (data['heightType'] ?? '').trim().isEmpty
// // // // // // //         ? null
// // // // // // //         : data['heightType'];
// // // // // // //
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           textFieldLabel('HEIGHT'),
// // // // // // //           const SizedBox(height: 2),
// // // // // // //           Row(
// // // // // // //             children: [
// // // // // // //               unitRadioButton(
// // // // // // //                 label: 'FT',
// // // // // // //                 value: 'FT',
// // // // // // //                 groupValue: selectedType,
// // // // // // //                 readOnly: readOnly,
// // // // // // //                 onChanged: (value) => onFieldChanged('heightType', value),
// // // // // // //               ),
// // // // // // //               const SizedBox(width: 18),
// // // // // // //               unitRadioButton(
// // // // // // //                 label: 'CM',
// // // // // // //                 value: 'CM',
// // // // // // //                 groupValue: selectedType,
// // // // // // //                 readOnly: readOnly,
// // // // // // //                 onChanged: (value) => onFieldChanged('heightType', value),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 4),
// // // // // // //           TextFormField(
// // // // // // //             key: ValueKey('height-${data['height'] ?? ''}-$readOnly'),
// // // // // // //             initialValue: data['height'] ?? '',
// // // // // // //             readOnly: readOnly,
// // // // // // //             onChanged: readOnly
// // // // // // //                 ? null
// // // // // // //                 : (value) {
// // // // // // //               onFieldChanged('height', value);
// // // // // // //             },
// // // // // // //             keyboardType: TextInputType.text,
// // // // // // //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// // // // // // //             decoration: profileInputDecoration(
// // // // // // //               hintText: "Ex. (5'7 OR 170)",
// // // // // // //               readOnly: readOnly,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget weightInputField({
// // // // // // //     required Map<String, String> data,
// // // // // // //     required void Function(String, String) onFieldChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //   }) {
// // // // // // //     final selectedType = (data['weightType'] ?? '').trim().isEmpty
// // // // // // //         ? null
// // // // // // //         : data['weightType'];
// // // // // // //
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           textFieldLabel('WEIGHT'),
// // // // // // //           const SizedBox(height: 2),
// // // // // // //           Row(
// // // // // // //             children: [
// // // // // // //               unitRadioButton(
// // // // // // //                 label: 'LBS',
// // // // // // //                 value: 'LBS',
// // // // // // //                 groupValue: selectedType,
// // // // // // //                 readOnly: readOnly,
// // // // // // //                 onChanged: (value) => onFieldChanged('weightType', value),
// // // // // // //               ),
// // // // // // //               const SizedBox(width: 18),
// // // // // // //               unitRadioButton(
// // // // // // //                 label: 'KG',
// // // // // // //                 value: 'KG',
// // // // // // //                 groupValue: selectedType,
// // // // // // //                 readOnly: readOnly,
// // // // // // //                 onChanged: (value) => onFieldChanged('weightType', value),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 4),
// // // // // // //           TextFormField(
// // // // // // //             key: ValueKey('weight-${data['weight'] ?? ''}-$readOnly'),
// // // // // // //             initialValue: data['weight'] ?? '',
// // // // // // //             readOnly: readOnly,
// // // // // // //             onChanged: readOnly
// // // // // // //                 ? null
// // // // // // //                 : (value) {
// // // // // // //               onFieldChanged('weight', value);
// // // // // // //             },
// // // // // // //             keyboardType: TextInputType.number,
// // // // // // //             style: const TextStyle(fontSize: 12, color: Colors.black87),
// // // // // // //             decoration: profileInputDecoration(
// // // // // // //               hintText: 'Ex. (150 LBS OR 68 KG)',
// // // // // // //               readOnly: readOnly,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget unitRadioButton({
// // // // // // //     required String label,
// // // // // // //     required String value,
// // // // // // //     required String? groupValue,
// // // // // // //     required void Function(String) onChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //   }) {
// // // // // // //     return InkWell(
// // // // // // //       onTap: readOnly ? null : () => onChanged(value),
// // // // // // //       borderRadius: BorderRadius.circular(8),
// // // // // // //       child: Row(
// // // // // // //         mainAxisSize: MainAxisSize.min,
// // // // // // //         children: [
// // // // // // //           Radio<String>(
// // // // // // //             value: value,
// // // // // // //             groupValue: groupValue,
// // // // // // //             onChanged: readOnly
// // // // // // //                 ? null
// // // // // // //                 : (selectedValue) {
// // // // // // //               if (selectedValue == null) return;
// // // // // // //               onChanged(selectedValue);
// // // // // // //             },
// // // // // // //             activeColor: const Color(0xFF5A002B),
// // // // // // //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // // // // // //             visualDensity: VisualDensity.compact,
// // // // // // //           ),
// // // // // // //           Text(
// // // // // // //             label,
// // // // // // //             style: const TextStyle(
// // // // // // //               fontSize: 12,
// // // // // // //               fontWeight: FontWeight.w800,
// // // // // // //               color: Color(0xFF5A002B),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   InputDecoration profileInputDecoration({
// // // // // // //     required String hintText,
// // // // // // //     bool readOnly = false,
// // // // // // //   }) {
// // // // // // //     return InputDecoration(
// // // // // // //       hintText: hintText,
// // // // // // //       hintStyle: TextStyle(
// // // // // // //         color: Colors.grey[600],
// // // // // // //         fontSize: 12,
// // // // // // //       ),
// // // // // // //       isDense: true,
// // // // // // //       contentPadding: const EdgeInsets.symmetric(
// // // // // // //         horizontal: 10,
// // // // // // //         vertical: 12,
// // // // // // //       ),
// // // // // // //       border: OutlineInputBorder(
// // // // // // //         borderRadius: BorderRadius.circular(8),
// // // // // // //         borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // //       ),
// // // // // // //       enabledBorder: OutlineInputBorder(
// // // // // // //         borderRadius: BorderRadius.circular(8),
// // // // // // //         borderSide: BorderSide(
// // // // // // //           color: readOnly
// // // // // // //               ? const Color(0xFFF2F2F2)
// // // // // // //               : const Color(0xFFE8E0F2),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       focusedBorder: OutlineInputBorder(
// // // // // // //         borderRadius: BorderRadius.circular(8),
// // // // // // //         borderSide: const BorderSide(color: Color(0xFF5A002B)),
// // // // // // //       ),
// // // // // // //       fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // // // //       filled: true,
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   DateTime? parseProfileDate(String? value) {
// // // // // // //     if (value == null || value.trim().isEmpty) return null;
// // // // // // //
// // // // // // //     final text = value.trim();
// // // // // // //
// // // // // // //     final dmyMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);
// // // // // // //     if (dmyMatch != null) {
// // // // // // //       final day = int.tryParse(dmyMatch.group(1)!);
// // // // // // //       final month = int.tryParse(dmyMatch.group(2)!);
// // // // // // //       final year = int.tryParse(dmyMatch.group(3)!);
// // // // // // //
// // // // // // //       if (day != null && month != null && year != null) {
// // // // // // //         return DateTime(year, month, day);
// // // // // // //       }
// // // // // // //     }
// // // // // // //
// // // // // // //     final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
// // // // // // //     if (isoMatch != null) {
// // // // // // //       final year = int.tryParse(isoMatch.group(1)!);
// // // // // // //       final month = int.tryParse(isoMatch.group(2)!);
// // // // // // //       final day = int.tryParse(isoMatch.group(3)!);
// // // // // // //
// // // // // // //       if (day != null && month != null && year != null) {
// // // // // // //         return DateTime(year, month, day);
// // // // // // //       }
// // // // // // //     }
// // // // // // //
// // // // // // //     return DateTime.tryParse(text);
// // // // // // //   }
// // // // // // //
// // // // // // //   String formatProfileDate(DateTime date) {
// // // // // // //     final day = date.day.toString().padLeft(2, '0');
// // // // // // //     final month = date.month.toString().padLeft(2, '0');
// // // // // // //     final year = date.year.toString();
// // // // // // //
// // // // // // //     return '$day/$month/$year';
// // // // // // //   }
// // // // // // //
// // // // // // //   void saveInterests() {
// // // // // // //     Get.snackbar(
// // // // // // //       'Success',
// // // // // // //       'Interests saved successfully',
// // // // // // //       snackPosition: SnackPosition.TOP,
// // // // // // //       backgroundColor: Colors.transparent,
// // // // // // //       colorText: Colors.white,
// // // // // // //       margin: const EdgeInsets.all(12),
// // // // // // //       borderRadius: 10,
// // // // // // //       duration: const Duration(seconds: 2),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // // //     final profileState = ref.watch(profileEditProvider);
// // // // // // //     final notifier = ref.read(profileEditProvider.notifier);
// // // // // // //
// // // // // // //     return LayoutBuilder(
// // // // // // //       builder: (context, constraints) {
// // // // // // //         final double width = constraints.maxWidth;
// // // // // // //         final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
// // // // // // //         final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;
// // // // // // //
// // // // // // //         return Container(
// // // // // // //           width: double.infinity,
// // // // // // //           constraints: BoxConstraints(
// // // // // // //             minHeight: MediaQuery.of(context).size.height * 0.62,
// // // // // // //           ),
// // // // // // //           padding: const EdgeInsets.all(16),
// // // // // // //           decoration: BoxDecoration(
// // // // // // //             color: Colors.white,
// // // // // // //             borderRadius: BorderRadius.circular(14),
// // // // // // //             border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // // // //           ),
// // // // // // //           child: Column(
// // // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //             children: [
// // // // // // //               if (profileState.isLoading)
// // // // // // //                 const Padding(
// // // // // // //                   padding: EdgeInsets.only(bottom: 10),
// // // // // // //                   child: LinearProgressIndicator(color: Colors.pink),
// // // // // // //                 ),
// // // // // // //               sectionHeader(profileState, notifier),
// // // // // // //               const SizedBox(height: 16),
// // // // // // //               if (profileState.isProfileDetailsTab)
// // // // // // //                 buildProfileDetailsContent(
// // // // // // //                   context,
// // // // // // //                   width,
// // // // // // //                   profileState,
// // // // // // //                   notifier,
// // // // // // //                 )
// // // // // // //               else
// // // // // // //                 buildInterestsContent(
// // // // // // //                   optionWidth,
// // // // // // //                   profileState,
// // // // // // //                   notifier,
// // // // // // //                 ),
// // // // // // //               const SizedBox(height: 18),
// // // // // // //               Center(
// // // // // // //                 child: SizedBox(
// // // // // // //                   width: 170,
// // // // // // //                   child: ElevatedButton(
// // // // // // //                     onPressed: profileState.isLoading
// // // // // // //                         ? null
// // // // // // //                         : () => notifier.saveProfile(),
// // // // // // //                     style: ElevatedButton.styleFrom(
// // // // // // //                       elevation: 4,
// // // // // // //                       padding: const EdgeInsets.symmetric(vertical: 12),
// // // // // // //                       backgroundColor: const Color(0xFF220027),
// // // // // // //                       foregroundColor: Colors.white,
// // // // // // //                       shape: RoundedRectangleBorder(
// // // // // // //                         borderRadius: BorderRadius.circular(22),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     child: profileState.isLoading
// // // // // // //                         ? const SizedBox(
// // // // // // //                       height: 20,
// // // // // // //                       width: 20,
// // // // // // //                       child: CircularProgressIndicator(
// // // // // // //                         color: Colors.white,
// // // // // // //                         strokeWidth: 2,
// // // // // // //                       ),
// // // // // // //                     )
// // // // // // //                         : Text(
// // // // // // //                       profileState.isProfileDetailsTab
// // // // // // //                           ? 'Save Profile'
// // // // // // //                           : 'Save Interest',
// // // // // // //                       style: const TextStyle(
// // // // // // //                         fontWeight: FontWeight.w700,
// // // // // // //                         fontSize: 12,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const SizedBox(height: 6),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         );
// // // // // // //       },
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
// // // // // // //     return Container(
// // // // // // //       height: 38,
// // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         gradient: const LinearGradient(
// // // // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // // //         ),
// // // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // // //       ),
// // // // // // //       child: Row(
// // // // // // //         children: [
// // // // // // //           InkWell(
// // // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // // //             onTap: () => notifier.toggleProfileTab(false),
// // // // // // //             child: Container(
// // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 color: !state.isProfileDetailsTab
// // // // // // //                     ? const Color(0xFFFF2D87)
// // // // // // //                     : Colors.transparent,
// // // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // // //               ),
// // // // // // //               child: const Text(
// // // // // // //                 'INTERESTS',
// // // // // // //                 style: TextStyle(
// // // // // // //                   color: Colors.white,
// // // // // // //                   fontSize: 11,
// // // // // // //                   fontWeight: FontWeight.w700,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           const Spacer(),
// // // // // // //           InkWell(
// // // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // // //             onTap: () => notifier.toggleProfileTab(true),
// // // // // // //             child: Container(
// // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 color: state.isProfileDetailsTab
// // // // // // //                     ? const Color(0xFFFF2D87)
// // // // // // //                     : Colors.transparent,
// // // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // // //               ),
// // // // // // //               child: const Text(
// // // // // // //                 'PROFILE DETAILS',
// // // // // // //                 style: TextStyle(
// // // // // // //                   color: Colors.white,
// // // // // // //                   fontSize: 12,
// // // // // // //                   fontWeight: FontWeight.w700,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget buildInterestsContent(
// // // // // // //       double optionWidth,
// // // // // // //       ProfileEditState state,
// // // // // // //       ProfileEditNotifier notifier,
// // // // // // //       ) {
// // // // // // //     return Column(
// // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //       children: [
// // // // // // //         const Text(
// // // // // // //           'davidbrown',
// // // // // // //           style: TextStyle(
// // // // // // //             fontWeight: FontWeight.w700,
// // // // // // //             fontSize: 34,
// // // // // // //             height: 1.05,
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 8),
// // // // // // //         Text(
// // // // // // //           'What are you looking for? *Select all that apply',
// // // // // // //           style: TextStyle(
// // // // // // //             color: Colors.grey[700],
// // // // // // //             fontSize: 14,
// // // // // // //             fontWeight: FontWeight.w500,
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 16),
// // // // // // //         interestGroup(
// // // // // // //           title: 'Swingers',
// // // // // // //           expanded: state.isSwingersExpanded,
// // // // // // //           onToggle: notifier.toggleSwingersExpanded,
// // // // // // //           options: state.swingersOptions,
// // // // // // //           optionWidth: optionWidth,
// // // // // // //           onChanged: (label, value) =>
// // // // // // //               notifier.updateSwingersOption(label, value),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 12),
// // // // // // //         interestGroup(
// // // // // // //           title: 'Hookup / Meetup',
// // // // // // //           expanded: state.isHookupExpanded,
// // // // // // //           onToggle: notifier.toggleHookupExpanded,
// // // // // // //           options: state.hookupOptions,
// // // // // // //           optionWidth: optionWidth,
// // // // // // //           onChanged: (label, value) => notifier.updateHookupOption(label, value),
// // // // // // //         ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget buildProfileDetailsContent(
// // // // // // //       BuildContext context,
// // // // // // //       double width,
// // // // // // //       ProfileEditState state,
// // // // // // //       ProfileEditNotifier notifier,
// // // // // // //       ) {
// // // // // // //     final bool stacked = width < 760;
// // // // // // //
// // // // // // //     return Column(
// // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //       children: [
// // // // // // //         textFieldLabel('INTRODUCE YOURSELF*'),
// // // // // // //         const SizedBox(height: 6),
// // // // // // //         simpleTextField(
// // // // // // //           label: 'About Me',
// // // // // // //           initialValue: state.aboutMe,
// // // // // // //           onChanged: notifier.updateAboutMe,
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 10),
// // // // // // //         textFieldLabel('LOOKING FOR'),
// // // // // // //         const SizedBox(height: 6),
// // // // // // //         simpleTextField(
// // // // // // //           label: 'Looking For',
// // // // // // //           initialValue: state.lookingFor,
// // // // // // //           maxLines: 2,
// // // // // // //           onChanged: notifier.updateLookingFor,
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 14),
// // // // // // //         const Center(
// // // // // // //           child: Text(
// // // // // // //             'About Yourselves',
// // // // // // //             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 12),
// // // // // // //         if (stacked)
// // // // // // //           Column(
// // // // // // //             children: [
// // // // // // //               partnerPanel(
// // // // // // //                 context: context,
// // // // // // //                 title: 'Partner 1',
// // // // // // //                 data: state.partner1,
// // // // // // //                 languages: state.partner1Languages,
// // // // // // //                 onFieldChanged: notifier.updatePartner1,
// // // // // // //                 onLanguagesChanged: notifier.updatePartner1Languages,
// // // // // // //               ),
// // // // // // //               const SizedBox(height: 12),
// // // // // // //               partnerPanel(
// // // // // // //                 context: context,
// // // // // // //                 title: 'Partner 2',
// // // // // // //                 data: state.partner2,
// // // // // // //                 languages: state.partner2Languages,
// // // // // // //                 onFieldChanged: notifier.updatePartner2,
// // // // // // //                 onLanguagesChanged: notifier.updatePartner2Languages,
// // // // // // //                 readOnly: true,
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           )
// // // // // // //         else
// // // // // // //           Row(
// // // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //             children: [
// // // // // // //               Expanded(
// // // // // // //                 child: partnerPanel(
// // // // // // //                   context: context,
// // // // // // //                   title: 'Partner 1',
// // // // // // //                   data: state.partner1,
// // // // // // //                   languages: state.partner1Languages,
// // // // // // //                   onFieldChanged: notifier.updatePartner1,
// // // // // // //                   onLanguagesChanged: notifier.updatePartner1Languages,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const SizedBox(width: 12),
// // // // // // //               Expanded(
// // // // // // //                 child: partnerPanel(
// // // // // // //                   context: context,
// // // // // // //                   title: 'Partner 2',
// // // // // // //                   data: state.partner2,
// // // // // // //                   languages: state.partner2Languages,
// // // // // // //                   onFieldChanged: notifier.updatePartner2,
// // // // // // //                   onLanguagesChanged: notifier.updatePartner2Languages,
// // // // // // //                   readOnly: true,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget partnerPanel({
// // // // // // //     required BuildContext context,
// // // // // // //     required String title,
// // // // // // //     required Map<String, String> data,
// // // // // // //     required List<String> languages,
// // // // // // //     required void Function(String, String) onFieldChanged,
// // // // // // //     required void Function(List<String>) onLanguagesChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //   }) {
// // // // // // //     return Column(
// // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //       children: [
// // // // // // //         Container(
// // // // // // //           height: 34,
// // // // // // //           alignment: Alignment.center,
// // // // // // //           decoration: BoxDecoration(
// // // // // // //             gradient: const LinearGradient(
// // // // // // //               colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // // //             ),
// // // // // // //             borderRadius: BorderRadius.circular(10),
// // // // // // //           ),
// // // // // // //           child: Text(
// // // // // // //             title,
// // // // // // //             style: const TextStyle(
// // // // // // //               color: Colors.white,
// // // // // // //               fontWeight: FontWeight.w700,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 10),
// // // // // // //
// // // // // // //         // dropdownField(
// // // // // // //         //   'DATE OF BIRTH',
// // // // // // //         //   data,
// // // // // // //         //   'dateOfBirth',
// // // // // // //         //   const [
// // // // // // //         //     '17/06/2004',
// // // // // // //         //     '03/12/2007',
// // // // // // //         //   ],
// // // // // // //         //   onFieldChanged,
// // // // // // //         //   readOnly: readOnly,
// // // // // // //         // ),
// // // // // // //         //
// // // // // // //         // dropdownField(
// // // // // // //         //   'HEIGHT',
// // // // // // //         //   data,
// // // // // // //         //   'height',
// // // // // // //         //   const [
// // // // // // //         //     "4'6",
// // // // // // //         //     "5'0",
// // // // // // //         //     "5'7",
// // // // // // //         //     "6'0",
// // // // // // //         //   ],
// // // // // // //         //   onFieldChanged,
// // // // // // //         //   readOnly: readOnly,
// // // // // // //         // ),
// // // // // // //         //
// // // // // // //         // dropdownField(
// // // // // // //         //   'WEIGHT',
// // // // // // //         //   data,
// // // // // // //         //   'weight',
// // // // // // //         //   const [
// // // // // // //         //     '55',
// // // // // // //         //     '60',
// // // // // // //         //     '65',
// // // // // // //         //     '70',
// // // // // // //         //   ],
// // // // // // //         //   onFieldChanged,
// // // // // // //         //   readOnly: readOnly,
// // // // // // //         // ),
// // // // // // //         Widget dateOfBirthField({
// // // // // // //     required BuildContext context,
// // // // // // //     required String label,
// // // // // // //     required Map<String, String> data,
// // // // // // //     required String keyName,
// // // // // // //     required void Function(String, String) onFieldChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //     }) {
// // // // // // //     final currentValue = data[keyName] ?? '';
// // // // // // //     final displayValue = currentValue.trim().isEmpty ? 'dd/mm/yyyy' : currentValue;
// // // // // // //
// // // // // // //     return Padding(
// // // // // // //     padding: const EdgeInsets.only(bottom: 8),
// // // // // // //     child: Column(
// // // // // // //     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //     children: [
// // // // // // //     textFieldLabel(label),
// // // // // // //     const SizedBox(height: 4),
// // // // // // //     InkWell(
// // // // // // //     onTap: readOnly
// // // // // // //     ? null
// // // // // // //         : () async {
// // // // // // //     final now = DateTime.now();
// // // // // // //     final parsedDate = parseProfileDate(currentValue);
// // // // // // //
// // // // // // //     final pickedDate = await showDatePicker(
// // // // // // //     context: context,
// // // // // // //     initialDate: parsedDate ?? DateTime(now.year - 18, now.month, now.day),
// // // // // // //     firstDate: DateTime(1900),
// // // // // // //     lastDate: now,
// // // // // // //     );
// // // // // // //
// // // // // // //     if (pickedDate == null) return;
// // // // // // //
// // // // // // //     onFieldChanged(keyName, formatProfileDate(pickedDate));
// // // // // // //     },
// // // // // // //     borderRadius: BorderRadius.circular(8),
// // // // // // //     child: Container(
// // // // // // //     height: 42,
// // // // // // //     width: double.infinity,
// // // // // // //     padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // // // //     decoration: BoxDecoration(
// // // // // // //     color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // // // //     borderRadius: BorderRadius.circular(8),
// // // // // // //     border: Border.all(
// // // // // // //     color: readOnly
// // // // // // //     ? const Color(0xFFF2F2F2)
// // // // // // //         : const Color(0xFFE8E0F2),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     child: Row(
// // // // // // //     children: [
// // // // // // //     Expanded(
// // // // // // //     child: Text(
// // // // // // //     displayValue,
// // // // // // //     maxLines: 1,
// // // // // // //     overflow: TextOverflow.ellipsis,
// // // // // // //     style: TextStyle(
// // // // // // //     fontSize: 12,
// // // // // // //     color: currentValue.trim().isEmpty
// // // // // // //     ? Colors.grey[600]
// // // // // // //         : Colors.black87,
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     const Icon(
// // // // // // //     Icons.calendar_today_outlined,
// // // // // // //     size: 17,
// // // // // // //     color: Colors.black87,
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     );
// // // // // // //     }
// // // // // // //
// // // // // // //     Widget heightInputField({
// // // // // // //     required Map<String, String> data,
// // // // // // //     required void Function(String, String) onFieldChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //     }) {
// // // // // // //     final selectedType = (data['heightType'] ?? '').trim().isEmpty
// // // // // // //     ? null
// // // // // // //         : data['heightType'];
// // // // // // //
// // // // // // //     return Padding(
// // // // // // //     padding: const EdgeInsets.only(bottom: 8),
// // // // // // //     child: Column(
// // // // // // //     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //     children: [
// // // // // // //     textFieldLabel('HEIGHT'),
// // // // // // //     const SizedBox(height: 2),
// // // // // // //     Row(
// // // // // // //     children: [
// // // // // // //     unitRadioButton(
// // // // // // //     label: 'FT',
// // // // // // //     value: 'FT',
// // // // // // //     groupValue: selectedType,
// // // // // // //     readOnly: readOnly,
// // // // // // //     onChanged: (value) => onFieldChanged('heightType', value),
// // // // // // //     ),
// // // // // // //     const SizedBox(width: 18),
// // // // // // //     unitRadioButton(
// // // // // // //     label: 'CM',
// // // // // // //     value: 'CM',
// // // // // // //     groupValue: selectedType,
// // // // // // //     readOnly: readOnly,
// // // // // // //     onChanged: (value) => onFieldChanged('heightType', value),
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     const SizedBox(height: 4),
// // // // // // //     TextFormField(
// // // // // // //     key: ValueKey('height-${data['height'] ?? ''}-$readOnly'),
// // // // // // //     initialValue: data['height'] ?? '',
// // // // // // //     readOnly: readOnly,
// // // // // // //     onChanged: readOnly
// // // // // // //     ? null
// // // // // // //         : (value) {
// // // // // // //     onFieldChanged('height', value);
// // // // // // //     },
// // // // // // //     keyboardType: TextInputType.text,
// // // // // // //     style: const TextStyle(fontSize: 12, color: Colors.black87),
// // // // // // //     decoration: profileInputDecoration(
// // // // // // //     hintText: "Ex. (5'7 OR 170)",
// // // // // // //     readOnly: readOnly,
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     );
// // // // // // //     }
// // // // // // //
// // // // // // //     Widget weightInputField({
// // // // // // //     required Map<String, String> data,
// // // // // // //     required void Function(String, String) onFieldChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //     }) {
// // // // // // //     final selectedType = (data['weightType'] ?? '').trim().isEmpty
// // // // // // //     ? null
// // // // // // //         : data['weightType'];
// // // // // // //
// // // // // // //     return Padding(
// // // // // // //     padding: const EdgeInsets.only(bottom: 8),
// // // // // // //     child: Column(
// // // // // // //     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //     children: [
// // // // // // //     textFieldLabel('WEIGHT'),
// // // // // // //     const SizedBox(height: 2),
// // // // // // //     Row(
// // // // // // //     children: [
// // // // // // //     unitRadioButton(
// // // // // // //     label: 'LBS',
// // // // // // //     value: 'LBS',
// // // // // // //     groupValue: selectedType,
// // // // // // //     readOnly: readOnly,
// // // // // // //     onChanged: (value) => onFieldChanged('weightType', value),
// // // // // // //     ),
// // // // // // //     const SizedBox(width: 18),
// // // // // // //     unitRadioButton(
// // // // // // //     label: 'KG',
// // // // // // //     value: 'KG',
// // // // // // //     groupValue: selectedType,
// // // // // // //     readOnly: readOnly,
// // // // // // //     onChanged: (value) => onFieldChanged('weightType', value),
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     const SizedBox(height: 4),
// // // // // // //     TextFormField(
// // // // // // //     key: ValueKey('weight-${data['weight'] ?? ''}-$readOnly'),
// // // // // // //     initialValue: data['weight'] ?? '',
// // // // // // //     readOnly: readOnly,
// // // // // // //     onChanged: readOnly
// // // // // // //     ? null
// // // // // // //         : (value) {
// // // // // // //     onFieldChanged('weight', value);
// // // // // // //     },
// // // // // // //     keyboardType: TextInputType.number,
// // // // // // //     style: const TextStyle(fontSize: 12, color: Colors.black87),
// // // // // // //     decoration: profileInputDecoration(
// // // // // // //     hintText: 'Ex. (150 LBS OR 68 KG)',
// // // // // // //     readOnly: readOnly,
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     );
// // // // // // //     }
// // // // // // //
// // // // // // //     Widget unitRadioButton({
// // // // // // //     required String label,
// // // // // // //     required String value,
// // // // // // //     required String? groupValue,
// // // // // // //     required void Function(String) onChanged,
// // // // // // //     bool readOnly = false,
// // // // // // //     }) {
// // // // // // //     return InkWell(
// // // // // // //     onTap: readOnly ? null : () => onChanged(value),
// // // // // // //     borderRadius: BorderRadius.circular(8),
// // // // // // //     child: Row(
// // // // // // //     mainAxisSize: MainAxisSize.min,
// // // // // // //     children: [
// // // // // // //     Radio<String>(
// // // // // // //     value: value,
// // // // // // //     groupValue: groupValue,
// // // // // // //     onChanged: readOnly
// // // // // // //     ? null
// // // // // // //         : (selectedValue) {
// // // // // // //     if (selectedValue == null) return;
// // // // // // //     onChanged(selectedValue);
// // // // // // //     },
// // // // // // //     activeColor: const Color(0xFF5A002B),
// // // // // // //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // // // // // //     visualDensity: VisualDensity.compact,
// // // // // // //     ),
// // // // // // //     Text(
// // // // // // //     label,
// // // // // // //     style: const TextStyle(
// // // // // // //     fontSize: 12,
// // // // // // //     fontWeight: FontWeight.w800,
// // // // // // //     color: Color(0xFF5A002B),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     );
// // // // // // //     }
// // // // // // //
// // // // // // //     InputDecoration profileInputDecoration({
// // // // // // //     required String hintText,
// // // // // // //     bool readOnly = false,
// // // // // // //     }) {
// // // // // // //     return InputDecoration(
// // // // // // //     hintText: hintText,
// // // // // // //     hintStyle: TextStyle(
// // // // // // //     color: Colors.grey[600],
// // // // // // //     fontSize: 12,
// // // // // // //     ),
// // // // // // //     isDense: true,
// // // // // // //     contentPadding: const EdgeInsets.symmetric(
// // // // // // //     horizontal: 10,
// // // // // // //     vertical: 12,
// // // // // // //     ),
// // // // // // //     border: OutlineInputBorder(
// // // // // // //     borderRadius: BorderRadius.circular(8),
// // // // // // //     borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // //     ),
// // // // // // //     enabledBorder: OutlineInputBorder(
// // // // // // //     borderRadius: BorderRadius.circular(8),
// // // // // // //     borderSide: BorderSide(
// // // // // // //     color: readOnly
// // // // // // //     ? const Color(0xFFF2F2F2)
// // // // // // //         : const Color(0xFFE8E0F2),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     focusedBorder: OutlineInputBorder(
// // // // // // //     borderRadius: BorderRadius.circular(8),
// // // // // // //     borderSide: const BorderSide(color: Color(0xFF5A002B)),
// // // // // // //     ),
// // // // // // //     fillColor: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // // // //     filled: true,
// // // // // // //     );
// // // // // // //     }
// // // // // // //
// // // // // // //     DateTime? parseProfileDate(String? value) {
// // // // // // //     if (value == null || value.trim().isEmpty) return null;
// // // // // // //
// // // // // // //     final text = value.trim();
// // // // // // //
// // // // // // //     final dmyMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(text);
// // // // // // //     if (dmyMatch != null) {
// // // // // // //     final day = int.tryParse(dmyMatch.group(1)!);
// // // // // // //     final month = int.tryParse(dmyMatch.group(2)!);
// // // // // // //     final year = int.tryParse(dmyMatch.group(3)!);
// // // // // // //
// // // // // // //     if (day != null && month != null && year != null) {
// // // // // // //     return DateTime(year, month, day);
// // // // // // //     }
// // // // // // //     }
// // // // // // //
// // // // // // //     final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
// // // // // // //     if (isoMatch != null) {
// // // // // // //     final year = int.tryParse(isoMatch.group(1)!);
// // // // // // //     final month = int.tryParse(isoMatch.group(2)!);
// // // // // // //     final day = int.tryParse(isoMatch.group(3)!);
// // // // // // //
// // // // // // //     if (day != null && month != null && year != null) {
// // // // // // //     return DateTime(year, month, day);
// // // // // // //     }
// // // // // // //     }
// // // // // // //
// // // // // // //     return DateTime.tryParse(text);
// // // // // // //     }
// // // // // // //
// // // // // // //     String formatProfileDate(DateTime date) {
// // // // // // //     final day = date.day.toString().padLeft(2, '0');
// // // // // // //     final month = date.month.toString().padLeft(2, '0');
// // // // // // //     final year = date.year.toString();
// // // // // // //
// // // // // // //     return '$day/$month/$year';
// // // // // // //     }
// // // // // // //
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'BODY TYPE',
// // // // // // //           data,
// // // // // // //           'bodyType',
// // // // // // //           ProfileOptions.bodyTypes,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'ETHNIC BACKGROUND',
// // // // // // //           data,
// // // // // // //           'ethnic',
// // // // // // //           ProfileOptions.ethnicBackgrounds,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'SEXUALITY',
// // // // // // //           data,
// // // // // // //           'sexuality',
// // // // // // //           ProfileOptions.sexualities,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'RELATIONSHIP ORIENTATION',
// // // // // // //           data,
// // // // // // //           'orientation',
// // // // // // //           ProfileOptions.relationshipOrientations,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'TATTOOS',
// // // // // // //           data,
// // // // // // //           'tattoos',
// // // // // // //           ProfileOptions.tattoos,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'PIERCINGS',
// // // // // // //           data,
// // // // // // //           'piercings',
// // // // // // //           ProfileOptions.piercings,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'SMOKING',
// // // // // // //           data,
// // // // // // //           'smoking',
// // // // // // //           ProfileOptions.smoking,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'DRINKING',
// // // // // // //           data,
// // // // // // //           'drinking',
// // // // // // //           ProfileOptions.drinking,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'BODY HAIR',
// // // // // // //           data,
// // // // // // //           'bodyHair',
// // // // // // //           ProfileOptions.bodyHair,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         // languagesField(
// // // // // // //         //   context,
// // // // // // //         //   'LANGUAGES SPOKEN',
// // // // // // //         //   languages,
// // // // // // //         //   onLanguagesChanged,
// // // // // // //         //   readOnly: readOnly,
// // // // // // //         // ),
// // // // // // //           Widget languagesField(
// // // // // // //           BuildContext context,
// // // // // // //     String label,
// // // // // // //     List<String> selectedValues,
// // // // // // //     void Function(List<String>) onSaved, {
// // // // // // //     bool readOnly = false,
// // // // // // //     }) {
// // // // // // //     return Padding(
// // // // // // //     padding: const EdgeInsets.only(bottom: 8),
// // // // // // //     child: Column(
// // // // // // //     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //     children: [
// // // // // // //     textFieldLabel(label),
// // // // // // //     const SizedBox(height: 4),
// // // // // // //     InkWell(
// // // // // // //     onTap: readOnly
// // // // // // //     ? null
// // // // // // //         : () => openLanguageSelector(context, selectedValues, onSaved),
// // // // // // //     borderRadius: BorderRadius.circular(8),
// // // // // // //     child: Container(
// // // // // // //     width: double.infinity,
// // // // // // //     constraints: const BoxConstraints(minHeight: 42),
// // // // // // //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// // // // // // //     decoration: BoxDecoration(
// // // // // // //     borderRadius: BorderRadius.circular(8),
// // // // // // //     border: Border.all(
// // // // // // //     color: readOnly
// // // // // // //     ? const Color(0xFFF2F2F2)
// // // // // // //         : const Color(0xFFE8E0F2),
// // // // // // //     ),
// // // // // // //     color: readOnly ? const Color(0xFFF9F9F9) : Colors.white,
// // // // // // //     ),
// // // // // // //     child: Row(
// // // // // // //     children: [
// // // // // // //     Expanded(
// // // // // // //     child: selectedValues.isEmpty
// // // // // // //     ? Text(
// // // // // // //     ProfileOptions.notComfortableLabel,
// // // // // // //     maxLines: 1,
// // // // // // //     overflow: TextOverflow.ellipsis,
// // // // // // //     style: TextStyle(
// // // // // // //     color: Colors.grey[600],
// // // // // // //     fontSize: 12,
// // // // // // //     ),
// // // // // // //     )
// // // // // // //         : Wrap(
// // // // // // //     spacing: 6,
// // // // // // //     runSpacing: 6,
// // // // // // //     children: selectedValues
// // // // // // //         .map(
// // // // // // //     (lang) => Container(
// // // // // // //     padding: const EdgeInsets.symmetric(
// // // // // // //     horizontal: 8,
// // // // // // //     vertical: 3,
// // // // // // //     ),
// // // // // // //     decoration: BoxDecoration(
// // // // // // //     color: const Color(0xFFF0F4FF),
// // // // // // //     borderRadius: BorderRadius.circular(12),
// // // // // // //     border: Border.all(
// // // // // // //     color: const Color(0xFFD4DDF2),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     child: Text(
// // // // // // //     lang,
// // // // // // //     style: const TextStyle(fontSize: 11),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     )
// // // // // // //         .toList(),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     const SizedBox(width: 8),
// // // // // // //     const Icon(
// // // // // // //     Icons.keyboard_arrow_down_rounded,
// // // // // // //     size: 20,
// // // // // // //     color: Colors.black87,
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     ),
// // // // // // //     ],
// // // // // // //     ),
// // // // // // //     );
// // // // // // //     }
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'LOOKS IMPORTANCE',
// // // // // // //           data,
// // // // // // //           'looks',
// // // // // // //           ProfileOptions.importanceLevels,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'INTELLIGENCE IMPORTANCE',
// // // // // // //           data,
// // // // // // //           'intelligence',
// // // // // // //           ProfileOptions.importanceLevels,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //
// // // // // // //         profileOptionDropdownField(
// // // // // // //           'CIRCUMCISED',
// // // // // // //           data,
// // // // // // //           'circumcised',
// // // // // // //           ProfileOptions.circumcised,
// // // // // // //           onFieldChanged,
// // // // // // //           readOnly: readOnly,
// // // // // // //         ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   ProfileOption? findProfileOption(
// // // // // // //       String? currentValue,
// // // // // // //       List<ProfileOption> options,
// // // // // // //       ) {
// // // // // // //     if (currentValue == null || currentValue.trim().isEmpty) {
// // // // // // //       return null;
// // // // // // //     }
// // // // // // //
// // // // // // //     final normalizedCurrent = _normalize(currentValue);
// // // // // // //
// // // // // // //     for (final option in options) {
// // // // // // //       if (_normalize(option.id) == normalizedCurrent ||
// // // // // // //           _normalize(option.value) == normalizedCurrent ||
// // // // // // //           _normalize(option.label) == normalizedCurrent) {
// // // // // // //         return option;
// // // // // // //       }
// // // // // // //     }
// // // // // // //
// // // // // // //     // Compatibility aliases for old values you were using in Flutter.
// // // // // // //     if (normalizedCurrent == _normalize('Bisexual')) {
// // // // // // //       return options.where((e) => e.value == 'Bi-sexual').firstOrNull;
// // // // // // //     }
// // // // // // //
// // // // // // //     if (normalizedCurrent == _normalize('Occasionally')) {
// // // // // // //       return options.where((e) => e.value == 'Occasionaly').firstOrNull;
// // // // // // //     }
// // // // // // //
// // // // // // //     if (normalizedCurrent == _normalize('Low')) {
// // // // // // //       return options.where((e) => e.value == 'Low Importance').firstOrNull;
// // // // // // //     }
// // // // // // //
// // // // // // //     if (normalizedCurrent == _normalize('Medium')) {
// // // // // // //       return options.where((e) => e.value == 'Medium Importance').firstOrNull;
// // // // // // //     }
// // // // // // //
// // // // // // //     if (normalizedCurrent == _normalize('High')) {
// // // // // // //       return options.where((e) => e.value == 'Very Important').firstOrNull;
// // // // // // //     }
// // // // // // //
// // // // // // //     return null;
// // // // // // //   }
// // // // // // //
// // // // // // //   String _normalize(String value) {
// // // // // // //     return value
// // // // // // //         .trim()
// // // // // // //         .toLowerCase()
// // // // // // //         .replaceAll('.', '')
// // // // // // //         .replaceAll('-', '')
// // // // // // //         .replaceAll('_', '')
// // // // // // //         .replaceAll(' ', '');
// // // // // // //   }
// // // // // // //
// // // // // // //   String? defaultProfileOptionValue(List<ProfileOption> options) {
// // // // // // //     if (options.isEmpty) return null;
// // // // // // //
// // // // // // //     for (final option in options) {
// // // // // // //       if (option.id == 'not_comfortable') {
// // // // // // //         return option.value;
// // // // // // //       }
// // // // // // //     }
// // // // // // //
// // // // // // //     return options.first.value;
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget profileOptionDropdownField(
// // // // // // //       String label,
// // // // // // //       Map<String, String> data,
// // // // // // //       String key,
// // // // // // //       List<ProfileOption> options,
// // // // // // //       void Function(String, String) onFieldChanged, {
// // // // // // //         bool readOnly = false,
// // // // // // //       }) {
// // // // // // //     final currentValue = data[key];
// // // // // // //     final selectedOption = findProfileOption(currentValue, options);
// // // // // // //     final validValue = selectedOption?.value ?? defaultProfileOptionValue(options);
// // // // // // //
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           textFieldLabel(label),
// // // // // // //           const SizedBox(height: 4),
// // // // // // //           DropdownButtonFormField<String>(
// // // // // // //             key: ValueKey('$label-$key-$validValue-$readOnly'),
// // // // // // //             initialValue: validValue,
// // // // // // //             isExpanded: true,
// // // // // // //             iconSize: 18,
// // // // // // //             style: const TextStyle(
// // // // // // //               fontSize: 12,
// // // // // // //               color: Colors.black87,
// // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // //             ),
// // // // // // //             items: options.map((option) {
// // // // // // //               return DropdownMenuItem<String>(
// // // // // // //                 value: option.value,
// // // // // // //                 child: Text(
// // // // // // //                   option.label,
// // // // // // //                   maxLines: 1,
// // // // // // //                   overflow: TextOverflow.ellipsis,
// // // // // // //                 ),
// // // // // // //               );
// // // // // // //             }).toList(),
// // // // // // //             selectedItemBuilder: (context) {
// // // // // // //               return options.map((option) {
// // // // // // //                 return Align(
// // // // // // //                   alignment: Alignment.centerLeft,
// // // // // // //                   child: Text(
// // // // // // //                     option.label,
// // // // // // //                     maxLines: 1,
// // // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // // //                   ),
// // // // // // //                 );
// // // // // // //               }).toList();
// // // // // // //             },
// // // // // // //             onChanged: readOnly
// // // // // // //                 ? null
// // // // // // //                 : (value) {
// // // // // // //               if (value == null) return;
// // // // // // //               onFieldChanged(key, value);
// // // // // // //             },
// // // // // // //             decoration: InputDecoration(
// // // // // // //               isDense: true,
// // // // // // //               contentPadding: const EdgeInsets.symmetric(
// // // // // // //                 horizontal: 10,
// // // // // // //                 vertical: 8,
// // // // // // //               ),
// // // // // // //               border: OutlineInputBorder(
// // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // //               ),
// // // // // // //               enabledBorder: OutlineInputBorder(
// // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // //                 borderSide: BorderSide(
// // // // // // //                   color: readOnly
// // // // // // //                       ? const Color(0xFFF2F2F2)
// // // // // // //                       : const Color(0xFFE8E0F2),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// // // // // // //               filled: readOnly,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget dropdownField(
// // // // // // //       String label,
// // // // // // //       Map<String, String> data,
// // // // // // //       String key,
// // // // // // //       List<String> options,
// // // // // // //       void Function(String, String) onFieldChanged, {
// // // // // // //         bool readOnly = false,
// // // // // // //       }) {
// // // // // // //     final currentValue = data[key];
// // // // // // //     final validValue = currentValue != null && options.contains(currentValue)
// // // // // // //         ? currentValue
// // // // // // //         : options.isNotEmpty
// // // // // // //         ? options[0]
// // // // // // //         : null;
// // // // // // //
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           textFieldLabel(label),
// // // // // // //           const SizedBox(height: 4),
// // // // // // //           DropdownButtonFormField<String>(
// // // // // // //             key: ValueKey('$label-$key-$validValue-$readOnly'),
// // // // // // //             initialValue: validValue,
// // // // // // //             isExpanded: true,
// // // // // // //             iconSize: 18,
// // // // // // //             style: const TextStyle(
// // // // // // //               fontSize: 12,
// // // // // // //               color: Colors.black87,
// // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // //             ),
// // // // // // //             items: options
// // // // // // //                 .map(
// // // // // // //                   (e) => DropdownMenuItem<String>(
// // // // // // //                 value: e,
// // // // // // //                 child: Text(
// // // // // // //                   e,
// // // // // // //                   maxLines: 1,
// // // // // // //                   overflow: TextOverflow.ellipsis,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             )
// // // // // // //                 .toList(),
// // // // // // //             selectedItemBuilder: (context) {
// // // // // // //               return options
// // // // // // //                   .map(
// // // // // // //                     (e) => Align(
// // // // // // //                   alignment: Alignment.centerLeft,
// // // // // // //                   child: Text(
// // // // // // //                     e,
// // // // // // //                     maxLines: 1,
// // // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               )
// // // // // // //                   .toList();
// // // // // // //             },
// // // // // // //             onChanged: readOnly
// // // // // // //                 ? null
// // // // // // //                 : (value) {
// // // // // // //               if (value == null) return;
// // // // // // //               onFieldChanged(key, value);
// // // // // // //             },
// // // // // // //             decoration: InputDecoration(
// // // // // // //               isDense: true,
// // // // // // //               contentPadding: const EdgeInsets.symmetric(
// // // // // // //                 horizontal: 10,
// // // // // // //                 vertical: 8,
// // // // // // //               ),
// // // // // // //               border: OutlineInputBorder(
// // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // //               ),
// // // // // // //               enabledBorder: OutlineInputBorder(
// // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // //                 borderSide: BorderSide(
// // // // // // //                   color: readOnly
// // // // // // //                       ? const Color(0xFFF2F2F2)
// // // // // // //                       : const Color(0xFFE8E0F2),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// // // // // // //               filled: readOnly,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget simpleTextField({
// // // // // // //     required String label,
// // // // // // //     required String initialValue,
// // // // // // //     required void Function(String) onChanged,
// // // // // // //     int maxLines = 1,
// // // // // // //     bool readOnly = false,
// // // // // // //   }) {
// // // // // // //     return TextFormField(
// // // // // // //       key: ValueKey('$label-$initialValue-$readOnly'),
// // // // // // //       initialValue: initialValue,
// // // // // // //       maxLines: maxLines,
// // // // // // //       onChanged: onChanged,
// // // // // // //       readOnly: readOnly,
// // // // // // //       style: const TextStyle(fontSize: 12),
// // // // // // //       decoration: InputDecoration(
// // // // // // //         hintText: label,
// // // // // // //         isDense: true,
// // // // // // //         contentPadding: const EdgeInsets.symmetric(
// // // // // // //           horizontal: 10,
// // // // // // //           vertical: 10,
// // // // // // //         ),
// // // // // // //         border: OutlineInputBorder(
// // // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // //         ),
// // // // // // //         enabledBorder: OutlineInputBorder(
// // // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget textFieldLabel(String text) {
// // // // // // //     return Text(
// // // // // // //       text,
// // // // // // //       style: const TextStyle(
// // // // // // //         fontSize: 11,
// // // // // // //         fontWeight: FontWeight.w800,
// // // // // // //         letterSpacing: 0.2,
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget languagesField(
// // // // // // //       BuildContext context,
// // // // // // //       String label,
// // // // // // //       List<String> selectedValues,
// // // // // // //       void Function(List<String>) onSaved, {
// // // // // // //         bool readOnly = false,
// // // // // // //       }) {
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           textFieldLabel(label),
// // // // // // //           const SizedBox(height: 4),
// // // // // // //           InkWell(
// // // // // // //             onTap: readOnly
// // // // // // //                 ? null
// // // // // // //                 : () => openLanguageSelector(context, selectedValues, onSaved),
// // // // // // //             borderRadius: BorderRadius.circular(8),
// // // // // // //             child: Container(
// // // // // // //               width: double.infinity,
// // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // //                 border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // // // //                 color: readOnly ? const Color(0xFFF9F9F9) : null,
// // // // // // //               ),
// // // // // // //               child: Row(
// // // // // // //                 children: [
// // // // // // //                   Expanded(
// // // // // // //                     child: Wrap(
// // // // // // //                       spacing: 6,
// // // // // // //                       runSpacing: 6,
// // // // // // //                       children: selectedValues.isEmpty
// // // // // // //                           ? [
// // // // // // //                         Text(
// // // // // // //                           ProfileOptions.notComfortableLabel,
// // // // // // //                           style: TextStyle(
// // // // // // //                             color: Colors.grey[600],
// // // // // // //                             fontSize: 12,
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ]
// // // // // // //                           : selectedValues
// // // // // // //                           .map(
// // // // // // //                             (lang) => Container(
// // // // // // //                           padding: const EdgeInsets.symmetric(
// // // // // // //                             horizontal: 8,
// // // // // // //                             vertical: 2,
// // // // // // //                           ),
// // // // // // //                           decoration: BoxDecoration(
// // // // // // //                             color: const Color(0xFFF0F4FF),
// // // // // // //                             borderRadius: BorderRadius.circular(12),
// // // // // // //                             border: Border.all(
// // // // // // //                               color: const Color(0xFFD4DDF2),
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                           child: Text(
// // // // // // //                             lang,
// // // // // // //                             style: const TextStyle(fontSize: 11),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       )
// // // // // // //                           .toList(),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> openLanguageSelector(
// // // // // // //       BuildContext context,
// // // // // // //       List<String> selectedValues,
// // // // // // //       void Function(List<String>) onSaved,
// // // // // // //       ) async {
// // // // // // //     final temp = [...selectedValues];
// // // // // // //
// // // // // // //     await showModalBottomSheet<void>(
// // // // // // //       context: context,
// // // // // // //       builder: (context) {
// // // // // // //         return StatefulBuilder(
// // // // // // //           builder: (context, setModalState) {
// // // // // // //             return SafeArea(
// // // // // // //               child: Padding(
// // // // // // //                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
// // // // // // //                 child: Column(
// // // // // // //                   mainAxisSize: MainAxisSize.min,
// // // // // // //                   children: [
// // // // // // //                     const Text(
// // // // // // //                       'Select Languages',
// // // // // // //                       style: TextStyle(
// // // // // // //                         fontWeight: FontWeight.w700,
// // // // // // //                         fontSize: 16,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     const SizedBox(height: 10),
// // // // // // //                     ...languageOptions.map(
// // // // // // //                           (lang) => CheckboxListTile(
// // // // // // //                         dense: true,
// // // // // // //                         value: temp.contains(lang),
// // // // // // //                         onChanged: (checked) {
// // // // // // //                           setModalState(() {
// // // // // // //                             if (checked == true) {
// // // // // // //                               if (!temp.contains(lang)) temp.add(lang);
// // // // // // //                             } else {
// // // // // // //                               temp.remove(lang);
// // // // // // //                             }
// // // // // // //                           });
// // // // // // //                         },
// // // // // // //                         title: Text(lang),
// // // // // // //                         controlAffinity: ListTileControlAffinity.leading,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     const SizedBox(height: 8),
// // // // // // //                     SizedBox(
// // // // // // //                       width: double.infinity,
// // // // // // //                       child: ElevatedButton(
// // // // // // //                         onPressed: () {
// // // // // // //                           onSaved(temp);
// // // // // // //                           Navigator.pop(context);
// // // // // // //                         },
// // // // // // //                         child: const Text('Done'),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             );
// // // // // // //           },
// // // // // // //         );
// // // // // // //       },
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget interestGroup({
// // // // // // //     required String title,
// // // // // // //     required bool expanded,
// // // // // // //     required VoidCallback onToggle,
// // // // // // //     required Map<String, bool> options,
// // // // // // //     required double optionWidth,
// // // // // // //     required void Function(String label, bool value) onChanged,
// // // // // // //   }) {
// // // // // // //     return Container(
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.white,
// // // // // // //         borderRadius: BorderRadius.circular(10),
// // // // // // //         border: Border.all(color: const Color(0xFFECE4F4)),
// // // // // // //       ),
// // // // // // //       child: Column(
// // // // // // //         children: [
// // // // // // //           InkWell(
// // // // // // //             onTap: onToggle,
// // // // // // //             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
// // // // // // //             child: Container(
// // // // // // //               height: 40,
// // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 14),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 gradient: const LinearGradient(
// // // // // // //                   colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // // //                 ),
// // // // // // //                 borderRadius: BorderRadius.vertical(
// // // // // // //                   top: const Radius.circular(10),
// // // // // // //                   bottom: expanded ? Radius.zero : const Radius.circular(10),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               child: Row(
// // // // // // //                 children: [
// // // // // // //                   Expanded(
// // // // // // //                     child: Text(
// // // // // // //                       title,
// // // // // // //                       maxLines: 1,
// // // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // // //                       style: const TextStyle(
// // // // // // //                         color: Colors.white,
// // // // // // //                         fontSize: 30,
// // // // // // //                         fontWeight: FontWeight.w800,
// // // // // // //                         height: 1.0,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(width: 8),
// // // // // // //                   CircleAvatar(
// // // // // // //                     radius: 12,
// // // // // // //                     backgroundColor: const Color(0xFFEACD71),
// // // // // // //                     child: Icon(
// // // // // // //                       expanded
// // // // // // //                           ? Icons.keyboard_arrow_up
// // // // // // //                           : Icons.keyboard_arrow_down,
// // // // // // //                       size: 16,
// // // // // // //                       color: Colors.black87,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           if (expanded)
// // // // // // //             Padding(
// // // // // // //               padding: const EdgeInsets.all(10),
// // // // // // //               child: Wrap(
// // // // // // //                 spacing: 8,
// // // // // // //                 runSpacing: 8,
// // // // // // //                 children: options.entries
// // // // // // //                     .map(
// // // // // // //                       (entry) => OptionChip(
// // // // // // //                     label: entry.key,
// // // // // // //                     selected: entry.value,
// // // // // // //                     width: optionWidth,
// // // // // // //                     onTap: () => onChanged(entry.key, !entry.value),
// // // // // // //                   ),
// // // // // // //                 )
// // // // // // //                     .toList(),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // //
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // // // OPTION CHIP
// // // // // // // // -----------------------------------------------------------------------------
// // // // // // //
// // // // // // // class OptionChip extends StatelessWidget {
// // // // // // //   const OptionChip({
// // // // // // //     super.key,
// // // // // // //     required this.label,
// // // // // // //     required this.selected,
// // // // // // //     required this.width,
// // // // // // //     required this.onTap,
// // // // // // //   });
// // // // // // //
// // // // // // //   final String label;
// // // // // // //   final bool selected;
// // // // // // //   final double width;
// // // // // // //   final VoidCallback onTap;
// // // // // // //
// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return InkWell(
// // // // // // //       onTap: onTap,
// // // // // // //       borderRadius: BorderRadius.circular(8),
// // // // // // //       child: Container(
// // // // // // //         width: width,
// // // // // // //         height: 42,
// // // // // // //         padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // // // //         decoration: BoxDecoration(
// // // // // // //           color: Colors.white,
// // // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // // //           border: Border.all(color: const Color(0xFFF1EBF8)),
// // // // // // //         ),
// // // // // // //         child: Row(
// // // // // // //           children: [
// // // // // // //             Expanded(
// // // // // // //               child: Text(
// // // // // // //                 label,
// // // // // // //                 overflow: TextOverflow.ellipsis,
// // // // // // //                 style: const TextStyle(
// // // // // // //                   color: Colors.black87,
// // // // // // //                   fontWeight: FontWeight.w500,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             Checkbox(
// // // // // // //               value: selected,
// // // // // // //               onChanged: (_) => onTap(),
// // // // // // //               shape: RoundedRectangleBorder(
// // // // // // //                 borderRadius: BorderRadius.circular(4),
// // // // // // //               ),
// // // // // // //               activeColor: const Color(0xFF47003D),
// // // // // // //               side: const BorderSide(color: Color(0xFFE0D4EE)),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // //
// // // // // // //
// // // // // // //
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // // import 'package:get/get.dart';
// // // // // // // // import 'package:beatflirt/Api_services/api_services.dart';
// // // // // // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // // // // //
// // // // // // // // // --- STATE ---
// // // // // // // // class ProfileEditState {
// // // // // // // //   final bool isProfileDetailsTab;
// // // // // // // //   final Map<String, bool> swingersOptions;
// // // // // // // //   final Map<String, bool> hookupOptions;
// // // // // // // //   final bool isSwingersExpanded;
// // // // // // // //   final bool isHookupExpanded;
// // // // // // // //   final String aboutMe;
// // // // // // // //   final String lookingFor;
// // // // // // // //   final Map<String, String> partner1;
// // // // // // // //   final Map<String, String> partner2;
// // // // // // // //   final List<String> partner1Languages;
// // // // // // // //   final List<String> partner2Languages;
// // // // // // // //   final bool isLoading;
// // // // // // // //   final Map<String, dynamic>? linkedPartner;
// // // // // // // //
// // // // // // // //   const ProfileEditState({
// // // // // // // //     this.isProfileDetailsTab = false,
// // // // // // // //     required this.swingersOptions,
// // // // // // // //     required this.hookupOptions,
// // // // // // // //     this.isSwingersExpanded = true,
// // // // // // // //     this.isHookupExpanded = true,
// // // // // // // //     this.aboutMe = 'About me',
// // // // // // // //     this.lookingFor = 'Describe what you are looking for...',
// // // // // // // //     required this.partner1,
// // // // // // // //     required this.partner2,
// // // // // // // //     required this.partner1Languages,
// // // // // // // //     required this.partner2Languages,
// // // // // // // //     this.isLoading = false,
// // // // // // // //     this.linkedPartner,
// // // // // // // //   });
// // // // // // // //
// // // // // // // //   ProfileEditState copyWith({
// // // // // // // //     bool? isProfileDetailsTab,
// // // // // // // //     Map<String, bool>? swingersOptions,
// // // // // // // //     Map<String, bool>? hookupOptions,
// // // // // // // //     bool? isSwingersExpanded,
// // // // // // // //     bool? isHookupExpanded,
// // // // // // // //     String? aboutMe,
// // // // // // // //     String? lookingFor,
// // // // // // // //     Map<String, String>? partner1,
// // // // // // // //     Map<String, String>? partner2,
// // // // // // // //     List<String>? partner1Languages,
// // // // // // // //     List<String>? partner2Languages,
// // // // // // // //     bool? isLoading,
// // // // // // // //     Map<String, dynamic>? linkedPartner,
// // // // // // // //   }) {
// // // // // // // //     return ProfileEditState(
// // // // // // // //       isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
// // // // // // // //       swingersOptions: swingersOptions ?? this.swingersOptions,
// // // // // // // //       hookupOptions: hookupOptions ?? this.hookupOptions,
// // // // // // // //       isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
// // // // // // // //       isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
// // // // // // // //       aboutMe: aboutMe ?? this.aboutMe,
// // // // // // // //       lookingFor: lookingFor ?? this.lookingFor,
// // // // // // // //       partner1: partner1 ?? this.partner1,
// // // // // // // //       partner2: partner2 ?? this.partner2,
// // // // // // // //       partner1Languages: partner1Languages ?? this.partner1Languages,
// // // // // // // //       partner2Languages: partner2Languages ?? this.partner2Languages,
// // // // // // // //       isLoading: isLoading ?? this.isLoading,
// // // // // // // //       linkedPartner: linkedPartner ?? this.linkedPartner,
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }
// // // // // // // //
// // // // // // // // // --- NOTIFIER ---
// // // // // // // // class ProfileEditNotifier extends Notifier<ProfileEditState> {
// // // // // // // //   final ApiServices _apiServices = ApiServices();
// // // // // // // //
// // // // // // // //   @override
// // // // // // // //   ProfileEditState build() {
// // // // // // // //     // Start fetching as soon as possible
// // // // // // // //     Future.microtask(() => loadProfile());
// // // // // // // //
// // // // // // // //     return ProfileEditState(
// // // // // // // //       swingersOptions: {
// // // // // // // //         'Couple Female/Male': true,
// // // // // // // //         'Couple Female/Female': true,
// // // // // // // //         'Couple Male/Male': true,
// // // // // // // //         'Female': true,
// // // // // // // //         'Male': true,
// // // // // // // //         'Transgender': true,
// // // // // // // //       },
// // // // // // // //       hookupOptions: {
// // // // // // // //         'Couple Female/Male': true,
// // // // // // // //         'Couple Female/Female': true,
// // // // // // // //         'Couple Male/Male': true,
// // // // // // // //         'Female': true,
// // // // // // // //         'Male': true,
// // // // // // // //         'Transgender': false,
// // // // // // // //       },
// // // // // // // //       partner1: {
// // // // // // // //         'dateOfBirth': '17/06/2004',
// // // // // // // //         'height': "4'6",
// // // // // // // //         'weight': '65',
// // // // // // // //         'bodyType': 'BBW',
// // // // // // // //         'ethnic': 'Italian',
// // // // // // // //         'sexuality': 'Straight',
// // // // // // // //         'orientation': "I'm not comfortable sharing that.",
// // // // // // // //         'tattoos': 'One',
// // // // // // // //         'piercings': 'No',
// // // // // // // //         'smoking': 'Yes',
// // // // // // // //         'drinking': 'Yes',
// // // // // // // //         'bodyHair': 'Bikini',
// // // // // // // //         'looks': "I'm not comfortable sharing that.",
// // // // // // // //         'intelligence': 'Very Important',
// // // // // // // //         'circumcised': 'Yes',
// // // // // // // //       },
// // // // // // // //       partner2: {}, // Will be populated from linkedPartner if available
// // // // // // // //       partner1Languages: ['English'],
// // // // // // // //       partner2Languages: [],
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<void> loadProfile() async {
// // // // // // // //     final token = await AuthService.getToken();
// // // // // // // //     if (token == null) return;
// // // // // // // //
// // // // // // // //     state = state.copyWith(isLoading: true);
// // // // // // // //     try {
// // // // // // // //       final data = await _apiServices.getProfile(token: token);
// // // // // // // //       final user = data['user'];
// // // // // // // //       if (user != null) {
// // // // // // // //         // Map backend fields to frontend state, preserving default keys
// // // // // // // //         final mergedTraits = Map<String, String>.from(state.partner1);
// // // // // // // //         final backendTraits = Map<String, dynamic>.from(user['partner1Traits'] ?? {});
// // // // // // // //         backendTraits.forEach((key, value) {
// // // // // // // //           if (mergedTraits.containsKey(key)) {
// // // // // // // //             mergedTraits[key] = value.toString();
// // // // // // // //           }
// // // // // // // //         });
// // // // // // // //
// // // // // // // //         final linked = user['partnerId']; // Populated from backend
// // // // // // // //         Map<String, String> p2Traits = {};
// // // // // // // //         List<String> p2Langs = [];
// // // // // // // //
// // // // // // // //         if (linked != null) {
// // // // // // // //           final lpTraits = Map<String, dynamic>.from(linked['partner1Traits'] ?? {});
// // // // // // // //           p2Traits = lpTraits.map((k, v) => MapEntry(k, v.toString()));
// // // // // // // //           p2Langs = List<String>.from(linked['partner1Languages'] ?? []);
// // // // // // // //         }
// // // // // // // //
// // // // // // // //         final mergedSwingers = Map<String, bool>.from(state.swingersOptions);
// // // // // // // //         final backendSwingers = Map<String, bool>.from(user['swingersOptions'] ?? {});
// // // // // // // //         backendSwingers.forEach((key, value) {
// // // // // // // //           if (mergedSwingers.containsKey(key)) {
// // // // // // // //             mergedSwingers[key] = value;
// // // // // // // //           }
// // // // // // // //         });
// // // // // // // //
// // // // // // // //         final mergedHookup = Map<String, bool>.from(state.hookupOptions);
// // // // // // // //         final backendHookup = Map<String, bool>.from(user['hookupOptions'] ?? {});
// // // // // // // //         backendHookup.forEach((key, value) {
// // // // // // // //           if (mergedHookup.containsKey(key)) {
// // // // // // // //             mergedHookup[key] = value;
// // // // // // // //           }
// // // // // // // //         });
// // // // // // // //
// // // // // // // //         state = state.copyWith(
// // // // // // // //           aboutMe: user['aboutMe'] ?? '',
// // // // // // // //           lookingFor: user['lookingFor'] ?? '',
// // // // // // // //           partner1: mergedTraits,
// // // // // // // //           partner1Languages: List<String>.from(user['partner1Languages'] ?? []),
// // // // // // // //           swingersOptions: mergedSwingers,
// // // // // // // //           hookupOptions: mergedHookup,
// // // // // // // //           partner2: p2Traits,
// // // // // // // //           partner2Languages: p2Langs,
// // // // // // // //           linkedPartner: linked,
// // // // // // // //         );
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint('Error loading profile: $e');
// // // // // // // //     } finally {
// // // // // // // //       state = state.copyWith(isLoading: false);
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<void> saveProfile() async {
// // // // // // // //     final token = await AuthService.getToken();
// // // // // // // //     if (token == null) return;
// // // // // // // //
// // // // // // // //     state = state.copyWith(isLoading: true);
// // // // // // // //     try {
// // // // // // // //       final updates = {
// // // // // // // //         'aboutMe': state.aboutMe,
// // // // // // // //         'lookingFor': state.lookingFor,
// // // // // // // //         'partner1Traits': state.partner1,
// // // // // // // //         'partner1Languages': state.partner1Languages,
// // // // // // // //         'swingersOptions': state.swingersOptions,
// // // // // // // //         'hookupOptions': state.hookupOptions,
// // // // // // // //       };
// // // // // // // //
// // // // // // // //       await _apiServices.updateProfile(token: token, updates: updates);
// // // // // // // //
// // // // // // // //       Get.snackbar(
// // // // // // // //         'Success',
// // // // // // // //         'Profile updated successfully',
// // // // // // // //         snackPosition: SnackPosition.TOP,
// // // // // // // //         backgroundColor: Colors.green,
// // // // // // // //         colorText: Colors.white,
// // // // // // // //       );
// // // // // // // //     } catch (e) {
// // // // // // // //       Get.snackbar(
// // // // // // // //         'Error',
// // // // // // // //         'Failed to update profile: $e',
// // // // // // // //         snackPosition: SnackPosition.TOP,
// // // // // // // //         backgroundColor: Colors.red,
// // // // // // // //         colorText: Colors.white,
// // // // // // // //       );
// // // // // // // //     } finally {
// // // // // // // //       state = state.copyWith(isLoading: false);
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void toggleProfileTab(bool isProfile) {
// // // // // // // //     state = state.copyWith(isProfileDetailsTab: isProfile);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void toggleSwingersExpanded() {
// // // // // // // //     state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void toggleHookupExpanded() {
// // // // // // // //     state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void updateSwingersOption(String label, bool value) {
// // // // // // // //     final newOptions = Map<String, bool>.from(state.swingersOptions);
// // // // // // // //     newOptions[label] = value;
// // // // // // // //     state = state.copyWith(swingersOptions: newOptions);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void updateHookupOption(String label, bool value) {
// // // // // // // //     final newOptions = Map<String, bool>.from(state.hookupOptions);
// // // // // // // //     newOptions[label] = value;
// // // // // // // //     state = state.copyWith(hookupOptions: newOptions);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void updateAboutMe(String value) {
// // // // // // // //     state = state.copyWith(aboutMe: value);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void updateLookingFor(String value) {
// // // // // // // //     state = state.copyWith(lookingFor: value);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void updatePartner1(String key, String value) {
// // // // // // // //     final newPartner = Map<String, String>.from(state.partner1);
// // // // // // // //     newPartner[key] = value;
// // // // // // // //     state = state.copyWith(partner1: newPartner);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void updatePartner2(String key, String value) {
// // // // // // // //     final newPartner = Map<String, String>.from(state.partner2);
// // // // // // // //     newPartner[key] = value;
// // // // // // // //     state = state.copyWith(partner2: newPartner);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void updatePartner1Languages(List<String> langs) {
// // // // // // // //     state = state.copyWith(partner1Languages: langs);
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   void updatePartner2Languages(List<String> langs) {
// // // // // // // //     state = state.copyWith(partner2Languages: langs);
// // // // // // // //   }
// // // // // // // // }
// // // // // // // //
// // // // // // // // // --- PROVIDER ---
// // // // // // // // final profileEditProvider =
// // // // // // // //     NotifierProvider<ProfileEditNotifier, ProfileEditState>(
// // // // // // // //       ProfileEditNotifier.new,
// // // // // // // //     );
// // // // // // // //
// // // // // // // // // --- WIDGET ---
// // // // // // // // class MyProfileEditTab extends ConsumerWidget {
// // // // // // // //   const MyProfileEditTab({super.key});
// // // // // // // //
// // // // // // // //   static const List<String> _languageOptions = [
// // // // // // // //     'English',
// // // // // // // //     'Hindi',
// // // // // // // //     'German',
// // // // // // // //     'French',
// // // // // // // //     'Spanish',
// // // // // // // //   ];
// // // // // // // //
// // // // // // // //   void _saveInterests() {
// // // // // // // //     Get.snackbar(
// // // // // // // //       'Success',
// // // // // // // //       'Interests saved successfully',
// // // // // // // //       snackPosition: SnackPosition.TOP,
// // // // // // // //       backgroundColor: Colors.transparent,
// // // // // // // //       colorText: Colors.white,
// // // // // // // //       margin: const EdgeInsets.all(12),
// // // // // // // //       borderRadius: 10,
// // // // // // // //       duration: const Duration(seconds: 2),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // // // //     final profileState = ref.watch(profileEditProvider);
// // // // // // // //     final notifier = ref.read(profileEditProvider.notifier);
// // // // // // // //
// // // // // // // //     if (profileState.isLoading && profileState.partner1.isEmpty) {
// // // // // // // //       return const Center(
// // // // // // // //         child: CircularProgressIndicator(color: Colors.pink),
// // // // // // // //       );
// // // // // // // //     }
// // // // // // // //
// // // // // // // //     return LayoutBuilder(
// // // // // // // //       builder: (context, constraints) {
// // // // // // // //         final double width = constraints.maxWidth;
// // // // // // // //         final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
// // // // // // // //         final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;
// // // // // // // //         return Container(
// // // // // // // //           width: double.infinity,
// // // // // // // //           constraints: BoxConstraints(
// // // // // // // //             minHeight: MediaQuery.of(context).size.height * 0.62,
// // // // // // // //           ),
// // // // // // // //           padding: const EdgeInsets.all(16),
// // // // // // // //           decoration: BoxDecoration(
// // // // // // // //             color: Colors.white,
// // // // // // // //             borderRadius: BorderRadius.circular(14),
// // // // // // // //             border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // // // // //           ),
// // // // // // // //           child: Column(
// // // // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //             children: [
// // // // // // // //               _sectionHeader(profileState, notifier),
// // // // // // // //               const SizedBox(height: 16),
// // // // // // // //               if (profileState.isProfileDetailsTab)
// // // // // // // //                 _buildProfileDetailsContent(context, width, profileState, notifier)
// // // // // // // //               else
// // // // // // // //                 _buildInterestsContent(optionWidth, profileState, notifier),
// // // // // // // //               const SizedBox(height: 18),
// // // // // // // //               Center(
// // // // // // // //                 child: SizedBox(
// // // // // // // //                   width: 170,
// // // // // // // //                   child: ElevatedButton(
// // // // // // // //                     onPressed: profileState.isLoading ? null : () => notifier.saveProfile(),
// // // // // // // //                     style: ElevatedButton.styleFrom(
// // // // // // // //                       elevation: 4,
// // // // // // // //                       padding: const EdgeInsets.symmetric(vertical: 12),
// // // // // // // //                       backgroundColor: const Color(0xFF220027),
// // // // // // // //                       foregroundColor: Colors.white,
// // // // // // // //                       shape: RoundedRectangleBorder(
// // // // // // // //                         borderRadius: BorderRadius.circular(22),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                     child: profileState.isLoading
// // // // // // // //                         ? const SizedBox(
// // // // // // // //                             height: 20,
// // // // // // // //                             width: 20,
// // // // // // // //                             child: CircularProgressIndicator(
// // // // // // // //                               color: Colors.white,
// // // // // // // //                               strokeWidth: 2,
// // // // // // // //                             ),
// // // // // // // //                           )
// // // // // // // //                         : const Text(
// // // // // // // //                             'Save Interest',
// // // // // // // //                             style: TextStyle(
// // // // // // // //                               fontWeight: FontWeight.w700,
// // // // // // // //                               fontSize: 12,
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const SizedBox(height: 6),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //         );
// // // // // // // //       },
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
// // // // // // // //     return Container(
// // // // // // // //       height: 38,
// // // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         gradient: const LinearGradient(
// // // // // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // // // //         ),
// // // // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // // // //       ),
// // // // // // // //       child: Row(
// // // // // // // //         children: [
// // // // // // // //           InkWell(
// // // // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // // // //             onTap: () => notifier.toggleProfileTab(false),
// // // // // // // //             child: Container(
// // // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // // // // //               decoration: BoxDecoration(
// // // // // // // //                 color: !state.isProfileDetailsTab
// // // // // // // //                     ? const Color(0xFFFF2D87)
// // // // // // // //                     : Colors.transparent,
// // // // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // // // //               ),
// // // // // // // //               child: const Text(
// // // // // // // //                 'INTERESTS',
// // // // // // // //                 style: TextStyle(
// // // // // // // //                   color: Colors.white,
// // // // // // // //                   fontSize: 11,
// // // // // // // //                   fontWeight: FontWeight.w700,
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           const Spacer(),
// // // // // // // //           InkWell(
// // // // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // // // //             onTap: () => notifier.toggleProfileTab(true),
// // // // // // // //             child: Container(
// // // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // // // // //               decoration: BoxDecoration(
// // // // // // // //                 color: state.isProfileDetailsTab
// // // // // // // //                     ? const Color(0xFFFF2D87)
// // // // // // // //                     : Colors.transparent,
// // // // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // // // //               ),
// // // // // // // //               child: const Text(
// // // // // // // //                 'PROFILE DETAILS',
// // // // // // // //                 style: TextStyle(
// // // // // // // //                   color: Colors.white,
// // // // // // // //                   fontSize: 12,
// // // // // // // //                   fontWeight: FontWeight.w700,
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           // const SizedBox(width: 1),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _buildInterestsContent(
// // // // // // // //     double optionWidth,
// // // // // // // //     ProfileEditState state,
// // // // // // // //     ProfileEditNotifier notifier,
// // // // // // // //   ) {
// // // // // // // //     return Column(
// // // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //       children: [
// // // // // // // //         const Text(
// // // // // // // //           'davidbrown',
// // // // // // // //           style: TextStyle(
// // // // // // // //             fontWeight: FontWeight.w700,
// // // // // // // //             fontSize: 34,
// // // // // // // //             height: 1.05,
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         const SizedBox(height: 8),
// // // // // // // //         Text(
// // // // // // // //           'What are you looking for? *Select all that apply',
// // // // // // // //           style: TextStyle(
// // // // // // // //             color: Colors.grey[700],
// // // // // // // //             fontSize: 14,
// // // // // // // //             fontWeight: FontWeight.w500,
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         const SizedBox(height: 16),
// // // // // // // //         _interestGroup(
// // // // // // // //           title: 'Swingers',
// // // // // // // //           expanded: state.isSwingersExpanded,
// // // // // // // //           onToggle: notifier.toggleSwingersExpanded,
// // // // // // // //           options: state.swingersOptions,
// // // // // // // //           optionWidth: optionWidth,
// // // // // // // //           onChanged: (label, value) =>
// // // // // // // //               notifier.updateSwingersOption(label, value),
// // // // // // // //         ),
// // // // // // // //         const SizedBox(height: 12),
// // // // // // // //         _interestGroup(
// // // // // // // //           title: 'Hokup / Meetup',
// // // // // // // //           expanded: state.isHookupExpanded,
// // // // // // // //           onToggle: notifier.toggleHookupExpanded,
// // // // // // // //           options: state.hookupOptions,
// // // // // // // //           optionWidth: optionWidth,
// // // // // // // //           onChanged: (label, value) =>
// // // // // // // //               notifier.updateHookupOption(label, value),
// // // // // // // //         ),
// // // // // // // //       ],
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _buildProfileDetailsContent(
// // // // // // // //     BuildContext context,
// // // // // // // //     double width,
// // // // // // // //     ProfileEditState state,
// // // // // // // //     ProfileEditNotifier notifier,
// // // // // // // //   ) {
// // // // // // // //     final bool stacked = width < 760;
// // // // // // // //     return Column(
// // // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //       children: [
// // // // // // // //         _textFieldLabel('INTRODUCE YOURSELF *'),
// // // // // // // //         const SizedBox(height: 6),
// // // // // // // //         _simpleTextField(
// // // // // // // //           label: 'About Me',
// // // // // // // //           initialValue: state.aboutMe,
// // // // // // // //           onChanged: notifier.updateAboutMe,
// // // // // // // //         ),
// // // // // // // //         const SizedBox(height: 10),
// // // // // // // //         _textFieldLabel('LOOKING FOR'),
// // // // // // // //         const SizedBox(height: 6),
// // // // // // // //         _simpleTextField(
// // // // // // // //           label: 'Looking For',
// // // // // // // //           initialValue: state.lookingFor,
// // // // // // // //           maxLines: 2,
// // // // // // // //           onChanged: notifier.updateLookingFor,
// // // // // // // //         ),
// // // // // // // //         const SizedBox(height: 14),
// // // // // // // //         const Center(
// // // // // // // //           child: Text(
// // // // // // // //             'About Yourselves',
// // // // // // // //             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         const SizedBox(height: 12),
// // // // // // // //         if (stacked)
// // // // // // // //           Column(
// // // // // // // //             children: [
// // // // // // // //               _partnerPanel(
// // // // // // // //                 context: context,
// // // // // // // //                 title: 'Partner 1',
// // // // // // // //                 data: state.partner1,
// // // // // // // //                 languages: state.partner1Languages,
// // // // // // // //                 onFieldChanged: notifier.updatePartner1,
// // // // // // // //                 onLanguagesChanged: notifier.updatePartner1Languages,
// // // // // // // //               ),
// // // // // // // //               const SizedBox(height: 12),
// // // // // // // //               _partnerPanel(
// // // // // // // //                 context: context,
// // // // // // // //                 title: 'Partner 2',
// // // // // // // //                 data: state.partner2,
// // // // // // // //                 languages: state.partner2Languages,
// // // // // // // //                 onFieldChanged: notifier.updatePartner2,
// // // // // // // //                 onLanguagesChanged: notifier.updatePartner2Languages,
// // // // // // // //                 readOnly: true, // Partner 2 is not editable
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //           )
// // // // // // // //         else
// // // // // // // //           Row(
// // // // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //             children: [
// // // // // // // //               Expanded(
// // // // // // // //                 child: _partnerPanel(
// // // // // // // //                   context: context,
// // // // // // // //                   title: 'Partner 1',
// // // // // // // //                   data: state.partner1,
// // // // // // // //                   languages: state.partner1Languages,
// // // // // // // //                   onFieldChanged: notifier.updatePartner1,
// // // // // // // //                   onLanguagesChanged: notifier.updatePartner1Languages,
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const SizedBox(width: 12),
// // // // // // // //               Expanded(
// // // // // // // //                 child: _partnerPanel(
// // // // // // // //                   context: context,
// // // // // // // //                   title: 'Partner 2',
// // // // // // // //                   data: state.partner2,
// // // // // // // //                   languages: state.partner2Languages,
// // // // // // // //                   onFieldChanged: notifier.updatePartner2,
// // // // // // // //                   onLanguagesChanged: notifier.updatePartner2Languages,
// // // // // // // //                   readOnly: true, // Partner 2 is not editable
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //       ],
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _partnerPanel({
// // // // // // // //     required BuildContext context,
// // // // // // // //     required String title,
// // // // // // // //     required Map<String, String> data,
// // // // // // // //     required List<String> languages,
// // // // // // // //     required void Function(String, String) onFieldChanged,
// // // // // // // //     required void Function(List<String>) onLanguagesChanged,
// // // // // // // //     bool readOnly = false,
// // // // // // // //   }) {
// // // // // // // //     return Column(
// // // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //       children: [
// // // // // // // //         Container(
// // // // // // // //           height: 34,
// // // // // // // //           alignment: Alignment.center,
// // // // // // // //           decoration: BoxDecoration(
// // // // // // // //             gradient: const LinearGradient(
// // // // // // // //               colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // // // //             ),
// // // // // // // //             borderRadius: BorderRadius.circular(10),
// // // // // // // //           ),
// // // // // // // //           child: Text(
// // // // // // // //             title,
// // // // // // // //             style: const TextStyle(
// // // // // // // //               color: Colors.white,
// // // // // // // //               fontWeight: FontWeight.w700,
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         const SizedBox(height: 10),
// // // // // // // //         _dropdownField('DATE OF BIRTH', data, 'dateOfBirth', const [
// // // // // // // //           '17/06/2004',
// // // // // // // //           '03/12/2007',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //
// // // // // // // //         _dropdownField('HEIGHT', data, 'height', const [
// // // // // // // //           "4'6",
// // // // // // // //           "5'0",
// // // // // // // //           "5'7",
// // // // // // // //           "6'0",
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('WEIGHT', data, 'weight', const [
// // // // // // // //           '55',
// // // // // // // //           '60',
// // // // // // // //           '65',
// // // // // // // //           '70',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('BODY TYPE', data, 'bodyType', const [
// // // // // // // //           'BBW',
// // // // // // // //           'Athletic',
// // // // // // // //           'Slim',
// // // // // // // //           'Average',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('ETHNIC BACKGROUND', data, 'ethnic', const [
// // // // // // // //           'Italian',
// // // // // // // //           'German',
// // // // // // // //           'Indian',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('SEXUALITY', data, 'sexuality', const [
// // // // // // // //           'Straight',
// // // // // // // //           'Bisexual',
// // // // // // // //           'Gay',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('RELATIONSHIP ORIENTATION', data, 'orientation', const [
// // // // // // // //           "I'm not comfortable sharing that.",
// // // // // // // //           'Swinger',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('TATTOOS', data, 'tattoos', const [
// // // // // // // //           'No',
// // // // // // // //           'One',
// // // // // // // //           'Many',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('PIERCINGS', data, 'piercings', const [
// // // // // // // //           'No',
// // // // // // // //           'Yes',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('SMOKING', data, 'smoking', const [
// // // // // // // //           'No',
// // // // // // // //           'Yes',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('DRINKING', data, 'drinking', const [
// // // // // // // //           'No',
// // // // // // // //           'Yes',
// // // // // // // //           'Occasionally',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('BODY HAIR', data, 'bodyHair', const [
// // // // // // // //           'Bikini',
// // // // // // // //           'Arm, Chest',
// // // // // // // //           'Trimmed',
// // // // // // // //           'Natural',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _languagesField(
// // // // // // // //           context,
// // // // // // // //           'LANGUAGES SPOKEN',
// // // // // // // //           languages,
// // // // // // // //           onLanguagesChanged,
// // // // // // // //           readOnly: readOnly,
// // // // // // // //         ),
// // // // // // // //         _dropdownField('LOOKS IMPORTANCE', data, 'looks', const [
// // // // // // // //           "I'm not comfortable sharing that.",
// // // // // // // //           'Low',
// // // // // // // //           'Medium',
// // // // // // // //           'High',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('INTELLIGENCE IMPORTANCE', data, 'intelligence', const [
// // // // // // // //           'Low Importance',
// // // // // // // //           'Medium Importance',
// // // // // // // //           'Very Important',
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //         _dropdownField('CIRCUMCISED', data, 'circumcised', const [
// // // // // // // //           'Yes',
// // // // // // // //           'No',
// // // // // // // //           "I'm not comfortable sharing that.",
// // // // // // // //         ], onFieldChanged, readOnly: readOnly),
// // // // // // // //       ],
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _dropdownField(
// // // // // // // //     String label,
// // // // // // // //     Map<String, String> data,
// // // // // // // //     String key,
// // // // // // // //     List<String> options,
// // // // // // // //     void Function(String, String) onFieldChanged, {
// // // // // // // //     bool readOnly = false,
// // // // // // // //   }) {
// // // // // // // //     // Ensure the current value exists in options, otherwise use first option
// // // // // // // //     final currentValue = data[key];
// // // // // // // //     final validValue = (currentValue != null && options.contains(currentValue))
// // // // // // // //         ? currentValue
// // // // // // // //         : (options.isNotEmpty ? options[0] : null);
// // // // // // // //
// // // // // // // //     return Padding(
// // // // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // // // //       child: Column(
// // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //         children: [
// // // // // // // //           _textFieldLabel(label),
// // // // // // // //           const SizedBox(height: 4),
// // // // // // // //           DropdownButtonFormField<String>(
// // // // // // // //             initialValue: validValue,
// // // // // // // //             isExpanded: true,
// // // // // // // //             iconSize: 18,
// // // // // // // //             style: const TextStyle(
// // // // // // // //               fontSize: 12,
// // // // // // // //               color: Colors.black87,
// // // // // // // //               overflow: TextOverflow.ellipsis,
// // // // // // // //             ),
// // // // // // // //             items: options
// // // // // // // //                 .map(
// // // // // // // //                   (e) => DropdownMenuItem<String>(
// // // // // // // //                     value: e,
// // // // // // // //                     child: Text(
// // // // // // // //                       e,
// // // // // // // //                       maxLines: 1,
// // // // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                 )
// // // // // // // //                 .toList(),
// // // // // // // //             selectedItemBuilder: (context) {
// // // // // // // //               return options
// // // // // // // //                   .map(
// // // // // // // //                     (e) => Align(
// // // // // // // //                       alignment: Alignment.centerLeft,
// // // // // // // //                       child: Text(
// // // // // // // //                         e,
// // // // // // // //                         maxLines: 1,
// // // // // // // //                         overflow: TextOverflow.ellipsis,
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   )
// // // // // // // //                   .toList();
// // // // // // // //             },
// // // // // // // //             onChanged: readOnly
// // // // // // // //                 ? null
// // // // // // // //                 : (value) {
// // // // // // // //                     if (value == null) return;
// // // // // // // //                     onFieldChanged(key, value);
// // // // // // // //                   },
// // // // // // // //             decoration: InputDecoration(
// // // // // // // //               isDense: true,
// // // // // // // //               contentPadding: const EdgeInsets.symmetric(
// // // // // // // //                 horizontal: 10,
// // // // // // // //                 vertical: 8,
// // // // // // // //               ),
// // // // // // // //               border: OutlineInputBorder(
// // // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // // //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // // //               ),
// // // // // // // //               enabledBorder: OutlineInputBorder(
// // // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // // //                 borderSide: BorderSide(
// // // // // // // //                     color: readOnly
// // // // // // // //                         ? const Color(0xFFF2F2F2)
// // // // // // // //                         : const Color(0xFFE8E0F2)),
// // // // // // // //               ),
// // // // // // // //               fillColor: readOnly ? const Color(0xFFF9F9F9) : null,
// // // // // // // //               filled: readOnly,
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _simpleTextField({
// // // // // // // //     required String label,
// // // // // // // //     required String initialValue,
// // // // // // // //     required void Function(String) onChanged,
// // // // // // // //     int maxLines = 1,
// // // // // // // //     bool readOnly = false,
// // // // // // // //   }) {
// // // // // // // //     return TextFormField(
// // // // // // // //       initialValue: initialValue,
// // // // // // // //       maxLines: maxLines,
// // // // // // // //       onChanged: onChanged,
// // // // // // // //       readOnly: readOnly,
// // // // // // // //       style: const TextStyle(fontSize: 12),
// // // // // // // //       decoration: InputDecoration(
// // // // // // // //         isDense: true,
// // // // // // // //         contentPadding: const EdgeInsets.symmetric(
// // // // // // // //           horizontal: 10,
// // // // // // // //           vertical: 10,
// // // // // // // //         ),
// // // // // // // //         border: OutlineInputBorder(
// // // // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // // // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // // //         ),
// // // // // // // //         enabledBorder: OutlineInputBorder(
// // // // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // // // //           borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _textFieldLabel(String text) {
// // // // // // // //     return Text(
// // // // // // // //       text,
// // // // // // // //       style: const TextStyle(
// // // // // // // //         fontSize: 11,
// // // // // // // //         fontWeight: FontWeight.w800,
// // // // // // // //         letterSpacing: 0.2,
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _languagesField(
// // // // // // // //     BuildContext context,
// // // // // // // //     String label,
// // // // // // // //     List<String> selectedValues,
// // // // // // // //     void Function(List<String>) onSaved, {
// // // // // // // //     bool readOnly = false,
// // // // // // // //   }) {
// // // // // // // //     return Padding(
// // // // // // // //       padding: const EdgeInsets.only(bottom: 8),
// // // // // // // //       child: Column(
// // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //         children: [
// // // // // // // //           _textFieldLabel(label),
// // // // // // // //           const SizedBox(height: 4),
// // // // // // // //           InkWell(
// // // // // // // //             onTap: readOnly
// // // // // // // //                 ? null
// // // // // // // //                 : () => _openLanguageSelector(context, selectedValues, onSaved),
// // // // // // // //             borderRadius: BorderRadius.circular(8),
// // // // // // // //             child: Container(
// // // // // // // //               width: double.infinity,
// // // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// // // // // // // //               decoration: BoxDecoration(
// // // // // // // //                 borderRadius: BorderRadius.circular(8),
// // // // // // // //                 border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // // // // //               ),
// // // // // // // //               child: Row(
// // // // // // // //                 children: [
// // // // // // // //                   Expanded(
// // // // // // // //                     child: Wrap(
// // // // // // // //                       spacing: 6,
// // // // // // // //                       runSpacing: 6,
// // // // // // // //                       children: selectedValues.isEmpty
// // // // // // // //                           ? [
// // // // // // // //                               Text(
// // // // // // // //                                 'Select languages',
// // // // // // // //                                 style: TextStyle(
// // // // // // // //                                   color: Colors.grey[600],
// // // // // // // //                                   fontSize: 12,
// // // // // // // //                                 ),
// // // // // // // //                               ),
// // // // // // // //                             ]
// // // // // // // //                           : selectedValues
// // // // // // // //                                 .map(
// // // // // // // //                                   (lang) => Container(
// // // // // // // //                                     padding: const EdgeInsets.symmetric(
// // // // // // // //                                       horizontal: 8,
// // // // // // // //                                       vertical: 2,
// // // // // // // //                                     ),
// // // // // // // //                                     decoration: BoxDecoration(
// // // // // // // //                                       color: const Color(0xFFF0F4FF),
// // // // // // // //                                       borderRadius: BorderRadius.circular(12),
// // // // // // // //                                       border: Border.all(
// // // // // // // //                                         color: const Color(0xFFD4DDF2),
// // // // // // // //                                       ),
// // // // // // // //                                     ),
// // // // // // // //                                     child: Text(
// // // // // // // //                                       lang,
// // // // // // // //                                       style: const TextStyle(fontSize: 11),
// // // // // // // //                                     ),
// // // // // // // //                                   ),
// // // // // // // //                                 )
// // // // // // // //                                 .toList(),
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                   const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
// // // // // // // //
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Future<void> _openLanguageSelector(
// // // // // // // //     BuildContext context,
// // // // // // // //     List<String> selectedValues,
// // // // // // // //     void Function(List<String>) onSaved,
// // // // // // // //   ) async {
// // // // // // // //     final temp = [...selectedValues];
// // // // // // // //     await showModalBottomSheet<void>(
// // // // // // // //       context: context,
// // // // // // // //       builder: (context) {
// // // // // // // //         return StatefulBuilder(
// // // // // // // //           builder: (context, setModalState) {
// // // // // // // //             return SafeArea(
// // // // // // // //               child: Padding(
// // // // // // // //                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
// // // // // // // //                 child: Column(
// // // // // // // //                   mainAxisSize: MainAxisSize.min,
// // // // // // // //                   children: [
// // // // // // // //                     const Text(
// // // // // // // //                       'Select Languages',
// // // // // // // //                       style: TextStyle(
// // // // // // // //                         fontWeight: FontWeight.w700,
// // // // // // // //                         fontSize: 16,
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                     const SizedBox(height: 10),
// // // // // // // //                     ..._languageOptions.map(
// // // // // // // //                       (lang) => CheckboxListTile(
// // // // // // // //                         dense: true,
// // // // // // // //                         value: temp.contains(lang),
// // // // // // // //                         onChanged: (checked) {
// // // // // // // //                           setModalState(() {
// // // // // // // //                             if (checked == true) {
// // // // // // // //                               if (!temp.contains(lang)) temp.add(lang);
// // // // // // // //                             } else {
// // // // // // // //                               temp.remove(lang);
// // // // // // // //                             }
// // // // // // // //                           });
// // // // // // // //                         },
// // // // // // // //                         title: Text(lang),
// // // // // // // //                         controlAffinity: ListTileControlAffinity.leading,
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                     const SizedBox(height: 8),
// // // // // // // //                     SizedBox(
// // // // // // // //                       width: double.infinity,
// // // // // // // //                       child: ElevatedButton(
// // // // // // // //                         onPressed: () {
// // // // // // // //                           onSaved(temp);
// // // // // // // //                           Navigator.pop(context);
// // // // // // // //                         },
// // // // // // // //                         child: const Text('Done'),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             );
// // // // // // // //           },
// // // // // // // //         );
// // // // // // // //       },
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   Widget _interestGroup({
// // // // // // // //     required String title,
// // // // // // // //     required bool expanded,
// // // // // // // //     required VoidCallback onToggle,
// // // // // // // //     required Map<String, bool> options,
// // // // // // // //     required double optionWidth,
// // // // // // // //     required void Function(String label, bool value) onChanged,
// // // // // // // //   }) {
// // // // // // // //     return Container(
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: Colors.white,
// // // // // // // //         borderRadius: BorderRadius.circular(10),
// // // // // // // //         border: Border.all(color: const Color(0xFFECE4F4)),
// // // // // // // //       ),
// // // // // // // //       child: Column(
// // // // // // // //         children: [
// // // // // // // //           InkWell(
// // // // // // // //             onTap: onToggle,
// // // // // // // //             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
// // // // // // // //             child: Container(
// // // // // // // //               height: 40,
// // // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 14),
// // // // // // // //               decoration: BoxDecoration(
// // // // // // // //                 gradient: const LinearGradient(
// // // // // // // //                   colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // // // //                 ),
// // // // // // // //                 borderRadius: BorderRadius.vertical(
// // // // // // // //                   top: const Radius.circular(10),
// // // // // // // //                   bottom: expanded ? Radius.zero : const Radius.circular(10),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               child: Row(
// // // // // // // //                 children: [
// // // // // // // //                   Expanded(
// // // // // // // //                     child: Text(
// // // // // // // //                       title,
// // // // // // // //                       maxLines: 1,
// // // // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // // // //                       style: const TextStyle(
// // // // // // // //                         color: Colors.white,
// // // // // // // //                         fontSize: 30,
// // // // // // // //                         fontWeight: FontWeight.w800,
// // // // // // // //                         height: 1.0,
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                   const SizedBox(width: 8),
// // // // // // // //                   CircleAvatar(
// // // // // // // //                     radius: 12,
// // // // // // // //                     backgroundColor: const Color(0xFFEACD71),
// // // // // // // //                     child: Icon(
// // // // // // // //                       expanded
// // // // // // // //                           ? Icons.keyboard_arrow_up
// // // // // // // //                           : Icons.keyboard_arrow_down,
// // // // // // // //                       size: 16,
// // // // // // // //                       color: Colors.black87,
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           if (expanded)
// // // // // // // //             Padding(
// // // // // // // //               padding: const EdgeInsets.all(10),
// // // // // // // //               child: Wrap(
// // // // // // // //                 spacing: 8,
// // // // // // // //                 runSpacing: 8,
// // // // // // // //                 children: options.entries
// // // // // // // //                     .map(
// // // // // // // //                       (entry) => _OptionChip(
// // // // // // // //                         label: entry.key,
// // // // // // // //                         selected: entry.value,
// // // // // // // //                         width: optionWidth,
// // // // // // // //                         onTap: () => onChanged(entry.key, !entry.value),
// // // // // // // //                       ),
// // // // // // // //                     )
// // // // // // // //                     .toList(),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }
// // // // // // // //
// // // // // // // // class _OptionChip extends StatelessWidget {
// // // // // // // //   const _OptionChip({
// // // // // // // //     required this.label,
// // // // // // // //     required this.selected,
// // // // // // // //     required this.width,
// // // // // // // //     required this.onTap,
// // // // // // // //   });
// // // // // // // //
// // // // // // // //   final String label;
// // // // // // // //   final bool selected;
// // // // // // // //   final double width;
// // // // // // // //   final VoidCallback onTap;
// // // // // // // //
// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     return InkWell(
// // // // // // // //       onTap: onTap,
// // // // // // // //       borderRadius: BorderRadius.circular(8),
// // // // // // // //       child: Container(
// // // // // // // //         width: width,
// // // // // // // //         height: 42,
// // // // // // // //         padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // // // // //         decoration: BoxDecoration(
// // // // // // // //           color: Colors.white,
// // // // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // // // //           border: Border.all(color: const Color(0xFFF1EBF8)),
// // // // // // // //         ),
// // // // // // // //         child: Row(
// // // // // // // //           children: [
// // // // // // // //             Expanded(
// // // // // // // //               child: Text(
// // // // // // // //                 label,
// // // // // // // //                 overflow: TextOverflow.ellipsis,
// // // // // // // //                 style: const TextStyle(
// // // // // // // //                   color: Colors.black87,
// // // // // // // //                   fontWeight: FontWeight.w500,
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //             Checkbox(
// // // // // // // //               value: selected,
// // // // // // // //               onChanged: (_) => onTap(),
// // // // // // // //               shape: RoundedRectangleBorder(
// // // // // // // //                 borderRadius: BorderRadius.circular(4),
// // // // // // // //               ),
// // // // // // // //               activeColor: const Color(0xFF47003D),
// // // // // // // //               side: const BorderSide(color: Color(0xFFE0D4EE)),
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }
// // // // // // // // //
// // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // // // import '../../../providers/profile_provider.dart';
// // // // // // // // // import '../../../core/constants.dart';
// // // // // // // // // import '../../../core/custom_text_field.dart';
// // // // // // // // //
// // // // // // // // // class EditTab extends ConsumerStatefulWidget {
// // // // // // // // //   const EditTab({super.key});
// // // // // // // // //
// // // // // // // // //   @override
// // // // // // // // //   ConsumerState<EditTab> createState() => _EditTabState();
// // // // // // // // // }
// // // // // // // // //
// // // // // // // // // class _EditTabState extends ConsumerState<EditTab> {
// // // // // // // // //   final _formKey = GlobalKey<FormState>();
// // // // // // // // //   bool _isInitialized = false;
// // // // // // // // //
// // // // // // // // //   @override
// // // // // // // // //   void didChangeDependencies() {
// // // // // // // // //     super.didChangeDependencies();
// // // // // // // // //     if (!_isInitialized) {
// // // // // // // // //       final profile = ref.read(profileProvider).profile;
// // // // // // // // //       if (profile != null) {
// // // // // // // // //         ref.read(editFormProvider.notifier).initFromProfile(profile);
// // // // // // // // //         _isInitialized = true;
// // // // // // // // //       }
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   @override
// // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // //     final profileState = ref.watch(profileProvider);
// // // // // // // // //     final formState = ref.watch(editFormProvider);
// // // // // // // // //     final profile = profileState.profile;
// // // // // // // // //
// // // // // // // // //     if (profile == null) {
// // // // // // // // //       return const Center(
// // // // // // // // //         child: Text(
// // // // // // // // //           'Please load your profile first',
// // // // // // // // //           style: AppTextStyles.bodyLarge,
// // // // // // // // //         ),
// // // // // // // // //       );
// // // // // // // // //     }
// // // // // // // // //
// // // // // // // // //     return SingleChildScrollView(
// // // // // // // // //       physics: const BouncingScrollPhysics(),
// // // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // // //       child: Form(
// // // // // // // // //         key: _formKey,
// // // // // // // // //         child: Column(
// // // // // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // //           children: [
// // // // // // // // //             // Section Header
// // // // // // // // //             _buildSectionHeader('Profile Information', Icons.person_outline),
// // // // // // // // //             const SizedBox(height: 16),
// // // // // // // // //
// // // // // // // // //             // Name fields based on profile type
// // // // // // // // //             if (profile.isSingle)
// // // // // // // // //               CustomTextField(
// // // // // // // // //                 label: 'Full Name',
// // // // // // // // //                 initialValue: formState.formData['single_full_name'] ?? '',
// // // // // // // // //                 onChanged: (val) => ref
// // // // // // // // //                     .read(editFormProvider.notifier)
// // // // // // // // //                     .updateField('single_full_name', val),
// // // // // // // // //                 validator: (val) =>
// // // // // // // // //                 val == null || val.isEmpty ? 'Name is required' : null,
// // // // // // // // //               )
// // // // // // // // //             else ...[
// // // // // // // // //               CustomTextField(
// // // // // // // // //                 label: '${profile.person1Name} Full Name',
// // // // // // // // //                 initialValue:
// // // // // // // // //                 formState.formData['couple_full_name_from'] ?? '',
// // // // // // // // //                 onChanged: (val) => ref
// // // // // // // // //                     .read(editFormProvider.notifier)
// // // // // // // // //                     .updateField('couple_full_name_from', val),
// // // // // // // // //               ),
// // // // // // // // //               CustomTextField(
// // // // // // // // //                 label: '${profile.person2Name} Full Name',
// // // // // // // // //                 initialValue:
// // // // // // // // //                 formState.formData['couple_full_name_to'] ?? '',
// // // // // // // // //                 onChanged: (val) => ref
// // // // // // // // //                     .read(editFormProvider.notifier)
// // // // // // // // //                     .updateField('couple_full_name_to', val),
// // // // // // // // //               ),
// // // // // // // // //             ],
// // // // // // // // //
// // // // // // // // //             // About Me
// // // // // // // // //             CustomTextField(
// // // // // // // // //               label: 'About Me',
// // // // // // // // //               hint: 'Tell others about yourself...',
// // // // // // // // //               initialValue: formState.formData['text'] ?? '',
// // // // // // // // //               maxLines: 4,
// // // // // // // // //               onChanged: (val) => ref
// // // // // // // // //                   .read(editFormProvider.notifier)
// // // // // // // // //                   .updateField('text', val),
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             // Comment
// // // // // // // // //             CustomTextField(
// // // // // // // // //               label: 'Comment',
// // // // // // // // //               hint: 'Add a comment...',
// // // // // // // // //               initialValue: formState.formData['comment'] ?? '',
// // // // // // // // //               maxLines: 3,
// // // // // // // // //               onChanged: (val) => ref
// // // // // // // // //                   .read(editFormProvider.notifier)
// // // // // // // // //                   .updateField('comment', val),
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             const SizedBox(height: 24),
// // // // // // // // //
// // // // // // // // //             // Person 1 Physical Details
// // // // // // // // //             _buildSectionHeader(
// // // // // // // // //               profile.isSingle
// // // // // // // // //                   ? 'Physical Details'
// // // // // // // // //                   : '${profile.person1Name} Physical Details',
// // // // // // // // //               Icons.accessibility_new,
// // // // // // // // //             ),
// // // // // // // // //             const SizedBox(height: 16),
// // // // // // // // //
// // // // // // // // //             Row(
// // // // // // // // //               children: [
// // // // // // // // //                 Expanded(
// // // // // // // // //                   child: CustomTextField(
// // // // // // // // //                     label: 'Height',
// // // // // // // // //                     hint: 'e.g. 5\'10"',
// // // // // // // // //                     initialValue:
// // // // // // // // //                     formState.formData['person1_height'] ?? '',
// // // // // // // // //                     onChanged: (val) => ref
// // // // // // // // //                         .read(editFormProvider.notifier)
// // // // // // // // //                         .updateField('person1_height', val),
// // // // // // // // //                   ),
// // // // // // // // //                 ),
// // // // // // // // //                 const SizedBox(width: 12),
// // // // // // // // //                 Expanded(
// // // // // // // // //                   child: CustomTextField(
// // // // // // // // //                     label: 'Weight',
// // // // // // // // //                     hint: 'e.g. 75 kg',
// // // // // // // // //                     initialValue:
// // // // // // // // //                     formState.formData['person1_weight'] ?? '',
// // // // // // // // //                     onChanged: (val) => ref
// // // // // // // // //                         .read(editFormProvider.notifier)
// // // // // // // // //                         .updateField('person1_weight', val),
// // // // // // // // //                   ),
// // // // // // // // //                 ),
// // // // // // // // //               ],
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             CustomDropdownField(
// // // // // // // // //               label: 'Body Type',
// // // // // // // // //               value: formState.formData['person1_body_type'],
// // // // // // // // //               items: const [
// // // // // // // // //                 'Slim', 'Athletic', 'Average', 'Curvy', 'Muscular',
// // // // // // // // //                 'Heavyset', 'Petite',
// // // // // // // // //               ],
// // // // // // // // //               onChanged: (val) {
// // // // // // // // //                 if (val != null) {
// // // // // // // // //                   ref
// // // // // // // // //                       .read(editFormProvider.notifier)
// // // // // // // // //                       .updateField('person1_body_type', val);
// // // // // // // // //                 }
// // // // // // // // //               },
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             CustomDropdownField(
// // // // // // // // //               label: 'Ethnic Background',
// // // // // // // // //               value: formState.formData['person1_ethnic_background'],
// // // // // // // // //               items: const [
// // // // // // // // //                 'Asian', 'Black', 'Caucasian', 'Hispanic', 'Indian',
// // // // // // // // //                 'Middle Eastern', 'Mixed', 'Other',
// // // // // // // // //               ],
// // // // // // // // //               onChanged: (val) {
// // // // // // // // //                 if (val != null) {
// // // // // // // // //                   ref
// // // // // // // // //                       .read(editFormProvider.notifier)
// // // // // // // // //                       .updateField('person1_ethnic_background', val);
// // // // // // // // //                 }
// // // // // // // // //               },
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             const SizedBox(height: 24),
// // // // // // // // //
// // // // // // // // //             // Person 1 Lifestyle
// // // // // // // // //             _buildSectionHeader(
// // // // // // // // //               profile.isSingle
// // // // // // // // //                   ? 'Lifestyle'
// // // // // // // // //                   : '${profile.person1Name} Lifestyle',
// // // // // // // // //               Icons.favorite_outline,
// // // // // // // // //             ),
// // // // // // // // //             const SizedBox(height: 16),
// // // // // // // // //
// // // // // // // // //             CustomDropdownField(
// // // // // // // // //               label: 'Smoking',
// // // // // // // // //               value: formState.formData['person1_smoking'],
// // // // // // // // //               items: const ['Non-Smoker', 'Social Smoker', 'Regular Smoker'],
// // // // // // // // //               onChanged: (val) {
// // // // // // // // //                 if (val != null) {
// // // // // // // // //                   ref
// // // // // // // // //                       .read(editFormProvider.notifier)
// // // // // // // // //                       .updateField('person1_smoking', val);
// // // // // // // // //                 }
// // // // // // // // //               },
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             CustomDropdownField(
// // // // // // // // //               label: 'Drinking',
// // // // // // // // //               value: formState.formData['person1_drinking'],
// // // // // // // // //               items: const [
// // // // // // // // //                 'Non-Drinker', 'Social Drinker', 'Regular Drinker',
// // // // // // // // //               ],
// // // // // // // // //               onChanged: (val) {
// // // // // // // // //                 if (val != null) {
// // // // // // // // //                   ref
// // // // // // // // //                       .read(editFormProvider.notifier)
// // // // // // // // //                       .updateField('person1_drinking', val);
// // // // // // // // //                 }
// // // // // // // // //               },
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             CustomDropdownField(
// // // // // // // // //               label: 'Sexuality',
// // // // // // // // //               value: formState.formData['person1_sexuality'],
// // // // // // // // //               items: const [
// // // // // // // // //                 'Straight', 'Gay', 'Lesbian', 'Bisexual', 'Pansexual',
// // // // // // // // //                 'Asexual', 'Other',
// // // // // // // // //               ],
// // // // // // // // //               onChanged: (val) {
// // // // // // // // //                 if (val != null) {
// // // // // // // // //                   ref
// // // // // // // // //                       .read(editFormProvider.notifier)
// // // // // // // // //                       .updateField('person1_sexuality', val);
// // // // // // // // //                 }
// // // // // // // // //               },
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             CustomDropdownField(
// // // // // // // // //               label: 'Relationship Orientation',
// // // // // // // // //               value:
// // // // // // // // //               formState.formData['person1_relationship_orientation'],
// // // // // // // // //               items: const [
// // // // // // // // //                 'Monogamous', 'Open', 'Polyamorous', 'Swinger',
// // // // // // // // //                 'Other',
// // // // // // // // //               ],
// // // // // // // // //               onChanged: (val) {
// // // // // // // // //                 if (val != null) {
// // // // // // // // //                   ref.read(editFormProvider.notifier).updateField(
// // // // // // // // //                       'person1_relationship_orientation', val);
// // // // // // // // //                 }
// // // // // // // // //               },
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             // Person 2 fields (Couple only)
// // // // // // // // //             if (profile.isCouple) ...[
// // // // // // // // //               const SizedBox(height: 32),
// // // // // // // // //               _buildSectionHeader(
// // // // // // // // //                 '${profile.person2Name} Physical Details',
// // // // // // // // //                 Icons.accessibility_new,
// // // // // // // // //               ),
// // // // // // // // //               const SizedBox(height: 16),
// // // // // // // // //
// // // // // // // // //               Row(
// // // // // // // // //                 children: [
// // // // // // // // //                   Expanded(
// // // // // // // // //                     child: CustomTextField(
// // // // // // // // //                       label: 'Height',
// // // // // // // // //                       hint: 'e.g. 5\'6"',
// // // // // // // // //                       initialValue:
// // // // // // // // //                       formState.formData['person2_height'] ?? '',
// // // // // // // // //                       onChanged: (val) => ref
// // // // // // // // //                           .read(editFormProvider.notifier)
// // // // // // // // //                           .updateField('person2_height', val),
// // // // // // // // //                     ),
// // // // // // // // //                   ),
// // // // // // // // //                   const SizedBox(width: 12),
// // // // // // // // //                   Expanded(
// // // // // // // // //                     child: CustomTextField(
// // // // // // // // //                       label: 'Weight',
// // // // // // // // //                       hint: 'e.g. 60 kg',
// // // // // // // // //                       initialValue:
// // // // // // // // //                       formState.formData['person2_weight'] ?? '',
// // // // // // // // //                       onChanged: (val) => ref
// // // // // // // // //                           .read(editFormProvider.notifier)
// // // // // // // // //                           .updateField('person2_weight', val),
// // // // // // // // //                     ),
// // // // // // // // //                   ),
// // // // // // // // //                 ],
// // // // // // // // //               ),
// // // // // // // // //
// // // // // // // // //               CustomDropdownField(
// // // // // // // // //                 label: 'Body Type',
// // // // // // // // //                 value: formState.formData['person2_body_type'],
// // // // // // // // //                 items: const [
// // // // // // // // //                   'Slim', 'Athletic', 'Average', 'Curvy', 'Muscular',
// // // // // // // // //                   'Heavyset', 'Petite',
// // // // // // // // //                 ],
// // // // // // // // //                 onChanged: (val) {
// // // // // // // // //                   if (val != null) {
// // // // // // // // //                     ref
// // // // // // // // //                         .read(editFormProvider.notifier)
// // // // // // // // //                         .updateField('person2_body_type', val);
// // // // // // // // //                   }
// // // // // // // // //                 },
// // // // // // // // //               ),
// // // // // // // // //
// // // // // // // // //               CustomDropdownField(
// // // // // // // // //                 label: 'Ethnic Background',
// // // // // // // // //                 value: formState.formData['person2_ethnic_background'],
// // // // // // // // //                 items: const [
// // // // // // // // //                   'Asian', 'Black', 'Caucasian', 'Hispanic', 'Indian',
// // // // // // // // //                   'Middle Eastern', 'Mixed', 'Other',
// // // // // // // // //                 ],
// // // // // // // // //                 onChanged: (val) {
// // // // // // // // //                   if (val != null) {
// // // // // // // // //                     ref.read(editFormProvider.notifier).updateField(
// // // // // // // // //                         'person2_ethnic_background', val);
// // // // // // // // //                   }
// // // // // // // // //                 },
// // // // // // // // //               ),
// // // // // // // // //
// // // // // // // // //               const SizedBox(height: 24),
// // // // // // // // //
// // // // // // // // //               _buildSectionHeader(
// // // // // // // // //                 '${profile.person2Name} Lifestyle',
// // // // // // // // //                 Icons.favorite_outline,
// // // // // // // // //               ),
// // // // // // // // //               const SizedBox(height: 16),
// // // // // // // // //
// // // // // // // // //               CustomDropdownField(
// // // // // // // // //                 label: 'Smoking',
// // // // // // // // //                 value: formState.formData['person2_smoking'],
// // // // // // // // //                 items: const [
// // // // // // // // //                   'Non-Smoker', 'Social Smoker', 'Regular Smoker',
// // // // // // // // //                 ],
// // // // // // // // //                 onChanged: (val) {
// // // // // // // // //                   if (val != null) {
// // // // // // // // //                     ref
// // // // // // // // //                         .read(editFormProvider.notifier)
// // // // // // // // //                         .updateField('person2_smoking', val);
// // // // // // // // //                   }
// // // // // // // // //                 },
// // // // // // // // //               ),
// // // // // // // // //
// // // // // // // // //               CustomDropdownField(
// // // // // // // // //                 label: 'Drinking',
// // // // // // // // //                 value: formState.formData['person2_drinking'],
// // // // // // // // //                 items: const [
// // // // // // // // //                   'Non-Drinker', 'Social Drinker', 'Regular Drinker',
// // // // // // // // //                 ],
// // // // // // // // //                 onChanged: (val) {
// // // // // // // // //                   if (val != null) {
// // // // // // // // //                     ref
// // // // // // // // //                         .read(editFormProvider.notifier)
// // // // // // // // //                         .updateField('person2_drinking', val);
// // // // // // // // //                   }
// // // // // // // // //                 },
// // // // // // // // //               ),
// // // // // // // // //
// // // // // // // // //               CustomDropdownField(
// // // // // // // // //                 label: 'Sexuality',
// // // // // // // // //                 value: formState.formData['person2_sexuality'],
// // // // // // // // //                 items: const [
// // // // // // // // //                   'Straight', 'Gay', 'Lesbian', 'Bisexual', 'Pansexual',
// // // // // // // // //                   'Asexual', 'Other',
// // // // // // // // //                 ],
// // // // // // // // //                 onChanged: (val) {
// // // // // // // // //                   if (val != null) {
// // // // // // // // //                     ref
// // // // // // // // //                         .read(editFormProvider.notifier)
// // // // // // // // //                         .updateField('person2_sexuality', val);
// // // // // // // // //                   }
// // // // // // // // //                 },
// // // // // // // // //               ),
// // // // // // // // //
// // // // // // // // //               CustomDropdownField(
// // // // // // // // //                 label: 'Relationship Orientation',
// // // // // // // // //                 value: formState
// // // // // // // // //                     .formData['person2_relationship_orientation'],
// // // // // // // // //                 items: const [
// // // // // // // // //                   'Monogamous', 'Open', 'Polyamorous', 'Swinger',
// // // // // // // // //                   'Other',
// // // // // // // // //                 ],
// // // // // // // // //                 onChanged: (val) {
// // // // // // // // //                   if (val != null) {
// // // // // // // // //                     ref.read(editFormProvider.notifier).updateField(
// // // // // // // // //                         'person2_relationship_orientation', val);
// // // // // // // // //                   }
// // // // // // // // //                 },
// // // // // // // // //               ),
// // // // // // // // //             ],
// // // // // // // // //
// // // // // // // // //             const SizedBox(height: 32),
// // // // // // // // //
// // // // // // // // //             // Save Button
// // // // // // // // //             SizedBox(
// // // // // // // // //               width: double.infinity,
// // // // // // // // //               height: 52,
// // // // // // // // //               child: ElevatedButton(
// // // // // // // // //                 onPressed: formState.isSaving ? null : () => _saveProfile(),
// // // // // // // // //                 style: ElevatedButton.styleFrom(
// // // // // // // // //                   backgroundColor: AppColors.primary,
// // // // // // // // //                   foregroundColor: Colors.white,
// // // // // // // // //                   shape: RoundedRectangleBorder(
// // // // // // // // //                     borderRadius: BorderRadius.circular(14),
// // // // // // // // //                   ),
// // // // // // // // //                   elevation: 4,
// // // // // // // // //                   shadowColor: AppColors.primary.withOpacity(0.5),
// // // // // // // // //                 ),
// // // // // // // // //                 child: formState.isSaving
// // // // // // // // //                     ? const SizedBox(
// // // // // // // // //                   width: 24,
// // // // // // // // //                   height: 24,
// // // // // // // // //                   child: CircularProgressIndicator(
// // // // // // // // //                     color: Colors.white,
// // // // // // // // //                     strokeWidth: 2.5,
// // // // // // // // //                   ),
// // // // // // // // //                 )
// // // // // // // // //                     : Row(
// // // // // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // // //                   children: [
// // // // // // // // //                     Icon(
// // // // // // // // //                       formState.isSaved
// // // // // // // // //                           ? Icons.check_circle
// // // // // // // // //                           : Icons.save,
// // // // // // // // //                       size: 20,
// // // // // // // // //                     ),
// // // // // // // // //                     const SizedBox(width: 8),
// // // // // // // // //                     Text(
// // // // // // // // //                       formState.isSaved
// // // // // // // // //                           ? 'Saved Successfully!'
// // // // // // // // //                           : 'Save Changes',
// // // // // // // // //                       style: const TextStyle(
// // // // // // // // //                         fontSize: 16,
// // // // // // // // //                         fontWeight: FontWeight.w600,
// // // // // // // // //                       ),
// // // // // // // // //                     ),
// // // // // // // // //                   ],
// // // // // // // // //                 ),
// // // // // // // // //               ),
// // // // // // // // //             ),
// // // // // // // // //
// // // // // // // // //             if (formState.error != null) ...[
// // // // // // // // //               const SizedBox(height: 12),
// // // // // // // // //               Container(
// // // // // // // // //                 padding: const EdgeInsets.all(12),
// // // // // // // // //                 decoration: BoxDecoration(
// // // // // // // // //                   color: AppColors.error.withOpacity(0.1),
// // // // // // // // //                   borderRadius: BorderRadius.circular(8),
// // // // // // // // //                   border: Border.all(
// // // // // // // // //                     color: AppColors.error.withOpacity(0.3),
// // // // // // // // //                   ),
// // // // // // // // //                 ),
// // // // // // // // //                 child: Row(
// // // // // // // // //                   children: [
// // // // // // // // //                     const Icon(Icons.error, color: AppColors.error, size: 20),
// // // // // // // // //                     const SizedBox(width: 8),
// // // // // // // // //                     Expanded(
// // // // // // // // //                       child: Text(
// // // // // // // // //                         formState.error!,
// // // // // // // // //                         style: const TextStyle(color: AppColors.error),
// // // // // // // // //                       ),
// // // // // // // // //                     ),
// // // // // // // // //                   ],
// // // // // // // // //                 ),
// // // // // // // // //               ),
// // // // // // // // //             ],
// // // // // // // // //
// // // // // // // // //             const SizedBox(height: 32),
// // // // // // // // //           ],
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   Widget _buildSectionHeader(String title, IconData icon) {
// // // // // // // // //     return Row(
// // // // // // // // //       children: [
// // // // // // // // //         Container(
// // // // // // // // //           padding: const EdgeInsets.all(8),
// // // // // // // // //           decoration: BoxDecoration(
// // // // // // // // //             color: AppColors.primary.withOpacity(0.15),
// // // // // // // // //             borderRadius: BorderRadius.circular(10),
// // // // // // // // //           ),
// // // // // // // // //           child: Icon(icon, color: AppColors.primary, size: 20),
// // // // // // // // //         ),
// // // // // // // // //         const SizedBox(width: 12),
// // // // // // // // //         Text(title, style: AppTextStyles.heading2),
// // // // // // // // //       ],
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   Future<void> _saveProfile() async {
// // // // // // // // //     if (!_formKey.currentState!.validate()) return;
// // // // // // // // //
// // // // // // // // //     final notifier = ref.read(editFormProvider.notifier);
// // // // // // // // //     notifier.setSaving(true);
// // // // // // // // //
// // // // // // // // //     try {
// // // // // // // // //       final formData = ref.read(editFormProvider).formData;
// // // // // // // // //       await ref
// // // // // // // // //           .read(profileProvider.notifier)
// // // // // // // // //           .updateProfile(formData);
// // // // // // // // //       notifier.setSaved(true);
// // // // // // // // //       notifier.setSaving(false);
// // // // // // // // //
// // // // // // // // //       if (mounted) {
// // // // // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // // //           SnackBar(
// // // // // // // // //             content: const Row(
// // // // // // // // //               children: [
// // // // // // // // //                 Icon(Icons.check_circle, color: Colors.white, size: 20),
// // // // // // // // //                 SizedBox(width: 8),
// // // // // // // // //                 Text('Profile updated successfully!'),
// // // // // // // // //               ],
// // // // // // // // //             ),
// // // // // // // // //             backgroundColor: AppColors.success,
// // // // // // // // //             behavior: SnackBarBehavior.floating,
// // // // // // // // //             shape: RoundedRectangleBorder(
// // // // // // // // //               borderRadius: BorderRadius.circular(10),
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //         );
// // // // // // // // //       }
// // // // // // // // //     } catch (e) {
// // // // // // // // //       notifier.setSaving(false);
// // // // // // // // //       notifier.setError('Failed to save profile. Please try again.');
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // // }
