// // Beat Flirt authentication and profile-type routing helpers.
// //
// // Extracted from website routes:
// //   https://beatflirtevent.com/login
// //   https://beatflirtevent.com/signup
// //
// // Login API:
// //   POST https://app.beatflirtevent.com/App/auth/login
// // Registration API:
// //   POST https://app.beatflirtevent.com/App/auth/registration
// // Username check:
// //   GET  https://app.beatflirtevent.com/App/user/getusername/{username}
// // Terms/privacy:
// //   GET  /auth/term_policy
// //   GET  /auth/privecy_policy


// // Reusable profile tab widgets for Beat Flirt profile screens.
// //
// // These widgets match the tab structure shown in the website screenshots:
// // Home | Edit | Photos | Video | Album | Location
// //
// // Use these from both:
// //   beat_view_single_profile_page.dart
// //   beat_view_couple_profile_page.dart


// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'beat_view_couple_profile_page.dart';
// import 'beat_view_single_profile_page.dart';
// // import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// const String beatWebBase = 'https://beatflirtevent.com/';

// String beatWebAsset(String path) => '$beatWebBase$path';

// String resolveBeatMediaUrl(String raw) {
//   final value = raw.trim();
//   if (value.isEmpty) return '';
//   if (value.startsWith('http://') || value.startsWith('https://')) return value;
//   if (value.startsWith('//')) return 'https:$value';
//   if (value.startsWith('assets/')) return '$beatWebBase$value';
//   if (value.startsWith('/assets/')) return '$beatWebBase${value.substring(1)}';
//   if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
//   return 'https://app.beatflirtevent.com/assets/$value';
// }

// class ProfileDetailRowData {
//   const ProfileDetailRowData({
//     required this.label,
//     required this.firstValue,
//     this.secondValue,
//   });

//   final String label;
//   final String firstValue;
//   final String? secondValue;

//   bool get isCouple => secondValue != null;
// }

// class ProfileMediaItem {
//   const ProfileMediaItem({
//     required this.id,
//     required this.url,
//     this.title = '',
//     this.isPending = false,
//     this.isMain = false,
//   });

//   final String id;
//   final String url;
//   final String title;
//   final bool isPending;
//   final bool isMain;
// }

// class ProfileAlbumItem {
//   const ProfileAlbumItem({
//     required this.id,
//     required this.name,
//     required this.coverUrl,
//     this.password = '',
//   });

//   final String id;
//   final String name;
//   final String coverUrl;
//   final String password;
// }

// class ViewSingleProfileHomeTab extends StatelessWidget {
//   const ViewSingleProfileHomeTab({
//     super.key,
//     required this.isCouple,
//     required this.profileImage,
//     required this.username,
//     required this.ageText,
//     required this.genderText,
//     required this.locationText,
//     required this.rows,
//     this.firstGenderAsset = 'assets/img/icons/female.svg',
//     this.secondGenderAsset = 'assets/img/icons/female.svg',
//     this.onProfileTap,
//   });

//   final bool isCouple;
//   final String profileImage;
//   final String username;
//   final String ageText;
//   final String genderText;
//   final String locationText;
//   final List<ProfileDetailRowData> rows;
//   final String firstGenderAsset;
//   final String secondGenderAsset;
//   final VoidCallback? onProfileTap;

//   static const Color _maroon = Color(0xFF560827);
//   static const Color _navy = Color(0xFF06032C);
//   static const Color _pink = Color(0xFFE91E63);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final wide = constraints.maxWidth >= (isCouple ? 980 : 900);
//         if (wide) {
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(width: 330, child: _leftProfileCard()),
//               const SizedBox(width: 42),
//               Expanded(child: _details()),
//             ],
//           );
//         }
//         return Column(
//           children: [
//             _leftProfileCard(),
//             const SizedBox(height: 24),
//             _details(),
//           ],
//         );
//       },
//     );
//   }

//   Widget _leftProfileCard() {
//     return InkWell(
//       onTap: onProfileTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: _gradientBox(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child: Image.network(
//                 resolveBeatMediaUrl(profileImage),
//                 width: double.infinity,
//                 height: 360,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   height: 360,
//                   color: Colors.black,
//                   child: Icon(isCouple ? Icons.people : Icons.person, color: Colors.white, size: 68),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(username, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
//             const SizedBox(height: 8),
//             Text(ageText, style: const TextStyle(color: Colors.white, fontSize: 14)),
//             const SizedBox(height: 6),
//             Text(genderText, style: const TextStyle(color: Colors.white, fontSize: 14)),
//             if (locationText.isNotEmpty) ...[
//               const SizedBox(height: 6),
//               Text(locationText, style: const TextStyle(color: Colors.white, fontSize: 14)),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _details() {
//     return Column(
//       children: rows.map((row) {
//         if (isCouple) return _coupleDetailRow(row);
//         return _singleDetailRow(row);
//       }).toList(),
//     );
//   }

