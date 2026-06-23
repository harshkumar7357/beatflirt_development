import 'dart:convert';
import 'dart:io';

import 'package:beatflirt/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// =============================================================================
// 1. DATA MODELS
// =============================================================================

class PhotoItem {
  final String id;
  final String imageUrl;
  final bool isApproved;
  final bool isMain;
  final File? localFile;

  const PhotoItem({
    required this.id,
    required this.imageUrl,
    required this.isApproved,
    this.isMain = false,
    this.localFile,
  });

  factory PhotoItem.fromJson(Map<String, dynamic> json) {
    String path = (json['profile_image'] ?? json['image'] ?? '')
        .toString()
        .trim();

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

    if (path.endsWith('/assets/images/') ||
        path.endsWith('/assets/images') ||
        path.isEmpty) {
      path = '';
    }

    return PhotoItem(
      id: (json['id'] ?? '').toString(),
      imageUrl: path,
      isApproved: (json['status'] ?? '').toString() == '1',
      isMain: (json['set_profile'] ?? '').toString() == '1',
    );
  }
}

// =============================================================================
// 2. STATE & NOTIFIER
// =============================================================================

class PhotosTabState {
  final bool showApproved;
  final bool isLoading;
  final List<PhotoItem> pendingPhotos;
  final List<PhotoItem> approvedPhotos;

  const PhotosTabState({
    this.showApproved = true,
    this.isLoading = false,
    this.pendingPhotos = const [],
    this.approvedPhotos = const [],
  });

  PhotosTabState copyWith({
    bool? showApproved,
    bool? isLoading,
    List<PhotoItem>? pendingPhotos,
    List<PhotoItem>? approvedPhotos,
  }) {
    return PhotosTabState(
      showApproved: showApproved ?? this.showApproved,
      isLoading: isLoading ?? this.isLoading,
      pendingPhotos: pendingPhotos ?? this.pendingPhotos,
      approvedPhotos: approvedPhotos ?? this.approvedPhotos,
    );
  }
}

class PhotosTabNotifier extends Notifier<PhotosTabState> {
  static const String approvedUrl =
      'https://app.beatflirtevent.com/App/user/signle_user_profile_approve_image';

  static const String pendingUrl =
      'https://app.beatflirtevent.com/App/user/signle_user_profile_pending_image';

  static const String uploadUrl =
      'https://app.beatflirtevent.com/App/upload/imageupload';

  static const String linkProfileImageUrl =
      'https://app.beatflirtevent.com/App/user/upload_profile_image';

  static const String deleteProfileImageUrl =
      'https://app.beatflirtevent.com/App/user/delete_profile_image';

  @override
  PhotosTabState build() {
    Future.microtask(fetchPhotos);
    return const PhotosTabState();
  }

  void toggleTab(bool showApproved) {
    state = state.copyWith(showApproved: showApproved);
  }

  Future<void> fetchPhotos() async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'access-token': token,
      };

      debugPrint('[PhotosTab] GET approvedUrl: $approvedUrl');

      final approvedRes = await http.get(
        Uri.parse(approvedUrl),
        headers: headers,
      );

      debugPrint(
        '[PhotosTab] GET approvedRes status: ${approvedRes.statusCode}',
      );
      debugPrint('[PhotosTab] GET approvedRes body: ${approvedRes.body}');

      debugPrint('[PhotosTab] GET pendingUrl: $pendingUrl');

      final pendingRes = await http.get(
        Uri.parse(pendingUrl),
        headers: headers,
      );

      debugPrint(
        '[PhotosTab] GET pendingRes status: ${pendingRes.statusCode}',
      );
      debugPrint('[PhotosTab] GET pendingRes body: ${pendingRes.body}');

      List<PhotoItem> approvedList = [];
      List<PhotoItem> pendingList = [];

      if (approvedRes.statusCode == 200) {
        final data = jsonDecode(approvedRes.body);

        if (data is Map && data['data'] is List) {
          approvedList = (data['data'] as List)
              .whereType<Map>()
              .map((e) => PhotoItem.fromJson(Map<String, dynamic>.from(e)))
              .where((p) => p.imageUrl.isNotEmpty)
              .toList();
        }
      }

      if (pendingRes.statusCode == 200) {
        final data = jsonDecode(pendingRes.body);

        if (data is Map && data['data'] is List) {
          pendingList = (data['data'] as List)
              .whereType<Map>()
              .map((e) => PhotoItem.fromJson(Map<String, dynamic>.from(e)))
              .where((p) => p.imageUrl.isNotEmpty)
              .toList();
        }
      }

      // Preserve local uploads that are still visible in UI
      final currentLocals = state.pendingPhotos
          .where((p) => p.localFile != null)
          .toList();

      state = state.copyWith(
        isLoading: false,
        approvedPhotos: approvedList,
        pendingPhotos: [...currentLocals, ...pendingList],
      );
    } catch (e) {
      debugPrint('[PhotosTab] Fetch error: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> uploadPhoto(XFile picked) async {
    final newItem = PhotoItem(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      imageUrl: picked.path,
      isApproved: false,
      localFile: File(picked.path),
    );

    // Optimistic UI update
    state = state.copyWith(
      pendingPhotos: [newItem, ...state.pendingPhotos],
      showApproved: false,
    );

    try {
      final bytes = await picked.readAsBytes();
      final base64String = base64Encode(bytes);

      final fileName = picked.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      final mimeExtension = extension == 'png' ? 'png' : 'jpeg';
      final dataUri = 'data:image/$mimeExtension;base64,$base64String';

      final token = await AuthService.getToken();

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        if (token != null && token.isNotEmpty) 'access-token': token,
      };

      debugPrint('[PhotosTab] Uploading base64 to $uploadUrl...');

      final response = await http.post(
        Uri.parse(uploadUrl),
        body: jsonEncode({'image': dataUri}),
        headers: headers,
      );

      debugPrint('[PhotosTab] Upload response status: ${response.statusCode}');
      debugPrint('[PhotosTab] Upload response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final imageName = body is Map ? body['data']?.toString() : null;

        debugPrint('[PhotosTab] Upload returned imageName: $imageName');

        if (imageName != null && imageName.isNotEmpty) {
          debugPrint('[PhotosTab] Linking profile image: $imageName');

          final linkRes = await http.post(
            Uri.parse(linkProfileImageUrl),
            headers: headers,
            body: jsonEncode({'profile_image': imageName}),
          );

          debugPrint('[PhotosTab] Linking response: ${linkRes.body}');
        }

        await fetchPhotos();
      } else {
        state = state.copyWith(
          pendingPhotos: state.pendingPhotos
              .where((p) => p.id != newItem.id)
              .toList(),
        );
      }
    } catch (e) {
      debugPrint('[PhotosTab] Upload Error: $e');

      state = state.copyWith(
        pendingPhotos: state.pendingPhotos
            .where((p) => p.id != newItem.id)
            .toList(),
      );
    }
  }

  Future<void> removePhoto(PhotoItem item) async {
    final originalApproved = state.approvedPhotos;
    final originalPending = state.pendingPhotos;

    if (item.isApproved) {
      state = state.copyWith(
        approvedPhotos: state.approvedPhotos
            .where((p) => p.id != item.id)
            .toList(),
      );
    } else {
      state = state.copyWith(
        pendingPhotos: state.pendingPhotos
            .where((p) => p.id != item.id)
            .toList(),
      );
    }

    if (item.id.startsWith('local_')) {
      return;
    }

    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) return;

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'access-token': token,
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(deleteProfileImageUrl),
        headers: headers,
        body: jsonEncode({'image_id': item.id}),
      );

      debugPrint('[PhotosTab] Delete response: ${response.body}');

      if (response.statusCode != 200) {
        state = state.copyWith(
          approvedPhotos: originalApproved,
          pendingPhotos: originalPending,
        );
      }
    } catch (e) {
      debugPrint('[PhotosTab] Delete error: $e');

      state = state.copyWith(
        approvedPhotos: originalApproved,
        pendingPhotos: originalPending,
      );
    }
  }
}

final photosTabProvider =
    NotifierProvider<PhotosTabNotifier, PhotosTabState>(
  PhotosTabNotifier.new,
);

// =============================================================================
// 3. UI SCREEN
// =============================================================================

class MyProfilePhotosTab extends ConsumerStatefulWidget {
  const MyProfilePhotosTab({super.key});

  @override
  ConsumerState<MyProfilePhotosTab> createState() => _MyProfilePhotosTabState();
}

