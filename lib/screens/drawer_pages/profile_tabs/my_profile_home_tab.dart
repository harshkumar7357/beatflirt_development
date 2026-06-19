import 'dart:convert';

import 'package:beatflirt/core/services/token_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// CONFIG
// ============================================================================

const String _apiBase = 'https://app.beatflirtevent.com/App';
const String _webBase = 'https://beatflirtevent.com/';
const String _assetBase = 'https://app.beatflirtevent.com/assets/';

String _resolveMediaUrl(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return '';
  if (value.startsWith('http://') || value.startsWith('https://')) return value;
  if (value.startsWith('//')) return 'https:$value';
  if (value.startsWith('assets/')) return '$_webBase$value';
  if (value.startsWith('/assets/')) return '$_webBase${value.substring(1)}';
  if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
  return '$_assetBase$value';
}

String _str(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final s = value.toString();
  return s.trim().isEmpty ? fallback : s;
}

int _intValue(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? fallback;
}

// ============================================================================
// TOKEN HELPERS
// ============================================================================

class _TokenBundle {
  const _TokenBundle({required this.token, required this.sign});

  final String token;
  final String sign;
}

Future<_TokenBundle> _readTokens() async {
  final prefs = await SharedPreferences.getInstance();

  String? token;

  try {
    token = await TokenService().getAccessToken();
  } catch (_) {
    token = null;
  }

  token ??= prefs.getString('Access-Token') ??
      prefs.getString('access_token') ??
      prefs.getString('token') ??
      prefs.getString('auth_token') ??
      '';

  final sign = prefs.getString('Access-Sign') ??
      prefs.getString('access_sign') ??
      prefs.getString('sign') ??
      '';

  return _TokenBundle(token: token, sign: sign);
}

Map<String, String> _authHeaders(_TokenBundle tokens) {
  return {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    if (tokens.token.isNotEmpty) 'Access-Token': tokens.token,
    if (tokens.sign.isNotEmpty) 'Access-Sign': tokens.sign,
  };
}

// ============================================================================
// MODEL
// ============================================================================

class ViewSingleProfileData {
  ViewSingleProfileData({required this.raw});

  final Map<String, dynamic> raw;

  factory ViewSingleProfileData.fromJson(Map<String, dynamic> json) {
    return ViewSingleProfileData(raw: json);
  }

  String get id => _str(raw['id']);
  String get username => _str(raw['username']);
  String get email => _str(raw['email']);
  String get profileType => _str(raw['profile_type']);
  String get genderProfileType => _str(raw['gender_profile_type']);

  String get singleFullName => _str(raw['single_full_name']);
  String get coupleFullNameFrom => _str(raw['couple_full_name_from']);
  String get coupleFullNameTo => _str(raw['couple_full_name_to']);

  String get address => _str(raw['address']);
  String get city => _str(raw['city']);
  String get address1 => _str(raw['address_1']);
  String get city1 => _str(raw['city_1']);

  String get person1Dob => _str(raw['person1_dob']);
  String get person2Dob => _str(raw['person2_dob']);

  int get age => _intValue(raw['age']);
  int get age2 => _intValue(raw['age2']);

  String get person1Name {
    final v = _str(raw['person1_name']);
    if (v.isNotEmpty) return v;
    if (singleFullName.isNotEmpty) return singleFullName;
    return 'Person 1';
  }

  String get person2Name {
    final v = _str(raw['person2_name']);
    if (v.isNotEmpty) return v;
    return 'Person 2';
  }

  String? get text => raw['text']?.toString();
  String? get comment => raw['comment']?.toString();

  String? get person1BodyHair => raw['person1_body_hair']?.toString();
  String? get height1Type => raw['height1_type']?.toString();
  String? get weight1Type => raw['weight1_type']?.toString();
  String? get person1Height => raw['person1_height']?.toString();
  String? get person1Weight => raw['person1_weight']?.toString();
  String? get person1BodyType => raw['person1_body_type']?.toString();
  String? get person1EthnicBackground => raw['person1_ethnic_background']?.toString();
  String? get person1Piercings => raw['person1_piercings']?.toString();
  String? get person1Tattoos => raw['person1_tattoos']?.toString();
  String? get person1LanguageSpoken => raw['person1_language_spoken']?.toString();
  String? get person1Circumcised => raw['person1_circumcised']?.toString();
  String? get person1Smoking => raw['person1_smoking']?.toString();
  String? get person1Drinking => raw['person1_drinking']?.toString();
  String? get person1IntelligenceImportance => raw['person1_intelligence_importance']?.toString();
  String? get person1Sexuality => raw['person1_sexuality']?.toString();
  String? get person1RelationshipOrientation => raw['person1_relationship_orientation']?.toString();
  String? get person1LooksImportant => raw['person1_looks_important']?.toString();

  String? get person2BodyHair => raw['person2_body_hair']?.toString();
  String? get height2Type => raw['height2_type']?.toString();
  String? get weight2Type => raw['weight2_type']?.toString();
  String? get person2Height => raw['person2_height']?.toString();
  String? get person2Weight => raw['person2_weight']?.toString();
  String? get person2BodyType => raw['person2_body_type']?.toString();
  String? get person2EthnicBackground => raw['person2_ethnic_background']?.toString();
  String? get person2Piercings => raw['person2_piercings']?.toString();
  String? get person2Tattoos => raw['person2_tattoos']?.toString();
  String? get person2LanguageSpoken => raw['person2_language_spoken']?.toString();
  String? get person2Circumcised => raw['person2_circumcised']?.toString();
  String? get person2Smoking => raw['person2_smoking']?.toString();
  String? get person2Drinking => raw['person2_drinking']?.toString();
  String? get person2IntelligenceImportance => raw['person2_intelligence_importance']?.toString();
  String? get person2Sexuality => raw['person2_sexuality']?.toString();
  String? get person2RelationshipOrientation => raw['person2_relationship_orientation']?.toString();
  String? get person2LooksImportant => raw['person2_looks_important']?.toString();

  bool get isCouple => profileType.toLowerCase() == 'couple';
}

class ProfileHomeImageResult {
  const ProfileHomeImageResult({
    required this.imageUrl,
    required this.rawImage,
    required this.imageId,
    required this.isMain,
  });

  final String imageUrl;
  final String rawImage;
  final String imageId;
  final bool isMain;
}

class ViewSingleProfileState {
  const ViewSingleProfileState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.data,
    this.homeImage,
  });

  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final ViewSingleProfileData? data;
  final ProfileHomeImageResult? homeImage;

  ViewSingleProfileState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    ViewSingleProfileData? data,
    ProfileHomeImageResult? homeImage,
  }) {
    return ViewSingleProfileState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      homeImage: homeImage ?? this.homeImage,
    );
  }
}

// ============================================================================
// PROVIDER
// ============================================================================

final viewSingleProfileProvider = NotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
  ViewSingleProfileNotifier.new,
);

class ViewSingleProfileNotifier extends Notifier<ViewSingleProfileState> {
  @override
  ViewSingleProfileState build() {
    return const ViewSingleProfileState();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(
      isLoading: true,
      isError: false,
      errorMessage: '',
    );

    try {
      final tokens = await _readTokens();

      if (tokens.token.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          errorMessage: 'Authentication token is missing. Please log in again.',
        );
        return;
      }

      final profile = await _fetchProfile(tokens);
      final image = await fetchProfileHomeTabImage(
        accessToken: tokens.token,
        accessSign: tokens.sign,
      );

      state = state.copyWith(
        isLoading: false,
        isError: false,
        errorMessage: '',
        data: profile,
        homeImage: image,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: 'Error: $e',
      );
    }
  }

  Future<ViewSingleProfileData> _fetchProfile(_TokenBundle tokens) async {
    final uri = Uri.parse('$_apiBase/user/signle_user_profile');

    final response = await http.get(
      uri,
      headers: _authHeaders(tokens),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid profile response');
    }

    if (decoded['status']?.toString() != '200' || decoded['data'] == null) {
      throw Exception(decoded['message']?.toString() ?? 'Invalid response format');
    }

    final profile = ViewSingleProfileData.fromJson(
      Map<String, dynamic>.from(decoded['data'] as Map),
    );

    return _mergeLocalCache(profile);
  }

  Future<ViewSingleProfileData> _mergeLocalCache(ViewSingleProfileData profile) async {
    // Optional local cache merge. Keeps your previous behavior but safe.
    if (profile.id.isEmpty) return profile;

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'cached_profile_details_${profile.id}';
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr == null || cachedStr.isEmpty) return profile;

      final cached = jsonDecode(cachedStr);
      if (cached is! Map) return profile;

      final raw = Map<String, dynamic>.from(profile.raw);

      void useCacheIfEmpty(String apiKey, String cacheKey) {
        final current = raw[apiKey]?.toString();
        final cachedVal = cached[cacheKey]?.toString();
        final shouldUse = current == null ||
            current.isEmpty ||
            current == "I'm not comfortable sharing that." ||
            current == 'Im not comfortable sharing that';
        if (shouldUse && cachedVal != null && cachedVal.isNotEmpty) {
          raw[apiKey] = cachedVal;
        }
      }

      useCacheIfEmpty('text', 'aboutMe');
      useCacheIfEmpty('comment', 'lookingFor');
      useCacheIfEmpty('person1_name', 'person1Name');
      useCacheIfEmpty('person2_name', 'person2Name');
      useCacheIfEmpty('person1_dob', 'partner1_dateOfBirth');
      useCacheIfEmpty('person1_height', 'partner1_height');
      useCacheIfEmpty('height1_type', 'partner1_heightType');
      useCacheIfEmpty('person1_weight', 'partner1_weight');
      useCacheIfEmpty('weight1_type', 'partner1_weightType');
      useCacheIfEmpty('person1_body_type', 'partner1_bodyType');
      useCacheIfEmpty('person1_ethnic_background', 'partner1_ethnic');
      useCacheIfEmpty('person1_sexuality', 'partner1_sexuality');
      useCacheIfEmpty('person1_relationship_orientation', 'partner1_orientation');
      useCacheIfEmpty('person1_tattoos', 'partner1_tattoos');
      useCacheIfEmpty('person1_piercings', 'partner1_piercings');
      useCacheIfEmpty('person1_smoking', 'partner1_smoking');
      useCacheIfEmpty('person1_drinking', 'partner1_drinking');
      useCacheIfEmpty('person1_body_hair', 'partner1_bodyHair');
      useCacheIfEmpty('person1_looks_important', 'partner1_looks');
      useCacheIfEmpty('person1_intelligence_importance', 'partner1_intelligence');
      useCacheIfEmpty('person1_circumcised', 'partner1_circumcised');

      useCacheIfEmpty('person2_dob', 'partner2_dateOfBirth');
      useCacheIfEmpty('person2_height', 'partner2_height');
      useCacheIfEmpty('height2_type', 'partner2_heightType');
      useCacheIfEmpty('person2_weight', 'partner2_weight');
      useCacheIfEmpty('weight2_type', 'partner2_weightType');
      useCacheIfEmpty('person2_body_type', 'partner2_bodyType');
      useCacheIfEmpty('person2_ethnic_background', 'partner2_ethnic');
      useCacheIfEmpty('person2_sexuality', 'partner2_sexuality');
      useCacheIfEmpty('person2_relationship_orientation', 'partner2_orientation');
      useCacheIfEmpty('person2_tattoos', 'partner2_tattoos');
      useCacheIfEmpty('person2_piercings', 'partner2_piercings');
      useCacheIfEmpty('person2_smoking', 'partner2_smoking');
      useCacheIfEmpty('person2_drinking', 'partner2_drinking');
      useCacheIfEmpty('person2_body_hair', 'partner2_bodyHair');
      useCacheIfEmpty('person2_looks_important', 'partner2_looks');
      useCacheIfEmpty('person2_intelligence_importance', 'partner2_intelligence');
      useCacheIfEmpty('person2_circumcised', 'partner2_circumcised');

      return ViewSingleProfileData.fromJson(raw);
    } catch (_) {
      return profile;
    }
  }
}

// ============================================================================
// PROFILE IMAGE FETCH FUNCTION
// ============================================================================

Future<ProfileHomeImageResult?> fetchProfileHomeTabImage({
  String? accessToken,
  String? accessSign,
  http.Client? client,
}) async {
  final prefs = await SharedPreferences.getInstance();

  final token = accessToken ??
      prefs.getString('Access-Token') ??
      prefs.getString('access_token') ??
      prefs.getString('token') ??
      '';

  final sign = accessSign ??
      prefs.getString('Access-Sign') ??
      prefs.getString('access_sign') ??
      prefs.getString('sign') ??
      '';

  if (token.isEmpty) return null;

  final httpClient = client ?? http.Client();

  final response = await httpClient.get(
    Uri.parse('$_apiBase/user/signle_user_profile_image'),
    headers: _authHeaders(_TokenBundle(token: token, sign: sign)),
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception(
      'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Profile image request failed'}',
    );
  }

  final decoded = jsonDecode(response.body);

  if (decoded is! Map || decoded['status']?.toString() != '200') {
    return null;
  }

  final data = decoded['data'];

  if (data is! List || data.isEmpty) {
    return null;
  }

  Map<String, dynamic>? selectedImage;

  for (final item in data) {
    if (item is Map && item['set_profile']?.toString() == '1') {
      selectedImage = Map<String, dynamic>.from(item);
      break;
    }
  }

  selectedImage ??= Map<String, dynamic>.from(data.first as Map);

  final rawImage = selectedImage['profile_image']?.toString() ?? '';

  return ProfileHomeImageResult(
    imageUrl: _resolveMediaUrl(rawImage),
    rawImage: rawImage,
    imageId: selectedImage['id']?.toString() ?? '',
    isMain: selectedImage['set_profile']?.toString() == '1',
  );
}

// ============================================================================
// AGE HELPER
// ============================================================================

int calculateAge(String? dob) {
  if (dob == null || dob.isEmpty) return 0;

  try {
    List<String> parts = [];

    if (dob.contains('-')) {
      parts = dob.split('-');
    } else if (dob.contains('/')) {
      parts = dob.split('/');
    } else {
      return 0;
    }

    if (parts.length != 3) return 0;

    int year;
    int month;
    int day;

    if (parts[0].length == 4) {
      year = int.parse(parts[0]);
      month = int.parse(parts[1]);
      day = int.parse(parts[2]);
    } else {
      year = int.parse(parts[2]);
      month = int.parse(parts[1]);
      day = int.parse(parts[0]);
    }

    final birthDate = DateTime(year, month, day);
    final today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  } catch (_) {
    return 0;
  }
}

String _emptyFallback(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "I'm not comfortable sharing that";
  }
  return value;
}

// ============================================================================
// MAIN HOME TAB WIDGET
// ============================================================================

class ViewSingleProfileHomeTab extends ConsumerStatefulWidget {
  const ViewSingleProfileHomeTab({super.key});

  @override
  ConsumerState<ViewSingleProfileHomeTab> createState() => _ViewSingleProfileHomeTabState();
}

