// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // // // import '../core/app_color_constants.dart';
// // // // // import '../core/app_constants.dart';
// // // // //
// // // // // class AppDrawer extends StatelessWidget {
// // // // //   const AppDrawer({super.key});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Drawer(
// // // // //       child: Column(
// // // // //         children: [
// // // // //           // ✅ Drawer Header
// // // // //            UserAccountsDrawerHeader(
// // // // //               decoration: const BoxDecoration(
// // // // //                 color: AppColors.primary,
// // // // //               ),
// // // // //               accountName: const Text(
// // // // //                 "Beat Flirt",
// // // // //                 style: TextStyle(fontWeight: FontWeight.bold),
// // // // //               ),
// // // // //               accountEmail: const Text("random@example.com"),
// // // // //               currentAccountPicture: const CircleAvatar(
// // // // //                 backgroundColor: Colors.white,
// // // // //                 child: Icon(Icons.person, size: 40, color: AppColors.primary)),
// // // // //               ),
// // // // //
// // // // //
// // // // //           // ✅ Drawer Items
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon:  Icons.person,
// // // // //             title: "Profile ",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //           const Spacer(),
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon: Icons.notifications_none,
// // // // //             title: "BeatFlirt Notification",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon:Icons.star_purple500_sharp,
// // // // //             title: "Celebrity Panel",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon: Icons.insert_emoticon_sharp,
// // // // //             title: "New Members",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //
// // // // //           const Spacer(),
// // // // //
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon: Icons.event_available_outlined,
// // // // //             title: "Events & Party",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //
// // // // //           const Spacer(),
// // // // //
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon: Icons.private_connectivity_rounded,
// // // // //             title: "Speed Date",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //
// // // // //           const Spacer(),
// // // // //
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon: Icons.mark_chat_read_outlined,
// // // // //             title: "Live Chatroom",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //
// // // // //           const Spacer(),
// // // // //
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon: Icons.privacy_tip_outlined,
// // // // //             title: "Privacy",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //
// // // // //           const Spacer(),
// // // // //
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon: Icons.upgrade,
// // // // //             title: "Upgrade",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //
// // // // //
// // // // //           const Spacer(),
// // // // //
// // // // //           const Divider(),
// // // // //
// // // // //           _buildDrawerItem(
// // // // //             context,
// // // // //             icon: Icons.logout,
// // // // //             title: "Logout",
// // // // //             iconColor: Colors.black,
// // // // //             textColor: Colors.black,
// // // // //             onTap: () {
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   // ✅ Reusable Drawer Tile
// // // // //   Widget _buildDrawerItem(
// // // // //       BuildContext context, {
// // // // //         required IconData icon,
// // // // //         required String title,
// // // // //         required VoidCallback onTap,
// // // // //         Color? iconColor,
// // // // //         Color? textColor,
// // // // //       }) {
// // // // //     return ListTile(
// // // // //       leading: Icon(
// // // // //         icon,
// // // // //         color: iconColor ?? AppColors.textPrimary,
// // // // //       ) ,
// // // // //
// // // // //       title: Text(
// // // // //         title,
// // // // //         style: TextStyle(
// // // // //           color: textColor ?? AppColors.textPrimary,
// // // // //           fontWeight: FontWeight.w500,
// // // // //         ),
// // // // //       ),
// // // // //       onTap: onTap,
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import '../core/app_color_constants.dart';
// // // // import '../core/app_constants.dart';
// // // //
// // // // class AppDrawer extends StatefulWidget {
// // // //   const AppDrawer({Key? key}) : super(key: key);
// // // //
// // // //   @override
// // // //   State<AppDrawer> createState() => _AppDrawerState();
// // // // }
// // // //
// // // // class _AppDrawerState extends State<AppDrawer> {
// // // //   bool _isProfileExpanded = false;
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Drawer(
// // // //         child: ListView(
// // // //           padding: EdgeInsets.zero,
// // // //           children: [
// // // //             _buildDrawerHeader(context),
// // // //             // _buildDrawerItem(
// // // //             //   icon: Icons.home,
// // // //             //   title: 'Home',
// // // //             //   onTap: () => _navigateTo(context, '/home'),
// // // //             // ),
// // // //             // _buildDrawerItem(
// // // //             //   icon: Icons.person,
// // // //             //   title: 'Profile',
// // // //             //   onTap: () => _navigateTo(context, '/profile'),
// // // //             // ),
// // // //             // _buildDrawerItem(
// // // //             //   icon: Icons.settings,
// // // //             //   title: 'Settings',
// // // //             //   onTap: () => _navigateTo(context, '/settings'),
// // // //             // ),
// // // //             // const Divider(),
// // // //             // _buildDrawerItem(
// // // //             //   icon: Icons.info,
// // // //             //   title: 'About',
// // // //             //   onTap: () => _navigateTo(context, '/about'),
// // // //             // ),
// // // //             // _buildDrawerItem(
// // // //             //   icon: Icons.logout,
// // // //             //   title: 'Logout',
// // // //             //   onTap: () => _logout(context),
// // // //             // ),
// // // //
// // // //             // ✅ Drawer Items
// // // //           // _buildDrawerItem(
// // // //           //   context,
// // // //           //   icon:  Icons.person,
// // // //           //   title: "Profile ",
// // // //           //   // iconColor: Colors.black,
// // // //           //   // textColor: Colors.black,
// // // //           //   onTap: () {
// // // //           //    _buildExpandableProfile(context);
// // // //           //   },
// // // //           // ),
// // // //
// // // //             _buildExpandableProfile(context),
// // // //
// // // //           const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon: Icons.notifications_none,
// // // //             title: "BeatFlirt Notification",
// // // //             // iconColor: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               Navigator.pop(context);
// // // //             },
// // // //           ),
// // // //
// // // //           const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon:Icons.star_purple500_sharp,
// // // //             title: "Celebrity Panel",
// // // //             // iconColor: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               Navigator.pop(context);
// // // //             },
// // // //           ),
// // // //
// // // //           const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon: Icons.insert_emoticon_sharp,
// // // //             title: "New Members",
// // // //             // iconColor: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               Navigator.pop(context);
// // // //             },
// // // //           ),
// // // //
// // // //           const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon: Icons.event_available_outlined,
// // // //             title: "Events & Party",
// // // //             // iconColor: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               Navigator.pop(context);
// // // //             },
// // // //           ),
// // // //
// // // //
// // // //
// // // //             const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon: Icons.private_connectivity_rounded,
// // // //             title: "Speed Date",
// // // //             // iconColor: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               Navigator.pop(context);
// // // //             },
// // // //           ),
// // // //
// // // //
// // // //
// // // //           const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon: Icons.mark_chat_read_outlined,
// // // //             title: "Live Chatroom",
// // // //             // iconColor: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               Navigator.pop(context);
// // // //             },
// // // //           ),
// // // //
// // // //
// // // //
// // // //           const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon: Icons.privacy_tip_outlined,
// // // //             title: "Privacy",
// // // //             // icon: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               Navigator.pop(context);
// // // //             },
// // // //           ),
// // // //
// // // //
// // // //
// // // //           const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon: Icons.upgrade,
// // // //             title: "Upgrade",
// // // //             // iconColor: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               Navigator.pop(context);
// // // //             },
// // // //           ),
// // // //
// // // //
// // // //
// // // //           const Divider(),
// // // //
// // // //           _buildDrawerItem(
// // // //             context,
// // // //             icon: Icons.logout,
// // // //             title: "Logout",
// // // //             // iconColor: Colors.black,
// // // //             // textColor: Colors.black,
// // // //             onTap: () {
// // // //               // Navigator.pop(context);
// // // //               _logout(context);
// // // //             },
// // // //           ),
// // // //           ],
// // // //         ),
// // // //
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildDrawerHeader(BuildContext context) {
// // // //     return DrawerHeader(
// // // //       padding: EdgeInsets.zero,
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.purple.withOpacity(0.5),
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.center,
// // // //         children: [
// // // //           CircleAvatar(
// // // //             radius: 40,
// // // //             backgroundImage: const AssetImage("assets/logo/logo.png"),
// // // //             backgroundColor: Colors.pink.withOpacity(0.9),
// // // //           ),
// // // //           const SizedBox(height: 10),
// // // //           const Text(
// // // //             'Beat Flirt',
// // // //             style: TextStyle(
// // // //               color: Colors.white,
// // // //               fontSize: 18,
// // // //               fontWeight: FontWeight.bold,
// // // //             ),
// // // //           ),
// // // //           Text(
// // // //             'random@example.com',
// // // //             style: TextStyle(
// // // //               color: Colors.white.withOpacity(0.8),
// // // //               fontSize: 14,
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildDrawerItem(BuildContext context, {
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required VoidCallback onTap,
// // // //   }) {
// // // //     return ListTile(
// // // //       leading: Icon(icon),
// // // //       title: Text(title),
// // // //       onTap: onTap,
// // // //     );
// // // //   }
// // // //
// // // //   void _navigateTo(BuildContext context, String route) {
// // // //     Navigator.pop(context);
// // // //     Navigator.pushNamed(context, route);
// // // //   }
// // // //
// // // //   void _logout(BuildContext context) {
// // // //     Navigator.pop(context);
// // // //     // Add logout logic here
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (context) => AlertDialog(
// // // //         title: const Text('Logout'),
// // // //         content: const Text('Are you sure you want to logout?'),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.pop(context),
// // // //             child: const Text('Cancel'),
// // // //           ),
// // // //           TextButton(
// // // //             onPressed: () {
// // // //               Navigator.pop(context);
// // // //               // Perform logout
// // // //             },
// // // //             child: const Text('Logout'),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // // // ✅ Expandable Profile Widget
// // // // Widget _buildExpandableProfile(BuildContext context) {
// // // //   // bool _isProfileExpanded = false;
// // // //   return Column(
// // // //     children: [
// // // //       ListTile(
// // // //         leading: const Icon(Icons.person, color: Colors.black87),
// // // //         title: const Text(
// // // //           "Profile",
// // // //           style: TextStyle(
// // // //             fontWeight: FontWeight.w500,
// // // //             color: Colors.black87,
// // // //           ),
// // // //         ),
// // // //         trailing: AnimatedRotation(
// // // //           turns: _isProfileExpanded ? 0.5 : 0,
// // // //           duration: const Duration(milliseconds: 300),
// // // //           child: const Icon(Icons.keyboard_arrow_down),
// // // //         ),
// // // //         onTap: () {
// // // //           setState(() {
// // // //             _isProfileExpanded = !_isProfileExpanded;
// // // //           });
// // // //         },
// // // //       ),
// // // //
// // // //       // ✅ Expandable Content
// // // //       // AnimatedContainer(
// // // //       //   duration: const Duration(milliseconds: 300),
// // // //       //   curve: Curves.easeInOut,
// // // //       //   height: _isProfileExpanded ? null : 0,
// // // //       //   child: _isProfileExpanded
// // // //       //       ?
// // // //         if(_isProfileExpanded)
// // // //               Container(
// // // //           color: Colors.grey[100],
// // // //           child: Column(
// // // //             children: [
// // // //               _buildSubMenuItem(
// // // //                 context,
// // // //                 icon: Icons.account_circle,
// // // //                 title: "View Profile",
// // // //                 onTap: () {
// // // //                   Navigator.pop(context);
// // // //                   // Navigate to view profile
// // // //                 },
// // // //               ),
// // // //               _buildSubMenuItem(
// // // //                 context,
// // // //                 icon: Icons.edit,
// // // //                 title: "Edit Profile",
// // // //                 onTap: () {
// // // //                   Navigator.pop(context);
// // // //                   // Navigate to edit profile
// // // //                 },
// // // //               ),
// // // //               _buildSubMenuItem(
// // // //                 context,
// // // //                 icon: Icons.photo_library,
// // // //                 title: "My Photos",
// // // //                 onTap: () {
// // // //                   Navigator.pop(context);
// // // //                   // Navigate to photos
// // // //                 },
// // // //               ),
// // // //               _buildSubMenuItem(
// // // //                 context,
// // // //                 icon: Icons.history,
// // // //                 title: "Activity History",
// // // //                 onTap: () {
// // // //                   Navigator.pop(context);
// // // //                   // Navigate to activity history
// // // //                 },
// // // //               ),
// // // //               _buildSubMenuItem(
// // // //                 context,
// // // //                 icon: Icons.verified_user,
// // // //                 title: "Verification",
// // // //                 onTap: () {
// // // //                   Navigator.pop(context);
// // // //                   // Navigate to verification
// // // //                 },
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         )
// // // //             : const SizedBox.shrink(),
// // // //       ),
// // // //     ],
// // // //   );
// // // // }
// // // //
// // // // // ✅ Sub Menu Item Widget
// // // // Widget _buildSubMenuItem(
// // // //     BuildContext context, {
// // // //       required IconData icon,
// // // //       required String title,
// // // //       required VoidCallback onTap,
// // // //     }) {
// // // //   return ListTile(
// // // //     contentPadding: const EdgeInsets.only(left: 72, right: 16),
// // // //     leading: Icon(icon, size: 20, color: AppColors.primary),
// // // //     title: Text(
// // // //       title,
// // // //       style: TextStyle(
// // // //         fontSize: 14,
// // // //         color: Colors.grey[800],
// // // //       ),
// // // //     ),
// // // //     onTap: onTap,
// // // //   );
// // // // }
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // import '../Api_services/api_services.dart';
// // // import '../core/app_color_constants.dart';
// // // import '../core/services/auth_services.dart';
// // // import '../screens/drawer_pages.dart';
// // // import '../screens/login_page.dart';
// // //
// // // class AppDrawer extends StatefulWidget {
// // //   const AppDrawer({super.key});
// // //
// // //   @override
// // //   State<AppDrawer> createState() => _AppDrawerState();
// // // }
// // //
// // // class _AppDrawerState extends State<AppDrawer> {
// // //   // ✅ Move the state variable here (inside the State class)
// // //   bool _isProfileExpanded = false;
// // //   final ApiServices _apiServices = ApiServices();
// // //   String _headerEmail = 'Loading...';
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadDrawerEmail();
// // //   }
// // //
// // //   Future<void> _loadDrawerEmail() async {
// // //     final savedEmail = await AuthService.getSavedEmail();
// // //     if (savedEmail != null && savedEmail.isNotEmpty && mounted) {
// // //       setState(() {
// // //         _headerEmail = savedEmail;
// // //       });
// // //     }
// // //
// // //     try {
// // //       final token = await AuthService.getToken();
// // //       if (token == null || token.isEmpty) return;
// // //       final profile = await _apiServices.getProfile(token: token);
// // //       final user = profile['user'];
// // //       String? email;
// // //       if (user is Map) {
// // //         email = user['email']?.toString();
// // //       }
// // //       if (email != null && email.isNotEmpty) {
// // //         await AuthService.saveEmail(email);
// // //         if (!mounted) return;
// // //         setState(() {
// // //           _headerEmail = email!;
// // //         });
// // //       }
// // //     } catch (_) {
// // //       // Keep cached email on API failure.
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Drawer(
// // //       child: ListView(
// // //         padding: EdgeInsets.zero,
// // //         children: [
// // //           _buildDrawerHeader(context),
// // //
// // //           // ✅ Call the expandable profile here
// // //           _buildExpandableProfile(),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.solidBell,
// // //             title: "BeatFlirt Notification",
// // //             onTap: () {
// // //               _openDrawerPage(context, const BeatFlirtNotificationPage());
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.crown,
// // //             title: "Celebrity Panel",
// // //             onTap: () {
// // //               _openDrawerPage(context, const CelebrityPanelPage());
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.userPlus,
// // //             title: "New Members",
// // //             onTap: () {
// // //               _openDrawerPage(context, const NewMembersPage());
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.champagneGlasses,
// // //             title: "Events & Party",
// // //             onTap: () {
// // //               _openDrawerPage(context, const EventsPartyPage());
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.bolt,
// // //             title: "Speed Date",
// // //             onTap: () {
// // //               _openDrawerPage(context, const SpeedDatePage());
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.comments,
// // //             title: "Live Chatroom",
// // //             onTap: () {
// // //               _openDrawerPage(context, const LiveChatroomPage());
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.userShield,
// // //             title: "Privacy",
// // //             onTap: () {
// // //               _openDrawerPage(context, const PrivacyPage());
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.rocket,
// // //             title: "Upgrade",
// // //             onTap: () {
// // //               _openDrawerPage(context, const UpgradePage());
// // //             },
// // //           ),
// // //
// // //           const Divider(),
// // //
// // //           _buildDrawerItem(
// // //             context,
// // //             icon: FontAwesomeIcons.rightFromBracket,
// // //             title: "Logout",
// // //             onTap: () {
// // //               _logout(context);
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildDrawerHeader(BuildContext context) {
// // //     return DrawerHeader(
// // //       padding: EdgeInsets.zero,
// // //       decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.5)),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.center,
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           CircleAvatar(
// // //             radius: 40,
// // //             backgroundImage: const AssetImage("assets/logo/logo.png"),
// // //             backgroundColor: Colors.pink.withValues(alpha: 0.9),
// // //           ),
// // //           const SizedBox(height: 10),
// // //           const Text(
// // //             'Beat Flirt',
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //           Text(
// // //             _headerEmail,
// // //             style: TextStyle(
// // //               color: Colors.white.withValues(alpha: 0.8),
// // //               fontSize: 14,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ✅ Move this method inside the State class
// // //   Widget _buildExpandableProfile() {
// // //     return Column(
// // //       children: [
// // //         ListTile(
// // //           leading: const Icon(Icons.person, color: Colors.black87),
// // //           title: const Text(
// // //             "Profile",
// // //             style: TextStyle(
// // //               fontWeight: FontWeight.w500,
// // //               color: Colors.black87,
// // //             ),
// // //           ),
// // //           trailing: AnimatedRotation(
// // //             turns: _isProfileExpanded ? 0.5 : 0,
// // //             duration: const Duration(milliseconds: 300),
// // //             child: const Icon(Icons.keyboard_arrow_down),
// // //           ),
// // //           onTap: () {
// // //             setState(() {
// // //               _isProfileExpanded = !_isProfileExpanded;
// // //             });
// // //           },
// // //         ),
// // //
// // //         // ✅ Expandable Content
// // //         if (_isProfileExpanded)
// // //           Container(
// // //             color: Colors.grey[100],
// // //             child: Column(
// // //               children: [
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.idBadge,
// // //                   title: "My Profile",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const MyProfilePage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.userGear,
// // //                   title: "Account",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const AccountPage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.signal,
// // //                   title: "Online",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const OnlinePage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.userGroup,
// // //                   title: "Friends",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const FriendsPage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.userClock,
// // //                   title: "Friend Request",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const FriendRequestPage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.user,
// // //                   title: "New Member",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const NewMemberPage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.solidCircleCheck,
// // //                   title: "Validation",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const ValidationPage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.clipboardCheck,
// // //                   title: "Validation Request",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const ValidationRequestPage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.eye,
// // //                   title: "Viewed Me",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const ViewedMePage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.solidHeart,
// // //                   title: "Likes",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const LikesPage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.userSlash,
// // //                   title: "Blocklist",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const BlocklistPage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.solidStar,
// // //                   title: "Favorite",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const FavoritePage());
// // //                   },
// // //                 ),
// // //                 _buildSubMenuItem(
// // //                   icon: FontAwesomeIcons.solidNoteSticky,
// // //                   title: "Notes",
// // //                   onTap: () {
// // //                     _openDrawerPage(context, const NotesPage());
// // //                   },
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   // ✅ Move this method inside the State class
// // //   Widget _buildSubMenuItem({
// // //     required Object icon,
// // //     // required IconData icon,
// // //     required String title,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return ListTile(
// // //       contentPadding: const EdgeInsets.only(left: 72, right: 16),
// // //       // leading: _buildDrawerLeadingIcon(icon, color: AppColors.primary, size: 20),
// // //       leading: _buildDrawerLeadingIcon(icon, color: Colors.black, size: 20),
// // //       title: Text(
// // //         title,
// // //         style: TextStyle(fontSize: 14, color: Colors.grey[800]),
// // //       ),
// // //       onTap: onTap,
// // //     );
// // //   }
// // //
// // //   Widget _buildDrawerItem(
// // //     BuildContext context, {
// // //     required Object icon,
// // //     required String title,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return ListTile(
// // //       leading: _buildDrawerLeadingIcon(icon, color: Colors.black87),
// // //       title: Text(
// // //         title,
// // //         style: const TextStyle(
// // //           fontWeight: FontWeight.w500,
// // //           color: Colors.black87,
// // //         ),
// // //       ),
// // //       onTap: onTap,
// // //     );
// // //   }
// // //
// // //   Widget _buildDrawerLeadingIcon(
// // //     Object icon, {
// // //     required Color color,
// // //     double size = 22,
// // //   }) {
// // //     if (icon is IconData) {
// // //       return Icon(icon, color: color, size: size);
// // //     }
// // //     if (icon is FaIconData) {
// // //       return FaIcon(icon, color: color, size: size - 2);
// // //     }
// // //     return Icon(Icons.circle, color: color, size: size);
// // //   }
// // //
// // //   void _openDrawerPage(BuildContext context, Widget page) {
// // //     Navigator.pop(context);
// // //     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
// // //   }
// // //
// // //   void _logout(BuildContext context) {
// // //     Navigator.pop(context);
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: const Text('Logout'),
// // //         content: const Text('Are you sure you want to logout?'),
// // //         actions: [
// // //           TextButton(
// // //             style: TextButton.styleFrom(
// // //               foregroundColor: Colors.black
// // //             ),
// // //             onPressed: () => Navigator.pop(context),
// // //             child: const Text('Cancel'),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: () async {
// // //               Navigator.pop(context);
// // //               await AuthService.logout();
// // //               if (!context.mounted) return;
// // //               Navigator.pushAndRemoveUntil(
// // //                 context,
// // //                 MaterialPageRoute(builder: (context) => const LoginPage()),
// // //                 (route) => false,
// // //               );
// // //             },
// // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
// // //             child: const Text('Logout'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import '../core/services/auth_services.dart';
// // import '../providers/drawer_providers.dart';
// // import '../screens/drawer_pages.dart';
// // import '../screens/login_page.dart';

// // // ✅ Change StatefulWidget to ConsumerStatefulWidget
// // class AppDrawer extends ConsumerWidget {
// //   const AppDrawer({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     // ✅ Watch providers instead of using state variables
// //     final isProfileExpanded = ref.watch(profileExpansionProvider);
// //     final headerEmail = ref.watch(drawerEmailProvider);

// //     return Drawer(
      
// //       child: ListView(
// //         padding: EdgeInsets.zero,
// //         children: [
// //           _buildDrawerHeader(context, headerEmail),
// //           _buildExpandableProfile(context, ref, isProfileExpanded),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.solidBell,
// //             title: "BeatFlirt Notification",
// //             onTap: () {
// //               _openDrawerPage(context, const BeatFlirtNotificationPage());
// //             },
// //           ),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.crown,
// //             title: "Celebrity Panel",
// //             onTap: () {
// //               _openDrawerPage(context, const CelebrityPanelPage());
// //             },
// //           ),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.userPlus,
// //             title: "New Members",
// //             onTap: () {
// //               _openDrawerPage(context, const NewMembersPage());
// //             },
// //           ),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.champagneGlasses,
// //             title: "Events & Party",
// //             onTap: () {
// //               _openDrawerPage(context, const EventsPartyPage());
// //             },
// //           ),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.bolt,
// //             title: "Speed Date",
// //             onTap: () {
// //               _openDrawerPage(context, const SpeedDatePage());
// //             },
// //           ),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.comments,
// //             title: "Live Chatroom",
// //             onTap: () {
// //               _openDrawerPage(context, const LiveChatroomPage());
// //             },
// //           ),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.userShield,
// //             title: "Privacy",
// //             onTap: () {
// //               _openDrawerPage(context, const PrivacyPage());
// //             },
// //           ),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.rocket,
// //             title: "Upgrade",
// //             onTap: () {
// //               _openDrawerPage(context, const UpgradePage());
// //             },
// //           ),
// //           const Divider(),
// //           _buildDrawerItem(
// //             context,
// //             icon: FontAwesomeIcons.rightFromBracket,
// //             title: "Logout",
// //             onTap: () {
// //               _logout(context);
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDrawerHeader(BuildContext context, String headerEmail) {
// //     return DrawerHeader(
// //       padding: EdgeInsets.zero,
// //       decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.5)),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircleAvatar(
// //             radius: 40,
// //             backgroundImage: const AssetImage("assets/logo/logo.png"),
// //             backgroundColor: Colors.pink.withValues(alpha: 0.9),
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
// //             headerEmail,
// //             style: TextStyle(
// //               color: Colors.white.withValues(alpha: 0.8),
// //               fontSize: 14,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildExpandableProfile(
// //     BuildContext context,
// //     WidgetRef ref,
// //     bool isProfileExpanded,
// //   ) {
// //     return Column(
// //       children: [
// //         ListTile(
// //           leading: const Icon(Icons.person, color: Colors.black87),
// //           title: const Text(
// //             "Profile",
// //             style: TextStyle(
// //               fontWeight: FontWeight.w500,
// //               color: Colors.black87,
// //             ),
// //           ),
// //           trailing: AnimatedRotation(
// //             turns: isProfileExpanded ? 0.5 : 0,
// //             duration: const Duration(milliseconds: 300),
// //             child: const Icon(Icons.keyboard_arrow_down),
// //           ),
// //           onTap: () {
// //             // ✅ Update provider instead of setState
// //             ref.read(profileExpansionProvider.notifier).state =
// //                 !isProfileExpanded;
// //           },
// //         ),
// //         if (isProfileExpanded)
// //           Container(
// //             color: Colors.grey[100],
// //             child: Column(
// //               children: [
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.idBadge,
// //                   title: "My Profile",
// //                   onTap: () {
// //                     _openDrawerPage(context, const MyProfilePage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.userGear,
// //                   title: "Account",
// //                   onTap: () {
// //                     _openDrawerPage(context, const AccountPage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.signal,
// //                   title: "Online",
// //                   onTap: () {
// //                     _openDrawerPage(context, const OnlinePage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.userGroup,
// //                   title: "Friends",
// //                   onTap: () {
// //                     _openDrawerPage(context, const FriendsPage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.userClock,
// //                   title: "Friend Request",
// //                   onTap: () {
// //                     _openDrawerPage(context, const FriendRequestPage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.user,
// //                   title: "New Member",
// //                   onTap: () {
// //                     _openDrawerPage(context, const NewMemberPage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.solidCircleCheck,
// //                   title: "Validation",
// //                   onTap: () {
// //                     _openDrawerPage(context, const ValidationPage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.clipboardCheck,
// //                   title: "Validation Request",
// //                   onTap: () {
// //                     _openDrawerPage(context, const ValidationRequestPage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.eye,
// //                   title: "Viewed Me",
// //                   onTap: () {
// //                     _openDrawerPage(context, const ViewedMePage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.solidHeart,
// //                   title: "Likes",
// //                   onTap: () {
// //                     _openDrawerPage(context, const LikesPage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.userSlash,
// //                   title: "Blocklist",
// //                   onTap: () {
// //                     _openDrawerPage(context, const BlocklistPage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.solidStar,
// //                   title: "Favorite",
// //                   onTap: () {
// //                     _openDrawerPage(context, const FavoritePage());
// //                   },
// //                 ),
// //                 _buildSubMenuItem(
// //                   context,
// //                   icon: FontAwesomeIcons.solidNoteSticky,
// //                   title: "Notes",
// //                   onTap: () {
// //                     _openDrawerPage(context, const NotesPage());
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   Widget _buildSubMenuItem(
// //     BuildContext context, {
// //     required Object icon,
// //     required String title,
// //     required VoidCallback onTap,
// //   }) {
// //     return ListTile(
// //       contentPadding: const EdgeInsets.only(left: 72, right: 16),
// //       leading: _buildDrawerLeadingIcon(icon, color: Colors.black, size: 20),
// //       title: Text(
// //         title,
// //         style: TextStyle(fontSize: 14, color: Colors.grey[800]),
// //       ),
// //       onTap: onTap,
// //     );
// //   }

// //   Widget _buildDrawerItem(
// //     BuildContext context, {
// //     required Object icon,
// //     required String title,
// //     required VoidCallback onTap,
// //   }) {
// //     return ListTile(
// //       leading: _buildDrawerLeadingIcon(icon, color: Colors.black87),
// //       title: Text(
// //         title,
// //         style: const TextStyle(
// //           fontWeight: FontWeight.w500,
// //           color: Colors.black87,
// //         ),
// //       ),
// //       onTap: onTap,
// //     );
// //   }

// //   Widget _buildDrawerLeadingIcon(
// //     Object icon, {
// //     required Color color,
// //     double size = 22,
// //   }) {
// //     if (icon is IconData) {
// //       return Icon(icon, color: color, size: size);
// //     }
// //     if (icon is FaIconData) {
// //       return FaIcon(icon, color: color, size: size - 2);
// //     }
// //     return Icon(Icons.circle, color: color, size: size);
// //   }

// //   void _openDrawerPage(BuildContext context, Widget page) {
// //     // Dismiss the keyboard when navigating to another screen from the drawer
// //     FocusManager.instance.primaryFocus?.unfocus();

// //     Navigator.pop(context);

// //     // Future.delayed(const Duration(milliseconds: 250), () {

// //     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
// //   }
// //   //   );
// //   // }

// //   void _logout(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (dialogContext) => AlertDialog(
// //         title: const Text('Logout'),
// //         content: const Text('Are you sure you want to logout?'),
// //         actions: [
// //           TextButton(
// //             style: TextButton.styleFrom(foregroundColor: Colors.black),
// //             onPressed: () => Navigator.pop(dialogContext),
// //             child: const Text('Cancel'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () async {
// //               // 1. Close the dialog
// //               Navigator.pop(dialogContext);
// //               // 2. Close the drawer
// //               Navigator.pop(context);

// //               // 3. Perform logout
// //               await AuthService.logout();

// //               // 4. Navigate to Login Page
// //               if (!context.mounted) {
// //                 // If the drawer context is unmounted, we can try to use the navigator from the parent
// //                 // But pushAndRemoveUntil usually works if called before the context is fully gone.
// //                 // As a fallback, we can use a global navigator key if available, but for now:
// //               }

// //               Navigator.pushAndRemoveUntil(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => const LoginPage()),
// //                 (route) => false,
// //               );
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.red,
// //               foregroundColor: Colors.white,
// //             ),
// //             child: const Text('Logout'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../core/services/auth_services.dart';

// import '../providers/drawer_providers.dart';

// import '../screens/drawer_pages.dart';

// import '../screens/login_page.dart';

// // ✅ BeatFlirt Brand Colors (from website design system)
// class BeatFlirtColors {
//   static const Color primary = Color(0xFF01529C);
//   static const Color secondary = Color(0xFF1C1AA1);
//   static const Color pinkAccent = Color(0xFFE91E63);
//   static const Color sidebarBgStart = Color(0xFF560827);
//   static const Color sidebarBgEnd = Color(0xFF06032C);
//   static const Color textLight = Color(0xFFFFF4FA);
//   static const Color textLight70 = Color(0xB3FFF4FA);
//   static const Color textLight50 = Color(0x80FFF4FA);
//   static const Color bodyBg = Color(0xFFFFF4FA);
//   static const Color hoverBg = Color(0x33FFFFFF);
// }

// // ✅ Change StatefulWidget to ConsumerStatefulWidget
// class AppDrawer extends ConsumerWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // ✅ Watch providers instead of using state variables
//     final isProfileExpanded = ref.watch(profileExpansionProvider);
//     final headerEmail = ref.watch(drawerEmailProvider);

//     return Drawer(
//       width: 280,
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               BeatFlirtColors.sidebarBgStart, // Deep maroon/red
//               BeatFlirtColors.sidebarBgEnd, // Near black/dark blue
//             ],
//           ),
//         ),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             _buildDrawerHeader(context, headerEmail),
//             _buildExpandableProfile(context, ref, isProfileExpanded),
//             _buildSectionDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.solidBell,
//               title: "BeatFlirt Notification",
//               onTap: () {
//                 _openDrawerPage(context, const BeatFlirtNotificationPage());
//               },
//             ),
//             _buildItemDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.crown,
//               title: "Celebrity Panel",
//               onTap: () {
//                 _openDrawerPage(context, const CelebrityPanelPage());
//               },
//             ),
//             _buildItemDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.userPlus,
//               title: "New Members",
//               onTap: () {
//                 _openDrawerPage(context, const NewMembersPage());
//               },
//             ),
//             _buildItemDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.champagneGlasses,
//               title: "Events & Party",
//               onTap: () {
//                 _openDrawerPage(context, const EventsPartyPage());
//               },
//             ),
//             _buildItemDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.bolt,
//               title: "Speed Date",
//               onTap: () {
//                 _openDrawerPage(context, const SpeedDatePage());
//               },
//             ),
//             _buildItemDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.comments,
//               title: "Live Chatroom",
//               onTap: () {
//                 _openDrawerPage(context, const LiveChatroomPage());
//               },
//             ),
//             _buildItemDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.userShield,
//               title: "Privacy",
//               onTap: () {
//                 _openDrawerPage(context, const PrivacyPage());
//               },
//             ),
//             _buildItemDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.rocket,
//               title: "Upgrade",
//               onTap: () {
//                 _openDrawerPage(context, const UpgradePage());
//               },
//             ),
//             _buildSectionDivider(),
//             _buildDrawerItem(
//               context,
//               icon: FontAwesomeIcons.rightFromBracket,
//               title: "Logout",
//               isLogout: true,
//               onTap: () {
//                 _logout(context);
//               },
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerHeader(BuildContext context, String headerEmail) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: BeatFlirtColors.textLight50,
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Logo with pink glow border
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: BeatFlirtColors.pinkAccent,
//                 width: 3,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: BeatFlirtColors.pinkAccent.withValues(alpha: 0.3),
//                   blurRadius: 12,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: CircleAvatar(
//               radius: 36,
//               backgroundImage: const AssetImage("assets/logo/logo.png"),
//               backgroundColor: BeatFlirtColors.pinkAccent.withValues(alpha: 0.9),
//             ),
//           ),
//           const SizedBox(height: 14),
//           const Text(
//             'Beat Flirt',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             headerEmail,
//             style: TextStyle(
//               color: BeatFlirtColors.textLight70,
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExpandableProfile(
//     BuildContext context,
//     WidgetRef ref,
//     bool isProfileExpanded,
//   ) {
//     return Column(
//       children: [
//         // Profile parent item
//         Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(25),
//             splashColor: BeatFlirtColors.hoverBg,
//             onTap: () {
//               ref.read(profileExpansionProvider.notifier).state =
//                   !isProfileExpanded;
//             },
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: isProfileExpanded
//                     ? BeatFlirtColors.hoverBg
//                     : Colors.transparent,
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                       color: BeatFlirtColors.pinkAccent.withValues(alpha: 0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.person,
//                       color: BeatFlirtColors.pinkAccent,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 14),
//                   const Text(
//                     "Profile",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const Spacer(),
//                   AnimatedRotation(
//                     turns: isProfileExpanded ? 0.5 : 0,
//                     duration: const Duration(milliseconds: 300),
//                     child: const Icon(
//                       Icons.keyboard_arrow_down,
//                       color: BeatFlirtColors.textLight70,
//                       size: 22,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         // Expanded sub-items
//         if (isProfileExpanded)
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               color: Colors.black.withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               children: [
//                 const SizedBox(height: 4),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.idBadge,
//                   title: "My Profile",
//                   onTap: () {
//                     _openDrawerPage(context, const MyProfilePage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.userGear,
//                   title: "Account",
//                   onTap: () {
//                     _openDrawerPage(context, const AccountPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.signal,
//                   title: "Online",
//                   onTap: () {
//                     _openDrawerPage(context, const OnlinePage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.userGroup,
//                   title: "Friends",
//                   onTap: () {
//                     _openDrawerPage(context, const FriendsPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.userClock,
//                   title: "Friend Request",
//                   onTap: () {
//                     _openDrawerPage(context, const FriendRequestPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.user,
//                   title: "New Member",
//                   onTap: () {
//                     _openDrawerPage(context, const NewMemberPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.solidCircleCheck,
//                   title: "Validation",
//                   onTap: () {
//                     _openDrawerPage(context, const ValidationPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.clipboardCheck,
//                   title: "Validation Request",
//                   onTap: () {
//                     _openDrawerPage(context, const ValidationRequestPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.eye,
//                   title: "Viewed Me",
//                   onTap: () {
//                     _openDrawerPage(context, const ViewedMePage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.solidHeart,
//                   title: "Likes",
//                   onTap: () {
//                     _openDrawerPage(context, const LikesPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.userSlash,
//                   title: "Blocklist",
//                   onTap: () {
//                     _openDrawerPage(context, const BlocklistPage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.solidStar,
//                   title: "Favorite",
//                   onTap: () {
//                     _openDrawerPage(context, const FavoritePage());
//                   },
//                 ),
//                 _buildSubMenuItem(
//                   context,
//                   icon: FontAwesomeIcons.solidNoteSticky,
//                   title: "Notes",
//                   onTap: () {
//                     _openDrawerPage(context, const NotesPage());
//                   },
//                 ),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildSubMenuItem(
//     BuildContext context, {
//     required Object icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         splashColor: BeatFlirtColors.hoverBg,
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           child: Row(
//             children: [
//               const SizedBox(width: 8),
//               _buildDrawerLeadingIcon(
//                 icon,
//                 color: BeatFlirtColors.textLight70,
//                 size: 16,
//               ),
//               const SizedBox(width: 14),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 13.5,
//                   color: BeatFlirtColors.textLight70,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     BuildContext context, {
//     required Object icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isLogout = false,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(25),
//         splashColor: BeatFlirtColors.hoverBg,
//         onTap: onTap,
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//           child: Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: isLogout
//                       ? BeatFlirtColors.pinkAccent.withValues(alpha: 0.15)
//                       : Colors.white.withValues(alpha: 0.08),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: _buildDrawerLeadingIcon(
//                   icon,
//                   color: isLogout
//                       ? BeatFlirtColors.pinkAccent
//                       : BeatFlirtColors.textLight,
//                   size: 18,
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: isLogout
//                       ? BeatFlirtColors.pinkAccent
//                       : Colors.white,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

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

//   Widget _buildSectionDivider() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Container(
//         height: 1,
//         color: BeatFlirtColors.textLight50,
//       ),
//     );
//   }

//   Widget _buildItemDivider() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 62, right: 20),
//       child: Container(
//         height: 0.5,
//         color: BeatFlirtColors.textLight50,
//       ),
//     );
//   }

//   void _openDrawerPage(BuildContext context, Widget page) {
//     // Dismiss the keyboard when navigating to another screen from the drawer
//     FocusManager.instance.primaryFocus?.unfocus();

//     Navigator.pop(context);

//     // Future.delayed(const Duration(milliseconds: 250), () {

//     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//   }
//   //   );
//   // }

//   void _logout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         backgroundColor: const Color(0xFF1A0533),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Row(
//           children: [
//             FaIcon(
//               FontAwesomeIcons.rightFromBracket,
//               color: BeatFlirtColors.pinkAccent,
//               size: 20,
//             ),
//             const SizedBox(width: 10),
//             const Text(
//               'Logout',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         content: const Text(
//           'Are you sure you want to logout?',
//           style: TextStyle(color: BeatFlirtColors.textLight70, fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             style: TextButton.styleFrom(
//               foregroundColor: BeatFlirtColors.textLight70,
//             ),
//             onPressed: () => Navigator.pop(dialogContext),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               // 1. Close the dialog
//               Navigator.pop(dialogContext);
//               // 2. Close the drawer
//               Navigator.pop(context);

//               // 3. Perform logout
//               await AuthService.logout();

//               // 4. Navigate to Login Page
//               if (!context.mounted) {
//                 // If the drawer context is unmounted, we can try to use the navigator from the parent
//                 // But pushAndRemoveUntil usually works if called before the context is fully gone.
//                 // As a fallback, we can use a global navigator key if available, but for now:
//               }

//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()),
//                 (route) => false,
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: BeatFlirtColors.pinkAccent,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//             ),
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
import '../screens/home_screen.dart';
// import '../screens/couple_profile_screen_view.dart';
// import 'package:beatflirt/my_profile_page.dart';


// ╔═══════════════════════════════════════════╗
// ║   BEAT FLIRT  NAVIGATION  DRAWER         ║
// ║   Pixel-matched to beatflirtevent.com     ║
// ╚═══════════════════════════════════════════╝

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  // ── Design Constants (extracted from website CSS) ──
  static const Color _bgDark = Color(0xFF1D032F);
  static const Color _bgMid = Color(0xFF3D0A3C);
  static const Color _bgRose = Color(0xFF761942);
  static const Color _textPrimary = Color(0xFFFFF4FA);
  static const Color _textSecondary = Color(0xCCFFF4FA);
  static const Color _textMuted = Color(0x80FFF4FA);
  static const Color _activeOverlay = Color(0x33FFFFFF);
  static const Color _badgeBg = Color(0xFF13042B);
  static const Color _accent = Color(0xFFE91E63);
  static const Color _divider = Color(0x30FFFFFF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProfileExpanded = ref.watch(profileExpansionProvider);
    final headerEmail = ref.watch(drawerEmailProvider);

    return Drawer(
      width: 260,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgDark, _bgMid, _bgRose],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ═══ LOGO HEADER ═══
              _buildLogoHeader(context, headerEmail),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(color: _divider, height: 1),
              ),
              const SizedBox(height: 8),

              // ═══ SCROLLABLE MENU ═══
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    // ── Profile (Expandable) ──
                    _buildExpandableProfile(context, ref, isProfileExpanded),

                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(color: _divider, height: 1),
                    ),
                    const SizedBox(height: 8),

                    // ── Primary Menu Items ──
                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.solidBell,
                      title: 'BeatFlirt Notification',
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.pop(context); // Close drawer
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (route) => false,
                        );
                      },
                    ),
                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.crown,
                      title: 'Celebrity Panel',
                      onTap: () =>
                          _openDrawerPage(context, const CelebrityPanelPage()),
                    ),
                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.userPlus,
                      title: 'New Members',
                      onTap: () =>
                          // _openDrawerPage(context, const NewMembersPage()),
                      _openDrawerPage(context, const NewMembersScreen()),   //main
                      
                    ),
                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.champagneGlasses,
                      title: 'Events & Party',
                      onTap: () =>
                          // _openDrawerPage(context, const EventsPartyPage()),
                      // _openDrawerPage(context, const EventsPage()),   //main
                      _openDrawerPage(context, const EventsListScreen()),
                                         
                       
                    ),
                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.bolt,
                      title: 'Speed Date',
                      onTap: () =>
                          _openDrawerPage(context, const SpeedDatePage()),
                    ),
                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.comments,
                      title: 'Live Chatroom',
                      onTap: () =>
                          _openDrawerPage(context, const LiveChatroomPage()),
                    ),

                    const SizedBox(height: 12),

                    // ── Section Label ──
                    const Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 6),
                      child: Text(
                        'ACCOUNT',
                        style: TextStyle(
                          color: _textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.2,
                        ),
                      ),
                    ),

                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.userShield,
                      title: 'Privacy',
                      onTap: () =>
                          // _openDrawerPage(context, const PrivacyPage()),
                          _openDrawerPage(context, const PrivacySettingsPage()),
                    ),
                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.rocket,
                      title: 'Upgrade',
                      onTap: () =>
                          _openDrawerPage(context, const UpgradePage()),
                    ),
                    _buildPillItem(
                      context,
                      icon: FontAwesomeIcons.rightFromBracket,
                      title: 'Logout',
                      isDestructive: true,
                      onTap: () => _logout(context),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ═══ FOOTER DIVIDER ═══
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(color: _divider, height: 1),
              ),

              // ═══ PROFILE FOOTER ═══
              _buildProfileFooter(context, headerEmail),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  //  LOGO + BRAND HEADER
  // ──────────────────────────────────────────
  Widget _buildLogoHeader(BuildContext context, String email) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo box (matches website .logo-white)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_bgDark, _bgRose, _bgDark],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0x40FFFFFF),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    'assets/logo/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.favorite_rounded,
                      color: _textPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'BEAT FLIRT',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            // email.isNotEmpty ? email : 'Events, Nightlife & Dating',
            'Events, Nightlife & Dating',
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w300,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  EXPANDABLE PROFILE SECTION
  // ──────────────────────────────────────────
  Widget _buildExpandableProfile(
    BuildContext context,
    WidgetRef ref,
    bool isExpanded,
  ) {
    return Column(
      children: [
        // Profile toggle pill
        _PillTile(
          icon: FontAwesomeIcons.solidUser,
          label: 'Profile',
          trailing: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _textSecondary,
              size: 22,
            ),
          ),
          onTap: () {
            ref.read(profileExpansionProvider.notifier).state = !isExpanded;
          },
        ),

        // Expanded sub-items
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.idBadge,
                  title: 'My Profile',
                  onTap: () =>
                      _openDrawerPage(context, const MyProfilePage()),  // main
                    //  _openDrawerPage(
                    //   context,
                    //   BeatProfileRouter(),),
                      
                      // _openDrawerPage(context, const MyProfileScreen()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.userGear,
                  title: 'Account',
                  onTap: () =>
                      _openDrawerPage(context, const AccountPage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.signal,
                  title: 'Online',
                  onTap: () =>
                      _openDrawerPage(context, const OnlinePage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.userGroup,
                  title: 'Friends',
                  onTap: () =>
                      _openDrawerPage(context, const FriendsPage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.userClock,
                  title: 'Friend Request',
                  // onTap: () =>
                  //     // _openDrawerPage(context, const FriendRequestPage()),
                  //     _openDrawerPage(context, FriendRequestPage()),

                  // onTap: () async {
                  //   final token = await AuthService.getToken();
                  //   if (context.mounted) {
                  //     _openDrawerPage(context, FriendRequestPage(bearerToken: token ?? ''));
                  //   }
                  // },

                  onTap: () =>
                      _openDrawerPage(context, const FriendRequestsPage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.user,
                  title: 'New Member',
                  onTap: () =>
                      // _openDrawerPage(context, const NewMemberPage()),
                      _openDrawerPage(context, const NewMembersScreen()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.solidCircleCheck,
                  title: 'Validation',
                  onTap: () =>
                      _openDrawerPage(context, const ValidationPage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.clipboardCheck,
                  title: 'Validation Request',
                  onTap: () =>
                      _openDrawerPage(context, const ValidationRequestPage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.eye,
                  title: 'Viewed Me',
                  onTap: () =>
                      _openDrawerPage(context, ViewedMePage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.solidHeart,
                  title: 'Likes',
                  onTap: () =>
                      _openDrawerPage(context, const LikesPage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.userSlash,
                  title: 'Blocklist',
                  onTap: () =>
                      _openDrawerPage(context, const BlocklistPage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.solidStar,
                  title: 'Favorite',
                  onTap: () =>
                      _openDrawerPage(context, const FavoritePage()),
                ),
                _buildSubPill(
                  context,
                  icon: FontAwesomeIcons.solidNoteSticky,
                  title: 'Notes',
                  onTap: () =>
                      _openDrawerPage(context, const NotesPage()),
                ),
              ],
            ),
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────
  //  PILL-SHAPED MENU ITEM (Primary)
  // ──────────────────────────────────────────
  Widget _buildPillItem(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return _PillTile(
      icon: icon,
      label: title,
      isDestructive: isDestructive,
      onTap: onTap,
    );
  }

  // ──────────────────────────────────────────
  //  PILL-SHAPED SUB-MENU ITEM (Indented)
  // ──────────────────────────────────────────
  Widget _buildSubPill(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return _PillTile(
      icon: icon,
      label: title,
      isSubItem: true,
      onTap: onTap,
    );
  }

  // ──────────────────────────────────────────
  //  PROFILE FOOTER
  // ──────────────────────────────────────────
  Widget _buildProfileFooter(BuildContext context, String email) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: GestureDetector(
        // onTap: () => _openDrawerPage(context, const MyProfilePage()),
        onTap: () => _openDrawerPage(context, const MyProfilePage()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: _activeOverlay.withValues(alpha: 0.3),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: _accent,
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),

              // Name + email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Account',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      // email.isNotEmpty ? email : 'View Profile',
                      'View Profile',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.chevron_right_rounded,
                color: _textSecondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  //  NAVIGATION HELPERS
  // ════════════════════════════════════════

  void _openDrawerPage(BuildContext context, Widget page) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

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
              final navigator = Navigator.of(context);
              Navigator.pop(dialogContext);
              await AuthService.logout();
              navigator.pushAndRemoveUntil(
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

// ╔═══════════════════════════════════════════╗
// ║   REUSABLE PILL TILE  (menu item)        ║
// ╚═══════════════════════════════════════════╝

class _PillTile extends StatelessWidget {
  final FaIconData? icon;
  final String label;
  final Widget? trailing;
  final bool isSubItem;
  final bool isDestructive;
  final VoidCallback onTap;

  const _PillTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.isSubItem = false,
    this.isDestructive = false,
    required this.onTap,
  });

  // Reuse parent constants
  static const Color _textPrimary = Color(0xFFFFF4FA);
  static const Color _textSecondary = Color(0xCCFFF4FA);
  static const Color _activeOverlay = Color(0x33FFFFFF);
  static const Color _accent = Color(0xFFE91E63);

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive ? _accent : _textSecondary;
    final iconColor = isDestructive ? _accent : _textSecondary;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 4,
        left: isSubItem ? 12 : 0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isSubItem ? 12 : 16,
              vertical: isSubItem ? 10 : 13,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                // Icon
                FaIcon(
                  icon,
                  color: iconColor,
                  size: isSubItem ? 16 : 18,
                ),
                const SizedBox(width: 12),

                // Label
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: isSubItem ? 13 : 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // Trailing widget (e.g. expand arrow)
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}