// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../providers/chatroom_provider.dart';
// import '../../core/services/auth_services.dart';
// import '../../Api_services/api_services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;

// class ChatroomDetailPage extends ConsumerStatefulWidget {
//   final Chatroom room;
//   const ChatroomDetailPage({super.key, required this.room});

//   @override
//   ConsumerState<ChatroomDetailPage> createState() => _ChatroomDetailPageState();
// }

// class _ChatroomDetailPageState extends ConsumerState<ChatroomDetailPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _messages = [];
//   bool _isLoading = false;
//   final ApiServices _api = ApiServices();
//   io.Socket? _socket;
//   String? _currentUserId;

//   @override
//   void dispose() {
//     _socket?.emit('leaveRoom', widget.room.id);
//     _socket?.disconnect();
//     _socket?.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchHistory().then((_) {
//       _initSocket();
//     });
//   }

//   Future<void> _fetchHistory() async {
//     setState(() => _isLoading = true);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       // --- Self-healing: recover userId if missing from SharedPreferences ---
//       String? currentUserId = await AuthService.getUserId();
//       if (currentUserId == null || currentUserId.isEmpty) {
//         try {
//           final profileData = await _api.getProfile(token: token);
//           final user = profileData['user'] as Map<String, dynamic>?;
//           currentUserId = (user?['_id'] ?? user?['id'] ?? '').toString();
//           if (currentUserId.isNotEmpty) {
//             // Save so we don't need to re-fetch next time
//             await AuthService.login(
//               token: token,
//               email: (user?['email'] ?? '').toString(),
//               userId: currentUserId,
//             );
//           }
//         } catch (_) {
//           currentUserId = null;
//         }
//       }
//       _currentUserId = currentUserId; // Save for socket listener
//       print('🛠️ DEBUG: currentUserId: \'$currentUserId\'');
//       // -------------------------------------------------------------------

//       final history = await _api.getChatroomMessages(
//         token: token,
//         roomId: widget.room.id,
//       );

//       setState(() {
//         _messages.clear();
//         _messages.addAll(
//           history.map((m) {
//             final rawSender = m['sender'];
//             final senderId = (rawSender is Map)
//                 ? (rawSender['_id'] ?? rawSender['id']).toString()
//                 : rawSender?.toString() ?? '';

//             final bool isMe =
//                 currentUserId != null &&
//                 currentUserId.isNotEmpty &&
//                 senderId == currentUserId.toString();

//             return {
//               'id': m['_id'],
//               'text': m['text'],
//               'attachmentUrl': m['attachmentUrl'],
//               'attachmentType': m['attachmentType'],
//               'sender': (rawSender is Map) ? rawSender['name'] : 'User',
//               'isMe': isMe,
//               'time': DateTime.parse(
//                 m['timestamp'] ?? DateTime.now().toIso8601String(),
//               ),
//             };
//           }).toList(),
//         );
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       print('Error fetching history: $e');
//     }
//   }

//   void _initSocket() {
//     _socket = io.io(ApiServices.baseUrl.replaceAll('/api', ''), <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });

//     _socket?.connect();

//     _socket?.onConnect((_) {
//       print('Connected to Chatroom WebSocket');
//       _socket?.emit('joinRoom', widget.room.id);
//     });

//     _socket?.on('newChatroomMessage', (data) {
//       if (!mounted) return;
      
//       final roomId = data['roomId'];
//       if (roomId != widget.room.id) return;

//       final m = data['message'];
//       final rawSender = m['sender'];
//       final senderId = (rawSender is Map)
//           ? (rawSender['_id'] ?? rawSender['id']).toString()
//           : rawSender?.toString() ?? '';

//       final bool isMe = _currentUserId != null &&
//           _currentUserId!.isNotEmpty &&
//           senderId == _currentUserId;

