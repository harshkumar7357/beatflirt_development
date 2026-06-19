// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// //
// // class UserListItem {
// //   final String id;
// //   final String name;
// //   final String imageUrl;
// //   final String lastSeen;
// //   final String location;
// //   final int age;
// //   final bool isOnline;
// //
// //   const UserListItem({
// //     required this.id,
// //     required this.name,
// //     required this.imageUrl,
// //     required this.lastSeen,
// //     this.location = 'New York, USA',
// //     this.age = 24,
// //     this.isOnline = false,
// //   });
// // }
// //
// // class UserListState {
// //   final List<UserListItem> users;
// //   final bool isLoading;
// //
// //   const UserListState({
// //     this.users = const [],
// //     this.isLoading = false,
// //   });
// //
// //   UserListState copyWith({
// //     List<UserListItem>? users,
// //     bool? isLoading,
// //   }) {
// //     return UserListState(
// //       users: users ?? this.users,
// //       isLoading: isLoading ?? this.isLoading,
// //     );
// //   }
// // }
// //
// // // Example Generic User List Notifier
// // class UserListNotifier extends FamilyNotifier<UserListState, String> {
// //   @override
// //   UserListState build(String type) {
// //     // Return dummy data based on the "type" (likes, friends, blocklist, etc.)
// //     return UserListState(
// //       users: [
// //         UserListItem(
// //           id: '1',
// //           name: 'Sarah Connor',
// //           imageUrl: 'assets/images/notification-image1.jpg',
// //           lastSeen: '2 mins ago',
// //           isOnline: true,
// //         ),
// //         UserListItem(
// //           id: '2',
// //           name: 'John Wick',
// //           imageUrl: 'assets/images/notification-image4.jpg',
// //           lastSeen: '1 hour ago',
// //         ),
// //         UserListItem(
// //           id: '3',
// //           name: 'Jane Doe',
// //           imageUrl: 'assets/images/notification-image5.jpg',
// //           lastSeen: 'Online',
// //           isOnline: true,
// //         ),
// //         UserListItem(
// //           id: '4',
// //           name: 'Agent Smith',
// //           imageUrl: 'assets/images/notification-image6.jpg',
// //           lastSeen: 'Yesterday',
// //         ),
// //       ],
// //     );
// //   }
// //
// //   void removeUser(String id) {
// //     state = state.copyWith(
// //       users: state.users.where((u) => u.id != id).toList(),
// //     );
// //   }
// // }
// //
// // final userListProvider = NotifierProviderFamily<UserListNotifier, UserListState, String>(UserListNotifier.new);

// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/core/services/auth_services.dart';

// class UserListItem {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final String lastSeen;
//   final String location;
//   final int age;
//   final bool isOnline;

//   const UserListItem({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.lastSeen,
//     this.location = 'New York, USA',
//     this.age = 24,
//     this.isOnline = false,
//   });

//   factory UserListItem.fromMap(Map<String, dynamic> map) {
//     String? imgUrl = map['imageUrl']?.toString();
    
//     if (imgUrl == null && map['photos'] is List) {
//       final photos = map['photos'] as List;
//       final mainPhoto = photos.firstWhere(
//         (p) => p['isMain'] == true,
//         orElse: () => photos.isNotEmpty ? photos[0] : null,
//       );
//       if (mainPhoto != null && mainPhoto['path'] != null) {
//         imgUrl = mainPhoto['path'].toString();
//       }
//     }

//     return UserListItem(
//       id: map['id']?.toString() ?? map['_id']?.toString() ?? '',
//       name: map['name']?.toString() ?? 'Unknown',
//       imageUrl: imgUrl ?? 'assets/images/notification-image1.jpg',
//       lastSeen: map['lastSeen']?.toString() ?? '',
//       location: map['location']?.toString() ?? 'New York, USA',
//       age: map['age'] is int ? map['age'] : 24,
//       isOnline: map['isOnline'] == true,
//     );
//   }

// }

// class UserListState {
//   final List<UserListItem> users;
//   final bool isLoading;
//   final String? error;

