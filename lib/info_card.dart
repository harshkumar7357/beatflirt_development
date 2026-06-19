// import 'package:flutter/material.dart';
// import '../core/constants.dart';
//
// class InfoCard extends StatelessWidget {
//   final String title;
//   final List<InfoItem> items;
//   final IconData? headerIcon;
//
//   const InfoCard({
//     super.key,
//     required this.title,
//     required this.items,
//     this.headerIcon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: AppColors.cardDark,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.divider, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
//             child: Row(
//               children: [
//                 if (headerIcon != null) ...[
//                   Icon(headerIcon, color: AppColors.primary, size: 20),
//                   const SizedBox(width: 8),
//                 ],
//                 Text(title, style: AppTextStyles.heading3),
//               ],
//             ),
//           ),
//           const Divider(color: AppColors.divider, height: 1),
//           // Items
//           ...items.asMap().entries.map((entry) {
//             final isLast = entry.key == items.length - 1;
//             final item = entry.value;
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 130,
//                         child: Text(
//                           item.label,
//                           style: AppTextStyles.label,
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           item.value.isNotEmpty ? item.value : 'Not set',
//                           style: AppTextStyles.bodyLarge.copyWith(
//                             color: item.value.isNotEmpty
//                                 ? AppColors.textPrimary
//                                 : AppColors.textMuted,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (!isLast)
//                   const Divider(
//                     color: AppColors.divider,
//                     height: 1,
//                     indent: 16,
//                     endIndent: 16,
//                   ),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
//
// class InfoItem {
//   final String label;
//   final String value;
//
//   const InfoItem({required this.label, required this.value});
// }
