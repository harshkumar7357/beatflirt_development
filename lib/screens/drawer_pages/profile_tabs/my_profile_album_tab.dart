// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyProfileAlbumTab extends StatefulWidget {
//   const MyProfileAlbumTab({super.key});
//
//   @override
//   State<MyProfileAlbumTab> createState() => _MyProfileAlbumTabState();
// }
//
// class _MyProfileAlbumTabState extends State<MyProfileAlbumTab> {
//   static const String _pendingKey = 'profile_album_pending';
//   static const String _approvedKey = 'profile_album_approved';
//
//   final ImagePicker _picker = ImagePicker();
//   bool _showApproved = false;
//
//   List<_AlbumItem> _pendingItems = [
//     _AlbumItem(path: 'assets/images/notification-image1.jpg', approved: false, title: 'Weekend Party'),
//     _AlbumItem(path: 'assets/images/notification-image5.jpg', approved: false, title: 'Beach Night'),
//   ];
//   List<_AlbumItem> _approvedItems = [
//     _AlbumItem(path: 'assets/images/notification-image4.jpg', approved: true, title: 'Main Album'),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAlbums();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final list = _showApproved ? _approvedItems : _pendingItems;
//     final sectionTitle = _showApproved ? 'Approved Albums' : 'Pending Albums';
//     final width = MediaQuery.of(context).size.width;
//     final isCompact = width < 380;
//     final cardWidth = isCompact ? width - 64 : 220.0;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _statusTabs(),
//         const SizedBox(height: 12),
//         if (_showApproved) _infoStrip(),
//         if (_showApproved) const SizedBox(height: 16),
//         if (_showApproved)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             crossAxisAlignment: WrapCrossAlignment.center,
//             children: [
//               Text(
//                 sectionTitle,
//                 style: TextStyle(fontSize: isCompact ? 24 : 28, fontWeight: FontWeight.w700),
//               ),
//               ElevatedButton.icon(
//                 onPressed: _addAlbumPhoto,
//                 icon: const Icon(Icons.add, size: 16),
//                 label: const Text('Add Album'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF220027),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 ),
//               ),
//             ],
//           )
//         else
//           Text(
//             sectionTitle,
//             style: TextStyle(fontSize: isCompact ? 24 : 28, fontWeight: FontWeight.w700),
//           ),
//         const SizedBox(height: 14),
//         if (list.isEmpty)
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 24),
//               child: Text(
//                 _showApproved ? 'No approved albums.' : 'No pending albums.',
//                 style: TextStyle(color: Colors.grey[700], fontSize: 16),
//               ),
//             ),
//           )
//         else
//           Wrap(
//             spacing: 14,
//             runSpacing: 14,
//             children: list.map((item) => _albumCard(item, cardWidth)).toList(),
//           ),
//       ],
//     );
//   }
//
//   Widget _statusTabs() {
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
//             selected: _showApproved,
//             onTap: () => setState(() => _showApproved = true),
//           ),
//           const Spacer(),
//           _pillTab(
//             label: 'Pending',
//             selected: !_showApproved,
//             onTap: () => setState(() => _showApproved = false),
//           ),
//         ],
//       ),
//     );
//   }
//
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
//
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
//           Icon(Icons.collections_outlined, size: 16),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               'Only high-quality album photos are approved. Avoid contact info in images.',
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _albumCard(_AlbumItem item, double width) {
//     return Container(
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE8E0F2)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
//                 child: item.xFile != null
//                     ? Image.file(
//                         File(item.xFile!.path),
//                         height: 170,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => _fallbackImage(),
//                       )
//                     : Image.asset(
//                         item.path,
//                         height: 170,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => _fallbackImage(),
//                       ),
//               ),
//               Positioned(
//                 left: 8,
//                 top: 8,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: item.approved ? const Color(0xFF20B35D) : const Color(0xFFF7D12D),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     item.approved ? 'APPROVED' : 'PENDING',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: CircleAvatar(
//                   radius: 12,
//                   backgroundColor: const Color(0xFFFF4473),
//                   child: IconButton(
//                     icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
//                     onPressed: () => _deleteAlbum(item),
//                     padding: EdgeInsets.zero,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: Row(
//               children: [
//                 Icon(
//                   item.approved ? Icons.check_circle_outline : Icons.access_time,
//                   size: 14,
//                   color: Colors.black54,
//                 ),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: Text(
//                     '${item.title} • ${item.approved ? 'Approved' : 'Awaiting Approval'}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _addAlbumPhoto() async {
//     final source = await _chooseSource();
//     if (source == null) return;
//
//     final picked = await _picker.pickImage(
//       source: source,
//       imageQuality: 85,
//       maxWidth: 1600,
//     );
//     if (picked == null) return;
//
//     setState(() {
//       _pendingItems.insert(
//         0,
//         _AlbumItem(
//           path: picked.path,
//           approved: false,
//           title: 'New Album Photo',
//           xFile: picked,
//         ),
//       );
//       _showApproved = false;
//     });
//     await _persistAlbums();
//
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Album photo added to pending approval')),
//     );
//   }
//
//   Future<ImageSource?> _chooseSource() async {
//     return showModalBottomSheet<ImageSource>(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library_outlined),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () => Navigator.pop(context, ImageSource.gallery),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt_outlined),
//                 title: const Text('Take Photo'),
//                 onTap: () => Navigator.pop(context, ImageSource.camera),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _deleteAlbum(_AlbumItem item) {
//     setState(() {
//       if (item.approved) {
//         _approvedItems.remove(item);
//       } else {
//         _pendingItems.remove(item);
//       }
//     });
//     _persistAlbums();
//   }
//
//   Future<void> _loadAlbums() async {
//     final prefs = await SharedPreferences.getInstance();
//     final pendingRaw = prefs.getString(_pendingKey);
//     final approvedRaw = prefs.getString(_approvedKey);
//
//     List<_AlbumItem> decode(String? raw) {
//       if (raw == null || raw.isEmpty) return [];
//       try {
//         final decoded = jsonDecode(raw);
//         if (decoded is! List) return [];
//         return decoded
//             .whereType<Map>()
//             .map((e) => _AlbumItem.fromJson(Map<String, dynamic>.from(e)))
//             .toList();
//       } catch (_) {
//         return [];
//       }
//     }
//
//     final p = decode(pendingRaw);
//     final a = decode(approvedRaw);
//     if (!mounted) return;
//     setState(() {
//       if (p.isNotEmpty) _pendingItems = p;
//       if (a.isNotEmpty) _approvedItems = a;
//     });
//   }
//
//   Future<void> _persistAlbums() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(
//       _pendingKey,
//       jsonEncode(_pendingItems.map((e) => e.toJson()).toList()),
//     );
//     await prefs.setString(
//       _approvedKey,
//       jsonEncode(_approvedItems.map((e) => e.toJson()).toList()),
//     );
//   }
//
//   Widget _fallbackImage() {
//     return Container(
//       height: 170,
//       width: double.infinity,
//       color: Colors.grey[200],
//       alignment: Alignment.center,
//       child: const Icon(Icons.image_not_supported_outlined),
//     );
//   }
// }
//
// class _AlbumItem {
//   const _AlbumItem({
//     required this.path,
//     required this.approved,
//     required this.title,
//     this.xFile,
//   });
//
//   final String path;
//   final bool approved;
//   final String title;
//   final XFile? xFile;
//
//   Map<String, dynamic> toJson() {
//     return {
//       'path': path,
//       'approved': approved,
//       'title': title,
//       'isLocal': xFile != null,
//     };
//   }
//
//   factory _AlbumItem.fromJson(Map<String, dynamic> json) {
//     final path = (json['path'] ?? '').toString();
//     final isLocal = json['isLocal'] == true;
//     return _AlbumItem(
//       path: path,
//       approved: json['approved'] == true,
//       title: (json['title'] ?? 'Album Photo').toString(),
//       xFile: isLocal && path.isNotEmpty ? XFile(path) : null,
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:beatflirt/providers/album_providers.dart';

