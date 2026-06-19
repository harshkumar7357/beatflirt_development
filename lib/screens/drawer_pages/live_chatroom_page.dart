// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../providers/user_list_provider.dart';
// import '../../providers/chatroom_provider.dart';
// import 'chatroom_detail_page.dart';
// import 'package:get/get.dart';

// class LiveChatroomPage extends ConsumerWidget {
//   const LiveChatroomPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F1A),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           _buildAppBar(context),
//           _buildLiveHeader(),
//           _buildActiveRooms(ref),
//           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       floating: true,
//       pinned: true,
//       backgroundColor: const Color(0xFF0F0F1A),
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(
//           Icons.arrow_back_ios_new,
//           color: Colors.white,
//           size: 20,
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),
//       centerTitle: true,
//       title: const Text(
//         'LIVE CHATROOMS',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w900,
//           fontSize: 16,
//           letterSpacing: 2.0,
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () => _showCreateRoomDialog(context),
//           icon: const FaIcon(
//             FontAwesomeIcons.plus,
//             color: Colors.pinkAccent,
//             size: 18,
//           ),
//           tooltip: "Create Room",
//         ),
//         const SizedBox(width: 10),
//       ],
//     );
//   }

//   Widget _buildLiveHeader() {
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
//           ),
//         ),
//         child: Row(
//           children: [
//             const FaIcon(
//               FontAwesomeIcons.towerBroadcast,
//               color: Colors.white,
//               size: 40,
//             ),
//             const SizedBox(width: 20),
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Global Chat',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'Join thousands of members online',
//                     style: TextStyle(color: Colors.white70, fontSize: 13),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.2),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: const Text(
//                 'LIVE',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 10,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActiveRooms(WidgetRef ref) {
//     final chatroomState = ref.watch(chatroomProvider);
//     final onlineUsers = ref.watch(userListProvider('online')).users;
//     final totalOnline = onlineUsers.length;

//     if (chatroomState.isLoading && chatroomState.rooms.isEmpty) {
//       return const SliverToBoxAdapter(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.all(50),
//             child: CircularProgressIndicator(color: Colors.pinkAccent),
//           ),
//         ),
//       );
//     }

//     if (chatroomState.rooms.isEmpty) {
//       return SliverToBoxAdapter(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(50),
//             child: Text(
//               "No active rooms found",
//               style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
//             ),
//           ),
//         ),
//       );
//     }

//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 15,
//           crossAxisSpacing: 15,
//           childAspectRatio: 1.1,
//         ),
//         delegate: SliverChildBuilderDelegate((context, index) {
//           final room = chatroomState.rooms[index];
//           // Distribute online users across rooms, or show 0 if none
//           int count = 0;
//           if (totalOnline > 0) {
//             count = index == 0
//                 ? totalOnline
//                 : (totalOnline / (index + 1)).floor();
//             if (count == 0 && totalOnline > 0 && index < 3) count = 1;
//           }
//           return _buildRoomCard(context, index, room, count);
//         }, childCount: chatroomState.rooms.length),
//       ),
//     );
//   }

//   Widget _buildRoomCard(
//     BuildContext context,
//     int index,
//     Chatroom room,
//     int activeCount,
//   ) {
//     final colors = [
//       Colors.blue,
//       Colors.orange,
//       Colors.green,
//       Colors.red,
//       Colors.purple,
//       Colors.teal,
//     ];

//     return InkWell(
//       onTap: () async {
//         final currentUserId = await AuthService.getUserId();
//         final isOwner = room.creatorId == currentUserId;

