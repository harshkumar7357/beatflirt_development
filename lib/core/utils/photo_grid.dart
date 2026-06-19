// import 'package:beatflirt/model/couple_profile.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class PhotoGrid extends StatelessWidget {
//   final List<ProfileImage> images;
//   final Function(ProfileImage)? onDelete;
//   final Function(ProfileImage)? onSetMain;
//   final bool isApproved;

//   const PhotoGrid({
//     super.key,
//     required this.images,
//     this.onDelete,
//     this.onSetMain,
//     this.isApproved = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (images.isEmpty) {
//       return Center(
//         child: Text(
//           isApproved ? 'No approved photos yet.' : 'No pending photos.',
//           style: const TextStyle(color: Colors.white70),
//         ),
//       );
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemCount: images.length,
//       itemBuilder: (context, index) {
//         final img = images[index];
//         return Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: CachedNetworkImage(
//                 imageUrl: img.profileImage,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//                 placeholder: (c, u) => const Center(child: CircularProgressIndicator()),
//                 errorWidget: (c, u, e) => const Icon(Icons.broken_image, color: Colors.grey),
//               ),
//             ),
//             if (img.setProfile == '1')
//               Positioned(
//                 top: 8,
//                 left: 8,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Text('MAIN', style: TextStyle(fontSize: 10, color: Colors.white)),
//                 ),
//               ),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Row(
//                 children: [
//                   if (onDelete != null)
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red, size: 18),
//                       onPressed: () => onDelete!(img),
//                       style: IconButton.styleFrom(backgroundColor: Colors.black54),
//                     ),
//                   if (onSetMain != null && img.setProfile != '1')
//                     IconButton(
//                       icon: const Icon(Icons.star, color: Colors.amber, size: 18),
//                       onPressed: () => onSetMain!(img),
//                       style: IconButton.styleFrom(backgroundColor: Colors.black54),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }