// ====================================user_list_provider.dart================================================================
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
//
// class UserListItem {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final String lastSeen;
//   final String location;
//   final int age;
//   final bool isOnline;
//
//   const UserListItem({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.lastSeen,
//     this.location = 'New York, USA',
//     this.age = 24,
//     this.isOnline = false,
//   });
//
//   factory UserListItem.fromMap(Map<String, dynamic> map) {
//     return UserListItem(
//       id: map['id']?.toString() ?? '',
//       name: map['name']?.toString() ?? 'Unknown',
//       imageUrl: map['imageUrl']?.toString() ?? 'assets/images/notification-image1.jpg',
//       lastSeen: map['lastSeen']?.toString() ?? '',
//       location: map['location']?.toString() ?? 'New York, USA',
//       age: map['age'] is int ? map['age'] : 24,
//       isOnline: map['isOnline'] == true,
//     );
//   }
// }
//
// class UserListState {
//   final List<UserListItem> users;
//   final bool isLoading;
//   final String? error;
//
//   const UserListState({
//     this.users = const [],
//     this.isLoading = false,
//     this.error,
//   });
//
//   UserListState copyWith({
//     List<UserListItem>? users,
//     bool? isLoading,
//     String? error,
//   }) {
//     return UserListState(
//       users: users ?? this.users,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
// }
//
// // Example Generic User List Notifier
// class UserListNotifier extends FamilyNotifier<UserListState, String> {
//   final ApiServices _api = ApiServices();
//
//   @override
//   UserListState build(String type) {
//     // Initial fetch
//     Future.microtask(() => fetchUsers());
//     return const UserListState(isLoading: true);
//   }
//
//   Future<void> fetchUsers() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) {
//         state = state.copyWith(isLoading: false, error: 'Unauthorized');
//         return;
//       }
//
//       // Here we differentiate by "type" (e.g., 'favorites', 'blocklist')
//       // For now, I'll mock the endpoint logic or use a generic one if available
//       // Since API doesn't have a specific 'favorites' endpoint yet, we use a placeholder
//
//       // If we had an endpoint:
//       // final response = await _api.getFavorites(token: token);
//
//       // MOCK for current temporary usage as requested
//       await Future.delayed(const Duration(milliseconds: 800));
//
//       final mockData = [
//         {'id': '1', 'name': 'Sarah Connor', 'imageUrl': 'assets/images/notification-image1.jpg', 'lastSeen': '2 mins ago', 'isOnline': true},
//         {'id': '2', 'name': 'John Wick', 'imageUrl': 'assets/images/notification-image4.jpg', 'lastSeen': '1 hour ago'},
//         {'id': '3', 'name': 'Jane Doe', 'imageUrl': 'assets/images/notification-image5.jpg', 'lastSeen': 'Online', 'isOnline': true},
//         {'id': '4', 'name': 'Agent Smith', 'imageUrl': 'assets/images/notification-image6.jpg', 'lastSeen': 'Yesterday'},
//       ];
//
//       state = state.copyWith(
//         isLoading: false,
//         users: mockData.map(UserListItem.fromMap).toList(),
//       );
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }
//
//   Future<void> removeUser(String id) async {
//     // Optimistic UI update
//     final originalUsers = state.users;
//     state = state.copyWith(
//       users: state.users.where((u) => u.id != id).toList(),
//     );
//
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;
//
//       // Call API to remove (commented until endpoint exists)
//       // await _api.removeFavorite(token: token, userId: id);
//     } catch (e) {
//       // Revert on failure
//       state = state.copyWith(users: originalUsers);
//     }
//   }
//
//   Future<void> addUser(UserListItem user) async {
//     state = state.copyWith(users: [user, ...state.users]);
//     // API logic here...
//   }
// }
//
// final userListProvider = NotifierProviderFamily<UserListNotifier, UserListState, String>(UserListNotifier.new);





// ============================================Favorite Page===========================================================
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/providers/user_list_provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// class FavoritePage extends ConsumerWidget {
//   const FavoritePage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(userListProvider('favorites'));
//
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF0F0F1A), // Deep dark
//               Color(0xFF1A1A2E), // Midnight blue tint
//               Color(0xFF0F0F1A),
//             ],
//           ),
//         ),
//         child: RefreshIndicator(
//           color: Colors.pinkAccent,
//           backgroundColor: const Color(0xFF1A1A2E),
//           onRefresh: () => ref.read(userListProvider('favorites').notifier).fetchUsers(),
//           child: CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _buildAppBar(context),
//               if (state.isLoading && state.users.isEmpty)
//                 const SliverFillRemaining(
//                   child: Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
//                 )
//               else if (state.error != null && state.users.isEmpty)
//                 SliverFillRemaining(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.error_outline, color: Colors.white54, size: 60),
//                         const SizedBox(height: 16),
//                         Text(state.error!, style: const TextStyle(color: Colors.white70)),
//                         TextButton(
//                           onPressed: () => ref.read(userListProvider('favorites').notifier).fetchUsers(),
//                           child: const Text('Retry', style: TextStyle(color: Colors.pinkAccent)),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               else ...[
//                   _buildFavoritesHeader(state.users.length),
//                   if (state.users.isEmpty)
//                     const SliverFillRemaining(
//                       hasScrollBody: false,
//                       child: Center(
//                         child: Text(
//                           'No favorites yet.',
//                           style: TextStyle(color: Colors.white54, fontSize: 16),
//                         ),
//                       ),
//                     )
//                   else
//                     _buildFavoritesGrid(state.users, ref),
//                 ],
//               const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       floating: true,
//       pinned: true,
//       backgroundColor: Colors.transparent, // Let the background gradient show through
//       surfaceTintColor: Colors.transparent,
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//         onPressed: () => Navigator.pop(context),
//       ),
//       centerTitle: true,
//       title: const Text(
//         'FAVORITES',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w900,
//           fontSize: 16,
//           letterSpacing: 2.0,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFavoritesHeader(int count) {
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//         padding: const EdgeInsets.all(25),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFFF4081).withValues(alpha: 0.3),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             const CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white24,
//               child: FaIcon(FontAwesomeIcons.solidHeart, color: Colors.white, size: 25),
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Saved Profiles', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//                   Text('$count people in your list', style: const TextStyle(color: Colors.white70, fontSize: 13)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFavoritesGrid(List<UserListItem> users, WidgetRef ref) {
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 15,
//           crossAxisSpacing: 15,
//           childAspectRatio: 0.75,
//         ),
//         delegate: SliverChildBuilderDelegate(
//               (context, index) {
//             final user = users[index];
//             return _buildFavoriteCard(user, ref);
//           },
//           childCount: users.length,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFavoriteCard(UserListItem user, WidgetRef ref) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//       ),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(24),
//             child: user.imageUrl.startsWith('http')
//                 ? Image.network(user.imageUrl, fit: BoxFit.cover)
//                 : Image.asset(user.imageUrl, fit: BoxFit.cover),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(24),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 12,
//             left: 12,
//             right: 12,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, color: Colors.white70, size: 10),
//                     const SizedBox(width: 4),
//                     Text(user.location, style: const TextStyle(color: Colors.white70, fontSize: 10)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 10,
//             right: 10,
//             child: InkWell(
//               onTap: () => ref.read(userListProvider('favorites').notifier).removeUser(user.id),
//               child: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: Colors.black45,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white24),
//                 ),
//                 child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