//   Widget _singleDetailRow(ProfileDetailRowData row) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 26),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth < 620) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _detailPill(row.label),
//                 const SizedBox(height: 12),
//                 Row(children: [
//                   _genderCircle(firstGenderAsset),
//                   const SizedBox(width: 14),
//                   Expanded(child: _valueBubble(_cleanValue(row.firstValue))),
//                 ]),
//               ],
//             );
//           }
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(width: 230, child: _detailPill(row.label)),
//               const SizedBox(width: 34),
//               _genderCircle(firstGenderAsset),
//               const SizedBox(width: 18),
//               Flexible(child: _valueBubble(_cleanValue(row.firstValue))),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _coupleDetailRow(ProfileDetailRowData row) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 26),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth < 820) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _detailPill(row.label),
//                 const SizedBox(height: 12),
//                 Row(children: [
//                   _genderCircle(firstGenderAsset),
//                   const SizedBox(width: 14),
//                   Expanded(child: _valueBubble(_cleanValue(row.firstValue))),
//                 ]),
//                 const SizedBox(height: 10),
//                 Row(children: [
//                   _genderCircle(secondGenderAsset),
//                   const SizedBox(width: 14),
//                   Expanded(child: _valueBubble(_cleanValue(row.secondValue ?? 'N/A'))),
//                 ]),
//               ],
//             );
//           }
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(width: 230, child: _detailPill(row.label)),
//               const SizedBox(width: 34),
//               _genderCircle(firstGenderAsset),
//               const SizedBox(width: 14),
//               Expanded(child: _valueBubble(_cleanValue(row.firstValue))),
//               const SizedBox(width: 34),
//               _genderCircle(secondGenderAsset),
//               const SizedBox(width: 14),
//               Expanded(child: _valueBubble(_cleanValue(row.secondValue ?? 'N/A'))),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   String _cleanValue(String value) => value.trim().isEmpty ? 'N/A' : value;

//   Widget _detailPill(String text) {
//     return Container(
//       height: 38,
//       alignment: Alignment.center,
//       decoration: _gradientBox(22),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
//       ),
//     );
//   }

//   Widget _valueBubble(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(18),
//           topRight: Radius.circular(18),
//           bottomRight: Radius.circular(18),
//         ),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 22, offset: const Offset(0, 8))],
//       ),
//       child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
//     );
//   }

//   Widget _genderCircle(String asset) {
//     return Container(
//       width: 52,
//       height: 52,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         boxShadow: [BoxShadow(color: _pink.withOpacity(.23), blurRadius: 24, spreadRadius: 8)],
//       ),
//       child: asset.endsWith('.svg')
//           ? SvgPicture.network(beatWebAsset(asset), placeholderBuilder: (_) => const SizedBox())
//           : Image.network(beatWebAsset(asset), errorBuilder: (_, __, ___) => const SizedBox()),
//     );
//   }

//   BoxDecoration _gradientBox(double radius) => BoxDecoration(
//         borderRadius: BorderRadius.circular(radius),
//         gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, _navy]),
//       );
// }

// class MyProfileEditTab extends StatelessWidget {
//   const MyProfileEditTab({
//     super.key,
//     required this.fields,
//     required this.onSaveDetails,
//     this.interestEditor,
//     this.title = 'Edit Profile Details',
//   });

//   final Map<String, TextEditingController> fields;
//   final Future<void> Function() onSaveDetails;
//   final Widget? interestEditor;
//   final String title;

//   static const Color _primary = Color(0xFF1D042A);
//   static const Color _maroon = Color(0xFF560827);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _section(
//           title,
//           Column(
//             children: [
//               ...fields.entries.map((entry) => Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: TextField(
//                       controller: entry.value,
//                       maxLines: entry.key == 'text' || entry.key == 'comment' ? 3 : 1,
//                       decoration: InputDecoration(
//                         labelText: entry.key.replaceAll('_', ' '),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                       ),
//                     ),
//                   )),
//               _primaryButton('Save Profile Details', onSaveDetails),
//             ],
//           ),
//         ),
//         if (interestEditor != null) interestEditor!,
//       ],
//     );
//   }

//   Widget _section(String sectionTitle, Widget child) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 25)]),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(sectionTitle, style: const TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 20)),
//         const SizedBox(height: 12),
//         child,
//       ]),
//     );
//   }

//   Widget _primaryButton(String label, Future<void> Function() onTap) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
//         onPressed: onTap,
//         child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//       ),
//     );
//   }
// }

// class MyProfilePhotosTab extends StatelessWidget {
//   const MyProfilePhotosTab({
//     super.key,
//     required this.approvedImages,
//     required this.pendingImages,
//     required this.onUpload,
//     required this.onDelete,
//     required this.onSetMain,
//     this.onEdit,
//   });

//   final List<ProfileMediaItem> approvedImages;
//   final List<ProfileMediaItem> pendingImages;
//   final Future<void> Function() onUpload;
//   final Future<void> Function(ProfileMediaItem item) onDelete;
//   final Future<void> Function(ProfileMediaItem item) onSetMain;
//   final Future<void> Function(ProfileMediaItem item)? onEdit;

//   @override
//   Widget build(BuildContext context) {
//     return _MediaGridTab(
//       title: 'Photos',
//       uploadLabel: 'Upload Profile Photo',
//       approved: approvedImages,
//       pending: pendingImages,
//       icon: Icons.photo,
//       onUpload: onUpload,
//       onDelete: onDelete,
//       onSetMain: onSetMain,
//       onEdit: onEdit,
//     );
//   }
// }

// class MyProfileVideoTab extends StatelessWidget {
//   const MyProfileVideoTab({
//     super.key,
//     required this.approvedVideos,
//     required this.pendingVideos,
//     required this.onUpload,
//     required this.onDelete,
//   });