//   const UserListState({
//     this.users = const [],
//     this.isLoading = false,
//     this.error,
//   });

//   UserListState copyWith({
//     List<UserListItem>? users,
//     bool? isLoading,
//     String? error,
//   }) {
//     return UserListState(
//       users: users ?? this.users,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
// }

// // Example Generic User List Notifier
// class UserListNotifier extends AutoDisposeFamilyNotifier<UserListState, String> {
//   final ApiServices _api = ApiServices();

//   @override
//   UserListState build(String type) {
//     // Initial fetch
//     Future.microtask(() => fetchUsers());
//     return const UserListState(isLoading: true);
//   }

//   Future<void> fetchUsers() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) {
//         state = state.copyWith(isLoading: false, error: 'Unauthorized');
//         return;
//       }

//       // Here we differentiate by "type" (e.g., 'favorites', 'blocklist', 'online')
//       if (arg == 'online') {
//         final usersData = await _api.getOnlineUsers(token: token);

//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) => UserListItem.fromMap(data)).toList(),
//         );
//         return;
//       }

//       if (arg == 'friends') {
//         final usersData = await _api.getFriends(token: token);

//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) => UserListItem.fromMap(data)).toList(),
//         );
//         return;
//       }

//       if (arg == 'validation_requests') {

//         final usersData = await _api.getPendingValidationRequests(token: token);

//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) {
//             final user = data['userId'];
//             final photos = user?['photos'] as List?;
//             final mainPhoto = photos?.firstWhere(
//               (p) => p['isMain'] == true,
//               orElse: () => photos.firstOrNull,
//             );
//             return UserListItem(
//               id: user?['_id'] ?? '',
//               name: user?['name'] ?? 'Unknown',
//               imageUrl:
//                   mainPhoto?['path'] ?? 'assets/images/notification-image1.jpg',
//               lastSeen: 'Pending Review',
//               isOnline: false,
//             );
//           }).toList(),
//         );
//         return;
//       }

//       if (arg == 'favorites') {
//         final usersData = await _api.getFavorites(token: token);
//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) => UserListItem.fromMap(data)).toList(),
//         );
//         return;
//       }

//       if (arg == 'likes') {
//         final usersData = await _api.getLikes(token: token);
//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) => UserListItem.fromMap(data)).toList(),
//         );
//         return;
//       }

//       if (arg == 'blocklist') {
//         final usersData = await _api.getBlocklist(token: token);
//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) => UserListItem.fromMap(data)).toList(),
//         );
//         return;
//       }

//       if (arg == 'viewed_me') {
//         final usersData = await _api.getViewedMe(token: token);
//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) => UserListItem.fromMap(data)).toList(),
//         );
//         return;
//       }

//       if (arg == 'new_members' || arg == 'new_member') {
//         final usersData = await _api.getNewMembers(token: token);
//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) => UserListItem.fromMap(data)).toList(),
//         );
//         return;
//       }

//       if (arg == 'friend_requests') {
//         final usersData = await _api.getFriendRequests(token: token);
//         state = state.copyWith(
//           isLoading: false,
//           users: usersData.map((data) => UserListItem.fromMap(data as Map<String, dynamic>)).toList(),
//         );
//         return;
//       }

//       // MOCK for other types for now
//       await Future.delayed(const Duration(milliseconds: 800));

//       final mockData = [
//         {
//           'id': '1',
//           'name': 'Sarah Connor',
//           'imageUrl': 'assets/images/notification-image1.jpg',
//           'lastSeen': '2 mins ago',
//           'isOnline': true,
//         },
//         {
//           'id': '2',
//           'name': 'John Wick',
//           'imageUrl': 'assets/images/notification-image4.jpg',
//           'lastSeen': '1 hour ago',
//         },
//         {
//           'id': '3',
//           'name': 'Jane Doe',
//           'imageUrl': 'assets/images/notification-image5.jpg',
//           'lastSeen': 'Online',
//           'isOnline': true,
//         },
//         {
//           'id': '4',
//           'name': 'Agent Smith',
//           'imageUrl': 'assets/images/notification-image6.jpg',
//           'lastSeen': 'Yesterday',
//         },
//       ];