class _ViewSingleProfileHomeTabState extends ConsumerState<ViewSingleProfileHomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(viewSingleProfileProvider.notifier).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(viewSingleProfileProvider);

    if (profileState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.pink),
      );
    }

    if (profileState.isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              profileState.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ref.read(viewSingleProfileProvider.notifier).fetchProfile();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final data = profileState.data;

    if (data == null) {
      return const Center(child: Text('No profile data available'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(viewSingleProfileProvider.notifier).fetchProfile();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(
              data: data,
              homeImage: profileState.homeImage,
            ),
            const SizedBox(height: 28),
            TraitsSection(data: data),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PROFILE CARD
// ============================================================================

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.data,
    this.homeImage,
  });

  final ViewSingleProfileData data;
  final ProfileHomeImageResult? homeImage;

  @override
  Widget build(BuildContext context) {
    final isCouple = data.isCouple;

    final displayName = isCouple
        ? (data.coupleFullNameFrom.isNotEmpty ? data.coupleFullNameFrom : data.username)
        : (data.singleFullName.isNotEmpty ? data.singleFullName : data.username);

    final displayAge = _displayAge(data);

    final genderText = data.genderProfileType.isNotEmpty
        ? data.genderProfileType
        : 'Gender not specified';

    final locationText = data.address.isNotEmpty
        ? data.address
        : (data.city.isNotEmpty
            ? data.city
            : (data.address1.isNotEmpty
                ? data.address1
                : (data.city1.isNotEmpty ? data.city1 : 'Location not available')));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1C0027), Color(0xFF32003E)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // THIS IS THE IMAGE INSIDE THE BLACK PART OF THE PROFILE CARD.
          ProfileHomeTabImage(
            imageUrl: homeImage?.imageUrl ?? '',
            fallbackIcon: isCouple ? Icons.people_alt : Icons.person,
            height: 360,
            borderRadius: 8,
          ),
          const SizedBox(height: 12),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayAge,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            genderText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            locationText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  String _displayAge(ViewSingleProfileData data) {
    if (data.isCouple) {
      final age1 = calculateAge(data.person1Dob);
      final age2 = calculateAge(data.person2Dob);

      if (age1 > 0 && age2 > 0) return '$age1 | $age2 Years';
      if (age1 > 0) return '$age1 Years';
      if (age2 > 0) return '$age2 Years';

      if (data.age > 0 && data.age2 > 0) return '${data.age} | ${data.age2} Years';
      if (data.age > 0) return '${data.age} Years';
      if (data.age2 > 0) return '${data.age2} Years';

      return 'Age not available';
    }

    final age = calculateAge(data.person1Dob);
    if (age > 0) return '$age Years';
    if (data.age > 0) return '${data.age} Years';
    return 'Age not available';
  }
}

class ProfileHomeTabImage extends StatelessWidget {
  const ProfileHomeTabImage({
    super.key,
    required this.imageUrl,
    this.height = 360,
    this.width = double.infinity,
    this.borderRadius = 8,
    this.fallbackIcon = Icons.person,
  });

  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = _resolveMediaUrl(imageUrl);

    if (resolvedUrl.isEmpty) {
      return _fallback();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        resolvedUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        color: Colors.grey[900],
        child: Icon(
          fallbackIcon,
          size: 90,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}

// ============================================================================
// TRAITS SECTION
// ============================================================================

class TraitsSection extends StatelessWidget {
  const TraitsSection({
    super.key,
    required this.data,
  });

  final ViewSingleProfileData data;

  @override
  Widget build(BuildContext context) {
    final isCouple = data.isCouple;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: isCouple ? 760 : 620,
        child: isCouple
            ? _CoupleTraitsTable(data: data)
            : _SingleTraitsTable(data: data),
      ),
    );
  }
}

// ============================================================================
// SINGLE TRAITS TABLE
// ============================================================================

class _SingleTraitsTable extends StatelessWidget {
  const _SingleTraitsTable({required this.data});

  final ViewSingleProfileData data;

  @override
  Widget build(BuildContext context) {
    final age = calculateAge(data.person1Dob);

    final traits = <_SingleTrait>[
      _SingleTrait(label: 'Age', value: age > 0 ? '$age' : (data.age > 0 ? '${data.age}' : 'N/A')),
      _SingleTrait(label: 'Tattoos', value: data.person1Tattoos),
      _SingleTrait(label: 'Body Hair', value: data.person1BodyHair),
      _SingleTrait(label: 'Weight', value: _formatWithType(data.person1Weight, data.weight1Type)),
      _SingleTrait(label: 'Height', value: _formatWithType(data.person1Height, data.height1Type)),
      _SingleTrait(label: 'Smoking', value: data.person1Smoking),
      _SingleTrait(label: 'Drinking', value: data.person1Drinking),
      _SingleTrait(label: 'Body Type', value: data.person1BodyType),
      _SingleTrait(label: 'Language Spoken', value: data.person1LanguageSpoken),
      _SingleTrait(label: 'Ethnic Background', value: data.person1EthnicBackground),
      _SingleTrait(label: 'Piercings', value: data.person1Piercings),
      _SingleTrait(label: 'Circumcised', value: data.person1Circumcised),
      _SingleTrait(label: 'Intelligence', value: data.person1IntelligenceImportance),
      _SingleTrait(label: 'Sexuality', value: data.person1Sexuality),
      _SingleTrait(label: 'Relationship', value: data.person1RelationshipOrientation),
      _SingleTrait(label: 'Looks Important', value: data.person1LooksImportant),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Details',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F1047),
          ),
        ),
        const SizedBox(height: 22),
        ...traits.map(
          (trait) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _TraitLabelPill(text: trait.label),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 6,
                  child: _ValueBubble(
                    text: _emptyFallback(trait.value),
                    avatarIcon: Icons.person,
                    avatarColor: const Color(0xFF3B6CB7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String? _formatWithType(String? value, String? type) {
    if (value == null || value.trim().isEmpty) return null;
    if (type == null || type.trim().isEmpty) return value;
    return '$value $type';
  }
}

// ============================================================================
// COUPLE TRAITS TABLE
// ============================================================================

class _CoupleTraitsTable extends StatelessWidget {
  const _CoupleTraitsTable({required this.data});

  final ViewSingleProfileData data;

  @override
  Widget build(BuildContext context) {
    final age1 = calculateAge(data.person1Dob);
    final age2 = calculateAge(data.person2Dob);

    final traits = <_CoupleTrait>[
      _CoupleTrait(
        label: 'Age',
        p1Value: age1 > 0 ? '$age1' : (data.age > 0 ? '${data.age}' : 'N/A'),
        p2Value: age2 > 0 ? '$age2' : (data.age2 > 0 ? '${data.age2}' : 'N/A'),
      ),
      _CoupleTrait(label: 'Tattoos', p1Value: _v(data.person1Tattoos), p2Value: _v(data.person2Tattoos)),
      _CoupleTrait(label: 'Body Hair', p1Value: _v(data.person1BodyHair), p2Value: _v(data.person2BodyHair)),
      _CoupleTrait(label: 'Weight', p1Value: _format(data.person1Weight, data.weight1Type), p2Value: _format(data.person2Weight, data.weight2Type)),
      _CoupleTrait(label: 'Height', p1Value: _format(data.person1Height, data.height1Type), p2Value: _format(data.person2Height, data.height2Type)),
      _CoupleTrait(label: 'Smoking', p1Value: _v(data.person1Smoking), p2Value: _v(data.person2Smoking)),
      _CoupleTrait(label: 'Drinking', p1Value: _v(data.person1Drinking), p2Value: _v(data.person2Drinking)),
      _CoupleTrait(label: 'Body Type', p1Value: _v(data.person1BodyType), p2Value: _v(data.person2BodyType)),
      _CoupleTrait(label: 'Language Spoken', p1Value: _v(data.person1LanguageSpoken), p2Value: _v(data.person2LanguageSpoken)),
      _CoupleTrait(label: 'Ethnic Background', p1Value: _v(data.person1EthnicBackground), p2Value: _v(data.person2EthnicBackground)),
      _CoupleTrait(label: 'Piercings', p1Value: _v(data.person1Piercings), p2Value: _v(data.person2Piercings)),
      _CoupleTrait(label: 'Circumcised', p1Value: _v(data.person1Circumcised), p2Value: _v(data.person2Circumcised)),
      _CoupleTrait(label: 'Intelligence', p1Value: _v(data.person1IntelligenceImportance), p2Value: _v(data.person2IntelligenceImportance)),
      _CoupleTrait(label: 'Sexuality', p1Value: _v(data.person1Sexuality), p2Value: _v(data.person2Sexuality)),
      _CoupleTrait(label: 'Relationship', p1Value: _v(data.person1RelationshipOrientation), p2Value: _v(data.person2RelationshipOrientation)),
      _CoupleTrait(label: 'Looks Important', p1Value: _v(data.person1LooksImportant), p2Value: _v(data.person2LooksImportant)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Details',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F1047),
          ),
        ),
        const SizedBox(height: 22),
        ...traits.map(
          (trait) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              children: [
                Expanded(flex: 4, child: _TraitLabelPill(text: trait.label)),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: _ValueBubble(
                    text: trait.p1Value,
                    avatarIcon: Icons.person,
                    avatarColor: const Color(0xFF3B6CB7),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: _ValueBubble(
                    text: trait.p2Value,
                    avatarIcon: Icons.person_2,
                    avatarColor: const Color(0xFFE91E63),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _v(String? value) => _emptyFallback(value);

  String _format(String? value, String? type) {
    if (value == null || value.trim().isEmpty) return 'N/A';
    if (type == null || type.trim().isEmpty) return value;
    return '$value $type';
  }
}

class _TraitLabelPill extends StatelessWidget {
  const _TraitLabelPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF180024), Color(0xFF3D0053)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _ValueBubble extends StatelessWidget {
  const _ValueBubble({
    required this.text,
    required this.avatarIcon,
    this.avatarColor = const Color(0xFF3B6CB7),
  });

  final String text;
  final IconData avatarIcon;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarColor.withOpacity(0.08),
            border: Border.all(color: avatarColor.withOpacity(0.5), width: 2),
          ),
          child: Icon(avatarIcon, size: 22, color: avatarColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 44,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE6DFF0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SingleTrait {
  _SingleTrait({required this.label, required this.value});

  final String label;
  final String? value;
}

class _CoupleTrait {
  _CoupleTrait({
    required this.label,
    required this.p1Value,
    required this.p2Value,
  });

  final String label;
  final String p1Value;
  final String p2Value;
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/core/services/token_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// // ═══════════════════════════════════════════════════════════════════
// //                          MODEL
// // ═══════════════════════════════════════════════════════════════════

// class ViewSingleProfileData {
//   final String id;
//   final String username;
//   final String email;
//   final String profileType;
//   final String genderProfileType;
//   final String singleProfileGenderFrom;
//   final String coupleProfileGenderFrom;
//   final String coupleProfileGenderTo;
//   final String singleFullName;
//   final String coupleFullNameFrom;
//   final String coupleFullNameTo;
//   final String created;
//   final String lastPayment;
//   final String expireDate;
//   final String lat;
//   final String lng;
//   final String city;
//   final String placeId;
//   final String mapUrl;
//   final String address;
//   final String? lat1;
//   final String? lng1;
//   final String? city1;
//   final String? placeId1;
//   final String? mapUrl1;
//   final String? address1;
//   final String? distance;
//   final String person1Name;
//   final String person2Name;
//   final String coupleMaleFemaleSwingers;
//   final String coupleMaleFemaleHookupMeetup;
//   final String coupleFemaleFemaleSwingers;
//   final String coupleFemaleFemaleHookupMeetup;
//   final String coupleMaleMaleSwingers;
//   final String coupleMaleMaleHookupMeetup;
//   final String coupleMaleSwingers;
//   final String coupleMaleHookupMeetup;
//   final String coupleFemaleSwingers;
//   final String coupleFemaleHookupMeetup;
//   final String coupleTransgenderSwingers;
//   final String coupleTransgenderHookupMeetup;
//   final String? text;
//   final String? comment;
//   final String person1Dob;
//   final int age;
//   final String? person1BodyHair;
//   final String? height1Type;
//   final String? weight1Type;
//   final String? person1Height;
//   final String? person1Weight;
//   final String? person1BodyType;
//   final String? person1EthnicBackground;
//   final String? person1Piercings;
//   final String? person1Tattoos;
//   final String? person1LanguageSpoken;
//   final String? person1Circumcised;
//   final String? person1Smoking;
//   final String? person1Drinking;
//   final String? person1IntelligenceImportance;
//   final String? person1Sexuality;
//   final String? person1RelationshipOrientation;
//   final String? person1LooksImportant;
//   final String person2Dob;
//   final int age2;
//   final String? person2BodyHair;
//   final String? height2Type;
//   final String? weight2Type;
//   final String? person2Height;
//   final String? person2Weight;
//   final String? person2BodyType;
//   final String? person2EthnicBackground;
//   final String? person2Piercings;
//   final String? person2Tattoos;
//   final String? person2LanguageSpoken;
//   final String? person2Circumcised;
//   final String? person2Smoking;
//   final String? person2Drinking;
//   final String? person2IntelligenceImportance;
//   final String? person2Sexuality;
//   final String? person2RelationshipOrientation;
//   final String? person2LooksImportant;

//   ViewSingleProfileData({
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.profileType,
//     required this.genderProfileType,
//     required this.singleProfileGenderFrom,
//     required this.coupleProfileGenderFrom,
//     required this.coupleProfileGenderTo,
//     required this.singleFullName,
//     required this.coupleFullNameFrom,
//     required this.coupleFullNameTo,
//     required this.created,
//     required this.lastPayment,
//     required this.expireDate,
//     required this.lat,
//     required this.lng,
//     required this.city,
//     required this.placeId,
//     required this.mapUrl,
//     required this.address,
//     this.lat1,
//     this.lng1,
//     this.city1,
//     this.placeId1,
//     this.mapUrl1,
//     this.address1,
//     this.distance,
//     required this.person1Name,
//     required this.person2Name,
//     required this.coupleMaleFemaleSwingers,
//     required this.coupleMaleFemaleHookupMeetup,
//     required this.coupleFemaleFemaleSwingers,
//     required this.coupleFemaleFemaleHookupMeetup,
//     required this.coupleMaleMaleSwingers,
//     required this.coupleMaleMaleHookupMeetup,
//     required this.coupleMaleSwingers,
//     required this.coupleMaleHookupMeetup,
//     required this.coupleFemaleSwingers,
//     required this.coupleFemaleHookupMeetup,
//     required this.coupleTransgenderSwingers,
//     required this.coupleTransgenderHookupMeetup,
//     this.text,
//     this.comment,
//     required this.person1Dob,
//     required this.age,
//     this.person1BodyHair,
//     this.height1Type,
//     this.weight1Type,
//     this.person1Height,
//     this.person1Weight,
//     this.person1BodyType,
//     this.person1EthnicBackground,
//     this.person1Piercings,
//     this.person1Tattoos,
//     this.person1LanguageSpoken,
//     this.person1Circumcised,
//     this.person1Smoking,
//     this.person1Drinking,
//     this.person1IntelligenceImportance,
//     this.person1Sexuality,
//     this.person1RelationshipOrientation,
//     this.person1LooksImportant,
//     required this.person2Dob,
//     required this.age2,
//     this.person2BodyHair,
//     this.height2Type,
//     this.weight2Type,
//     this.person2Height,
//     this.person2Weight,
//     this.person2BodyType,
//     this.person2EthnicBackground,
//     this.person2Piercings,
//     this.person2Tattoos,
//     this.person2LanguageSpoken,
//     this.person2Circumcised,
//     this.person2Smoking,
//     this.person2Drinking,
//     this.person2IntelligenceImportance,
//     this.person2Sexuality,
//     this.person2RelationshipOrientation,
//     this.person2LooksImportant,
//   });

//   ViewSingleProfileData copyWith({
//     String? id,
//     String? username,
//     String? email,
//     String? profileType,
//     String? genderProfileType,
//     String? singleProfileGenderFrom,
//     String? coupleProfileGenderFrom,
//     String? coupleProfileGenderTo,
//     String? singleFullName,
//     String? coupleFullNameFrom,
//     String? coupleFullNameTo,
//     String? created,
//     String? lastPayment,
//     String? expireDate,
//     String? lat,
//     String? lng,
//     String? city,
//     String? placeId,
//     String? mapUrl,
//     String? address,
//     String? lat1,
//     String? lng1,
//     String? city1,
//     String? placeId1,
//     String? mapUrl1,
//     String? address1,
//     String? distance,
//     String? person1Name,
//     String? person2Name,
//     String? coupleMaleFemaleSwingers,
//     String? coupleMaleFemaleHookupMeetup,
//     String? coupleFemaleFemaleSwingers,
//     String? coupleFemaleFemaleHookupMeetup,
//     String? coupleMaleMaleSwingers,
//     String? coupleMaleMaleHookupMeetup,
//     String? coupleMaleSwingers,
//     String? coupleMaleHookupMeetup,
//     String? coupleFemaleSwingers,
//     String? coupleFemaleHookupMeetup,
//     String? coupleTransgenderSwingers,
//     String? coupleTransgenderHookupMeetup,
//     String? text,
//     String? comment,
//     String? person1Dob,
//     int? age,
//     String? person1BodyHair,
//     String? height1Type,
//     String? weight1Type,
//     String? person1Height,
//     String? person1Weight,
//     String? person1BodyType,
//     String? person1EthnicBackground,
//     String? person1Piercings,
//     String? person1Tattoos,
//     String? person1LanguageSpoken,
//     String? person1Circumcised,
//     String? person1Smoking,
//     String? person1Drinking,
//     String? person1IntelligenceImportance,
//     String? person1Sexuality,
//     String? person1RelationshipOrientation,
//     String? person1LooksImportant,
//     String? person2Dob,
//     int? age2,
//     String? person2BodyHair,
//     String? height2Type,
//     String? weight2Type,
//     String? person2Height,
//     String? person2Weight,
//     String? person2BodyType,
//     String? person2EthnicBackground,
//     String? person2Piercings,
//     String? person2Tattoos,
//     String? person2LanguageSpoken,
//     String? person2Circumcised,
//     String? person2Smoking,
//     String? person2Drinking,
//     String? person2IntelligenceImportance,
//     String? person2Sexuality,
//     String? person2RelationshipOrientation,
//     String? person2LooksImportant,
//   }) {
//     return ViewSingleProfileData(
//       id: id ?? this.id,
//       username: username ?? this.username,
//       email: email ?? this.email,
//       profileType: profileType ?? this.profileType,
//       genderProfileType: genderProfileType ?? this.genderProfileType,
//       singleProfileGenderFrom: singleProfileGenderFrom ?? this.singleProfileGenderFrom,
//       coupleProfileGenderFrom: coupleProfileGenderFrom ?? this.coupleProfileGenderFrom,
//       coupleProfileGenderTo: coupleProfileGenderTo ?? this.coupleProfileGenderTo,
//       singleFullName: singleFullName ?? this.singleFullName,
//       coupleFullNameFrom: coupleFullNameFrom ?? this.coupleFullNameFrom,
//       coupleFullNameTo: coupleFullNameTo ?? this.coupleFullNameTo,
//       created: created ?? this.created,
//       lastPayment: lastPayment ?? this.lastPayment,
//       expireDate: expireDate ?? this.expireDate,
//       lat: lat ?? this.lat,
//       lng: lng ?? this.lng,
//       city: city ?? this.city,
//       placeId: placeId ?? this.placeId,
//       mapUrl: mapUrl ?? this.mapUrl,
//       address: address ?? this.address,
//       lat1: lat1 ?? this.lat1,
//       lng1: lng1 ?? this.lng1,
//       city1: city1 ?? this.city1,
//       placeId1: placeId1 ?? this.placeId1,
//       mapUrl1: mapUrl1 ?? this.mapUrl1,
//       address1: address1 ?? this.address1,
//       distance: distance ?? this.distance,
//       person1Name: person1Name ?? this.person1Name,
//       person2Name: person2Name ?? this.person2Name,
//       coupleMaleFemaleSwingers: coupleMaleFemaleSwingers ?? this.coupleMaleFemaleSwingers,
//       coupleMaleFemaleHookupMeetup: coupleMaleFemaleHookupMeetup ?? this.coupleMaleFemaleHookupMeetup,
//       coupleFemaleFemaleSwingers: coupleFemaleFemaleSwingers ?? this.coupleFemaleFemaleSwingers,
//       coupleFemaleFemaleHookupMeetup: coupleFemaleFemaleHookupMeetup ?? this.coupleFemaleFemaleHookupMeetup,
//       coupleMaleMaleSwingers: coupleMaleMaleSwingers ?? this.coupleMaleMaleSwingers,
//       coupleMaleMaleHookupMeetup: coupleMaleMaleHookupMeetup ?? this.coupleMaleMaleHookupMeetup,
//       coupleMaleSwingers: coupleMaleSwingers ?? this.coupleMaleSwingers,
//       coupleMaleHookupMeetup: coupleMaleHookupMeetup ?? this.coupleMaleHookupMeetup,
//       coupleFemaleSwingers: coupleFemaleSwingers ?? this.coupleFemaleSwingers,
//       coupleFemaleHookupMeetup: coupleFemaleHookupMeetup ?? this.coupleFemaleHookupMeetup,
//       coupleTransgenderSwingers: coupleTransgenderSwingers ?? this.coupleTransgenderSwingers,
//       coupleTransgenderHookupMeetup: coupleTransgenderHookupMeetup ?? this.coupleTransgenderHookupMeetup,
//       text: text ?? this.text,
//       comment: comment ?? this.comment,
//       person1Dob: person1Dob ?? this.person1Dob,
//       age: age ?? this.age,
//       person1BodyHair: person1BodyHair ?? this.person1BodyHair,
//       height1Type: height1Type ?? this.height1Type,
//       weight1Type: weight1Type ?? this.weight1Type,
//       person1Height: person1Height ?? this.person1Height,
//       person1Weight: person1Weight ?? this.person1Weight,
//       person1BodyType: person1BodyType ?? this.person1BodyType,
//       person1EthnicBackground: person1EthnicBackground ?? this.person1EthnicBackground,
//       person1Piercings: person1Piercings ?? this.person1Piercings,
//       person1Tattoos: person1Tattoos ?? this.person1Tattoos,
//       person1LanguageSpoken: person1LanguageSpoken ?? this.person1LanguageSpoken,
//       person1Circumcised: person1Circumcised ?? this.person1Circumcised,
//       person1Smoking: person1Smoking ?? this.person1Smoking,
//       person1Drinking: person1Drinking ?? this.person1Drinking,
//       person1IntelligenceImportance: person1IntelligenceImportance ?? this.person1IntelligenceImportance,
//       person1Sexuality: person1Sexuality ?? this.person1Sexuality,
//       person1RelationshipOrientation: person1RelationshipOrientation ?? this.person1RelationshipOrientation,
//       person1LooksImportant: person1LooksImportant ?? this.person1LooksImportant,
//       person2Dob: person2Dob ?? this.person2Dob,
//       age2: age2 ?? this.age2,
//       person2BodyHair: person2BodyHair ?? this.person2BodyHair,
//       height2Type: height2Type ?? this.height2Type,
//       weight2Type: weight2Type ?? this.weight2Type,
//       person2Height: person2Height ?? this.person2Height,
//       person2Weight: person2Weight ?? this.person2Weight,
//       person2BodyType: person2BodyType ?? this.person2BodyType,
//       person2EthnicBackground: person2EthnicBackground ?? this.person2EthnicBackground,
//       person2Piercings: person2Piercings ?? this.person2Piercings,
//       person2Tattoos: person2Tattoos ?? this.person2Tattoos,
//       person2LanguageSpoken: person2LanguageSpoken ?? this.person2LanguageSpoken,
//       person2Circumcised: person2Circumcised ?? this.person2Circumcised,
//       person2Smoking: person2Smoking ?? this.person2Smoking,
//       person2Drinking: person2Drinking ?? this.person2Drinking,
//       person2IntelligenceImportance: person2IntelligenceImportance ?? this.person2IntelligenceImportance,
//       person2Sexuality: person2Sexuality ?? this.person2Sexuality,
//       person2RelationshipOrientation: person2RelationshipOrientation ?? this.person2RelationshipOrientation,
//       person2LooksImportant: person2LooksImportant ?? this.person2LooksImportant,
//     );
//   }

//   factory ViewSingleProfileData.fromJson(Map<String, dynamic> json) {
//     return ViewSingleProfileData(
//       id: json['id'] ?? '',
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       profileType: json['profile_type'] ?? '',
//       genderProfileType: json['gender_profile_type'] ?? '',
//       singleProfileGenderFrom: json['single_profile_gender_from'] ?? '',
//       coupleProfileGenderFrom: json['couple_profile_gender_from'] ?? '',
//       coupleProfileGenderTo: json['couple_profile_gender_to'] ?? '',
//       singleFullName: json['single_full_name'] ?? '',
//       coupleFullNameFrom: json['couple_full_name_from'] ?? '',
//       coupleFullNameTo: json['couple_full_name_to'] ?? '',
//       created: json['created'] ?? '',
//       lastPayment: json['last_payment'] ?? '',
//       expireDate: json['expire_date'] ?? '',
//       lat: json['lat'] ?? '',
//       lng: json['lng'] ?? '',
//       city: json['city'] ?? '',
//       placeId: json['place_id'] ?? '',
//       mapUrl: json['map_url'] ?? '',
//       address: json['address'] ?? '',
//       lat1: json['lat_1'],
//       lng1: json['lng_1'],
//       city1: json['city_1'],
//       placeId1: json['place_id_1'],
//       mapUrl1: json['map_url_1'],
//       address1: json['address_1'],
//       distance: json['distance'],
//       person1Name: (json['person1_name'] != null && json['person1_name'].toString().trim().isNotEmpty) ? json['person1_name'].toString() : 'Person 1',
//       person2Name: (json['person2_name'] != null && json['person2_name'].toString().trim().isNotEmpty) ? json['person2_name'].toString() : 'Person 2',
//       coupleMaleFemaleSwingers: json['couple_male_female_swingers'] ?? '0',
//       coupleMaleFemaleHookupMeetup:
//           json['couple_male_female_hookup_meetup'] ?? '0',
//       coupleFemaleFemaleSwingers:
//           json['couple_female_female_swingers'] ?? '0',
//       coupleFemaleFemaleHookupMeetup:
//           json['couple_female_female_hookup_meetup'] ?? '0',
//       coupleMaleMaleSwingers: json['couple_male_male_swingers'] ?? '0',
//       coupleMaleMaleHookupMeetup:
//           json['couple_male_male_hookup_meetup'] ?? '0',
//       coupleMaleSwingers: json['couple_male_swingers'] ?? '0',
//       coupleMaleHookupMeetup: json['couple_male_hookup_meetup'] ?? '0',
//       coupleFemaleSwingers: json['couple_female_swingers'] ?? '0',
//       coupleFemaleHookupMeetup: json['couple_female_hookup_meetup'] ?? '0',
//       coupleTransgenderSwingers: json['couple_transgender_swingers'] ?? '0',
//       coupleTransgenderHookupMeetup:
//           json['couple_transgender_hookup_meetup'] ?? '0',
//       text: json['text'],
//       comment: json['comment'],
//       person1Dob: json['person1_dob'] ?? '',
//       age: json['age'] ?? 0,
//       person1BodyHair: json['person1_body_hair'],
//       height1Type: json['height1_type'],
//       weight1Type: json['weight1_type'],
//       person1Height: json['person1_height'],
//       person1Weight: json['person1_weight'],
//       person1BodyType: json['person1_body_type'],
//       person1EthnicBackground: json['person1_ethnic_background'],
//       person1Piercings: json['person1_piercings'],
//       person1Tattoos: json['person1_tattoos'],
//       person1LanguageSpoken: json['person1_language_spoken'],
//       person1Circumcised: json['person1_circumcised'],
//       person1Smoking: json['person1_smoking'],
//       person1Drinking: json['person1_drinking'],
//       person1IntelligenceImportance: json['person1_intelligence_importance'],
//       person1Sexuality: json['person1_sexuality'],
//       person1RelationshipOrientation: json['person1_relationship_orientation'],
//       person1LooksImportant: json['person1_looks_important'],
//       person2Dob: json['person2_dob'] ?? '',
//       age2: json['age2'] ?? 0,
//       person2BodyHair: json['person2_body_hair'],
//       height2Type: json['height2_type'],
//       weight2Type: json['weight2_type'],
//       person2Height: json['person2_height'],
//       person2Weight: json['person2_weight'],
//       person2BodyType: json['person2_body_type'],
//       person2EthnicBackground: json['person2_ethnic_background'],
//       person2Piercings: json['person2_piercings'],
//       person2Tattoos: json['person2_tattoos'],
//       person2LanguageSpoken: json['person2_language_spoken'],
//       person2Circumcised: json['person2_circumcised'],
//       person2Smoking: json['person2_smoking'],
//       person2Drinking: json['person2_drinking'],
//       person2IntelligenceImportance: json['person2_intelligence_importance'],
//       person2Sexuality: json['person2_sexuality'],
//       person2RelationshipOrientation: json['person2_relationship_orientation'],
//       person2LooksImportant: json['person2_looks_important'],
//     );
//   }
// }

// class ViewSingleProfileState {
//   final bool isLoading;
//   final bool isError;
//   final String errorMessage;
//   final ViewSingleProfileData? data;

//   ViewSingleProfileState({
//     this.isLoading = false,
//     this.isError = false,
//     this.errorMessage = '',
//     this.data,
//   });

//   ViewSingleProfileState copyWith({
//     bool? isLoading,
//     bool? isError,
//     String? errorMessage,
//     ViewSingleProfileData? data,
//   }) {
//     return ViewSingleProfileState(
//       isLoading: isLoading ?? this.isLoading,
//       isError: isError ?? this.isError,
//       errorMessage: errorMessage ?? this.errorMessage,
//       data: data ?? this.data,
//     );
//   }
// }

// // // ═══════════════════════════════════════════════════════════════════
// // //                          PROVIDER
// // // ═══════════════════════════════════════════════════════════════════

// // final viewSingleProfileProvider =
// //     StateNotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
// //         (ref) => ViewSingleProfileNotifier());

// // class ViewSingleProfileNotifier extends StateNotifier<ViewSingleProfileState> {
// //   ViewSingleProfileNotifier() : super(ViewSingleProfileState());

// //   final TokenService _tokenService = TokenService();

// //   Future<void> fetchProfile() async {
// //     state = state.copyWith(isLoading: true, isError: false, errorMessage: '');

// //     try {
// //       String? token = await _tokenService.getAccessToken();

// //       // Fallback: try reading directly from SharedPreferences
// //       if (token == null || token.isEmpty) {
// //         final prefs = await SharedPreferences.getInstance();
// //         token = prefs.getString('access_token') ??
// //                 prefs.getString('token') ??
// //                 prefs.getString('auth_token');
// //       }

// //       if (token == null || token.isEmpty) {
// //         state = state.copyWith(
// //           isLoading: false,
// //           isError: true,
// //           errorMessage: 'Authentication token is missing. Please log in again.',
// //         );
// //         return;
// //       }

// //       print('========== FETCHING PROFILE (HOME TAB) ==========');
// //       print('TOKEN length: ${token.length}');

// //       final uri = Uri.parse(
// //           'https://app.beatflirtevent.com/App/user/signle_user_profile');

// //       final response = await http.post(
// //         uri,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'access-token': token,
// //           'Content-Type': 'application/json',
// //           'Accept': 'application/json',
// //         },
// //         body: jsonEncode({}), // send empty body as POST
// //       );

// //       print('FETCH STATUS: ${response.statusCode}');
// //       print('FETCH BODY: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final Map<String, dynamic> jsonResponse =
// //             json.decode(response.body) as Map<String, dynamic>;

// //         if (jsonResponse['status'] == '200' && jsonResponse['data'] != null) {
// //           var data = ViewSingleProfileData.fromJson(jsonResponse['data']);
          
// //           if (data.person1Dob.isNotEmpty) {
// //             data = data.copyWith(age: calculateAge(data.person1Dob));
// //           }
// //           if (data.person2Dob.isNotEmpty) {
// //             data = data.copyWith(age2: calculateAge(data.person2Dob));
// //           }

// //           if (data.id.isNotEmpty) {
// //             try {
// //               final prefs = await SharedPreferences.getInstance();
// //               final cacheKey = 'cached_profile_details_${data.id}';
// //               final cachedStr = prefs.getString(cacheKey);
// //               if (cachedStr != null && cachedStr.isNotEmpty) {
// //                 final cachedMap = jsonDecode(cachedStr);
// //                 if (cachedMap is Map<String, dynamic>) {
// //                   print('Found cached profile details (home tab) for user ${data.id}: $cachedStr');
                  
// //                   String? selectVal(String? current, String key) {
// //                     final cachedVal = cachedMap[key]?.toString();
// //                     if ((current == null || current.isEmpty || current == "I'm not comfortable sharing that." || current == "Im not comfortable sharing that") &&
// //                         cachedVal != null && cachedVal.isNotEmpty) {
// //                       return cachedVal;
// //                     }
// //                     return current;
// //                   }

// //                   data = data.copyWith(
// //                     text: selectVal(data.text, 'aboutMe'),
// //                     comment: selectVal(data.comment, 'lookingFor'),
// //                     person1Name: selectVal(data.person1Name, 'person1Name'),
// //                     person2Name: selectVal(data.person2Name, 'person2Name'),
                    
// //                     person1Dob: selectVal(data.person1Dob, 'partner1_dateOfBirth'),
// //                     person1Height: selectVal(data.person1Height, 'partner1_height'),
// //                     height1Type: selectVal(data.height1Type, 'partner1_heightType'),
// //                     person1Weight: selectVal(data.person1Weight, 'partner1_weight'),
// //                     weight1Type: selectVal(data.weight1Type, 'partner1_weightType'),
// //                     person1BodyType: selectVal(data.person1BodyType, 'partner1_bodyType'),
// //                     person1EthnicBackground: selectVal(data.person1EthnicBackground, 'partner1_ethnic'),
// //                     person1Sexuality: selectVal(data.person1Sexuality, 'partner1_sexuality'),
// //                     person1RelationshipOrientation: selectVal(data.person1RelationshipOrientation, 'partner1_orientation'),
// //                     person1Tattoos: selectVal(data.person1Tattoos, 'partner1_tattoos'),
// //                     person1Piercings: selectVal(data.person1Piercings, 'partner1_piercings'),
// //                     person1Smoking: selectVal(data.person1Smoking, 'partner1_smoking'),
// //                     person1Drinking: selectVal(data.person1Drinking, 'partner1_drinking'),
// //                     person1BodyHair: selectVal(data.person1BodyHair, 'partner1_bodyHair'),
// //                     person1LooksImportant: selectVal(data.person1LooksImportant, 'partner1_looks'),
// //                     person1IntelligenceImportance: selectVal(data.person1IntelligenceImportance, 'partner1_intelligence'),
// //                     person1Circumcised: selectVal(data.person1Circumcised, 'partner1_circumcised'),
                    
// //                     person2Dob: selectVal(data.person2Dob, 'partner2_dateOfBirth'),
// //                     person2Height: selectVal(data.person2Height, 'partner2_height'),
// //                     height2Type: selectVal(data.height2Type, 'partner2_heightType'),
// //                     person2Weight: selectVal(data.person2Weight, 'partner2_weight'),
// //                     weight2Type: selectVal(data.weight2Type, 'partner2_weightType'),
// //                     person2BodyType: selectVal(data.person2BodyType, 'partner2_bodyType'),
// //                     person2EthnicBackground: selectVal(data.person2EthnicBackground, 'partner2_ethnic'),
// //                     person2Sexuality: selectVal(data.person2Sexuality, 'partner2_sexuality'),
// //                     person2RelationshipOrientation: selectVal(data.person2RelationshipOrientation, 'partner2_orientation'),
// //                     person2Tattoos: selectVal(data.person2Tattoos, 'partner2_tattoos'),
// //                     person2Piercings: selectVal(data.person2Piercings, 'partner2_piercings'),
// //                     person2Smoking: selectVal(data.person2Smoking, 'partner2_smoking'),
// //                     person2Drinking: selectVal(data.person2Drinking, 'partner2_drinking'),
// //                     person2BodyHair: selectVal(data.person2BodyHair, 'partner2_bodyHair'),
// //                     person2LooksImportant: selectVal(data.person2LooksImportant, 'partner2_looks'),
// //                     person2IntelligenceImportance: selectVal(data.person2IntelligenceImportance, 'partner2_intelligence'),
// //                     person2Circumcised: selectVal(data.person2Circumcised, 'partner2_circumcised'),
// //                   );

// //                   if (data.person1Dob.isNotEmpty) {
// //                     data = data.copyWith(age: calculateAge(data.person1Dob));
// //                   }
// //                   if (data.person2Dob.isNotEmpty) {
// //                     data = data.copyWith(age2: calculateAge(data.person2Dob));
// //                   }

// //                   if ((data.person1LanguageSpoken == null || data.person1LanguageSpoken!.isEmpty) &&
// //                       cachedMap['partner1Languages'] != null) {
// //                     final List<dynamic> p1Langs = cachedMap['partner1Languages'];
// //                     data = data.copyWith(person1LanguageSpoken: jsonEncode(p1Langs));
// //                   }
// //                   if ((data.person2LanguageSpoken == null || data.person2LanguageSpoken!.isEmpty) &&
// //                       cachedMap['partner2Languages'] != null) {
// //                     final List<dynamic> p2Langs = cachedMap['partner2Languages'];
// //                     data = data.copyWith(person2LanguageSpoken: jsonEncode(p2Langs));
// //                   }
// //                 }
// //               }
// //             } catch (e) {
// //               print('Error merging local cache (home tab): $e');
// //             }
// //           }

// //           state = state.copyWith(isLoading: false, data: data);
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


// // ═══════════════════════════════════════════════════════════════════
// //                          PROVIDER
// // ═══════════════════════════════════════════════════════════════════

// final viewSingleProfileProvider =
//     NotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
//   ViewSingleProfileNotifier.new,
// );

// class ViewSingleProfileNotifier extends Notifier<ViewSingleProfileState> {
//   final TokenService _tokenService = TokenService();

//   @override
//   ViewSingleProfileState build() {
//     return ViewSingleProfileState();
//   }

//   Future<void> fetchProfile() async {
//     state = state.copyWith(
//       isLoading: true,
//       isError: false,
//       errorMessage: '',
//     );

//     try {
//       String? token = await _tokenService.getAccessToken();

//       // Fallback: try reading directly from SharedPreferences
//       if (token == null || token.isEmpty) {
//         final prefs = await SharedPreferences.getInstance();

//         token = prefs.getString('access_token') ??
//             prefs.getString('token') ??
//             prefs.getString('auth_token');
//       }

//       if (token == null || token.isEmpty) {
//         state = state.copyWith(
//           isLoading: false,
//           isError: true,
//           errorMessage: 'Authentication token is missing. Please log in again.',
//         );
//         return;
//       }

//       debugPrint('========== FETCHING PROFILE (HOME TAB) ==========');
//       debugPrint('TOKEN length: ${token.length}');

//       final uri = Uri.parse(
//         'https://app.beatflirtevent.com/App/user/signle_user_profile',
//       );

//       final response = await http.post(
//         uri,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'access-token': token,
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({}),
//       );

//       debugPrint('FETCH STATUS: ${response.statusCode}');
//       debugPrint('FETCH BODY: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse =
//             jsonDecode(response.body) as Map<String, dynamic>;

//         if (jsonResponse['status'] == '200' && jsonResponse['data'] != null) {
//           var data = ViewSingleProfileData.fromJson(
//             Map<String, dynamic>.from(jsonResponse['data'] as Map),
//           );

//           if (data.person1Dob.isNotEmpty) {
//             data = data.copyWith(age: calculateAge(data.person1Dob));
//           }

//           if (data.person2Dob.isNotEmpty) {
//             data = data.copyWith(age2: calculateAge(data.person2Dob));
//           }

//           if (data.id.isNotEmpty) {
//             try {
//               final prefs = await SharedPreferences.getInstance();
//               final cacheKey = 'cached_profile_details_${data.id}';
//               final cachedStr = prefs.getString(cacheKey);

//               if (cachedStr != null && cachedStr.isNotEmpty) {
//                 final cachedMapRaw = jsonDecode(cachedStr);

//                 if (cachedMapRaw is Map) {
//                   final cachedMap = Map<String, dynamic>.from(cachedMapRaw);

//                   debugPrint(
//                     'Found cached profile details (home tab) for user ${data.id}: $cachedStr',
//                   );

//                   String? selectVal(String? current, String key) {
//                     final cachedVal = cachedMap[key]?.toString();

//                     final shouldUseCached = current == null ||
//                         current.isEmpty ||
//                         current == "I'm not comfortable sharing that." ||
//                         current == 'Im not comfortable sharing that';

//                     if (shouldUseCached &&
//                         cachedVal != null &&
//                         cachedVal.isNotEmpty) {
//                       return cachedVal;
//                     }

//                     return current;
//                   }

//                   data = data.copyWith(
//                     text: selectVal(data.text, 'aboutMe'),
//                     comment: selectVal(data.comment, 'lookingFor'),
//                     person1Name: selectVal(data.person1Name, 'person1Name'),
//                     person2Name: selectVal(data.person2Name, 'person2Name'),
//                     person1Dob:
//                         selectVal(data.person1Dob, 'partner1_dateOfBirth'),
//                     person1Height:
//                         selectVal(data.person1Height, 'partner1_height'),
//                     height1Type:
//                         selectVal(data.height1Type, 'partner1_heightType'),
//                     person1Weight:
//                         selectVal(data.person1Weight, 'partner1_weight'),
//                     weight1Type:
//                         selectVal(data.weight1Type, 'partner1_weightType'),
//                     person1BodyType:
//                         selectVal(data.person1BodyType, 'partner1_bodyType'),
//                     person1EthnicBackground: selectVal(
//                       data.person1EthnicBackground,
//                       'partner1_ethnic',
//                     ),
//                     person1Sexuality:
//                         selectVal(data.person1Sexuality, 'partner1_sexuality'),
//                     person1RelationshipOrientation: selectVal(
//                       data.person1RelationshipOrientation,
//                       'partner1_orientation',
//                     ),
//                     person1Tattoos:
//                         selectVal(data.person1Tattoos, 'partner1_tattoos'),
//                     person1Piercings:
//                         selectVal(data.person1Piercings, 'partner1_piercings'),
//                     person1Smoking:
//                         selectVal(data.person1Smoking, 'partner1_smoking'),
//                     person1Drinking:
//                         selectVal(data.person1Drinking, 'partner1_drinking'),
//                     person1BodyHair:
//                         selectVal(data.person1BodyHair, 'partner1_bodyHair'),
//                     person1LooksImportant:
//                         selectVal(data.person1LooksImportant, 'partner1_looks'),
//                     person1IntelligenceImportance: selectVal(
//                       data.person1IntelligenceImportance,
//                       'partner1_intelligence',
//                     ),
//                     person1Circumcised: selectVal(
//                       data.person1Circumcised,
//                       'partner1_circumcised',
//                     ),
//                     person2Dob:
//                         selectVal(data.person2Dob, 'partner2_dateOfBirth'),
//                     person2Height:
//                         selectVal(data.person2Height, 'partner2_height'),
//                     height2Type:
//                         selectVal(data.height2Type, 'partner2_heightType'),
//                     person2Weight:
//                         selectVal(data.person2Weight, 'partner2_weight'),
//                     weight2Type:
//                         selectVal(data.weight2Type, 'partner2_weightType'),
//                     person2BodyType:
//                         selectVal(data.person2BodyType, 'partner2_bodyType'),
//                     person2EthnicBackground: selectVal(
//                       data.person2EthnicBackground,
//                       'partner2_ethnic',
//                     ),
//                     person2Sexuality:
//                         selectVal(data.person2Sexuality, 'partner2_sexuality'),
//                     person2RelationshipOrientation: selectVal(
//                       data.person2RelationshipOrientation,
//                       'partner2_orientation',
//                     ),
//                     person2Tattoos:
//                         selectVal(data.person2Tattoos, 'partner2_tattoos'),
//                     person2Piercings:
//                         selectVal(data.person2Piercings, 'partner2_piercings'),
//                     person2Smoking:
//                         selectVal(data.person2Smoking, 'partner2_smoking'),
//                     person2Drinking:
//                         selectVal(data.person2Drinking, 'partner2_drinking'),
//                     person2BodyHair:
//                         selectVal(data.person2BodyHair, 'partner2_bodyHair'),
//                     person2LooksImportant:
//                         selectVal(data.person2LooksImportant, 'partner2_looks'),
//                     person2IntelligenceImportance: selectVal(
//                       data.person2IntelligenceImportance,
//                       'partner2_intelligence',
//                     ),
//                     person2Circumcised: selectVal(
//                       data.person2Circumcised,
//                       'partner2_circumcised',
//                     ),
//                   );

//                   if (data.person1Dob.isNotEmpty) {
//                     data = data.copyWith(age: calculateAge(data.person1Dob));
//                   }

//                   if (data.person2Dob.isNotEmpty) {
//                     data = data.copyWith(age2: calculateAge(data.person2Dob));
//                   }

//                   if ((data.person1LanguageSpoken == null ||
//                           data.person1LanguageSpoken!.isEmpty) &&
//                       cachedMap['partner1Languages'] != null) {
//                     final p1Langs = cachedMap['partner1Languages'];

//                     if (p1Langs is List) {
//                       data = data.copyWith(
//                         person1LanguageSpoken: jsonEncode(p1Langs),
//                       );
//                     }
//                   }

//                   if ((data.person2LanguageSpoken == null ||
//                           data.person2LanguageSpoken!.isEmpty) &&
//                       cachedMap['partner2Languages'] != null) {
//                     final p2Langs = cachedMap['partner2Languages'];

//                     if (p2Langs is List) {
//                       data = data.copyWith(
//                         person2LanguageSpoken: jsonEncode(p2Langs),
//                       );
//                     }
//                   }
//                 }
//               }
//             } catch (e) {
//               debugPrint('Error merging local cache (home tab): $e');
//             }
//           }

//           state = state.copyWith(
//             isLoading: false,
//             isError: false,
//             errorMessage: '',
//             data: data,
//           );

//           debugPrint('✅ Home tab profile loaded successfully');
//         } else {
//           state = state.copyWith(
//             isLoading: false,
//             isError: true,
//             errorMessage: 'Invalid response format',
//           );

//           debugPrint('❌ Invalid response format');
//         }
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           isError: true,
//           errorMessage: 'Failed to load profile: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         isError: true,
//         errorMessage: 'Error: $e',
//       );

//       debugPrint('❌ Error fetching profile: $e');
//     }
//   }
// }


// // ═══════════════════════════════════════════════════════════════════
// //                          WIDGETS
// // ═══════════════════════════════════════════════════════════════════

// /// Helper to calculate age from YYYY-MM-DD format
// int calculateAge(String? dob) {
//   if (dob == null || dob.isEmpty) return 0;
//   try {
//     List<String> parts = [];
//     if (dob.contains('-')) {
//       parts = dob.split('-');
//     } else if (dob.contains('/')) {
//       parts = dob.split('/');
//     } else {
//       return 0;
//     }
//     if (parts.length != 3) return 0;

//     int year, month, day;
//     if (parts[0].length == 4) {
//       // YYYY-MM-DD or YYYY/MM/DD
//       year = int.parse(parts[0]);
//       month = int.parse(parts[1]);
//       day = int.parse(parts[2]);
//     } else {
//       // DD-MM-YYYY or DD/MM/YYYY
//       year = int.parse(parts[2]);
//       month = int.parse(parts[1]);
//       day = int.parse(parts[0]);
//     }

//     final birthDate = DateTime(year, month, day);
//     final today = DateTime.now();
//     int age = today.year - birthDate.year;
//     if (today.month < birthDate.month ||
//         (today.month == birthDate.month && today.day < birthDate.day)) {
//       age--;
//     }
//     return age;
//   } catch (_) {
//     return 0;
//   }
// }

// class ViewSingleProfileHomeTab extends ConsumerStatefulWidget {
//   const ViewSingleProfileHomeTab({super.key});

//   @override
//   ConsumerState<ViewSingleProfileHomeTab> createState() =>
//       _ViewSingleProfileHomeTabState();
// }

// class _ViewSingleProfileHomeTabState
//     extends ConsumerState<ViewSingleProfileHomeTab> {

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(viewSingleProfileProvider.notifier).fetchProfile();
//     });
//   }


// // const String _webBase = 'https://beatflirtevent.com/';
// // const String _apiBase = 'https://app.beatflirtevent.com/App';
// // const String _apiAssetBase = 'https://app.beatflirtevent.com/assets/';

// // String _webAsset(String path) => '$_webBase$path';

// // String _resolveMediaUrl(String raw) {
// //   final value = raw.trim();
// //   if (value.isEmpty) return '';
// //   if (value.startsWith('http://') || value.startsWith('https://')) return value;
// //   if (value.startsWith('//')) return 'https:$value';
// //   if (value.startsWith('assets/')) return '$_webBase$value';
// //   if (value.startsWith('/assets/')) return '$_webBase${value.substring(1)}';
// //   if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
// //   return '$_apiAssetBase$value';
// // }


//   @override
//   Widget build(BuildContext context) {
//     final profileState = ref.watch(viewSingleProfileProvider);

//     if (profileState.isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(color: Colors.pink),
//       );
//     }

//     if (profileState.isError) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 48, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               profileState.errorMessage,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.red, fontSize: 14),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black, foregroundColor: Colors.white),
//               onPressed: () {
//                 ref.read(viewSingleProfileProvider.notifier).fetchProfile();
//               },
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     final data = profileState.data;
//     if (data == null) {
//       return const Center(child: Text('No profile data available'));
//     }

//     return RefreshIndicator(
//       onRefresh: () async {
//         await ref.read(viewSingleProfileProvider.notifier).fetchProfile();
//       },
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ProfileCard(data: data),
//             const SizedBox(height: 16),
//             TraitsSection(data: data),
//             // const SizedBox(height: 16),
//             // ProfileSummaryPanels(data: data),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────
// // Profile Card
// // ─────────────────────────────────────────────────────────────────────
// class ProfileCard extends StatelessWidget {
//   final ViewSingleProfileData data;
//   const ProfileCard({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     ProfileHomeTabImage(
//   initialImage: profileImage,
//   height: 360,
//   borderRadius: 5,
// )

//     final isCouple = data.profileType.toLowerCase() == 'couple';
//     final displayName = isCouple
//         ? (data.coupleFullNameFrom.isNotEmpty
//             ? data.coupleFullNameFrom
//             : data.username)
//         : (data.singleFullName.isNotEmpty
//             ? data.singleFullName
//             : data.username);

//     String displayAge;
//     if (isCouple) {
//       final age1 = calculateAge(data.person1Dob);
//       final age2 = calculateAge(data.person2Dob);
//       if (age1 > 0 && age2 > 0) {
//         displayAge = '$age1 | $age2 Years';
//       } else if (age1 > 0) {
//         displayAge = '$age1 Years';
//       } else if (age2 > 0) {
//         displayAge = '$age2 Years';
//       } else {
//         displayAge = 'Age not available';
//       }
//     } else {
//       final age = calculateAge(data.person1Dob);
//       displayAge = age > 0 ? '$age Years' : 'Age not available';
//     }

//     final genderText = data.genderProfileType.isNotEmpty ? data.genderProfileType : 'Gender not specified';

//     final locationText = data.address.isNotEmpty
//         ? data.address
//         : (data.city.isNotEmpty ? data.city : (data.address1?.isNotEmpty == true ? data.address1! : (data.city1?.isNotEmpty == true ? data.city1! : 'Location not available')));


//     final coupleTypes = <String>[];
//     if (data.coupleMaleFemaleSwingers == '1') coupleTypes.add('Swingers');
//     if (data.coupleMaleFemaleHookupMeetup == '1')
//       coupleTypes.add('HookUps/Meetups');

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFF1C0027), Color(0xFF32003E)],
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               height: 200,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 isCouple ? Icons.people_alt : Icons.person,
//                 size: 80,
//                 color: Colors.white.withValues(alpha: 0.3),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             displayName,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             displayAge,
//             style: TextStyle(
//               color: Colors.white.withValues(alpha: 0.85),
//               fontSize: 12,
//             ),
//           ),
//           Text(
//             genderText,
//             style: TextStyle(
//               color: Colors.white.withValues(alpha: 0.85),
//               fontSize: 12,
//             ),
//           ),
//           Text(
//             locationText,
//             style: TextStyle(
//               color: Colors.white.withValues(alpha: 0.85),
//               fontSize: 12,
//             ),
//           ),
//           if (isCouple && coupleTypes.isNotEmpty) ...[
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 6,
//               children: coupleTypes
//                   .map((type) => Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.pink.withValues(alpha: 0.3),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: Colors.pink),
//                         ),
//                         child: Text(
//                           type,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ))
//                   .toList(),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────
// // Traits Section
// // ─────────────────────────────────────────────────────────────────────
// // class TraitsSection extends StatelessWidget {
// //   final ViewSingleProfileData data;
// //   const TraitsSection({super.key, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final isCouple = data.profileType.toLowerCase() == 'couple';
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       physics: const BouncingScrollPhysics(),
// //       child: SizedBox(
// //         width: isCouple ? 460 : 320,
// //         child: isCouple ? _CoupleTraitsTable(data: data) : _SingleTraitsTable(data: data),
// //       ),
// //     );
// //   }
// // }


// class TraitsSection extends StatelessWidget {
//   final ViewSingleProfileData data;

//   const TraitsSection({
//     super.key,
//     required this.data,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isCouple = data.profileType.toLowerCase() == 'couple';

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       physics: const BouncingScrollPhysics(),
//       child: SizedBox(
//         width: isCouple ? 460 : 320,
//         child: isCouple
//             ? _CoupleTraitsTable(data: data)
//             : _SingleTraitsTable(data: data),
//       ),
//     );
//   }
// }
// // ─────────────────────────────────────────────────────────────────────
// // Single Traits Table
// // ─────────────────────────────────────────────────────────────────────
// class _SingleTraitsTable extends StatelessWidget {
//   final ViewSingleProfileData data;
//   const _SingleTraitsTable({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final traits = <_SingleTrait>[];

//     String formatValue(dynamic value) {
//       if (value == null || value.toString().isEmpty) {
//         return "I'm not comfortable sharing that";
//       }
//       return value.toString();
//     }

//     final age = calculateAge(data.person1Dob);
//     traits.add(_SingleTrait(
//         label: 'Age', value: age > 0 ? '$age' : 'N/A'));
//     traits.add(_SingleTrait(label: 'Tattoos', value: data.person1Tattoos));
//     traits.add(_SingleTrait(label: 'Body Hair', value: data.person1BodyHair));
//     traits.add(_SingleTrait(label: 'Weight', value: formatWeight(data.person1Weight)));
//     traits.add(_SingleTrait(label: 'Height', value: formatHeight(data.person1Height)));
//     traits.add(_SingleTrait(label: 'Smoking', value: data.person1Smoking));
//     traits.add(_SingleTrait(label: 'Drinking', value: data.person1Drinking));
//     traits.add(_SingleTrait(label: 'Body Type', value: data.person1BodyType));
//     traits.add(_SingleTrait(label: 'Languages', value: data.person1LanguageSpoken));
//     traits.add(_SingleTrait(label: 'Ethnic Background', value: data.person1EthnicBackground));
//     traits.add(_SingleTrait(label: 'Piercings', value: data.person1Piercings));
//     traits.add(_SingleTrait(label: 'Circumcised', value: data.person1Circumcised));
//     traits.add(_SingleTrait(label: 'Intelligence as Importance', value: data.person1IntelligenceImportance));
//     traits.add(_SingleTrait(label: 'Sexuality', value: data.person1Sexuality));
//     traits.add(_SingleTrait(label: 'Relationship Orientation', value: data.person1RelationshipOrientation));
//     traits.add(_SingleTrait(label: 'Looks are Important', value: data.person1LooksImportant));

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Profile Details',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2F1047))),
//         const SizedBox(height: 12),
//         ...traits.map((trait) => Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: Container(
//                       height: 32,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF180024), Color(0xFF3D0053)],
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         trait.label,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 6,
//                     child: _ValueBubble(
//                       text: trait.value ?? "I'm not comfortable sharing that",
//                       avatarIcon: Icons.person,
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//       ],
//     );
//   }

//   String? formatWeight(String? weight) =>
//       (weight == null || weight.isEmpty) ? null : '$weight KG';

//   String? formatHeight(String? height) =>
//       (height == null || height.isEmpty) ? null : '$height FT';
// }

// // ─────────────────────────────────────────────────────────────────────
// // Couple Traits Table
// // ─────────────────────────────────────────────────────────────────────
// class _CoupleTraitsTable extends StatelessWidget {
//   final ViewSingleProfileData data;
//   const _CoupleTraitsTable({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final traits = <_CoupleTrait>[];

//     String formatValueP1(dynamic value) =>
//         (value == null || value.toString().isEmpty) ? 'N/A' : value.toString();
//     String formatValueP2(dynamic value) =>
//         (value == null || value.toString().isEmpty) ? 'N/A' : value.toString();

//     final age1 = calculateAge(data.person1Dob);
//     final age2 = calculateAge(data.person2Dob);
//     traits.add(_CoupleTrait(
//       label: 'Age',
//       p1Value: age1 > 0 ? '$age1' : 'N/A',
//       p2Value: age2 > 0 ? '$age2' : 'N/A',
//     ));
//     traits.add(_CoupleTrait(
//         label: 'Tattoos',
//         p1Value: formatValueP1(data.person1Tattoos),
//         p2Value: formatValueP2(data.person2Tattoos)));
//     traits.add(_CoupleTrait(
//         label: 'Body Hair',
//         p1Value: formatValueP1(data.person1BodyHair),
//         p2Value: formatValueP2(data.person2BodyHair)));
//     traits.add(_CoupleTrait(
//         label: 'Weight',
//         p1Value: formatWeightP1(data.person1Weight),
//         p2Value: formatWeightP2(data.person2Weight)));
//     traits.add(_CoupleTrait(
//         label: 'Height',
//         p1Value: formatHeightP1(data.person1Height),
//         p2Value: formatHeightP2(data.person2Height)));
//     traits.add(_CoupleTrait(
//         label: 'Smoking',
//         p1Value: formatValueP1(data.person1Smoking),
//         p2Value: formatValueP2(data.person2Smoking)));
//     traits.add(_CoupleTrait(
//         label: 'Drinking',
//         p1Value: formatValueP1(data.person1Drinking),
//         p2Value: formatValueP2(data.person2Drinking)));
//     traits.add(_CoupleTrait(
//         label: 'Body Type',
//         p1Value: formatValueP1(data.person1BodyType),
//         p2Value: formatValueP2(data.person2BodyType)));
//     traits.add(_CoupleTrait(
//         label: 'Languages',
//         p1Value: formatValueP1(data.person1LanguageSpoken),
//         p2Value: formatValueP2(data.person2LanguageSpoken)));
//     traits.add(_CoupleTrait(
//         label: 'Ethnic Background',
//         p1Value: formatValueP1(data.person1EthnicBackground),
//         p2Value: formatValueP2(data.person2EthnicBackground)));
//     traits.add(_CoupleTrait(
//         label: 'Piercings',
//         p1Value: formatValueP1(data.person1Piercings),
//         p2Value: formatValueP2(data.person2Piercings)));
//     traits.add(_CoupleTrait(
//         label: 'Circumcised',
//         p1Value: formatValueP1(data.person1Circumcised),
//         p2Value: formatValueP2(data.person2Circumcised)));
//     traits.add(_CoupleTrait(
//         label: 'Intelligence as Importance',
//         p1Value: formatValueP1(data.person1IntelligenceImportance),
//         p2Value: formatValueP2(data.person2IntelligenceImportance)));
//     traits.add(_CoupleTrait(
//         label: 'Sexuality',
//         p1Value: formatValueP1(data.person1Sexuality),
//         p2Value: formatValueP2(data.person2Sexuality)));
//     traits.add(_CoupleTrait(
//         label: 'Relationship Orientation',
//         p1Value: formatValueP1(data.person1RelationshipOrientation),
//         p2Value: formatValueP2(data.person2RelationshipOrientation)));
//     traits.add(_CoupleTrait(
//         label: 'Looks are Important',
//         p1Value: formatValueP1(data.person1LooksImportant),
//         p2Value: formatValueP2(data.person2LooksImportant)));

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Expanded(flex: 5, child: SizedBox()),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 5,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                       colors: [Color(0xFF180024), Color(0xFF3D0053)]),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(data.person1Name,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12)),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 5,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                       colors: [Color(0xFF180024), Color(0xFF3D0053)]),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(data.person2Name,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12)),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         const Text('Profile Details',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2F1047))),
//         const SizedBox(height: 12),
//         ...traits.map((trait) => Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: Container(
//                       height: 32,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                             colors: [Color(0xFF180024), Color(0xFF3D0053)]),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(trait.label,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 11)),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     flex: 5,
//                     child: _ValueBubble(
//                       text: trait.p1Value,
//                       avatarIcon: Icons.person,
//                       avatarColor: const Color(0xFF3B6CB7),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     flex: 5,
//                     child: _ValueBubble(
//                       text: trait.p2Value,
//                       avatarIcon: Icons.person_2,
//                       avatarColor: const Color(0xFFE91E63),
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//       ],
//     );
//   }

//   String formatWeightP1(String? w) => (w == null || w.isEmpty) ? 'N/A' : '$w KG';
//   String formatWeightP2(String? w) => (w == null || w.isEmpty) ? 'N/A' : '$w KG';
//   String formatHeightP1(String? h) => (h == null || h.isEmpty) ? 'N/A' : '$h FT';
//   String formatHeightP2(String? h) => (h == null || h.isEmpty) ? 'N/A' : '$h FT';
// }

// // ─────────────────────────────────────────────────────────────────────
// // Value Bubble
// // ─────────────────────────────────────────────────────────────────────
// class _ValueBubble extends StatelessWidget {
//   final String text;
//   final IconData avatarIcon;
//   final Color avatarColor;

//   const _ValueBubble({
//     required this.text,
//     required this.avatarIcon,
//     this.avatarColor = const Color(0xFF3B6CB7),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 30,
//           height: 30,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: LinearGradient(
//               colors: [
//                 avatarColor.withValues(alpha: 0.1),
//                 avatarColor.withValues(alpha: 0.2)
//               ],
//             ),
//             border: Border.all(color: avatarColor.withValues(alpha: 0.5)),
//           ),
//           child: Icon(avatarIcon, size: 16, color: avatarColor),
//         ),
//         const SizedBox(width: 6),
//         Expanded(
//           child: Container(
//             height: 30,
//             alignment: Alignment.center,
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: const Color(0xFFE6DFF0)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.purple.withValues(alpha: 0.08),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Text(
//               text,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 11,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // // ─────────────────────────────────────────────────────────────────────
// // // Profile Summary Panels
// // // ─────────────────────────────────────────────────────────────────────
// // class ProfileSummaryPanels extends StatelessWidget {
// //   final ViewSingleProfileData data;
// //   const ProfileSummaryPanels({super.key, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final aboutText = data.comment ?? 'No information provided';
// //     final lookingForText = data.text ?? 'No information provided';

// //     return LayoutBuilder(
// //       builder: (context, constraints) {
// //         final isCompact = constraints.maxWidth < 640;
// //         if (isCompact) {
// //           return Column(
// //             children: [
// //               InfoPanel(title: 'About', content: aboutText),
// //               const SizedBox(height: 10),
// //               InfoPanel(title: 'Interests', content: lookingForText),
// //             ],
// //           );
// //         }
// //         return Row(
// //           children: [
// //             Expanded(child: InfoPanel(title: 'About', content: aboutText)),
// //             const SizedBox(width: 10),
// //             Expanded(child: InfoPanel(title: 'Interests', content: lookingForText)),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }

// // class InfoPanel extends StatelessWidget {
// //   final String title;
// //   final String content;
// //   const InfoPanel({super.key, required this.title, required this.content});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFFBF8FF),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: const Color(0xFFE5DDF2)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(title,
// //               style: const TextStyle(
// //                   fontSize: 13,
// //                   fontWeight: FontWeight.w700,
// //                   color: Color(0xFF2F1047))),
// //           const SizedBox(height: 6),
// //           Text(content,
// //               style: TextStyle(fontSize: 12, height: 1.3, color: Colors.grey[800])),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // ─────────────────────────────────────────────────────────────────────
// // Helper Classes
// // ─────────────────────────────────────────────────────────────────────
// class _SingleTrait {
//   final String label;
//   final String? value;
//   _SingleTrait({required this.label, required this.value});
// }

// class _CoupleTrait {
//   final String label;
//   final String p1Value;
//   final String p2Value;
//   _CoupleTrait({required this.label, required this.p1Value, required this.p2Value});
// }



// class ProfileHomeImageResult {
//   const ProfileHomeImageResult({
//     required this.imageUrl,
//     required this.rawImage,
//     required this.imageId,
//     required this.isMain,
//   });

//   final String imageUrl;
//   final String rawImage;
//   final String imageId;
//   final bool isMain;
// }

// /// Fetches the image used on the left profile card in the Home tab.
// ///
// /// Website API used:
// /// GET https://app.beatflirtevent.com/App/user/signle_user_profile_image
// ///
// /// It picks the image where `set_profile == "1"`. If there is no main image,
// /// it falls back to the first image in the response.
// Future<ProfileHomeImageResult?> fetchProfileHomeTabImage({
//   String? accessToken,
//   String? accessSign,
//   String apiBaseUrl = 'https://app.beatflirtevent.com/App',
//   http.Client? client,
// }) async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = accessToken ?? prefs.getString('Access-Token') ?? '';
//   final sign = accessSign ?? prefs.getString('Access-Sign') ?? '';
//   final httpClient = client ?? http.Client();

//   final response = await httpClient.get(
//     Uri.parse('$apiBaseUrl/user/signle_user_profile_image'),
//     headers: {
//       'Content-Type': 'application/json; charset=UTF-8',
//       if (token.isNotEmpty) 'Access-Token': token,
//       if (sign.isNotEmpty) 'Access-Sign': sign,
//     },
//   );

//   if (response.statusCode < 200 || response.statusCode >= 300) {
//     throw Exception(
//       'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Profile image request failed'}',
//     );
//   }

//   final decoded = jsonDecode(response.body);
//   if (decoded is! Map || decoded['status']?.toString() != '200') return null;

//   final data = decoded['data'];
//   if (data is! List || data.isEmpty) return null;

//   Map<String, dynamic>? selected;

//   for (final item in data) {
//     if (item is Map && item['set_profile']?.toString() == '1') {
//       selected = Map<String, dynamic>.from(item);
//       break;
//     }
//   }

//   selected ??= Map<String, dynamic>.from(data.first as Map);

//   final rawImage = selected['profile_image']?.toString() ?? '';

//   return ProfileHomeImageResult(
//     imageUrl: resolveBeatMediaUrl(rawImage),
//     rawImage: rawImage,
//     imageId: selected['id']?.toString() ?? '',
//     isMain: selected['set_profile']?.toString() == '1',
//   );
// }


// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:beatflirt/core/services/token_services.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // // ═══════════════════════════════════════════════════════════════════
// // //                          MODEL
// // // ═══════════════════════════════════════════════════════════════════

// // class ViewSingleProfileData {
// //   final String id;
// //   final String username;
// //   final String email;
// //   final String profileType;
// //   final String genderProfileType;
// //   final String singleProfileGenderFrom;
// //   final String coupleProfileGenderFrom;
// //   final String coupleProfileGenderTo;
// //   final String singleFullName;
// //   final String coupleFullNameFrom;
// //   final String coupleFullNameTo;
// //   final String created;
// //   final String lastPayment;
// //   final String expireDate;
// //   final String lat;
// //   final String lng;
// //   final String city;
// //   final String placeId;
// //   final String mapUrl;
// //   final String address;
// //   final String? lat1;
// //   final String? lng1;
// //   final String? city1;
// //   final String? placeId1;
// //   final String? mapUrl1;
// //   final String? address1;
// //   final String? distance;
// //   final String person1Name;
// //   final String person2Name;
// //   final String coupleMaleFemaleSwingers;
// //   final String coupleMaleFemaleHookupMeetup;
// //   final String coupleFemaleFemaleSwingers;
// //   final String coupleFemaleFemaleHookupMeetup;
// //   final String coupleMaleMaleSwingers;
// //   final String coupleMaleMaleHookupMeetup;
// //   final String coupleMaleSwingers;
// //   final String coupleMaleHookupMeetup;
// //   final String coupleFemaleSwingers;
// //   final String coupleFemaleHookupMeetup;
// //   final String coupleTransgenderSwingers;
// //   final String coupleTransgenderHookupMeetup;
// //   final String? text;
// //   final String? comment;
// //   final String person1Dob;
// //   final int age;
// //   final String? person1BodyHair;
// //   final String? height1Type;
// //   final String? weight1Type;
// //   final String? person1Height;
// //   final String? person1Weight;
// //   final String? person1BodyType;
// //   final String? person1EthnicBackground;
// //   final String? person1Piercings;
// //   final String? person1Tattoos;
// //   final String? person1LanguageSpoken;
// //   final String? person1Circumcised;
// //   final String? person1Smoking;
// //   final String? person1Drinking;
// //   final String? person1IntelligenceImportance;
// //   final String? person1Sexuality;
// //   final String? person1RelationshipOrientation;
// //   final String? person1LooksImportant;
// //   final String person2Dob;
// //   final int age2;
// //   final String? person2BodyHair;
// //   final String? height2Type;
// //   final String? weight2Type;
// //   final String? person2Height;
// //   final String? person2Weight;
// //   final String? person2BodyType;
// //   final String? person2EthnicBackground;
// //   final String? person2Piercings;
// //   final String? person2Tattoos;
// //   final String? person2LanguageSpoken;
// //   final String? person2Circumcised;
// //   final String? person2Smoking;
// //   final String? person2Drinking;
// //   final String? person2IntelligenceImportance;
// //   final String? person2Sexuality;
// //   final String? person2RelationshipOrientation;
// //   final String? person2LooksImportant;

// //   ViewSingleProfileData({
// //     required this.id,
// //     required this.username,
// //     required this.email,
// //     required this.profileType,
// //     required this.genderProfileType,
// //     required this.singleProfileGenderFrom,
// //     required this.coupleProfileGenderFrom,
// //     required this.coupleProfileGenderTo,
// //     required this.singleFullName,
// //     required this.coupleFullNameFrom,
// //     required this.coupleFullNameTo,
// //     required this.created,
// //     required this.lastPayment,
// //     required this.expireDate,
// //     required this.lat,
// //     required this.lng,
// //     required this.city,
// //     required this.placeId,
// //     required this.mapUrl,
// //     required this.address,
// //     this.lat1,
// //     this.lng1,
// //     this.city1,
// //     this.placeId1,
// //     this.mapUrl1,
// //     this.address1,
// //     this.distance,
// //     required this.person1Name,
// //     required this.person2Name,
// //     required this.coupleMaleFemaleSwingers,
// //     required this.coupleMaleFemaleHookupMeetup,
// //     required this.coupleFemaleFemaleSwingers,
// //     required this.coupleFemaleFemaleHookupMeetup,
// //     required this.coupleMaleMaleSwingers,
// //     required this.coupleMaleMaleHookupMeetup,
// //     required this.coupleMaleSwingers,
// //     required this.coupleMaleHookupMeetup,
// //     required this.coupleFemaleSwingers,
// //     required this.coupleFemaleHookupMeetup,
// //     required this.coupleTransgenderSwingers,
// //     required this.coupleTransgenderHookupMeetup,
// //     this.text,
// //     this.comment,
// //     required this.person1Dob,
// //     required this.age,
// //     this.person1BodyHair,
// //     this.height1Type,
// //     this.weight1Type,
// //     this.person1Height,
// //     this.person1Weight,
// //     this.person1BodyType,
// //     this.person1EthnicBackground,
// //     this.person1Piercings,
// //     this.person1Tattoos,
// //     this.person1LanguageSpoken,
// //     this.person1Circumcised,
// //     this.person1Smoking,
// //     this.person1Drinking,
// //     this.person1IntelligenceImportance,
// //     this.person1Sexuality,
// //     this.person1RelationshipOrientation,
// //     this.person1LooksImportant,
// //     required this.person2Dob,
// //     required this.age2,
// //     this.person2BodyHair,
// //     this.height2Type,
// //     this.weight2Type,
// //     this.person2Height,
// //     this.person2Weight,
// //     this.person2BodyType,
// //     this.person2EthnicBackground,
// //     this.person2Piercings,
// //     this.person2Tattoos,
// //     this.person2LanguageSpoken,
// //     this.person2Circumcised,
// //     this.person2Smoking,
// //     this.person2Drinking,
// //     this.person2IntelligenceImportance,
// //     this.person2Sexuality,
// //     this.person2RelationshipOrientation,
// //     this.person2LooksImportant,
// //   });

// //   factory ViewSingleProfileData.fromJson(Map<String, dynamic> json) {
// //     return ViewSingleProfileData(
// //       id: json['id'] ?? '',
// //       username: json['username'] ?? '',
// //       email: json['email'] ?? '',
// //       profileType: json['profile_type'] ?? '',
// //       genderProfileType: json['gender_profile_type'] ?? '',
// //       singleProfileGenderFrom: json['single_profile_gender_from'] ?? '',
// //       coupleProfileGenderFrom: json['couple_profile_gender_from'] ?? '',
// //       coupleProfileGenderTo: json['couple_profile_gender_to'] ?? '',
// //       singleFullName: json['single_full_name'] ?? '',
// //       coupleFullNameFrom: json['couple_full_name_from'] ?? '',
// //       coupleFullNameTo: json['couple_full_name_to'] ?? '',
// //       created: json['created'] ?? '',
// //       lastPayment: json['last_payment'] ?? '',
// //       expireDate: json['expire_date'] ?? '',
// //       lat: json['lat'] ?? '',
// //       lng: json['lng'] ?? '',
// //       city: json['city'] ?? '',
// //       placeId: json['place_id'] ?? '',
// //       mapUrl: json['map_url'] ?? '',
// //       address: json['address'] ?? '',
// //       lat1: json['lat_1'],
// //       lng1: json['lng_1'],
// //       city1: json['city_1'],
// //       placeId1: json['place_id_1'],
// //       mapUrl1: json['map_url_1'],
// //       address1: json['address_1'],
// //       distance: json['distance'],
// //       person1Name: json['person1_name'] ?? 'Person 1',
// //       person2Name: json['person2_name'] ?? 'Person 2',
// //       coupleMaleFemaleSwingers: json['couple_male_female_swingers'] ?? '0',
// //       coupleMaleFemaleHookupMeetup:
// //           json['couple_male_female_hookup_meetup'] ?? '0',
// //       coupleFemaleFemaleSwingers:
// //           json['couple_female_female_swingers'] ?? '0',
// //       coupleFemaleFemaleHookupMeetup:
// //           json['couple_female_female_hookup_meetup'] ?? '0',
// //       coupleMaleMaleSwingers: json['couple_male_male_swingers'] ?? '0',
// //       coupleMaleMaleHookupMeetup:
// //           json['couple_male_male_hookup_meetup'] ?? '0',
// //       coupleMaleSwingers: json['couple_male_swingers'] ?? '0',
// //       coupleMaleHookupMeetup: json['couple_male_hookup_meetup'] ?? '0',
// //       coupleFemaleSwingers: json['couple_female_swingers'] ?? '0',
// //       coupleFemaleHookupMeetup: json['couple_female_hookup_meetup'] ?? '0',
// //       coupleTransgenderSwingers: json['couple_transgender_swingers'] ?? '0',
// //       coupleTransgenderHookupMeetup:
// //           json['couple_transgender_hookup_meetup'] ?? '0',
// //       text: json['text'],
// //       comment: json['comment'],
// //       person1Dob: json['person1_dob'] ?? '',
// //       age: json['age'] ?? 0,
// //       person1BodyHair: json['person1_body_hair'],
// //       height1Type: json['height1_type'],
// //       weight1Type: json['weight1_type'],
// //       person1Height: json['person1_height'],
// //       person1Weight: json['person1_weight'],
// //       person1BodyType: json['person1_body_type'],
// //       person1EthnicBackground: json['person1_ethnic_background'],
// //       person1Piercings: json['person1_piercings'],
// //       person1Tattoos: json['person1_tattoos'],
// //       person1LanguageSpoken: json['person1_language_spoken'],
// //       person1Circumcised: json['person1_circumcised'],
// //       person1Smoking: json['person1_smoking'],
// //       person1Drinking: json['person1_drinking'],
// //       person1IntelligenceImportance: json['person1_intelligence_importance'],
// //       person1Sexuality: json['person1_sexuality'],
// //       person1RelationshipOrientation: json['person1_relationship_orientation'],
// //       person1LooksImportant: json['person1_looks_important'],
// //       person2Dob: json['person2_dob'] ?? '',
// //       age2: json['age2'] ?? 0,
// //       person2BodyHair: json['person2_body_hair'],
// //       height2Type: json['height2_type'],
// //       weight2Type: json['weight2_type'],
// //       person2Height: json['person2_height'],
// //       person2Weight: json['person2_weight'],
// //       person2BodyType: json['person2_body_type'],
// //       person2EthnicBackground: json['person2_ethnic_background'],
// //       person2Piercings: json['person2_piercings'],
// //       person2Tattoos: json['person2_tattoos'],
// //       person2LanguageSpoken: json['person2_language_spoken'],
// //       person2Circumcised: json['person2_circumcised'],
// //       person2Smoking: json['person2_smoking'],
// //       person2Drinking: json['person2_drinking'],
// //       person2IntelligenceImportance: json['person2_intelligence_importance'],
// //       person2Sexuality: json['person2_sexuality'],
// //       person2RelationshipOrientation: json['person2_relationship_orientation'],
// //       person2LooksImportant: json['person2_looks_important'],
// //     );
// //   }
// // }

// // class ViewSingleProfileState {
// //   final bool isLoading;
// //   final bool isError;
// //   final String errorMessage;
// //   final ViewSingleProfileData? data;

// //   ViewSingleProfileState({
// //     this.isLoading = false,
// //     this.isError = false,
// //     this.errorMessage = '',
// //     this.data,
// //   });

// //   ViewSingleProfileState copyWith({
// //     bool? isLoading,
// //     bool? isError,
// //     String? errorMessage,
// //     ViewSingleProfileData? data,
// //   }) {
// //     return ViewSingleProfileState(
// //       isLoading: isLoading ?? this.isLoading,
// //       isError: isError ?? this.isError,
// //       errorMessage: errorMessage ?? this.errorMessage,
// //       data: data ?? this.data,
// //     );
// //   }
// // }

// // // ═══════════════════════════════════════════════════════════════════
// // //                          PROVIDER
// // // ═══════════════════════════════════════════════════════════════════

// // final viewSingleProfileProvider =
// //     StateNotifierProvider<ViewSingleProfileNotifier, ViewSingleProfileState>(
// //         (ref) => ViewSingleProfileNotifier());

// // class ViewSingleProfileNotifier extends StateNotifier<ViewSingleProfileState> {
// //   ViewSingleProfileNotifier() : super(ViewSingleProfileState());

// //   final TokenService _tokenService = TokenService();

// //   Future<void> fetchProfile() async {
// //     state = state.copyWith(isLoading: true, isError: false, errorMessage: '');

// //     try {
// //       final token = await _tokenService.getAccessToken();

// //       if (token == null || token.isEmpty) {
// //         state = state.copyWith(
// //           isLoading: false,
// //           isError: true,
// //           errorMessage: 'Authentication token is missing. Please log in again.',
// //         );
// //         return;
// //       }

// //       print('========== FETCHING PROFILE (HOME TAB) ==========');
// //       print('TOKEN length: ${token.length}');

// //       final uri = Uri.parse(
// //           'https://app.beatflirtevent.com/App/user/signle_user_profile');

// //       final response = await http.post(
// //         uri,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'access-token': token,
// //           'Content-Type': 'application/json',
// //           'Accept': 'application/json',
// //         },
// //       );

// //       print('FETCH STATUS: ${response.statusCode}');
// //       print('FETCH BODY: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final Map<String, dynamic> jsonResponse =
// //             json.decode(response.body) as Map<String, dynamic>;

// //         if (jsonResponse['status'] == '200' && jsonResponse['data'] != null) {
// //           final data = ViewSingleProfileData.fromJson(jsonResponse['data']);
// //           state = state.copyWith(isLoading: false, data: data);
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

// // // ═══════════════════════════════════════════════════════════════════
// // //                          WIDGETS
// // // ═══════════════════════════════════════════════════════════════════

// // /// Helper to calculate age from YYYY-MM-DD format
// // int calculateAge(String? dob) {
// //   if (dob == null || dob.isEmpty) return 0;
// //   try {
// //     final parts = dob.split('-');
// //     if (parts.length != 3) return 0;
// //     final birthDate = DateTime(
// //       int.parse(parts[0]),
// //       int.parse(parts[1]),
// //       int.parse(parts[2]),
// //     );
// //     final today = DateTime.now();
// //     int age = today.year - birthDate.year;
// //     if (today.month < birthDate.month ||
// //         (today.month == birthDate.month && today.day < birthDate.day)) {
// //       age--;
// //     }
// //     return age;
// //   } catch (_) {
// //     return 0;
// //   }
// // }

// // class ViewSingleProfileHomeTab extends ConsumerStatefulWidget {
// //   const ViewSingleProfileHomeTab({super.key});

// //   @override
// //   ConsumerState<ViewSingleProfileHomeTab> createState() =>
// //       _ViewSingleProfileHomeTabState();
// // }

// // class _ViewSingleProfileHomeTabState
// //     extends ConsumerState<ViewSingleProfileHomeTab> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final profileState = ref.watch(viewSingleProfileProvider);

// //     if (profileState.isLoading) {
// //       return const Center(
// //         child: CircularProgressIndicator(color: Colors.pink),
// //       );
// //     }

// //     if (profileState.isError) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Icon(Icons.error_outline, size: 48, color: Colors.red),
// //             const SizedBox(height: 16),
// //             Text(
// //               profileState.errorMessage,
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(color: Colors.red, fontSize: 14),
// //             ),
// //             const SizedBox(height: 16),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.black, foregroundColor: Colors.white),
// //               onPressed: () {
// //                 ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// //               },
// //               child: const Text('Retry'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     final data = profileState.data;
// //     if (data == null) {
// //       return const Center(child: Text('No profile data available'));
// //     }

// //     return RefreshIndicator(
// //       onRefresh: () async {
// //         await ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// //       },
// //       child: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             ProfileCard(data: data),
// //             const SizedBox(height: 16),
// //             TraitsSection(data: data),
// //             const SizedBox(height: 16),
// //             ProfileSummaryPanels(data: data),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────
// // // Profile Card
// // // ─────────────────────────────────────────────────────────────────────
// // class ProfileCard extends StatelessWidget {
// //   final ViewSingleProfileData data;
// //   const ProfileCard({super.key, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final isCouple = data.profileType.toLowerCase() == 'couple';
// //     final displayName = isCouple
// //         ? (data.coupleFullNameFrom.isNotEmpty
// //             ? data.coupleFullNameFrom
// //             : data.username)
// //         : (data.singleFullName.isNotEmpty
// //             ? data.singleFullName
// //             : data.username);

// //     String displayAge;
// //     if (isCouple) {
// //       final age1 = calculateAge(data.person1Dob);
// //       final age2 = calculateAge(data.person2Dob);
// //       displayAge = age2 > 0 ? '$age1 | $age2 Years' : '$age1 Years';
// //     } else {
// //       displayAge = '${calculateAge(data.person1Dob)} Years';
// //     }

// //     final genderText = isCouple
// //         ? '${data.genderProfileType} | ${data.genderProfileType}'
// //         : data.genderProfileType;

// //     final locationText = data.address.isNotEmpty
// //         ? data.address
// //         : (data.city.isNotEmpty ? data.city : 'Location not available');

// //     final coupleTypes = <String>[];
// //     if (data.coupleMaleFemaleSwingers == '1') coupleTypes.add('Swingers');
// //     if (data.coupleMaleFemaleHookupMeetup == '1')
// //       coupleTypes.add('HookUps/Meetups');

// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //           colors: [Color(0xFF1C0027), Color(0xFF32003E)],
// //         ),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(8),
// //             child: Container(
// //               height: 200,
// //               width: double.infinity,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[900],
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Icon(
// //                 isCouple ? Icons.people_alt : Icons.person,
// //                 size: 80,
// //                 color: Colors.white.withValues(alpha: 0.3),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           Text(
// //             displayName,
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontWeight: FontWeight.w700,
// //               fontSize: 16,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             displayAge,
// //             style: TextStyle(
// //               color: Colors.white.withValues(alpha: 0.85),
// //               fontSize: 12,
// //             ),
// //           ),
// //           Text(
// //             genderText,
// //             style: TextStyle(
// //               color: Colors.white.withValues(alpha: 0.85),
// //               fontSize: 12,
// //             ),
// //           ),
// //           Text(
// //             locationText,
// //             style: TextStyle(
// //               color: Colors.white.withValues(alpha: 0.85),
// //               fontSize: 12,
// //             ),
// //           ),
// //           if (isCouple && coupleTypes.isNotEmpty) ...[
// //             const SizedBox(height: 8),
// //             Wrap(
// //               spacing: 6,
// //               children: coupleTypes
// //                   .map((type) => Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 12, vertical: 6),
// //                         decoration: BoxDecoration(
// //                           color: Colors.pink.withValues(alpha: 0.3),
// //                           borderRadius: BorderRadius.circular(20),
// //                           border: Border.all(color: Colors.pink),
// //                         ),
// //                         child: Text(
// //                           type,
// //                           style: const TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.w600,
// //                             fontSize: 11,
// //                           ),
// //                         ),
// //                       ))
// //                   .toList(),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────
// // // Traits Section
// // // ─────────────────────────────────────────────────────────────────────
// // class TraitsSection extends StatelessWidget {
// //   final ViewSingleProfileData data;
// //   const TraitsSection({super.key, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final isCouple = data.profileType.toLowerCase() == 'couple';
// //     return isCouple ? _CoupleTraitsTable(data: data) : _SingleTraitsTable(data: data);
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────
// // // Single Traits Table
// // // ─────────────────────────────────────────────────────────────────────
// // class _SingleTraitsTable extends StatelessWidget {
// //   final ViewSingleProfileData data;
// //   const _SingleTraitsTable({required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final traits = <_SingleTrait>[];

// //     String formatValue(dynamic value) {
// //       if (value == null || value.toString().isEmpty) {
// //         return "I'm not comfortable sharing that";
// //       }
// //       return value.toString();
// //     }

// //     traits.add(_SingleTrait(
// //         label: 'Age', value: '${calculateAge(data.person1Dob)} Years'));
// //     traits.add(_SingleTrait(label: 'Tattoos', value: data.person1Tattoos));
// //     traits.add(_SingleTrait(label: 'Body Hair', value: data.person1BodyHair));
// //     traits.add(_SingleTrait(label: 'Weight', value: formatWeight(data.person1Weight)));
// //     traits.add(_SingleTrait(label: 'Height', value: formatHeight(data.person1Height)));
// //     traits.add(_SingleTrait(label: 'Smoking', value: data.person1Smoking));
// //     traits.add(_SingleTrait(label: 'Drinking', value: data.person1Drinking));
// //     traits.add(_SingleTrait(label: 'Body Type', value: data.person1BodyType));
// //     traits.add(_SingleTrait(label: 'Languages', value: data.person1LanguageSpoken));
// //     traits.add(_SingleTrait(label: 'Ethnic Background', value: data.person1EthnicBackground));
// //     traits.add(_SingleTrait(label: 'Piercings', value: data.person1Piercings));
// //     traits.add(_SingleTrait(label: 'Circumcised', value: data.person1Circumcised));
// //     traits.add(_SingleTrait(label: 'Intelligence as Importance', value: data.person1IntelligenceImportance));
// //     traits.add(_SingleTrait(label: 'Sexuality', value: data.person1Sexuality));
// //     traits.add(_SingleTrait(label: 'Relationship Orientation', value: data.person1RelationshipOrientation));
// //     traits.add(_SingleTrait(label: 'Looks are Important', value: data.person1LooksImportant));

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text('Profile Details',
// //             style: TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color(0xFF2F1047))),
// //         const SizedBox(height: 12),
// //         ...traits.map((trait) => Padding(
// //               padding: const EdgeInsets.only(bottom: 10),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     flex: 5,
// //                     child: Container(
// //                       height: 32,
// //                       alignment: Alignment.center,
// //                       decoration: BoxDecoration(
// //                         gradient: const LinearGradient(
// //                           colors: [Color(0xFF180024), Color(0xFF3D0053)],
// //                         ),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Text(
// //                         trait.label,
// //                         textAlign: TextAlign.center,
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w700,
// //                           fontSize: 11,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     flex: 6,
// //                     child: _ValueBubble(
// //                       text: trait.value ?? "I'm not comfortable sharing that",
// //                       avatarIcon: Icons.person,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             )),
// //       ],
// //     );
// //   }

// //   String? formatWeight(String? weight) =>
// //       (weight == null || weight.isEmpty) ? null : '$weight KG';

// //   String? formatHeight(String? height) =>
// //       (height == null || height.isEmpty) ? null : '$height FT';
// // }

// // // ─────────────────────────────────────────────────────────────────────
// // // Couple Traits Table
// // // ─────────────────────────────────────────────────────────────────────
// // class _CoupleTraitsTable extends StatelessWidget {
// //   final ViewSingleProfileData data;
// //   const _CoupleTraitsTable({required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final traits = <_CoupleTrait>[];

// //     String formatValueP1(dynamic value) =>
// //         (value == null || value.toString().isEmpty) ? 'N/A' : value.toString();
// //     String formatValueP2(dynamic value) =>
// //         (value == null || value.toString().isEmpty) ? 'N/A' : value.toString();

// //     traits.add(_CoupleTrait(
// //       label: 'Age',
// //       p1Value: '${calculateAge(data.person1Dob)} Years',
// //       p2Value: '${calculateAge(data.person2Dob)} Years',
// //     ));
// //     traits.add(_CoupleTrait(
// //         label: 'Tattoos',
// //         p1Value: formatValueP1(data.person1Tattoos),
// //         p2Value: formatValueP2(data.person2Tattoos)));
// //     traits.add(_CoupleTrait(
// //         label: 'Body Hair',
// //         p1Value: formatValueP1(data.person1BodyHair),
// //         p2Value: formatValueP2(data.person2BodyHair)));
// //     traits.add(_CoupleTrait(
// //         label: 'Weight',
// //         p1Value: formatWeightP1(data.person1Weight),
// //         p2Value: formatWeightP2(data.person2Weight)));
// //     traits.add(_CoupleTrait(
// //         label: 'Height',
// //         p1Value: formatHeightP1(data.person1Height),
// //         p2Value: formatHeightP2(data.person2Height)));
// //     traits.add(_CoupleTrait(
// //         label: 'Smoking',
// //         p1Value: formatValueP1(data.person1Smoking),
// //         p2Value: formatValueP2(data.person2Smoking)));
// //     traits.add(_CoupleTrait(
// //         label: 'Drinking',
// //         p1Value: formatValueP1(data.person1Drinking),
// //         p2Value: formatValueP2(data.person2Drinking)));
// //     traits.add(_CoupleTrait(
// //         label: 'Body Type',
// //         p1Value: formatValueP1(data.person1BodyType),
// //         p2Value: formatValueP2(data.person2BodyType)));
// //     traits.add(_CoupleTrait(
// //         label: 'Languages',
// //         p1Value: formatValueP1(data.person1LanguageSpoken),
// //         p2Value: formatValueP2(data.person2LanguageSpoken)));
// //     traits.add(_CoupleTrait(
// //         label: 'Ethnic Background',
// //         p1Value: formatValueP1(data.person1EthnicBackground),
// //         p2Value: formatValueP2(data.person2EthnicBackground)));
// //     traits.add(_CoupleTrait(
// //         label: 'Piercings',
// //         p1Value: formatValueP1(data.person1Piercings),
// //         p2Value: formatValueP2(data.person2Piercings)));
// //     traits.add(_CoupleTrait(
// //         label: 'Circumcised',
// //         p1Value: formatValueP1(data.person1Circumcised),
// //         p2Value: formatValueP2(data.person2Circumcised)));
// //     traits.add(_CoupleTrait(
// //         label: 'Intelligence as Importance',
// //         p1Value: formatValueP1(data.person1IntelligenceImportance),
// //         p2Value: formatValueP2(data.person2IntelligenceImportance)));
// //     traits.add(_CoupleTrait(
// //         label: 'Sexuality',
// //         p1Value: formatValueP1(data.person1Sexuality),
// //         p2Value: formatValueP2(data.person2Sexuality)));
// //     traits.add(_CoupleTrait(
// //         label: 'Relationship Orientation',
// //         p1Value: formatValueP1(data.person1RelationshipOrientation),
// //         p2Value: formatValueP2(data.person2RelationshipOrientation)));
// //     traits.add(_CoupleTrait(
// //         label: 'Looks are Important',
// //         p1Value: formatValueP1(data.person1LooksImportant),
// //         p2Value: formatValueP2(data.person2LooksImportant)));

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             const Expanded(flex: 5, child: SizedBox()),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               flex: 5,
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(vertical: 8),
// //                 alignment: Alignment.center,
// //                 decoration: BoxDecoration(
// //                   gradient: const LinearGradient(
// //                       colors: [Color(0xFF180024), Color(0xFF3D0053)]),
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: Text(data.person1Name,
// //                     style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.w700,
// //                         fontSize: 12)),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               flex: 5,
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(vertical: 8),
// //                 alignment: Alignment.center,
// //                 decoration: BoxDecoration(
// //                   gradient: const LinearGradient(
// //                       colors: [Color(0xFF180024), Color(0xFF3D0053)]),
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: Text(data.person2Name,
// //                     style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.w700,
// //                         fontSize: 12)),
// //               ),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 12),
// //         const Text('Profile Details',
// //             style: TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color(0xFF2F1047))),
// //         const SizedBox(height: 12),
// //         ...traits.map((trait) => Padding(
// //               padding: const EdgeInsets.only(bottom: 10),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     flex: 5,
// //                     child: Container(
// //                       height: 32,
// //                       alignment: Alignment.center,
// //                       decoration: BoxDecoration(
// //                         gradient: const LinearGradient(
// //                             colors: [Color(0xFF180024), Color(0xFF3D0053)]),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Text(trait.label,
// //                           textAlign: TextAlign.center,
// //                           style: const TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: 11)),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   Expanded(
// //                     flex: 5,
// //                     child: _ValueBubble(
// //                       text: trait.p1Value,
// //                       avatarIcon: Icons.person,
// //                       avatarColor: const Color(0xFF3B6CB7),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   Expanded(
// //                     flex: 5,
// //                     child: _ValueBubble(
// //                       text: trait.p2Value,
// //                       avatarIcon: Icons.person_2,
// //                       avatarColor: const Color(0xFFE91E63),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             )),
// //       ],
// //     );
// //   }

// //   String formatWeightP1(String? w) => (w == null || w.isEmpty) ? 'N/A' : '$w KG';
// //   String formatWeightP2(String? w) => (w == null || w.isEmpty) ? 'N/A' : '$w KG';
// //   String formatHeightP1(String? h) => (h == null || h.isEmpty) ? 'N/A' : '$h FT';
// //   String formatHeightP2(String? h) => (h == null || h.isEmpty) ? 'N/A' : '$h FT';
// // }

// // // ─────────────────────────────────────────────────────────────────────
// // // Value Bubble
// // // ─────────────────────────────────────────────────────────────────────
// // class _ValueBubble extends StatelessWidget {
// //   final String text;
// //   final IconData avatarIcon;
// //   final Color avatarColor;

// //   const _ValueBubble({
// //     required this.text,
// //     required this.avatarIcon,
// //     this.avatarColor = const Color(0xFF3B6CB7),
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         Container(
// //           width: 30,
// //           height: 30,
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             gradient: LinearGradient(
// //               colors: [
// //                 avatarColor.withValues(alpha: 0.1),
// //                 avatarColor.withValues(alpha: 0.2)
// //               ],
// //             ),
// //             border: Border.all(color: avatarColor.withValues(alpha: 0.5)),
// //           ),
// //           child: Icon(avatarIcon, size: 16, color: avatarColor),
// //         ),
// //         const SizedBox(width: 6),
// //         Expanded(
// //           child: Container(
// //             height: 30,
// //             alignment: Alignment.center,
// //             padding: const EdgeInsets.symmetric(horizontal: 8),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(20),
// //               border: Border.all(color: const Color(0xFFE6DFF0)),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.purple.withValues(alpha: 0.08),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 3),
// //                 ),
// //               ],
// //             ),
// //             child: Text(
// //               text,
// //               overflow: TextOverflow.ellipsis,
// //               style: const TextStyle(
// //                 color: Colors.black87,
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 11,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────
// // // Profile Summary Panels
// // // ─────────────────────────────────────────────────────────────────────
// // class ProfileSummaryPanels extends StatelessWidget {
// //   final ViewSingleProfileData data;
// //   const ProfileSummaryPanels({super.key, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final aboutText = data.comment ?? 'No information provided';
// //     final lookingForText = data.text ?? 'No information provided';

// //     return LayoutBuilder(
// //       builder: (context, constraints) {
// //         final isCompact = constraints.maxWidth < 640;
// //         if (isCompact) {
// //           return Column(
// //             children: [
// //               InfoPanel(title: 'About', content: aboutText),
// //               const SizedBox(height: 10),
// //               InfoPanel(title: 'Interests', content: lookingForText),
// //             ],
// //           );
// //         }
// //         return Row(
// //           children: [
// //             Expanded(child: InfoPanel(title: 'About', content: aboutText)),
// //             const SizedBox(width: 10),
// //             Expanded(child: InfoPanel(title: 'Interests', content: lookingForText)),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }

// // class InfoPanel extends StatelessWidget {
// //   final String title;
// //   final String content;
// //   const InfoPanel({super.key, required this.title, required this.content});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFFBF8FF),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: const Color(0xFFE5DDF2)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(title,
// //               style: const TextStyle(
// //                   fontSize: 13,
// //                   fontWeight: FontWeight.w700,
// //                   color: Color(0xFF2F1047))),
// //           const SizedBox(height: 6),
// //           Text(content,
// //               style: TextStyle(fontSize: 12, height: 1.3, color: Colors.grey[800])),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────
// // // Helper Classes
// // // ─────────────────────────────────────────────────────────────────────
// // class _SingleTrait {
// //   final String label;
// //   final String? value;
// //   _SingleTrait({required this.label, required this.value});
// // }

// // class _CoupleTrait {
// //   final String label;
// //   final String p1Value;
// //   final String p2Value;
// //   _CoupleTrait({required this.label, required this.p1Value, required this.p2Value});
// // }


// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import '../../../model/profile_hometab_model.dart';
// // // import '../../../providers/profile_hometab_provider.dart';

// // // /// Helper to calculate age from YYYY-MM-DD format
// // // int calculateAge(String? dob) {
// // //   if (dob == null || dob.isEmpty) return 0;
// // //   try {
// // //     final parts = dob.split('-');
// // //     if (parts.length != 3) return 0;
// // //     final birthDate = DateTime(
// // //       int.parse(parts[0]),
// // //       int.parse(parts[1]),
// // //       int.parse(parts[2]),
// // //     );
// // //     final today = DateTime.now();
// // //     int age = today.year - birthDate.year;
// // //     if (today.month < birthDate.month ||
// // //         (today.month == birthDate.month && today.day < birthDate.day)) {
// // //       age--;
// // //     }
// // //     return age;
// // //   } catch (_) {
// // //     return 0;
// // //   }
// // // }

// // // class ViewSingleProfileHomeTab extends ConsumerStatefulWidget {
// // //   const ViewSingleProfileHomeTab({super.key});

// // //   @override
// // //   ConsumerState<ViewSingleProfileHomeTab> createState() =>
// // //       _ViewSingleProfileHomeTabState();
// // // }

// // // class _ViewSingleProfileHomeTabState
// // //     extends ConsumerState<ViewSingleProfileHomeTab> {
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     // Fetch profile data on init
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final profileState = ref.watch(viewSingleProfileProvider);

// // //     if (profileState.isLoading) {
// // //       return const Center(
// // //         child: CircularProgressIndicator(color: Colors.pink),
// // //       );
// // //     }

// // //     if (profileState.isError) {
// // //       return Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             const Icon(Icons.error_outline, size: 48, color: Colors.red),
// // //             const SizedBox(height: 16),
// // //             Text(
// // //               profileState.errorMessage,
// // //               textAlign: TextAlign.center,
// // //               style: const TextStyle(color: Colors.red, fontSize: 14),
// // //             ),
// // //             const SizedBox(height: 16),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.black, foregroundColor: Colors.white),
// // //               onPressed: () {
// // //                 ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// // //               },
// // //               child: const Text('Retry'),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //     }

// // //     final data = profileState.data;
// // //     if (data == null) {
// // //       return const Center(
// // //         child: Text('No profile data available'),
// // //       );
// // //     }

// // //     return RefreshIndicator(
// // //       onRefresh: () async {
// // //         await ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// // //       },
// // //       child: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             ProfileCard(data: data),
// // //             const SizedBox(height: 16),
// // //             TraitsSection(data: data),
// // //             const SizedBox(height: 16),
// // //             ProfileSummaryPanels(data: data),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // /// Profile Card Widget - Adapts for single/couple
// // // class ProfileCard extends StatelessWidget {
// // //   final ViewSingleProfileData data;
// // //   const ProfileCard({super.key, required this.data});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final isCouple = data.profileType.toLowerCase() == 'couple';
// // //     final displayName = isCouple
// // //         ? (data.coupleFullNameFrom.isNotEmpty
// // //             ? data.coupleFullNameFrom
// // //             : data.username)
// // //         : (data.singleFullName.isNotEmpty
// // //             ? data.singleFullName
// // //             : data.username);

// // //     String displayAge;
// // //     if (isCouple) {
// // //       final age1 = calculateAge(data.person1Dob);
// // //       final age2 = calculateAge(data.person2Dob);
// // //       displayAge = age2 > 0 ? '$age1 | $age2 Years' : '$age1 Years';
// // //     } else {
// // //       displayAge = '${calculateAge(data.person1Dob)} Years';
// // //     }

// // //     final genderText = isCouple
// // //         ? '${data.genderProfileType} | ${data.genderProfileType}'
// // //         : data.genderProfileType;

// // //     final locationText = data.address.isNotEmpty
// // //         ? data.address
// // //         : (data.city.isNotEmpty ? data.city : 'Location not available');

// // //     // Build couple type badges
// // //     final coupleTypes = <String>[];
// // //     if (data.coupleMaleFemaleSwingers == '1') coupleTypes.add('Swingers');
// // //     if (data.coupleMaleFemaleHookupMeetup == '1')
// // //       coupleTypes.add('HookUps/Meetups');
// // //     // Add more couple type checks as needed

// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       decoration: BoxDecoration(
// // //         gradient: const LinearGradient(
// // //           begin: Alignment.topCenter,
// // //           end: Alignment.bottomCenter,
// // //           colors: [Color(0xFF1C0027), Color(0xFF32003E)],
// // //         ),
// // //         borderRadius: BorderRadius.circular(12),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           ClipRRect(
// // //             borderRadius: BorderRadius.circular(8),
// // //             child: Container(
// // //               height: 200,
// // //               width: double.infinity,
// // //               decoration: BoxDecoration(
// // //                 color: Colors.grey[900],
// // //                 borderRadius: BorderRadius.circular(8),
// // //               ),
// // //               child: Icon(
// // //                 isCouple ? Icons.people_alt : Icons.person,
// // //                 size: 80,
// // //                 color: Colors.white.withValues(alpha: 0.3),
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 12),
// // //           Text(
// // //             displayName,
// // //             style: const TextStyle(
// // //               color: Colors.white,
// // //               fontWeight: FontWeight.w700,
// // //               fontSize: 16,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 4),
// // //           Text(
// // //             displayAge,
// // //             style: TextStyle(
// // //               color: Colors.white.withValues(alpha: 0.85),
// // //               fontSize: 12,
// // //             ),
// // //           ),
// // //           Text(
// // //             genderText,
// // //             style: TextStyle(
// // //               color: Colors.white.withValues(alpha: 0.85),
// // //               fontSize: 12,
// // //             ),
// // //           ),
// // //           Text(
// // //             locationText,
// // //             style: TextStyle(
// // //               color: Colors.white.withValues(alpha: 0.85),
// // //               fontSize: 12,
// // //             ),
// // //           ),
// // //           if (isCouple && coupleTypes.isNotEmpty) ...[
// // //             const SizedBox(height: 8),
// // //             Wrap(
// // //               spacing: 6,
// // //               children: coupleTypes
// // //                   .map((type) => Container(
// // //                         padding: const EdgeInsets.symmetric(
// // //                             horizontal: 12, vertical: 6),
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.pink.withValues(alpha: 0.3),
// // //                           borderRadius: BorderRadius.circular(20),
// // //                           border: Border.all(color: Colors.pink),
// // //                         ),
// // //                         child: Text(
// // //                           type,
// // //                           style: const TextStyle(
// // //                             color: Colors.white,
// // //                             fontWeight: FontWeight.w600,
// // //                             fontSize: 11,
// // //                           ),
// // //                         ),
// // //                       ))
// // //                   .toList(),
// // //             ),
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // /// Traits Section - Adapts layout for single vs couple
// // // class TraitsSection extends StatelessWidget {
// // //   final ViewSingleProfileData data;
// // //   const TraitsSection({super.key, required this.data});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final isCouple = data.profileType.toLowerCase() == 'couple';

// // //     if (isCouple) {
// // //       return _CoupleTraitsTable(data: data);
// // //     } else {
// // //       return _SingleTraitsTable(data: data);
// // //     }
// // //   }
// // // }

// // // /// Single Profile Traits Table (1 column)
// // // class _SingleTraitsTable extends StatelessWidget {
// // //   final ViewSingleProfileData data;
// // //   const _SingleTraitsTable({required this.data});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final traits = <_SingleTrait>[];

// // //     // Helper to create trait with "I'm not comfortable sharing that" for null
// // //     String formatValue(dynamic value) {
// // //       if (value == null || value.toString().isEmpty) {
// // //         return "I'm not comfortable sharing that";
// // //       }
// // //       return value.toString();
// // //     }

// // //     traits.add(_SingleTrait(
// // //         label: 'Age', value: '${calculateAge(data.person1Dob)} Years'));
// // //     traits.add(_SingleTrait(label: 'Tattoos', value: data.person1Tattoos));
// // //     traits.add(_SingleTrait(label: 'Body Hair', value: data.person1BodyHair));
// // //     traits.add(
// // //         _SingleTrait(label: 'Weight', value: formatWeight(data.person1Weight)));
// // //     traits.add(
// // //         _SingleTrait(label: 'Height', value: formatHeight(data.person1Height)));
// // //     traits.add(_SingleTrait(label: 'Smoking', value: data.person1Smoking));
// // //     traits.add(_SingleTrait(label: 'Drinking', value: data.person1Drinking));
// // //     traits.add(_SingleTrait(label: 'Body Type', value: data.person1BodyType));
// // //     traits.add(_SingleTrait(
// // //         label: 'Languages', value: data.person1LanguageSpoken));
// // //     traits.add(_SingleTrait(
// // //         label: 'Ethnic Background', value: data.person1EthnicBackground));
// // //     traits.add(_SingleTrait(label: 'Piercings', value: data.person1Piercings));
// // //     traits.add(
// // //         _SingleTrait(label: 'Circumcised', value: data.person1Circumcised));
// // //     traits.add(_SingleTrait(
// // //         label: 'Intelligence as Importance',
// // //         value: data.person1IntelligenceImportance));
// // //     traits.add(
// // //         _SingleTrait(label: 'Sexuality', value: data.person1Sexuality));
// // //     traits.add(_SingleTrait(
// // //         label: 'Relationship Orientation',
// // //         value: data.person1RelationshipOrientation));
// // //     traits.add(_SingleTrait(
// // //         label: 'Looks are Important', value: data.person1LooksImportant));

// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         const Text(
// // //           'Profile Details',
// // //           style: TextStyle(
// // //             fontSize: 16,
// // //             fontWeight: FontWeight.bold,
// // //             color: Color(0xFF2F1047),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 12),
// // //         ...traits.map((trait) => Padding(
// // //               padding: const EdgeInsets.only(bottom: 10),
// // //               child: Row(
// // //                 children: [
// // //                   Expanded(
// // //                     flex: 5,
// // //                     child: Container(
// // //                       height: 32,
// // //                       alignment: Alignment.center,
// // //                       decoration: BoxDecoration(
// // //                         gradient: const LinearGradient(
// // //                           colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // //                         ),
// // //                         borderRadius: BorderRadius.circular(20),
// // //                       ),
// // //                       child: Text(
// // //                         trait.label,
// // //                         textAlign: TextAlign.center,
// // //                         style: const TextStyle(
// // //                           color: Colors.white,
// // //                           fontWeight: FontWeight.w700,
// // //                           fontSize: 11,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 12),
// // //                   Expanded(
// // //                     flex: 6,
// // //                     child: _ValueBubble(
// // //                       text: trait.value ?? "I'm not comfortable sharing that",
// // //                       avatarIcon: Icons.person,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             )),
// // //       ],
// // //     );
// // //   }

// // //   String? formatWeight(String? weight) {
// // //     if (weight == null || weight.isEmpty) return null;
// // //     return '$weight KG';
// // //   }

// // //   String? formatHeight(String? height) {
// // //     if (height == null || height.isEmpty) return null;
// // //     return '$height FT';
// // //   }
// // // }

// // // /// Couple Profile Traits Table (2 columns)
// // // class _CoupleTraitsTable extends StatelessWidget {
// // //   final ViewSingleProfileData data;
// // //   const _CoupleTraitsTable({required this.data});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final traits = <_CoupleTrait>[];

// // //     // Helper to create trait with "N/A" for null couple values
// // //     String formatValueP1(dynamic value) {
// // //       if (value == null || value.toString().isEmpty) return 'N/A';
// // //       return value.toString();
// // //     }

// // //     String formatValueP2(dynamic value) {
// // //       if (value == null || value.toString().isEmpty) return 'N/A';
// // //       return value.toString();
// // //     }

// // //     traits.add(_CoupleTrait(
// // //       label: 'Age',
// // //       p1Value: '${calculateAge(data.person1Dob)} Years',
// // //       p2Value: '${calculateAge(data.person2Dob)} Years',
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Tattoos',
// // //       p1Value: formatValueP1(data.person1Tattoos),
// // //       p2Value: formatValueP2(data.person2Tattoos),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Body Hair',
// // //       p1Value: formatValueP1(data.person1BodyHair),
// // //       p2Value: formatValueP2(data.person2BodyHair),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Weight',
// // //       p1Value: formatWeightP1(data.person1Weight),
// // //       p2Value: formatWeightP2(data.person2Weight),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Height',
// // //       p1Value: formatHeightP1(data.person1Height),
// // //       p2Value: formatHeightP2(data.person2Height),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Smoking',
// // //       p1Value: formatValueP1(data.person1Smoking),
// // //       p2Value: formatValueP2(data.person2Smoking),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Drinking',
// // //       p1Value: formatValueP1(data.person1Drinking),
// // //       p2Value: formatValueP2(data.person2Drinking),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Body Type',
// // //       p1Value: formatValueP1(data.person1BodyType),
// // //       p2Value: formatValueP2(data.person2BodyType),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Languages',
// // //       p1Value: formatValueP1(data.person1LanguageSpoken),
// // //       p2Value: formatValueP2(data.person2LanguageSpoken),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Ethnic Background',
// // //       p1Value: formatValueP1(data.person1EthnicBackground),
// // //       p2Value: formatValueP2(data.person2EthnicBackground),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Piercings',
// // //       p1Value: formatValueP1(data.person1Piercings),
// // //       p2Value: formatValueP2(data.person2Piercings),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Circumcised',
// // //       p1Value: formatValueP1(data.person1Circumcised),
// // //       p2Value: formatValueP2(data.person2Circumcised),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Intelligence as Importance',
// // //       p1Value: formatValueP1(data.person1IntelligenceImportance),
// // //       p2Value: formatValueP2(data.person2IntelligenceImportance),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Sexuality',
// // //       p1Value: formatValueP1(data.person1Sexuality),
// // //       p2Value: formatValueP2(data.person2Sexuality),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Relationship Orientation',
// // //       p1Value: formatValueP1(data.person1RelationshipOrientation),
// // //       p2Value: formatValueP2(data.person2RelationshipOrientation),
// // //     ));
// // //     traits.add(_CoupleTrait(
// // //       label: 'Looks are Important',
// // //       p1Value: formatValueP1(data.person1LooksImportant),
// // //       p2Value: formatValueP2(data.person2LooksImportant),
// // //     ));

// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         // Header row
// // //         Row(
// // //           children: [
// // //             const Expanded(flex: 5, child: SizedBox()),
// // //             const SizedBox(width: 12),
// // //             Expanded(
// // //               flex: 5,
// // //               child: Container(
// // //                 padding: const EdgeInsets.symmetric(vertical: 8),
// // //                 alignment: Alignment.center,
// // //                 decoration: BoxDecoration(
// // //                   gradient: const LinearGradient(
// // //                     colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // //                   ),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                 ),
// // //                 child: Text(
// // //                   data.person1Name,
// // //                   style: const TextStyle(
// // //                     color: Colors.white,
// // //                     fontWeight: FontWeight.w700,
// // //                     fontSize: 12,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             Expanded(
// // //               flex: 5,
// // //               child: Container(
// // //                 padding: const EdgeInsets.symmetric(vertical: 8),
// // //                 alignment: Alignment.center,
// // //                 decoration: BoxDecoration(
// // //                   gradient: const LinearGradient(
// // //                     colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // //                   ),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                 ),
// // //                 child: Text(
// // //                   data.person2Name,
// // //                   style: const TextStyle(
// // //                     color: Colors.white,
// // //                     fontWeight: FontWeight.w700,
// // //                     fontSize: 12,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //         const SizedBox(height: 12),
// // //         const Text(
// // //           'Profile Details',
// // //           style: TextStyle(
// // //             fontSize: 16,
// // //             fontWeight: FontWeight.bold,
// // //             color: Color(0xFF2F1047),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 12),
// // //         ...traits.map((trait) => Padding(
// // //               padding: const EdgeInsets.only(bottom: 10),
// // //               child: Row(
// // //                 children: [
// // //                   // Label column
// // //                   Expanded(
// // //                     flex: 5,
// // //                     child: Container(
// // //                       height: 32,
// // //                       alignment: Alignment.center,
// // //                       decoration: BoxDecoration(
// // //                         gradient: const LinearGradient(
// // //                           colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // //                         ),
// // //                         borderRadius: BorderRadius.circular(20),
// // //                       ),
// // //                       child: Text(
// // //                         trait.label,
// // //                         textAlign: TextAlign.center,
// // //                         style: const TextStyle(
// // //                           color: Colors.white,
// // //                           fontWeight: FontWeight.w700,
// // //                           fontSize: 11,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 8),
// // //                   // Person 1 value
// // //                   Expanded(
// // //                     flex: 5,
// // //                     child: _ValueBubble(
// // //                       text: trait.p1Value,
// // //                       avatarIcon: Icons.person,
// // //                       avatarColor: const Color(0xFF3B6CB7),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 8),
// // //                   // Person 2 value
// // //                   Expanded(
// // //                     flex: 5,
// // //                     child: _ValueBubble(
// // //                       text: trait.p2Value,
// // //                       avatarIcon: Icons.person_2,
// // //                       avatarColor: const Color(0xFFE91E63),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             )),
// // //       ],
// // //     );
// // //   }

// // //   String formatWeightP1(String? weight) {
// // //     if (weight == null || weight.isEmpty) return 'N/A';
// // //     return '$weight KG';
// // //   }

// // //   String formatWeightP2(String? weight) {
// // //     if (weight == null || weight.isEmpty) return 'N/A';
// // //     return '$weight KG';
// // //   }

// // //   String formatHeightP1(String? height) {
// // //     if (height == null || height.isEmpty) return 'N/A';
// // //     return '$height FT';
// // //   }

// // //   String formatHeightP2(String? height) {
// // //     if (height == null || height.isEmpty) return 'N/A';
// // //     return '$height FT';
// // //   }
// // // }

// // // /// Value Bubble Widget - Single person style
// // // class _ValueBubble extends StatelessWidget {
// // //   final String text;
// // //   final IconData avatarIcon;
// // //   final Color avatarColor;

// // //   const _ValueBubble({
// // //     required this.text,
// // //     required this.avatarIcon,
// // //     this.avatarColor = const Color(0xFF3B6CB7),
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Row(
// // //       children: [
// // //         Container(
// // //           width: 30,
// // //           height: 30,
// // //           decoration: BoxDecoration(
// // //             shape: BoxShape.circle,
// // //             gradient: LinearGradient(
// // //               colors: [
// // //                 avatarColor.withValues(alpha: 0.1),
// // //                 avatarColor.withValues(alpha: 0.2)
// // //               ],
// // //             ),
// // //             border: Border.all(color: avatarColor.withValues(alpha: 0.5)),
// // //           ),
// // //           child: Icon(avatarIcon, size: 16, color: avatarColor),
// // //         ),
// // //         const SizedBox(width: 6),
// // //         Expanded(
// // //           child: Container(
// // //             height: 30,
// // //             alignment: Alignment.center,
// // //             padding: const EdgeInsets.symmetric(horizontal: 8),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(20),
// // //               border: Border.all(color: const Color(0xFFE6DFF0)),
// // //               boxShadow: [
// // //                 BoxShadow(
// // //                   color: Colors.purple.withValues(alpha: 0.08),
// // //                   blurRadius: 8,
// // //                   offset: const Offset(0, 3),
// // //                 ),
// // //               ],
// // //             ),
// // //             child: Text(
// // //               text,
// // //               overflow: TextOverflow.ellipsis,
// // //               style: const TextStyle(
// // //                 color: Colors.black87,
// // //                 fontWeight: FontWeight.w600,
// // //                 fontSize: 11,
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // /// Profile Summary Panels
// // // class ProfileSummaryPanels extends StatelessWidget {
// // //   final ViewSingleProfileData data;
// // //   const ProfileSummaryPanels({super.key, required this.data});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final aboutText = data.comment ?? 'No information provided';
// // //     final lookingForText = data.text ?? 'No information provided';

// // //     return LayoutBuilder(
// // //       builder: (context, constraints) {
// // //         final isCompact = constraints.maxWidth < 640;
// // //         if (isCompact) {
// // //           return Column(
// // //             children: [
// // //               InfoPanel(title: 'About', content: aboutText),
// // //               const SizedBox(height: 10),
// // //               InfoPanel(title: 'Interests', content: lookingForText),
// // //             ],
// // //           );
// // //         }
// // //         return Row(
// // //           children: [
// // //             Expanded(
// // //               child: InfoPanel(title: 'About', content: aboutText),
// // //             ),
// // //             const SizedBox(width: 10),
// // //             Expanded(
// // //               child: InfoPanel(title: 'Interests', content: lookingForText),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // /// Info Panel Widget
// // // class InfoPanel extends StatelessWidget {
// // //   final String title;
// // //   final String content;

// // //   const InfoPanel({super.key, required this.title, required this.content});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(12),
// // //       decoration: BoxDecoration(
// // //         color: const Color(0xFFFBF8FF),
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: const Color(0xFFE5DDF2)),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             title,
// // //             style: const TextStyle(
// // //               fontSize: 13,
// // //               fontWeight: FontWeight.w700,
// // //               color: Color(0xFF2F1047),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 6),
// // //           Text(
// // //             content,
// // //             style: TextStyle(
// // //               fontSize: 12,
// // //               height: 1.3,
// // //               color: Colors.grey[800],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // /// Helper Classes
// // // class _SingleTrait {
// // //   final String label;
// // //   final String? value;

// // //   _SingleTrait({required this.label, required this.value});
// // // }

// // // class _CoupleTrait {
// // //   final String label;
// // //   final String p1Value;
// // //   final String p2Value;

// // //   _CoupleTrait({
// // //     required this.label,
// // //     required this.p1Value,
// // //     required this.p2Value,
// // //   });
// // // }


// // // // // lib/screens/view_single_profile/view_single_profile_home_tab.dart

// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import '../../../model/profile_hometab_model.dart';
// // // // import '../../../providers/profile_hometab_provider.dart';


// // // // /// Helper to calculate age from YYYY-MM-DD format
// // // // int calculateAge(String? dob) {
// // // //   if (dob == null || dob.isEmpty) return 0;
// // // //   try {
// // // //     final parts = dob.split('-');
// // // //     if (parts.length != 3) return 0;
// // // //     final birthDate = DateTime(
// // // //       int.parse(parts[0]),
// // // //       int.parse(parts[1]),
// // // //       int.parse(parts[2]),
// // // //     );
// // // //     final today = DateTime.now();
// // // //     int age = today.year - birthDate.year;
// // // //     if (today.month < birthDate.month ||
// // // //         (today.month == birthDate.month && today.day < birthDate.day)) {
// // // //       age--;
// // // //     }
// // // //     return age;
// // // //   } catch (_) {
// // // //     return 0;
// // // //   }
// // // // }

// // // // class ViewSingleProfileHomeTab extends ConsumerStatefulWidget {
// // // //   const ViewSingleProfileHomeTab({super.key});

// // // //   @override
// // // //   ConsumerState<ViewSingleProfileHomeTab> createState() =>
// // // //       _ViewSingleProfileHomeTabState();
// // // // }

// // // // class _ViewSingleProfileHomeTabState
// // // //     extends ConsumerState<ViewSingleProfileHomeTab> {
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     // Fetch profile data on init
// // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //       ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// // // //     });
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final profileState = ref.watch(viewSingleProfileProvider);

// // // //     if (profileState.isLoading) {
// // // //       return const Center(
// // // //         child: CircularProgressIndicator(color: Colors.pink),
// // // //       );
// // // //     }

// // // //     if (profileState.isError) {
// // // //       return Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             const Icon(Icons.error_outline, size: 48, color: Colors.red),
// // // //             const SizedBox(height: 16),
// // // //             Text(
// // // //               profileState.errorMessage,
// // // //               textAlign: TextAlign.center,
// // // //               style: const TextStyle(color: Colors.red, fontSize: 14),
// // // //             ),
// // // //             const SizedBox(height: 16),
// // // //             ElevatedButton(
// // // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
// // // //               onPressed: () {
// // // //                 ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// // // //               },
// // // //               child: const Text('Retry'),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       );
// // // //     }

// // // //     final data = profileState.data;
// // // //     if (data == null) {
// // // //       return const Center(
// // // //         child: Text('No profile data available'),
// // // //       );
// // // //     }

// // // //     return RefreshIndicator(
// // // //       onRefresh: () async {
// // // //         await ref.read(viewSingleProfileProvider.notifier).fetchProfile();
// // // //       },
// // // //       child: SingleChildScrollView(
// // // //         padding: const EdgeInsets.all(16),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             ProfileCard(data: data),
// // // //             const SizedBox(height: 16),
// // // //             TraitsSection(data: data),
// // // //             const SizedBox(height: 16),
// // // //             ProfileSummaryPanels(data: data),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // /// Profile Card Widget - Adapts for single/couple
// // // // class ProfileCard extends StatelessWidget {
// // // //   final ViewSingleProfileData data;
// // // //   const ProfileCard({super.key, required this.data});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final isCouple = data.profileType.toLowerCase() == 'couple';
// // // //     final displayName = isCouple
// // // //         ? (data.coupleFullNameFrom.isNotEmpty
// // // //         ? data.coupleFullNameFrom
// // // //         : data.username)
// // // //         : (data.singleFullName.isNotEmpty
// // // //         ? data.singleFullName
// // // //         : data.username);

// // // //     String displayAge;
// // // //     if (isCouple) {
// // // //       final age1 = calculateAge(data.person1Dob);
// // // //       final age2 = calculateAge(data.person2Dob);
// // // //       displayAge = age2 > 0 ? '$age1 | $age2 Years' : '$age1 Years';
// // // //     } else {
// // // //       displayAge = '${calculateAge(data.person1Dob)} Years';
// // // //     }

// // // //     final genderText = isCouple
// // // //         ? '${data.genderProfileType} | ${data.genderProfileType}'
// // // //         : data.genderProfileType;

// // // //     final locationText = data.address.isNotEmpty
// // // //         ? data.address
// // // //         : (data.city.isNotEmpty ? data.city : 'Location not available');

// // // //     // Build couple type badges
// // // //     final coupleTypes = <String>[];
// // // //     if (data.coupleMaleFemaleSwingers == '1') coupleTypes.add('Swingers');
// // // //     if (data.coupleMaleFemaleHookupMeetup == '1') coupleTypes.add('HookUps/Meetups');
// // // //     // Add more couple type checks as needed

// // // //     return Container(
// // // //       padding: const EdgeInsets.all(16),
// // // //       decoration: BoxDecoration(
// // // //         gradient: const LinearGradient(
// // // //           begin: Alignment.topCenter,
// // // //           end: Alignment.bottomCenter,
// // // //           colors: [Color(0xFF1C0027), Color(0xFF32003E)],
// // // //         ),
// // // //         borderRadius: BorderRadius.circular(12),
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           ClipRRect(
// // // //             borderRadius: BorderRadius.circular(8),
// // // //             child: Container(
// // // //               height: 200,
// // // //               width: double.infinity,
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.grey[900],
// // // //                 borderRadius: BorderRadius.circular(8),
// // // //               ),
// // // //               child: Icon(
// // // //                 // isCouple ? Icons.couple : Icons.person,
// // // //                 isCouple ? Icons.people_alt : Icons.person,
// // // //                 size: 80,
// // // //                 color: Colors.white.withValues(alpha: 0.3),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 12),
// // // //           Text(
// // // //             displayName,
// // // //             style: const TextStyle(
// // // //               color: Colors.white,
// // // //               fontWeight: FontWeight.w700,
// // // //               fontSize: 16,
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 4),
// // // //           Text(
// // // //             displayAge,
// // // //             style: TextStyle(
// // // //               color: Colors.white.withValues(alpha: 0.85),
// // // //               fontSize: 12,
// // // //             ),
// // // //           ),
// // // //           Text(
// // // //             genderText,
// // // //             style: TextStyle(
// // // //               color: Colors.white.withValues(alpha: 0.85),
// // // //               fontSize: 12,
// // // //             ),
// // // //           ),
// // // //           Text(
// // // //             locationText,
// // // //             style: TextStyle(
// // // //               color: Colors.white.withValues(alpha: 0.85),
// // // //               fontSize: 12,
// // // //             ),
// // // //           ),
// // // //           if (isCouple && coupleTypes.isNotEmpty) ...[
// // // //             const SizedBox(height: 8),
// // // //             Wrap(
// // // //               spacing: 6,
// // // //               children: coupleTypes
// // // //                   .map((type) => Container(
// // // //                 padding: const EdgeInsets.symmetric(
// // // //                     horizontal: 12, vertical: 6),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.pink.withValues(alpha: 0.3),
// // // //                   borderRadius: BorderRadius.circular(20),
// // // //                   border: Border.all(color: Colors.pink),
// // // //                 ),
// // // //                 child: Text(
// // // //                   type,
// // // //                   style: const TextStyle(
// // // //                     color: Colors.white,
// // // //                     fontWeight: FontWeight.w600,
// // // //                     fontSize: 11,
// // // //                   ),
// // // //                 ),
// // // //               ))
// // // //                   .toList(),
// // // //             ),
// // // //           ],
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // /// Traits Section - Adapts layout for single vs couple
// // // // class TraitsSection extends StatelessWidget {
// // // //   final ViewSingleProfileData data;
// // // //   const TraitsSection({super.key, required this.data});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final isCouple = data.profileType.toLowerCase() == 'couple';

// // // //     if (isCouple) {
// // // //       return _CoupleTraitsTable(data: data);
// // // //     } else {
// // // //       return _SingleTraitsTable(data: data);
// // // //     }
// // // //   }
// // // // }

// // // // /// Single Profile Traits Table (1 column)
// // // // class _SingleTraitsTable extends StatelessWidget {
// // // //   final ViewSingleProfileData data;
// // // //   const _SingleTraitsTable({required this.data});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final traits = <_SingleTrait>[];

// // // //     // Helper to create trait with "I'm not comfortable sharing that" for null
// // // //     String formatValue(dynamic value) {
// // // //       if (value == null || value.toString().isEmpty) {
// // // //         return "I'm not comfortable sharing that";
// // // //       }
// // // //       return value.toString();
// // // //     }

// // // //     traits.add(_SingleTrait(
// // // //         label: 'Age', value: '${calculateAge(data.person1Dob)} Years'));
// // // //     traits.add(_SingleTrait(label: 'Tattoos', value: data.person1Tattoos));
// // // //     traits.add(_SingleTrait(label: 'Body Hair', value: data.person1BodyHair));
// // // //     traits.add(
// // // //         _SingleTrait(label: 'Weight', value: formatWeight(data.person1Weight)));
// // // //     traits.add(
// // // //         _SingleTrait(label: 'Height', value: formatHeight(data.person1Height)));
// // // //     traits.add(_SingleTrait(label: 'Smoking', value: data.person1Smoking));
// // // //     traits.add(_SingleTrait(label: 'Drinking', value: data.person1Drinking));
// // // //     traits.add(_SingleTrait(label: 'Body Type', value: data.person1BodyType));
// // // //     traits.add(_SingleTrait(
// // // //         label: 'Languages', value: data.person1LanguageSpoken));
// // // //     traits.add(_SingleTrait(
// // // //         label: 'Ethnic Background', value: data.person1EthnicBackground));
// // // //     traits.add(_SingleTrait(
// // // //         label: 'Piercings', value: data.person1Piercings));
// // // //     traits.add(
// // // //         _SingleTrait(label: 'Circumcised', value: data.person1Circumcised));
// // // //     traits.add(_SingleTrait(
// // // //         label: 'Intelligence as Importance',
// // // //         value: data.person1IntelligenceImportance));
// // // //     traits.add(
// // // //         _SingleTrait(label: 'Sexuality', value: data.person1Sexuality));
// // // //     traits.add(_SingleTrait(
// // // //         label: 'Relationship Orientation',
// // // //         value: data.person1RelationshipOrientation));
// // // //     traits.add(_SingleTrait(
// // // //         label: 'Looks are Important', value: data.person1LooksImportant));

// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         const Text(
// // // //           'Profile Details',
// // // //           style: TextStyle(
// // // //             fontSize: 16,
// // // //             fontWeight: FontWeight.bold,
// // // //             color: Color(0xFF2F1047),
// // // //           ),
// // // //         ),
// // // //         const SizedBox(height: 12),
// // // //         ...traits.map((trait) => Padding(
// // // //           padding: const EdgeInsets.only(bottom: 10),
// // // //           child: Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 flex: 5,
// // // //                 child: Container(
// // // //                   height: 32,
// // // //                   alignment: Alignment.center,
// // // //                   decoration: BoxDecoration(
// // // //                     gradient: const LinearGradient(
// // // //                       colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // // //                     ),
// // // //                     borderRadius: BorderRadius.circular(20),
// // // //                   ),
// // // //                   child: Text(
// // // //                     trait.label,
// // // //                     textAlign: TextAlign.center,
// // // //                     style: const TextStyle(
// // // //                       color: Colors.white,
// // // //                       fontWeight: FontWeight.w700,
// // // //                       fontSize: 11,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 12),
// // // //               Expanded(
// // // //                 flex: 6,
// // // //                 child: _ValueBubble(
// // // //                   // text: trait.value,
// // // //                   text: trait.value ?? "I'm not comfortable sharing that",
// // // //                   avatarIcon: Icons.person,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         )),
// // // //       ],
// // // //     );
// // // //   }

// // // //   String? formatWeight(String? weight) {
// // // //     if (weight == null || weight.isEmpty) return null;
// // // //     return '$weight KG';
// // // //   }

// // // //   String? formatHeight(String? height) {
// // // //     if (height == null || height.isEmpty) return null;
// // // //     return '$height FT';
// // // //   }
// // // // }

// // // // /// Couple Profile Traits Table (2 columns)
// // // // class _CoupleTraitsTable extends StatelessWidget {
// // // //   final ViewSingleProfileData data;
// // // //   const _CoupleTraitsTable({required this.data});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final traits = <_CoupleTrait>[];

// // // //     // Helper to create trait with "N/A" for null couple values
// // // //     String formatValueP1(dynamic value) {
// // // //       if (value == null || value.toString().isEmpty) return 'N/A';
// // // //       return value.toString();
// // // //     }

// // // //     String formatValueP2(dynamic value) {
// // // //       if (value == null || value.toString().isEmpty) return 'N/A';
// // // //       return value.toString();
// // // //     }

// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Age',
// // // //       p1Value: '${calculateAge(data.person1Dob)} Years',
// // // //       p2Value: '${calculateAge(data.person2Dob)} Years',
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Tattoos',
// // // //       p1Value: formatValueP1(data.person1Tattoos),
// // // //       p2Value: formatValueP2(data.person2Tattoos),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Body Hair',
// // // //       p1Value: formatValueP1(data.person1BodyHair),
// // // //       p2Value: formatValueP2(data.person2BodyHair),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Weight',
// // // //       p1Value: formatWeightP1(data.person1Weight),
// // // //       p2Value: formatWeightP2(data.person2Weight),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Height',
// // // //       p1Value: formatHeightP1(data.person1Height),
// // // //       p2Value: formatHeightP2(data.person2Height),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Smoking',
// // // //       p1Value: formatValueP1(data.person1Smoking),
// // // //       p2Value: formatValueP2(data.person2Smoking),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Drinking',
// // // //       p1Value: formatValueP1(data.person1Drinking),
// // // //       p2Value: formatValueP2(data.person2Drinking),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Body Type',
// // // //       p1Value: formatValueP1(data.person1BodyType),
// // // //       p2Value: formatValueP2(data.person2BodyType),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Languages',
// // // //       p1Value: formatValueP1(data.person1LanguageSpoken),
// // // //       p2Value: formatValueP2(data.person2LanguageSpoken),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Ethnic Background',
// // // //       p1Value: formatValueP1(data.person1EthnicBackground),
// // // //       p2Value: formatValueP2(data.person2EthnicBackground),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Piercings',
// // // //       p1Value: formatValueP1(data.person1Piercings),
// // // //       p2Value: formatValueP2(data.person2Piercings),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Circumcised',
// // // //       p1Value: formatValueP1(data.person1Circumcised),
// // // //       p2Value: formatValueP2(data.person2Circumcised),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Intelligence as Importance',
// // // //       p1Value: formatValueP1(data.person1IntelligenceImportance),
// // // //       p2Value: formatValueP2(data.person2IntelligenceImportance),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Sexuality',
// // // //       p1Value: formatValueP1(data.person1Sexuality),
// // // //       p2Value: formatValueP2(data.person2Sexuality),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Relationship Orientation',
// // // //       p1Value: formatValueP1(data.person1RelationshipOrientation),
// // // //       p2Value: formatValueP2(data.person2RelationshipOrientation),
// // // //     ));
// // // //     traits.add(_CoupleTrait(
// // // //       label: 'Looks are Important',
// // // //       p1Value: formatValueP1(data.person1LooksImportant),
// // // //       p2Value: formatValueP2(data.person2LooksImportant),
// // // //     ));

// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         // Header row
// // // //         Row(
// // // //           children: [
// // // //             const Expanded(flex: 5, child: SizedBox()),
// // // //             const SizedBox(width: 12),
// // // //             Expanded(
// // // //               flex: 5,
// // // //               child: Container(
// // // //                 padding: const EdgeInsets.symmetric(vertical: 8),
// // // //                 alignment: Alignment.center,
// // // //                 decoration: BoxDecoration(
// // // //                   gradient: const LinearGradient(
// // // //                     colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // // //                   ),
// // // //                   borderRadius: BorderRadius.circular(20),
// // // //                 ),
// // // //                 child: Text(
// // // //                   data.person1Name,
// // // //                   style: const TextStyle(
// // // //                     color: Colors.white,
// // // //                     fontWeight: FontWeight.w700,
// // // //                     fontSize: 12,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(width: 12),
// // // //             Expanded(
// // // //               flex: 5,
// // // //               child: Container(
// // // //                 padding: const EdgeInsets.symmetric(vertical: 8),
// // // //                 alignment: Alignment.center,
// // // //                 decoration: BoxDecoration(
// // // //                   gradient: const LinearGradient(
// // // //                     colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // // //                   ),
// // // //                   borderRadius: BorderRadius.circular(20),
// // // //                 ),
// // // //                 child: Text(
// // // //                   data.person2Name,
// // // //                   style: const TextStyle(
// // // //                     color: Colors.white,
// // // //                     fontWeight: FontWeight.w700,
// // // //                     fontSize: 12,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         const SizedBox(height: 12),
// // // //         const Text(
// // // //           'Profile Details',
// // // //           style: TextStyle(
// // // //             fontSize: 16,
// // // //             fontWeight: FontWeight.bold,
// // // //             color: Color(0xFF2F1047),
// // // //           ),
// // // //         ),
// // // //         const SizedBox(height: 12),
// // // //         ...traits.map((trait) => Padding(
// // // //           padding: const EdgeInsets.only(bottom: 10),
// // // //           child: Row(
// // // //             children: [
// // // //               // Label column
// // // //               Expanded(
// // // //                 flex: 5,
// // // //                 child: Container(
// // // //                   height: 32,
// // // //                   alignment: Alignment.center,
// // // //                   decoration: BoxDecoration(
// // // //                     gradient: const LinearGradient(
// // // //                       colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // // //                     ),
// // // //                     borderRadius: BorderRadius.circular(20),
// // // //                   ),
// // // //                   child: Text(
// // // //                     trait.label,
// // // //                     textAlign: TextAlign.center,
// // // //                     style: const TextStyle(
// // // //                       color: Colors.white,
// // // //                       fontWeight: FontWeight.w700,
// // // //                       fontSize: 11,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               // Person 1 value
// // // //               Expanded(
// // // //                 flex: 5,
// // // //                 child: _ValueBubble(
// // // //                   text: trait.p1Value,
// // // //                   avatarIcon: Icons.person,
// // // //                   avatarColor: const Color(0xFF3B6CB7),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               // Person 2 value
// // // //               Expanded(
// // // //                 flex: 5,
// // // //                 child: _ValueBubble(
// // // //                   text: trait.p2Value,
// // // //                   avatarIcon: Icons.person_2,
// // // //                   avatarColor: const Color(0xFFE91E63),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         )),
// // // //       ],
// // // //     );
// // // //   }

// // // //   String formatWeightP1(String? weight) {
// // // //     if (weight == null || weight.isEmpty) return 'N/A';
// // // //     return '$weight KG';
// // // //   }

// // // //   String formatWeightP2(String? weight) {
// // // //     if (weight == null || weight.isEmpty) return 'N/A';
// // // //     return '$weight KG';
// // // //   }

// // // //   String formatHeightP1(String? height) {
// // // //     if (height == null || height.isEmpty) return 'N/A';
// // // //     return '$height FT';
// // // //   }

// // // //   String formatHeightP2(String? height) {
// // // //     if (height == null || height.isEmpty) return 'N/A';
// // // //     return '$height FT';
// // // //   }
// // // // }

// // // // /// Value Bubble Widget - Single person style
// // // // class _ValueBubble extends StatelessWidget {
// // // //   final String text;
// // // //   final IconData avatarIcon;
// // // //   final Color avatarColor;

// // // //   const _ValueBubble({
// // // //     required this.text,
// // // //     required this.avatarIcon,
// // // //     this.avatarColor = const Color(0xFF3B6CB7),
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Row(
// // // //       children: [
// // // //         Container(
// // // //           width: 30,
// // // //           height: 30,
// // // //           decoration: BoxDecoration(
// // // //             shape: BoxShape.circle,
// // // //             gradient: LinearGradient(
// // // //               colors: [avatarColor.withValues(alpha: 0.1), avatarColor.withValues(alpha: 0.2)],
// // // //             ),
// // // //             border: Border.all(color: avatarColor.withValues(alpha: 0.5)),
// // // //           ),
// // // //           child: Icon(avatarIcon, size: 16, color: avatarColor),
// // // //         ),
// // // //         const SizedBox(width: 6),
// // // //         Expanded(
// // // //           child: Container(
// // // //             height: 30,
// // // //             alignment: Alignment.center,
// // // //             padding: const EdgeInsets.symmetric(horizontal: 8),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.white,
// // // //               borderRadius: BorderRadius.circular(20),
// // // //               border: Border.all(color: const Color(0xFFE6DFF0)),
// // // //               boxShadow: [
// // // //                 BoxShadow(
// // // //                   color: Colors.purple.withValues(alpha: 0.08),
// // // //                   blurRadius: 8,
// // // //                   offset: const Offset(0, 3),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             child: Text(
// // // //               text,
// // // //               overflow: TextOverflow.ellipsis,
// // // //               style: const TextStyle(
// // // //                 color: Colors.black87,
// // // //                 fontWeight: FontWeight.w600,
// // // //                 fontSize: 11,
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }

// // // // /// Profile Summary Panels
// // // // class ProfileSummaryPanels extends StatelessWidget {
// // // //   final ViewSingleProfileData data;
// // // //   const ProfileSummaryPanels({super.key, required this.data});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final aboutText = data.comment ?? 'No information provided';
// // // //     final lookingForText = data.text ?? 'No information provided';

// // // //     return LayoutBuilder(
// // // //       builder: (context, constraints) {
// // // //         final isCompact = constraints.maxWidth < 640;
// // // //         if (isCompact) {
// // // //           return Column(
// // // //             children: [
// // // //               InfoPanel(title: 'About', content: aboutText),
// // // //               const SizedBox(height: 10),
// // // //               InfoPanel(title: 'Interests', content: lookingForText),
// // // //             ],
// // // //           );
// // // //         }
// // // //         return Row(
// // // //           children: [
// // // //             Expanded(
// // // //               child: InfoPanel(title: 'About', content: aboutText),
// // // //             ),
// // // //             const SizedBox(width: 10),
// // // //             Expanded(
// // // //               child: InfoPanel(title: 'Interests', content: lookingForText),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // // /// Info Panel Widget
// // // // class InfoPanel extends StatelessWidget {
// // // //   final String title;
// // // //   final String content;

// // // //   const InfoPanel({super.key, required this.title, required this.content});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Container(
// // // //       padding: const EdgeInsets.all(12),
// // // //       decoration: BoxDecoration(
// // // //         color: const Color(0xFFFBF8FF),
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(color: const Color(0xFFE5DDF2)),
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Text(
// // // //             title,
// // // //             style: const TextStyle(
// // // //               fontSize: 13,
// // // //               fontWeight: FontWeight.w700,
// // // //               color: Color(0xFF2F1047),
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 6),
// // // //           Text(
// // // //             content,
// // // //             style: TextStyle(
// // // //               fontSize: 12,
// // // //               height: 1.3,
// // // //               color: Colors.grey[800],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // /// Helper Classes
// // // // class _SingleTrait {
// // // //   final String label;
// // // //   final String? value;

// // // //   _SingleTrait({required this.label, required this.value});
// // // // }

// // // // class _CoupleTrait {
// // // //   final String label;
// // // //   final String p1Value;
// // // //   final String p2Value;

// // // //   _CoupleTrait({
// // // //     required this.label,
// // // //     required this.p1Value,
// // // //     required this.p2Value,
// // // //   });
// // // // }


// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_edit_tab.dart';
// // // // //
// // // // // import '../../../providers/profile_provider.dart';
// // // // //
// // // // // // Moved to top-level for better hot-reload stability and clean code
// // // // // int _calculateAge(String? dob) {
// // // // //   if (dob == null) return 21;
// // // // //   try {
// // // // //     final parts = dob.split('/');
// // // // //     if (parts.length != 3) return 21;
// // // // //     final birthDate = DateTime(
// // // // //       int.parse(parts[2]),
// // // // //       int.parse(parts[1]),
// // // // //       int.parse(parts[0]),
// // // // //     );
// // // // //     final today = DateTime.now();
// // // // //     int age = today.year - birthDate.year;
// // // // //     if (today.month < birthDate.month ||
// // // // //         (today.month == birthDate.month && today.day < birthDate.day)) {
// // // // //       age--;
// // // // //     }
// // // // //     return age;
// // // // //   } catch (_) {
// // // // //     return 21;
// // // // //   }
// // // // // }
// // // // //
// // // // // class MyProfileHomeTab extends ConsumerWidget {
// // // // //   const MyProfileHomeTab({super.key});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final profileState = ref.watch(profileEditProvider);
// // // // //
// // // // //     if (profileState.isLoading && profileState.partner1.isEmpty) {
// // // // //       return const Center(
// // // // //         child: CircularProgressIndicator(color: Colors.pink),
// // // // //       );
// // // // //     }
// // // // //
// // // // //     final p1 = profileState.partner1;
// // // // //     final p2 = profileState.partner2;
// // // // //
// // // // //     final List<_Trait> dynamicTraits = [
// // // // //       _Trait(
// // // // //         label: 'Age',
// // // // //         mine: '${_calculateAge(p1['dateOfBirth'])} Years',
// // // // //         match: '${_calculateAge(p2['dateOfBirth'])} Years',
// // // // //       ),
// // // // //       _Trait(
// // // // //         label: 'Tattoos',
// // // // //         mine: p1['tattoos'] ?? 'One',
// // // // //         match: p2['tattoos'] ?? 'One',
// // // // //       ),
// // // // //       _Trait(
// // // // //         label: 'Body Hair',
// // // // //         mine: p1['bodyHair'] ?? 'Bikini',
// // // // //         match: p2['bodyHair'] ?? 'Arm, Chest',
// // // // //       ),
// // // // //       _Trait(
// // // // //         label: 'Weight',
// // // // //         mine: '${p1['weight'] ?? '65'} KG',
// // // // //         match: '${p2['weight'] ?? '65'} KG',
// // // // //       ),
// // // // //       _Trait(
// // // // //         label: 'Height',
// // // // //         mine: '${p1['height'] ?? "4'6"} FT',
// // // // //         match: '${p2['height'] ?? "5'7"} FT',
// // // // //       ),
// // // // //       _Trait(
// // // // //         label: 'Smoking',
// // // // //         mine: p1['smoking'] ?? 'Yes',
// // // // //         match: p2['smoking'] ?? 'No',
// // // // //       ),
// // // // //       _Trait(
// // // // //         label: 'Drinking',
// // // // //         mine: p1['drinking'] ?? 'Yes',
// // // // //         match: p2['drinking'] ?? 'Occasionally',
// // // // //       ),
// // // // //       _Trait(
// // // // //         label: 'Body Type',
// // // // //         mine: p1['bodyType'] ?? 'BBW',
// // // // //         match: p2['bodyType'] ?? 'Athletic',
// // // // //       ),
// // // // //       _Trait(
// // // // //         label: 'Languages',
// // // // //         mine: profileState.partner1Languages.join(', '),
// // // // //         match: profileState.partner2Languages.join(', '),
// // // // //       ),
// // // // //     ];
// // // // //
// // // // //     return LayoutBuilder(
// // // // //       builder: (context, constraints) {
// // // // //         final isCompact = constraints.maxWidth < 820;
// // // // //         return Column(
// // // // //           children: [
// // // // //             if (isCompact)
// // // // //               Column(
// // // // //                 children: [
// // // // //                   _ProfileCard(age: _calculateAge(p1['dateOfBirth'])),
// // // // //                   const SizedBox(height: 12),
// // // // //                   _TraitsTable(traits: dynamicTraits),
// // // // //                 ],
// // // // //               )
// // // // //             else
// // // // //               Row(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                 children: [
// // // // //                   Expanded(
// // // // //                       flex: 4,
// // // // //                       child: _ProfileCard(
// // // // //                           age: _calculateAge(p1['dateOfBirth']))),
// // // // //                   SizedBox(width: 12),
// // // // //                   Expanded(flex: 6, child: _TraitsTable(traits: dynamicTraits)),
// // // // //                 ],
// // // // //               ),
// // // // //             const SizedBox(height: 14),
// // // // //             _ProfileSummaryPanels(
// // // // //               about: profileState.aboutMe,
// // // // //               lookingFor: profileState.lookingFor,
// // // // //             ),
// // // // //           ],
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // class _ProfileCard extends StatelessWidget {
// // // // //   final int age;
// // // // //   const _ProfileCard({required this.age});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.all(10),
// // // // //       decoration: BoxDecoration(
// // // // //         gradient: const LinearGradient(
// // // // //           begin: Alignment.topCenter,
// // // // //           end: Alignment.bottomCenter,
// // // // //           colors: [Color(0xFF1C0027), Color(0xFF32003E)],
// // // // //         ),
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           ClipRRect(
// // // // //             borderRadius: BorderRadius.circular(8),
// // // // //             child: Image.asset(
// // // // //               'assets/images/notification-image4.jpg',
// // // // //               height: 130,
// // // // //               width: double.infinity,
// // // // //               fit: BoxFit.cover,
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(height: 8),
// // // // //           const Text(
// // // // //             'davidbrown',
// // // // //             style: TextStyle(
// // // // //               color: Colors.white,
// // // // //               fontWeight: FontWeight.w700,
// // // // //               fontSize: 14,
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(height: 2),
// // // // //           Text(
// // // // //             '$age Years',
// // // // //             style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
// // // // //           ),
// // // // //           Text(
// // // // //             'Male | Female',
// // // // //             style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
// // // // //           ),
// // // // //           Text(
// // // // //             'Jaipur, Rajasthan, India',
// // // // //             style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
// // // // //           ),
// // // // //           const SizedBox(height: 8),
// // // // //           const Text(
// // // // //             'Swingers\nHookUps/Meetups',
// // // // //             style: TextStyle(
// // // // //               color: Colors.white,
// // // // //               fontWeight: FontWeight.w700,
// // // // //               fontSize: 20,
// // // // //               height: 1.15,
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // class _TraitsTable extends StatelessWidget {
// // // // //   final List<_Trait> traits;
// // // // //   const _TraitsTable({required this.traits});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Column(
// // // // //       children: traits.map((trait) => _TraitRow(trait: trait)).toList(),
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // class _TraitRow extends StatelessWidget {
// // // // //   const _TraitRow({required this.trait});
// // // // //
// // // // //   final _Trait trait;
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 10),
// // // // //       child: Row(
// // // // //         children: [
// // // // //           Expanded(
// // // // //             flex: 4,
// // // // //             child: Container(
// // // // //               height: 30,
// // // // //               alignment: Alignment.center,
// // // // //               decoration: BoxDecoration(
// // // // //                 gradient: const LinearGradient(
// // // // //                   colors: [Color(0xFF180024), Color(0xFF3D0053)],
// // // // //                 ),
// // // // //                 borderRadius: BorderRadius.circular(20),
// // // // //               ),
// // // // //               child: Text(
// // // // //                 trait.label,
// // // // //                 style: const TextStyle(
// // // // //                   color: Colors.white,
// // // // //                   fontWeight: FontWeight.w700,
// // // // //                   fontSize: 11,
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(width: 8),
// // // // //           Expanded(
// // // // //             flex: 3,
// // // // //             child: _ConversationValue(
// // // // //               text: trait.mine,
// // // // //               avatarIcon: Icons.person,
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(width: 8),
// // // // //           Expanded(
// // // // //             flex: 3,
// // // // //             child: _ConversationValue(
// // // // //               text: trait.match,
// // // // //               avatarIcon: Icons.person_2,
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // class _ConversationValue extends StatefulWidget {
// // // // //   const _ConversationValue({
// // // // //     required this.text,
// // // // //     required this.avatarIcon,
// // // // //   });
// // // // //
// // // // //   final String text;
// // // // //   final IconData avatarIcon;
// // // // //
// // // // //   @override
// // // // //   State<_ConversationValue> createState() => _ConversationValueState();
// // // // // }
// // // // //
// // // // // class _ConversationValueState extends State<_ConversationValue> {
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Row(
// // // // //       children: [
// // // // //         Container(
// // // // //           width: 30,
// // // // //           height: 30,
// // // // //           decoration: BoxDecoration(
// // // // //             shape: BoxShape.circle,
// // // // //             gradient: const LinearGradient(
// // // // //               colors: [Color(0xFFEDF5FF), Color(0xFFDCE9FF)],
// // // // //             ),
// // // // //             border: Border.all(color: const Color(0xFFBDD1F8)),
// // // // //           ),
// // // // //           child: Icon(widget.avatarIcon, size: 16, color: const Color(0xFF3B6CB7)),
// // // // //         ),
// // // // //         const SizedBox(width: 6),
// // // // //         Expanded(
// // // // //           child: Container(
// // // // //             height: 30,
// // // // //             alignment: Alignment.center,
// // // // //             decoration: BoxDecoration(
// // // // //               color: Colors.white,
// // // // //               borderRadius: BorderRadius.circular(20),
// // // // //               border: Border.all(color: const Color(0xFFE6DFF0)),
// // // // //               boxShadow: [
// // // // //                 BoxShadow(
// // // // //                   color: Colors.purple.withValues(alpha: 0.08),
// // // // //                   blurRadius: 8,
// // // // //                   offset: const Offset(0, 3),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //             child: Text(
// // // // //               widget.text,
// // // // //               overflow: TextOverflow.ellipsis,
// // // // //               style: const TextStyle(
// // // // //                 color: Colors.black87,
// // // // //                 fontWeight: FontWeight.w600,
// // // // //                 fontSize: 11,
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // class _Trait {
// // // // //   const _Trait({
// // // // //     required this.label,
// // // // //     required this.mine,
// // // // //     required this.match,
// // // // //   });
// // // // //
// // // // //   final String label;
// // // // //   final String mine;
// // // // //   final String match;
// // // // // }
// // // // //
// // // // // class _ProfileSummaryPanels extends StatelessWidget {
// // // // //   final String about;
// // // // //   final String lookingFor;
// // // // //   const _ProfileSummaryPanels({required this.about, required this.lookingFor});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return LayoutBuilder(
// // // // //       builder: (context, constraints) {
// // // // //         final compact = constraints.maxWidth < 640;
// // // // //         if (compact) {
// // // // //           return Column(
// // // // //             children: [
// // // // //               _InfoPanel(
// // // // //                 title: 'About',
// // // // //                 content: about,
// // // // //               ),
// // // // //               const SizedBox(height: 10),
// // // // //               _InfoPanel(
// // // // //                 title: 'Interests',
// // // // //                 content: lookingFor,
// // // // //               ),
// // // // //             ],
// // // // //           );
// // // // //         }
// // // // //         return Row(
// // // // //           children: [
// // // // //             Expanded(
// // // // //               child: _InfoPanel(
// // // // //                 title: 'About',
// // // // //                 content: about,
// // // // //               ),
// // // // //             ),
// // // // //             const SizedBox(width: 10),
// // // // //             Expanded(
// // // // //               child: _InfoPanel(
// // // // //                 title: 'Interests',
// // // // //                 content: lookingFor,
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // class _InfoPanel extends StatelessWidget {
// // // // //   const _InfoPanel({
// // // // //     required this.title,
// // // // //     required this.content,
// // // // //   });
// // // // //
// // // // //   final String title;
// // // // //   final String content;
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.all(12),
// // // // //       decoration: BoxDecoration(
// // // // //         color: const Color(0xFFFBF8FF),
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         border: Border.all(color: const Color(0xFFE5DDF2)),
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Text(
// // // // //             title,
// // // // //             style: const TextStyle(
// // // // //               fontSize: 13,
// // // // //               fontWeight: FontWeight.w700,
// // // // //               color: Color(0xFF2F1047),
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(height: 6),
// // // // //           Text(
// // // // //             content,
// // // // //             style: TextStyle(
// // // // //               fontSize: 12,
// // // // //               height: 1.3,
// // // // //               color: Colors.grey[800],
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import '../../../info_card.dart';
// // // // // // import '../../../model/user_profile_model.dart';
// // // // // // import '../../../profile_avatar.dart';
// // // // // // import '../../../providers/profile_provider.dart';
// // // // // // import '../../../core/constants.dart';
// // // // // // import '../../../shimmer_loading.dart';
// // // // // //
// // // // // //
// // // // // // class HomeTab extends ConsumerWidget {
// // // // // //   const HomeTab({super.key});
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     final profileState = ref.watch(profileProvider);
// // // // // //
// // // // // //     switch (profileState.status) {
// // // // // //       case ProfileStatus.initial:
// // // // // //       case ProfileStatus.loading:
// // // // // //         return const ProfileShimmer();
// // // // // //
// // // // // //       case ProfileStatus.error:
// // // // // //         return _buildError(profileState.errorMessage ?? 'Unknown error', ref);
// // // // // //
// // // // // //       case ProfileStatus.loaded:
// // // // // //         if (profileState.profile == null) {
// // // // // //           return _buildError('Profile not found', ref);
// // // // // //         }
// // // // // //         return _buildProfile(context, profileState.profile!);
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildError(String message, WidgetRef ref) {
// // // // // //     return Center(
// // // // // //       child: Padding(
// // // // // //         padding: const EdgeInsets.all(32),
// // // // // //         child: Column(
// // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // //           children: [
// // // // // //             Icon(
// // // // // //               Icons.error_outline,
// // // // // //               size: 64,
// // // // // //               color: AppColors.error.withOpacity(0.7),
// // // // // //             ),
// // // // // //             const SizedBox(height: 16),
// // // // // //             Text(
// // // // // //               message,
// // // // // //               style: AppTextStyles.bodyLarge,
// // // // // //               textAlign: TextAlign.center,
// // // // // //             ),
// // // // // //             const SizedBox(height: 24),
// // // // // //             ElevatedButton.icon(
// // // // // //               onPressed: () =>
// // // // // //                   ref.read(profileProvider.notifier).fetchProfile(),
// // // // // //               icon: const Icon(Icons.refresh),
// // // // // //               label: const Text('Retry'),
// // // // // //               style: ElevatedButton.styleFrom(
// // // // // //                 backgroundColor: AppColors.primary,
// // // // // //                 foregroundColor: Colors.white,
// // // // // //                 padding: const EdgeInsets.symmetric(
// // // // // //                   horizontal: 32,
// // // // // //                   vertical: 12,
// // // // // //                 ),
// // // // // //                 shape: RoundedRectangleBorder(
// // // // // //                   borderRadius: BorderRadius.circular(12),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildProfile(BuildContext context, UserProfileModel profile) {
// // // // // //     return SingleChildScrollView(
// // // // // //       physics: const BouncingScrollPhysics(),
// // // // // //       child: Column(
// // // // // //         children: [
// // // // // //           // Profile Header
// // // // // //           _buildProfileHeader(profile),
// // // // // //           const SizedBox(height: 8),
// // // // // //
// // // // // //           // Quick Stats
// // // // // //           _buildQuickStats(profile),
// // // // // //           const SizedBox(height: 8),
// // // // // //
// // // // // //           // About Section
// // // // // //           if (profile.text != null && profile.text!.isNotEmpty)
// // // // // //             _buildAboutSection(profile),
// // // // // //
// // // // // //           // Basic Info Card
// // // // // //           InfoCard(
// // // // // //             title: 'Basic Information',
// // // // // //             headerIcon: Icons.person_outline,
// // // // // //             items: [
// // // // // //               InfoItem(label: 'Username', value: profile.username),
// // // // // //               InfoItem(label: 'Email', value: profile.email),
// // // // // //               InfoItem(label: 'Profile Type', value: profile.profileType.toUpperCase()),
// // // // // //               InfoItem(label: 'Gender', value: profile.genderDisplay),
// // // // // //               InfoItem(label: 'Age', value: '${profile.age} years'),
// // // // // //               if (profile.person1Dob != null)
// // // // // //                 InfoItem(label: 'Date of Birth', value: profile.person1Dob!),
// // // // // //             ],
// // // // // //           ),
// // // // // //
// // // // // //           // Person 1 Details
// // // // // //           InfoCard(
// // // // // //             title: profile.isSingle ? 'Physical Details' : '${profile.person1Name} Details',
// // // // // //             headerIcon: Icons.accessibility_new,
// // // // // //             items: [
// // // // // //               InfoItem(label: 'Height', value: profile.person1Height ?? ''),
// // // // // //               InfoItem(label: 'Weight', value: profile.person1Weight ?? ''),
// // // // // //               InfoItem(label: 'Body Type', value: profile.person1BodyType ?? ''),
// // // // // //               InfoItem(label: 'Ethnicity', value: profile.person1EthnicBackground ?? ''),
// // // // // //               InfoItem(label: 'Body Hair', value: profile.person1BodyHair ?? ''),
// // // // // //               InfoItem(label: 'Piercings', value: profile.person1Piercings ?? ''),
// // // // // //               InfoItem(label: 'Tattoos', value: profile.person1Tattoos ?? ''),
// // // // // //             ],
// // // // // //           ),
// // // // // //
// // // // // //           // Person 1 Lifestyle
// // // // // //           InfoCard(
// // // // // //             title: profile.isSingle ? 'Lifestyle' : '${profile.person1Name} Lifestyle',
// // // // // //             headerIcon: Icons.favorite_outline,
// // // // // //             items: [
// // // // // //               InfoItem(label: 'Smoking', value: profile.person1Smoking ?? ''),
// // // // // //               InfoItem(label: 'Drinking', value: profile.person1Drinking ?? ''),
// // // // // //               InfoItem(label: 'Sexuality', value: profile.person1Sexuality ?? ''),
// // // // // //               InfoItem(label: 'Relationship', value: profile.person1RelationshipOrientation ?? ''),
// // // // // //               InfoItem(label: 'Language', value: profile.person1LanguageSpoken ?? ''),
// // // // // //             ],
// // // // // //           ),
// // // // // //
// // // // // //           // Person 2 Details (Couple only)
// // // // // //           if (profile.isCouple) ...[
// // // // // //             InfoCard(
// // // // // //               title: '${profile.person2Name} Details',
// // // // // //               headerIcon: Icons.accessibility_new,
// // // // // //               items: [
// // // // // //                 InfoItem(label: 'Age', value: '${profile.age2} years'),
// // // // // //                 if (profile.person2Dob != null)
// // // // // //                   InfoItem(label: 'Date of Birth', value: profile.person2Dob!),
// // // // // //                 InfoItem(label: 'Height', value: profile.person2Height ?? ''),
// // // // // //                 InfoItem(label: 'Weight', value: profile.person2Weight ?? ''),
// // // // // //                 InfoItem(label: 'Body Type', value: profile.person2BodyType ?? ''),
// // // // // //                 InfoItem(label: 'Ethnicity', value: profile.person2EthnicBackground ?? ''),
// // // // // //                 InfoItem(label: 'Body Hair', value: profile.person2BodyHair ?? ''),
// // // // // //                 InfoItem(label: 'Piercings', value: profile.person2Piercings ?? ''),
// // // // // //                 InfoItem(label: 'Tattoos', value: profile.person2Tattoos ?? ''),
// // // // // //               ],
// // // // // //             ),
// // // // // //
// // // // // //             InfoCard(
// // // // // //               title: '${profile.person2Name} Lifestyle',
// // // // // //               headerIcon: Icons.favorite_outline,
// // // // // //               items: [
// // // // // //                 InfoItem(label: 'Smoking', value: profile.person2Smoking ?? ''),
// // // // // //                 InfoItem(label: 'Drinking', value: profile.person2Drinking ?? ''),
// // // // // //                 InfoItem(label: 'Sexuality', value: profile.person2Sexuality ?? ''),
// // // // // //                 InfoItem(label: 'Relationship', value: profile.person2RelationshipOrientation ?? ''),
// // // // // //                 InfoItem(label: 'Language', value: profile.person2LanguageSpoken ?? ''),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ],
// // // // // //
// // // // // //           // Location Card
// // // // // //           InfoCard(
// // // // // //             title: 'Location',
// // // // // //             headerIcon: Icons.location_on_outlined,
// // // // // //             items: [
// // // // // //               InfoItem(label: 'City', value: profile.city ?? ''),
// // // // // //               InfoItem(label: 'Address', value: profile.address ?? ''),
// // // // // //               if (profile.lat != null)
// // // // // //                 InfoItem(label: 'Coordinates', value: '${profile.lat}, ${profile.lng}'),
// // // // // //             ],
// // // // // //           ),
// // // // // //
// // // // // //           // Membership Card
// // // // // //           InfoCard(
// // // // // //             title: 'Membership',
// // // // // //             headerIcon: Icons.card_membership,
// // // // // //             items: [
// // // // // //               InfoItem(label: 'Member Since', value: profile.created),
// // // // // //               InfoItem(label: 'Last Payment', value: profile.lastPayment),
// // // // // //               InfoItem(label: 'Expires', value: profile.expireDate),
// // // // // //             ],
// // // // // //           ),
// // // // // //
// // // // // //           const SizedBox(height: 32),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildProfileHeader(UserProfileModel profile) {
// // // // // //     return Container(
// // // // // //       width: double.infinity,
// // // // // //       decoration: const BoxDecoration(
// // // // // //         gradient: LinearGradient(
// // // // // //           colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
// // // // // //           begin: Alignment.topCenter,
// // // // // //           end: Alignment.bottomCenter,
// // // // // //         ),
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         children: [
// // // // // //           const SizedBox(height: 24),
// // // // // //           // Avatar
// // // // // //           ProfileAvatar(
// // // // // //             isCouple: profile.isCouple,
// // // // // //             radius: 55,
// // // // // //             showEditIcon: true,
// // // // // //           ),
// // // // // //           const SizedBox(height: 16),
// // // // // //
// // // // // //           // Name
// // // // // //           Text(
// // // // // //             profile.displayName,
// // // // // //             style: AppTextStyles.heading1,
// // // // // //             textAlign: TextAlign.center,
// // // // // //           ),
// // // // // //           const SizedBox(height: 6),
// // // // // //
// // // // // //           // Gender & type badge
// // // // // //           Row(
// // // // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // // // //             children: [
// // // // // //               Container(
// // // // // //                 padding: const EdgeInsets.symmetric(
// // // // // //                   horizontal: 12,
// // // // // //                   vertical: 4,
// // // // // //                 ),
// // // // // //                 decoration: BoxDecoration(
// // // // // //                   color: profile.isSingle
// // // // // //                       ? AppColors.primary.withOpacity(0.2)
// // // // // //                       : AppColors.accent.withOpacity(0.2),
// // // // // //                   borderRadius: BorderRadius.circular(20),
// // // // // //                   border: Border.all(
// // // // // //                     color: profile.isSingle
// // // // // //                         ? AppColors.primary.withOpacity(0.5)
// // // // // //                         : AppColors.accent.withOpacity(0.5),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 child: Row(
// // // // // //                   mainAxisSize: MainAxisSize.min,
// // // // // //                   children: [
// // // // // //                     Icon(
// // // // // //                       profile.isSingle ? Icons.person : Icons.people,
// // // // // //                       size: 14,
// // // // // //                       color: profile.isSingle
// // // // // //                           ? AppColors.primary
// // // // // //                           : AppColors.accent,
// // // // // //                     ),
// // // // // //                     const SizedBox(width: 4),
// // // // // //                     Text(
// // // // // //                       profile.genderDisplay,
// // // // // //                       style: TextStyle(
// // // // // //                         fontSize: 12,
// // // // // //                         fontWeight: FontWeight.w600,
// // // // // //                         color: profile.isSingle
// // // // // //                             ? AppColors.primary
// // // // // //                             : AppColors.accent,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 8),
// // // // // //
// // // // // //           // Location
// // // // // //           Row(
// // // // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // // // //             children: [
// // // // // //               Icon(
// // // // // //                 Icons.location_on,
// // // // // //                 size: 14,
// // // // // //                 color: AppColors.textMuted,
// // // // // //               ),
// // // // // //               const SizedBox(width: 4),
// // // // // //               Text(
// // // // // //                 profile.locationDisplay,
// // // // // //                 style: AppTextStyles.bodySmall,
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 20),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildQuickStats(UserProfileModel profile) {
// // // // // //     return Container(
// // // // // //       margin: const EdgeInsets.symmetric(horizontal: 16),
// // // // // //       padding: const EdgeInsets.symmetric(vertical: 16),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: AppColors.cardDark,
// // // // // //         borderRadius: BorderRadius.circular(16),
// // // // // //         border: Border.all(color: AppColors.divider, width: 0.5),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // // //         children: [
// // // // // //           _buildStatItem(
// // // // // //             icon: Icons.cake,
// // // // // //             label: 'Age',
// // // // // //             value: '${profile.age}',
// // // // // //           ),
// // // // // //           _buildDivider(),
// // // // // //           _buildStatItem(
// // // // // //             icon: Icons.calendar_today,
// // // // // //             label: 'Member Since',
// // // // // //             value: profile.created.isNotEmpty
// // // // // //                 ? profile.created.substring(0, 7)
// // // // // //                 : '-',
// // // // // //           ),
// // // // // //           _buildDivider(),
// // // // // //           _buildStatItem(
// // // // // //             icon: Icons.verified,
// // // // // //             label: 'Status',
// // // // // //             value: 'Active',
// // // // // //             valueColor: AppColors.success,
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildStatItem({
// // // // // //     required IconData icon,
// // // // // //     required String label,
// // // // // //     required String value,
// // // // // //     Color? valueColor,
// // // // // //   }) {
// // // // // //     return Column(
// // // // // //       children: [
// // // // // //         Icon(icon, color: AppColors.primary, size: 22),
// // // // // //         const SizedBox(height: 6),
// // // // // //         Text(
// // // // // //           value,
// // // // // //           style: AppTextStyles.heading3.copyWith(
// // // // // //             color: valueColor ?? AppColors.textPrimary,
// // // // // //             fontSize: 16,
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 2),
// // // // // //         Text(label, style: AppTextStyles.bodySmall),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildDivider() {
// // // // // //     return Container(
// // // // // //       width: 1,
// // // // // //       height: 40,
// // // // // //       color: AppColors.divider,
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildAboutSection(UserProfileModel profile) {
// // // // // //     return Container(
// // // // // //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // // // // //       padding: const EdgeInsets.all(16),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: AppColors.cardDark,
// // // // // //         borderRadius: BorderRadius.circular(16),
// // // // // //         border: Border.all(color: AppColors.divider, width: 0.5),
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
// // // // // //               const SizedBox(width: 8),
// // // // // //               Text('About', style: AppTextStyles.heading3),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 12),
// // // // // //           Text(
// // // // // //             profile.text!,
// // // // // //             style: AppTextStyles.bodyMedium.copyWith(
// // // // // //               height: 1.6,
// // // // // //               color: AppColors.textSecondary,
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