//   final List<ProfileMediaItem> approvedVideos;
//   final List<ProfileMediaItem> pendingVideos;
//   final Future<void> Function() onUpload;
//   final Future<void> Function(ProfileMediaItem item) onDelete;

//   @override
//   Widget build(BuildContext context) {
//     return _MediaGridTab(
//       title: 'Video',
//       uploadLabel: 'Upload Profile Video',
//       approved: approvedVideos,
//       pending: pendingVideos,
//       icon: Icons.play_circle,
//       onUpload: onUpload,
//       onDelete: onDelete,
//       isVideo: true,
//     );
//   }
// }

// class MyProfileAlbumTab extends StatelessWidget {
//   const MyProfileAlbumTab({
//     super.key,
//     required this.albums,
//     required this.onCreateAlbum,
//     required this.onViewAlbum,
//     required this.onEditAlbum,
//     required this.onDeleteAlbum,
//     required this.onAddPhoto,
//     required this.onAddVideo,
//   });

//   final List<ProfileAlbumItem> albums;
//   final Future<void> Function() onCreateAlbum;
//   final Future<void> Function(ProfileAlbumItem item) onViewAlbum;
//   final Future<void> Function(ProfileAlbumItem item) onEditAlbum;
//   final Future<void> Function(ProfileAlbumItem item) onDeleteAlbum;
//   final Future<void> Function(ProfileAlbumItem item) onAddPhoto;
//   final Future<void> Function(ProfileAlbumItem item) onAddVideo;

//   static const Color _primary = Color(0xFF1D042A);
//   static const Color _maroon = Color(0xFF560827);

