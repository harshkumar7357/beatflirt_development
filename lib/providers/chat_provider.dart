// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;

// class ChatMessage {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String content;
//   final DateTime timestamp;

//   ChatMessage({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.content,
//     required this.timestamp,
//   });

//   factory ChatMessage.fromMap(Map<String, dynamic> map) {
//     return ChatMessage(
//       id: map['_id']?.toString() ?? '',
//       senderId: map['sender']?.toString() ?? '',
//       receiverId: map['receiver']?.toString() ?? '',
//       content: map['content'] ?? '',
//       timestamp: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
//     );
//   }
// }

// class ChatState {
//   final List<ChatMessage> messages;
//   final bool isLoading;
//   final String? error;

//   ChatState({
//     this.messages = const [],
//     this.isLoading = false,
//     this.error,
//   });

//   ChatState copyWith({
//     List<ChatMessage>? messages,
//     bool? isLoading,
//     String? error,
//   }) {
//     return ChatState(
//       messages: messages ?? this.messages,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
// }

// class ChatNotifier extends FamilyNotifier<ChatState, String> {
//   final ApiService _api = ApiService();
//   io.Socket? _socket;

//   @override
//   ChatState build(String userId) {
//     ref.keepAlive();
//     Future.microtask(() => _initChat());
    
//     ref.onDispose(() {
//       _socket?.disconnect();
//       _socket?.dispose();
//     });

//     return ChatState(isLoading: true);
//   }

//   Future<void> _initChat() async {
//     await fetchMessages();
//     if (_socket == null) {
//       await _initSocket();
//     }
//   }


//   Future<void> _initSocket() async {
//     final token = await AuthService.getToken();
//     if (token == null) return;

//     // Get current user profile to know our own ID
//     String? myId;
//     try {
//       final profileData = await _api.getProfile(token: token);
//       myId = profileData['user']['id'] ?? profileData['user']['_id'];
//     } catch (e) {
//       print('Error fetching profile for socket: $e');
//     }

//     // Initialize socket
//     _socket = io.io('https://beatflirtevent.com', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });

//     _socket?.connect();

//     _socket?.onConnect((_) {
//       print('Connected to WebSocket');
//       if (myId != null) {
//         _socket?.emit('join', myId);
//       }
//     });

//     _socket?.on('receiveMessage', (data) {
//       print('New message received via socket: $data');
//       final newMessage = ChatMessage.fromMap(Map<String, dynamic>.from(data));
      
//       // Only add if it belongs to this conversation
//       if ((newMessage.senderId == arg && newMessage.receiverId == myId) ||
//           (newMessage.senderId == myId && newMessage.receiverId == arg)) {
//         state = state.copyWith(messages: [...state.messages, newMessage]);
//       }
//     });

//     _socket?.onDisconnect((_) => print('Disconnected from WebSocket'));
//   }

//   Future<void> fetchMessages({bool showLoading = true}) async {
//     if (showLoading && state.messages.isEmpty) {
//       state = state.copyWith(isLoading: true, error: null);
//     }

    
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       final messagesData = await _api.getMessages(token: token, userId: arg);
//       final newMessages = messagesData.map(ChatMessage.fromMap).toList();
      
//       print('Fetched ${newMessages.length} messages for conversation with $arg');
      
//       state = state.copyWith(
//         isLoading: false,
//         messages: newMessages,
//       );
//     } catch (e) {
//       if (showLoading) state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> sendMessage(String content) async {
//     final token = await AuthService.getToken();
//     if (token == null) return;

//     try {
//       final messageData = await _api.sendMessage(
//         token: token,
//         receiverId: arg,
//         content: content,
//       );

//       final newMessage = ChatMessage.fromMap(messageData);
      
//       // The socket server will also emit this back to us if we are listening correctly,
//       // but adding it here manually for immediate feedback (optimistic update).
//       // If the socket also emits it, we need to check for duplicates.
//       if (!state.messages.any((m) => m.id == newMessage.id)) {
//         state = state.copyWith(
//           messages: [...state.messages, newMessage],
//         );
//       }
//     } catch (e) {
//       state = state.copyWith(error: e.toString());
//     }
//   }
// }

