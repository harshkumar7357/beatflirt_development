// ╔═══════════════════════════════════════════════════════════════════╗
// ║  View User Pay-Per-Click Detail Page                             ║
// ║  Web route: /view-user-pay-per-click?id=<base64_id>              ║
// ║  Web source: chunk-QHNFHIEW.js + chunk-7ZDHDJXH.js (reviews)    ║
// ║                                                                  ║
// ║  APIs called (in parallel like web ngOnInit):                    ║
// ║    POST /payperclick/get_single_chocolate_factory  {id}          ║
// ║    POST /payperclick/get_user_calender_details    {pay_per_id}   ║
// ║    POST /payperclick/pay_per_user_approve_image   {pay_per_id}   ║
// ║    POST /payperclick/pay_per_user_approve_video   {pay_per_id}   ║
// ║    POST /payperclick/get_all_review               {pay_per_id}   ║
// ╚═══════════════════════════════════════════════════════════════════╝

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const String _kApiBase = 'https://app.beatflirtevent.com/App';
const String _kAssetBase = 'https://app.beatflirtevent.com/assets/';

// ════════════════════════════════════════════════════════════════════
// MODELS
// ════════════════════════════════════════════════════════════════════

class _Img {
  final String profileImage;
  const _Img({required this.profileImage});
  factory _Img.fromJson(Map<String, dynamic> j) =>
      _Img(profileImage: '${j['profile_image'] ?? ''}');
}

class _ApprovedMedia {
  final String id;
  final String image;
  final String lockImage;
  final String video;
  final String lockVideo;
  final String userId;
  final String title;
  final String price;
  const _ApprovedMedia({
    this.id = '',
    this.image = '',
    this.lockImage = '0',
    this.video = '',
    this.lockVideo = '0',
    this.userId = '',
    this.title = '',
    this.price = '',
  });
  factory _ApprovedMedia.fromJson(Map<String, dynamic> j) => _ApprovedMedia(
    id: '${j['id'] ?? ''}',
    image: '${j['image'] ?? ''}',
    lockImage: '${j['lock_image'] ?? '0'}',
    video: '${j['video'] ?? ''}',
    lockVideo: '${j['lock_video'] ?? '0'}',
    userId: '${j['user_id'] ?? ''}',
    title: '${j['title'] ?? ''}',
    price: '${j['price'] ?? ''}',
  );
}

class _User {
  final String id,
      username,
      age,
      showAge,
      stateOfResidence,
      heightFeet,
      heightInch,
      showHeight,
      weight,
      showWeight,
      showPreferences,
      selfDescription;
  final List<String> preferences;
  final List<_Img> images;

  const _User({
    required this.id,
    required this.username,
    this.age = '',
    this.showAge = '0',
    this.stateOfResidence = '',
    this.heightFeet = '',
    this.heightInch = '',
    this.showHeight = '0',
    this.weight = '',
    this.showWeight = '0',
    this.preferences = const [],
    this.showPreferences = '0',
    this.selfDescription = '',
    this.images = const [],
  });

  String get profileImage => images.isNotEmpty ? images.first.profileImage : '';
  String get displayHeight => "${heightFeet}' ${heightInch}\"";

  factory _User.fromJson(Map<String, dynamic> j) => _User(
    id: '${j['id'] ?? ''}',
    username: '${j['username'] ?? ''}',
    age: '${j['age'] ?? ''}',
    showAge: '${j['show_age'] ?? '0'}',
    stateOfResidence: '${j['state_of_residence'] ?? ''}',
    heightFeet: '${j['height_feet'] ?? ''}',
    heightInch: '${j['height_inch'] ?? ''}',
    showHeight: '${j['show_height'] ?? '0'}',
    weight: '${j['weight'] ?? ''}',
    showWeight: '${j['show_weight'] ?? '0'}',
    preferences:
        (j['preferences'] as List<dynamic>?)?.map((e) => '$e').toList() ?? [],
    showPreferences: '${j['show_preferences'] ?? '0'}',
    selfDescription: '${j['self_description'] ?? ''}',
    images:
        (j['image'] as List<dynamic>?)?.map((e) => _Img.fromJson(e)).toList() ??
        [],
  );
}

class _CalSlot {
  final String calenderDate, startTime, endTime;
  const _CalSlot({
    required this.calenderDate,
    required this.startTime,
    required this.endTime,
  });
  factory _CalSlot.fromJson(Map<String, dynamic> j) => _CalSlot(
    calenderDate: '${j['calender_date'] ?? ''}',
    startTime: '${j['start_time_12_formate'] ?? ''}',
    endTime: '${j['end_time_12_formate'] ?? ''}',
  );
}