//   @override
//   Widget build(BuildContext context) {
//     return _section(
//       'Album',
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Wrap(
//             spacing: 12,
//             runSpacing: 12,
//             children: albums.map((album) {
//               return Container(
//                 width: 170,
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
//                     const SizedBox(height: 8),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         resolveBeatMediaUrl(album.coverUrl),
//                         width: 150,
//                         height: 105,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => const SizedBox(width: 150, height: 105, child: Icon(Icons.photo_album)),
//                       ),
//                     ),
//                     Wrap(
//                       children: [
//                         TextButton(onPressed: () => onViewAlbum(album), child: const Text('View')),
//                         TextButton(onPressed: () => onAddPhoto(album), child: const Text('Add Photo')),
//                         TextButton(onPressed: () => onAddVideo(album), child: const Text('Add Video')),
//                         IconButton(onPressed: () => onEditAlbum(album), icon: const Icon(Icons.edit, size: 18)),
//                         IconButton(onPressed: () => onDeleteAlbum(album), icon: const Icon(Icons.delete, size: 18, color: Colors.red)),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
//               onPressed: onCreateAlbum,
//               child: const Text('Create Album', style: TextStyle(fontWeight: FontWeight.w700)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _section(String title, Widget child) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 25)]),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(title, style: const TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 20)),
//         const SizedBox(height: 12),
//         child,
//       ]),
//     );
//   }
// }

// class MyProfileLocationTab extends StatelessWidget {
//   const MyProfileLocationTab({
//     super.key,
//     required this.currentLocation,
//     required this.locationController,
//     this.secondLocationController,
//     required this.onSave,
//   });

//   final String currentLocation;
//   final TextEditingController locationController;
//   final TextEditingController? secondLocationController;
//   final Future<void> Function() onSave;

//   static const Color _primary = Color(0xFF1D042A);
//   static const Color _maroon = Color(0xFF560827);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 25)]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Location Settings', style: TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 20)),
//           const SizedBox(height: 14),
//           const Text('Your Current location is', style: TextStyle(fontWeight: FontWeight.w700)),
//           Text(currentLocation),
//           const SizedBox(height: 12),
//           TextField(controller: locationController, decoration: _input('Current Location')),
//           if (secondLocationController != null) ...[
//             const SizedBox(height: 12),
//             TextField(controller: secondLocationController, decoration: _input('Second Location')),
//           ],
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
//               onPressed: onSave,
//               child: const Text('Update Location', style: TextStyle(fontWeight: FontWeight.w700)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   InputDecoration _input(String label) => InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       );
// }

// class _MediaGridTab extends StatelessWidget {
//   const _MediaGridTab({
//     required this.title,
//     required this.uploadLabel,
//     required this.approved,
//     required this.pending,
//     required this.icon,
//     required this.onUpload,
//     required this.onDelete,
//     this.onSetMain,
//     this.onEdit,
//     this.isVideo = false,
//   });

//   final String title;
//   final String uploadLabel;
//   final List<ProfileMediaItem> approved;
//   final List<ProfileMediaItem> pending;
//   final IconData icon;
//   final Future<void> Function() onUpload;
//   final Future<void> Function(ProfileMediaItem item) onDelete;
//   final Future<void> Function(ProfileMediaItem item)? onSetMain;
//   final Future<void> Function(ProfileMediaItem item)? onEdit;
//   final bool isVideo;

//   static const Color _primary = Color(0xFF1D042A);
//   static const Color _maroon = Color(0xFF560827);

//   @override
//   Widget build(BuildContext context) {
//     return _section(
//       title,
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               ...approved.map((item) => _card(item, approved: true)),
//               ...pending.map((item) => _card(item, approved: false)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
//               onPressed: onUpload,
//               child: Text(uploadLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _card(ProfileMediaItem item, {required bool approved}) {
//     return Container(
//       width: 145,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black12)),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: isVideo
//                     ? Container(width: 128, height: 105, color: Colors.black87, child: Icon(icon, color: Colors.white, size: 42))
//                     : Image.network(
//                         resolveBeatMediaUrl(item.url),
//                         width: 128,
//                         height: 105,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => SizedBox(width: 128, height: 105, child: Icon(icon)),
//                       ),
//               ),
//               Positioned(top: 4, left: 4, child: _statusBadge(approved ? 'Approved' : 'Pending', approved ? Colors.green : Colors.orange)),
//             ],
//           ),
//           if (onSetMain != null)
//             CheckboxListTile(
//               value: item.isMain,
//               dense: true,
//               contentPadding: EdgeInsets.zero,
//               title: const Text('Set Main', style: TextStyle(fontSize: 12)),
//               onChanged: approved ? (_) => onSetMain!(item) : null,
//             ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if (onEdit != null) IconButton(onPressed: () => onEdit!(item), icon: const Icon(Icons.edit, size: 18)),
//               IconButton(onPressed: () => onDelete(item), icon: const Icon(Icons.delete, size: 18, color: Colors.red)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statusBadge(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
//       child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
//     );
//   }

//   Widget _section(String sectionTitle, Widget child) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 25)]),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(sectionTitle, style: const TextStyle(color: _primary, fontWeight: FontWeight.w700, fontSize: 20)),
//         const SizedBox(height: 12),
//         child,
//       ]),
//     );
//   }
// }




// const String beatApiBase = 'https://app.beatflirtevent.com/App';

// enum BeatProfileType { single, couple, unknown }

// class BeatAuthException implements Exception {
//   BeatAuthException(this.message);
//   final String message;

//   @override
//   String toString() => message;
// }

// class BeatAuthUser {
//   BeatAuthUser({
//     required this.token,
//     required this.sign,
//     required this.userId,
//     required this.profileType,
//     required this.raw,
//   });

//   final String token;
//   final String sign;
//   final String userId;
//   final BeatProfileType profileType;
//   final Map<String, dynamic> raw;

//   factory BeatAuthUser.fromJson(Map<String, dynamic> json) {
//     return BeatAuthUser(
//       token: json['token']?.toString() ?? '',
//       sign: json['sign']?.toString() ?? '',
//       userId: json['userid']?.toString() ?? json['id']?.toString() ?? '',
//       profileType: BeatProfileRouter.parseProfileType(json['profile_type']?.toString()),
//       raw: json,
//     );
//   }
// }

// class BeatRegistrationRequest {
//   BeatRegistrationRequest({
//     required this.username,
//     required this.email,
//     required this.password,
//     required this.profileType,
//     this.singleGender = '',
//     this.coupleGenderFrom = '',
//     this.coupleGenderTo = '',
//     this.lat = '',
//     this.lng = '',
//     this.cityName = '',
//     this.placeId = '',
//     this.mapUrl = '',
//     this.formattedAddress = '',
//   });

//   final String username;
//   final String email;
//   final String password;
//   final BeatProfileType profileType;

//   /// Website gender values:
//   /// 1 = Male, 2 = Female, 3 = Transgender.
//   final String singleGender;
//   final String coupleGenderFrom;
//   final String coupleGenderTo;

//   final String lat;
//   final String lng;
//   final String cityName;
//   final String placeId;
//   final String mapUrl;
//   final String formattedAddress;

//   Map<String, dynamic> toJson() {
//     final profileTypeString = profileType == BeatProfileType.couple ? 'couple' : 'single';
//     final gender = _resolveGender(profileType, singleGender, coupleGenderFrom, coupleGenderTo);

//     return {
//       'email': email,
//       'password': password,
//       'username': username,
//       'profile_type': profileTypeString,
//       'single_profile_gender_from': profileType == BeatProfileType.single ? singleGender : '',
//       'single_full_name': '',
//       'couple_profile_gender_from': profileType == BeatProfileType.couple ? coupleGenderFrom : '',
//       'couple_profile_gender_to': profileType == BeatProfileType.couple ? coupleGenderTo : '',
//       'couple_full_name_from': '',
//       'couple_full_name_to': '',
//       'lat': lat,
//       'lng': lng,
//       'city_name': cityName,
//       'place_id': placeId,
//       'map_url': mapUrl,
//       'formatted_address': formattedAddress,
//       'image_type': gender.imageType,
//       'gender_profile_type': gender.genderProfileType,
//       'filter_profile_type': gender.filterProfileType,
//     };
//   }

//   static _ResolvedGender _resolveGender(
//     BeatProfileType profileType,
//     String single,
//     String from,
//     String to,
//   ) {
//     if (profileType == BeatProfileType.single) {
//       if (single == '1') return const _ResolvedGender('male.png', 'Male', 'Male');
//       if (single == '3') return const _ResolvedGender('transgender.png', 'Transgender', 'Transgender');
//       return const _ResolvedGender('female.png', 'Female', 'Female');
//     }

//     String name(String code) {
//       if (code == '1') return 'Male';
//       if (code == '3') return 'Transgender';
//       return 'Female';
//     }

//     String imageType = 'transgender.png';
//     if (from == '1' && to == '1') imageType = 'male-male.png';
//     if (from == '1' && to == '2') imageType = 'male-female.png';
//     if (from == '2' && to == '1') imageType = 'female-male.png';
//     if (from == '2' && to == '2') imageType = 'female-female.png';

//     return _ResolvedGender(imageType, '${name(from)} | ${name(to)}', 'Couple');
//   }
// }

// class _ResolvedGender {
//   const _ResolvedGender(this.imageType, this.genderProfileType, this.filterProfileType);
//   final String imageType;
//   final String genderProfileType;
//   final String filterProfileType;
// }

// class BeatAuthApi {
//   BeatAuthApi({http.Client? client, this.baseUrl = beatApiBase}) : _client = client ?? http.Client();

//   final http.Client _client;
//   final String baseUrl;

//   Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
//     final response = await _client.post(
//       Uri.parse('$baseUrl$path'),
//       headers: {'Content-Type': 'application/json; charset=UTF-8'},
//       body: jsonEncode(body),
//     );
//     return _decode(response);
//   }

//   Future<Map<String, dynamic>> _get(String path) async {
//     final response = await _client.get(Uri.parse('$baseUrl$path'));
//     return _decode(response);
//   }

//   Map<String, dynamic> _decode(http.Response response) {
//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       throw BeatAuthException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
//     }
//     final decoded = jsonDecode(response.body);
//     if (decoded is Map<String, dynamic>) return decoded;
//     throw BeatAuthException('Unexpected API response');
//   }

//   Future<BeatAuthUser> login({required String username, required String password}) async {
//     final json = await _post('/auth/login', {
//       'username': username,
//       'password': password,
//     });
//     if (!_ok(json['status'])) throw BeatAuthException(json['message']?.toString() ?? 'Login failed');
//     final user = BeatAuthUser.fromJson(Map<String, dynamic>.from(json['data'] as Map));
//     await BeatProfileRouter.saveAuthUser(user);
//     return user;
//   }

//   Future<BeatAuthUser> register(BeatRegistrationRequest request) async {
//     final json = await _post('/auth/registration', request.toJson());
//     if (!_ok(json['status'])) throw BeatAuthException(json['message']?.toString() ?? 'Registration failed');
//     final user = BeatAuthUser.fromJson(Map<String, dynamic>.from(json['data'] as Map));
//     await BeatProfileRouter.saveAuthUser(user);
//     return user;
//   }

//   /// Website returns status 404 when username is available.
//   Future<bool> isUsernameAvailable(String username) async {
//     final json = await _get('/user/getusername/$username');
//     return json['status']?.toString() == '404' || json['status'] == 0;
//   }

//   Future<Map<String, dynamic>?> termsPolicy() async {
//     final json = await _get('/auth/term_policy');
//     if (!_ok(json['status']) || json['data'] is! List || (json['data'] as List).isEmpty) return null;
//     return Map<String, dynamic>.from((json['data'] as List).first as Map);
//   }

//   Future<Map<String, dynamic>?> privacyPolicy() async {
//     final json = await _get('/auth/privecy_policy');
//     if (!_ok(json['status']) || json['data'] is! List || (json['data'] as List).isEmpty) return null;
//     return Map<String, dynamic>.from((json['data'] as List).first as Map);
//   }
// }

// bool _ok(dynamic status) => status?.toString() == '200';

// class BeatProfileRouter {
//   static BeatProfileType parseProfileType(String? value) {
//     if (value == 'single') return BeatProfileType.single;
//     if (value == 'couple') return BeatProfileType.couple;
//     return BeatProfileType.unknown;
//   }

//   static Future<void> saveAuthUser(BeatAuthUser user) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('Access-Token', user.token);
//     await prefs.setString('Access-Sign', user.sign);
//     await prefs.setString('user-id', user.userId);
//     await prefs.setString('profile-type', user.profileType == BeatProfileType.couple ? 'couple' : 'single');

//     // Messenger compatibility keys copied from website localStorage behavior.
//     await prefs.setString('chatapp_user_id', user.userId);
//     await prefs.setString('chatapp_user_data', jsonEncode(user.raw));
//   }

//   static Future<BeatProfileType> getSavedProfileType() async {
//     final prefs = await SharedPreferences.getInstance();
//     return parseProfileType(prefs.getString('profile-type'));
//   }

//   static Future<Widget> myProfilePage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('Access-Token') ?? '';
//     final sign = prefs.getString('Access-Sign') ?? '';
//     final type = parseProfileType(prefs.getString('profile-type'));

//     if (type == BeatProfileType.couple) {
//       return ViewCoupleProfilePage(accessToken: token, accessSign: sign);
//     }
//     return ViewSingleProfilePage(accessToken: token, accessSign: sign);
//   }

//   static Future<void> openMyProfile(BuildContext context) async {
//     final page = await myProfilePage();
//     if (!context.mounted) return;
//     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//   }

//   static Future<void> openProfileAfterLoginOrSignup(BuildContext context, BeatAuthUser user) async {
//     await saveAuthUser(user);
//     if (!context.mounted) return;
//     if (user.profileType == BeatProfileType.couple) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => ViewCoupleProfilePage(accessToken: user.token, accessSign: user.sign)),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => ViewSingleProfilePage(accessToken: user.token, accessSign: user.sign)),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/profile_provider.dart';
import 'profile_tabs/my_profile_album_tab.dart';
import 'profile_tabs/my_profile_edit_tab.dart';
import 'profile_tabs/my_profile_home_tab.dart';
import 'profile_tabs/my_profile_location_tab.dart';
import 'profile_tabs/my_profile_photos_tab.dart';
import 'profile_tabs/my_profile_video_tab.dart';
import 'package:beatflirt/profile_detials/beat_view_single_profile_page.dart';

class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({super.key});

  static const List<String> _tabLabels = [
    'Home',
    'Edit',
    'Photos',
    'Video',
    'Album',
    'Location',
  ];

  List<Widget> _tabPages() {
    return const [
      // MyProfileHomeTab(),
      ViewSingleProfileHomeTab(),  //main
      
      MyProfileEditTab(),
      MyProfilePhotosTab(),
      MyProfileVideoTab(),
      MyProfileAlbumTab(),
      MyProfileLocationTab(),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(profileTabProvider);
    final pages = _tabPages();

    // Trigger fetch on mount
    ref.listen(profileProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTopTabs(ref, selectedTabIndex),
                const SizedBox(height: 14),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: SingleChildScrollView(
                      key: ValueKey<int>(selectedTabIndex),
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: pages[selectedTabIndex],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopTabs(WidgetRef ref, int selectedTabIndex) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Threshold: if available width >= 400, use fixed tabs; else scrollable
        final isWide = constraints.maxWidth >= 400;

        final tabBar = Container(
          margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF14001C), Color(0xFF3B004B)],
            ),
          ),
          child: isWide
              // ── Fixed layout for wide screens ──
              ? Row(
                  children: List.generate(
                    _tabLabels.length,
                    (index) => _TopTab(
                      label: _tabLabels[index],
                      selected: selectedTabIndex == index,
                      onTap: () {
                        ref.read(profileTabProvider.notifier).state = index;
                      },
                    ),
                  ),
                )
              // ── Scrollable layout for small screens ──
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      _tabLabels.length,
                      (index) => _TopTab(
                        label: _tabLabels[index],
                        selected: selectedTabIndex == index,
                        onTap: () {
                          ref.read(profileTabProvider.notifier).state = index;
                        },
                        scrollable: true, // tell the tab not to use Expanded
                      ),
                    ),
                  ),
                ),
        );

        return tabBar;
      },
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.scrollable = false, // NEW
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool scrollable; // NEW

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 30,
          // Fixed min-width for scrollable mode so text never clips
          constraints: scrollable ? const BoxConstraints(minWidth: 72) : null,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );

    // In wide mode use Expanded to fill the row evenly
    // In scrollable mode just return the widget directly
    return scrollable ? child : Expanded(child: child);
  }
}



