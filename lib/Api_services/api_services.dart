import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../content/card_data.dart';

class ApiServices {
  ApiServices({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _requestTimeout = Duration(seconds: 30);

  // For physical Android device use your laptop IP:
  // flutter run --dart-define=API_BASE_URL=http://192.168.x.x:5001
  static const String _defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // defaultValue: 'http://10.0.2.2:5001',
    // defaultValue: 'http://192.168.1.13:5001',
    // defaultValue: 'http://192.168.1.5:5001',
    defaultValue: 'http://192.168.1.36:5001',
  );

  static String get baseUrl => _defaultBaseUrl;
  // static const String _baseUrl = 'https://beatflirtevent.com';

  Uri _uri(String path) => Uri.parse('$_defaultBaseUrl$path');

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // final uri = _uri('/api/auth/login');
      final uri = Uri.parse('https://beatflirtevent.com/api/App/auth/login');
      final bodyData = {'email': email.trim(), 'password': password};
      _logRequest('POST', uri, body: bodyData);

      final response = await _client
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(bodyData),
          )
          .timeout(_requestTimeout);

      _logResponse(response);
      final body = _decodeJson(response.body);
      if (response.statusCode != 200) {
        throw Exception(body['message'] ?? 'Login failed');
      }
      return body;
    } on SocketException {
      throw Exception('No internet connection or server unreachable');
    } on TimeoutException {
      throw Exception('Server is taking too long to respond');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final uri = _uri('/api/auth/register');
    final bodyData = {
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
    };
    _logRequest('POST', uri, body: bodyData);

    final response = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Registration failed');
    }
    return body;
  }

  Future<Map<String, dynamic>> requestPasswordReset({
    required String email,
  }) async {
    final uri = _uri('/api/auth/forgot-password/request');
    final bodyData = {'email': email.trim()};
    _logRequest('POST', uri, body: bodyData);
    final response = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to request reset token');
    }
    return body;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    final uri = _uri('/api/auth/forgot-password/reset');
    final bodyData = {
      'email': email.trim(),
      'resetToken': resetToken.trim(),
      'newPassword': '***',
    };
    _logRequest('POST', uri, body: bodyData);
    final response = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'resetToken': resetToken.trim(),
        'newPassword': newPassword,
      }),
    );
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to update password');
    }
    return body;
  }

  // Future<Map<String, dynamic>> logout({required String token}) async {
  //   final uri = _uri('/api/auth/logout');
  //   _logRequest('POST', uri, headers: {'Authorization': 'Bearer $token'});
  //   final response = await _client
  //       .post(
  //         uri,
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
  //       )
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception(body['message'] ?? 'Logout failed');
  //   }
  //   return body;
  // }

  Future<Map<String, dynamic>> getProfile({required String token}) async {
    final uri = Uri.parse(
      'https://app.beatflirtevent.com/App/user/signle_user_profile',
    );
    final response = await _client
        .get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'access-token': token,
          },
        )
        .timeout(_requestTimeout);

    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to load profile');
    }
    return {'user': body['data']};
  }

  // Future<Map<String, dynamic>> updateProfile({
  //   required String token,
  //   required Map<String, dynamic> updates,
  // }) async {
  //   final uri = _uri('/api/users/profile/update');
  //   _logRequest('POST', uri, headers: {'Authorization': 'Bearer $token'}, body: updates);
  //   final response = await _client
  //       .post(
  //         uri,
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
  //         body: jsonEncode(updates),
  //       )
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception(body['message'] ?? 'Failed to update profile');
  //   }
  //   return body;
  // }

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final uri = _uri('/api/auth/change-password');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'oldPassword': '***', 'newPassword': '***'},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'oldPassword': oldPassword,
            'newPassword': newPassword,
          }),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to change password');
    }
    return body;
  }

  // Future<Map<String, dynamic>> deleteAccount({required String token}) async {
  //   final uri = _uri('/api/auth/delete-account');
  //   _logRequest('DELETE', uri, headers: {'Authorization': 'Bearer $token'});
  //   final response = await _client
  //       .delete(uri, headers: {'Authorization': 'Bearer $token'})
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception(body['message'] ?? 'Failed to delete account');
  //   }
  //   return body;
  // }

  // Future<List<Map<String, dynamic>>> getPhotos({required String token}) async {
  //   final uri = _uri('/api/auth/photos');
  //   _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
  //   final response = await _client
  //       .get(uri, headers: {'Authorization': 'Bearer $token'})
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception(body['message'] ?? 'Failed to fetch photos');
  //   }
  //   final photos = body['photos'];
  //   if (photos is List) {
  //     return photos.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  //   }
  //   return [];
  // }

  // Future<Map<String, dynamic>> addPhoto({
  //   required String token,
  //   required String path,
  //   String title = '',
  // }) async {
  //   final uri = _uri('/api/auth/photos');
  //   final bodyData = {'path': path, 'title': title, 'status': 'pending'};
  //   _logRequest('POST', uri, headers: {'Authorization': 'Bearer $token'}, body: bodyData);
  //   final response = await _client
  //       .post(
  //         uri,
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
  //         body: jsonEncode(bodyData),
  //       )
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 201) {
  //     throw Exception(body['message'] ?? 'Failed to add photo');
  //   }
  //   return body;
  // }

  // Future<void> deletePhoto({
  //   required String token,
  //   required String mediaId,
  // }) async {
  //   final uri = _uri('/api/auth/photos/$mediaId');
  //   _logRequest('DELETE', uri, headers: {'Authorization': 'Bearer $token'});
  //   final response = await _client
  //       .delete(uri, headers: {'Authorization': 'Bearer $token'})
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception(body['message'] ?? 'Failed to delete photo');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getVideos({required String token}) async {
  //   final uri = _uri('/api/auth/videos');
  //   _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
  //   final response = await _client
  //       .get(uri, headers: {'Authorization': 'Bearer $token'})
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception(body['message'] ?? 'Failed to fetch videos');
  //   }
  //   final videos = body['videos'];
  //   if (videos is List) {
  //     return videos.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  //   }
  //   return [];
  // }

  // Future<Map<String, dynamic>> addVideo({
  //   required String token,
  //   required String path,
  //   String thumbnailPath = '',
  // }) async {
  //   final uri = _uri('/api/auth/videos');
  //   final bodyData = {'path': path, 'thumbnailPath': thumbnailPath, 'status': 'pending'};
  //   _logRequest('POST', uri, headers: {'Authorization': 'Bearer $token'}, body: bodyData);
  //   final response = await _client
  //       .post(
  //         uri,
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
  //         body: jsonEncode(bodyData),
  //       )
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 201) {
  //     throw Exception(body['message'] ?? 'Failed to add video');
  //   }
  //   return body;
  // }

  // Future<void> deleteVideo({
  //   required String token,
  //   required String mediaId,
  // }) async {
  //   final uri = _uri('/api/auth/videos/$mediaId');
  //   _logRequest('DELETE', uri, headers: {'Authorization': 'Bearer $token'});
  //   final response = await _client
  //       .delete(uri, headers: {'Authorization': 'Bearer $token'})
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception(body['message'] ?? 'Failed to delete video');
  //   }
  // }

  // Future<Map<String, dynamic>> updatePrivacy({
  //   required String token,
  //   required Map<String, dynamic> privacy,
  // }) async {
  //   final uri = _uri('/api/auth/privacy');
  //   _logRequest('PUT', uri, headers: {'Authorization': 'Bearer $token'}, body: {'privacy': privacy});
  //   final response = await _client
  //       .put(
  //         uri,
  //         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
  //         body: jsonEncode({'privacy': privacy}),
  //       )
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200) {
  //     throw Exception(body['message'] ?? 'Failed to update privacy');
  //   }
  //   return body;
  // }

  // Future<List<CardData>> fetchCards({String? token}) async {
  //   final uri = _uri('/api/cards');
  //   _logRequest('GET', uri, headers: (token != null && token.isNotEmpty) ? {'Authorization': 'Bearer $token'} : {});
  //   final response = await _client
  //       .get(
  //         uri,
  //         headers: {
  //           if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  //         },
  //       )
  //       .timeout(_requestTimeout);
  //   _logResponse(response);
  //   final decoded = _decodeDynamic(response.body);
  //   if (response.statusCode != 200 || decoded is! List) {
  //     throw Exception('Failed to fetch cards');
  //   }
  //   return decoded.whereType<Map<String, dynamic>>().map(CardData.fromJson).toList();
  // }

  Future<List<Map<String, dynamic>>> getOnlineUsers({
    required String token,
  }) async {
    final uri = _uri('/api/users/online');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch online users');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getFavorites({
    required String token,
  }) async {
    final uri = _uri('/api/users/favorites');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getLikes({required String token}) async {
    final uri = _uri('/api/users/likes');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getBlocklist({
    required String token,
  }) async {
    final uri = _uri('/api/users/blocklist');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getViewedMe({
    required String token,
  }) async {
    final uri = _uri('/api/users/viewed-me');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getNewMembers({
    required String token,
  }) async {
    final uri = _uri('/api/users/new-members');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> sendMessage({
    required String token,
    required String receiverId,
    required String content,
  }) async {
    final uri = _uri('/api/messages/send');
    final bodyData = {'receiverId': receiverId, 'content': content};
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: bodyData,
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(bodyData),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Failed to send message');
    }
    return body;
  }

  Future<List<Map<String, dynamic>>> getMessages({
    required String token,
    required String userId,
  }) async {
    final uri = _uri('/api/messages/conversation/$userId');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch messages');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> submitValidation({
    required String token,
    required String selfiePath,
    required String idCardPath,
  }) async {
    final uri = _uri('/api/validation/submit');
    final bodyData = {'selfiePath': selfiePath, 'idCardPath': idCardPath};
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: bodyData,
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(bodyData),
        )
        .timeout(const Duration(seconds: 60));
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Failed to submit validation');
    }
    return body;
  }

  /// Uploads a profile photo file and returns the parsed JSON response.
  /// Expects the backend to accept a multipart file under field name 'photo'.
  // Future<Map<String, dynamic>> uploadProfilePhoto({
  //   required String token,
  //   required File file,
  // }) async {
  //   final uri = _uri('/api/users/profile/photo');
  //   _logRequest('POST', uri, headers: {'Authorization': 'Bearer $token'}, body: {'file': file.path});

  //   final request = http.MultipartRequest('POST', uri);
  //   request.headers['Authorization'] = 'Bearer $token';
  //   try {
  //     final multipartFile = await http.MultipartFile.fromPath('photo', file.path);
  //     request.files.add(multipartFile);
  //   } catch (e) {
  //     throw Exception('Failed to read file for upload: $e');
  //   }

  //   final streamed = await _client.send(request).timeout(const Duration(seconds: 60));
  //   final response = await http.Response.fromStream(streamed);
  //   _logResponse(response);
  //   final body = _decodeJson(response.body);
  //   if (response.statusCode != 200 && response.statusCode != 201) {
  //     throw Exception(body['message'] ?? 'Failed to upload profile photo');
  //   }
  //   return body;
  // }

  Future<Map<String, dynamic>> getValidationStatus({
    required String token,
  }) async {
    final uri = _uri('/api/validation/status');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to check validation status');
    }
    return body;
  }

  Future<List<Map<String, dynamic>>> getPendingValidationRequests({
    required String token,
  }) async {
    final uri = _uri('/api/validation/pending');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch validation requests');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> reviewValidation({
    required String token,
    required String userId,
    required String status,
    String? reason,
  }) async {
    final uri = _uri('/api/validation/review');
    final bodyData = {'userId': userId, 'status': status, 'reason': reason};
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: bodyData,
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(bodyData),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to review validation');
    }
    return body;
  }

  Future<List<Map<String, dynamic>>> getNotifications({
    required String token,
  }) async {
    final uri = _uri('/api/notifications');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch notifications');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> markNotificationRead({
    required String token,
    required String notificationId,
  }) async {
    final uri = _uri('/api/notifications/read/$notificationId');
    _logRequest('PUT', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .put(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<void> clearNotifications({required String token}) async {
    final uri = _uri('/api/notifications/clear');
    _logRequest('DELETE', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .delete(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      throw Exception('Failed to clear notifications');
    }
  }

  Future<List<Map<String, dynamic>>> getChatrooms({
    required String token,
  }) async {
    final uri = _uri('/api/chatrooms');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch chatrooms');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> createChatroom({
    required String token,
    required String name,
    required String category,
    String description = '',
    bool isPrivate = false,
  }) async {
    final uri = _uri('/api/chatrooms');
    final bodyData = {
      'name': name,
      'category': category,
      'description': description,
      'isPrivate': isPrivate,
    };
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: bodyData,
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(bodyData),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Failed to create chatroom');
    }
    return body;
  }

  Future<Map<String, dynamic>> joinChatroomByCode({
    required String token,
    required String code,
  }) async {
    final uri = _uri('/api/chatrooms/join');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'joinCode': code},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'joinCode': code}),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to join chatroom');
    }
    return body;
  }

  // --- Friends ---
  Future<List<dynamic>> getFriends({required String token}) async {
    final uri = _uri('/api/users/friends');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      throw Exception(
        _decodeJson(response.body)['message'] ?? 'Failed to fetch friends',
      );
    }
    final decoded = _decodeDynamic(response.body);
    if (decoded is List) return decoded;
    return [];
  }

  Future<void> removeFriend({
    required String token,
    required String friendId,
  }) async {
    final uri = _uri('/api/users/friends/remove');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'friendId': friendId},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'friendId': friendId}),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      throw Exception(
        _decodeJson(response.body)['message'] ?? 'Failed to remove friend',
      );
    }
  }

  Future<List<dynamic>> getFriendRequests({required String token}) async {
    final uri = _uri('/api/users/friend-requests');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      throw Exception(
        _decodeJson(response.body)['message'] ??
            'Failed to fetch friend requests',
      );
    }
    final decoded = _decodeDynamic(response.body);
    if (decoded is List) return decoded;
    return [];
  }

  Future<void> acceptFriendRequest({
    required String token,
    required String requesterId,
  }) async {
    final uri = _uri('/api/users/friend-requests/accept');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'requesterId': requesterId},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'requesterId': requesterId}),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      final decoded = _decodeJson(response.body);
      throw Exception(
        decoded['error'] ??
            decoded['message'] ??
            'Failed to accept friend request',
      );
    }
  }

  Future<void> declineFriendRequest({
    required String token,
    required String requesterId,
  }) async {
    final uri = _uri('/api/users/friend-requests/decline');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'requesterId': requesterId},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'requesterId': requesterId}),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      final decoded = _decodeJson(response.body);
      throw Exception(
        decoded['error'] ??
            decoded['message'] ??
            'Failed to decline friend request',
      );
    }
  }

  // --- Speed Date Sessions ---
  Future<List<Map<String, dynamic>>> getSpeedDateSessions({
    required String token,
  }) async {
    final uri = _uri('/api/speed-date/sessions');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch speed date sessions');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> joinSpeedDateSession({
    required String token,
    required String sessionId,
  }) async {
    final uri = _uri('/api/speed-date/join');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'sessionId': sessionId},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'sessionId': sessionId}),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to join session');
    }
    return body;
  }

  Future<Map<String, dynamic>> startSpeedMatch({required String token}) async {
    final uri = _uri('/api/speed-date/start');
    _logRequest('POST', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to start speed match');
    }
    return body;
  }

  // --- Events & Parties ---
  Future<List<Map<String, dynamic>>> getEvents({required String token}) async {
    final uri = _uri('/api/events');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch events');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> getFeaturedEvent({required String token}) async {
    final uri = _uri('/api/events/featured');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to fetch featured event');
    }
    return body;
  }

  Future<Map<String, dynamic>> rsvpEvent({
    required String token,
    required String eventId,
  }) async {
    final uri = _uri('/api/events/rsvp');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'eventId': eventId},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'eventId': eventId}),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to RSVP to event');
    }
    return body;
  }

  // --- Profile Interactions ---
  Future<void> sendHi({required String token, required String userId}) async {
    final uri = _uri('/api/users/say-hi');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'userId': userId},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'userId': userId}),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      final body = _decodeJson(response.body);
      throw Exception(body['message'] ?? 'Failed to send Hi');
    }
  }

  Future<void> toggleFavorite({
    required String token,
    required String userId,
  }) async {
    final uri = _uri('/api/users/favorites/toggle');
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'userId': userId},
    );
    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'userId': userId}),
        )
        .timeout(_requestTimeout);
    _logResponse(response);
    if (response.statusCode != 200) {
      final body = _decodeJson(response.body);
      throw Exception(body['message'] ?? 'Failed to toggle favorite');
    }
  }

  Future<Map<String, dynamic>> getOtherUserProfile({
    required String token,
    required String userId,
  }) async {
    final uri = _uri('/api/users/profile/$userId');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);
    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to load user profile');
    }
    return body;
  }

  Map<String, dynamic> _decodeJson(String body) {
    final decoded = _decodeDynamic(body);
    if (decoded is Map<String, dynamic>) return decoded;
    return {};
  }

  dynamic _decodeDynamic(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  // --- LOGGING HELPERS ---
  void _logRequest(
    String method,
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    print('------------------------------------------------------------');
    print('🚀 [API REQUEST] $method ${uri.path}');
    print('📍 URL: $uri');
    if (headers != null && headers.isNotEmpty) {
      print('🔑 HEADERS: ${jsonEncode(headers)}');
    }
    if (body != null) {
      print('📦 BODY: ${body is String ? body : jsonEncode(body)}');
    }
  }

  void _logResponse(http.Response response) {
    final status = response.statusCode;
    final emoji = (status >= 200 && status < 300) ? '✅' : '❌';
    print(
      '$emoji [API RESPONSE] ${response.request?.method} ${response.request?.url.path}',
    );
    print('📊 STATUS: $status');
    print('📝 BODY: ${response.body}');
    print('------------------------------------------------------------');
  }

  Future<List<Map<String, dynamic>>> getChatroomMessages({
    required String token,
    required String roomId,
  }) async {
    final uri = _uri('/api/chatrooms/$roomId/messages');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});

    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);

    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch chatroom messages');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> sendChatroomMessage({
    required String token,
    required String roomId,
    String? text,
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    final uri = _uri('/api/chatrooms/$roomId/messages');
    final bodyData = {
      'text': text,
      'attachmentUrl': attachmentUrl,
      'attachmentType': attachmentType,
    };
    _logRequest(
      'POST',
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: bodyData,
    );

    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(bodyData),
        )
        .timeout(_requestTimeout);

    _logResponse(response);
    final body = _decodeJson(response.body);
    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Failed to send chatroom message');
    }
    return body;
  }

  Future<List<Map<String, dynamic>>> searchUsers({
    required String token,
    required String query,
  }) async {
    final uri = _uri('/api/users/search?query=$query');
    _logRequest('GET', uri, headers: {'Authorization': 'Bearer $token'});

    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);

    _logResponse(response);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to search users');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> deleteChatroomMessage({
    required String token,
    required String roomId,
    required String messageId,
  }) async {
    final uri = _uri('/api/chatrooms/$roomId/messages/$messageId');
    _logRequest('DELETE', uri, headers: {'Authorization': 'Bearer $token'});

    final response = await _client
        .delete(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_requestTimeout);

    _logResponse(response);
    if (response.statusCode != 200) {
      final body = _decodeJson(response.body);
      throw Exception(body['message'] ?? 'Failed to delete message');
    }
  }
}
