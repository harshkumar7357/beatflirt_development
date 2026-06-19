// import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:beatflirt/core/utils/widgets/interest_widgets.dart';
// import 'package:beatflirt/model/couple_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:beatflirt/core/utils/photo_grid.dart';
// import 'package:beatflirt/core/utils/album_grid.dart';
// import 'package:beatflirt/core/utils/video_grid.dart';


// class CoupleProfileViewScreen extends StatefulWidget {
//   const CoupleProfileViewScreen({super.key});

//   @override
//   State<CoupleProfileViewScreen> createState() => _CoupleProfileViewScreenState();
// }

// class _CoupleProfileViewScreenState extends State<CoupleProfileViewScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final ApiService _api = ApiService();

//   CoupleProfile? profileData;
//   List<ProfileImage> approvedImages = [];
//   List<ProfileImage> pendingImages = [];
//   List<ProfileVideo> approvedVideos = [];
//   List<ProfileVideo> pendingVideos = [];
//   List<Album> albums = [];
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _loadAllData();
//   }

//   Future<void> _loadAllData() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });

//     try {
//       // Check login? For demo, assume token or prompt
//       // In real, if not logged, show login first

//       // Load profile
//       final profileResp = await _api.getSingleUserProfile(token: '');
//       if (profileResp['status'] == '200' && profileResp['data'] != null) {
//         // Note: the API may return list or object, adjust based on real response
//         final data = profileResp['data'] is List ? profileResp['data'][0] : profileResp['data'];
//         profileData = CoupleProfile.fromJson(data);
//       }

//       // Load images
//       final approveImgResp = await _api.getApproveProfileImages();
//       if (approveImgResp['status'] == '200' && approveImgResp['data'] != null) {
//         approvedImages = (approveImgResp['data'] as List)
//             .map((e) => ProfileImage.fromJson(e))
//             .toList();
//       }

//       final pendingImgResp = await _api.getPendingProfileImages();
//       if (pendingImgResp['status'] == '200' && pendingImgResp['data'] != null) {
//         pendingImages = (pendingImgResp['data'] as List)
//             .map((e) => ProfileImage.fromJson(e))
//             .toList();
//       }

//       // Videos
//       final approveVidResp = await _api.getApproveProfileVideos();
//       if (approveVidResp['status'] == '200' && approveVidResp['data'] != null) {
//         approvedVideos = (approveVidResp['data'] as List)
//             .map((e) => ProfileVideo.fromJson(e))
//             .toList();
//       }

//       final pendingVidResp = await _api.getPendingProfileVideos();
//       if (pendingVidResp['status'] == '200' && pendingVidResp['data'] != null) {
//         pendingVideos = (pendingVidResp['data'] as List)
//             .map((e) => ProfileVideo.fromJson(e))
//             .toList();
//       }

//       // Albums
//       final albumResp = await _api.getAllAlbums();
//       if (albumResp['status'] == '200' && albumResp['data'] != null) {
//         albums = (albumResp['data'] as List)
//             .map((e) => Album.fromJson(e))
//             .toList();
//       }

//       // You can load more album images if needed separately