// ✅ Changed to ConsumerWidget
class MyProfileAlbumTab extends ConsumerWidget {
  const MyProfileAlbumTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch providers
    final showApproved = ref.watch(albumTabProvider);
    final pendingItems = ref.watch(pendingAlbumsProvider);
    final approvedItems = ref.watch(approvedAlbumsProvider);

    final list = showApproved ? approvedItems : pendingItems;
    final sectionTitle = showApproved ? 'Approved Albums' : 'Pending Albums';
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 380;
    final cardWidth = isCompact ? width - 64 : 220.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusTabs(context, ref, showApproved),
        const SizedBox(height: 12),
        if (showApproved) _buildInfoStrip(),
        if (showApproved) const SizedBox(height: 16),
        if (showApproved)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: isCompact ? 24 : 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _addAlbumPhoto(context, ref),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Album'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF220027),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          )
        else
          Text(
            sectionTitle,
            style: TextStyle(
              fontSize: isCompact ? 24 : 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                showApproved ? 'No approved albums.' : 'No pending albums.',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
          )
        else
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: list.map((item) => _buildAlbumCard(
              context,
              ref,
              item,
              cardWidth,
            )).toList(),
          ),
      ],
    );
  }

  Widget _buildStatusTabs(BuildContext context, WidgetRef ref, bool showApproved) {
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
          _buildPillTab(
            label: 'Approved',
            selected: showApproved,
            onTap: () {
              // ✅ Update provider instead of setState
              ref.read(albumTabProvider.notifier).state = true;
            },
          ),
          const Spacer(),
          _buildPillTab(
            label: 'Pending',
            selected: !showApproved,
            onTap: () {
              // ✅ Update provider instead of setState
              ref.read(albumTabProvider.notifier).state = false;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab({
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

  Widget _buildInfoStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2D1935)),
      ),
      child: const Row(
        children: [
          Icon(Icons.collections_outlined, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Only high-quality album photos are approved. Avoid contact info in images.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumCard(
      BuildContext context,
      WidgetRef ref,
      AlbumItem item,
      double width,
      ) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E0F2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: item.xFile != null
                    ? Image.file(
                  File(item.xFile!.path),
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  cacheHeight: 340, // Optimize memory: height * device pixel ratio approx
                  errorBuilder: (_, __, ___) => _buildFallbackImage(),
                )
                    : Image.asset(
                  item.path,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  cacheHeight: 340,
                  errorBuilder: (_, __, ___) => _buildFallbackImage(),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
                    onPressed: () => _deleteAlbum(ref, item),
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
                Expanded(
                  child: Text(
                    '${item.title} • ${item.approved ? 'Approved' : 'Awaiting Approval'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addAlbumPhoto(BuildContext context, WidgetRef ref) async {
    final source = await _chooseSource(context);
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (picked == null) return;

    // ✅ Add to pending albums using provider
    ref.read(pendingAlbumsProvider.notifier).addAlbum(
      AlbumItem(
        path: picked.path,
        approved: false,
        title: 'New Album Photo',
        xFile: picked,
      ),
    );

    // ✅ Switch to pending tab
    ref.read(albumTabProvider.notifier).state = false;

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Album photo added to pending approval')),
    );
  }

  Future<ImageSource?> _chooseSource(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteAlbum(WidgetRef ref, AlbumItem item) {
    // ✅ Delete from appropriate provider
    if (item.approved) {
      ref.read(approvedAlbumsProvider.notifier).removeAlbum(item);
    } else {
      ref.read(pendingAlbumsProvider.notifier).removeAlbum(item);
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      height: 170,
      width: double.infinity,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined),
    );
  }
}