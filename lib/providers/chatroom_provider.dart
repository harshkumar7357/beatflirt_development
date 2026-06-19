import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';

class Chatroom {
  final String id;
  final String name;
  final String description;
  final String category;
  final String creatorId; // Stores the raw user ID
  final String creatorName; // Stores the display name
  final List<String> activeUsers;
  final bool isPrivate;
  final String? joinCode;
  final String imageUrl;

  Chatroom({
    required this.id,
    required this.name,
    this.description = '',
    this.category = 'General',
    required this.creatorId,
    required this.creatorName,
    this.activeUsers = const [],
    this.isPrivate = false,
    this.joinCode,
    this.imageUrl = '',
  });

  factory Chatroom.fromMap(Map<String, dynamic> map) {
    String cId = '';
    String cName = 'Unknown';

    final createdBy = map['createdBy'];
    if (createdBy is Map) {
      cId = (createdBy['_id'] ?? createdBy['id'] ?? '').toString();
      cName = (createdBy['name'] ?? 'Unknown').toString();
    } else {
      cId = createdBy?.toString() ?? '';
    }

    return Chatroom(
      id: map['_id'] ?? map['id'] ?? '',
      name: map['name'] ?? 'Unknown Room',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      creatorId: cId,
      creatorName: cName,
      activeUsers: List<String>.from(map['activeUsers'] ?? []),
      isPrivate: map['isPrivate'] == true,
      joinCode: map['joinCode'],
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

class ChatroomState {
  final List<Chatroom> rooms;
  final bool isLoading;
  final String? error;

  ChatroomState({
    this.rooms = const [],
    this.isLoading = false,
    this.error,
  });

  ChatroomState copyWith({
    List<Chatroom>? rooms,
    bool? isLoading,
    String? error,
  }) {
    return ChatroomState(
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ChatroomNotifier extends Notifier<ChatroomState> {
  final ApiServices _api = ApiServices();

  @override
  ChatroomState build() {
    Future.microtask(() => fetchRooms());
    return ChatroomState(isLoading: true);
  }

  Future<void> fetchRooms() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        state = state.copyWith(isLoading: false, error: 'Unauthorized');
        return;
      }

      final roomsData = await _api.getChatrooms(token: token);
      final rooms = roomsData.map(Chatroom.fromMap).toList();
      print("Fetched ${rooms.length} rooms from API");

      state = state.copyWith(
        isLoading: false,
        rooms: rooms,
      );

    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createRoom(String name, String category, {String description = '', bool isPrivate = false}) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return;

      final roomData = await _api.createChatroom(
        token: token,
        name: name,
        category: category,
        description: description,
        isPrivate: isPrivate,
      );


      final newRoom = Chatroom.fromMap(roomData);
      print("New room created: ${newRoom.name}, isPrivate: ${newRoom.isPrivate}");
      
      // Update local state and then force refresh from server
      state = state.copyWith(rooms: [newRoom, ...state.rooms]);
      await fetchRooms();
      print("State refreshed after creation. Total rooms: ${state.rooms.length}");
    } catch (e) {
      print("Error creating room: $e");
      state = state.copyWith(error: e.toString());
      rethrow; // Rethrow so UI can catch it
    }
  }


  Future<Chatroom> joinByCode(String code) async {
    // Clear any previous error before starting
    state = state.copyWith(error: null);
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Unauthorized');

    final roomData = await _api.joinChatroomByCode(token: token, code: code);
    final joinedRoom = Chatroom.fromMap(roomData);

    // Add to local state if not already present
    if (!state.rooms.any((r) => r.id == joinedRoom.id)) {
      state = state.copyWith(rooms: [joinedRoom, ...state.rooms]);
    }
    return joinedRoom;
  }
}


final chatroomProvider = NotifierProvider<ChatroomNotifier, ChatroomState>(ChatroomNotifier.new);