//       state = state.copyWith(
//         isLoading: false,
//         users: mockData.map(UserListItem.fromMap).toList(),
//       );
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> removeUser(String id) async {
//     // Optimistic UI update
//     final originalUsers = state.users;
//     state = state.copyWith(
//       users: state.users.where((u) => u.id != id).toList(),
//     );

//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       // Call API to remove
//       if (arg == 'friends') {
//         await _api.removeFriend(token: token, friendId: id);
//       } else {
//         // await _api.removeFavorite(token: token, userId: id);
//       }
//     } catch (e) {
//       // Revert on failure
//       state = state.copyWith(users: originalUsers);
//     }
//   }

//   Future<void> reviewValidation(String userId, String status) async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       await _api.reviewValidation(token: token, userId: userId, status: status);

//       // Remove from local list
//       state = state.copyWith(
//         users: state.users.where((u) => u.id != userId).toList(),
//       );
//     } catch (e) {
//       // Handle error (maybe show a toast)
//       print('Review error: $e');
//     }
//   }

//   Future<void> acceptFriendRequest(String requesterId) async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;
//       await _api.acceptFriendRequest(token: token, requesterId: requesterId);
//       // Remove from local list
//       state = state.copyWith(
//         users: state.users.where((u) => u.id != requesterId).toList(),
//       );
//     } catch (e) {
//       print('Accept friend request error: $e');
//     }
//   }

//   Future<void> declineFriendRequest(String requesterId) async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;
//       await _api.declineFriendRequest(token: token, requesterId: requesterId);
//       // Remove from local list
//       state = state.copyWith(
//         users: state.users.where((u) => u.id != requesterId).toList(),
//       );
//     } catch (e) {
//       print('Decline friend request error: $e');
//     }
//   }

//   Future<void> sayHi(String userId) async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;
//       await _api.sendHi(token: token, userId: userId);
//     } catch (e) {
//       print('Say Hi error: $e');
//       rethrow;
//     }
//   }

//   Future<void> toggleFavorite(String userId) async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;
//       await _api.toggleFavorite(token: token, userId: userId);
//       if (arg == 'favorites') {
//         state = state.copyWith(
//           users: state.users.where((u) => u.id != userId).toList(),
//         );
//       }
//     } catch (e) {
//       print('Toggle favorite error: $e');
//       rethrow;
//     }
//   }


//   Future<void> searchUsers(String query) async {
//     if (query.isEmpty) {
//       await fetchUsers();
//       return;
//     }
    
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) return;