//     } catch (e) {
//       error = e.toString();
//       // For demo, load mock data if API fails (no token)
//       _loadMockData();
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   void _loadMockData() {
//     // Mock data for demo when no token / to show UI
//     profileData = CoupleProfile(
//       id: '1',
//       username: 'demo_couple',
//       text: 'We are a fun loving couple looking for exciting experiences and new friends in the lifestyle.',
//       comment: 'Open to new adventures!',
//       profileImage: 'https://app.beatflirtevent.com/assets/images/img5 (1).png',
//       location: 'New York, USA',
//       coupleMaleFemaleSwingers: '1',
//       coupleFemaleFemaleSwingers: '0',
//       coupleMaleMaleSwingers: '0',
//       coupleMaleSwingers: '0',
//       coupleFemaleSwingers: '1',
//       coupleTransgenderSwingers: '0',
//       coupleMaleFemaleHookupMeetup: '1',
//       coupleFemaleFemaleHookupMeetup: '1',
//       coupleMaleMaleHookupMeetup: '0',
//       coupleMaleHookupMeetup: '0',
//       coupleFemaleHookupMeetup: '1',
//       coupleTransgenderHookupMeetup: '0',
//     );

//     approvedImages = [
//       ProfileImage(id: '1', profileImage: 'https://app.beatflirtevent.com/assets/images/img5.png', setProfile: '1'),
//       ProfileImage(id: '2', profileImage: 'https://app.beatflirtevent.com/assets/images/img6.png'),
//     ];
//     pendingImages = [
//       ProfileImage(id: '3', profileImage: 'https://app.beatflirtevent.com/assets/images/img7.png'),
//     ];

//     approvedVideos = [
//       ProfileVideo(id: '1', profileVideo: 'https://app.beatflirtevent.com/assets/images/18-WhatsApp-Video-2024-09-27-at-3.11.31-PM.mp4'),
//     ];
//     pendingVideos = [];

//     albums = [
//       Album(id: '1', albumName: 'Our Vacation', image: 'https://app.beatflirtevent.com/assets/images/img8.png'),
//       Album(id: '2', albumName: 'Private Party', image: 'https://app.beatflirtevent.com/assets/images/img9.png'),
//     ];
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('View Couple Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadAllData,
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await _api.logout(token: '');
//               // navigate to login if needed
//             },
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           tabs: const [
//             Tab(text: 'Overview'),
//             Tab(text: 'Photos'),
//             Tab(text: 'Videos'),
//             Tab(text: 'Albums'),
//             Tab(text: 'Interests'),
//           ],
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.pink))
//           : error != null && profileData == null
//               ? Center(child: Text('Error: $error\nShowing demo data.', style: const TextStyle(color: Colors.white)))
//               : TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildOverviewTab(),
//                     _buildPhotosTab(),
//                     _buildVideosTab(),
//                     _buildAlbumsTab(),
//                     _buildInterestsTab(),
//                   ],
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // e.g. edit or message
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Message / Edit feature - integrate chat API here')),
//           );
//         },
//         backgroundColor: const Color(0xFF560827),
//         child: const Icon(Icons.message),
//       ),
//     );
//   }

//   Widget _buildOverviewTab() {
//     if (profileData == null) return const Center(child: Text('No profile data', style: TextStyle(color: Colors.white)));
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Main profile image
//           if (profileData!.profileImage != null)
//             Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Image.network(
//                   profileData!.profileImage!,
//                   height: 200,
//                   width: 200,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 100, color: Colors.grey),
//                 ),
//               ),
//             ),
//           const SizedBox(height: 16),
//           Text(
//             profileData!.username ?? 'Couple',
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           if (profileData!.location != null)
//             Text(profileData!.location!, style: const TextStyle(color: Colors.grey)),
//           const SizedBox(height: 16),
//           const Text('Bio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
//           Text(
//             profileData!.text ?? 'No bio available.',
//             style: const TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//           const SizedBox(height: 8),
//           if (profileData!.comment != null && profileData!.comment!.isNotEmpty)
//             Text(
//               profileData!.comment!,
//               style: const TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
//             ),
//           const SizedBox(height: 24),
//           // Add more overview like stats, etc.
//           const Text('Quick Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
//           const ListTile(
//             leading: Icon(Icons.location_on, color: Colors.pink),
//             title: Text('Location', style: TextStyle(color: Colors.white)),
//             subtitle: Text('New York, USA', style: TextStyle(color: Colors.white70)),
//           ),
//           // Add more from profileData
//         ],
//       ),
//     );
//   }

//   Widget _buildPhotosTab() {
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           const TabBar(
//             tabs: [
//               Tab(text: 'Approved'),
//               Tab(text: 'Pending Approval'),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 PhotoGrid(
//                   images: approvedImages,
//                   onDelete: (img) async {
//                     final res = await _api.deleteProfileImage(img.id);
//                     if (res['status'] == '200') {
//                       setState(() {
//                         approvedImages.removeWhere((e) => e.id == img.id);
//                       });
//                     }
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Deleted')));
//                   },
//                   onSetMain: (img) async {
//                     final res = await _api.setProfilePicture(img.id);
//                     if (res['status'] == '200') {
//                       // refresh or update
//                       _loadAllData();
//                     }
//                   },
//                   isApproved: true,
//                 ),
//                 PhotoGrid(
//                   images: pendingImages,
//                   onDelete: (img) async {
//                     final res = await _api.deleteProfileImage(img.id);
//                     if (res['status'] == '200') {
//                       setState(() => pendingImages.removeWhere((e) => e.id == img.id));
//                     }
//                   },
//                   onSetMain: null, // can't set main for pending
//                   isApproved: false,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideosTab() {
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           const TabBar(
//             tabs: [
//               Tab(text: 'Approved'),
//               Tab(text: 'Pending'),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 VideoGrid(videos: approvedVideos, onDelete: (v) async {
//                   await _api.deleteProfileVideo(v.id);
//                   setState(() => approvedVideos.removeWhere((e) => e.id == v.id));
//                 }),
//                 VideoGrid(videos: pendingVideos, onDelete: (v) async {
//                   await _api.deleteProfileVideo(v.id);
//                   setState(() => pendingVideos.removeWhere((e) => e.id == v.id));
//                 }),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAlbumsTab() {
//     return AlbumGrid(
//       albums: albums,
//       onView: (album) {
//         // Navigate to album detail or call viewAlbum API
//         // For now show dialog
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: Text(album.albumName),
//             content: const Text('Album view - integrate get album details API here. Add photos/videos inside.'),
//             actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
//           ),
//         );
//       },
//       onDelete: (album) async {
//         // call delete API
//         // await _api.deleteAlbum(album.id);
//         setState(() => albums.removeWhere((a) => a.id == album.id));
//       },
//       onAddPhoto: (album) {
//         // Show image picker and call uploadAlbumImage
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload photo to album - use image_picker + upload API')));
//       },
//       onAddVideo: (album) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload video to album')));
//       },
//       onEdit: (album) {
//         // edit name & password
//       },
//     );
//   }

//   Widget _buildInterestsTab() {
//     return InterestsWidget(profile: profileData);
//   }
// }
