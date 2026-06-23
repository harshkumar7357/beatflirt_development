import 'dart:convert';
import 'dart:io';

import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:beatflirt/core/utils/video_thumbnail_utils.dart';
import 'package:get/get.dart';

// --- API CONFIG ---
class _VideoApi {
  static const String _base = 'https://app.beatflirtevent.com/App/user';
  static const String approvedUrl = '$_base/signle_user_profile_approve_video';
  static const String pendingUrl = '$_base/signle_user_profile_pending_video';

  static const String uploadUrl =
      'https://app.beatflirtevent.com/App/upload/video_upload';
  static const String deleteUrl =
      'https://app.beatflirtevent.com/App/user/delete_profile_video';

  static Future<void> deleteVideo({
    required String token,
    required String mediaId,
  }) async {
    final response = await http.post(
      Uri.parse(deleteUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'access-token': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'video_id': mediaId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Delete failed: ${response.statusCode}');
    }
  }

  /// Uploads a video file via multipart/form-data to `/upload/video_upload`,
  /// and then links it to the profile using JSON post to `/user/upload_profile_video`.
  static Future<String> uploadVideo({
    required String token,
    required String filePath,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.headers['access-token'] = token;
    request.files.add(
      await http.MultipartFile.fromPath('video', filePath),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    // ---- DEBUG ----
    debugPrint('[VideoApi] POST $uploadUrl');
    debugPrint('[VideoApi] upload status=${response.statusCode}');
    debugPrint('[VideoApi] upload body=${response.body}');
    // ---------------

    if (response.statusCode != 200) {
      throw Exception('Upload failed: HTTP ${response.statusCode}');
    }

    final body = response.body.trim();
    final decoded = jsonDecode(body);
    if (decoded is! Map) {
      throw Exception('Upload failed: unexpected response');
    }

    final status = (decoded['status'] ?? '').toString();
    if (status != '200') {
      throw Exception(
        'Upload failed: ${decoded['message'] ?? 'status $status'}',
      );
    }

    final data = decoded['data'];
    if (data is Map) {
      final fileName = data['file_name']?.toString();
      if (fileName != null && fileName.isNotEmpty) {
        // Link to profile
        final linkUrl = 'https://app.beatflirtevent.com/App/user/upload_profile_video';
        debugPrint('[VideoApi] Linking video to profile: $fileName');
        final linkRes = await http.post(
          Uri.parse(linkUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'access-token': token,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'video': fileName}),
        );
        debugPrint('[VideoApi] Link response: ${linkRes.body}');
        if (linkRes.statusCode == 200) {
          final linkDecoded = jsonDecode(linkRes.body);
          if (linkDecoded['status'] == '200') {
            final linkData = linkDecoded['data'];
            if (linkData is Map) {
              String fullPath = (linkData['full_path'] ?? linkData['profile_video'] ?? '').toString();
              if (fullPath.isNotEmpty) {
                if (fullPath.contains('public_html/app.beatflirtevent.com/')) {
                  fullPath = fullPath.replaceFirst(
                    '/home/beatflirtevent/public_html/app.beatflirtevent.com/',
                    'https://app.beatflirtevent.com/',
                  );
                }
                return fullPath;
              }
            }
            return 'https://app.beatflirtevent.com/assets/images/$fileName';
          }
        }
      }
    }
    return '';
  }

  /// Fetches a video list from [url]. Returns parsed [VideoItem]s.
  ///
  /// Handles the two documented response shapes:
  ///   - {"status":"200","data":[ {id, profile_video, status}, ... ]}
  ///   - {"status":"404","data":""}  (empty)
  ///
  /// [approved] decides which list these items belong to, since the endpoint
  /// itself determines approval state.
  static Future<List<VideoItem>> fetchVideos({
    required String url,
    required String token,
    required bool approved,
  }) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'access-token': token,
      },
    );

    // ---- DEBUG: see exactly what the server returns ----
    debugPrint('[VideoApi] GET $url');
    debugPrint('[VideoApi] status=${response.statusCode}');
    debugPrint('[VideoApi] body=${response.body}');
    // ----------------------------------------------------

    if (response.statusCode != 200) {
      throw Exception('Request failed: ${response.statusCode}');
    }

    final body = response.body.trim();
    if (body.isEmpty) return [];

    final decoded = jsonDecode(body);
    if (decoded is! Map) return [];

    final status = (decoded['status'] ?? '').toString();
    if (status != '200') return []; // 404 / empty etc.

    final data = decoded['data'];
    if (data is! List) return []; // empty data comes back as "" (a String)

    final items = data
        .whereType<Map>()
        .map(
          (e) => VideoItem.fromApi(
            Map<String, dynamic>.from(e),
            approved: approved,
          ),
        )
        .where((item) => item.videoPath != null && item.videoPath!.isNotEmpty)
        .toList();

    debugPrint('[VideoApi] parsed ${items.length} item(s) from $url');
    return items;
  }
}

// --- MODEL ---
class VideoItem {
  const VideoItem({
    required this.mediaId,
    required this.thumbnailPath,
    required this.approved,
    this.videoPath,
    this.isLocalVideo = false,
  });

  final String mediaId;
  final String thumbnailPath;
  final bool approved;
  final String? videoPath;
  final bool isLocalVideo;

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'thumbnailPath': thumbnailPath,
      'approved': approved,
      'videoPath': videoPath,
      'isLocalVideo': isLocalVideo,
    };
  }

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    String? path = json['videoPath']?.toString();
    if (path != null && path.contains('public_html/app.beatflirtevent.com/')) {
      path = path.replaceFirst(
        '/home/beatflirtevent/public_html/app.beatflirtevent.com/',
        'https://app.beatflirtevent.com/',
      );
    }
    if (path != null && !path.startsWith('http') && !path.startsWith('/') && path.isNotEmpty) {
      if (path.startsWith('assets/images/')) {
        path = 'https://app.beatflirtevent.com/$path';
      } else {
        path = 'https://app.beatflirtevent.com/assets/images/$path';
      }
    } else if (path != null && path.startsWith('/assets/images/')) {
      path = 'https://app.beatflirtevent.com$path';
    }
    if (path != null &&
        (path.endsWith('/assets/images/') || path.endsWith('/assets/images') || path.isEmpty)) {
      path = null;
    }
    return VideoItem(
      mediaId: (json['mediaId'] ?? '').toString(),
      thumbnailPath:
          (json['thumbnailPath'] ?? 'assets/images/notification-image4.jpg')
              .toString(),
      approved: json['approved'] == true,
      videoPath: path,
      isLocalVideo: path != null && path.startsWith('/') && !path.startsWith('http'),
    );
  }

  /// Maps the new API shape:
  /// {
  ///   "id": "1",
  ///   "profile_video": "https://.../video.mp4",
  ///   "status": "0"   // "0" = pending, "1" = approved
  /// }
  ///
  /// [approved] is supplied by the calling endpoint (approved vs pending),
  /// but we also fall back to the per-item `status` field if present.
  factory VideoItem.fromApi(
    Map<String, dynamic> json, {
    required bool approved,
  }) {
    String path = (json['profile_video'] ?? json['video_path'] ?? json['video'] ?? '').toString().trim();
    if (path.contains('public_html/app.beatflirtevent.com/')) {
      path = path.replaceFirst(
        '/home/beatflirtevent/public_html/app.beatflirtevent.com/',
        'https://app.beatflirtevent.com/',
      );
    }

    if (!path.startsWith('http') && !path.startsWith('/') && path.isNotEmpty) {
      if (path.startsWith('assets/images/')) {
        path = 'https://app.beatflirtevent.com/$path';
      } else {
        path = 'https://app.beatflirtevent.com/assets/images/$path';
      }
    } else if (path.startsWith('/assets/images/')) {
      path = 'https://app.beatflirtevent.com$path';
    }

    if (path.endsWith('/assets/images/') || path.endsWith('/assets/images') || path.isEmpty) {
      path = '';
    }
    final statusStr = (json['status'] ?? '').toString();

    // Prefer the endpoint's intent, but honor an explicit status when given.
    bool isApproved = approved;
    if (statusStr == '1') {
      isApproved = true;
    } else if (statusStr == '0') {
      isApproved = false;
    }

    return VideoItem(
      mediaId: (json['id'] ?? '').toString(),
      // No separate thumbnail from the API; we generate one from the video.
      thumbnailPath: 'assets/images/notification-image4.jpg',
      approved: isApproved,
      videoPath: path.isEmpty ? null : path,
      isLocalVideo: path.startsWith('/') && !path.startsWith('http'),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoItem &&
          runtimeType == other.runtimeType &&
          mediaId == other.mediaId &&
          videoPath == other.videoPath;

  @override
  int get hashCode => mediaId.hashCode ^ videoPath.hashCode;
}

// --- STATE ---
class VideoTabState {
  final bool showApproved;
  final bool isLoading;
  final List<VideoItem> pendingVideos;
  final List<VideoItem> approvedVideos;

  const VideoTabState({
    this.showApproved = false,
    this.isLoading = true,
    this.pendingVideos = const [],
    this.approvedVideos = const [],
  });

  VideoTabState copyWith({
    bool? showApproved,
    bool? isLoading,
    List<VideoItem>? pendingVideos,
    List<VideoItem>? approvedVideos,
  }) {
    return VideoTabState(
      showApproved: showApproved ?? this.showApproved,
      isLoading: isLoading ?? this.isLoading,
      pendingVideos: pendingVideos ?? this.pendingVideos,
      approvedVideos: approvedVideos ?? this.approvedVideos,
    );
  }
}

// --- NOTIFIER ---
class VideoTabNotifier extends Notifier<VideoTabState> {
  static const String _pendingKey = 'profile_videos_pending';
  static const String _approvedKey = 'profile_videos_approved';

  // Kept for Add/Delete operations.
  final ApiServices _api = ApiServices();

  @override
  VideoTabState build() => const VideoTabState();

  void toggleTab(bool showApproved) {
    state = state.copyWith(showApproved: showApproved);
  }

  Future<void> loadVideosFromApi() async {
    state = state.copyWith(isLoading: true);
    await _loadVideosFromPrefs(); // Load cached items first!
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      // Fetch both lists in parallel from the two new endpoints.
      final results = await Future.wait([
        _VideoApi.fetchVideos(
          url: _VideoApi.approvedUrl,
          token: token,
          approved: true,
        ),
        _VideoApi.fetchVideos(
          url: _VideoApi.pendingUrl,
          token: token,
          approved: false,
        ),
      ]);

      final approved = results[0];
      final serverPending = results[1];

      // IMPORTANT: keep locally-added videos that the server has not returned
      // yet (just-uploaded items have an empty mediaId / are local files).
      // Without this, a freshly added video disappears the moment we refetch,
      // because the server's pending list may not include it yet.
      final localOnly = state.pendingVideos.where((v) {
        final notOnServer = v.mediaId.isEmpty || v.isLocalVideo;
        final alreadyInServerList = serverPending.any(
          (s) {
            final sameId = s.mediaId.isNotEmpty && s.mediaId == v.mediaId;
            if (sameId) return true;

            if (s.videoPath != null && v.videoPath != null) {
              final sFile = s.videoPath!.split('/').last;
              final vFile = v.videoPath!.split('/').last;
              if (sFile.isNotEmpty && sFile == vFile) {
                return true;
              }
            }
            return false;
          },
        );
        return notOnServer && !alreadyInServerList;
      }).toList();

      final mergedPending = [...localOnly, ...serverPending];

      debugPrint(
        '[VideoTab] approved=${approved.length} serverPending=${serverPending.length} localOnly=${localOnly.length} -> mergedPending=${mergedPending.length}',
      );

      state = state.copyWith(
        approvedVideos: approved,
        pendingVideos: mergedPending,
        isLoading: false,
      );
      await _persistVideos();
    } catch (e) {
      debugPrint('[VideoTab] loadVideosFromApi error: $e');
      state = state.copyWith(isLoading: false);
      await _loadVideosFromPrefs();
    }
  }

  Future<void> addVideo(XFile picked) async {
    final thumbnail = await VideoThumbnailUtils.generateThumbnail(picked.path);

    state = state.copyWith(
      pendingVideos: [
        VideoItem(
          mediaId: '',
          thumbnailPath: thumbnail ?? 'assets/images/notification-image4.jpg',
          approved: false,
          videoPath: picked.path,
          isLocalVideo: true,
        ),
        ...state.pendingVideos,
      ],
      showApproved: false,
    );

    final token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        debugPrint('[VideoTab] uploading video: ${picked.path}');
        final uploadedPath = await _VideoApi.uploadVideo(
          token: token,
          filePath: picked.path,
        );
        debugPrint('[VideoTab] upload success, full_path=$uploadedPath');
        // Refetch from server. The optimistic local item is preserved by
        // loadVideosFromApi() until the server starts returning it.
        await loadVideosFromApi();
      } catch (e) {
        // Upload failed -> keep the optimistic local item & persist it so the
        // user still sees their video in Pending.
        debugPrint('[VideoTab] upload failed: $e');
        await _persistVideos();
        rethrow; // let the UI show an error snackbar
      }
    } else {
      debugPrint('[VideoTab] no token -> persisting locally only');
      await _persistVideos();
    }
  }

  Future<void> deleteVideo(VideoItem item) async {
    final newApproved = List<VideoItem>.from(state.approvedVideos)
      ..remove(item);
    final newPending = List<VideoItem>.from(state.pendingVideos)..remove(item);

    state = state.copyWith(
      approvedVideos: item.approved ? newApproved : state.approvedVideos,
      pendingVideos: !item.approved ? newPending : state.pendingVideos,
    );

    await _deleteVideoApi(item);
  }

  Future<void> _deleteVideoApi(VideoItem item) async {
    if (item.mediaId.isEmpty) {
      await _persistVideos();
      return;
    }
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) return;
      await _VideoApi.deleteVideo(token: token, mediaId: item.mediaId);
    } catch (_) {
      // keep optimistic UI
    } finally {
      await _persistVideos();
    }
  }

  Future<void> _loadVideosFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingRaw = prefs.getString(_pendingKey);
    final approvedRaw = prefs.getString(_approvedKey);

    List<VideoItem> decode(String? raw) {
      if (raw == null || raw.isEmpty) return [];
      try {
        final decoded = jsonDecode(raw);
        if (decoded is! List) return [];
        return decoded
            .whereType<Map>()
            .map((e) => VideoItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } catch (_) {
        return [];
      }
    }

    final pending = decode(pendingRaw);
    final approved = decode(approvedRaw);
    state = state.copyWith(pendingVideos: pending, approvedVideos: approved);
  }

  Future<void> _persistVideos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _pendingKey,
      jsonEncode(state.pendingVideos.map((e) => e.toJson()).toList()),
    );
    await prefs.setString(
      _approvedKey,
      jsonEncode(state.approvedVideos.map((e) => e.toJson()).toList()),
    );
  }
}

