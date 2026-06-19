// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/core/services/auth_services.dart';

// // Album Item Model
// class AlbumItem {
//   const AlbumItem({
//     required this.id,
//     required this.path,
//     required this.approved,
//     required this.title,
//     this.xFile,
//   });

//   final String id;
//   final String path;
//   final bool approved;
//   final String title;
//   final XFile? xFile;

//   factory AlbumItem.fromMap(Map<String, dynamic> map) {
//     return AlbumItem(
//       id: map['mediaId']?.toString() ?? '',
//       path: map['path']?.toString() ?? '',
//       approved: map['status'] == 'approved',
//       title: map['title']?.toString() ?? 'Album Photo',
//     );
//   }
// }

// // Tab selection provider (true = approved, false = pending)
// final albumTabProvider = StateProvider<bool>((ref) => true);

// // Unified Album Notifier
// class AlbumNotifier extends Notifier<List<AlbumItem>> {
//   final ApiServices _api = ApiServices();

//   @override
//   List<AlbumItem> build() {
//     Future.microtask(() => fetchAlbums());
//     return [];
//   }

//   Future<void> fetchAlbums() async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       final photosData = await _api.getPhotos(token: token);
//       state = photosData.map((data) => AlbumItem.fromMap(data)).toList();
//     } catch (e) {
//       print('Fetch albums error: $e');
//     }
//   }

//   Future<void> addAlbum(XFile file) async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       await _api.addPhoto(
//         token: token,
//         path: file.path,
//         title: 'New Photo',
//       );
//       await fetchAlbums();
//     } catch (e) {
//       print('Add album error: $e');
//     }
//   }

//   Future<void> removeAlbum(String mediaId) async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       await _api.deletePhoto(token: token, mediaId: mediaId);
//       await fetchAlbums();
//     } catch (e) {
//       print('Delete album error: $e');
//     }
//   }
// }

// final albumProvider = NotifierProvider<AlbumNotifier, List<AlbumItem>>(AlbumNotifier.new);

// // Filtered providers for backward compatibility in UI
// final pendingAlbumsProvider = Provider<List<AlbumItem>>((ref) {
//   return ref.watch(albumProvider).where((item) => !item.approved).toList();
// });

// final approvedAlbumsProvider = Provider<List<AlbumItem>>((ref) {
//   return ref.watch(albumProvider).where((item) => item.approved).toList();
// });