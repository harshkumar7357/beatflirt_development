// import 'package:flutter_riverpod/flutter_riverpod.dart';
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
// }
//
// class UserListState {
//   final List<UserListItem> users;
//   final bool isLoading;
//
//   const UserListState({
//     this.users = const [],
//     this.isLoading = false,
//   });
//
//   UserListState copyWith({
//     List<UserListItem>? users,
//     bool? isLoading,
//   }) {
//     return UserListState(
//       users: users ?? this.users,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
// }
//
// // Example Generic User List Notifier
// class UserListNotifier extends FamilyNotifier<UserListState, String> {
//   @override
//   UserListState build(String type) {
//     // Return dummy data based on the "type" (likes, friends, blocklist, etc.)
//     return UserListState(
//       users: [
//         UserListItem(
//           id: '1',
//           name: 'Sarah Connor',
//           imageUrl: 'assets/images/notification-image1.jpg',
//           lastSeen: '2 mins ago',
//           isOnline: true,
//         ),
//         UserListItem(
//           id: '2',
//           name: 'John Wick',
//           imageUrl: 'assets/images/notification-image4.jpg',
//           lastSeen: '1 hour ago',
//         ),
//         UserListItem(
//           id: '3',
//           name: 'Jane Doe',
//           imageUrl: 'assets/images/notification-image5.jpg',
//           lastSeen: 'Online',
//           isOnline: true,
//         ),
//         UserListItem(
//           id: '4',
//           name: 'Agent Smith',
//           imageUrl: 'assets/images/notification-image6.jpg',
//           lastSeen: 'Yesterday',
//         ),
//       ],
//     );
//   }
//
//   void removeUser(String id) {
//     state = state.copyWith(
//       users: state.users.where((u) => u.id != id).toList(),
//     );
//   }
// }
//
// final userListProvider = NotifierProviderFamily<UserListNotifier, UserListState, String>(UserListNotifier.new);


import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';

class UserListItem {
  final String id;
  final String name;
  final String imageUrl;
  final String lastSeen;
  final String location;
  final int age;
  final bool isOnline;

  const UserListItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastSeen,
    this.location = 'New York, USA',
    this.age = 24,
    this.isOnline = false,
  });

  factory UserListItem.fromMap(Map<String, dynamic> map) {
    return UserListItem(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unknown',
      imageUrl: map['imageUrl']?.toString() ?? 'assets/images/notification-image1.jpg',
      lastSeen: map['lastSeen']?.toString() ?? '',
      location: map['location']?.toString() ?? 'New York, USA',
      age: map['age'] is int ? map['age'] : 24,
      isOnline: map['isOnline'] == true,
    );
  }
}

class UserListState {
  final List<UserListItem> users;
  final bool isLoading;
  final String? error;

  const UserListState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  UserListState copyWith({
    List<UserListItem>? users,
    bool? isLoading,
    String? error,
  }) {
    return UserListState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Example Generic User List Notifier
class UserListNotifier extends FamilyNotifier<UserListState, String> {
  final ApiServices _api = ApiServices();

  @override
  UserListState build(String type) {
    // Initial fetch
    Future.microtask(() => fetchUsers());
    return const UserListState(isLoading: true);
  }

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        state = state.copyWith(isLoading: false, error: 'Unauthorized');
        return;
      }

      // Here we differentiate by "type" (e.g., 'favorites', 'blocklist')
      // For now, I'll mock the endpoint logic or use a generic one if available
      // Since API doesn't have a specific 'favorites' endpoint yet, we use a placeholder

      // If we had an endpoint:
      // final response = await _api.getFavorites(token: token);

      // MOCK for current temporary usage as requested
      await Future.delayed(const Duration(milliseconds: 800));

      final mockData = [
        {'id': '1', 'name': 'Sarah Connor', 'imageUrl': 'assets/images/notification-image1.jpg', 'lastSeen': '2 mins ago', 'isOnline': true},
        {'id': '2', 'name': 'John Wick', 'imageUrl': 'assets/images/notification-image4.jpg', 'lastSeen': '1 hour ago'},
        {'id': '3', 'name': 'Jane Doe', 'imageUrl': 'assets/images/notification-image5.jpg', 'lastSeen': 'Online', 'isOnline': true},
        {'id': '4', 'name': 'Agent Smith', 'imageUrl': 'assets/images/notification-image6.jpg', 'lastSeen': 'Yesterday'},
      ];

      state = state.copyWith(
        isLoading: false,
        users: mockData.map(UserListItem.fromMap).toList(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> removeUser(String id) async {
    // Optimistic UI update
    final originalUsers = state.users;
    state = state.copyWith(
      users: state.users.where((u) => u.id != id).toList(),
    );

    try {
      final token = await AuthService.getToken();
      if (token == null) return;

      // Call API to remove (commented until endpoint exists)
      // await _api.removeFavorite(token: token, userId: id);
    } catch (e) {
      // Revert on failure
      state = state.copyWith(users: originalUsers);
    }
  }

  Future<void> addUser(UserListItem user) async {
    state = state.copyWith(users: [user, ...state.users]);
    // API logic here...
  }
}

final userListProvider = NotifierProviderFamily<UserListNotifier, UserListState, String>(UserListNotifier.new);