//         if (room.isPrivate && !isOwner) {
//           if (context.mounted) _showJoinCodeDialog(context, room);
//         } else {
//           // Public room or Owner - join directly
//           if (context.mounted) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatroomDetailPage(room: room),
//               ),
//             );
//           }
//         }
//       },
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(alpha: 0.05),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//         ),
//         child: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: colors[index % colors.length].withValues(
//                       alpha: 0.2,
//                     ),
//                     child: FaIcon(
//                       FontAwesomeIcons.message,
//                       color: colors[index % colors.length],
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     room.name,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '$activeCount active',
//                     style: TextStyle(
//                       color: Colors.white.withValues(alpha: 0.5),
//                       fontSize: 11,
//                     ),
//                   ),
//                   if (room.joinCode != null) ...[
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "Code: ${room.joinCode}",
//                         style: const TextStyle(
//                           color: Colors.pinkAccent,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 10,
//               right: 10,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: room.isPrivate
//                       ? Colors.redAccent.withValues(alpha: 0.2)
//                       : Colors.greenAccent.withValues(alpha: 0.2),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: room.isPrivate
//                         ? Colors.redAccent
//                         : Colors.greenAccent,
//                     width: 0.5,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (room.isPrivate)
//                       const Padding(
//                         padding: EdgeInsets.only(right: 4.0),
//                         child: Icon(
//                           Icons.lock,
//                           color: Colors.redAccent,
//                           size: 8,
//                         ),
//                       ),
//                     Text(
//                       room.isPrivate ? "Private" : "Public",
//                       style: TextStyle(
//                         color: room.isPrivate
//                             ? Colors.redAccent
//                             : Colors.greenAccent,
//                         fontSize: 8,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showJoinCodeDialog(BuildContext context, Chatroom room) {
//     final TextEditingController controller = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => Consumer(
//         builder: (context, ref, child) => AlertDialog(
//           backgroundColor: const Color(0xFF1A1A2E),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Text(
//             "Join ${room.name}",
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 onTapOutside: (_) {
//                   FocusManager.instance.primaryFocus!.unfocus();
//                 },
//                 controller: controller,
//                 style: const TextStyle(color: Colors.white),
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: "Enter 6-digit number",
//                   hintStyle: const TextStyle(color: Colors.white30),
//                   filled: true,
//                   fillColor: Colors.white.withValues(alpha: 0.05),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const Text(
//                 "Enter the unique code shared by the room creator to join.",
//                 style: TextStyle(color: Colors.white38, fontSize: 12),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(color: Colors.white38),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final code = controller.text.trim();
//                 if (code.isEmpty) return;

//                 try {
//                   final joinedRoom = await ref
//                       .read(chatroomProvider.notifier)
//                       .joinByCode(code);
//                   if (!context.mounted) return;
//                   Navigator.pop(context); // Close dialog
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           ChatroomDetailPage(room: joinedRoom),
//                     ),
//                   );
//                 } catch (e) {
//                   if (!context.mounted) return;
//                   Get.snackbar(
//                     "Error",
//                     e.toString().replaceFirst('Exception: ', ''),
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.redAccent,
//                     colorText: Colors.white,
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.pinkAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text("Join", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCreateRoomDialog(BuildContext context) {
//     final TextEditingController controller = TextEditingController();
//     bool isPrivate = false;

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => Consumer(
//           builder: (context, ref, child) => AlertDialog(
//             backgroundColor: const Color(0xFF1A1A2E),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: const Text(
//               "Create New Room",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   onTapOutside: (_) {
//                     FocusManager.instance.primaryFocus!.unfocus();
//                   },
//                   controller: controller,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     hintText: "Room Name",
//                     hintStyle: const TextStyle(color: Colors.white30),
//                     filled: true,
//                     fillColor: Colors.white.withValues(alpha: 0.05),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 SwitchListTile(
//                   title: Text(
//                     isPrivate ? "Private Room" : "Public Room",
//                     style: const TextStyle(color: Colors.white70, fontSize: 14),
//                   ),
//                   subtitle: Text(
//                     isPrivate
//                         ? "Only invited members can join"
//                         : "Everyone can see and join",
//                     style: const TextStyle(color: Colors.white24, fontSize: 11),
//                   ),
//                   value: isPrivate,

//                   activeColor: Colors.pinkAccent,
//                   onChanged: (val) => setState(() => isPrivate = val),
//                   contentPadding: EdgeInsets.zero,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Start a new themed chatroom and invite people to join!",
//                   style: TextStyle(color: Colors.white38, fontSize: 12),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   "Cancel",
//                   style: TextStyle(color: Colors.white38),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final name = controller.text.trim();
//                   if (name.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Please enter a room name")),
//                     );
//                     return;
//                   }

//                   try {
//                     await ref
//                         .read(chatroomProvider.notifier)
//                         .createRoom(name, 'Social', isPrivate: isPrivate);
//                     if (!context.mounted) return;
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           isPrivate
//                               ? "Private room created!"
//                               : "Public room created!",
//                         ),
//                       ),
//                     );
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Failed to create room: $e")),
//                     );
//                   }
//                 },

//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pinkAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   "Create",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// Beat Flirt /messenger screen converted from:
// https://beatflirtevent.com/messenger
//
// Main class: LiveChatroomPage
//
// Required pubspec dependencies:
//   http: ^1.2.2
//   shared_preferences: ^2.3.2
//   socket_io_client: ^3.0.0
//   image_picker: ^1.1.2
//   url_launcher: ^6.3.1
//
// AndroidManifest.xml:
//   <uses-permission android:name="android.permission.INTERNET" />
//
// Note: the website chat server is https://node.technoderivation.com:3301/.
// At the time of extraction its SSL certificate may be expired, so this page
// allows bad certificates by default for the chat server on Android.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beatflirt/single_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'upgrade_page.dart';

// import 'beat_single_user_profile_screen.dart';

const String _webBase = 'https://beatflirtevent.com/';
const String _apiBase = 'https://app.beatflirtevent.com/App';
const String _socketBase = 'https://node.technoderivation.com:3301/';
const String _chatImageBase = 'https://app.beatflirtevent.com/assets/';

String _resolveChatImage(String raw) {
  final value = raw.trim();
  if (value.isEmpty || value == 'undefined' || value == 'null') return '';
  if (value.startsWith('http://') || value.startsWith('https://')) return value;
  if (value.startsWith('//')) return 'https:$value';
  if (value.startsWith('assets/')) return '$_webBase$value';
  if (value.startsWith('/')) return 'https://app.beatflirtevent.com$value';
  return '${_chatImageBase}images/$value';
}

String _string(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final s = value.toString();
  return s.isEmpty ? fallback : s;
}

DateTime? _date(dynamic value) {
  final raw = _string(value);
  if (raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

String _timeLabel(dynamic value) {
  final date = _date(value);
  if (date == null) return '';
  final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

String _dayLabel(dynamic value) {
  final date = _date(value);
  if (date == null) return '';
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[date.month - 1]} ${date.day}';
}

String _btoa(String value) => base64Encode(utf8.encode(value));

bool _ok(dynamic status) => status?.toString() == '200' || status == true || status?.toString() == 'true';

class _BadCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  }
}

class LiveChatApiException implements Exception {
  LiveChatApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ChatCurrentUser {
  ChatCurrentUser({
    required this.userId,
    required this.email,
    required this.username,
    required this.profileImage,
  });

  final String userId;
  final String email;
  final String username;
  final String profileImage;

  factory ChatCurrentUser.fromPrefs(SharedPreferences prefs) {
    final raw = prefs.getString('chatapp_user_data') ?? '';
    if (raw.isNotEmpty) {
      try {
        final json = jsonDecode(raw);
        if (json is Map) {
          return ChatCurrentUser(
            userId: _string(json['userid'], _string(json['id'], prefs.getString('user-id') ?? '')),
            email: _string(json['email'], prefs.getString('email') ?? ''),
            username: _string(json['username'], prefs.getString('username') ?? 'You'),
            profileImage: _string(json['profile_image'], prefs.getString('profile_image') ?? ''),
          );
        }
      } catch (_) {}
    }

    return ChatCurrentUser(
      userId: prefs.getString('user-id') ?? prefs.getString('chatapp_user_id') ?? '',
      email: prefs.getString('email') ?? '',
      username: prefs.getString('username') ?? 'You',
      profileImage: prefs.getString('profile_image') ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userid': userId,
        'email': email,
        'username': username,
        'profile_image': profileImage,
      };
}

class ChatUser {
  ChatUser({
    required this.raw,
    required this.id,
    required this.email,
    required this.username,
    required this.profileImage,
    required this.lastMessage,
    required this.messageDateTime,
    required this.lastLogin,
    required this.blockUser,
  });

  final Map<String, dynamic> raw;
  final String id;
  final String email;
  final String username;
  final String profileImage;
  final String lastMessage;
  final String messageDateTime;
  final String lastLogin;
  final String blockUser;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        raw: json,
        id: _string(json['id'], _string(json['userid'])),
        email: _string(json['email']),
        username: _string(json['username'], _string(json['name'], 'User')),
        profileImage: _string(json['profile_image']),
        lastMessage: _string(json['last_message']),
        messageDateTime: _string(json['message_date_time']),
        lastLogin: _string(json['last_login']),
        blockUser: _string(json['block_user'], '0'),
      );

  bool get isBlocked => blockUser == '1';
  bool get isOnline => lastLogin != '0' && lastLogin.isNotEmpty;

  ChatUser copyWith({String? blockUser, String? lastMessage, String? messageDateTime}) => ChatUser(
        raw: raw,
        id: id,
        email: email,
        username: username,
        profileImage: profileImage,
        lastMessage: lastMessage ?? this.lastMessage,
        messageDateTime: messageDateTime ?? this.messageDateTime,
        lastLogin: lastLogin,
        blockUser: blockUser ?? this.blockUser,
      );
}

class ChatMessage {
  ChatMessage({
    required this.raw,
    required this.fromUser,
    required this.toUser,
    required this.user,
    required this.profileImage,
    required this.message,
    required this.image,
    required this.room,
    required this.createdAt,
  });

  final Map<String, dynamic> raw;
  final String fromUser;
  final String toUser;
  final String user;
  final String profileImage;
  final String message;
  final String image;
  final String room;
  final String createdAt;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        raw: json,
        fromUser: _string(json['from_user']),
        toUser: _string(json['to_user']),
        user: _string(json['user']),
        profileImage: _string(json['profile_image']),
        message: _string(json['message'], _string(json['text'])),
        image: _string(json['image']),
        room: _string(json['room']),
        createdAt: _string(json['created_at'], DateTime.now().toIso8601String()),
      );

  bool isMine(ChatCurrentUser current) {
    if (fromUser.isNotEmpty) return fromUser == current.userId;
    return user == current.username;
  }

  bool get hasText => message.isNotEmpty && message != 'undefined' && message != 'null';
  bool get hasImage => image.isNotEmpty && image != 'undefined' && image != 'null';

  Map<String, dynamic> toSocketPayload() => {
        'user': user,
        'profile_image': profileImage,
        'image': image.isEmpty ? 'undefined' : image,
        'room': room,
        'message': message.isEmpty ? 'undefined' : message,
        'from_user': fromUser,
        'to_user': toUser,
        'created_at': createdAt,
      };
}

class LiveChatApi {
  LiveChatApi({
    required this.accessToken,
    required this.accessSign,
    required this.chatAppUserId,
    required this.chatAppCookie,
    this.appBaseUrl = _apiBase,
    this.socketBaseUrl = _socketBase,
    this.allowBadCertificates = true,
    http.Client? appClient,
    http.Client? nodeClient,
  })  : _appClient = appClient ?? http.Client(),
        _nodeClient = nodeClient ?? _buildNodeClient(allowBadCertificates);

  final String accessToken;
  final String accessSign;
  final String chatAppUserId;
  final String chatAppCookie;
  final String appBaseUrl;
  final String socketBaseUrl;
  final bool allowBadCertificates;
  final http.Client _appClient;
  final http.Client _nodeClient;

  static http.Client _buildNodeClient(bool allowBadCertificates) {
    if (!allowBadCertificates) return http.Client();
    final httpClient = HttpClient()..badCertificateCallback = (cert, host, port) => true;
    return IOClient(httpClient);
  }

  Map<String, String> get _appHeaders {
    final h = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (accessToken.isNotEmpty) {
      h['Access-Token'] = accessToken;
      h['access-token'] = accessToken;
      h['Authorization'] = 'Bearer $accessToken';
    }
    if (accessSign.isNotEmpty) {
      h['Access-Sign'] = accessSign;
    }
    return h;
  }

  Future<Map<String, dynamic>> _appPost(String path, Map<String, dynamic> body) async {
    final response = await _appClient.post(
      Uri.parse('$appBaseUrl$path'),
      headers: _appHeaders,
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> _nodePost(String path, Map<String, String> body) async {
    final response = await _nodeClient.post(
      Uri.parse('$socketBaseUrl$path'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LiveChatApiException('HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw LiveChatApiException('Unexpected response');
  }

  Future<List<ChatUser>> getAllUsers(String currentUserId) async {
    final json = await _nodePost('user/allusers', {
      'username': chatAppUserId,
      'Access-Token': accessToken,
      'user': currentUserId,
    });

    if (_string(json['result']) == 'success') {
      final data = json['data'];
      if (data is List) return data.whereType<Map>().map((e) => ChatUser.fromJson(Map<String, dynamic>.from(e))).toList();
      return <ChatUser>[];
    }
    return <ChatUser>[];
  }

  Future<Map<String, String>> getRoomIds(String currentUserId) async {
    final json = await _nodePost('user/allusers', {
      'username': chatAppUserId,
      'Access-Token': accessToken,
      'user': currentUserId,
    });
    final rooms = json['room_ids'];
    if (rooms is Map) {
      return rooms.map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return <String, String>{};
  }

  Future<List<ChatMessage>> getAllMessages({
    required String user1,
    required String user2,
    required Map<String, ChatUser> userById,
    required ChatCurrentUser currentUser,
  }) async {
    final json = await _nodePost('messages/getAllMessages', {
      'id': chatAppUserId,
      'cookie': chatAppCookie,
      'user1': user1,
      'user2': user2,
    });

    if (_string(json['result']) != 'success') return <ChatMessage>[];
    final data = json['data'];
    if (data is! List) return <ChatMessage>[];

    final messages = <ChatMessage>[];
    for (final item in data.whereType<Map>()) {
      final map = Map<String, dynamic>.from(item);
      final fromUser = _string(map['from_user']);
      final user = fromUser == currentUser.userId ? null : userById[fromUser];
      map['user'] = fromUser == currentUser.userId ? currentUser.username : (user?.username ?? _string(map['user']));
      map['profile_image'] = fromUser == currentUser.userId ? currentUser.profileImage : (user?.profileImage ?? _string(map['profile_image']));
      map['message'] = _string(map['text'], _string(map['message']));
      messages.add(ChatMessage.fromJson(map));
    }

    messages.sort((a, b) {
      final da = _date(a.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = _date(b.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return da.compareTo(db);
    });
    return messages;
  }

  Future<String> uploadImageDataUrl(String dataUrl) async {
    final json = await _appPost('/upload/imageupload', {'image': dataUrl});
    if (_ok(json['status'])) return _string(json['data']);
    throw LiveChatApiException(_string(json['message'], 'Image upload failed'));
  }

  Future<String> sendChatBlock({
    required String senderId,
    required String receivedId,
    required String status,
  }) async {
    final json = await _appPost('/user/send_chat_block', {
      'sendor_id': senderId,
      'recieved_id': receivedId,
      'status': status,
    });
    if (_ok(json['status'])) return _string(json['message'], 'Success');
    throw LiveChatApiException(_string(json['message'], 'Request failed'));
  }

  Future<Map<String, dynamic>> generateRtcToken(String channelName) async {
    final json = await _appPost('/agora/generateRTCToken', {
      'channelName': channelName,
      'uid': 0,
    });
    if (_ok(json['status'])) return json;
    throw LiveChatApiException(_string(json['message'], 'Unable to start video call'));
  }

  Future<String?> checkLoginUserMembership() async {
    final json = await _appPost('/user/check_login_user_membership', {});
    return json['membership_expire']?.toString();
  }
}

class LiveChatSocketService {
  LiveChatSocketService({
    required this.socketBaseUrl,
    required this.currentUserId,
    this.allowBadCertificates = true,
  });

  final String socketBaseUrl;
  final String currentUserId;
  final bool allowBadCertificates;

  IO.Socket? _socket;
  final _messageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get messages => _messageController.stream;

  void connect() {
    if (allowBadCertificates) HttpOverrides.global = _BadCertificateHttpOverrides();

    _socket = IO.io(
      socketBaseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      _socket!.emit('login', {'userId': currentUserId});
    });

    _socket!.on('new message', (data) {
      if (data is Map) {
        _messageController.add(ChatMessage.fromJson(Map<String, dynamic>.from(data)));
      }
    });

    _socket!.connect();
  }

  void joinRoom({required String user, required String room}) {
    _socket?.emit('join', {'user': user, 'room': room});
  }

  void sendMessage(ChatMessage message) {
    _socket?.emit('message', message.toSocketPayload());
  }

  void dispose() {
    _socket?.dispose();
    _messageController.close();
  }
}

class LiveChatroomPage extends StatefulWidget {
  const LiveChatroomPage({
    super.key,
    this.api,
    this.accessToken,
    this.accessSign,
    this.initialUserEmail,
    this.encodedInitialUserEmail,
    this.allowBadCertificates = true,
    this.autoCheckMembership = true,
    this.onOpenMembership,
  });

  final LiveChatApi? api;
  final String? accessToken;
  final String? accessSign;
  final String? initialUserEmail;
  final String? encodedInitialUserEmail;
  final bool allowBadCertificates;
  final bool autoCheckMembership;
  final VoidCallback? onOpenMembership;

  @override
  State<LiveChatroomPage> createState() => _LiveChatroomPageState();
}

class _LiveChatroomPageState extends State<LiveChatroomPage> {
  static const Color _maroon = Color(0xFF560827);
  static const Color _deepPink = Color(0xFFA00D41);
  static const Color _lightBg = Color(0xFFFFF4FA);

  final _messageController = TextEditingController();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _picker = ImagePicker();

  LiveChatApi? _api;
  LiveChatSocketService? _socket;
  StreamSubscription<ChatMessage>? _messageSub;

  ChatCurrentUser? _currentUser;
  List<ChatUser> _users = <ChatUser>[];
  List<ChatUser> _filteredUsers = <ChatUser>[];
  Map<String, String> _roomIds = <String, String>{};
  Map<String, ChatUser> _userById = <String, ChatUser>{};
  ChatUser? _selectedUser;
  List<ChatMessage> _messages = <ChatMessage>[];

  bool _loadingShell = true;
  bool _loadingMessages = false;
  bool _sending = false;
  String? _error;
  String _membershipValue = '';

  bool get _membershipLocked => _membershipValue == 'Yes';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _messageSub?.cancel();
    _socket?.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = ChatCurrentUser.fromPrefs(prefs);
      _currentUser = current;
      _membershipValue = prefs.getString('membership') ?? '';

      final token = widget.accessToken ??
          prefs.getString('Access-Token') ??
          prefs.getString('access_token') ??
          prefs.getString('accessToken') ??
          prefs.getString('token') ??
          prefs.getString('auth_token') ??
          '';

      final sign = widget.accessSign ??
          prefs.getString('Access-Sign') ??
          prefs.getString('access_sign') ??
          prefs.getString('accessSign') ??
          prefs.getString('sign') ??
          '';

      _api = widget.api ??
          LiveChatApi(
            accessToken: token,
            accessSign: sign,
            chatAppUserId: prefs.getString('chatapp_user_id') ?? current.userId,
            chatAppCookie: prefs.getString('chatapp_cookie') ?? '',
            allowBadCertificates: widget.allowBadCertificates,
          );

      if (widget.autoCheckMembership) {
        try {
          final m = await _api!.checkLoginUserMembership();
          if (m != null) {
            _membershipValue = m;
            await prefs.setString('membership', m);
          }
        } catch (_) {}
      }

      _socket = LiveChatSocketService(
        socketBaseUrl: _socketBase,
        currentUserId: current.userId,
        allowBadCertificates: widget.allowBadCertificates,
      );
      _socket!.connect();
      _messageSub = _socket!.messages.listen(_onSocketMessage);

      await _loadUsers();
      if (!mounted) return;
      setState(() => _loadingShell = false);

      final initialEmail = widget.initialUserEmail ?? _decodeBase64Nullable(widget.encodedInitialUserEmail);
      if (initialEmail != null && initialEmail.isNotEmpty) {
        final match = _users.where((u) => u.email == initialEmail).toList();
        if (match.isNotEmpty) await _selectUser(match.first);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingShell = false;
        _error = e.toString();
      });
    }
  }

  String? _decodeBase64Nullable(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return utf8.decode(base64Decode(value));
    } catch (_) {
      return value;
    }
  }

  Future<void> _loadUsers() async {
    final api = _api;
    final current = _currentUser;
    if (api == null || current == null) return;

    final users = await api.getAllUsers(current.userId);
    final rooms = await api.getRoomIds(current.userId);

    users.sort((a, b) {
      final da = _date(a.messageDateTime) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = _date(b.messageDateTime) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });

    _userById = {for (final u in users) u.id: u};
    _roomIds = rooms;
    _users = users;
    _filteredUsers = users;
  }

  Future<void> _refreshUsers() async {
    setState(() => _loadingShell = true);
    try {
      await _loadUsers();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loadingShell = false);
    }
  }

  Future<void> _selectUser(ChatUser user) async {
    final api = _api;
    final current = _currentUser;
    if (api == null || current == null) return;

    setState(() {
      _selectedUser = user;
      _loadingMessages = true;
      _messages = <ChatMessage>[];
    });

    try {
      final messages = await api.getAllMessages(
        user1: current.userId,
        user2: user.id,
        userById: _userById,
        currentUser: current,
      );

      final room = _roomIds[user.id] ?? user.raw['room_id']?.toString() ?? '';
      if (room.isNotEmpty) _socket?.joinRoom(user: current.username, room: room);

      if (!mounted) return;
      setState(() => _messages = messages);
      _scrollToBottom();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loadingMessages = false);
    }
  }

  void _onSocketMessage(ChatMessage message) {
    final selected = _selectedUser;
    if (selected == null) return;
    final room = _roomIds[selected.id] ?? '';
    if (message.room != room) return;

    setState(() => _messages.add(message));
    _scrollToBottom();
  }

  void _filterUsers(String keyword) {
    final q = keyword.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers = _users.where((u) {
          return u.username.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q) ||
              u.lastMessage.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  Future<void> _sendText() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _selectedUser == null || _currentUser == null) return;
    if (_selectedUser!.isBlocked) return;

    final room = _roomIds[_selectedUser!.id] ?? '';
    final message = ChatMessage(
      raw: const {},
      fromUser: _currentUser!.userId,
      toUser: _selectedUser!.id,
      user: _currentUser!.username,
      profileImage: _currentUser!.profileImage,
      message: text,
      image: 'undefined',
      room: room,
      createdAt: DateTime.now().toIso8601String(),
    );

    setState(() {
      _sending = true;
      _messages.add(message);
      _messageController.clear();
    });
    _scrollToBottom();

    try {
      _socket?.sendMessage(message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _pickAndSendImage() async {
    if (_selectedUser == null || _currentUser == null || _selectedUser!.isBlocked) return;
    final api = _api;
    if (api == null) return;

    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 82);
    if (picked == null) return;

    setState(() => _sending = true);
    try {
      final bytes = await picked.readAsBytes();
      final ext = picked.name.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
      final dataUrl = 'data:image/$ext;base64,${base64Encode(bytes)}';
      final fileName = await api.uploadImageDataUrl(dataUrl);
      final room = _roomIds[_selectedUser!.id] ?? '';

      final message = ChatMessage(
        raw: const {},
        fromUser: _currentUser!.userId,
        toUser: _selectedUser!.id,
        user: _currentUser!.username,
        profileImage: _currentUser!.profileImage,
        message: 'undefined',
        image: fileName,
        room: room,
        createdAt: DateTime.now().toIso8601String(),
      );

      setState(() => _messages.add(message));
      _socket?.sendMessage(message);
      _scrollToBottom();
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _blockOrUnblockSelected() async {
    final api = _api;
    final selected = _selectedUser;
    final current = _currentUser;
    if (api == null || selected == null || current == null) return;

    final nextStatus = selected.isBlocked ? '0' : '1';
    setState(() => _sending = true);
    try {
      final msg = await api.sendChatBlock(
        senderId: current.userId,
        receivedId: selected.id,
        status: nextStatus,
      );
      _snack(msg);
      final updated = selected.copyWith(blockUser: nextStatus);
      setState(() {
        _selectedUser = updated;
        _users = _users.map((u) => u.id == updated.id ? updated : u).toList();
        _filteredUsers = _filteredUsers.map((u) => u.id == updated.id ? updated : u).toList();
      });
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _startVideoCall() async {
    final api = _api;
    final selected = _selectedUser;
    final current = _currentUser;
    if (api == null || selected == null || current == null) return;

    try {
      final channel = 'channel_${DateTime.now().millisecondsSinceEpoch}${DateTime.now().microsecond % 1000}';
      final token = await api.generateRtcToken(channel);
      final appId = _string(token['appId']);
      final channelName = _string(token['channelName'], channel);
      final liveToken = _string(token['token']);
      final url = Uri.parse(
        'https://beatflirtevent.com/agora_video/?appid=${Uri.encodeComponent(appId)}'
        '&channel=${Uri.encodeComponent(channelName)}'
        '&token=${Uri.encodeComponent(liveToken)}'
        '&user_name=${Uri.encodeComponent(current.email)}'
        '&return_url=${Uri.encodeComponent('https://beatflirtevent.com/messenger')}',
      );
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      _snack(e.toString(), error: true);
    }
  }

  void _openSelectedProfile() {
    final selected = _selectedUser;
    if (selected == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BeatSingleUserProfileScreen(userId: selected.id),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _snack(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_membershipLocked) return _membershipLockedScreen();

    return Scaffold(
      backgroundColor: _lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: _mainContent(),
            ),
            if (_loadingShell)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.55),
                  child: const Center(child: CircularProgressIndicator(color: _maroon)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _mainContent() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 42),
            const SizedBox(height: 10),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _refreshUsers,
              style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_users.isEmpty && !_loadingShell) return _emptyNoMessages();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 30, offset: Offset(0, 10))],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          if (wide) {
            return Row(
              children: [
                SizedBox(width: 330, child: _chatList()),
                Expanded(child: _chatPane(showBack: false)),
              ],
            );
          }

          if (_selectedUser == null) return _chatList();
          return _chatPane(showBack: true);
        },
      ),
    );
  }

  Widget _chatList() {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: const Color(0xFFFDFDFD),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: _maroon,
              onRefresh: _refreshUsers,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  final active = _selectedUser?.email == user.email;
                  return _userTile(user, active);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userTile(ChatUser user, bool active) {
    return InkWell(
      onTap: () => _selectUser(user),
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          border: Border(left: BorderSide(color: active ? _maroon : Colors.transparent, width: 4)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _avatar(user.profileImage, size: 50),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF333333), fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(user.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF888888), fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(_dayLabel(user.messageDateTime), style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _chatPane({required bool showBack}) {
    final selected = _selectedUser;
    if (selected == null) return _emptyStartChat();

    return Column(
      children: [
        _chatHeader(selected, showBack: showBack),
        Expanded(
          child: _loadingMessages
              ? const Center(child: CircularProgressIndicator(color: _maroon))
              : _messageList(),
        ),
        if (selected.isBlocked)
          _blockedFooter(selected)
        else
          _chatFooter(),
      ],
    );
  }

  Widget _chatHeader(ChatUser user, {required bool showBack}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [_maroon, _deepPink]),
        boxShadow: [BoxShadow(color: Color(0x26000000), blurRadius: 15, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: () => setState(() => _selectedUser = null),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          InkWell(onTap: _openSelectedProfile, child: _avatar(user.profileImage, size: 45)),
          const SizedBox(width: 14),
          Expanded(
            child: InkWell(
              onTap: _openSelectedProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                  Text(user.isOnline ? 'Online' : 'Offline', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: _startVideoCall,
            icon: const Icon(Icons.videocam, color: Colors.white),
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (_) => _blockOrUnblockSelected(),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'block', child: Text(user.isBlocked ? 'Unblock' : 'Block')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _messageList() {
    return Container(
      color: const Color(0xFFE5DDD5),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(15),
        itemCount: _messages.length,
        itemBuilder: (context, index) => _messageBubble(_messages[index]),
      ),
    );
  }

  Widget _messageBubble(ChatMessage message) {
    final current = _currentUser;
    final isMine = current != null && message.isMine(current);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xFFDCF8C6) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMine ? 8 : 0),
            topRight: Radius.circular(isMine ? 0 : 8),
            bottomLeft: const Radius.circular(8),
            bottomRight: const Radius.circular(8),
          ),
          boxShadow: const [BoxShadow(color: Color(0x21000000), blurRadius: 1, offset: Offset(0, 1))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  _resolveChatImage(message.image),
                  width: 230,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(width: 180, height: 120, child: Icon(Icons.broken_image)),
                ),
              ),
            if (message.hasText)
              Padding(
                padding: EdgeInsets.only(top: message.hasImage ? 6 : 0),
                child: Text(message.message, style: const TextStyle(color: Color(0xFF303030), fontSize: 14.5, height: 1.35)),
              ),
            const SizedBox(height: 3),
            Text(_timeLabel(message.createdAt), style: const TextStyle(color: Colors.black45, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _chatFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: const Color(0xFFF0F0F0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 1)]),
              child: Row(
                children: [
                  InkWell(
                    onTap: _pickAndSendImage,
                    child: const SizedBox(width: 34, height: 34, child: Icon(Icons.attach_file, color: Color(0xFF919191))),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      onSubmitted: (_) => _sendText(),
                      decoration: const InputDecoration(hintText: 'Type a message...', border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 45,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008069), foregroundColor: Colors.white, shape: const CircleBorder(), padding: EdgeInsets.zero),
              onPressed: _sending ? null : _sendText,
              child: _sending ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blockedFooter(ChatUser user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFFF5F5),
      child: Text(
        "Can't send a message to blocked contact ${user.username}.",
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _emptyStartChat() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(opacity: .5, child: Image.network('${_webBase}assets/img/logo/logo.png', width: 120, errorBuilder: (_, __, ___) => const Icon(Icons.chat, size: 80, color: _maroon))),
            const SizedBox(height: 18),
            const Text('Send and Receive Messages, start chat!', style: TextStyle(color: Colors.black54, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _emptyNoMessages() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(opacity: .65, child: Image.network('${_webBase}assets/img/logo/logo.png', width: 110, errorBuilder: (_, __, ___) => const Icon(Icons.forum_outlined, size: 80, color: _maroon))),
            const SizedBox(height: 14),
            const Text('No Messages Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _maroon)),
            const SizedBox(height: 6),
            const Text("Looks like you haven't started any conversations. Start exploring and say hi to someone!", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _membershipLockedScreen() {
    return Scaffold(
      backgroundColor: _lightBg,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_maroon, Color(0xFF06032C)]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Beat Flirt Team!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text('"You have not purchased a Beat Flirt membership plan. Buy membership"', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15)),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _maroon, foregroundColor: Colors.white),
                 onPressed: widget.onOpenMembership ?? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UpgradePage()),
                  );
                },
                child: const Text('Purchase'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(String image, {double size = 50}) {
    return ClipOval(
      child: Image.network(
        _resolveChatImage(image),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          color: Colors.white,
          alignment: Alignment.center,
          child: Icon(Icons.person, color: _maroon, size: size * .55),
        ),
      ),
    );
  }
}
