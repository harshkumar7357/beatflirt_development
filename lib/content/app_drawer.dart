// // // import 'package:flutter/material.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // import '../core/app_color_constants.dart';
// // // import '../core/app_constants.dart';
// // //
// // // class AppDrawer extends StatelessWidget {
// // //   const AppDrawer({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Drawer(
// // //       child: Column(
// // //         children: [
// // //           // ✅ Drawer Header
// // //            UserAccountsDrawerHeader(
// // //               decoration: const BoxDecoration(
// // //                 color: AppColors.primary,
// // //               ),
// // //               accountName: const Text(
// // //                 "Beat Flirt",
// // //                 style: TextStyle(fontWeight: FontWeight.bold),
// // //               ),
// // //               accountEmail: const Text("random@example.com"),
// // //               currentAccountPicture: const CircleAvatar(
// // //                 backgroundColor: Colors.white,
// // //                 child: Icon(Icons.person, size: 40, color: AppColors.primary)),
// // //               ),
// // //
// // //
// // //           // ✅ Drawer Items
// // //           _buildDrawerItem(
// // //             context,
// // //             icon:  Icons.person,
// // //             title: "Profile ",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //           const Spacer(),
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: Icons.notifications_none,
// // //             title: "BeatFlirt Notification",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon:Icons.star_purple500_sharp,
// // //             title: "Celebrity Panel",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: Icons.insert_emoticon_sharp,
// // //             title: "New Members",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //
// // //           const Spacer(),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: Icons.event_available_outlined,
// // //             title: "Events & Party",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //
// // //           const Spacer(),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: Icons.private_connectivity_rounded,
// // //             title: "Speed Date",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //
// // //           const Spacer(),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: Icons.mark_chat_read_outlined,
// // //             title: "Live Chatroom",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //
// // //           const Spacer(),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: Icons.privacy_tip_outlined,
// // //             title: "Privacy",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //
// // //           const Spacer(),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: Icons.upgrade,
// // //             title: "Upgrade",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //
// // //
// // //           const Spacer(),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: Icons.logout,
// // //             title: "Logout",
// // //             iconColor: Colors.black,
// // //             textColor: Colors.black,
// // //             onTap: () {
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ✅ Reusable Drawer Tile
// // //   Widget _buildDrawerItem(
// // //       BuildContext context, {
// // //         required IconData icon,
// // //         required String title,
// // //         required VoidCallback onTap,
// // //         Color? iconColor,
// // //         Color? textColor,
// // //       }) {
// // //     return ListTile(
// // //       leading: Icon(
// // //         icon,
// // //         color: iconColor ?? AppColors.textPrimary,
// // //       ) ,
// // //
// // //       title: Text(
// // //         title,
// // //         style: TextStyle(
// // //           color: textColor ?? AppColors.textPrimary,
// // //           fontWeight: FontWeight.w500,
// // //         ),
// // //       ),
// // //       onTap: onTap,
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import '../core/app_color_constants.dart';
// // import '../core/app_constants.dart';
// //
// // class AppDrawer extends StatefulWidget {
// //   const AppDrawer({Key? key}) : super(key: key);
// //
// //   @override
// //   State<AppDrawer> createState() => _AppDrawerState();
// // }
// //
// // class _AppDrawerState extends State<AppDrawer> {
// //   bool _isProfileExpanded = false;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Drawer(
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //           children: [
// //             _buildDrawerHeader(context),
// //             // _buildDrawerItem(
// //             //   icon: Icons.home,
// //             //   title: 'Home',
// //             //   onTap: () => _navigateTo(context, '/home'),
// //             // ),
// //             // _buildDrawerItem(
// //             //   icon: Icons.person,
// //             //   title: 'Profile',
// //             //   onTap: () => _navigateTo(context, '/profile'),
// //             // ),
// //             // _buildDrawerItem(
// //             //   icon: Icons.settings,
// //             //   title: 'Settings',
// //             //   onTap: () => _navigateTo(context, '/settings'),
// //             // ),
// //             // const Divider(),
// //             // _buildDrawerItem(
// //             //   icon: Icons.info,
// //             //   title: 'About',
// //             //   onTap: () => _navigateTo(context, '/about'),
// //             // ),
// //             // _buildDrawerItem(
// //             //   icon: Icons.logout,
// //             //   title: 'Logout',
// //             //   onTap: () => _logout(context),
// //             // ),
// //
// //             // ✅ Drawer Items
// //           // _buildDrawerItem(
// //           //   context,
// //           //   icon:  Icons.person,
// //           //   title: "Profile ",
// //           //   // iconColor: Colors.black,
// //           //   // textColor: Colors.black,
// //           //   onTap: () {
// //           //    _buildExpandableProfile(context);
// //           //   },
// //           // ),
// //
// //             _buildExpandableProfile(context),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.notifications_none,
// //             title: "BeatFlirt Notification",
// //             // iconColor: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon:Icons.star_purple500_sharp,
// //             title: "Celebrity Panel",
// //             // iconColor: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.insert_emoticon_sharp,
// //             title: "New Members",
// //             // iconColor: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.event_available_outlined,
// //             title: "Events & Party",
// //             // iconColor: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //
// //             const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.private_connectivity_rounded,
// //             title: "Speed Date",
// //             // iconColor: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.mark_chat_read_outlined,
// //             title: "Live Chatroom",
// //             // iconColor: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.privacy_tip_outlined,
// //             title: "Privacy",
// //             // icon: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.upgrade,
// //             title: "Upgrade",
// //             // iconColor: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.logout,
// //             title: "Logout",
// //             // iconColor: Colors.black,
// //             // textColor: Colors.black,
// //             onTap: () {
// //               // Navigator.pop(context);
// //               _logout(context);
// //             },
// //           ),
// //           ],
// //         ),
// //
// //     );
// //   }
// //
// //   Widget _buildDrawerHeader(BuildContext context) {
// //     return DrawerHeader(
// //       padding: EdgeInsets.zero,
// //       decoration: BoxDecoration(
// //         color: Colors.purple.withOpacity(0.5),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           CircleAvatar(
// //             radius: 40,
// //             backgroundImage: const AssetImage("assets/logo/logo.png"),
// //             backgroundColor: Colors.pink.withOpacity(0.9),
// //           ),
// //           const SizedBox(height: 10),
// //           const Text(
// //             'Beat Flirt',
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           Text(
// //             'random@example.com',
// //             style: TextStyle(
// //               color: Colors.white.withOpacity(0.8),
// //               fontSize: 14,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDrawerItem(BuildContext context, {
// //     required IconData icon,
// //     required String title,
// //     required VoidCallback onTap,
// //   }) {
// //     return ListTile(
// //       leading: Icon(icon),
// //       title: Text(title),
// //       onTap: onTap,
// //     );
// //   }
// //
// //   void _navigateTo(BuildContext context, String route) {
// //     Navigator.pop(context);
// //     Navigator.pushNamed(context, route);
// //   }
// //
// //   void _logout(BuildContext context) {
// //     Navigator.pop(context);
// //     // Add logout logic here
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Logout'),
// //         content: const Text('Are you sure you want to logout?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               // Perform logout
// //             },
// //             child: const Text('Logout'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // // ✅ Expandable Profile Widget
// // Widget _buildExpandableProfile(BuildContext context) {
// //   // bool _isProfileExpanded = false;
// //   return Column(
// //     children: [
// //       ListTile(
// //         leading: const Icon(Icons.person, color: Colors.black87),
// //         title: const Text(
// //           "Profile",
// //           style: TextStyle(
// //             fontWeight: FontWeight.w500,
// //             color: Colors.black87,
// //           ),
// //         ),
// //         trailing: AnimatedRotation(
// //           turns: _isProfileExpanded ? 0.5 : 0,
// //           duration: const Duration(milliseconds: 300),
// //           child: const Icon(Icons.keyboard_arrow_down),
// //         ),
// //         onTap: () {
// //           setState(() {
// //             _isProfileExpanded = !_isProfileExpanded;
// //           });
// //         },
// //       ),
// //
// //       // ✅ Expandable Content
// //       // AnimatedContainer(
// //       //   duration: const Duration(milliseconds: 300),
// //       //   curve: Curves.easeInOut,
// //       //   height: _isProfileExpanded ? null : 0,
// //       //   child: _isProfileExpanded
// //       //       ?
// //         if(_isProfileExpanded)
// //               Container(
// //           color: Colors.grey[100],
// //           child: Column(
// //             children: [
// //               _buildSubMenuItem(
// //                 context,
// //                 icon: Icons.account_circle,
// //                 title: "View Profile",
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   // Navigate to view profile
// //                 },
// //               ),
// //               _buildSubMenuItem(
// //                 context,
// //                 icon: Icons.edit,
// //                 title: "Edit Profile",
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   // Navigate to edit profile
// //                 },
// //               ),
// //               _buildSubMenuItem(
// //                 context,
// //                 icon: Icons.photo_library,
// //                 title: "My Photos",
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   // Navigate to photos
// //                 },
// //               ),
// //               _buildSubMenuItem(
// //                 context,
// //                 icon: Icons.history,
// //                 title: "Activity History",
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   // Navigate to activity history
// //                 },
// //               ),
// //               _buildSubMenuItem(
// //                 context,
// //                 icon: Icons.verified_user,
// //                 title: "Verification",
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   // Navigate to verification
// //                 },
// //               ),
// //             ],
// //           ),
// //         )
// //             : const SizedBox.shrink(),
// //       ),
// //     ],
// //   );
// // }
// //
// // // ✅ Sub Menu Item Widget
// // Widget _buildSubMenuItem(
// //     BuildContext context, {
// //       required IconData icon,
// //       required String title,
// //       required VoidCallback onTap,
// //     }) {
// //   return ListTile(
// //     contentPadding: const EdgeInsets.only(left: 72, right: 16),
// //     leading: Icon(icon, size: 20, color: AppColors.primary),
// //     title: Text(
// //       title,
// //       style: TextStyle(
// //         fontSize: 14,
// //         color: Colors.grey[800],
// //       ),
// //     ),
// //     onTap: onTap,
// //   );
// // }
//
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../Api_services/api_services.dart';
// import '../core/app_color_constants.dart';
// import '../core/services/auth_services.dart';
// import '../screens/drawer_pages.dart';
// import '../screens/login_page.dart';
//
// class AppDrawer extends StatefulWidget {
//   const AppDrawer({super.key});
//
//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//   // ✅ Move the state variable here (inside the State class)
//   bool _isProfileExpanded = false;
//   final ApiServices _apiServices = ApiServices();
//   String _headerEmail = 'Loading...';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadDrawerEmail();
//   }
//
//   Future<void> _loadDrawerEmail() async {
//     final savedEmail = await AuthService.getSavedEmail();
//     if (savedEmail != null && savedEmail.isNotEmpty && mounted) {
//       setState(() {
//         _headerEmail = savedEmail;
//       });
//     }
//
//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) return;
//       final profile = await _apiServices.getProfile(token: token);
//       final user = profile['user'];
//       String? email;
//       if (user is Map) {
//         email = user['email']?.toString();
//       }
//       if (email != null && email.isNotEmpty) {
//         await AuthService.saveEmail(email);
//         if (!mounted) return;
//         setState(() {
//           _headerEmail = email!;
//         });
//       }
//     } catch (_) {
//       // Keep cached email on API failure.
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           _buildDrawerHeader(context),
//
//           // ✅ Call the expandable profile here
//           _buildExpandableProfile(),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.solidBell,
//             title: "BeatFlirt Notification",
//             onTap: () {
//               _openDrawerPage(context, const BeatFlirtNotificationPage());
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.crown,
//             title: "Celebrity Panel",
//             onTap: () {
//               _openDrawerPage(context, const CelebrityPanelPage());
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.userPlus,
//             title: "New Members",
//             onTap: () {
//               _openDrawerPage(context, const NewMembersPage());
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.champagneGlasses,
//             title: "Events & Party",
//             onTap: () {
//               _openDrawerPage(context, const EventsPartyPage());
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.bolt,
//             title: "Speed Date",
//             onTap: () {
//               _openDrawerPage(context, const SpeedDatePage());
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.comments,
//             title: "Live Chatroom",
//             onTap: () {
//               _openDrawerPage(context, const LiveChatroomPage());
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.userShield,
//             title: "Privacy",
//             onTap: () {
//               _openDrawerPage(context, const PrivacyPage());
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.rocket,
//             title: "Upgrade",
//             onTap: () {
//               _openDrawerPage(context, const UpgradePage());
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: FontAwesomeIcons.rightFromBracket,
//             title: "Logout",
//             onTap: () {
//               _logout(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawerHeader(BuildContext context) {
//     return DrawerHeader(
//       padding: EdgeInsets.zero,
//       decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.5)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundImage: const AssetImage("assets/logo/logo.png"),
//             backgroundColor: Colors.pink.withValues(alpha: 0.9),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Beat Flirt',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             _headerEmail,
//             style: TextStyle(
//               color: Colors.white.withValues(alpha: 0.8),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ✅ Move this method inside the State class
//   Widget _buildExpandableProfile() {
//     return Column(
//       children: [
//         ListTile(
//           leading: const Icon(Icons.person, color: Colors.black87),
//           title: const Text(
//             "Profile",
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           trailing: AnimatedRotation(
//             turns: _isProfileExpanded ? 0.5 : 0,
//             duration: const Duration(milliseconds: 300),
//             child: const Icon(Icons.keyboard_arrow_down),
//           ),
//           onTap: () {
//             setState(() {
//               _isProfileExpanded = !_isProfileExpanded;
//             });
//           },
//         ),
//
//         // ✅ Expandable Content
//         if (_isProfileExpanded)
//           Container(
//             color: Colors.grey[100],
//             child: Column(
//               children: [
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.idBadge,
//                   title: "My Profile",
//                   onTap: () {
//                     _openDrawerPage(context, const MyProfilePage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.userGear,
//                   title: "Account",
//                   onTap: () {
//                     _openDrawerPage(context, const AccountPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.signal,
//                   title: "Online",
//                   onTap: () {
//                     _openDrawerPage(context, const OnlinePage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.userGroup,
//                   title: "Friends",
//                   onTap: () {
//                     _openDrawerPage(context, const FriendsPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.userClock,
//                   title: "Friend Request",
//                   onTap: () {
//                     _openDrawerPage(context, const FriendRequestPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.user,
//                   title: "New Member",
//                   onTap: () {
//                     _openDrawerPage(context, const NewMemberPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.solidCircleCheck,
//                   title: "Validation",
//                   onTap: () {
//                     _openDrawerPage(context, const ValidationPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.clipboardCheck,
//                   title: "Validation Request",
//                   onTap: () {
//                     _openDrawerPage(context, const ValidationRequestPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.eye,
//                   title: "Viewed Me",
//                   onTap: () {
//                     _openDrawerPage(context, const ViewedMePage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.solidHeart,
//                   title: "Likes",
//                   onTap: () {
//                     _openDrawerPage(context, const LikesPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.userSlash,
//                   title: "Blocklist",
//                   onTap: () {
//                     _openDrawerPage(context, const BlocklistPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.solidStar,
//                   title: "Favorite",
//                   onTap: () {
//                     _openDrawerPage(context, const FavoritePage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   icon: FontAwesomeIcons.solidNoteSticky,
//                   title: "Notes",
//                   onTap: () {
//                     _openDrawerPage(context, const NotesPage());
//                   },
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
//
//   // ✅ Move this method inside the State class
//   Widget _buildSubMenuItem({
//     required Object icon,
//     // required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       contentPadding: const EdgeInsets.only(left: 72, right: 16),
//       // leading: _buildDrawerLeadingIcon(icon, color: AppColors.primary, size: 20),
//       leading: _buildDrawerLeadingIcon(icon, color: Colors.black, size: 20),
//       title: Text(
//         title,
//         style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildDrawerItem(
//     BuildContext context, {
//     required Object icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: _buildDrawerLeadingIcon(icon, color: Colors.black87),
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.w500,
//           color: Colors.black87,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildDrawerLeadingIcon(
//     Object icon, {
//     required Color color,
//     double size = 22,
//   }) {
//     if (icon is IconData) {
//       return Icon(icon, color: color, size: size);
//     }
//     if (icon is FaIconData) {
//       return FaIcon(icon, color: color, size: size - 2);
//     }
//     return Icon(Icons.circle, color: color, size: size);
//   }
//
//   void _openDrawerPage(BuildContext context, Widget page) {
//     Navigator.pop(context);
//     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//   }
//
//   void _logout(BuildContext context) {
//     Navigator.pop(context);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.black
//             ),
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await AuthService.logout();
//               if (!context.mounted) return;
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()),
//                 (route) => false,
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/services/auth_services.dart';
import '../providers/drawer_providers.dart';
import '../screens/drawer_pages.dart';
import '../screens/login_page.dart';

// ✅ Change StatefulWidget to ConsumerStatefulWidget
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch providers instead of using state variables
    final isProfileExpanded = ref.watch(profileExpansionProvider);
    final headerEmail = ref.watch(drawerEmailProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context, headerEmail),
          _buildExpandableProfile(context, ref, isProfileExpanded),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.solidBell,
            title: "BeatFlirt Notification",
            onTap: () {
              _openDrawerPage(context, const BeatFlirtNotificationPage());
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.crown,
            title: "Celebrity Panel",
            onTap: () {
              _openDrawerPage(context, const CelebrityPanelPage());
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.userPlus,
            title: "New Members",
            onTap: () {
              _openDrawerPage(context, const NewMembersPage());
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.champagneGlasses,
            title: "Events & Party",
            onTap: () {
              _openDrawerPage(context, const EventsPartyPage());
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.bolt,
            title: "Speed Date",
            onTap: () {
              _openDrawerPage(context, const SpeedDatePage());
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.comments,
            title: "Live Chatroom",
            onTap: () {
              _openDrawerPage(context, const LiveChatroomPage());
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.userShield,
            title: "Privacy",
            onTap: () {
              _openDrawerPage(context, const PrivacyPage());
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.rocket,
            title: "Upgrade",
            onTap: () {
              _openDrawerPage(context, const UpgradePage());
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.rightFromBracket,
            title: "Logout",
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String headerEmail) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: const AssetImage("assets/logo/logo.png"),
            backgroundColor: Colors.pink.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 10),
          const Text(
            'Beat Flirt',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            headerEmail,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableProfile(
      BuildContext context,
      WidgetRef ref,
      bool isProfileExpanded,
      ) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person, color: Colors.black87),
          title: const Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: AnimatedRotation(
            turns: isProfileExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.keyboard_arrow_down),
          ),
          onTap: () {
            // ✅ Update provider instead of setState
            ref.read(profileExpansionProvider.notifier).state =
            !isProfileExpanded;
          },
        ),
        if (isProfileExpanded)
          Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.idBadge,
                  title: "My Profile",
                  onTap: () {
                    _openDrawerPage(context, const MyProfilePage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.userGear,
                  title: "Account",
                  onTap: () {
                    _openDrawerPage(context, const AccountPage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.signal,
                  title: "Online",
                  onTap: () {
                    _openDrawerPage(context, const OnlinePage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.userGroup,
                  title: "Friends",
                  onTap: () {
                    _openDrawerPage(context, const FriendsPage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.userClock,
                  title: "Friend Request",
                  onTap: () {
                    _openDrawerPage(context, const FriendRequestPage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.user,
                  title: "New Member",
                  onTap: () {
                    _openDrawerPage(context, const NewMemberPage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.solidCircleCheck,
                  title: "Validation",
                  onTap: () {
                    _openDrawerPage(context, const ValidationPage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.clipboardCheck,
                  title: "Validation Request",
                  onTap: () {
                    _openDrawerPage(context, const ValidationRequestPage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.eye,
                  title: "Viewed Me",
                  onTap: () {
                    _openDrawerPage(context, const ViewedMePage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.solidHeart,
                  title: "Likes",
                  onTap: () {
                    _openDrawerPage(context, const LikesPage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.userSlash,
                  title: "Blocklist",
                  onTap: () {
                    _openDrawerPage(context, const BlocklistPage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.solidStar,
                  title: "Favorite",
                  onTap: () {
                    _openDrawerPage(context, const FavoritePage());
                  },
                ),
                _buildSubMenuItem(
                  context,
                  icon: FontAwesomeIcons.solidNoteSticky,
                  title: "Notes",
                  onTap: () {
                    _openDrawerPage(context, const NotesPage());
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem(
      BuildContext context, {
        required Object icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72, right: 16),
      leading: _buildDrawerLeadingIcon(icon, color: Colors.black, size: 20),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required Object icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: _buildDrawerLeadingIcon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDrawerLeadingIcon(
      Object icon, {
        required Color color,
        double size = 22,
      }) {
    if (icon is IconData) {
      return Icon(icon, color: color, size: size);
    }
    if (icon is FaIconData) {
      return FaIcon(icon, color: color, size: size - 2);
    }
    return Icon(Icons.circle, color: color, size: size);
  }

  void _openDrawerPage(BuildContext context, Widget page) {
    Navigator.pop(context);

    // Future.delayed(const Duration(milliseconds: 250), () {

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
  //   );
  // }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // 1. Close the dialog
              Navigator.pop(dialogContext);
              // 2. Close the drawer
              Navigator.pop(context);

              // 3. Perform logout
              await AuthService.logout();

              // 4. Navigate to Login Page
              if (!context.mounted) {
                // If the drawer context is unmounted, we can try to use the navigator from the parent
                // But pushAndRemoveUntil usually works if called before the context is fully gone.
                // As a fallback, we can use a global navigator key if available, but for now:
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}