//       setState(() {
//         // Prevent duplicate messages from optimistic update
//         if (!_messages.any((msg) => msg['id'] == m['_id'])) {
//           _messages.add({
//             'id': m['_id'],
//             'text': m['text'],
//             'attachmentUrl': m['attachmentUrl'],
//             'attachmentType': m['attachmentType'],
//             'sender': (rawSender is Map) ? rawSender['name'] : 'User',
//             'isMe': isMe,
//             'time': DateTime.parse(
//               m['timestamp'] ?? DateTime.now().toIso8601String(),
//             ),
//           });
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F1A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A1A2E),
//         elevation: 0,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.white.withValues(alpha: 0.1),
//               child: ClipOval(
//                 child: widget.room.imageUrl.isNotEmpty
//                     ? Image.network(widget.room.imageUrl, fit: BoxFit.cover)
//                     : const Icon(Icons.group, color: Colors.white70, size: 20),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.room.name,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: const BoxDecoration(
//                           color: Colors.greenAccent,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         "online",
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.white.withValues(alpha: 0.5),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             size: 18,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           FutureBuilder<String?>(
//             future: AuthService.getUserId(),
//             builder: (context, snapshot) {
//               final currentUserId = snapshot.data;
//               final isOwner = widget.room.creatorId == currentUserId;

//               if (isOwner &&
//                   widget.room.isPrivate &&
//                   widget.room.joinCode != null) {
//                 return IconButton(
//                   icon: const Icon(
//                     Icons.share,
//                     color: Colors.pinkAccent,
//                     size: 20,
//                   ),
//                   onPressed: () => _showShareCodeDialog(context),
//                   tooltip: "Share Room Code",
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//           IconButton(
//             icon: const FaIcon(FontAwesomeIcons.users, size: 18),
//             onPressed: () {
//               // Show members list
//             },
//           ),
//           const SizedBox(width: 5),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF0F0F1A),
//           // Removed AssetImage pattern to avoid potential crash if file missing
//         ),
//         child: Column(
//           children: [
            
//             Expanded(
//               child: _isLoading
//                   ? const Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.pinkAccent,
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 20,
//                       ),
//                       reverse: true,
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final currentMsgIndex = _messages.length - 1 - index;
//                         final msg = _messages[currentMsgIndex];
                        
//                         bool showDateHeader = false;
//                         if (currentMsgIndex == 0) {
//                           showDateHeader = true;
//                         } else {
//                           final prevMsg = _messages[currentMsgIndex - 1];
//                           final currentDate = msg['time'] as DateTime;
//                           final prevDate = prevMsg['time'] as DateTime;
//                           if (currentDate.year != prevDate.year || 
//                               currentDate.month != prevDate.month || 
//                               currentDate.day != prevDate.day) {
//                             showDateHeader = true;
//                           }
//                         }

//                         if (showDateHeader) {
//                           return Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               _buildDateHeader(msg['time'] as DateTime),
//                               _buildMessageBubble(msg),
//                             ],
//                           );
//                         }

//                         return _buildMessageBubble(msg);
//                       },
//                     ),
//             ),
//             _buildMessageInput(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDateHeader(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final msgDate = DateTime(date.year, date.month, date.day);

//     String dateString;
//     if (msgDate == today) {
//       dateString = "Today";
//     } else if (msgDate == yesterday) {
//       dateString = "Yesterday";
//     } else if (now.difference(msgDate).inDays < 7) {
//       dateString = DateFormat('EEEE').format(date); // Monday, Tuesday, etc.
//     } else {
//       dateString = DateFormat('MMMM d, y').format(date); // May 16, 2026
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2E2E40),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Text(
//         dateString,
//         style: const TextStyle(
//           color: Colors.white70,
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Map<String, dynamic> msg) {
//     bool isMe = msg['isMe'] ?? false;
//     return GestureDetector(
//       onLongPress: isMe ? () => _showDeleteConfirmation(msg) : null,
//       child: Align(
//         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           margin: EdgeInsets.only(
//             top: 4,
//             bottom: 4,
//             left: isMe ? 60 : 0,
//             right: isMe ? 0 : 60,
//           ),
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.75,
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: isMe
//                 ? const Color(0xFFE91E63)
//                 : Colors.white.withValues(alpha: 0.08),
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(16),
//               topRight: const Radius.circular(16),
//               bottomLeft: Radius.circular(isMe ? 16 : 0),
//               bottomRight: Radius.circular(isMe ? 0 : 16),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.1),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (!isMe)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 4),
//                   child: Text(
//                     msg['sender'] ?? 'User',
//                     style: const TextStyle(
//                       color: Colors.pinkAccent,
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               if (msg['attachmentUrl'] != null && msg['attachmentUrl'].isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 5),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       msg['attachmentUrl'],
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) =>
//                           const Icon(Icons.broken_image, color: Colors.white24),
//                     ),
//                   ),
//                 ),
//               if (msg['text'] != null && msg['text'].toString().isNotEmpty)
//                 Text(
//                   msg['text'] ?? '',
//                   style: const TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               const SizedBox(height: 4),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     DateFormat('hh:mm a').format(msg['time'] ?? DateTime.now()),
//                     style: TextStyle(
//                       color: Colors.white.withValues(alpha: 0.4),
//                       fontSize: 9,
//                     ),
//                   ),
//                   if (isMe) ...[
//                     const SizedBox(width: 4),
//                     const Icon(
//                       Icons.done_all,
//                       color: Colors.blueAccent,
//                       size: 12,
//                     ),
//                   ],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmation(Map<String, dynamic> msg) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1A1A2E),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   "Message Options",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.copy, color: Colors.white70),
//                 title: const Text("Copy Text", style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Clipboard.setData(ClipboardData(text: msg['text'] ?? ""));
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                 title: const Text("Delete for everyone", style: TextStyle(color: Colors.redAccent)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _deleteMessage(msg);
//                 },
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _deleteMessage(Map<String, dynamic> msg) async {
//     final messageId = msg['id'];
//     if (messageId == null) return;

//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       await _api.deleteChatroomMessage(
//         token: token,
//         roomId: widget.room.id,
//         messageId: messageId,
//       );

//       setState(() {
//         _messages.removeWhere((m) => m['id'] == messageId);
//       });
      
//       Get.snackbar(
//         "Deleted", 
//         "Message removed successfully",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.black87,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Error deleting message: $e");
//     }
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A2E),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.2),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             IconButton(
//               icon: const Icon(
//                 Icons.add_circle_outline,
//                 color: Colors.pinkAccent,
//               ),
//               onPressed: () => _pickImage(ImageSource.gallery),
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.05),
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(
//                     color: Colors.white.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const SizedBox(width: 15),
//                     Expanded(
//                       child: TextField(
//                         controller: _messageController,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                         maxLines: 4,
//                         minLines: 1,
//                         decoration: InputDecoration(
//                           hintText: "Type a message...",
//                           hintStyle: TextStyle(
//                             color: Colors.white.withValues(alpha: 0.2),
//                           ),
//                           border: InputBorder.none,
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(
//                             vertical: 10,
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.emoji_emotions_outlined,
//                         color: Colors.white30,
//                         size: 20,
//                       ),
//                       onPressed: () {
//                         // In a real app, show emoji picker. For now, add a cool emoji
//                         _messageController.text += "🔥";
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.camera_alt_outlined,
//                         color: Colors.white30,
//                         size: 20,
//                       ),
//                       onPressed: () => _pickImage(ImageSource.camera),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: () => _sendMessage(),
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFE91E63),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.send, color: Colors.white, size: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _sendMessage({
//     String? attachmentUrl,
//     String? attachmentType,
//   }) async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty && attachmentUrl == null) return;

//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       final msgData = await _api.sendChatroomMessage(
//         token: token,
//         roomId: widget.room.id,
//         text: text.isNotEmpty ? text : null,
//         attachmentUrl: attachmentUrl,
//         attachmentType: attachmentType,
//       );

//       setState(() {
//         _messages.add({
//           'id': msgData['_id'],
//           'text': msgData['text'],
//           'attachmentUrl': msgData['attachmentUrl'],
//           'attachmentType': msgData['attachmentType'],
//           'sender': 'Me',
//           'isMe': true,
//           'time': DateTime.now(),
//         });
//         _messageController.clear();
//       });
//       // Trigger a re-scroll if needed, or simply let the reverse ListView handle it.
//     } catch (e) {
//       print("Error sending message: $e");
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       // In a real app, upload to Cloudinary/S3 first.
//       // For now, we'll use the local path to simulate a backend URL for UI demonstration.
//       // Ideally: final uploadUrl = await _api.uploadFile(pickedFile.path);
//       await _sendMessage(
//         attachmentUrl: pickedFile.path,
//         attachmentType: 'image',
//       );
//     }
//   }

//   void _showShareCodeDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1A2E),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text(
//           "Share Room Code",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Share this 6-digit code with people you want to invite to this private room:",
//               style: TextStyle(color: Colors.white70, fontSize: 13),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.05),
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(
//                   color: Colors.pinkAccent.withValues(alpha: 0.3),
//                 ),
//               ),
//               child: Text(
//                 widget.room.joinCode ?? "N/A",
//                 style: const TextStyle(
//                   color: Colors.pinkAccent,
//                   fontSize: 32,
//                   fontWeight: FontWeight.w900,
//                   letterSpacing: 8,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close", style: TextStyle(color: Colors.white38)),
//           ),
//           ElevatedButton.icon(
//             onPressed: () {
//               Clipboard.setData(
//                 ClipboardData(text: widget.room.joinCode ?? ""),
//               );
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Code copied to clipboard!")),
//               );
//             },
//             icon: const Icon(Icons.copy, size: 16),
//             label: const Text("Copy Code"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.pinkAccent,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