class _MyProfilePhotosTabState extends ConsumerState<MyProfilePhotosTab> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(photosTabProvider);
    final notifier = ref.read(photosTabProvider.notifier);

    final currentList =
        state.showApproved ? state.approvedPhotos : state.pendingPhotos;

    final sectionTitle =
        state.showApproved ? 'Approved Photos' : 'Pending Approval';

    return RefreshIndicator(
      onRefresh: () => notifier.fetchPhotos(),
      color: Colors.pink,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sub Tabs Toggle
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF240024),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  _statusPill(
                    'Approved',
                    state.showApproved,
                    () => notifier.toggleTab(true),
                  ),
                  _statusPill(
                    'Pending',
                    !state.showApproved,
                    () => notifier.toggleTab(false),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildInfoStrip(),

            const SizedBox(height: 20),

            Text(
              sectionTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F1047),
              ),
            ),

            const SizedBox(height: 12),

            if (state.showApproved) _buildAddButton(notifier),

            const SizedBox(height: 20),

            if (state.isLoading && currentList.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: Colors.pink),
                ),
              )
            else if (currentList.isEmpty)
              _buildEmptyState(sectionTitle)
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: currentList
                    .map((item) => _buildPhotoCard(item, notifier))
                    .toList(),
              ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _statusPill(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF2D87) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoStrip() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5DDF2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: Color(0xFF490040)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Only high-quality images are approved. Avoid children, animals, weapons, or contact info.',
              style: TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(PhotosTabNotifier notifier) {
    return ElevatedButton.icon(
      onPressed: () => _handleImagePick(notifier),
      icon: const Icon(Icons.add, size: 14),
      label: const Text(
        'Add Photo',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF19001F),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget _buildEmptyState(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              'No $title available',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(PhotoItem item, PhotosTabNotifier notifier) {
    final cardWidth = (MediaQuery.of(context).size.width - 44) / 2;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E0F2)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: item.localFile != null
                    ? Image.file(
                        item.localFile!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        item.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey[100],
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: GestureDetector(
                  onTap: () => notifier.removePhoto(item),
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFFFF4473),
                    child: Icon(
                      Icons.delete_outline,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(
                  item.isApproved
                      ? Icons.check_circle
                      : Icons.access_time_filled,
                  size: 13,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.isApproved
                        ? (item.isMain ? 'Profile Pic' : 'Approved')
                        : 'Awaiting Approval',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImagePick(PhotosTabNotifier notifier) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (c) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(c, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(c, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      final picked = await _picker.pickImage(source: source);

      if (picked != null) {
        await notifier.uploadPhoto(picked);
      }
    }
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// // =============================================================================
// // 1. DATA MODELS
// // =============================================================================

// class PhotoItem {
//   final String id;
//   final String imageUrl;
//   final bool isApproved;
//   final bool isMain;
//   final File? localFile;

//   PhotoItem({
//     required this.id,
//     required this.imageUrl,
//     required this.isApproved,
//     this.isMain = false,
//     this.localFile,
//   });

//   factory PhotoItem.fromJson(Map<String, dynamic> json) {
//     String path = (json['profile_image'] ?? json['image'] ?? '').toString().trim();
//     if (path.contains('public_html/app.beatflirtevent.com/')) {
//       path = path.replaceFirst(
//         '/home/beatflirtevent/public_html/app.beatflirtevent.com/',
//         'https://app.beatflirtevent.com/',
//       );
//     }
    
//     if (!path.startsWith('http') && !path.startsWith('/') && path.isNotEmpty) {
//       if (path.startsWith('assets/images/')) {
//         path = 'https://app.beatflirtevent.com/$path';
//       } else {
//         path = 'https://app.beatflirtevent.com/assets/images/$path';
//       }
//     } else if (path.startsWith('/assets/images/')) {
//       path = 'https://app.beatflirtevent.com$path';
//     }

//     if (path.endsWith('/assets/images/') || path.endsWith('/assets/images') || path.isEmpty) {
//       path = '';
//     }

//     return PhotoItem(
//       id: (json['id'] ?? '').toString(),
//       imageUrl: path,
//       isApproved: (json['status'] ?? '').toString() == "1",
//       isMain: (json['set_profile'] ?? '').toString() == "1",
//     );
//   }
// }

// // =============================================================================
// // 2. STATE & NOTIFIER (All Logic Stays Here)
// // =============================================================================

// class PhotosTabState {
//   final bool showApproved;
//   final bool isLoading;
//   final List<PhotoItem> pendingPhotos;
//   final List<PhotoItem> approvedPhotos;

//   const PhotosTabState({
//     this.showApproved = true,
//     this.isLoading = false,
//     this.pendingPhotos = const [],
//     this.approvedPhotos = const [],
//   });

//   PhotosTabState copyWith({
//     bool? showApproved,
//     bool? isLoading,
//     List<PhotoItem>? pendingPhotos,
//     List<PhotoItem>? approvedPhotos,
//   }) {
//     return PhotosTabState(
//       showApproved: showApproved ?? this.showApproved,
//       isLoading: isLoading ?? this.isLoading,
//       pendingPhotos: pendingPhotos ?? this.pendingPhotos,
//       approvedPhotos: approvedPhotos ?? this.approvedPhotos,
//     );
//   }
// }

// class PhotosTabNotifier extends StateNotifier<PhotosTabState> {
//   PhotosTabNotifier() : super(const PhotosTabState()) {
//     fetchPhotos();
//   }

//   final String approvedUrl =
//       "https://app.beatflirtevent.com/App/user/signle_user_profile_approve_image";
//   final String pendingUrl =
//       "https://app.beatflirtevent.com/App/user/signle_user_profile_pending_image";
//   final String uploadUrl =
//       "https://app.beatflirtevent.com/App/upload/imageupload";

//   void toggleTab(bool showApproved) {
//     state = state.copyWith(showApproved: showApproved);
//   }

//   Future<void> fetchPhotos() async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) {
//         state = state.copyWith(isLoading: false);
//         return;
//       }
//       final headers = {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//         'access-token': token,
//       };
//       debugPrint('[PhotosTab] GET approvedUrl: $approvedUrl');
//       final approvedRes = await http.get(
//         Uri.parse(approvedUrl),
//         headers: headers,
//       );
//       debugPrint('[PhotosTab] GET approvedRes status: ${approvedRes.statusCode}');
//       debugPrint('[PhotosTab] GET approvedRes body: ${approvedRes.body}');

//       debugPrint('[PhotosTab] GET pendingUrl: $pendingUrl');
//       final pendingRes = await http.get(
//         Uri.parse(pendingUrl),
//         headers: headers,
//       );
//       debugPrint('[PhotosTab] GET pendingRes status: ${pendingRes.statusCode}');
//       debugPrint('[PhotosTab] GET pendingRes body: ${pendingRes.body}');

//       List<PhotoItem> approvedList = [];
//       List<PhotoItem> pendingList = [];

//       if (approvedRes.statusCode == 200) {
//         final data = json.decode(approvedRes.body);
//         if (data['data'] != null && data['data'] is List) {
//           approvedList = (data['data'] as List)
//               .map((e) => PhotoItem.fromJson(e))
//               .where((p) => p.imageUrl.isNotEmpty)
//               .toList();
//         }
//       }
//       if (pendingRes.statusCode == 200) {
//         final data = json.decode(pendingRes.body);
//         if (data['data'] != null && data['data'] is List) {
//           pendingList = (data['data'] as List)
//               .map((e) => PhotoItem.fromJson(e))
//               .where((p) => p.imageUrl.isNotEmpty)
//               .toList();
//         }
//       }

//       // Preserve local uploads that are still in progress UI
//       final currentLocals = state.pendingPhotos
//           .where((p) => p.localFile != null)
//           .toList();

//       state = state.copyWith(
//         isLoading: false,
//         approvedPhotos: approvedList,
//         pendingPhotos: [...currentLocals, ...pendingList],
//       );
//     } catch (e) {
//       state = state.copyWith(isLoading: false);
//     }
//   }

//   Future<void> uploadPhoto(XFile picked) async {
//     // 1. Optimistic UI: Show the photo immediately in Pending
//     final newItem = PhotoItem(
//       id: "local_${DateTime.now().millisecondsSinceEpoch}",
//       imageUrl: picked.path,
//       isApproved: false,
//       localFile: File(picked.path),
//     );

//     state = state.copyWith(
//       pendingPhotos: [newItem, ...state.pendingPhotos],
//       showApproved: false,
//     );

//     try {
//       // 2. Prepare Base64
//       final bytes = await picked.readAsBytes();
//       final base64String = base64Encode(bytes);
//       final fileName = picked.path.split('/').last;
//       final extension = fileName.split('.').last.toLowerCase();
//       final dataUri = "data:image/$extension;base64,$base64String";

//       // 3. API Call
//       final token = await AuthService.getToken();
//       final headers = {
//         "Content-Type": "application/json",
//         if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//         if (token != null && token.isNotEmpty) 'access-token': token,
//       };
      
//       debugPrint('[PhotosTab] Uploading base64 to $uploadUrl...');
//       final response = await http.post(
//         Uri.parse(uploadUrl),
//         body: json.encode({"image": dataUri}),
//         headers: headers,
//       );
//       debugPrint('[PhotosTab] Upload response status: ${response.statusCode}');
//       debugPrint('[PhotosTab] Upload response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);
//         final imageName = body['data']?.toString();
//         debugPrint('[PhotosTab] Upload returned imageName: $imageName');
        
//         if (imageName != null) {
//           final linkUrl = "https://app.beatflirtevent.com/App/user/upload_profile_image";
//           debugPrint('[PhotosTab] Linking profile image: $imageName');
//           final linkRes = await http.post(
//             Uri.parse(linkUrl),
//             headers: headers,
//             body: json.encode({"profile_image": imageName}),
//           );
//           debugPrint('[PhotosTab] Linking response: ${linkRes.body}');
//         }

//         // Success: Refresh data to get real server data
//         await fetchPhotos();
//       } else {
//         // Remove local if failed
//         state = state.copyWith(
//           pendingPhotos: state.pendingPhotos
//               .where((p) => p.id != newItem.id)
//               .toList(),
//         );
//       }
//     } catch (e) {
//       debugPrint("Upload Error: $e");
//       state = state.copyWith(
//         pendingPhotos: state.pendingPhotos
//             .where((p) => p.id != newItem.id)
//             .toList(),
//       );
//     }
//   }

//   Future<void> removePhoto(PhotoItem item) async {
//     final originalApproved = state.approvedPhotos;
//     final originalPending = state.pendingPhotos;

//     if (item.isApproved) {
//       state = state.copyWith(
//         approvedPhotos: state.approvedPhotos
//             .where((p) => p.id != item.id)
//             .toList(),
//       );
//     } else {
//       state = state.copyWith(
//         pendingPhotos: state.pendingPhotos
//             .where((p) => p.id != item.id)
//             .toList(),
//       );
//     }

//     if (item.id.startsWith('local_')) {
//       return;
//     }

//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) return;
//       final headers = {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//         'access-token': token,
//         'Content-Type': 'application/json',
//       };
//       final response = await http.post(
//         Uri.parse("https://app.beatflirtevent.com/App/user/delete_profile_image"),
//         headers: headers,
//         body: json.encode({"id": item.id}),
//       );
//       debugPrint('[PhotosTab] Delete response: ${response.body}');
//       if (response.statusCode != 200) {
//         state = state.copyWith(
//           approvedPhotos: originalApproved,
//           pendingPhotos: originalPending,
//         );
//       }
//     } catch (e) {
//       debugPrint('[PhotosTab] Delete error: $e');
//       state = state.copyWith(
//         approvedPhotos: originalApproved,
//         pendingPhotos: originalPending,
//       );
//     }
//   }
// }

// final photosTabProvider =
//     StateNotifierProvider<PhotosTabNotifier, PhotosTabState>((ref) {
//       return PhotosTabNotifier();
//     });

// // =============================================================================
// // 3. UI SCREEN
// // =============================================================================

// class MyProfilePhotosTab extends ConsumerStatefulWidget {
//   const MyProfilePhotosTab({super.key});

//   @override
//   ConsumerState<MyProfilePhotosTab> createState() => _MyProfilePhotosTabState();
// }

// class _MyProfilePhotosTabState extends ConsumerState<MyProfilePhotosTab> {
//   final ImagePicker _picker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(photosTabProvider);
//     final notifier = ref.read(photosTabProvider.notifier);
//     final currentList = state.showApproved
//         ? state.approvedPhotos
//         : state.pendingPhotos;
//     final sectionTitle = state.showApproved
//         ? 'Approved Photos'
//         : 'Pending Approval';

//     return RefreshIndicator(
//       onRefresh: () => notifier.fetchPhotos(),
//       color: Colors.pink,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Sub Tabs Toggle
//             Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF240024),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: const EdgeInsets.all(3),
//               child: Row(
//                 children: [
//                   _statusPill(
//                     'Approved',
//                     state.showApproved,
//                     () => notifier.toggleTab(true),
//                   ),
//                   _statusPill(
//                     'Pending',
//                     !state.showApproved,
//                     () => notifier.toggleTab(false),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildInfoStrip(),
//             const SizedBox(height: 20),

//             // Section Title
//             Text(
//               sectionTitle,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2F1047),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Refined Add Button
//             if (state.showApproved) _buildAddButton(notifier),

//             const SizedBox(height: 20),

//             // Grid Content
//             if (state.isLoading && currentList.isEmpty)
//               const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(40),
//                   child: CircularProgressIndicator(color: Colors.pink),
//                 ),
//               )
//             else if (currentList.isEmpty)
//               _buildEmptyState(sectionTitle)
//             else
//               Wrap(
//                 spacing: 12,
//                 runSpacing: 12,
//                 children: currentList
//                     .map((item) => _buildPhotoCard(item, notifier))
//                     .toList(),
//               ),
//             const SizedBox(height: 60),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _statusPill(String label, bool isSelected, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: isSelected ? const Color(0xFFFF2D87) : Colors.transparent,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 13,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoStrip() {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFBF8FF),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: const Color(0xFFE5DDF2)),
//       ),
//       child: const Row(
//         children: [
//           Icon(Icons.info_outline, size: 18, color: Color(0xFF490040)),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               'Only high-quality images are approved. Avoid children, animals, weapons, or contact info.',
//               style: TextStyle(fontSize: 11, color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddButton(PhotosTabNotifier notifier) {
//     return ElevatedButton.icon(
//       onPressed: () => _handleImagePick(notifier),
//       icon: const Icon(Icons.add, size: 14),
//       label: const Text(
//         'Add Photo',
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF19001F),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       ),
//     );
//   }

//   Widget _buildEmptyState(String title) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 40),
//         child: Column(
//           children: [
//             const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
//             const SizedBox(height: 10),
//             Text(
//               "No $title available",
//               style: const TextStyle(color: Colors.grey, fontSize: 13),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPhotoCard(PhotoItem item, PhotosTabNotifier notifier) {
//     final cardWidth = (MediaQuery.of(context).size.width - 44) / 2;
//     return Container(
//       width: cardWidth,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE8E0F2)),
//       ),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//                 child: item.localFile != null
//                     ? Image.file(
//                         item.localFile!,
//                         height: 150,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                     : Image.network(
//                         item.imageUrl,
//                         height: 150,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (c, e, s) =>
//                             Container(height: 150, color: Colors.grey[100]),
//                       ),
//               ),
//               Positioned(
//                 right: 6,
//                 top: 6,
//                 child: GestureDetector(
//                   onTap: () => notifier.removePhoto(item),
//                   child: const CircleAvatar(
//                     radius: 12,
//                     backgroundColor: Color(0xFFFF4473),
//                     child: Icon(
//                       Icons.delete_outline,
//                       size: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Icon(
//                   item.isApproved
//                       ? Icons.check_circle
//                       : Icons.access_time_filled,
//                   size: 13,
//                   color: Colors.black54,
//                 ),
//                 const SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     item.isApproved
//                         ? (item.isMain ? 'Profile Pic' : 'Approved')
//                         : 'Awaiting Approval',
//                     style: const TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _handleImagePick(PhotosTabNotifier notifier) async {
//     final source = await showModalBottomSheet<ImageSource>(
//       context: context,
//       builder: (c) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Gallery'),
//               onTap: () => Navigator.pop(c, ImageSource.gallery),
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Camera'),
//               onTap: () => Navigator.pop(c, ImageSource.camera),
//             ),
//           ],
//         ),
//       ),
//     );
//     if (source != null) {
//       final picked = await _picker.pickImage(source: source);
//       if (picked != null) {
//         notifier.uploadPhoto(picked);
//       }
//     }
//   }
// }

// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:image_picker/image_picker.dart';
// // // Assuming these exist in your project based on your first snippet
// // // import 'package:beatflirt/core/services/auth_services.dart'; 

// // // ==========================================
// // // 1. DATA MODELS
// // // ==========================================

// // class PhotoItem {
// //   final String id;
// //   final String imageUrl;
// //   final bool isApproved;
// //   final bool isMain;
// //   final File? localFile;

// //   PhotoItem({
// //     required this.id, required this.imageUrl, required this.isApproved,
// //     this.isMain = false, this.localFile,
// //   });

// //   factory PhotoItem.fromJson(Map<String, dynamic> json) {
// //     return PhotoItem(
// //       id: (json['id'] ?? '').toString(),
// //       imageUrl: (json['profile_image'] ?? '').toString(),
// //       isApproved: (json['status'] ?? '').toString() == "1",
// //       isMain: (json['set_profile'] ?? '').toString() == "1",
// //     );
// //   }
// // }

// // // ==========================================
// // // 2. STATE & NOTIFIER (PERSISTENT)
// // // ==========================================

// // class PhotosTabState {
// //   final bool showApproved;
// //   final bool isLoading;
// //   final List<PhotoItem> pendingPhotos;
// //   final List<PhotoItem> approvedPhotos;

// //   const PhotosTabState({
// //     this.showApproved = true, this.isLoading = false,
// //     this.pendingPhotos = const [], this.approvedPhotos = const [],
// //   });

// //   PhotosTabState copyWith({bool? showApproved, bool? isLoading, List<PhotoItem>? pendingPhotos, List<PhotoItem>? approvedPhotos}) {
// //     return PhotosTabState(
// //       showApproved: showApproved ?? this.showApproved,
// //       isLoading: isLoading ?? this.isLoading,
// //       pendingPhotos: pendingPhotos ?? this.pendingPhotos,
// //       approvedPhotos: approvedPhotos ?? this.approvedPhotos,
// //     );
// //   }
// // }

// // class PhotosTabNotifier extends StateNotifier<PhotosTabState> {
// //   PhotosTabNotifier() : super(const PhotosTabState());

// //   final String approvedUrl = "https://app.beatflirtevent.com/App/user/signle_user_profile_approve_image";
// //   final String pendingUrl = "https://app.beatflirtevent.com/App/user/signle_user_profile_pending_image";

// //   void toggleTab(bool showApproved) {
// //     state = state.copyWith(showApproved: showApproved);
// //   }

// //   Future<void> fetchPhotos() async {
// //     state = state.copyWith(isLoading: true);
// //     try {
// //       // NOTE: You should pass your Bearer token in headers here
// //       // final token = await AuthService.getToken();
// //       final headers = { 'Content-Type': 'application/json' }; 

// //       final approvedRes = await http.get(Uri.parse(approvedUrl), headers: headers);
// //       final pendingRes = await http.get(Uri.parse(pendingUrl), headers: headers);
      
// //       List<PhotoItem> approvedList = [];
// //       List<PhotoItem> pendingList = [];

// //       if (approvedRes.statusCode == 200) {
// //         final data = json.decode(approvedRes.body);
// //         if (data['data'] != null && data['data'] is List) {
// //           approvedList = (data['data'] as List).map((e) => PhotoItem.fromJson(e)).toList();
// //         }
// //       }
// //       if (pendingRes.statusCode == 200) {
// //         final data = json.decode(pendingRes.body);
// //         if (data['data'] != null && data['data'] is List) {
// //           pendingList = (data['data'] as List).map((e) => PhotoItem.fromJson(e)).toList();
// //         }
// //       }

// //       // Merge logic: Keep local pending photos that aren't on the server yet
// //       final localPending = state.pendingPhotos.where((p) => p.localFile != null).toList();

// //       state = state.copyWith(
// //         isLoading: false, 
// //         approvedPhotos: approvedList, 
// //         pendingPhotos: [...localPending, ...pendingList]
// //       );
// //     } catch (e) {
// //       state = state.copyWith(isLoading: false);
// //     }
// //   }

// //   void addLocalPhoto(XFile picked) {
// //     final newItem = PhotoItem(
// //       id: DateTime.now().millisecondsSinceEpoch.toString(),
// //       imageUrl: picked.path, isApproved: false, localFile: File(picked.path),
// //     );
// //     state = state.copyWith(
// //       pendingPhotos: [newItem, ...state.pendingPhotos], 
// //       showApproved: false
// //     );
// //     // Trigger API upload here...
// //   }

// //   void removePhoto(PhotoItem item) {
// //     if (item.isApproved) {
// //       state = state.copyWith(approvedPhotos: state.approvedPhotos.where((p) => p.id != item.id).toList());
// //     } else {
// //       state = state.copyWith(pendingPhotos: state.pendingPhotos.where((p) => p.id != item.id).toList());
// //     }
// //   }
// // }

// // final photosTabProvider = StateNotifierProvider<PhotosTabNotifier, PhotosTabState>((ref) => PhotosTabNotifier());

// // // ==========================================
// // // 3. UI SCREEN
// // // ==========================================

// // class MyProfilePhotosTab extends ConsumerStatefulWidget {
// //   const MyProfilePhotosTab({super.key});
// //   @override
// //   ConsumerState<MyProfilePhotosTab> createState() => _MyProfilePhotosTabState();
// // }

// // class _MyProfilePhotosTabState extends ConsumerState<MyProfilePhotosTab> {
// //   final ImagePicker _picker = ImagePicker();

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       ref.read(photosTabProvider.notifier).fetchPhotos();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final state = ref.watch(photosTabProvider);
// //     final notifier = ref.read(photosTabProvider.notifier);
// //     final currentList = state.showApproved ? state.approvedPhotos : state.pendingPhotos;
// //     final sectionTitle = state.showApproved ? 'Approved Photos' : 'Pending Approval';

// //     return RefreshIndicator(
// //       onRefresh: () => notifier.fetchPhotos(),
// //       color: Colors.pink,
// //       child: SingleChildScrollView(
// //         physics: const AlwaysScrollableScrollPhysics(),
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // COMPACT TABS
// //             Container(
// //               height: 40, 
// //               decoration: BoxDecoration(color: const Color(0xFF240024), borderRadius: BorderRadius.circular(30)),
// //               padding: const EdgeInsets.all(3),
// //               child: Row(children: [
// //                 _statusPill('Approved', state.showApproved, () => notifier.toggleTab(true)),
// //                 _statusPill('Pending', !state.showApproved, () => notifier.toggleTab(false)),
// //               ]),
// //             ),
// //             const SizedBox(height: 16),
// //             _buildInfoStrip(),
// //             const SizedBox(height: 24),
            
// //             // TITLE
// //             Text(sectionTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2F1047))),
// //             const SizedBox(height: 12),
            
// //             // COMPACT ADD BUTTON ON NEW LINE
// //             if (state.showApproved) _buildAddButton(),
            
// //             const SizedBox(height: 24),
            
// //             // GRID CONTENT
// //             if (state.isLoading && currentList.isEmpty)
// //               const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: Colors.pink)))
// //             else if (currentList.isEmpty)
// //               _buildEmptyState(sectionTitle)
// //             else
// //               Wrap(
// //                 spacing: 12, runSpacing: 12,
// //                 children: currentList.map((item) => _buildPhotoCard(item)).toList(),
// //               ),
// //             const SizedBox(height: 60),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _statusPill(String label, bool isSelected, VoidCallback onTap) {
// //     return Expanded(
// //       child: GestureDetector(
// //         onTap: onTap,
// //         child: Container(
// //           alignment: Alignment.center,
// //           decoration: BoxDecoration(color: isSelected ? const Color(0xFFFF2D87) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
// //           child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInfoStrip() {
// //     return Container(
// //       padding: const EdgeInsets.all(10),
// //       decoration: BoxDecoration(color: const Color(0xFFFBF8FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5DDF2))),
// //       child: const Row(children: [
// //         Icon(Icons.info_outline, size: 18, color: Color(0xFF490040)),
// //         SizedBox(width: 8),
// //         Expanded(child: Text('Only high-quality images are approved. Avoid children, animals, weapons, or contact info.', style: TextStyle(fontSize: 11, color: Colors.black87))),
// //       ]),
// //     );
// //   }

// //   Widget _buildAddButton() {
// //     return ElevatedButton.icon(
// //       onPressed: _addPhoto, 
// //       icon: const Icon(Icons.add, size: 14), 
// //       label: const Text('Add Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
// //       style: ElevatedButton.styleFrom(
// //         backgroundColor: const Color(0xFF19001F), 
// //         foregroundColor: Colors.white, 
// //         elevation: 0,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState(String title) {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 40), 
// //         child: Column(children: [
// //           const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
// //           const SizedBox(height: 10), 
// //           Text("No $title available", style: const TextStyle(color: Colors.grey, fontSize: 13))
// //         ])
// //       )
// //     );
// //   }

// //   Widget _buildPhotoCard(PhotoItem item) {
// //     final cardWidth = (MediaQuery.of(context).size.width - 44) / 2;
// //     return Container(
// //       width: cardWidth,
// //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8E0F2))),
// //       child: Column(children: [
// //         Stack(children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
// //             child: item.localFile != null 
// //               ? Image.file(item.localFile!, height: 150, width: double.infinity, fit: BoxFit.cover) 
// //               : Image.network(item.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 150, color: Colors.grey[100])),
// //           ),
// //           Positioned(right: 6, top: 6, child: GestureDetector(onTap: () => ref.read(photosTabProvider.notifier).removePhoto(item), child: const CircleAvatar(radius: 12, backgroundColor: Color(0xFFFF4473), child: Icon(Icons.delete_outline, size: 14, color: Colors.white)))),
// //         ]),
// //         Padding(padding: const EdgeInsets.all(8), child: Row(children: [Icon(item.isApproved ? Icons.check_circle : Icons.access_time_filled, size: 13, color: Colors.black54), const SizedBox(width: 4), Expanded(child: Text(item.isApproved ? (item.isMain ? 'Profile Pic' : 'Approved') : 'Awaiting Approval', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))])),
// //       ]),
// //     );
// //   }


// //   Future<void> _addPhoto() async {
// //     final source = await showModalBottomSheet<ImageSource>(context: context, builder: (c) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () => Navigator.pop(c, ImageSource.gallery)), ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Camera'), onTap: () => Navigator.pop(c, ImageSource.camera))])));
// //     if (source != null) {
// //       final picked = await _picker.pickImage(source: source);
// //       if (picked != null) ref.read(photosTabProvider.notifier).addLocalPhoto(picked);
// //     }
// //   }
// // }

// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:image_picker/image_picker.dart';

// // // // =============================================================================
// // // // 1. DATA MODELS
// // // // =============================================================================

// // // class PhotoItem {
// // //   final String id;
// // //   final String imageUrl;
// // //   final bool isApproved;
// // //   final bool isMain;
// // //   final File? localFile;

// // //   PhotoItem({
// // //     required this.id, required this.imageUrl, required this.isApproved,
// // //     this.isMain = false, this.localFile,
// // //   });

// // //   factory PhotoItem.fromJson(Map<String, dynamic> json) {
// // //     return PhotoItem(
// // //       id: (json['id'] ?? '').toString(),
// // //       imageUrl: (json['profile_image'] ?? '').toString(),
// // //       isApproved: (json['status'] ?? '').toString() == "1",
// // //       isMain: (json['set_profile'] ?? '').toString() == "1",
// // //     );
// // //   }
// // // }

// // // // =============================================================================
// // // // 2. STATE & NOTIFIER (PERSISTENT STATE)
// // // // =============================================================================

// // // class PhotosTabState {
// // //   final bool showApproved;
// // //   final bool isLoading;
// // //   final List<PhotoItem> pendingPhotos;
// // //   final List<PhotoItem> approvedPhotos;

// // //   const PhotosTabState({
// // //     this.showApproved = true, this.isLoading = false,
// // //     this.pendingPhotos = const [], this.approvedPhotos = const [],
// // //   });

// // //   PhotosTabState copyWith({bool? showApproved, bool? isLoading, List<PhotoItem>? pendingPhotos, List<PhotoItem>? approvedPhotos}) {
// // //     return PhotosTabState(
// // //       showApproved: showApproved ?? this.showApproved,
// // //       isLoading: isLoading ?? this.isLoading,
// // //       pendingPhotos: pendingPhotos ?? this.pendingPhotos,
// // //       approvedPhotos: approvedPhotos ?? this.approvedPhotos,
// // //     );
// // //   }
// // // }

// // // class PhotosTabNotifier extends StateNotifier<PhotosTabState> {
// // //   PhotosTabNotifier() : super(const PhotosTabState()) {
// // //     fetchPhotos(); // Auto-load on startup
// // //   }

// // //   final String approvedUrl = "https://app.beatflirtevent.com/App/user/signle_user_profile_approve_image";
// // //   final String pendingUrl = "https://app.beatflirtevent.com/App/user/signle_user_profile_pending_image";

// // //   void toggleTab(bool showApproved) {
// // //     state = state.copyWith(showApproved: showApproved);
// // //   }

// // //   Future<void> fetchPhotos() async {
// // //     state = state.copyWith(isLoading: true);
// // //     try {
// // //       final approvedRes = await http.get(Uri.parse(approvedUrl));
// // //       final pendingRes = await http.get(Uri.parse(pendingUrl));
      
// // //       List<PhotoItem> approvedList = [];
// // //       List<PhotoItem> pendingList = [];

// // //       if (approvedRes.statusCode == 200) {
// // //         final data = json.decode(approvedRes.body);
// // //         if (data['data'] != null) approvedList = (data['data'] as List).map((e) => PhotoItem.fromJson(e)).toList();
// // //       }
// // //       if (pendingRes.statusCode == 200) {
// // //         final data = json.decode(pendingRes.body);
// // //         if (data['data'] != null) pendingList = (data['data'] as List).map((e) => PhotoItem.fromJson(e)).toList();
// // //       }

// // //       state = state.copyWith(isLoading: false, approvedPhotos: approvedList, pendingPhotos: pendingList);
// // //     } catch (e) {
// // //       state = state.copyWith(isLoading: false);
// // //     }
// // //   }

// // //   void addLocalPhoto(XFile picked) {
// // //     final newItem = PhotoItem(
// // //       id: DateTime.now().millisecondsSinceEpoch.toString(),
// // //       imageUrl: picked.path, isApproved: false, localFile: File(picked.path),
// // //     );
// // //     state = state.copyWith(pendingPhotos: [newItem, ...state.pendingPhotos], showApproved: false);
// // //   }

// // //   void removePhoto(PhotoItem item) {
// // //     if (item.isApproved) {
// // //       state = state.copyWith(approvedPhotos: state.approvedPhotos.where((p) => p.id != item.id).toList());
// // //     } else {
// // //       state = state.copyWith(pendingPhotos: state.pendingPhotos.where((p) => p.id != item.id).toList());
// // //     }
// // //   }
// // // }

// // // final photosTabProvider = StateNotifierProvider<PhotosTabNotifier, PhotosTabState>((ref) => PhotosTabNotifier());

// // // // =============================================================================
// // // // 3. UI SCREEN
// // // // =============================================================================

// // // class MyProfilePhotosTab extends ConsumerStatefulWidget {
// // //   const MyProfilePhotosTab({super.key});
// // //   @override
// // //   ConsumerState<MyProfilePhotosTab> createState() => _MyProfilePhotosTabState();
// // // }

// // // class _MyProfilePhotosTabState extends ConsumerState<MyProfilePhotosTab> {
// // //   final ImagePicker _picker = ImagePicker();

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final state = ref.watch(photosTabProvider);
// // //     final notifier = ref.read(photosTabProvider.notifier);
// // //     final currentList = state.showApproved ? state.approvedPhotos : state.pendingPhotos;
// // //     final sectionTitle = state.showApproved ? 'Approved Photos' : 'Pending Approval';

// // //     return RefreshIndicator(
// // //       onRefresh: () => notifier.fetchPhotos(),
// // //       color: Colors.pink,
// // //       child: SingleChildScrollView(
// // //         physics: const AlwaysScrollableScrollPhysics(),
// // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             // Tabs
// // //             Container(
// // //               height: 42,
// // //               decoration: BoxDecoration(color: const Color(0xFF350035), borderRadius: BorderRadius.circular(30)),
// // //               padding: const EdgeInsets.all(4),
// // //               child: Row(children: [
// // //                 _statusPill('Approved', state.showApproved, () => notifier.toggleTab(true)),
// // //                 _statusPill('Pending', !state.showApproved, () => notifier.toggleTab(false)),
// // //               ]),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             _buildInfoStrip(),
// // //             const SizedBox(height: 24),
// // //             // Title
// // //             Text(sectionTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F1047))),
// // //             const SizedBox(height: 12),
// // //             // Button on Next Line
// // //             if (state.showApproved) SizedBox(width: double.infinity, child: _buildAddButton()),
// // //             const SizedBox(height: 24),
// // //             // Grid
// // //             if (state.isLoading && currentList.isEmpty)
// // //               const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator(color: Colors.pink)))
// // //             else if (currentList.isEmpty)
// // //               _buildEmptyState(sectionTitle)
// // //             else
// // //               Wrap(
// // //                 spacing: 12, runSpacing: 12,
// // //                 children: currentList.map((item) => _buildPhotoCard(item)).toList(),
// // //               ),
// // //             const SizedBox(height: 100),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _statusPill(String label, bool isSelected, VoidCallback onTap) {
// // //     return Expanded(
// // //       child: GestureDetector(
// // //         onTap: onTap,
// // //         child: Container(
// // //           alignment: Alignment.center,
// // //           decoration: BoxDecoration(color: isSelected ? const Color(0xFFFF2D87) : Colors.transparent, borderRadius: BorderRadius.circular(25)),
// // //           child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildInfoStrip() {
// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       decoration: BoxDecoration(color: const Color(0xFFFBF8FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5DDF2))),
// // //       child: const Row(children: [
// // //         Icon(Icons.info_outline, size: 24, color: Color(0xFF490040)),
// // //         SizedBox(width: 12),
// // //         Expanded(child: Text('Only high-quality images are approved. Avoid children, animals, weapons, or contact info.', style: TextStyle(fontSize: 13, color: Colors.black87))),
// // //       ]),
// // //     );
// // //   }

// // //   // W// Refined build method for the Add Photo button
// // // Widget _buildAddButton() {
// // //   return ElevatedButton.icon(
// // //     onPressed: _addPhoto, 
// // //     icon: const Icon(Icons.add, size: 16), 
// // //     label: const Text('Add Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
// // //     style: ElevatedButton.styleFrom(
// // //       backgroundColor: const Color(0xFF19001F), 
// // //       foregroundColor: Colors.white, 
// // //       elevation: 0,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
// // //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), // Compact padding
// // //     ),
// // //   );
// // // }

// // //   Widget _buildEmptyState(String title) {
// // //     return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 60), child: Column(children: [const Icon(Icons.image_outlined, size: 64, color: Colors.grey), const SizedBox(height: 12), Text("No $title available", style: const TextStyle(color: Colors.grey, fontSize: 16))])));
// // //   }

// // //   Widget _buildPhotoCard(PhotoItem item) {
// // //     final cardWidth = (MediaQuery.of(context).size.width - 44) / 2;
// // //     return Container(
// // //       width: cardWidth,
// // //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8E0F2))),
// // //       child: Column(children: [
// // //         Stack(children: [
// // //           ClipRRect(
// // //             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
// // //             child: item.localFile != null ? Image.file(item.localFile!, height: 170, width: double.infinity, fit: BoxFit.cover) : Image.network(item.imageUrl, height: 170, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 170, color: Colors.grey[100])),
// // //           ),
// // //           Positioned(right: 8, top: 8, child: GestureDetector(onTap: () => ref.read(photosTabProvider.notifier).removePhoto(item), child: const CircleAvatar(radius: 14, backgroundColor: Color(0xFFFF4473), child: Icon(Icons.delete_outline, size: 16, color: Colors.white)))),
// // //         ]),
// // //         Padding(padding: const EdgeInsets.all(12), child: Row(children: [Icon(item.isApproved ? Icons.check_circle : Icons.access_time_filled, size: 15, color: Colors.black54), const SizedBox(width: 6), Expanded(child: Text(item.isApproved ? (item.isMain ? 'Profile Pic' : 'Approved') : 'Awaiting Approval', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))])),
// // //       ]),
// // //     );
// // //   }

// // //   Future<void> _addPhoto() async {
// // //     final source = await showModalBottomSheet<ImageSource>(context: context, builder: (c) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () => Navigator.pop(c, ImageSource.gallery)), ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Camera'), onTap: () => Navigator.pop(c, ImageSource.camera))])));
// // //     if (source != null) {
// // //       final picked = await _picker.pickImage(source: source);
// // //       if (picked != null) ref.read(photosTabProvider.notifier).addLocalPhoto(picked);
// // //     }
// // //   }
// // // }

// // // // import 'dart:convert';
// // // // import 'dart:io';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:image_picker/image_picker.dart';

// // // // // =============================================================================
// // // // // 1. DATA MODELS
// // // // // =============================================================================

// // // // class PhotoItem {
// // // //   final String id;
// // // //   final String imageUrl;
// // // //   final bool isApproved;
// // // //   final bool isMain;
// // // //   final File? localFile;

// // // //   PhotoItem({
// // // //     required this.id, required this.imageUrl, required this.isApproved,
// // // //     this.isMain = false, this.localFile,
// // // //   });

// // // //   factory PhotoItem.fromJson(Map<String, dynamic> json) {
// // // //     return PhotoItem(
// // // //       id: (json['id'] ?? '').toString(),
// // // //       imageUrl: (json['profile_image'] ?? '').toString(),
// // // //       isApproved: (json['status'] ?? '').toString() == "1",
// // // //       isMain: (json['set_profile'] ?? '').toString() == "1",
// // // //     );
// // // //   }
// // // // }

// // // // // =============================================================================
// // // // // 2. STATE & NOTIFIER
// // // // // =============================================================================

// // // // class PhotosTabState {
// // // //   final bool showApproved;
// // // //   final bool isLoading;
// // // //   final List<PhotoItem> pendingPhotos;
// // // //   final List<PhotoItem> approvedPhotos;

// // // //   const PhotosTabState({
// // // //     this.showApproved = true, this.isLoading = false,
// // // //     this.pendingPhotos = const [], this.approvedPhotos = const [],
// // // //   });

// // // //   PhotosTabState copyWith({bool? showApproved, bool? isLoading, List<PhotoItem>? pendingPhotos, List<PhotoItem>? approvedPhotos}) {
// // // //     return PhotosTabState(
// // // //       showApproved: showApproved ?? this.showApproved,
// // // //       isLoading: isLoading ?? this.isLoading,
// // // //       pendingPhotos: pendingPhotos ?? this.pendingPhotos,
// // // //       approvedPhotos: approvedPhotos ?? this.approvedPhotos,
// // // //     );
// // // //   }
// // // // }

// // // // class PhotosTabNotifier extends StateNotifier<PhotosTabState> {
// // // //   PhotosTabNotifier() : super(const PhotosTabState());

// // // //   final String approvedUrl = "https://app.beatflirtevent.com/App/user/signle_user_profile_approve_image";
// // // //   final String pendingUrl = "https://app.beatflirtevent.com/App/user/signle_user_profile_pending_image";

// // // //   void toggleTab(bool showApproved) {
// // // //     state = state.copyWith(showApproved: showApproved);
// // // //   }

// // // //   Future<void> fetchPhotos() async {
// // // //     state = state.copyWith(isLoading: true);
// // // //     try {
// // // //       final approvedRes = await http.get(Uri.parse(approvedUrl));
// // // //       List<PhotoItem> approvedList = [];
// // // //       if (approvedRes.statusCode == 200) {
// // // //         final data = json.decode(approvedRes.body);
// // // //         if (data['data'] != null) approvedList = (data['data'] as List).map((e) => PhotoItem.fromJson(e)).toList();
// // // //       }

// // // //       final pendingRes = await http.get(Uri.parse(pendingUrl));
// // // //       List<PhotoItem> pendingList = [];
// // // //       if (pendingRes.statusCode == 200) {
// // // //         final data = json.decode(pendingRes.body);
// // // //         if (data['data'] != null) pendingList = (data['data'] as List).map((e) => PhotoItem.fromJson(e)).toList();
// // // //       }

// // // //       state = state.copyWith(isLoading: false, approvedPhotos: approvedList, pendingPhotos: pendingList);
// // // //     } catch (e) {
// // // //       state = state.copyWith(isLoading: false);
// // // //     }
// // // //   }

// // // //   void addLocalPhoto(XFile picked) {
// // // //     final newItem = PhotoItem(
// // // //       id: DateTime.now().millisecondsSinceEpoch.toString(),
// // // //       imageUrl: picked.path, isApproved: false, localFile: File(picked.path),
// // // //     );
// // // //     state = state.copyWith(pendingPhotos: [newItem, ...state.pendingPhotos], showApproved: false);
// // // //   }

// // // //   void removePhoto(PhotoItem item) {
// // // //     if (item.isApproved) {
// // // //       state = state.copyWith(approvedPhotos: state.approvedPhotos.where((p) => p.id != item.id).toList());
// // // //     } else {
// // // //       state = state.copyWith(pendingPhotos: state.pendingPhotos.where((p) => p.id != item.id).toList());
// // // //     }
// // // //   }
// // // // }

// // // // final photosTabProvider = StateNotifierProvider<PhotosTabNotifier, PhotosTabState>((ref) => PhotosTabNotifier());

// // // // // =============================================================================
// // // // // 3. UI SCREEN
// // // // // =============================================================================

// // // // class MyProfilePhotosTab extends ConsumerStatefulWidget {
// // // //   const MyProfilePhotosTab({super.key});
// // // //   @override
// // // //   ConsumerState<MyProfilePhotosTab> createState() => _MyProfilePhotosTabState();
// // // // }

// // // // class _MyProfilePhotosTabState extends ConsumerState<MyProfilePhotosTab> {
// // // //   final ImagePicker _picker = ImagePicker();

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //       ref.read(photosTabProvider.notifier).fetchPhotos();
// // // //     });
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final state = ref.watch(photosTabProvider);
// // // //     final notifier = ref.read(photosTabProvider.notifier);
// // // //     final currentList = state.showApproved ? state.approvedPhotos : state.pendingPhotos;
// // // //     final sectionTitle = state.showApproved ? 'Approved Photos' : 'Pending Approval';

// // // //     return SingleChildScrollView(
// // // //       physics: const AlwaysScrollableScrollPhysics(),
// // // //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           // Sub Tabs Toggle
// // // //           Container(
// // // //             // height: 54,
// // // //             height: 40,
// // // //             decoration: BoxDecoration(color: const Color(0xFF350035), borderRadius: BorderRadius.circular(30)),
// // // //             padding: const EdgeInsets.all(4),
// // // //             child: Row(
// // // //               children: [
// // // //                 _statusPill('Approved', state.showApproved, () => notifier.toggleTab(true)),
// // // //                 _statusPill('Pending', !state.showApproved, () => notifier.toggleTab(false)),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 20),
// // // //           _buildInfoStrip(),
// // // //           const SizedBox(height: 24),
// // // //           // Section Title + Add Button (Fixed with Expanded)
// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: Text(
// // // //                   sectionTitle,
// // // //                   maxLines: 1,
// // // //                   overflow: TextOverflow.ellipsis,
// // // //                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2F1047)),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               if (state.showApproved) _buildAddButton(),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 24),
// // // //           if (state.isLoading)
// // // //             const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: Colors.pink)))
// // // //           else if (currentList.isEmpty)
// // // //             Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 60), child: Text("No $sectionTitle available", style: const TextStyle(color: Colors.grey, fontSize: 16))))
      
// // // //           else
// // // //             Wrap(
// // // //               spacing: 12, runSpacing: 12,
// // // //               children: currentList.map((item) => _buildPhotoCard(item)).toList(),
// // // //             ),
        
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _statusPill(String label, bool isSelected, VoidCallback onTap) {
// // // //     return Expanded(
// // // //       child: GestureDetector(
// // // //         onTap: onTap,
// // // //         child: Container(
// // // //           alignment: Alignment.center,
// // // //           decoration: BoxDecoration(color: isSelected ? const Color(0xFFFF2D87) : Colors.transparent, borderRadius: BorderRadius.circular(25)),
// // // //           child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildInfoStrip() {
// // // //     return Container(
// // // //       padding: const EdgeInsets.all(16),
// // // //       decoration: BoxDecoration(color: const Color(0xFFFBF8FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5DDF2))),
// // // //       child: const Row(
// // // //         children: [
// // // //           Icon(Icons.info_outline, size: 24, color: Color(0xFF490040)),
// // // //           SizedBox(width: 12),
// // // //           Expanded(child: Text('Only high-quality images are approved. Avoid children, animals, weapons, or contact info.', style: TextStyle(fontSize: 13, color: Colors.black87))),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildAddButton() {
// // // //     return ElevatedButton.icon(
// // // //       onPressed: _addPhoto,
// // // //       icon: const Icon(Icons.add, size: 18),
// // // //       label: const Text('Add Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
// // // //       style: ElevatedButton.styleFrom(
// // // //         backgroundColor: const Color(0xFF19001F), foregroundColor: Colors.white,
// // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildPhotoCard(PhotoItem item) {
// // // //     final cardWidth = (MediaQuery.of(context).size.width - 44) / 2;
// // // //     return Container(
// // // //       width: cardWidth,
// // // //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8E0F2))),
// // // //       child: Column(children: [
// // // //         Stack(children: [
// // // //           ClipRRect(
// // // //             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
// // // //             child: item.localFile != null ? Image.file(item.localFile!, height: 170, width: double.infinity, fit: BoxFit.cover) : Image.network(item.imageUrl, height: 170, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 170, color: Colors.grey[100])),
// // // //           ),
// // // //           Positioned(right: 8, top: 8, child: GestureDetector(onTap: () => ref.read(photosTabProvider.notifier).removePhoto(item), child: const CircleAvatar(radius: 14, backgroundColor: Color(0xFFFF4473), child: Icon(Icons.delete_outline, size: 16, color: Colors.white)))),
// // // //         ]),
// // // //         Padding(padding: const EdgeInsets.all(12), child: Row(children: [Icon(item.isApproved ? Icons.check_circle : Icons.access_time_filled, size: 15, color: Colors.black54), const SizedBox(width: 6), Expanded(child: Text(item.isApproved ? (item.isMain ? 'Profile Pic' : 'Approved') : 'Awaiting', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))])),
// // // //       ]),
// // // //     );
// // // //   }

// // // //   Future<void> _addPhoto() async {
// // // //     final source = await showModalBottomSheet<ImageSource>(context: context, builder: (c) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () => Navigator.pop(c, ImageSource.gallery)), ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Camera'), onTap: () => Navigator.pop(c, ImageSource.camera))])));
// // // //     if (source != null) {
// // // //       final picked = await _picker.pickImage(source: source);
// // // //       if (picked != null) ref.read(photosTabProvider.notifier).addLocalPhoto(picked);
// // // //     }
// // // //   }
// // // // }

// // // // // // import 'dart:io';
// // // // // //
// // // // // // import 'package:beatflirt/Api_services/api_services.dart';
// // // // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:image_picker/image_picker.dart';
// // // // // //
// // // // // // class MyProfilePhotosTab extends StatefulWidget {
// // // // // //   const MyProfilePhotosTab({super.key});
// // // // // //
// // // // // //   @override
// // // // // //   State<MyProfilePhotosTab> createState() => _MyProfilePhotosTabState();
// // // // // // }
// // // // // //
// // // // // // class _MyProfilePhotosTabState extends State<MyProfilePhotosTab> {
// // // // // //   bool _showApproved = false;
// // // // // //   final ImagePicker _picker = ImagePicker();
// // // // // //   final ApiServices _api = ApiServices();
// // // // // //   bool _isLoading = true;
// // // // // //
// // // // // //   List<_PhotoItem> _pendingPhotos = [
// // // // // //     _PhotoItem(mediaId: '', path: 'assets/images/notification-image1.jpg', approved: false),
// // // // // //     _PhotoItem(mediaId: '', path: 'assets/images/notification-image5.jpg', approved: false),
// // // // // //     _PhotoItem(mediaId: '', path: 'assets/images/notification-image4.jpg', approved: false),
// // // // // //   ];
// // // // // //   List<_PhotoItem> _approvedPhotos = [
// // // // // //     _PhotoItem(mediaId: '', path: 'assets/images/notification-image4.jpg', approved: true, isMain: true),
// // // // // //   ];
// // // // // //
// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _loadPhotosFromApi();
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final list = _showApproved ? _approvedPhotos : _pendingPhotos;
// // // // // //     final sectionTitle = _showApproved ? 'Approved Photos' : 'Pending Approval';
// // // // // //     final width = MediaQuery.of(context).size.width;
// // // // // //     final isCompact = width < 380;
// // // // // //     final cardWidth = isCompact ? width - 64 : 220.0;
// // // // // //
// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         _statusTabs(),
// // // // // //         const SizedBox(height: 12),
// // // // // //         if (_showApproved) _infoStrip(),
// // // // // //         if (_showApproved) const SizedBox(height: 16),
// // // // // //         if (_showApproved)
// // // // // //           Wrap(
// // // // // //             spacing: 8,
// // // // // //             runSpacing: 8,
// // // // // //             crossAxisAlignment: WrapCrossAlignment.center,
// // // // // //             children: [
// // // // // //               Text(
// // // // // //                 sectionTitle,
// // // // // //                 style: TextStyle(
// // // // // //                   fontSize: isCompact ? 24 : 28,
// // // // // //                   fontWeight: FontWeight.w700,
// // // // // //                 ),
// // // // // //               ),
// // // // // //               ElevatedButton.icon(
// // // // // //                 onPressed: _addPhoto,
// // // // // //                 icon: const Icon(Icons.add, size: 16),
// // // // // //                 label: const Text('Add Photo'),
// // // // // //                 style: ElevatedButton.styleFrom(
// // // // // //                   backgroundColor: const Color(0xFF220027),
// // // // // //                   foregroundColor: Colors.white,
// // // // // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           )
// // // // // //         else
// // // // // //           Text(
// // // // // //             sectionTitle,
// // // // // //             style: TextStyle(
// // // // // //               fontSize: isCompact ? 24 : 28,
// // // // // //               fontWeight: FontWeight.w700,
// // // // // //             ),
// // // // // //           ),
// // // // // //         const SizedBox(height: 14),
// // // // // //         if (_isLoading)
// // // // // //           const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
// // // // // //         else
// // // // // //           Wrap(
// // // // // //             spacing: 14,
// // // // // //             runSpacing: 14,
// // // // // //             children: list.map((item) => _photoCard(item, cardWidth)).toList(),
// // // // // //           ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _statusTabs() {
// // // // // //     return Container(
// // // // // //       height: 40,
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
// // // // // //       decoration: BoxDecoration(
// // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // //         gradient: const LinearGradient(
// // // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // //         ),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           _pillTab(
// // // // // //             label: 'Approved',
// // // // // //             selected: _showApproved,
// // // // // //             onTap: () => setState(() => _showApproved = true),
// // // // // //           ),
// // // // // //           const Spacer(),
// // // // // //           _pillTab(
// // // // // //             label: 'Pending',
// // // // // //             selected: !_showApproved,
// // // // // //             onTap: () => setState(() => _showApproved = false),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _pillTab({
// // // // // //     required String label,
// // // // // //     required bool selected,
// // // // // //     required VoidCallback onTap,
// // // // // //   }) {
// // // // // //     return InkWell(
// // // // // //       onTap: onTap,
// // // // // //       borderRadius: BorderRadius.circular(16),
// // // // // //       child: Container(
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// // // // // //           borderRadius: BorderRadius.circular(16),
// // // // // //         ),
// // // // // //         child: Text(
// // // // // //           label,
// // // // // //           style: const TextStyle(
// // // // // //             color: Colors.white,
// // // // // //             fontSize: 11,
// // // // // //             fontWeight: FontWeight.w700,
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _infoStrip() {
// // // // // //     return Container(
// // // // // //       width: double.infinity,
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // // // // //       decoration: BoxDecoration(
// // // // // //         borderRadius: BorderRadius.circular(4),
// // // // // //         border: Border.all(color: const Color(0xFF2D1935)),
// // // // // //       ),
// // // // // //       child: const Row(
// // // // // //         children: [
// // // // // //           Icon(Icons.info, size: 16),
// // // // // //           SizedBox(width: 8),
// // // // // //           Expanded(
// // // // // //             child: Text(
// // // // // //               'Only high-quality images are approved. Avoid children, animals, weapons, or contact info.',
// // // // // //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _photoCard(_PhotoItem item, double width) {
// // // // // //     return Container(
// // // // // //       width: width,
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(14),
// // // // // //         border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // // //         boxShadow: [
// // // // // //           BoxShadow(
// // // // // //             color: Colors.black.withValues(alpha: 0.05),
// // // // // //             blurRadius: 10,
// // // // // //             offset: const Offset(0, 4),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           Stack(
// // // // // //             children: [
// // // // // //               ClipRRect(
// // // // // //                 borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
// // // // // //                 child: item.xFile != null
// // // // // //                     ? Image.file(
// // // // // //                         File(item.xFile!.path),
// // // // // //                         height: 180,
// // // // // //                         width: double.infinity,
// // // // // //                         fit: BoxFit.cover,
// // // // // //                         errorBuilder: (context, error, stackTrace) => _fallbackImage(),
// // // // // //                       )
// // // // // //                     : Image.asset(
// // // // // //                         item.path,
// // // // // //                         height: 180,
// // // // // //                         width: double.infinity,
// // // // // //                         fit: BoxFit.cover,
// // // // // //                         errorBuilder: (context, error, stackTrace) => _fallbackImage(),
// // // // // //                       ),
// // // // // //               ),
// // // // // //               Positioned(
// // // // // //                 left: 8,
// // // // // //                 top: 8,
// // // // // //                 child: Container(
// // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// // // // // //                   decoration: BoxDecoration(
// // // // // //                     color: item.approved ? const Color(0xFF20B35D) : const Color(0xFFF7D12D),
// // // // // //                     borderRadius: BorderRadius.circular(8),
// // // // // //                   ),
// // // // // //                   child: Text(
// // // // // //                     item.approved ? 'APPROVED' : 'PENDING',
// // // // // //                     style: const TextStyle(
// // // // // //                       color: Colors.white,
// // // // // //                       fontSize: 10,
// // // // // //                       fontWeight: FontWeight.w700,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               Positioned(
// // // // // //                 right: 8,
// // // // // //                 top: 8,
// // // // // //                 child: CircleAvatar(
// // // // // //                   radius: 12,
// // // // // //                   backgroundColor: const Color(0xFFFF4473),
// // // // // //                   child: IconButton(
// // // // // //                     icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
// // // // // //                     onPressed: () => _deletePhoto(item),
// // // // // //                     padding: EdgeInsets.zero,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           Container(
// // // // // //             width: double.infinity,
// // // // // //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// // // // // //             child: Row(
// // // // // //               children: [
// // // // // //                 Icon(
// // // // // //                   item.approved ? Icons.check_circle_outline : Icons.access_time,
// // // // // //                   size: 14,
// // // // // //                   color: Colors.black54,
// // // // // //                 ),
// // // // // //                 const SizedBox(width: 6),
// // // // // //                 Text(
// // // // // //                   item.approved
// // // // // //                       ? (item.isMain ? 'Set Main' : 'Approved')
// // // // // //                       : 'Awaiting Approval',
// // // // // //                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   void _deletePhoto(_PhotoItem item) {
// // // // // //     _deletePhotoApi(item);
// // // // // //   }
// // // // // //
// // // // // //   Future<void> _addPhoto() async {
// // // // // //     final source = await _chooseSource();
// // // // // //     if (source == null) return;
// // // // // //
// // // // // //     final picked = await _picker.pickImage(
// // // // // //       source: source,
// // // // // //       imageQuality: 85,
// // // // // //       maxWidth: 1600,
// // // // // //     );
// // // // // //     if (picked == null) return;
// // // // // //
// // // // // //     setState(() {
// // // // // //       _pendingPhotos.insert(
// // // // // //         0,
// // // // // //         _PhotoItem(
// // // // // //           mediaId: '',
// // // // // //           path: picked.path,
// // // // // //           approved: false,
// // // // // //           xFile: picked,
// // // // // //         ),
// // // // // //       );
// // // // // //       _showApproved = false;
// // // // // //     });
// // // // // //     final token = await AuthService.getToken();
// // // // // //     if (token != null && token.isNotEmpty) {
// // // // // //       try {
// // // // // //         await _api.addPhoto(
// // // // // //           token: token,
// // // // // //           path: picked.path,
// // // // // //           title: 'New Photo',
// // // // // //         );
// // // // // //         await _loadPhotosFromApi();
// // // // // //       } catch (_) {
// // // // // //         // Keep local fallback photo if API call fails.
// // // // // //       }
// // // // // //     }
// // // // // //
// // // // // //     if (!mounted) return;
// // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // //       const SnackBar(content: Text('Photo added to pending approval')),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Future<ImageSource?> _chooseSource() async {
// // // // // //     return showModalBottomSheet<ImageSource>(
// // // // // //       context: context,
// // // // // //       builder: (context) {
// // // // // //         return SafeArea(
// // // // // //           child: Column(
// // // // // //             mainAxisSize: MainAxisSize.min,
// // // // // //             children: [
// // // // // //               ListTile(
// // // // // //                 leading: const Icon(Icons.photo_library_outlined),
// // // // // //                 title: const Text('Choose from Gallery'),
// // // // // //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// // // // // //               ),
// // // // // //               ListTile(
// // // // // //                 leading: const Icon(Icons.camera_alt_outlined),
// // // // // //                 title: const Text('Take Photo'),
// // // // // //                 onTap: () => Navigator.pop(context, ImageSource.camera),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _fallbackImage() {
// // // // // //     return Container(
// // // // // //       height: 180,
// // // // // //       width: double.infinity,
// // // // // //       color: Colors.grey[200],
// // // // // //       alignment: Alignment.center,
// // // // // //       child: const Icon(Icons.image_not_supported_outlined),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Future<void> _loadPhotosFromApi() async {
// // // // // //     setState(() => _isLoading = true);
// // // // // //     try {
// // // // // //       final token = await AuthService.getToken();
// // // // // //       if (token == null || token.isEmpty) {
// // // // // //         if (!mounted) return;
// // // // // //         setState(() => _isLoading = false);
// // // // // //         return;
// // // // // //       }
// // // // // //       final items = await _api.getPhotos(token: token);
// // // // // //       final photos = items.map(_PhotoItem.fromApi).toList();
// // // // // //       if (!mounted) return;
// // // // // //       setState(() {
// // // // // //         _approvedPhotos = photos.where((p) => p.approved).toList();
// // // // // //         _pendingPhotos = photos.where((p) => !p.approved).toList();
// // // // // //         _isLoading = false;
// // // // // //       });
// // // // // //     } catch (_) {
// // // // // //       if (!mounted) return;
// // // // // //       setState(() => _isLoading = false);
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   Future<void> _deletePhotoApi(_PhotoItem item) async {
// // // // // //     setState(() {
// // // // // //       if (item.approved) {
// // // // // //         _approvedPhotos.remove(item);
// // // // // //       } else {
// // // // // //         _pendingPhotos.remove(item);
// // // // // //       }
// // // // // //     });
// // // // // //     if (item.mediaId.isEmpty) return;
// // // // // //     try {
// // // // // //       final token = await AuthService.getToken();
// // // // // //       if (token == null || token.isEmpty) return;
// // // // // //       await _api.deletePhoto(token: token, mediaId: item.mediaId);
// // // // // //     } catch (_) {
// // // // // //       // Keep optimistic UI; data will refresh from API later.
// // // // // //     }
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // class _PhotoItem {
// // // // // //   const _PhotoItem({
// // // // // //     required this.mediaId,
// // // // // //     required this.path,
// // // // // //     required this.approved,
// // // // // //     this.xFile,
// // // // // //     this.isMain = false,
// // // // // //   });
// // // // // //
// // // // // //   final String mediaId;
// // // // // //   final String path;
// // // // // //   final bool approved;
// // // // // //   final XFile? xFile;
// // // // // //   final bool isMain;
// // // // // //
// // // // // //   factory _PhotoItem.fromApi(Map<String, dynamic> json) {
// // // // // //     final path = (json['path'] ?? '').toString();
// // // // // //     final status = (json['status'] ?? '').toString();
// // // // // //     return _PhotoItem(
// // // // // //       mediaId: (json['mediaId'] ?? '').toString(),
// // // // // //       path: path,
// // // // // //       approved: status == 'approved',
// // // // // //       isMain: json['isMain'] == true,
// // // // // //       xFile: path.startsWith('/') ? XFile(path) : null,
// // // // // //     );
// // // // // //   }
// // // // // // }


// // // // // import 'dart:io';

// // // // // import 'package:beatflirt/Api_services/api_services.dart';
// // // // // import 'package:beatflirt/core/services/auth_services.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:image_picker/image_picker.dart';

// // // // // // --- MODEL ---
// // // // // class PhotoItem {
// // // // //   const PhotoItem({
// // // // //     required this.mediaId,
// // // // //     required this.path,
// // // // //     required this.approved,
// // // // //     this.xFile,
// // // // //     this.isMain = false,
// // // // //   });

// // // // //   final String mediaId;
// // // // //   final String path;
// // // // //   final bool approved;
// // // // //   final XFile? xFile;
// // // // //   final bool isMain;

// // // // //   factory PhotoItem.fromApi(Map<String, dynamic> json) {
// // // // //     final path = (json['path'] ?? '').toString();
// // // // //     final status = (json['status'] ?? '').toString();
// // // // //     return PhotoItem(
// // // // //       mediaId: (json['mediaId'] ?? '').toString(),
// // // // //       path: path,
// // // // //       approved: status == 'approved',
// // // // //       isMain: json['isMain'] == true,
// // // // //       xFile: path.startsWith('/') ? XFile(path) : null,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // --- STATE ---
// // // // // class PhotosTabState {
// // // // //   final bool showApproved;
// // // // //   final bool isLoading;
// // // // //   final List<PhotoItem> pendingPhotos;
// // // // //   final List<PhotoItem> approvedPhotos;

// // // // //   const PhotosTabState({
// // // // //     this.showApproved = false,
// // // // //     this.isLoading = true,
// // // // //     this.pendingPhotos = const [],
// // // // //     this.approvedPhotos = const [],
// // // // //   });

// // // // //   PhotosTabState copyWith({
// // // // //     bool? showApproved,
// // // // //     bool? isLoading,
// // // // //     List<PhotoItem>? pendingPhotos,
// // // // //     List<PhotoItem>? approvedPhotos,
// // // // //   }) {
// // // // //     return PhotosTabState(
// // // // //       showApproved: showApproved ?? this.showApproved,
// // // // //       isLoading: isLoading ?? this.isLoading,
// // // // //       pendingPhotos: pendingPhotos ?? this.pendingPhotos,
// // // // //       approvedPhotos: approvedPhotos ?? this.approvedPhotos,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // --- NOTIFIER ---
// // // // // class PhotosTabNotifier extends Notifier<PhotosTabState> {
// // // // //   final ApiServices _api = ApiServices();

// // // // //   @override
// // // // //   PhotosTabState build() {
// // // // //     return PhotosTabState(
// // // // //       pendingPhotos: [
// // // // //         const PhotoItem(mediaId: '', path: 'assets/images/notification-image1.jpg', approved: false),
// // // // //         const PhotoItem(mediaId: '', path: 'assets/images/notification-image5.jpg', approved: false),
// // // // //         const PhotoItem(mediaId: '', path: 'assets/images/notification-image4.jpg', approved: false),
// // // // //       ],
// // // // //       approvedPhotos: [
// // // // //         const PhotoItem(mediaId: '', path: 'assets/images/notification-image4.jpg', approved: true, isMain: true),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   void toggleTab(bool showApproved) {
// // // // //     state = state.copyWith(showApproved: showApproved);
// // // // //   }

// // // // //   Future<void> loadPhotosFromApi() async {
// // // // //     state = state.copyWith(isLoading: true);
// // // // //     try {
// // // // //       final token = await AuthService.getToken();
// // // // //       if (token == null || token.isEmpty) {
// // // // //         state = state.copyWith(isLoading: false);
// // // // //         return;
// // // // //       }
// // // // //       final items = await _api.getPhotos(token: token);
// // // // //       final photos = items.map(PhotoItem.fromApi).toList();
// // // // //       state = state.copyWith(
// // // // //         approvedPhotos: photos.where((p) => p.approved).toList(),
// // // // //         pendingPhotos: photos.where((p) => !p.approved).toList(),
// // // // //         isLoading: false,
// // // // //       );
// // // // //     } catch (_) {
// // // // //       state = state.copyWith(isLoading: false);
// // // // //     }
// // // // //   }

// // // // //   Future<void> addPhoto(XFile picked) async {
// // // // //     state = state.copyWith(
// // // // //       pendingPhotos: [
// // // // //         PhotoItem(
// // // // //           mediaId: '',
// // // // //           path: picked.path,
// // // // //           approved: false,
// // // // //           xFile: picked,
// // // // //         ),
// // // // //         ...state.pendingPhotos,
// // // // //       ],
// // // // //       showApproved: false,
// // // // //     );

// // // // //     final token = await AuthService.getToken();
// // // // //     if (token != null && token.isNotEmpty) {
// // // // //       try {
// // // // //         await _api.addPhoto(
// // // // //           token: token,
// // // // //           path: picked.path,
// // // // //           title: 'New Photo',
// // // // //         );
// // // // //         await loadPhotosFromApi();
// // // // //       } catch (_) {
// // // // //         // Keep local fallback photo if API call fails.
// // // // //       }
// // // // //     }
// // // // //   }

// // // // //   Future<void> deletePhoto(PhotoItem item) async {
// // // // //     final newApproved = List<PhotoItem>.from(state.approvedPhotos)..remove(item);
// // // // //     final newPending = List<PhotoItem>.from(state.pendingPhotos)..remove(item);

// // // // //     state = state.copyWith(
// // // // //       approvedPhotos: item.approved ? newApproved : state.approvedPhotos,
// // // // //       pendingPhotos: !item.approved ? newPending : state.pendingPhotos,
// // // // //     );

// // // // //     if (item.mediaId.isEmpty) return;
// // // // //     try {
// // // // //       final token = await AuthService.getToken();
// // // // //       if (token == null || token.isEmpty) return;
// // // // //       await _api.deletePhoto(token: token, mediaId: item.mediaId);
// // // // //     } catch (_) {
// // // // //       // Keep optimistic UI; data will refresh from API later.
// // // // //     }
// // // // //   }
// // // // // }

// // // // // // --- PROVIDER ---
// // // // // final photosTabProvider =
// // // // // NotifierProvider<PhotosTabNotifier, PhotosTabState>(
// // // // //   PhotosTabNotifier.new,
// // // // // );

// // // // // // --- WIDGET ---
// // // // // class MyProfilePhotosTab extends ConsumerStatefulWidget {
// // // // //   const MyProfilePhotosTab({super.key});

// // // // //   @override
// // // // //   ConsumerState<MyProfilePhotosTab> createState() => _MyProfilePhotosTabState();
// // // // // }

// // // // // class _MyProfilePhotosTabState extends ConsumerState<MyProfilePhotosTab> {
// // // // //   final ImagePicker _picker = ImagePicker();

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // // //       ref.read(photosTabProvider.notifier).loadPhotosFromApi();
// // // // //     });
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final state = ref.watch(photosTabProvider);
// // // // //     final notifier = ref.read(photosTabProvider.notifier);
// // // // //     final list = state.showApproved ? state.approvedPhotos : state.pendingPhotos;
// // // // //     final sectionTitle = state.showApproved ? 'Approved Photos' : 'Pending Approval';
// // // // //     final width = MediaQuery.of(context).size.width;
// // // // //     final isCompact = width < 380;
// // // // //     final cardWidth = isCompact ? width - 64 : 220.0;

// // // // //     return Column(
// // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //       children: [
// // // // //         _statusTabs(state, notifier),
// // // // //         const SizedBox(height: 12),
// // // // //         if (state.showApproved) _infoStrip(),
// // // // //         if (state.showApproved) const SizedBox(height: 16),
// // // // //         if (state.showApproved)
// // // // //           Wrap(
// // // // //             spacing: 8,
// // // // //             runSpacing: 8,
// // // // //             crossAxisAlignment: WrapCrossAlignment.center,
// // // // //             children: [
// // // // //               Text(
// // // // //                 sectionTitle,
// // // // //                 style: TextStyle(
// // // // //                   fontSize: isCompact ? 24 : 28,
// // // // //                   fontWeight: FontWeight.w700,
// // // // //                 ),
// // // // //               ),
// // // // //               ElevatedButton.icon(
// // // // //                 onPressed: _addPhoto,
// // // // //                 icon: const Icon(Icons.add, size: 16),
// // // // //                 label: const Text('Add Photo'),
// // // // //                 style: ElevatedButton.styleFrom(
// // // // //                   backgroundColor: const Color(0xFF220027),
// // // // //                   foregroundColor: Colors.white,
// // // // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           )
// // // // //         else
// // // // //           Text(
// // // // //             sectionTitle,
// // // // //             style: TextStyle(
// // // // //               fontSize: isCompact ? 24 : 28,
// // // // //               fontWeight: FontWeight.w700,
// // // // //             ),
// // // // //           ),
// // // // //         const SizedBox(height: 14),
// // // // //         if (state.isLoading)
// // // // //           const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
// // // // //         else
// // // // //           Wrap(
// // // // //             spacing: 14,
// // // // //             runSpacing: 14,
// // // // //             children: list.map((item) => _photoCard(item, cardWidth)).toList(),
// // // // //           ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   Widget _statusTabs(PhotosTabState state, PhotosTabNotifier notifier) {
// // // // //     return Container(
// // // // //       height: 40,
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
// // // // //       decoration: BoxDecoration(
// // // // //         borderRadius: BorderRadius.circular(22),
// // // // //         gradient: const LinearGradient(
// // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // //         ),
// // // // //       ),
// // // // //       child: Row(
// // // // //         children: [
// // // // //           _pillTab(
// // // // //             label: 'Approved',
// // // // //             selected: state.showApproved,
// // // // //             onTap: () => notifier.toggleTab(true),
// // // // //           ),
// // // // //           const Spacer(),
// // // // //           _pillTab(
// // // // //             label: 'Pending',
// // // // //             selected: !state.showApproved,
// // // // //             onTap: () => notifier.toggleTab(false),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _pillTab({
// // // // //     required String label,
// // // // //     required bool selected,
// // // // //     required VoidCallback onTap,
// // // // //   }) {
// // // // //     return InkWell(
// // // // //       onTap: onTap,
// // // // //       borderRadius: BorderRadius.circular(16),
// // // // //       child: Container(
// // // // //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// // // // //         decoration: BoxDecoration(
// // // // //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// // // // //           borderRadius: BorderRadius.circular(16),
// // // // //         ),
// // // // //         child: Text(
// // // // //           label,
// // // // //           style: const TextStyle(
// // // // //             color: Colors.white,
// // // // //             fontSize: 11,
// // // // //             fontWeight: FontWeight.w700,
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _infoStrip() {
// // // // //     return Container(
// // // // //       width: double.infinity,
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // // // //       decoration: BoxDecoration(
// // // // //         borderRadius: BorderRadius.circular(4),
// // // // //         border: Border.all(color: const Color(0xFF2D1935)),
// // // // //       ),
// // // // //       child: const Row(
// // // // //         children: [
// // // // //           Icon(Icons.info, size: 16),
// // // // //           SizedBox(width: 8),
// // // // //           Expanded(
// // // // //             child: Text(
// // // // //               'Only high-quality images are approved. Avoid children, animals, weapons, or contact info.',
// // // // //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _photoCard(PhotoItem item, double width) {
// // // // //     return Container(
// // // // //       width: width,
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(14),
// // // // //         border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // //         boxShadow: [
// // // // //           BoxShadow(
// // // // //             color: Colors.black.withValues(alpha: 0.05),
// // // // //             blurRadius: 10,
// // // // //             offset: const Offset(0, 4),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Stack(
// // // // //             children: [
// // // // //               ClipRRect(
// // // // //                 borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
// // // // //                 child: item.xFile != null
// // // // //                     ? Image.file(
// // // // //                   File(item.xFile!.path),
// // // // //                   height: 180,
// // // // //                   width: double.infinity,
// // // // //                   fit: BoxFit.cover,
// // // // //                   errorBuilder: (context, error, stackTrace) => _fallbackImage(),
// // // // //                 )
// // // // //                     : Image.asset(
// // // // //                   item.path,
// // // // //                   height: 180,
// // // // //                   width: double.infinity,
// // // // //                   fit: BoxFit.cover,
// // // // //                   errorBuilder: (context, error, stackTrace) => _fallbackImage(),
// // // // //                 ),
// // // // //               ),
// // // // //               Positioned(
// // // // //                 left: 8,
// // // // //                 top: 8,
// // // // //                 child: Container(
// // // // //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// // // // //                   decoration: BoxDecoration(
// // // // //                     color: item.approved ? const Color(0xFF20B35D) : const Color(0xFFF7D12D),
// // // // //                     borderRadius: BorderRadius.circular(8),
// // // // //                   ),
// // // // //                   child: Text(
// // // // //                     item.approved ? 'APPROVED' : 'PENDING',
// // // // //                     style: const TextStyle(
// // // // //                       color: Colors.white,
// // // // //                       fontSize: 10,
// // // // //                       fontWeight: FontWeight.w700,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //               Positioned(
// // // // //                 right: 8,
// // // // //                 top: 8,
// // // // //                 child: CircleAvatar(
// // // // //                   radius: 12,
// // // // //                   backgroundColor: const Color(0xFFFF4473),
// // // // //                   child: IconButton(
// // // // //                     icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
// // // // //                     onPressed: () => ref.read(photosTabProvider.notifier).deletePhoto(item),
// // // // //                     padding: EdgeInsets.zero,
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           Container(
// // // // //             width: double.infinity,
// // // // //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// // // // //             child: Row(
// // // // //               children: [
// // // // //                 Icon(
// // // // //                   item.approved ? Icons.check_circle_outline : Icons.access_time,
// // // // //                   size: 14,
// // // // //                   color: Colors.black54,
// // // // //                 ),
// // // // //                 const SizedBox(width: 6),
// // // // //                 Text(
// // // // //                   item.approved
// // // // //                       ? (item.isMain ? 'Set Main' : 'Approved')
// // // // //                       : 'Awaiting Approval',
// // // // //                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Future<void> _addPhoto() async {
// // // // //     final source = await _chooseSource();
// // // // //     if (source == null) return;

// // // // //     final picked = await _picker.pickImage(
// // // // //       source: source,
// // // // //       imageQuality: 85,
// // // // //       maxWidth: 1600,
// // // // //     );
// // // // //     if (picked == null) return;

// // // // //     await ref.read(photosTabProvider.notifier).addPhoto(picked);

// // // // //     if (!mounted) return;
// // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // //       const SnackBar(content: Text('Photo added to pending approval')),
// // // // //     );
// // // // //   }

// // // // //   Future<ImageSource?> _chooseSource() async {
// // // // //     return showModalBottomSheet<ImageSource>(
// // // // //       context: context,
// // // // //       builder: (context) {
// // // // //         return SafeArea(
// // // // //           child: Column(
// // // // //             mainAxisSize: MainAxisSize.min,
// // // // //             children: [
// // // // //               ListTile(
// // // // //                 leading: const Icon(Icons.photo_library_outlined),
// // // // //                 title: const Text('Choose from Gallery'),
// // // // //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// // // // //               ),
// // // // //               ListTile(
// // // // //                 leading: const Icon(Icons.camera_alt_outlined),
// // // // //                 title: const Text('Take Photo'),
// // // // //                 onTap: () => Navigator.pop(context, ImageSource.camera),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }

// // // // //   Widget _fallbackImage() {
// // // // //     return Container(
// // // // //       height: 180,
// // // // //       width: double.infinity,
// // // // //       color: Colors.grey[200],
// // // // //       alignment: Alignment.center,
// // // // //       child: const Icon(Icons.image_not_supported_outlined),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import 'package:image_picker/image_picker.dart';
// // // // // // import 'dart:io';
// // // // // // import '../../../providers/profile_provider.dart';
// // // // // // import '../../../core/constants.dart';
// // // // // //
// // // // // // class PhotosTab extends ConsumerStatefulWidget {
// // // // // //   const PhotosTab({super.key});
// // // // // //
// // // // // //   @override
// // // // // //   ConsumerState<PhotosTab> createState() => _PhotosTabState();
// // // // // // }
// // // // // //
// // // // // // class _PhotosTabState extends ConsumerState<PhotosTab> {
// // // // // //   final ImagePicker _picker = ImagePicker();
// // // // // //
// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     // Fetch photos on init
// // // // // //     Future.microtask(() {
// // // // // //       ref.read(photosProvider.notifier).fetchPhotos();
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final photosState = ref.watch(photosProvider);
// // // // // //
// // // // // //     return Column(
// // // // // //       children: [
// // // // // //         // Header with upload button
// // // // // //         _buildHeader(photosState),
// // // // // //
// // // // // //         // Photo grid
// // // // // //         Expanded(
// // // // // //           child: photosState.isLoading
// // // // // //               ? _buildLoadingGrid()
// // // // // //               : photosState.photos.isEmpty
// // // // // //               ? _buildEmptyState()
// // // // // //               : _buildPhotoGrid(photosState.photos),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildHeader(PhotosState state) {
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.all(16),
// // // // // //       decoration: const BoxDecoration(
// // // // // //         color: AppColors.surface,
// // // // // //         border: Border(
// // // // // //           bottom: BorderSide(color: AppColors.divider, width: 0.5),
// // // // // //         ),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           const Icon(Icons.photo_library, color: AppColors.primary, size: 22),
// // // // // //           const SizedBox(width: 10),
// // // // // //           Text(
// // // // // //             'My Photos',
// // // // // //             style: AppTextStyles.heading3,
// // // // // //           ),
// // // // // //           const Spacer(),
// // // // // //           Text(
// // // // // //             '${state.photos.length} photos',
// // // // // //             style: AppTextStyles.bodySmall,
// // // // // //           ),
// // // // // //           const SizedBox(width: 12),
// // // // // //           // Upload button
// // // // // //           Material(
// // // // // //             color: AppColors.primary,
// // // // // //             borderRadius: BorderRadius.circular(12),
// // // // // //             child: InkWell(
// // // // // //               borderRadius: BorderRadius.circular(12),
// // // // // //               onTap: state.isUploading ? null : () => _showUploadOptions(),
// // // // // //               child: Container(
// // // // // //                 padding: const EdgeInsets.symmetric(
// // // // // //                   horizontal: 16,
// // // // // //                   vertical: 10,
// // // // // //                 ),
// // // // // //                 child: state.isUploading
// // // // // //                     ? const SizedBox(
// // // // // //                   width: 20,
// // // // // //                   height: 20,
// // // // // //                   child: CircularProgressIndicator(
// // // // // //                     color: Colors.white,
// // // // // //                     strokeWidth: 2,
// // // // // //                   ),
// // // // // //                 )
// // // // // //                     : const Row(
// // // // // //                   mainAxisSize: MainAxisSize.min,
// // // // // //                   children: [
// // // // // //                     Icon(Icons.add_a_photo, color: Colors.white, size: 18),
// // // // // //                     SizedBox(width: 6),
// // // // // //                     Text(
// // // // // //                       'Upload',
// // // // // //                       style: TextStyle(
// // // // // //                         color: Colors.white,
// // // // // //                         fontSize: 13,
// // // // // //                         fontWeight: FontWeight.w600,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildEmptyState() {
// // // // // //     return Center(
// // // // // //       child: Padding(
// // // // // //         padding: const EdgeInsets.all(48),
// // // // // //         child: Column(
// // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // //           children: [
// // // // // //             Container(
// // // // // //               padding: const EdgeInsets.all(24),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 color: AppColors.primary.withOpacity(0.1),
// // // // // //                 shape: BoxShape.circle,
// // // // // //               ),
// // // // // //               child: Icon(
// // // // // //                 Icons.add_photo_alternate_outlined,
// // // // // //                 size: 64,
// // // // // //                 color: AppColors.primary.withOpacity(0.6),
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(height: 24),
// // // // // //             const Text(
// // // // // //               'No Photos Yet',
// // // // // //               style: AppTextStyles.heading2,
// // // // // //             ),
// // // // // //             const SizedBox(height: 8),
// // // // // //             Text(
// // // // // //               'Upload your first photo to make your\nprofile stand out!',
// // // // // //               style: AppTextStyles.bodyMedium,
// // // // // //               textAlign: TextAlign.center,
// // // // // //             ),
// // // // // //             const SizedBox(height: 24),
// // // // // //             ElevatedButton.icon(
// // // // // //               onPressed: () => _showUploadOptions(),
// // // // // //               icon: const Icon(Icons.add_a_photo),
// // // // // //               label: const Text('Add Photos'),
// // // // // //               style: ElevatedButton.styleFrom(
// // // // // //                 backgroundColor: AppColors.primary,
// // // // // //                 foregroundColor: Colors.white,
// // // // // //                 padding: const EdgeInsets.symmetric(
// // // // // //                   horizontal: 32,
// // // // // //                   vertical: 14,
// // // // // //                 ),
// // // // // //                 shape: RoundedRectangleBorder(
// // // // // //                   borderRadius: BorderRadius.circular(14),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildLoadingGrid() {
// // // // // //     return GridView.builder(
// // // // // //       padding: const EdgeInsets.all(12),
// // // // // //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // //         crossAxisCount: 3,
// // // // // //         crossAxisSpacing: 8,
// // // // // //         mainAxisSpacing: 8,
// // // // // //       ),
// // // // // //       itemCount: 9,
// // // // // //       itemBuilder: (context, index) {
// // // // // //         return Container(
// // // // // //           decoration: BoxDecoration(
// // // // // //             color: AppColors.cardDark,
// // // // // //             borderRadius: BorderRadius.circular(12),
// // // // // //           ),
// // // // // //           child: const Center(
// // // // // //             child: CircularProgressIndicator(
// // // // // //               color: AppColors.primary,
// // // // // //               strokeWidth: 2,
// // // // // //             ),
// // // // // //           ),
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildPhotoGrid(List<String> photos) {
// // // // // //     return GridView.builder(
// // // // // //       physics: const BouncingScrollPhysics(),
// // // // // //       padding: const EdgeInsets.all(12),
// // // // // //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // //         crossAxisCount: 3,
// // // // // //         crossAxisSpacing: 8,
// // // // // //         mainAxisSpacing: 8,
// // // // // //       ),
// // // // // //       itemCount: photos.length,
// // // // // //       itemBuilder: (context, index) {
// // // // // //         return _buildPhotoItem(photos[index], index);
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildPhotoItem(String photoUrl, int index) {
// // // // // //     return GestureDetector(
// // // // // //       onTap: () => _viewPhoto(photoUrl, index),
// // // // // //       onLongPress: () => _showPhotoOptions(index),
// // // // // //       child: Container(
// // // // // //         decoration: BoxDecoration(
// // // // // //           borderRadius: BorderRadius.circular(12),
// // // // // //           border: Border.all(color: AppColors.divider, width: 0.5),
// // // // // //         ),
// // // // // //         child: ClipRRect(
// // // // // //           borderRadius: BorderRadius.circular(12),
// // // // // //           child: Stack(
// // // // // //             fit: StackFit.expand,
// // // // // //             children: [
// // // // // //               Image.network(
// // // // // //                 photoUrl,
// // // // // //                 fit: BoxFit.cover,
// // // // // //                 loadingBuilder: (context, child, loadingProgress) {
// // // // // //                   if (loadingProgress == null) return child;
// // // // // //                   return Container(
// // // // // //                     color: AppColors.cardDark,
// // // // // //                     child: const Center(
// // // // // //                       child: CircularProgressIndicator(
// // // // // //                         color: AppColors.primary,
// // // // // //                         strokeWidth: 2,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   );
// // // // // //                 },
// // // // // //                 errorBuilder: (_, __, ___) => Container(
// // // // // //                   color: AppColors.cardDark,
// // // // // //                   child: const Icon(
// // // // // //                     Icons.broken_image,
// // // // // //                     color: AppColors.textMuted,
// // // // // //                     size: 32,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               // Gradient overlay at bottom
// // // // // //               Positioned(
// // // // // //                 bottom: 0,
// // // // // //                 left: 0,
// // // // // //                 right: 0,
// // // // // //                 child: Container(
// // // // // //                   height: 30,
// // // // // //                   decoration: BoxDecoration(
// // // // // //                     gradient: LinearGradient(
// // // // // //                       begin: Alignment.topCenter,
// // // // // //                       end: Alignment.bottomCenter,
// // // // // //                       colors: [
// // // // // //                         Colors.transparent,
// // // // // //                         Colors.black.withOpacity(0.5),
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   void _viewPhoto(String photoUrl, int index) {
// // // // // //     final photos = ref.read(photosProvider).photos;
// // // // // //     Navigator.push(
// // // // // //       context,
// // // // // //       MaterialPageRoute(
// // // // // //         builder: (_) => PhotoViewerScreen(
// // // // // //           photos: photos,
// // // // // //           initialIndex: index,
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   void _showPhotoOptions(int index) {
// // // // // //     showModalBottomSheet(
// // // // // //       context: context,
// // // // // //       backgroundColor: AppColors.cardDark,
// // // // // //       shape: const RoundedRectangleBorder(
// // // // // //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // // // // //       ),
// // // // // //       builder: (context) => Padding(
// // // // // //         padding: const EdgeInsets.symmetric(vertical: 20),
// // // // // //         child: Column(
// // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // //           children: [
// // // // // //             Container(
// // // // // //               width: 40,
// // // // // //               height: 4,
// // // // // //               decoration: BoxDecoration(
// // // // // //                 color: AppColors.divider,
// // // // // //                 borderRadius: BorderRadius.circular(2),
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(height: 20),
// // // // // //             ListTile(
// // // // // //               leading: const Icon(Icons.visibility, color: AppColors.primary),
// // // // // //               title: const Text('View Photo',
// // // // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // // // //               onTap: () {
// // // // // //                 Navigator.pop(context);
// // // // // //                 final photos = ref.read(photosProvider).photos;
// // // // // //                 _viewPhoto(photos[index], index);
// // // // // //               },
// // // // // //             ),
// // // // // //             ListTile(
// // // // // //               leading: const Icon(Icons.star, color: AppColors.gold),
// // // // // //               title: const Text('Set as Profile Photo',
// // // // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // // // //               onTap: () {
// // // // // //                 Navigator.pop(context);
// // // // // //                 // TODO: Set as profile photo API call
// // // // // //               },
// // // // // //             ),
// // // // // //             ListTile(
// // // // // //               leading: const Icon(Icons.delete, color: AppColors.error),
// // // // // //               title: const Text('Delete Photo',
// // // // // //                   style: TextStyle(color: AppColors.error)),
// // // // // //               onTap: () {
// // // // // //                 Navigator.pop(context);
// // // // // //                 _confirmDelete(index);
// // // // // //               },
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   void _confirmDelete(int index) {
// // // // // //     showDialog(
// // // // // //       context: context,
// // // // // //       builder: (context) => AlertDialog(
// // // // // //         backgroundColor: AppColors.cardDark,
// // // // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // // // //         title: const Text('Delete Photo',
// // // // // //             style: TextStyle(color: AppColors.textPrimary)),
// // // // // //         content: const Text(
// // // // // //           'Are you sure you want to delete this photo?',
// // // // // //           style: TextStyle(color: AppColors.textSecondary),
// // // // // //         ),
// // // // // //         actions: [
// // // // // //           TextButton(
// // // // // //             onPressed: () => Navigator.pop(context),
// // // // // //             child: const Text('Cancel'),
// // // // // //           ),
// // // // // //           ElevatedButton(
// // // // // //             onPressed: () {
// // // // // //               Navigator.pop(context);
// // // // // //               ref.read(photosProvider.notifier).removePhoto(index);
// // // // // //             },
// // // // // //             style: ElevatedButton.styleFrom(
// // // // // //               backgroundColor: AppColors.error,
// // // // // //               foregroundColor: Colors.white,
// // // // // //             ),
// // // // // //             child: const Text('Delete'),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   void _showUploadOptions() {
// // // // // //     showModalBottomSheet(
// // // // // //       context: context,
// // // // // //       backgroundColor: AppColors.cardDark,
// // // // // //       shape: const RoundedRectangleBorder(
// // // // // //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // // // // //       ),
// // // // // //       builder: (context) => Padding(
// // // // // //         padding: const EdgeInsets.symmetric(vertical: 20),
// // // // // //         child: Column(
// // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // //           children: [
// // // // // //             Container(
// // // // // //               width: 40,
// // // // // //               height: 4,
// // // // // //               decoration: BoxDecoration(
// // // // // //                 color: AppColors.divider,
// // // // // //                 borderRadius: BorderRadius.circular(2),
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(height: 20),
// // // // // //             const Text('Upload Photo',
// // // // // //                 style: AppTextStyles.heading3),
// // // // // //             const SizedBox(height: 16),
// // // // // //             ListTile(
// // // // // //               leading: Container(
// // // // // //                 padding: const EdgeInsets.all(10),
// // // // // //                 decoration: BoxDecoration(
// // // // // //                   color: AppColors.primary.withOpacity(0.15),
// // // // // //                   borderRadius: BorderRadius.circular(12),
// // // // // //                 ),
// // // // // //                 child: const Icon(Icons.camera_alt, color: AppColors.primary),
// // // // // //               ),
// // // // // //               title: const Text('Camera',
// // // // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // // // //               subtitle: const Text('Take a new photo',
// // // // // //                   style: TextStyle(color: AppColors.textMuted)),
// // // // // //               onTap: () {
// // // // // //                 Navigator.pop(context);
// // // // // //                 _pickImage(ImageSource.camera);
// // // // // //               },
// // // // // //             ),
// // // // // //             ListTile(
// // // // // //               leading: Container(
// // // // // //                 padding: const EdgeInsets.all(10),
// // // // // //                 decoration: BoxDecoration(
// // // // // //                   color: AppColors.accent.withOpacity(0.15),
// // // // // //                   borderRadius: BorderRadius.circular(12),
// // // // // //                 ),
// // // // // //                 child:
// // // // // //                 const Icon(Icons.photo_library, color: AppColors.accent),
// // // // // //               ),
// // // // // //               title: const Text('Gallery',
// // // // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // // // //               subtitle: const Text('Choose from gallery',
// // // // // //                   style: TextStyle(color: AppColors.textMuted)),
// // // // // //               onTap: () {
// // // // // //                 Navigator.pop(context);
// // // // // //                 _pickImage(ImageSource.gallery);
// // // // // //               },
// // // // // //             ),
// // // // // //             const SizedBox(height: 12),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Future<void> _pickImage(ImageSource source) async {
// // // // // //     try {
// // // // // //       final XFile? image = await _picker.pickImage(
// // // // // //         source: source,
// // // // // //         maxWidth: 1920,
// // // // // //         maxHeight: 1920,
// // // // // //         imageQuality: 85,
// // // // // //       );
// // // // // //       if (image != null) {
// // // // // //         await ref
// // // // // //             .read(photosProvider.notifier)
// // // // // //             .uploadPhoto(File(image.path));
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       if (mounted) {
// // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // //           SnackBar(
// // // // // //             content: Text('Error picking image: ${e.toString()}'),
// // // // // //             backgroundColor: AppColors.error,
// // // // // //           ),
// // // // // //         );
// // // // // //       }
// // // // // //     }
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // // ─── Full Screen Photo Viewer ───
// // // // // // class PhotoViewerScreen extends StatefulWidget {
// // // // // //   final List<String> photos;
// // // // // //   final int initialIndex;
// // // // // //
// // // // // //   const PhotoViewerScreen({
// // // // // //     super.key,
// // // // // //     required this.photos,
// // // // // //     required this.initialIndex,
// // // // // //   });
// // // // // //
// // // // // //   @override
// // // // // //   State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
// // // // // // }
// // // // // //
// // // // // // class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
// // // // // //   late PageController _pageController;
// // // // // //   late int _currentIndex;
// // // // // //
// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _currentIndex = widget.initialIndex;
// // // // // //     _pageController = PageController(initialPage: widget.initialIndex);
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   void dispose() {
// // // // // //     _pageController.dispose();
// // // // // //     super.dispose();
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       backgroundColor: Colors.black,
// // // // // //       appBar: AppBar(
// // // // // //         backgroundColor: Colors.black,
// // // // // //         foregroundColor: Colors.white,
// // // // // //         title: Text(
// // // // // //           '${_currentIndex + 1} / ${widget.photos.length}',
// // // // // //           style: const TextStyle(fontSize: 16),
// // // // // //         ),
// // // // // //         centerTitle: true,
// // // // // //       ),
// // // // // //       body: PageView.builder(
// // // // // //         controller: _pageController,
// // // // // //         itemCount: widget.photos.length,
// // // // // //         onPageChanged: (index) {
// // // // // //           setState(() => _currentIndex = index);
// // // // // //         },
// // // // // //         itemBuilder: (context, index) {
// // // // // //           return InteractiveViewer(
// // // // // //             minScale: 0.5,
// // // // // //             maxScale: 4.0,
// // // // // //             child: Center(
// // // // // //               child: Image.network(
// // // // // //                 widget.photos[index],
// // // // // //                 fit: BoxFit.contain,
// // // // // //                 loadingBuilder: (context, child, loadingProgress) {
// // // // // //                   if (loadingProgress == null) return child;
// // // // // //                   return const Center(
// // // // // //                     child: CircularProgressIndicator(
// // // // // //                       color: AppColors.primary,
// // // // // //                     ),
// // // // // //                   );
// // // // // //                 },
// // // // // //               ),
// // // // // //             ),
// // // // // //           );
// // // // // //         },
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
