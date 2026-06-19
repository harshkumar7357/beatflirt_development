// import 'package:flutter/material.dart';
// import '../../core/constants/app_colors.dart';

// class ChatScreen extends StatefulWidget {
//   final String recipientId;
//   final String recipientName;
//   final String? recipientPhoto;

//   const ChatScreen({
//     super.key,
//     required this.recipientId,
//     required this.recipientName,         //////main
//     this.recipientPhoto,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<Map<String, dynamic>> _messages = [];
//   bool _isTyping = false;

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty) return;

//     setState(() {
//       _messages.add({
//         'id': DateTime.now().millisecondsSinceEpoch.toString(),
//         'text': _messageController.text.trim(),
//         'senderId': 'current_user',
//         'timestamp': DateTime.now(),
//         'isRead': false,
//       });
//     });

//     _messageController.clear();
//     _scrollToBottom();

//     // Simulate typing indicator and auto-reply for demo
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() => _isTyping = true);
//       }
//     });

//     Future.delayed(const Duration(seconds: 4), () {
//       if (mounted) {
//         setState(() {
//           _isTyping = false;
//           _messages.add({
//             'id': DateTime.now().millisecondsSinceEpoch.toString(),
//             'text': 'Thanks for reaching out! We\'d love to connect with you.',
//             'senderId': widget.recipientId,
//             'timestamp': DateTime.now(),
//             'isRead': false,
//           });
//         });
//         _scrollToBottom();
//       }
//     });
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.cardBackground,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Row(
//           children: [
//             // Avatar
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: AppColors.primaryColor,
//               child: const Icon(Icons.person, color: Colors.white, size: 24),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.recipientName,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const Row(
//                   children: [
//                     Icon(Icons.circle, color: AppColors.onlineIndicator, size: 8),
//                     SizedBox(width: 4),
//                     Text(
//                       'Online',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
//             onPressed: () {
//               // More options
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Messages List
//           Expanded(
//             child: _messages.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//                     controller: _scrollController,
//                     padding: const EdgeInsets.all(16),
//                     itemCount: _messages.length + (_isTyping ? 1 : 0),
//                     itemBuilder: (context, index) {
//                       if (_isTyping && index == _messages.length) {
//                         return _buildTypingIndicator();
//                       }
//                       final message = _messages[index];
//                       final isMe = message['senderId'] == 'current_user';
//                       return _buildMessageBubble(message, isMe);
//                     },
//                   ),
//           ),
          
//           // Typing Indicator Banner (when other person is typing)
//           if (_isTyping)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               color: AppColors.backgroundColor,
//               child: Row(
//                 children: [
//                   const SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: AppColors.primaryColor,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     '${widget.recipientName} is typing...',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.textSecondary,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
          
//           // Message Input
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: AppColors.primaryLight.withValues(alpha: 0.3),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.chat_bubble_outline,
//               size: 48,
//               color: AppColors.primaryColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Start the conversation!',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Send a message to connect with this couple',
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.textSecondary,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         decoration: BoxDecoration(
//           color: isMe ? AppColors.primaryColor : AppColors.cardBackground,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(20),
//             topRight: const Radius.circular(20),
//             bottomLeft: Radius.circular(isMe ? 20 : 4),
//             bottomRight: Radius.circular(isMe ? 4 : 20),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.shadowColor,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               message['text'],
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isMe ? Colors.white : AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _formatTime(message['timestamp']),
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: isMe ? Colors.white70 : AppColors.textSecondary,
//                   ),
//                 ),
//                 if (isMe) ...[
//                   const SizedBox(width: 4),
//                   Icon(
//                     message['isRead'] ? Icons.done_all : Icons.done,
//                     size: 14,
//                     color: message['isRead'] ? AppColors.info : Colors.white70,
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTypingIndicator() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: AppColors.cardBackground,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//             bottomLeft: Radius.circular(4),
//             bottomRight: Radius.circular(20),
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildDot(0),
//             const SizedBox(width: 4),
//             _buildDot(1),
//             const SizedBox(width: 4),
//             _buildDot(2),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDot(int index) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + (index * 200)),
//       builder: (context, value, child) {
//         return Container(
//           width: 8,
//           height: 8,
//           decoration: BoxDecoration(
//             color: AppColors.primaryColor.withValues(alpha: value),
//             shape: BoxShape.circle,
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowColor,
//             blurRadius: 8,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             // Attachment Button
//             IconButton(
//               icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
//               onPressed: () {
//                 // Add attachment
//               },
//             ),
            
//             // Text Input
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.backgroundColor,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: TextField(
//                   controller: _messageController,
//                   decoration: const InputDecoration(
//                     hintText: 'Type a message...',
//                     hintStyle: TextStyle(color: AppColors.textHint),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   ),
//                   textCapitalization: TextCapitalization.sentences,
//                   maxLines: 4,
//                   minLines: 1,
//                   onSubmitted: (_) => _sendMessage(),
//                 ),
//               ),
//             ),
            
//             const SizedBox(width: 8),
            
//             // Send Button
//             Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(colors: AppColors.primaryGradient),
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.send, color: Colors.white),
//                 onPressed: _sendMessage,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatTime(DateTime timestamp) {
//     final hour = timestamp.hour.toString().padLeft(2, '0');
//     final minute = timestamp.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/providers/chat_provider.dart';
import 'package:beatflirt/providers/user_list_provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final UserListItem user;
  const ChatScreen({super.key, required this.user, required String recipientId, required String recipientName});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Scroll to bottom after first build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.user.id));

    // Listen for changes in messages to auto-scroll
    ref.listen(chatProvider(widget.user.id), (previous, next) {
      if (next.messages.length != (previous?.messages.length ?? 0)) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              backgroundImage: widget.user.imageUrl.startsWith('assets/')
                  ? AssetImage(widget.user.imageUrl) as ImageProvider
                  : NetworkImage(widget.user.imageUrl),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.user.isOnline
                            ? Colors.green
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.user.isOnline ? 'Active Now' : 'Offline',
                      style: TextStyle(
                        color: widget.user.isOnline
                            ? Colors.green
                            : Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.error != null && chatState.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                        const SizedBox(height: 10),
                        Text(
                          'Error: ${chatState.error}',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        TextButton(
                          onPressed: () => ref
                              .read(chatProvider(widget.user.id).notifier)
                              .fetchMessages(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : chatState.isLoading && chatState.messages.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.pinkAccent),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      final isMe = message.senderId != widget.user.id;

                      // Show date header if it's the first message of the day
                      bool showDateHeader = false;
                      if (index == 0) {
                        showDateHeader = true;
                      } else {
                        final prevDate =
                            chatState.messages[index - 1].timestamp;
                        if (prevDate.day != message.timestamp.day) {
                          showDateHeader = true;
                        }
                      }

                      return Column(
                        children: [
                          if (showDateHeader)
                            _buildDateHeader(message.timestamp),
                          _buildMessageBubble(message, isMe),
                        ],
                      );
                    },
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            DateFormat('MMMM dd, yyyy').format(timestamp),
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(
                  colors: [Colors.pinkAccent, Color(0xFFFF4081)],
                )
              : null,
          color: isMe ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 5),
            bottomRight: Radius.circular(isMe ? 5 : 20),
          ),
          boxShadow: [
            if (isMe)
              BoxShadow(
                color: Colors.pinkAccent.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: TextStyle(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.white38,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  onTapOutside: (_) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.white30),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                final content = _messageController.text.trim();
                if (content.isNotEmpty) {
                  ref
                      .read(chatProvider(widget.user.id).notifier)
                      .sendMessage(content);
                  _messageController.clear();
                  Future.delayed(
                    const Duration(milliseconds: 100),
                    _scrollToBottom,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