// --- PROVIDER ---
final videoTabProvider = NotifierProvider<VideoTabNotifier, VideoTabState>(
  VideoTabNotifier.new,
);

// --- WIDGET ---
class MyProfileVideoTab extends ConsumerStatefulWidget {
  const MyProfileVideoTab({super.key});

  @override
  ConsumerState<MyProfileVideoTab> createState() => _MyProfileVideoTabState();
}

class _MyProfileVideoTabState extends ConsumerState<MyProfileVideoTab> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoTabProvider.notifier).loadVideosFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(videoTabProvider);
    final notifier = ref.read(videoTabProvider.notifier);
    final list = state.showApproved
        ? state.approvedVideos
        : state.pendingVideos;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 380;
    final title = state.showApproved ? 'Approved Videos' : 'Pending Approval';

    return RefreshIndicator(
      onRefresh: () => notifier.loadVideosFromApi(),
      color: Colors.pink,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statusTabs(state, notifier),
            const SizedBox(height: 12),
            if (state.showApproved) _infoStrip(),
            if (state.showApproved) const SizedBox(height: 16),
            if (state.showApproved)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isCompact ? 24 : 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addVideo,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Video'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF220027),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(
                title,
                style: TextStyle(
                  fontSize: isCompact ? 24 : 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(height: 14),
            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (list.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    state.showApproved
                        ? 'No approved videos.'
                        : 'No pending videos.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: list
                    .map((item) => _videoCard(item, isCompact ? width - 64 : 240))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statusTabs(VideoTabState state, VideoTabNotifier notifier) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF19001F), Color(0xFF490040)],
        ),
      ),
      child: Row(
        children: [
          _pillTab(
            label: 'Approved',
            selected: state.showApproved,
            onTap: () => notifier.toggleTab(true),
          ),
          const Spacer(),
          _pillTab(
            label: 'Pending',
            selected: !state.showApproved,
            onTap: () => notifier.toggleTab(false),
          ),
        ],
      ),
    );
  }

  Widget _pillTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _infoStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2D1935)),
      ),
      child: const Row(
        children: [
          Icon(Icons.movie_outlined, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Maximum video size is 10MB. Formats supported: avi, wmv, mov, mp4.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoCard(VideoItem item, double width) {
    return InkWell(
      onTap: () => _openVideoPlayer(item),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E0F2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: _buildThumbnail(item),
                ),
                Positioned.fill(
                  child: Center(
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: item.approved
                          ? const Color(0xFF20B35D)
                          : const Color(0xFFF7D12D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.approved ? 'APPROVED' : 'PENDING',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFFFF4473),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 14,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          ref.read(videoTabProvider.notifier).deleteVideo(item),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    item.approved
                        ? Icons.check_circle_outline
                        : Icons.access_time,
                    size: 14,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.approved ? 'Approved' : 'Awaiting Approval',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the thumbnail for a card.
  ///
  /// - Local video file  -> generate a thumbnail from the file.
  /// - Remote video URL  -> generate a thumbnail from the network video.
  /// - http(s) image      -> Image.network.
  /// - asset fallback     -> Image.asset.
  Widget _buildThumbnail(VideoItem item) {
    const double h = 160;

    Widget placeholder() => Container(
      height: h,
      width: double.infinity,
      color: const Color(0xFFF2ECF7),
      child: const Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 56,
          color: Color(0xFF4A3B57),
        ),
      ),
    );

    Widget loading() => Container(
      height: h,
      width: double.infinity,
      color: const Color(0xFFF2ECF7),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );

    final videoPath = item.videoPath ?? '';
    final bool isVideoSource =
        videoPath.isNotEmpty &&
        (item.isLocalVideo ||
            videoPath.startsWith('http') ||
            videoPath.startsWith('https'));

    // Generate a thumbnail directly from the video (local or remote).
    if (isVideoSource) {
      return FutureBuilder<String?>(
        future: VideoThumbnailUtils.generateThumbnail(videoPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          }
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(
              File(snapshot.data!),
              height: h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder(),
            );
          }
          return placeholder();
        },
      );
    }

    // Fallback to thumbnailPath (image url or asset).
    if (item.thumbnailPath.startsWith('http')) {
      return Image.network(
        item.thumbnailPath,
        height: h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: h,
          width: double.infinity,
          color: const Color(0xFFF2ECF7),
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    return Image.asset(
      item.thumbnailPath,
      height: h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder(),
    );
  }

  Future<void> _addVideo() async {
    try {
      final source = await _chooseVideoSource();
      if (source == null) return;

      final picked = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );
      if (picked == null) return;

      await ref.read(videoTabProvider.notifier).addVideo(picked);

      if (!mounted) return;
      Get.snackbar(
        'Success',
        'Video added to pending approval',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
        colorText: Colors.black,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (_) {
      if (!mounted) return;
      Get.snackbar(
        'Error',
        'Unable to upload video. Please check your connection and try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
        colorText: Colors.black,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<ImageSource?> _chooseVideoSource() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: const Text('Record Video'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openVideoPlayer(VideoItem item) {
    if (item.videoPath == null || item.videoPath!.isEmpty) {
      Get.snackbar(
        'Error',
        'Playable video not available for this item.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
        colorText: Colors.black,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _VideoPlayerPage(videoPath: item.videoPath!),
      ),
    );
  }
}

class _VideoPlayerPage extends StatefulWidget {
  const _VideoPlayerPage({required this.videoPath});

  final String videoPath;

  @override
  State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<_VideoPlayerPage> {
  VideoPlayerController? _controller;
  String? _initError;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final String path = widget.videoPath;
      final VideoPlayerController controller;

      if (path.startsWith('http') || path.startsWith('https')) {
        controller = VideoPlayerController.networkUrl(Uri.parse(path));
      } else {
        final file = File(path);
        if (!await file.exists()) {
          throw Exception("The video file no longer exists on this device.");
        }
        controller = VideoPlayerController.file(file);
      }

      _controller = controller;
      await controller.initialize();
      if (!mounted) return;
      await controller.play();
      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _initError = e.toString().contains('Exception:')
            ? e.toString().split('Exception:').last
            : e.toString();
        _isInitializing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Video player initialization failed. Please restart the app fully and try again.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Video Preview')),
      backgroundColor: Colors.black,
      body: Center(
        child: _isInitializing
            ? const CircularProgressIndicator()
            : _initError != null
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not play this video.\n\n$_initError',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              )
            : c == null || !c.value.isInitialized
            ? const Text(
                'Video is unavailable.',
                style: TextStyle(color: Colors.white70),
              )
            : GestureDetector(
                onTap: () {
                  if (c.value.isPlaying) {
                    c.pause();
                  } else {
                    c.play();
                  }
                  setState(() {});
                },
                child: AspectRatio(
                  aspectRatio: c.value.aspectRatio,
                  child: VideoPlayer(c),
                ),
              ),
      ),
      floatingActionButton: c == null || !c.value.isInitialized
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (c.value.isPlaying) {
                  c.pause();
                } else {
                  c.play();
                }
                setState(() {});
              },
              child: Icon(c.value.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
    );
  }
}


// import 'dart:convert';
// import 'dart:io';

// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';
// import 'package:beatflirt/core/utils/video_thumbnail_utils.dart';
// import 'package:get/get.dart';

// // --- API CONFIG ---
// class _VideoApi {
//   static const String _base = 'https://app.beatflirtevent.com/App/user';
//   static const String approvedUrl = '$_base/signle_user_profile_approve_video';
//   static const String pendingUrl = '$_base/signle_user_profile_pending_video';

//   /// Fetches a video list from [url]. Returns parsed [VideoItem]s.
//   ///
//   /// Handles the two documented response shapes:
//   ///   - {"status":"200","data":[ {id, profile_video, status}, ... ]}
//   ///   - {"status":"404","data":""}  (empty)
//   ///
//   /// [approved] decides which list these items belong to, since the endpoint
//   /// itself determines approval state.
//   static Future<List<VideoItem>> fetchVideos({
//     required String url,
//     required String token,
//     required bool approved,
//   }) async {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       },
//     );

//     // ---- DEBUG: see exactly what the server returns ----
//     debugPrint('[VideoApi] GET $url');
//     debugPrint('[VideoApi] status=${response.statusCode}');
//     debugPrint('[VideoApi] body=${response.body}');
//     // ----------------------------------------------------

//     if (response.statusCode != 200) {
//       throw Exception('Request failed: ${response.statusCode}');
//     }

//     final body = response.body.trim();
//     if (body.isEmpty) return [];

//     final decoded = jsonDecode(body);
//     if (decoded is! Map) return [];

//     final status = (decoded['status'] ?? '').toString();
//     if (status != '200') return []; // 404 / empty etc.

//     final data = decoded['data'];
//     if (data is! List) return []; // empty data comes back as "" (a String)

//     final items = data
//         .whereType<Map>()
//         .map((e) => VideoItem.fromApi(
//               Map<String, dynamic>.from(e),
//               approved: approved,
//             ))
//         .toList();

//     debugPrint('[VideoApi] parsed ${items.length} item(s) from $url');
//     return items;
//   }
// }

// // --- MODEL ---
// class VideoItem {
//   const VideoItem({
//     required this.mediaId,
//     required this.thumbnailPath,
//     required this.approved,
//     this.videoPath,
//     this.isLocalVideo = false,
//   });

//   final String mediaId;
//   final String thumbnailPath;
//   final bool approved;
//   final String? videoPath;
//   final bool isLocalVideo;

//   Map<String, dynamic> toJson() {
//     return {
//       'mediaId': mediaId,
//       'thumbnailPath': thumbnailPath,
//       'approved': approved,
//       'videoPath': videoPath,
//       'isLocalVideo': isLocalVideo,
//     };
//   }

//   factory VideoItem.fromJson(Map<String, dynamic> json) {
//     return VideoItem(
//       mediaId: (json['mediaId'] ?? '').toString(),
//       thumbnailPath: (json['thumbnailPath'] ??
//               'assets/images/notification-image4.jpg')
//           .toString(),
//       approved: json['approved'] == true,
//       videoPath: json['videoPath']?.toString(),
//       isLocalVideo: json['isLocalVideo'] == true,
//     );
//   }

//   /// Maps the new API shape:
//   /// {
//   ///   "id": "1",
//   ///   "profile_video": "https://.../video.mp4",
//   ///   "status": "0"   // "0" = pending, "1" = approved
//   /// }
//   ///
//   /// [approved] is supplied by the calling endpoint (approved vs pending),
//   /// but we also fall back to the per-item `status` field if present.
//   factory VideoItem.fromApi(
//     Map<String, dynamic> json, {
//     required bool approved,
//   }) {
//     final path = (json['profile_video'] ?? '').toString();
//     final statusStr = (json['status'] ?? '').toString();

//     // Prefer the endpoint's intent, but honor an explicit status when given.
//     bool isApproved = approved;
//     if (statusStr == '1') {
//       isApproved = true;
//     } else if (statusStr == '0') {
//       isApproved = false;
//     }

//     return VideoItem(
//       mediaId: (json['id'] ?? '').toString(),
//       // No separate thumbnail from the API; we generate one from the video.
//       thumbnailPath: 'assets/images/notification-image4.jpg',
//       approved: isApproved,
//       videoPath: path.isEmpty ? null : path,
//       isLocalVideo: path.startsWith('/'),
//     );
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is VideoItem &&
//           runtimeType == other.runtimeType &&
//           mediaId == other.mediaId &&
//           videoPath == other.videoPath;

//   @override
//   int get hashCode => mediaId.hashCode ^ videoPath.hashCode;
// }

// // --- STATE ---
// class VideoTabState {
//   final bool showApproved;
//   final bool isLoading;
//   final List<VideoItem> pendingVideos;
//   final List<VideoItem> approvedVideos;

//   const VideoTabState({
//     this.showApproved = false,
//     this.isLoading = true,
//     this.pendingVideos = const [],
//     this.approvedVideos = const [],
//   });

//   VideoTabState copyWith({
//     bool? showApproved,
//     bool? isLoading,
//     List<VideoItem>? pendingVideos,
//     List<VideoItem>? approvedVideos,
//   }) {
//     return VideoTabState(
//       showApproved: showApproved ?? this.showApproved,
//       isLoading: isLoading ?? this.isLoading,
//       pendingVideos: pendingVideos ?? this.pendingVideos,
//       approvedVideos: approvedVideos ?? this.approvedVideos,
//     );
//   }
// }

// // --- NOTIFIER ---
// class VideoTabNotifier extends Notifier<VideoTabState> {
//   static const String _pendingKey = 'profile_videos_pending';
//   static const String _approvedKey = 'profile_videos_approved';

//   // Kept for Add/Delete operations.
//   final ApiServices _api = ApiServices();

//   @override
//   VideoTabState build() => const VideoTabState();

//   void toggleTab(bool showApproved) {
//     state = state.copyWith(showApproved: showApproved);
//   }

//   Future<void> loadVideosFromApi() async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) {
//         state = state.copyWith(isLoading: false);
//         return;
//       }

//       // Fetch both lists in parallel from the two new endpoints.
//       final results = await Future.wait([
//         _VideoApi.fetchVideos(
//           url: _VideoApi.approvedUrl,
//           token: token,
//           approved: true,
//         ),
//         _VideoApi.fetchVideos(
//           url: _VideoApi.pendingUrl,
//           token: token,
//           approved: false,
//         ),
//       ]);

//       final approved = results[0];
//       final serverPending = results[1];

//       // IMPORTANT: keep locally-added videos that the server has not returned
//       // yet (just-uploaded items have an empty mediaId / are local files).
//       // Without this, a freshly added video disappears the moment we refetch,
//       // because the server's pending list may not include it yet.
//       final localOnly = state.pendingVideos.where((v) {
//         final notOnServer = v.mediaId.isEmpty || v.isLocalVideo;
//         final alreadyInServerList = serverPending.any((s) =>
//             (s.mediaId.isNotEmpty && s.mediaId == v.mediaId) ||
//             (s.videoPath != null && s.videoPath == v.videoPath));
//         return notOnServer && !alreadyInServerList;
//       }).toList();

//       final mergedPending = [...localOnly, ...serverPending];

//       debugPrint(
//           '[VideoTab] approved=${approved.length} serverPending=${serverPending.length} localOnly=${localOnly.length} -> mergedPending=${mergedPending.length}');

//       state = state.copyWith(
//         approvedVideos: approved,
//         pendingVideos: mergedPending,
//         isLoading: false,
//       );
//       await _persistVideos();
//     } catch (e) {
//       debugPrint('[VideoTab] loadVideosFromApi error: $e');
//       state = state.copyWith(isLoading: false);
//       await _loadVideosFromPrefs();
//     }
//   }

//   Future<void> addVideo(XFile picked) async {
//     final thumbnail =
//         await VideoThumbnailUtils.generateThumbnail(picked.path);

//     state = state.copyWith(
//       pendingVideos: [
//         VideoItem(
//           mediaId: '',
//           thumbnailPath:
//               thumbnail ?? 'assets/images/notification-image4.jpg',
//           approved: false,
//           videoPath: picked.path,
//           isLocalVideo: true,
//         ),
//         ...state.pendingVideos,
//       ],
//       showApproved: false,
//     );

//     final token = await AuthService.getToken();
//     if (token != null && token.isNotEmpty) {
//       try {
//         debugPrint('[VideoTab] uploading video: ${picked.path}');
//         final uploadResult = await _api.addVideo(
//           token: token,
//           path: picked.path,
//           thumbnailPath:
//               thumbnail ?? 'assets/images/notification-image4.jpg',
//         );
//         debugPrint('[VideoTab] addVideo result: $uploadResult');
//         // Refetch from server. The optimistic local item is preserved by
//         // loadVideosFromApi() until the server starts returning it.
//         await loadVideosFromApi();
//       } catch (e) {
//         // Upload failed -> keep the optimistic local item & persist it so the
//         // user still sees their video in Pending.
//         debugPrint('[VideoTab] addVideo failed: $e');
//         await _persistVideos();
//       }
//     } else {
//       debugPrint('[VideoTab] no token -> persisting locally only');
//       await _persistVideos();
//     }
//   }

//   Future<void> deleteVideo(VideoItem item) async {
//     final newApproved = List<VideoItem>.from(state.approvedVideos)
//       ..remove(item);
//     final newPending = List<VideoItem>.from(state.pendingVideos)
//       ..remove(item);

//     state = state.copyWith(
//       approvedVideos: item.approved ? newApproved : state.approvedVideos,
//       pendingVideos: !item.approved ? newPending : state.pendingVideos,
//     );

//     await _deleteVideoApi(item);
//   }

//   Future<void> _deleteVideoApi(VideoItem item) async {
//     if (item.mediaId.isEmpty) {
//       await _persistVideos();
//       return;
//     }
//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) return;
//       await _api.deleteVideo(token: token, mediaId: item.mediaId);
//     } catch (_) {
//       // keep optimistic UI
//     } finally {
//       await _persistVideos();
//     }
//   }

//   Future<void> _loadVideosFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final pendingRaw = prefs.getString(_pendingKey);
//     final approvedRaw = prefs.getString(_approvedKey);

//     List<VideoItem> decode(String? raw) {
//       if (raw == null || raw.isEmpty) return [];
//       try {
//         final decoded = jsonDecode(raw);
//         if (decoded is! List) return [];
//         return decoded
//             .whereType<Map>()
//             .map((e) => VideoItem.fromJson(Map<String, dynamic>.from(e)))
//             .toList();
//       } catch (_) {
//         return [];
//       }
//     }

//     final pending = decode(pendingRaw);
//     final approved = decode(approvedRaw);
//     state = state.copyWith(
//       pendingVideos: pending,
//       approvedVideos: approved,
//     );
//   }

//   Future<void> _persistVideos() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(
//       _pendingKey,
//       jsonEncode(state.pendingVideos.map((e) => e.toJson()).toList()),
//     );
//     await prefs.setString(
//       _approvedKey,
//       jsonEncode(state.approvedVideos.map((e) => e.toJson()).toList()),
//     );
//   }
// }

// // --- PROVIDER ---
// final videoTabProvider =
//     NotifierProvider<VideoTabNotifier, VideoTabState>(
//   VideoTabNotifier.new,
// );

// // --- WIDGET ---
// class MyProfileVideoTab extends ConsumerStatefulWidget {
//   const MyProfileVideoTab({super.key});

//   @override
//   ConsumerState<MyProfileVideoTab> createState() =>
//       _MyProfileVideoTabState();
// }

// class _MyProfileVideoTabState extends ConsumerState<MyProfileVideoTab> {
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(videoTabProvider.notifier).loadVideosFromApi();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(videoTabProvider);
//     final notifier = ref.read(videoTabProvider.notifier);
//     final list =
//         state.showApproved ? state.approvedVideos : state.pendingVideos;
//     final width = MediaQuery.of(context).size.width;
//     final isCompact = width < 380;
//     final title = state.showApproved ? 'Approved Videos' : 'Pending Approval';

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _statusTabs(state, notifier),
//         const SizedBox(height: 12),
//         if (state.showApproved) _infoStrip(),
//         if (state.showApproved) const SizedBox(height: 16),
//         if (state.showApproved)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             crossAxisAlignment: WrapCrossAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: isCompact ? 24 : 28,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed: _addVideo,
//                 icon: const Icon(Icons.add, size: 16),
//                 label: const Text('Add Video'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF220027),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 10),
//                 ),
//               ),
//             ],
//           )
//         else
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: isCompact ? 24 : 28,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         const SizedBox(height: 14),
//         if (state.isLoading)
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.only(top: 24),
//               child: CircularProgressIndicator(),
//             ),
//           )
//         else if (list.isEmpty)
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 24),
//               child: Text(
//                 state.showApproved
//                     ? 'No approved videos.'
//                     : 'No pending videos.',
//                 style: TextStyle(color: Colors.grey[700], fontSize: 16),
//               ),
//             ),
//           )
//         else
//           Wrap(
//             spacing: 14,
//             runSpacing: 14,
//             children: list
//                 .map((item) =>
//                     _videoCard(item, isCompact ? width - 64 : 240))
//                 .toList(),
//           ),
//       ],
//     );
//   }

//   Widget _statusTabs(VideoTabState state, VideoTabNotifier notifier) {
//     return Container(
//       height: 40,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(22),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF19001F), Color(0xFF490040)],
//         ),
//       ),
//       child: Row(
//         children: [
//           _pillTab(
//             label: 'Approved',
//             selected: state.showApproved,
//             onTap: () => notifier.toggleTab(true),
//           ),
//           const Spacer(),
//           _pillTab(
//             label: 'Pending',
//             selected: !state.showApproved,
//             onTap: () => notifier.toggleTab(false),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _pillTab({
//     required String label,
//     required bool selected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//         decoration: BoxDecoration(
//           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 11,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _infoStrip() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(4),
//         border: Border.all(color: const Color(0xFF2D1935)),
//       ),
//       child: const Row(
//         children: [
//           Icon(Icons.movie_outlined, size: 16),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               'Maximum video size is 10MB. Formats supported: avi, wmv, mov, mp4.',
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _videoCard(VideoItem item, double width) {
//     return InkWell(
//       onTap: () => _openVideoPlayer(item),
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         width: width,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: const Color(0xFFE8E0F2)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(14)),
//                   child: _buildThumbnail(item),
//                 ),
//                 Positioned.fill(
//                   child: Center(
//                     child: CircleAvatar(
//                       radius: 18,
//                       backgroundColor:
//                           Colors.black.withValues(alpha: 0.5),
//                       child: const Icon(Icons.play_arrow,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: 8,
//                   top: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8, vertical: 3),
//                     decoration: BoxDecoration(
//                       color: item.approved
//                           ? const Color(0xFF20B35D)
//                           : const Color(0xFFF7D12D),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       item.approved ? 'APPROVED' : 'PENDING',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   right: 8,
//                   top: 8,
//                   child: CircleAvatar(
//                     radius: 12,
//                     backgroundColor: const Color(0xFFFF4473),
//                     child: IconButton(
//                       icon: const Icon(Icons.delete_outline,
//                           size: 14, color: Colors.white),
//                       onPressed: () => ref
//                           .read(videoTabProvider.notifier)
//                           .deleteVideo(item),
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 10, vertical: 10),
//               child: Row(
//                 children: [
//                   Icon(
//                     item.approved
//                         ? Icons.check_circle_outline
//                         : Icons.access_time,
//                     size: 14,
//                     color: Colors.black54,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     item.approved ? 'Approved' : 'Awaiting Approval',
//                     style: const TextStyle(
//                         fontSize: 12, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Builds the thumbnail for a card.
//   ///
//   /// - Local video file  -> generate a thumbnail from the file.
//   /// - Remote video URL  -> generate a thumbnail from the network video.
//   /// - http(s) image      -> Image.network.
//   /// - asset fallback     -> Image.asset.
//   Widget _buildThumbnail(VideoItem item) {
//     const double h = 160;

//     Widget placeholder() => Container(
//           height: h,
//           width: double.infinity,
//           color: const Color(0xFFF2ECF7),
//           child: const Center(
//             child: Icon(Icons.play_circle_outline,
//                 size: 56, color: Color(0xFF4A3B57)),
//           ),
//         );

//     Widget loading() => Container(
//           height: h,
//           width: double.infinity,
//           color: const Color(0xFFF2ECF7),
//           child: const Center(
//               child: CircularProgressIndicator(strokeWidth: 2)),
//         );

//     final videoPath = item.videoPath ?? '';
//     final bool isVideoSource = videoPath.isNotEmpty &&
//         (item.isLocalVideo ||
//             videoPath.startsWith('http') ||
//             videoPath.startsWith('https'));

//     // Generate a thumbnail directly from the video (local or remote).
//     if (isVideoSource) {
//       return FutureBuilder<String?>(
//         future: VideoThumbnailUtils.generateThumbnail(videoPath),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return loading();
//           }
//           if (snapshot.hasData && snapshot.data != null) {
//             return Image.file(
//               File(snapshot.data!),
//               height: h,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => placeholder(),
//             );
//           }
//           return placeholder();
//         },
//       );
//     }

//     // Fallback to thumbnailPath (image url or asset).
//     if (item.thumbnailPath.startsWith('http')) {
//       return Image.network(
//         item.thumbnailPath,
//         height: h,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => Container(
//           height: h,
//           width: double.infinity,
//           color: const Color(0xFFF2ECF7),
//           child: const Icon(Icons.broken_image, color: Colors.grey),
//         ),
//       );
//     }

//     return Image.asset(
//       item.thumbnailPath,
//       height: h,
//       width: double.infinity,
//       fit: BoxFit.cover,
//       errorBuilder: (_, __, ___) => placeholder(),
//     );
//   }

//   Future<void> _addVideo() async {
//     try {
//       final source = await _chooseVideoSource();
//       if (source == null) return;

//       final picked = await _picker.pickVideo(
//         source: source,
//         maxDuration: const Duration(minutes: 5),
//       );
//       if (picked == null) return;

//       await ref.read(videoTabProvider.notifier).addVideo(picked);

//       if (!mounted) return;
//       Get.snackbar(
//         'Success',
//         'Video added to pending approval',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.transparent,
//         colorText: Colors.black,
//         borderRadius: 12,
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       );
//     } catch (_) {
//       if (!mounted) return;
//       Get.snackbar(
//         'Error',
//         'Unable to pick video. Please restart app once and try again.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.transparent,
//         colorText: Colors.black,
//         borderRadius: 12,
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       );
//     }
//   }

//   Future<ImageSource?> _chooseVideoSource() async {
//     return showModalBottomSheet<ImageSource>(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.video_library_outlined),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () =>
//                     Navigator.pop(context, ImageSource.gallery),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.videocam_outlined),
//                 title: const Text('Record Video'),
//                 onTap: () =>
//                     Navigator.pop(context, ImageSource.camera),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _openVideoPlayer(VideoItem item) {
//     if (item.videoPath == null || item.videoPath!.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Playable video not available for this item.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.transparent,
//         colorText: Colors.black,
//         borderRadius: 12,
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       );
//       return;
//     }
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => _VideoPlayerPage(videoPath: item.videoPath!),
//       ),
//     );
//   }
// }

// class _VideoPlayerPage extends StatefulWidget {
//   const _VideoPlayerPage({required this.videoPath});

//   final String videoPath;

//   @override
//   State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
// }

// class _VideoPlayerPageState extends State<_VideoPlayerPage> {
//   VideoPlayerController? _controller;
//   String? _initError;
//   bool _isInitializing = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }

//   Future<void> _initializePlayer() async {
//     try {
//       final String path = widget.videoPath;
//       final VideoPlayerController controller;

//       if (path.startsWith('http') || path.startsWith('https')) {
//         controller = VideoPlayerController.networkUrl(Uri.parse(path));
//       } else {
//         final file = File(path);
//         if (!await file.exists()) {
//           throw Exception("The video file no longer exists on this device.");
//         }
//         controller = VideoPlayerController.file(file);
//       }

//       _controller = controller;
//       await controller.initialize();
//       if (!mounted) return;
//       await controller.play();
//       setState(() {
//         _isInitializing = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _initError = e.toString().contains('Exception:')
//             ? e.toString().split('Exception:').last
//             : e.toString();
//         _isInitializing = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//               'Video player initialization failed. Please restart the app fully and try again.'),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final c = _controller;
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Preview')),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: _isInitializing
//             ? const CircularProgressIndicator()
//             : _initError != null
//                 ? Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Text(
//                       'Could not play this video.\n\n$_initError',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(color: Colors.white70),
//                     ),
//                   )
//                 : c == null || !c.value.isInitialized
//                     ? const Text(
//                         'Video is unavailable.',
//                         style: TextStyle(color: Colors.white70),
//                       )
//                     : GestureDetector(
//                         onTap: () {
//                           if (c.value.isPlaying) {
//                             c.pause();
//                           } else {
//                             c.play();
//                           }
//                           setState(() {});
//                         },
//                         child: AspectRatio(
//                           aspectRatio: c.value.aspectRatio,
//                           child: VideoPlayer(c),
//                         ),
//                       ),
//       ),
//       floatingActionButton: c == null || !c.value.isInitialized
//           ? null
//           : FloatingActionButton(
//               onPressed: () {
//                 if (c.value.isPlaying) {
//                   c.pause();
//                 } else {
//                   c.play();
//                 }
//                 setState(() {});
//               },
//               child: Icon(
//                   c.value.isPlaying ? Icons.pause : Icons.play_arrow),
//             ),
//     );
//   }
// }


// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:beatflirt/Api_services/api_services.dart';
// // import 'package:beatflirt/core/services/auth_services.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:image_picker/image_picker.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:video_player/video_player.dart';
// // import 'package:beatflirt/core/utils/video_thumbnail_utils.dart';
// // import 'package:get/get.dart';

// // // --- API CONFIG ---
// // class _VideoApi {
// //   static const String _base = 'https://app.beatflirtevent.com/App/user';
// //   static const String approvedUrl = '$_base/signle_user_profile_approve_video';
// //   static const String pendingUrl = '$_base/signle_user_profile_pending_video';

// //   /// Fetches a video list from [url]. Returns parsed [VideoItem]s.
// //   ///
// //   /// Handles the two documented response shapes:
// //   ///   - {"status":"200","data":[ {id, profile_video, status}, ... ]}
// //   ///   - {"status":"404","data":""}  (empty)
// //   ///
// //   /// [approved] decides which list these items belong to, since the endpoint
// //   /// itself determines approval state.
// //   static Future<List<VideoItem>> fetchVideos({
// //     required String url,
// //     required String token,
// //     required bool approved,
// //   }) async {
// //     final response = await http.get(
// //       Uri.parse(url),
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Accept': 'application/json',
// //       },
// //     );

// //     if (response.statusCode != 200) {
// //       throw Exception('Request failed: ${response.statusCode}');
// //     }

// //     final body = response.body.trim();
// //     if (body.isEmpty) return [];

// //     final decoded = jsonDecode(body);
// //     if (decoded is! Map) return [];

// //     final status = (decoded['status'] ?? '').toString();
// //     if (status != '200') return []; // 404 / empty etc.

// //     final data = decoded['data'];
// //     if (data is! List) return []; // empty data comes back as "" (a String)

// //     return data
// //         .whereType<Map>()
// //         .map((e) => VideoItem.fromApi(
// //               Map<String, dynamic>.from(e),
// //               approved: approved,
// //             ))
// //         .toList();
// //   }
// // }

// // // --- MODEL ---
// // class VideoItem {
// //   const VideoItem({
// //     required this.mediaId,
// //     required this.thumbnailPath,
// //     required this.approved,
// //     this.videoPath,
// //     this.isLocalVideo = false,
// //   });

// //   final String mediaId;
// //   final String thumbnailPath;
// //   final bool approved;
// //   final String? videoPath;
// //   final bool isLocalVideo;

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'mediaId': mediaId,
// //       'thumbnailPath': thumbnailPath,
// //       'approved': approved,
// //       'videoPath': videoPath,
// //       'isLocalVideo': isLocalVideo,
// //     };
// //   }

// //   factory VideoItem.fromJson(Map<String, dynamic> json) {
// //     return VideoItem(
// //       mediaId: (json['mediaId'] ?? '').toString(),
// //       thumbnailPath: (json['thumbnailPath'] ??
// //               'assets/images/notification-image4.jpg')
// //           .toString(),
// //       approved: json['approved'] == true,
// //       videoPath: json['videoPath']?.toString(),
// //       isLocalVideo: json['isLocalVideo'] == true,
// //     );
// //   }

// //   /// Maps the new API shape:
// //   /// {
// //   ///   "id": "1",
// //   ///   "profile_video": "https://.../video.mp4",
// //   ///   "status": "0"   // "0" = pending, "1" = approved
// //   /// }
// //   ///
// //   /// [approved] is supplied by the calling endpoint (approved vs pending),
// //   /// but we also fall back to the per-item `status` field if present.
// //   factory VideoItem.fromApi(
// //     Map<String, dynamic> json, {
// //     required bool approved,
// //   }) {
// //     final path = (json['profile_video'] ?? '').toString();
// //     final statusStr = (json['status'] ?? '').toString();

// //     // Prefer the endpoint's intent, but honor an explicit status when given.
// //     bool isApproved = approved;
// //     if (statusStr == '1') {
// //       isApproved = true;
// //     } else if (statusStr == '0') {
// //       isApproved = false;
// //     }

// //     return VideoItem(
// //       mediaId: (json['id'] ?? '').toString(),
// //       // No separate thumbnail from the API; we generate one from the video.
// //       thumbnailPath: 'assets/images/notification-image4.jpg',
// //       approved: isApproved,
// //       videoPath: path.isEmpty ? null : path,
// //       isLocalVideo: path.startsWith('/'),
// //     );
// //   }

// //   @override
// //   bool operator ==(Object other) =>
// //       identical(this, other) ||
// //       other is VideoItem &&
// //           runtimeType == other.runtimeType &&
// //           mediaId == other.mediaId &&
// //           videoPath == other.videoPath;

// //   @override
// //   int get hashCode => mediaId.hashCode ^ videoPath.hashCode;
// // }

// // // --- STATE ---
// // class VideoTabState {
// //   final bool showApproved;
// //   final bool isLoading;
// //   final List<VideoItem> pendingVideos;
// //   final List<VideoItem> approvedVideos;

// //   const VideoTabState({
// //     this.showApproved = false,
// //     this.isLoading = true,
// //     this.pendingVideos = const [],
// //     this.approvedVideos = const [],
// //   });

// //   VideoTabState copyWith({
// //     bool? showApproved,
// //     bool? isLoading,
// //     List<VideoItem>? pendingVideos,
// //     List<VideoItem>? approvedVideos,
// //   }) {
// //     return VideoTabState(
// //       showApproved: showApproved ?? this.showApproved,
// //       isLoading: isLoading ?? this.isLoading,
// //       pendingVideos: pendingVideos ?? this.pendingVideos,
// //       approvedVideos: approvedVideos ?? this.approvedVideos,
// //     );
// //   }
// // }

// // // --- NOTIFIER ---
// // class VideoTabNotifier extends Notifier<VideoTabState> {
// //   static const String _pendingKey = 'profile_videos_pending';
// //   static const String _approvedKey = 'profile_videos_approved';

// //   // Kept for Add/Delete operations.
// //   final ApiServices _api = ApiServices();

// //   @override
// //   VideoTabState build() => const VideoTabState();

// //   void toggleTab(bool showApproved) {
// //     state = state.copyWith(showApproved: showApproved);
// //   }

// //   Future<void> loadVideosFromApi() async {
// //     state = state.copyWith(isLoading: true);
// //     try {
// //       final token = await AuthService.getToken();
// //       if (token == null || token.isEmpty) {
// //         state = state.copyWith(isLoading: false);
// //         return;
// //       }

// //       // Fetch both lists in parallel from the two new endpoints.
// //       final results = await Future.wait([
// //         _VideoApi.fetchVideos(
// //           url: _VideoApi.approvedUrl,
// //           token: token,
// //           approved: true,
// //         ),
// //         _VideoApi.fetchVideos(
// //           url: _VideoApi.pendingUrl,
// //           token: token,
// //           approved: false,
// //         ),
// //       ]);

// //       final approved = results[0];
// //       final pending = results[1];

// //       state = state.copyWith(
// //         approvedVideos: approved,
// //         pendingVideos: pending,
// //         isLoading: false,
// //       );
// //     } catch (_) {
// //       state = state.copyWith(isLoading: false);
// //       await _loadVideosFromPrefs();
// //     }
// //   }

// //   Future<void> addVideo(XFile picked) async {
// //     final thumbnail =
// //         await VideoThumbnailUtils.generateThumbnail(picked.path);

// //     state = state.copyWith(
// //       pendingVideos: [
// //         VideoItem(
// //           mediaId: '',
// //           thumbnailPath:
// //               thumbnail ?? 'assets/images/notification-image4.jpg',
// //           approved: false,
// //           videoPath: picked.path,
// //           isLocalVideo: true,
// //         ),
// //         ...state.pendingVideos,
// //       ],
// //       showApproved: false,
// //     );

// //     final token = await AuthService.getToken();
// //     if (token != null && token.isNotEmpty) {
// //       try {
// //         await _api.addVideo(
// //           token: token,
// //           path: picked.path,
// //           thumbnailPath:
// //               thumbnail ?? 'assets/images/notification-image4.jpg',
// //         );
// //         await loadVideosFromApi();
// //       } catch (_) {
// //         await _persistVideos();
// //       }
// //     } else {
// //       await _persistVideos();
// //     }
// //   }

// //   Future<void> deleteVideo(VideoItem item) async {
// //     final newApproved = List<VideoItem>.from(state.approvedVideos)
// //       ..remove(item);
// //     final newPending = List<VideoItem>.from(state.pendingVideos)
// //       ..remove(item);

// //     state = state.copyWith(
// //       approvedVideos: item.approved ? newApproved : state.approvedVideos,
// //       pendingVideos: !item.approved ? newPending : state.pendingVideos,
// //     );

// //     await _deleteVideoApi(item);
// //   }

// //   Future<void> _deleteVideoApi(VideoItem item) async {
// //     if (item.mediaId.isEmpty) {
// //       await _persistVideos();
// //       return;
// //     }
// //     try {
// //       final token = await AuthService.getToken();
// //       if (token == null || token.isEmpty) return;
// //       await _api.deleteVideo(token: token, mediaId: item.mediaId);
// //     } catch (_) {
// //       // keep optimistic UI
// //     } finally {
// //       await _persistVideos();
// //     }
// //   }

// //   Future<void> _loadVideosFromPrefs() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final pendingRaw = prefs.getString(_pendingKey);
// //     final approvedRaw = prefs.getString(_approvedKey);

// //     List<VideoItem> decode(String? raw) {
// //       if (raw == null || raw.isEmpty) return [];
// //       try {
// //         final decoded = jsonDecode(raw);
// //         if (decoded is! List) return [];
// //         return decoded
// //             .whereType<Map>()
// //             .map((e) => VideoItem.fromJson(Map<String, dynamic>.from(e)))
// //             .toList();
// //       } catch (_) {
// //         return [];
// //       }
// //     }

// //     final pending = decode(pendingRaw);
// //     final approved = decode(approvedRaw);
// //     state = state.copyWith(
// //       pendingVideos: pending,
// //       approvedVideos: approved,
// //     );
// //   }

// //   Future<void> _persistVideos() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString(
// //       _pendingKey,
// //       jsonEncode(state.pendingVideos.map((e) => e.toJson()).toList()),
// //     );
// //     await prefs.setString(
// //       _approvedKey,
// //       jsonEncode(state.approvedVideos.map((e) => e.toJson()).toList()),
// //     );
// //   }
// // }

// // // --- PROVIDER ---
// // final videoTabProvider =
// //     NotifierProvider<VideoTabNotifier, VideoTabState>(
// //   VideoTabNotifier.new,
// // );

// // // --- WIDGET ---
// // class MyProfileVideoTab extends ConsumerStatefulWidget {
// //   const MyProfileVideoTab({super.key});

// //   @override
// //   ConsumerState<MyProfileVideoTab> createState() =>
// //       _MyProfileVideoTabState();
// // }

// // class _MyProfileVideoTabState extends ConsumerState<MyProfileVideoTab> {
// //   final ImagePicker _picker = ImagePicker();

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       ref.read(videoTabProvider.notifier).loadVideosFromApi();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final state = ref.watch(videoTabProvider);
// //     final notifier = ref.read(videoTabProvider.notifier);
// //     final list =
// //         state.showApproved ? state.approvedVideos : state.pendingVideos;
// //     final width = MediaQuery.of(context).size.width;
// //     final isCompact = width < 380;
// //     final title = state.showApproved ? 'Approved Videos' : 'Pending Approval';

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _statusTabs(state, notifier),
// //         const SizedBox(height: 12),
// //         if (state.showApproved) _infoStrip(),
// //         if (state.showApproved) const SizedBox(height: 16),
// //         if (state.showApproved)
// //           Wrap(
// //             spacing: 8,
// //             runSpacing: 8,
// //             crossAxisAlignment: WrapCrossAlignment.center,
// //             children: [
// //               Text(
// //                 title,
// //                 style: TextStyle(
// //                   fontSize: isCompact ? 24 : 28,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //               ),
// //               ElevatedButton.icon(
// //                 onPressed: _addVideo,
// //                 icon: const Icon(Icons.add, size: 16),
// //                 label: const Text('Add Video'),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFF220027),
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(20)),
// //                   padding: const EdgeInsets.symmetric(
// //                       horizontal: 16, vertical: 10),
// //                 ),
// //               ),
// //             ],
// //           )
// //         else
// //           Text(
// //             title,
// //             style: TextStyle(
// //               fontSize: isCompact ? 24 : 28,
// //               fontWeight: FontWeight.w700,
// //             ),
// //           ),
// //         const SizedBox(height: 14),
// //         if (state.isLoading)
// //           const Center(
// //             child: Padding(
// //               padding: EdgeInsets.only(top: 24),
// //               child: CircularProgressIndicator(),
// //             ),
// //           )
// //         else if (list.isEmpty)
// //           Center(
// //             child: Padding(
// //               padding: const EdgeInsets.only(top: 24),
// //               child: Text(
// //                 state.showApproved
// //                     ? 'No approved videos.'
// //                     : 'No pending videos.',
// //                 style: TextStyle(color: Colors.grey[700], fontSize: 16),
// //               ),
// //             ),
// //           )
// //         else
// //           Wrap(
// //             spacing: 14,
// //             runSpacing: 14,
// //             children: list
// //                 .map((item) =>
// //                     _videoCard(item, isCompact ? width - 64 : 240))
// //                 .toList(),
// //           ),
// //       ],
// //     );
// //   }

// //   Widget _statusTabs(VideoTabState state, VideoTabNotifier notifier) {
// //     return Container(
// //       height: 40,
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(22),
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           _pillTab(
// //             label: 'Approved',
// //             selected: state.showApproved,
// //             onTap: () => notifier.toggleTab(true),
// //           ),
// //           const Spacer(),
// //           _pillTab(
// //             label: 'Pending',
// //             selected: !state.showApproved,
// //             onTap: () => notifier.toggleTab(false),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _pillTab({
// //     required String label,
// //     required bool selected,
// //     required VoidCallback onTap,
// //   }) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(16),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// //         decoration: BoxDecoration(
// //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         child: Text(
// //           label,
// //           style: const TextStyle(
// //             color: Colors.white,
// //             fontSize: 11,
// //             fontWeight: FontWeight.w700,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _infoStrip() {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(4),
// //         border: Border.all(color: const Color(0xFF2D1935)),
// //       ),
// //       child: const Row(
// //         children: [
// //           Icon(Icons.movie_outlined, size: 16),
// //           SizedBox(width: 8),
// //           Expanded(
// //             child: Text(
// //               'Maximum video size is 10MB. Formats supported: avi, wmv, mov, mp4.',
// //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _videoCard(VideoItem item, double width) {
// //     return InkWell(
// //       onTap: () => _openVideoPlayer(item),
// //       borderRadius: BorderRadius.circular(14),
// //       child: Container(
// //         width: width,
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(14),
// //           border: Border.all(color: const Color(0xFFE8E0F2)),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Stack(
// //               children: [
// //                 ClipRRect(
// //                   borderRadius: const BorderRadius.vertical(
// //                       top: Radius.circular(14)),
// //                   child: _buildThumbnail(item),
// //                 ),
// //                 Positioned.fill(
// //                   child: Center(
// //                     child: CircleAvatar(
// //                       radius: 18,
// //                       backgroundColor:
// //                           Colors.black.withValues(alpha: 0.5),
// //                       child: const Icon(Icons.play_arrow,
// //                           color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   left: 8,
// //                   top: 8,
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 8, vertical: 3),
// //                     decoration: BoxDecoration(
// //                       color: item.approved
// //                           ? const Color(0xFF20B35D)
// //                           : const Color(0xFFF7D12D),
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: Text(
// //                       item.approved ? 'APPROVED' : 'PENDING',
// //                       style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 10,
// //                           fontWeight: FontWeight.w700),
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   right: 8,
// //                   top: 8,
// //                   child: CircleAvatar(
// //                     radius: 12,
// //                     backgroundColor: const Color(0xFFFF4473),
// //                     child: IconButton(
// //                       icon: const Icon(Icons.delete_outline,
// //                           size: 14, color: Colors.white),
// //                       onPressed: () => ref
// //                           .read(videoTabProvider.notifier)
// //                           .deleteVideo(item),
// //                       padding: EdgeInsets.zero,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(
// //                   horizontal: 10, vertical: 10),
// //               child: Row(
// //                 children: [
// //                   Icon(
// //                     item.approved
// //                         ? Icons.check_circle_outline
// //                         : Icons.access_time,
// //                     size: 14,
// //                     color: Colors.black54,
// //                   ),
// //                   const SizedBox(width: 6),
// //                   Text(
// //                     item.approved ? 'Approved' : 'Awaiting Approval',
// //                     style: const TextStyle(
// //                         fontSize: 12, fontWeight: FontWeight.w600),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   /// Builds the thumbnail for a card.
// //   ///
// //   /// - Local video file  -> generate a thumbnail from the file.
// //   /// - Remote video URL  -> generate a thumbnail from the network video.
// //   /// - http(s) image      -> Image.network.
// //   /// - asset fallback     -> Image.asset.
// //   Widget _buildThumbnail(VideoItem item) {
// //     const double h = 160;

// //     Widget placeholder() => Container(
// //           height: h,
// //           width: double.infinity,
// //           color: const Color(0xFFF2ECF7),
// //           child: const Center(
// //             child: Icon(Icons.play_circle_outline,
// //                 size: 56, color: Color(0xFF4A3B57)),
// //           ),
// //         );

// //     Widget loading() => Container(
// //           height: h,
// //           width: double.infinity,
// //           color: const Color(0xFFF2ECF7),
// //           child: const Center(
// //               child: CircularProgressIndicator(strokeWidth: 2)),
// //         );

// //     final videoPath = item.videoPath ?? '';
// //     final bool isVideoSource = videoPath.isNotEmpty &&
// //         (item.isLocalVideo ||
// //             videoPath.startsWith('http') ||
// //             videoPath.startsWith('https'));

// //     // Generate a thumbnail directly from the video (local or remote).
// //     if (isVideoSource) {
// //       return FutureBuilder<String?>(
// //         future: VideoThumbnailUtils.generateThumbnail(videoPath),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return loading();
// //           }
// //           if (snapshot.hasData && snapshot.data != null) {
// //             return Image.file(
// //               File(snapshot.data!),
// //               height: h,
// //               width: double.infinity,
// //               fit: BoxFit.cover,
// //               errorBuilder: (_, __, ___) => placeholder(),
// //             );
// //           }
// //           return placeholder();
// //         },
// //       );
// //     }

// //     // Fallback to thumbnailPath (image url or asset).
// //     if (item.thumbnailPath.startsWith('http')) {
// //       return Image.network(
// //         item.thumbnailPath,
// //         height: h,
// //         width: double.infinity,
// //         fit: BoxFit.cover,
// //         errorBuilder: (_, __, ___) => Container(
// //           height: h,
// //           width: double.infinity,
// //           color: const Color(0xFFF2ECF7),
// //           child: const Icon(Icons.broken_image, color: Colors.grey),
// //         ),
// //       );
// //     }

// //     return Image.asset(
// //       item.thumbnailPath,
// //       height: h,
// //       width: double.infinity,
// //       fit: BoxFit.cover,
// //       errorBuilder: (_, __, ___) => placeholder(),
// //     );
// //   }

// //   Future<void> _addVideo() async {
// //     try {
// //       final source = await _chooseVideoSource();
// //       if (source == null) return;

// //       final picked = await _picker.pickVideo(
// //         source: source,
// //         maxDuration: const Duration(minutes: 5),
// //       );
// //       if (picked == null) return;

// //       await ref.read(videoTabProvider.notifier).addVideo(picked);

// //       if (!mounted) return;
// //       Get.snackbar(
// //         'Success',
// //         'Video added to pending approval',
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: Colors.transparent,
// //         colorText: Colors.black,
// //         borderRadius: 12,
// //         margin: const EdgeInsets.all(16),
// //         duration: const Duration(seconds: 2),
// //       );
// //     } catch (_) {
// //       if (!mounted) return;
// //       Get.snackbar(
// //         'Error',
// //         'Unable to pick video. Please restart app once and try again.',
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: Colors.transparent,
// //         colorText: Colors.black,
// //         borderRadius: 12,
// //         margin: const EdgeInsets.all(16),
// //         duration: const Duration(seconds: 2),
// //       );
// //     }
// //   }

// //   Future<ImageSource?> _chooseVideoSource() async {
// //     return showModalBottomSheet<ImageSource>(
// //       context: context,
// //       builder: (context) {
// //         return SafeArea(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ListTile(
// //                 leading: const Icon(Icons.video_library_outlined),
// //                 title: const Text('Choose from Gallery'),
// //                 onTap: () =>
// //                     Navigator.pop(context, ImageSource.gallery),
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.videocam_outlined),
// //                 title: const Text('Record Video'),
// //                 onTap: () =>
// //                     Navigator.pop(context, ImageSource.camera),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   void _openVideoPlayer(VideoItem item) {
// //     if (item.videoPath == null || item.videoPath!.isEmpty) {
// //       Get.snackbar(
// //         'Error',
// //         'Playable video not available for this item.',
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: Colors.transparent,
// //         colorText: Colors.black,
// //         borderRadius: 12,
// //         margin: const EdgeInsets.all(16),
// //         duration: const Duration(seconds: 2),
// //       );
// //       return;
// //     }
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => _VideoPlayerPage(videoPath: item.videoPath!),
// //       ),
// //     );
// //   }
// // }

// // class _VideoPlayerPage extends StatefulWidget {
// //   const _VideoPlayerPage({required this.videoPath});

// //   final String videoPath;

// //   @override
// //   State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
// // }

// // class _VideoPlayerPageState extends State<_VideoPlayerPage> {
// //   VideoPlayerController? _controller;
// //   String? _initError;
// //   bool _isInitializing = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializePlayer();
// //   }

// //   Future<void> _initializePlayer() async {
// //     try {
// //       final String path = widget.videoPath;
// //       final VideoPlayerController controller;

// //       if (path.startsWith('http') || path.startsWith('https')) {
// //         controller = VideoPlayerController.networkUrl(Uri.parse(path));
// //       } else {
// //         final file = File(path);
// //         if (!await file.exists()) {
// //           throw Exception("The video file no longer exists on this device.");
// //         }
// //         controller = VideoPlayerController.file(file);
// //       }

// //       _controller = controller;
// //       await controller.initialize();
// //       if (!mounted) return;
// //       await controller.play();
// //       setState(() {
// //         _isInitializing = false;
// //       });
// //     } catch (e) {
// //       if (!mounted) return;
// //       setState(() {
// //         _initError = e.toString().contains('Exception:')
// //             ? e.toString().split('Exception:').last
// //             : e.toString();
// //         _isInitializing = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //               'Video player initialization failed. Please restart the app fully and try again.'),
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _controller?.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final c = _controller;
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Video Preview')),
// //       backgroundColor: Colors.black,
// //       body: Center(
// //         child: _isInitializing
// //             ? const CircularProgressIndicator()
// //             : _initError != null
// //                 ? Padding(
// //                     padding: const EdgeInsets.all(24),
// //                     child: Text(
// //                       'Could not play this video.\n\n$_initError',
// //                       textAlign: TextAlign.center,
// //                       style: const TextStyle(color: Colors.white70),
// //                     ),
// //                   )
// //                 : c == null || !c.value.isInitialized
// //                     ? const Text(
// //                         'Video is unavailable.',
// //                         style: TextStyle(color: Colors.white70),
// //                       )
// //                     : GestureDetector(
// //                         onTap: () {
// //                           if (c.value.isPlaying) {
// //                             c.pause();
// //                           } else {
// //                             c.play();
// //                           }
// //                           setState(() {});
// //                         },
// //                         child: AspectRatio(
// //                           aspectRatio: c.value.aspectRatio,
// //                           child: VideoPlayer(c),
// //                         ),
// //                       ),
// //       ),
// //       floatingActionButton: c == null || !c.value.isInitialized
// //           ? null
// //           : FloatingActionButton(
// //               onPressed: () {
// //                 if (c.value.isPlaying) {
// //                   c.pause();
// //                 } else {
// //                   c.play();
// //                 }
// //                 setState(() {});
// //               },
// //               child: Icon(
// //                   c.value.isPlaying ? Icons.pause : Icons.play_arrow),
// //             ),
// //     );
// //   }
// // }



// // // import 'dart:convert';
// // // import 'dart:io';

// // // import 'package:beatflirt/Api_services/api_services.dart';
// // // import 'package:beatflirt/core/services/auth_services.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:video_player/video_player.dart';
// // // import 'package:beatflirt/core/utils/video_thumbnail_utils.dart';
// // // import 'package:get/get.dart';

// // // // --- MODEL ---
// // // class VideoItem {
// // //   const VideoItem({
// // //     required this.mediaId,
// // //     required this.thumbnailPath,
// // //     required this.approved,
// // //     this.videoPath,
// // //     this.isLocalVideo = false,
// // //   });

// // //   final String mediaId;
// // //   final String thumbnailPath;
// // //   final bool approved;
// // //   final String? videoPath;
// // //   final bool isLocalVideo;

// // //   Map<String, dynamic> toJson() {
// // //     return {
// // //       'mediaId': mediaId,
// // //       'thumbnailPath': thumbnailPath,
// // //       'approved': approved,
// // //       'videoPath': videoPath,
// // //       'isLocalVideo': isLocalVideo,
// // //     };
// // //   }

// // //   factory VideoItem.fromJson(Map<String, dynamic> json) {
// // //     return VideoItem(
// // //       mediaId: (json['mediaId'] ?? '').toString(),
// // //       thumbnailPath: (json['thumbnailPath'] ?? 'assets/images/notification-image4.jpg').toString(),
// // //       approved: json['approved'] == true,
// // //       videoPath: json['videoPath']?.toString(),
// // //       isLocalVideo: json['isLocalVideo'] == true,
// // //     );
// // //   }

// // //   factory VideoItem.fromApi(Map<String, dynamic> json) {
// // //     final path = (json['path'] ?? '').toString();
// // //     final thumb = (json['thumbnailPath'] ?? '').toString();
// // //     return VideoItem(
// // //       mediaId: (json['mediaId'] ?? '').toString(),
// // //       thumbnailPath: thumb.isEmpty ? 'assets/images/notification-image4.jpg' : thumb,
// // //       approved: (json['status'] ?? '').toString() == 'approved',
// // //       videoPath: path,
// // //       isLocalVideo: path.startsWith('/'),
// // //     );
// // //   }

// // //   @override
// // //   bool operator ==(Object other) =>
// // //       identical(this, other) ||
// // //           other is VideoItem &&
// // //               runtimeType == other.runtimeType &&
// // //               mediaId == other.mediaId &&
// // //               videoPath == other.videoPath;

// // //   @override
// // //   int get hashCode => mediaId.hashCode ^ videoPath.hashCode;
// // // }

// // // // --- STATE ---
// // // class VideoTabState {
// // //   final bool showApproved;
// // //   final bool isLoading;
// // //   final List<VideoItem> pendingVideos;
// // //   final List<VideoItem> approvedVideos;

// // //   const VideoTabState({
// // //     this.showApproved = false,
// // //     this.isLoading = true,
// // //     this.pendingVideos = const [],
// // //     this.approvedVideos = const [],
// // //   });

// // //   VideoTabState copyWith({
// // //     bool? showApproved,
// // //     bool? isLoading,
// // //     List<VideoItem>? pendingVideos,
// // //     List<VideoItem>? approvedVideos,
// // //   }) {
// // //     return VideoTabState(
// // //       showApproved: showApproved ?? this.showApproved,
// // //       isLoading: isLoading ?? this.isLoading,
// // //       pendingVideos: pendingVideos ?? this.pendingVideos,
// // //       approvedVideos: approvedVideos ?? this.approvedVideos,
// // //     );
// // //   }
// // // }

// // // // --- NOTIFIER ---
// // // class VideoTabNotifier extends Notifier<VideoTabState> {
// // //   static const String _pendingKey = 'profile_videos_pending';
// // //   static const String _approvedKey = 'profile_videos_approved';
// // //   final ApiServices _api = ApiServices();

// // //   @override
// // //   VideoTabState build() => const VideoTabState();

// // //   void toggleTab(bool showApproved) {
// // //     state = state.copyWith(showApproved: showApproved);
// // //   }

// // //   Future<void> loadVideosFromApi() async {
// // //     state = state.copyWith(isLoading: true);
// // //     try {
// // //       final token = await AuthService.getToken();
// // //       if (token == null || token.isEmpty) {
// // //         state = state.copyWith(isLoading: false);
// // //         return;
// // //       }
// // //       final items = await _api.getVideos(token: token);
// // //       final videos = items.map(VideoItem.fromApi).toList();
// // //       state = state.copyWith(
// // //         approvedVideos: videos.where((v) => v.approved).toList(),
// // //         pendingVideos: videos.where((v) => !v.approved).toList(),
// // //         isLoading: false,
// // //       );
// // //     } catch (_) {
// // //       state = state.copyWith(isLoading: false);
// // //       await _loadVideosFromPrefs();
// // //     }
// // //   }

// // //   Future<void> addVideo(XFile picked) async {
// // //     final thumbnail = await VideoThumbnailUtils.generateThumbnail(picked.path);

// // //     state = state.copyWith(
// // //       pendingVideos: [
// // //         VideoItem(
// // //           mediaId: '',
// // //           thumbnailPath: thumbnail ?? 'assets/images/notification-image4.jpg',
// // //           approved: false,
// // //           videoPath: picked.path,
// // //           isLocalVideo: true,
// // //         ),
// // //         ...state.pendingVideos,
// // //       ],
// // //       showApproved: false,
// // //     );

// // //     final token = await AuthService.getToken();
// // //     if (token != null && token.isNotEmpty) {
// // //       try {
// // //         await _api.addVideo(
// // //           token: token,
// // //           path: picked.path,
// // //           thumbnailPath: thumbnail ?? 'assets/images/notification-image4.jpg',
// // //         );
// // //         await loadVideosFromApi();
// // //       } catch (_) {
// // //         await _persistVideos();
// // //       }
// // //     } else {
// // //       await _persistVideos();
// // //     }
// // //   }

// // //   Future<void> deleteVideo(VideoItem item) async {
// // //     final newApproved = List<VideoItem>.from(state.approvedVideos)..remove(item);
// // //     final newPending = List<VideoItem>.from(state.pendingVideos)..remove(item);

// // //     state = state.copyWith(
// // //       approvedVideos: item.approved ? newApproved : state.approvedVideos,
// // //       pendingVideos: !item.approved ? newPending : state.pendingVideos,
// // //     );

// // //     await _deleteVideoApi(item);
// // //   }

// // //   Future<void> _deleteVideoApi(VideoItem item) async {
// // //     if (item.mediaId.isEmpty) {
// // //       await _persistVideos();
// // //       return;
// // //     }
// // //     try {
// // //       final token = await AuthService.getToken();
// // //       if (token == null || token.isEmpty) return;
// // //       await _api.deleteVideo(token: token, mediaId: item.mediaId);
// // //     } catch (_) {
// // //       // keep optimistic UI
// // //     } finally {
// // //       await _persistVideos();
// // //     }
// // //   }

// // //   Future<void> _loadVideosFromPrefs() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final pendingRaw = prefs.getString(_pendingKey);
// // //     final approvedRaw = prefs.getString(_approvedKey);

// // //     List<VideoItem> decode(String? raw) {
// // //       if (raw == null || raw.isEmpty) return [];
// // //       try {
// // //         final decoded = jsonDecode(raw);
// // //         if (decoded is! List) return [];
// // //         return decoded
// // //             .whereType<Map>()
// // //             .map((e) => VideoItem.fromJson(Map<String, dynamic>.from(e)))
// // //             .toList();
// // //       } catch (_) {
// // //         return [];
// // //       }
// // //     }

// // //     final pending = decode(pendingRaw);
// // //     final approved = decode(approvedRaw);
// // //     state = state.copyWith(
// // //       pendingVideos: pending,
// // //       approvedVideos: approved,
// // //     );
// // //   }

// // //   Future<void> _persistVideos() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.setString(
// // //       _pendingKey,
// // //       jsonEncode(state.pendingVideos.map((e) => e.toJson()).toList()),
// // //     );
// // //     await prefs.setString(
// // //       _approvedKey,
// // //       jsonEncode(state.approvedVideos.map((e) => e.toJson()).toList()),
// // //     );
// // //   }
// // // }

// // // // --- PROVIDER ---
// // // final videoTabProvider =
// // // NotifierProvider<VideoTabNotifier, VideoTabState>(
// // //   VideoTabNotifier.new,
// // // );

// // // // --- WIDGET ---
// // // class MyProfileVideoTab extends ConsumerStatefulWidget {
// // //   const MyProfileVideoTab({super.key});

// // //   @override
// // //   ConsumerState<MyProfileVideoTab> createState() => _MyProfileVideoTabState();
// // // }

// // // class _MyProfileVideoTabState extends ConsumerState<MyProfileVideoTab> {
// // //   final ImagePicker _picker = ImagePicker();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       ref.read(videoTabProvider.notifier).loadVideosFromApi();
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final state = ref.watch(videoTabProvider);
// // //     final notifier = ref.read(videoTabProvider.notifier);
// // //     final list = state.showApproved ? state.approvedVideos : state.pendingVideos;
// // //     final width = MediaQuery.of(context).size.width;
// // //     final isCompact = width < 380;
// // //     final title = state.showApproved ? 'Approved Videos' : 'Pending Approval';

// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         _statusTabs(state, notifier),
// // //         const SizedBox(height: 12),
// // //         if (state.showApproved) _infoStrip(),
// // //         if (state.showApproved) const SizedBox(height: 16),
// // //         if (state.showApproved)
// // //           Wrap(
// // //             spacing: 8,
// // //             runSpacing: 8,
// // //             crossAxisAlignment: WrapCrossAlignment.center,
// // //             children: [
// // //               Text(
// // //                 title,
// // //                 style: TextStyle(
// // //                   fontSize: isCompact ? 24 : 28,
// // //                   fontWeight: FontWeight.w700,
// // //                 ),
// // //               ),
// // //               ElevatedButton.icon(
// // //                 onPressed: _addVideo,
// // //                 icon: const Icon(Icons.add, size: 16),
// // //                 label: const Text('Add Video'),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: const Color(0xFF220027),
// // //                   foregroundColor: Colors.white,
// // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // //                 ),
// // //               ),
// // //             ],
// // //           )
// // //         else
// // //           Text(
// // //             title,
// // //             style: TextStyle(
// // //               fontSize: isCompact ? 24 : 28,
// // //               fontWeight: FontWeight.w700,
// // //             ),
// // //           ),
// // //         const SizedBox(height: 14),
// // //         if (state.isLoading)
// // //           const Center(
// // //             child: Padding(
// // //               padding: EdgeInsets.only(top: 24),
// // //               child: CircularProgressIndicator(),
// // //             ),
// // //           )
// // //         else if (list.isEmpty)
// // //           Center(
// // //             child: Padding(
// // //               padding: const EdgeInsets.only(top: 24),
// // //               child: Text(
// // //                 state.showApproved ? 'No approved videos.' : 'No pending videos.',
// // //                 style: TextStyle(color: Colors.grey[700], fontSize: 16),
// // //               ),
// // //             ),
// // //           )
// // //         else
// // //           Wrap(
// // //             spacing: 14,
// // //             runSpacing: 14,
// // //             children: list.map((item) => _videoCard(item, isCompact ? width - 64 : 240)).toList(),
// // //           ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _statusTabs(VideoTabState state, VideoTabNotifier notifier) {
// // //     return Container(
// // //       height: 40,
// // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
// // //       decoration: BoxDecoration(
// // //         borderRadius: BorderRadius.circular(22),
// // //         gradient: const LinearGradient(
// // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // //         ),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           _pillTab(
// // //             label: 'Approved',
// // //             selected: state.showApproved,
// // //             onTap: () => notifier.toggleTab(true),
// // //           ),
// // //           const Spacer(),
// // //           _pillTab(
// // //             label: 'Pending',
// // //             selected: !state.showApproved,
// // //             onTap: () => notifier.toggleTab(false),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _pillTab({
// // //     required String label,
// // //     required bool selected,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return InkWell(
// // //       onTap: onTap,
// // //       borderRadius: BorderRadius.circular(16),
// // //       child: Container(
// // //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// // //         decoration: BoxDecoration(
// // //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// // //           borderRadius: BorderRadius.circular(16),
// // //         ),
// // //         child: Text(
// // //           label,
// // //           style: const TextStyle(
// // //             color: Colors.white,
// // //             fontSize: 11,
// // //             fontWeight: FontWeight.w700,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _infoStrip() {
// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // //       decoration: BoxDecoration(
// // //         borderRadius: BorderRadius.circular(4),
// // //         border: Border.all(color: const Color(0xFF2D1935)),
// // //       ),
// // //       child: const Row(
// // //         children: [
// // //           Icon(Icons.movie_outlined, size: 16),
// // //           SizedBox(width: 8),
// // //           Expanded(
// // //             child: Text(
// // //               'Maximum video size is 10MB. Formats supported: avi, wmv, mov, mp4.',
// // //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _videoCard(VideoItem item, double width) {
// // //     return InkWell(
// // //       onTap: () => _openVideoPlayer(item),
// // //       borderRadius: BorderRadius.circular(14),
// // //       child: Container(
// // //         width: width,
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(14),
// // //           border: Border.all(color: const Color(0xFFE8E0F2)),
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Stack(
// // //               children: [
// // //                 ClipRRect(
// // //                   borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
// // //                   child: item.isLocalVideo
// // //                       ? FutureBuilder<String?>(
// // //                           future: VideoThumbnailUtils.generateThumbnail(item.videoPath ?? ''),
// // //                           builder: (context, snapshot) {
// // //                             if (snapshot.connectionState == ConnectionState.waiting) {
// // //                               return Container(
// // //                                 height: 160,
// // //                                 width: double.infinity,
// // //                                 color: const Color(0xFFF2ECF7),
// // //                                 child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
// // //                               );
// // //                             }
// // //                             if (snapshot.hasData && snapshot.data != null) {
// // //                               return Image.file(
// // //                                 File(snapshot.data!),
// // //                                 height: 160,
// // //                                 width: double.infinity,
// // //                                 fit: BoxFit.cover,
// // //                               );
// // //                             }
// // //                             return Container(
// // //                               height: 160,
// // //                               width: double.infinity,
// // //                               color: const Color(0xFFF2ECF7),
// // //                               child: const Center(
// // //                                 child: Icon(Icons.play_circle_outline, size: 56, color: Color(0xFF4A3B57)),
// // //                               ),
// // //                             );
// // //                           },
// // //                         )
// // //                       : (item.thumbnailPath.startsWith('http')
// // //                           ? Image.network(
// // //                               item.thumbnailPath,
// // //                               height: 160,
// // //                               width: double.infinity,
// // //                               fit: BoxFit.cover,
// // //                               errorBuilder: (_, __, ___) => Container(
// // //                                 height: 160,
// // //                                 width: double.infinity,
// // //                                 color: const Color(0xFFF2ECF7),
// // //                                 child: const Icon(Icons.broken_image, color: Colors.grey),
// // //                               ),
// // //                             )
// // //                           : Image.asset(
// // //                               item.thumbnailPath,
// // //                               height: 160,
// // //                               width: double.infinity,
// // //                               fit: BoxFit.cover,
// // //                             )),
// // //                 ),
// // //                 Positioned.fill(
// // //                   child: Center(
// // //                     child: CircleAvatar(
// // //                       radius: 18,
// // //                       backgroundColor: Colors.black.withValues(alpha: 0.5),
// // //                       child: const Icon(Icons.play_arrow, color: Colors.white),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 Positioned(
// // //                   left: 8,
// // //                   top: 8,
// // //                   child: Container(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// // //                     decoration: BoxDecoration(
// // //                       color: item.approved ? const Color(0xFF20B35D) : const Color(0xFFF7D12D),
// // //                       borderRadius: BorderRadius.circular(8),
// // //                     ),
// // //                     child: Text(
// // //                       item.approved ? 'APPROVED' : 'PENDING',
// // //                       style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 Positioned(
// // //                   right: 8,
// // //                   top: 8,
// // //                   child: CircleAvatar(
// // //                     radius: 12,
// // //                     backgroundColor: const Color(0xFFFF4473),
// // //                     child: IconButton(
// // //                       icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
// // //                       onPressed: () => ref.read(videoTabProvider.notifier).deleteVideo(item),
// // //                       padding: EdgeInsets.zero,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             Padding(
// // //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// // //               child: Row(
// // //                 children: [
// // //                   Icon(
// // //                     item.approved ? Icons.check_circle_outline : Icons.access_time,
// // //                     size: 14,
// // //                     color: Colors.black54,
// // //                   ),
// // //                   const SizedBox(width: 6),
// // //                   Text(
// // //                     item.approved ? 'Approved' : 'Awaiting Approval',
// // //                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Future<void> _addVideo() async {
// // //     try {
// // //       final source = await _chooseVideoSource();
// // //       if (source == null) return;

// // //       final picked = await _picker.pickVideo(
// // //         source: source,
// // //         maxDuration: const Duration(minutes: 5),
// // //       );
// // //       if (picked == null) return;

// // //       await ref.read(videoTabProvider.notifier).addVideo(picked);

// // //       if (!mounted) return;
// // //       // ScaffoldMessenger.of(context).showSnackBar(
// // //       //   const SnackBar(content: Text('Video added to pending approval')),
// // //       // );
// // //       Get.snackbar(
// // //         'Success',
// // //         'Video added to pending approval',
// // //         snackPosition: SnackPosition.TOP,
// // //         backgroundColor: Colors.transparent,
// // //         colorText: Colors.black,
// // //         borderRadius: 12,
// // //         margin: const EdgeInsets.all(16),
// // //         duration: const Duration(seconds: 2),
// // //       );
// // //     } catch (_) {
// // //       if (!mounted) return;
// // //       // ScaffoldMessenger.of(context).showSnackBar(
// // //       //   const SnackBar(content: Text('Unable to pick video. Please restart app once and try again.')),
// // //       // );
// // //       Get.snackbar(
// // //         'Error',
// // //         'Unable to pick video. Please restart app once and try again.',
// // //         snackPosition: SnackPosition.TOP,
// // //         backgroundColor: Colors.transparent,
// // //         colorText: Colors.black,
// // //         borderRadius: 12,
// // //         margin: const EdgeInsets.all(16),
// // //         duration: const Duration(seconds: 2),
// // //       );
// // //     }
// // //   }

// // //   Future<ImageSource?> _chooseVideoSource() async {
// // //     return showModalBottomSheet<ImageSource>(
// // //       context: context,
// // //       builder: (context) {
// // //         return SafeArea(
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               ListTile(
// // //                 leading: const Icon(Icons.video_library_outlined),
// // //                 title: const Text('Choose from Gallery'),
// // //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// // //               ),
// // //               ListTile(
// // //                 leading: const Icon(Icons.videocam_outlined),
// // //                 title: const Text('Record Video'),
// // //                 onTap: () => Navigator.pop(context, ImageSource.camera),
// // //               ),
// // //             ],
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   void _openVideoPlayer(VideoItem item) {
// // //     if (item.videoPath == null || item.videoPath!.isEmpty) {
// // //       // ScaffoldMessenger.of(context).showSnackBar(
// // //       //   const SnackBar(content: Text('Playable local video not available for this item.')),
// // //       // );
// // //       Get.snackbar(
// // //         'Error',
// // //         'Playable local video not available for this item.',
// // //         snackPosition: SnackPosition.TOP,
// // //         backgroundColor: Colors.transparent,
// // //         colorText: Colors.black,
// // //         borderRadius: 12,
// // //         margin: const EdgeInsets.all(16),
// // //         duration: const Duration(seconds: 2),
// // //       );
// // //       return;
// // //     }
// // //     Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => _VideoPlayerPage(videoPath: item.videoPath!),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _VideoPlayerPage extends StatefulWidget {
// // //   const _VideoPlayerPage({required this.videoPath});

// // //   final String videoPath;

// // //   @override
// // //   State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
// // // }

// // // class _VideoPlayerPageState extends State<_VideoPlayerPage> {
// // //   VideoPlayerController? _controller;
// // //   String? _initError;
// // //   bool _isInitializing = true;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initializePlayer();
// // //   }

// // //   Future<void> _initializePlayer() async {
// // //     try {
// // //       final String path = widget.videoPath;
// // //       final VideoPlayerController controller;

// // //       if (path.startsWith('http') || path.startsWith('https')) {
// // //         controller = VideoPlayerController.networkUrl(Uri.parse(path));
// // //       } else {
// // //         final file = File(path);
// // //         if (!await file.exists()) {
// // //           throw Exception("The video file no longer exists on this device.");
// // //         }
// // //         controller = VideoPlayerController.file(file);
// // //       }

// // //       _controller = controller;
// // //       await controller.initialize();
// // //       if (!mounted) return;
// // //       await controller.play();
// // //       setState(() {
// // //         _isInitializing = false;
// // //       });
// // //     } catch (e) {
// // //       if (!mounted) return;
// // //       setState(() {
// // //         _initError = e.toString().contains('Exception:')
// // //             ? e.toString().split('Exception:').last
// // //             : e.toString();
// // //         _isInitializing = false;
// // //       });
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('Video player initialization failed. Please restart the app fully and try again.'),
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _controller?.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final c = _controller;
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Video Preview')),
// // //       backgroundColor: Colors.black,
// // //       body: Center(
// // //         child: _isInitializing
// // //             ? const CircularProgressIndicator()
// // //             : _initError != null
// // //             ? Padding(
// // //           padding: const EdgeInsets.all(24),
// // //           child: Text(
// // //             'Could not play this video.\n\n$_initError',
// // //             textAlign: TextAlign.center,
// // //             style: const TextStyle(color: Colors.white70),
// // //           ),
// // //         )
// // //             : c == null || !c.value.isInitialized
// // //             ? const Text(
// // //           'Video is unavailable.',
// // //           style: TextStyle(color: Colors.white70),
// // //         )
// // //             : GestureDetector(
// // //           onTap: () {
// // //             if (c.value.isPlaying) {
// // //               c.pause();
// // //             } else {
// // //               c.play();
// // //             }
// // //             setState(() {});
// // //           },
// // //           child: AspectRatio(
// // //             aspectRatio: c.value.aspectRatio,
// // //             child: VideoPlayer(c),
// // //           ),
// // //         ),
// // //       ),
// // //       floatingActionButton: c == null || !c.value.isInitialized
// // //           ? null
// // //           : FloatingActionButton(
// // //         onPressed: () {
// // //           if (c.value.isPlaying) {
// // //             c.pause();
// // //           } else {
// // //             c.play();
// // //           }
// // //           setState(() {});
// // //         },
// // //         child: Icon(c.value.isPlaying ? Icons.pause : Icons.play_arrow),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:image_picker/image_picker.dart';
// // // // import 'package:video_player/video_player.dart';
// // // // import 'dart:io';
// // // // import '../../../providers/profile_provider.dart';
// // // // import '../../../core/constants.dart';
// // // //
// // // // class VideosTab extends ConsumerStatefulWidget {
// // // //   const VideosTab({super.key});
// // // //
// // // //   @override
// // // //   ConsumerState<VideosTab> createState() => _VideosTabState();
// // // // }
// // // //
// // // // class _VideosTabState extends ConsumerState<VideosTab> {
// // // //   final ImagePicker _picker = ImagePicker();
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     Future.microtask(() {
// // // //       ref.read(videosProvider.notifier).fetchVideos();
// // // //     });
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final videosState = ref.watch(videosProvider);
// // // //
// // // //     return Column(
// // // //       children: [
// // // //         // Header
// // // //         _buildHeader(videosState),
// // // //
// // // //         // Video list
// // // //         Expanded(
// // // //           child: videosState.isLoading
// // // //               ? _buildLoadingList()
// // // //               : videosState.videos.isEmpty
// // // //               ? _buildEmptyState()
// // // //               : _buildVideoList(videosState.videos),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildHeader(VideosState state) {
// // // //     return Container(
// // // //       padding: const EdgeInsets.all(16),
// // // //       decoration: const BoxDecoration(
// // // //         color: AppColors.surface,
// // // //         border: Border(
// // // //           bottom: BorderSide(color: AppColors.divider, width: 0.5),
// // // //         ),
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           const Icon(Icons.videocam, color: AppColors.primary, size: 22),
// // // //           const SizedBox(width: 10),
// // // //           Text('My Videos', style: AppTextStyles.heading3),
// // // //           const Spacer(),
// // // //           Text(
// // // //             '${state.videos.length} videos',
// // // //             style: AppTextStyles.bodySmall,
// // // //           ),
// // // //           const SizedBox(width: 12),
// // // //           Material(
// // // //             color: AppColors.primary,
// // // //             borderRadius: BorderRadius.circular(12),
// // // //             child: InkWell(
// // // //               borderRadius: BorderRadius.circular(12),
// // // //               onTap: state.isUploading ? null : () => _showUploadOptions(),
// // // //               child: Container(
// // // //                 padding: const EdgeInsets.symmetric(
// // // //                   horizontal: 16,
// // // //                   vertical: 10,
// // // //                 ),
// // // //                 child: state.isUploading
// // // //                     ? const SizedBox(
// // // //                   width: 20,
// // // //                   height: 20,
// // // //                   child: CircularProgressIndicator(
// // // //                     color: Colors.white,
// // // //                     strokeWidth: 2,
// // // //                   ),
// // // //                 )
// // // //                     : const Row(
// // // //                   mainAxisSize: MainAxisSize.min,
// // // //                   children: [
// // // //                     Icon(Icons.video_call, color: Colors.white, size: 18),
// // // //                     SizedBox(width: 6),
// // // //                     Text(
// // // //                       'Upload',
// // // //                       style: TextStyle(
// // // //                         color: Colors.white,
// // // //                         fontSize: 13,
// // // //                         fontWeight: FontWeight.w600,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildEmptyState() {
// // // //     return Center(
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.all(48),
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             Container(
// // // //               padding: const EdgeInsets.all(24),
// // // //               decoration: BoxDecoration(
// // // //                 color: AppColors.primary.withOpacity(0.1),
// // // //                 shape: BoxShape.circle,
// // // //               ),
// // // //               child: Icon(
// // // //                 Icons.video_library_outlined,
// // // //                 size: 64,
// // // //                 color: AppColors.primary.withOpacity(0.6),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 24),
// // // //             const Text('No Videos Yet', style: AppTextStyles.heading2),
// // // //             const SizedBox(height: 8),
// // // //             Text(
// // // //               'Upload videos to showcase yourself\nand attract more attention!',
// // // //               style: AppTextStyles.bodyMedium,
// // // //               textAlign: TextAlign.center,
// // // //             ),
// // // //             const SizedBox(height: 24),
// // // //             ElevatedButton.icon(
// // // //               onPressed: () => _showUploadOptions(),
// // // //               icon: const Icon(Icons.video_call),
// // // //               label: const Text('Add Videos'),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: AppColors.primary,
// // // //                 foregroundColor: Colors.white,
// // // //                 padding: const EdgeInsets.symmetric(
// // // //                   horizontal: 32,
// // // //                   vertical: 14,
// // // //                 ),
// // // //                 shape: RoundedRectangleBorder(
// // // //                   borderRadius: BorderRadius.circular(14),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildLoadingList() {
// // // //     return ListView.builder(
// // // //       padding: const EdgeInsets.all(16),
// // // //       itemCount: 4,
// // // //       itemBuilder: (context, index) => Container(
// // // //         height: 200,
// // // //         margin: const EdgeInsets.only(bottom: 12),
// // // //         decoration: BoxDecoration(
// // // //           color: AppColors.cardDark,
// // // //           borderRadius: BorderRadius.circular(16),
// // // //         ),
// // // //         child: const Center(
// // // //           child: CircularProgressIndicator(
// // // //             color: AppColors.primary,
// // // //             strokeWidth: 2,
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildVideoList(List<String> videos) {
// // // //     return ListView.builder(
// // // //       physics: const BouncingScrollPhysics(),
// // // //       padding: const EdgeInsets.all(16),
// // // //       itemCount: videos.length,
// // // //       itemBuilder: (context, index) {
// // // //         return _buildVideoItem(videos[index], index);
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildVideoItem(String videoUrl, int index) {
// // // //     return GestureDetector(
// // // //       onTap: () => _playVideo(videoUrl),
// // // //       child: Container(
// // // //         height: 200,
// // // //         margin: const EdgeInsets.only(bottom: 12),
// // // //         decoration: BoxDecoration(
// // // //           color: AppColors.cardDark,
// // // //           borderRadius: BorderRadius.circular(16),
// // // //           border: Border.all(color: AppColors.divider, width: 0.5),
// // // //         ),
// // // //         child: ClipRRect(
// // // //           borderRadius: BorderRadius.circular(16),
// // // //           child: Stack(
// // // //             fit: StackFit.expand,
// // // //             children: [
// // // //               // Video thumbnail placeholder
// // // //               Container(
// // // //                 color: AppColors.cardDark,
// // // //                 child: const Center(
// // // //                   child: Icon(
// // // //                     Icons.movie,
// // // //                     size: 48,
// // // //                     color: AppColors.textMuted,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               // Play button overlay
// // // //               Center(
// // // //                 child: Container(
// // // //                   padding: const EdgeInsets.all(16),
// // // //                   decoration: BoxDecoration(
// // // //                     color: AppColors.primary.withOpacity(0.9),
// // // //                     shape: BoxShape.circle,
// // // //                     boxShadow: [
// // // //                       BoxShadow(
// // // //                         color: AppColors.primary.withOpacity(0.4),
// // // //                         blurRadius: 20,
// // // //                         spreadRadius: 2,
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                   child: const Icon(
// // // //                     Icons.play_arrow,
// // // //                     size: 32,
// // // //                     color: Colors.white,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               // Options menu
// // // //               Positioned(
// // // //                 top: 8,
// // // //                 right: 8,
// // // //                 child: GestureDetector(
// // // //                   onTap: () => _showVideoOptions(index),
// // // //                   child: Container(
// // // //                     padding: const EdgeInsets.all(6),
// // // //                     decoration: BoxDecoration(
// // // //                       color: Colors.black.withOpacity(0.5),
// // // //                       borderRadius: BorderRadius.circular(8),
// // // //                     ),
// // // //                     child: const Icon(
// // // //                       Icons.more_vert,
// // // //                       color: Colors.white,
// // // //                       size: 20,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               // Video index label
// // // //               Positioned(
// // // //                 bottom: 8,
// // // //                 left: 8,
// // // //                 child: Container(
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                     horizontal: 10,
// // // //                     vertical: 4,
// // // //                   ),
// // // //                   decoration: BoxDecoration(
// // // //                     color: Colors.black.withOpacity(0.6),
// // // //                     borderRadius: BorderRadius.circular(8),
// // // //                   ),
// // // //                   child: Text(
// // // //                     'Video ${index + 1}',
// // // //                     style: const TextStyle(
// // // //                       color: Colors.white,
// // // //                       fontSize: 12,
// // // //                       fontWeight: FontWeight.w500,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   void _playVideo(String videoUrl) {
// // // //     Navigator.push(
// // // //       context,
// // // //       MaterialPageRoute(
// // // //         builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   void _showVideoOptions(int index) {
// // // //     showModalBottomSheet(
// // // //       context: context,
// // // //       backgroundColor: AppColors.cardDark,
// // // //       shape: const RoundedRectangleBorder(
// // // //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // // //       ),
// // // //       builder: (context) => Padding(
// // // //         padding: const EdgeInsets.symmetric(vertical: 20),
// // // //         child: Column(
// // // //           mainAxisSize: MainAxisSize.min,
// // // //           children: [
// // // //             Container(
// // // //               width: 40,
// // // //               height: 4,
// // // //               decoration: BoxDecoration(
// // // //                 color: AppColors.divider,
// // // //                 borderRadius: BorderRadius.circular(2),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 20),
// // // //             ListTile(
// // // //               leading: const Icon(Icons.play_circle, color: AppColors.primary),
// // // //               title: const Text('Play Video',
// // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // //               onTap: () {
// // // //                 Navigator.pop(context);
// // // //                 final videos = ref.read(videosProvider).videos;
// // // //                 _playVideo(videos[index]);
// // // //               },
// // // //             ),
// // // //             ListTile(
// // // //               leading: const Icon(Icons.delete, color: AppColors.error),
// // // //               title: const Text('Delete Video',
// // // //                   style: TextStyle(color: AppColors.error)),
// // // //               onTap: () {
// // // //                 Navigator.pop(context);
// // // //                 _confirmDelete(index);
// // // //               },
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   void _confirmDelete(int index) {
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (context) => AlertDialog(
// // // //         backgroundColor: AppColors.cardDark,
// // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // //         title: const Text('Delete Video',
// // // //             style: TextStyle(color: AppColors.textPrimary)),
// // // //         content: const Text(
// // // //           'Are you sure you want to delete this video?',
// // // //           style: TextStyle(color: AppColors.textSecondary),
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.pop(context),
// // // //             child: const Text('Cancel'),
// // // //           ),
// // // //           ElevatedButton(
// // // //             onPressed: () {
// // // //               Navigator.pop(context);
// // // //               ref.read(videosProvider.notifier).removeVideo(index);
// // // //             },
// // // //             style: ElevatedButton.styleFrom(
// // // //               backgroundColor: AppColors.error,
// // // //               foregroundColor: Colors.white,
// // // //             ),
// // // //             child: const Text('Delete'),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   void _showUploadOptions() {
// // // //     showModalBottomSheet(
// // // //       context: context,
// // // //       backgroundColor: AppColors.cardDark,
// // // //       shape: const RoundedRectangleBorder(
// // // //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // // //       ),
// // // //       builder: (context) => Padding(
// // // //         padding: const EdgeInsets.symmetric(vertical: 20),
// // // //         child: Column(
// // // //           mainAxisSize: MainAxisSize.min,
// // // //           children: [
// // // //             Container(
// // // //               width: 40,
// // // //               height: 4,
// // // //               decoration: BoxDecoration(
// // // //                 color: AppColors.divider,
// // // //                 borderRadius: BorderRadius.circular(2),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 20),
// // // //             const Text('Upload Video', style: AppTextStyles.heading3),
// // // //             const SizedBox(height: 16),
// // // //             ListTile(
// // // //               leading: Container(
// // // //                 padding: const EdgeInsets.all(10),
// // // //                 decoration: BoxDecoration(
// // // //                   color: AppColors.primary.withOpacity(0.15),
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                 ),
// // // //                 child:
// // // //                 const Icon(Icons.videocam, color: AppColors.primary),
// // // //               ),
// // // //               title: const Text('Record Video',
// // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // //               subtitle: const Text('Record a new video',
// // // //                   style: TextStyle(color: AppColors.textMuted)),
// // // //               onTap: () {
// // // //                 Navigator.pop(context);
// // // //                 _pickVideo(ImageSource.camera);
// // // //               },
// // // //             ),
// // // //             ListTile(
// // // //               leading: Container(
// // // //                 padding: const EdgeInsets.all(10),
// // // //                 decoration: BoxDecoration(
// // // //                   color: AppColors.accent.withOpacity(0.15),
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                 ),
// // // //                 child: const Icon(Icons.video_library,
// // // //                     color: AppColors.accent),
// // // //               ),
// // // //               title: const Text('From Gallery',
// // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // //               subtitle: const Text('Choose from gallery',
// // // //                   style: TextStyle(color: AppColors.textMuted)),
// // // //               onTap: () {
// // // //                 Navigator.pop(context);
// // // //                 _pickVideo(ImageSource.gallery);
// // // //               },
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Future<void> _pickVideo(ImageSource source) async {
// // // //     try {
// // // //       final XFile? video = await _picker.pickVideo(
// // // //         source: source,
// // // //         maxDuration: const Duration(minutes: 5),
// // // //       );
// // // //       if (video != null) {
// // // //         await ref
// // // //             .read(videosProvider.notifier)
// // // //             .uploadVideo(File(video.path));
// // // //       }
// // // //     } catch (e) {
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(
// // // //             content: Text('Error picking video: ${e.toString()}'),
// // // //             backgroundColor: AppColors.error,
// // // //           ),
// // // //         );
// // // //       }
// // // //     }
// // // //   }
// // // // }
// // // //
// // // // // ─── Video Player Screen ───
// // // // class VideoPlayerScreen extends StatefulWidget {
// // // //   final String videoUrl;
// // // //
// // // //   const VideoPlayerScreen({super.key, required this.videoUrl});
// // // //
// // // //   @override
// // // //   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// // // // }
// // // //
// // // // class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
// // // //   late VideoPlayerController _controller;
// // // //   bool _isInitialized = false;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _controller = VideoPlayerController.networkUrl(
// // // //       Uri.parse(widget.videoUrl),
// // // //     )..initialize().then((_) {
// // // //       setState(() => _isInitialized = true);
// // // //       _controller.play();
// // // //     });
// // // //   }
// // // //
// // // //   @override
// // // //   void dispose() {
// // // //     _controller.dispose();
// // // //     super.dispose();
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.black,
// // // //       appBar: AppBar(
// // // //         backgroundColor: Colors.black,
// // // //         foregroundColor: Colors.white,
// // // //         title: const Text('Video Player'),
// // // //       ),
// // // //       body: Center(
// // // //         child: _isInitialized
// // // //             ? AspectRatio(
// // // //           aspectRatio: _controller.value.aspectRatio,
// // // //           child: Stack(
// // // //             alignment: Alignment.center,
// // // //             children: [
// // // //               VideoPlayer(_controller),
// // // //               // Play/Pause overlay
// // // //               GestureDetector(
// // // //                 onTap: () {
// // // //                   setState(() {
// // // //                     _controller.value.isPlaying
// // // //                         ? _controller.pause()
// // // //                         : _controller.play();
// // // //                   });
// // // //                 },
// // // //                 child: AnimatedOpacity(
// // // //                   opacity: _controller.value.isPlaying ? 0.0 : 1.0,
// // // //                   duration: const Duration(milliseconds: 300),
// // // //                   child: Container(
// // // //                     padding: const EdgeInsets.all(12),
// // // //                     decoration: BoxDecoration(
// // // //                       color: Colors.black54,
// // // //                       shape: BoxShape.circle,
// // // //                     ),
// // // //                     child: const Icon(
// // // //                       Icons.play_arrow,
// // // //                       size: 48,
// // // //                       color: Colors.white,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               // Progress bar
// // // //               Positioned(
// // // //                 bottom: 0,
// // // //                 left: 0,
// // // //                 right: 0,
// // // //                 child: VideoProgressIndicator(
// // // //                   _controller,
// // // //                   allowScrubbing: true,
// // // //                   colors: const VideoProgressColors(
// // // //                     playedColor: AppColors.primary,
// // // //                     bufferedColor: Colors.white24,
// // // //                     backgroundColor: Colors.white10,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         )
// // // //             : const CircularProgressIndicator(color: AppColors.primary),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
