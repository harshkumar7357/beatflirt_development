// // // // // // // // import 'package:beatflirt/Api_services/api_service.dart';
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // // import 'package:beatflirt/providers/celebrity_provider.dart';
// // // // // // // // import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// // // // // // // // import 'package:beatflirt/providers/user_list_provider.dart';
// // // // // // // // import 'package:beatflirt/core/utils/image_utils.dart';

// // // // // // // // class CelebrityPanelPage extends ConsumerWidget {
// // // // // // // //   const CelebrityPanelPage({super.key});

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // // // //     final state = ref.watch(celebrityProvider);

// // // // // // // //     return Scaffold(
// // // // // // // //       backgroundColor: const Color(0xFF0F0F1A), // Deep dark premium background
// // // // // // // //       body: CustomScrollView(
// // // // // // // //         slivers: [
// // // // // // // //           _buildAppBar(context),
// // // // // // // //           if (state.isLoading)
// // // // // // // //             const SliverFillRemaining(
// // // // // // // //               child: Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
// // // // // // // //             )
// // // // // // // //           else if (state.error != null && state.trendingCelebrities.isEmpty)
// // // // // // // //             SliverFillRemaining(
// // // // // // // //               child: Center(
// // // // // // // //                 child: Column(
// // // // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //                   children: [
// // // // // // // //                     const Icon(Icons.error_outline, color: Colors.white24, size: 48),
// // // // // // // //                     const SizedBox(height: 16),
// // // // // // // //                     Text(
// // // // // // // //                       'Failed to load celebrities',
// // // // // // // //                       style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
// // // // // // // //                     ),
// // // // // // // //                     TextButton(
// // // // // // // //                       onPressed: () => ref.read(celebrityProvider.notifier).fetchCelebrityPanel(),
// // // // // // // //                       child: const Text('Retry', style: TextStyle(color: Colors.pinkAccent)),
// // // // // // // //                     ),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             )
// // // // // // // //           else ...[
// // // // // // // //             _buildSearchAndFilter(),
// // // // // // // //             _buildSectionTitle('Trending Now'),
// // // // // // // //             _buildTrendingList(state.trendingCelebrities),
// // // // // // // //             _buildSectionTitle('Top Rated Experts'),
// // // // // // // //             _buildExpertGrid(state.topRatedCelebrities),
// // // // // // // //             const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
// // // // // // // //           ],
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //       floatingActionButton: FloatingActionButton.extended(
// // // // // // // //         onPressed: () {},
// // // // // // // //         backgroundColor: Colors.pinkAccent,
// // // // // // // //         icon: const Icon(Icons.star, color: Colors.white),
// // // // // // // //         label: const Text('Apply as Star', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // // Widget _buildAppBar(BuildContext context) {
// // // // // // // //   return SliverAppBar(
// // // // // // // //     leading: IconButton(
// // // // // // // //       icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
// // // // // // // //       onPressed: () => Navigator.pop(context),
// // // // // // // //     ),
// // // // // // // //     expandedHeight: 120.0,
// // // // // // // //     floating: false,
// // // // // // // //     pinned: true,
// // // // // // // //     backgroundColor: const Color(0xFF0F0F1A),
// // // // // // // //     elevation: 0,
// // // // // // // //     flexibleSpace: LayoutBuilder(
// // // // // // // //       builder: (context, constraints) {
// // // // // // // //         final double top = MediaQuery.of(context).padding.top;
// // // // // // // //         final double collapsedHeight = kToolbarHeight + top;
// // // // // // // //         final bool isCollapsed = constraints.maxHeight <= collapsedHeight + 10;

// // // // // // // //         return FlexibleSpaceBar(
// // // // // // // //           centerTitle: false,
// // // // // // // //           titlePadding: EdgeInsets.only(
// // // // // // // //             left: isCollapsed ? 50 : 20,
// // // // // // // //             bottom: 13,
// // // // // // // //           ),
// // // // // // // //           title: const Text(
// // // // // // // //             'Celebrity Panel',
// // // // // // // //             style: TextStyle(
// // // // // // // //               color: Colors.white,
// // // // // // // //               fontWeight: FontWeight.bold,
// // // // // // // //               fontSize: 20,
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           background: Container(
// // // // // // // //             decoration: const BoxDecoration(
// // // // // // // //               gradient: LinearGradient(
// // // // // // // //                 begin: Alignment.topCenter,
// // // // // // // //                 end: Alignment.bottomCenter,
// // // // // // // //                 colors: [Colors.pinkAccent, Color(0xFF0F0F1A)],
// // // // // // // //                 stops: [0.0, 0.7],
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         );
// // // // // // // //       },
// // // // // // // //     ),
// // // // // // // //     actions: [
// // // // // // // //       IconButton(
// // // // // // // //         icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
// // // // // // // //         onPressed: () {},
// // // // // // // //       ),
// // // // // // // //       const SizedBox(width: 8),
// // // // // // // //     ],
// // // // // // // //   );
// // // // // // // // }

// // // // // // // //   Widget _buildSearchAndFilter() {
// // // // // // // //     return SliverToBoxAdapter(
// // // // // // // //       child: Padding(
// // // // // // // //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// // // // // // // //         child: Row(
// // // // // // // //           children: [
// // // // // // // //             Expanded(
// // // // // // // //               child: Container(
// // // // // // // //                 height: 50,
// // // // // // // //                 decoration: BoxDecoration(
// // // // // // // //                   color: Colors.white.withValues(alpha: 0.1),
// // // // // // // //                   borderRadius: BorderRadius.circular(15),
// // // // // // // //                 ),
// // // // // // // //                 child: TextField(
// // // // // // // //                   style: const TextStyle(color: Colors.white),
// // // // // // // //                   decoration: const InputDecoration(
// // // // // // // //                     hintText: 'Search celebrities...',
// // // // // // // //                     hintStyle: TextStyle(color: Colors.white54),
// // // // // // // //                     prefixIcon: Icon(Icons.search, color: Colors.white54),
// // // // // // // //                     border: InputBorder.none,
// // // // // // // //                     contentPadding: EdgeInsets.symmetric(vertical: 15),
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //             const SizedBox(width: 12),
// // // // // // // //             Container(
// // // // // // // //               height: 50,
// // // // // // // //               width: 50,
// // // // // // // //               decoration: BoxDecoration(
// // // // // // // //                 color: Colors.pinkAccent.withValues(alpha: 0.2),
// // // // // // // //                 borderRadius: BorderRadius.circular(15),
// // // // // // // //                 border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.5)),
// // // // // // // //               ),
// // // // // // // //               child: const Icon(Icons.tune, color: Colors.pinkAccent),
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildSectionTitle(String title) {
// // // // // // // //     return SliverToBoxAdapter(
// // // // // // // //       child: Padding(
// // // // // // // //         padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
// // // // // // // //         child: Row(
// // // // // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // //           children: [
// // // // // // // //             Text(
// // // // // // // //               title,
// // // // // // // //               style: const TextStyle(
// // // // // // // //                 color: Colors.white,
// // // // // // // //                 fontSize: 18,
// // // // // // // //                 fontWeight: FontWeight.bold,
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //             TextButton(
// // // // // // // //               onPressed: () {},
// // // // // // // //               child: const Text('View All', style: TextStyle(color: Colors.pinkAccent)),
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildTrendingList(List<Celebrity> celebs) {
// // // // // // // //     return SliverToBoxAdapter(
// // // // // // // //       child: SizedBox(
// // // // // // // //         height: 280,
// // // // // // // //         child: ListView.builder(
// // // // // // // //           scrollDirection: Axis.horizontal,
// // // // // // // //           padding: const EdgeInsets.only(left: 20),
// // // // // // // //           itemCount: celebs.length,
// // // // // // // //           itemBuilder: (context, index) {
// // // // // // // //             final celeb = celebs[index];
// // // // // // // //             return GestureDetector(
// // // // // // // //               onTap: () => Navigator.push(
// // // // // // // //                 context,
// // // // // // // //                 MaterialPageRoute(builder: (_) => OtherUserProfilePage(user: UserListItem(
// // // // // // // //                   id: celeb.id,
// // // // // // // //                   name: celeb.name,
// // // // // // // //                   imageUrl: celeb.imageUrl,
// // // // // // // //                   lastSeen: celeb.isOnline ? 'Online' : 'Offline',
// // // // // // // //                   location: celeb.location,
// // // // // // // //                   isOnline: celeb.isOnline,
// // // // // // // //                 ))),
// // // // // // // //               ),
// // // // // // // //               child: Container(
// // // // // // // //                 width: 200,
// // // // // // // //                 margin: const EdgeInsets.only(right: 16),
// // // // // // // //                 child: Stack(
// // // // // // // //                   fit: StackFit.expand,
// // // // // // // //                   children: [
// // // // // // // //                     ClipRRect(
// // // // // // // //                       borderRadius: BorderRadius.circular(24),
// // // // // // // //                       child: buildUserImage(celeb.imageUrl),
// // // // // // // //                     ),
// // // // // // // //                     Container(
// // // // // // // //                       padding: const EdgeInsets.all(16),
// // // // // // // //                       decoration: BoxDecoration(
// // // // // // // //                         borderRadius: BorderRadius.circular(24),
// // // // // // // //                         gradient: LinearGradient(
// // // // // // // //                           begin: Alignment.topCenter,
// // // // // // // //                           end: Alignment.bottomCenter,
// // // // // // // //                           colors: [
// // // // // // // //                             Colors.transparent,
// // // // // // // //                             Colors.black.withValues(alpha: 0.8),
// // // // // // // //                           ],
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                       child: Column(
// // // // // // // //                         mainAxisAlignment: MainAxisAlignment.end,
// // // // // // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                         children: [
// // // // // // // //                           if (celeb.isOnline)
// // // // // // // //                             Container(
// // // // // // // //                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // // // // //                               decoration: BoxDecoration(
// // // // // // // //                                 color: Colors.greenAccent,
// // // // // // // //                                 borderRadius: BorderRadius.circular(8),
// // // // // // // //                               ),
// // // // // // // //                               child: const Text(
// // // // // // // //                                 'LIVE',
// // // // // // // //                                 style: TextStyle(
// // // // // // // //                                   color: Colors.black,
// // // // // // // //                                   fontSize: 10,
// // // // // // // //                                   fontWeight: FontWeight.bold,
// // // // // // // //                                 ),
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                           const Spacer(),
// // // // // // // //                           Text(
// // // // // // // //                             celeb.name,
// // // // // // // //                             style: const TextStyle(
// // // // // // // //                               color: Colors.white,
// // // // // // // //                               fontSize: 18,
// // // // // // // //                               fontWeight: FontWeight.bold,
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                           Text(
// // // // // // // //                             celeb.category,
// // // // // // // //                             style: TextStyle(
// // // // // // // //                               color: Colors.white.withValues(alpha: 0.7),
// // // // // // // //                               fontSize: 14,
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                           const SizedBox(height: 8),
// // // // // // // //                           Row(
// // // // // // // //                             children: [
// // // // // // // //                               const Icon(Icons.location_on, color: Colors.pinkAccent, size: 14),
// // // // // // // //                               const SizedBox(width: 4),
// // // // // // // //                               Expanded(
// // // // // // // //                                 child: Text(
// // // // // // // //                                   celeb.location,
// // // // // // // //                                   style: const TextStyle(color: Colors.white70, fontSize: 12),
// // // // // // // //                                   maxLines: 1,
// // // // // // // //                                   overflow: TextOverflow.ellipsis,
// // // // // // // //                                 ),
// // // // // // // //                               ),
// // // // // // // //                             ],
// // // // // // // //                           ),
// // // // // // // //                         ],
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             );
// // // // // // // //           },
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildExpertGrid(List<Celebrity> celebs) {
// // // // // // // //     return SliverPadding(
// // // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 20),
// // // // // // // //       sliver: SliverGrid(
// // // // // // // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // // //           crossAxisCount: 2,
// // // // // // // //           mainAxisSpacing: 16,
// // // // // // // //           crossAxisSpacing: 16,
// // // // // // // //           childAspectRatio: 0.75,
// // // // // // // //         ),
// // // // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // // // //           (context, index) {
// // // // // // // //             final celeb = celebs[index];
// // // // // // // //             return GestureDetector(
// // // // // // // //               onTap: () => Navigator.push(
// // // // // // // //                 context,
// // // // // // // //                 MaterialPageRoute(builder: (_) => OtherUserProfilePage(user: UserListItem(
// // // // // // // //                   id: celeb.id,
// // // // // // // //                   name: celeb.name,
// // // // // // // //                   imageUrl: celeb.imageUrl,
// // // // // // // //                   lastSeen: celeb.isOnline ? 'Online' : 'Offline',
// // // // // // // //                   location: celeb.location,
// // // // // // // //                   isOnline: celeb.isOnline,
// // // // // // // //                 ))),
// // // // // // // //               ),
// // // // // // // //               child: Container(
// // // // // // // //                 decoration: BoxDecoration(
// // // // // // // //                   color: Colors.white.withValues(alpha: 0.05),
// // // // // // // //                   borderRadius: BorderRadius.circular(20),
// // // // // // // //                   border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
// // // // // // // //                 ),
// // // // // // // //                 child: Column(
// // // // // // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                   children: [
// // // // // // // //                     Expanded(
// // // // // // // //                       child: ClipRRect(
// // // // // // // //                         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// // // // // // // //                         child: buildUserImage(celeb.imageUrl),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                     Padding(
// // // // // // // //                       padding: const EdgeInsets.all(12),
// // // // // // // //                       child: Column(
// // // // // // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                         children: [
// // // // // // // //                           Text(
// // // // // // // //                             celeb.name,
// // // // // // // //                             style: const TextStyle(
// // // // // // // //                               color: Colors.white,
// // // // // // // //                               fontWeight: FontWeight.bold,
// // // // // // // //                               fontSize: 15,
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                           const SizedBox(height: 4),
// // // // // // // //                           Row(
// // // // // // // //                             children: [
// // // // // // // //                               const Icon(Icons.star, color: Colors.amber, size: 14),
// // // // // // // //                               const SizedBox(width: 4),
// // // // // // // //                               Text(
// // // // // // // //                                 celeb.rating.toString(),
// // // // // // // //                                 style: const TextStyle(color: Colors.white70, fontSize: 12),
// // // // // // // //                               ),
// // // // // // // //                               const Spacer(),
// // // // // // // //                               Text(
// // // // // // // //                                 celeb.category,
// // // // // // // //                                 style: const TextStyle(color: Colors.pinkAccent, fontSize: 11),
// // // // // // // //                               ),
// // // // // // // //                             ],
// // // // // // // //                           ),
// // // // // // // //                         ],
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             );
// // // // // // // //           },
// // // // // // // //           childCount: celebs.length,
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // ╔═══════════════════════════════════════════════════════════════════╗
// // // // // // // // ║  Celebrity Panel – Pay-Per-Click (Chocolate Factory)            ║
// // // // // // // // ║  Single self-contained file — paste into your existing project  ║
// // // // // // // // ║  API: https://app.beatflirtevent.com/App                        ║
// // // // // // // // ╚═══════════════════════════════════════════════════════════════════╝

// // // // // // // import 'dart:convert';
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // import 'package:http/http.dart' as http;

// // // // // // // // ── Uncomment these imports for your existing project ────────────
// // // // // // // // import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// // // // // // // // import 'package:beatflirt/providers/user_list_provider.dart';
// // // // // // // // import 'package:beatflirt/core/utils/image_utils.dart';

// // // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // // 1)  A P I   C O N S T A N T S
// // // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // // const String kApiBase = 'https://app.beatflirtevent.com/App';
// // // // // // // const String kAssetBase = 'https://app.beatflirtevent.com/assets/';
// // // // // // // const List<String> kPreferenceOptions = [
// // // // // // //   'Orgy',
// // // // // // //   'Gang Bang',
// // // // // // //   'Couple',
// // // // // // //   'BDSM',
// // // // // // //   'Dom',
// // // // // // //   'Sub',
// // // // // // //   'Cuckolder',
// // // // // // //   'Bull Stag',
// // // // // // // ];

// // // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // // 2)  D A T A   M O D E L S
// // // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // // class ChocolateFactoryUser {
// // // // // // //   final String id;
// // // // // // //   final String username;
// // // // // // //   final String age;
// // // // // // //   final String showAge;
// // // // // // //   final String stateOfResidence;
// // // // // // //   final String heightFeet;
// // // // // // //   final String heightInch;
// // // // // // //   final String showHeight;
// // // // // // //   final String weight;
// // // // // // //   final String showWeight;
// // // // // // //   final List<String> preferences;
// // // // // // //   final String showPreferences;
// // // // // // //   final String selfDescription;
// // // // // // //   final List<ChocolateFactoryImage> images;

// // // // // // //   const ChocolateFactoryUser({
// // // // // // //     required this.id,
// // // // // // //     required this.username,
// // // // // // //     required this.age,
// // // // // // //     required this.showAge,
// // // // // // //     required this.stateOfResidence,
// // // // // // //     required this.heightFeet,
// // // // // // //     required this.heightInch,
// // // // // // //     required this.showHeight,
// // // // // // //     required this.weight,
// // // // // // //     required this.showWeight,
// // // // // // //     required this.preferences,
// // // // // // //     required this.showPreferences,
// // // // // // //     required this.selfDescription,
// // // // // // //     required this.images,
// // // // // // //   });

// // // // // // //   String get profileImage => images.isNotEmpty ? images.first.profileImage : '';

// // // // // // //   String get displayHeight => "${heightFeet}' ${heightInch}\"";

// // // // // // //   factory ChocolateFactoryUser.fromJson(Map<String, dynamic> j) {
// // // // // // //     return ChocolateFactoryUser(
// // // // // // //       id: '${j['id'] ?? ''}',
// // // // // // //       username: '${j['username'] ?? ''}',
// // // // // // //       age: '${j['age'] ?? ''}',
// // // // // // //       showAge: '${j['show_age'] ?? '0'}',
// // // // // // //       stateOfResidence: '${j['state_of_residence'] ?? ''}',
// // // // // // //       heightFeet: '${j['height_feet'] ?? ''}',
// // // // // // //       heightInch: '${j['height_inch'] ?? ''}',
// // // // // // //       showHeight: '${j['show_height'] ?? '0'}',
// // // // // // //       weight: '${j['weight'] ?? ''}',
// // // // // // //       showWeight: '${j['show_weight'] ?? '0'}',
// // // // // // //       preferences:
// // // // // // //           (j['preferences'] as List<dynamic>?)?.map((e) => '$e').toList() ?? [],
// // // // // // //       showPreferences: '${j['show_preferences'] ?? '0'}',
// // // // // // //       selfDescription: '${j['self_description'] ?? ''}',
// // // // // // //       images:
// // // // // // //           (j['image'] as List<dynamic>?)
// // // // // // //               ?.map((e) => ChocolateFactoryImage.fromJson(e))
// // // // // // //               .toList() ??
// // // // // // //           [],
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // class ChocolateFactoryImage {
// // // // // // //   final String profileImage;
// // // // // // //   const ChocolateFactoryImage({required this.profileImage});
// // // // // // //   factory ChocolateFactoryImage.fromJson(Map<String, dynamic> j) =>
// // // // // // //       ChocolateFactoryImage(profileImage: '${j['profile_image'] ?? ''}');
// // // // // // // }

// // // // // // // class CalendarSlot {
// // // // // // //   final String username;
// // // // // // //   final String calenderDate;
// // // // // // //   final String startTime12Format;
// // // // // // //   final String endTime12Format;
// // // // // // //   const CalendarSlot({
// // // // // // //     required this.username,
// // // // // // //     required this.calenderDate,
// // // // // // //     required this.startTime12Format,
// // // // // // //     required this.endTime12Format,
// // // // // // //   });
// // // // // // //   factory CalendarSlot.fromJson(Map<String, dynamic> j) => CalendarSlot(
// // // // // // //     username: '${j['username'] ?? ''}',
// // // // // // //     calenderDate: '${j['calender_date'] ?? ''}',
// // // // // // //     startTime12Format: '${j['start_time_12_formate'] ?? ''}',
// // // // // // //     endTime12Format: '${j['end_time_12_formate'] ?? ''}',
// // // // // // //   );
// // // // // // // }

// // // // // // // class TermsCondition {
// // // // // // //   final String description;
// // // // // // //   const TermsCondition({required this.description});
// // // // // // //   factory TermsCondition.fromJson(Map<String, dynamic> j) =>
// // // // // // //       TermsCondition(description: '${j['description'] ?? ''}');
// // // // // // // }

// // // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // // 3)  S T A T E
// // // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // // class PanelState {
// // // // // // //   final bool isLoading;
// // // // // // //   final String? error;
// // // // // // //   final ChocolateFactoryUser? myProfile;
// // // // // // //   final List<ChocolateFactoryUser> allUsers;
// // // // // // //   final String searchQuery;
// // // // // // //   // filter values
// // // // // // //   final int ageMin;
// // // // // // //   final int ageMax;
// // // // // // //   final int heightMin;
// // // // // // //   final int heightMax;
// // // // // // //   final int weightMin;
// // // // // // //   final int weightMax;
// // // // // // //   final List<String> selectedPreferences;

// // // // // // //   const PanelState({
// // // // // // //     this.isLoading = false,
// // // // // // //     this.error,
// // // // // // //     this.myProfile,
// // // // // // //     this.allUsers = const [],
// // // // // // //     this.searchQuery = '',
// // // // // // //     this.ageMin = 18,
// // // // // // //     this.ageMax = 80,
// // // // // // //     this.heightMin = 3,
// // // // // // //     this.heightMax = 8,
// // // // // // //     this.weightMin = 20,
// // // // // // //     this.weightMax = 150,
// // // // // // //     this.selectedPreferences = const [],
// // // // // // //   });

// // // // // // //   PanelState copyWith({
// // // // // // //     bool? isLoading,
// // // // // // //     String? error,
// // // // // // //     ChocolateFactoryUser? myProfile,
// // // // // // //     List<ChocolateFactoryUser>? allUsers,
// // // // // // //     String? searchQuery,
// // // // // // //     int? ageMin,
// // // // // // //     int? ageMax,
// // // // // // //     int? heightMin,
// // // // // // //     int? heightMax,
// // // // // // //     int? weightMin,
// // // // // // //     int? weightMax,
// // // // // // //     List<String>? selectedPreferences,
// // // // // // //   }) {
// // // // // // //     return PanelState(
// // // // // // //       isLoading: isLoading ?? this.isLoading,
// // // // // // //       error: error,
// // // // // // //       myProfile: myProfile ?? this.myProfile,
// // // // // // //       allUsers: allUsers ?? this.allUsers,
// // // // // // //       searchQuery: searchQuery ?? this.searchQuery,
// // // // // // //       ageMin: ageMin ?? this.ageMin,
// // // // // // //       ageMax: ageMax ?? this.ageMax,
// // // // // // //       heightMin: heightMin ?? this.heightMin,
// // // // // // //       heightMax: heightMax ?? this.heightMax,
// // // // // // //       weightMin: weightMin ?? this.weightMin,
// // // // // // //       weightMax: weightMax ?? this.weightMax,
// // // // // // //       selectedPreferences: selectedPreferences ?? this.selectedPreferences,
// // // // // // //     );
// // // // // // //   }

// // // // // // //   List<ChocolateFactoryUser> get filteredUsers {
// // // // // // //     var list = allUsers;
// // // // // // //     if (searchQuery.isNotEmpty) {
// // // // // // //       list = list
// // // // // // //           .where(
// // // // // // //             (u) => u.username.toLowerCase().contains(searchQuery.toLowerCase()),
// // // // // // //           )
// // // // // // //           .toList();
// // // // // // //     }
// // // // // // //     return list;
// // // // // // //   }
// // // // // // // }

// // // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // // 4)  N O T I F I E R   (API calls + state)
// // // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // // class PanelNotifier extends StateNotifier<PanelState> {
// // // // // // //   String? _token;

// // // // // // //   PanelNotifier() : super(const PanelState()) {
// // // // // // //     _loadToken();
// // // // // // //   }

// // // // // // //   Future<void> _loadToken() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     _token = prefs.getString('access_token') ?? prefs.getString('token');
// // // // // // //     fetchPanel();
// // // // // // //   }

// // // // // // //   // ── HTTP helpers ──────────────────────────────────────────────

// // // // // // //   Map<String, String> get _headers => {
// // // // // // //     'Content-Type': 'application/json',
// // // // // // //     'Accept': 'application/json',
// // // // // // //     if (_token != null && _token!.isNotEmpty) 'Authorization': 'Bearer $_token',
// // // // // // //   };

// // // // // // //   Future<Map<String, dynamic>?> _post(
// // // // // // //     String path,
// // // // // // //     Map<String, dynamic> body,
// // // // // // //   ) async {
// // // // // // //     try {
// // // // // // //       final r = await http.post(
// // // // // // //         Uri.parse('$kApiBase$path'),
// // // // // // //         headers: _headers,
// // // // // // //         body: jsonEncode(body),
// // // // // // //       );
// // // // // // //       if (r.statusCode == 200) {
// // // // // // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // // // // // //       }
// // // // // // //       return null;
// // // // // // //     } catch (_) {
// // // // // // //       return null;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<Map<String, dynamic>?> _get(String path) async {
// // // // // // //     try {
// // // // // // //       final r = await http.get(Uri.parse('$kApiBase$path'), headers: _headers);
// // // // // // //       if (r.statusCode == 200) {
// // // // // // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // // // // // //       }
// // // // // // //       return null;
// // // // // // //     } catch (_) {
// // // // // // //       return null;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // ── Main data fetch ───────────────────────────────────────────

// // // // // // //   Future<void> fetchPanel() async {
// // // // // // //     state = state.copyWith(isLoading: true, error: null);
// // // // // // //     try {
// // // // // // //       final results = await Future.wait([
// // // // // // //         _post('/payperclick/get_chocolate_factory_data', {'user_type': 'me'}),
// // // // // // //         _post('/payperclick/get_all_chocolate_factory_data', {
// // // // // // //           'age_minvalue': state.ageMin,
// // // // // // //           'age_maxvalue': state.ageMax,
// // // // // // //           'height_minvalue': state.heightMin,
// // // // // // //           'height_maxvalue': state.heightMax,
// // // // // // //           'weight_minvalue': state.weightMin,
// // // // // // //           'weight_maxvalue': state.weightMax,
// // // // // // //           'preferencesArray': state.selectedPreferences,
// // // // // // //         }),
// // // // // // //       ]);

// // // // // // //       ChocolateFactoryUser? myProfile;
// // // // // // //       final me = results[0];
// // // // // // //       if (me != null && me['status'] == 200) {
// // // // // // //         final d = me['data'];
// // // // // // //         if (d is List && d.isNotEmpty) {
// // // // // // //           myProfile = ChocolateFactoryUser.fromJson(d[0]);
// // // // // // //         }
// // // // // // //       }

// // // // // // //       List<ChocolateFactoryUser> allUsers = [];
// // // // // // //       final all = results[1];
// // // // // // //       if (all != null && all['status'] == 200) {
// // // // // // //         final d = all['data'];
// // // // // // //         if (d is List) {
// // // // // // //           allUsers = d.map((e) => ChocolateFactoryUser.fromJson(e)).toList();
// // // // // // //         }
// // // // // // //       }

// // // // // // //       state = state.copyWith(
// // // // // // //         isLoading: false,
// // // // // // //         myProfile: myProfile,
// // // // // // //         allUsers: allUsers,
// // // // // // //       );
// // // // // // //     } catch (e) {
// // // // // // //       state = state.copyWith(isLoading: false, error: e.toString());
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // ── Apply filters ─────────────────────────────────────────────

// // // // // // //   Future<void> applyFilters() => fetchPanel();

// // // // // // //   void updateAge(RangeValues v) =>
// // // // // // //       state = state.copyWith(ageMin: v.start.round(), ageMax: v.end.round());
// // // // // // //   void updateHeight(RangeValues v) => state = state.copyWith(
// // // // // // //     heightMin: v.start.round(),
// // // // // // //     heightMax: v.end.round(),
// // // // // // //   );
// // // // // // //   void updateWeight(RangeValues v) => state = state.copyWith(
// // // // // // //     weightMin: v.start.round(),
// // // // // // //     weightMax: v.end.round(),
// // // // // // //   );

// // // // // // //   void togglePreference(String pref) {
// // // // // // //     final list = [...state.selectedPreferences];
// // // // // // //     if (list.contains(pref)) {
// // // // // // //       list.remove(pref);
// // // // // // //     } else {
// // // // // // //       list.add(pref);
// // // // // // //     }
// // // // // // //     state = state.copyWith(selectedPreferences: list);
// // // // // // //   }

// // // // // // //   void setSearch(String q) => state = state.copyWith(searchQuery: q);

// // // // // // //   // ── Calendar ──────────────────────────────────────────────────

// // // // // // //   Future<List<CalendarSlot>> fetchCalendar(String payPerId) async {
// // // // // // //     final r = await _post('/payperclick/get_user_calender_details', {
// // // // // // //       'pay_per_id': payPerId,
// // // // // // //     });
// // // // // // //     if (r != null && r['status'] == 200) {
// // // // // // //       final d = r['data'];
// // // // // // //       if (d is List) return d.map((e) => CalendarSlot.fromJson(e)).toList();
// // // // // // //     }
// // // // // // //     return [];
// // // // // // //   }

// // // // // // //   // ── Terms ─────────────────────────────────────────────────────

// // // // // // //   Future<TermsCondition?> fetchTerms() async {
// // // // // // //     final r = await _get('/auth/pay_per_click_terms_condition');
// // // // // // //     if (r != null && r['status'] == 200) {
// // // // // // //       final d = r['data'];
// // // // // // //       if (d is List && d.isNotEmpty) {
// // // // // // //         return TermsCondition.fromJson(d[0]);
// // // // // // //       }
// // // // // // //     }
// // // // // // //     return null;
// // // // // // //   }

// // // // // // //   // ── Check flags ───────────────────────────────────────────────

// // // // // // //   Future<bool> checkPost() async {
// // // // // // //     final r = await _get('/payperclick/check_chocolate_factory_post');
// // // // // // //     return r != null && r['status'] == 200;
// // // // // // //   }

// // // // // // //   Future<bool> checkPopup() async {
// // // // // // //     final r = await _get('/payperclick/check_chocolate_factory_popup');
// // // // // // //     return r != null && r['status'] == 200;
// // // // // // //   }
// // // // // // // }

// // // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // // 5)  P R O V I D E R
// // // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // // final panelProvider =
// // // // // // //     StateNotifierProvider.autoDispose<PanelNotifier, PanelState>(
// // // // // // //       (ref) => PanelNotifier(),
// // // // // // //     );

// // // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // // 6)  M A I N   P A G E   W I D G E T
// // // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // // class CelebrityPanelPage extends ConsumerStatefulWidget {
// // // // // // //   const CelebrityPanelPage({super.key});

// // // // // // //   @override
// // // // // // //   ConsumerState<CelebrityPanelPage> createState() => _CelebrityPanelPageState();
// // // // // // // }

// // // // // // // class _CelebrityPanelPageState extends ConsumerState<CelebrityPanelPage>
// // // // // // //     with TickerProviderStateMixin {
// // // // // // //   late AnimationController _flipController;
// // // // // // //   final TextEditingController _searchCtrl = TextEditingController();
// // // // // // //   bool _filterExpanded = false;

// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     _flipController = AnimationController(
// // // // // // //       vsync: this,
// // // // // // //       duration: const Duration(milliseconds: 600),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   void dispose() {
// // // // // // //     _flipController.dispose();
// // // // // // //     _searchCtrl.dispose();
// // // // // // //     super.dispose();
// // // // // // //   }

// // // // // // //   // ── Colour palette ────────────────────────────────────────────

// // // // // // //   static const _bg = Color(0xFF0B0B1A);
// // // // // // //   static const _card = Color(0xFF13132B);
// // // // // // //   static const _accent = Color(0xFFE91E63);
// // // // // // //   static const _gold = Color(0xFFF4BA4A);
// // // // // // //   static const _surface = Color(0xFF1C1C3A);

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // BUILD
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final s = ref.watch(panelProvider);

// // // // // // //     return Scaffold(
// // // // // // //       backgroundColor: _bg,
// // // // // // //       body: CustomScrollView(
// // // // // // //         physics: const BouncingScrollPhysics(),
// // // // // // //         slivers: [
// // // // // // //           // ── App Bar ───────────────────────────────────────────
// // // // // // //           SliverAppBar(
// // // // // // //             leading: IconButton(
// // // // // // //               icon: const Icon(
// // // // // // //                 Icons.arrow_back_ios_new,
// // // // // // //                 color: Colors.white,
// // // // // // //                 size: 20,
// // // // // // //               ),
// // // // // // //               onPressed: () => Navigator.pop(context),
// // // // // // //             ),
// // // // // // //             expandedHeight: 130,
// // // // // // //             floating: false,
// // // // // // //             pinned: true,
// // // // // // //             backgroundColor: _bg,
// // // // // // //             elevation: 0,
// // // // // // //             flexibleSpace: LayoutBuilder(
// // // // // // //               builder: (context, constraints) {
// // // // // // //                 final top = MediaQuery.of(context).padding.top;
// // // // // // //                 final collapsed = kToolbarHeight + top;
// // // // // // //                 final isCollapsed = constraints.maxHeight <= collapsed + 10;
// // // // // // //                 return FlexibleSpaceBar(
// // // // // // //                   centerTitle: false,
// // // // // // //                   titlePadding: EdgeInsets.only(
// // // // // // //                     left: isCollapsed ? 50 : 20,
// // // // // // //                     bottom: 14,
// // // // // // //                   ),
// // // // // // //                   title: const Text(
// // // // // // //                     'Celebrity Panel',
// // // // // // //                     style: TextStyle(
// // // // // // //                       color: Colors.white,
// // // // // // //                       fontWeight: FontWeight.bold,
// // // // // // //                       fontSize: 20,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   background: Container(
// // // // // // //                     decoration: const BoxDecoration(
// // // // // // //                       gradient: LinearGradient(
// // // // // // //                         begin: Alignment.topCenter,
// // // // // // //                         end: Alignment.bottomCenter,
// // // // // // //                         colors: [_accent, _bg],
// // // // // // //                         stops: [0.0, 0.8],
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 );
// // // // // // //               },
// // // // // // //             ),
// // // // // // //             actions: [
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(
// // // // // // //                   Icons.notifications_active_outlined,
// // // // // // //                   color: Colors.white,
// // // // // // //                 ),
// // // // // // //                 onPressed: () {},
// // // // // // //               ),
// // // // // // //               const SizedBox(width: 8),
// // // // // // //             ],
// // // // // // //           ),

// // // // // // //           // ── Loading ───────────────────────────────────────────
// // // // // // //           if (s.isLoading)
// // // // // // //             const SliverFillRemaining(
// // // // // // //               child: Center(child: CircularProgressIndicator(color: _accent)),
// // // // // // //             )
// // // // // // //           // ── Error ─────────────────────────────────────────────
// // // // // // //           else if (s.error != null && s.allUsers.isEmpty)
// // // // // // //             SliverFillRemaining(
// // // // // // //               child: Center(
// // // // // // //                 child: Column(
// // // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //                   children: [
// // // // // // //                     const Icon(
// // // // // // //                       Icons.error_outline,
// // // // // // //                       color: Colors.white24,
// // // // // // //                       size: 48,
// // // // // // //                     ),
// // // // // // //                     const SizedBox(height: 16),
// // // // // // //                     Text(
// // // // // // //                       'Failed to load celebrities',
// // // // // // //                       style: TextStyle(color: Colors.white.withAlpha(153)),
// // // // // // //                     ),
// // // // // // //                     TextButton(
// // // // // // //                       onPressed: () =>
// // // // // // //                           ref.read(panelProvider.notifier).fetchPanel(),
// // // // // // //                       child: const Text(
// // // // // // //                         'Retry',
// // // // // // //                         style: TextStyle(color: _accent),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             )
// // // // // // //           // ── Content ───────────────────────────────────────────
// // // // // // //           else ...[
// // // // // // //             // MY PROFILE CARD
// // // // // // //             if (s.myProfile != null) _buildMyProfileCard(s.myProfile!),

// // // // // // //             // SEARCH + FILTER TOGGLE
// // // // // // //             _buildSearchBar(),

// // // // // // //             // EXPANDABLE FILTER PANEL
// // // // // // //             _buildFilterPanel(s),

// // // // // // //             // ALL USERS GRID
// // // // // // //             _buildUsersGrid(s),

// // // // // // //             const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
// // // // // // //           ],
// // // // // // //         ],
// // // // // // //       ),

// // // // // // //       // ── FAB ─────────────────────────────────────────────────────
// // // // // // //       floatingActionButton: FloatingActionButton.extended(
// // // // // // //         onPressed: () {
// // // // // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //             const SnackBar(
// // // // // // //               content: Text('Navigate to Add Celebrity Profile'),
// // // // // // //               backgroundColor: _accent,
// // // // // // //             ),
// // // // // // //           );
// // // // // // //         },
// // // // // // //         backgroundColor: _accent,
// // // // // // //         icon: const Icon(Icons.star, color: Colors.white),
// // // // // // //         label: const Text(
// // // // // // //           'Apply as Star',
// // // // // // //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // MY PROFILE CARD
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   Widget _buildMyProfileCard(ChocolateFactoryUser u) {
// // // // // // //     return SliverToBoxAdapter(
// // // // // // //       child: Container(
// // // // // // //         margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
// // // // // // //         decoration: BoxDecoration(
// // // // // // //           color: _card,
// // // // // // //           borderRadius: BorderRadius.circular(24),
// // // // // // //           border: Border.all(color: Colors.white.withAlpha(25)),
// // // // // // //           boxShadow: [
// // // // // // //             BoxShadow(
// // // // // // //               color: _accent.withAlpha(40),
// // // // // // //               blurRadius: 30,
// // // // // // //               offset: const Offset(0, 10),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //         child: Column(
// // // // // // //           children: [
// // // // // // //             // ── Image row ─────────────────────────────────────
// // // // // // //             SizedBox(
// // // // // // //               height: 220,
// // // // // // //               child: Stack(
// // // // // // //                 children: [
// // // // // // //                   // Profile image
// // // // // // //                   ClipRRect(
// // // // // // //                     borderRadius: const BorderRadius.vertical(
// // // // // // //                       top: Radius.circular(24),
// // // // // // //                     ),
// // // // // // //                     child: SizedBox(
// // // // // // //                       width: double.infinity,
// // // // // // //                       child: _networkImage(u.profileImage, fit: BoxFit.cover),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   // Verified badge
// // // // // // //                   Positioned(
// // // // // // //                     top: 12,
// // // // // // //                     left: 12,
// // // // // // //                     child: Container(
// // // // // // //                       padding: const EdgeInsets.all(8),
// // // // // // //                       decoration: BoxDecoration(
// // // // // // //                         color: _accent.withAlpha(200),
// // // // // // //                         borderRadius: BorderRadius.circular(12),
// // // // // // //                       ),
// // // // // // //                       child: Image.network(
// // // // // // //                         '${kAssetBase}img/badge1.png',
// // // // // // //                         width: 40,
// // // // // // //                         height: 40,
// // // // // // //                         errorBuilder: (_, __, ___) =>
// // // // // // //                             const Icon(Icons.verified, color: Colors.white),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   // Edit button
// // // // // // //                   Positioned(
// // // // // // //                     top: 12,
// // // // // // //                     right: 12,
// // // // // // //                     child: GestureDetector(
// // // // // // //                       onTap: () {
// // // // // // //                         // Navigate to edit pay-per-click
// // // // // // //                       },
// // // // // // //                       child: Container(
// // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // //                           horizontal: 14,
// // // // // // //                           vertical: 8,
// // // // // // //                         ),
// // // // // // //                         decoration: BoxDecoration(
// // // // // // //                           color: Colors.black.withAlpha(150),
// // // // // // //                           borderRadius: BorderRadius.circular(20),
// // // // // // //                           border: Border.all(color: Colors.white.withAlpha(60)),
// // // // // // //                         ),
// // // // // // //                         child: const Row(
// // // // // // //                           mainAxisSize: MainAxisSize.min,
// // // // // // //                           children: [
// // // // // // //                             Icon(Icons.edit, color: Colors.white, size: 14),
// // // // // // //                             SizedBox(width: 4),
// // // // // // //                             Text(
// // // // // // //                               'Edit Profile',
// // // // // // //                               style: TextStyle(
// // // // // // //                                 color: Colors.white,
// // // // // // //                                 fontSize: 12,
// // // // // // //                                 fontWeight: FontWeight.w600,
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                           ],
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   // Gradient overlay
// // // // // // //                   Positioned.fill(
// // // // // // //                     child: Container(
// // // // // // //                       decoration: BoxDecoration(
// // // // // // //                         borderRadius: const BorderRadius.vertical(
// // // // // // //                           top: Radius.circular(24),
// // // // // // //                         ),
// // // // // // //                         gradient: LinearGradient(
// // // // // // //                           begin: Alignment.topCenter,
// // // // // // //                           end: Alignment.bottomCenter,
// // // // // // //                           colors: [
// // // // // // //                             Colors.transparent,
// // // // // // //                             Colors.black.withAlpha(180),
// // // // // // //                           ],
// // // // // // //                           stops: const [0.5, 1.0],
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   // Name + age overlay
// // // // // // //                   Positioned(
// // // // // // //                     left: 16,
// // // // // // //                     bottom: 16,
// // // // // // //                     child: Row(
// // // // // // //                       children: [
// // // // // // //                         Text(
// // // // // // //                           u.username,
// // // // // // //                           style: const TextStyle(
// // // // // // //                             color: Colors.white,
// // // // // // //                             fontSize: 22,
// // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                         if (u.showAge == '1') ...[
// // // // // // //                           const SizedBox(width: 8),
// // // // // // //                           Text(
// // // // // // //                             'Age ${u.age}',
// // // // // // //                             style: TextStyle(
// // // // // // //                               color: Colors.white.withAlpha(200),
// // // // // // //                               fontSize: 14,
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         ],
// // // // // // //                       ],
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),

// // // // // // //             // ── Info section ───────────────────────────────────
// // // // // // //             Padding(
// // // // // // //               padding: const EdgeInsets.all(20),
// // // // // // //               child: Column(
// // // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //                 children: [
// // // // // // //                   // Location
// // // // // // //                   Row(
// // // // // // //                     children: [
// // // // // // //                       const Icon(Icons.location_on, color: _accent, size: 16),
// // // // // // //                       const SizedBox(width: 6),
// // // // // // //                       Text(
// // // // // // //                         u.stateOfResidence,
// // // // // // //                         style: TextStyle(
// // // // // // //                           color: Colors.white.withAlpha(180),
// // // // // // //                           fontSize: 14,
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 14),

// // // // // // //                   // Stats row
// // // // // // //                   Row(
// // // // // // //                     children: [
// // // // // // //                       if (u.showHeight == '1')
// // // // // // //                         _statChip(Icons.height, u.displayHeight),
// // // // // // //                       if (u.showHeight == '1') const SizedBox(width: 12),
// // // // // // //                       if (u.showWeight == '1')
// // // // // // //                         _statChip(
// // // // // // //                           Icons.monitor_weight_outlined,
// // // // // // //                           '${u.weight} Kg',
// // // // // // //                         ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 14),

// // // // // // //                   // Preferences
// // // // // // //                   if (u.showPreferences == '1' && u.preferences.isNotEmpty) ...[
// // // // // // //                     const Text(
// // // // // // //                       'Preferences',
// // // // // // //                       style: TextStyle(
// // // // // // //                         color: Colors.white,
// // // // // // //                         fontSize: 14,
// // // // // // //                         fontWeight: FontWeight.w600,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     const SizedBox(height: 8),
// // // // // // //                     Wrap(
// // // // // // //                       spacing: 8,
// // // // // // //                       runSpacing: 8,
// // // // // // //                       children: u.preferences
// // // // // // //                           .map(
// // // // // // //                             (p) => Container(
// // // // // // //                               padding: const EdgeInsets.symmetric(
// // // // // // //                                 horizontal: 12,
// // // // // // //                                 vertical: 6,
// // // // // // //                               ),
// // // // // // //                               decoration: BoxDecoration(
// // // // // // //                                 color: _accent.withAlpha(30),
// // // // // // //                                 borderRadius: BorderRadius.circular(20),
// // // // // // //                                 border: Border.all(
// // // // // // //                                   color: _accent.withAlpha(80),
// // // // // // //                                 ),
// // // // // // //                               ),
// // // // // // //                               child: Text(
// // // // // // //                                 p,
// // // // // // //                                 style: const TextStyle(
// // // // // // //                                   color: _accent,
// // // // // // //                                   fontSize: 12,
// // // // // // //                                 ),
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                           )
// // // // // // //                           .toList(),
// // // // // // //                     ),
// // // // // // //                     const SizedBox(height: 14),
// // // // // // //                   ],

// // // // // // //                   // Calendar + Review row
// // // // // // //                   Row(
// // // // // // //                     children: [
// // // // // // //                       // Calendar button
// // // // // // //                       Expanded(
// // // // // // //                         child: GestureDetector(
// // // // // // //                           onTap: () => _showCalendarDialog(u.id, u.username),
// // // // // // //                           child: Container(
// // // // // // //                             padding: const EdgeInsets.symmetric(vertical: 12),
// // // // // // //                             decoration: BoxDecoration(
// // // // // // //                               color: _surface,
// // // // // // //                               borderRadius: BorderRadius.circular(14),
// // // // // // //                               border: Border.all(
// // // // // // //                                 color: Colors.white.withAlpha(20),
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                             child: const Row(
// // // // // // //                               mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //                               children: [
// // // // // // //                                 Icon(
// // // // // // //                                   Icons.calendar_month,
// // // // // // //                                   color: _gold,
// // // // // // //                                   size: 18,
// // // // // // //                                 ),
// // // // // // //                                 SizedBox(width: 8),
// // // // // // //                                 Text(
// // // // // // //                                   'Calendar',
// // // // // // //                                   style: TextStyle(
// // // // // // //                                     color: Colors.white,
// // // // // // //                                     fontSize: 13,
// // // // // // //                                     fontWeight: FontWeight.w600,
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                                 SizedBox(width: 4),
// // // // // // //                                 Text(
// // // // // // //                                   'View booked slots',
// // // // // // //                                   style: TextStyle(
// // // // // // //                                     color: Colors.white54,
// // // // // // //                                     fontSize: 11,
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               ],
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       const SizedBox(width: 10),
// // // // // // //                       // Write review
// // // // // // //                       GestureDetector(
// // // // // // //                         onTap: () {
// // // // // // //                           // Navigate to review page
// // // // // // //                         },
// // // // // // //                         child: Container(
// // // // // // //                           padding: const EdgeInsets.symmetric(
// // // // // // //                             horizontal: 16,
// // // // // // //                             vertical: 12,
// // // // // // //                           ),
// // // // // // //                           decoration: BoxDecoration(
// // // // // // //                             color: _accent.withAlpha(20),
// // // // // // //                             borderRadius: BorderRadius.circular(14),
// // // // // // //                             border: Border.all(color: _accent.withAlpha(60)),
// // // // // // //                           ),
// // // // // // //                           child: const Row(
// // // // // // //                             children: [
// // // // // // //                               Icon(Icons.rate_review, color: _accent, size: 16),
// // // // // // //                               SizedBox(width: 6),
// // // // // // //                               Text(
// // // // // // //                                 'Write Review',
// // // // // // //                                 style: TextStyle(color: _accent, fontSize: 13),
// // // // // // //                               ),
// // // // // // //                             ],
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 14),

// // // // // // //                   // Description
// // // // // // //                   if (u.selfDescription.isNotEmpty) ...[
// // // // // // //                     Text(
// // // // // // //                       'Description',
// // // // // // //                       style: TextStyle(
// // // // // // //                         color: Colors.white.withAlpha(150),
// // // // // // //                         fontSize: 12,
// // // // // // //                         fontWeight: FontWeight.w600,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     const SizedBox(height: 6),
// // // // // // //                     Text(
// // // // // // //                       u.selfDescription,
// // // // // // //                       style: TextStyle(
// // // // // // //                         color: Colors.white.withAlpha(120),
// // // // // // //                         fontSize: 13,
// // // // // // //                         height: 1.5,
// // // // // // //                       ),
// // // // // // //                       maxLines: 4,
// // // // // // //                       overflow: TextOverflow.ellipsis,
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _statChip(IconData icon, String label) {
// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: _surface,
// // // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // // //         border: Border.all(color: Colors.white.withAlpha(20)),
// // // // // // //       ),
// // // // // // //       child: Row(
// // // // // // //         mainAxisSize: MainAxisSize.min,
// // // // // // //         children: [
// // // // // // //           Icon(icon, color: _gold, size: 16),
// // // // // // //           const SizedBox(width: 6),
// // // // // // //           Text(
// // // // // // //             label,
// // // // // // //             style: const TextStyle(color: Colors.white, fontSize: 13),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // SEARCH BAR
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   Widget _buildSearchBar() {
// // // // // // //     return SliverToBoxAdapter(
// // // // // // //       child: Padding(
// // // // // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // // // //         child: Row(
// // // // // // //           children: [
// // // // // // //             Expanded(
// // // // // // //               child: Container(
// // // // // // //                 height: 50,
// // // // // // //                 decoration: BoxDecoration(
// // // // // // //                   color: Colors.white.withAlpha(15),
// // // // // // //                   borderRadius: BorderRadius.circular(15),
// // // // // // //                 ),
// // // // // // //                 child: TextField(
// // // // // // //                   controller: _searchCtrl,
// // // // // // //                   style: const TextStyle(color: Colors.white),
// // // // // // //                   onChanged: (v) =>
// // // // // // //                       ref.read(panelProvider.notifier).setSearch(v),
// // // // // // //                   decoration: InputDecoration(
// // // // // // //                     hintText: 'Search celebrities...',
// // // // // // //                     hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
// // // // // // //                     prefixIcon: Icon(
// // // // // // //                       Icons.search,
// // // // // // //                       color: Colors.white.withAlpha(100),
// // // // // // //                     ),
// // // // // // //                     border: InputBorder.none,
// // // // // // //                     contentPadding: const EdgeInsets.symmetric(vertical: 15),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             const SizedBox(width: 12),
// // // // // // //             GestureDetector(
// // // // // // //               onTap: () => setState(() => _filterExpanded = !_filterExpanded),
// // // // // // //               child: AnimatedContainer(
// // // // // // //                 duration: const Duration(milliseconds: 300),
// // // // // // //                 height: 50,
// // // // // // //                 width: 50,
// // // // // // //                 decoration: BoxDecoration(
// // // // // // //                   color: _filterExpanded ? _accent : _accent.withAlpha(30),
// // // // // // //                   borderRadius: BorderRadius.circular(15),
// // // // // // //                   border: Border.all(
// // // // // // //                     color: _accent.withAlpha(_filterExpanded ? 255 : 120),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 child: AnimatedRotation(
// // // // // // //                   duration: const Duration(milliseconds: 300),
// // // // // // //                   turns: _filterExpanded ? 0.125 : 0,
// // // // // // //                   child: Icon(
// // // // // // //                     Icons.tune,
// // // // // // //                     color: _filterExpanded ? Colors.white : _accent,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // FILTER PANEL
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   Widget _buildFilterPanel(PanelState s) {
// // // // // // //     return SliverToBoxAdapter(
// // // // // // //       child: AnimatedContainer(
// // // // // // //         duration: const Duration(milliseconds: 400),
// // // // // // //         curve: Curves.easeInOutCubic,
// // // // // // //         height: _filterExpanded ? null : 0,
// // // // // // //         clipBehavior: Clip.hardEdge,
// // // // // // //         decoration: const BoxDecoration(),
// // // // // // //         child: AnimatedOpacity(
// // // // // // //           duration: const Duration(milliseconds: 300),
// // // // // // //           opacity: _filterExpanded ? 1.0 : 0.0,
// // // // // // //           child: Container(
// // // // // // //             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// // // // // // //             padding: const EdgeInsets.all(20),
// // // // // // //             decoration: BoxDecoration(
// // // // // // //               color: _card,
// // // // // // //               borderRadius: BorderRadius.circular(20),
// // // // // // //               border: Border.all(color: Colors.white.withAlpha(20)),
// // // // // // //             ),
// // // // // // //             child: Column(
// // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //               children: [
// // // // // // //                 // Age slider
// // // // // // //                 _rangeSlider(
// // // // // // //                   label: 'Age',
// // // // // // //                   icon: Icons.cake,
// // // // // // //                   min: 18,
// // // // // // //                   max: 100,
// // // // // // //                   values: RangeValues(s.ageMin.toDouble(), s.ageMax.toDouble()),
// // // // // // //                   onChanged: (v) =>
// // // // // // //                       ref.read(panelProvider.notifier).updateAge(v),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 18),

// // // // // // //                 // Height slider
// // // // // // //                 _rangeSlider(
// // // // // // //                   label: 'Height (ft)',
// // // // // // //                   icon: Icons.height,
// // // // // // //                   min: 0,
// // // // // // //                   max: 10,
// // // // // // //                   values: RangeValues(
// // // // // // //                     s.heightMin.toDouble(),
// // // // // // //                     s.heightMax.toDouble(),
// // // // // // //                   ),
// // // // // // //                   onChanged: (v) =>
// // // // // // //                       ref.read(panelProvider.notifier).updateHeight(v),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 18),

// // // // // // //                 // Weight slider
// // // // // // //                 _rangeSlider(
// // // // // // //                   label: 'Weight (Kg)',
// // // // // // //                   icon: Icons.monitor_weight_outlined,
// // // // // // //                   min: 20,
// // // // // // //                   max: 200,
// // // // // // //                   values: RangeValues(
// // // // // // //                     s.weightMin.toDouble(),
// // // // // // //                     s.weightMax.toDouble(),
// // // // // // //                   ),
// // // // // // //                   onChanged: (v) =>
// // // // // // //                       ref.read(panelProvider.notifier).updateWeight(v),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 18),

// // // // // // //                 // Preferences
// // // // // // //                 const Text(
// // // // // // //                   'Preferences',
// // // // // // //                   style: TextStyle(
// // // // // // //                     color: Colors.white,
// // // // // // //                     fontSize: 14,
// // // // // // //                     fontWeight: FontWeight.w600,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 10),
// // // // // // //                 Wrap(
// // // // // // //                   spacing: 8,
// // // // // // //                   runSpacing: 8,
// // // // // // //                   children: kPreferenceOptions.map((pref) {
// // // // // // //                     final selected = s.selectedPreferences.contains(pref);
// // // // // // //                     return GestureDetector(
// // // // // // //                       onTap: () => ref
// // // // // // //                           .read(panelProvider.notifier)
// // // // // // //                           .togglePreference(pref),
// // // // // // //                       child: AnimatedContainer(
// // // // // // //                         duration: const Duration(milliseconds: 200),
// // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // //                           horizontal: 14,
// // // // // // //                           vertical: 8,
// // // // // // //                         ),
// // // // // // //                         decoration: BoxDecoration(
// // // // // // //                           color: selected ? _accent : _surface,
// // // // // // //                           borderRadius: BorderRadius.circular(20),
// // // // // // //                           border: Border.all(
// // // // // // //                             color: selected
// // // // // // //                                 ? _accent
// // // // // // //                                 : Colors.white.withAlpha(30),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                         child: Row(
// // // // // // //                           mainAxisSize: MainAxisSize.min,
// // // // // // //                           children: [
// // // // // // //                             Icon(
// // // // // // //                               selected
// // // // // // //                                   ? Icons.check_circle
// // // // // // //                                   : Icons.circle_outlined,
// // // // // // //                               color: selected
// // // // // // //                                   ? Colors.white
// // // // // // //                                   : Colors.white.withAlpha(80),
// // // // // // //                               size: 16,
// // // // // // //                             ),
// // // // // // //                             const SizedBox(width: 6),
// // // // // // //                             Text(
// // // // // // //                               pref,
// // // // // // //                               style: TextStyle(
// // // // // // //                                 color: selected
// // // // // // //                                     ? Colors.white
// // // // // // //                                     : Colors.white.withAlpha(120),
// // // // // // //                                 fontSize: 12,
// // // // // // //                                 fontWeight: selected
// // // // // // //                                     ? FontWeight.w600
// // // // // // //                                     : FontWeight.normal,
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                           ],
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     );
// // // // // // //                   }).toList(),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 20),

// // // // // // //                 // Apply button
// // // // // // //                 SizedBox(
// // // // // // //                   width: double.infinity,
// // // // // // //                   height: 50,
// // // // // // //                   child: ElevatedButton.icon(
// // // // // // //                     onPressed: () =>
// // // // // // //                         ref.read(panelProvider.notifier).applyFilters(),
// // // // // // //                     icon: const Icon(Icons.filter_list, color: Colors.white),
// // // // // // //                     label: const Text(
// // // // // // //                       'Apply Filters',
// // // // // // //                       style: TextStyle(
// // // // // // //                         color: Colors.white,
// // // // // // //                         fontWeight: FontWeight.bold,
// // // // // // //                         fontSize: 16,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     style: ElevatedButton.styleFrom(
// // // // // // //                       backgroundColor: _accent,
// // // // // // //                       shape: RoundedRectangleBorder(
// // // // // // //                         borderRadius: BorderRadius.circular(16),
// // // // // // //                       ),
// // // // // // //                       elevation: 4,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _rangeSlider({
// // // // // // //     required String label,
// // // // // // //     required IconData icon,
// // // // // // //     required double min,
// // // // // // //     required double max,
// // // // // // //     required RangeValues values,
// // // // // // //     required ValueChanged<RangeValues> onChanged,
// // // // // // //   }) {
// // // // // // //     return Column(
// // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //       children: [
// // // // // // //         Row(
// // // // // // //           children: [
// // // // // // //             Icon(icon, color: _gold, size: 16),
// // // // // // //             const SizedBox(width: 8),
// // // // // // //             Text(
// // // // // // //               label,
// // // // // // //               style: const TextStyle(
// // // // // // //                 color: Colors.white,
// // // // // // //                 fontSize: 14,
// // // // // // //                 fontWeight: FontWeight.w600,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             const Spacer(),
// // // // // // //             Text(
// // // // // // //               '${values.start.round()} – ${values.end.round()}',
// // // // // // //               style: TextStyle(color: _accent, fontSize: 13),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //         SliderTheme(
// // // // // // //           data: SliderThemeData(
// // // // // // //             activeTrackColor: _accent,
// // // // // // //             inactiveTrackColor: Colors.white.withAlpha(30),
// // // // // // //             thumbColor: _accent,
// // // // // // //             overlayColor: _accent.withAlpha(30),
// // // // // // //             rangeThumbShape: const RoundRangeSliderThumbShape(
// // // // // // //               enabledThumbRadius: 10,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           child: RangeSlider(
// // // // // // //             values: values,
// // // // // // //             min: min,
// // // // // // //             max: max,
// // // // // // //             onChanged: onChanged,
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // ALL USERS GRID  (flip-card style matching web)
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   Widget _buildUsersGrid(PanelState s) {
// // // // // // //     final users = s.filteredUsers;

// // // // // // //     if (users.isEmpty) {
// // // // // // //       return SliverToBoxAdapter(
// // // // // // //         child: Container(
// // // // // // //           margin: const EdgeInsets.all(40),
// // // // // // //           padding: const EdgeInsets.symmetric(vertical: 50),
// // // // // // //           decoration: BoxDecoration(
// // // // // // //             color: _card,
// // // // // // //             borderRadius: BorderRadius.circular(24),
// // // // // // //           ),
// // // // // // //           child: Column(
// // // // // // //             children: [
// // // // // // //               Icon(Icons.search, size: 60, color: Colors.white.withAlpha(40)),
// // // // // // //               const SizedBox(height: 16),
// // // // // // //               const Text(
// // // // // // //                 'No Records Found',
// // // // // // //                 style: TextStyle(
// // // // // // //                   color: Colors.white,
// // // // // // //                   fontSize: 18,
// // // // // // //                   fontWeight: FontWeight.bold,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const SizedBox(height: 8),
// // // // // // //               Text(
// // // // // // //                 'Try adjusting your filters to find more results.',
// // // // // // //                 style: TextStyle(
// // // // // // //                   color: Colors.white.withAlpha(80),
// // // // // // //                   fontSize: 14,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }

// // // // // // //     return SliverPadding(
// // // // // // //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
// // // // // // //       sliver: SliverGrid(
// // // // // // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // //           crossAxisCount: 2,
// // // // // // //           mainAxisSpacing: 16,
// // // // // // //           crossAxisSpacing: 16,
// // // // // // //           childAspectRatio: 0.52,
// // // // // // //         ),
// // // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // // //           (context, index) => _FlipCard(
// // // // // // //             user: users[index],
// // // // // // //             onViewMore: () => _navigateToUserProfile(users[index]),
// // // // // // //             onCalendar: () =>
// // // // // // //                 _showCalendarDialog(users[index].id, users[index].username),
// // // // // // //             onFrontTap: () => _navigateToUserProfile(users[index]),
// // // // // // //           ),
// // // // // // //           childCount: users.length,
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // FLIP CARD WIDGET (matches the web's flip-bx hover card)
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   Widget _FlipCard({
// // // // // // //     required ChocolateFactoryUser user,
// // // // // // //     required VoidCallback onViewMore,
// // // // // // //     required VoidCallback onCalendar,
// // // // // // //     required VoidCallback onFrontTap,
// // // // // // //   }) {
// // // // // // //     return _FlipCardStateful(
// // // // // // //       user: user,
// // // // // // //       onViewMore: onViewMore,
// // // // // // //       onCalendar: onCalendar,
// // // // // // //       onFrontTap: onFrontTap,
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // CALENDAR DIALOG
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   void _showCalendarDialog(String payPerId, String username) async {
// // // // // // //     showGeneralDialog(
// // // // // // //       context: context,
// // // // // // //       barrierDismissible: true,
// // // // // // //       barrierLabel: 'Calendar',
// // // // // // //       barrierColor: Colors.black87,
// // // // // // //       transitionDuration: const Duration(milliseconds: 350),
// // // // // // //       pageBuilder: (ctx, anim1, anim2) => Center(
// // // // // // //         child: Material(
// // // // // // //           color: Colors.transparent,
// // // // // // //           child: Container(
// // // // // // //             width: MediaQuery.of(ctx).size.width * 0.9,
// // // // // // //             constraints: const BoxConstraints(maxHeight: 500),
// // // // // // //             decoration: BoxDecoration(
// // // // // // //               color: _card,
// // // // // // //               borderRadius: BorderRadius.circular(24),
// // // // // // //               border: Border.all(color: Colors.white.withAlpha(20)),
// // // // // // //             ),
// // // // // // //             child: Column(
// // // // // // //               mainAxisSize: MainAxisSize.min,
// // // // // // //               children: [
// // // // // // //                 // Header
// // // // // // //                 Container(
// // // // // // //                   padding: const EdgeInsets.all(20),
// // // // // // //                   decoration: BoxDecoration(
// // // // // // //                     gradient: const LinearGradient(
// // // // // // //                       colors: [_accent, Color(0xFF5C2438)],
// // // // // // //                     ),
// // // // // // //                     borderRadius: const BorderRadius.vertical(
// // // // // // //                       top: Radius.circular(24),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   child: Row(
// // // // // // //                     children: [
// // // // // // //                       const Icon(
// // // // // // //                         Icons.calendar_month,
// // // // // // //                         color: Colors.white,
// // // // // // //                         size: 24,
// // // // // // //                       ),
// // // // // // //                       const SizedBox(width: 10),
// // // // // // //                       Expanded(
// // // // // // //                         child: Text(
// // // // // // //                           'Already Booked Slots',
// // // // // // //                           style: const TextStyle(
// // // // // // //                             color: Colors.white,
// // // // // // //                             fontSize: 18,
// // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       IconButton(
// // // // // // //                         icon: const Icon(Icons.close, color: Colors.white70),
// // // // // // //                         onPressed: () => Navigator.pop(ctx),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 // Slots list
// // // // // // //                 Padding(
// // // // // // //                   padding: const EdgeInsets.all(16),
// // // // // // //                   child: FutureBuilder<List<CalendarSlot>>(
// // // // // // //                     future: ref
// // // // // // //                         .read(panelProvider.notifier)
// // // // // // //                         .fetchCalendar(payPerId),
// // // // // // //                     builder: (ctx, snap) {
// // // // // // //                       if (snap.connectionState == ConnectionState.waiting) {
// // // // // // //                         return const Padding(
// // // // // // //                           padding: EdgeInsets.all(30),
// // // // // // //                           child: Center(
// // // // // // //                             child: CircularProgressIndicator(color: _accent),
// // // // // // //                           ),
// // // // // // //                         );
// // // // // // //                       }
// // // // // // //                       final slots = snap.data ?? [];
// // // // // // //                       if (slots.isEmpty) {
// // // // // // //                         return const Padding(
// // // // // // //                           padding: EdgeInsets.all(30),
// // // // // // //                           child: Text(
// // // // // // //                             'No record found…..',
// // // // // // //                             style: TextStyle(color: Colors.white54),
// // // // // // //                           ),
// // // // // // //                         );
// // // // // // //                       }
// // // // // // //                       return Column(
// // // // // // //                         children: slots.asMap().entries.map((entry) {
// // // // // // //                           final i = entry.key;
// // // // // // //                           final slot = entry.value;
// // // // // // //                           return Container(
// // // // // // //                             margin: const EdgeInsets.only(bottom: 10),
// // // // // // //                             padding: const EdgeInsets.all(14),
// // // // // // //                             decoration: BoxDecoration(
// // // // // // //                               color: _surface,
// // // // // // //                               borderRadius: BorderRadius.circular(14),
// // // // // // //                               border: Border.all(
// // // // // // //                                 color: Colors.white.withAlpha(15),
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                             child: Row(
// // // // // // //                               children: [
// // // // // // //                                 // Index
// // // // // // //                                 Container(
// // // // // // //                                   width: 32,
// // // // // // //                                   height: 32,
// // // // // // //                                   decoration: BoxDecoration(
// // // // // // //                                     color: _accent.withAlpha(30),
// // // // // // //                                     borderRadius: BorderRadius.circular(10),
// // // // // // //                                   ),
// // // // // // //                                   child: Center(
// // // // // // //                                     child: Text(
// // // // // // //                                       '${i + 1}',
// // // // // // //                                       style: const TextStyle(
// // // // // // //                                         color: _accent,
// // // // // // //                                         fontWeight: FontWeight.bold,
// // // // // // //                                       ),
// // // // // // //                                     ),
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                                 const SizedBox(width: 12),
// // // // // // //                                 Expanded(
// // // // // // //                                   child: Column(
// // // // // // //                                     crossAxisAlignment:
// // // // // // //                                         CrossAxisAlignment.start,
// // // // // // //                                     children: [
// // // // // // //                                       Text(
// // // // // // //                                         slot.username,
// // // // // // //                                         style: const TextStyle(
// // // // // // //                                           color: Colors.white,
// // // // // // //                                           fontWeight: FontWeight.w600,
// // // // // // //                                           fontSize: 14,
// // // // // // //                                         ),
// // // // // // //                                       ),
// // // // // // //                                       const SizedBox(height: 4),
// // // // // // //                                       Text(
// // // // // // //                                         slot.calenderDate,
// // // // // // //                                         style: TextStyle(
// // // // // // //                                           color: _gold,
// // // // // // //                                           fontSize: 12,
// // // // // // //                                         ),
// // // // // // //                                       ),
// // // // // // //                                     ],
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                                 Column(
// // // // // // //                                   crossAxisAlignment: CrossAxisAlignment.end,
// // // // // // //                                   children: [
// // // // // // //                                     Row(
// // // // // // //                                       children: [
// // // // // // //                                         Icon(
// // // // // // //                                           Icons.play_arrow,
// // // // // // //                                           color: Colors.greenAccent.shade400,
// // // // // // //                                           size: 14,
// // // // // // //                                         ),
// // // // // // //                                         const SizedBox(width: 4),
// // // // // // //                                         Text(
// // // // // // //                                           slot.startTime12Format,
// // // // // // //                                           style: const TextStyle(
// // // // // // //                                             color: Colors.greenAccent,
// // // // // // //                                             fontSize: 12,
// // // // // // //                                           ),
// // // // // // //                                         ),
// // // // // // //                                       ],
// // // // // // //                                     ),
// // // // // // //                                     const SizedBox(height: 2),
// // // // // // //                                     Row(
// // // // // // //                                       children: [
// // // // // // //                                         Icon(
// // // // // // //                                           Icons.stop,
// // // // // // //                                           color: Colors.redAccent.shade200,
// // // // // // //                                           size: 14,
// // // // // // //                                         ),
// // // // // // //                                         const SizedBox(width: 4),
// // // // // // //                                         Text(
// // // // // // //                                           slot.endTime12Format,
// // // // // // //                                           style: TextStyle(
// // // // // // //                                             color: Colors.redAccent.shade200,
// // // // // // //                                             fontSize: 12,
// // // // // // //                                           ),
// // // // // // //                                         ),
// // // // // // //                                       ],
// // // // // // //                                     ),
// // // // // // //                                   ],
// // // // // // //                                 ),
// // // // // // //                               ],
// // // // // // //                             ),
// // // // // // //                           );
// // // // // // //                         }).toList(),
// // // // // // //                       );
// // // // // // //                     },
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       transitionBuilder: (ctx, anim1, anim2, child) =>
// // // // // // //           ScaleTransition(scale: anim1, child: child),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // TERMS DIALOG
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   void _showTermsDialog() async {
// // // // // // //     showGeneralDialog(
// // // // // // //       context: context,
// // // // // // //       barrierDismissible: true,
// // // // // // //       barrierLabel: 'Terms',
// // // // // // //       barrierColor: Colors.black87,
// // // // // // //       transitionDuration: const Duration(milliseconds: 350),
// // // // // // //       pageBuilder: (ctx, anim1, anim2) => Center(
// // // // // // //         child: Material(
// // // // // // //           color: Colors.transparent,
// // // // // // //           child: Container(
// // // // // // //             width: MediaQuery.of(ctx).size.width * 0.9,
// // // // // // //             constraints: const BoxConstraints(maxHeight: 500),
// // // // // // //             decoration: BoxDecoration(
// // // // // // //               color: _card,
// // // // // // //               borderRadius: BorderRadius.circular(24),
// // // // // // //             ),
// // // // // // //             child: Column(
// // // // // // //               mainAxisSize: MainAxisSize.min,
// // // // // // //               children: [
// // // // // // //                 Container(
// // // // // // //                   padding: const EdgeInsets.all(20),
// // // // // // //                   decoration: const BoxDecoration(
// // // // // // //                     gradient: LinearGradient(
// // // // // // //                       colors: [_accent, Color(0xFF5C2438)],
// // // // // // //                     ),
// // // // // // //                     borderRadius: BorderRadius.vertical(
// // // // // // //                       top: Radius.circular(24),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   child: Row(
// // // // // // //                     children: [
// // // // // // //                       const Icon(
// // // // // // //                         Icons.description,
// // // // // // //                         color: Colors.white,
// // // // // // //                         size: 24,
// // // // // // //                       ),
// // // // // // //                       const SizedBox(width: 10),
// // // // // // //                       const Expanded(
// // // // // // //                         child: Text(
// // // // // // //                           'Terms and Conditions',
// // // // // // //                           style: TextStyle(
// // // // // // //                             color: Colors.white,
// // // // // // //                             fontSize: 18,
// // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       IconButton(
// // // // // // //                         icon: const Icon(Icons.close, color: Colors.white70),
// // // // // // //                         onPressed: () => Navigator.pop(ctx),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 Padding(
// // // // // // //                   padding: const EdgeInsets.all(20),
// // // // // // //                   child: FutureBuilder<TermsCondition?>(
// // // // // // //                     future: ref.read(panelProvider.notifier).fetchTerms(),
// // // // // // //                     builder: (ctx, snap) {
// // // // // // //                       if (snap.connectionState == ConnectionState.waiting) {
// // // // // // //                         return const Center(
// // // // // // //                           child: CircularProgressIndicator(color: _accent),
// // // // // // //                         );
// // // // // // //                       }
// // // // // // //                       return Text(
// // // // // // //                         snap.data?.description ?? 'No terms available.',
// // // // // // //                         style: TextStyle(
// // // // // // //                           color: Colors.white.withAlpha(200),
// // // // // // //                           fontSize: 14,
// // // // // // //                           height: 1.7,
// // // // // // //                         ),
// // // // // // //                       );
// // // // // // //                     },
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       transitionBuilder: (ctx, anim1, anim2, child) =>
// // // // // // //           ScaleTransition(scale: anim1, child: child),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // NAVIGATE TO USER PROFILE
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   void _navigateToUserProfile(ChocolateFactoryUser user) {
// // // // // // //     // ── Uses your existing OtherUserProfilePage ──────────────────
// // // // // // //     // Make sure to uncomment the imports at the top of this file:
// // // // // // //     //   - other_user_profile_page.dart
// // // // // // //     //   - user_list_provider.dart
// // // // // // //     //
// // // // // // //     // Then use the code below:
// // // // // // //     //
// // // // // // //     // Navigator.push(
// // // // // // //     //   context,
// // // // // // //     //   MaterialPageRoute(
// // // // // // //     //     builder: (_) => OtherUserProfilePage(
// // // // // // //     //       user: UserListItem(
// // // // // // //     //         id: user.id,
// // // // // // //     //         name: user.username,
// // // // // // //     //         imageUrl: user.profileImage,
// // // // // // //     //         lastSeen: 'Offline',
// // // // // // //     //         location: user.stateOfResidence,
// // // // // // //     //         isOnline: false,
// // // // // // //     //       ),
// // // // // // //     //     ),
// // // // // // //     //   ),
// // // // // // //     // );
// // // // // // //   }

// // // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // // //   // NETWORK IMAGE HELPER
// // // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // // //   Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
// // // // // // //     if (url.isEmpty) {
// // // // // // //       return Container(
// // // // // // //         color: _surface,
// // // // // // //         child: const Center(
// // // // // // //           child: Icon(Icons.person, color: Colors.white24, size: 50),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }
// // // // // // //     String full = url;
// // // // // // //     if (!url.startsWith('http')) {
// // // // // // //       full = '$kAssetBase$url';
// // // // // // //     }
// // // // // // //     return Image.network(
// // // // // // //       full,
// // // // // // //       fit: fit,
// // // // // // //       errorBuilder: (_, __, ___) => Container(
// // // // // // //         color: _surface,
// // // // // // //         child: const Center(
// // // // // // //           child: Icon(Icons.person, color: Colors.white24, size: 50),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       loadingBuilder: (_, child, progress) {
// // // // // // //         if (progress == null) return child;
// // // // // // //         return Container(
// // // // // // //           color: _surface,
// // // // // // //           child: const Center(
// // // // // // //             child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
// // // // // // //           ),
// // // // // // //         );
// // // // // // //       },
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // // FLIP CARD — hover / tap to flip between front (image) and back (info)
// // // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // // class _FlipCardStateful extends StatefulWidget {
// // // // // // //   final ChocolateFactoryUser user;
// // // // // // //   final VoidCallback onViewMore;
// // // // // // //   final VoidCallback onCalendar;
// // // // // // //   final VoidCallback onFrontTap;

// // // // // // //   const _FlipCardStateful({
// // // // // // //     required this.user,
// // // // // // //     required this.onViewMore,
// // // // // // //     required this.onCalendar,
// // // // // // //     required this.onFrontTap,
// // // // // // //   });

// // // // // // //   @override
// // // // // // //   State<_FlipCardStateful> createState() => _FlipCardStatefulState();
// // // // // // // }

// // // // // // // class _FlipCardStatefulState extends State<_FlipCardStateful>
// // // // // // //     with SingleTickerProviderStateMixin {
// // // // // // //   late AnimationController _controller;
// // // // // // //   late Animation<double> _animation;
// // // // // // //   bool _showFront = true;

// // // // // // //   static const _bg = Color(0xFF13132B);
// // // // // // //   static const _accent = Color(0xFFE91E63);
// // // // // // //   static const _surface = Color(0xFF1C1C3A);
// // // // // // //   static const _gold = Color(0xFFF4BA4A);

// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     _controller = AnimationController(
// // // // // // //       duration: const Duration(milliseconds: 600),
// // // // // // //       vsync: this,
// // // // // // //     );
// // // // // // //     _animation = Tween<double>(
// // // // // // //       begin: 0,
// // // // // // //       end: 1,
// // // // // // //     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   void dispose() {
// // // // // // //     _controller.dispose();
// // // // // // //     super.dispose();
// // // // // // //   }

// // // // // // //   void _flip() {
// // // // // // //     if (_showFront) {
// // // // // // //       _controller.forward();
// // // // // // //     } else {
// // // // // // //       _controller.reverse();
// // // // // // //     }
// // // // // // //     setState(() => _showFront = !_showFront);
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final u = widget.user;
// // // // // // //     return GestureDetector(
// // // // // // //       onTap: _flip,
// // // // // // //       child: _FlipCardAnimationBuilder(
// // // // // // //         animation: _animation,
// // // // // // //         builder: (context, child) {
// // // // // // //           final angle = _animation.value * 3.14159265;
// // // // // // //           final isFront = angle < 1.5708;
// // // // // // //           return Transform(
// // // // // // //             alignment: Alignment.center,
// // // // // // //             transform: Matrix4.identity()
// // // // // // //               ..setEntry(3, 2, 0.001)
// // // // // // //               ..rotateY(angle),
// // // // // // //             child: isFront
// // // // // // //                 ? _buildFront(u)
// // // // // // //                 : Transform(
// // // // // // //                     alignment: Alignment.center,
// // // // // // //                     transform: Matrix4.identity()..rotateY(3.14159265),
// // // // // // //                     child: _buildBack(u),
// // // // // // //                   ),
// // // // // // //           );
// // // // // // //         },
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ── Front: image + badge + name ────────────────────────────────

// // // // // // //   Widget _buildFront(ChocolateFactoryUser u) {
// // // // // // //     return Container(
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         borderRadius: BorderRadius.circular(20),
// // // // // // //         color: _bg,
// // // // // // //         boxShadow: [
// // // // // // //           BoxShadow(
// // // // // // //             color: Colors.black.withAlpha(80),
// // // // // // //             blurRadius: 15,
// // // // // // //             offset: const Offset(0, 8),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       child: Stack(
// // // // // // //         children: [
// // // // // // //           // Image
// // // // // // //           ClipRRect(
// // // // // // //             borderRadius: BorderRadius.circular(20),
// // // // // // //             child: SizedBox(
// // // // // // //               width: double.infinity,
// // // // // // //               height: double.infinity,
// // // // // // //               child: _networkImg(u.profileImage),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           // Badge
// // // // // // //           Positioned(
// // // // // // //             top: 10,
// // // // // // //             left: 10,
// // // // // // //             child: Image.network(
// // // // // // //               '${kAssetBase}img/badge1.png',
// // // // // // //               width: 40,
// // // // // // //               height: 40,
// // // // // // //               errorBuilder: (_, __, ___) =>
// // // // // // //                   const Icon(Icons.verified, color: _gold, size: 28),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           // Gradient overlay
// // // // // // //           Positioned.fill(
// // // // // // //             child: Container(
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 borderRadius: BorderRadius.circular(20),
// // // // // // //                 gradient: LinearGradient(
// // // // // // //                   begin: Alignment.topCenter,
// // // // // // //                   end: Alignment.bottomCenter,
// // // // // // //                   colors: [
// // // // // // //                     Colors.transparent,
// // // // // // //                     Colors.transparent,
// // // // // // //                     Colors.black.withAlpha(200),
// // // // // // //                   ],
// // // // // // //                   stops: const [0.0, 0.5, 1.0],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           // Name + age
// // // // // // //           Positioned(
// // // // // // //             left: 14,
// // // // // // //             bottom: 14,
// // // // // // //             right: 14,
// // // // // // //             child: Column(
// // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //               children: [
// // // // // // //                 Text(
// // // // // // //                   u.username,
// // // // // // //                   style: const TextStyle(
// // // // // // //                     color: Colors.white,
// // // // // // //                     fontSize: 16,
// // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 if (u.showAge == '1')
// // // // // // //                   Text(
// // // // // // //                     'Age ${u.age}',
// // // // // // //                     style: TextStyle(
// // // // // // //                       color: Colors.white.withAlpha(180),
// // // // // // //                       fontSize: 12,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ── Back: dark card with info + buttons ────────────────────────

// // // // // // //   Widget _buildBack(ChocolateFactoryUser u) {
// // // // // // //     return Container(
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         borderRadius: BorderRadius.circular(20),
// // // // // // //         gradient: const LinearGradient(
// // // // // // //           begin: Alignment.topCenter,
// // // // // // //           end: Alignment.bottomCenter,
// // // // // // //           colors: [Color(0xFF560827), Color(0xFF06032C)],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       child: Padding(
// // // // // // //         padding: const EdgeInsets.all(16),
// // // // // // //         child: Column(
// // // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //           children: [
// // // // // // //             // Username
// // // // // // //             Text(
// // // // // // //               u.username,
// // // // // // //               style: const TextStyle(
// // // // // // //                 color: Colors.white,
// // // // // // //                 fontSize: 20,
// // // // // // //                 fontWeight: FontWeight.bold,
// // // // // // //               ),
// // // // // // //               textAlign: TextAlign.center,
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 4),
// // // // // // //             // Location
// // // // // // //             if (u.stateOfResidence.isNotEmpty)
// // // // // // //               Text(
// // // // // // //                 u.stateOfResidence,
// // // // // // //                 style: TextStyle(
// // // // // // //                   color: Colors.white.withAlpha(160),
// // // // // // //                   fontSize: 13,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             const SizedBox(height: 12),
// // // // // // //             // Stats
// // // // // // //             Wrap(
// // // // // // //               alignment: WrapAlignment.center,
// // // // // // //               spacing: 8,
// // // // // // //               runSpacing: 6,
// // // // // // //               children: [
// // // // // // //                 if (u.showAge == '1') _backChip('${u.age} yrs'),
// // // // // // //                 if (u.showHeight == '1')
// // // // // // //                   _backChip("${u.heightFeet}' ${u.heightInch}\""),
// // // // // // //                 if (u.showWeight == '1') _backChip('${u.weight} Kg'),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 10),
// // // // // // //             // Preferences
// // // // // // //             if (u.showPreferences == '1' && u.preferences.isNotEmpty)
// // // // // // //               Wrap(
// // // // // // //                 spacing: 6,
// // // // // // //                 runSpacing: 6,
// // // // // // //                 alignment: WrapAlignment.center,
// // // // // // //                 children: u.preferences
// // // // // // //                     .take(3)
// // // // // // //                     .map(
// // // // // // //                       (p) => Container(
// // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // //                           horizontal: 8,
// // // // // // //                           vertical: 4,
// // // // // // //                         ),
// // // // // // //                         decoration: BoxDecoration(
// // // // // // //                           color: _accent.withAlpha(40),
// // // // // // //                           borderRadius: BorderRadius.circular(12),
// // // // // // //                         ),
// // // // // // //                         child: Text(
// // // // // // //                           p,
// // // // // // //                           style: const TextStyle(color: _accent, fontSize: 10),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     )
// // // // // // //                     .toList(),
// // // // // // //               ),
// // // // // // //             const SizedBox(height: 16),
// // // // // // //             // View More button
// // // // // // //             SizedBox(
// // // // // // //               width: double.infinity,
// // // // // // //               child: ElevatedButton(
// // // // // // //                 onPressed: widget.onViewMore,
// // // // // // //                 style: ElevatedButton.styleFrom(
// // // // // // //                   backgroundColor: _accent,
// // // // // // //                   foregroundColor: Colors.white,
// // // // // // //                   shape: RoundedRectangleBorder(
// // // // // // //                     borderRadius: BorderRadius.circular(14),
// // // // // // //                   ),
// // // // // // //                   padding: const EdgeInsets.symmetric(vertical: 10),
// // // // // // //                 ),
// // // // // // //                 child: const Text(
// // // // // // //                   'View More',
// // // // // // //                   style: TextStyle(fontWeight: FontWeight.bold),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 8),
// // // // // // //             // Calendar button
// // // // // // //             GestureDetector(
// // // // // // //               onTap: widget.onCalendar,
// // // // // // //               child: Container(
// // // // // // //                 padding: const EdgeInsets.symmetric(vertical: 8),
// // // // // // //                 decoration: BoxDecoration(
// // // // // // //                   border: Border.all(color: _gold.withAlpha(80)),
// // // // // // //                   borderRadius: BorderRadius.circular(14),
// // // // // // //                 ),
// // // // // // //                 child: const Row(
// // // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //                   children: [
// // // // // // //                     Icon(Icons.calendar_today, color: _gold, size: 16),
// // // // // // //                     SizedBox(width: 6),
// // // // // // //                     Text(
// // // // // // //                       'View Calendar',
// // // // // // //                       style: TextStyle(color: _gold, fontSize: 13),
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _backChip(String text) {
// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.white.withAlpha(15),
// // // // // // //         borderRadius: BorderRadius.circular(10),
// // // // // // //       ),
// // // // // // //       child: Text(
// // // // // // //         text,
// // // // // // //         style: const TextStyle(color: Colors.white, fontSize: 11),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _networkImg(String url) {
// // // // // // //     if (url.isEmpty) {
// // // // // // //       return Container(
// // // // // // //         color: _surface,
// // // // // // //         child: const Center(
// // // // // // //           child: Icon(Icons.person, color: Colors.white24, size: 50),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }
// // // // // // //     String full = url;
// // // // // // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // // // // // //     return Image.network(
// // // // // // //       full,
// // // // // // //       fit: BoxFit.cover,
// // // // // // //       errorBuilder: (_, __, ___) => Container(
// // // // // // //         color: _surface,
// // // // // // //         child: const Center(
// // // // // // //           child: Icon(Icons.person, color: Colors.white24, size: 50),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       loadingBuilder: (_, child, progress) {
// // // // // // //         if (progress == null) return child;
// // // // // // //         return Container(
// // // // // // //           color: _surface,
// // // // // // //           child: const Center(
// // // // // // //             child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
// // // // // // //           ),
// // // // // // //         );
// // // // // // //       },
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // // Flip card animation builder
// // // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // // class _FlipCardAnimationBuilder extends AnimatedWidget {
// // // // // // //   final Widget Function(BuildContext context, Widget? child) builder;
// // // // // // //   final Widget? child;

// // // // // // //   const _FlipCardAnimationBuilder({
// // // // // // //     // required super.listenable,
// // // // // // //     // required this.builder,
// // // // // // //     // this.child,
// // // // // // //     required Animation<double> animation,
// // // // // // //     required this.builder,
// // // // // // //     this.child,
// // // // // // //   }) : super(listenable: animation);

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return builder(context, child);
// // // // // // //   }
// // // // // // // }


// // // // // // // ╔═══════════════════════════════════════════════════════════════════╗
// // // // // // // ║  Celebrity Panel – Pay-Per-Click (Chocolate Factory)            ║
// // // // // // // ║  Single self-contained file — paste into your existing project  ║
// // // // // // // ║  API: https://app.beatflirtevent.com/App                        ║
// // // // // // // ║  Auth: Access-Token + Access-Sign headers (from sessionStorage) ║
// // // // // // // ╚═══════════════════════════════════════════════════════════════════╝

// // // // // // import 'dart:convert';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // import 'package:http/http.dart' as http;

// // // // // // // ── Uncomment these for your existing project navigation ─────────
// // // // // // // import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// // // // // // // import 'package:beatflirt/providers/user_list_provider.dart';

// // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // 1)  A P I   C O N S T A N T S
// // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // const String kApiBase = 'https://app.beatflirtevent.com/App';
// // // // // // const String kAssetBase = 'https://app.beatflirtevent.com/assets/';

// // // // // // const List<String> kPreferenceOptions = [
// // // // // //   'Orgy',
// // // // // //   'Gang Bang',
// // // // // //   'Couple',
// // // // // //   'BDSM',
// // // // // //   'Dom',
// // // // // //   'Sub',
// // // // // //   'Cuckolder',
// // // // // //   'Bull Stag',
// // // // // // ];

// // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // 2)  D A T A   M O D E L S
// // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // class ChocolateFactoryUser {
// // // // // //   final String id;
// // // // // //   final String username;
// // // // // //   final String age;
// // // // // //   final String showAge;
// // // // // //   final String stateOfResidence;
// // // // // //   final String heightFeet;
// // // // // //   final String heightInch;
// // // // // //   final String showHeight;
// // // // // //   final String weight;
// // // // // //   final String showWeight;
// // // // // //   final List<String> preferences;
// // // // // //   final String showPreferences;
// // // // // //   final String selfDescription;
// // // // // //   final List<ChocolateFactoryImage> images;

// // // // // //   const ChocolateFactoryUser({
// // // // // //     required this.id,
// // // // // //     required this.username,
// // // // // //     required this.age,
// // // // // //     required this.showAge,
// // // // // //     required this.stateOfResidence,
// // // // // //     required this.heightFeet,
// // // // // //     required this.heightInch,
// // // // // //     required this.showHeight,
// // // // // //     required this.weight,
// // // // // //     required this.showWeight,
// // // // // //     required this.preferences,
// // // // // //     required this.showPreferences,
// // // // // //     required this.selfDescription,
// // // // // //     required this.images,
// // // // // //   });

// // // // // //   String get profileImage =>
// // // // // //       images.isNotEmpty ? images.first.profileImage : '';

// // // // // //   String get displayHeight => "${heightFeet}' ${heightInch}\"";

// // // // // //   factory ChocolateFactoryUser.fromJson(Map<String, dynamic> j) {
// // // // // //     return ChocolateFactoryUser(
// // // // // //       id: '${j['id'] ?? ''}',
// // // // // //       username: '${j['username'] ?? ''}',
// // // // // //       age: '${j['age'] ?? ''}',
// // // // // //       showAge: '${j['show_age'] ?? '0'}',
// // // // // //       stateOfResidence: '${j['state_of_residence'] ?? ''}',
// // // // // //       heightFeet: '${j['height_feet'] ?? ''}',
// // // // // //       heightInch: '${j['height_inch'] ?? ''}',
// // // // // //       showHeight: '${j['show_height'] ?? '0'}',
// // // // // //       weight: '${j['weight'] ?? ''}',
// // // // // //       showWeight: '${j['show_weight'] ?? '0'}',
// // // // // //       preferences:
// // // // // //           (j['preferences'] as List<dynamic>?)
// // // // // //               ?.map((e) => '$e')
// // // // // //               .toList() ?? [],
// // // // // //       showPreferences: '${j['show_preferences'] ?? '0'}',
// // // // // //       selfDescription: '${j['self_description'] ?? ''}',
// // // // // //       images:
// // // // // //           (j['image'] as List<dynamic>?)
// // // // // //               ?.map((e) => ChocolateFactoryImage.fromJson(e))
// // // // // //               .toList() ?? [],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // class ChocolateFactoryImage {
// // // // // //   final String profileImage;
// // // // // //   const ChocolateFactoryImage({required this.profileImage});
// // // // // //   factory ChocolateFactoryImage.fromJson(Map<String, dynamic> j) =>
// // // // // //       ChocolateFactoryImage(profileImage: '${j['profile_image'] ?? ''}');
// // // // // // }

// // // // // // class CalendarSlot {
// // // // // //   final String username;
// // // // // //   final String calenderDate;
// // // // // //   final String startTime12Format;
// // // // // //   final String endTime12Format;
// // // // // //   const CalendarSlot({
// // // // // //     required this.username,
// // // // // //     required this.calenderDate,
// // // // // //     required this.startTime12Format,
// // // // // //     required this.endTime12Format,
// // // // // //   });
// // // // // //   factory CalendarSlot.fromJson(Map<String, dynamic> j) => CalendarSlot(
// // // // // //         username: '${j['username'] ?? ''}',
// // // // // //         calenderDate: '${j['calender_date'] ?? ''}',
// // // // // //         startTime12Format: '${j['start_time_12_formate'] ?? ''}',
// // // // // //         endTime12Format: '${j['end_time_12_formate'] ?? ''}',
// // // // // //       );
// // // // // // }

// // // // // // class TermsCondition {
// // // // // //   final String description;
// // // // // //   const TermsCondition({required this.description});
// // // // // //   factory TermsCondition.fromJson(Map<String, dynamic> j) =>
// // // // // //       TermsCondition(description: '${j['description'] ?? ''}');
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // 3)  S T A T E
// // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // class PanelState {
// // // // // //   final bool isLoading;
// // // // // //   final String? error;
// // // // // //   final ChocolateFactoryUser? myProfile;
// // // // // //   final List<ChocolateFactoryUser> allUsers;
// // // // // //   final String searchQuery;
// // // // // //   final int ageMin;
// // // // // //   final int ageMax;
// // // // // //   final int heightMin;
// // // // // //   final int heightMax;
// // // // // //   final int weightMin;
// // // // // //   final int weightMax;
// // // // // //   final List<String> selectedPreferences;

// // // // // //   const PanelState({
// // // // // //     this.isLoading = false,
// // // // // //     this.error,
// // // // // //     this.myProfile,
// // // // // //     this.allUsers = const [],
// // // // // //     this.searchQuery = '',
// // // // // //     this.ageMin = 18,
// // // // // //     this.ageMax = 80,
// // // // // //     this.heightMin = 3,
// // // // // //     this.heightMax = 8,
// // // // // //     this.weightMin = 20,
// // // // // //     this.weightMax = 150,
// // // // // //     this.selectedPreferences = const [],
// // // // // //   });

// // // // // //   PanelState copyWith({
// // // // // //     bool? isLoading,
// // // // // //     String? error,
// // // // // //     ChocolateFactoryUser? myProfile,
// // // // // //     List<ChocolateFactoryUser>? allUsers,
// // // // // //     String? searchQuery,
// // // // // //     int? ageMin,
// // // // // //     int? ageMax,
// // // // // //     int? heightMin,
// // // // // //     int? heightMax,
// // // // // //     int? weightMin,
// // // // // //     int? weightMax,
// // // // // //     List<String>? selectedPreferences,
// // // // // //   }) {
// // // // // //     return PanelState(
// // // // // //       isLoading: isLoading ?? this.isLoading,
// // // // // //       error: error,
// // // // // //       myProfile: myProfile ?? this.myProfile,
// // // // // //       allUsers: allUsers ?? this.allUsers,
// // // // // //       searchQuery: searchQuery ?? this.searchQuery,
// // // // // //       ageMin: ageMin ?? this.ageMin,
// // // // // //       ageMax: ageMax ?? this.ageMax,
// // // // // //       heightMin: heightMin ?? this.heightMin,
// // // // // //       heightMax: heightMax ?? this.heightMax,
// // // // // //       weightMin: weightMin ?? this.weightMin,
// // // // // //       weightMax: weightMax ?? this.weightMax,
// // // // // //       selectedPreferences: selectedPreferences ?? this.selectedPreferences,
// // // // // //     );
// // // // // //   }

// // // // // //   List<ChocolateFactoryUser> get filteredUsers {
// // // // // //     var list = allUsers;
// // // // // //     if (searchQuery.isNotEmpty) {
// // // // // //       list = list
// // // // // //           .where((u) =>
// // // // // //               u.username.toLowerCase().contains(searchQuery.toLowerCase()))
// // // // // //           .toList();
// // // // // //     }
// // // // // //     return list;
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // 4)  N O T I F I E R   (API calls + state)
// // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // class PanelNotifier extends StateNotifier<PanelState> {
// // // // // //   String? _accessToken;
// // // // // //   String? _accessSign;

// // // // // //   PanelNotifier() : super(const PanelState()) {
// // // // // //     _loadToken();
// // // // // //   }

// // // // // //   // ── Load auth credentials ─────────────────────────────────────
// // // // // //   //
// // // // // //   // The web app stores them in sessionStorage / localStorage as:
// // // // // //   //   "Access-Token"  →  sent as header  Access-Token
// // // // // //   //   "Access-Sign"   →  sent as header  Access-Sign
// // // // // //   //
// // // // // //   // The Flutter app likely stores them in SharedPreferences with the
// // // // // //   // same keys, or lower-case variants.  We try both.

// // // // // //   Future<void> _loadToken() async {
// // // // // //     final prefs = await SharedPreferences.getInstance();

// // // // // //     // Try every possible key variant
// // // // // //     _accessToken = prefs.getString('Access-Token') //
// // // // // //         ?? prefs.getString('access_token')
// // // // // //         ?? prefs.getString('accessToken')
// // // // // //         ?? prefs.getString('token')
// // // // // //         ?? prefs.getString('auth_token');
// // // // // //     _accessSign = prefs.getString('Access-Sign') //
// // // // // //         ?? prefs.getString('access_sign')
// // // // // //         ?? prefs.getString('accessSign')
// // // // // //         ?? prefs.getString('sign');

// // // // // //     debugPrint('═══ CelebrityPanel ═══');
// // // // // //     debugPrint('  Access-Token : ${_accessToken != null ? "${_accessToken!.substring(0, _accessToken!.length > 20 ? 20 : _accessToken!.length)}..." : "NULL"}');
// // // // // //     debugPrint('  Access-Sign  : ${_accessSign != null ? "${_accessSign!.substring(0, _accessSign!.length > 20 ? 20 : _accessSign!.length)}..." : "NULL"}');
// // // // // //     debugPrint('═══════════════════════');

// // // // // //     fetchPanel();
// // // // // //   }

// // // // // //   // ── HTTP helpers ──────────────────────────────────────────────
// // // // // //   //
// // // // // //   //  The web's callapi.setHeaders() builds:
// // // // // //   //    { "Content-Type":"application/json; charset=UTF-8",
// // // // // //   //      "Access-Token":"<token>",  "Access-Sign":"<sign>" }
// // // // // //   //
// // // // // //   //  NOT  Authorization: Bearer ...  ← this was the bug!

// // // // // //   Map<String, String> get _headers => {
// // // // // //         'Content-Type': 'application/json; charset=UTF-8',
// // // // // //         if (_accessToken != null && _accessToken!.isNotEmpty)
// // // // // //           'Access-Token': _accessToken!,
// // // // // //         if (_accessSign != null && _accessSign!.isNotEmpty)
// // // // // //           'Access-Sign': _accessSign!,
// // // // // //       };

// // // // // //   Future<Map<String, dynamic>?> _post(
// // // // // //       String path, Map<String, dynamic> body) async {
// // // // // //     try {
// // // // // //       final uri = Uri.parse('$kApiBase$path');
// // // // // //       debugPrint('POST $uri  headers=$_headers');
// // // // // //       final r = await http.post(uri, headers: _headers, body: jsonEncode(body));
// // // // // //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// // // // // //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// // // // // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // // // // //       }
// // // // // //       return null;
// // // // // //     } catch (e) {
// // // // // //       debugPrint('  → ERROR $e');
// // // // // //       return null;
// // // // // //     }
// // // // // //   }

// // // // // //   Future<Map<String, dynamic>?> _get(String path) async {
// // // // // //     try {
// // // // // //       final uri = Uri.parse('$kApiBase$path');
// // // // // //       debugPrint('GET $uri  headers=$_headers');
// // // // // //       final r = await http.get(uri, headers: _headers);
// // // // // //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// // // // // //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// // // // // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // // // // //       }
// // // // // //       return null;
// // // // // //     } catch (e) {
// // // // // //       debugPrint('  → ERROR $e');
// // // // // //       return null;
// // // // // //     }
// // // // // //   }

// // // // // //   // ── Helper: check status as int or string ─────────────────────
// // // // // //   //  Web API sometimes returns {"status":200} (int)
// // // // // //   //  and sometimes {"status":"404"} (string).
// // // // // //   //  JavaScript == coerces both, but Dart's == does NOT.

// // // // // //   bool _isOk(Map<String, dynamic>? r) {
// // // // // //     if (r == null) return false;
// // // // // //     final s = r['status'];
// // // // // //     return s != null && s.toString() == '200';
// // // // // //   }

// // // // // //   // ── Main data fetch ───────────────────────────────────────────

// // // // // //   Future<void> fetchPanel() async {
// // // // // //     state = state.copyWith(isLoading: true, error: null);
// // // // // //     try {
// // // // // //       final results = await Future.wait([
// // // // // //         _post('/payperclick/get_chocolate_factory_data', {'user_type': 'me'}),
// // // // // //         _post('/payperclick/get_all_chocolate_factory_data', {
// // // // // //           'age_minvalue': state.ageMin,
// // // // // //           'age_maxvalue': state.ageMax,
// // // // // //           'height_minvalue': state.heightMin,
// // // // // //           'height_maxvalue': state.heightMax,
// // // // // //           'weight_minvalue': state.weightMin,
// // // // // //           'weight_maxvalue': state.weightMax,
// // // // // //           'preferencesArray': state.selectedPreferences,
// // // // // //         }),
// // // // // //       ]);

// // // // // //       ChocolateFactoryUser? myProfile;
// // // // // //       final me = results[0];
// // // // // //       if (_isOk(me)) {
// // // // // //         final d = me!['data'];
// // // // // //         if (d is List && d.isNotEmpty) {
// // // // // //           myProfile = ChocolateFactoryUser.fromJson(d[0]);
// // // // // //         }
// // // // // //       }

// // // // // //       List<ChocolateFactoryUser> allUsers = [];
// // // // // //       final all = results[1];
// // // // // //       if (_isOk(all)) {
// // // // // //         final d = all!['data'];
// // // // // //         if (d is List) {
// // // // // //           allUsers = d.map((e) => ChocolateFactoryUser.fromJson(e)).toList();
// // // // // //         }
// // // // // //       }

// // // // // //       debugPrint('  myProfile: ${myProfile?.username ?? "null"}');
// // // // // //       debugPrint('  allUsers count: ${allUsers.length}');

// // // // // //       state = state.copyWith(
// // // // // //         isLoading: false,
// // // // // //         myProfile: myProfile,
// // // // // //         allUsers: allUsers,
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       debugPrint('  fetchPanel ERROR: $e');
// // // // // //       state = state.copyWith(isLoading: false, error: e.toString());
// // // // // //     }
// // // // // //   }

// // // // // //   // ── Filters ───────────────────────────────────────────────────

// // // // // //   Future<void> applyFilters() => fetchPanel();

// // // // // //   void updateAge(RangeValues v) =>
// // // // // //       state = state.copyWith(ageMin: v.start.round(), ageMax: v.end.round());
// // // // // //   void updateHeight(RangeValues v) => state = state.copyWith(
// // // // // //       heightMin: v.start.round(), heightMax: v.end.round());
// // // // // //   void updateWeight(RangeValues v) => state = state.copyWith(
// // // // // //       weightMin: v.start.round(), weightMax: v.end.round());

// // // // // //   void togglePreference(String pref) {
// // // // // //     final list = [...state.selectedPreferences];
// // // // // //     if (list.contains(pref)) {
// // // // // //       list.remove(pref);
// // // // // //     } else {
// // // // // //       list.add(pref);
// // // // // //     }
// // // // // //     state = state.copyWith(selectedPreferences: list);
// // // // // //   }

// // // // // //   void setSearch(String q) => state = state.copyWith(searchQuery: q);

// // // // // //   // ── Calendar ──────────────────────────────────────────────────

// // // // // //   Future<List<CalendarSlot>> fetchCalendar(String payPerId) async {
// // // // // //     final r = await _post('/payperclick/get_user_calender_details', {
// // // // // //       'pay_per_id': payPerId,
// // // // // //     });
// // // // // //     if (_isOk(r)) {
// // // // // //       final d = r!['data'];
// // // // // //       if (d is List) return d.map((e) => CalendarSlot.fromJson(e)).toList();
// // // // // //     }
// // // // // //     return [];
// // // // // //   }

// // // // // //   // ── Terms ─────────────────────────────────────────────────────

// // // // // //   Future<TermsCondition?> fetchTerms() async {
// // // // // //     final r = await _get('/auth/pay_per_click_terms_condition');
// // // // // //     if (_isOk(r)) {
// // // // // //       final d = r!['data'];
// // // // // //       if (d is List && d.isNotEmpty) return TermsCondition.fromJson(d[0]);
// // // // // //     }
// // // // // //     return null;
// // // // // //   }

// // // // // //   // ── Check flags ───────────────────────────────────────────────

// // // // // //   Future<bool> checkPost() async {
// // // // // //     final r = await _get('/payperclick/check_chocolate_factory_post');
// // // // // //     return _isOk(r);
// // // // // //   }

// // // // // //   Future<bool> checkPopup() async {
// // // // // //     final r = await _get('/payperclick/check_chocolate_factory_popup');
// // // // // //     return _isOk(r);
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // 5)  P R O V I D E R
// // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // final panelProvider =
// // // // // //     StateNotifierProvider.autoDispose<PanelNotifier, PanelState>(
// // // // // //   (ref) => PanelNotifier(),
// // // // // // );

// // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // 6)  M A I N   P A G E   W I D G E T
// // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // class CelebrityPanelPage extends ConsumerStatefulWidget {
// // // // // //   const CelebrityPanelPage({super.key});

// // // // // //   @override
// // // // // //   ConsumerState<CelebrityPanelPage> createState() => _CelebrityPanelPageState();
// // // // // // }

// // // // // // class _CelebrityPanelPageState extends ConsumerState<CelebrityPanelPage>
// // // // // //     with TickerProviderStateMixin {
// // // // // //   final TextEditingController _searchCtrl = TextEditingController();
// // // // // //   bool _filterExpanded = false;

// // // // // //   // ── Colour palette ────────────────────────────────────────────
// // // // // //   static const _bg = Color(0xFF0B0B1A);
// // // // // //   static const _card = Color(0xFF13132B);
// // // // // //   static const _accent = Color(0xFFE91E63);
// // // // // //   static const _gold = Color(0xFFF4BA4A);
// // // // // //   static const _surface = Color(0xFF1C1C3A);

// // // // // //   @override
// // // // // //   void dispose() {
// // // // // //     _searchCtrl.dispose();
// // // // // //     super.dispose();
// // // // // //   }

// // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // //   // BUILD
// // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final s = ref.watch(panelProvider);

// // // // // //     return Scaffold(
// // // // // //       backgroundColor: _bg,
// // // // // //       body: CustomScrollView(
// // // // // //         physics: const BouncingScrollPhysics(),
// // // // // //         slivers: [
// // // // // //           // ── App Bar (no notification icon) ────────────────────
// // // // // //           SliverAppBar(
// // // // // //             leading: IconButton(
// // // // // //               icon: const Icon(Icons.arrow_back_ios_new,
// // // // // //                   color: Colors.white, size: 20),
// // // // // //               onPressed: () => Navigator.pop(context),
// // // // // //             ),
// // // // // //             expandedHeight: 130,
// // // // // //             floating: false,
// // // // // //             pinned: true,
// // // // // //             backgroundColor: _bg,
// // // // // //             elevation: 0,
// // // // // //             flexibleSpace: LayoutBuilder(
// // // // // //               builder: (context, constraints) {
// // // // // //                 final top = MediaQuery.of(context).padding.top;
// // // // // //                 final collapsed = kToolbarHeight + top;
// // // // // //                 final isCollapsed = constraints.maxHeight <= collapsed + 10;
// // // // // //                 return FlexibleSpaceBar(
// // // // // //                   centerTitle: false,
// // // // // //                   titlePadding: EdgeInsets.only(
// // // // // //                     left: isCollapsed ? 50 : 20,
// // // // // //                     bottom: 14,
// // // // // //                   ),
// // // // // //                   title: const Text(
// // // // // //                     'Celebrity Panel',
// // // // // //                     style: TextStyle(
// // // // // //                       color: Colors.white,
// // // // // //                       fontWeight: FontWeight.bold,
// // // // // //                       fontSize: 20,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   background: Container(
// // // // // //                     decoration: const BoxDecoration(
// // // // // //                       gradient: LinearGradient(
// // // // // //                         begin: Alignment.topCenter,
// // // // // //                         end: Alignment.bottomCenter,
// // // // // //                         colors: [_accent, _bg],
// // // // // //                         stops: [0.0, 0.8],
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 );
// // // // // //               },
// // // // // //             ),
// // // // // //           ),

// // // // // //           // ── Loading ───────────────────────────────────────────
// // // // // //           if (s.isLoading)
// // // // // //             const SliverFillRemaining(
// // // // // //               child: Center(child: CircularProgressIndicator(color: _accent)),
// // // // // //             )

// // // // // //           // ── Error ─────────────────────────────────────────────
// // // // // //           else if (s.error != null && s.allUsers.isEmpty)
// // // // // //             SliverFillRemaining(
// // // // // //               child: Center(
// // // // // //                 child: Column(
// // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // //                   children: [
// // // // // //                     const Icon(Icons.error_outline,
// // // // // //                         color: Colors.white24, size: 48),
// // // // // //                     const SizedBox(height: 16),
// // // // // //                     Text('Failed to load celebrities',
// // // // // //                         style: TextStyle(color: Colors.white.withAlpha(153))),
// // // // // //                     const SizedBox(height: 8),
// // // // // //                     Text(s.error ?? '',
// // // // // //                         style: TextStyle(color: Colors.white38, fontSize: 12),
// // // // // //                         textAlign: TextAlign.center),
// // // // // //                     const SizedBox(height: 12),
// // // // // //                     TextButton(
// // // // // //                       onPressed: () =>
// // // // // //                           ref.read(panelProvider.notifier).fetchPanel(),
// // // // // //                       child: const Text('Retry',
// // // // // //                           style: TextStyle(color: _accent)),
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             )

// // // // // //           // ── Content ───────────────────────────────────────────
// // // // // //           else ...[
// // // // // //             if (s.myProfile != null) _buildMyProfileCard(s.myProfile!),
// // // // // //             _buildSearchBar(),
// // // // // //             _buildFilterPanel(s),
// // // // // //             _buildUsersGrid(s),
// // // // // //             const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
// // // // // //           ],
// // // // // //         ],
// // // // // //       ),
// // // // // //       // ── NO FAB (removed) ──────────────────────────────────────
// // // // // //     );
// // // // // //   }

// // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // //   // MY PROFILE CARD
// // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // //   Widget _buildMyProfileCard(ChocolateFactoryUser u) {
// // // // // //     return SliverToBoxAdapter(
// // // // // //       child: Container(
// // // // // //         margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: _card,
// // // // // //           borderRadius: BorderRadius.circular(24),
// // // // // //           border: Border.all(color: Colors.white.withAlpha(25)),
// // // // // //           boxShadow: [
// // // // // //             BoxShadow(
// // // // // //               color: _accent.withAlpha(40),
// // // // // //               blurRadius: 30,
// // // // // //               offset: const Offset(0, 10),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //         child: Column(
// // // // // //           children: [
// // // // // //             // ── Image ─────────────────────────────────────────
// // // // // //             SizedBox(
// // // // // //               height: 220,
// // // // // //               child: Stack(
// // // // // //                 children: [
// // // // // //                   ClipRRect(
// // // // // //                     borderRadius: const BorderRadius.vertical(
// // // // // //                         top: Radius.circular(24)),
// // // // // //                     child: SizedBox(
// // // // // //                       width: double.infinity,
// // // // // //                       child: _networkImage(u.profileImage, fit: BoxFit.cover),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   // Badge
// // // // // //                   Positioned(
// // // // // //                     top: 12,
// // // // // //                     left: 12,
// // // // // //                     child: Container(
// // // // // //                       padding: const EdgeInsets.all(8),
// // // // // //                       decoration: BoxDecoration(
// // // // // //                         color: _accent.withAlpha(200),
// // // // // //                         borderRadius: BorderRadius.circular(12),
// // // // // //                       ),
// // // // // //                       child: Image.network(
// // // // // //                         '${kAssetBase}img/badge1.png',
// // // // // //                         width: 40,
// // // // // //                         height: 40,
// // // // // //                         errorBuilder: (_, __, ___) =>
// // // // // //                             const Icon(Icons.verified, color: Colors.white),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   // Edit button
// // // // // //                   Positioned(
// // // // // //                     top: 12,
// // // // // //                     right: 12,
// // // // // //                     child: GestureDetector(
// // // // // //                       onTap: () {},
// // // // // //                       child: Container(
// // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // //                             horizontal: 14, vertical: 8),
// // // // // //                         decoration: BoxDecoration(
// // // // // //                           color: Colors.black.withAlpha(150),
// // // // // //                           borderRadius: BorderRadius.circular(20),
// // // // // //                           border: Border.all(
// // // // // //                               color: Colors.white.withAlpha(60)),
// // // // // //                         ),
// // // // // //                         child: const Row(
// // // // // //                           mainAxisSize: MainAxisSize.min,
// // // // // //                           children: [
// // // // // //                             Icon(Icons.edit, color: Colors.white, size: 14),
// // // // // //                             SizedBox(width: 4),
// // // // // //                             Text('Edit Profile',
// // // // // //                                 style: TextStyle(
// // // // // //                                     color: Colors.white,
// // // // // //                                     fontSize: 12,
// // // // // //                                     fontWeight: FontWeight.w600)),
// // // // // //                           ],
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   // Gradient
// // // // // //                   Positioned.fill(
// // // // // //                     child: Container(
// // // // // //                       decoration: BoxDecoration(
// // // // // //                         borderRadius: const BorderRadius.vertical(
// // // // // //                             top: Radius.circular(24)),
// // // // // //                         gradient: LinearGradient(
// // // // // //                           begin: Alignment.topCenter,
// // // // // //                           end: Alignment.bottomCenter,
// // // // // //                           colors: [
// // // // // //                             Colors.transparent,
// // // // // //                             Colors.black.withAlpha(180),
// // // // // //                           ],
// // // // // //                           stops: const [0.5, 1.0],
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   // Name + age
// // // // // //                   Positioned(
// // // // // //                     left: 16,
// // // // // //                     bottom: 16,
// // // // // //                     child: Row(
// // // // // //                       children: [
// // // // // //                         Text(u.username,
// // // // // //                             style: const TextStyle(
// // // // // //                                 color: Colors.white,
// // // // // //                                 fontSize: 22,
// // // // // //                                 fontWeight: FontWeight.bold)),
// // // // // //                         if (u.showAge == '1') ...[
// // // // // //                           const SizedBox(width: 8),
// // // // // //                           Text('Age ${u.age}',
// // // // // //                               style: TextStyle(
// // // // // //                                   color: Colors.white.withAlpha(200),
// // // // // //                                   fontSize: 14)),
// // // // // //                         ],
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),

// // // // // //             // ── Info ───────────────────────────────────────────
// // // // // //             Padding(
// // // // // //               padding: const EdgeInsets.all(20),
// // // // // //               child: Column(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [
// // // // // //                   // Location
// // // // // //                   Row(
// // // // // //                     children: [
// // // // // //                       const Icon(Icons.location_on, color: _accent, size: 16),
// // // // // //                       const SizedBox(width: 6),
// // // // // //                       Text(u.stateOfResidence,
// // // // // //                           style: TextStyle(
// // // // // //                               color: Colors.white.withAlpha(180),
// // // // // //                               fontSize: 14)),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 14),

// // // // // //                   // Stats
// // // // // //                   Row(
// // // // // //                     children: [
// // // // // //                       if (u.showHeight == '1')
// // // // // //                         _statChip(Icons.height, u.displayHeight),
// // // // // //                       if (u.showHeight == '1') const SizedBox(width: 12),
// // // // // //                       if (u.showWeight == '1')
// // // // // //                         _statChip(
// // // // // //                             Icons.monitor_weight_outlined, '${u.weight} Kg'),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 14),

// // // // // //                   // Preferences
// // // // // //                   if (u.showPreferences == '1' &&
// // // // // //                       u.preferences.isNotEmpty) ...[
// // // // // //                     const Text('Preferences',
// // // // // //                         style: TextStyle(
// // // // // //                             color: Colors.white,
// // // // // //                             fontSize: 14,
// // // // // //                             fontWeight: FontWeight.w600)),
// // // // // //                     const SizedBox(height: 8),
// // // // // //                     Wrap(
// // // // // //                       spacing: 8,
// // // // // //                       runSpacing: 8,
// // // // // //                       children: u.preferences
// // // // // //                           .map((p) => Container(
// // // // // //                                 padding: const EdgeInsets.symmetric(
// // // // // //                                     horizontal: 12, vertical: 6),
// // // // // //                                 decoration: BoxDecoration(
// // // // // //                                   color: _accent.withAlpha(30),
// // // // // //                                   borderRadius: BorderRadius.circular(20),
// // // // // //                                   border: Border.all(
// // // // // //                                       color: _accent.withAlpha(80)),
// // // // // //                                 ),
// // // // // //                                 child: Text(p,
// // // // // //                                     style: const TextStyle(
// // // // // //                                         color: _accent, fontSize: 12)),
// // // // // //                               ))
// // // // // //                           .toList(),
// // // // // //                     ),
// // // // // //                     const SizedBox(height: 14),
// // // // // //                   ],

// // // // // //                   // Calendar + Review
// // // // // //                   Row(
// // // // // //                     children: [
// // // // // //                       Expanded(
// // // // // //                         child: GestureDetector(
// // // // // //                           onTap: () =>
// // // // // //                               _showCalendarDialog(u.id, u.username),
// // // // // //                           child: Container(
// // // // // //                             padding: const EdgeInsets.symmetric(vertical: 12),
// // // // // //                             decoration: BoxDecoration(
// // // // // //                               color: _surface,
// // // // // //                               borderRadius: BorderRadius.circular(14),
// // // // // //                               border: Border.all(
// // // // // //                                   color: Colors.white.withAlpha(20)),
// // // // // //                             ),
// // // // // //                             child: const Row(
// // // // // //                               mainAxisAlignment: MainAxisAlignment.center,
// // // // // //                               children: [
// // // // // //                                 Icon(Icons.calendar_month,
// // // // // //                                     color: _gold, size: 18),
// // // // // //                                 SizedBox(width: 8),
// // // // // //                                 Text('Calendar',
// // // // // //                                     style: TextStyle(
// // // // // //                                         color: Colors.white,
// // // // // //                                         fontSize: 13,
// // // // // //                                         fontWeight: FontWeight.w600)),
// // // // // //                                 SizedBox(width: 4),
// // // // // //                                 Text('View booked slots',
// // // // // //                                     style: TextStyle(
// // // // // //                                         color: Colors.white54, fontSize: 11)),
// // // // // //                               ],
// // // // // //                             ),
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                       const SizedBox(width: 10),
// // // // // //                       GestureDetector(
// // // // // //                         onTap: () {},
// // // // // //                         child: Container(
// // // // // //                           padding: const EdgeInsets.symmetric(
// // // // // //                               horizontal: 16, vertical: 12),
// // // // // //                           decoration: BoxDecoration(
// // // // // //                             color: _accent.withAlpha(20),
// // // // // //                             borderRadius: BorderRadius.circular(14),
// // // // // //                             border:
// // // // // //                                 Border.all(color: _accent.withAlpha(60)),
// // // // // //                           ),
// // // // // //                           child: const Row(
// // // // // //                             children: [
// // // // // //                               Icon(Icons.rate_review,
// // // // // //                                   color: _accent, size: 16),
// // // // // //                               SizedBox(width: 6),
// // // // // //                               Text('Write Review',
// // // // // //                                   style: TextStyle(
// // // // // //                                       color: _accent, fontSize: 13)),
// // // // // //                             ],
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 14),

// // // // // //                   // Description
// // // // // //                   if (u.selfDescription.isNotEmpty) ...[
// // // // // //                     Text('Description',
// // // // // //                         style: TextStyle(
// // // // // //                             color: Colors.white.withAlpha(150),
// // // // // //                             fontSize: 12,
// // // // // //                             fontWeight: FontWeight.w600)),
// // // // // //                     const SizedBox(height: 6),
// // // // // //                     Text(u.selfDescription,
// // // // // //                         style: TextStyle(
// // // // // //                             color: Colors.white.withAlpha(120),
// // // // // //                             fontSize: 13,
// // // // // //                             height: 1.5),
// // // // // //                         maxLines: 4,
// // // // // //                         overflow: TextOverflow.ellipsis),
// // // // // //                   ],
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _statChip(IconData icon, String label) {
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: _surface,
// // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // //         border: Border.all(color: Colors.white.withAlpha(20)),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         mainAxisSize: MainAxisSize.min,
// // // // // //         children: [
// // // // // //           Icon(icon, color: _gold, size: 16),
// // // // // //           const SizedBox(width: 6),
// // // // // //           Text(label,
// // // // // //               style: const TextStyle(color: Colors.white, fontSize: 13)),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // //   // SEARCH BAR
// // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // //   Widget _buildSearchBar() {
// // // // // //     return SliverToBoxAdapter(
// // // // // //       child: Padding(
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // // //         child: Row(
// // // // // //           children: [
// // // // // //             Expanded(
// // // // // //               child: Container(
// // // // // //                 height: 50,
// // // // // //                 decoration: BoxDecoration(
// // // // // //                   color: Colors.white.withAlpha(15),
// // // // // //                   borderRadius: BorderRadius.circular(15),
// // // // // //                 ),
// // // // // //                 child: TextField(
// // // // // //                   controller: _searchCtrl,
// // // // // //                   style: const TextStyle(color: Colors.white),
// // // // // //                   onChanged: (v) =>
// // // // // //                       ref.read(panelProvider.notifier).setSearch(v),
// // // // // //                   decoration: InputDecoration(
// // // // // //                     hintText: 'Search celebrities...',
// // // // // //                     hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
// // // // // //                     prefixIcon: Icon(Icons.search,
// // // // // //                         color: Colors.white.withAlpha(100)),
// // // // // //                     border: InputBorder.none,
// // // // // //                     contentPadding: const EdgeInsets.symmetric(vertical: 15),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(width: 12),
// // // // // //             GestureDetector(
// // // // // //               onTap: () =>
// // // // // //                   setState(() => _filterExpanded = !_filterExpanded),
// // // // // //               child: AnimatedContainer(
// // // // // //                 duration: const Duration(milliseconds: 300),
// // // // // //                 height: 50,
// // // // // //                 width: 50,
// // // // // //                 decoration: BoxDecoration(
// // // // // //                   color: _filterExpanded
// // // // // //                       ? _accent
// // // // // //                       : _accent.withAlpha(30),
// // // // // //                   borderRadius: BorderRadius.circular(15),
// // // // // //                   border: Border.all(
// // // // // //                       color:
// // // // // //                           _accent.withAlpha(_filterExpanded ? 255 : 120)),
// // // // // //                 ),
// // // // // //                 child: AnimatedRotation(
// // // // // //                   duration: const Duration(milliseconds: 300),
// // // // // //                   turns: _filterExpanded ? 0.125 : 0,
// // // // // //                   child: Icon(Icons.tune,
// // // // // //                       color: _filterExpanded ? Colors.white : _accent),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // //   // FILTER PANEL
// // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // //   Widget _buildFilterPanel(PanelState s) {
// // // // // //     return SliverToBoxAdapter(
// // // // // //       child: AnimatedContainer(
// // // // // //         duration: const Duration(milliseconds: 400),
// // // // // //         curve: Curves.easeInOutCubic,
// // // // // //         height: _filterExpanded ? null : 0,
// // // // // //         clipBehavior: Clip.hardEdge,
// // // // // //         child: AnimatedOpacity(
// // // // // //           duration: const Duration(milliseconds: 300),
// // // // // //           opacity: _filterExpanded ? 1.0 : 0.0,
// // // // // //           child: Container(
// // // // // //             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// // // // // //             padding: const EdgeInsets.all(20),
// // // // // //             decoration: BoxDecoration(
// // // // // //               color: _card,
// // // // // //               borderRadius: BorderRadius.circular(20),
// // // // // //               border: Border.all(color: Colors.white.withAlpha(20)),
// // // // // //             ),
// // // // // //             child: Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 _rangeSlider(
// // // // // //                   label: 'Age',
// // // // // //                   icon: Icons.cake,
// // // // // //                   min: 18,
// // // // // //                   max: 100,
// // // // // //                   values: RangeValues(
// // // // // //                       s.ageMin.toDouble(), s.ageMax.toDouble()),
// // // // // //                   onChanged: (v) =>
// // // // // //                       ref.read(panelProvider.notifier).updateAge(v),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 18),
// // // // // //                 _rangeSlider(
// // // // // //                   label: 'Height (ft)',
// // // // // //                   icon: Icons.height,
// // // // // //                   min: 0,
// // // // // //                   max: 10,
// // // // // //                   values: RangeValues(
// // // // // //                       s.heightMin.toDouble(), s.heightMax.toDouble()),
// // // // // //                   onChanged: (v) =>
// // // // // //                       ref.read(panelProvider.notifier).updateHeight(v),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 18),
// // // // // //                 _rangeSlider(
// // // // // //                   label: 'Weight (Kg)',
// // // // // //                   icon: Icons.monitor_weight_outlined,
// // // // // //                   min: 20,
// // // // // //                   max: 200,
// // // // // //                   values: RangeValues(
// // // // // //                       s.weightMin.toDouble(), s.weightMax.toDouble()),
// // // // // //                   onChanged: (v) =>
// // // // // //                       ref.read(panelProvider.notifier).updateWeight(v),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 18),
// // // // // //                 const Text('Preferences',
// // // // // //                     style: TextStyle(
// // // // // //                         color: Colors.white,
// // // // // //                         fontSize: 14,
// // // // // //                         fontWeight: FontWeight.w600)),
// // // // // //                 const SizedBox(height: 10),
// // // // // //                 Wrap(
// // // // // //                   spacing: 8,
// // // // // //                   runSpacing: 8,
// // // // // //                   children: kPreferenceOptions.map((pref) {
// // // // // //                     final selected =
// // // // // //                         s.selectedPreferences.contains(pref);
// // // // // //                     return GestureDetector(
// // // // // //                       onTap: () => ref
// // // // // //                           .read(panelProvider.notifier)
// // // // // //                           .togglePreference(pref),
// // // // // //                       child: AnimatedContainer(
// // // // // //                         duration: const Duration(milliseconds: 200),
// // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // //                             horizontal: 14, vertical: 8),
// // // // // //                         decoration: BoxDecoration(
// // // // // //                           color: selected ? _accent : _surface,
// // // // // //                           borderRadius: BorderRadius.circular(20),
// // // // // //                           border: Border.all(
// // // // // //                             color: selected
// // // // // //                                 ? _accent
// // // // // //                                 : Colors.white.withAlpha(30),
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                         child: Row(
// // // // // //                           mainAxisSize: MainAxisSize.min,
// // // // // //                           children: [
// // // // // //                             Icon(
// // // // // //                               selected
// // // // // //                                   ? Icons.check_circle
// // // // // //                                   : Icons.circle_outlined,
// // // // // //                               color: selected
// // // // // //                                   ? Colors.white
// // // // // //                                   : Colors.white.withAlpha(80),
// // // // // //                               size: 16,
// // // // // //                             ),
// // // // // //                             const SizedBox(width: 6),
// // // // // //                             Text(pref,
// // // // // //                                 style: TextStyle(
// // // // // //                                   color: selected
// // // // // //                                       ? Colors.white
// // // // // //                                       : Colors.white.withAlpha(120),
// // // // // //                                   fontSize: 12,
// // // // // //                                   fontWeight: selected
// // // // // //                                       ? FontWeight.w600
// // // // // //                                       : FontWeight.normal,
// // // // // //                                 )),
// // // // // //                           ],
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     );
// // // // // //                   }).toList(),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 20),
// // // // // //                 SizedBox(
// // // // // //                   width: double.infinity,
// // // // // //                   height: 50,
// // // // // //                   child: ElevatedButton.icon(
// // // // // //                     onPressed: () =>
// // // // // //                         ref.read(panelProvider.notifier).applyFilters(),
// // // // // //                     icon: const Icon(Icons.filter_list, color: Colors.white),
// // // // // //                     label: const Text('Apply Filters',
// // // // // //                         style: TextStyle(
// // // // // //                             color: Colors.white,
// // // // // //                             fontWeight: FontWeight.bold,
// // // // // //                             fontSize: 16)),
// // // // // //                     style: ElevatedButton.styleFrom(
// // // // // //                       backgroundColor: _accent,
// // // // // //                       shape: RoundedRectangleBorder(
// // // // // //                           borderRadius: BorderRadius.circular(16)),
// // // // // //                       elevation: 4,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _rangeSlider({
// // // // // //     required String label,
// // // // // //     required IconData icon,
// // // // // //     required double min,
// // // // // //     required double max,
// // // // // //     required RangeValues values,
// // // // // //     required ValueChanged<RangeValues> onChanged,
// // // // // //   }) {
// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         Row(
// // // // // //           children: [
// // // // // //             Icon(icon, color: _gold, size: 16),
// // // // // //             const SizedBox(width: 8),
// // // // // //             Text(label,
// // // // // //                 style: const TextStyle(
// // // // // //                     color: Colors.white,
// // // // // //                     fontSize: 14,
// // // // // //                     fontWeight: FontWeight.w600)),
// // // // // //             const Spacer(),
// // // // // //             Text('${values.start.round()} – ${values.end.round()}',
// // // // // //                 style: TextStyle(color: _accent, fontSize: 13)),
// // // // // //           ],
// // // // // //         ),
// // // // // //         SliderTheme(
// // // // // //           data: SliderThemeData(
// // // // // //             activeTrackColor: _accent,
// // // // // //             inactiveTrackColor: Colors.white.withAlpha(30),
// // // // // //             thumbColor: _accent,
// // // // // //             overlayColor: _accent.withAlpha(30),
// // // // // //             rangeThumbShape:
// // // // // //                 const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
// // // // // //           ),
// // // // // //           child: RangeSlider(
// // // // // //             values: values,
// // // // // //             min: min,
// // // // // //             max: max,
// // // // // //             onChanged: onChanged,
// // // // // //           ),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }

// // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // //   // ALL USERS GRID  (flip-card style)
// // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // //   Widget _buildUsersGrid(PanelState s) {
// // // // // //     final users = s.filteredUsers;

// // // // // //     if (users.isEmpty) {
// // // // // //       return SliverToBoxAdapter(
// // // // // //         child: Container(
// // // // // //           margin: const EdgeInsets.all(40),
// // // // // //           padding: const EdgeInsets.symmetric(vertical: 50),
// // // // // //           decoration: BoxDecoration(
// // // // // //             color: _card,
// // // // // //             borderRadius: BorderRadius.circular(24),
// // // // // //           ),
// // // // // //           child: Column(
// // // // // //             children: [
// // // // // //               Icon(Icons.search,
// // // // // //                   size: 60, color: Colors.white.withAlpha(40)),
// // // // // //               const SizedBox(height: 16),
// // // // // //               const Text('No Records Found',
// // // // // //                   style: TextStyle(
// // // // // //                       color: Colors.white,
// // // // // //                       fontSize: 18,
// // // // // //                       fontWeight: FontWeight.bold)),
// // // // // //               const SizedBox(height: 8),
// // // // // //               Text('Try adjusting your filters to find more results.',
// // // // // //                   style: TextStyle(
// // // // // //                       color: Colors.white.withAlpha(80), fontSize: 14)),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),
// // // // // //       );
// // // // // //     }

// // // // // //     return SliverPadding(
// // // // // //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
// // // // // //       sliver: SliverGrid(
// // // // // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // //           crossAxisCount: 2,
// // // // // //           mainAxisSpacing: 16,
// // // // // //           crossAxisSpacing: 16,
// // // // // //           childAspectRatio: 0.52,
// // // // // //         ),
// // // // // //         delegate: SliverChildBuilderDelegate(
// // // // // //           (context, index) => _FlipCardWidget(
// // // // // //             user: users[index],
// // // // // //             onViewMore: () => _navigateToUserProfile(users[index]),
// // // // // //             onCalendar: () => _showCalendarDialog(
// // // // // //                 users[index].id, users[index].username),
// // // // // //           ),
// // // // // //           childCount: users.length,
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // //   // CALENDAR DIALOG
// // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // //   void _showCalendarDialog(String payPerId, String username) {
// // // // // //     showGeneralDialog(
// // // // // //       context: context,
// // // // // //       barrierDismissible: true,
// // // // // //       barrierLabel: 'Calendar',
// // // // // //       barrierColor: Colors.black87,
// // // // // //       transitionDuration: const Duration(milliseconds: 350),
// // // // // //       pageBuilder: (ctx, anim1, anim2) => Center(
// // // // // //         child: Material(
// // // // // //           color: Colors.transparent,
// // // // // //           child: Container(
// // // // // //             width: MediaQuery.of(ctx).size.width * 0.9,
// // // // // //             constraints: const BoxConstraints(maxHeight: 500),
// // // // // //             decoration: BoxDecoration(
// // // // // //               color: _card,
// // // // // //               borderRadius: BorderRadius.circular(24),
// // // // // //               border: Border.all(color: Colors.white.withAlpha(20)),
// // // // // //             ),
// // // // // //             child: Column(
// // // // // //               mainAxisSize: MainAxisSize.min,
// // // // // //               children: [
// // // // // //                 Container(
// // // // // //                   padding: const EdgeInsets.all(20),
// // // // // //                   decoration: const BoxDecoration(
// // // // // //                     gradient:
// // // // // //                         LinearGradient(colors: [_accent, Color(0xFF5C2438)]),
// // // // // //                     borderRadius: BorderRadius.vertical(
// // // // // //                         top: Radius.circular(24)),
// // // // // //                   ),
// // // // // //                   child: Row(
// // // // // //                     children: [
// // // // // //                       const Icon(Icons.calendar_month,
// // // // // //                           color: Colors.white, size: 24),
// // // // // //                       const SizedBox(width: 10),
// // // // // //                       const Expanded(
// // // // // //                         child: Text('Already Booked Slots',
// // // // // //                             style: TextStyle(
// // // // // //                                 color: Colors.white,
// // // // // //                                 fontSize: 18,
// // // // // //                                 fontWeight: FontWeight.bold)),
// // // // // //                       ),
// // // // // //                       IconButton(
// // // // // //                         icon: const Icon(Icons.close, color: Colors.white70),
// // // // // //                         onPressed: () => Navigator.pop(ctx),
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 Padding(
// // // // // //                   padding: const EdgeInsets.all(16),
// // // // // //                   child: FutureBuilder<List<CalendarSlot>>(
// // // // // //                     future: ref
// // // // // //                         .read(panelProvider.notifier)
// // // // // //                         .fetchCalendar(payPerId),
// // // // // //                     builder: (ctx, snap) {
// // // // // //                       if (snap.connectionState == ConnectionState.waiting) {
// // // // // //                         return const Padding(
// // // // // //                           padding: EdgeInsets.all(30),
// // // // // //                           child: Center(
// // // // // //                               child:
// // // // // //                                   CircularProgressIndicator(color: _accent)),
// // // // // //                         );
// // // // // //                       }
// // // // // //                       final slots = snap.data ?? [];
// // // // // //                       if (slots.isEmpty) {
// // // // // //                         return const Padding(
// // // // // //                           padding: EdgeInsets.all(30),
// // // // // //                           child: Text('No record found…..',
// // // // // //                               style: TextStyle(color: Colors.white54)),
// // // // // //                         );
// // // // // //                       }
// // // // // //                       return Column(
// // // // // //                         children: slots.asMap().entries.map((entry) {
// // // // // //                           final i = entry.key;
// // // // // //                           final slot = entry.value;
// // // // // //                           return Container(
// // // // // //                             margin: const EdgeInsets.only(bottom: 10),
// // // // // //                             padding: const EdgeInsets.all(14),
// // // // // //                             decoration: BoxDecoration(
// // // // // //                               color: _surface,
// // // // // //                               borderRadius: BorderRadius.circular(14),
// // // // // //                               border: Border.all(
// // // // // //                                   color: Colors.white.withAlpha(15)),
// // // // // //                             ),
// // // // // //                             child: Row(
// // // // // //                               children: [
// // // // // //                                 Container(
// // // // // //                                   width: 32,
// // // // // //                                   height: 32,
// // // // // //                                   decoration: BoxDecoration(
// // // // // //                                     color: _accent.withAlpha(30),
// // // // // //                                     borderRadius: BorderRadius.circular(10),
// // // // // //                                   ),
// // // // // //                                   child: Center(
// // // // // //                                     child: Text('${i + 1}',
// // // // // //                                         style: const TextStyle(
// // // // // //                                             color: _accent,
// // // // // //                                             fontWeight: FontWeight.bold)),
// // // // // //                                   ),
// // // // // //                                 ),
// // // // // //                                 const SizedBox(width: 12),
// // // // // //                                 Expanded(
// // // // // //                                   child: Column(
// // // // // //                                     crossAxisAlignment:
// // // // // //                                         CrossAxisAlignment.start,
// // // // // //                                     children: [
// // // // // //                                       Text(slot.username,
// // // // // //                                           style: const TextStyle(
// // // // // //                                               color: Colors.white,
// // // // // //                                               fontWeight: FontWeight.w600,
// // // // // //                                               fontSize: 14)),
// // // // // //                                       const SizedBox(height: 4),
// // // // // //                                       Text(slot.calenderDate,
// // // // // //                                           style: TextStyle(
// // // // // //                                               color: _gold, fontSize: 12)),
// // // // // //                                     ],
// // // // // //                                   ),
// // // // // //                                 ),
// // // // // //                                 Column(
// // // // // //                                   crossAxisAlignment: CrossAxisAlignment.end,
// // // // // //                                   children: [
// // // // // //                                     Row(
// // // // // //                                       children: [
// // // // // //                                         Icon(Icons.play_arrow,
// // // // // //                                             color:
// // // // // //                                                 Colors.greenAccent.shade400,
// // // // // //                                             size: 14),
// // // // // //                                         const SizedBox(width: 4),
// // // // // //                                         Text(slot.startTime12Format,
// // // // // //                                             style: const TextStyle(
// // // // // //                                                 color: Colors.greenAccent,
// // // // // //                                                 fontSize: 12)),
// // // // // //                                       ],
// // // // // //                                     ),
// // // // // //                                     const SizedBox(height: 2),
// // // // // //                                     Row(
// // // // // //                                       children: [
// // // // // //                                         Icon(Icons.stop,
// // // // // //                                             color: Colors.redAccent.shade200,
// // // // // //                                             size: 14),
// // // // // //                                         const SizedBox(width: 4),
// // // // // //                                         Text(slot.endTime12Format,
// // // // // //                                             style: TextStyle(
// // // // // //                                                 color:
// // // // // //                                                     Colors.redAccent.shade200,
// // // // // //                                                 fontSize: 12)),
// // // // // //                                       ],
// // // // // //                                     ),
// // // // // //                                   ],
// // // // // //                                 ),
// // // // // //                               ],
// // // // // //                             ),
// // // // // //                           );
// // // // // //                         }).toList(),
// // // // // //                       );
// // // // // //                     },
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //       transitionBuilder: (ctx, anim1, anim2, child) =>
// // // // // //           ScaleTransition(scale: anim1, child: child),
// // // // // //     );
// // // // // //   }

// // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // //   // NAVIGATE TO USER PROFILE
// // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // //   void _navigateToUserProfile(ChocolateFactoryUser user) {
// // // // // //     // ── Uncomment after adding the imports at the top ──────────
// // // // // //     //
// // // // // //     // Navigator.push(
// // // // // //     //   context,
// // // // // //     //   MaterialPageRoute(
// // // // // //     //     builder: (_) => OtherUserProfilePage(
// // // // // //     //       user: UserListItem(
// // // // // //     //         id: user.id,
// // // // // //     //         name: user.username,
// // // // // //     //         imageUrl: user.profileImage,
// // // // // //     //         lastSeen: 'Offline',
// // // // // //     //         location: user.stateOfResidence,
// // // // // //     //         isOnline: false,
// // // // // //     //       ),
// // // // // //     //     ),
// // // // // //     //   ),
// // // // // //     // );
// // // // // //   }

// // // // // //   // ════════════════════════════════════════════════════════════════
// // // // // //   // NETWORK IMAGE HELPER
// // // // // //   // ════════════════════════════════════════════════════════════════

// // // // // //   Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
// // // // // //     if (url.isEmpty) {
// // // // // //       return Container(
// // // // // //         color: _surface,
// // // // // //         child: const Center(
// // // // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // // // //       );
// // // // // //     }
// // // // // //     String full = url;
// // // // // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // // // // //     return Image.network(
// // // // // //       full,
// // // // // //       fit: fit,
// // // // // //       errorBuilder: (_, __, ___) => Container(
// // // // // //         color: _surface,
// // // // // //         child: const Center(
// // // // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // // // //       ),
// // // // // //       loadingBuilder: (_, child, progress) {
// // // // // //         if (progress == null) return child;
// // // // // //         return Container(
// // // // // //           color: _surface,
// // // // // //           child: const Center(
// // // // // //             child: CircularProgressIndicator(
// // // // // //                 color: _accent, strokeWidth: 2),
// // // // // //           ),
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // // FLIP CARD — tap to flip between front (image) and back (info)
// // // // // // // ════════════════════════════════════════════════════════════════════

// // // // // // class _FlipCardWidget extends StatefulWidget {
// // // // // //   final ChocolateFactoryUser user;
// // // // // //   final VoidCallback onViewMore;
// // // // // //   final VoidCallback onCalendar;

// // // // // //   const _FlipCardWidget({
// // // // // //     required this.user,
// // // // // //     required this.onViewMore,
// // // // // //     required this.onCalendar,
// // // // // //   });

// // // // // //   @override
// // // // // //   State<_FlipCardWidget> createState() => _FlipCardWidgetState();
// // // // // // }

// // // // // // class _FlipCardWidgetState extends State<_FlipCardWidget>
// // // // // //     with SingleTickerProviderStateMixin {
// // // // // //   late AnimationController _controller;
// // // // // //   late Animation<double> _animation;
// // // // // //   bool _showFront = true;

// // // // // //   static const _bg = Color(0xFF13132B);
// // // // // //   static const _accent = Color(0xFFE91E63);
// // // // // //   static const _surface = Color(0xFF1C1C3A);
// // // // // //   static const _gold = Color(0xFFF4BA4A);

// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _controller = AnimationController(
// // // // // //       duration: const Duration(milliseconds: 600),
// // // // // //       vsync: this,
// // // // // //     );
// // // // // //     _animation = Tween<double>(begin: 0, end: 1).animate(
// // // // // //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
// // // // // //     );
// // // // // //   }

// // // // // //   @override
// // // // // //   void dispose() {
// // // // // //     _controller.dispose();
// // // // // //     super.dispose();
// // // // // //   }

// // // // // //   void _flip() {
// // // // // //     if (_showFront) {
// // // // // //       _controller.forward();
// // // // // //     } else {
// // // // // //       _controller.reverse();
// // // // // //     }
// // // // // //     setState(() => _showFront = !_showFront);
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final u = widget.user;
// // // // // //     return GestureDetector(
// // // // // //       onTap: _flip,
// // // // // //       child: AnimatedBuilder(
// // // // // //         animation: _animation,
// // // // // //         builder: (context, child) {
// // // // // //           final angle = _animation.value * 3.14159265;
// // // // // //           final isFront = angle < 1.5708;
// // // // // //           return Transform(
// // // // // //             alignment: Alignment.center,
// // // // // //             transform: Matrix4.identity()
// // // // // //               ..setEntry(3, 2, 0.001)
// // // // // //               ..rotateY(angle),
// // // // // //             child: isFront
// // // // // //                 ? _buildFront(u)
// // // // // //                 : Transform(
// // // // // //                     alignment: Alignment.center,
// // // // // //                     transform: Matrix4.identity()..rotateY(3.14159265),
// // // // // //                     child: _buildBack(u),
// // // // // //                   ),
// // // // // //           );
// // // // // //         },
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // ── Front ──────────────────────────────────────────────────────

// // // // // //   Widget _buildFront(ChocolateFactoryUser u) {
// // // // // //     return Container(
// // // // // //       decoration: BoxDecoration(
// // // // // //         borderRadius: BorderRadius.circular(20),
// // // // // //         color: _bg,
// // // // // //         boxShadow: [
// // // // // //           BoxShadow(
// // // // // //             color: Colors.black.withAlpha(80),
// // // // // //             blurRadius: 15,
// // // // // //             offset: const Offset(0, 8),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //       child: Stack(
// // // // // //         children: [
// // // // // //           ClipRRect(
// // // // // //             borderRadius: BorderRadius.circular(20),
// // // // // //             child: SizedBox(
// // // // // //               width: double.infinity,
// // // // // //               height: double.infinity,
// // // // // //               child: _networkImg(u.profileImage),
// // // // // //             ),
// // // // // //           ),
// // // // // //           Positioned(
// // // // // //             top: 10,
// // // // // //             left: 10,
// // // // // //             child: Image.network(
// // // // // //               '${kAssetBase}img/badge1.png',
// // // // // //               width: 40,
// // // // // //               height: 40,
// // // // // //               errorBuilder: (_, __, ___) =>
// // // // // //                   const Icon(Icons.verified, color: _gold, size: 28),
// // // // // //             ),
// // // // // //           ),
// // // // // //           Positioned.fill(
// // // // // //             child: Container(
// // // // // //               decoration: BoxDecoration(
// // // // // //                 borderRadius: BorderRadius.circular(20),
// // // // // //                 gradient: LinearGradient(
// // // // // //                   begin: Alignment.topCenter,
// // // // // //                   end: Alignment.bottomCenter,
// // // // // //                   colors: [
// // // // // //                     Colors.transparent,
// // // // // //                     Colors.transparent,
// // // // // //                     Colors.black.withAlpha(200),
// // // // // //                   ],
// // // // // //                   stops: const [0.0, 0.5, 1.0],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           Positioned(
// // // // // //             left: 14,
// // // // // //             bottom: 14,
// // // // // //             right: 14,
// // // // // //             child: Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 Text(u.username,
// // // // // //                     style: const TextStyle(
// // // // // //                         color: Colors.white,
// // // // // //                         fontSize: 16,
// // // // // //                         fontWeight: FontWeight.bold)),
// // // // // //                 if (u.showAge == '1')
// // // // // //                   Text('Age ${u.age}',
// // // // // //                       style: TextStyle(
// // // // // //                           color: Colors.white.withAlpha(180), fontSize: 12)),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // ── Back ───────────────────────────────────────────────────────

// // // // // //   Widget _buildBack(ChocolateFactoryUser u) {
// // // // // //     return Container(
// // // // // //       decoration: const BoxDecoration(
// // // // // //         borderRadius: BorderRadius.all(Radius.circular(20)),
// // // // // //         gradient: LinearGradient(
// // // // // //           colors: [Color(0xFF560827), Color(0xFF06032C)],
// // // // // //         ),
// // // // // //       ),
// // // // // //       child: Padding(
// // // // // //         padding: const EdgeInsets.all(16),
// // // // // //         child: Column(
// // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // //           children: [
// // // // // //             Text(u.username,
// // // // // //                 style: const TextStyle(
// // // // // //                     color: Colors.white,
// // // // // //                     fontSize: 20,
// // // // // //                     fontWeight: FontWeight.bold),
// // // // // //                 textAlign: TextAlign.center),
// // // // // //             const SizedBox(height: 4),
// // // // // //             if (u.stateOfResidence.isNotEmpty)
// // // // // //               Text(u.stateOfResidence,
// // // // // //                   style:
// // // // // //                       TextStyle(color: Colors.white.withAlpha(160), fontSize: 13)),
// // // // // //             const SizedBox(height: 12),
// // // // // //             Wrap(
// // // // // //               alignment: WrapAlignment.center,
// // // // // //               spacing: 8,
// // // // // //               runSpacing: 6,
// // // // // //               children: [
// // // // // //                 if (u.showAge == '1') _backChip('${u.age} yrs'),
// // // // // //                 if (u.showHeight == '1')
// // // // // //                   _backChip("${u.heightFeet}' ${u.heightInch}\""),
// // // // // //                 if (u.showWeight == '1') _backChip('${u.weight} Kg'),
// // // // // //               ],
// // // // // //             ),
// // // // // //             const SizedBox(height: 10),
// // // // // //             if (u.showPreferences == '1' && u.preferences.isNotEmpty)
// // // // // //               Wrap(
// // // // // //                 spacing: 6,
// // // // // //                 runSpacing: 6,
// // // // // //                 alignment: WrapAlignment.center,
// // // // // //                 children: u.preferences.take(3).map((p) {
// // // // // //                   return Container(
// // // // // //                     padding: const EdgeInsets.symmetric(
// // // // // //                         horizontal: 8, vertical: 4),
// // // // // //                     decoration: BoxDecoration(
// // // // // //                       color: _accent.withAlpha(40),
// // // // // //                       borderRadius: BorderRadius.circular(12),
// // // // // //                     ),
// // // // // //                     child: Text(p,
// // // // // //                         style:
// // // // // //                             const TextStyle(color: _accent, fontSize: 10)),
// // // // // //                   );
// // // // // //                 }).toList(),
// // // // // //               ),
// // // // // //             const SizedBox(height: 16),
// // // // // //             SizedBox(
// // // // // //               width: double.infinity,
// // // // // //               child: ElevatedButton(
// // // // // //                 onPressed: widget.onViewMore,
// // // // // //                 style: ElevatedButton.styleFrom(
// // // // // //                   backgroundColor: _accent,
// // // // // //                   foregroundColor: Colors.white,
// // // // // //                   shape: RoundedRectangleBorder(
// // // // // //                       borderRadius: BorderRadius.circular(14)),
// // // // // //                   padding: const EdgeInsets.symmetric(vertical: 10),
// // // // // //                 ),
// // // // // //                 child: const Text('View More',
// // // // // //                     style: TextStyle(fontWeight: FontWeight.bold)),
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(height: 8),
// // // // // //             GestureDetector(
// // // // // //               onTap: widget.onCalendar,
// // // // // //               child: Container(
// // // // // //                 padding: const EdgeInsets.symmetric(vertical: 8),
// // // // // //                 decoration: BoxDecoration(
// // // // // //                   border: Border.all(color: _gold.withAlpha(80)),
// // // // // //                   borderRadius: BorderRadius.circular(14),
// // // // // //                 ),
// // // // // //                 child: const Row(
// // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // //                   children: [
// // // // // //                     Icon(Icons.calendar_today, color: _gold, size: 16),
// // // // // //                     SizedBox(width: 6),
// // // // // //                     Text('View Calendar',
// // // // // //                         style: TextStyle(color: _gold, fontSize: 13)),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _backChip(String text) {
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white.withAlpha(15),
// // // // // //         borderRadius: BorderRadius.circular(10),
// // // // // //       ),
// // // // // //       child: Text(text,
// // // // // //           style: const TextStyle(color: Colors.white, fontSize: 11)),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _networkImg(String url) {
// // // // // //     if (url.isEmpty) {
// // // // // //       return Container(
// // // // // //         color: _surface,
// // // // // //         child: const Center(
// // // // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // // // //       );
// // // // // //     }
// // // // // //     String full = url;
// // // // // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // // // // //     return Image.network(
// // // // // //       full,
// // // // // //       fit: BoxFit.cover,
// // // // // //       errorBuilder: (_, __, ___) => Container(
// // // // // //         color: _surface,
// // // // // //         child: const Center(
// // // // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // // // //       ),
// // // // // //       loadingBuilder: (_, child, progress) {
// // // // // //         if (progress == null) return child;
// // // // // //         return Container(
// // // // // //           color: _surface,
// // // // // //           child: const Center(
// // // // // //             child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
// // // // // //           ),
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // ╔═══════════════════════════════════════════════════════════════════╗
// // // // // // ║  Celebrity Panel – Pay-Per-Click (Chocolate Factory)            ║
// // // // // // ║  Single self-contained file — paste into your existing project  ║
// // // // // // ║  API: https://app.beatflirtevent.com/App                        ║
// // // // // // ║  Auth: Access-Token + Access-Sign headers (from sessionStorage) ║
// // // // // // ╚═══════════════════════════════════════════════════════════════════╝

// // // // // import 'dart:convert';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:http/http.dart' as http;

// // // // // // ── Uncomment these for your existing project navigation ─────────
// // // // // // import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// // // // // // import 'package:beatflirt/providers/user_list_provider.dart';

// // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // 1)  A P I   C O N S T A N T S
// // // // // // ════════════════════════════════════════════════════════════════════

// // // // // const String kApiBase = 'https://app.beatflirtevent.com/App';
// // // // // const String kAssetBase = 'https://app.beatflirtevent.com/assets/';

// // // // // const List<String> kPreferenceOptions = [
// // // // //   'Orgy',
// // // // //   'Gang Bang',
// // // // //   'Couple',
// // // // //   'BDSM',
// // // // //   'Dom',
// // // // //   'Sub',
// // // // //   'Cuckolder',
// // // // //   'Bull Stag',
// // // // // ];

// // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // 2)  D A T A   M O D E L S
// // // // // // ════════════════════════════════════════════════════════════════════

// // // // // class ChocolateFactoryUser {
// // // // //   final String id;
// // // // //   final String username;
// // // // //   final String age;
// // // // //   final String showAge;
// // // // //   final String stateOfResidence;
// // // // //   final String heightFeet;
// // // // //   final String heightInch;
// // // // //   final String showHeight;
// // // // //   final String weight;
// // // // //   final String showWeight;
// // // // //   final List<String> preferences;
// // // // //   final String showPreferences;
// // // // //   final String selfDescription;
// // // // //   final List<ChocolateFactoryImage> images;

// // // // //   const ChocolateFactoryUser({
// // // // //     required this.id,
// // // // //     required this.username,
// // // // //     required this.age,
// // // // //     required this.showAge,
// // // // //     required this.stateOfResidence,
// // // // //     required this.heightFeet,
// // // // //     required this.heightInch,
// // // // //     required this.showHeight,
// // // // //     required this.weight,
// // // // //     required this.showWeight,
// // // // //     required this.preferences,
// // // // //     required this.showPreferences,
// // // // //     required this.selfDescription,
// // // // //     required this.images,
// // // // //   });

// // // // //   String get profileImage =>
// // // // //       images.isNotEmpty ? images.first.profileImage : '';

// // // // //   String get displayHeight => "${heightFeet}' ${heightInch}\"";

// // // // //   factory ChocolateFactoryUser.fromJson(Map<String, dynamic> j) {
// // // // //     return ChocolateFactoryUser(
// // // // //       id: '${j['id'] ?? ''}',
// // // // //       username: '${j['username'] ?? ''}',
// // // // //       age: '${j['age'] ?? ''}',
// // // // //       showAge: '${j['show_age'] ?? '0'}',
// // // // //       stateOfResidence: '${j['state_of_residence'] ?? ''}',
// // // // //       heightFeet: '${j['height_feet'] ?? ''}',
// // // // //       heightInch: '${j['height_inch'] ?? ''}',
// // // // //       showHeight: '${j['show_height'] ?? '0'}',
// // // // //       weight: '${j['weight'] ?? ''}',
// // // // //       showWeight: '${j['show_weight'] ?? '0'}',
// // // // //       preferences:
// // // // //           (j['preferences'] as List<dynamic>?)
// // // // //               ?.map((e) => '$e')
// // // // //               .toList() ?? [],
// // // // //       showPreferences: '${j['show_preferences'] ?? '0'}',
// // // // //       selfDescription: '${j['self_description'] ?? ''}',
// // // // //       images:
// // // // //           (j['image'] as List<dynamic>?)
// // // // //               ?.map((e) => ChocolateFactoryImage.fromJson(e))
// // // // //               .toList() ?? [],
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class ChocolateFactoryImage {
// // // // //   final String profileImage;
// // // // //   const ChocolateFactoryImage({required this.profileImage});
// // // // //   factory ChocolateFactoryImage.fromJson(Map<String, dynamic> j) =>
// // // // //       ChocolateFactoryImage(profileImage: '${j['profile_image'] ?? ''}');
// // // // // }

// // // // // class CalendarSlot {
// // // // //   final String username;
// // // // //   final String calenderDate;
// // // // //   final String startTime12Format;
// // // // //   final String endTime12Format;
// // // // //   const CalendarSlot({
// // // // //     required this.username,
// // // // //     required this.calenderDate,
// // // // //     required this.startTime12Format,
// // // // //     required this.endTime12Format,
// // // // //   });
// // // // //   factory CalendarSlot.fromJson(Map<String, dynamic> j) => CalendarSlot(
// // // // //         username: '${j['username'] ?? ''}',
// // // // //         calenderDate: '${j['calender_date'] ?? ''}',
// // // // //         startTime12Format: '${j['start_time_12_formate'] ?? ''}',
// // // // //         endTime12Format: '${j['end_time_12_formate'] ?? ''}',
// // // // //       );
// // // // // }

// // // // // class TermsCondition {
// // // // //   final String description;
// // // // //   const TermsCondition({required this.description});
// // // // //   factory TermsCondition.fromJson(Map<String, dynamic> j) =>
// // // // //       TermsCondition(description: '${j['description'] ?? ''}');
// // // // // }

// // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // 3)  S T A T E
// // // // // // ════════════════════════════════════════════════════════════════════

// // // // // class PanelState {
// // // // //   final bool isLoading;
// // // // //   final String? error;
// // // // //   final ChocolateFactoryUser? myProfile;
// // // // //   final List<ChocolateFactoryUser> allUsers;
// // // // //   final String searchQuery;
// // // // //   final int ageMin;
// // // // //   final int ageMax;
// // // // //   final int heightMin;
// // // // //   final int heightMax;
// // // // //   final int weightMin;
// // // // //   final int weightMax;
// // // // //   final List<String> selectedPreferences;

// // // // //   const PanelState({
// // // // //     this.isLoading = false,
// // // // //     this.error,
// // // // //     this.myProfile,
// // // // //     this.allUsers = const [],
// // // // //     this.searchQuery = '',
// // // // //     this.ageMin = 18,
// // // // //     this.ageMax = 80,
// // // // //     this.heightMin = 3,
// // // // //     this.heightMax = 8,
// // // // //     this.weightMin = 20,
// // // // //     this.weightMax = 150,
// // // // //     this.selectedPreferences = const [],
// // // // //   });

// // // // //   PanelState copyWith({
// // // // //     bool? isLoading,
// // // // //     String? error,
// // // // //     ChocolateFactoryUser? myProfile,
// // // // //     List<ChocolateFactoryUser>? allUsers,
// // // // //     String? searchQuery,
// // // // //     int? ageMin,
// // // // //     int? ageMax,
// // // // //     int? heightMin,
// // // // //     int? heightMax,
// // // // //     int? weightMin,
// // // // //     int? weightMax,
// // // // //     List<String>? selectedPreferences,
// // // // //   }) {
// // // // //     return PanelState(
// // // // //       isLoading: isLoading ?? this.isLoading,
// // // // //       error: error,
// // // // //       myProfile: myProfile ?? this.myProfile,
// // // // //       allUsers: allUsers ?? this.allUsers,
// // // // //       searchQuery: searchQuery ?? this.searchQuery,
// // // // //       ageMin: ageMin ?? this.ageMin,
// // // // //       ageMax: ageMax ?? this.ageMax,
// // // // //       heightMin: heightMin ?? this.heightMin,
// // // // //       heightMax: heightMax ?? this.heightMax,
// // // // //       weightMin: weightMin ?? this.weightMin,
// // // // //       weightMax: weightMax ?? this.weightMax,
// // // // //       selectedPreferences: selectedPreferences ?? this.selectedPreferences,
// // // // //     );
// // // // //   }

// // // // //   List<ChocolateFactoryUser> get filteredUsers {
// // // // //     var list = allUsers;
// // // // //     if (searchQuery.isNotEmpty) {
// // // // //       list = list
// // // // //           .where((u) =>
// // // // //               u.username.toLowerCase().contains(searchQuery.toLowerCase()))
// // // // //           .toList();
// // // // //     }
// // // // //     return list;
// // // // //   }
// // // // // }

// // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // 4)  N O T I F I E R   (API calls + state)
// // // // // // ════════════════════════════════════════════════════════════════════

// // // // // class PanelNotifier extends StateNotifier<PanelState> {
// // // // //   String? _accessToken;
// // // // //   String? _accessSign;

// // // // //   PanelNotifier() : super(const PanelState()) {
// // // // //     _loadToken();
// // // // //   }

// // // // //   // ── Load auth credentials ─────────────────────────────────────
// // // // //   //
// // // // //   // The web app stores them in sessionStorage / localStorage as:
// // // // //   //   "Access-Token"  →  sent as header  Access-Token
// // // // //   //   "Access-Sign"   →  sent as header  Access-Sign
// // // // //   //
// // // // //   // The Flutter app likely stores them in SharedPreferences with the
// // // // //   // same keys, or lower-case variants.  We try both.

// // // // //   Future<void> _loadToken() async {
// // // // //     final prefs = await SharedPreferences.getInstance();

// // // // //     // Try every possible key variant
// // // // //     _accessToken = prefs.getString('Access-Token') //
// // // // //         ?? prefs.getString('access_token')
// // // // //         ?? prefs.getString('accessToken')
// // // // //         ?? prefs.getString('token')
// // // // //         ?? prefs.getString('auth_token');
// // // // //     _accessSign = prefs.getString('Access-Sign') //
// // // // //         ?? prefs.getString('access_sign')
// // // // //         ?? prefs.getString('accessSign')
// // // // //         ?? prefs.getString('sign');

// // // // //     debugPrint('═══ CelebrityPanel ═══');
// // // // //     debugPrint('  Access-Token : ${_accessToken != null ? "${_accessToken!.substring(0, _accessToken!.length > 20 ? 20 : _accessToken!.length)}..." : "NULL"}');
// // // // //     debugPrint('  Access-Sign  : ${_accessSign != null ? "${_accessSign!.substring(0, _accessSign!.length > 20 ? 20 : _accessSign!.length)}..." : "NULL"}');
// // // // //     debugPrint('═══════════════════════');

// // // // //     fetchPanel();
// // // // //   }

// // // // //   // ── HTTP helpers ──────────────────────────────────────────────
// // // // //   //
// // // // //   //  The web's callapi.setHeaders() builds:
// // // // //   //    { "Content-Type":"application/json; charset=UTF-8",
// // // // //   //      "Access-Token":"<token>",  "Access-Sign":"<sign>" }
// // // // //   //
// // // // //   //  NOT  Authorization: Bearer ...  ← this was the bug!

// // // // //   Map<String, String> get _headers => {
// // // // //         'Content-Type': 'application/json; charset=UTF-8',
// // // // //         if (_accessToken != null && _accessToken!.isNotEmpty)
// // // // //           'Access-Token': _accessToken!,
// // // // //         if (_accessSign != null && _accessSign!.isNotEmpty)
// // // // //           'Access-Sign': _accessSign!,
// // // // //       };

// // // // //   Future<Map<String, dynamic>?> _post(
// // // // //       String path, Map<String, dynamic> body) async {
// // // // //     try {
// // // // //       final uri = Uri.parse('$kApiBase$path');
// // // // //       debugPrint('POST $uri  headers=$_headers');
// // // // //       final r = await http.post(uri, headers: _headers, body: jsonEncode(body));
// // // // //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// // // // //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// // // // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // // // //       }
// // // // //       return null;
// // // // //     } catch (e) {
// // // // //       debugPrint('  → ERROR $e');
// // // // //       return null;
// // // // //     }
// // // // //   }

// // // // //   Future<Map<String, dynamic>?> _get(String path) async {
// // // // //     try {
// // // // //       final uri = Uri.parse('$kApiBase$path');
// // // // //       debugPrint('GET $uri  headers=$_headers');
// // // // //       final r = await http.get(uri, headers: _headers);
// // // // //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// // // // //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// // // // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // // // //       }
// // // // //       return null;
// // // // //     } catch (e) {
// // // // //       debugPrint('  → ERROR $e');
// // // // //       return null;
// // // // //     }
// // // // //   }

// // // // //   // ── Helper: check status as int or string ─────────────────────
// // // // //   //  Web API sometimes returns {"status":200} (int)
// // // // //   //  and sometimes {"status":"404"} (string).
// // // // //   //  JavaScript == coerces both, but Dart's == does NOT.

// // // // //   bool _isOk(Map<String, dynamic>? r) {
// // // // //     if (r == null) return false;
// // // // //     final s = r['status'];
// // // // //     return s != null && s.toString() == '200';
// // // // //   }

// // // // //   // ── Main data fetch ───────────────────────────────────────────

// // // // //   Future<void> fetchPanel() async {
// // // // //     state = state.copyWith(isLoading: true, error: null);
// // // // //     try {
// // // // //       final results = await Future.wait([
// // // // //         _post('/payperclick/get_chocolate_factory_data', {'user_type': 'me'}),
// // // // //         _post('/payperclick/get_all_chocolate_factory_data', {
// // // // //           'age_minvalue': state.ageMin,
// // // // //           'age_maxvalue': state.ageMax,
// // // // //           'height_minvalue': state.heightMin,
// // // // //           'height_maxvalue': state.heightMax,
// // // // //           'weight_minvalue': state.weightMin,
// // // // //           'weight_maxvalue': state.weightMax,
// // // // //           'preferencesArray': state.selectedPreferences,
// // // // //         }),
// // // // //       ]);

// // // // //       ChocolateFactoryUser? myProfile;
// // // // //       final me = results[0];
// // // // //       if (_isOk(me)) {
// // // // //         final d = me!['data'];
// // // // //         if (d is List && d.isNotEmpty) {
// // // // //           myProfile = ChocolateFactoryUser.fromJson(d[0]);
// // // // //         }
// // // // //       }

// // // // //       List<ChocolateFactoryUser> allUsers = [];
// // // // //       final all = results[1];
// // // // //       if (_isOk(all)) {
// // // // //         final d = all!['data'];
// // // // //         if (d is List) {
// // // // //           allUsers = d.map((e) => ChocolateFactoryUser.fromJson(e)).toList();
// // // // //         }
// // // // //       }

// // // // //       debugPrint('  myProfile: ${myProfile?.username ?? "null"}');
// // // // //       debugPrint('  allUsers count: ${allUsers.length}');

// // // // //       state = state.copyWith(
// // // // //         isLoading: false,
// // // // //         myProfile: myProfile,
// // // // //         allUsers: allUsers,
// // // // //       );
// // // // //     } catch (e) {
// // // // //       debugPrint('  fetchPanel ERROR: $e');
// // // // //       state = state.copyWith(isLoading: false, error: e.toString());
// // // // //     }
// // // // //   }

// // // // //   // ── Filters ───────────────────────────────────────────────────

// // // // //   Future<void> applyFilters() => fetchPanel();

// // // // //   void updateAge(RangeValues v) =>
// // // // //       state = state.copyWith(ageMin: v.start.round(), ageMax: v.end.round());
// // // // //   void updateHeight(RangeValues v) => state = state.copyWith(
// // // // //       heightMin: v.start.round(), heightMax: v.end.round());
// // // // //   void updateWeight(RangeValues v) => state = state.copyWith(
// // // // //       weightMin: v.start.round(), weightMax: v.end.round());

// // // // //   void togglePreference(String pref) {
// // // // //     final list = [...state.selectedPreferences];
// // // // //     if (list.contains(pref)) {
// // // // //       list.remove(pref);
// // // // //     } else {
// // // // //       list.add(pref);
// // // // //     }
// // // // //     state = state.copyWith(selectedPreferences: list);
// // // // //   }

// // // // //   void setSearch(String q) => state = state.copyWith(searchQuery: q);

// // // // //   // ── Calendar ──────────────────────────────────────────────────

// // // // //   Future<List<CalendarSlot>> fetchCalendar(String payPerId) async {
// // // // //     final r = await _post('/payperclick/get_user_calender_details', {
// // // // //       'pay_per_id': payPerId,
// // // // //     });
// // // // //     if (_isOk(r)) {
// // // // //       final d = r!['data'];
// // // // //       if (d is List) return d.map((e) => CalendarSlot.fromJson(e)).toList();
// // // // //     }
// // // // //     return [];
// // // // //   }

// // // // //   // ── Terms ─────────────────────────────────────────────────────

// // // // //   Future<TermsCondition?> fetchTerms() async {
// // // // //     final r = await _get('/auth/pay_per_click_terms_condition');
// // // // //     if (_isOk(r)) {
// // // // //       final d = r!['data'];
// // // // //       if (d is List && d.isNotEmpty) return TermsCondition.fromJson(d[0]);
// // // // //     }
// // // // //     return null;
// // // // //   }

// // // // //   // ── Check flags ───────────────────────────────────────────────

// // // // //   Future<bool> checkPost() async {
// // // // //     final r = await _get('/payperclick/check_chocolate_factory_post');
// // // // //     return _isOk(r);
// // // // //   }

// // // // //   Future<bool> checkPopup() async {
// // // // //     final r = await _get('/payperclick/check_chocolate_factory_popup');
// // // // //     return _isOk(r);
// // // // //   }
// // // // // }

// // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // 5)  P R O V I D E R
// // // // // // ════════════════════════════════════════════════════════════════════

// // // // // final panelProvider =
// // // // //     StateNotifierProvider.autoDispose<PanelNotifier, PanelState>(
// // // // //   (ref) => PanelNotifier(),
// // // // // );

// // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // 6)  M A I N   P A G E   W I D G E T
// // // // // // ════════════════════════════════════════════════════════════════════

// // // // // class CelebrityPanelPage extends ConsumerStatefulWidget {
// // // // //   const CelebrityPanelPage({super.key});

// // // // //   @override
// // // // //   ConsumerState<CelebrityPanelPage> createState() => _CelebrityPanelPageState();
// // // // // }

// // // // // class _CelebrityPanelPageState extends ConsumerState<CelebrityPanelPage>
// // // // //     with TickerProviderStateMixin {
// // // // //   final TextEditingController _searchCtrl = TextEditingController();
// // // // //   bool _filterExpanded = false;

// // // // //   // ── Colour palette ────────────────────────────────────────────
// // // // //   static const _bg = Color(0xFF0B0B1A);
// // // // //   static const _card = Color(0xFF13132B);
// // // // //   static const _accent = Color(0xFFE91E63);
// // // // //   static const _gold = Color(0xFFF4BA4A);
// // // // //   static const _surface = Color(0xFF1C1C3A);

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _searchCtrl.dispose();
// // // // //     super.dispose();
// // // // //   }

// // // // //   // ════════════════════════════════════════════════════════════════
// // // // //   // BUILD
// // // // //   // ════════════════════════════════════════════════════════════════

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final s = ref.watch(panelProvider);

// // // // //     return Scaffold(
// // // // //       backgroundColor: _bg,
// // // // //       body: CustomScrollView(
// // // // //         physics: const BouncingScrollPhysics(),
// // // // //         slivers: [
// // // // //           // ── App Bar (no notification icon) ────────────────────
// // // // //           SliverAppBar(
// // // // //             leading: IconButton(
// // // // //               icon: const Icon(Icons.arrow_back_ios_new,
// // // // //                   color: Colors.white, size: 20),
// // // // //               onPressed: () => Navigator.pop(context),
// // // // //             ),
// // // // //             expandedHeight: 130,
// // // // //             floating: false,
// // // // //             pinned: true,
// // // // //             backgroundColor: _bg,
// // // // //             elevation: 0,
// // // // //             flexibleSpace: LayoutBuilder(
// // // // //               builder: (context, constraints) {
// // // // //                 final top = MediaQuery.of(context).padding.top;
// // // // //                 final collapsed = kToolbarHeight + top;
// // // // //                 final isCollapsed = constraints.maxHeight <= collapsed + 10;
// // // // //                 return FlexibleSpaceBar(
// // // // //                   centerTitle: false,
// // // // //                   titlePadding: EdgeInsets.only(
// // // // //                     left: isCollapsed ? 50 : 20,
// // // // //                     bottom: 14,
// // // // //                   ),
// // // // //                   title: const Text(
// // // // //                     'Celebrity Panel',
// // // // //                     style: TextStyle(
// // // // //                       color: Colors.white,
// // // // //                       fontWeight: FontWeight.bold,
// // // // //                       fontSize: 20,
// // // // //                     ),
// // // // //                   ),
// // // // //                   background: Container(
// // // // //                     decoration: const BoxDecoration(
// // // // //                       gradient: LinearGradient(
// // // // //                         begin: Alignment.topCenter,
// // // // //                         end: Alignment.bottomCenter,
// // // // //                         colors: [_accent, _bg],
// // // // //                         stops: [0.0, 0.8],
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 );
// // // // //               },
// // // // //             ),
// // // // //           ),

// // // // //           // ── Loading ───────────────────────────────────────────
// // // // //           if (s.isLoading)
// // // // //             const SliverFillRemaining(
// // // // //               child: Center(child: CircularProgressIndicator(color: _accent)),
// // // // //             )

// // // // //           // ── Error ─────────────────────────────────────────────
// // // // //           else if (s.error != null && s.allUsers.isEmpty)
// // // // //             SliverFillRemaining(
// // // // //               child: Center(
// // // // //                 child: Column(
// // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // //                   children: [
// // // // //                     const Icon(Icons.error_outline,
// // // // //                         color: Colors.white24, size: 48),
// // // // //                     const SizedBox(height: 16),
// // // // //                     Text('Failed to load celebrities',
// // // // //                         style: TextStyle(color: Colors.white.withAlpha(153))),
// // // // //                     const SizedBox(height: 8),
// // // // //                     Text(s.error ?? '',
// // // // //                         style: TextStyle(color: Colors.white38, fontSize: 12),
// // // // //                         textAlign: TextAlign.center),
// // // // //                     const SizedBox(height: 12),
// // // // //                     TextButton(
// // // // //                       onPressed: () =>
// // // // //                           ref.read(panelProvider.notifier).fetchPanel(),
// // // // //                       child: const Text('Retry',
// // // // //                           style: TextStyle(color: _accent)),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             )

// // // // //           // ── Content ───────────────────────────────────────────
// // // // //           else ...[
// // // // //             if (s.myProfile != null) _buildMyProfileCard(s.myProfile!),
// // // // //             _buildSearchBar(),
// // // // //             _buildFilterPanel(s),
// // // // //             _buildUsersGrid(s),
// // // // //             const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
// // // // //           ],
// // // // //         ],
// // // // //       ),
// // // // //       // ── NO FAB (removed) ──────────────────────────────────────
// // // // //     );
// // // // //   }

// // // // //   // ════════════════════════════════════════════════════════════════
// // // // //   // MY PROFILE CARD
// // // // //   // ════════════════════════════════════════════════════════════════

// // // // //   Widget _buildMyProfileCard(ChocolateFactoryUser u) {
// // // // //     return SliverToBoxAdapter(
// // // // //       child: Container(
// // // // //         margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
// // // // //         decoration: BoxDecoration(
// // // // //           color: _card,
// // // // //           borderRadius: BorderRadius.circular(24),
// // // // //           border: Border.all(color: Colors.white.withAlpha(25)),
// // // // //           boxShadow: [
// // // // //             BoxShadow(
// // // // //               color: _accent.withAlpha(40),
// // // // //               blurRadius: 30,
// // // // //               offset: const Offset(0, 10),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //         child: Column(
// // // // //           children: [
// // // // //             // ── Image ─────────────────────────────────────────
// // // // //             SizedBox(
// // // // //               height: 220,
// // // // //               child: Stack(
// // // // //                 children: [
// // // // //                   ClipRRect(
// // // // //                     borderRadius: const BorderRadius.vertical(
// // // // //                         top: Radius.circular(24)),
// // // // //                     child: SizedBox(
// // // // //                       width: double.infinity,
// // // // //                       child: _networkImage(u.profileImage, fit: BoxFit.cover),
// // // // //                     ),
// // // // //                   ),
// // // // //                   // Badge
// // // // //                   Positioned(
// // // // //                     top: 12,
// // // // //                     left: 12,
// // // // //                     child: Container(
// // // // //                       padding: const EdgeInsets.all(8),
// // // // //                       decoration: BoxDecoration(
// // // // //                         color: _accent.withAlpha(200),
// // // // //                         borderRadius: BorderRadius.circular(12),
// // // // //                       ),
// // // // //                       child: Image.network(
// // // // //                         '${kAssetBase}img/badge1.png',
// // // // //                         width: 40,
// // // // //                         height: 40,
// // // // //                         errorBuilder: (_, __, ___) =>
// // // // //                             const Icon(Icons.verified, color: Colors.white),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                   // Edit button
// // // // //                   Positioned(
// // // // //                     top: 12,
// // // // //                     right: 12,
// // // // //                     child: GestureDetector(
// // // // //                       onTap: () {},
// // // // //                       child: Container(
// // // // //                         padding: const EdgeInsets.symmetric(
// // // // //                             horizontal: 14, vertical: 8),
// // // // //                         decoration: BoxDecoration(
// // // // //                           color: Colors.black.withAlpha(150),
// // // // //                           borderRadius: BorderRadius.circular(20),
// // // // //                           border: Border.all(
// // // // //                               color: Colors.white.withAlpha(60)),
// // // // //                         ),
// // // // //                         child: const Row(
// // // // //                           mainAxisSize: MainAxisSize.min,
// // // // //                           children: [
// // // // //                             Icon(Icons.edit, color: Colors.white, size: 14),
// // // // //                             SizedBox(width: 4),
// // // // //                             Text('Edit Profile',
// // // // //                                 style: TextStyle(
// // // // //                                     color: Colors.white,
// // // // //                                     fontSize: 12,
// // // // //                                     fontWeight: FontWeight.w600)),
// // // // //                           ],
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                   // Gradient
// // // // //                   Positioned.fill(
// // // // //                     child: Container(
// // // // //                       decoration: BoxDecoration(
// // // // //                         borderRadius: const BorderRadius.vertical(
// // // // //                             top: Radius.circular(24)),
// // // // //                         gradient: LinearGradient(
// // // // //                           begin: Alignment.topCenter,
// // // // //                           end: Alignment.bottomCenter,
// // // // //                           colors: [
// // // // //                             Colors.transparent,
// // // // //                             Colors.black.withAlpha(180),
// // // // //                           ],
// // // // //                           stops: const [0.5, 1.0],
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                   // Name + age
// // // // //                   Positioned(
// // // // //                     left: 16,
// // // // //                     bottom: 16,
// // // // //                     child: Row(
// // // // //                       children: [
// // // // //                         Text(u.username,
// // // // //                             style: const TextStyle(
// // // // //                                 color: Colors.white,
// // // // //                                 fontSize: 22,
// // // // //                                 fontWeight: FontWeight.bold)),
// // // // //                         if (u.showAge == '1') ...[
// // // // //                           const SizedBox(width: 8),
// // // // //                           Text('Age ${u.age}',
// // // // //                               style: TextStyle(
// // // // //                                   color: Colors.white.withAlpha(200),
// // // // //                                   fontSize: 14)),
// // // // //                         ],
// // // // //                       ],
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),

// // // // //             // ── Info ───────────────────────────────────────────
// // // // //             Padding(
// // // // //               padding: const EdgeInsets.all(20),
// // // // //               child: Column(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                 children: [
// // // // //                   // Location
// // // // //                   Row(
// // // // //                     children: [
// // // // //                       const Icon(Icons.location_on, color: _accent, size: 16),
// // // // //                       const SizedBox(width: 6),
// // // // //                       Text(u.stateOfResidence,
// // // // //                           style: TextStyle(
// // // // //                               color: Colors.white.withAlpha(180),
// // // // //                               fontSize: 14)),
// // // // //                     ],
// // // // //                   ),
// // // // //                   const SizedBox(height: 14),

// // // // //                   // Stats
// // // // //                   Row(
// // // // //                     children: [
// // // // //                       if (u.showHeight == '1')
// // // // //                         _statChip(Icons.height, u.displayHeight),
// // // // //                       if (u.showHeight == '1') const SizedBox(width: 12),
// // // // //                       if (u.showWeight == '1')
// // // // //                         _statChip(
// // // // //                             Icons.monitor_weight_outlined, '${u.weight} Kg'),
// // // // //                     ],
// // // // //                   ),
// // // // //                   const SizedBox(height: 14),

// // // // //                   // Preferences
// // // // //                   if (u.showPreferences == '1' &&
// // // // //                       u.preferences.isNotEmpty) ...[
// // // // //                     const Text('Preferences',
// // // // //                         style: TextStyle(
// // // // //                             color: Colors.white,
// // // // //                             fontSize: 14,
// // // // //                             fontWeight: FontWeight.w600)),
// // // // //                     const SizedBox(height: 8),
// // // // //                     Wrap(
// // // // //                       spacing: 8,
// // // // //                       runSpacing: 8,
// // // // //                       children: u.preferences
// // // // //                           .map((p) => Container(
// // // // //                                 padding: const EdgeInsets.symmetric(
// // // // //                                     horizontal: 12, vertical: 6),
// // // // //                                 decoration: BoxDecoration(
// // // // //                                   color: _accent.withAlpha(30),
// // // // //                                   borderRadius: BorderRadius.circular(20),
// // // // //                                   border: Border.all(
// // // // //                                       color: _accent.withAlpha(80)),
// // // // //                                 ),
// // // // //                                 child: Text(p,
// // // // //                                     style: const TextStyle(
// // // // //                                         color: _accent, fontSize: 12)),
// // // // //                               ))
// // // // //                           .toList(),
// // // // //                     ),
// // // // //                     const SizedBox(height: 14),
// // // // //                   ],

// // // // //                   // Calendar + Review
// // // // //                   Row(
// // // // //                     children: [
// // // // //                       Expanded(
// // // // //                         child: GestureDetector(
// // // // //                           onTap: () =>
// // // // //                               _showCalendarDialog(u.id, u.username),
// // // // //                           child: Container(
// // // // //                             padding: const EdgeInsets.symmetric(vertical: 12),
// // // // //                             decoration: BoxDecoration(
// // // // //                               color: _surface,
// // // // //                               borderRadius: BorderRadius.circular(14),
// // // // //                               border: Border.all(
// // // // //                                   color: Colors.white.withAlpha(20)),
// // // // //                             ),
// // // // //                             child: const Row(
// // // // //                               mainAxisAlignment: MainAxisAlignment.center,
// // // // //                               children: [
// // // // //                                 Icon(Icons.calendar_month,
// // // // //                                     color: _gold, size: 18),
// // // // //                                 SizedBox(width: 8),
// // // // //                                 Text('Calendar',
// // // // //                                     style: TextStyle(
// // // // //                                         color: Colors.white,
// // // // //                                         fontSize: 13,
// // // // //                                         fontWeight: FontWeight.w600)),
// // // // //                                 SizedBox(width: 4),
// // // // //                                 Text('View booked slots',
// // // // //                                     style: TextStyle(
// // // // //                                         color: Colors.white54, fontSize: 11)),
// // // // //                               ],
// // // // //                             ),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(width: 10),
// // // // //                       GestureDetector(
// // // // //                         onTap: () {},
// // // // //                         child: Container(
// // // // //                           padding: const EdgeInsets.symmetric(
// // // // //                               horizontal: 16, vertical: 12),
// // // // //                           decoration: BoxDecoration(
// // // // //                             color: _accent.withAlpha(20),
// // // // //                             borderRadius: BorderRadius.circular(14),
// // // // //                             border:
// // // // //                                 Border.all(color: _accent.withAlpha(60)),
// // // // //                           ),
// // // // //                           child: const Row(
// // // // //                             children: [
// // // // //                               Icon(Icons.rate_review,
// // // // //                                   color: _accent, size: 16),
// // // // //                               SizedBox(width: 6),
// // // // //                               Text('Write Review',
// // // // //                                   style: TextStyle(
// // // // //                                       color: _accent, fontSize: 13)),
// // // // //                             ],
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                   const SizedBox(height: 14),

// // // // //                   // Description
// // // // //                   if (u.selfDescription.isNotEmpty) ...[
// // // // //                     Text('Description',
// // // // //                         style: TextStyle(
// // // // //                             color: Colors.white.withAlpha(150),
// // // // //                             fontSize: 12,
// // // // //                             fontWeight: FontWeight.w600)),
// // // // //                     const SizedBox(height: 6),
// // // // //                     Text(u.selfDescription,
// // // // //                         style: TextStyle(
// // // // //                             color: Colors.white.withAlpha(120),
// // // // //                             fontSize: 13,
// // // // //                             height: 1.5),
// // // // //                         maxLines: 4,
// // // // //                         overflow: TextOverflow.ellipsis),
// // // // //                   ],
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _statChip(IconData icon, String label) {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // // // //       decoration: BoxDecoration(
// // // // //         color: _surface,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         border: Border.all(color: Colors.white.withAlpha(20)),
// // // // //       ),
// // // // //       child: Row(
// // // // //         mainAxisSize: MainAxisSize.min,
// // // // //         children: [
// // // // //           Icon(icon, color: _gold, size: 16),
// // // // //           const SizedBox(width: 6),
// // // // //           Text(label,
// // // // //               style: const TextStyle(color: Colors.white, fontSize: 13)),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // ════════════════════════════════════════════════════════════════
// // // // //   // SEARCH BAR
// // // // //   // ════════════════════════════════════════════════════════════════

// // // // //   Widget _buildSearchBar() {
// // // // //     return SliverToBoxAdapter(
// // // // //       child: Padding(
// // // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // // //         child: Row(
// // // // //           children: [
// // // // //             Expanded(
// // // // //               child: Container(
// // // // //                 height: 50,
// // // // //                 decoration: BoxDecoration(
// // // // //                   color: Colors.white.withAlpha(15),
// // // // //                   borderRadius: BorderRadius.circular(15),
// // // // //                 ),
// // // // //                 child: TextField(
// // // // //                   controller: _searchCtrl,
// // // // //                   style: const TextStyle(color: Colors.white),
// // // // //                   onChanged: (v) =>
// // // // //                       ref.read(panelProvider.notifier).setSearch(v),
// // // // //                   decoration: InputDecoration(
// // // // //                     hintText: 'Search celebrities...',
// // // // //                     hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
// // // // //                     prefixIcon: Icon(Icons.search,
// // // // //                         color: Colors.white.withAlpha(100)),
// // // // //                     border: InputBorder.none,
// // // // //                     contentPadding: const EdgeInsets.symmetric(vertical: 15),
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //             const SizedBox(width: 12),
// // // // //             GestureDetector(
// // // // //               onTap: () =>
// // // // //                   setState(() => _filterExpanded = !_filterExpanded),
// // // // //               child: AnimatedContainer(
// // // // //                 duration: const Duration(milliseconds: 300),
// // // // //                 height: 50,
// // // // //                 width: 50,
// // // // //                 decoration: BoxDecoration(
// // // // //                   color: _filterExpanded
// // // // //                       ? _accent
// // // // //                       : _accent.withAlpha(30),
// // // // //                   borderRadius: BorderRadius.circular(15),
// // // // //                   border: Border.all(
// // // // //                       color:
// // // // //                           _accent.withAlpha(_filterExpanded ? 255 : 120)),
// // // // //                 ),
// // // // //                 child: AnimatedRotation(
// // // // //                   duration: const Duration(milliseconds: 300),
// // // // //                   turns: _filterExpanded ? 0.125 : 0,
// // // // //                   child: Icon(Icons.tune,
// // // // //                       color: _filterExpanded ? Colors.white : _accent),
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // ════════════════════════════════════════════════════════════════
// // // // //   // FILTER PANEL
// // // // //   // ════════════════════════════════════════════════════════════════

// // // // //   Widget _buildFilterPanel(PanelState s) {
// // // // //     if (!_filterExpanded) return const SliverToBoxAdapter(child: SizedBox.shrink());
// // // // //     return SliverToBoxAdapter(
// // // // //       child: AnimatedOpacity(
// // // // //         duration: const Duration(milliseconds: 300),
// // // // //         opacity: _filterExpanded ? 1.0 : 0.0,
// // // // //         child: Container(
// // // // //           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// // // // //           padding: const EdgeInsets.all(20),
// // // // //           decoration: BoxDecoration(
// // // // //             color: _card,
// // // // //             borderRadius: BorderRadius.circular(20),
// // // // //             border: Border.all(color: Colors.white.withAlpha(20)),
// // // // //           ),
// // // // //           child: Column(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               children: [
// // // // //                 _rangeSlider(
// // // // //                   label: 'Age',
// // // // //                   icon: Icons.cake,
// // // // //                   min: 18,
// // // // //                   max: 100,
// // // // //                   values: RangeValues(
// // // // //                       s.ageMin.toDouble(), s.ageMax.toDouble()),
// // // // //                   onChanged: (v) =>
// // // // //                       ref.read(panelProvider.notifier).updateAge(v),
// // // // //                 ),
// // // // //                 const SizedBox(height: 18),
// // // // //                 _rangeSlider(
// // // // //                   label: 'Height (ft)',
// // // // //                   icon: Icons.height,
// // // // //                   min: 0,
// // // // //                   max: 10,
// // // // //                   values: RangeValues(
// // // // //                       s.heightMin.toDouble(), s.heightMax.toDouble()),
// // // // //                   onChanged: (v) =>
// // // // //                       ref.read(panelProvider.notifier).updateHeight(v),
// // // // //                 ),
// // // // //                 const SizedBox(height: 18),
// // // // //                 _rangeSlider(
// // // // //                   label: 'Weight (Kg)',
// // // // //                   icon: Icons.monitor_weight_outlined,
// // // // //                   min: 20,
// // // // //                   max: 200,
// // // // //                   values: RangeValues(
// // // // //                       s.weightMin.toDouble(), s.weightMax.toDouble()),
// // // // //                   onChanged: (v) =>
// // // // //                       ref.read(panelProvider.notifier).updateWeight(v),
// // // // //                 ),
// // // // //                 const SizedBox(height: 18),
// // // // //                 const Text('Preferences',
// // // // //                     style: TextStyle(
// // // // //                         color: Colors.white,
// // // // //                         fontSize: 14,
// // // // //                         fontWeight: FontWeight.w600)),
// // // // //                 const SizedBox(height: 10),
// // // // //                 Wrap(
// // // // //                   spacing: 8,
// // // // //                   runSpacing: 8,
// // // // //                   children: kPreferenceOptions.map((pref) {
// // // // //                     final selected =
// // // // //                         s.selectedPreferences.contains(pref);
// // // // //                     return GestureDetector(
// // // // //                       onTap: () => ref
// // // // //                           .read(panelProvider.notifier)
// // // // //                           .togglePreference(pref),
// // // // //                       child: AnimatedContainer(
// // // // //                         duration: const Duration(milliseconds: 200),
// // // // //                         padding: const EdgeInsets.symmetric(
// // // // //                             horizontal: 14, vertical: 8),
// // // // //                         decoration: BoxDecoration(
// // // // //                           color: selected ? _accent : _surface,
// // // // //                           borderRadius: BorderRadius.circular(20),
// // // // //                           border: Border.all(
// // // // //                             color: selected
// // // // //                                 ? _accent
// // // // //                                 : Colors.white.withAlpha(30),
// // // // //                           ),
// // // // //                         ),
// // // // //                         child: Row(
// // // // //                           mainAxisSize: MainAxisSize.min,
// // // // //                           children: [
// // // // //                             Icon(
// // // // //                               selected
// // // // //                                   ? Icons.check_circle
// // // // //                                   : Icons.circle_outlined,
// // // // //                               color: selected
// // // // //                                   ? Colors.white
// // // // //                                   : Colors.white.withAlpha(80),
// // // // //                               size: 16,
// // // // //                             ),
// // // // //                             const SizedBox(width: 6),
// // // // //                             Text(pref,
// // // // //                                 style: TextStyle(
// // // // //                                   color: selected
// // // // //                                       ? Colors.white
// // // // //                                       : Colors.white.withAlpha(120),
// // // // //                                   fontSize: 12,
// // // // //                                   fontWeight: selected
// // // // //                                       ? FontWeight.w600
// // // // //                                       : FontWeight.normal,
// // // // //                                 )),
// // // // //                           ],
// // // // //                         ),
// // // // //                       ),
// // // // //                     );
// // // // //                   }).toList(),
// // // // //                 ),
// // // // //                 const SizedBox(height: 20),
// // // // //                 SizedBox(
// // // // //                   width: double.infinity,
// // // // //                   height: 50,
// // // // //                   child: ElevatedButton.icon(
// // // // //                     onPressed: () =>
// // // // //                         ref.read(panelProvider.notifier).applyFilters(),
// // // // //                     icon: const Icon(Icons.filter_list, color: Colors.white),
// // // // //                     label: const Text('Apply Filters',
// // // // //                         style: TextStyle(
// // // // //                             color: Colors.white,
// // // // //                             fontWeight: FontWeight.bold,
// // // // //                             fontSize: 16)),
// // // // //                     style: ElevatedButton.styleFrom(
// // // // //                       backgroundColor: _accent,
// // // // //                       shape: RoundedRectangleBorder(
// // // // //                           borderRadius: BorderRadius.circular(16)),
// // // // //                       elevation: 4,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ),
      
// // // // //     );
// // // // //   }

// // // // //   Widget _rangeSlider({
// // // // //     required String label,
// // // // //     required IconData icon,
// // // // //     required double min,
// // // // //     required double max,
// // // // //     required RangeValues values,
// // // // //     required ValueChanged<RangeValues> onChanged,
// // // // //   }) {
// // // // //     return Column(
// // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //       children: [
// // // // //         Row(
// // // // //           children: [
// // // // //             Icon(icon, color: _gold, size: 16),
// // // // //             const SizedBox(width: 8),
// // // // //             Text(label,
// // // // //                 style: const TextStyle(
// // // // //                     color: Colors.white,
// // // // //                     fontSize: 14,
// // // // //                     fontWeight: FontWeight.w600)),
// // // // //             const Spacer(),
// // // // //             Text('${values.start.round()} – ${values.end.round()}',
// // // // //                 style: TextStyle(color: _accent, fontSize: 13)),
// // // // //           ],
// // // // //         ),
// // // // //         SliderTheme(
// // // // //           data: SliderThemeData(
// // // // //             activeTrackColor: _accent,
// // // // //             inactiveTrackColor: Colors.white.withAlpha(30),
// // // // //             thumbColor: _accent,
// // // // //             overlayColor: _accent.withAlpha(30),
// // // // //             rangeThumbShape:
// // // // //                 const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
// // // // //           ),
// // // // //           child: RangeSlider(
// // // // //             values: values,
// // // // //             min: min,
// // // // //             max: max,
// // // // //             onChanged: onChanged,
// // // // //           ),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   // ════════════════════════════════════════════════════════════════
// // // // //   // ALL USERS GRID  (flip-card style)
// // // // //   // ════════════════════════════════════════════════════════════════

// // // // //   Widget _buildUsersGrid(PanelState s) {
// // // // //     final users = s.filteredUsers;

// // // // //     if (users.isEmpty) {
// // // // //       return SliverToBoxAdapter(
// // // // //         child: Container(
// // // // //           margin: const EdgeInsets.all(40),
// // // // //           padding: const EdgeInsets.symmetric(vertical: 50),
// // // // //           decoration: BoxDecoration(
// // // // //             color: _card,
// // // // //             borderRadius: BorderRadius.circular(24),
// // // // //           ),
// // // // //           child: Column(
// // // // //             children: [
// // // // //               Icon(Icons.search,
// // // // //                   size: 60, color: Colors.white.withAlpha(40)),
// // // // //               const SizedBox(height: 16),
// // // // //               const Text('No Records Found',
// // // // //                   style: TextStyle(
// // // // //                       color: Colors.white,
// // // // //                       fontSize: 18,
// // // // //                       fontWeight: FontWeight.bold)),
// // // // //               const SizedBox(height: 8),
// // // // //               Text('Try adjusting your filters to find more results.',
// // // // //                   style: TextStyle(
// // // // //                       color: Colors.white.withAlpha(80), fontSize: 14)),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       );
// // // // //     }

// // // // //     return SliverPadding(
// // // // //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
// // // // //       sliver: SliverGrid(
// // // // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // //           crossAxisCount: 2,
// // // // //           mainAxisSpacing: 16,
// // // // //           crossAxisSpacing: 16,
// // // // //           childAspectRatio: 0.52,
// // // // //         ),
// // // // //         delegate: SliverChildBuilderDelegate(
// // // // //           (context, index) => _FlipCardWidget(
// // // // //             user: users[index],
// // // // //             onViewMore: () => _navigateToUserProfile(users[index]),
// // // // //             onCalendar: () => _showCalendarDialog(
// // // // //                 users[index].id, users[index].username),
// // // // //           ),
// // // // //           childCount: users.length,
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // ════════════════════════════════════════════════════════════════
// // // // //   // CALENDAR DIALOG
// // // // //   // ════════════════════════════════════════════════════════════════

// // // // //   void _showCalendarDialog(String payPerId, String username) {
// // // // //     showGeneralDialog(
// // // // //       context: context,
// // // // //       barrierDismissible: true,
// // // // //       barrierLabel: 'Calendar',
// // // // //       barrierColor: Colors.black87,
// // // // //       transitionDuration: const Duration(milliseconds: 350),
// // // // //       pageBuilder: (ctx, anim1, anim2) => Center(
// // // // //         child: Material(
// // // // //           color: Colors.transparent,
// // // // //           child: Container(
// // // // //             width: MediaQuery.of(ctx).size.width * 0.9,
// // // // //             constraints: const BoxConstraints(maxHeight: 500),
// // // // //             decoration: BoxDecoration(
// // // // //               color: _card,
// // // // //               borderRadius: BorderRadius.circular(24),
// // // // //               border: Border.all(color: Colors.white.withAlpha(20)),
// // // // //             ),
// // // // //             child: Column(
// // // // //               mainAxisSize: MainAxisSize.min,
// // // // //               children: [
// // // // //                 Container(
// // // // //                   padding: const EdgeInsets.all(20),
// // // // //                   decoration: const BoxDecoration(
// // // // //                     gradient:
// // // // //                         LinearGradient(colors: [_accent, Color(0xFF5C2438)]),
// // // // //                     borderRadius: BorderRadius.vertical(
// // // // //                         top: Radius.circular(24)),
// // // // //                   ),
// // // // //                   child: Row(
// // // // //                     children: [
// // // // //                       const Icon(Icons.calendar_month,
// // // // //                           color: Colors.white, size: 24),
// // // // //                       const SizedBox(width: 10),
// // // // //                       const Expanded(
// // // // //                         child: Text('Already Booked Slots',
// // // // //                             style: TextStyle(
// // // // //                                 color: Colors.white,
// // // // //                                 fontSize: 18,
// // // // //                                 fontWeight: FontWeight.bold)),
// // // // //                       ),
// // // // //                       IconButton(
// // // // //                         icon: const Icon(Icons.close, color: Colors.white70),
// // // // //                         onPressed: () => Navigator.pop(ctx),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.all(16),
// // // // //                   child: FutureBuilder<List<CalendarSlot>>(
// // // // //                     future: ref
// // // // //                         .read(panelProvider.notifier)
// // // // //                         .fetchCalendar(payPerId),
// // // // //                     builder: (ctx, snap) {
// // // // //                       if (snap.connectionState == ConnectionState.waiting) {
// // // // //                         return const Padding(
// // // // //                           padding: EdgeInsets.all(30),
// // // // //                           child: Center(
// // // // //                               child:
// // // // //                                   CircularProgressIndicator(color: _accent)),
// // // // //                         );
// // // // //                       }
// // // // //                       final slots = snap.data ?? [];
// // // // //                       if (slots.isEmpty) {
// // // // //                         return const Padding(
// // // // //                           padding: EdgeInsets.all(30),
// // // // //                           child: Text('No record found…..',
// // // // //                               style: TextStyle(color: Colors.white54)),
// // // // //                         );
// // // // //                       }
// // // // //                       return Column(
// // // // //                         children: slots.asMap().entries.map((entry) {
// // // // //                           final i = entry.key;
// // // // //                           final slot = entry.value;
// // // // //                           return Container(
// // // // //                             margin: const EdgeInsets.only(bottom: 10),
// // // // //                             padding: const EdgeInsets.all(14),
// // // // //                             decoration: BoxDecoration(
// // // // //                               color: _surface,
// // // // //                               borderRadius: BorderRadius.circular(14),
// // // // //                               border: Border.all(
// // // // //                                   color: Colors.white.withAlpha(15)),
// // // // //                             ),
// // // // //                             child: Row(
// // // // //                               children: [
// // // // //                                 Container(
// // // // //                                   width: 32,
// // // // //                                   height: 32,
// // // // //                                   decoration: BoxDecoration(
// // // // //                                     color: _accent.withAlpha(30),
// // // // //                                     borderRadius: BorderRadius.circular(10),
// // // // //                                   ),
// // // // //                                   child: Center(
// // // // //                                     child: Text('${i + 1}',
// // // // //                                         style: const TextStyle(
// // // // //                                             color: _accent,
// // // // //                                             fontWeight: FontWeight.bold)),
// // // // //                                   ),
// // // // //                                 ),
// // // // //                                 const SizedBox(width: 12),
// // // // //                                 Expanded(
// // // // //                                   child: Column(
// // // // //                                     crossAxisAlignment:
// // // // //                                         CrossAxisAlignment.start,
// // // // //                                     children: [
// // // // //                                       Text(slot.username,
// // // // //                                           style: const TextStyle(
// // // // //                                               color: Colors.white,
// // // // //                                               fontWeight: FontWeight.w600,
// // // // //                                               fontSize: 14)),
// // // // //                                       const SizedBox(height: 4),
// // // // //                                       Text(slot.calenderDate,
// // // // //                                           style: TextStyle(
// // // // //                                               color: _gold, fontSize: 12)),
// // // // //                                     ],
// // // // //                                   ),
// // // // //                                 ),
// // // // //                                 Column(
// // // // //                                   crossAxisAlignment: CrossAxisAlignment.end,
// // // // //                                   children: [
// // // // //                                     Row(
// // // // //                                       children: [
// // // // //                                         Icon(Icons.play_arrow,
// // // // //                                             color:
// // // // //                                                 Colors.greenAccent.shade400,
// // // // //                                             size: 14),
// // // // //                                         const SizedBox(width: 4),
// // // // //                                         Text(slot.startTime12Format,
// // // // //                                             style: const TextStyle(
// // // // //                                                 color: Colors.greenAccent,
// // // // //                                                 fontSize: 12)),
// // // // //                                       ],
// // // // //                                     ),
// // // // //                                     const SizedBox(height: 2),
// // // // //                                     Row(
// // // // //                                       children: [
// // // // //                                         Icon(Icons.stop,
// // // // //                                             color: Colors.redAccent.shade200,
// // // // //                                             size: 14),
// // // // //                                         const SizedBox(width: 4),
// // // // //                                         Text(slot.endTime12Format,
// // // // //                                             style: TextStyle(
// // // // //                                                 color:
// // // // //                                                     Colors.redAccent.shade200,
// // // // //                                                 fontSize: 12)),
// // // // //                                       ],
// // // // //                                     ),
// // // // //                                   ],
// // // // //                                 ),
// // // // //                               ],
// // // // //                             ),
// // // // //                           );
// // // // //                         }).toList(),
// // // // //                       );
// // // // //                     },
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //       transitionBuilder: (ctx, anim1, anim2, child) =>
// // // // //           ScaleTransition(scale: anim1, child: child),
// // // // //     );
// // // // //   }

// // // // //   // ════════════════════════════════════════════════════════════════
// // // // //   // NAVIGATE TO USER PROFILE
// // // // //   // ════════════════════════════════════════════════════════════════

// // // // //   void _navigateToUserProfile(ChocolateFactoryUser user) {
// // // // //     // ── Uncomment after adding the imports at the top ──────────
// // // // //     //
// // // // //     // Navigator.push(
// // // // //     //   context,
// // // // //     //   MaterialPageRoute(
// // // // //     //     builder: (_) => OtherUserProfilePage(
// // // // //     //       user: UserListItem(
// // // // //     //         id: user.id,
// // // // //     //         name: user.username,
// // // // //     //         imageUrl: user.profileImage,
// // // // //     //         lastSeen: 'Offline',
// // // // //     //         location: user.stateOfResidence,
// // // // //     //         isOnline: false,
// // // // //     //       ),
// // // // //     //     ),
// // // // //     //   ),
// // // // //     // );
// // // // //   }

// // // // //   // ════════════════════════════════════════════════════════════════
// // // // //   // NETWORK IMAGE HELPER
// // // // //   // ════════════════════════════════════════════════════════════════

// // // // //   Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
// // // // //     if (url.isEmpty) {
// // // // //       return Container(
// // // // //         color: _surface,
// // // // //         child: const Center(
// // // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // // //       );
// // // // //     }
// // // // //     String full = url;
// // // // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // // // //     return Image.network(
// // // // //       full,
// // // // //       fit: fit,
// // // // //       errorBuilder: (_, __, ___) => Container(
// // // // //         color: _surface,
// // // // //         child: const Center(
// // // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // // //       ),
// // // // //       loadingBuilder: (_, child, progress) {
// // // // //         if (progress == null) return child;
// // // // //         return Container(
// // // // //           color: _surface,
// // // // //           child: const Center(
// // // // //             child: CircularProgressIndicator(
// // // // //                 color: _accent, strokeWidth: 2),
// // // // //           ),
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ════════════════════════════════════════════════════════════════════
// // // // // // FLIP CARD — tap to flip between front (image) and back (info)
// // // // // // ════════════════════════════════════════════════════════════════════

// // // // // class _FlipCardWidget extends StatefulWidget {
// // // // //   final ChocolateFactoryUser user;
// // // // //   final VoidCallback onViewMore;
// // // // //   final VoidCallback onCalendar;

// // // // //   const _FlipCardWidget({
// // // // //     required this.user,
// // // // //     required this.onViewMore,
// // // // //     required this.onCalendar,
// // // // //   });

// // // // //   @override
// // // // //   State<_FlipCardWidget> createState() => _FlipCardWidgetState();
// // // // // }

// // // // // class _FlipCardWidgetState extends State<_FlipCardWidget>
// // // // //     with SingleTickerProviderStateMixin {
// // // // //   late AnimationController _controller;
// // // // //   late Animation<double> _animation;
// // // // //   bool _showFront = true;

// // // // //   static const _bg = Color(0xFF13132B);
// // // // //   static const _accent = Color(0xFFE91E63);
// // // // //   static const _surface = Color(0xFF1C1C3A);
// // // // //   static const _gold = Color(0xFFF4BA4A);

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _controller = AnimationController(
// // // // //       duration: const Duration(milliseconds: 600),
// // // // //       vsync: this,
// // // // //     );
// // // // //     _animation = Tween<double>(begin: 0, end: 1).animate(
// // // // //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
// // // // //     );
// // // // //   }

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _controller.dispose();
// // // // //     super.dispose();
// // // // //   }

// // // // //   void _flip() {
// // // // //     if (_showFront) {
// // // // //       _controller.forward();
// // // // //     } else {
// // // // //       _controller.reverse();
// // // // //     }
// // // // //     setState(() => _showFront = !_showFront);
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final u = widget.user;
// // // // //     return GestureDetector(
// // // // //       onTap: _flip,
// // // // //       child: AnimatedBuilder(
// // // // //         animation: _animation,
// // // // //         builder: (context, child) {
// // // // //           final angle = _animation.value * 3.14159265;
// // // // //           final isFront = angle < 1.5708;
// // // // //           return Transform(
// // // // //             alignment: Alignment.center,
// // // // //             transform: Matrix4.identity()
// // // // //               ..setEntry(3, 2, 0.001)
// // // // //               ..rotateY(angle),
// // // // //             child: isFront
// // // // //                 ? _buildFront(u)
// // // // //                 : Transform(
// // // // //                     alignment: Alignment.center,
// // // // //                     transform: Matrix4.identity()..rotateY(3.14159265),
// // // // //                     child: _buildBack(u),
// // // // //                   ),
// // // // //           );
// // // // //         },
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // ── Front ──────────────────────────────────────────────────────

// // // // //   Widget _buildFront(ChocolateFactoryUser u) {
// // // // //     return Container(
// // // // //       decoration: BoxDecoration(
// // // // //         borderRadius: BorderRadius.circular(20),
// // // // //         color: _bg,
// // // // //         boxShadow: [
// // // // //           BoxShadow(
// // // // //             color: Colors.black.withAlpha(80),
// // // // //             blurRadius: 15,
// // // // //             offset: const Offset(0, 8),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       child: Stack(
// // // // //         children: [
// // // // //           ClipRRect(
// // // // //             borderRadius: BorderRadius.circular(20),
// // // // //             child: SizedBox(
// // // // //               width: double.infinity,
// // // // //               height: double.infinity,
// // // // //               child: _networkImg(u.profileImage),
// // // // //             ),
// // // // //           ),
// // // // //           Positioned(
// // // // //             top: 10,
// // // // //             left: 10,
// // // // //             child: Image.network(
// // // // //               '${kAssetBase}img/badge1.png',
// // // // //               width: 40,
// // // // //               height: 40,
// // // // //               errorBuilder: (_, __, ___) =>
// // // // //                   const Icon(Icons.verified, color: _gold, size: 28),
// // // // //             ),
// // // // //           ),
// // // // //           Positioned.fill(
// // // // //             child: Container(
// // // // //               decoration: BoxDecoration(
// // // // //                 borderRadius: BorderRadius.circular(20),
// // // // //                 gradient: LinearGradient(
// // // // //                   begin: Alignment.topCenter,
// // // // //                   end: Alignment.bottomCenter,
// // // // //                   colors: [
// // // // //                     Colors.transparent,
// // // // //                     Colors.transparent,
// // // // //                     Colors.black.withAlpha(200),
// // // // //                   ],
// // // // //                   stops: const [0.0, 0.5, 1.0],
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           Positioned(
// // // // //             left: 14,
// // // // //             bottom: 14,
// // // // //             right: 14,
// // // // //             child: Column(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               children: [
// // // // //                 Text(u.username,
// // // // //                     style: const TextStyle(
// // // // //                         color: Colors.white,
// // // // //                         fontSize: 16,
// // // // //                         fontWeight: FontWeight.bold)),
// // // // //                 if (u.showAge == '1')
// // // // //                   Text('Age ${u.age}',
// // // // //                       style: TextStyle(
// // // // //                           color: Colors.white.withAlpha(180), fontSize: 12)),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // ── Back ───────────────────────────────────────────────────────

// // // // //   Widget _buildBack(ChocolateFactoryUser u) {
// // // // //     return Container(
// // // // //       decoration: const BoxDecoration(
// // // // //         borderRadius: BorderRadius.all(Radius.circular(20)),
// // // // //         gradient: LinearGradient(
// // // // //           colors: [Color(0xFF560827), Color(0xFF06032C)],
// // // // //         ),
// // // // //       ),
// // // // //       child: Padding(
// // // // //         padding: const EdgeInsets.all(16),
// // // // //         child: Column(
// // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // //           children: [
// // // // //             Text(u.username,
// // // // //                 style: const TextStyle(
// // // // //                     color: Colors.white,
// // // // //                     fontSize: 20,
// // // // //                     fontWeight: FontWeight.bold),
// // // // //                 textAlign: TextAlign.center),
// // // // //             const SizedBox(height: 4),
// // // // //             if (u.stateOfResidence.isNotEmpty)
// // // // //               Text(u.stateOfResidence,
// // // // //                   style:
// // // // //                       TextStyle(color: Colors.white.withAlpha(160), fontSize: 13)),
// // // // //             const SizedBox(height: 12),
// // // // //             Wrap(
// // // // //               alignment: WrapAlignment.center,
// // // // //               spacing: 8,
// // // // //               runSpacing: 6,
// // // // //               children: [
// // // // //                 if (u.showAge == '1') _backChip('${u.age} yrs'),
// // // // //                 if (u.showHeight == '1')
// // // // //                   _backChip("${u.heightFeet}' ${u.heightInch}\""),
// // // // //                 if (u.showWeight == '1') _backChip('${u.weight} Kg'),
// // // // //               ],
// // // // //             ),
// // // // //             const SizedBox(height: 10),
// // // // //             if (u.showPreferences == '1' && u.preferences.isNotEmpty)
// // // // //               Wrap(
// // // // //                 spacing: 6,
// // // // //                 runSpacing: 6,
// // // // //                 alignment: WrapAlignment.center,
// // // // //                 children: u.preferences.take(3).map((p) {
// // // // //                   return Container(
// // // // //                     padding: const EdgeInsets.symmetric(
// // // // //                         horizontal: 8, vertical: 4),
// // // // //                     decoration: BoxDecoration(
// // // // //                       color: _accent.withAlpha(40),
// // // // //                       borderRadius: BorderRadius.circular(12),
// // // // //                     ),
// // // // //                     child: Text(p,
// // // // //                         style:
// // // // //                             const TextStyle(color: _accent, fontSize: 10)),
// // // // //                   );
// // // // //                 }).toList(),
// // // // //               ),
// // // // //             const SizedBox(height: 16),
// // // // //             SizedBox(
// // // // //               width: double.infinity,
// // // // //               child: ElevatedButton(
// // // // //                 onPressed: widget.onViewMore,
// // // // //                 style: ElevatedButton.styleFrom(
// // // // //                   backgroundColor: _accent,
// // // // //                   foregroundColor: Colors.white,
// // // // //                   shape: RoundedRectangleBorder(
// // // // //                       borderRadius: BorderRadius.circular(14)),
// // // // //                   padding: const EdgeInsets.symmetric(vertical: 10),
// // // // //                 ),
// // // // //                 child: const Text('View More',
// // // // //                     style: TextStyle(fontWeight: FontWeight.bold)),
// // // // //               ),
// // // // //             ),
// // // // //             const SizedBox(height: 8),
// // // // //             GestureDetector(
// // // // //               onTap: widget.onCalendar,
// // // // //               child: Container(
// // // // //                 padding: const EdgeInsets.symmetric(vertical: 8),
// // // // //                 decoration: BoxDecoration(
// // // // //                   border: Border.all(color: _gold.withAlpha(80)),
// // // // //                   borderRadius: BorderRadius.circular(14),
// // // // //                 ),
// // // // //                 child: const Row(
// // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // //                   children: [
// // // // //                     Icon(Icons.calendar_today, color: _gold, size: 16),
// // // // //                     SizedBox(width: 6),
// // // // //                     Text('View Calendar',
// // // // //                         style: TextStyle(color: _gold, fontSize: 13)),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _backChip(String text) {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white.withAlpha(15),
// // // // //         borderRadius: BorderRadius.circular(10),
// // // // //       ),
// // // // //       child: Text(text,
// // // // //           style: const TextStyle(color: Colors.white, fontSize: 11)),
// // // // //     );
// // // // //   }

// // // // //   Widget _networkImg(String url) {
// // // // //     if (url.isEmpty) {
// // // // //       return Container(
// // // // //         color: _surface,
// // // // //         child: const Center(
// // // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // // //       );
// // // // //     }
// // // // //     String full = url;
// // // // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // // // //     return Image.network(
// // // // //       full,
// // // // //       fit: BoxFit.cover,
// // // // //       errorBuilder: (_, __, ___) => Container(
// // // // //         color: _surface,
// // // // //         child: const Center(
// // // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // // //       ),
// // // // //       loadingBuilder: (_, child, progress) {
// // // // //         if (progress == null) return child;
// // // // //         return Container(
// // // // //           color: _surface,
// // // // //           child: const Center(
// // // // //             child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
// // // // //           ),
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }
// // // // // }


// // // // // ╔═══════════════════════════════════════════════════════════════════╗
// // // // // ║  Celebrity Panel – Pay-Per-Click (Chocolate Factory)            ║
// // // // // ║  Single self-contained file — paste into your existing project  ║
// // // // // ║  API: https://app.beatflirtevent.com/App                        ║
// // // // // ║  Auth: Access-Token + Access-Sign headers (from sessionStorage) ║
// // // // // ╚═══════════════════════════════════════════════════════════════════╝

// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:http/http.dart' as http;

// // // // // ── Uncomment these for your existing project navigation ─────────
// // // // // import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// // // // // import 'package:beatflirt/providers/user_list_provider.dart';

// // // // // ════════════════════════════════════════════════════════════════════
// // // // // 1)  A P I   C O N S T A N T S
// // // // // ════════════════════════════════════════════════════════════════════

// // // // const String kApiBase = 'https://app.beatflirtevent.com/App';
// // // // const String kAssetBase = 'https://app.beatflirtevent.com/assets/';

// // // // const List<String> kPreferenceOptions = [
// // // //   'Orgy',
// // // //   'Gang Bang',
// // // //   'Couple',
// // // //   'BDSM',
// // // //   'Dom',
// // // //   'Sub',
// // // //   'Cuckolder',
// // // //   'Bull Stag',
// // // // ];

// // // // // ════════════════════════════════════════════════════════════════════
// // // // // 2)  D A T A   M O D E L S
// // // // // ════════════════════════════════════════════════════════════════════

// // // // class ChocolateFactoryUser {
// // // //   final String id;
// // // //   final String username;
// // // //   final String age;
// // // //   final String showAge;
// // // //   final String stateOfResidence;
// // // //   final String heightFeet;
// // // //   final String heightInch;
// // // //   final String showHeight;
// // // //   final String weight;
// // // //   final String showWeight;
// // // //   final List<String> preferences;
// // // //   final String showPreferences;
// // // //   final String selfDescription;
// // // //   final List<ChocolateFactoryImage> images;

// // // //   const ChocolateFactoryUser({
// // // //     required this.id,
// // // //     required this.username,
// // // //     required this.age,
// // // //     required this.showAge,
// // // //     required this.stateOfResidence,
// // // //     required this.heightFeet,
// // // //     required this.heightInch,
// // // //     required this.showHeight,
// // // //     required this.weight,
// // // //     required this.showWeight,
// // // //     required this.preferences,
// // // //     required this.showPreferences,
// // // //     required this.selfDescription,
// // // //     required this.images,
// // // //   });

// // // //   String get profileImage =>
// // // //       images.isNotEmpty ? images.first.profileImage : '';

// // // //   String get displayHeight => "${heightFeet}' ${heightInch}\"";

// // // //   factory ChocolateFactoryUser.fromJson(Map<String, dynamic> j) {
// // // //     return ChocolateFactoryUser(
// // // //       id: '${j['id'] ?? ''}',
// // // //       username: '${j['username'] ?? ''}',
// // // //       age: '${j['age'] ?? ''}',
// // // //       showAge: '${j['show_age'] ?? '0'}',
// // // //       stateOfResidence: '${j['state_of_residence'] ?? ''}',
// // // //       heightFeet: '${j['height_feet'] ?? ''}',
// // // //       heightInch: '${j['height_inch'] ?? ''}',
// // // //       showHeight: '${j['show_height'] ?? '0'}',
// // // //       weight: '${j['weight'] ?? ''}',
// // // //       showWeight: '${j['show_weight'] ?? '0'}',
// // // //       preferences:
// // // //           (j['preferences'] as List<dynamic>?)
// // // //               ?.map((e) => '$e')
// // // //               .toList() ?? [],
// // // //       showPreferences: '${j['show_preferences'] ?? '0'}',
// // // //       selfDescription: '${j['self_description'] ?? ''}',
// // // //       images:
// // // //           (j['image'] as List<dynamic>?)
// // // //               ?.map((e) => ChocolateFactoryImage.fromJson(e))
// // // //               .toList() ?? [],
// // // //     );
// // // //   }
// // // // }

// // // // class ChocolateFactoryImage {
// // // //   final String profileImage;
// // // //   const ChocolateFactoryImage({required this.profileImage});
// // // //   factory ChocolateFactoryImage.fromJson(Map<String, dynamic> j) =>
// // // //       ChocolateFactoryImage(profileImage: '${j['profile_image'] ?? ''}');
// // // // }

// // // // class CalendarSlot {
// // // //   final String username;
// // // //   final String calenderDate;
// // // //   final String startTime12Format;
// // // //   final String endTime12Format;
// // // //   const CalendarSlot({
// // // //     required this.username,
// // // //     required this.calenderDate,
// // // //     required this.startTime12Format,
// // // //     required this.endTime12Format,
// // // //   });
// // // //   factory CalendarSlot.fromJson(Map<String, dynamic> j) => CalendarSlot(
// // // //         username: '${j['username'] ?? ''}',
// // // //         calenderDate: '${j['calender_date'] ?? ''}',
// // // //         startTime12Format: '${j['start_time_12_formate'] ?? ''}',
// // // //         endTime12Format: '${j['end_time_12_formate'] ?? ''}',
// // // //       );
// // // // }

// // // // class TermsCondition {
// // // //   final String description;
// // // //   const TermsCondition({required this.description});
// // // //   factory TermsCondition.fromJson(Map<String, dynamic> j) =>
// // // //       TermsCondition(description: '${j['description'] ?? ''}');
// // // // }

// // // // // ════════════════════════════════════════════════════════════════════
// // // // // 3)  S T A T E
// // // // // ════════════════════════════════════════════════════════════════════

// // // // class PanelState {
// // // //   final bool isLoading;
// // // //   final String? error;
// // // //   final ChocolateFactoryUser? myProfile;
// // // //   final List<ChocolateFactoryUser> allUsers;
// // // //   final String searchQuery;
// // // //   final int ageMin;
// // // //   final int ageMax;
// // // //   final int heightMin;
// // // //   final int heightMax;
// // // //   final int weightMin;
// // // //   final int weightMax;
// // // //   final List<String> selectedPreferences;

// // // //   const PanelState({
// // // //     this.isLoading = false,
// // // //     this.error,
// // // //     this.myProfile,
// // // //     this.allUsers = const [],
// // // //     this.searchQuery = '',
// // // //     this.ageMin = 18,
// // // //     this.ageMax = 80,
// // // //     this.heightMin = 3,
// // // //     this.heightMax = 8,
// // // //     this.weightMin = 20,
// // // //     this.weightMax = 150,
// // // //     this.selectedPreferences = const [],
// // // //   });

// // // //   PanelState copyWith({
// // // //     bool? isLoading,
// // // //     String? error,
// // // //     ChocolateFactoryUser? myProfile,
// // // //     List<ChocolateFactoryUser>? allUsers,
// // // //     String? searchQuery,
// // // //     int? ageMin,
// // // //     int? ageMax,
// // // //     int? heightMin,
// // // //     int? heightMax,
// // // //     int? weightMin,
// // // //     int? weightMax,
// // // //     List<String>? selectedPreferences,
// // // //   }) {
// // // //     return PanelState(
// // // //       isLoading: isLoading ?? this.isLoading,
// // // //       error: error,
// // // //       myProfile: myProfile ?? this.myProfile,
// // // //       allUsers: allUsers ?? this.allUsers,
// // // //       searchQuery: searchQuery ?? this.searchQuery,
// // // //       ageMin: ageMin ?? this.ageMin,
// // // //       ageMax: ageMax ?? this.ageMax,
// // // //       heightMin: heightMin ?? this.heightMin,
// // // //       heightMax: heightMax ?? this.heightMax,
// // // //       weightMin: weightMin ?? this.weightMin,
// // // //       weightMax: weightMax ?? this.weightMax,
// // // //       selectedPreferences: selectedPreferences ?? this.selectedPreferences,
// // // //     );
// // // //   }

// // // //   List<ChocolateFactoryUser> get filteredUsers {
// // // //     var list = allUsers;
// // // //     if (searchQuery.isNotEmpty) {
// // // //       list = list
// // // //           .where((u) =>
// // // //               u.username.toLowerCase().contains(searchQuery.toLowerCase()))
// // // //           .toList();
// // // //     }
// // // //     return list;
// // // //   }
// // // // }

// // // // // ════════════════════════════════════════════════════════════════════
// // // // // 4)  N O T I F I E R   (API calls + state)
// // // // // ════════════════════════════════════════════════════════════════════

// // // // class PanelNotifier extends StateNotifier<PanelState> {
// // // //   String? _accessToken;
// // // //   String? _accessSign;

// // // //   PanelNotifier() : super(const PanelState()) {
// // // //     _loadToken();
// // // //   }

// // // //   // ── Load auth credentials ─────────────────────────────────────
// // // //   //
// // // //   // The web app stores them in sessionStorage / localStorage as:
// // // //   //   "Access-Token"  →  sent as header  Access-Token
// // // //   //   "Access-Sign"   →  sent as header  Access-Sign
// // // //   //
// // // //   // The Flutter app likely stores them in SharedPreferences with the
// // // //   // same keys, or lower-case variants.  We try both.

// // // //   Future<void> _loadToken() async {
// // // //     final prefs = await SharedPreferences.getInstance();

// // // //     // Try every possible key variant
// // // //     _accessToken = prefs.getString('Access-Token') //
// // // //         ?? prefs.getString('access_token')
// // // //         ?? prefs.getString('accessToken')
// // // //         ?? prefs.getString('token')
// // // //         ?? prefs.getString('auth_token');
// // // //     _accessSign = prefs.getString('Access-Sign') //
// // // //         ?? prefs.getString('access_sign')
// // // //         ?? prefs.getString('accessSign')
// // // //         ?? prefs.getString('sign');

// // // //     debugPrint('═══ CelebrityPanel ═══');
// // // //     debugPrint('  Access-Token : ${_accessToken != null ? "${_accessToken!.substring(0, _accessToken!.length > 20 ? 20 : _accessToken!.length)}..." : "NULL"}');
// // // //     debugPrint('  Access-Sign  : ${_accessSign != null ? "${_accessSign!.substring(0, _accessSign!.length > 20 ? 20 : _accessSign!.length)}..." : "NULL"}');
// // // //     debugPrint('═══════════════════════');

// // // //     fetchPanel();
// // // //   }

// // // //   // ── HTTP helpers ──────────────────────────────────────────────
// // // //   //
// // // //   //  The web's callapi.setHeaders() builds:
// // // //   //    { "Content-Type":"application/json; charset=UTF-8",
// // // //   //      "Access-Token":"<token>",  "Access-Sign":"<sign>" }
// // // //   //
// // // //   //  NOT  Authorization: Bearer ...  ← this was the bug!

// // // //   Map<String, String> get _headers => {
// // // //         'Content-Type': 'application/json; charset=UTF-8',
// // // //         if (_accessToken != null && _accessToken!.isNotEmpty)
// // // //           'Access-Token': _accessToken!,
// // // //         if (_accessSign != null && _accessSign!.isNotEmpty)
// // // //           'Access-Sign': _accessSign!,
// // // //       };

// // // //   Future<Map<String, dynamic>?> _post(
// // // //       String path, Map<String, dynamic> body) async {
// // // //     try {
// // // //       final uri = Uri.parse('$kApiBase$path');
// // // //       debugPrint('POST $uri  headers=$_headers');
// // // //       final r = await http.post(uri, headers: _headers, body: jsonEncode(body));
// // // //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// // // //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// // // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // // //       }
// // // //       return null;
// // // //     } catch (e) {
// // // //       debugPrint('  → ERROR $e');
// // // //       return null;
// // // //     }
// // // //   }

// // // //   Future<Map<String, dynamic>?> _get(String path) async {
// // // //     try {
// // // //       final uri = Uri.parse('$kApiBase$path');
// // // //       debugPrint('GET $uri  headers=$_headers');
// // // //       final r = await http.get(uri, headers: _headers);
// // // //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// // // //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// // // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // // //       }
// // // //       return null;
// // // //     } catch (e) {
// // // //       debugPrint('  → ERROR $e');
// // // //       return null;
// // // //     }
// // // //   }

// // // //   // ── Helper: check status as int or string ─────────────────────
// // // //   //  Web API sometimes returns {"status":200} (int)
// // // //   //  and sometimes {"status":"404"} (string).
// // // //   //  JavaScript == coerces both, but Dart's == does NOT.

// // // //   bool _isOk(Map<String, dynamic>? r) {
// // // //     if (r == null) return false;
// // // //     final s = r['status'];
// // // //     return s != null && s.toString() == '200';
// // // //   }

// // // //   // ── Main data fetch ───────────────────────────────────────────

// // // //   Future<void> fetchPanel() async {
// // // //     state = state.copyWith(isLoading: true, error: null);
// // // //     try {
// // // //       final results = await Future.wait([
// // // //         _post('/payperclick/get_chocolate_factory_data', {'user_type': 'me'}),
// // // //         _post('/payperclick/get_all_chocolate_factory_data', {
// // // //           'age_minvalue': state.ageMin,
// // // //           'age_maxvalue': state.ageMax,
// // // //           'height_minvalue': state.heightMin,
// // // //           'height_maxvalue': state.heightMax,
// // // //           'weight_minvalue': state.weightMin,
// // // //           'weight_maxvalue': state.weightMax,
// // // //           'preferencesArray': state.selectedPreferences,
// // // //         }),
// // // //       ]);

// // // //       ChocolateFactoryUser? myProfile;
// // // //       final me = results[0];
// // // //       if (_isOk(me)) {
// // // //         final d = me!['data'];
// // // //         if (d is List && d.isNotEmpty) {
// // // //           myProfile = ChocolateFactoryUser.fromJson(d[0]);
// // // //         }
// // // //       }

// // // //       List<ChocolateFactoryUser> allUsers = [];
// // // //       final all = results[1];
// // // //       if (_isOk(all)) {
// // // //         final d = all!['data'];
// // // //         if (d is List) {
// // // //           allUsers = d.map((e) => ChocolateFactoryUser.fromJson(e)).toList();
// // // //         }
// // // //       }

// // // //       debugPrint('  myProfile: ${myProfile?.username ?? "null"}');
// // // //       debugPrint('  allUsers count: ${allUsers.length}');

// // // //       state = state.copyWith(
// // // //         isLoading: false,
// // // //         myProfile: myProfile,
// // // //         allUsers: allUsers,
// // // //       );
// // // //     } catch (e) {
// // // //       debugPrint('  fetchPanel ERROR: $e');
// // // //       state = state.copyWith(isLoading: false, error: e.toString());
// // // //     }
// // // //   }

// // // //   // ── Filters ───────────────────────────────────────────────────

// // // //   Future<void> applyFilters() => fetchPanel();

// // // //   void updateAge(RangeValues v) =>
// // // //       state = state.copyWith(ageMin: v.start.round(), ageMax: v.end.round());
// // // //   void updateHeight(RangeValues v) => state = state.copyWith(
// // // //       heightMin: v.start.round(), heightMax: v.end.round());
// // // //   void updateWeight(RangeValues v) => state = state.copyWith(
// // // //       weightMin: v.start.round(), weightMax: v.end.round());

// // // //   void togglePreference(String pref) {
// // // //     final list = [...state.selectedPreferences];
// // // //     if (list.contains(pref)) {
// // // //       list.remove(pref);
// // // //     } else {
// // // //       list.add(pref);
// // // //     }
// // // //     state = state.copyWith(selectedPreferences: list);
// // // //   }

// // // //   void setSearch(String q) => state = state.copyWith(searchQuery: q);

// // // //   // ── Calendar ──────────────────────────────────────────────────

// // // //   Future<List<CalendarSlot>> fetchCalendar(String payPerId) async {
// // // //     final r = await _post('/payperclick/get_user_calender_details', {
// // // //       'pay_per_id': payPerId,
// // // //     });
// // // //     if (_isOk(r)) {
// // // //       final d = r!['data'];
// // // //       if (d is List) return d.map((e) => CalendarSlot.fromJson(e)).toList();
// // // //     }
// // // //     return [];
// // // //   }

// // // //   // ── Terms ─────────────────────────────────────────────────────

// // // //   Future<TermsCondition?> fetchTerms() async {
// // // //     final r = await _get('/auth/pay_per_click_terms_condition');
// // // //     if (_isOk(r)) {
// // // //       final d = r!['data'];
// // // //       if (d is List && d.isNotEmpty) return TermsCondition.fromJson(d[0]);
// // // //     }
// // // //     return null;
// // // //   }

// // // //   // ── Check flags ───────────────────────────────────────────────

// // // //   Future<bool> checkPost() async {
// // // //     final r = await _get('/payperclick/check_chocolate_factory_post');
// // // //     return _isOk(r);
// // // //   }

// // // //   Future<bool> checkPopup() async {
// // // //     final r = await _get('/payperclick/check_chocolate_factory_popup');
// // // //     return _isOk(r);
// // // //   }
// // // // }

// // // // // ════════════════════════════════════════════════════════════════════
// // // // // 5)  P R O V I D E R
// // // // // ════════════════════════════════════════════════════════════════════

// // // // final panelProvider =
// // // //     StateNotifierProvider.autoDispose<PanelNotifier, PanelState>(
// // // //   (ref) => PanelNotifier(),
// // // // );

// // // // // ════════════════════════════════════════════════════════════════════
// // // // // 6)  M A I N   P A G E   W I D G E T
// // // // // ════════════════════════════════════════════════════════════════════

// // // // class CelebrityPanelPage extends ConsumerStatefulWidget {
// // // //   const CelebrityPanelPage({super.key});

// // // //   @override
// // // //   ConsumerState<CelebrityPanelPage> createState() => _CelebrityPanelPageState();
// // // // }

// // // // class _CelebrityPanelPageState extends ConsumerState<CelebrityPanelPage>
// // // //     with TickerProviderStateMixin {
// // // //   final TextEditingController _searchCtrl = TextEditingController();
// // // //   bool _filterExpanded = false;

// // // //   // ── Colour palette ────────────────────────────────────────────
// // // //   static const _bg = Color(0xFF0B0B1A);
// // // //   static const _card = Color(0xFF13132B);
// // // //   static const _accent = Color(0xFFE91E63);
// // // //   static const _gold = Color(0xFFF4BA4A);
// // // //   static const _surface = Color(0xFF1C1C3A);

// // // //   @override
// // // //   void dispose() {
// // // //     _searchCtrl.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   // ════════════════════════════════════════════════════════════════
// // // //   // BUILD
// // // //   // ════════════════════════════════════════════════════════════════

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final s = ref.watch(panelProvider);

// // // //     return Scaffold(
// // // //       backgroundColor: _bg,
// // // //       body: CustomScrollView(
// // // //         physics: const BouncingScrollPhysics(),
// // // //         slivers: [
// // // //           // ── App Bar (no notification icon) ────────────────────
// // // //           SliverAppBar(
// // // //             leading: IconButton(
// // // //               icon: const Icon(Icons.arrow_back_ios_new,
// // // //                   color: Colors.white, size: 20),
// // // //               onPressed: () => Navigator.pop(context),
// // // //             ),
// // // //             expandedHeight: 130,
// // // //             floating: false,
// // // //             pinned: true,
// // // //             backgroundColor: _bg,
// // // //             elevation: 0,
// // // //             flexibleSpace: LayoutBuilder(
// // // //               builder: (context, constraints) {
// // // //                 final top = MediaQuery.of(context).padding.top;
// // // //                 final collapsed = kToolbarHeight + top;
// // // //                 final isCollapsed = constraints.maxHeight <= collapsed + 10;
// // // //                 return FlexibleSpaceBar(
// // // //                   centerTitle: false,
// // // //                   titlePadding: EdgeInsets.only(
// // // //                     left: isCollapsed ? 50 : 20,
// // // //                     bottom: 14,
// // // //                   ),
// // // //                   title: const Text(
// // // //                     'Celebrity Panel',
// // // //                     style: TextStyle(
// // // //                       color: Colors.white,
// // // //                       fontWeight: FontWeight.bold,
// // // //                       fontSize: 20,
// // // //                     ),
// // // //                   ),
// // // //                   background: Container(
// // // //                     decoration: const BoxDecoration(
// // // //                       gradient: LinearGradient(
// // // //                         begin: Alignment.topCenter,
// // // //                         end: Alignment.bottomCenter,
// // // //                         colors: [_accent, _bg],
// // // //                         stops: [0.0, 0.8],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),

// // // //           // ── Loading ───────────────────────────────────────────
// // // //           if (s.isLoading)
// // // //             const SliverFillRemaining(
// // // //               child: Center(child: CircularProgressIndicator(color: _accent)),
// // // //             )

// // // //           // ── Error ─────────────────────────────────────────────
// // // //           else if (s.error != null && s.allUsers.isEmpty)
// // // //             SliverFillRemaining(
// // // //               child: Center(
// // // //                 child: Column(
// // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // //                   children: [
// // // //                     const Icon(Icons.error_outline,
// // // //                         color: Colors.white24, size: 48),
// // // //                     const SizedBox(height: 16),
// // // //                     Text('Failed to load celebrities',
// // // //                         style: TextStyle(color: Colors.white.withAlpha(153))),
// // // //                     const SizedBox(height: 8),
// // // //                     Text(s.error ?? '',
// // // //                         style: TextStyle(color: Colors.white38, fontSize: 12),
// // // //                         textAlign: TextAlign.center),
// // // //                     const SizedBox(height: 12),
// // // //                     TextButton(
// // // //                       onPressed: () =>
// // // //                           ref.read(panelProvider.notifier).fetchPanel(),
// // // //                       child: const Text('Retry',
// // // //                           style: TextStyle(color: _accent)),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             )

// // // //           // ── Content ───────────────────────────────────────────
// // // //           else ...[
// // // //             if (s.myProfile != null) _buildMyProfileCard(s.myProfile!),
// // // //             _buildSearchBar(),
// // // //             _buildFilterPanel(s),
// // // //             _buildUsersGrid(s),
// // // //             const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
// // // //           ],
// // // //         ],
// // // //       ),
// // // //       // ── NO FAB (removed) ──────────────────────────────────────
// // // //     );
// // // //   }

// // // //   // ════════════════════════════════════════════════════════════════
// // // //   // MY PROFILE CARD
// // // //   // ════════════════════════════════════════════════════════════════

// // // //   Widget _buildMyProfileCard(ChocolateFactoryUser u) {
// // // //     return SliverToBoxAdapter(
// // // //       child: Container(
// // // //         margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
// // // //         decoration: BoxDecoration(
// // // //           color: _card,
// // // //           borderRadius: BorderRadius.circular(24),
// // // //           border: Border.all(color: Colors.white.withAlpha(25)),
// // // //           boxShadow: [
// // // //             BoxShadow(
// // // //               color: _accent.withAlpha(40),
// // // //               blurRadius: 30,
// // // //               offset: const Offset(0, 10),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         child: Column(
// // // //           children: [
// // // //             // ── Image ─────────────────────────────────────────
// // // //             SizedBox(
// // // //               height: 220,
// // // //               child: Stack(
// // // //                 children: [
// // // //                   ClipRRect(
// // // //                     borderRadius: const BorderRadius.vertical(
// // // //                         top: Radius.circular(24)),
// // // //                     child: SizedBox(
// // // //                       width: double.infinity,
// // // //                       child: _networkImage(u.profileImage, fit: BoxFit.cover),
// // // //                     ),
// // // //                   ),
// // // //                   // Badge
// // // //                   Positioned(
// // // //                     top: 12,
// // // //                     left: 12,
// // // //                     child: Container(
// // // //                       padding: const EdgeInsets.all(8),
// // // //                       decoration: BoxDecoration(
// // // //                         color: _accent.withAlpha(200),
// // // //                         borderRadius: BorderRadius.circular(12),
// // // //                       ),
// // // //                       child: Image.network(
// // // //                         '${kAssetBase}img/badge1.png',
// // // //                         width: 40,
// // // //                         height: 40,
// // // //                         errorBuilder: (_, __, ___) =>
// // // //                             const Icon(Icons.verified, color: Colors.white),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   // Edit button
// // // //                   Positioned(
// // // //                     top: 12,
// // // //                     right: 12,
// // // //                     child: GestureDetector(
// // // //                       onTap: () {},
// // // //                       child: Container(
// // // //                         padding: const EdgeInsets.symmetric(
// // // //                             horizontal: 14, vertical: 8),
// // // //                         decoration: BoxDecoration(
// // // //                           color: Colors.black.withAlpha(150),
// // // //                           borderRadius: BorderRadius.circular(20),
// // // //                           border: Border.all(
// // // //                               color: Colors.white.withAlpha(60)),
// // // //                         ),
// // // //                         child: const Row(
// // // //                           mainAxisSize: MainAxisSize.min,
// // // //                           children: [
// // // //                             Icon(Icons.edit, color: Colors.white, size: 14),
// // // //                             SizedBox(width: 4),
// // // //                             Text('Edit Profile',
// // // //                                 style: TextStyle(
// // // //                                     color: Colors.white,
// // // //                                     fontSize: 12,
// // // //                                     fontWeight: FontWeight.w600)),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   // Gradient
// // // //                   Positioned.fill(
// // // //                     child: Container(
// // // //                       decoration: BoxDecoration(
// // // //                         borderRadius: const BorderRadius.vertical(
// // // //                             top: Radius.circular(24)),
// // // //                         gradient: LinearGradient(
// // // //                           begin: Alignment.topCenter,
// // // //                           end: Alignment.bottomCenter,
// // // //                           colors: [
// // // //                             Colors.transparent,
// // // //                             Colors.black.withAlpha(180),
// // // //                           ],
// // // //                           stops: const [0.5, 1.0],
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   // Name + age
// // // //                   Positioned(
// // // //                     left: 16,
// // // //                     bottom: 16,
// // // //                     child: Row(
// // // //                       children: [
// // // //                         Text(u.username,
// // // //                             style: const TextStyle(
// // // //                                 color: Colors.white,
// // // //                                 fontSize: 22,
// // // //                                 fontWeight: FontWeight.bold)),
// // // //                         if (u.showAge == '1') ...[
// // // //                           const SizedBox(width: 8),
// // // //                           Text('Age ${u.age}',
// // // //                               style: TextStyle(
// // // //                                   color: Colors.white.withAlpha(200),
// // // //                                   fontSize: 14)),
// // // //                         ],
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),

// // // //             // ── Info ───────────────────────────────────────────
// // // //             Padding(
// // // //               padding: const EdgeInsets.all(20),
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   // Location
// // // //                   Row(
// // // //                     children: [
// // // //                       const Icon(Icons.location_on, color: _accent, size: 16),
// // // //                       const SizedBox(width: 6),
// // // //                       Text(u.stateOfResidence,
// // // //                           style: TextStyle(
// // // //                               color: Colors.white.withAlpha(180),
// // // //                               fontSize: 14)),
// // // //                     ],
// // // //                   ),
// // // //                   const SizedBox(height: 14),

// // // //                   // Stats
// // // //                   Row(
// // // //                     children: [
// // // //                       if (u.showHeight == '1')
// // // //                         _statChip(Icons.height, u.displayHeight),
// // // //                       if (u.showHeight == '1') const SizedBox(width: 12),
// // // //                       if (u.showWeight == '1')
// // // //                         _statChip(
// // // //                             Icons.monitor_weight_outlined, '${u.weight} Kg'),
// // // //                     ],
// // // //                   ),
// // // //                   const SizedBox(height: 14),

// // // //                   // Preferences
// // // //                   if (u.showPreferences == '1' &&
// // // //                       u.preferences.isNotEmpty) ...[
// // // //                     const Text('Preferences',
// // // //                         style: TextStyle(
// // // //                             color: Colors.white,
// // // //                             fontSize: 14,
// // // //                             fontWeight: FontWeight.w600)),
// // // //                     const SizedBox(height: 8),
// // // //                     Wrap(
// // // //                       spacing: 8,
// // // //                       runSpacing: 8,
// // // //                       children: u.preferences
// // // //                           .map((p) => Container(
// // // //                                 padding: const EdgeInsets.symmetric(
// // // //                                     horizontal: 12, vertical: 6),
// // // //                                 decoration: BoxDecoration(
// // // //                                   color: _accent.withAlpha(30),
// // // //                                   borderRadius: BorderRadius.circular(20),
// // // //                                   border: Border.all(
// // // //                                       color: _accent.withAlpha(80)),
// // // //                                 ),
// // // //                                 child: Text(p,
// // // //                                     style: const TextStyle(
// // // //                                         color: _accent, fontSize: 12)),
// // // //                               ))
// // // //                           .toList(),
// // // //                     ),
// // // //                     const SizedBox(height: 14),
// // // //                   ],

// // // //                   // Calendar + Review
// // // //                   Row(
// // // //                     children: [
// // // //                       Expanded(
// // // //                         child: GestureDetector(
// // // //                           onTap: () =>
// // // //                               _showCalendarDialog(u.id, u.username),
// // // //                           child: Container(
// // // //                             padding: const EdgeInsets.symmetric(vertical: 12),
// // // //                             decoration: BoxDecoration(
// // // //                               color: _surface,
// // // //                               borderRadius: BorderRadius.circular(14),
// // // //                               border: Border.all(
// // // //                                   color: Colors.white.withAlpha(20)),
// // // //                             ),
// // // //                             child: const Row(
// // // //                               mainAxisAlignment: MainAxisAlignment.center,
// // // //                               children: [
// // // //                                 Icon(Icons.calendar_month,
// // // //                                     color: _gold, size: 18),
// // // //                                 SizedBox(width: 8),
// // // //                                 Flexible(
// // // //                                   child: Text('Calendar',
// // // //                                       style: TextStyle(
// // // //                                           color: Colors.white,
// // // //                                           fontSize: 13,
// // // //                                           fontWeight: FontWeight.w600),
// // // //                                       overflow: TextOverflow.ellipsis),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       const SizedBox(width: 10),
// // // //                       Flexible(
// // // //                         child: GestureDetector(
// // // //                           onTap: () {},
// // // //                           child: Container(
// // // //                             padding: const EdgeInsets.symmetric(
// // // //                                 horizontal: 16, vertical: 12),
// // // //                             decoration: BoxDecoration(
// // // //                               color: _accent.withAlpha(20),
// // // //                               borderRadius: BorderRadius.circular(14),
// // // //                               border:
// // // //                                   Border.all(color: _accent.withAlpha(60)),
// // // //                             ),
// // // //                             child: const Row(
// // // //                               mainAxisAlignment: MainAxisAlignment.center,
// // // //                               mainAxisSize: MainAxisSize.min,
// // // //                               children: [
// // // //                                 Icon(Icons.rate_review,
// // // //                                     color: _accent, size: 16),
// // // //                                 SizedBox(width: 6),
// // // //                                 Flexible(
// // // //                                   child: Text('Write Review',
// // // //                                       style: TextStyle(
// // // //                                           color: _accent, fontSize: 13),
// // // //                                       overflow: TextOverflow.ellipsis),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                   const SizedBox(height: 14),

// // // //                   // Description
// // // //                   if (u.selfDescription.isNotEmpty) ...[
// // // //                     Text('Description',
// // // //                         style: TextStyle(
// // // //                             color: Colors.white.withAlpha(150),
// // // //                             fontSize: 12,
// // // //                             fontWeight: FontWeight.w600)),
// // // //                     const SizedBox(height: 6),
// // // //                     Text(u.selfDescription,
// // // //                         style: TextStyle(
// // // //                             color: Colors.white.withAlpha(120),
// // // //                             fontSize: 13,
// // // //                             height: 1.5),
// // // //                         maxLines: 4,
// // // //                         overflow: TextOverflow.ellipsis),
// // // //                   ],
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _statChip(IconData icon, String label) {
// // // //     return Container(
// // // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // // //       decoration: BoxDecoration(
// // // //         color: _surface,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(color: Colors.white.withAlpha(20)),
// // // //       ),
// // // //       child: Row(
// // // //         mainAxisSize: MainAxisSize.min,
// // // //         children: [
// // // //           Icon(icon, color: _gold, size: 16),
// // // //           const SizedBox(width: 6),
// // // //           Text(label,
// // // //               style: const TextStyle(color: Colors.white, fontSize: 13)),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ════════════════════════════════════════════════════════════════
// // // //   // SEARCH BAR
// // // //   // ════════════════════════════════════════════════════════════════

// // // //   Widget _buildSearchBar() {
// // // //     return SliverToBoxAdapter(
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // // //         child: Row(
// // // //           children: [
// // // //             Expanded(
// // // //               child: Container(
// // // //                 height: 50,
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.white.withAlpha(15),
// // // //                   borderRadius: BorderRadius.circular(15),
// // // //                 ),
// // // //                 child: TextField(
// // // //                   controller: _searchCtrl,
// // // //                   style: const TextStyle(color: Colors.white),
// // // //                   onChanged: (v) =>
// // // //                       ref.read(panelProvider.notifier).setSearch(v),
// // // //                   decoration: InputDecoration(
// // // //                     hintText: 'Search celebrities...',
// // // //                     hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
// // // //                     prefixIcon: Icon(Icons.search,
// // // //                         color: Colors.white.withAlpha(100)),
// // // //                     border: InputBorder.none,
// // // //                     contentPadding: const EdgeInsets.symmetric(vertical: 15),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(width: 12),
// // // //             GestureDetector(
// // // //               onTap: () =>
// // // //                   setState(() => _filterExpanded = !_filterExpanded),
// // // //               child: AnimatedContainer(
// // // //                 duration: const Duration(milliseconds: 300),
// // // //                 height: 50,
// // // //                 width: 50,
// // // //                 decoration: BoxDecoration(
// // // //                   color: _filterExpanded
// // // //                       ? _accent
// // // //                       : _accent.withAlpha(30),
// // // //                   borderRadius: BorderRadius.circular(15),
// // // //                   border: Border.all(
// // // //                       color:
// // // //                           _accent.withAlpha(_filterExpanded ? 255 : 120)),
// // // //                 ),
// // // //                 child: AnimatedRotation(
// // // //                   duration: const Duration(milliseconds: 300),
// // // //                   turns: _filterExpanded ? 0.125 : 0,
// // // //                   child: Icon(Icons.tune,
// // // //                       color: _filterExpanded ? Colors.white : _accent),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ════════════════════════════════════════════════════════════════
// // // //   // FILTER PANEL
// // // //   // ════════════════════════════════════════════════════════════════

// // // //   Widget _buildFilterPanel(PanelState s) {
// // // //     if (!_filterExpanded) {
// // // //       return const SliverToBoxAdapter(child: SizedBox.shrink());
// // // //     }
// // // //     return SliverToBoxAdapter(
// // // //       child: Container(
// // // //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// // // //         padding: const EdgeInsets.all(20),
// // // //         decoration: BoxDecoration(
// // // //           color: _card,
// // // //           borderRadius: BorderRadius.circular(20),
// // // //           border: Border.all(color: Colors.white.withAlpha(20)),
// // // //         ),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             _rangeSlider(
// // // //               label: 'Age',
// // // //               icon: Icons.cake,
// // // //               min: 18,
// // // //               max: 100,
// // // //               values: RangeValues(s.ageMin.toDouble(), s.ageMax.toDouble()),
// // // //               onChanged: (v) => ref.read(panelProvider.notifier).updateAge(v),
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             _rangeSlider(
// // // //               label: 'Height (ft)',
// // // //               icon: Icons.height,
// // // //               min: 0,
// // // //               max: 10,
// // // //               values: RangeValues(s.heightMin.toDouble(), s.heightMax.toDouble()),
// // // //               onChanged: (v) => ref.read(panelProvider.notifier).updateHeight(v),
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             _rangeSlider(
// // // //               label: 'Weight (Kg)',
// // // //               icon: Icons.monitor_weight_outlined,
// // // //               min: 20,
// // // //               max: 200,
// // // //               values: RangeValues(s.weightMin.toDouble(), s.weightMax.toDouble()),
// // // //               onChanged: (v) => ref.read(panelProvider.notifier).updateWeight(v),
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             const Text('Preferences',
// // // //                 style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
// // // //             const SizedBox(height: 10),
// // // //             Wrap(
// // // //               spacing: 8,
// // // //               runSpacing: 8,
// // // //               children: kPreferenceOptions.map((pref) {
// // // //                 final selected = s.selectedPreferences.contains(pref);
// // // //                 return GestureDetector(
// // // //                   onTap: () => ref.read(panelProvider.notifier).togglePreference(pref),
// // // //                   child: AnimatedContainer(
// // // //                     duration: const Duration(milliseconds: 200),
// // // //                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // // //                     decoration: BoxDecoration(
// // // //                       color: selected ? _accent : _surface,
// // // //                       borderRadius: BorderRadius.circular(20),
// // // //                       border: Border.all(color: selected ? _accent : Colors.white.withAlpha(30)),
// // // //                     ),
// // // //                     child: Row(
// // // //                       mainAxisSize: MainAxisSize.min,
// // // //                       children: [
// // // //                         Icon(selected ? Icons.check_circle : Icons.circle_outlined,
// // // //                             color: selected ? Colors.white : Colors.white.withAlpha(80), size: 16),
// // // //                         const SizedBox(width: 6),
// // // //                         Text(pref,
// // // //                             style: TextStyle(
// // // //                               color: selected ? Colors.white : Colors.white.withAlpha(120),
// // // //                               fontSize: 12,
// // // //                               fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
// // // //                             )),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 );
// // // //               }).toList(),
// // // //             ),
// // // //             const SizedBox(height: 20),
// // // //             SizedBox(
// // // //               width: double.infinity,
// // // //               height: 50,
// // // //               child: ElevatedButton.icon(
// // // //                 onPressed: () => ref.read(panelProvider.notifier).applyFilters(),
// // // //                 icon: const Icon(Icons.filter_list, color: Colors.white),
// // // //                 label: const Text('Apply Filters',
// // // //                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: _accent,
// // // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // //                   elevation: 4,
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _rangeSlider({
// // // //     required String label,
// // // //     required IconData icon,
// // // //     required double min,
// // // //     required double max,
// // // //     required RangeValues values,
// // // //     required ValueChanged<RangeValues> onChanged,
// // // //   }) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         Row(
// // // //           children: [
// // // //             Icon(icon, color: _gold, size: 16),
// // // //             const SizedBox(width: 8),
// // // //             Text(label,
// // // //                 style: const TextStyle(
// // // //                     color: Colors.white,
// // // //                     fontSize: 14,
// // // //                     fontWeight: FontWeight.w600)),
// // // //             const Spacer(),
// // // //             Text('${values.start.round()} – ${values.end.round()}',
// // // //                 style: TextStyle(color: _accent, fontSize: 13)),
// // // //           ],
// // // //         ),
// // // //         SliderTheme(
// // // //           data: SliderThemeData(
// // // //             activeTrackColor: _accent,
// // // //             inactiveTrackColor: Colors.white.withAlpha(30),
// // // //             thumbColor: _accent,
// // // //             overlayColor: _accent.withAlpha(30),
// // // //             rangeThumbShape:
// // // //                 const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
// // // //           ),
// // // //           child: RangeSlider(
// // // //             values: values,
// // // //             min: min,
// // // //             max: max,
// // // //             onChanged: onChanged,
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   // ════════════════════════════════════════════════════════════════
// // // //   // ALL USERS GRID  (flip-card style)
// // // //   // ════════════════════════════════════════════════════════════════

// // // //   Widget _buildUsersGrid(PanelState s) {
// // // //     final users = s.filteredUsers;

// // // //     if (users.isEmpty) {
// // // //       return SliverToBoxAdapter(
// // // //         child: Container(
// // // //           margin: const EdgeInsets.all(40),
// // // //           padding: const EdgeInsets.symmetric(vertical: 50),
// // // //           decoration: BoxDecoration(
// // // //             color: _card,
// // // //             borderRadius: BorderRadius.circular(24),
// // // //           ),
// // // //           child: Column(
// // // //             children: [
// // // //               Icon(Icons.search,
// // // //                   size: 60, color: Colors.white.withAlpha(40)),
// // // //               const SizedBox(height: 16),
// // // //               const Text('No Records Found',
// // // //                   style: TextStyle(
// // // //                       color: Colors.white,
// // // //                       fontSize: 18,
// // // //                       fontWeight: FontWeight.bold)),
// // // //               const SizedBox(height: 8),
// // // //               Text('Try adjusting your filters to find more results.',
// // // //                   style: TextStyle(
// // // //                       color: Colors.white.withAlpha(80), fontSize: 14)),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       );
// // // //     }

// // // //     return SliverPadding(
// // // //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
// // // //       sliver: SliverGrid(
// // // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // //           crossAxisCount: 2,
// // // //           mainAxisSpacing: 16,
// // // //           crossAxisSpacing: 16,
// // // //           childAspectRatio: 0.52,
// // // //         ),
// // // //         delegate: SliverChildBuilderDelegate(
// // // //           (context, index) => _FlipCardWidget(
// // // //             user: users[index],
// // // //             onViewMore: () => _navigateToUserProfile(users[index]),
// // // //             onCalendar: () => _showCalendarDialog(
// // // //                 users[index].id, users[index].username),
// // // //           ),
// // // //           childCount: users.length,
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ════════════════════════════════════════════════════════════════
// // // //   // CALENDAR DIALOG
// // // //   // ════════════════════════════════════════════════════════════════

// // // //   void _showCalendarDialog(String payPerId, String username) {
// // // //     showGeneralDialog(
// // // //       context: context,
// // // //       barrierDismissible: true,
// // // //       barrierLabel: 'Calendar',
// // // //       barrierColor: Colors.black87,
// // // //       transitionDuration: const Duration(milliseconds: 350),
// // // //       pageBuilder: (ctx, anim1, anim2) => Center(
// // // //         child: Material(
// // // //           color: Colors.transparent,
// // // //           child: Container(
// // // //             width: MediaQuery.of(ctx).size.width * 0.9,
// // // //             constraints: const BoxConstraints(maxHeight: 500),
// // // //             decoration: BoxDecoration(
// // // //               color: _card,
// // // //               borderRadius: BorderRadius.circular(24),
// // // //               border: Border.all(color: Colors.white.withAlpha(20)),
// // // //             ),
// // // //             child: Column(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 Container(
// // // //                   padding: const EdgeInsets.all(20),
// // // //                   decoration: const BoxDecoration(
// // // //                     gradient:
// // // //                         LinearGradient(colors: [_accent, Color(0xFF5C2438)]),
// // // //                     borderRadius: BorderRadius.vertical(
// // // //                         top: Radius.circular(24)),
// // // //                   ),
// // // //                   child: Row(
// // // //                     children: [
// // // //                       const Icon(Icons.calendar_month,
// // // //                           color: Colors.white, size: 24),
// // // //                       const SizedBox(width: 10),
// // // //                       const Expanded(
// // // //                         child: Text('Already Booked Slots',
// // // //                             style: TextStyle(
// // // //                                 color: Colors.white,
// // // //                                 fontSize: 18,
// // // //                                 fontWeight: FontWeight.bold)),
// // // //                       ),
// // // //                       IconButton(
// // // //                         icon: const Icon(Icons.close, color: Colors.white70),
// // // //                         onPressed: () => Navigator.pop(ctx),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 Padding(
// // // //                   padding: const EdgeInsets.all(16),
// // // //                   child: FutureBuilder<List<CalendarSlot>>(
// // // //                     future: ref
// // // //                         .read(panelProvider.notifier)
// // // //                         .fetchCalendar(payPerId),
// // // //                     builder: (ctx, snap) {
// // // //                       if (snap.connectionState == ConnectionState.waiting) {
// // // //                         return const Padding(
// // // //                           padding: EdgeInsets.all(30),
// // // //                           child: Center(
// // // //                               child:
// // // //                                   CircularProgressIndicator(color: _accent)),
// // // //                         );
// // // //                       }
// // // //                       final slots = snap.data ?? [];
// // // //                       if (slots.isEmpty) {
// // // //                         return const Padding(
// // // //                           padding: EdgeInsets.all(30),
// // // //                           child: Text('No record found…..',
// // // //                               style: TextStyle(color: Colors.white54)),
// // // //                         );
// // // //                       }
// // // //                       return Column(
// // // //                         children: slots.asMap().entries.map((entry) {
// // // //                           final i = entry.key;
// // // //                           final slot = entry.value;
// // // //                           return Container(
// // // //                             margin: const EdgeInsets.only(bottom: 10),
// // // //                             padding: const EdgeInsets.all(14),
// // // //                             decoration: BoxDecoration(
// // // //                               color: _surface,
// // // //                               borderRadius: BorderRadius.circular(14),
// // // //                               border: Border.all(
// // // //                                   color: Colors.white.withAlpha(15)),
// // // //                             ),
// // // //                             child: Row(
// // // //                               children: [
// // // //                                 Container(
// // // //                                   width: 32,
// // // //                                   height: 32,
// // // //                                   decoration: BoxDecoration(
// // // //                                     color: _accent.withAlpha(30),
// // // //                                     borderRadius: BorderRadius.circular(10),
// // // //                                   ),
// // // //                                   child: Center(
// // // //                                     child: Text('${i + 1}',
// // // //                                         style: const TextStyle(
// // // //                                             color: _accent,
// // // //                                             fontWeight: FontWeight.bold)),
// // // //                                   ),
// // // //                                 ),
// // // //                                 const SizedBox(width: 12),
// // // //                                 Expanded(
// // // //                                   child: Column(
// // // //                                     crossAxisAlignment:
// // // //                                         CrossAxisAlignment.start,
// // // //                                     children: [
// // // //                                       Text(slot.username,
// // // //                                           style: const TextStyle(
// // // //                                               color: Colors.white,
// // // //                                               fontWeight: FontWeight.w600,
// // // //                                               fontSize: 14)),
// // // //                                       const SizedBox(height: 4),
// // // //                                       Text(slot.calenderDate,
// // // //                                           style: TextStyle(
// // // //                                               color: _gold, fontSize: 12)),
// // // //                                     ],
// // // //                                   ),
// // // //                                 ),
// // // //                                 Column(
// // // //                                   crossAxisAlignment: CrossAxisAlignment.end,
// // // //                                   children: [
// // // //                                     Row(
// // // //                                       children: [
// // // //                                         Icon(Icons.play_arrow,
// // // //                                             color:
// // // //                                                 Colors.greenAccent.shade400,
// // // //                                             size: 14),
// // // //                                         const SizedBox(width: 4),
// // // //                                         Text(slot.startTime12Format,
// // // //                                             style: const TextStyle(
// // // //                                                 color: Colors.greenAccent,
// // // //                                                 fontSize: 12)),
// // // //                                       ],
// // // //                                     ),
// // // //                                     const SizedBox(height: 2),
// // // //                                     Row(
// // // //                                       children: [
// // // //                                         Icon(Icons.stop,
// // // //                                             color: Colors.redAccent.shade200,
// // // //                                             size: 14),
// // // //                                         const SizedBox(width: 4),
// // // //                                         Text(slot.endTime12Format,
// // // //                                             style: TextStyle(
// // // //                                                 color:
// // // //                                                     Colors.redAccent.shade200,
// // // //                                                 fontSize: 12)),
// // // //                                       ],
// // // //                                     ),
// // // //                                   ],
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                           );
// // // //                         }).toList(),
// // // //                       );
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       transitionBuilder: (ctx, anim1, anim2, child) =>
// // // //           ScaleTransition(scale: anim1, child: child),
// // // //     );
// // // //   }

// // // //   // ════════════════════════════════════════════════════════════════
// // // //   // NAVIGATE TO USER PROFILE
// // // //   // ════════════════════════════════════════════════════════════════

// // // //   void _navigateToUserProfile(ChocolateFactoryUser user) {
// // // //     // ── Uncomment after adding the imports at the top ──────────
// // // //     //
// // // //     // Navigator.push(
// // // //     //   context,
// // // //     //   MaterialPageRoute(
// // // //     //     builder: (_) => OtherUserProfilePage(
// // // //     //       user: UserListItem(
// // // //     //         id: user.id,
// // // //     //         name: user.username,
// // // //     //         imageUrl: user.profileImage,
// // // //     //         lastSeen: 'Offline',
// // // //     //         location: user.stateOfResidence,
// // // //     //         isOnline: false,
// // // //     //       ),
// // // //     //     ),
// // // //     //   ),
// // // //     // );
// // // //   }

// // // //   // ════════════════════════════════════════════════════════════════
// // // //   // NETWORK IMAGE HELPER
// // // //   // ════════════════════════════════════════════════════════════════

// // // //   Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
// // // //     if (url.isEmpty) {
// // // //       return Container(
// // // //         color: _surface,
// // // //         child: const Center(
// // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // //       );
// // // //     }
// // // //     String full = url;
// // // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // // //     return Image.network(
// // // //       full,
// // // //       fit: fit,
// // // //       errorBuilder: (_, __, ___) => Container(
// // // //         color: _surface,
// // // //         child: const Center(
// // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // //       ),
// // // //       loadingBuilder: (_, child, progress) {
// // // //         if (progress == null) return child;
// // // //         return Container(
// // // //           color: _surface,
// // // //           child: const Center(
// // // //             child: CircularProgressIndicator(
// // // //                 color: _accent, strokeWidth: 2),
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // // // ════════════════════════════════════════════════════════════════════
// // // // // FLIP CARD — tap to flip between front (image) and back (info)
// // // // // ════════════════════════════════════════════════════════════════════

// // // // class _FlipCardWidget extends StatefulWidget {
// // // //   final ChocolateFactoryUser user;
// // // //   final VoidCallback onViewMore;
// // // //   final VoidCallback onCalendar;

// // // //   const _FlipCardWidget({
// // // //     required this.user,
// // // //     required this.onViewMore,
// // // //     required this.onCalendar,
// // // //   });

// // // //   @override
// // // //   State<_FlipCardWidget> createState() => _FlipCardWidgetState();
// // // // }

// // // // class _FlipCardWidgetState extends State<_FlipCardWidget>
// // // //     with SingleTickerProviderStateMixin {
// // // //   late AnimationController _controller;
// // // //   late Animation<double> _animation;
// // // //   bool _showFront = true;

// // // //   static const _bg = Color(0xFF13132B);
// // // //   static const _accent = Color(0xFFE91E63);
// // // //   static const _surface = Color(0xFF1C1C3A);
// // // //   static const _gold = Color(0xFFF4BA4A);

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _controller = AnimationController(
// // // //       duration: const Duration(milliseconds: 600),
// // // //       vsync: this,
// // // //     );
// // // //     _animation = Tween<double>(begin: 0, end: 1).animate(
// // // //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
// // // //     );
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _controller.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   void _flip() {
// // // //     if (_showFront) {
// // // //       _controller.forward();
// // // //     } else {
// // // //       _controller.reverse();
// // // //     }
// // // //     setState(() => _showFront = !_showFront);
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final u = widget.user;
// // // //     return GestureDetector(
// // // //       onTap: _flip,
// // // //       child: AnimatedBuilder(
// // // //         animation: _animation,
// // // //         builder: (context, child) {
// // // //           final angle = _animation.value * 3.14159265;
// // // //           final isFront = angle < 1.5708;
// // // //           return Transform(
// // // //             alignment: Alignment.center,
// // // //             transform: Matrix4.identity()
// // // //               ..setEntry(3, 2, 0.001)
// // // //               ..rotateY(angle),
// // // //             child: isFront
// // // //                 ? _buildFront(u)
// // // //                 : Transform(
// // // //                     alignment: Alignment.center,
// // // //                     transform: Matrix4.identity()..rotateY(3.14159265),
// // // //                     child: _buildBack(u),
// // // //                   ),
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ── Front ──────────────────────────────────────────────────────

// // // //   Widget _buildFront(ChocolateFactoryUser u) {
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         borderRadius: BorderRadius.circular(20),
// // // //         color: _bg,
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.black.withAlpha(80),
// // // //             blurRadius: 15,
// // // //             offset: const Offset(0, 8),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Stack(
// // // //         children: [
// // // //           ClipRRect(
// // // //             borderRadius: BorderRadius.circular(20),
// // // //             child: SizedBox(
// // // //               width: double.infinity,
// // // //               height: double.infinity,
// // // //               child: _networkImg(u.profileImage),
// // // //             ),
// // // //           ),
// // // //           Positioned(
// // // //             top: 10,
// // // //             left: 10,
// // // //             child: Image.network(
// // // //               '${kAssetBase}img/badge1.png',
// // // //               width: 40,
// // // //               height: 40,
// // // //               errorBuilder: (_, __, ___) =>
// // // //                   const Icon(Icons.verified, color: _gold, size: 28),
// // // //             ),
// // // //           ),
// // // //           Positioned.fill(
// // // //             child: Container(
// // // //               decoration: BoxDecoration(
// // // //                 borderRadius: BorderRadius.circular(20),
// // // //                 gradient: LinearGradient(
// // // //                   begin: Alignment.topCenter,
// // // //                   end: Alignment.bottomCenter,
// // // //                   colors: [
// // // //                     Colors.transparent,
// // // //                     Colors.transparent,
// // // //                     Colors.black.withAlpha(200),
// // // //                   ],
// // // //                   stops: const [0.0, 0.5, 1.0],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //           Positioned(
// // // //             left: 14,
// // // //             bottom: 14,
// // // //             right: 14,
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 Text(u.username,
// // // //                     style: const TextStyle(
// // // //                         color: Colors.white,
// // // //                         fontSize: 16,
// // // //                         fontWeight: FontWeight.bold),
// // // //                     maxLines: 1,
// // // //                     overflow: TextOverflow.ellipsis),
// // // //                 if (u.showAge == '1')
// // // //                   Text('Age ${u.age}',
// // // //                       style: TextStyle(
// // // //                           color: Colors.white.withAlpha(180), fontSize: 12)),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ── Back ───────────────────────────────────────────────────────

// // // //   Widget _buildBack(ChocolateFactoryUser u) {
// // // //     return Container(
// // // //       decoration: const BoxDecoration(
// // // //         borderRadius: BorderRadius.all(Radius.circular(20)),
// // // //         gradient: LinearGradient(
// // // //           colors: [Color(0xFF560827), Color(0xFF06032C)],
// // // //         ),
// // // //       ),
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
// // // //         child: LayoutBuilder(
// // // //           builder: (context, constraints) {
// // // //             return SingleChildScrollView(
// // // //               physics: const NeverScrollableScrollPhysics(),
// // // //               child: ConstrainedBox(
// // // //                 constraints: BoxConstraints(
// // // //                   minHeight: constraints.maxHeight,
// // // //                 ),
// // // //                 child: IntrinsicHeight(
// // // //                   child: Column(
// // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // //                     children: [
// // // //                       FittedBox(
// // // //                         child: Text(u.username,
// // // //                             style: const TextStyle(
// // // //                                 color: Colors.white,
// // // //                                 fontSize: 18,
// // // //                                 fontWeight: FontWeight.bold),
// // // //                             textAlign: TextAlign.center,
// // // //                             maxLines: 1),
// // // //                       ),
// // // //                       if (u.stateOfResidence.isNotEmpty) ...[
// // // //                         const SizedBox(height: 3),
// // // //                         Text(u.stateOfResidence,
// // // //                             style: TextStyle(
// // // //                                 color: Colors.white.withAlpha(160),
// // // //                                 fontSize: 12),
// // // //                             maxLines: 1,
// // // //                             overflow: TextOverflow.ellipsis),
// // // //                       ],
// // // //                       const SizedBox(height: 10),
// // // //                       Wrap(
// // // //                         alignment: WrapAlignment.center,
// // // //                         spacing: 6,
// // // //                         runSpacing: 5,
// // // //                         children: [
// // // //                           if (u.showAge == '1') _backChip('${u.age} yrs'),
// // // //                           if (u.showHeight == '1')
// // // //                             _backChip("${u.heightFeet}' ${u.heightInch}\""),
// // // //                           if (u.showWeight == '1') _backChip('${u.weight} Kg'),
// // // //                         ],
// // // //                       ),
// // // //                       if (u.showPreferences == '1' &&
// // // //                           u.preferences.isNotEmpty) ...[
// // // //                         const SizedBox(height: 8),
// // // //                         Wrap(
// // // //                           spacing: 5,
// // // //                           runSpacing: 5,
// // // //                           alignment: WrapAlignment.center,
// // // //                           children: u.preferences.take(3).map((p) {
// // // //                             return Container(
// // // //                               padding: const EdgeInsets.symmetric(
// // // //                                   horizontal: 8, vertical: 4),
// // // //                               decoration: BoxDecoration(
// // // //                                 color: _accent.withAlpha(40),
// // // //                                 borderRadius: BorderRadius.circular(12),
// // // //                               ),
// // // //                               child: Text(p,
// // // //                                   style: const TextStyle(
// // // //                                       color: _accent, fontSize: 10)),
// // // //                             );
// // // //                           }).toList(),
// // // //                         ),
// // // //                       ],
// // // //                       const SizedBox(height: 12),
// // // //                       SizedBox(
// // // //                         width: double.infinity,
// // // //                         child: ElevatedButton(
// // // //                           onPressed: widget.onViewMore,
// // // //                           style: ElevatedButton.styleFrom(
// // // //                             backgroundColor: _accent,
// // // //                             foregroundColor: Colors.white,
// // // //                             shape: RoundedRectangleBorder(
// // // //                                 borderRadius: BorderRadius.circular(14)),
// // // //                             padding: const EdgeInsets.symmetric(vertical: 9),
// // // //                           ),
// // // //                           child: const Text('View More',
// // // //                               style: TextStyle(
// // // //                                   fontWeight: FontWeight.bold, fontSize: 13)),
// // // //                         ),
// // // //                       ),
// // // //                       const SizedBox(height: 6),
// // // //                       GestureDetector(
// // // //                         onTap: widget.onCalendar,
// // // //                         child: Container(
// // // //                           padding: const EdgeInsets.symmetric(vertical: 8),
// // // //                           decoration: BoxDecoration(
// // // //                             border: Border.all(color: _gold.withAlpha(80)),
// // // //                             borderRadius: BorderRadius.circular(14),
// // // //                           ),
// // // //                           child: const Row(
// // // //                             mainAxisAlignment: MainAxisAlignment.center,
// // // //                             mainAxisSize: MainAxisSize.min,
// // // //                             children: [
// // // //                               Icon(Icons.calendar_today,
// // // //                                   color: _gold, size: 15),
// // // //                               SizedBox(width: 5),
// // // //                               Text('Calendar',
// // // //                                   style: TextStyle(
// // // //                                       color: _gold, fontSize: 12)),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             );
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _backChip(String text) {
// // // //     return Container(
// // // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white.withAlpha(15),
// // // //         borderRadius: BorderRadius.circular(10),
// // // //       ),
// // // //       child: Text(text,
// // // //           style: const TextStyle(color: Colors.white, fontSize: 11)),
// // // //     );
// // // //   }

// // // //   Widget _networkImg(String url) {
// // // //     if (url.isEmpty) {
// // // //       return Container(
// // // //         color: _surface,
// // // //         child: const Center(
// // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // //       );
// // // //     }
// // // //     String full = url;
// // // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // // //     return Image.network(
// // // //       full,
// // // //       fit: BoxFit.cover,
// // // //       errorBuilder: (_, __, ___) => Container(
// // // //         color: _surface,
// // // //         child: const Center(
// // // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // // //       ),
// // // //       loadingBuilder: (_, child, progress) {
// // // //         if (progress == null) return child;
// // // //         return Container(
// // // //           color: _surface,
// // // //           child: const Center(
// // // //             child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }


// // // // ╔═══════════════════════════════════════════════════════════════════╗
// // // // ║  Celebrity Panel – Pay-Per-Click (Chocolate Factory)            ║
// // // // ║  Single self-contained file — paste into your existing project  ║
// // // // ║  API: https://app.beatflirtevent.com/App                        ║
// // // // ║  Auth: Access-Token + Access-Sign headers (from sessionStorage) ║
// // // // ╚═══════════════════════════════════════════════════════════════════╝

// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:http/http.dart' as http;

// // // // ── Uncomment these for your existing project navigation ─────────
// // // // import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// // // // import 'package:beatflirt/providers/user_list_provider.dart';

// // // // ════════════════════════════════════════════════════════════════════
// // // // 1)  A P I   C O N S T A N T S
// // // // ════════════════════════════════════════════════════════════════════

// // // const String kApiBase = 'https://app.beatflirtevent.com/App';
// // // const String kAssetBase = 'https://app.beatflirtevent.com/assets/';

// // // const List<String> kPreferenceOptions = [
// // //   'Orgy',
// // //   'Gang Bang',
// // //   'Couple',
// // //   'BDSM',
// // //   'Dom',
// // //   'Sub',
// // //   'Cuckolder',
// // //   'Bull Stag',
// // // ];

// // // // ════════════════════════════════════════════════════════════════════
// // // // 2)  D A T A   M O D E L S
// // // // ════════════════════════════════════════════════════════════════════

// // // class ChocolateFactoryUser {
// // //   final String id;
// // //   final String username;
// // //   final String age;
// // //   final String showAge;
// // //   final String stateOfResidence;
// // //   final String heightFeet;
// // //   final String heightInch;
// // //   final String showHeight;
// // //   final String weight;
// // //   final String showWeight;
// // //   final List<String> preferences;
// // //   final String showPreferences;
// // //   final String selfDescription;
// // //   final List<ChocolateFactoryImage> images;

// // //   const ChocolateFactoryUser({
// // //     required this.id,
// // //     required this.username,
// // //     required this.age,
// // //     required this.showAge,
// // //     required this.stateOfResidence,
// // //     required this.heightFeet,
// // //     required this.heightInch,
// // //     required this.showHeight,
// // //     required this.weight,
// // //     required this.showWeight,
// // //     required this.preferences,
// // //     required this.showPreferences,
// // //     required this.selfDescription,
// // //     required this.images,
// // //   });

// // //   String get profileImage =>
// // //       images.isNotEmpty ? images.first.profileImage : '';

// // //   String get displayHeight => "${heightFeet}' ${heightInch}\"";

// // //   factory ChocolateFactoryUser.fromJson(Map<String, dynamic> j) {
// // //     return ChocolateFactoryUser(
// // //       id: '${j['id'] ?? ''}',
// // //       username: '${j['username'] ?? ''}',
// // //       age: '${j['age'] ?? ''}',
// // //       showAge: '${j['show_age'] ?? '0'}',
// // //       stateOfResidence: '${j['state_of_residence'] ?? ''}',
// // //       heightFeet: '${j['height_feet'] ?? ''}',
// // //       heightInch: '${j['height_inch'] ?? ''}',
// // //       showHeight: '${j['show_height'] ?? '0'}',
// // //       weight: '${j['weight'] ?? ''}',
// // //       showWeight: '${j['show_weight'] ?? '0'}',
// // //       preferences:
// // //           (j['preferences'] as List<dynamic>?)
// // //               ?.map((e) => '$e')
// // //               .toList() ?? [],
// // //       showPreferences: '${j['show_preferences'] ?? '0'}',
// // //       selfDescription: '${j['self_description'] ?? ''}',
// // //       images:
// // //           (j['image'] as List<dynamic>?)
// // //               ?.map((e) => ChocolateFactoryImage.fromJson(e))
// // //               .toList() ?? [],
// // //     );
// // //   }
// // // }

// // // class ChocolateFactoryImage {
// // //   final String profileImage;
// // //   const ChocolateFactoryImage({required this.profileImage});
// // //   factory ChocolateFactoryImage.fromJson(Map<String, dynamic> j) =>
// // //       ChocolateFactoryImage(profileImage: '${j['profile_image'] ?? ''}');
// // // }

// // // class CalendarSlot {
// // //   final String username;
// // //   final String calenderDate;
// // //   final String startTime12Format;
// // //   final String endTime12Format;
// // //   const CalendarSlot({
// // //     required this.username,
// // //     required this.calenderDate,
// // //     required this.startTime12Format,
// // //     required this.endTime12Format,
// // //   });
// // //   factory CalendarSlot.fromJson(Map<String, dynamic> j) => CalendarSlot(
// // //         username: '${j['username'] ?? ''}',
// // //         calenderDate: '${j['calender_date'] ?? ''}',
// // //         startTime12Format: '${j['start_time_12_formate'] ?? ''}',
// // //         endTime12Format: '${j['end_time_12_formate'] ?? ''}',
// // //       );
// // // }

// // // class TermsCondition {
// // //   final String description;
// // //   const TermsCondition({required this.description});
// // //   factory TermsCondition.fromJson(Map<String, dynamic> j) =>
// // //       TermsCondition(description: '${j['description'] ?? ''}');
// // // }

// // // // ════════════════════════════════════════════════════════════════════
// // // // 3)  S T A T E
// // // // ════════════════════════════════════════════════════════════════════

// // // class PanelState {
// // //   final bool isLoading;
// // //   final String? error;
// // //   final ChocolateFactoryUser? myProfile;
// // //   final List<ChocolateFactoryUser> allUsers;
// // //   final String searchQuery;
// // //   final int ageMin;
// // //   final int ageMax;
// // //   final int heightMin;
// // //   final int heightMax;
// // //   final int weightMin;
// // //   final int weightMax;
// // //   final List<String> selectedPreferences;

// // //   const PanelState({
// // //     this.isLoading = false,
// // //     this.error,
// // //     this.myProfile,
// // //     this.allUsers = const [],
// // //     this.searchQuery = '',
// // //     this.ageMin = 18,
// // //     this.ageMax = 80,
// // //     this.heightMin = 3,
// // //     this.heightMax = 8,
// // //     this.weightMin = 20,
// // //     this.weightMax = 150,
// // //     this.selectedPreferences = const [],
// // //   });

// // //   PanelState copyWith({
// // //     bool? isLoading,
// // //     String? error,
// // //     ChocolateFactoryUser? myProfile,
// // //     List<ChocolateFactoryUser>? allUsers,
// // //     String? searchQuery,
// // //     int? ageMin,
// // //     int? ageMax,
// // //     int? heightMin,
// // //     int? heightMax,
// // //     int? weightMin,
// // //     int? weightMax,
// // //     List<String>? selectedPreferences,
// // //   }) {
// // //     return PanelState(
// // //       isLoading: isLoading ?? this.isLoading,
// // //       error: error,
// // //       myProfile: myProfile ?? this.myProfile,
// // //       allUsers: allUsers ?? this.allUsers,
// // //       searchQuery: searchQuery ?? this.searchQuery,
// // //       ageMin: ageMin ?? this.ageMin,
// // //       ageMax: ageMax ?? this.ageMax,
// // //       heightMin: heightMin ?? this.heightMin,
// // //       heightMax: heightMax ?? this.heightMax,
// // //       weightMin: weightMin ?? this.weightMin,
// // //       weightMax: weightMax ?? this.weightMax,
// // //       selectedPreferences: selectedPreferences ?? this.selectedPreferences,
// // //     );
// // //   }

// // //   List<ChocolateFactoryUser> get filteredUsers {
// // //     var list = allUsers;
// // //     if (searchQuery.isNotEmpty) {
// // //       list = list
// // //           .where((u) =>
// // //               u.username.toLowerCase().contains(searchQuery.toLowerCase()))
// // //           .toList();
// // //     }
// // //     return list;
// // //   }
// // // }

// // // // ════════════════════════════════════════════════════════════════════
// // // // 4)  N O T I F I E R   (API calls + state)
// // // // ════════════════════════════════════════════════════════════════════

// // // class PanelNotifier extends StateNotifier<PanelState> {
// // //   String? _accessToken;
// // //   String? _accessSign;

// // //   PanelNotifier() : super(const PanelState()) {
// // //     _loadToken();
// // //   }

// // //   // ── Load auth credentials ─────────────────────────────────────
// // //   //
// // //   // The web app stores them in sessionStorage / localStorage as:
// // //   //   "Access-Token"  →  sent as header  Access-Token
// // //   //   "Access-Sign"   →  sent as header  Access-Sign
// // //   //
// // //   // The Flutter app likely stores them in SharedPreferences with the
// // //   // same keys, or lower-case variants.  We try both.

// // //   Future<void> _loadToken() async {
// // //     final prefs = await SharedPreferences.getInstance();

// // //     // ── DEBUG: Print ALL SharedPreferences keys to find the real ones ──
// // //     debugPrint('═══ CelebrityPanel — ALL SharedPreferences Keys ═══');
// // //     final allKeys = prefs.getKeys();
// // //     for (final key in allKeys) {
// // //       final val = prefs.get(key);
// // //       final valStr = val.toString();
// // //       final preview = valStr.length > 40 ? '${valStr.substring(0, 40)}...' : valStr;
// // //       debugPrint('  KEY: "$key" → $preview');
// // //     }
// // //     debugPrint('════════════════════════════════════════════════════');

// // //     // Try every possible key variant for Access-Token
// // //     _accessToken = prefs.getString('Access-Token') //
// // //         ?? prefs.getString('access_token')
// // //         ?? prefs.getString('accessToken')
// // //         ?? prefs.getString('token')
// // //         ?? prefs.getString('auth_token')
// // //         ?? prefs.getString('access_token_key')
// // //         ?? prefs.getString('user_token');

// // //     // Try every possible key variant for Access-Sign
// // //     _accessSign = prefs.getString('Access-Sign') //
// // //         ?? prefs.getString('access_sign')
// // //         ?? prefs.getString('accessSign')
// // //         ?? prefs.getString('sign')
// // //         ?? prefs.getString('Access_Sign')
// // //         ?? prefs.getString('access-sign')
// // //         ?? prefs.getString('sign_key')
// // //         ?? prefs.getString('user_sign')
// // //         ?? prefs.getString('secret')
// // //         ?? prefs.getString('secret_key')
// // //         ?? prefs.getString('user_secret');

// // //     debugPrint('═══ CelebrityPanel ═══');
// // //     debugPrint('  Access-Token : ${_accessToken != null ? "${_accessToken!.substring(0, _accessToken!.length > 20 ? 20 : _accessToken!.length)}..." : "NULL"}');
// // //     debugPrint('  Access-Sign  : ${_accessSign != null ? "${_accessSign!.substring(0, _accessSign!.length > 20 ? 20 : _accessSign!.length)}..." : "NULL"}');
// // //     debugPrint('═══════════════════════');

// // //     fetchPanel();
// // //   }

// // //   // ── HTTP helpers ──────────────────────────────────────────────
// // //   //
// // //   //  The web's callapi.setHeaders() builds:
// // //   //    { "Content-Type":"application/json; charset=UTF-8",
// // //   //      "Access-Token":"<token>",  "Access-Sign":"<sign>" }
// // //   //
// // //   //  NOT  Authorization: Bearer ...  ← this was the bug!

// // //   Map<String, String> get _headers => {
// // //         'Content-Type': 'application/json; charset=UTF-8',
// // //         if (_accessToken != null && _accessToken!.isNotEmpty)
// // //           'Access-Token': _accessToken!,
// // //         if (_accessSign != null && _accessSign!.isNotEmpty)
// // //           'Access-Sign': _accessSign!,
// // //       };

// // //   Future<Map<String, dynamic>?> _post(
// // //       String path, Map<String, dynamic> body) async {
// // //     try {
// // //       final uri = Uri.parse('$kApiBase$path');
// // //       debugPrint('POST $uri  headers=$_headers');
// // //       final r = await http.post(uri, headers: _headers, body: jsonEncode(body));
// // //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// // //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // //       }
// // //       return null;
// // //     } catch (e) {
// // //       debugPrint('  → ERROR $e');
// // //       return null;
// // //     }
// // //   }

// // //   Future<Map<String, dynamic>?> _get(String path) async {
// // //     try {
// // //       final uri = Uri.parse('$kApiBase$path');
// // //       debugPrint('GET $uri  headers=$_headers');
// // //       final r = await http.get(uri, headers: _headers);
// // //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// // //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// // //         return jsonDecode(r.body) as Map<String, dynamic>;
// // //       }
// // //       return null;
// // //     } catch (e) {
// // //       debugPrint('  → ERROR $e');
// // //       return null;
// // //     }
// // //   }

// // //   // ── Helper: check status as int or string ─────────────────────
// // //   //  Web API sometimes returns {"status":200} (int)
// // //   //  and sometimes {"status":"404"} (string).
// // //   //  JavaScript == coerces both, but Dart's == does NOT.

// // //   bool _isOk(Map<String, dynamic>? r) {
// // //     if (r == null) return false;
// // //     final s = r['status'];
// // //     return s != null && s.toString() == '200';
// // //   }

// // //   // ── Main data fetch ───────────────────────────────────────────

// // //   Future<void> fetchPanel() async {
// // //     state = state.copyWith(isLoading: true, error: null);
// // //     try {
// // //       final results = await Future.wait([
// // //         _post('/payperclick/get_chocolate_factory_data', {'user_type': 'me'}),
// // //         _post('/payperclick/get_all_chocolate_factory_data', {
// // //           'age_minvalue': state.ageMin,
// // //           'age_maxvalue': state.ageMax,
// // //           'height_minvalue': state.heightMin,
// // //           'height_maxvalue': state.heightMax,
// // //           'weight_minvalue': state.weightMin,
// // //           'weight_maxvalue': state.weightMax,
// // //           'preferencesArray': state.selectedPreferences,
// // //         }),
// // //       ]);

// // //       ChocolateFactoryUser? myProfile;
// // //       final me = results[0];
// // //       if (_isOk(me)) {
// // //         final d = me!['data'];
// // //         if (d is List && d.isNotEmpty) {
// // //           myProfile = ChocolateFactoryUser.fromJson(d[0]);
// // //         }
// // //       }

// // //       List<ChocolateFactoryUser> allUsers = [];
// // //       final all = results[1];
// // //       if (_isOk(all)) {
// // //         final d = all!['data'];
// // //         if (d is List) {
// // //           allUsers = d.map((e) => ChocolateFactoryUser.fromJson(e)).toList();
// // //         }
// // //       }

// // //       debugPrint('  myProfile: ${myProfile?.username ?? "null"}');
// // //       debugPrint('  allUsers count: ${allUsers.length}');

// // //       state = state.copyWith(
// // //         isLoading: false,
// // //         myProfile: myProfile,
// // //         allUsers: allUsers,
// // //       );
// // //     } catch (e) {
// // //       debugPrint('  fetchPanel ERROR: $e');
// // //       state = state.copyWith(isLoading: false, error: e.toString());
// // //     }
// // //   }

// // //   // ── Filters ───────────────────────────────────────────────────

// // //   Future<void> applyFilters() => fetchPanel();

// // //   void updateAge(RangeValues v) =>
// // //       state = state.copyWith(ageMin: v.start.round(), ageMax: v.end.round());
// // //   void updateHeight(RangeValues v) => state = state.copyWith(
// // //       heightMin: v.start.round(), heightMax: v.end.round());
// // //   void updateWeight(RangeValues v) => state = state.copyWith(
// // //       weightMin: v.start.round(), weightMax: v.end.round());

// // //   void togglePreference(String pref) {
// // //     final list = [...state.selectedPreferences];
// // //     if (list.contains(pref)) {
// // //       list.remove(pref);
// // //     } else {
// // //       list.add(pref);
// // //     }
// // //     state = state.copyWith(selectedPreferences: list);
// // //   }

// // //   void setSearch(String q) => state = state.copyWith(searchQuery: q);

// // //   // ── Calendar ──────────────────────────────────────────────────

// // //   Future<List<CalendarSlot>> fetchCalendar(String payPerId) async {
// // //     final r = await _post('/payperclick/get_user_calender_details', {
// // //       'pay_per_id': payPerId,
// // //     });
// // //     if (_isOk(r)) {
// // //       final d = r!['data'];
// // //       if (d is List) return d.map((e) => CalendarSlot.fromJson(e)).toList();
// // //     }
// // //     return [];
// // //   }

// // //   // ── Terms ─────────────────────────────────────────────────────

// // //   Future<TermsCondition?> fetchTerms() async {
// // //     final r = await _get('/auth/pay_per_click_terms_condition');
// // //     if (_isOk(r)) {
// // //       final d = r!['data'];
// // //       if (d is List && d.isNotEmpty) return TermsCondition.fromJson(d[0]);
// // //     }
// // //     return null;
// // //   }

// // //   // ── Check flags ───────────────────────────────────────────────

// // //   Future<bool> checkPost() async {
// // //     final r = await _get('/payperclick/check_chocolate_factory_post');
// // //     return _isOk(r);
// // //   }

// // //   Future<bool> checkPopup() async {
// // //     final r = await _get('/payperclick/check_chocolate_factory_popup');
// // //     return _isOk(r);
// // //   }
// // // }

// // // // ════════════════════════════════════════════════════════════════════
// // // // 5)  P R O V I D E R
// // // // ════════════════════════════════════════════════════════════════════

// // // final panelProvider =
// // //     StateNotifierProvider.autoDispose<PanelNotifier, PanelState>(
// // //   (ref) => PanelNotifier(),
// // // );

// // // // ════════════════════════════════════════════════════════════════════
// // // // 6)  M A I N   P A G E   W I D G E T
// // // // ════════════════════════════════════════════════════════════════════

// // // class CelebrityPanelPage extends ConsumerStatefulWidget {
// // //   const CelebrityPanelPage({super.key});

// // //   @override
// // //   ConsumerState<CelebrityPanelPage> createState() => _CelebrityPanelPageState();
// // // }

// // // class _CelebrityPanelPageState extends ConsumerState<CelebrityPanelPage>
// // //     with TickerProviderStateMixin {
// // //   final TextEditingController _searchCtrl = TextEditingController();
// // //   bool _filterExpanded = false;

// // //   // ── Colour palette ────────────────────────────────────────────
// // //   static const _bg = Color(0xFF0B0B1A);
// // //   static const _card = Color(0xFF13132B);
// // //   static const _accent = Color(0xFFE91E63);
// // //   static const _gold = Color(0xFFF4BA4A);
// // //   static const _surface = Color(0xFF1C1C3A);

// // //   @override
// // //   void dispose() {
// // //     _searchCtrl.dispose();
// // //     super.dispose();
// // //   }

// // //   // ════════════════════════════════════════════════════════════════
// // //   // BUILD
// // //   // ════════════════════════════════════════════════════════════════

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final s = ref.watch(panelProvider);

// // //     return Scaffold(
// // //       backgroundColor: _bg,
// // //       body: CustomScrollView(
// // //         physics: const BouncingScrollPhysics(),
// // //         slivers: [
// // //           // ── App Bar (no notification icon) ────────────────────
// // //           SliverAppBar(
// // //             leading: IconButton(
// // //               icon: const Icon(Icons.arrow_back_ios_new,
// // //                   color: Colors.white, size: 20),
// // //               onPressed: () => Navigator.pop(context),
// // //             ),
// // //             expandedHeight: 130,
// // //             floating: false,
// // //             pinned: true,
// // //             backgroundColor: _bg,
// // //             elevation: 0,
// // //             flexibleSpace: LayoutBuilder(
// // //               builder: (context, constraints) {
// // //                 final top = MediaQuery.of(context).padding.top;
// // //                 final collapsed = kToolbarHeight + top;
// // //                 final isCollapsed = constraints.maxHeight <= collapsed + 10;
// // //                 return FlexibleSpaceBar(
// // //                   centerTitle: false,
// // //                   titlePadding: EdgeInsets.only(
// // //                     left: isCollapsed ? 50 : 20,
// // //                     bottom: 14,
// // //                   ),
// // //                   title: const Text(
// // //                     'Celebrity Panel',
// // //                     style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontWeight: FontWeight.bold,
// // //                       fontSize: 20,
// // //                     ),
// // //                   ),
// // //                   background: Container(
// // //                     decoration: const BoxDecoration(
// // //                       gradient: LinearGradient(
// // //                         begin: Alignment.topCenter,
// // //                         end: Alignment.bottomCenter,
// // //                         colors: [_accent, _bg],
// // //                         stops: [0.0, 0.8],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //           ),

// // //           // ── Loading ───────────────────────────────────────────
// // //           if (s.isLoading)
// // //             const SliverFillRemaining(
// // //               child: Center(child: CircularProgressIndicator(color: _accent)),
// // //             )

// // //           // ── Error ─────────────────────────────────────────────
// // //           else if (s.error != null && s.allUsers.isEmpty)
// // //             SliverFillRemaining(
// // //               child: Center(
// // //                 child: Column(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     const Icon(Icons.error_outline,
// // //                         color: Colors.white24, size: 48),
// // //                     const SizedBox(height: 16),
// // //                     Text('Failed to load celebrities',
// // //                         style: TextStyle(color: Colors.white.withAlpha(153))),
// // //                     const SizedBox(height: 8),
// // //                     Text(s.error ?? '',
// // //                         style: TextStyle(color: Colors.white38, fontSize: 12),
// // //                         textAlign: TextAlign.center),
// // //                     const SizedBox(height: 12),
// // //                     TextButton(
// // //                       onPressed: () =>
// // //                           ref.read(panelProvider.notifier).fetchPanel(),
// // //                       child: const Text('Retry',
// // //                           style: TextStyle(color: _accent)),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             )

// // //           // ── Content ───────────────────────────────────────────
// // //           else ...[
// // //             if (s.myProfile != null) _buildMyProfileCard(s.myProfile!),
// // //             _buildSearchBar(),
// // //             _buildFilterPanel(s),
// // //             _buildUsersGrid(s),
// // //             const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
// // //           ],
// // //         ],
// // //       ),
// // //       // ── NO FAB (removed) ──────────────────────────────────────
// // //     );
// // //   }

// // //   // ════════════════════════════════════════════════════════════════
// // //   // MY PROFILE CARD
// // //   // ════════════════════════════════════════════════════════════════

// // //   Widget _buildMyProfileCard(ChocolateFactoryUser u) {
// // //     return SliverToBoxAdapter(
// // //       child: Container(
// // //         margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
// // //         decoration: BoxDecoration(
// // //           color: _card,
// // //           borderRadius: BorderRadius.circular(24),
// // //           border: Border.all(color: Colors.white.withAlpha(25)),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: _accent.withAlpha(40),
// // //               blurRadius: 30,
// // //               offset: const Offset(0, 10),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           children: [
// // //             // ── Image ─────────────────────────────────────────
// // //             SizedBox(
// // //               height: 220,
// // //               child: Stack(
// // //                 children: [
// // //                   ClipRRect(
// // //                     borderRadius: const BorderRadius.vertical(
// // //                         top: Radius.circular(24)),
// // //                     child: SizedBox(
// // //                       width: double.infinity,
// // //                       child: _networkImage(u.profileImage, fit: BoxFit.cover),
// // //                     ),
// // //                   ),
// // //                   // Badge
// // //                   Positioned(
// // //                     top: 12,
// // //                     left: 12,
// // //                     child: Container(
// // //                       padding: const EdgeInsets.all(8),
// // //                       decoration: BoxDecoration(
// // //                         color: _accent.withAlpha(200),
// // //                         borderRadius: BorderRadius.circular(12),
// // //                       ),
// // //                       child: Image.network(
// // //                         '${kAssetBase}img/badge1.png',
// // //                         width: 40,
// // //                         height: 40,
// // //                         errorBuilder: (_, __, ___) =>
// // //                             const Icon(Icons.verified, color: Colors.white),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   // Edit button
// // //                   Positioned(
// // //                     top: 12,
// // //                     right: 12,
// // //                     child: GestureDetector(
// // //                       onTap: () {},
// // //                       child: Container(
// // //                         padding: const EdgeInsets.symmetric(
// // //                             horizontal: 14, vertical: 8),
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.black.withAlpha(150),
// // //                           borderRadius: BorderRadius.circular(20),
// // //                           border: Border.all(
// // //                               color: Colors.white.withAlpha(60)),
// // //                         ),
// // //                         child: const Row(
// // //                           mainAxisSize: MainAxisSize.min,
// // //                           children: [
// // //                             Icon(Icons.edit, color: Colors.white, size: 14),
// // //                             SizedBox(width: 4),
// // //                             Text('Edit Profile',
// // //                                 style: TextStyle(
// // //                                     color: Colors.white,
// // //                                     fontSize: 12,
// // //                                     fontWeight: FontWeight.w600)),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   // Gradient
// // //                   Positioned.fill(
// // //                     child: Container(
// // //                       decoration: BoxDecoration(
// // //                         borderRadius: const BorderRadius.vertical(
// // //                             top: Radius.circular(24)),
// // //                         gradient: LinearGradient(
// // //                           begin: Alignment.topCenter,
// // //                           end: Alignment.bottomCenter,
// // //                           colors: [
// // //                             Colors.transparent,
// // //                             Colors.black.withAlpha(180),
// // //                           ],
// // //                           stops: const [0.5, 1.0],
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   // Name + age
// // //                   Positioned(
// // //                     left: 16,
// // //                     bottom: 16,
// // //                     right: 16,
// // //                     child: Row(
// // //                       children: [
// // //                         Flexible(
// // //                           child: Text(u.username,
// // //                               style: const TextStyle(
// // //                                   color: Colors.white,
// // //                                   fontSize: 22,
// // //                                   fontWeight: FontWeight.bold),
// // //                               maxLines: 1,
// // //                               overflow: TextOverflow.ellipsis),
// // //                         ),
// // //                         if (u.showAge == '1') ...[
// // //                           const SizedBox(width: 8),
// // //                           Text('Age ${u.age}',
// // //                               style: TextStyle(
// // //                                   color: Colors.white.withAlpha(200),
// // //                                   fontSize: 14)),
// // //                         ],
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),

// // //             // ── Info ───────────────────────────────────────────
// // //             Padding(
// // //               padding: const EdgeInsets.all(20),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   // Location
// // //                   Row(
// // //                     children: [
// // //                       const Icon(Icons.location_on, color: _accent, size: 16),
// // //                       const SizedBox(width: 6),
// // //                       Text(u.stateOfResidence,
// // //                           style: TextStyle(
// // //                               color: Colors.white.withAlpha(180),
// // //                               fontSize: 14)),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 14),

// // //                   // Stats
// // //                   Row(
// // //                     children: [
// // //                       if (u.showHeight == '1')
// // //                         _statChip(Icons.height, u.displayHeight),
// // //                       if (u.showHeight == '1') const SizedBox(width: 12),
// // //                       if (u.showWeight == '1')
// // //                         _statChip(
// // //                             Icons.monitor_weight_outlined, '${u.weight} Kg'),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 14),

// // //                   // Preferences
// // //                   if (u.showPreferences == '1' &&
// // //                       u.preferences.isNotEmpty) ...[
// // //                     const Text('Preferences',
// // //                         style: TextStyle(
// // //                             color: Colors.white,
// // //                             fontSize: 14,
// // //                             fontWeight: FontWeight.w600)),
// // //                     const SizedBox(height: 8),
// // //                     Wrap(
// // //                       spacing: 8,
// // //                       runSpacing: 8,
// // //                       children: u.preferences
// // //                           .map((p) => Container(
// // //                                 padding: const EdgeInsets.symmetric(
// // //                                     horizontal: 12, vertical: 6),
// // //                                 decoration: BoxDecoration(
// // //                                   color: _accent.withAlpha(30),
// // //                                   borderRadius: BorderRadius.circular(20),
// // //                                   border: Border.all(
// // //                                       color: _accent.withAlpha(80)),
// // //                                 ),
// // //                                 child: Text(p,
// // //                                     style: const TextStyle(
// // //                                         color: _accent, fontSize: 12)),
// // //                               ))
// // //                           .toList(),
// // //                     ),
// // //                     const SizedBox(height: 14),
// // //                   ],

// // //                   // Calendar + Review
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: GestureDetector(
// // //                           onTap: () =>
// // //                               _showCalendarDialog(u.id, u.username),
// // //                           child: Container(
// // //                             padding: const EdgeInsets.symmetric(vertical: 12),
// // //                             decoration: BoxDecoration(
// // //                               color: _surface,
// // //                               borderRadius: BorderRadius.circular(14),
// // //                               border: Border.all(
// // //                                   color: Colors.white.withAlpha(20)),
// // //                             ),
// // //                             child: const Row(
// // //                               mainAxisAlignment: MainAxisAlignment.center,
// // //                               children: [
// // //                                 Icon(Icons.calendar_month,
// // //                                     color: _gold, size: 18),
// // //                                 SizedBox(width: 8),
// // //                                 Flexible(
// // //                                   child: Text('Calendar',
// // //                                       style: TextStyle(
// // //                                           color: Colors.white,
// // //                                           fontSize: 13,
// // //                                           fontWeight: FontWeight.w600),
// // //                                       overflow: TextOverflow.ellipsis),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 10),
// // //                       Flexible(
// // //                         child: GestureDetector(
// // //                           onTap: () {},
// // //                           child: Container(
// // //                             padding: const EdgeInsets.symmetric(
// // //                                 horizontal: 16, vertical: 12),
// // //                             decoration: BoxDecoration(
// // //                               color: _accent.withAlpha(20),
// // //                               borderRadius: BorderRadius.circular(14),
// // //                               border:
// // //                                   Border.all(color: _accent.withAlpha(60)),
// // //                             ),
// // //                             child: const Row(
// // //                               mainAxisAlignment: MainAxisAlignment.center,
// // //                               mainAxisSize: MainAxisSize.min,
// // //                               children: [
// // //                                 Icon(Icons.rate_review,
// // //                                     color: _accent, size: 16),
// // //                                 SizedBox(width: 6),
// // //                                 Flexible(
// // //                                   child: Text('Write Review',
// // //                                       style: TextStyle(
// // //                                           color: _accent, fontSize: 13),
// // //                                       overflow: TextOverflow.ellipsis),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 14),

// // //                   // Description
// // //                   if (u.selfDescription.isNotEmpty) ...[
// // //                     Text('Description',
// // //                         style: TextStyle(
// // //                             color: Colors.white.withAlpha(150),
// // //                             fontSize: 12,
// // //                             fontWeight: FontWeight.w600)),
// // //                     const SizedBox(height: 6),
// // //                     Text(u.selfDescription,
// // //                         style: TextStyle(
// // //                             color: Colors.white.withAlpha(120),
// // //                             fontSize: 13,
// // //                             height: 1.5),
// // //                         maxLines: 4,
// // //                         overflow: TextOverflow.ellipsis),
// // //                   ],
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _statChip(IconData icon, String label) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // //       decoration: BoxDecoration(
// // //         color: _surface,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.white.withAlpha(20)),
// // //       ),
// // //       child: Row(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Icon(icon, color: _gold, size: 16),
// // //           const SizedBox(width: 6),
// // //           Text(label,
// // //               style: const TextStyle(color: Colors.white, fontSize: 13)),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ════════════════════════════════════════════════════════════════
// // //   // SEARCH BAR
// // //   // ════════════════════════════════════════════════════════════════

// // //   Widget _buildSearchBar() {
// // //     return SliverToBoxAdapter(
// // //       child: Padding(
// // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // //         child: Row(
// // //           children: [
// // //             Expanded(
// // //               child: Container(
// // //                 height: 50,
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.white.withAlpha(15),
// // //                   borderRadius: BorderRadius.circular(15),
// // //                 ),
// // //                 child: TextField(
// // //                   controller: _searchCtrl,
// // //                   style: const TextStyle(color: Colors.white),
// // //                   onChanged: (v) =>
// // //                       ref.read(panelProvider.notifier).setSearch(v),
// // //                   decoration: InputDecoration(
// // //                     hintText: 'Search celebrities...',
// // //                     hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
// // //                     prefixIcon: Icon(Icons.search,
// // //                         color: Colors.white.withAlpha(100)),
// // //                     border: InputBorder.none,
// // //                     contentPadding: const EdgeInsets.symmetric(vertical: 15),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             GestureDetector(
// // //               onTap: () =>
// // //                   setState(() => _filterExpanded = !_filterExpanded),
// // //               child: AnimatedContainer(
// // //                 duration: const Duration(milliseconds: 300),
// // //                 height: 50,
// // //                 width: 50,
// // //                 decoration: BoxDecoration(
// // //                   color: _filterExpanded
// // //                       ? _accent
// // //                       : _accent.withAlpha(30),
// // //                   borderRadius: BorderRadius.circular(15),
// // //                   border: Border.all(
// // //                       color:
// // //                           _accent.withAlpha(_filterExpanded ? 255 : 120)),
// // //                 ),
// // //                 child: AnimatedRotation(
// // //                   duration: const Duration(milliseconds: 300),
// // //                   turns: _filterExpanded ? 0.125 : 0,
// // //                   child: Icon(Icons.tune,
// // //                       color: _filterExpanded ? Colors.white : _accent),
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // ════════════════════════════════════════════════════════════════
// // //   // FILTER PANEL
// // //   // ════════════════════════════════════════════════════════════════

// // //   Widget _buildFilterPanel(PanelState s) {
// // //     if (!_filterExpanded) {
// // //       return const SliverToBoxAdapter(child: SizedBox.shrink());
// // //     }
// // //     return SliverToBoxAdapter(
// // //       child: Container(
// // //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// // //         padding: const EdgeInsets.all(20),
// // //         decoration: BoxDecoration(
// // //           color: _card,
// // //           borderRadius: BorderRadius.circular(20),
// // //           border: Border.all(color: Colors.white.withAlpha(20)),
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             _rangeSlider(
// // //               label: 'Age',
// // //               icon: Icons.cake,
// // //               min: 18,
// // //               max: 100,
// // //               values: RangeValues(s.ageMin.toDouble(), s.ageMax.toDouble()),
// // //               onChanged: (v) => ref.read(panelProvider.notifier).updateAge(v),
// // //             ),
// // //             const SizedBox(height: 18),
// // //             _rangeSlider(
// // //               label: 'Height (ft)',
// // //               icon: Icons.height,
// // //               min: 0,
// // //               max: 10,
// // //               values: RangeValues(s.heightMin.toDouble(), s.heightMax.toDouble()),
// // //               onChanged: (v) => ref.read(panelProvider.notifier).updateHeight(v),
// // //             ),
// // //             const SizedBox(height: 18),
// // //             _rangeSlider(
// // //               label: 'Weight (Kg)',
// // //               icon: Icons.monitor_weight_outlined,
// // //               min: 20,
// // //               max: 200,
// // //               values: RangeValues(s.weightMin.toDouble(), s.weightMax.toDouble()),
// // //               onChanged: (v) => ref.read(panelProvider.notifier).updateWeight(v),
// // //             ),
// // //             const SizedBox(height: 18),
// // //             const Text('Preferences',
// // //                 style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
// // //             const SizedBox(height: 10),
// // //             Wrap(
// // //               spacing: 8,
// // //               runSpacing: 8,
// // //               children: kPreferenceOptions.map((pref) {
// // //                 final selected = s.selectedPreferences.contains(pref);
// // //                 return GestureDetector(
// // //                   onTap: () => ref.read(panelProvider.notifier).togglePreference(pref),
// // //                   child: AnimatedContainer(
// // //                     duration: const Duration(milliseconds: 200),
// // //                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// // //                     decoration: BoxDecoration(
// // //                       color: selected ? _accent : _surface,
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       border: Border.all(color: selected ? _accent : Colors.white.withAlpha(30)),
// // //                     ),
// // //                     child: Row(
// // //                       mainAxisSize: MainAxisSize.min,
// // //                       children: [
// // //                         Icon(selected ? Icons.check_circle : Icons.circle_outlined,
// // //                             color: selected ? Colors.white : Colors.white.withAlpha(80), size: 16),
// // //                         const SizedBox(width: 6),
// // //                         Text(pref,
// // //                             style: TextStyle(
// // //                               color: selected ? Colors.white : Colors.white.withAlpha(120),
// // //                               fontSize: 12,
// // //                               fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
// // //                             )),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 );
// // //               }).toList(),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             SizedBox(
// // //               width: double.infinity,
// // //               height: 50,
// // //               child: ElevatedButton.icon(
// // //                 onPressed: () => ref.read(panelProvider.notifier).applyFilters(),
// // //                 icon: const Icon(Icons.filter_list, color: Colors.white),
// // //                 label: const Text('Apply Filters',
// // //                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: _accent,
// // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // //                   elevation: 4,
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _rangeSlider({
// // //     required String label,
// // //     required IconData icon,
// // //     required double min,
// // //     required double max,
// // //     required RangeValues values,
// // //     required ValueChanged<RangeValues> onChanged,
// // //   }) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Row(
// // //           children: [
// // //             Icon(icon, color: _gold, size: 16),
// // //             const SizedBox(width: 8),
// // //             Text(label,
// // //                 style: const TextStyle(
// // //                     color: Colors.white,
// // //                     fontSize: 14,
// // //                     fontWeight: FontWeight.w600)),
// // //             const Spacer(),
// // //             Text('${values.start.round()} – ${values.end.round()}',
// // //                 style: TextStyle(color: _accent, fontSize: 13)),
// // //           ],
// // //         ),
// // //         SliderTheme(
// // //           data: SliderThemeData(
// // //             activeTrackColor: _accent,
// // //             inactiveTrackColor: Colors.white.withAlpha(30),
// // //             thumbColor: _accent,
// // //             overlayColor: _accent.withAlpha(30),
// // //             rangeThumbShape:
// // //                 const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
// // //           ),
// // //           child: RangeSlider(
// // //             values: values,
// // //             min: min,
// // //             max: max,
// // //             onChanged: onChanged,
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   // ════════════════════════════════════════════════════════════════
// // //   // ALL USERS GRID  (flip-card style)
// // //   // ════════════════════════════════════════════════════════════════

// // //   Widget _buildUsersGrid(PanelState s) {
// // //     final users = s.filteredUsers;

// // //     if (users.isEmpty) {
// // //       return SliverToBoxAdapter(
// // //         child: Container(
// // //           margin: const EdgeInsets.all(40),
// // //           padding: const EdgeInsets.symmetric(vertical: 50),
// // //           decoration: BoxDecoration(
// // //             color: _card,
// // //             borderRadius: BorderRadius.circular(24),
// // //           ),
// // //           child: Column(
// // //             children: [
// // //               Icon(Icons.search,
// // //                   size: 60, color: Colors.white.withAlpha(40)),
// // //               const SizedBox(height: 16),
// // //               const Text('No Records Found',
// // //                   style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.bold)),
// // //               const SizedBox(height: 8),
// // //               Text('Try adjusting your filters to find more results.',
// // //                   style: TextStyle(
// // //                       color: Colors.white.withAlpha(80), fontSize: 14)),
// // //             ],
// // //           ),
// // //         ),
// // //       );
// // //     }

// // //     return SliverPadding(
// // //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
// // //       sliver: SliverGrid(
// // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //           crossAxisCount: 2,
// // //           mainAxisSpacing: 16,
// // //           crossAxisSpacing: 16,
// // //           childAspectRatio: 0.52,
// // //         ),
// // //         delegate: SliverChildBuilderDelegate(
// // //           (context, index) => _FlipCardWidget(
// // //             user: users[index],
// // //             onViewMore: () => _navigateToUserProfile(users[index]),
// // //             onCalendar: () => _showCalendarDialog(
// // //                 users[index].id, users[index].username),
// // //           ),
// // //           childCount: users.length,
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // ════════════════════════════════════════════════════════════════
// // //   // CALENDAR DIALOG
// // //   // ════════════════════════════════════════════════════════════════

// // //   void _showCalendarDialog(String payPerId, String username) {
// // //     showGeneralDialog(
// // //       context: context,
// // //       barrierDismissible: true,
// // //       barrierLabel: 'Calendar',
// // //       barrierColor: Colors.black87,
// // //       transitionDuration: const Duration(milliseconds: 350),
// // //       pageBuilder: (ctx, anim1, anim2) => Center(
// // //         child: Material(
// // //           color: Colors.transparent,
// // //           child: Container(
// // //             width: MediaQuery.of(ctx).size.width * 0.9,
// // //             constraints: const BoxConstraints(maxHeight: 500),
// // //             decoration: BoxDecoration(
// // //               color: _card,
// // //               borderRadius: BorderRadius.circular(24),
// // //               border: Border.all(color: Colors.white.withAlpha(20)),
// // //             ),
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Container(
// // //                   padding: const EdgeInsets.all(20),
// // //                   decoration: const BoxDecoration(
// // //                     gradient:
// // //                         LinearGradient(colors: [_accent, Color(0xFF5C2438)]),
// // //                     borderRadius: BorderRadius.vertical(
// // //                         top: Radius.circular(24)),
// // //                   ),
// // //                   child: Row(
// // //                     children: [
// // //                       const Icon(Icons.calendar_month,
// // //                           color: Colors.white, size: 24),
// // //                       const SizedBox(width: 10),
// // //                       const Expanded(
// // //                         child: Text('Already Booked Slots',
// // //                             style: TextStyle(
// // //                                 color: Colors.white,
// // //                                 fontSize: 18,
// // //                                 fontWeight: FontWeight.bold)),
// // //                       ),
// // //                       IconButton(
// // //                         icon: const Icon(Icons.close, color: Colors.white70),
// // //                         onPressed: () => Navigator.pop(ctx),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 Flexible(
// // //                   child: Padding(
// // //                     padding: const EdgeInsets.all(16),
// // //                     child: FutureBuilder<List<CalendarSlot>>(
// // //                       future: ref
// // //                           .read(panelProvider.notifier)
// // //                           .fetchCalendar(payPerId),
// // //                       builder: (ctx, snap) {
// // //                         if (snap.connectionState == ConnectionState.waiting) {
// // //                           return const Padding(
// // //                             padding: EdgeInsets.all(30),
// // //                             child: Center(
// // //                                 child:
// // //                                     CircularProgressIndicator(color: _accent)),
// // //                           );
// // //                         }
// // //                         final slots = snap.data ?? [];
// // //                         if (slots.isEmpty) {
// // //                           return const Padding(
// // //                             padding: EdgeInsets.all(30),
// // //                             child: Text('No record found…..',
// // //                                 style: TextStyle(color: Colors.white54)),
// // //                           );
// // //                         }
// // //                         return SingleChildScrollView(
// // //                           child: Column(
// // //                             mainAxisSize: MainAxisSize.min,
// // //                             children: slots.asMap().entries.map((entry) {
// // //                               final i = entry.key;
// // //                               final slot = entry.value;
// // //                               return Container(
// // //                                 margin: const EdgeInsets.only(bottom: 10),
// // //                                 padding: const EdgeInsets.all(14),
// // //                                 decoration: BoxDecoration(
// // //                                   color: _surface,
// // //                                   borderRadius: BorderRadius.circular(14),
// // //                                   border: Border.all(
// // //                                       color: Colors.white.withAlpha(15)),
// // //                                 ),
// // //                                 child: Row(
// // //                                   children: [
// // //                                     Container(
// // //                                       width: 32,
// // //                                       height: 32,
// // //                                       decoration: BoxDecoration(
// // //                                         color: _accent.withAlpha(30),
// // //                                         borderRadius: BorderRadius.circular(10),
// // //                                       ),
// // //                                       child: Center(
// // //                                         child: Text('${i + 1}',
// // //                                             style: const TextStyle(
// // //                                                 color: _accent,
// // //                                                 fontWeight: FontWeight.bold)),
// // //                                       ),
// // //                                     ),
// // //                                     const SizedBox(width: 12),
// // //                                     Expanded(
// // //                                       child: Column(
// // //                                         crossAxisAlignment:
// // //                                             CrossAxisAlignment.start,
// // //                                         children: [
// // //                                           Text(slot.username,
// // //                                               style: const TextStyle(
// // //                                                   color: Colors.white,
// // //                                                   fontWeight: FontWeight.w600,
// // //                                                   fontSize: 14),
// // //                                               maxLines: 1,
// // //                                               overflow: TextOverflow.ellipsis),
// // //                                           const SizedBox(height: 4),
// // //                                           Text(slot.calenderDate,
// // //                                               style: TextStyle(
// // //                                                   color: _gold, fontSize: 12)),
// // //                                         ],
// // //                                       ),
// // //                                     ),
// // //                                     Flexible(
// // //                                       child: Column(
// // //                                         crossAxisAlignment: CrossAxisAlignment.end,
// // //                                         children: [
// // //                                           Row(
// // //                                             mainAxisSize: MainAxisSize.min,
// // //                                             children: [
// // //                                               Icon(Icons.play_arrow,
// // //                                                   color:
// // //                                                       Colors.greenAccent.shade400,
// // //                                                   size: 14),
// // //                                               const SizedBox(width: 4),
// // //                                               Text(slot.startTime12Format,
// // //                                                   style: const TextStyle(
// // //                                                       color: Colors.greenAccent,
// // //                                                       fontSize: 12)),
// // //                                             ],
// // //                                           ),
// // //                                           const SizedBox(height: 2),
// // //                                           Row(
// // //                                             mainAxisSize: MainAxisSize.min,
// // //                                             children: [
// // //                                               Icon(Icons.stop,
// // //                                                   color: Colors.redAccent.shade200,
// // //                                                   size: 14),
// // //                                               const SizedBox(width: 4),
// // //                                               Text(slot.endTime12Format,
// // //                                                   style: TextStyle(
// // //                                                       color:
// // //                                                           Colors.redAccent.shade200,
// // //                                                       fontSize: 12)),
// // //                                             ],
// // //                                           ),
// // //                                         ],
// // //                                       ),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               );
// // //                             }).toList(),
// // //                           ),
// // //                         );
// // //                       },
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //       transitionBuilder: (ctx, anim1, anim2, child) =>
// // //           ScaleTransition(scale: anim1, child: child),
// // //     );
// // //   }

// // //   // ════════════════════════════════════════════════════════════════
// // //   // NAVIGATE TO USER PROFILE
// // //   // ════════════════════════════════════════════════════════════════

// // //   void _navigateToUserProfile(ChocolateFactoryUser user) {
// // //     // ── Uncomment after adding the imports at the top ──────────
// // //     //
// // //     // Navigator.push(
// // //     //   context,
// // //     //   MaterialPageRoute(
// // //     //     builder: (_) => OtherUserProfilePage(
// // //     //       user: UserListItem(
// // //     //         id: user.id,
// // //     //         name: user.username,
// // //     //         imageUrl: user.profileImage,
// // //     //         lastSeen: 'Offline',
// // //     //         location: user.stateOfResidence,
// // //     //         isOnline: false,
// // //     //       ),
// // //     //     ),
// // //     //   ),
// // //     // );
// // //   }

// // //   // ════════════════════════════════════════════════════════════════
// // //   // NETWORK IMAGE HELPER
// // //   // ════════════════════════════════════════════════════════════════

// // //   Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
// // //     if (url.isEmpty) {
// // //       return Container(
// // //         color: _surface,
// // //         child: const Center(
// // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // //       );
// // //     }
// // //     String full = url;
// // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // //     return Image.network(
// // //       full,
// // //       fit: fit,
// // //       errorBuilder: (_, __, ___) => Container(
// // //         color: _surface,
// // //         child: const Center(
// // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // //       ),
// // //       loadingBuilder: (_, child, progress) {
// // //         if (progress == null) return child;
// // //         return Container(
// // //           color: _surface,
// // //           child: const Center(
// // //             child: CircularProgressIndicator(
// // //                 color: _accent, strokeWidth: 2),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // // ════════════════════════════════════════════════════════════════════
// // // // FLIP CARD — tap to flip between front (image) and back (info)
// // // // ════════════════════════════════════════════════════════════════════

// // // class _FlipCardWidget extends StatefulWidget {
// // //   final ChocolateFactoryUser user;
// // //   final VoidCallback onViewMore;
// // //   final VoidCallback onCalendar;

// // //   const _FlipCardWidget({
// // //     required this.user,
// // //     required this.onViewMore,
// // //     required this.onCalendar,
// // //   });

// // //   @override
// // //   State<_FlipCardWidget> createState() => _FlipCardWidgetState();
// // // }

// // // class _FlipCardWidgetState extends State<_FlipCardWidget>
// // //     with SingleTickerProviderStateMixin {
// // //   late AnimationController _controller;
// // //   late Animation<double> _animation;
// // //   bool _showFront = true;

// // //   static const _bg = Color(0xFF13132B);
// // //   static const _accent = Color(0xFFE91E63);
// // //   static const _surface = Color(0xFF1C1C3A);
// // //   static const _gold = Color(0xFFF4BA4A);

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _controller = AnimationController(
// // //       duration: const Duration(milliseconds: 600),
// // //       vsync: this,
// // //     );
// // //     _animation = Tween<double>(begin: 0, end: 1).animate(
// // //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _controller.dispose();
// // //     super.dispose();
// // //   }

// // //   void _flip() {
// // //     if (_showFront) {
// // //       _controller.forward();
// // //     } else {
// // //       _controller.reverse();
// // //     }
// // //     setState(() => _showFront = !_showFront);
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final u = widget.user;
// // //     return GestureDetector(
// // //       onTap: _flip,
// // //       child: AnimatedBuilder(
// // //         animation: _animation,
// // //         builder: (context, child) {
// // //           final angle = _animation.value * 3.14159265;
// // //           final isFront = angle < 1.5708;
// // //           return Transform(
// // //             alignment: Alignment.center,
// // //             transform: Matrix4.identity()
// // //               ..setEntry(3, 2, 0.001)
// // //               ..rotateY(angle),
// // //             child: isFront
// // //                 ? _buildFront(u)
// // //                 : Transform(
// // //                     alignment: Alignment.center,
// // //                     transform: Matrix4.identity()..rotateY(3.14159265),
// // //                     child: _buildBack(u),
// // //                   ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   // ── Front ──────────────────────────────────────────────────────

// // //   Widget _buildFront(ChocolateFactoryUser u) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         borderRadius: BorderRadius.circular(20),
// // //         color: _bg,
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withAlpha(80),
// // //             blurRadius: 15,
// // //             offset: const Offset(0, 8),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Stack(
// // //         children: [
// // //           ClipRRect(
// // //             borderRadius: BorderRadius.circular(20),
// // //             child: SizedBox(
// // //               width: double.infinity,
// // //               height: double.infinity,
// // //               child: _networkImg(u.profileImage),
// // //             ),
// // //           ),
// // //           Positioned(
// // //             top: 10,
// // //             left: 10,
// // //             child: Image.network(
// // //               '${kAssetBase}img/badge1.png',
// // //               width: 40,
// // //               height: 40,
// // //               errorBuilder: (_, __, ___) =>
// // //                   const Icon(Icons.verified, color: _gold, size: 28),
// // //             ),
// // //           ),
// // //           Positioned.fill(
// // //             child: Container(
// // //               decoration: BoxDecoration(
// // //                 borderRadius: BorderRadius.circular(20),
// // //                 gradient: LinearGradient(
// // //                   begin: Alignment.topCenter,
// // //                   end: Alignment.bottomCenter,
// // //                   colors: [
// // //                     Colors.transparent,
// // //                     Colors.transparent,
// // //                     Colors.black.withAlpha(200),
// // //                   ],
// // //                   stops: const [0.0, 0.5, 1.0],
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //           Positioned(
// // //             left: 14,
// // //             bottom: 14,
// // //             right: 14,
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Text(u.username,
// // //                     style: const TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 16,
// // //                         fontWeight: FontWeight.bold),
// // //                     maxLines: 1,
// // //                     overflow: TextOverflow.ellipsis),
// // //                 if (u.showAge == '1')
// // //                   Text('Age ${u.age}',
// // //                       style: TextStyle(
// // //                           color: Colors.white.withAlpha(180), fontSize: 12)),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ── Back ───────────────────────────────────────────────────────

// // //   Widget _buildBack(ChocolateFactoryUser u) {
// // //     return Container(
// // //       decoration: const BoxDecoration(
// // //         borderRadius: BorderRadius.all(Radius.circular(20)),
// // //         gradient: LinearGradient(
// // //           colors: [Color(0xFF560827), Color(0xFF06032C)],
// // //         ),
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
// // //         child: LayoutBuilder(
// // //           builder: (context, constraints) {
// // //             return SingleChildScrollView(
// // //               physics: const NeverScrollableScrollPhysics(),
// // //               child: ConstrainedBox(
// // //                 constraints: BoxConstraints(
// // //                   minHeight: constraints.maxHeight,
// // //                 ),
// // //                 child: IntrinsicHeight(
// // //                   child: Column(
// // //                     mainAxisAlignment: MainAxisAlignment.center,
// // //                     children: [
// // //                       FittedBox(
// // //                         child: Text(u.username,
// // //                             style: const TextStyle(
// // //                                 color: Colors.white,
// // //                                 fontSize: 18,
// // //                                 fontWeight: FontWeight.bold),
// // //                             textAlign: TextAlign.center,
// // //                             maxLines: 1),
// // //                       ),
// // //                       if (u.stateOfResidence.isNotEmpty) ...[
// // //                         const SizedBox(height: 3),
// // //                         Text(u.stateOfResidence,
// // //                             style: TextStyle(
// // //                                 color: Colors.white.withAlpha(160),
// // //                                 fontSize: 12),
// // //                             maxLines: 1,
// // //                             overflow: TextOverflow.ellipsis),
// // //                       ],
// // //                       const SizedBox(height: 10),
// // //                       Wrap(
// // //                         alignment: WrapAlignment.center,
// // //                         spacing: 6,
// // //                         runSpacing: 5,
// // //                         children: [
// // //                           if (u.showAge == '1') _backChip('${u.age} yrs'),
// // //                           if (u.showHeight == '1')
// // //                             _backChip("${u.heightFeet}' ${u.heightInch}\""),
// // //                           if (u.showWeight == '1') _backChip('${u.weight} Kg'),
// // //                         ],
// // //                       ),
// // //                       if (u.showPreferences == '1' &&
// // //                           u.preferences.isNotEmpty) ...[
// // //                         const SizedBox(height: 8),
// // //                         Wrap(
// // //                           spacing: 5,
// // //                           runSpacing: 5,
// // //                           alignment: WrapAlignment.center,
// // //                           children: u.preferences.take(3).map((p) {
// // //                             return Container(
// // //                               padding: const EdgeInsets.symmetric(
// // //                                   horizontal: 8, vertical: 4),
// // //                               decoration: BoxDecoration(
// // //                                 color: _accent.withAlpha(40),
// // //                                 borderRadius: BorderRadius.circular(12),
// // //                               ),
// // //                               child: Text(p,
// // //                                   style: const TextStyle(
// // //                                       color: _accent, fontSize: 10)),
// // //                             );
// // //                           }).toList(),
// // //                         ),
// // //                       ],
// // //                       const SizedBox(height: 12),
// // //                       SizedBox(
// // //                         width: double.infinity,
// // //                         child: ElevatedButton(
// // //                           onPressed: widget.onViewMore,
// // //                           style: ElevatedButton.styleFrom(
// // //                             backgroundColor: _accent,
// // //                             foregroundColor: Colors.white,
// // //                             shape: RoundedRectangleBorder(
// // //                                 borderRadius: BorderRadius.circular(14)),
// // //                             padding: const EdgeInsets.symmetric(vertical: 9),
// // //                           ),
// // //                           child: const Text('View More',
// // //                               style: TextStyle(
// // //                                   fontWeight: FontWeight.bold, fontSize: 13)),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(height: 6),
// // //                       GestureDetector(
// // //                         onTap: widget.onCalendar,
// // //                         child: Container(
// // //                           padding: const EdgeInsets.symmetric(vertical: 8),
// // //                           decoration: BoxDecoration(
// // //                             border: Border.all(color: _gold.withAlpha(80)),
// // //                             borderRadius: BorderRadius.circular(14),
// // //                           ),
// // //                           child: const Row(
// // //                             mainAxisAlignment: MainAxisAlignment.center,
// // //                             mainAxisSize: MainAxisSize.min,
// // //                             children: [
// // //                               Icon(Icons.calendar_today,
// // //                                   color: _gold, size: 15),
// // //                               SizedBox(width: 5),
// // //                               Text('Calendar',
// // //                                   style: TextStyle(
// // //                                       color: _gold, fontSize: 12)),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             );
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _backChip(String text) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white.withAlpha(15),
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       child: Text(text,
// // //           style: const TextStyle(color: Colors.white, fontSize: 11)),
// // //     );
// // //   }

// // //   Widget _networkImg(String url) {
// // //     if (url.isEmpty) {
// // //       return Container(
// // //         color: _surface,
// // //         child: const Center(
// // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // //       );
// // //     }
// // //     String full = url;
// // //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// // //     return Image.network(
// // //       full,
// // //       fit: BoxFit.cover,
// // //       errorBuilder: (_, __, ___) => Container(
// // //         color: _surface,
// // //         child: const Center(
// // //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// // //       ),
// // //       loadingBuilder: (_, child, progress) {
// // //         if (progress == null) return child;
// // //         return Container(
// // //           color: _surface,
// // //           child: const Center(
// // //             child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }


// // // ╔═══════════════════════════════════════════════════════════════════╗
// // // ║  Celebrity Panel – Pay-Per-Click (Chocolate Factory)            ║
// // // ║  Single self-contained file — paste into your existing project  ║
// // // ║  API: https://app.beatflirtevent.com/App                        ║
// // // ║  Auth: Access-Token + Access-Sign headers (from sessionStorage) ║
// // // ╚═══════════════════════════════════════════════════════════════════╝

// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http/http.dart' as http;

// // // ── Uncomment these for your existing project navigation ─────────
// // // import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// // // import 'package:beatflirt/providers/user_list_provider.dart';

// // // ════════════════════════════════════════════════════════════════════
// // // 1)  A P I   C O N S T A N T S
// // // ════════════════════════════════════════════════════════════════════

// // const String kApiBase = 'https://app.beatflirtevent.com/App';
// // const String kAssetBase = 'https://app.beatflirtevent.com/assets/';

// // const List<String> kPreferenceOptions = [
// //   'Orgy',
// //   'Gang Bang',
// //   'Couple',
// //   'BDSM',
// //   'Dom',
// //   'Sub',
// //   'Cuckolder',
// //   'Bull Stag',
// // ];

// // // ════════════════════════════════════════════════════════════════════
// // // 2)  D A T A   M O D E L S
// // // ════════════════════════════════════════════════════════════════════

// // class ChocolateFactoryUser {
// //   final String id;
// //   final String username;
// //   final String age;
// //   final String showAge;
// //   final String stateOfResidence;
// //   final String heightFeet;
// //   final String heightInch;
// //   final String showHeight;
// //   final String weight;
// //   final String showWeight;
// //   final List<String> preferences;
// //   final String showPreferences;
// //   final String selfDescription;
// //   final List<ChocolateFactoryImage> images;

// //   const ChocolateFactoryUser({
// //     required this.id,
// //     required this.username,
// //     required this.age,
// //     required this.showAge,
// //     required this.stateOfResidence,
// //     required this.heightFeet,
// //     required this.heightInch,
// //     required this.showHeight,
// //     required this.weight,
// //     required this.showWeight,
// //     required this.preferences,
// //     required this.showPreferences,
// //     required this.selfDescription,
// //     required this.images,
// //   });

// //   String get profileImage =>
// //       images.isNotEmpty ? images.first.profileImage : '';

// //   String get displayHeight => "${heightFeet}' ${heightInch}\"";

// //   factory ChocolateFactoryUser.fromJson(Map<String, dynamic> j) {
// //     return ChocolateFactoryUser(
// //       id: '${j['id'] ?? ''}',
// //       username: '${j['username'] ?? ''}',
// //       age: '${j['age'] ?? ''}',
// //       showAge: '${j['show_age'] ?? '0'}',
// //       stateOfResidence: '${j['state_of_residence'] ?? ''}',
// //       heightFeet: '${j['height_feet'] ?? ''}',
// //       heightInch: '${j['height_inch'] ?? ''}',
// //       showHeight: '${j['show_height'] ?? '0'}',
// //       weight: '${j['weight'] ?? ''}',
// //       showWeight: '${j['show_weight'] ?? '0'}',
// //       preferences:
// //           (j['preferences'] as List<dynamic>?)
// //               ?.map((e) => '$e')
// //               .toList() ?? [],
// //       showPreferences: '${j['show_preferences'] ?? '0'}',
// //       selfDescription: '${j['self_description'] ?? ''}',
// //       images:
// //           (j['image'] as List<dynamic>?)
// //               ?.map((e) => ChocolateFactoryImage.fromJson(e))
// //               .toList() ?? [],
// //     );
// //   }
// // }

// // class ChocolateFactoryImage {
// //   final String profileImage;
// //   const ChocolateFactoryImage({required this.profileImage});
// //   factory ChocolateFactoryImage.fromJson(Map<String, dynamic> j) =>
// //       ChocolateFactoryImage(profileImage: '${j['profile_image'] ?? ''}');
// // }

// // class CalendarSlot {
// //   final String username;
// //   final String calenderDate;
// //   final String startTime12Format;
// //   final String endTime12Format;
// //   const CalendarSlot({
// //     required this.username,
// //     required this.calenderDate,
// //     required this.startTime12Format,
// //     required this.endTime12Format,
// //   });
// //   factory CalendarSlot.fromJson(Map<String, dynamic> j) => CalendarSlot(
// //         username: '${j['username'] ?? ''}',
// //         calenderDate: '${j['calender_date'] ?? ''}',
// //         startTime12Format: '${j['start_time_12_formate'] ?? ''}',
// //         endTime12Format: '${j['end_time_12_formate'] ?? ''}',
// //       );
// // }

// // class TermsCondition {
// //   final String description;
// //   const TermsCondition({required this.description});
// //   factory TermsCondition.fromJson(Map<String, dynamic> j) =>
// //       TermsCondition(description: '${j['description'] ?? ''}');
// // }

// // // ════════════════════════════════════════════════════════════════════
// // // 3)  S T A T E
// // // ════════════════════════════════════════════════════════════════════

// // class PanelState {
// //   final bool isLoading;
// //   final String? error;
// //   final ChocolateFactoryUser? myProfile;
// //   final List<ChocolateFactoryUser> allUsers;
// //   final String searchQuery;
// //   final int ageMin;
// //   final int ageMax;
// //   final int heightMin;
// //   final int heightMax;
// //   final int weightMin;
// //   final int weightMax;
// //   final List<String> selectedPreferences;

// //   const PanelState({
// //     this.isLoading = false,
// //     this.error,
// //     this.myProfile,
// //     this.allUsers = const [],
// //     this.searchQuery = '',
// //     this.ageMin = 18,
// //     this.ageMax = 80,
// //     this.heightMin = 3,
// //     this.heightMax = 8,
// //     this.weightMin = 20,
// //     this.weightMax = 150,
// //     this.selectedPreferences = const [],
// //   });

// //   PanelState copyWith({
// //     bool? isLoading,
// //     String? error,
// //     ChocolateFactoryUser? myProfile,
// //     List<ChocolateFactoryUser>? allUsers,
// //     String? searchQuery,
// //     int? ageMin,
// //     int? ageMax,
// //     int? heightMin,
// //     int? heightMax,
// //     int? weightMin,
// //     int? weightMax,
// //     List<String>? selectedPreferences,
// //   }) {
// //     return PanelState(
// //       isLoading: isLoading ?? this.isLoading,
// //       error: error,
// //       myProfile: myProfile ?? this.myProfile,
// //       allUsers: allUsers ?? this.allUsers,
// //       searchQuery: searchQuery ?? this.searchQuery,
// //       ageMin: ageMin ?? this.ageMin,
// //       ageMax: ageMax ?? this.ageMax,
// //       heightMin: heightMin ?? this.heightMin,
// //       heightMax: heightMax ?? this.heightMax,
// //       weightMin: weightMin ?? this.weightMin,
// //       weightMax: weightMax ?? this.weightMax,
// //       selectedPreferences: selectedPreferences ?? this.selectedPreferences,
// //     );
// //   }

// //   List<ChocolateFactoryUser> get filteredUsers {
// //     var list = allUsers;
// //     if (searchQuery.isNotEmpty) {
// //       list = list
// //           .where((u) =>
// //               u.username.toLowerCase().contains(searchQuery.toLowerCase()))
// //           .toList();
// //     }
// //     return list;
// //   }
// // }

// // // ════════════════════════════════════════════════════════════════════
// // // 4)  N O T I F I E R   (API calls + state)
// // // ════════════════════════════════════════════════════════════════════

// // class PanelNotifier extends StateNotifier<PanelState> {
// //   String? _accessToken;
// //   String? _accessSign;

// //   PanelNotifier() : super(const PanelState()) {
// //     _loadToken();
// //   }

// //   // ── Load auth credentials ─────────────────────────────────────
// //   //
// //   // The web app stores them in sessionStorage / localStorage as:
// //   //   "Access-Token"  →  sent as header  Access-Token
// //   //   "Access-Sign"   →  sent as header  Access-Sign
// //   //
// //   // The Flutter app likely stores them in SharedPreferences with the
// //   // same keys, or lower-case variants.  We try both.

// //   Future<void> _loadToken() async {
// //     final prefs = await SharedPreferences.getInstance();

// //     // ── DEBUG: Print ALL SharedPreferences keys to find the real ones ──
// //     debugPrint('═══ CelebrityPanel — ALL SharedPreferences Keys ═══');
// //     final allKeys = prefs.getKeys();
// //     for (final key in allKeys) {
// //       final val = prefs.get(key);
// //       final valStr = val.toString();
// //       final preview = valStr.length > 40 ? '${valStr.substring(0, 40)}...' : valStr;
// //       debugPrint('  KEY: "$key" → $preview');
// //     }
// //     debugPrint('════════════════════════════════════════════════════');

// //     // Try every possible key variant for Access-Token
// //     _accessToken = prefs.getString('Access-Token') //
// //         ?? prefs.getString('access_token')
// //         ?? prefs.getString('accessToken')
// //         ?? prefs.getString('token')
// //         ?? prefs.getString('auth_token')
// //         ?? prefs.getString('access_token_key')
// //         ?? prefs.getString('user_token');

// //     // Try every possible key variant for Access-Sign
// //     _accessSign = prefs.getString('Access-Sign') //
// //         ?? prefs.getString('access_sign')
// //         ?? prefs.getString('accessSign')
// //         ?? prefs.getString('sign')
// //         ?? prefs.getString('Access_Sign')
// //         ?? prefs.getString('access-sign')
// //         ?? prefs.getString('sign_key')
// //         ?? prefs.getString('user_sign')
// //         ?? prefs.getString('secret')
// //         ?? prefs.getString('secret_key')
// //         ?? prefs.getString('user_secret');

// //     debugPrint('═══ CelebrityPanel ═══');
// //     debugPrint('  Access-Token : ${_accessToken != null ? "${_accessToken!.substring(0, _accessToken!.length > 20 ? 20 : _accessToken!.length)}..." : "NULL"}');
// //     debugPrint('  Access-Sign  : ${_accessSign != null ? "${_accessSign!.substring(0, _accessSign!.length > 20 ? 20 : _accessSign!.length)}..." : "NULL"}');
// //     debugPrint('═══════════════════════');

// //     fetchPanel();
// //   }

// //   // ── HTTP helpers ──────────────────────────────────────────────
// //   //
// //   //  The web's callapi.setHeaders() builds:
// //   //    { "Content-Type":"application/json; charset=UTF-8",
// //   //      "Access-Token":"<token>",  "Access-Sign":"<sign>" }
// //   //
// //   //  NOT  Authorization: Bearer ...  ← this was the bug!

// //   Map<String, String> get _headers => {
// //         'Content-Type': 'application/json; charset=UTF-8',
// //         if (_accessToken != null && _accessToken!.isNotEmpty)
// //           'Access-Token': _accessToken!,
// //         if (_accessSign != null && _accessSign!.isNotEmpty)
// //           'Access-Sign': _accessSign!,
// //       };

// //   Future<Map<String, dynamic>?> _post(
// //       String path, Map<String, dynamic> body) async {
// //     try {
// //       final uri = Uri.parse('$kApiBase$path');
// //       debugPrint('POST $uri  headers=$_headers');
// //       final r = await http.post(uri, headers: _headers, body: jsonEncode(body));
// //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// //         return jsonDecode(r.body) as Map<String, dynamic>;
// //       }
// //       return null;
// //     } catch (e) {
// //       debugPrint('  → ERROR $e');
// //       return null;
// //     }
// //   }

// //   Future<Map<String, dynamic>?> _get(String path) async {
// //     try {
// //       final uri = Uri.parse('$kApiBase$path');
// //       debugPrint('GET $uri  headers=$_headers');
// //       final r = await http.get(uri, headers: _headers);
// //       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
// //       if (r.statusCode == 200 && r.body.isNotEmpty) {
// //         return jsonDecode(r.body) as Map<String, dynamic>;
// //       }
// //       return null;
// //     } catch (e) {
// //       debugPrint('  → ERROR $e');
// //       return null;
// //     }
// //   }

// //   // ── Helper: check status as int or string ─────────────────────
// //   //  Web API sometimes returns {"status":200} (int)
// //   //  and sometimes {"status":"404"} (string).
// //   //  JavaScript == coerces both, but Dart's == does NOT.

// //   bool _isOk(Map<String, dynamic>? r) {
// //     if (r == null) return false;
// //     final s = r['status'];
// //     return s != null && s.toString() == '200';
// //   }

// //   // ── Main data fetch ───────────────────────────────────────────

// //   Future<void> fetchPanel() async {
// //     state = state.copyWith(isLoading: true, error: null);
// //     try {
// //       final results = await Future.wait([
// //         _post('/payperclick/get_chocolate_factory_data', {'user_type': 'me'}),
// //         _post('/payperclick/get_all_chocolate_factory_data', {
// //           'age_minvalue': state.ageMin,
// //           'age_maxvalue': state.ageMax,
// //           'height_minvalue': state.heightMin,
// //           'height_maxvalue': state.heightMax,
// //           'weight_minvalue': state.weightMin,
// //           'weight_maxvalue': state.weightMax,
// //           'preferencesArray': state.selectedPreferences,
// //         }),
// //       ]);

// //       ChocolateFactoryUser? myProfile;
// //       final me = results[0];
// //       if (_isOk(me)) {
// //         final d = me!['data'];
// //         if (d is List && d.isNotEmpty) {
// //           myProfile = ChocolateFactoryUser.fromJson(d[0]);
// //         }
// //       }

// //       List<ChocolateFactoryUser> allUsers = [];
// //       final all = results[1];
// //       if (_isOk(all)) {
// //         final d = all!['data'];
// //         if (d is List) {
// //           allUsers = d.map((e) => ChocolateFactoryUser.fromJson(e)).toList();
// //         }
// //       }

// //       debugPrint('  myProfile: ${myProfile?.username ?? "null"}');
// //       debugPrint('  allUsers count: ${allUsers.length}');

// //       state = state.copyWith(
// //         isLoading: false,
// //         myProfile: myProfile,
// //         allUsers: allUsers,
// //       );
// //     } catch (e) {
// //       debugPrint('  fetchPanel ERROR: $e');
// //       state = state.copyWith(isLoading: false, error: e.toString());
// //     }
// //   }

// //   // ── Filters ───────────────────────────────────────────────────

// //   Future<void> applyFilters() => fetchPanel();

// //   void updateAge(RangeValues v) =>
// //       state = state.copyWith(ageMin: v.start.round(), ageMax: v.end.round());
// //   void updateHeight(RangeValues v) => state = state.copyWith(
// //       heightMin: v.start.round(), heightMax: v.end.round());
// //   void updateWeight(RangeValues v) => state = state.copyWith(
// //       weightMin: v.start.round(), weightMax: v.end.round());

// //   void togglePreference(String pref) {
// //     final list = [...state.selectedPreferences];
// //     if (list.contains(pref)) {
// //       list.remove(pref);
// //     } else {
// //       list.add(pref);
// //     }
// //     state = state.copyWith(selectedPreferences: list);
// //   }

// //   void setSearch(String q) => state = state.copyWith(searchQuery: q);

// //   // ── Calendar ──────────────────────────────────────────────────

// //   Future<List<CalendarSlot>> fetchCalendar(String payPerId) async {
// //     final r = await _post('/payperclick/get_user_calender_details', {
// //       'pay_per_id': payPerId,
// //     });
// //     if (_isOk(r)) {
// //       final d = r!['data'];
// //       if (d is List) return d.map((e) => CalendarSlot.fromJson(e)).toList();
// //     }
// //     return [];
// //   }

// //   // ── Terms ─────────────────────────────────────────────────────

// //   Future<TermsCondition?> fetchTerms() async {
// //     final r = await _get('/auth/pay_per_click_terms_condition');
// //     if (_isOk(r)) {
// //       final d = r!['data'];
// //       if (d is List && d.isNotEmpty) return TermsCondition.fromJson(d[0]);
// //     }
// //     return null;
// //   }

// //   // ── Check flags ───────────────────────────────────────────────

// //   Future<bool> checkPost() async {
// //     final r = await _get('/payperclick/check_chocolate_factory_post');
// //     return _isOk(r);
// //   }

// //   Future<bool> checkPopup() async {
// //     final r = await _get('/payperclick/check_chocolate_factory_popup');
// //     return _isOk(r);
// //   }
// // }

// // // ════════════════════════════════════════════════════════════════════
// // // 5)  P R O V I D E R
// // // ════════════════════════════════════════════════════════════════════

// // final panelProvider =
// //     StateNotifierProvider.autoDispose<PanelNotifier, PanelState>(
// //   (ref) => PanelNotifier(),
// // );

// // // ════════════════════════════════════════════════════════════════════
// // // 6)  M A I N   P A G E   W I D G E T
// // // ════════════════════════════════════════════════════════════════════

// // class CelebrityPanelPage extends ConsumerStatefulWidget {
// //   const CelebrityPanelPage({super.key});

// //   @override
// //   ConsumerState<CelebrityPanelPage> createState() => _CelebrityPanelPageState();
// // }

// // class _CelebrityPanelPageState extends ConsumerState<CelebrityPanelPage>
// //     with TickerProviderStateMixin {
// //   final TextEditingController _searchCtrl = TextEditingController();
// //   bool _filterExpanded = false;

// //   // ── Colour palette ────────────────────────────────────────────
// //   static const _bg = Color(0xFF0B0B1A);
// //   static const _card = Color(0xFF13132B);
// //   static const _accent = Color(0xFFE91E63);
// //   static const _gold = Color(0xFFF4BA4A);
// //   static const _surface = Color(0xFF1C1C3A);

// //   @override
// //   void dispose() {
// //     _searchCtrl.dispose();
// //     super.dispose();
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // BUILD
// //   // ════════════════════════════════════════════════════════════════

// //   @override
// //   Widget build(BuildContext context) {
// //     final s = ref.watch(panelProvider);

// //     return Scaffold(
// //       backgroundColor: _bg,
// //       body: CustomScrollView(
// //         physics: const BouncingScrollPhysics(),
// //         slivers: [
// //           // ── App Bar (no notification icon) ────────────────────
// //           SliverAppBar(
// //             leading: IconButton(
// //               icon: const Icon(Icons.arrow_back_ios_new,
// //                   color: Colors.white, size: 20),
// //               onPressed: () => Navigator.pop(context),
// //             ),
// //             expandedHeight: 130,
// //             floating: false,
// //             pinned: true,
// //             backgroundColor: _bg,
// //             elevation: 0,
// //             flexibleSpace: LayoutBuilder(
// //               builder: (context, constraints) {
// //                 final top = MediaQuery.of(context).padding.top;
// //                 final collapsed = kToolbarHeight + top;
// //                 final isCollapsed = constraints.maxHeight <= collapsed + 10;
// //                 return FlexibleSpaceBar(
// //                   centerTitle: false,
// //                   titlePadding: EdgeInsets.only(
// //                     left: isCollapsed ? 50 : 20,
// //                     bottom: 14,
// //                   ),
// //                   title: const Text(
// //                     'Celebrity Panel',
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 20,
// //                     ),
// //                   ),
// //                   background: Container(
// //                     decoration: const BoxDecoration(
// //                       gradient: LinearGradient(
// //                         begin: Alignment.topCenter,
// //                         end: Alignment.bottomCenter,
// //                         colors: [_accent, _bg],
// //                         stops: [0.0, 0.8],
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),

// //           // ── Loading ───────────────────────────────────────────
// //           if (s.isLoading)
// //             const SliverFillRemaining(
// //               child: Center(child: CircularProgressIndicator(color: _accent)),
// //             )

// //           // ── Error ─────────────────────────────────────────────
// //           else if (s.error != null && s.allUsers.isEmpty)
// //             SliverFillRemaining(
// //               child: Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Icon(Icons.error_outline,
// //                         color: Colors.white24, size: 48),
// //                     const SizedBox(height: 16),
// //                     Text('Failed to load celebrities',
// //                         style: TextStyle(color: Colors.white.withAlpha(153))),
// //                     const SizedBox(height: 8),
// //                     Text(s.error ?? '',
// //                         style: TextStyle(color: Colors.white38, fontSize: 12),
// //                         textAlign: TextAlign.center),
// //                     const SizedBox(height: 12),
// //                     TextButton(
// //                       onPressed: () =>
// //                           ref.read(panelProvider.notifier).fetchPanel(),
// //                       child: const Text('Retry',
// //                           style: TextStyle(color: _accent)),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             )

// //           // ── Content ───────────────────────────────────────────
// //           else ...[
// //             if (s.myProfile != null) _buildMyProfileCard(s.myProfile!),
// //             _buildSearchBar(),
// //             _buildFilterPanel(s),
// //             _buildUsersGrid(s),
// //             const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
// //           ],
// //         ],
// //       ),
// //       // ── NO FAB (removed) ──────────────────────────────────────
// //     );
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // MY PROFILE CARD
// //   // ════════════════════════════════════════════════════════════════

// //   Widget _buildMyProfileCard(ChocolateFactoryUser u) {
// //     return SliverToBoxAdapter(
// //       child: Container(
// //         margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
// //         decoration: BoxDecoration(
// //           color: _card,
// //           borderRadius: BorderRadius.circular(24),
// //           border: Border.all(color: Colors.white.withAlpha(25)),
// //           boxShadow: [
// //             BoxShadow(
// //               color: _accent.withAlpha(40),
// //               blurRadius: 30,
// //               offset: const Offset(0, 10),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             // ── Image ─────────────────────────────────────────
// //             SizedBox(
// //               height: 220,
// //               child: Stack(
// //                 children: [
// //                   ClipRRect(
// //                     borderRadius: const BorderRadius.vertical(
// //                         top: Radius.circular(24)),
// //                     child: SizedBox(
// //                       width: double.infinity,
// //                       child: _networkImage(u.profileImage, fit: BoxFit.cover),
// //                     ),
// //                   ),
// //                   // Badge
// //                   Positioned(
// //                     top: 12,
// //                     left: 12,
// //                     child: Container(
// //                       padding: const EdgeInsets.all(8),
// //                       decoration: BoxDecoration(
// //                         color: _accent.withAlpha(200),
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Image.network(
// //                         '${kAssetBase}img/badge1.png',
// //                         width: 40,
// //                         height: 40,
// //                         errorBuilder: (_, __, ___) =>
// //                             const Icon(Icons.verified, color: Colors.white),
// //                       ),
// //                     ),
// //                   ),
// //                   // Edit button
// //                   Positioned(
// //                     top: 12,
// //                     right: 12,
// //                     child: GestureDetector(
// //                       onTap: () {},
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 14, vertical: 8),
// //                         decoration: BoxDecoration(
// //                           color: Colors.black.withAlpha(150),
// //                           borderRadius: BorderRadius.circular(20),
// //                           border: Border.all(
// //                               color: Colors.white.withAlpha(60)),
// //                         ),
// //                         child: const Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Icon(Icons.edit, color: Colors.white, size: 14),
// //                             SizedBox(width: 4),
// //                             Text('Edit Profile',
// //                                 style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 12,
// //                                     fontWeight: FontWeight.w600)),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   // Gradient
// //                   Positioned.fill(
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         borderRadius: const BorderRadius.vertical(
// //                             top: Radius.circular(24)),
// //                         gradient: LinearGradient(
// //                           begin: Alignment.topCenter,
// //                           end: Alignment.bottomCenter,
// //                           colors: [
// //                             Colors.transparent,
// //                             Colors.black.withAlpha(180),
// //                           ],
// //                           stops: const [0.5, 1.0],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   // Name + age
// //                   Positioned(
// //                     left: 16,
// //                     bottom: 16,
// //                     right: 16,
// //                     child: Row(
// //                       children: [
// //                         Flexible(
// //                           child: Text(u.username,
// //                               style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 22,
// //                                   fontWeight: FontWeight.bold),
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis),
// //                         ),
// //                         if (u.showAge == '1') ...[
// //                           const SizedBox(width: 8),
// //                           Text('Age ${u.age}',
// //                               style: TextStyle(
// //                                   color: Colors.white.withAlpha(200),
// //                                   fontSize: 14)),
// //                         ],
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             // ── Info ───────────────────────────────────────────
// //             Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Location
// //                   Row(
// //                     children: [
// //                       const Icon(Icons.location_on, color: _accent, size: 16),
// //                       const SizedBox(width: 6),
// //                       Text(u.stateOfResidence,
// //                           style: TextStyle(
// //                               color: Colors.white.withAlpha(180),
// //                               fontSize: 14)),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 14),

// //                   // Stats
// //                   Row(
// //                     children: [
// //                       if (u.showHeight == '1')
// //                         _statChip(Icons.height, u.displayHeight),
// //                       if (u.showHeight == '1') const SizedBox(width: 12),
// //                       if (u.showWeight == '1')
// //                         _statChip(
// //                             Icons.monitor_weight_outlined, '${u.weight} Kg'),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 14),

// //                   // Preferences
// //                   if (u.showPreferences == '1' &&
// //                       u.preferences.isNotEmpty) ...[
// //                     const Text('Preferences',
// //                         style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w600)),
// //                     const SizedBox(height: 8),
// //                     Wrap(
// //                       spacing: 8,
// //                       runSpacing: 8,
// //                       children: u.preferences
// //                           .map((p) => Container(
// //                                 padding: const EdgeInsets.symmetric(
// //                                     horizontal: 12, vertical: 6),
// //                                 decoration: BoxDecoration(
// //                                   color: _accent.withAlpha(30),
// //                                   borderRadius: BorderRadius.circular(20),
// //                                   border: Border.all(
// //                                       color: _accent.withAlpha(80)),
// //                                 ),
// //                                 child: Text(p,
// //                                     style: const TextStyle(
// //                                         color: _accent, fontSize: 12)),
// //                               ))
// //                           .toList(),
// //                     ),
// //                     const SizedBox(height: 14),
// //                   ],

// //                   // Calendar + Review
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: GestureDetector(
// //                           onTap: () =>
// //                               _showCalendarDialog(u.id, u.username),
// //                           child: Container(
// //                             padding: const EdgeInsets.symmetric(vertical: 12),
// //                             decoration: BoxDecoration(
// //                               color: _surface,
// //                               borderRadius: BorderRadius.circular(14),
// //                               border: Border.all(
// //                                   color: Colors.white.withAlpha(20)),
// //                             ),
// //                             child: const Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Icon(Icons.calendar_month,
// //                                     color: _gold, size: 18),
// //                                 SizedBox(width: 8),
// //                                 Flexible(
// //                                   child: Text('Calendar',
// //                                       style: TextStyle(
// //                                           color: Colors.white,
// //                                           fontSize: 13,
// //                                           fontWeight: FontWeight.w600),
// //                                       overflow: TextOverflow.ellipsis),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 10),
// //                       Flexible(
// //                         child: GestureDetector(
// //                           onTap: () {},
// //                           child: Container(
// //                             padding: const EdgeInsets.symmetric(
// //                                 horizontal: 16, vertical: 12),
// //                             decoration: BoxDecoration(
// //                               color: _accent.withAlpha(20),
// //                               borderRadius: BorderRadius.circular(14),
// //                               border:
// //                                   Border.all(color: _accent.withAlpha(60)),
// //                             ),
// //                             child: const Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               mainAxisSize: MainAxisSize.min,
// //                               children: [
// //                                 Icon(Icons.rate_review,
// //                                     color: _accent, size: 16),
// //                                 SizedBox(width: 6),
// //                                 Flexible(
// //                                   child: Text('Write Review',
// //                                       style: TextStyle(
// //                                           color: _accent, fontSize: 13),
// //                                       overflow: TextOverflow.ellipsis),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 14),

// //                   // Description
// //                   if (u.selfDescription.isNotEmpty) ...[
// //                     Text('Description',
// //                         style: TextStyle(
// //                             color: Colors.white.withAlpha(150),
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.w600)),
// //                     const SizedBox(height: 6),
// //                     Text(u.selfDescription,
// //                         style: TextStyle(
// //                             color: Colors.white.withAlpha(120),
// //                             fontSize: 13,
// //                             height: 1.5),
// //                         maxLines: 4,
// //                         overflow: TextOverflow.ellipsis),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _statChip(IconData icon, String label) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: _surface,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.white.withAlpha(20)),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, color: _gold, size: 16),
// //           const SizedBox(width: 6),
// //           Text(label,
// //               style: const TextStyle(color: Colors.white, fontSize: 13)),
// //         ],
// //       ),
// //     );
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // SEARCH BAR
// //   // ════════════════════════════════════════════════════════════════

// //   Widget _buildSearchBar() {
// //     return SliverToBoxAdapter(
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: Container(
// //                 height: 50,
// //                 decoration: BoxDecoration(
// //                   color: Colors.white.withAlpha(15),
// //                   borderRadius: BorderRadius.circular(15),
// //                 ),
// //                 child: TextField(
// //                   controller: _searchCtrl,
// //                   style: const TextStyle(color: Colors.white),
// //                   onChanged: (v) =>
// //                       ref.read(panelProvider.notifier).setSearch(v),
// //                   decoration: InputDecoration(
// //                     hintText: 'Search celebrities...',
// //                     hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
// //                     prefixIcon: Icon(Icons.search,
// //                         color: Colors.white.withAlpha(100)),
// //                     border: InputBorder.none,
// //                     contentPadding: const EdgeInsets.symmetric(vertical: 15),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             GestureDetector(
// //               onTap: () =>
// //                   setState(() => _filterExpanded = !_filterExpanded),
// //               child: AnimatedContainer(
// //                 duration: const Duration(milliseconds: 300),
// //                 height: 50,
// //                 width: 50,
// //                 decoration: BoxDecoration(
// //                   color: _filterExpanded
// //                       ? _accent
// //                       : _accent.withAlpha(30),
// //                   borderRadius: BorderRadius.circular(15),
// //                   border: Border.all(
// //                       color:
// //                           _accent.withAlpha(_filterExpanded ? 255 : 120)),
// //                 ),
// //                 child: AnimatedRotation(
// //                   duration: const Duration(milliseconds: 300),
// //                   turns: _filterExpanded ? 0.125 : 0,
// //                   child: Icon(Icons.tune,
// //                       color: _filterExpanded ? Colors.white : _accent),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // FILTER PANEL
// //   // ════════════════════════════════════════════════════════════════

// //   Widget _buildFilterPanel(PanelState s) {
// //     if (!_filterExpanded) {
// //       return const SliverToBoxAdapter(child: SizedBox.shrink());
// //     }
// //     return SliverToBoxAdapter(
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           color: _card,
// //           borderRadius: BorderRadius.circular(20),
// //           border: Border.all(color: Colors.white.withAlpha(20)),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _rangeSlider(
// //               label: 'Age',
// //               icon: Icons.cake,
// //               min: 18,
// //               max: 100,
// //               values: RangeValues(s.ageMin.toDouble(), s.ageMax.toDouble()),
// //               onChanged: (v) => ref.read(panelProvider.notifier).updateAge(v),
// //             ),
// //             const SizedBox(height: 18),
// //             _rangeSlider(
// //               label: 'Height (ft)',
// //               icon: Icons.height,
// //               min: 0,
// //               max: 10,
// //               values: RangeValues(s.heightMin.toDouble(), s.heightMax.toDouble()),
// //               onChanged: (v) => ref.read(panelProvider.notifier).updateHeight(v),
// //             ),
// //             const SizedBox(height: 18),
// //             _rangeSlider(
// //               label: 'Weight (Kg)',
// //               icon: Icons.monitor_weight_outlined,
// //               min: 20,
// //               max: 200,
// //               values: RangeValues(s.weightMin.toDouble(), s.weightMax.toDouble()),
// //               onChanged: (v) => ref.read(panelProvider.notifier).updateWeight(v),
// //             ),
// //             const SizedBox(height: 18),
// //             const Text('Preferences',
// //                 style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
// //             const SizedBox(height: 10),
// //             Wrap(
// //               spacing: 8,
// //               runSpacing: 8,
// //               children: kPreferenceOptions.map((pref) {
// //                 final selected = s.selectedPreferences.contains(pref);
// //                 return GestureDetector(
// //                   onTap: () => ref.read(panelProvider.notifier).togglePreference(pref),
// //                   child: AnimatedContainer(
// //                     duration: const Duration(milliseconds: 200),
// //                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //                     decoration: BoxDecoration(
// //                       color: selected ? _accent : _surface,
// //                       borderRadius: BorderRadius.circular(20),
// //                       border: Border.all(color: selected ? _accent : Colors.white.withAlpha(30)),
// //                     ),
// //                     child: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Icon(selected ? Icons.check_circle : Icons.circle_outlined,
// //                             color: selected ? Colors.white : Colors.white.withAlpha(80), size: 16),
// //                         const SizedBox(width: 6),
// //                         Text(pref,
// //                             style: TextStyle(
// //                               color: selected ? Colors.white : Colors.white.withAlpha(120),
// //                               fontSize: 12,
// //                               fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
// //                             )),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //             const SizedBox(height: 20),
// //             SizedBox(
// //               width: double.infinity,
// //               height: 50,
// //               child: ElevatedButton.icon(
// //                 onPressed: () => ref.read(panelProvider.notifier).applyFilters(),
// //                 icon: const Icon(Icons.filter_list, color: Colors.white),
// //                 label: const Text('Apply Filters',
// //                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: _accent,
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //                   elevation: 4,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _rangeSlider({
// //     required String label,
// //     required IconData icon,
// //     required double min,
// //     required double max,
// //     required RangeValues values,
// //     required ValueChanged<RangeValues> onChanged,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Icon(icon, color: _gold, size: 16),
// //             const SizedBox(width: 8),
// //             Text(label,
// //                 style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w600)),
// //             const Spacer(),
// //             Text('${values.start.round()} – ${values.end.round()}',
// //                 style: TextStyle(color: _accent, fontSize: 13)),
// //           ],
// //         ),
// //         SliderTheme(
// //           data: SliderThemeData(
// //             activeTrackColor: _accent,
// //             inactiveTrackColor: Colors.white.withAlpha(30),
// //             thumbColor: _accent,
// //             overlayColor: _accent.withAlpha(30),
// //             rangeThumbShape:
// //                 const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
// //           ),
// //           child: RangeSlider(
// //             values: values,
// //             min: min,
// //             max: max,
// //             onChanged: onChanged,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // ALL USERS GRID  (flip-card style)
// //   // ════════════════════════════════════════════════════════════════

// //   Widget _buildUsersGrid(PanelState s) {
// //     final users = s.filteredUsers;

// //     if (users.isEmpty) {
// //       return SliverToBoxAdapter(
// //         child: Container(
// //           margin: const EdgeInsets.all(40),
// //           padding: const EdgeInsets.symmetric(vertical: 50),
// //           decoration: BoxDecoration(
// //             color: _card,
// //             borderRadius: BorderRadius.circular(24),
// //           ),
// //           child: Column(
// //             children: [
// //               Icon(Icons.search,
// //                   size: 60, color: Colors.white.withAlpha(40)),
// //               const SizedBox(height: 16),
// //               const Text('No Records Found',
// //                   style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold)),
// //               const SizedBox(height: 8),
// //               Text('Try adjusting your filters to find more results.',
// //                   style: TextStyle(
// //                       color: Colors.white.withAlpha(80), fontSize: 14)),
// //             ],
// //           ),
// //         ),
// //       );
// //     }

// //     return SliverPadding(
// //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
// //       sliver: SliverGrid(
// //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           mainAxisSpacing: 16,
// //           crossAxisSpacing: 16,
// //           childAspectRatio: 0.44,
// //         ),
// //         delegate: SliverChildBuilderDelegate(
// //           (context, index) => _FlipCardWidget(
// //             user: users[index],
// //             onViewMore: () => _navigateToUserProfile(users[index]),
// //             onCalendar: () => _showCalendarDialog(
// //                 users[index].id, users[index].username),
// //           ),
// //           childCount: users.length,
// //         ),
// //       ),
// //     );
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // CALENDAR DIALOG
// //   // ════════════════════════════════════════════════════════════════

// //   void _showCalendarDialog(String payPerId, String username) {
// //     showGeneralDialog(
// //       context: context,
// //       barrierDismissible: true,
// //       barrierLabel: 'Calendar',
// //       barrierColor: Colors.black87,
// //       transitionDuration: const Duration(milliseconds: 350),
// //       pageBuilder: (ctx, anim1, anim2) => Center(
// //         child: Material(
// //           color: Colors.transparent,
// //           child: Container(
// //             width: MediaQuery.of(ctx).size.width * 0.92,
// //             constraints: BoxConstraints(
// //               maxHeight: MediaQuery.of(ctx).size.height * 0.7,
// //             ),
// //             decoration: BoxDecoration(
// //               color: _card,
// //               borderRadius: BorderRadius.circular(24),
// //               border: Border.all(color: Colors.white.withAlpha(20)),
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 // ── Header ─────────────────────────────────────
// //                 Container(
// //                   padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
// //                   decoration: const BoxDecoration(
// //                     gradient:
// //                         LinearGradient(colors: [_accent, Color(0xFF5C2438)]),
// //                     borderRadius: BorderRadius.vertical(
// //                         top: Radius.circular(24)),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       const Icon(Icons.calendar_month,
// //                           color: Colors.white, size: 22),
// //                       const SizedBox(width: 10),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Text(username,
// //                                 style: const TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.bold),
// //                                 maxLines: 1,
// //                                 overflow: TextOverflow.ellipsis),
// //                             const SizedBox(height: 2),
// //                             const Text('Booked Slots',
// //                                 style: TextStyle(
// //                                     color: Colors.white70,
// //                                     fontSize: 12)),
// //                           ],
// //                         ),
// //                       ),
// //                       IconButton(
// //                         icon: const Icon(Icons.close, color: Colors.white70, size: 22),
// //                         onPressed: () => Navigator.pop(ctx),
// //                         padding: EdgeInsets.zero,
// //                         constraints: const BoxConstraints(),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 // ── Slots list ──────────────────────────────────
// //                 Flexible(
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(14),
// //                     child: FutureBuilder<List<CalendarSlot>>(
// //                       future: ref
// //                           .read(panelProvider.notifier)
// //                           .fetchCalendar(payPerId),
// //                       builder: (ctx, snap) {
// //                         if (snap.connectionState == ConnectionState.waiting) {
// //                           return const Padding(
// //                             padding: EdgeInsets.all(30),
// //                             child: Center(
// //                                 child:
// //                                     CircularProgressIndicator(color: _accent)),
// //                           );
// //                         }
// //                         final slots = snap.data ?? [];
// //                         if (slots.isEmpty) {
// //                           return const Padding(
// //                             padding: EdgeInsets.all(30),
// //                             child: Center(
// //                               child: Column(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   Icon(Icons.event_busy,
// //                                       color: Colors.white24, size: 40),
// //                                   SizedBox(height: 12),
// //                                   Text('No booked slots found',
// //                                       style: TextStyle(
// //                                           color: Colors.white54, fontSize: 14)),
// //                                 ],
// //                               ),
// //                             ),
// //                           );
// //                         }
// //                         return ListView.separated(
// //                           shrinkWrap: true,
// //                           padding: EdgeInsets.zero,
// //                           itemCount: slots.length,
// //                           separatorBuilder: (_, __) => const SizedBox(height: 8),
// //                           itemBuilder: (ctx, i) {
// //                             final slot = slots[i];
// //                             return Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 12, vertical: 10),
// //                               decoration: BoxDecoration(
// //                                 color: _surface,
// //                                 borderRadius: BorderRadius.circular(12),
// //                                 border: Border.all(
// //                                     color: Colors.white.withAlpha(15)),
// //                               ),
// //                               child: Row(
// //                                 children: [
// //                                   // Number badge
// //                                   Container(
// //                                     width: 28,
// //                                     height: 28,
// //                                     decoration: BoxDecoration(
// //                                       color: _accent.withAlpha(30),
// //                                       borderRadius: BorderRadius.circular(8),
// //                                     ),
// //                                     child: Center(
// //                                       child: Text('${i + 1}',
// //                                           style: const TextStyle(
// //                                               color: _accent,
// //                                               fontWeight: FontWeight.bold,
// //                                               fontSize: 12)),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(width: 10),
// //                                   // Name + date
// //                                   Expanded(
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         Text(slot.username,
// //                                             style: const TextStyle(
// //                                                 color: Colors.white,
// //                                                 fontWeight: FontWeight.w600,
// //                                                 fontSize: 13),
// //                                             maxLines: 1,
// //                                             overflow: TextOverflow.ellipsis),
// //                                         const SizedBox(height: 2),
// //                                         Text(slot.calenderDate,
// //                                             style: TextStyle(
// //                                                 color: _gold,
// //                                                 fontSize: 11)),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   // Time range
// //                                   Container(
// //                                     padding: const EdgeInsets.symmetric(
// //                                         horizontal: 8, vertical: 4),
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.white.withAlpha(8),
// //                                       borderRadius: BorderRadius.circular(8),
// //                                     ),
// //                                     child: Column(
// //                                       crossAxisAlignment: CrossAxisAlignment.end,
// //                                       children: [
// //                                         Row(
// //                                           mainAxisSize: MainAxisSize.min,
// //                                           children: [
// //                                             Icon(Icons.play_arrow,
// //                                                 color:
// //                                                     Colors.greenAccent.shade400,
// //                                                 size: 12),
// //                                             const SizedBox(width: 3),
// //                                             Text(slot.startTime12Format,
// //                                                 style: const TextStyle(
// //                                                     color: Colors.greenAccent,
// //                                                     fontSize: 11)),
// //                                           ],
// //                                         ),
// //                                         const SizedBox(height: 1),
// //                                         Row(
// //                                           mainAxisSize: MainAxisSize.min,
// //                                           children: [
// //                                             Icon(Icons.stop,
// //                                                 color: Colors.redAccent.shade200,
// //                                                 size: 12),
// //                                             const SizedBox(width: 3),
// //                                             Text(slot.endTime12Format,
// //                                                 style: TextStyle(
// //                                                     color:
// //                                                         Colors.redAccent.shade200,
// //                                                     fontSize: 11)),
// //                                           ],
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             );
// //                           },
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //       transitionBuilder: (ctx, anim1, anim2, child) =>
// //           ScaleTransition(scale: anim1, child: child),
// //     );
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // NAVIGATE TO USER PROFILE
// //   // ════════════════════════════════════════════════════════════════

// //   void _navigateToUserProfile(ChocolateFactoryUser user) {
// //     // ── Uncomment after adding the imports at the top ──────────
// //     //
// //     // Navigator.push(
// //     //   context,
// //     //   MaterialPageRoute(
// //     //     builder: (_) => OtherUserProfilePage(
// //     //       user: UserListItem(
// //     //         id: user.id,
// //     //         name: user.username,
// //     //         imageUrl: user.profileImage,
// //     //         lastSeen: 'Offline',
// //     //         location: user.stateOfResidence,
// //     //         isOnline: false,
// //     //       ),
// //     //     ),
// //     //   ),
// //     // );
// //   }

// //   // ════════════════════════════════════════════════════════════════
// //   // NETWORK IMAGE HELPER
// //   // ════════════════════════════════════════════════════════════════

// //   Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
// //     if (url.isEmpty) {
// //       return Container(
// //         color: _surface,
// //         child: const Center(
// //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// //       );
// //     }
// //     String full = url;
// //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// //     return Image.network(
// //       full,
// //       fit: fit,
// //       errorBuilder: (_, __, ___) => Container(
// //         color: _surface,
// //         child: const Center(
// //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// //       ),
// //       loadingBuilder: (_, child, progress) {
// //         if (progress == null) return child;
// //         return Container(
// //           color: _surface,
// //           child: const Center(
// //             child: CircularProgressIndicator(
// //                 color: _accent, strokeWidth: 2),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // // ════════════════════════════════════════════════════════════════════
// // // FLIP CARD — tap to flip between front (image) and back (info)
// // // ════════════════════════════════════════════════════════════════════

// // class _FlipCardWidget extends StatefulWidget {
// //   final ChocolateFactoryUser user;
// //   final VoidCallback onViewMore;
// //   final VoidCallback onCalendar;

// //   const _FlipCardWidget({
// //     required this.user,
// //     required this.onViewMore,
// //     required this.onCalendar,
// //   });

// //   @override
// //   State<_FlipCardWidget> createState() => _FlipCardWidgetState();
// // }

// // class _FlipCardWidgetState extends State<_FlipCardWidget>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _animation;
// //   bool _showFront = true;

// //   static const _bg = Color(0xFF13132B);
// //   static const _accent = Color(0xFFE91E63);
// //   static const _surface = Color(0xFF1C1C3A);
// //   static const _gold = Color(0xFFF4BA4A);

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       duration: const Duration(milliseconds: 600),
// //       vsync: this,
// //     );
// //     _animation = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   void _flip() {
// //     if (_showFront) {
// //       _controller.forward();
// //     } else {
// //       _controller.reverse();
// //     }
// //     setState(() => _showFront = !_showFront);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final u = widget.user;
// //     return GestureDetector(
// //       onTap: _flip,
// //       child: AnimatedBuilder(
// //         animation: _animation,
// //         builder: (context, child) {
// //           final angle = _animation.value * 3.14159265;
// //           final isFront = angle < 1.5708;
// //           return Transform(
// //             alignment: Alignment.center,
// //             transform: Matrix4.identity()
// //               ..setEntry(3, 2, 0.001)
// //               ..rotateY(angle),
// //             child: isFront
// //                 ? _buildFront(u)
// //                 : Transform(
// //                     alignment: Alignment.center,
// //                     transform: Matrix4.identity()..rotateY(3.14159265),
// //                     child: _buildBack(u),
// //                   ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   // ── Front ──────────────────────────────────────────────────────

// //   Widget _buildFront(ChocolateFactoryUser u) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(20),
// //         color: _bg,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withAlpha(80),
// //             blurRadius: 15,
// //             offset: const Offset(0, 8),
// //           ),
// //         ],
// //       ),
// //       child: Stack(
// //         children: [
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(20),
// //             child: SizedBox(
// //               width: double.infinity,
// //               height: double.infinity,
// //               child: _networkImg(u.profileImage),
// //             ),
// //           ),
// //           Positioned(
// //             top: 10,
// //             left: 10,
// //             child: Image.network(
// //               '${kAssetBase}img/badge1.png',
// //               width: 40,
// //               height: 40,
// //               errorBuilder: (_, __, ___) =>
// //                   const Icon(Icons.verified, color: _gold, size: 28),
// //             ),
// //           ),
// //           Positioned.fill(
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(20),
// //                 gradient: LinearGradient(
// //                   begin: Alignment.topCenter,
// //                   end: Alignment.bottomCenter,
// //                   colors: [
// //                     Colors.transparent,
// //                     Colors.transparent,
// //                     Colors.black.withAlpha(200),
// //                   ],
// //                   stops: const [0.0, 0.5, 1.0],
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             left: 14,
// //             bottom: 14,
// //             right: 14,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text(u.username,
// //                     style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold),
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis),
// //                 if (u.showAge == '1')
// //                   Text('Age ${u.age}',
// //                       style: TextStyle(
// //                           color: Colors.white.withAlpha(180), fontSize: 12)),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ── Back ───────────────────────────────────────────────────────

// //   Widget _buildBack(ChocolateFactoryUser u) {
// //     return Container(
// //       clipBehavior: Clip.antiAlias,
// //       decoration: const BoxDecoration(
// //         borderRadius: BorderRadius.all(Radius.circular(20)),
// //         gradient: LinearGradient(
// //           colors: [Color(0xFF560827), Color(0xFF06032C)],
// //         ),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           children: [
// //             // Username
// //             FittedBox(
// //               child: Text(u.username,
// //                   style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold),
// //                   textAlign: TextAlign.center,
// //                   maxLines: 1),
// //             ),
// //             // Location
// //             if (u.stateOfResidence.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 4),
// //                 child: Text(u.stateOfResidence,
// //                     style: TextStyle(
// //                         color: Colors.white.withAlpha(160), fontSize: 11),
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                     textAlign: TextAlign.center),
// //               ),
// //             // Stat chips
// //             Wrap(
// //               alignment: WrapAlignment.center,
// //               spacing: 4,
// //               runSpacing: 4,
// //               children: [
// //                 if (u.showAge == '1') _backChip('${u.age} yrs'),
// //                 if (u.showHeight == '1')
// //                   _backChip("${u.heightFeet}' ${u.heightInch}\""),
// //                 if (u.showWeight == '1') _backChip('${u.weight} Kg'),
// //               ],
// //             ),
// //             // Preferences
// //             if (u.showPreferences == '1' && u.preferences.isNotEmpty)
// //               Wrap(
// //                 spacing: 4,
// //                 runSpacing: 4,
// //                 alignment: WrapAlignment.center,
// //                 children: u.preferences.take(3).map((p) {
// //                   return Container(
// //                     padding:
// //                         const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
// //                     decoration: BoxDecoration(
// //                       color: _accent.withAlpha(40),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: Text(p,
// //                         style: const TextStyle(color: _accent, fontSize: 9)),
// //                   );
// //                 }).toList(),
// //               ),
// //             // View More button
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: widget.onViewMore,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: _accent,
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12)),
// //                   padding: const EdgeInsets.symmetric(vertical: 8),
// //                   minimumSize: Size.zero,
// //                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //                 ),
// //                 child: const Text('View More',
// //                     style:
// //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
// //               ),
// //             ),
// //             // Calendar button
// //             GestureDetector(
// //               onTap: widget.onCalendar,
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(vertical: 7),
// //                 width: double.infinity,
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: _gold.withAlpha(80)),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     const Icon(Icons.calendar_today, color: _gold, size: 14),
// //                     const SizedBox(width: 4),
// //                     const Text('Calendar',
// //                         style: TextStyle(color: _gold, fontSize: 11)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _backChip(String text) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withAlpha(15),
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Text(text,
// //           style: const TextStyle(color: Colors.white, fontSize: 11)),
// //     );
// //   }

// //   Widget _networkImg(String url) {
// //     if (url.isEmpty) {
// //       return Container(
// //         color: _surface,
// //         child: const Center(
// //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// //       );
// //     }
// //     String full = url;
// //     if (!url.startsWith('http')) full = '$kAssetBase$url';
// //     return Image.network(
// //       full,
// //       fit: BoxFit.cover,
// //       errorBuilder: (_, __, ___) => Container(
// //         color: _surface,
// //         child: const Center(
// //             child: Icon(Icons.person, color: Colors.white24, size: 50)),
// //       ),
// //       loadingBuilder: (_, child, progress) {
// //         if (progress == null) return child;
// //         return Container(
// //           color: _surface,
// //           child: const Center(
// //             child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // ╔═══════════════════════════════════════════════════════════════════╗
// // ║  Celebrity Panel – Pay-Per-Click (Chocolate Factory)            ║
// // ║  Single self-contained file — paste into your existing project  ║
// // ║  API: https://app.beatflirtevent.com/App                        ║
// // ║  Auth: Access-Token + Access-Sign headers (from sessionStorage) ║
// // ╚═══════════════════════════════════════════════════════════════════╝

// import 'dart:convert';
// import 'package:beatflirt/screens/drawer_pages/celebrity_panel_next_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// // ── Import the detail page ───────────────────────────────────────
// // import 'package:beatflirt/screens/drawer_pages/celebrity_profile_detail_page.dart';

// // ── Uncomment these for your existing project navigation ─────────
// // import 'package:beatflirt/screens/drawer_pages/other_user_profile_page.dart';
// // import 'package:beatflirt/providers/user_list_provider.dart';

// // ════════════════════════════════════════════════════════════════════
// // 1)  A P I   C O N S T A N T S
// // ════════════════════════════════════════════════════════════════════

// const String kApiBase = 'https://app.beatflirtevent.com/App';
// const String kAssetBase = 'https://app.beatflirtevent.com/assets/';

// const List<String> kPreferenceOptions = [
//   'Orgy',
//   'Gang Bang',
//   'Couple',
//   'BDSM',
//   'Dom',
//   'Sub',
//   'Cuckolder',
//   'Bull Stag',
// ];

// // ════════════════════════════════════════════════════════════════════
// // 2)  D A T A   M O D E L S
// // ════════════════════════════════════════════════════════════════════

// class ChocolateFactoryUser {
//   final String id;
//   final String username;
//   final String age;
//   final String showAge;
//   final String stateOfResidence;
//   final String heightFeet;
//   final String heightInch;
//   final String showHeight;
//   final String weight;
//   final String showWeight;
//   final List<String> preferences;
//   final String showPreferences;
//   final String selfDescription;
//   final List<ChocolateFactoryImage> images;

//   const ChocolateFactoryUser({
//     required this.id,
//     required this.username,
//     required this.age,
//     required this.showAge,
//     required this.stateOfResidence,
//     required this.heightFeet,
//     required this.heightInch,
//     required this.showHeight,
//     required this.weight,
//     required this.showWeight,
//     required this.preferences,
//     required this.showPreferences,
//     required this.selfDescription,
//     required this.images,
//   });

//   String get profileImage =>
//       images.isNotEmpty ? images.first.profileImage : '';

//   String get displayHeight => "${heightFeet}' ${heightInch}\"";

//   factory ChocolateFactoryUser.fromJson(Map<String, dynamic> j) {
//     return ChocolateFactoryUser(
//       id: '${j['id'] ?? ''}',
//       username: '${j['username'] ?? ''}',
//       age: '${j['age'] ?? ''}',
//       showAge: '${j['show_age'] ?? '0'}',
//       stateOfResidence: '${j['state_of_residence'] ?? ''}',
//       heightFeet: '${j['height_feet'] ?? ''}',
//       heightInch: '${j['height_inch'] ?? ''}',
//       showHeight: '${j['show_height'] ?? '0'}',
//       weight: '${j['weight'] ?? ''}',
//       showWeight: '${j['show_weight'] ?? '0'}',
//       preferences:
//           (j['preferences'] as List<dynamic>?)
//               ?.map((e) => '$e')
//               .toList() ?? [],
//       showPreferences: '${j['show_preferences'] ?? '0'}',
//       selfDescription: '${j['self_description'] ?? ''}',
//       images:
//           (j['image'] as List<dynamic>?)
//               ?.map((e) => ChocolateFactoryImage.fromJson(e))
//               .toList() ?? [],
//     );
//   }
// }

// class ChocolateFactoryImage {
//   final String profileImage;
//   const ChocolateFactoryImage({required this.profileImage});
//   factory ChocolateFactoryImage.fromJson(Map<String, dynamic> j) =>
//       ChocolateFactoryImage(profileImage: '${j['profile_image'] ?? ''}');
// }

// class CalendarSlot {
//   final String username;
//   final String calenderDate;
//   final String startTime12Format;
//   final String endTime12Format;
//   const CalendarSlot({
//     required this.username,
//     required this.calenderDate,
//     required this.startTime12Format,
//     required this.endTime12Format,
//   });
//   factory CalendarSlot.fromJson(Map<String, dynamic> j) => CalendarSlot(
//         username: '${j['username'] ?? ''}',
//         calenderDate: '${j['calender_date'] ?? ''}',
//         startTime12Format: '${j['start_time_12_formate'] ?? ''}',
//         endTime12Format: '${j['end_time_12_formate'] ?? ''}',
//       );
// }

// class TermsCondition {
//   final String description;
//   const TermsCondition({required this.description});
//   factory TermsCondition.fromJson(Map<String, dynamic> j) =>
//       TermsCondition(description: '${j['description'] ?? ''}');
// }

// // ════════════════════════════════════════════════════════════════════
// // 3)  S T A T E
// // ════════════════════════════════════════════════════════════════════

// class PanelState {
//   final bool isLoading;
//   final String? error;
//   final ChocolateFactoryUser? myProfile;
//   final List<ChocolateFactoryUser> allUsers;
//   final String searchQuery;
//   final int ageMin;
//   final int ageMax;
//   final int heightMin;
//   final int heightMax;
//   final int weightMin;
//   final int weightMax;
//   final List<String> selectedPreferences;

//   const PanelState({
//     this.isLoading = false,
//     this.error,
//     this.myProfile,
//     this.allUsers = const [],
//     this.searchQuery = '',
//     this.ageMin = 18,
//     this.ageMax = 80,
//     this.heightMin = 3,
//     this.heightMax = 8,
//     this.weightMin = 20,
//     this.weightMax = 150,
//     this.selectedPreferences = const [],
//   });

//   PanelState copyWith({
//     bool? isLoading,
//     String? error,
//     ChocolateFactoryUser? myProfile,
//     List<ChocolateFactoryUser>? allUsers,
//     String? searchQuery,
//     int? ageMin,
//     int? ageMax,
//     int? heightMin,
//     int? heightMax,
//     int? weightMin,
//     int? weightMax,
//     List<String>? selectedPreferences,
//   }) {
//     return PanelState(
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//       myProfile: myProfile ?? this.myProfile,
//       allUsers: allUsers ?? this.allUsers,
//       searchQuery: searchQuery ?? this.searchQuery,
//       ageMin: ageMin ?? this.ageMin,
//       ageMax: ageMax ?? this.ageMax,
//       heightMin: heightMin ?? this.heightMin,
//       heightMax: heightMax ?? this.heightMax,
//       weightMin: weightMin ?? this.weightMin,
//       weightMax: weightMax ?? this.weightMax,
//       selectedPreferences: selectedPreferences ?? this.selectedPreferences,
//     );
//   }

//   List<ChocolateFactoryUser> get filteredUsers {
//     var list = allUsers;
//     if (searchQuery.isNotEmpty) {
//       list = list
//           .where((u) =>
//               u.username.toLowerCase().contains(searchQuery.toLowerCase()))
//           .toList();
//     }
//     return list;
//   }
// }

// // ════════════════════════════════════════════════════════════════════
// // 4)  N O T I F I E R   (API calls + state)
// // ════════════════════════════════════════════════════════════════════

// class PanelNotifier extends StateNotifier<PanelState> {
//   String? _accessToken;
//   String? _accessSign;

//   PanelNotifier() : super(const PanelState()) {
//     _loadToken();
//   }

//   // ── Load auth credentials ─────────────────────────────────────
//   //
//   // The web app stores them in sessionStorage / localStorage as:
//   //   "Access-Token"  →  sent as header  Access-Token
//   //   "Access-Sign"   →  sent as header  Access-Sign
//   //
//   // The Flutter app likely stores them in SharedPreferences with the
//   // same keys, or lower-case variants.  We try both.

//   Future<void> _loadToken() async {
//     final prefs = await SharedPreferences.getInstance();

//     // ── DEBUG: Print ALL SharedPreferences keys to find the real ones ──
//     debugPrint('═══ CelebrityPanel — ALL SharedPreferences Keys ═══');
//     final allKeys = prefs.getKeys();
//     for (final key in allKeys) {
//       final val = prefs.get(key);
//       final valStr = val.toString();
//       final preview = valStr.length > 40 ? '${valStr.substring(0, 40)}...' : valStr;
//       debugPrint('  KEY: "$key" → $preview');
//     }
//     debugPrint('════════════════════════════════════════════════════');

//     // Try every possible key variant for Access-Token
//     _accessToken = prefs.getString('Access-Token') //
//         ?? prefs.getString('access_token')
//         ?? prefs.getString('accessToken')
//         ?? prefs.getString('token')
//         ?? prefs.getString('auth_token')
//         ?? prefs.getString('access_token_key')
//         ?? prefs.getString('user_token');

//     // Try every possible key variant for Access-Sign
//     _accessSign = prefs.getString('Access-Sign') //
//         ?? prefs.getString('access_sign')
//         ?? prefs.getString('accessSign')
//         ?? prefs.getString('sign')
//         ?? prefs.getString('Access_Sign')
//         ?? prefs.getString('access-sign')
//         ?? prefs.getString('sign_key')
//         ?? prefs.getString('user_sign')
//         ?? prefs.getString('secret')
//         ?? prefs.getString('secret_key')
//         ?? prefs.getString('user_secret');

//     debugPrint('═══ CelebrityPanel ═══');
//     debugPrint('  Access-Token : ${_accessToken != null ? "${_accessToken!.substring(0, _accessToken!.length > 20 ? 20 : _accessToken!.length)}..." : "NULL"}');
//     debugPrint('  Access-Sign  : ${_accessSign != null ? "${_accessSign!.substring(0, _accessSign!.length > 20 ? 20 : _accessSign!.length)}..." : "NULL"}');
//     debugPrint('═══════════════════════');

//     fetchPanel();
//   }

//   // ── HTTP helpers ──────────────────────────────────────────────
//   //
//   //  The web's callapi.setHeaders() builds:
//   //    { "Content-Type":"application/json; charset=UTF-8",
//   //      "Access-Token":"<token>",  "Access-Sign":"<sign>" }
//   //
//   //  NOT  Authorization: Bearer ...  ← this was the bug!

//   Map<String, String> get _headers => {
//         'Content-Type': 'application/json; charset=UTF-8',
//         if (_accessToken != null && _accessToken!.isNotEmpty)
//           'Access-Token': _accessToken!,
//         if (_accessSign != null && _accessSign!.isNotEmpty)
//           'Access-Sign': _accessSign!,
//       };

//   Future<Map<String, dynamic>?> _post(
//       String path, Map<String, dynamic> body) async {
//     try {
//       final uri = Uri.parse('$kApiBase$path');
//       debugPrint('POST $uri  headers=$_headers');
//       final r = await http.post(uri, headers: _headers, body: jsonEncode(body));
//       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
//       if (r.statusCode == 200 && r.body.isNotEmpty) {
//         return jsonDecode(r.body) as Map<String, dynamic>;
//       }
//       return null;
//     } catch (e) {
//       debugPrint('  → ERROR $e');
//       return null;
//     }
//   }

//   Future<Map<String, dynamic>?> _get(String path) async {
//     try {
//       final uri = Uri.parse('$kApiBase$path');
//       debugPrint('GET $uri  headers=$_headers');
//       final r = await http.get(uri, headers: _headers);
//       debugPrint('  → ${r.statusCode}  body=${r.body.length > 200 ? r.body.substring(0, 200) : r.body}');
//       if (r.statusCode == 200 && r.body.isNotEmpty) {
//         return jsonDecode(r.body) as Map<String, dynamic>;
//       }
//       return null;
//     } catch (e) {
//       debugPrint('  → ERROR $e');
//       return null;
//     }
//   }

//   // ── Helper: check status as int or string ─────────────────────
//   //  Web API sometimes returns {"status":200} (int)
//   //  and sometimes {"status":"404"} (string).
//   //  JavaScript == coerces both, but Dart's == does NOT.

//   bool _isOk(Map<String, dynamic>? r) {
//     if (r == null) return false;
//     final s = r['status'];
//     return s != null && s.toString() == '200';
//   }

//   // ── Main data fetch ───────────────────────────────────────────

//   Future<void> fetchPanel() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final results = await Future.wait([
//         _post('/payperclick/get_chocolate_factory_data', {'user_type': 'me'}),
//         _post('/payperclick/get_all_chocolate_factory_data', {
//           'age_minvalue': state.ageMin,
//           'age_maxvalue': state.ageMax,
//           'height_minvalue': state.heightMin,
//           'height_maxvalue': state.heightMax,
//           'weight_minvalue': state.weightMin,
//           'weight_maxvalue': state.weightMax,
//           'preferencesArray': state.selectedPreferences,
//         }),
//       ]);

//       ChocolateFactoryUser? myProfile;
//       final me = results[0];
//       if (_isOk(me)) {
//         final d = me!['data'];
//         if (d is List && d.isNotEmpty) {
//           myProfile = ChocolateFactoryUser.fromJson(d[0]);
//         }
//       }

//       List<ChocolateFactoryUser> allUsers = [];
//       final all = results[1];
//       if (_isOk(all)) {
//         final d = all!['data'];
//         if (d is List) {
//           allUsers = d.map((e) => ChocolateFactoryUser.fromJson(e)).toList();
//         }
//       }

//       debugPrint('  myProfile: ${myProfile?.username ?? "null"}');
//       debugPrint('  allUsers count: ${allUsers.length}');

//       state = state.copyWith(
//         isLoading: false,
//         myProfile: myProfile,
//         allUsers: allUsers,
//       );
//     } catch (e) {
//       debugPrint('  fetchPanel ERROR: $e');
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   // ── Filters ───────────────────────────────────────────────────

//   Future<void> applyFilters() => fetchPanel();

//   void updateAge(RangeValues v) =>
//       state = state.copyWith(ageMin: v.start.round(), ageMax: v.end.round());
//   void updateHeight(RangeValues v) => state = state.copyWith(
//       heightMin: v.start.round(), heightMax: v.end.round());
//   void updateWeight(RangeValues v) => state = state.copyWith(
//       weightMin: v.start.round(), weightMax: v.end.round());

//   void togglePreference(String pref) {
//     final list = [...state.selectedPreferences];
//     if (list.contains(pref)) {
//       list.remove(pref);
//     } else {
//       list.add(pref);
//     }
//     state = state.copyWith(selectedPreferences: list);
//   }

//   void setSearch(String q) => state = state.copyWith(searchQuery: q);

//   // ── Calendar ──────────────────────────────────────────────────

//   Future<List<CalendarSlot>> fetchCalendar(String payPerId) async {
//     final r = await _post('/payperclick/get_user_calender_details', {
//       'pay_per_id': payPerId,
//     });
//     if (_isOk(r)) {
//       final d = r!['data'];
//       if (d is List) return d.map((e) => CalendarSlot.fromJson(e)).toList();
//     }
//     return [];
//   }

//   // ── Terms ─────────────────────────────────────────────────────

//   Future<TermsCondition?> fetchTerms() async {
//     final r = await _get('/auth/pay_per_click_terms_condition');
//     if (_isOk(r)) {
//       final d = r!['data'];
//       if (d is List && d.isNotEmpty) return TermsCondition.fromJson(d[0]);
//     }
//     return null;
//   }

//   // ── Check flags ───────────────────────────────────────────────

//   Future<bool> checkPost() async {
//     final r = await _get('/payperclick/check_chocolate_factory_post');
//     return _isOk(r);
//   }

//   Future<bool> checkPopup() async {
//     final r = await _get('/payperclick/check_chocolate_factory_popup');
//     return _isOk(r);
//   }
// }

// // ════════════════════════════════════════════════════════════════════
// // 5)  P R O V I D E R
// // ════════════════════════════════════════════════════════════════════

// final panelProvider =
//     StateNotifierProvider.autoDispose<PanelNotifier, PanelState>(
//   (ref) => PanelNotifier(),
// );

// // ════════════════════════════════════════════════════════════════════
// // 6)  M A I N   P A G E   W I D G E T
// // ════════════════════════════════════════════════════════════════════

// class CelebrityPanelPage extends ConsumerStatefulWidget {
//   const CelebrityPanelPage({super.key});

//   @override
//   ConsumerState<CelebrityPanelPage> createState() => _CelebrityPanelPageState();
// }

// class _CelebrityPanelPageState extends ConsumerState<CelebrityPanelPage>
//     with TickerProviderStateMixin {
//   final TextEditingController _searchCtrl = TextEditingController();
//   bool _filterExpanded = false;

//   // ── Colour palette ────────────────────────────────────────────
//   static const _bg = Color(0xFF0B0B1A);
//   static const _card = Color(0xFF13132B);
//   static const _accent = Color(0xFFE91E63);
//   static const _gold = Color(0xFFF4BA4A);
//   static const _surface = Color(0xFF1C1C3A);

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   // ════════════════════════════════════════════════════════════════
//   // BUILD
//   // ════════════════════════════════════════════════════════════════

//   @override
//   Widget build(BuildContext context) {
//     final s = ref.watch(panelProvider);

//     return Scaffold(
//       backgroundColor: _bg,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── App Bar (no notification icon) ────────────────────
//           SliverAppBar(
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new,
//                   color: Colors.white, size: 20),
//               onPressed: () => Navigator.pop(context),
//             ),
//             expandedHeight: 130,
//             floating: false,
//             pinned: true,
//             backgroundColor: _bg,
//             elevation: 0,
//             flexibleSpace: LayoutBuilder(
//               builder: (context, constraints) {
//                 final top = MediaQuery.of(context).padding.top;
//                 final collapsed = kToolbarHeight + top;
//                 final isCollapsed = constraints.maxHeight <= collapsed + 10;
//                 return FlexibleSpaceBar(
//                   centerTitle: false,
//                   titlePadding: EdgeInsets.only(
//                     left: isCollapsed ? 50 : 20,
//                     bottom: 14,
//                   ),
//                   title: const Text(
//                     'Celebrity Panel',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                   background: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [_accent, _bg],
//                         stops: [0.0, 0.8],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // ── Loading ───────────────────────────────────────────
//           if (s.isLoading)
//             const SliverFillRemaining(
//               child: Center(child: CircularProgressIndicator(color: _accent)),
//             )

//           // ── Error ─────────────────────────────────────────────
//           else if (s.error != null && s.allUsers.isEmpty)
//             SliverFillRemaining(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error_outline,
//                         color: Colors.white24, size: 48),
//                     const SizedBox(height: 16),
//                     Text('Failed to load celebrities',
//                         style: TextStyle(color: Colors.white.withAlpha(153))),
//                     const SizedBox(height: 8),
//                     Text(s.error ?? '',
//                         style: TextStyle(color: Colors.white38, fontSize: 12),
//                         textAlign: TextAlign.center),
//                     const SizedBox(height: 12),
//                     TextButton(
//                       onPressed: () =>
//                           ref.read(panelProvider.notifier).fetchPanel(),
//                       child: const Text('Retry',
//                           style: TextStyle(color: _accent)),
//                     ),
//                   ],
//                 ),
//               ),
//             )

//           // ── Content ───────────────────────────────────────────
//           else ...[
//             if (s.myProfile != null) _buildMyProfileCard(s.myProfile!),
//             _buildSearchBar(),
//             _buildFilterPanel(s),
//             _buildUsersGrid(s),
//             const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
//           ],
//         ],
//       ),
//       // ── NO FAB (removed) ──────────────────────────────────────
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   // MY PROFILE CARD
//   // ════════════════════════════════════════════════════════════════

//   Widget _buildMyProfileCard(ChocolateFactoryUser u) {
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//         decoration: BoxDecoration(
//           color: _card,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: Colors.white.withAlpha(25)),
//           boxShadow: [
//             BoxShadow(
//               color: _accent.withAlpha(40),
//               blurRadius: 30,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // ── Image ─────────────────────────────────────────
//             SizedBox(
//               height: 220,
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(24)),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: _networkImage(u.profileImage, fit: BoxFit.cover),
//                     ),
//                   ),
//                   // Badge
//                   Positioned(
//                     top: 12,
//                     left: 12,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: _accent.withAlpha(200),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Image.network(
//                         '${kAssetBase}img/badge1.png',
//                         width: 40,
//                         height: 40,
//                         errorBuilder: (_, __, ___) =>
//                             const Icon(Icons.verified, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   // Edit button
//                   Positioned(
//                     top: 12,
//                     right: 12,
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withAlpha(150),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                               color: Colors.white.withAlpha(60)),
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.edit, color: Colors.white, size: 14),
//                             SizedBox(width: 4),
//                             Text('Edit Profile',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Gradient
//                   Positioned.fill(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(24)),
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withAlpha(180),
//                           ],
//                           stops: const [0.5, 1.0],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Name + age
//                   Positioned(
//                     left: 16,
//                     bottom: 16,
//                     right: 16,
//                     child: Row(
//                       children: [
//                         Flexible(
//                           child: Text(u.username,
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                         ),
//                         if (u.showAge == '1') ...[
//                           const SizedBox(width: 8),
//                           Text('Age ${u.age}',
//                               style: TextStyle(
//                                   color: Colors.white.withAlpha(200),
//                                   fontSize: 14)),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ── Info ───────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Location
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, color: _accent, size: 16),
//                       const SizedBox(width: 6),
//                       Text(u.stateOfResidence,
//                           style: TextStyle(
//                               color: Colors.white.withAlpha(180),
//                               fontSize: 14)),
//                     ],
//                   ),
//                   const SizedBox(height: 14),

//                   // Stats
//                   Row(
//                     children: [
//                       if (u.showHeight == '1')
//                         _statChip(Icons.height, u.displayHeight),
//                       if (u.showHeight == '1') const SizedBox(width: 12),
//                       if (u.showWeight == '1')
//                         _statChip(
//                             Icons.monitor_weight_outlined, '${u.weight} Kg'),
//                     ],
//                   ),
//                   const SizedBox(height: 14),

//                   // Preferences
//                   if (u.showPreferences == '1' &&
//                       u.preferences.isNotEmpty) ...[
//                     const Text('Preferences',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 8),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: u.preferences
//                           .map((p) => Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 6),
//                                 decoration: BoxDecoration(
//                                   color: _accent.withAlpha(30),
//                                   borderRadius: BorderRadius.circular(20),
//                                   border: Border.all(
//                                       color: _accent.withAlpha(80)),
//                                 ),
//                                 child: Text(p,
//                                     style: const TextStyle(
//                                         color: _accent, fontSize: 12)),
//                               ))
//                           .toList(),
//                     ),
//                     const SizedBox(height: 14),
//                   ],

//                   // Calendar + Review
//                   Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () =>
//                               _showCalendarDialog(u.id, u.username),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               color: _surface,
//                               borderRadius: BorderRadius.circular(14),
//                               border: Border.all(
//                                   color: Colors.white.withAlpha(20)),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.calendar_month,
//                                     color: _gold, size: 18),
//                                 SizedBox(width: 8),
//                                 Flexible(
//                                   child: Text('Calendar',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600),
//                                       overflow: TextOverflow.ellipsis),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Flexible(
//                         child: GestureDetector(
//                           onTap: () {},
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12),
//                             decoration: BoxDecoration(
//                               color: _accent.withAlpha(20),
//                               borderRadius: BorderRadius.circular(14),
//                               border:
//                                   Border.all(color: _accent.withAlpha(60)),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.rate_review,
//                                     color: _accent, size: 16),
//                                 SizedBox(width: 6),
//                                 Flexible(
//                                   child: Text('Write Review',
//                                       style: TextStyle(
//                                           color: _accent, fontSize: 13),
//                                       overflow: TextOverflow.ellipsis),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 14),

//                   // Description
//                   if (u.selfDescription.isNotEmpty) ...[
//                     Text('Description',
//                         style: TextStyle(
//                             color: Colors.white.withAlpha(150),
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 6),
//                     Text(u.selfDescription,
//                         style: TextStyle(
//                             color: Colors.white.withAlpha(120),
//                             fontSize: 13,
//                             height: 1.5),
//                         maxLines: 4,
//                         overflow: TextOverflow.ellipsis),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _statChip(IconData icon, String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: _surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withAlpha(20)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: _gold, size: 16),
//           const SizedBox(width: 6),
//           Text(label,
//               style: const TextStyle(color: Colors.white, fontSize: 13)),
//         ],
//       ),
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   // SEARCH BAR
//   // ════════════════════════════════════════════════════════════════

//   Widget _buildSearchBar() {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withAlpha(15),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: TextField(
//                   controller: _searchCtrl,
//                   style: const TextStyle(color: Colors.white),
//                   onChanged: (v) =>
//                       ref.read(panelProvider.notifier).setSearch(v),
//                   decoration: InputDecoration(
//                     hintText: 'Search celebrities...',
//                     hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
//                     prefixIcon: Icon(Icons.search,
//                         color: Colors.white.withAlpha(100)),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             GestureDetector(
//               onTap: () =>
//                   setState(() => _filterExpanded = !_filterExpanded),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                   color: _filterExpanded
//                       ? _accent
//                       : _accent.withAlpha(30),
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(
//                       color:
//                           _accent.withAlpha(_filterExpanded ? 255 : 120)),
//                 ),
//                 child: AnimatedRotation(
//                   duration: const Duration(milliseconds: 300),
//                   turns: _filterExpanded ? 0.125 : 0,
//                   child: Icon(Icons.tune,
//                       color: _filterExpanded ? Colors.white : _accent),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   // FILTER PANEL
//   // ════════════════════════════════════════════════════════════════

//   Widget _buildFilterPanel(PanelState s) {
//     if (!_filterExpanded) {
//       return const SliverToBoxAdapter(child: SizedBox.shrink());
//     }
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: _card,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withAlpha(20)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _rangeSlider(
//               label: 'Age',
//               icon: Icons.cake,
//               min: 18,
//               max: 100,
//               values: RangeValues(s.ageMin.toDouble(), s.ageMax.toDouble()),
//               onChanged: (v) => ref.read(panelProvider.notifier).updateAge(v),
//             ),
//             const SizedBox(height: 18),
//             _rangeSlider(
//               label: 'Height (ft)',
//               icon: Icons.height,
//               min: 0,
//               max: 10,
//               values: RangeValues(s.heightMin.toDouble(), s.heightMax.toDouble()),
//               onChanged: (v) => ref.read(panelProvider.notifier).updateHeight(v),
//             ),
//             const SizedBox(height: 18),
//             _rangeSlider(
//               label: 'Weight (Kg)',
//               icon: Icons.monitor_weight_outlined,
//               min: 20,
//               max: 200,
//               values: RangeValues(s.weightMin.toDouble(), s.weightMax.toDouble()),
//               onChanged: (v) => ref.read(panelProvider.notifier).updateWeight(v),
//             ),
//             const SizedBox(height: 18),
//             const Text('Preferences',
//                 style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
//             const SizedBox(height: 10),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: kPreferenceOptions.map((pref) {
//                 final selected = s.selectedPreferences.contains(pref);
//                 return GestureDetector(
//                   onTap: () => ref.read(panelProvider.notifier).togglePreference(pref),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: selected ? _accent : _surface,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: selected ? _accent : Colors.white.withAlpha(30)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(selected ? Icons.check_circle : Icons.circle_outlined,
//                             color: selected ? Colors.white : Colors.white.withAlpha(80), size: 16),
//                         const SizedBox(width: 6),
//                         Text(pref,
//                             style: TextStyle(
//                               color: selected ? Colors.white : Colors.white.withAlpha(120),
//                               fontSize: 12,
//                               fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
//                             )),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 onPressed: () => ref.read(panelProvider.notifier).applyFilters(),
//                 icon: const Icon(Icons.filter_list, color: Colors.white),
//                 label: const Text('Apply Filters',
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _accent,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   elevation: 4,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _rangeSlider({
//     required String label,
//     required IconData icon,
//     required double min,
//     required double max,
//     required RangeValues values,
//     required ValueChanged<RangeValues> onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: _gold, size: 16),
//             const SizedBox(width: 8),
//             Text(label,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600)),
//             const Spacer(),
//             Text('${values.start.round()} – ${values.end.round()}',
//                 style: TextStyle(color: _accent, fontSize: 13)),
//           ],
//         ),
//         SliderTheme(
//           data: SliderThemeData(
//             activeTrackColor: _accent,
//             inactiveTrackColor: Colors.white.withAlpha(30),
//             thumbColor: _accent,
//             overlayColor: _accent.withAlpha(30),
//             rangeThumbShape:
//                 const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
//           ),
//           child: RangeSlider(
//             values: values,
//             min: min,
//             max: max,
//             onChanged: onChanged,
//           ),
//         ),
//       ],
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   // ALL USERS GRID  (flip-card style)
//   // ════════════════════════════════════════════════════════════════

//   Widget _buildUsersGrid(PanelState s) {
//     final users = s.filteredUsers;

//     if (users.isEmpty) {
//       return SliverToBoxAdapter(
//         child: Container(
//           margin: const EdgeInsets.all(40),
//           padding: const EdgeInsets.symmetric(vertical: 50),
//           decoration: BoxDecoration(
//             color: _card,
//             borderRadius: BorderRadius.circular(24),
//           ),
//           child: Column(
//             children: [
//               Icon(Icons.search,
//                   size: 60, color: Colors.white.withAlpha(40)),
//               const SizedBox(height: 16),
//               const Text('No Records Found',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               Text('Try adjusting your filters to find more results.',
//                   style: TextStyle(
//                       color: Colors.white.withAlpha(80), fontSize: 14)),
//             ],
//           ),
//         ),
//       );
//     }

//     return SliverPadding(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           childAspectRatio: 0.44,
//         ),
//         delegate: SliverChildBuilderDelegate(
//           (context, index) => _FlipCardWidget(
//             user: users[index],
//             onViewMore: () => _navigateToUserProfile(users[index]),
//             onCalendar: () => _showCalendarDialog(
//                 users[index].id, users[index].username),
//           ),
//           childCount: users.length,
//         ),
//       ),
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   // CALENDAR DIALOG
//   // ════════════════════════════════════════════════════════════════

//   void _showCalendarDialog(String payPerId, String username) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: 'Calendar',
//       barrierColor: Colors.black87,
//       transitionDuration: const Duration(milliseconds: 350),
//       pageBuilder: (ctx, anim1, anim2) => Center(
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             width: MediaQuery.of(ctx).size.width * 0.92,
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(ctx).size.height * 0.7,
//             ),
//             decoration: BoxDecoration(
//               color: _card,
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(color: Colors.white.withAlpha(20)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // ── Header ─────────────────────────────────────
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
//                   decoration: const BoxDecoration(
//                     gradient:
//                         LinearGradient(colors: [_accent, Color(0xFF5C2438)]),
//                     borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(24)),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.calendar_month,
//                           color: Colors.white, size: 22),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(username,
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis),
//                             const SizedBox(height: 2),
//                             const Text('Booked Slots',
//                                 style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 12)),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.white70, size: 22),
//                         onPressed: () => Navigator.pop(ctx),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // ── Slots list ──────────────────────────────────
//                 Flexible(
//                   child: Padding(
//                     padding: const EdgeInsets.all(14),
//                     child: FutureBuilder<List<CalendarSlot>>(
//                       future: ref
//                           .read(panelProvider.notifier)
//                           .fetchCalendar(payPerId),
//                       builder: (ctx, snap) {
//                         if (snap.connectionState == ConnectionState.waiting) {
//                           return const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: Center(
//                                 child:
//                                     CircularProgressIndicator(color: _accent)),
//                           );
//                         }
//                         final slots = snap.data ?? [];
//                         if (slots.isEmpty) {
//                           return const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: Center(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.event_busy,
//                                       color: Colors.white24, size: 40),
//                                   SizedBox(height: 12),
//                                   Text('No booked slots found',
//                                       style: TextStyle(
//                                           color: Colors.white54, fontSize: 14)),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }
//                         return ListView.separated(
//                           shrinkWrap: true,
//                           padding: EdgeInsets.zero,
//                           itemCount: slots.length,
//                           separatorBuilder: (_, __) => const SizedBox(height: 8),
//                           itemBuilder: (ctx, i) {
//                             final slot = slots[i];
//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 10),
//                               decoration: BoxDecoration(
//                                 color: _surface,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                     color: Colors.white.withAlpha(15)),
//                               ),
//                               child: Row(
//                                 children: [
//                                   // Number badge
//                                   Container(
//                                     width: 28,
//                                     height: 28,
//                                     decoration: BoxDecoration(
//                                       color: _accent.withAlpha(30),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Center(
//                                       child: Text('${i + 1}',
//                                           style: const TextStyle(
//                                               color: _accent,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12)),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   // Name + date
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(slot.username,
//                                             style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 13),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis),
//                                         const SizedBox(height: 2),
//                                         Text(slot.calenderDate,
//                                             style: TextStyle(
//                                                 color: _gold,
//                                                 fontSize: 11)),
//                                       ],
//                                     ),
//                                   ),
//                                   // Time range
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8, vertical: 4),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withAlpha(8),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                       children: [
//                                         Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(Icons.play_arrow,
//                                                 color:
//                                                     Colors.greenAccent.shade400,
//                                                 size: 12),
//                                             const SizedBox(width: 3),
//                                             Text(slot.startTime12Format,
//                                                 style: const TextStyle(
//                                                     color: Colors.greenAccent,
//                                                     fontSize: 11)),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 1),
//                                         Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(Icons.stop,
//                                                 color: Colors.redAccent.shade200,
//                                                 size: 12),
//                                             const SizedBox(width: 3),
//                                             Text(slot.endTime12Format,
//                                                 style: TextStyle(
//                                                     color:
//                                                         Colors.redAccent.shade200,
//                                                     fontSize: 11)),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       transitionBuilder: (ctx, anim1, anim2, child) =>
//           ScaleTransition(scale: anim1, child: child),
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   // NAVIGATE TO USER PROFILE
//   // ════════════════════════════════════════════════════════════════

//   void _navigateToUserProfile(ChocolateFactoryUser user) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CelebrityProfileDetailPage(
//           userId: user.id,
//           username: user.username,
//           profileImageUrl: user.profileImage,
//           userState: user.stateOfResidence,
//         ),
//       ),
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   // NETWORK IMAGE HELPER
//   // ════════════════════════════════════════════════════════════════

//   Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
//     if (url.isEmpty) {
//       return Container(
//         color: _surface,
//         child: const Center(
//             child: Icon(Icons.person, color: Colors.white24, size: 50)),
//       );
//     }
//     String full = url;
//     if (!url.startsWith('http')) full = '$kAssetBase$url';
//     return Image.network(
//       full,
//       fit: fit,
//       errorBuilder: (_, __, ___) => Container(
//         color: _surface,
//         child: const Center(
//             child: Icon(Icons.person, color: Colors.white24, size: 50)),
//       ),
//       loadingBuilder: (_, child, progress) {
//         if (progress == null) return child;
//         return Container(
//           color: _surface,
//           child: const Center(
//             child: CircularProgressIndicator(
//                 color: _accent, strokeWidth: 2),
//           ),
//         );
//       },
//     );
//   }
// }

// // ════════════════════════════════════════════════════════════════════
// // FLIP CARD — tap to flip between front (image) and back (info)
// // ════════════════════════════════════════════════════════════════════

// class _FlipCardWidget extends StatefulWidget {
//   final ChocolateFactoryUser user;
//   final VoidCallback onViewMore;
//   final VoidCallback onCalendar;

//   const _FlipCardWidget({
//     required this.user,
//     required this.onViewMore,
//     required this.onCalendar,
//   });

//   @override
//   State<_FlipCardWidget> createState() => _FlipCardWidgetState();
// }

// class _FlipCardWidgetState extends State<_FlipCardWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _showFront = true;

//   static const _bg = Color(0xFF13132B);
//   static const _accent = Color(0xFFE91E63);
//   static const _surface = Color(0xFF1C1C3A);
//   static const _gold = Color(0xFFF4BA4A);

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _flip() {
//     if (_showFront) {
//       _controller.forward();
//     } else {
//       _controller.reverse();
//     }
//     setState(() => _showFront = !_showFront);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final u = widget.user;
//     return GestureDetector(
//       onTap: _flip,
//       child: AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           final angle = _animation.value * 3.14159265;
//           final isFront = angle < 1.5708;
//           return Transform(
//             alignment: Alignment.center,
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.001)
//               ..rotateY(angle),
//             child: isFront
//                 ? _buildFront(u)
//                 : Transform(
//                     alignment: Alignment.center,
//                     transform: Matrix4.identity()..rotateY(3.14159265),
//                     child: _buildBack(u),
//                   ),
//           );
//         },
//       ),
//     );
//   }

//   // ── Front ──────────────────────────────────────────────────────

//   Widget _buildFront(ChocolateFactoryUser u) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: _bg,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withAlpha(80),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: _networkImg(u.profileImage),
//             ),
//           ),
//           Positioned(
//             top: 10,
//             left: 10,
//             child: Image.network(
//               '${kAssetBase}img/badge1.png',
//               width: 40,
//               height: 40,
//               errorBuilder: (_, __, ___) =>
//                   const Icon(Icons.verified, color: _gold, size: 28),
//             ),
//           ),
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.transparent,
//                     Colors.black.withAlpha(200),
//                   ],
//                   stops: const [0.0, 0.5, 1.0],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 14,
//             bottom: 14,
//             right: 14,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(u.username,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis),
//                 if (u.showAge == '1')
//                   Text('Age ${u.age}',
//                       style: TextStyle(
//                           color: Colors.white.withAlpha(180), fontSize: 12)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Back ───────────────────────────────────────────────────────

//   Widget _buildBack(ChocolateFactoryUser u) {
//     return Container(
//       clipBehavior: Clip.antiAlias,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         gradient: LinearGradient(
//           colors: [Color(0xFF560827), Color(0xFF06032C)],
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // Username
//             FittedBox(
//               child: Text(u.username,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                   maxLines: 1),
//             ),
//             // Location
//             if (u.stateOfResidence.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: Text(u.stateOfResidence,
//                     style: TextStyle(
//                         color: Colors.white.withAlpha(160), fontSize: 11),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.center),
//               ),
//             // Stat chips
//             Wrap(
//               alignment: WrapAlignment.center,
//               spacing: 4,
//               runSpacing: 4,
//               children: [
//                 if (u.showAge == '1') _backChip('${u.age} yrs'),
//                 if (u.showHeight == '1')
//                   _backChip("${u.heightFeet}' ${u.heightInch}\""),
//                 if (u.showWeight == '1') _backChip('${u.weight} Kg'),
//               ],
//             ),
//             // Preferences
//             if (u.showPreferences == '1' && u.preferences.isNotEmpty)
//               Wrap(
//                 spacing: 4,
//                 runSpacing: 4,
//                 alignment: WrapAlignment.center,
//                 children: u.preferences.take(3).map((p) {
//                   return Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                     decoration: BoxDecoration(
//                       color: _accent.withAlpha(40),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(p,
//                         style: const TextStyle(color: _accent, fontSize: 9)),
//                   );
//                 }).toList(),
//               ),
//             // View More button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: widget.onViewMore,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _accent,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   minimumSize: Size.zero,
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 ),
//                 child: const Text('View More',
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//               ),
//             ),
//             // Calendar button
//             GestureDetector(
//               onTap: widget.onCalendar,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 7),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: _gold.withAlpha(80)),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.calendar_today, color: _gold, size: 14),
//                     const SizedBox(width: 4),
//                     const Text('Calendar',
//                         style: TextStyle(color: _gold, fontSize: 11)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _backChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.white.withAlpha(15),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(text,
//           style: const TextStyle(color: Colors.white, fontSize: 11)),
//     );
//   }

//   Widget _networkImg(String url) {
//     if (url.isEmpty) {
//       return Container(
//         color: _surface,
//         child: const Center(
//             child: Icon(Icons.person, color: Colors.white24, size: 50)),
//       );
//     }
//     String full = url;
//     if (!url.startsWith('http')) full = '$kAssetBase$url';
//     return Image.network(
//       full,
//       fit: BoxFit.cover,
//       errorBuilder: (_, __, ___) => Container(
//         color: _surface,
//         child: const Center(
//             child: Icon(Icons.person, color: Colors.white24, size: 50)),
//       ),
//       loadingBuilder: (_, child, progress) {
//         if (progress == null) return child;
//         return Container(
//           color: _surface,
//           child: const Center(
//             child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
//           ),
//         );
//       },
//     );
//   }
// }



// ╔═══════════════════════════════════════════════════════════════════╗
// ║  Celebrity Panel – Pay-Per-Click Chocolate Factory               ║
// ║  Riverpod 3 compatible                                           ║
// ╚═══════════════════════════════════════════════════════════════════╝

import 'dart:convert';

import 'package:beatflirt/screens/drawer_pages/celebrity_panel_next_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ════════════════════════════════════════════════════════════════════
// 1) API CONSTANTS
// ════════════════════════════════════════════════════════════════════

const String kApiBase = 'https://app.beatflirtevent.com/App';
const String kAssetBase = 'https://app.beatflirtevent.com/assets/';

const List<String> kPreferenceOptions = [
  'Orgy',
  'Gang Bang',
  'Couple',
  'BDSM',
  'Dom',
  'Sub',
  'Cuckolder',
  'Bull Stag',
];

// ════════════════════════════════════════════════════════════════════
// 2) DATA MODELS
// ════════════════════════════════════════════════════════════════════

class ChocolateFactoryUser {
  final String id;
  final String username;
  final String age;
  final String showAge;
  final String stateOfResidence;
  final String heightFeet;
  final String heightInch;
  final String showHeight;
  final String weight;
  final String showWeight;
  final List<String> preferences;
  final String showPreferences;
  final String selfDescription;
  final List<ChocolateFactoryImage> images;

  const ChocolateFactoryUser({
    required this.id,
    required this.username,
    required this.age,
    required this.showAge,
    required this.stateOfResidence,
    required this.heightFeet,
    required this.heightInch,
    required this.showHeight,
    required this.weight,
    required this.showWeight,
    required this.preferences,
    required this.showPreferences,
    required this.selfDescription,
    required this.images,
  });

  String get profileImage => images.isNotEmpty ? images.first.profileImage : '';

  String get displayHeight => "$heightFeet' $heightInch\"";

  factory ChocolateFactoryUser.fromJson(Map<String, dynamic> j) {
    return ChocolateFactoryUser(
      id: '${j['id'] ?? ''}',
      username: '${j['username'] ?? ''}',
      age: '${j['age'] ?? ''}',
      showAge: '${j['show_age'] ?? '0'}',
      stateOfResidence: '${j['state_of_residence'] ?? ''}',
      heightFeet: '${j['height_feet'] ?? ''}',
      heightInch: '${j['height_inch'] ?? ''}',
      showHeight: '${j['show_height'] ?? '0'}',
      weight: '${j['weight'] ?? ''}',
      showWeight: '${j['show_weight'] ?? '0'}',
      preferences: (j['preferences'] as List<dynamic>?)
              ?.map((e) => '$e')
              .toList() ??
          [],
      showPreferences: '${j['show_preferences'] ?? '0'}',
      selfDescription: '${j['self_description'] ?? ''}',
      images: (j['image'] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (e) => ChocolateFactoryImage.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList() ??
          [],
    );
  }
}

class ChocolateFactoryImage {
  final String profileImage;

  const ChocolateFactoryImage({
    required this.profileImage,
  });

  factory ChocolateFactoryImage.fromJson(Map<String, dynamic> j) {
    return ChocolateFactoryImage(
      profileImage: '${j['profile_image'] ?? ''}',
    );
  }
}

class CalendarSlot {
  final String username;
  final String calenderDate;
  final String startTime12Format;
  final String endTime12Format;

  const CalendarSlot({
    required this.username,
    required this.calenderDate,
    required this.startTime12Format,
    required this.endTime12Format,
  });

  factory CalendarSlot.fromJson(Map<String, dynamic> j) {
    return CalendarSlot(
      username: '${j['username'] ?? ''}',
      calenderDate: '${j['calender_date'] ?? ''}',
      startTime12Format: '${j['start_time_12_formate'] ?? ''}',
      endTime12Format: '${j['end_time_12_formate'] ?? ''}',
    );
  }
}

class TermsCondition {
  final String description;

  const TermsCondition({
    required this.description,
  });

  factory TermsCondition.fromJson(Map<String, dynamic> j) {
    return TermsCondition(
      description: '${j['description'] ?? ''}',
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// 3) STATE
// ════════════════════════════════════════════════════════════════════

class PanelState {
  final bool isLoading;
  final String? error;
  final ChocolateFactoryUser? myProfile;
  final List<ChocolateFactoryUser> allUsers;
  final String searchQuery;
  final int ageMin;
  final int ageMax;
  final int heightMin;
  final int heightMax;
  final int weightMin;
  final int weightMax;
  final List<String> selectedPreferences;

  const PanelState({
    this.isLoading = false,
    this.error,
    this.myProfile,
    this.allUsers = const [],
    this.searchQuery = '',
    this.ageMin = 18,
    this.ageMax = 80,
    this.heightMin = 3,
    this.heightMax = 8,
    this.weightMin = 20,
    this.weightMax = 150,
    this.selectedPreferences = const [],
  });

  PanelState copyWith({
    bool? isLoading,
    String? error,
    ChocolateFactoryUser? myProfile,
    List<ChocolateFactoryUser>? allUsers,
    String? searchQuery,
    int? ageMin,
    int? ageMax,
    int? heightMin,
    int? heightMax,
    int? weightMin,
    int? weightMax,
    List<String>? selectedPreferences,
  }) {
    return PanelState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      myProfile: myProfile ?? this.myProfile,
      allUsers: allUsers ?? this.allUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      heightMin: heightMin ?? this.heightMin,
      heightMax: heightMax ?? this.heightMax,
      weightMin: weightMin ?? this.weightMin,
      weightMax: weightMax ?? this.weightMax,
      selectedPreferences:
          selectedPreferences ?? this.selectedPreferences,
    );
  }

  List<ChocolateFactoryUser> get filteredUsers {
    var list = allUsers;

    if (searchQuery.isNotEmpty) {
      list = list
          .where(
            (u) => u.username
                .toLowerCase()
                .contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return list;
  }
}

// ════════════════════════════════════════════════════════════════════
// 4) NOTIFIER - RIVERPOD 3
// ════════════════════════════════════════════════════════════════════

class PanelNotifier extends Notifier<PanelState> {
  String? _accessToken;
  String? _accessSign;

  @override
  PanelState build() {
    Future.microtask(_loadToken);
    return const PanelState();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();

    debugPrint('═══ CelebrityPanel — ALL SharedPreferences Keys ═══');

    final allKeys = prefs.getKeys();

    for (final key in allKeys) {
      final val = prefs.get(key);
      final valStr = val.toString();
      final preview =
          valStr.length > 40 ? '${valStr.substring(0, 40)}...' : valStr;

      debugPrint('  KEY: "$key" → $preview');
    }

    debugPrint('════════════════════════════════════════════════════');

    _accessToken = prefs.getString('Access-Token') ??
        prefs.getString('access_token') ??
        prefs.getString('accessToken') ??
        prefs.getString('token') ??
        prefs.getString('auth_token') ??
        prefs.getString('access_token_key') ??
        prefs.getString('user_token');

    _accessSign = prefs.getString('Access-Sign') ??
        prefs.getString('access_sign') ??
        prefs.getString('accessSign') ??
        prefs.getString('sign') ??
        prefs.getString('Access_Sign') ??
        prefs.getString('access-sign') ??
        prefs.getString('sign_key') ??
        prefs.getString('user_sign') ??
        prefs.getString('secret') ??
        prefs.getString('secret_key') ??
        prefs.getString('user_secret');

    debugPrint('═══ CelebrityPanel ═══');
    debugPrint('  Access-Token : ${_mask(_accessToken)}');
    debugPrint('  Access-Sign  : ${_mask(_accessSign)}');
    debugPrint('═══════════════════════');

    await fetchPanel();
  }

  String _mask(String? value) {
    if (value == null || value.isEmpty) return 'NULL';

    final end = value.length > 20 ? 20 : value.length;
    return '${value.substring(0, end)}...';
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (_accessToken != null && _accessToken!.isNotEmpty)
        'Access-Token': _accessToken!,
      if (_accessSign != null && _accessSign!.isNotEmpty)
        'Access-Sign': _accessSign!,
    };
  }

  Future<Map<String, dynamic>?> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('$kApiBase$path');

      debugPrint('POST $uri headers=$_headers');

      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );

      debugPrint(
        '  → ${response.statusCode} body=${response.body.length > 200 ? response.body.substring(0, 200) : response.body}',
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      debugPrint('  → ERROR $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _get(String path) async {
    try {
      final uri = Uri.parse('$kApiBase$path');

      debugPrint('GET $uri headers=$_headers');

      final response = await http.get(
        uri,
        headers: _headers,
      );

      debugPrint(
        '  → ${response.statusCode} body=${response.body.length > 200 ? response.body.substring(0, 200) : response.body}',
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      debugPrint('  → ERROR $e');
      return null;
    }
  }

  bool _isOk(Map<String, dynamic>? response) {
    if (response == null) return false;

    final status = response['status'];

    return status != null && status.toString() == '200';
  }

  Future<void> fetchPanel() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final results = await Future.wait([
        _post(
          '/payperclick/get_chocolate_factory_data',
          {
            'user_type': 'me',
          },
        ),
        _post(
          '/payperclick/get_all_chocolate_factory_data',
          {
            'age_minvalue': state.ageMin,
            'age_maxvalue': state.ageMax,
            'height_minvalue': state.heightMin,
            'height_maxvalue': state.heightMax,
            'weight_minvalue': state.weightMin,
            'weight_maxvalue': state.weightMax,
            'preferencesArray': state.selectedPreferences,
          },
        ),
      ]);

      ChocolateFactoryUser? myProfile;

      final me = results[0];

      if (_isOk(me)) {
        final data = me!['data'];

        if (data is List && data.isNotEmpty && data.first is Map) {
          myProfile = ChocolateFactoryUser.fromJson(
            Map<String, dynamic>.from(data.first as Map),
          );
        }
      }

      List<ChocolateFactoryUser> allUsers = [];

      final all = results[1];

      if (_isOk(all)) {
        final data = all!['data'];

        if (data is List) {
          allUsers = data
              .whereType<Map>()
              .map(
                (e) => ChocolateFactoryUser.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList();
        }
      }

      debugPrint('  myProfile: ${myProfile?.username ?? "null"}');
      debugPrint('  allUsers count: ${allUsers.length}');

      state = state.copyWith(
        isLoading: false,
        myProfile: myProfile,
        allUsers: allUsers,
      );
    } catch (e) {
      debugPrint('  fetchPanel ERROR: $e');

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> applyFilters() {
    return fetchPanel();
  }

  void updateAge(RangeValues values) {
    state = state.copyWith(
      ageMin: values.start.round(),
      ageMax: values.end.round(),
    );
  }

  void updateHeight(RangeValues values) {
    state = state.copyWith(
      heightMin: values.start.round(),
      heightMax: values.end.round(),
    );
  }

  void updateWeight(RangeValues values) {
    state = state.copyWith(
      weightMin: values.start.round(),
      weightMax: values.end.round(),
    );
  }

  void togglePreference(String pref) {
    final list = [...state.selectedPreferences];

    if (list.contains(pref)) {
      list.remove(pref);
    } else {
      list.add(pref);
    }

    state = state.copyWith(
      selectedPreferences: list,
    );
  }

  void setSearch(String query) {
    state = state.copyWith(
      searchQuery: query,
    );
  }

  Future<List<CalendarSlot>> fetchCalendar(String payPerId) async {
    final response = await _post(
      '/payperclick/get_user_calender_details',
      {
        'pay_per_id': payPerId,
      },
    );

    if (_isOk(response)) {
      final data = response!['data'];

      if (data is List) {
        return data
            .whereType<Map>()
            .map(
              (e) => CalendarSlot.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      }
    }

    return [];
  }

  Future<TermsCondition?> fetchTerms() async {
    final response = await _get('/auth/pay_per_click_terms_condition');

    if (_isOk(response)) {
      final data = response!['data'];

      if (data is List && data.isNotEmpty && data.first is Map) {
        return TermsCondition.fromJson(
          Map<String, dynamic>.from(data.first as Map),
        );
      }
    }

    return null;
  }

  Future<bool> checkPost() async {
    final response = await _get('/payperclick/check_chocolate_factory_post');
    return _isOk(response);
  }

  Future<bool> checkPopup() async {
    final response = await _get('/payperclick/check_chocolate_factory_popup');
    return _isOk(response);
  }
}

// ════════════════════════════════════════════════════════════════════
// 5) PROVIDER - RIVERPOD 3
// ════════════════════════════════════════════════════════════════════

final panelProvider =
    NotifierProvider.autoDispose<PanelNotifier, PanelState>(
  PanelNotifier.new,
);

// ════════════════════════════════════════════════════════════════════
// 6) MAIN PAGE WIDGET
// ════════════════════════════════════════════════════════════════════

class CelebrityPanelPage extends ConsumerStatefulWidget {
  const CelebrityPanelPage({
    super.key,
  });

  @override
  ConsumerState<CelebrityPanelPage> createState() {
    return _CelebrityPanelPageState();
  }
}

class _CelebrityPanelPageState extends ConsumerState<CelebrityPanelPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();

  bool _filterExpanded = false;

  static const _bg = Color(0xFF0B0B1A);
  static const _card = Color(0xFF13132B);
  static const _accent = Color(0xFFE91E63);
  static const _gold = Color(0xFFF4BA4A);
  static const _surface = Color(0xFF1C1C3A);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(panelProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            expandedHeight: 130,
            floating: false,
            pinned: true,
            backgroundColor: _bg,
            elevation: 0,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = MediaQuery.of(context).padding.top;
                final collapsed = kToolbarHeight + top;
                final isCollapsed = constraints.maxHeight <= collapsed + 10;

                return FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: EdgeInsets.only(
                    left: isCollapsed ? 50 : 20,
                    bottom: 14,
                  ),
                  title: const Text(
                    'Celebrity Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_accent, _bg],
                        stops: [0.0, 0.8],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (state.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: _accent,
                ),
              ),
            )
          else if (state.error != null && state.allUsers.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white24,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load celebrities',
                      style: TextStyle(
                        color: Colors.white.withAlpha(153),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error ?? '',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        ref.read(panelProvider.notifier).fetchPanel();
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: _accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            if (state.myProfile != null) _buildMyProfileCard(state.myProfile!),
            _buildSearchBar(),
            _buildFilterPanel(state),
            _buildUsersGrid(state),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 40),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMyProfileCard(ChocolateFactoryUser user) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withAlpha(25),
          ),
          boxShadow: [
            BoxShadow(
              color: _accent.withAlpha(40),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: _networkImage(
                        user.profileImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _accent.withAlpha(200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        '${kAssetBase}img/badge1.png',
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.verified,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withAlpha(60),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(180),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.showAge == '1') ...[
                          const SizedBox(width: 8),
                          Text(
                            'Age ${user.age}',
                            style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: _accent,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.stateOfResidence,
                        style: TextStyle(
                          color: Colors.white.withAlpha(180),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (user.showHeight == '1')
                        _statChip(
                          Icons.height,
                          user.displayHeight,
                        ),
                      if (user.showHeight == '1') const SizedBox(width: 12),
                      if (user.showWeight == '1')
                        _statChip(
                          Icons.monitor_weight_outlined,
                          '${user.weight} Kg',
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (user.showPreferences == '1' &&
                      user.preferences.isNotEmpty) ...[
                    const Text(
                      'Preferences',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.preferences.map((pref) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _accent.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _accent.withAlpha(80),
                            ),
                          ),
                          child: Text(
                            pref,
                            style: const TextStyle(
                              color: _accent,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showCalendarDialog(
                              user.id,
                              user.username,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withAlpha(20),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: _gold,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Calendar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _accent.withAlpha(20),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _accent.withAlpha(60),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.rate_review,
                                  color: _accent,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Write Review',
                                    style: TextStyle(
                                      color: _accent,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (user.selfDescription.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white.withAlpha(150),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user.selfDescription,
                      style: TextStyle(
                        color: Colors.white.withAlpha(120),
                        fontSize: 13,
                        height: 1.5,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _gold,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    ref.read(panelProvider.notifier).setSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search celebrities...',
                    hintStyle: TextStyle(
                      color: Colors.white.withAlpha(100),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withAlpha(100),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _filterExpanded = !_filterExpanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: _filterExpanded
                      ? _accent
                      : _accent.withAlpha(30),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _accent.withAlpha(
                      _filterExpanded ? 255 : 120,
                    ),
                  ),
                ),
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _filterExpanded ? 0.125 : 0,
                  child: Icon(
                    Icons.tune,
                    color: _filterExpanded ? Colors.white : _accent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel(PanelState state) {
    if (!_filterExpanded) {
      return const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      );
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withAlpha(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _rangeSlider(
              label: 'Age',
              icon: Icons.cake,
              min: 18,
              max: 100,
              values: RangeValues(
                state.ageMin.toDouble(),
                state.ageMax.toDouble(),
              ),
              onChanged: (values) {
                ref.read(panelProvider.notifier).updateAge(values);
              },
            ),
            const SizedBox(height: 18),
            _rangeSlider(
              label: 'Height (ft)',
              icon: Icons.height,
              min: 0,
              max: 10,
              values: RangeValues(
                state.heightMin.toDouble(),
                state.heightMax.toDouble(),
              ),
              onChanged: (values) {
                ref.read(panelProvider.notifier).updateHeight(values);
              },
            ),
            const SizedBox(height: 18),
            _rangeSlider(
              label: 'Weight (Kg)',
              icon: Icons.monitor_weight_outlined,
              min: 20,
              max: 200,
              values: RangeValues(
                state.weightMin.toDouble(),
                state.weightMax.toDouble(),
              ),
              onChanged: (values) {
                ref.read(panelProvider.notifier).updateWeight(values);
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Preferences',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kPreferenceOptions.map((pref) {
                final selected = state.selectedPreferences.contains(pref);

                return GestureDetector(
                  onTap: () {
                    ref.read(panelProvider.notifier).togglePreference(pref);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? _accent : _surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? _accent
                            : Colors.white.withAlpha(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: selected
                              ? Colors.white
                              : Colors.white.withAlpha(80),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          pref,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.white.withAlpha(120),
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(panelProvider.notifier).applyFilters();
                },
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                label: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rangeSlider({
    required String label,
    required IconData icon,
    required double min,
    required double max,
    required RangeValues values,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: _gold,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${values.start.round()} – ${values.end.round()}',
              style: const TextStyle(
                color: _accent,
                fontSize: 13,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: _accent,
            inactiveTrackColor: Colors.white.withAlpha(30),
            thumbColor: _accent,
            overlayColor: _accent.withAlpha(30),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
            ),
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildUsersGrid(PanelState state) {
    final users = state.filteredUsers;

    if (users.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 26,
          ),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Icon(
                Icons.search,
                size: 60,
                color: Colors.white.withAlpha(40),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Records Found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters to find more results.',
                style: TextStyle(
                  color: Colors.white.withAlpha(80),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.44,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final user = users[index];

            return _FlipCardWidget(
              user: user,
              onViewMore: () {
                _navigateToUserProfile(user);
              },
              onCalendar: () {
                _showCalendarDialog(
                  user.id,
                  user.username,
                );
              },
            );
          },
          childCount: users.length,
        ),
      ),
    );
  }

  void _showCalendarDialog(String payPerId, String username) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Calendar',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(ctx).size.width * 0.92,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withAlpha(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_accent, Color(0xFF5C2438)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Booked Slots',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 22,
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: FutureBuilder<List<CalendarSlot>>(
                        future: ref
                            .read(panelProvider.notifier)
                            .fetchCalendar(payPerId),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(30),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: _accent,
                                ),
                              ),
                            );
                          }

                          final slots = snapshot.data ?? [];

                          if (slots.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(30),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      color: Colors.white24,
                                      size: 40,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'No booked slots found',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: slots.length,
                            separatorBuilder: (_, __) {
                              return const SizedBox(height: 8);
                            },
                            itemBuilder: (ctx, index) {
                              final slot = slots[index];

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(15),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: _accent.withAlpha(30),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: _accent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            slot.username,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            slot.calenderDate,
                                            style: const TextStyle(
                                              color: _gold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.play_arrow,
                                                color: Colors
                                                    .greenAccent.shade400,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                slot.startTime12Format,
                                                style: const TextStyle(
                                                  color: Colors.greenAccent,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 1),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.stop,
                                                color:
                                                    Colors.redAccent.shade200,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                slot.endTime12Format,
                                                style: TextStyle(
                                                  color:
                                                      Colors.redAccent.shade200,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return ScaleTransition(
          scale: anim1,
          child: child,
        );
      },
    );
  }

  void _navigateToUserProfile(ChocolateFactoryUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CelebrityProfileDetailPage(
          userId: user.id,
          username: user.username,
          profileImageUrl: user.profileImage,
          userState: user.stateOfResidence,
        ),
      ),
    );
  }

  Widget _networkImage(String url, {BoxFit fit = BoxFit.cover}) {
    if (url.isEmpty) {
      return Container(
        color: _surface,
        child: const Center(
          child: Icon(
            Icons.person,
            color: Colors.white24,
            size: 50,
          ),
        ),
      );
    }

    String fullUrl = url;

    if (!url.startsWith('http')) {
      fullUrl = '$kAssetBase$url';
    }

    return Image.network(
      fullUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: _surface,
          child: const Center(
            child: Icon(
              Icons.person,
              color: Colors.white24,
              size: 50,
            ),
          ),
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          color: _surface,
          child: const Center(
            child: CircularProgressIndicator(
              color: _accent,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// FLIP CARD
// ════════════════════════════════════════════════════════════════════

class _FlipCardWidget extends StatefulWidget {
  final ChocolateFactoryUser user;
  final VoidCallback onViewMore;
  final VoidCallback onCalendar;

  const _FlipCardWidget({
    required this.user,
    required this.onViewMore,
    required this.onCalendar,
  });

  @override
  State<_FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<_FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _showFront = true;

  static const _bg = Color(0xFF13132B);
  static const _accent = Color(0xFFE91E63);
  static const _surface = Color(0xFF1C1C3A);
  static const _gold = Color(0xFFF4BA4A);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * 3.14159265;
          final isFront = angle < 1.5708;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? _buildFront(user)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159265),
                    child: _buildBack(user),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront(ChocolateFactoryUser user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _networkImg(user.profileImage),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Image.network(
              '${kAssetBase}img/badge1.png',
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.verified,
                  color: _gold,
                  size: 28,
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withAlpha(200),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 14,
            right: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.showAge == '1')
                  Text(
                    'Age ${user.age}',
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(ChocolateFactoryUser user) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFF560827),
            Color(0xFF06032C),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FittedBox(
              child: Text(
                user.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            if (user.stateOfResidence.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  user.stateOfResidence,
                  style: TextStyle(
                    color: Colors.white.withAlpha(160),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              runSpacing: 4,
              children: [
                if (user.showAge == '1') _backChip('${user.age} yrs'),
                if (user.showHeight == '1')
                  _backChip("${user.heightFeet}' ${user.heightInch}\""),
                if (user.showWeight == '1') _backChip('${user.weight} Kg'),
              ],
            ),
            if (user.showPreferences == '1' &&
                user.preferences.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: user.preferences.take(3).map((pref) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withAlpha(40),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      pref,
                      style: const TextStyle(
                        color: _accent,
                        fontSize: 9,
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onViewMore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View More',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onCalendar,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _gold.withAlpha(80),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: _gold,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Calendar',
                      style: TextStyle(
                        color: _gold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _networkImg(String url) {
    if (url.isEmpty) {
      return Container(
        color: _surface,
        child: const Center(
          child: Icon(
            Icons.person,
            color: Colors.white24,
            size: 50,
          ),
        ),
      );
    }

    String fullUrl = url;

    if (!url.startsWith('http')) {
      fullUrl = '$kAssetBase$url';
    }

    return Image.network(
      fullUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: _surface,
          child: const Center(
            child: Icon(
              Icons.person,
              color: Colors.white24,
              size: 50,
            ),
          ),
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          color: _surface,
          child: const Center(
            child: CircularProgressIndicator(
              color: _accent,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
}