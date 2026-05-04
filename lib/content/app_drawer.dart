// // import 'package:flutter/material.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import '../core/app_color_constants.dart';
// // import '../core/app_constants.dart';
// //
// // class AppDrawer extends StatelessWidget {
// //   const AppDrawer({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Drawer(
// //       child: Column(
// //         children: [
// //           // ✅ Drawer Header
// //            UserAccountsDrawerHeader(
// //               decoration: const BoxDecoration(
// //                 color: AppColors.primary,
// //               ),
// //               accountName: const Text(
// //                 "Beat Flirt",
// //                 style: TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //               accountEmail: const Text("random@example.com"),
// //               currentAccountPicture: const CircleAvatar(
// //                 backgroundColor: Colors.white,
// //                 child: Icon(Icons.person, size: 40, color: AppColors.primary)),
// //               ),
// //
// //
// //           // ✅ Drawer Items
// //           _buildDrawerItem(
// //             context,
// //             icon:  Icons.person,
// //             title: "Profile ",
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //           const Spacer(),
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.notifications_none,
// //             title: "BeatFlirt Notification",
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
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
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
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
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //           const Spacer(),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.event_available_outlined,
// //             title: "Events & Party",
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //           const Spacer(),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.private_connectivity_rounded,
// //             title: "Speed Date",
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //           const Spacer(),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.mark_chat_read_outlined,
// //             title: "Live Chatroom",
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //           const Spacer(),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.privacy_tip_outlined,
// //             title: "Privacy",
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //           const Spacer(),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.upgrade,
// //             title: "Upgrade",
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //
// //
// //           const Spacer(),
// //
// //           const Divider(),
// //
// //           _buildDrawerItem(
// //             context,
// //             icon: Icons.logout,
// //             title: "Logout",
// //             iconColor: Colors.black,
// //             textColor: Colors.black,
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // ✅ Reusable Drawer Tile
// //   Widget _buildDrawerItem(
// //       BuildContext context, {
// //         required IconData icon,
// //         required String title,
// //         required VoidCallback onTap,
// //         Color? iconColor,
// //         Color? textColor,
// //       }) {
// //     return ListTile(
// //       leading: Icon(
// //         icon,
// //         color: iconColor ?? AppColors.textPrimary,
// //       ) ,
// //
// //       title: Text(
// //         title,
// //         style: TextStyle(
// //           color: textColor ?? AppColors.textPrimary,
// //           fontWeight: FontWeight.w500,
// //         ),
// //       ),
// //       onTap: onTap,
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import '../core/app_color_constants.dart';
// import '../core/app_constants.dart';
//
// class AppDrawer extends StatefulWidget {
//   const AppDrawer({Key? key}) : super(key: key);
//
//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//   bool _isProfileExpanded = false;
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             _buildDrawerHeader(context),
//             // _buildDrawerItem(
//             //   icon: Icons.home,
//             //   title: 'Home',
//             //   onTap: () => _navigateTo(context, '/home'),
//             // ),
//             // _buildDrawerItem(
//             //   icon: Icons.person,
//             //   title: 'Profile',
//             //   onTap: () => _navigateTo(context, '/profile'),
//             // ),
//             // _buildDrawerItem(
//             //   icon: Icons.settings,
//             //   title: 'Settings',
//             //   onTap: () => _navigateTo(context, '/settings'),
//             // ),
//             // const Divider(),
//             // _buildDrawerItem(
//             //   icon: Icons.info,
//             //   title: 'About',
//             //   onTap: () => _navigateTo(context, '/about'),
//             // ),
//             // _buildDrawerItem(
//             //   icon: Icons.logout,
//             //   title: 'Logout',
//             //   onTap: () => _logout(context),
//             // ),
//
//             // ✅ Drawer Items
//           // _buildDrawerItem(
//           //   context,
//           //   icon:  Icons.person,
//           //   title: "Profile ",
//           //   // iconColor: Colors.black,
//           //   // textColor: Colors.black,
//           //   onTap: () {
//           //    _buildExpandableProfile(context);
//           //   },
//           // ),
//
//             _buildExpandableProfile(context),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: Icons.notifications_none,
//             title: "BeatFlirt Notification",
//             // iconColor: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon:Icons.star_purple500_sharp,
//             title: "Celebrity Panel",
//             // iconColor: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: Icons.insert_emoticon_sharp,
//             title: "New Members",
//             // iconColor: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: Icons.event_available_outlined,
//             title: "Events & Party",
//             // iconColor: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//
//
//             const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: Icons.private_connectivity_rounded,
//             title: "Speed Date",
//             // iconColor: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: Icons.mark_chat_read_outlined,
//             title: "Live Chatroom",
//             // iconColor: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: Icons.privacy_tip_outlined,
//             title: "Privacy",
//             // icon: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: Icons.upgrade,
//             title: "Upgrade",
//             // iconColor: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//
//
//           const Divider(),
//
//           _buildDrawerItem(
//             context,
//             icon: Icons.logout,
//             title: "Logout",
//             // iconColor: Colors.black,
//             // textColor: Colors.black,
//             onTap: () {
//               // Navigator.pop(context);
//               _logout(context);
//             },
//           ),
//           ],
//         ),
//
//     );
//   }
//
//   Widget _buildDrawerHeader(BuildContext context) {
//     return DrawerHeader(
//       padding: EdgeInsets.zero,
//       decoration: BoxDecoration(
//         color: Colors.purple.withOpacity(0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundImage: const AssetImage("assets/logo/logo.png"),
//             backgroundColor: Colors.pink.withOpacity(0.9),
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
//             'random@example.com',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.8),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem(BuildContext context, {
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       onTap: onTap,
//     );
//   }
//
//   void _navigateTo(BuildContext context, String route) {
//     Navigator.pop(context);
//     Navigator.pushNamed(context, route);
//   }
//
//   void _logout(BuildContext context) {
//     Navigator.pop(context);
//     // Add logout logic here
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Perform logout
//             },
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ✅ Expandable Profile Widget
// Widget _buildExpandableProfile(BuildContext context) {
//   // bool _isProfileExpanded = false;
//   return Column(
//     children: [
//       ListTile(
//         leading: const Icon(Icons.person, color: Colors.black87),
//         title: const Text(
//           "Profile",
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         trailing: AnimatedRotation(
//           turns: _isProfileExpanded ? 0.5 : 0,
//           duration: const Duration(milliseconds: 300),
//           child: const Icon(Icons.keyboard_arrow_down),
//         ),
//         onTap: () {
//           setState(() {
//             _isProfileExpanded = !_isProfileExpanded;
//           });
//         },
//       ),
//
//       // ✅ Expandable Content
//       // AnimatedContainer(
//       //   duration: const Duration(milliseconds: 300),
//       //   curve: Curves.easeInOut,
//       //   height: _isProfileExpanded ? null : 0,
//       //   child: _isProfileExpanded
//       //       ?
//         if(_isProfileExpanded)
//               Container(
//           color: Colors.grey[100],
//           child: Column(
//             children: [
//               _buildSubMenuItem(
//                 context,
//                 icon: Icons.account_circle,
//                 title: "View Profile",
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Navigate to view profile
//                 },
//               ),
//               _buildSubMenuItem(
//                 context,
//                 icon: Icons.edit,
//                 title: "Edit Profile",
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Navigate to edit profile
//                 },
//               ),
//               _buildSubMenuItem(
//                 context,
//                 icon: Icons.photo_library,
//                 title: "My Photos",
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Navigate to photos
//                 },
//               ),
//               _buildSubMenuItem(
//                 context,
//                 icon: Icons.history,
//                 title: "Activity History",
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Navigate to activity history
//                 },
//               ),
//               _buildSubMenuItem(
//                 context,
//                 icon: Icons.verified_user,
//                 title: "Verification",
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Navigate to verification
//                 },
//               ),
//             ],
//           ),
//         )
//             : const SizedBox.shrink(),
//       ),
//     ],
//   );
// }
//
// // ✅ Sub Menu Item Widget
// Widget _buildSubMenuItem(
//     BuildContext context, {
//       required IconData icon,
//       required String title,
//       required VoidCallback onTap,
//     }) {
//   return ListTile(
//     contentPadding: const EdgeInsets.only(left: 72, right: 16),
//     leading: Icon(icon, size: 20, color: AppColors.primary),
//     title: Text(
//       title,
//       style: TextStyle(
//         fontSize: 14,
//         color: Colors.grey[800],
//       ),
//     ),
//     onTap: onTap,
//   );
// }

import 'package:flutter/material.dart';
import '../core/app_color_constants.dart';
import '../core/app_constants.dart';
import '../screens/login_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // ✅ Move the state variable here (inside the State class)
  bool _isProfileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),

          // ✅ Call the expandable profile here
          _buildExpandableProfile(),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.notifications_none,
            title: "BeatFlirt Notification",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.star_purple500_sharp,
            title: "Celebrity Panel",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.insert_emoticon_sharp,
            title: "New Members",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.event_available_outlined,
            title: "Events & Party",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.private_connectivity_rounded,
            title: "Speed Date",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.mark_chat_read_outlined,
            title: "Live Chatroom",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.privacy_tip_outlined,
            title: "Privacy",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.upgrade,
            title: "Upgrade",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(color: Colors.purple.withOpacity(0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: const AssetImage("assets/logo/logo.png"),
            backgroundColor: Colors.pink.withOpacity(0.9),
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
            'random@example.com',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Move this method inside the State class
  Widget _buildExpandableProfile() {
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
            turns: _isProfileExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.keyboard_arrow_down),
          ),
          onTap: () {
            setState(() {
              _isProfileExpanded = !_isProfileExpanded;
            });
          },
        ),

        // ✅ Expandable Content
        if (_isProfileExpanded)
          Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                _buildSubMenuItem(
                  icon: Icons.account_circle,
                  title: "My Profile",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to view profile
                    print("My Profile clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.edit,
                  title: "Account",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to edit profile
                    print("Account clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.phone_android_sharp,
                  title: "Online",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to photos
                    print("Online clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.person_2,
                  title: "Friends",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to activity history
                    print("Friends clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.mobile_friendly,
                  title: "Friend Request",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to verification
                    print("Friend Request clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.account_circle,
                  title: "New Member",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to view profile
                    print("New Member clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.edit,
                  title: "Validation",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to edit profile
                    print("Validation clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.photo_library,
                  title: "Validation Request",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to photos
                    print("Validation Request clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.history,
                  title: "Viewed Me",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to activity history
                    print("Viewed Me clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.verified_user,
                  title: "Likes",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to verification
                    print("Likes clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.account_circle,
                  title: "Blocklist",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to view profile
                    print("Blocklist clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.edit,
                  title: "Favorite",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to edit profile
                    print("Favorite clicked");
                  },
                ),
                _buildSubMenuItem(
                  icon: Icons.photo_library,
                  title: "Notes",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to photos
                    print("Notes clicked");
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ✅ Move this method inside the State class
  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72, right: 16),
      leading: Icon(icon, size: 20, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
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

  void _logout(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.pop(context);
              // Perform logout
              Navigator.push(
                context,MaterialPageRoute(
                  builder:(context)=> LoginPage(),
                )
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
