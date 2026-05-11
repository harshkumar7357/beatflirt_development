import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../content/card_data.dart';

class ApiServices {
  ApiServices({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _requestTimeout = Duration(seconds: 15);

  // For physical Android device use your laptop IP:
  // flutter run --dart-define=API_BASE_URL=http://192.168.x.x:5001
  static const String _defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // defaultValue: 'http://10.0.2.2:5001',
    defaultValue: 'http://192.168.1.13:5001'
  );

  Uri _uri(String path) => Uri.parse('$_defaultBaseUrl$path');

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            _uri('/api/auth/login'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email.trim(), 'password': password}),
          )
          .timeout(_requestTimeout);
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
    final response = await _client.post(
      _uri('/api/auth/register'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      }),
    );
    final body = _decodeJson(response.body);
    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Registration failed');
    }
    return body;
  }

  Future<Map<String, dynamic>> requestPasswordReset({
    required String email,
  }) async {
    final response = await _client.post(
      _uri('/api/auth/forgot-password/request'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim()}),
    );
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
    final response = await _client.post(
      _uri('/api/auth/forgot-password/reset'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'resetToken': resetToken.trim(),
        'newPassword': newPassword,
      }),
    );
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to update password');
    }
    return body;
  }

  Future<Map<String, dynamic>> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Logout failed');
    }
    return body;
  }

  Future<Map<String, dynamic>> getProfile({required String token}) async {
    final response = await _client.get(
      _uri('/api/auth/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to load profile');
    }
    return body;
  }

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await _client.post(
      _uri('/api/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to change password');
    }
    return body;
  }

  Future<Map<String, dynamic>> deleteAccount({required String token}) async {
    final response = await _client.delete(
      _uri('/api/auth/delete-account'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to delete account');
    }
    return body;
  }

  Future<List<Map<String, dynamic>>> getPhotos({required String token}) async {
    final response = await _client.get(
      _uri('/api/auth/photos'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to fetch photos');
    }
    final photos = body['photos'];
    if (photos is List) {
      return photos.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> addPhoto({
    required String token,
    required String path,
    String title = '',
  }) async {
    final response = await _client.post(
      _uri('/api/auth/photos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'path': path, 'title': title, 'status': 'pending'}),
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Failed to add photo');
    }
    return body;
  }

  Future<void> deletePhoto({
    required String token,
    required String mediaId,
  }) async {
    final response = await _client.delete(
      _uri('/api/auth/photos/$mediaId'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to delete photo');
    }
  }

  Future<List<Map<String, dynamic>>> getVideos({required String token}) async {
    final response = await _client.get(
      _uri('/api/auth/videos'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to fetch videos');
    }
    final videos = body['videos'];
    if (videos is List) {
      return videos.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> addVideo({
    required String token,
    required String path,
    String thumbnailPath = '',
  }) async {
    final response = await _client.post(
      _uri('/api/auth/videos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'path': path,
        'thumbnailPath': thumbnailPath,
        'status': 'pending',
      }),
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Failed to add video');
    }
    return body;
  }

  Future<void> deleteVideo({
    required String token,
    required String mediaId,
  }) async {
    final response = await _client.delete(
      _uri('/api/auth/videos/$mediaId'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to delete video');
    }
  }

  Future<Map<String, dynamic>> updatePrivacy({
    required String token,
    required Map<String, dynamic> privacy,
  }) async {
    final response = await _client.put(
      _uri('/api/auth/privacy'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'privacy': privacy}),
    ).timeout(_requestTimeout);
    final body = _decodeJson(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to update privacy');
    }
    return body;
  }

  Future<List<CardData>> fetchCards({String? token}) async {
    final response = await _client.get(
      _uri('/api/cards'),
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ).timeout(_requestTimeout);
    final decoded = _decodeDynamic(response.body);
    if (response.statusCode != 200 || decoded is! List) {
      throw Exception('Failed to fetch cards');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(CardData.fromJson)
        .toList();
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
}