//       final results = await _api.searchUsers(token: token, query: query);
//       state = state.copyWith(
//         isLoading: false,
//         users: results.map((data) => UserListItem.fromMap(data)).toList(),
//       );
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> addUser(UserListItem user) async {
//     state = state.copyWith(users: [user, ...state.users]);
//     // API logic here...
//   }
// }

// final userListProvider =
//     NotifierProvider.autoDispose.family<UserListNotifier, UserListState, String>(
//       UserListNotifier.new,
//     );


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
    String? imgUrl = map['imageUrl']?.toString();

    if ((imgUrl == null || imgUrl.isEmpty) && map['photos'] is List) {
      final photos = map['photos'] as List;

      Map<String, dynamic>? mainPhoto;

      for (final photo in photos) {
        if (photo is Map && photo['isMain'] == true) {
          mainPhoto = Map<String, dynamic>.from(photo);
          break;
        }
      }

      if (mainPhoto == null && photos.isNotEmpty && photos.first is Map) {
        mainPhoto = Map<String, dynamic>.from(photos.first as Map);
      }

      if (mainPhoto != null && mainPhoto['path'] != null) {
        imgUrl = mainPhoto['path'].toString();
      }
    }

    return UserListItem(
      id: map['id']?.toString() ?? map['_id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unknown',
      imageUrl: imgUrl ?? 'assets/images/notification-image1.jpg',
      lastSeen: map['lastSeen']?.toString() ?? '',
      location: map['location']?.toString() ?? 'New York, USA',
      age: map['age'] is int
          ? map['age'] as int
          : int.tryParse(map['age']?.toString() ?? '') ?? 24,
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
    bool clearError = false,
  }) {
    return UserListState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class UserListNotifier extends Notifier<UserListState> {
  UserListNotifier(this.type);

  final String type;

  final ApiServices _api = ApiServices();

  @override
  UserListState build() {
    Future.microtask(fetchUsers);
    return const UserListState(isLoading: true);
  }

  Map<String, dynamic> _toMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return <String, dynamic>{};
  }

  List<UserListItem> _toUserItems(List<dynamic> data) {
    return data.map((item) => UserListItem.fromMap(_toMap(item))).toList();
  }

  UserListItem _validationRequestToUserItem(dynamic data) {
    final map = _toMap(data);
    final userRaw = map['userId'];

    final user = userRaw is Map ? Map<String, dynamic>.from(userRaw) : null;

    final photos = user?['photos'] is List ? user!['photos'] as List : null;

    Map<String, dynamic>? mainPhoto;

    if (photos != null) {
      for (final photo in photos) {
        if (photo is Map && photo['isMain'] == true) {
          mainPhoto = Map<String, dynamic>.from(photo);
          break;
        }
      }

      if (mainPhoto == null && photos.isNotEmpty && photos.first is Map) {
        mainPhoto = Map<String, dynamic>.from(photos.first as Map);
      }
    }

    return UserListItem(
      id: user?['_id']?.toString() ?? user?['id']?.toString() ?? '',
      name: user?['name']?.toString() ?? 'Unknown',
      imageUrl:
          mainPhoto?['path']?.toString() ?? 'assets/images/notification-image1.jpg',
      lastSeen: 'Pending Review',
      isOnline: false,
    );
  }

  Future<void> fetchUsers() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Unauthorized',
        );
        return;
      }

      if (type == 'online') {
        final usersData = await _api.getOnlineUsers(token: token);

        state = state.copyWith(
          isLoading: false,
          users: _toUserItems(List<dynamic>.from(usersData)),
          clearError: true,
        );
        return;
      }

      if (type == 'friends') {
        final usersData = await _api.getFriends(token: token);

        state = state.copyWith(
          isLoading: false,
          users: _toUserItems(List<dynamic>.from(usersData)),
          clearError: true,
        );
        return;
      }

      if (type == 'validation_requests') {
        final usersData = await _api.getPendingValidationRequests(token: token);

        state = state.copyWith(
          isLoading: false,
          users: List<dynamic>.from(usersData)
              .map(_validationRequestToUserItem)
              .toList(),
          clearError: true,
        );
        return;
      }

      if (type == 'favorites') {
        final usersData = await _api.getFavorites(token: token);

        state = state.copyWith(
          isLoading: false,
          users: _toUserItems(List<dynamic>.from(usersData)),
          clearError: true,
        );
        return;
      }

      if (type == 'likes') {
        final usersData = await _api.getLikes(token: token);

        state = state.copyWith(
          isLoading: false,
          users: _toUserItems(List<dynamic>.from(usersData)),
          clearError: true,
        );
        return;
      }

      if (type == 'blocklist') {
        final usersData = await _api.getBlocklist(token: token);

        state = state.copyWith(
          isLoading: false,
          users: _toUserItems(List<dynamic>.from(usersData)),
          clearError: true,
        );
        return;
      }

      if (type == 'viewed_me') {
        final usersData = await _api.getViewedMe(token: token);

        state = state.copyWith(
          isLoading: false,
          users: _toUserItems(List<dynamic>.from(usersData)),
          clearError: true,
        );
        return;
      }

      if (type == 'new_members' || type == 'new_member') {
        final usersData = await _api.getNewMembers(token: token);

        state = state.copyWith(
          isLoading: false,
          users: _toUserItems(List<dynamic>.from(usersData)),
          clearError: true,
        );
        return;
      }

      if (type == 'friend_requests') {
        final usersData = await _api.getFriendRequests(token: token);

        state = state.copyWith(
          isLoading: false,
          users: _toUserItems(List<dynamic>.from(usersData)),
          clearError: true,
        );
        return;
      }

      // MOCK for other types for now
      await Future.delayed(const Duration(milliseconds: 800));

      final mockData = <Map<String, dynamic>>[
        {
          'id': '1',
          'name': 'Sarah Connor',
          'imageUrl': 'assets/images/notification-image1.jpg',
          'lastSeen': '2 mins ago',
          'isOnline': true,
        },
        {
          'id': '2',
          'name': 'John Wick',
          'imageUrl': 'assets/images/notification-image4.jpg',
          'lastSeen': '1 hour ago',
        },
        {
          'id': '3',
          'name': 'Jane Doe',
          'imageUrl': 'assets/images/notification-image5.jpg',
          'lastSeen': 'Online',
          'isOnline': true,
        },
        {
          'id': '4',
          'name': 'Agent Smith',
          'imageUrl': 'assets/images/notification-image6.jpg',
          'lastSeen': 'Yesterday',
        },
      ];

      state = state.copyWith(
        isLoading: false,
        users: mockData.map(UserListItem.fromMap).toList(),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> removeUser(String id) async {
    final originalUsers = state.users;

    state = state.copyWith(
      users: state.users.where((u) => u.id != id).toList(),
    );

    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) return;

      if (type == 'friends') {
        await _api.removeFriend(token: token, friendId: id);
      } else {
        // Add other remove API calls here if needed.
        // await _api.removeFavorite(token: token, userId: id);
      }
    } catch (e) {
      state = state.copyWith(users: originalUsers);
    }
  }

  Future<void> reviewValidation(String userId, String status) async {
    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) return;

      await _api.reviewValidation(
        token: token,
        userId: userId,
        status: status,
      );

      state = state.copyWith(
        users: state.users.where((u) => u.id != userId).toList(),
      );
    } catch (e) {
      print('Review error: $e');
    }
  }

  Future<void> acceptFriendRequest(String requesterId) async {
    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) return;

      await _api.acceptFriendRequest(
        token: token,
        requesterId: requesterId,
      );

      state = state.copyWith(
        users: state.users.where((u) => u.id != requesterId).toList(),
      );
    } catch (e) {
      print('Accept friend request error: $e');
    }
  }

  Future<void> declineFriendRequest(String requesterId) async {
    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) return;

      await _api.declineFriendRequest(
        token: token,
        requesterId: requesterId,
      );

      state = state.copyWith(
        users: state.users.where((u) => u.id != requesterId).toList(),
      );
    } catch (e) {
      print('Decline friend request error: $e');
    }
  }

  Future<void> sayHi(String userId) async {
    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) return;

      await _api.sendHi(
        token: token,
        userId: userId,
      );
    } catch (e) {
      print('Say Hi error: $e');
      rethrow;
    }
  }

  Future<void> toggleFavorite(String userId) async {
    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) return;

      await _api.toggleFavorite(
        token: token,
        userId: userId,
      );

      if (type == 'favorites') {
        state = state.copyWith(
          users: state.users.where((u) => u.id != userId).toList(),
        );
      }
    } catch (e) {
      print('Toggle favorite error: $e');
      rethrow;
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      await fetchUsers();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Unauthorized',
        );
        return;
      }

      final results = await _api.searchUsers(
        token: token,
        query: query,
      );

      state = state.copyWith(
        isLoading: false,
        users: _toUserItems(List<dynamic>.from(results)),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addUser(UserListItem user) async {
    state = state.copyWith(
      users: [user, ...state.users],
    );

    // API logic here if needed.
  }
}

final userListProvider =
    NotifierProvider.autoDispose.family<UserListNotifier, UserListState, String>(
  UserListNotifier.new,
);