// //   Widget _buildTopTabs(WidgetRef ref, int selectedTabIndex) {
// //     return Container(
// //       margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
// //       padding: const EdgeInsets.all(6),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(28),
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF14001C), Color(0xFF3B004B)],
// //         ),
// //       ),
// //       child: Row(
// //         children: List.generate(
// //           _tabLabels.length,
// //           (index) => _TopTab(
// //             label: _tabLabels[index],
// //             selected: selectedTabIndex == index,
// //             onTap: () {
// //               ref.read(profileTabProvider.notifier).state = index;
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _TopTab extends StatelessWidget {
// //   const _TopTab({
// //     required this.label,
// //     required this.onTap,
// //     this.selected = false,
// //   });

// //   final String label;
// //   final VoidCallback onTap;
// //   final bool selected;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           borderRadius: BorderRadius.circular(16),
// //           onTap: onTap,
// //           child: Container(
// //             height: 30,
// //             alignment: Alignment.center,
// //             decoration: BoxDecoration(
// //               color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// //               borderRadius: BorderRadius.circular(16),
// //             ),
// //             child: Text(
// //               label,
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 11,
// //                 fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_home_tab.dart';
// // // import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_album_tab.dart';
// // // import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_edit_tab.dart';
// // // import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_location_tab.dart';
// // // import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_photos_tab.dart';
// // // import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_video_tab.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import '../../providers/profile_provider.dart';
// // // import '../../core/constants.dart';
// // //
// // // import '../../profile_avatar.dart';
// // // // import '/home_tab.dart';
// // // // import 'tabs/edit_tab.dart';
// // // // import 'tabs/photos_tab.dart';
// // // // import 'tabs/videos_tab.dart';
// // // // import 'tabs/album_tab.dart';
// // // // import 'tabs/locations_tab.dart';
// // //
// // //
// // // class MyProfileScreen extends ConsumerStatefulWidget {
// // //   const MyProfileScreen({super.key});
// // //
// // //   @override
// // //   ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
// // // }
// // //
// // // class _MyProfileScreenState extends ConsumerState<MyProfileScreen>
// // //     with SingleTickerProviderStateMixin {
// // //   late TabController _tabController;
// // //
// // //   final List<_TabItem> _tabs = [
// // //     _TabItem(icon: Icons.home_rounded, label: 'Home'),
// // //     _TabItem(icon: Icons.edit_rounded, label: 'Edit'),
// // //     _TabItem(icon: Icons.photo_camera_rounded, label: 'Photos'),
// // //     _TabItem(icon: Icons.videocam_rounded, label: 'Videos'),
// // //     _TabItem(icon: Icons.photo_album_rounded, label: 'Album'),
// // //     _TabItem(icon: Icons.location_on_rounded, label: 'Locations'),
// // //   ];
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: _tabs.length, vsync: this);
// // //     _tabController.addListener(() {
// // //       if (!_tabController.indexIsChanging) {
// // //         ref.read(selectedTabProvider.notifier).state = _tabController.index;
// // //       }
// // //     });
// // //
// // //     // Fetch profile on init
// // //     Future.microtask(() {
// // //       ref.read(profileProvider.notifier).fetchProfile();
// // //     });
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _tabController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final profileState = ref.watch(profileProvider);
// // //     final selectedTab = ref.watch(selectedTabProvider);
// // //
// // //     return Scaffold(
// // //       backgroundColor: AppColors.background,
// // //       appBar: _buildAppBar(profileState),
// // //       body: Column(
// // //         children: [
// // //           // Custom Tab Bar
// // //           _buildTabBar(selectedTab),
// // //
// // //           // Tab Content
// // //           Expanded(
// // //             child: TabBarView(
// // //               controller: _tabController,
// // //               children: const [
// // //                 HomeTab(),
// // //                 EditTab(),
// // //                 PhotosTab(),
// // //                 VideosTab(),
// // //                 AlbumTab(),
// // //                 LocationsTab(),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   PreferredSizeWidget _buildAppBar(ProfileState profileState) {
// // //     final profile = profileState.profile;
// // //
// // //     return AppBar(
// // //       backgroundColor: AppColors.surface,
// // //       elevation: 0,
// // //       scrolledUnderElevation: 0,
// // //       title: Row(
// // //         children: [
// // //           // Small avatar in app bar
// // //           if (profile != null)
// // //             ProfileAvatar(
// // //               radius: 18,
// // //               isCouple: profile.isCouple,
// // //             ),
// // //           if (profile != null) const SizedBox(width: 10),
// // //           Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 'My Profile',
// // //                 style: AppTextStyles.heading3.copyWith(fontSize: 17),
// // //               ),
// // //               if (profile != null)
// // //                 Text(
// // //                   profile.profileType.toUpperCase(),
// // //                   style: TextStyle(
// // //                     fontSize: 10,
// // //                     fontWeight: FontWeight.w600,
// // //                     color: profile.isSingle
// // //                         ? AppColors.primary
// // //                         : AppColors.accent,
// // //                     letterSpacing: 1.2,
// // //                   ),
// // //                 ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //       actions: [
// // //         // Refresh button
// // //         IconButton(
// // //           icon: const Icon(
// // //             Icons.refresh,
// // //             color: AppColors.textSecondary,
// // //           ),
// // //           onPressed: () {
// // //             ref.read(profileProvider.notifier).fetchProfile();
// // //           },
// // //           tooltip: 'Refresh Profile',
// // //         ),
// // //         // Settings button
// // //         IconButton(
// // //           icon: const Icon(
// // //             Icons.settings_outlined,
// // //             color: AppColors.textSecondary,
// // //           ),
// // //           onPressed: () {
// // //             // TODO: Navigate to settings
// // //           },
// // //           tooltip: 'Settings',
// // //         ),
// // //         const SizedBox(width: 4),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildTabBar(int selectedTab) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: AppColors.surface,
// // //         border: Border(
// // //           bottom: BorderSide(
// // //             color: AppColors.divider.withOpacity(0.5),
// // //             width: 1,
// // //           ),
// // //         ),
// // //       ),
// // //       child: TabBar(
// // //         controller: _tabController,
// // //         isScrollable: true,
// // //         tabAlignment: TabAlignment.start,
// // //         indicatorColor: AppColors.primary,
// // //         indicatorWeight: 3,
// // //         indicatorSize: TabBarIndicatorSize.label,
// // //         labelColor: AppColors.primary,
// // //         unselectedLabelColor: AppColors.textMuted,
// // //         labelStyle: AppTextStyles.tabLabel,
// // //         unselectedLabelStyle: AppTextStyles.tabLabel.copyWith(
// // //           fontWeight: FontWeight.w400,
// // //         ),
// // //         padding: const EdgeInsets.symmetric(horizontal: 8),
// // //         labelPadding: const EdgeInsets.symmetric(horizontal: 12),
// // //         dividerColor: Colors.transparent,
// // //         splashBorderRadius: BorderRadius.circular(8),
// // //         tabs: _tabs.map((tab) {
// // //           return Tab(
// // //             height: 48,
// // //             child: Row(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Icon(tab.icon, size: 18),
// // //                 const SizedBox(width: 6),
// // //                 Text(tab.label),
// // //               ],
// // //             ),
// // //           );
// // //         }).toList(),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class _TabItem {
// // //   final IconData icon;
// // //   final String label;
// // //
// // //   _TabItem({required this.icon, required this.label});
// // // }