class _Review {
  final String username, message, starCount;
  final String profileImage;
  const _Review({
    required this.username,
    required this.message,
    required this.starCount,
    this.profileImage = '',
  });
  factory _Review.fromJson(Map<String, dynamic> j) => _Review(
    username: '${j['username'] ?? ''}',
    message: '${j['message'] ?? ''}',
    starCount: '${j['star_count'] ?? '0'}',
    profileImage: (j['image'] is List && (j['image'] as List).isNotEmpty)
        ? '${j['image'][0]['profile_image'] ?? ''}'
        : '',
  );
}

// ════════════════════════════════════════════════════════════════════
// PAGE
// ════════════════════════════════════════════════════════════════════

class CelebrityProfileDetailPage extends ConsumerStatefulWidget {
  final String userId;
  final String username;
  final String? profileImageUrl;
  final String? userState;

  const CelebrityProfileDetailPage({
    super.key,
    required this.userId,
    required this.username,
    this.profileImageUrl,
    this.userState,
  });

  @override
  ConsumerState<CelebrityProfileDetailPage> createState() =>
      _CelebrityProfileDetailPageState();
}

class _CelebrityProfileDetailPageState
    extends ConsumerState<CelebrityProfileDetailPage> {
  static const _bg = Color(0xFF0B0B1A);
  static const _card = Color(0xFF13132B);
  static const _accent = Color(0xFFE91E63);
  static const _gold = Color(0xFFF4BA4A);
  static const _surface = Color(0xFF1C1C3A);

  _User? _user;
  bool _loading = true;
  List<_CalSlot> _calSlots = [];
  List<_ApprovedMedia> _photos = [];
  List<_ApprovedMedia> _videos = [];
  List<_Review> _reviews = [];
  String _activeTab = 'photos'; // photos | videos

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  // ── Auth headers ──────────────────────────────────────────────
  Future<Map<String, String>> _h() async {
    final p = await SharedPreferences.getInstance();
    final t =
        p.getString('Access-Token') ??
        p.getString('access_token') ??
        p.getString('accessToken') ??
        p.getString('token') ??
        p.getString('auth_token');
    final s =
        p.getString('Access-Sign') ??
        p.getString('access_sign') ??
        p.getString('accessSign') ??
        p.getString('sign');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (t != null) 'Access-Token': t,
      if (s != null) 'Access-Sign': s,
    };
  }

  bool _ok(Map<String, dynamic>? r) => r != null && '${r['status']}' == '200';

  Future<Map<String, dynamic>?> _post(
    Map<String, String> h,
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('$_kApiBase$path');
      final r = await http.post(uri, headers: h, body: jsonEncode(body));
      debugPrint('  POST $path → ${r.statusCode}');
      if (r.statusCode == 200 && r.body.isNotEmpty) {
        return jsonDecode(r.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('  POST $path ERROR: $e');
    }
    return null;
  }

  // ── Load all data in parallel (matches web ngOnInit) ──────────
  Future<void> _loadAll() async {
    final h = await _h();
    final id = widget.userId;

    final results = await Future.wait([
      _post(h, '/payperclick/get_single_chocolate_factory', {'id': id}),
      _post(h, '/payperclick/get_user_calender_details', {'pay_per_id': id}),
      _post(h, '/payperclick/pay_per_user_approve_image', {'pay_per_id': id}),
      _post(h, '/payperclick/pay_per_user_approve_video', {'pay_per_id': id}),
      _post(h, '/payperclick/get_all_review', {'pay_per_id': id}),
    ]);

    // 1) Profile
    final profile = results[0];
    if (_ok(profile)) {
      final d = profile!['data'];
      if (d is List && d.isNotEmpty)
        _user = _User.fromJson(d[0]);
      else if (d is Map)
        _user = _User.fromJson(d[0]);
    }
    _user ??= _User(
      id: widget.userId,
      username: widget.username,
      stateOfResidence: widget.userState ?? '',
      images: widget.profileImageUrl != null
          ? [_Img(profileImage: widget.profileImageUrl!)]
          : [],
    );

    // 2) Calendar
    final cal = results[1];
    if (_ok(cal)) {
      final d = cal!['data'];
      if (d is List) _calSlots = d.map((e) => _CalSlot.fromJson(e)).toList();
    }

    // 3) Photos
    final photos = results[2];
    if (_ok(photos)) {
      final d = photos!['data'];
      if (d is List)
        _photos = d.map((e) => _ApprovedMedia.fromJson(e)).toList();
    }

    // 4) Videos
    final vids = results[3];
    if (_ok(vids)) {
      final d = vids!['data'];
      if (d is List)
        _videos = d.map((e) => _ApprovedMedia.fromJson(e)).toList();
    }

    // 5) Reviews
    final revs = results[4];
    if (_ok(revs)) {
      final d = revs!['data'];
      if (d is List) _reviews = d.map((e) => _Review.fromJson(e)).toList();
    }

    if (mounted) setState(() => _loading = false);
  }

  // ── Submit review ─────────────────────────────────────────────
  // Web: POST /payperclick/save_review {pay_per_id, star_count, message}
  Future<void> _submitReview(int starCount, String message) async {
    if (starCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (message.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a review'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final h = await _h();
    final r = await _post(h, '/payperclick/save_review', {
      'pay_per_id': widget.userId,
      'star_count': '$starCount',
      'message': message.trim(),
    });

    if (_ok(r)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(r?['message'] ?? 'Review submitted!'),
          backgroundColor: Colors.green,
        ),
      );
      // Reload reviews
      setState(() => _loading = true);
      _loadAll();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit review'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _accent))
          : _buildPage(),
    );
  }

  Widget _buildPage() {
    final u = _user!;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Back button ──────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Back',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Profile banner ───────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _card,
            ),
            child: Column(
              children: [
                // Image with badge + name overlay
                SizedBox(
                  height: 280,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: _netImg(u.profileImage, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withAlpha(200),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Image.network(
                          '${_kAssetBase}img/badge1.png',
                          width: 44,
                          height: 44,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.verified,
                            color: _gold,
                            size: 32,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 14,
                        right: 16,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                u.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (u.showAge == '1' && u.age.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Age ${u.age}',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(200),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Profile meta ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username + age row
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${u.username} ${u.showAge == '1' && u.age.isNotEmpty ? 'Age ${u.age}' : ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Location
                      if (u.stateOfResidence.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: _accent,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                u.stateOfResidence,
                                style: TextStyle(
                                  color: Colors.white.withAlpha(170),
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),

                      // Height / Weight
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            if (u.showHeight == '1' && u.heightFeet.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Height: ',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      u.displayHeight,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (u.showWeight == '1' && u.weight.isNotEmpty)
                              Row(
                                children: [
                                  const Text(
                                    'Weight: ',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${u.weight} Kg',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Preferences
                      if (u.showPreferences == '1' &&
                          u.preferences.isNotEmpty) ...[
                        const Text(
                          'Preferences',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: u.preferences
                              .map(
                                (p) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _accent.withAlpha(25),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _accent.withAlpha(70),
                                    ),
                                  ),
                                  child: Text(
                                    p,
                                    style: const TextStyle(
                                      color: _accent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Write Review button
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () => _showReviewDialog(),
                          icon: const Icon(
                            Icons.rate_review,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            'Write Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Calendar
                      GestureDetector(
                        onTap: () => _showCalendarModal(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withAlpha(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: _gold,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Calendar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'View booked slots',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(100),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Description
                      const Text(
                        'Description:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        u.selfDescription.isNotEmpty
                            ? u.selfDescription
                            : 'No comment',
                        style: TextStyle(
                          color: Colors.white.withAlpha(160),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Media section: Photos / Videos tabs ──────────
          // (matches web beat-media-section with nav tabs)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab bar
                Container(
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 'photos'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _activeTab == 'photos'
                                  ? _accent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                'Photos',
                                style: TextStyle(
                                  color: _activeTab == 'photos'
                                      ? Colors.white
                                      : Colors.white.withAlpha(120),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 'videos'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _activeTab == 'videos'
                                  ? _accent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                'Videos',
                                style: TextStyle(
                                  color: _activeTab == 'videos'
                                      ? Colors.white
                                      : Colors.white.withAlpha(120),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Tab content
                if (_activeTab == 'photos') _buildPhotosGrid(),
                if (_activeTab == 'videos') _buildVideosGrid(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Reviews section ──────────────────────────────
          // (matches web: get_all_review + review items)
          if (_reviews.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._reviews.map(
                    (rev) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withAlpha(10)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: _surface,
                            backgroundImage: rev.profileImage.isNotEmpty
                                ? NetworkImage(
                                    rev.profileImage.startsWith('http')
                                        ? rev.profileImage
                                        : '$_kAssetBase${rev.profileImage}',
                                  )
                                : null,
                            child: rev.profileImage.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white24,
                                    size: 20,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      rev.username,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),

                                    const SizedBox(width: 8),
                                    // Stars
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        i < (int.tryParse(rev.starCount) ?? 0)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color:
                                            i <
                                                (int.tryParse(rev.starCount) ??
                                                    0)
                                            ? _gold
                                            : Colors.white24,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  rev.message,
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(160),
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review,
                      color: Colors.white.withAlpha(20),
                      size: 36,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to share your experience!',
                      style: TextStyle(
                        color: Colors.white.withAlpha(50),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Photos grid ───────────────────────────────────────────────
  Widget _buildPhotosGrid() {
    if (_photos.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.photo_library,
              color: Colors.white.withAlpha(20),
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              'No Photos Available',
              style: TextStyle(color: Colors.white.withAlpha(40)),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _photos.length,
      itemBuilder: (ctx, i) {
        final ph = _photos[i];
        final locked = ph.lockImage == '1';
        return GestureDetector(
          onTap: () {
            if (!locked && ph.image.isNotEmpty) _showImage(ph.image);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _netImg(locked ? '${_kAssetBase}img/lock.png' : ph.image),
                Positioned(
                  bottom: 6,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: locked
                            ? _accent.withAlpha(200)
                            : Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        locked ? 'Unlock' : 'View',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Videos grid ───────────────────────────────────────────────
  // Web: video thumbnail or lock + "Unlock Video" label
  Widget _buildVideosGrid() {
    if (_videos.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.videocam, color: Colors.white.withAlpha(20), size: 40),
            const SizedBox(height: 8),
            Text(
              'No Videos Available',
              style: TextStyle(color: Colors.white.withAlpha(40)),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _videos.length,
      itemBuilder: (ctx, i) {
        final v = _videos[i];
        final locked = v.lockVideo == '1';
        return GestureDetector(
          onTap: () {
            if (!locked && v.video.isNotEmpty) {
              // Play video — for now show in full screen
              _showVideo(v.video);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Thumbnail: show lock icon or video thumbnail
                Container(
                  color: _surface,
                  child: Center(
                    child: locked
                        ? Image.network(
                            '${_kAssetBase}img/lock.png',
                            width: 40,
                            height: 40,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.lock,
                              color: Colors.white24,
                              size: 36,
                            ),
                          )
                        : const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white54,
                            size: 48,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: locked
                            ? _accent.withAlpha(200)
                            : Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        locked ? 'Unlock Video' : 'Play',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Review dialog (matches web add-pay-per-review) ────────────
  // Web: star rating (1-5) + textarea + submit → save_review API
  void _showReviewDialog() {
    int selectedStars = 0;
    final msgCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Title
                    const Text(
                      'Write a Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Star rating
                    const Text(
                      'Rating',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (i) => GestureDetector(
                          onTap: () =>
                              setModalState(() => selectedStars = i + 1),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              i < selectedStars
                                  ? Icons.star
                                  : Icons.star_border,
                              color: i < selectedStars ? _gold : Colors.white24,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Message
                    const Text(
                      'Your Review',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: msgCtrl,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Tell us about your experience...',
                        hintStyle: TextStyle(color: Colors.white.withAlpha(60)),
                        filled: true,
                        fillColor: _surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _accent.withAlpha(80)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _submitReview(selectedStars, msgCtrl.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Calendar modal ────────────────────────────────────────────
  void _showCalendarModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month, color: _gold, size: 22),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Booked Slots',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_calSlots.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No booked slots found',
                  style: TextStyle(color: Colors.white.withAlpha(50)),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _calSlots.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final s = _calSlots[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _accent.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: _accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s.calenderDate,
                              style: TextStyle(color: _gold, fontSize: 13),
                            ),
                          ),
                          Text(
                            '${s.startTime} - ${s.endTime}',
                            style: TextStyle(
                              color: Colors.white.withAlpha(160),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Image viewer ──────────────────────────────────────────────
  void _showImage(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(child: _netImg(url, fit: BoxFit.contain)),
          ),
        ),
      ),
    );
  }

  // ── Video viewer (basic) ──────────────────────────────────────
  void _showVideo(String url) {
    String full = url.startsWith('http') ? url : '$_kAssetBase$url';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_fill, color: _accent, size: 80),
                const SizedBox(height: 16),
                Text(
                  'Video Player',
                  style: TextStyle(
                    color: Colors.white.withAlpha(120),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    full,
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // NOTE: For full video playback, add video_player package and use VideoPlayer widget
  }

  // ── Network image helper ──────────────────────────────────────
  Widget _netImg(String url, {BoxFit fit = BoxFit.cover}) {
    if (url.isEmpty)
      return Container(
        color: _surface,
        child: const Center(
          child: Icon(Icons.person, color: Colors.white24, size: 50),
        ),
      );
    String full = url.startsWith('http') ? url : '$_kAssetBase$url';
    return Image.network(
      full,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        color: _surface,
        child: const Center(
          child: Icon(Icons.person, color: Colors.white24, size: 50),
        ),
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: _surface,
          child: const Center(
            child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
          ),
        );
      },
    );
  }
}
