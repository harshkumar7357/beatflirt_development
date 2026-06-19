// import 'package:beatflirt/model/couple_profile.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';


// class AlbumGrid extends StatelessWidget {
//   final List<Album> albums;
//   final Function(Album) onView;
//   final Function(Album) onDelete;
//   final Function(Album) onAddPhoto;
//   final Function(Album) onAddVideo;
//   final Function(Album) onEdit;

//   const AlbumGrid({
//     super.key,
//     required this.albums,
//     required this.onView,
//     required this.onDelete,
//     required this.onAddPhoto,
//     required this.onAddVideo,
//     required this.onEdit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (albums.isEmpty) {
//       return const Center(child: Text('No albums yet.', style: TextStyle(color: Colors.white70)));
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(12),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.9,
//       ),
//       itemCount: albums.length,
//       itemBuilder: (context, index) {
//         final album = albums[index];
//         return Card(
//           color: Colors.grey[850],
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => onView(album),
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                     child: album.image != null
//                         ? CachedNetworkImage(
//                             imageUrl: album.image!,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             // errorBuilder: (_, __, ___) => const Icon(Icons.photo_album, size: 60, color: Colors.grey),
//                             errorWidget: (context, url, error) => const Icon(Icons.photo_album, size: 60, color: Colors.grey)
//                           )
//                         : Container(
//                             color: Colors.grey[800],
//                             child: const Icon(Icons.photo_album, size: 60, color: Colors.grey),
//                           ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       album.albumName,
//                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     Wrap(
//                       spacing: 4,
//                       children: [
//                         TextButton.icon(
//                           icon: const Icon(Icons.photo, size: 14),
//                           label: const Text('Photo', style: TextStyle(fontSize: 11)),
//                           onPressed: () => onAddPhoto(album),
//                           style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: Colors.pink),
//                         ),
//                         TextButton.icon(
//                           icon: const Icon(Icons.videocam, size: 14),
//                           label: const Text('Video', style: TextStyle(fontSize: 11)),
//                           onPressed: () => onAddVideo(album),
//                           style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: Colors.pink),
//                         ),
//                         PopupMenuButton(
//                           icon: const Icon(Icons.more_vert, size: 16, color: Colors.white70),
//                           itemBuilder: (c) => [
//                             const PopupMenuItem(value: 'edit', child: Text('Name & Password')),
//                             const PopupMenuItem(value: 'view', child: Text('View')),
//                             const PopupMenuItem(value: 'delete', child: Text('Delete')),
//                           ],
//                           onSelected: (v) {
//                             if (v == 'edit') onEdit(album);
//                             if (v == 'view') onView(album);
//                             if (v == 'delete') onDelete(album);
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }