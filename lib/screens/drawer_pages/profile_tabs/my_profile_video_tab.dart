import 'dart:convert';
import 'dart:io';

import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class MyProfileVideoTab extends StatefulWidget {
  const MyProfileVideoTab({super.key});

  @override
  State<MyProfileVideoTab> createState() => _MyProfileVideoTabState();
}

class _MyProfileVideoTabState extends State<MyProfileVideoTab> {
  bool _showApproved = false;
  static const String _pendingKey = 'profile_videos_pending';
  static const String _approvedKey = 'profile_videos_approved';
  final ImagePicker _picker = ImagePicker();
  final ApiServices _api = ApiServices();
  List<_VideoItem> _pendingVideos = [];
  List<_VideoItem> _approvedVideos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideosFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final list = _showApproved ? _approvedVideos : _pendingVideos;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 380;
    final title = _showApproved ? 'Your Approved Videos' : 'Pending Approval';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusTabs(),
        const SizedBox(height: 12),
        if (_showApproved) _infoStrip(),
        if (_showApproved) const SizedBox(height: 16),
        if (_showApproved)
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        if (_isLoading)
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
                _showApproved ? 'No approved videos.' : 'No pending videos.',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
          )
        else
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: list.map((item) => _videoCard(item, isCompact ? width - 64 : 240)).toList(),
          ),
      ],
    );
  }

  Widget _statusTabs() {
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
            selected: _showApproved,
            onTap: () => setState(() => _showApproved = true),
          ),
          const Spacer(),
          _pillTab(
            label: 'Pending',
            selected: !_showApproved,
            onTap: () => setState(() => _showApproved = false),
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

  Widget _videoCard(_VideoItem item, double width) {
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: item.isLocalVideo
                      ? Container(
                          height: 160,
                          width: double.infinity,
                          color: const Color(0xFFF2ECF7),
                          child: const Center(
                            child: Icon(Icons.play_circle_outline, size: 56, color: Color(0xFF4A3B57)),
                          ),
                        )
                      : Image.asset(
                          item.thumbnailPath,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.approved ? const Color(0xFF20B35D) : const Color(0xFFF7D12D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.approved ? 'APPROVED' : 'PENDING',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
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
                      icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
                      onPressed: () => _deleteVideo(item),
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
                    item.approved ? Icons.check_circle_outline : Icons.access_time,
                    size: 14,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.approved ? 'Approved' : 'Awaiting Approval',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteVideo(_VideoItem item) {
    setState(() {
      if (item.approved) {
        _approvedVideos.remove(item);
      } else {
        _pendingVideos.remove(item);
      }
    });
    _deleteVideoApi(item);
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

      setState(() {
        _pendingVideos.insert(
          0,
          _VideoItem(
            mediaId: '',
            thumbnailPath: 'assets/images/notification-image4.jpg',
            approved: false,
            videoPath: picked.path,
            isLocalVideo: true,
          ),
        );
        _showApproved = false;
      });
      final token = await AuthService.getToken();
      if (token != null && token.isNotEmpty) {
        try {
          await _api.addVideo(
            token: token,
            path: picked.path,
            thumbnailPath: 'assets/images/notification-image4.jpg',
          );
          await _loadVideosFromApi();
        } catch (_) {
          await _persistVideos();
        }
      } else {
        await _persistVideos();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video added to pending approval')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to pick video. Please restart app once and try again.')),
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

  Future<void> _loadVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingRaw = prefs.getString(_pendingKey);
    final approvedRaw = prefs.getString(_approvedKey);

    List<_VideoItem> decode(String? raw) {
      if (raw == null || raw.isEmpty) return [];
      try {
        final decoded = jsonDecode(raw);
        if (decoded is! List) return [];
        return decoded
            .whereType<Map>()
            .map((e) => _VideoItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } catch (_) {
        return [];
      }
    }

    final pending = decode(pendingRaw);
    final approved = decode(approvedRaw);
    if (!mounted) return;
    setState(() {
      _pendingVideos = pending;
      _approvedVideos = approved;
    });
  }

  Future<void> _persistVideos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _pendingKey,
      jsonEncode(_pendingVideos.map((e) => e.toJson()).toList()),
    );
    await prefs.setString(
      _approvedKey,
      jsonEncode(_approvedVideos.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _loadVideosFromApi() async {
    setState(() => _isLoading = true);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        return;
      }
      final items = await _api.getVideos(token: token);
      final videos = items.map(_VideoItem.fromApi).toList();
      if (!mounted) return;
      setState(() {
        _approvedVideos = videos.where((v) => v.approved).toList();
        _pendingVideos = videos.where((v) => !v.approved).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      await _loadVideos();
    }
  }

  Future<void> _deleteVideoApi(_VideoItem item) async {
    if (item.mediaId.isEmpty) {
      await _persistVideos();
      return;
    }
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) return;
      await _api.deleteVideo(token: token, mediaId: item.mediaId);
    } catch (_) {
      // keep optimistic UI
    } finally {
      await _persistVideos();
    }
  }

  void _openVideoPlayer(_VideoItem item) {
    if (item.videoPath == null || item.videoPath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playable local video not available for this item.')),
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

class _VideoItem {
  const _VideoItem({
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

  factory _VideoItem.fromJson(Map<String, dynamic> json) {
    return _VideoItem(
      mediaId: (json['mediaId'] ?? '').toString(),
      thumbnailPath: (json['thumbnailPath'] ?? 'assets/images/notification-image4.jpg').toString(),
      approved: json['approved'] == true,
      videoPath: json['videoPath']?.toString(),
      isLocalVideo: json['isLocalVideo'] == true,
    );
  }

  factory _VideoItem.fromApi(Map<String, dynamic> json) {
    final path = (json['path'] ?? '').toString();
    final thumb = (json['thumbnailPath'] ?? '').toString();
    return _VideoItem(
      mediaId: (json['mediaId'] ?? '').toString(),
      thumbnailPath: thumb.isEmpty ? 'assets/images/notification-image4.jpg' : thumb,
      approved: (json['status'] ?? '').toString() == 'approved',
      videoPath: path,
      isLocalVideo: path.startsWith('/'),
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
      final controller = VideoPlayerController.file(File(widget.videoPath));
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
        _initError = e.toString();
        _isInitializing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video player initialization failed. Please restart the app fully and try again.'),
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