// final chatProvider = NotifierProviderFamily<ChatNotifier, ChatState, String>(ChatNotifier.new);


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:beatflirt/Api_services/api_service.dart';
import 'package:beatflirt/core/services/auth_services.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? '',
      senderId: _extractId(map['sender']),
      receiverId: _extractId(map['receiver']),
      content: map['content']?.toString() ?? '',
      timestamp: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static String _extractId(dynamic value) {
    if (value == null) return '';

    if (value is Map) {
      return value['_id']?.toString() ?? value['id']?.toString() ?? '';
    }

    return value.toString();
  }
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  ChatNotifier(this.conversationUserId);

  final String conversationUserId;

  final ApiService _api = ApiService();

  io.Socket? _socket;
  String? _myId;

  @override
  ChatState build() {
    Future.microtask(_initChat);

    ref.onDispose(() {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
    });

    return const ChatState(isLoading: true);
  }

  Future<void> _initChat() async {
    await fetchMessages();

    if (_socket == null) {
      await _initSocket();
    }
  }

  Future<void> _initSocket() async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) return;

    try {
      final profileData = await _api.getProfile(token: token);

      final userData = profileData['user'];

      if (userData is Map) {
        _myId = userData['id']?.toString() ?? userData['_id']?.toString();
      }
    } catch (e) {
      print('Error fetching profile for socket: $e');
    }

    _socket = io.io(
      'https://beatflirtevent.com',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    _socket?.onConnect((_) {
      print('Connected to WebSocket');

      if (_myId != null && _myId!.isNotEmpty) {
        _socket?.emit('join', _myId);
      }
    });

    _socket?.on('receiveMessage', (data) {
      print('New message received via socket: $data');

      try {
        final newMessage = ChatMessage.fromMap(
          Map<String, dynamic>.from(data as Map),
        );

        final belongsToThisConversation =
            (newMessage.senderId == conversationUserId &&
                    newMessage.receiverId == _myId) ||
                (newMessage.senderId == _myId &&
                    newMessage.receiverId == conversationUserId);

        if (!belongsToThisConversation) return;

        final alreadyExists = state.messages.any(
          (m) => m.id == newMessage.id && newMessage.id.isNotEmpty,
        );

        if (!alreadyExists) {
          state = state.copyWith(
            messages: [...state.messages, newMessage],
            clearError: true,
          );
        }
      } catch (e) {
        print('Socket message parse error: $e');
      }
    });

    _socket?.onDisconnect((_) {
      print('Disconnected from WebSocket');
    });

    _socket?.connect();
  }

  Future<void> fetchMessages({bool showLoading = true}) async {
    if (showLoading && state.messages.isEmpty) {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );
    }

    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Not authenticated',
        );
        return;
      }

      final messagesData = await _api.getMessages(
        token: token,
        userId: conversationUserId,
      );

      final newMessages = messagesData
          .map(
            (e) => ChatMessage.fromMap(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();

      print(
        'Fetched ${newMessages.length} messages for conversation with $conversationUserId',
      );

      state = state.copyWith(
        isLoading: false,
        messages: newMessages,
        clearError: true,
      );
    } catch (e) {
      if (showLoading) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> sendMessage(String content) async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      state = state.copyWith(error: 'Not authenticated');
      return;
    }

    try {
      final messageData = await _api.sendMessage(
        token: token,
        receiverId: conversationUserId,
        content: content,
      );

      final newMessage = ChatMessage.fromMap(
        Map<String, dynamic>.from(messageData),
      );

      final alreadyExists = state.messages.any(
        (m) => m.id == newMessage.id && newMessage.id.isNotEmpty,
      );

      if (!alreadyExists) {
        state = state.copyWith(
          messages: [...state.messages, newMessage],
          clearError: true,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final chatProvider = NotifierProvider.family<ChatNotifier, ChatState, String>(
  ChatNotifier.new,
);