// import 'package:flutter/material.dart';
// import '../core/constants.dart';
//
// class ProfileAvatar extends StatelessWidget {
//   final String? imageUrl;
//   final double radius;
//   final bool isCouple;
//   final VoidCallback? onTap;
//   final bool showEditIcon;
//
//   const ProfileAvatar({
//     super.key,
//     this.imageUrl,
//     this.radius = 55,
//     this.isCouple = false,
//     this.onTap,
//     this.showEditIcon = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//         children: [
//           Container(
//             width: radius * 2,
//             height: radius * 2,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: AppColors.primaryGradient,
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primary.withOpacity(0.4),
//                   blurRadius: 15,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(3),
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.surface,
//               ),
//               child: ClipOval(
//                 child: imageUrl != null && imageUrl!.isNotEmpty
//                     ? Image.network(
//                   imageUrl!,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => _buildPlaceholder(),
//                 )
//                     : _buildPlaceholder(),
//               ),
//             ),
//           ),
//           if (isCouple)
//             Positioned(
//               bottom: 2,
//               left: 2,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 6,
//                   vertical: 2,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.accent,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Text(
//                   'COUPLE',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 8,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           if (showEditIcon)
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary,
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: AppColors.background,
//                     width: 2,
//                   ),
//                 ),
//                 child: const Icon(
//                   Icons.camera_alt,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlaceholder() {
//     return Container(
//       color: AppColors.cardDark,
//       child: Icon(
//         isCouple ? Icons.people : Icons.person,
//         size: radius * 0.8,
//         color: AppColors.textMuted,
//       ),
//     );
//   }
// }