// // //
// // // import 'package:flutter/material.dart';
// // // import 'tabs/home_tab.dart';
// // // import 'tabs/edit_tab.dart';
// // // import 'tabs/photos_tab.dart';
// // // import 'tabs/about_tab.dart';
// // // import 'tabs/interests_tab.dart';
// // // import '../../models/user_profile.dart';
// // //
// // // class MyProfilePage extends StatefulWidget {
// // //   final String profileType; // 'single' or 'couple'
// // //   final String userId;
// // //
// // //   const MyProfilePage({
// // //     super.key,
// // //     required this.profileType,
// // //     required this.userId,
// // //   });
// // //
// // //   @override
// // //   State<MyProfilePage> createState() => _MyProfilePageState();
// // // }
// // //
// // // class _MyProfilePageState extends State<MyProfilePage> with SingleTickerProviderStateMixin {
// // //   late TabController _tabController;
// // //   UserProfile? profile;
// // //   bool isLoading = true;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: 5, vsync: this);
// // //     _loadProfile();
// // //   }
// // //
// // //   Future<void> _loadProfile() async {
// // //     // TODO: Replace with your actual API
// // //     // Single: https://www.beatflirtevent.com/view-single-profile?id=USER_ID
// // //     // Couple: https://www.beatflirtevent.com/view-couple-profile?id=USER_ID
// // //
// // //     await Future.delayed(const Duration(seconds: 1));
// // //
// // //     setState(() {
// // //       if (widget.profileType == 'single') {
// // //         profile = UserProfile.mockSingle();
// // //       } else {
// // //         profile = UserProfile.mockCouple();
// // //       }
// // //       isLoading = false;
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFF0A0A0A),
// // //       body: isLoading
// // //           ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
// // //           : NestedScrollView(
// // //               headerSliverBuilder: (context, innerBoxIsScrolled) {
// // //                 return [
// // //                   SliverAppBar(
// // //                     expandedHeight: 280,
// // //                     pinned: true,
// // //                     backgroundColor: Colors.black,
// // //                     flexibleSpace: FlexibleSpaceBar(
// // //                       background: _buildProfileHeader(),
// // //                     ),
// // //                     bottom: TabBar(
// // //                       controller: _tabController,
// // //                       isScrollable: true,
// // //                       indicatorColor: const Color(0xFFE91E63),
// // //                       labelColor: Colors.white,
// // //                       unselectedLabelColor: Colors.grey,
// // //                       tabs: const [
// // //                         Tab(text: 'HOME'),
// // //                         Tab(text: 'EDIT'),
// // //                         Tab(text: 'PHOTOS'),
// // //                         Tab(text: 'ABOUT'),
// // //                         Tab(text: 'INTERESTS'),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ];
// // //               },
// // //               body: TabBarView(
// // //                 controller: _tabController,
// // //                 children: [
// // //                   HomeTab(profile: profile!, profileType: widget.profileType),
// // //                   EditTab(profile: profile!, onUpdate: _loadProfile),
// // //                   PhotosTab(profile: profile!),
// // //                   AboutTab(profile: profile!),
// // //                   InterestsTab(profile: profile!),
// // //                 ],
// // //               ),
// // //             ),
// // //     );
// // //   }
// // //
// // //   Widget _buildProfileHeader() {
// // //     final isCouple = widget.profileType == 'couple';
// // //
// // //     return Container(
// // //       decoration: const BoxDecoration(
// // //         gradient: LinearGradient(
// // //           begin: Alignment.topCenter,
// // //           end: Alignment.bottomCenter,
// // //           colors: [Color(0xFF1A1A2E), Color(0xFF0A0A0A)],
// // //         ),
// // //       ),
// // //       child: SafeArea(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             const SizedBox(height: 20),
// // //             if (isCouple)
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   _buildAvatar(profile!.photo1, 80),
// // //                   const SizedBox(width: 20),
// // //                   Container(
// // //                     padding: const EdgeInsets.all(8),
// // //                     decoration: BoxDecoration(
// // //                       color: const Color(0xFFE91E63),
// // //                       shape: BoxShape.circle,
// // //                     ),
// // //                     child: const Icon(Icons.favorite, color: Colors.white, size: 20),
// // //                   ),
// // //                   const SizedBox(width: 20),
// // //                   _buildAvatar(profile!.photo2, 80),
// // //                 ],
// // //               )
// // //             else
// // //               _buildAvatar(profile!.photo1, 100),
// // //             const SizedBox(height: 16),
// // //             Text(
// // //               isCouple ? profile!.coupleName : profile!.displayName,
// // //               style: const TextStyle(
// // //                 color: Colors.white,
// // //                 fontSize: 24,
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 4),
// // //             Text(
// // //               isCouple
// // //                 ? '${profile!.age1} & ${profile!.age2} • ${profile!.location}'
// // //                 : '${profile!.age1}, ${profile!.gender} • ${profile!.location}',
// // //               style: const TextStyle(color: Colors.grey, fontSize: 14),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // //               decoration: BoxDecoration(
// // //                 color: const Color(0xFFE91E63).withOpacity(0.2),
// // //                 borderRadius: BorderRadius.circular(20),
// // //                 border: Border.all(color: const Color(0xFFE91E63)),
// // //               ),
// // //               child: Text(
// // //                 isCouple ? 'COUPLE PROFILE' : 'SINGLE PROFILE',
// // //                 style: const TextStyle(
// // //                   color: Color(0xFFE91E63),
// // //                   fontSize: 12,
// // //                   fontWeight: FontWeight.bold,
// // //                   letterSpacing: 1,
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildAvatar(String? url, double size) {
// // //     return Container(
// // //       width: size,
// // //       height: size,
// // //       decoration: BoxDecoration(
// // //         shape: BoxShape.circle,
// // //         border: Border.all(color: const Color(0xFFE91E63), width: 3),
// // //         image: DecorationImage(
// // //           image: NetworkImage(url ?? 'https://via.placeholder.com/150'),
// // //           fit: BoxFit.cover,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }