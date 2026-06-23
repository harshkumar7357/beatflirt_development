

import 'dart:convert';
import 'dart:io';
import 'package:beatflirt/Api_services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Native Imports from BeatFlirt project structure
import 'package:beatflirt/core/services/token_services.dart';

// ==========================================
// 1. DATA MODELS
// ==========================================

class AlbumModel {
  final String id;
  final String albumName;
  final String albumPassword;
  final String image;
  final String status; // "1" for Approved, otherwise Pending

  AlbumModel({
    required this.id,
    required this.albumName,
    required this.albumPassword,
    required this.image,
    required this.status,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id']?.toString() ?? '',
      albumName: json['album_name']?.toString() ?? '',
      albumPassword: json['album_password']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      status: json['status']?.toString() ?? '1',
    );
  }
}

class AlbumImageModel {
  final String id;
  final String albumId;
  final String image;

  AlbumImageModel({
    required this.id,
    required this.albumId,
    required this.image,
  });

  factory AlbumImageModel.fromJson(Map<String, dynamic> json) {
    return AlbumImageModel(
      id: json['id']?.toString() ?? '',
      albumId: json['album_id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class AlbumDetailsModel {
  final String id;
  final String albumName;
  final String albumPassword;

  AlbumDetailsModel({
    required this.id,
    required this.albumName,
    required this.albumPassword,
  });

  factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
    return AlbumDetailsModel(
      id: json['id']?.toString() ?? '',
      albumName: json['album_name']?.toString() ?? '',
      albumPassword: json['album_password']?.toString() ?? '',
    );
  }
}

// ==========================================
// 2. NATIVE-INTEGRATED ALBUM SERVICE (WITH TRIPLE-SAFEGUARDS)
// ==========================================

class AlbumService {
  static const String baseUrl = 'https://app.beatflirtevent.com/App';
  final TokenService _tokenService = TokenService();

  // Bulletproof token retriever (inspects TokenService & scans SharedPreferences fallback)
  Future<String?> _getToken() async {
    // 1. Try native TokenService first
    try {
      final token = await _tokenService.getAccessToken();
      if (token != null && token.trim().isNotEmpty) {
        debugPrint('🔑 [AlbumService] Active token from TokenService: $token');
        return token;
      }
    } catch (e) {
      debugPrint('⚠️ [AlbumService] TokenService lookup error: $e');
    }

    // 2. Fallback: Automatically search SharedPreferences for any token key
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      debugPrint('ℹ️ [AlbumService] SharedPreferences active keys list: $keys');

      for (final key in keys) {
        if (key.toLowerCase().contains('token')) {
          final val = prefs.get(key);
          if (val is String && val.trim().isNotEmpty) {
            debugPrint(
              '🔑 [AlbumService] Fallback token found in SharedPreferences [$key]: $val',
            );
            return val;
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ [AlbumService] SharedPreferences lookup error: $e');
    }

    debugPrint(
      '❌ [AlbumService] Could not find any active authentication token!',
    );
    return null;
  }

  // Generates complete authorization header payload with custom tokens, signs, and session cookies
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();

    // Core standard JSON headers
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
      h['access-token'] = token;
      h['Access-Token'] = token;
      h['token'] = token;
      h['Token'] = token;
    }

    // Capture Native cryptographic access-sign if available
    try {
      final sign = await _tokenService.getAccessSign();
      if (sign != null && sign.isNotEmpty) {
        h['Access-Sign'] = sign;
        h['access-sign'] = sign;
      }
    } catch (e) {
      debugPrint('⚠️ [AlbumService] AccessSign retrieval error: $e');
    }

    // Merge in ApiService Cookies / session data
    try {
      final nativeHeaders = ApiService.buildAuthHeaders(token: token);
      if (nativeHeaders.containsKey('Cookie')) {
        h['Cookie'] = nativeHeaders['Cookie']!;
      }
    } catch (e) {
      debugPrint('⚠️ [AlbumService] ApiService Cookie building error: $e');
    }

    debugPrint('➡️ [AlbumService Headers] Outgoing payload headers: $h');
    return h;
  }

  // 1. Get all albums (GET)
  Future<List<AlbumModel>> getAllAlbums() async {
    final url = '$baseUrl/user/get_all_album';
    debugPrint('➡️ [AlbumService GET] URL: $url');
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint(
        '⬅️ [AlbumService GET] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((item) => AlbumModel.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('❌ [AlbumService GET] Exception: $e');
    }
    return [];
  }

  // 2. Get all approved album images (GET)
  Future<List<String>> getAllApprovedAlbumImages() async {
    final url = '$baseUrl/user/get_all_approve_album_image';
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint(
        '⬅️ [AlbumService Approved Images] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((e) => e['image'].toString())
              .toList();
        }
      }
    } catch (e) {
      debugPrint('❌ [AlbumService GET] Exception: $e');
    }
    return [];
  }

  // 3. Get all pending album images (GET)
  Future<List<String>> getAllPendingAlbumImages() async {
    final url = '$baseUrl/user/get_all_pending_album_image';
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint(
        '⬅️ [AlbumService Pending Images] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((e) => e['image'].toString())
              .toList();
        }
      }
    } catch (e) {
      debugPrint('❌ [AlbumService GET] Exception: $e');
    }
    return [];
  }

  // Get pending album images for a specific album (GET filtered)
  Future<List<AlbumImageModel>> getPendingAlbumImages(String albumId) async {
    final url = '$baseUrl/user/get_all_pending_album_image';
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint(
        '⬅️ [AlbumService Pending Images] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((item) => AlbumImageModel.fromJson(item))
              .where((item) => item.albumId == albumId)
              .toList();
        }
      }
    } catch (e) {
      debugPrint('❌ [AlbumService GET Pending] Exception: $e');
    }
    return [];
  }

  // 4 & View. Get album images for a specific album (POST - JSON payload)
  Future<List<AlbumImageModel>> getAlbumImages(String albumId) async {
    final url = '$baseUrl/user/get_album_image';
    final payload = {'album_id': albumId};
    debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      debugPrint(
        '⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((item) => AlbumImageModel.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('❌ [AlbumService POST] Exception: $e');
    }
    return [];
  }

  // 5. Create profile album (POST - JSON payload)
  Future<bool> createProfileAlbum(String name, String password) async {
    final url = '$baseUrl/user/create_profile_album';
    final payload = {'album_name': name, 'album_password': password};
    debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      debugPrint(
        '⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['status'] == '200';
      }
    } catch (e) {
      debugPrint('❌ [AlbumService POST] Exception: $e');
    }
    return false;
  }

  // Popup Action 1: Upload image base64 (POST - JSON payload)
  Future<String?> uploadImageMultiple(String base64Image) async {
    final url = '$baseUrl/upload/imageuploadMultiple';
    final payload = {
      'image': [
        {'image': base64Image},
      ],
    };
    debugPrint(
      '➡️ [AlbumService JSON POST] URL: $url | Payload snippet: ${jsonEncode(payload).substring(0, 100)}...',
    );
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      debugPrint(
        '⬅️ [AlbumService JSON POST] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' &&
            decoded['data'] is List &&
            decoded['data'].isNotEmpty) {
          return decoded['data'][0]['image_name']?.toString();
        }
      }
    } catch (e) {
      debugPrint('❌ [AlbumService JSON POST] Exception: $e');
    }
    return null;
  }

  // Popup Action 2: Link image to album (POST - JSON payload)
  Future<bool> linkImageToAlbum(String imageName, String albumId) async {
    final url = '$baseUrl/user/single_user_mutiple_album_image';
    final payload = {'image': imageName, 'album_id': albumId};
    debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      debugPrint(
        '⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['status'] == '200';
      }
    } catch (e) {
      debugPrint('❌ [AlbumService POST] Exception: $e');
    }
    return false;
  }

  // Popup Action 3: Get album details (POST - JSON payload)
  Future<AlbumDetailsModel?> getAlbumDetails(String albumId) async {
    final url = '$baseUrl/user/get_album_details';
    final payload = {'album_id': albumId};
    debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      debugPrint(
        '⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' && decoded['data'] != null) {
          return AlbumDetailsModel.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      debugPrint('❌ [AlbumService POST] Exception: $e');
    }
    return null;
  }

  // Popup Action 4: Upload video binary (POST - multipart)
  Future<String?> uploadVideo(File videoFile) async {
    final url = '$baseUrl/upload/video_upload';
    debugPrint('➡️ [AlbumService MULTIPART POST] URL: $url');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      final headers = await _getHeaders();
      headers.forEach((key, val) => request.headers[key] = val);
      request.files.add(
        await http.MultipartFile.fromPath('video', videoFile.path),
      );
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint(
        '⬅️ [AlbumService MULTIPART POST] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' && decoded['data'] != null) {
          return decoded['data']['file_name']?.toString();
        }
      }
    } catch (e) {
      debugPrint('❌ [AlbumService MULTIPART POST] Exception: $e');
    }
    return null;
  }

  // Popup Action 5: Update profile album (POST - JSON payload)
  Future<bool> updateProfileAlbum(
    String albumId,
    String name,
    String password,
  ) async {
    final url = '$baseUrl/user/update_profile_album';
    final payload = {
      'album_id': albumId,
      'album_name': name,
      'album_password': password,
    };
    debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      debugPrint(
        '⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['status'] == '200';
      }
    } catch (e) {
      debugPrint('❌ [AlbumService POST] Exception: $e');
    }
    return false;
  }

  // 6. Delete album (POST - JSON payload)
  Future<bool> deleteAlbum(String albumId) async {
    final url = '$baseUrl/user/delete_album';
    final payload = {'album_id': albumId};
    debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      debugPrint(
        '⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}',
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['status'] == '200';
      }
    } catch (e) {
      debugPrint('❌ [AlbumService POST] Exception: $e');
    }
    return false;
  }
}

// ==========================================
// 2B. ALBUM API SERVICE (beatflirtevent.com)
// ==========================================

class AlbumApiService {
  static const String baseUrl = 'https://app.beatflirtevent.com/App';
  final TokenService _tokenService = TokenService();

  Future<String?> uploadImageMultiple(String base64Image) async {
    final url = '$baseUrl/upload/imageuploadMultiple';
    final payload = {
      'image': [
        {'image': base64Image},
      ],
    };
    print('[AlbumApiService] POST base64 → $url');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      print('[AlbumApiService] POST base64 ← status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' &&
            decoded['data'] is List &&
            decoded['data'].isNotEmpty) {
          return decoded['data'][0]['image_name']?.toString();
        }
      }
    } catch (e) {
      print('[AlbumApiService] POST base64 ✖ error: $e');
    }
    return null;
  }

  Future<bool> linkImageToAlbum(String imageName, String albumId) async {
    final res = await singleUserMutipleAlbumImage(imageName, albumId);
    return res['status']?.toString() == '200';
  }

  Future<String?> uploadVideo(File videoFile) async {
    final res = await videoUpload(videoFile);
    if (res['status']?.toString() == '200' && res['data'] != null) {
      return res['data']['file_name']?.toString();
    }
    return null;
  }

  Future<List<AlbumImageModel>> getAlbumImages(String albumId) async {
    final res = await getAlbumImage(albumId);
    if (res['status']?.toString() == '200' && res['data'] is List) {
      return (res['data'] as List).map((item) => AlbumImageModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<List<AlbumImageModel>> getPendingAlbumImages(String albumId) async {
    final res = await getAllPendingAlbumImage();
    if (res['status']?.toString() == '200' && res['data'] is List) {
      return (res['data'] as List)
          .map((item) => AlbumImageModel.fromJson(item))
          .where((item) => item.albumId == albumId)
          .toList();
    }
    return [];
  }

  Future<AlbumDetailsModel?> getAlbumDetailsModel(String albumId) async {
    final url = '$baseUrl/user/get_album_details';
    print('[AlbumApiService] POST Details → $url');
    try {
      final headers = await _getHeaders();
      final body = {'album_id': albumId};
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      print('[AlbumApiService] POST Details ← status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == '200' && decoded['data'] != null) {
          return AlbumDetailsModel.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      print('[AlbumApiService] POST Details ✖ error: $e');
    }
    return null;
  }

  Future<String?> _getToken() async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token != null && token.trim().isNotEmpty) return token;
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in prefs.getKeys()) {
        if (key.toLowerCase().contains('token')) {
          final val = prefs.get(key);
          if (val is String && val.trim().isNotEmpty) return val;
        }
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
      h['access-token'] = token;
      h['Access-Token'] = token;
    }
    try {
      final sign = await _tokenService.getAccessSign();
      if (sign != null && sign.isNotEmpty) {
        h['Access-Sign'] = sign;
        h['access-sign'] = sign;
      }
    } catch (_) {}
    try {
      final nativeHeaders = ApiService.buildAuthHeaders(token: token);
      if (nativeHeaders.containsKey('Cookie')) {
        h['Cookie'] = nativeHeaders['Cookie']!;
      }
    } catch (_) {}
    return h;
  }

  // 1. GET ALL ALBUMS
  Future<Map<String, dynamic>> getAllAlbum() async {
    final url = '$baseUrl/user/get_all_album';
    print('[AlbumApiService] GET → $url');
    try {
      final headers = await _getHeaders();
      final res = await http.get(Uri.parse(url), headers: headers);
      print('[AlbumApiService] GET ← status: ${res.statusCode}');
      print('[AlbumApiService] GET ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'data': decoded};
    } catch (e) {
      print('[AlbumApiService] GET ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 2. GET ALL PENDING ALBUM IMAGES
  Future<Map<String, dynamic>> getAllPendingAlbumImage() async {
    final url = '$baseUrl/user/get_all_pending_album_image';
    print('[AlbumApiService] GET → $url');
    try {
      final headers = await _getHeaders();
      final res = await http.get(Uri.parse(url), headers: headers);
      print('[AlbumApiService] GET ← status: ${res.statusCode}');
      print('[AlbumApiService] GET ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'data': decoded};
    } catch (e) {
      print('[AlbumApiService] GET ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 3. GET ALL APPROVED ALBUM IMAGES
  Future<Map<String, dynamic>> getAllApproveAlbumImage() async {
    final url = '$baseUrl/user/get_all_approve_album_image';
    print('[AlbumApiService] GET → $url');
    try {
      final headers = await _getHeaders();
      final res = await http.get(Uri.parse(url), headers: headers);
      print('[AlbumApiService] GET ← status: ${res.statusCode}');
      print('[AlbumApiService] GET ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'data': decoded};
    } catch (e) {
      print('[AlbumApiService] GET ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 4. GET ALBUM DETAILS
  Future<Map<String, dynamic>> getAlbumDetails(String albumId) async {
    final url = '$baseUrl/user/get_album_details';
    print('[AlbumApiService] POST → $url');
    try {
      final headers = await _getHeaders();
      final body = {'album_id': albumId};
      final res = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'data': decoded};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 5. CREATE PROFILE ALBUM
  Future<Map<String, dynamic>> createProfileAlbum(String albumName, String albumPassword) async {
    final url = '$baseUrl/user/create_profile_album';
    print('[AlbumApiService] POST → $url');
    try {
      final headers = await _getHeaders();
      final body = {'album_name': albumName, 'album_password': albumPassword};
      final res = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'message': res.body};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 6. UPDATE PROFILE ALBUM
  Future<Map<String, dynamic>> updateProfileAlbum(String albumName, String albumPassword, String albumId) async {
    final url = '$baseUrl/user/update_profile_album';
    print('[AlbumApiService] POST → $url');
    try {
      final headers = await _getHeaders();
      final body = {'album_name': albumName, 'album_password': albumPassword, 'album_id': albumId};
      final res = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'message': res.body};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 7. DELETE ALBUM
  Future<Map<String, dynamic>> deleteAlbum(String albumId) async {
    final url = '$baseUrl/user/delete_album';
    print('[AlbumApiService] POST → $url');
    try {
      final headers = await _getHeaders();
      final body = {'album_id': albumId};
      final res = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'message': res.body};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 8. GET ALBUM IMAGES
  Future<Map<String, dynamic>> getAlbumImage(String albumId) async {
    final url = '$baseUrl/user/get_album_image';
    print('[AlbumApiService] POST → $url');
    try {
      final headers = await _getHeaders();
      final body = {'album_id': albumId};
      final res = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'data': decoded};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 9. SAVE MULTIPLE IMAGES TO ALBUM
  Future<Map<String, dynamic>> singleUserMutipleAlbumImage(String image, String albumId) async {
    final url = '$baseUrl/user/single_user_mutiple_album_image';
    print('[AlbumApiService] POST → $url');
    try {
      final headers = await _getHeaders();
      final body = {'image': image, 'album_id': albumId};
      final res = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'message': res.body};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // 10. UPLOAD PROFILE ALBUM VIDEO
  Future<Map<String, dynamic>> uploadProfileAlbumVideo(String video, String albumId) async {
    final url = '$baseUrl/user/upload_profile_album_video';
    print('[AlbumApiService] POST → $url');
    try {
      final headers = await _getHeaders();
      final body = {'video': video, 'album_id': albumId};
      final res = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'message': res.body};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // BONUS: IMAGE UPLOAD (2-step)
  Future<Map<String, dynamic>> imageUploadMultiple(List<File> images) async {
    final url = '$baseUrl/upload/imageuploadMultiple';
    print('[AlbumApiService] POST → $url');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      final headers = await _getHeaders();
      headers.forEach((key, val) => request.headers[key] = val);
      for (final image in images) {
        request.files.add(await http.MultipartFile.fromPath('image[]', image.path));
      }
      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'data': decoded};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }

  // BONUS: VIDEO UPLOAD (2-step)
  Future<Map<String, dynamic>> videoUpload(File videoFile) async {
    final url = '$baseUrl/upload/video_upload';
    print('[AlbumApiService] POST → $url');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      final headers = await _getHeaders();
      headers.forEach((key, val) => request.headers[key] = val);
      request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));
      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      print('[AlbumApiService] POST ← status: ${res.statusCode}');
      print('[AlbumApiService] POST ← body: ${res.body}');
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : {'status': res.statusCode, 'data': decoded};
    } catch (e) {
      print('[AlbumApiService] POST ✖ error: $e');
      return {'status': 500, 'message': e.toString()};
    }
  }
}

// // ==========================================
// // 3. RIVERPOD PROVIDERS
// // ==========================================

// final albumServiceProvider = Provider<AlbumService>((ref) => AlbumService());

// // State provider for active toggles (true = Approved, false = Pending)
// final albumTabProvider = StateProvider<bool>((ref) => true);

// class AlbumsNotifier extends StateNotifier<AsyncValue<List<AlbumModel>>> {
//   final AlbumService _service;

//   AlbumsNotifier(this._service) : super(const AsyncValue.loading()) {
//     fetchAlbums();
//   }

//   Future<void> fetchAlbums() async {
//     state = const AsyncValue.loading();
//     try {
//       final list = await _service.getAllAlbums();
//       state = AsyncValue.data(list);
//     } catch (e, stack) {
//       state = AsyncValue.error(e, stack);
//     }
//   }

//   Future<bool> createAlbum(String name, String password) async {
//     try {
//       final success = await _service.createProfileAlbum(name, password);
//       if (success) {
//         await fetchAlbums();
//       }
//       return success;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> updateAlbum(String id, String name, String password) async {
//     try {
//       final success = await _service.updateProfileAlbum(id, name, password);
//       if (success) {
//         await fetchAlbums();
//       }
//       return success;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> deleteAlbum(String id) async {
//     try {
//       final success = await _service.deleteAlbum(id);
//       if (success) {
//         await fetchAlbums();
//       }
//       return success;
//     } catch (e) {
//       return false;
//     }
//   }
// }

// final albumsProvider = StateNotifierProvider<AlbumsNotifier, AsyncValue<List<AlbumModel>>>((ref) {
//   return AlbumsNotifier(ref.watch(albumServiceProvider));
// });

// final approvedAlbumsProvider = Provider<List<AlbumModel>>((ref) {
//   final state = ref.watch(albumsProvider);
//   return state.maybeWhen(
//     data: (list) => list.where((album) => album.status == '1').toList(),
//     orElse: () => [],
//   );
// });

// final pendingAlbumsProvider = Provider<List<AlbumModel>>((ref) {
//   final state = ref.watch(albumsProvider);
//   return state.maybeWhen(
//     data: (list) => list.where((album) => album.status != '1').toList(),
//     orElse: () => [],
//   );
// });

// ==========================================
// 3. RIVERPOD PROVIDERS
// ==========================================

final albumServiceProvider = Provider<AlbumApiService>((ref) {
  return AlbumApiService();
});

// State provider replacement for Riverpod 3
// true = Approved, false = Pending
class AlbumTabNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void setShowApproved(bool value) {
    state = value;
  }
}

final albumTabProvider = NotifierProvider<AlbumTabNotifier, bool>(
  AlbumTabNotifier.new,
);

class SelectedAlbumNotifier extends Notifier<AlbumModel?> {
  @override
  AlbumModel? build() {
    return null;
  }

  void select(AlbumModel? album) {
    state = album;
  }
}

final selectedAlbumProvider =
    NotifierProvider<SelectedAlbumNotifier, AlbumModel?>(
      SelectedAlbumNotifier.new,
    );

class AlbumsNotifier extends AsyncNotifier<List<AlbumModel>> {
  AlbumApiService get _service => ref.read(albumServiceProvider);

  @override
  Future<List<AlbumModel>> build() async {
    return _fetchAllFromApi();
  }

  Future<void> fetchAlbums() async {
    state = const AsyncValue.loading();
    try {
      final list = await _fetchAllFromApi();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<List<AlbumModel>> _fetchAllFromApi() async {
    final res = await _service.getAllAlbum();
    if (res['status']?.toString() == '200' && res['data'] is List) {
      return (res['data'] as List)
          .map((item) => AlbumModel.fromJson(item))
          .toList();
    }
    return [];
  }

  Future<bool> createAlbum(String name, String password) async {
    try {
      final res = await _service.createProfileAlbum(name, password);
      final success = res['status']?.toString() == '200';
      if (success) {
        await fetchAlbums();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAlbum(String id, String name, String password) async {
    try {
      final res = await _service.updateProfileAlbum(name, password, id);
      final success = res['status']?.toString() == '200';
      if (success) {
        await fetchAlbums();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAlbum(String id) async {
    try {
      final res = await _service.deleteAlbum(id);
      final success = res['status']?.toString() == '200';
      if (success) {
        await fetchAlbums();
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}

final albumsProvider = AsyncNotifierProvider<AlbumsNotifier, List<AlbumModel>>(
  AlbumsNotifier.new,
);

final approvedAlbumsProvider = Provider<List<AlbumModel>>((ref) {
  final state = ref.watch(albumsProvider);

  return state.maybeWhen(
    data: (list) {
      return list.where((album) => album.status == '1').toList();
    },
    orElse: () => [],
  );
});

final pendingAlbumsProvider = Provider<List<AlbumModel>>((ref) {
  final state = ref.watch(albumsProvider);

  return state.maybeWhen(
    data: (list) {
      return list.where((album) => album.status != '1').toList();
    },
    orElse: () => [],
  );
});
// ==========================================
// 4. MAIN WIDGET: MyProfileAlbumTab
// ==========================================

class MyProfileAlbumTab extends ConsumerWidget {
  const MyProfileAlbumTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showApproved = ref.watch(albumTabProvider);
    final albumsState = ref.watch(albumsProvider);
    final selectedAlbum = ref.watch(selectedAlbumProvider);

    final approvedItems = ref.watch(approvedAlbumsProvider);
    final pendingItems = ref.watch(pendingAlbumsProvider);

    final currentList = showApproved ? approvedItems : pendingItems;

    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 380;
    final cardWidth = isCompact ? width - 48 : 220.0;

    if (selectedAlbum != null) {
      return _buildAlbumDetailsView(context, ref, selectedAlbum);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(albumsProvider.notifier).fetchAlbums(),
      color: Colors.pink,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status toggle tabs (Approved / Pending)
            _buildStatusTabs(context, ref, showApproved),
            const SizedBox(height: 16),

            // Quality Info Strip
            if (showApproved) ...[
              _buildInfoStrip(),
              const SizedBox(height: 16),
            ],

            // Section Title & Action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Private\nAlbums',
                    style: TextStyle(
                      fontSize: isCompact ? 26 : 30,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF19001F),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showAddAlbumDialog(context, ref),
                    icon: const Icon(
                      Icons.create_new_folder_outlined,
                      size: 18,
                    ),
                    label: const Text(
                      'Create Album',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF220027),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Albums list or state rendering
            albumsState.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF2D87),
                    ),
                  ),
                ),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text('Error loading albums: $error'),
                      TextButton(
                        onPressed: () =>
                            ref.read(albumsProvider.notifier).fetchAlbums(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (_) {
                if (currentList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48.0),
                      child: Text(
                        showApproved
                            ? 'No approved albums found.'
                            : 'No pending albums found.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  );
                }

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: currentList
                      .map(
                        (item) =>
                            _buildAlbumCard(context, ref, item, cardWidth),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumDetailsView(
    BuildContext context,
    WidgetRef ref,
    AlbumModel album,
  ) {
    final showApproved = ref.watch(albumTabProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status toggle tabs (Approved / Pending) - exactly below main tab bar like Screenshot 2
          _buildStatusTabs(context, ref, showApproved),
          const SizedBox(height: 16),

          // Back button
          InkWell(
            onTap: () => ref.read(selectedAlbumProvider.notifier).select(null),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: Colors.black87, size: 24),
                  SizedBox(width: 4),
                  Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Fetch images
          FutureBuilder<List<AlbumImageModel>>(
            future: showApproved
                ? ref.read(albumServiceProvider).getAlbumImages(album.id)
                : ref
                      .read(albumServiceProvider)
                      .getPendingAlbumImages(album.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF2D87),
                      ),
                    ),
                  ),
                );
              }

              final images = snapshot.data ?? [];

              if (images.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 80.0),
                    child: Text(
                      'No Record Found.....',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[index].image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs(
    BuildContext context,
    WidgetRef ref,
    bool showApproved,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF19001F), Color(0xFF490040)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPillTab(
              label: 'Approved',
              selected: showApproved,
              onTap: () {
                ref.read(albumTabProvider.notifier).setShowApproved(true);
              },
            ),
          ),
          Expanded(
            child: _buildPillTab(
              label: 'Pending',
              selected: !showApproved,
              onTap: () {
                ref.read(albumTabProvider.notifier).setShowApproved(false);
              },
            ),
          ),
        ],
      ),
    );
  }
  // // Approved vs Pending toggle
  // Widget _buildStatusTabs(BuildContext context, WidgetRef ref, bool showApproved) {
  //   return Container(
  //     height: 44,
  //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(22),
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF19001F), Color(0xFF490040)],
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: _buildPillTab(
  //             label: 'Approved',
  //             selected: showApproved,
  //             onTap: () => ref.read(albumTabProvider.notifier).state = true,
  //           ),
  //         ),
  //         Expanded(
  //           child: _buildPillTab(
  //             label: 'Pending',
  //             selected: !showApproved,
  //             onTap: () => ref.read(albumTabProvider.notifier).state = false,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPillTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2D1935)),
        color: const Color(0xFFFDF8FD),
      ),
      child: const Row(
        children: [
          Icon(Icons.collections_outlined, size: 18, color: Color(0xFF490040)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Only high-quality album photos are approved. Avoid contact info in images.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF490040),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Individual Album Card layout
  Widget _buildAlbumCard(
    BuildContext context,
    WidgetRef ref,
    AlbumModel item,
    double cardWidth,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedAlbumProvider.notifier).select(item);
      },
      child: Container(
        width: cardWidth,
        height: 250,
        decoration: BoxDecoration(
          color: const Color(0xFF2E3539), // Slate grey background
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Header: Title & Edit pencil
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF19001F), Color(0xFF490040)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.albumName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (details) => _showCardPopupMenu(
                      context,
                      ref,
                      item,
                      details.globalPosition,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body: Centered Private Lock Icon
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.white.withOpacity(0.4),
                    ),
                    if (item.status != '1') ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2D87).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFFF2D87),
                            width: 0.5,
                          ),
                        ),
                        child: const Text(
                          'PENDING',
                          style: TextStyle(
                            color: Color(0xFFFF2D87),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Precise popup menu overlay positioning
  void _showCardPopupMenu(
    BuildContext context,
    WidgetRef ref,
    AlbumModel item,
    Offset position,
  ) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx - 100,
        position.dy,
        position.dx,
        position.dy + 100,
      ),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      items: [
        const PopupMenuItem<String>(
          value: 'add_photo',
          child: Text(
            'Add Photo',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'add_video',
          child: Text(
            'Add Video',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'name_password',
          child: Text(
            'Name & Password',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'view',
          child: Text(
            'View',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            'Delete',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );

    if (result == null) return;

    switch (result) {
      case 'add_photo':
        _handlePopupAddPhoto(context, ref, item);
        break;
      case 'add_video':
        _handlePopupAddVideo(context, ref, item);
        break;
      case 'name_password':
        _handlePopupNamePassword(context, ref, item);
        break;
      case 'view':
        _handlePopupView(context, ref, item);
        break;
      case 'delete':
        _handlePopupDelete(context, ref, item);
        break;
    }
  }

  // ==========================================
  // 5. POPUP OPTION HANDLERS
  // ==========================================

  // Add Photo: Picker -> Base64 -> Multiple Image Upload -> Link to Album ID -> Refetch
  Future<void> _handlePopupAddPhoto(
    BuildContext context,
    WidgetRef ref,
    AlbumModel item,
  ) async {
    final source = await _chooseMediaSource(context, isVideo: false);
    if (source == null) return;

    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (pickedFile == null) return;

    final navigator = Navigator.of(context);
    _showLoadingOverlay(context);

    try {
      final bytes = await pickedFile.readAsBytes();
      final base64Str = base64Encode(bytes);
      final ext = pickedFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
      final dataUri = 'data:$mimeType;base64,$base64Str';

      final service = ref.read(albumServiceProvider);
      final imageName = await service.uploadImageMultiple(dataUri);

      if (imageName != null) {
        final success = await service.linkImageToAlbum(imageName, item.id);
        navigator
            .pop(); // Dismiss loader safely using captured navigator reference

        if (success) {
          _showSnackBar(
            context,
            'Photo uploaded and linked to album successfully.',
          );
          ref.read(albumsProvider.notifier).fetchAlbums();
        } else {
          _showSnackBar(context, 'Photo uploaded but link failed.');
        }
      } else {
        navigator
            .pop(); // Dismiss loader safely using captured navigator reference
        _showSnackBar(context, 'Failed to upload photo.');
      }
    } catch (e) {
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference
      _showSnackBar(context, 'Error uploading photo: $e');
    }
  }

  // Add Video: Pick -> Multipart Video Upload -> Refetch
  Future<void> _handlePopupAddVideo(
    BuildContext context,
    WidgetRef ref,
    AlbumModel item,
  ) async {
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    final navigator = Navigator.of(context);
    _showLoadingOverlay(context);

    try {
      final service = ref.read(albumServiceProvider);
      final fileName = await service.uploadVideo(File(pickedFile.path));
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference

      if (fileName != null) {
        _showSnackBar(context, 'Video uploaded successfully.');
        ref.read(albumsProvider.notifier).fetchAlbums();
      } else {
        _showSnackBar(context, 'Failed to upload video.');
      }
    } catch (e) {
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference
      _showSnackBar(context, 'Error uploading video: $e');
    }
  }

  // Name & Password: Fetch details -> Prefill custom Dialog -> Update -> Refetch
  Future<void> _handlePopupNamePassword(
    BuildContext context,
    WidgetRef ref,
    AlbumModel item,
  ) async {
    final navigator = Navigator.of(context);
    _showLoadingOverlay(context);

    try {
      final service = ref.read(albumServiceProvider);
      final details = await service.getAlbumDetailsModel(item.id);
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference

      if (details != null) {
        _showAddAlbumDialog(context, ref, editDetails: details);
      } else {
        _showSnackBar(context, 'Failed to load album details.');
      }
    } catch (e) {
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference
      _showSnackBar(context, 'Error: $e');
    }
  }

  // View: Fetch images for this album -> Render elegant bottom sheet
  Future<void> _handlePopupView(
    BuildContext context,
    WidgetRef ref,
    AlbumModel item,
  ) async {
    final navigator = Navigator.of(context);
    _showLoadingOverlay(context);

    try {
      final service = ref.read(albumServiceProvider);
      final images = await service.getAlbumImages(item.id);
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference

      if (images.isEmpty) {
        _showSnackBar(context, 'No images found in this album.');
        return;
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black87,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Album Photos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            images[index].image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference
      _showSnackBar(context, 'Error retrieving images: $e');
    }
  }

  // Delete Album: Confirms -> Deletes -> Refetch
  Future<void> _handlePopupDelete(
    BuildContext context,
    WidgetRef ref,
    AlbumModel item,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Album'),
          content: Text(
            'Are you sure you want to delete the album "${item.albumName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final navigator = Navigator.of(context);
    _showLoadingOverlay(context);

    try {
      final success = await ref
          .read(albumsProvider.notifier)
          .deleteAlbum(item.id);
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference

      if (success) {
        _showSnackBar(context, 'Album deleted successfully.');
      } else {
        _showSnackBar(context, 'Failed to delete album.');
      }
    } catch (e) {
      navigator
          .pop(); // Dismiss loader safely using captured navigator reference
      _showSnackBar(context, 'Error deleting album: $e');
    }
  }

  // ==========================================
  // 6. HELPER OVERLAYS AND DIALOGS
  // ==========================================

  Future<ImageSource?> _chooseMediaSource(
    BuildContext context, {
    required bool isVideo,
  }) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              if (!isVideo)
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Take Photo'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
        ),
      ),
    );
  }

  // Edit / Add Album Form Dialog (Matches third screenshot perfectly and handles async safely)
  void _showAddAlbumDialog(
    BuildContext context,
    WidgetRef ref, {
    AlbumDetailsModel? editDetails,
  }) {
    final nameController = TextEditingController(
      text: editDetails?.albumName ?? '',
    );
    final passwordController = TextEditingController(
      text: editDetails?.albumPassword ?? '',
    );
    final isEditing = editDetails != null;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Bar (Matches design exactly)
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF19001F), Color(0xFF490040)],
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.create_new_folder_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEditing ? 'Edit Album' : 'Add Album',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (!isLoading)
                            IconButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    ),

                    // Form Textfields
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Album Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: nameController,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: 'Enter album name',
                              fillColor: const Color(0xFFF2F4F7),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Album Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: passwordController,
                            enabled: !isLoading,
                            obscureText:
                                false, // Visible text matching screenshot
                            decoration: InputDecoration(
                              hintText: 'Enter password',
                              fillColor: const Color(0xFFF2F4F7),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Save Button or Loading Spinner
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (isLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFFF2D87),
                                    ),
                                  ),
                                )
                              else
                                ElevatedButton(
                                  onPressed: () async {
                                    final name = nameController.text.trim();
                                    final password = passwordController.text
                                        .trim();

                                    if (name.isEmpty || password.isEmpty) {
                                      _showSnackBar(
                                        dialogContext,
                                        'Please enter both name and password.',
                                      );
                                      return;
                                    }

                                    setState(() {
                                      isLoading = true;
                                    });

                                    bool success;
                                    try {
                                      if (isEditing) {
                                        success = await ref
                                            .read(albumsProvider.notifier)
                                            .updateAlbum(
                                              editDetails.id,
                                              name,
                                              password,
                                            );
                                      } else {
                                        success = await ref
                                            .read(albumsProvider.notifier)
                                            .createAlbum(name, password);
                                      }
                                    } catch (_) {
                                      success = false;
                                    }

                                    if (success) {
                                      Navigator.pop(
                                        dialogContext,
                                      ); // Safely close the dialog
                                      _showSnackBar(
                                        context, // Show on parent context safely
                                        isEditing
                                            ? 'Album updated successfully!'
                                            : 'Album created successfully!',
                                      );
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      _showSnackBar(
                                        dialogContext,
                                        'Failed to save album.',
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF220027),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}


// import 'dart:convert';
// import 'dart:io';
// import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// // Native Imports from BeatFlirt project structure
// import 'package:beatflirt/core/services/token_services.dart';
// // import 'package:beatflirt/services/api_service.dart'; // Import to use ApiService.buildAuthHeaders

// // ==========================================
// // 1. DATA MODELS
// // ==========================================

// class AlbumModel {
//   final String id;
//   final String albumName;
//   final String albumPassword;
//   final String image;
//   final String status; // "1" for Approved, otherwise Pending

//   AlbumModel({
//     required this.id,
//     required this.albumName,
//     required this.albumPassword,
//     required this.image,
//     required this.status,
//   });

//   factory AlbumModel.fromJson(Map<String, dynamic> json) {
//     return AlbumModel(
//       id: json['id']?.toString() ?? '',
//       albumName: json['album_name']?.toString() ?? '',
//       albumPassword: json['album_password']?.toString() ?? '',
//       image: json['image']?.toString() ?? '',
//       status: json['status']?.toString() ?? '1',
//     );
//   }
// }

// class AlbumImageModel {
//   final String id;
//   final String albumId;
//   final String image;

//   AlbumImageModel({
//     required this.id,
//     required this.albumId,
//     required this.image,
//   });

//   factory AlbumImageModel.fromJson(Map<String, dynamic> json) {
//     return AlbumImageModel(
//       id: json['id']?.toString() ?? '',
//       albumId: json['album_id']?.toString() ?? '',
//       image: json['image']?.toString() ?? '',
//     );
//   }
// }

// class AlbumDetailsModel {
//   final String id;
//   final String albumName;
//   final String albumPassword;

//   AlbumDetailsModel({
//     required this.id,
//     required this.albumName,
//     required this.albumPassword,
//   });

//   factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
//     return AlbumDetailsModel(
//       id: json['id']?.toString() ?? '',
//       albumName: json['album_name']?.toString() ?? '',
//       albumPassword: json['album_password']?.toString() ?? '',
//     );
//   }
// }

// // ==========================================
// // 2. NATIVE-INTEGRATED ALBUM SERVICE
// // ==========================================

// class AlbumService {
//   static const String baseUrl = 'https://app.beatflirtevent.com/App';
//   final TokenService _tokenService = TokenService();

//   // Dynamically load active user session token from Native TokenService
//   Future<String?> _getToken() async {
//     try {
//       return await _tokenService.getAccessToken();
//     } catch (e) {
//       debugPrint('Error getting access token: $e');
//       return null;
//     }
//   }

//   // Generate perfect headers matching native ApiService with cookie jars and formats
//   Future<Map<String, String>> _getHeaders() async {
//     final token = await _getToken();
//     return ApiService.buildAuthHeaders(token: token);
//   }

//   // 1. Get all albums (GET)
//   Future<List<AlbumModel>> getAllAlbums() async {
//     final url = '$baseUrl/user/get_all_album';
//     debugPrint('➡️ [AlbumService GET] URL: $url');
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(Uri.parse(url), headers: headers);
//       debugPrint('⬅️ [AlbumService GET] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (decoded['status'] == '200' && decoded['data'] is List) {
//           return (decoded['data'] as List)
//               .map((item) => AlbumModel.fromJson(item))
//               .toList();
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService GET] Exception: $e');
//     }
//     return [];
//   }

//   // 2. Get all approved album images (GET)
//   Future<List<String>> getAllApprovedAlbumImages() async {
//     final url = '$baseUrl/user/get_all_approve_album_image';
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(Uri.parse(url), headers: headers);
//       debugPrint('⬅️ [AlbumService Approved Images] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (decoded['status'] == '200' && decoded['data'] is List) {
//           return (decoded['data'] as List).map((e) => e['image'].toString()).toList();
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService GET] Exception: $e');
//     }
//     return [];
//   }

//   // 3. Get all pending album images (GET)
//   Future<List<String>> getAllPendingAlbumImages() async {
//     final url = '$baseUrl/user/get_all_pending_album_image';
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(Uri.parse(url), headers: headers);
//       debugPrint('⬅️ [AlbumService Pending Images] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (decoded['status'] == '200' && decoded['data'] is List) {
//           return (decoded['data'] as List).map((e) => e['image'].toString()).toList();
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService GET] Exception: $e');
//     }
//     return [];
//   }

//   // 4 & View. Get album images for a specific album (POST - JSON payload)
//   Future<List<AlbumImageModel>> getAlbumImages(String albumId) async {
//     final url = '$baseUrl/user/get_album_image';
//     final payload = {'album_id': albumId};
//     debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//       debugPrint('⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (decoded['status'] == '200' && decoded['data'] is List) {
//           return (decoded['data'] as List)
//               .map((item) => AlbumImageModel.fromJson(item))
//               .toList();
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService POST] Exception: $e');
//     }
//     return [];
//   }

//   // 5. Create profile album (POST - JSON payload)
//   Future<bool> createProfileAlbum(String name, String password) async {
//     final url = '$baseUrl/user/create_profile_album';
//     final payload = {
//       'album_name': name,
//       'album_password': password,
//     };
//     debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//       debugPrint('⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         return decoded['status'] == '200';
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService POST] Exception: $e');
//     }
//     return false;
//   }

//   // Popup Action 1: Upload image base64 (POST - JSON payload)
//   Future<String?> uploadImageMultiple(String base64Image) async {
//     final url = '$baseUrl/upload/imageuploadMultiple';
//     final payload = {
//       'image': [
//         {'image': base64Image}
//       ]
//     };
//     debugPrint('➡️ [AlbumService JSON POST] URL: $url | Payload snippet: ${jsonEncode(payload).substring(0, 100)}...');
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//       debugPrint('⬅️ [AlbumService JSON POST] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (decoded['status'] == '200' && decoded['data'] is List && decoded['data'].isNotEmpty) {
//           return decoded['data'][0]['image_name']?.toString();
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService JSON POST] Exception: $e');
//     }
//     return null;
//   }

//   // Popup Action 2: Link image to album (POST - JSON payload)
//   Future<bool> linkImageToAlbum(String imageName, String albumId) async {
//     final url = '$baseUrl/user/single_user_mutiple_album_image';
//     final payload = {
//       'image': imageName,
//       'album_id': albumId,
//     };
//     debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//       debugPrint('⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         return decoded['status'] == '200';
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService POST] Exception: $e');
//     }
//     return false;
//   }

//   // Popup Action 3: Get album details (POST - JSON payload)
//   Future<AlbumDetailsModel?> getAlbumDetails(String albumId) async {
//     final url = '$baseUrl/user/get_album_details';
//     final payload = {'album_id': albumId};
//     debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//       debugPrint('⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (decoded['status'] == '200' && decoded['data'] != null) {
//           return AlbumDetailsModel.fromJson(decoded['data']);
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService POST] Exception: $e');
//     }
//     return null;
//   }

//   // Popup Action 4: Upload video binary (POST - multipart)
//   Future<String?> uploadVideo(File videoFile) async {
//     final url = '$baseUrl/upload/video_upload';
//     debugPrint('➡️ [AlbumService MULTIPART POST] URL: $url');
//     try {
//       final request = http.MultipartRequest('POST', Uri.parse(url));
//       final headers = await _getHeaders();
//       headers.forEach((key, val) => request.headers[key] = val);
//       request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//       debugPrint('⬅️ [AlbumService MULTIPART POST] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (decoded['status'] == '200' && decoded['data'] != null) {
//           return decoded['data']['file_name']?.toString();
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService MULTIPART POST] Exception: $e');
//     }
//     return null;
//   }

//   // Popup Action 5: Update profile album (POST - JSON payload)
//   Future<bool> updateProfileAlbum(String albumId, String name, String password) async {
//     final url = '$baseUrl/user/update_profile_album';
//     final payload = {
//       'album_id': albumId,
//       'album_name': name,
//       'album_password': password,
//     };
//     debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//       debugPrint('⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         return decoded['status'] == '200';
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService POST] Exception: $e');
//     }
//     return false;
//   }

//   // 6. Delete album (POST - JSON payload)
//   Future<bool> deleteAlbum(String albumId) async {
//     final url = '$baseUrl/user/delete_album';
//     final payload = {'album_id': albumId};
//     debugPrint('➡️ [AlbumService POST] URL: $url | Payload: $payload');
//     try {
//       final headers = await _getHeaders();
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//       debugPrint('⬅️ [AlbumService POST] Response (${response.statusCode}): ${response.body}');
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         return decoded['status'] == '200';
//       }
//     } catch (e) {
//       debugPrint('❌ [AlbumService POST] Exception: $e');
//     }
//     return false;
//   }
// }

// // ==========================================
// // 3. RIVERPOD PROVIDERS
// // ==========================================

// final albumServiceProvider = Provider<AlbumService>((ref) => AlbumService());

// // State provider for active toggles (true = Approved, false = Pending)
// final albumTabProvider = StateProvider<bool>((ref) => true);

// class AlbumsNotifier extends StateNotifier<AsyncValue<List<AlbumModel>>> {
//   final AlbumService _service;

//   AlbumsNotifier(this._service) : super(const AsyncValue.loading()) {
//     fetchAlbums();
//   }

//   Future<void> fetchAlbums() async {
//     state = const AsyncValue.loading();
//     try {
//       final list = await _service.getAllAlbums();
//       state = AsyncValue.data(list);
//     } catch (e, stack) {
//       state = AsyncValue.error(e, stack);
//     }
//   }

//   Future<bool> createAlbum(String name, String password) async {
//     try {
//       final success = await _service.createProfileAlbum(name, password);
//       if (success) {
//         await fetchAlbums();
//       }
//       return success;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> updateAlbum(String id, String name, String password) async {
//     try {
//       final success = await _service.updateProfileAlbum(id, name, password);
//       if (success) {
//         await fetchAlbums();
//       }
//       return success;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> deleteAlbum(String id) async {
//     try {
//       final success = await _service.deleteAlbum(id);
//       if (success) {
//         await fetchAlbums();
//       }
//       return success;
//     } catch (e) {
//       return false;
//     }
//   }
// }

// final albumsProvider = StateNotifierProvider<AlbumsNotifier, AsyncValue<List<AlbumModel>>>((ref) {
//   return AlbumsNotifier(ref.watch(albumServiceProvider));
// });

// final approvedAlbumsProvider = Provider<List<AlbumModel>>((ref) {
//   final state = ref.watch(albumsProvider);
//   return state.maybeWhen(
//     data: (list) => list.where((album) => album.status == '1').toList(),
//     orElse: () => [],
//   );
// });

// final pendingAlbumsProvider = Provider<List<AlbumModel>>((ref) {
//   final state = ref.watch(albumsProvider);
//   return state.maybeWhen(
//     data: (list) => list.where((album) => album.status != '1').toList(),
//     orElse: () => [],
//   );
// });

// // ==========================================
// // 4. MAIN WIDGET: MyProfileAlbumTab
// // ==========================================

// class MyProfileAlbumTab extends ConsumerWidget {
//   const MyProfileAlbumTab({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final showApproved = ref.watch(albumTabProvider);
//     final albumsState = ref.watch(albumsProvider);

//     final approvedItems = ref.watch(approvedAlbumsProvider);
//     final pendingItems = ref.watch(pendingAlbumsProvider);

//     final currentList = showApproved ? approvedItems : pendingItems;

//     final width = MediaQuery.of(context).size.width;
//     final isCompact = width < 380;
//     final cardWidth = isCompact ? width - 48 : 220.0;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Status toggle tabs (Approved / Pending)
//         _buildStatusTabs(context, ref, showApproved),
//         const SizedBox(height: 16),

//         // Quality Info Strip
//         if (showApproved) ...[
//           _buildInfoStrip(),
//           const SizedBox(height: 16),
//         ],

//         // Section Title & Action
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 4.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Your Private\nAlbums',
//                 style: TextStyle(
//                   fontSize: isCompact ? 26 : 30,
//                   fontWeight: FontWeight.w800,
//                   color: const Color(0xFF19001F),
//                   height: 1.1,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton.icon(
//                 onPressed: () => _showAddAlbumDialog(context, ref),
//                 icon: const Icon(Icons.create_new_folder_outlined, size: 18),
//                 label: const Text(
//                   'Create Album',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF220027),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(22),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),

//         // Albums list or state rendering
//         albumsState.when(
//           loading: () => const Center(
//             child: Padding(
//               padding: EdgeInsets.all(40.0),
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
//               ),
//             ),
//           ),
//           error: (error, _) => Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 children: [
//                   const Icon(Icons.error_outline, color: Colors.red, size: 40),
//                   const SizedBox(height: 10),
//                   Text('Error loading albums: $error'),
//                   TextButton(
//                     onPressed: () => ref.read(albumsProvider.notifier).fetchAlbums(),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           data: (_) {
//             if (currentList.isEmpty) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 48.0),
//                   child: Text(
//                     showApproved ? 'No approved albums found.' : 'No pending albums found.',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                   ),
//                 ),
//               );
//             }

//             return Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: currentList
//                   .map((item) => _buildAlbumCard(context, ref, item, cardWidth))
//                   .toList(),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   // Approved vs Pending toggle
//   Widget _buildStatusTabs(BuildContext context, WidgetRef ref, bool showApproved) {
//     return Container(
//       height: 44,
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(22),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF19001F), Color(0xFF490040)],
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildPillTab(
//               label: 'Approved',
//               selected: showApproved,
//               onTap: () => ref.read(albumTabProvider.notifier).state = true,
//             ),
//           ),
//           Expanded(
//             child: _buildPillTab(
//               label: 'Pending',
//               selected: !showApproved,
//               onTap: () => ref.read(albumTabProvider.notifier).state = false,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPillTab({
//     required String label,
//     required bool selected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoStrip() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFF2D1935)),
//         color: const Color(0xFFFDF8FD),
//       ),
//       child: const Row(
//         children: [
//           Icon(Icons.collections_outlined, size: 18, color: Color(0xFF490040)),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               'Only high-quality album photos are approved. Avoid contact info in images.',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF490040),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Individual Album Card layout
//   Widget _buildAlbumCard(
//     BuildContext context,
//     WidgetRef ref,
//     AlbumModel item,
//     double cardWidth,
//   ) {
//     return Container(
//       width: cardWidth,
//       height: 250,
//       decoration: BoxDecoration(
//         color: const Color(0xFF2E3539), // Slate grey background
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Card Header: Title & Edit pencil
//           Container(
//             height: 42,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF19001F), Color(0xFF490040)],
//               ),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     item.albumName,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTapDown: (details) => _showCardPopupMenu(context, ref, item, details.globalPosition),
//                   child: const Padding(
//                     padding: EdgeInsets.all(4.0),
//                     child: Icon(
//                       Icons.edit_outlined,
//                       size: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Card Body: Centered Private Lock Icon
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.lock_outline,
//                     size: 64,
//                     color: Colors.white.withOpacity(0.4),
//                   ),
//                   if (item.status != '1') ...[
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFF2D87).withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(4),
//                         border: Border.all(color: const Color(0xFFFF2D87), width: 0.5),
//                       ),
//                       child: const Text(
//                         'PENDING',
//                         style: TextStyle(
//                           color: Color(0xFFFF2D87),
//                           fontSize: 9,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Precise popup menu overlay positioning
//   void _showCardPopupMenu(
//     BuildContext context,
//     WidgetRef ref,
//     AlbumModel item,
//     Offset position,
//   ) async {
//     final result = await showMenu<String>(
//       context: context,
//       position: RelativeRect.fromLTRB(position.dx - 100, position.dy, position.dx, position.dy + 100),
//       color: Colors.white,
//       elevation: 8,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: const BorderSide(color: Color(0xFFE0E0E0)),
//       ),
//       items: [
//         const PopupMenuItem<String>(
//           value: 'add_photo',
//           child: Text('Add Photo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
//         ),
//         const PopupMenuItem<String>(
//           value: 'add_video',
//           child: Text('Add Video', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
//         ),
//         const PopupMenuItem<String>(
//           value: 'name_password',
//           child: Text('Name & Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
//         ),
//         const PopupMenuItem<String>(
//           value: 'view',
//           child: Text('View', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
//         ),
//         const PopupMenuItem<String>(
//           value: 'delete',
//           child: Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
//         ),
//       ],
//     );

//     if (result == null) return;

//     switch (result) {
//       case 'add_photo':
//         _handlePopupAddPhoto(context, ref, item);
//         break;
//       case 'add_video':
//         _handlePopupAddVideo(context, ref, item);
//         break;
//       case 'name_password':
//         _handlePopupNamePassword(context, ref, item);
//         break;
//       case 'view':
//         _handlePopupView(context, ref, item);
//         break;
//       case 'delete':
//         _handlePopupDelete(context, ref, item);
//         break;
//     }
//   }

//   // ==========================================
//   // 5. POPUP OPTION HANDLERS
//   // ==========================================

//   // Add Photo: Picker -> Base64 -> Multiple Image Upload -> Link to Album ID -> Refetch
//   Future<void> _handlePopupAddPhoto(BuildContext context, WidgetRef ref, AlbumModel item) async {
//     final source = await _chooseMediaSource(context, isVideo: false);
//     if (source == null) return;

//     final pickedFile = await ImagePicker().pickImage(
//       source: source,
//       imageQuality: 85,
//     );
//     if (pickedFile == null) return;

//     final navigator = Navigator.of(context);
//     _showLoadingOverlay(context);

//     try {
//       final bytes = await pickedFile.readAsBytes();
//       final base64Str = base64Encode(bytes);
//       final ext = pickedFile.path.split('.').last.toLowerCase();
//       final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
//       final dataUri = 'data:$mimeType;base64,$base64Str';

//       final service = ref.read(albumServiceProvider);
//       final imageName = await service.uploadImageMultiple(dataUri);

//       if (imageName != null) {
//         final success = await service.linkImageToAlbum(imageName, item.id);
//         navigator.pop(); // Dismiss loader safely using captured navigator reference

//         if (success) {
//           _showSnackBar(context, 'Photo uploaded and linked to album successfully.');
//           ref.read(albumsProvider.notifier).fetchAlbums();
//         } else {
//           _showSnackBar(context, 'Photo uploaded but link failed.');
//         }
//       } else {
//         navigator.pop(); // Dismiss loader safely using captured navigator reference
//         _showSnackBar(context, 'Failed to upload photo.');
//       }
//     } catch (e) {
//       navigator.pop(); // Dismiss loader safely using captured navigator reference
//       _showSnackBar(context, 'Error uploading photo: $e');
//     }
//   }

//   // Add Video: Pick -> Multipart Video Upload -> Refetch
//   Future<void> _handlePopupAddVideo(BuildContext context, WidgetRef ref, AlbumModel item) async {
//     final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
//     if (pickedFile == null) return;

//     final navigator = Navigator.of(context);
//     _showLoadingOverlay(context);

//     try {
//       final service = ref.read(albumServiceProvider);
//       final fileName = await service.uploadVideo(File(pickedFile.path));
//       navigator.pop(); // Dismiss loader safely using captured navigator reference

//       if (fileName != null) {
//         _showSnackBar(context, 'Video uploaded successfully.');
//         ref.read(albumsProvider.notifier).fetchAlbums();
//       } else {
//         _showSnackBar(context, 'Failed to upload video.');
//       }
//     } catch (e) {
//       navigator.pop(); // Dismiss loader safely using captured navigator reference
//       _showSnackBar(context, 'Error uploading video: $e');
//     }
//   }

//   // Name & Password: Fetch details -> Prefill custom Dialog -> Update -> Refetch
//   Future<void> _handlePopupNamePassword(BuildContext context, WidgetRef ref, AlbumModel item) async {
//     final navigator = Navigator.of(context);
//     _showLoadingOverlay(context);

//     try {
//       final service = ref.read(albumServiceProvider);
//       final details = await service.getAlbumDetails(item.id);
//       navigator.pop(); // Dismiss loader safely using captured navigator reference

//       if (details != null) {
//         _showAddAlbumDialog(context, ref, editDetails: details);
//       } else {
//         _showSnackBar(context, 'Failed to load album details.');
//       }
//     } catch (e) {
//       navigator.pop(); // Dismiss loader safely using captured navigator reference
//       _showSnackBar(context, 'Error: $e');
//     }
//   }

//   // View: Fetch images for this album -> Render elegant bottom sheet
//   Future<void> _handlePopupView(BuildContext context, WidgetRef ref, AlbumModel item) async {
//     final navigator = Navigator.of(context);
//     _showLoadingOverlay(context);

//     try {
//       final service = ref.read(albumServiceProvider);
//       final images = await service.getAlbumImages(item.id);
//       navigator.pop(); // Dismiss loader safely using captured navigator reference

//       if (images.isEmpty) {
//         _showSnackBar(context, 'No images found in this album.');
//         return;
//       }

//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.black87,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         builder: (context) {
//           return DraggableScrollableSheet(
//             expand: false,
//             initialChildSize: 0.6,
//             maxChildSize: 0.9,
//             builder: (context, scrollController) {
//               return Column(
//                 children: [
//                   const SizedBox(height: 12),
//                   Container(
//                     width: 40,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: Colors.white24,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Album Photos',
//                       style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Expanded(
//                     child: GridView.builder(
//                       controller: scrollController,
//                       padding: const EdgeInsets.all(16),
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                       ),
//                       itemCount: images.length,
//                       itemBuilder: (context, index) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             images[index].image,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => Container(
//                               color: Colors.grey[800],
//                               child: const Icon(Icons.image_not_supported, color: Colors.white38),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );
//     } catch (e) {
//       navigator.pop(); // Dismiss loader safely using captured navigator reference
//       _showSnackBar(context, 'Error retrieving images: $e');
//     }
//   }

//   // Delete Album: Confirms -> Deletes -> Refetch
//   Future<void> _handlePopupDelete(BuildContext context, WidgetRef ref, AlbumModel item) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Album'),
//           content: Text('Are you sure you want to delete the album "${item.albumName}"?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//               child: const Text('Delete', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirm != true) return;

//     final navigator = Navigator.of(context);
//     _showLoadingOverlay(context);

//     try {
//       final success = await ref.read(albumsProvider.notifier).deleteAlbum(item.id);
//       navigator.pop(); // Dismiss loader safely using captured navigator reference

//       if (success) {
//         _showSnackBar(context, 'Album deleted successfully.');
//       } else {
//         _showSnackBar(context, 'Failed to delete album.');
//       }
//     } catch (e) {
//       navigator.pop(); // Dismiss loader safely using captured navigator reference
//       _showSnackBar(context, 'Error deleting album: $e');
//     }
//   }

//   // ==========================================
//   // 6. HELPER OVERLAYS AND DIALOGS
//   // ==========================================

//   Future<ImageSource?> _chooseMediaSource(BuildContext context, {required bool isVideo}) async {
//     return showModalBottomSheet<ImageSource>(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library_outlined),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () => Navigator.pop(context, ImageSource.gallery),
//               ),
//               if (!isVideo)
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt_outlined),
//                   title: const Text('Take Photo'),
//                   onTap: () => Navigator.pop(context, ImageSource.camera),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showLoadingOverlay(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
//         ),
//       ),
//     );
//   }

//   // Edit / Add Album Form Dialog (Matches third screenshot perfectly and handles async safely)
//   void _showAddAlbumDialog(
//     BuildContext context,
//     WidgetRef ref, {
//     AlbumDetailsModel? editDetails,
//   }) {
//     final nameController = TextEditingController(text: editDetails?.albumName ?? '');
//     final passwordController = TextEditingController(text: editDetails?.albumPassword ?? '');
//     final isEditing = editDetails != null;

//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (dialogContext) {
//         bool isLoading = false;

//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Header Bar (Matches design exactly)
//                     Container(
//                       height: 52,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xFF19001F), Color(0xFF490040)],
//                         ),
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.create_new_folder_outlined, color: Colors.white, size: 22),
//                           const SizedBox(width: 8),
//                           Text(
//                             isEditing ? 'Edit Album' : 'Add Album',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Spacer(),
//                           if (!isLoading)
//                             IconButton(
//                               onPressed: () => Navigator.pop(dialogContext),
//                               icon: const Icon(Icons.close, color: Colors.white, size: 20),
//                               padding: EdgeInsets.zero,
//                               constraints: const BoxConstraints(),
//                             ),
//                         ],
//                       ),
//                     ),

//                     // Form Textfields
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Album Name',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: nameController,
//                             enabled: !isLoading,
//                             decoration: InputDecoration(
//                               hintText: 'Enter album name',
//                               fillColor: const Color(0xFFF2F4F7),
//                               filled: true,
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(color: Colors.grey.shade300),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(color: Colors.grey.shade300),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Album Password',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: passwordController,
//                             enabled: !isLoading,
//                             obscureText: false, // Visible text matching screenshot
//                             decoration: InputDecoration(
//                               hintText: 'Enter password',
//                               fillColor: const Color(0xFFF2F4F7),
//                               filled: true,
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(color: Colors.grey.shade300),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(color: Colors.grey.shade300),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 24),

//                           // Save Button or Loading Spinner
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               if (isLoading)
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 24.0),
//                                   child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
//                                   ),
//                                 )
//                               else
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     final name = nameController.text.trim();
//                                     final password = passwordController.text.trim();

//                                     if (name.isEmpty || password.isEmpty) {
//                                       _showSnackBar(dialogContext, 'Please enter both name and password.');
//                                       return;
//                                     }

//                                     setState(() {
//                                       isLoading = true;
//                                     });

//                                     bool success;
//                                     try {
//                                       if (isEditing) {
//                                         success = await ref
//                                             .read(albumsProvider.notifier)
//                                             .updateAlbum(editDetails.id, name, password);
//                                       } else {
//                                         success = await ref
//                                             .read(albumsProvider.notifier)
//                                             .createAlbum(name, password);
//                                       }
//                                     } catch (_) {
//                                       success = false;
//                                     }

//                                     if (success) {
//                                       Navigator.pop(dialogContext); // Safely close the dialog
//                                       _showSnackBar(
//                                         context, // Show on parent context safely
//                                         isEditing
//                                             ? 'Album updated successfully!'
//                                             : 'Album created successfully!',
//                                       );
//                                     } else {
//                                       setState(() {
//                                         isLoading = false;
//                                       });
//                                       _showSnackBar(dialogContext, 'Failed to save album.');
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF220027),
//                                     foregroundColor: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 24,
//                                       vertical: 12,
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     'Save',
//                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }


// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:http/http.dart' as http;

// // // ==========================================
// // // 1. AUTHENTICATION TOKEN PROVIDER
// // // ==========================================
// // // ⚠️ IMPORTANT: Replace 'YOUR_ACTUAL_USER_TOKEN_HERE' with your actual login/session token string.
// // // E.g. If you have an AuthState provider:
// // // final tokenProvider = Provider<String?>((ref) => ref.watch(authProvider).token);
// // final tokenProvider = Provider<String?>((ref) {
// //   // TODO: Paste your real login user token here
// //   return 'YOUR_ACTUAL_USER_TOKEN_HERE';
// // });

// // // ==========================================
// // // 2. DATA MODELS
// // // ==========================================

// // class AlbumModel {
// //   final String id;
// //   final String albumName;
// //   final String albumPassword;
// //   final String image;
// //   final String status; // "1" for Approved, otherwise Pending

// //   AlbumModel({
// //     required this.id,
// //     required this.albumName,
// //     required this.albumPassword,
// //     required this.image,
// //     required this.status,
// //   });

// //   factory AlbumModel.fromJson(Map<String, dynamic> json) {
// //     return AlbumModel(
// //       id: json['id']?.toString() ?? '',
// //       albumName: json['album_name']?.toString() ?? '',
// //       albumPassword: json['album_password']?.toString() ?? '',
// //       image: json['image']?.toString() ?? '',
// //       status: json['status']?.toString() ?? '1',
// //     );
// //   }
// // }

// // class AlbumImageModel {
// //   final String id;
// //   final String albumId;
// //   final String image;

// //   AlbumImageModel({
// //     required this.id,
// //     required this.albumId,
// //     required this.image,
// //   });

// //   factory AlbumImageModel.fromJson(Map<String, dynamic> json) {
// //     return AlbumImageModel(
// //       id: json['id']?.toString() ?? '',
// //       albumId: json['album_id']?.toString() ?? '',
// //       image: json['image']?.toString() ?? '',
// //     );
// //   }
// // }

// // class AlbumDetailsModel {
// //   final String id;
// //   final String albumName;
// //   final String albumPassword;

// //   AlbumDetailsModel({
// //     required this.id,
// //     required this.albumName,
// //     required this.albumPassword,
// //   });

// //   factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
// //     return AlbumDetailsModel(
// //       id: json['id']?.toString() ?? '',
// //       albumName: json['album_name']?.toString() ?? '',
// //       albumPassword: json['album_password']?.toString() ?? '',
// //     );
// //   }
// // }

// // // ==========================================
// // // 3. BULLETPROOF API SERVICE WITH EXTENSIVE LOGGING
// // // ==========================================

// // class AlbumService {
// //   final Ref _ref;
// //   static const String baseUrl = 'https://app.beatflirtevent.com/App';

// //   AlbumService(this._ref);

// //   String? get _token => _ref.read(tokenProvider);

// //   // Auto-generate standard HTTP headers with Bearer & Token keys
// //   Map<String, String> get _headers {
// //     final tokenVal = _token ?? '';
// //     return {
// //       'token': tokenVal,
// //       'Token': tokenVal,
// //       'Authorization': 'Bearer $tokenVal',
// //     };
// //   }

// //   // Auto-inject token into POST form bodies as an extra safeguard
// //   Map<String, String> _injectTokenToBody(Map<String, String> body) {
// //     final tokenVal = _token;
// //     if (tokenVal != null && tokenVal.isNotEmpty) {
// //       return {
// //         ...body,
// //         'token': tokenVal,
// //         'Token': tokenVal,
// //       };
// //     }
// //     return body;
// //   }

// //   // Append token to GET query parameters
// //   Uri _buildGetUri(String path) {
// //     final tokenVal = _token;
// //     final baseUri = Uri.parse('$baseUrl$path');
// //     if (tokenVal != null && tokenVal.isNotEmpty) {
// //       return baseUri.replace(
// //         queryParameters: {
// //           ...baseUri.queryParameters,
// //           'token': tokenVal,
// //           'Token': tokenVal,
// //         },
// //       );
// //     }
// //     return baseUri;
// //   }

// //   // 1. Get all albums (GET)
// //   Future<List<AlbumModel>> getAllAlbums() async {
// //     final url = _buildGetUri('/user/get_all_album');
// //     debugPrint('➡️ [API GET] Request: $url');
// //     try {
// //       final response = await http.get(url, headers: _headers);
// //       debugPrint('⬅️ [API GET] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         if (decoded['status'] == '200' && decoded['data'] is List) {
// //           return (decoded['data'] as List)
// //               .map((item) => AlbumModel.fromJson(item))
// //               .toList();
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API GET] Exception: $e');
// //     }
// //     return [];
// //   }

// //   // 2. Get all approved album images (GET)
// //   Future<List<String>> getAllApprovedAlbumImages() async {
// //     final url = _buildGetUri('/user/get_all_approve_album_image');
// //     debugPrint('➡️ [API GET] Request: $url');
// //     try {
// //       final response = await http.get(url, headers: _headers);
// //       debugPrint('⬅️ [API GET] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         if (decoded['status'] == '200' && decoded['data'] is List) {
// //           return (decoded['data'] as List).map((e) => e['image'].toString()).toList();
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API GET] Exception: $e');
// //     }
// //     return [];
// //   }

// //   // 3. Get all pending album images (GET)
// //   Future<List<String>> getAllPendingAlbumImages() async {
// //     final url = _buildGetUri('/user/get_all_pending_album_image');
// //     debugPrint('➡️ [API GET] Request: $url');
// //     try {
// //       final response = await http.get(url, headers: _headers);
// //       debugPrint('⬅️ [API GET] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         if (decoded['status'] == '200' && decoded['data'] is List) {
// //           return (decoded['data'] as List).map((e) => e['image'].toString()).toList();
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API GET] Exception: $e');
// //     }
// //     return [];
// //   }

// //   // 4 & View. Get album images for a specific album (POST)
// //   Future<List<AlbumImageModel>> getAlbumImages(String albumId) async {
// //     final url = '$baseUrl/user/get_album_image';
// //     final body = _injectTokenToBody({'album_id': albumId});
// //     debugPrint('➡️ [API POST] Request: $url');
// //     debugPrint('➡️ [API POST] Body: $body');
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: _headers,
// //         body: body,
// //       );
// //       debugPrint('⬅️ [API POST] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         if (decoded['status'] == '200' && decoded['data'] is List) {
// //           return (decoded['data'] as List)
// //               .map((item) => AlbumImageModel.fromJson(item))
// //               .toList();
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API POST] Exception: $e');
// //     }
// //     return [];
// //   }

// //   // 5. Create profile album (POST)
// //   Future<bool> createProfileAlbum(String name, String password) async {
// //     final url = '$baseUrl/user/create_profile_album';
// //     final body = _injectTokenToBody({
// //       'album_name': name,
// //       'album_password': password,
// //     });
// //     debugPrint('➡️ [API POST] Request: $url');
// //     debugPrint('➡️ [API POST] Headers: $_headers');
// //     debugPrint('➡️ [API POST] Body: $body');
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: _headers,
// //         body: body,
// //       );
// //       debugPrint('⬅️ [API POST] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         return decoded['status'] == '200';
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API POST] Exception: $e');
// //     }
// //     return false;
// //   }

// //   // Popup Action 1: Upload image base64 (POST)
// //   Future<String?> uploadImageMultiple(String base64Image) async {
// //     final url = '$baseUrl/upload/imageuploadMultiple';
// //     final payload = {
// //       'image': [
// //         {'image': base64Image}
// //       ],
// //       if (_token != null && _token!.isNotEmpty) 'token': _token!,
// //     };
// //     debugPrint('➡️ [API JSON POST] Request: $url');
// //     debugPrint('➡️ [API JSON POST] Payload snippet: ${jsonEncode(payload).substring(0, 100)}...');
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           ..._headers,
// //         },
// //         body: jsonEncode(payload),
// //       );
// //       debugPrint('⬅️ [API JSON POST] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         if (decoded['status'] == '200' && decoded['data'] is List && decoded['data'].isNotEmpty) {
// //           return decoded['data'][0]['image_name']?.toString();
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API JSON POST] Exception: $e');
// //     }
// //     return null;
// //   }

// //   // Popup Action 2: Link image to album (POST)
// //   Future<bool> linkImageToAlbum(String imageName, String albumId) async {
// //     final url = '$baseUrl/user/single_user_mutiple_album_image';
// //     final body = _injectTokenToBody({
// //       'image': imageName,
// //       'album_id': albumId,
// //     });
// //     debugPrint('➡️ [API POST] Request: $url');
// //     debugPrint('➡️ [API POST] Body: $body');
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: _headers,
// //         body: body,
// //       );
// //       debugPrint('⬅️ [API POST] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         return decoded['status'] == '200';
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API POST] Exception: $e');
// //     }
// //     return false;
// //   }

// //   // Popup Action 3: Get album details (POST)
// //   Future<AlbumDetailsModel?> getAlbumDetails(String albumId) async {
// //     final url = '$baseUrl/user/get_album_details';
// //     final body = _injectTokenToBody({'album_id': albumId});
// //     debugPrint('➡️ [API POST] Request: $url');
// //     debugPrint('➡️ [API POST] Body: $body');
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: _headers,
// //         body: body,
// //       );
// //       debugPrint('⬅️ [API POST] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         if (decoded['status'] == '200' && decoded['data'] != null) {
// //           return AlbumDetailsModel.fromJson(decoded['data']);
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API POST] Exception: $e');
// //     }
// //     return null;
// //   }

// //   // Popup Action 4: Upload video binary (POST)
// //   Future<String?> uploadVideo(File videoFile) async {
// //     final url = '$baseUrl/upload/video_upload';
// //     debugPrint('➡️ [API MULTIPART POST] Request: $url');
// //     try {
// //       final request = http.MultipartRequest('POST', Uri.parse(url));
// //       _headers.forEach((key, val) => request.headers[key] = val);
// //       if (_token != null && _token!.isNotEmpty) {
// //         request.fields['token'] = _token!;
// //         request.fields['Token'] = _token!;
// //       }
// //       request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));
// //       final streamedResponse = await request.send();
// //       final response = await http.Response.fromStream(streamedResponse);
// //       debugPrint('⬅️ [API MULTIPART POST] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         if (decoded['status'] == '200' && decoded['data'] != null) {
// //           return decoded['data']['file_name']?.toString();
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API MULTIPART POST] Exception: $e');
// //     }
// //     return null;
// //   }

// //   // Popup Action 5: Update profile album (POST)
// //   Future<bool> updateProfileAlbum(String albumId, String name, String password) async {
// //     final url = '$baseUrl/user/update_profile_album';
// //     final body = _injectTokenToBody({
// //       'album_id': albumId,
// //       'album_name': name,
// //       'album_password': password,
// //     });
// //     debugPrint('➡️ [API POST] Request: $url');
// //     debugPrint('➡️ [API POST] Body: $body');
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: _headers,
// //         body: body,
// //       );
// //       debugPrint('⬅️ [API POST] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         return decoded['status'] == '200';
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API POST] Exception: $e');
// //     }
// //     return false;
// //   }

// //   // 6. Delete album (POST)
// //   Future<bool> deleteAlbum(String albumId) async {
// //     final url = '$baseUrl/user/delete_album';
// //     final body = _injectTokenToBody({'album_id': albumId});
// //     debugPrint('➡️ [API POST] Request: $url');
// //     debugPrint('➡️ [API POST] Body: $body');
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: _headers,
// //         body: body,
// //       );
// //       debugPrint('⬅️ [API POST] Response (${response.statusCode}): ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         return decoded['status'] == '200';
// //       }
// //     } catch (e) {
// //       debugPrint('❌ [API POST] Exception: $e');
// //     }
// //     return false;
// //   }
// // }

// // // ==========================================
// // // 4. RIVERPOD PROVIDERS
// // // ==========================================

// // final albumServiceProvider = Provider<AlbumService>((ref) => AlbumService(ref));

// // // State provider for active toggles (true = Approved, false = Pending)
// // final albumTabProvider = StateProvider<bool>((ref) => true);

// // class AlbumsNotifier extends StateNotifier<AsyncValue<List<AlbumModel>>> {
// //   final AlbumService _service;

// //   AlbumsNotifier(this._service) : super(const AsyncValue.loading()) {
// //     fetchAlbums();
// //   }

// //   Future<void> fetchAlbums() async {
// //     state = const AsyncValue.loading();
// //     try {
// //       final list = await _service.getAllAlbums();
// //       state = AsyncValue.data(list);
// //     } catch (e, stack) {
// //       state = AsyncValue.error(e, stack);
// //     }
// //   }

// //   Future<bool> createAlbum(String name, String password) async {
// //     try {
// //       final success = await _service.createProfileAlbum(name, password);
// //       if (success) {
// //         await fetchAlbums();
// //       }
// //       return success;
// //     } catch (e) {
// //       return false;
// //     }
// //   }

// //   Future<bool> updateAlbum(String id, String name, String password) async {
// //     try {
// //       final success = await _service.updateProfileAlbum(id, name, password);
// //       if (success) {
// //         await fetchAlbums();
// //       }
// //       return success;
// //     } catch (e) {
// //       return false;
// //     }
// //   }

// //   Future<bool> deleteAlbum(String id) async {
// //     try {
// //       final success = await _service.deleteAlbum(id);
// //       if (success) {
// //         await fetchAlbums();
// //       }
// //       return success;
// //     } catch (e) {
// //       return false;
// //     }
// //   }
// // }

// // final albumsProvider = StateNotifierProvider<AlbumsNotifier, AsyncValue<List<AlbumModel>>>((ref) {
// //   return AlbumsNotifier(ref.watch(albumServiceProvider));
// // });

// // final approvedAlbumsProvider = Provider<List<AlbumModel>>((ref) {
// //   final state = ref.watch(albumsProvider);
// //   return state.maybeWhen(
// //     data: (list) => list.where((album) => album.status == '1').toList(),
// //     orElse: () => [],
// //   );
// // });

// // final pendingAlbumsProvider = Provider<List<AlbumModel>>((ref) {
// //   final state = ref.watch(albumsProvider);
// //   return state.maybeWhen(
// //     data: (list) => list.where((album) => album.status != '1').toList(),
// //     orElse: () => [],
// //   );
// // });

// // // ==========================================
// // // 5. MAIN WIDGET: MyProfileAlbumTab
// // // ==========================================

// // class MyProfileAlbumTab extends ConsumerWidget {
// //   const MyProfileAlbumTab({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final showApproved = ref.watch(albumTabProvider);
// //     final albumsState = ref.watch(albumsProvider);

// //     final approvedItems = ref.watch(approvedAlbumsProvider);
// //     final pendingItems = ref.watch(pendingAlbumsProvider);

// //     final currentList = showApproved ? approvedItems : pendingItems;

// //     final width = MediaQuery.of(context).size.width;
// //     final isCompact = width < 380;
// //     final cardWidth = isCompact ? width - 48 : 220.0;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         // Status toggle tabs (Approved / Pending)
// //         _buildStatusTabs(context, ref, showApproved),
// //         const SizedBox(height: 16),

// //         // Quality Info Strip
// //         if (showApproved) ...[
// //           _buildInfoStrip(),
// //           const SizedBox(height: 16),
// //         ],

// //         // Section Title & Action
// //         Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 'Your Private\nAlbums',
// //                 style: TextStyle(
// //                   fontSize: isCompact ? 26 : 30,
// //                   fontWeight: FontWeight.w800,
// //                   color: const Color(0xFF19001F),
// //                   height: 1.1,
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               ElevatedButton.icon(
// //                 onPressed: () => _showAddAlbumDialog(context, ref),
// //                 icon: const Icon(Icons.create_new_folder_outlined, size: 18),
// //                 label: const Text(
// //                   'Create Album',
// //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// //                 ),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFF220027),
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(22),
// //                   ),
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 20,
// //                     vertical: 12,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(height: 20),

// //         // Albums list or state rendering
// //         albumsState.when(
// //           loading: () => const Center(
// //             child: Padding(
// //               padding: EdgeInsets.all(40.0),
// //               child: CircularProgressIndicator(
// //                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// //               ),
// //             ),
// //           ),
// //           error: (error, _) => Center(
// //             child: Padding(
// //               padding: const EdgeInsets.all(24.0),
// //               child: Column(
// //                 children: [
// //                   const Icon(Icons.error_outline, color: Colors.red, size: 40),
// //                   const SizedBox(height: 10),
// //                   Text('Error loading albums: $error'),
// //                   TextButton(
// //                     onPressed: () => ref.read(albumsProvider.notifier).fetchAlbums(),
// //                     child: const Text('Retry'),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           data: (_) {
// //             if (currentList.isEmpty) {
// //               return Center(
// //                 child: Padding(
// //                   padding: const EdgeInsets.symmetric(vertical: 48.0),
// //                   child: Text(
// //                     showApproved ? 'No approved albums found.' : 'No pending albums found.',
// //                     style: TextStyle(color: Colors.grey[600], fontSize: 16),
// //                   ),
// //                 ),
// //               );
// //             }

// //             return Wrap(
// //               spacing: 16,
// //               runSpacing: 16,
// //               children: currentList
// //                   .map((item) => _buildAlbumCard(context, ref, item, cardWidth))
// //                   .toList(),
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   // Approved vs Pending toggle
// //   Widget _buildStatusTabs(BuildContext context, WidgetRef ref, bool showApproved) {
// //     return Container(
// //       height: 44,
// //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(22),
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: _buildPillTab(
// //               label: 'Approved',
// //               selected: showApproved,
// //               onTap: () => ref.read(albumTabProvider.notifier).state = true,
// //             ),
// //           ),
// //           Expanded(
// //             child: _buildPillTab(
// //               label: 'Pending',
// //               selected: !showApproved,
// //               onTap: () => ref.read(albumTabProvider.notifier).state = false,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildPillTab({
// //     required String label,
// //     required bool selected,
// //     required VoidCallback onTap,
// //   }) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(18),
// //       child: Container(
// //         alignment: Alignment.center,
// //         decoration: BoxDecoration(
// //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// //           borderRadius: BorderRadius.circular(18),
// //         ),
// //         child: Text(
// //           label,
// //           style: const TextStyle(
// //             color: Colors.white,
// //             fontSize: 12,
// //             fontWeight: FontWeight.w700,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInfoStrip() {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: const Color(0xFF2D1935)),
// //         color: const Color(0xFFFDF8FD),
// //       ),
// //       child: const Row(
// //         children: [
// //           Icon(Icons.collections_outlined, size: 18, color: Color(0xFF490040)),
// //           SizedBox(width: 10),
// //           Expanded(
// //             child: Text(
// //               'Only high-quality album photos are approved. Avoid contact info in images.',
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w600,
// //                 color: Color(0xFF490040),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Individual Album Card layout
// //   Widget _buildAlbumCard(
// //     BuildContext context,
// //     WidgetRef ref,
// //     AlbumModel item,
// //     double cardWidth,
// //   ) {
// //     return Container(
// //       width: cardWidth,
// //       height: 250,
// //       decoration: BoxDecoration(
// //         color: const Color(0xFF2E3539), // Slate grey background
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.15),
// //             blurRadius: 8,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         children: [
// //           // Card Header: Title & Edit pencil
// //           Container(
// //             height: 42,
// //             padding: const EdgeInsets.symmetric(horizontal: 12),
// //             decoration: const BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [Color(0xFF19001F), Color(0xFF490040)],
// //               ),
// //               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
// //             ),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: Text(
// //                     item.albumName,
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 GestureDetector(
// //                   onTapDown: (details) => _showCardPopupMenu(context, ref, item, details.globalPosition),
// //                   child: const Padding(
// //                     padding: EdgeInsets.all(4.0),
// //                     child: Icon(
// //                       Icons.edit_outlined,
// //                       size: 18,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           // Card Body: Centered Private Lock Icon
// //           Expanded(
// //             child: Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(
// //                     Icons.lock_outline,
// //                     size: 64,
// //                     color: Colors.white.withOpacity(0.4),
// //                   ),
// //                   if (item.status != '1') ...[
// //                     const SizedBox(height: 8),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFFFF2D87).withOpacity(0.2),
// //                         borderRadius: BorderRadius.circular(4),
// //                         border: Border.all(color: const Color(0xFFFF2D87), width: 0.5),
// //                       ),
// //                       child: const Text(
// //                         'PENDING',
// //                         style: TextStyle(
// //                           color: Color(0xFFFF2D87),
// //                           fontSize: 9,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Precise popup menu overlay positioning
// //   void _showCardPopupMenu(
// //     BuildContext context,
// //     WidgetRef ref,
// //     AlbumModel item,
// //     Offset position,
// //   ) async {
// //     final result = await showMenu<String>(
// //       context: context,
// //       position: RelativeRect.fromLTRB(position.dx - 100, position.dy, position.dx, position.dy + 100),
// //       color: Colors.white,
// //       elevation: 8,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(8),
// //         side: const BorderSide(color: Color(0xFFE0E0E0)),
// //       ),
// //       items: [
// //         const PopupMenuItem<String>(
// //           value: 'add_photo',
// //           child: Text('Add Photo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// //         ),
// //         const PopupMenuItem<String>(
// //           value: 'add_video',
// //           child: Text('Add Video', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// //         ),
// //         const PopupMenuItem<String>(
// //           value: 'name_password',
// //           child: Text('Name & Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// //         ),
// //         const PopupMenuItem<String>(
// //           value: 'view',
// //           child: Text('View', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// //         ),
// //         const PopupMenuItem<String>(
// //           value: 'delete',
// //           child: Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
// //         ),
// //       ],
// //     );

// //     if (result == null) return;

// //     switch (result) {
// //       case 'add_photo':
// //         _handlePopupAddPhoto(context, ref, item);
// //         break;
// //       case 'add_video':
// //         _handlePopupAddVideo(context, ref, item);
// //         break;
// //       case 'name_password':
// //         _handlePopupNamePassword(context, ref, item);
// //         break;
// //       case 'view':
// //         _handlePopupView(context, ref, item);
// //         break;
// //       case 'delete':
// //         _handlePopupDelete(context, ref, item);
// //         break;
// //     }
// //   }

// //   // ==========================================
// //   // 5. POPUP OPTION HANDLERS
// //   // ==========================================

// //   // Add Photo: Picker -> Base64 -> Multiple Image Upload -> Link to Album ID -> Refetch
// //   Future<void> _handlePopupAddPhoto(BuildContext context, WidgetRef ref, AlbumModel item) async {
// //     final source = await _chooseMediaSource(context, isVideo: false);
// //     if (source == null) return;

// //     final pickedFile = await ImagePicker().pickImage(
// //       source: source,
// //       imageQuality: 85,
// //     );
// //     if (pickedFile == null) return;

// //     final navigator = Navigator.of(context);
// //     _showLoadingOverlay(context);

// //     try {
// //       final bytes = await pickedFile.readAsBytes();
// //       final base64Str = base64Encode(bytes);
// //       final ext = pickedFile.path.split('.').last.toLowerCase();
// //       final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
// //       final dataUri = 'data:$mimeType;base64,$base64Str';

// //       final service = ref.read(albumServiceProvider);
// //       final imageName = await service.uploadImageMultiple(dataUri);

// //       if (imageName != null) {
// //         final success = await service.linkImageToAlbum(imageName, item.id);
// //         navigator.pop(); // Dismiss loader safely using captured navigator reference

// //         if (success) {
// //           _showSnackBar(context, 'Photo uploaded and linked to album successfully.');
// //           ref.read(albumsProvider.notifier).fetchAlbums();
// //         } else {
// //           _showSnackBar(context, 'Photo uploaded but link failed.');
// //         }
// //       } else {
// //         navigator.pop(); // Dismiss loader safely using captured navigator reference
// //         _showSnackBar(context, 'Failed to upload photo.');
// //       }
// //     } catch (e) {
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// //       _showSnackBar(context, 'Error uploading photo: $e');
// //     }
// //   }

// //   // Add Video: Pick -> Multipart Video Upload -> Refetch
// //   Future<void> _handlePopupAddVideo(BuildContext context, WidgetRef ref, AlbumModel item) async {
// //     final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
// //     if (pickedFile == null) return;

// //     final navigator = Navigator.of(context);
// //     _showLoadingOverlay(context);

// //     try {
// //       final service = ref.read(albumServiceProvider);
// //       final fileName = await service.uploadVideo(File(pickedFile.path));
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// //       if (fileName != null) {
// //         _showSnackBar(context, 'Video uploaded successfully.');
// //         ref.read(albumsProvider.notifier).fetchAlbums();
// //       } else {
// //         _showSnackBar(context, 'Failed to upload video.');
// //       }
// //     } catch (e) {
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// //       _showSnackBar(context, 'Error uploading video: $e');
// //     }
// //   }

// //   // Name & Password: Fetch details -> Prefill custom Dialog -> Update -> Refetch
// //   Future<void> _handlePopupNamePassword(BuildContext context, WidgetRef ref, AlbumModel item) async {
// //     final navigator = Navigator.of(context);
// //     _showLoadingOverlay(context);

// //     try {
// //       final service = ref.read(albumServiceProvider);
// //       final details = await service.getAlbumDetails(item.id);
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// //       if (details != null) {
// //         _showAddAlbumDialog(context, ref, editDetails: details);
// //       } else {
// //         _showSnackBar(context, 'Failed to load album details.');
// //       }
// //     } catch (e) {
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// //       _showSnackBar(context, 'Error: $e');
// //     }
// //   }

// //   // View: Fetch images for this album -> Render elegant bottom sheet
// //   Future<void> _handlePopupView(BuildContext context, WidgetRef ref, AlbumModel item) async {
// //     final navigator = Navigator.of(context);
// //     _showLoadingOverlay(context);

// //     try {
// //       final service = ref.read(albumServiceProvider);
// //       final images = await service.getAlbumImages(item.id);
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// //       if (images.isEmpty) {
// //         _showSnackBar(context, 'No images found in this album.');
// //         return;
// //       }

// //       showModalBottomSheet(
// //         context: context,
// //         isScrollControlled: true,
// //         backgroundColor: Colors.black87,
// //         shape: const RoundedRectangleBorder(
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //         ),
// //         builder: (context) {
// //           return DraggableScrollableSheet(
// //             expand: false,
// //             initialChildSize: 0.6,
// //             maxChildSize: 0.9,
// //             builder: (context, scrollController) {
// //               return Column(
// //                 children: [
// //                   const SizedBox(height: 12),
// //                   Container(
// //                     width: 40,
// //                     height: 5,
// //                     decoration: BoxDecoration(
// //                       color: Colors.white24,
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                   const Padding(
// //                     padding: EdgeInsets.all(16.0),
// //                     child: Text(
// //                       'Album Photos',
// //                       style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //                     ),
// //                   ),
// //                   Expanded(
// //                     child: GridView.builder(
// //                       controller: scrollController,
// //                       padding: const EdgeInsets.all(16),
// //                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                         crossAxisCount: 3,
// //                         crossAxisSpacing: 10,
// //                         mainAxisSpacing: 10,
// //                       ),
// //                       itemCount: images.length,
// //                       itemBuilder: (context, index) {
// //                         return ClipRRect(
// //                           borderRadius: BorderRadius.circular(8),
// //                           child: Image.network(
// //                             images[index].image,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (_, __, ___) => Container(
// //                               color: Colors.grey[800],
// //                               child: const Icon(Icons.image_not_supported, color: Colors.white38),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               );
// //             },
// //           );
// //         },
// //       );
// //     } catch (e) {
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// //       _showSnackBar(context, 'Error retrieving images: $e');
// //     }
// //   }

// //   // Delete Album: Confirms -> Deletes -> Refetch
// //   Future<void> _handlePopupDelete(BuildContext context, WidgetRef ref, AlbumModel item) async {
// //     final confirm = await showDialog<bool>(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: const Text('Delete Album'),
// //           content: Text('Are you sure you want to delete the album "${item.albumName}"?'),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context, false),
// //               child: const Text('Cancel'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () => Navigator.pop(context, true),
// //               style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
// //               child: const Text('Delete', style: TextStyle(color: Colors.white)),
// //             ),
// //           ],
// //         );
// //       },
// //     );

// //     if (confirm != true) return;

// //     final navigator = Navigator.of(context);
// //     _showLoadingOverlay(context);

// //     try {
// //       final success = await ref.read(albumsProvider.notifier).deleteAlbum(item.id);
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// //       if (success) {
// //         _showSnackBar(context, 'Album deleted successfully.');
// //       } else {
// //         _showSnackBar(context, 'Failed to delete album.');
// //       }
// //     } catch (e) {
// //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// //       _showSnackBar(context, 'Error deleting album: $e');
// //     }
// //   }

// //   // ==========================================
// //   // 6. HELPER OVERLAYS AND DIALOGS
// //   // ==========================================

// //   Future<ImageSource?> _chooseMediaSource(BuildContext context, {required bool isVideo}) async {
// //     return showModalBottomSheet<ImageSource>(
// //       context: context,
// //       builder: (context) {
// //         return SafeArea(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ListTile(
// //                 leading: const Icon(Icons.photo_library_outlined),
// //                 title: const Text('Choose from Gallery'),
// //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// //               ),
// //               if (!isVideo)
// //                 ListTile(
// //                   leading: const Icon(Icons.camera_alt_outlined),
// //                   title: const Text('Take Photo'),
// //                   onTap: () => Navigator.pop(context, ImageSource.camera),
// //                 ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   void _showLoadingOverlay(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => const Center(
// //         child: CircularProgressIndicator(
// //           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// //         ),
// //       ),
// //     );
// //   }

// //   // Edit / Add Album Form Dialog (Matches third screenshot perfectly and handles async safely)
// //   void _showAddAlbumDialog(
// //     BuildContext context,
// //     WidgetRef ref, {
// //     AlbumDetailsModel? editDetails,
// //   }) {
// //     final nameController = TextEditingController(text: editDetails?.albumName ?? '');
// //     final passwordController = TextEditingController(text: editDetails?.albumPassword ?? '');
// //     final isEditing = editDetails != null;

// //     showDialog(
// //       context: context,
// //       barrierDismissible: true,
// //       builder: (dialogContext) {
// //         bool isLoading = false;

// //         return StatefulBuilder(
// //           builder: (context, setState) {
// //             return Dialog(
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// //                   children: [
// //                     // Header Bar (Matches design exactly)
// //                     Container(
// //                       height: 52,
// //                       padding: const EdgeInsets.symmetric(horizontal: 16),
// //                       decoration: const BoxDecoration(
// //                         gradient: LinearGradient(
// //                           colors: [Color(0xFF19001F), Color(0xFF490040)],
// //                         ),
// //                         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           const Icon(Icons.create_new_folder_outlined, color: Colors.white, size: 22),
// //                           const SizedBox(width: 8),
// //                           Text(
// //                             isEditing ? 'Edit Album' : 'Add Album',
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                           const Spacer(),
// //                           if (!isLoading)
// //                             IconButton(
// //                               onPressed: () => Navigator.pop(dialogContext),
// //                               icon: const Icon(Icons.close, color: Colors.white, size: 20),
// //                               padding: EdgeInsets.zero,
// //                               constraints: const BoxConstraints(),
// //                             ),
// //                         ],
// //                       ),
// //                     ),

// //                     // Form Textfields
// //                     Padding(
// //                       padding: const EdgeInsets.all(20.0),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           const Text(
// //                             'Album Name',
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.black87,
// //                               fontSize: 14,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 8),
// //                           TextField(
// //                             controller: nameController,
// //                             enabled: !isLoading,
// //                             decoration: InputDecoration(
// //                               hintText: 'Enter album name',
// //                               fillColor: const Color(0xFFF2F4F7),
// //                               filled: true,
// //                               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //                               border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 borderSide: BorderSide(color: Colors.grey.shade300),
// //                               ),
// //                               enabledBorder: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 borderSide: BorderSide(color: Colors.grey.shade300),
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 16),
// //                           const Text(
// //                             'Album Password',
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.black87,
// //                               fontSize: 14,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 8),
// //                           TextField(
// //                             controller: passwordController,
// //                             enabled: !isLoading,
// //                             obscureText: false, // Visible text matching screenshot
// //                             decoration: InputDecoration(
// //                               hintText: 'Enter password',
// //                               fillColor: const Color(0xFFF2F4F7),
// //                               filled: true,
// //                               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //                               border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 borderSide: BorderSide(color: Colors.grey.shade300),
// //                               ),
// //                               enabledBorder: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 borderSide: BorderSide(color: Colors.grey.shade300),
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 24),

// //                           // Save Button or Loading Spinner
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.end,
// //                             children: [
// //                               if (isLoading)
// //                                 const Padding(
// //                                   padding: EdgeInsets.symmetric(horizontal: 24.0),
// //                                   child: CircularProgressIndicator(
// //                                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// //                                   ),
// //                                 )
// //                               else
// //                                 ElevatedButton(
// //                                   onPressed: () async {
// //                                     final name = nameController.text.trim();
// //                                     final password = passwordController.text.trim();

// //                                     if (name.isEmpty || password.isEmpty) {
// //                                       _showSnackBar(dialogContext, 'Please enter both name and password.');
// //                                       return;
// //                                     }

// //                                     setState(() {
// //                                       isLoading = true;
// //                                     });

// //                                     bool success;
// //                                     try {
// //                                       if (isEditing) {
// //                                         success = await ref
// //                                             .read(albumsProvider.notifier)
// //                                             .updateAlbum(editDetails.id, name, password);
// //                                       } else {
// //                                         success = await ref
// //                                             .read(albumsProvider.notifier)
// //                                             .createAlbum(name, password);
// //                                       }
// //                                     } catch (_) {
// //                                       success = false;
// //                                     }

// //                                     if (success) {
// //                                       Navigator.pop(dialogContext); // Safely close the dialog
// //                                       _showSnackBar(
// //                                         context, // Show on parent context safely
// //                                         isEditing
// //                                             ? 'Album updated successfully!'
// //                                             : 'Album created successfully!',
// //                                       );
// //                                     } else {
// //                                       setState(() {
// //                                         isLoading = false;
// //                                       });
// //                                       _showSnackBar(dialogContext, 'Failed to save album.');
// //                                     }
// //                                   },
// //                                   style: ElevatedButton.styleFrom(
// //                                     backgroundColor: const Color(0xFF220027),
// //                                     foregroundColor: Colors.white,
// //                                     shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(8),
// //                                     ),
// //                                     padding: const EdgeInsets.symmetric(
// //                                       horizontal: 24,
// //                                       vertical: 12,
// //                                     ),
// //                                   ),
// //                                   child: const Text(
// //                                     'Save',
// //                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// //                                   ),
// //                                 ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   void _showSnackBar(BuildContext context, String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         duration: const Duration(seconds: 3),
// //       ),
// //     );
// //   }
// // }


// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:http/http.dart' as http;

// // // // ==========================================
// // // // 1. AUTHENTICATION TOKEN PROVIDER
// // // // ==========================================
// // // // ⚠️ REPLACE THIS with your actual app's session or login token provider.
// // // // E.g., if you have a shared authStateProvider, you can write:
// // // // final tokenProvider = Provider<String?>((ref) => ref.watch(authStateProvider).token);
// // // final tokenProvider = Provider<String?>((ref) {
// // //   // TODO: Link this to your actual authorization/session token string.
// // //   return 'YOUR_ACTUAL_USER_TOKEN_HERE';
// // // });

// // // // ==========================================
// // // // 2. DATA MODELS
// // // // ==========================================

// // // class AlbumModel {
// // //   final String id;
// // //   final String albumName;
// // //   final String albumPassword;
// // //   final String image;
// // //   final String status; // "1" for Approved, otherwise Pending

// // //   AlbumModel({
// // //     required this.id,
// // //     required this.albumName,
// // //     required this.albumPassword,
// // //     required this.image,
// // //     required this.status,
// // //   });

// // //   factory AlbumModel.fromJson(Map<String, dynamic> json) {
// // //     return AlbumModel(
// // //       id: json['id']?.toString() ?? '',
// // //       albumName: json['album_name']?.toString() ?? '',
// // //       albumPassword: json['album_password']?.toString() ?? '',
// // //       image: json['image']?.toString() ?? '',
// // //       status: json['status']?.toString() ?? '1',
// // //     );
// // //   }
// // // }

// // // class AlbumImageModel {
// // //   final String id;
// // //   final String albumId;
// // //   final String image;

// // //   AlbumImageModel({
// // //     required this.id,
// // //     required this.albumId,
// // //     required this.image,
// // //   });

// // //   factory AlbumImageModel.fromJson(Map<String, dynamic> json) {
// // //     return AlbumImageModel(
// // //       id: json['id']?.toString() ?? '',
// // //       albumId: json['album_id']?.toString() ?? '',
// // //       image: json['image']?.toString() ?? '',
// // //     );
// // //   }
// // // }

// // // class AlbumDetailsModel {
// // //   final String id;
// // //   final String albumName;
// // //   final String albumPassword;

// // //   AlbumDetailsModel({
// // //     required this.id,
// // //     required this.albumName,
// // //     required this.albumPassword,
// // //   });

// // //   factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
// // //     return AlbumDetailsModel(
// // //       id: json['id']?.toString() ?? '',
// // //       albumName: json['album_name']?.toString() ?? '',
// // //       albumPassword: json['album_password']?.toString() ?? '',
// // //     );
// // //   }
// // // }

// // // // ==========================================
// // // // 3. BULLETPROOF API SERVICE
// // // // ==========================================

// // // class AlbumService {
// // //   final Ref _ref;
// // //   static const String baseUrl = 'https://app.beatflirtevent.com/App';

// // //   AlbumService(this._ref);

// // //   // Retrieve latest token value from the provider
// // //   String? get _token => _ref.read(tokenProvider);

// // //   // Auto-generate standard HTTP headers with Bearer & Token keys
// // //   Map<String, String> get _headers {
// // //     final tokenVal = _token ?? '';
// // //     return {
// // //       'token': tokenVal,
// // //       'Token': tokenVal,
// // //       'Authorization': 'Bearer $tokenVal',
// // //     };
// // //   }

// // //   // Auto-inject token into POST form bodies as an extra safeguard
// // //   Map<String, String> _injectTokenToBody(Map<String, String> body) {
// // //     final tokenVal = _token;
// // //     if (tokenVal != null && tokenVal.isNotEmpty) {
// // //       return {
// // //         ...body,
// // //         'token': tokenVal,
// // //         'Token': tokenVal,
// // //       };
// // //     }
// // //     return body;
// // //   }

// // //   // Append token to GET query parameters
// // //   Uri _buildGetUri(String path) {
// // //     final tokenVal = _token;
// // //     final baseUri = Uri.parse('$baseUrl$path');
// // //     if (tokenVal != null && tokenVal.isNotEmpty) {
// // //       return baseUri.replace(
// // //         queryParameters: {
// // //           ...baseUri.queryParameters,
// // //           'token': tokenVal,
// // //           'Token': tokenVal,
// // //         },
// // //       );
// // //     }
// // //     return baseUri;
// // //   }

// // //   // 1. Get all albums (GET)
// // //   Future<List<AlbumModel>> getAllAlbums() async {
// // //     try {
// // //       final response = await http.get(_buildGetUri('/user/get_all_album'), headers: _headers);
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // //           return (decoded['data'] as List)
// // //               .map((item) => AlbumModel.fromJson(item))
// // //               .toList();
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error fetching albums: $e');
// // //     }
// // //     return [];
// // //   }

// // //   // 2. Get all approved album images (GET)
// // //   Future<List<String>> getAllApprovedAlbumImages() async {
// // //     try {
// // //       final response = await http.get(_buildGetUri('/user/get_all_approve_album_image'), headers: _headers);
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // //           return (decoded['data'] as List).map((e) => e['image'].toString()).toList();
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error fetching approved images: $e');
// // //     }
// // //     return [];
// // //   }

// // //   // 3. Get all pending album images (GET)
// // //   Future<List<String>> getAllPendingAlbumImages() async {
// // //     try {
// // //       final response = await http.get(_buildGetUri('/user/get_all_pending_album_image'), headers: _headers);
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // //           return (decoded['data'] as List).map((e) => e['image'].toString()).toList();
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error fetching pending images: $e');
// // //     }
// // //     return [];
// // //   }

// // //   // 4 & View. Get album images for a specific album (POST)
// // //   Future<List<AlbumImageModel>> getAlbumImages(String albumId) async {
// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('$baseUrl/user/get_album_image'),
// // //         headers: _headers,
// // //         body: _injectTokenToBody({'album_id': albumId}),
// // //       );
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // //           return (decoded['data'] as List)
// // //               .map((item) => AlbumImageModel.fromJson(item))
// // //               .toList();
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error fetching album images: $e');
// // //     }
// // //     return [];
// // //   }

// // //   // 5. Create profile album (POST)
// // //   Future<bool> createProfileAlbum(String name, String password) async {
// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('$baseUrl/user/create_profile_album'),
// // //         headers: _headers,
// // //         body: _injectTokenToBody({
// // //           'album_name': name,
// // //           'album_password': password,
// // //         }),
// // //       );
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         return decoded['status'] == '200';
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error creating album: $e');
// // //     }
// // //     return false;
// // //   }

// // //   // Popup Action 1: Upload image base64 (POST)
// // //   Future<String?> uploadImageMultiple(String base64Image) async {
// // //     try {
// // //       // Create JSON payload with image array and inject token directly
// // //       final payload = {
// // //         'image': [
// // //           {'image': base64Image}
// // //         ],
// // //         if (_token != null && _token!.isNotEmpty) 'token': _token!,
// // //       };

// // //       final response = await http.post(
// // //         Uri.parse('$baseUrl/upload/imageuploadMultiple'),
// // //         headers: {
// // //           'Content-Type': 'application/json',
// // //           ..._headers,
// // //         },
// // //         body: jsonEncode(payload),
// // //       );
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         if (decoded['status'] == '200' && decoded['data'] is List && decoded['data'].isNotEmpty) {
// // //           return decoded['data'][0]['image_name']?.toString();
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error uploading image base64: $e');
// // //     }
// // //     return null;
// // //   }

// // //   // Popup Action 2: Link image to album (POST)
// // //   Future<bool> linkImageToAlbum(String imageName, String albumId) async {
// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('$baseUrl/user/single_user_mutiple_album_image'),
// // //         headers: _headers,
// // //         body: _injectTokenToBody({
// // //           'image': imageName,
// // //           'album_id': albumId,
// // //         }),
// // //       );
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         return decoded['status'] == '200';
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error linking image to album: $e');
// // //     }
// // //     return false;
// // //   }

// // //   // Popup Action 3: Get album details (POST)
// // //   Future<AlbumDetailsModel?> getAlbumDetails(String albumId) async {
// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('$baseUrl/user/get_album_details'),
// // //         headers: _headers,
// // //         body: _injectTokenToBody({'album_id': albumId}),
// // //       );
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         if (decoded['status'] == '200' && decoded['data'] != null) {
// // //           return AlbumDetailsModel.fromJson(decoded['data']);
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error fetching album details: $e');
// // //     }
// // //     return null;
// // //   }

// // //   // Popup Action 4: Upload video binary (POST)
// // //   Future<String?> uploadVideo(File videoFile) async {
// // //     try {
// // //       final request = http.MultipartRequest(
// // //         'POST',
// // //         Uri.parse('$baseUrl/upload/video_upload'),
// // //       );
// // //       // Inject headers
// // //       _headers.forEach((key, val) {
// // //         request.headers[key] = val;
// // //       });
// // //       // Inject token inside multipart fields as well
// // //       if (_token != null && _token!.isNotEmpty) {
// // //         request.fields['token'] = _token!;
// // //         request.fields['Token'] = _token!;
// // //       }
// // //       request.files.add(
// // //         await http.MultipartFile.fromPath('video', videoFile.path),
// // //       );
// // //       final streamedResponse = await request.send();
// // //       final response = await http.Response.fromStream(streamedResponse);
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         if (decoded['status'] == '200' && decoded['data'] != null) {
// // //           return decoded['data']['file_name']?.toString();
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error uploading video: $e');
// // //     }
// // //     return null;
// // //   }

// // //   // Popup Action 5: Update profile album (POST)
// // //   Future<bool> updateProfileAlbum(String albumId, String name, String password) async {
// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('$baseUrl/user/update_profile_album'),
// // //         headers: _headers,
// // //         body: _injectTokenToBody({
// // //           'album_id': albumId,
// // //           'album_name': name,
// // //           'album_password': password,
// // //         }),
// // //       );
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         return decoded['status'] == '200';
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error updating album: $e');
// // //     }
// // //     return false;
// // //   }

// // //   // 6. Delete album (POST)
// // //   Future<bool> deleteAlbum(String albumId) async {
// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('$baseUrl/user/delete_album'),
// // //         headers: _headers,
// // //         body: _injectTokenToBody({'album_id': albumId}),
// // //       );
// // //       if (response.statusCode == 200) {
// // //         final decoded = jsonDecode(response.body);
// // //         return decoded['status'] == '200';
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error deleting album: $e');
// // //     }
// // //     return false;
// // //   }
// // // }

// // // // ==========================================
// // // // 4. RIVERPOD PROVIDERS
// // // // ==========================================

// // // final albumServiceProvider = Provider<AlbumService>((ref) => AlbumService(ref));

// // // // State provider for active toggles (true = Approved, false = Pending)
// // // final albumTabProvider = StateProvider<bool>((ref) => true);

// // // class AlbumsNotifier extends StateNotifier<AsyncValue<List<AlbumModel>>> {
// // //   final AlbumService _service;

// // //   AlbumsNotifier(this._service) : super(const AsyncValue.loading()) {
// // //     fetchAlbums();
// // //   }

// // //   Future<void> fetchAlbums() async {
// // //     state = const AsyncValue.loading();
// // //     try {
// // //       final list = await _service.getAllAlbums();
// // //       state = AsyncValue.data(list);
// // //     } catch (e, stack) {
// // //       state = AsyncValue.error(e, stack);
// // //     }
// // //   }

// // //   Future<bool> createAlbum(String name, String password) async {
// // //     try {
// // //       final success = await _service.createProfileAlbum(name, password);
// // //       if (success) {
// // //         await fetchAlbums();
// // //       }
// // //       return success;
// // //     } catch (e) {
// // //       return false;
// // //     }
// // //   }

// // //   Future<bool> updateAlbum(String id, String name, String password) async {
// // //     try {
// // //       final success = await _service.updateProfileAlbum(id, name, password);
// // //       if (success) {
// // //         await fetchAlbums();
// // //       }
// // //       return success;
// // //     } catch (e) {
// // //       return false;
// // //     }
// // //   }

// // //   Future<bool> deleteAlbum(String id) async {
// // //     try {
// // //       final success = await _service.deleteAlbum(id);
// // //       if (success) {
// // //         await fetchAlbums();
// // //       }
// // //       return success;
// // //     } catch (e) {
// // //       return false;
// // //     }
// // //   }
// // // }

// // // final albumsProvider = StateNotifierProvider<AlbumsNotifier, AsyncValue<List<AlbumModel>>>((ref) {
// // //   return AlbumsNotifier(ref.watch(albumServiceProvider));
// // // });

// // // final approvedAlbumsProvider = Provider<List<AlbumModel>>((ref) {
// // //   final state = ref.watch(albumsProvider);
// // //   return state.maybeWhen(
// // //     data: (list) => list.where((album) => album.status == '1').toList(),
// // //     orElse: () => [],
// // //   );
// // // });

// // // final pendingAlbumsProvider = Provider<List<AlbumModel>>((ref) {
// // //   final state = ref.watch(albumsProvider);
// // //   return state.maybeWhen(
// // //     data: (list) => list.where((album) => album.status != '1').toList(),
// // //     orElse: () => [],
// // //   );
// // // });

// // // // ==========================================
// // // // 5. MAIN WIDGET: MyProfileAlbumTab
// // // // ==========================================

// // // class MyProfileAlbumTab extends ConsumerWidget {
// // //   const MyProfileAlbumTab({super.key});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final showApproved = ref.watch(albumTabProvider);
// // //     final albumsState = ref.watch(albumsProvider);

// // //     final approvedItems = ref.watch(approvedAlbumsProvider);
// // //     final pendingItems = ref.watch(pendingAlbumsProvider);

// // //     final currentList = showApproved ? approvedItems : pendingItems;

// // //     final width = MediaQuery.of(context).size.width;
// // //     final isCompact = width < 380;
// // //     final cardWidth = isCompact ? width - 48 : 220.0;

// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         // Status toggle tabs (Approved / Pending)
// // //         _buildStatusTabs(context, ref, showApproved),
// // //         const SizedBox(height: 16),

// // //         // Quality Info Strip
// // //         if (showApproved) ...[
// // //           _buildInfoStrip(),
// // //           const SizedBox(height: 16),
// // //         ],

// // //         // Section Title & Action
// // //         Padding(
// // //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 'Your Private\nAlbums',
// // //                 style: TextStyle(
// // //                   fontSize: isCompact ? 26 : 30,
// // //                   fontWeight: FontWeight.w800,
// // //                   color: const Color(0xFF19001F),
// // //                   height: 1.1,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               ElevatedButton.icon(
// // //                 onPressed: () => _showAddAlbumDialog(context, ref),
// // //                 icon: const Icon(Icons.create_new_folder_outlined, size: 18),
// // //                 label: const Text(
// // //                   'Create Album',
// // //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// // //                 ),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: const Color(0xFF220027),
// // //                   foregroundColor: Colors.white,
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(22),
// // //                   ),
// // //                   padding: const EdgeInsets.symmetric(
// // //                     horizontal: 20,
// // //                     vertical: 12,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //         const SizedBox(height: 20),

// // //         // Albums list or state rendering
// // //         albumsState.when(
// // //           loading: () => const Center(
// // //             child: Padding(
// // //               padding: EdgeInsets.all(40.0),
// // //               child: CircularProgressIndicator(
// // //                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// // //               ),
// // //             ),
// // //           ),
// // //           error: (error, _) => Center(
// // //             child: Padding(
// // //               padding: const EdgeInsets.all(24.0),
// // //               child: Column(
// // //                 children: [
// // //                   const Icon(Icons.error_outline, color: Colors.red, size: 40),
// // //                   const SizedBox(height: 10),
// // //                   Text('Error loading albums: $error'),
// // //                   TextButton(
// // //                     onPressed: () => ref.read(albumsProvider.notifier).fetchAlbums(),
// // //                     child: const Text('Retry'),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           data: (_) {
// // //             if (currentList.isEmpty) {
// // //               return Center(
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.symmetric(vertical: 48.0),
// // //                   child: Text(
// // //                     showApproved ? 'No approved albums found.' : 'No pending albums found.',
// // //                     style: TextStyle(color: Colors.grey[600], fontSize: 16),
// // //                   ),
// // //                 ),
// // //               );
// // //             }

// // //             return Wrap(
// // //               spacing: 16,
// // //               runSpacing: 16,
// // //               children: currentList
// // //                   .map((item) => _buildAlbumCard(context, ref, item, cardWidth))
// // //                   .toList(),
// // //             );
// // //           },
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   // Approved vs Pending toggle
// // //   Widget _buildStatusTabs(BuildContext context, WidgetRef ref, bool showApproved) {
// // //     return Container(
// // //       height: 44,
// // //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
// // //       decoration: BoxDecoration(
// // //         borderRadius: BorderRadius.circular(22),
// // //         gradient: const LinearGradient(
// // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // //         ),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Expanded(
// // //             child: _buildPillTab(
// // //               label: 'Approved',
// // //               selected: showApproved,
// // //               onTap: () => ref.read(albumTabProvider.notifier).state = true,
// // //             ),
// // //           ),
// // //           Expanded(
// // //             child: _buildPillTab(
// // //               label: 'Pending',
// // //               selected: !showApproved,
// // //               onTap: () => ref.read(albumTabProvider.notifier).state = false,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildPillTab({
// // //     required String label,
// // //     required bool selected,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return InkWell(
// // //       onTap: onTap,
// // //       borderRadius: BorderRadius.circular(18),
// // //       child: Container(
// // //         alignment: Alignment.center,
// // //         decoration: BoxDecoration(
// // //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// // //           borderRadius: BorderRadius.circular(18),
// // //         ),
// // //         child: Text(
// // //           label,
// // //           style: const TextStyle(
// // //             color: Colors.white,
// // //             fontSize: 12,
// // //             fontWeight: FontWeight.w700,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildInfoStrip() {
// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// // //       decoration: BoxDecoration(
// // //         borderRadius: BorderRadius.circular(8),
// // //         border: Border.all(color: const Color(0xFF2D1935)),
// // //         color: const Color(0xFFFDF8FD),
// // //       ),
// // //       child: const Row(
// // //         children: [
// // //           Icon(Icons.collections_outlined, size: 18, color: Color(0xFF490040)),
// // //           SizedBox(width: 10),
// // //           Expanded(
// // //             child: Text(
// // //               'Only high-quality album photos are approved. Avoid contact info in images.',
// // //               style: TextStyle(
// // //                 fontSize: 12,
// // //                 fontWeight: FontWeight.w600,
// // //                 color: Color(0xFF490040),
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // Individual Album Card layout
// // //   Widget _buildAlbumCard(
// // //     BuildContext context,
// // //     WidgetRef ref,
// // //     AlbumModel item,
// // //     double cardWidth,
// // //   ) {
// // //     return Container(
// // //       width: cardWidth,
// // //       height: 250,
// // //       decoration: BoxDecoration(
// // //         color: const Color(0xFF2E3539), // Slate grey background
// // //         borderRadius: BorderRadius.circular(12),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withOpacity(0.15),
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 4),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.stretch,
// // //         children: [
// // //           // Card Header: Title & Edit pencil
// // //           Container(
// // //             height: 42,
// // //             padding: const EdgeInsets.symmetric(horizontal: 12),
// // //             decoration: const BoxDecoration(
// // //               gradient: LinearGradient(
// // //                 colors: [Color(0xFF19001F), Color(0xFF490040)],
// // //               ),
// // //               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: Text(
// // //                     item.albumName,
// // //                     maxLines: 1,
// // //                     overflow: TextOverflow.ellipsis,
// // //                     style: const TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 14,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 GestureDetector(
// // //                   onTapDown: (details) => _showCardPopupMenu(context, ref, item, details.globalPosition),
// // //                   child: const Padding(
// // //                     padding: EdgeInsets.all(4.0),
// // //                     child: Icon(
// // //                       Icons.edit_outlined,
// // //                       size: 18,
// // //                       color: Colors.white,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),

// // //           // Card Body: Centered Private Lock Icon
// // //           Expanded(
// // //             child: Center(
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   Icon(
// // //                     Icons.lock_outline,
// // //                     size: 64,
// // //                     color: Colors.white.withOpacity(0.4),
// // //                   ),
// // //                   if (item.status != '1') ...[
// // //                     const SizedBox(height: 8),
// // //                     Container(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// // //                       decoration: BoxDecoration(
// // //                         color: const Color(0xFFFF2D87).withOpacity(0.2),
// // //                         borderRadius: BorderRadius.circular(4),
// // //                         border: Border.all(color: const Color(0xFFFF2D87), width: 0.5),
// // //                       ),
// // //                       child: const Text(
// // //                         'PENDING',
// // //                         style: TextStyle(
// // //                           color: Color(0xFFFF2D87),
// // //                           fontSize: 9,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // Precise popup menu overlay positioning
// // //   void _showCardPopupMenu(
// // //     BuildContext context,
// // //     WidgetRef ref,
// // //     AlbumModel item,
// // //     Offset position,
// // //   ) async {
// // //     final result = await showMenu<String>(
// // //       context: context,
// // //       position: RelativeRect.fromLTRB(position.dx - 100, position.dy, position.dx, position.dy + 100),
// // //       color: Colors.white,
// // //       elevation: 8,
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(8),
// // //         side: const BorderSide(color: Color(0xFFE0E0E0)),
// // //       ),
// // //       items: [
// // //         const PopupMenuItem<String>(
// // //           value: 'add_photo',
// // //           child: Text('Add Photo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// // //         ),
// // //         const PopupMenuItem<String>(
// // //           value: 'add_video',
// // //           child: Text('Add Video', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// // //         ),
// // //         const PopupMenuItem<String>(
// // //           value: 'name_password',
// // //           child: Text('Name & Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// // //         ),
// // //         const PopupMenuItem<String>(
// // //           value: 'view',
// // //           child: Text('View', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// // //         ),
// // //         const PopupMenuItem<String>(
// // //           value: 'delete',
// // //           child: Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
// // //         ),
// // //       ],
// // //     );

// // //     if (result == null) return;

// // //     switch (result) {
// // //       case 'add_photo':
// // //         _handlePopupAddPhoto(context, ref, item);
// // //         break;
// // //       case 'add_video':
// // //         _handlePopupAddVideo(context, ref, item);
// // //         break;
// // //       case 'name_password':
// // //         _handlePopupNamePassword(context, ref, item);
// // //         break;
// // //       case 'view':
// // //         _handlePopupView(context, ref, item);
// // //         break;
// // //       case 'delete':
// // //         _handlePopupDelete(context, ref, item);
// // //         break;
// // //     }
// // //   }

// // //   // ==========================================
// // //   // 5. POPUP OPTION HANDLERS
// // //   // ==========================================

// // //   // Add Photo: Picker -> Base64 -> Multiple Image Upload -> Link to Album ID -> Refetch
// // //   Future<void> _handlePopupAddPhoto(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // //     final source = await _chooseMediaSource(context, isVideo: false);
// // //     if (source == null) return;

// // //     final pickedFile = await ImagePicker().pickImage(
// // //       source: source,
// // //       imageQuality: 85,
// // //     );
// // //     if (pickedFile == null) return;

// // //     final navigator = Navigator.of(context);
// // //     _showLoadingOverlay(context);

// // //     try {
// // //       final bytes = await pickedFile.readAsBytes();
// // //       final base64Str = base64Encode(bytes);
// // //       final ext = pickedFile.path.split('.').last.toLowerCase();
// // //       final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
// // //       final dataUri = 'data:$mimeType;base64,$base64Str';

// // //       final service = ref.read(albumServiceProvider);
// // //       final imageName = await service.uploadImageMultiple(dataUri);

// // //       if (imageName != null) {
// // //         final success = await service.linkImageToAlbum(imageName, item.id);
// // //         navigator.pop(); // Dismiss loader safely using captured navigator reference

// // //         if (success) {
// // //           _showSnackBar(context, 'Photo uploaded and linked to album successfully.');
// // //           ref.read(albumsProvider.notifier).fetchAlbums();
// // //         } else {
// // //           _showSnackBar(context, 'Photo uploaded but link failed.');
// // //         }
// // //       } else {
// // //         navigator.pop(); // Dismiss loader safely using captured navigator reference
// // //         _showSnackBar(context, 'Failed to upload photo.');
// // //       }
// // //     } catch (e) {
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // //       _showSnackBar(context, 'Error uploading photo: $e');
// // //     }
// // //   }

// // //   // Add Video: Pick -> Multipart Video Upload -> Refetch
// // //   Future<void> _handlePopupAddVideo(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // //     final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
// // //     if (pickedFile == null) return;

// // //     final navigator = Navigator.of(context);
// // //     _showLoadingOverlay(context);

// // //     try {
// // //       final service = ref.read(albumServiceProvider);
// // //       final fileName = await service.uploadVideo(File(pickedFile.path));
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// // //       if (fileName != null) {
// // //         _showSnackBar(context, 'Video uploaded successfully.');
// // //         ref.read(albumsProvider.notifier).fetchAlbums();
// // //       } else {
// // //         _showSnackBar(context, 'Failed to upload video.');
// // //       }
// // //     } catch (e) {
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // //       _showSnackBar(context, 'Error uploading video: $e');
// // //     }
// // //   }

// // //   // Name & Password: Fetch details -> Prefill custom Dialog -> Update -> Refetch
// // //   Future<void> _handlePopupNamePassword(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // //     final navigator = Navigator.of(context);
// // //     _showLoadingOverlay(context);

// // //     try {
// // //       final service = ref.read(albumServiceProvider);
// // //       final details = await service.getAlbumDetails(item.id);
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// // //       if (details != null) {
// // //         _showAddAlbumDialog(context, ref, editDetails: details);
// // //       } else {
// // //         _showSnackBar(context, 'Failed to load album details.');
// // //       }
// // //     } catch (e) {
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // //       _showSnackBar(context, 'Error: $e');
// // //     }
// // //   }

// // //   // View: Fetch images for this album -> Render elegant bottom sheet
// // //   Future<void> _handlePopupView(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // //     final navigator = Navigator.of(context);
// // //     _showLoadingOverlay(context);

// // //     try {
// // //       final service = ref.read(albumServiceProvider);
// // //       final images = await service.getAlbumImages(item.id);
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// // //       if (images.isEmpty) {
// // //         _showSnackBar(context, 'No images found in this album.');
// // //         return;
// // //       }

// // //       showModalBottomSheet(
// // //         context: context,
// // //         isScrollControlled: true,
// // //         backgroundColor: Colors.black87,
// // //         shape: const RoundedRectangleBorder(
// // //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // //         ),
// // //         builder: (context) {
// // //           return DraggableScrollableSheet(
// // //             expand: false,
// // //             initialChildSize: 0.6,
// // //             maxChildSize: 0.9,
// // //             builder: (context, scrollController) {
// // //               return Column(
// // //                 children: [
// // //                   const SizedBox(height: 12),
// // //                   Container(
// // //                     width: 40,
// // //                     height: 5,
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.white24,
// // //                       borderRadius: BorderRadius.circular(10),
// // //                     ),
// // //                   ),
// // //                   const Padding(
// // //                     padding: EdgeInsets.all(16.0),
// // //                     child: Text(
// // //                       'Album Photos',
// // //                       style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// // //                     ),
// // //                   ),
// // //                   Expanded(
// // //                     child: GridView.builder(
// // //                       controller: scrollController,
// // //                       padding: const EdgeInsets.all(16),
// // //                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //                         crossAxisCount: 3,
// // //                         crossAxisSpacing: 10,
// // //                         mainAxisSpacing: 10,
// // //                       ),
// // //                       itemCount: images.length,
// // //                       itemBuilder: (context, index) {
// // //                         return ClipRRect(
// // //                           borderRadius: BorderRadius.circular(8),
// // //                           child: Image.network(
// // //                             images[index].image,
// // //                             fit: BoxFit.cover,
// // //                             errorBuilder: (_, __, ___) => Container(
// // //                               color: Colors.grey[800],
// // //                               child: const Icon(Icons.image_not_supported, color: Colors.white38),
// // //                             ),
// // //                           ),
// // //                         );
// // //                       },
// // //                     ),
// // //                   ),
// // //                 ],
// // //               );
// // //             },
// // //           );
// // //         },
// // //       );
// // //     } catch (e) {
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // //       _showSnackBar(context, 'Error retrieving images: $e');
// // //     }
// // //   }

// // //   // Delete Album: Confirms -> Deletes -> Refetch
// // //   Future<void> _handlePopupDelete(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // //     final confirm = await showDialog<bool>(
// // //       context: context,
// // //       builder: (context) {
// // //         return AlertDialog(
// // //           title: const Text('Delete Album'),
// // //           content: Text('Are you sure you want to delete the album "${item.albumName}"?'),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context, false),
// // //               child: const Text('Cancel'),
// // //             ),
// // //             ElevatedButton(
// // //               onPressed: () => Navigator.pop(context, true),
// // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
// // //               child: const Text('Delete', style: TextStyle(color: Colors.white)),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );

// // //     if (confirm != true) return;

// // //     final navigator = Navigator.of(context);
// // //     _showLoadingOverlay(context);

// // //     try {
// // //       final success = await ref.read(albumsProvider.notifier).deleteAlbum(item.id);
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// // //       if (success) {
// // //         _showSnackBar(context, 'Album deleted successfully.');
// // //       } else {
// // //         _showSnackBar(context, 'Failed to delete album.');
// // //       }
// // //     } catch (e) {
// // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // //       _showSnackBar(context, 'Error deleting album: $e');
// // //     }
// // //   }

// // //   // ==========================================
// // //   // 6. HELPER OVERLAYS AND DIALOGS
// // //   // ==========================================

// // //   Future<ImageSource?> _chooseMediaSource(BuildContext context, {required bool isVideo}) async {
// // //     return showModalBottomSheet<ImageSource>(
// // //       context: context,
// // //       builder: (context) {
// // //         return SafeArea(
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               ListTile(
// // //                 leading: const Icon(Icons.photo_library_outlined),
// // //                 title: const Text('Choose from Gallery'),
// // //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// // //               ),
// // //               if (!isVideo)
// // //                 ListTile(
// // //                   leading: const Icon(Icons.camera_alt_outlined),
// // //                   title: const Text('Take Photo'),
// // //                   onTap: () => Navigator.pop(context, ImageSource.camera),
// // //                 ),
// // //             ],
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   void _showLoadingOverlay(BuildContext context) {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (context) => const Center(
// // //         child: CircularProgressIndicator(
// // //           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // Edit / Add Album Form Dialog (Matches third screenshot perfectly and handles async safely)
// // //   void _showAddAlbumDialog(
// // //     BuildContext context,
// // //     WidgetRef ref, {
// // //     AlbumDetailsModel? editDetails,
// // //   }) {
// // //     final nameController = TextEditingController(text: editDetails?.albumName ?? '');
// // //     final passwordController = TextEditingController(text: editDetails?.albumPassword ?? '');
// // //     final isEditing = editDetails != null;

// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: true,
// // //       builder: (dialogContext) {
// // //         bool isLoading = false;

// // //         return StatefulBuilder(
// // //           builder: (context, setState) {
// // //             return Dialog(
// // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //               child: SingleChildScrollView(
// // //                 child: Column(
// // //                   mainAxisSize: MainAxisSize.min,
// // //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                   children: [
// // //                     // Header Bar (Matches design exactly)
// // //                     Container(
// // //                       height: 52,
// // //                       padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                       decoration: const BoxDecoration(
// // //                         gradient: LinearGradient(
// // //                           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // //                         ),
// // //                         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
// // //                       ),
// // //                       child: Row(
// // //                         children: [
// // //                           const Icon(Icons.create_new_folder_outlined, color: Colors.white, size: 22),
// // //                           const SizedBox(width: 8),
// // //                           Text(
// // //                             isEditing ? 'Edit Album' : 'Add Album',
// // //                             style: const TextStyle(
// // //                               color: Colors.white,
// // //                               fontSize: 18,
// // //                               fontWeight: FontWeight.bold,
// // //                             ),
// // //                           ),
// // //                           const Spacer(),
// // //                           if (!isLoading)
// // //                             IconButton(
// // //                               onPressed: () => Navigator.pop(dialogContext),
// // //                               icon: const Icon(Icons.close, color: Colors.white, size: 20),
// // //                               padding: EdgeInsets.zero,
// // //                               constraints: const BoxConstraints(),
// // //                             ),
// // //                         ],
// // //                       ),
// // //                     ),

// // //                     // Form Textfields
// // //                     Padding(
// // //                       padding: const EdgeInsets.all(20.0),
// // //                       child: Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           const Text(
// // //                             'Album Name',
// // //                             style: TextStyle(
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.black87,
// // //                               fontSize: 14,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(height: 8),
// // //                           TextField(
// // //                             controller: nameController,
// // //                             enabled: !isLoading,
// // //                             decoration: InputDecoration(
// // //                               hintText: 'Enter album name',
// // //                               fillColor: const Color(0xFFF2F4F7),
// // //                               filled: true,
// // //                               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // //                               border: OutlineInputBorder(
// // //                                 borderRadius: BorderRadius.circular(8),
// // //                                 borderSide: BorderSide(color: Colors.grey.shade300),
// // //                               ),
// // //                               enabledBorder: OutlineInputBorder(
// // //                                 borderRadius: BorderRadius.circular(8),
// // //                                 borderSide: BorderSide(color: Colors.grey.shade300),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           const SizedBox(height: 16),
// // //                           const Text(
// // //                             'Album Password',
// // //                             style: TextStyle(
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.black87,
// // //                               fontSize: 14,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(height: 8),
// // //                           TextField(
// // //                             controller: passwordController,
// // //                             enabled: !isLoading,
// // //                             obscureText: false, // Visible text matching screenshot
// // //                             decoration: InputDecoration(
// // //                               hintText: 'Enter password',
// // //                               fillColor: const Color(0xFFF2F4F7),
// // //                               filled: true,
// // //                               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // //                               border: OutlineInputBorder(
// // //                                 borderRadius: BorderRadius.circular(8),
// // //                                 borderSide: BorderSide(color: Colors.grey.shade300),
// // //                               ),
// // //                               enabledBorder: OutlineInputBorder(
// // //                                 borderRadius: BorderRadius.circular(8),
// // //                                 borderSide: BorderSide(color: Colors.grey.shade300),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           const SizedBox(height: 24),

// // //                           // Save Button or Loading Spinner
// // //                           Row(
// // //                             mainAxisAlignment: MainAxisAlignment.end,
// // //                             children: [
// // //                               if (isLoading)
// // //                                 const Padding(
// // //                                   padding: EdgeInsets.symmetric(horizontal: 24.0),
// // //                                   child: CircularProgressIndicator(
// // //                                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// // //                                   ),
// // //                                 )
// // //                               else
// // //                                 ElevatedButton(
// // //                                   onPressed: () async {
// // //                                     final name = nameController.text.trim();
// // //                                     final password = passwordController.text.trim();

// // //                                     if (name.isEmpty || password.isEmpty) {
// // //                                       _showSnackBar(dialogContext, 'Please enter both name and password.');
// // //                                       return;
// // //                                     }

// // //                                     setState(() {
// // //                                       isLoading = true;
// // //                                     });

// // //                                     bool success;
// // //                                     try {
// // //                                       if (isEditing) {
// // //                                         success = await ref
// // //                                             .read(albumsProvider.notifier)
// // //                                             .updateAlbum(editDetails.id, name, password);
// // //                                       } else {
// // //                                         success = await ref
// // //                                             .read(albumsProvider.notifier)
// // //                                             .createAlbum(name, password);
// // //                                       }
// // //                                     } catch (_) {
// // //                                       success = false;
// // //                                     }

// // //                                     if (success) {
// // //                                       Navigator.pop(dialogContext); // Safely close the dialog
// // //                                       _showSnackBar(
// // //                                         context, // Show on parent context safely
// // //                                         isEditing
// // //                                             ? 'Album updated successfully!'
// // //                                             : 'Album created successfully!',
// // //                                       );
// // //                                     } else {
// // //                                       setState(() {
// // //                                         isLoading = false;
// // //                                       });
// // //                                       _showSnackBar(dialogContext, 'Failed to save album.');
// // //                                     }
// // //                                   },
// // //                                   style: ElevatedButton.styleFrom(
// // //                                     backgroundColor: const Color(0xFF220027),
// // //                                     foregroundColor: Colors.white,
// // //                                     shape: RoundedRectangleBorder(
// // //                                       borderRadius: BorderRadius.circular(8),
// // //                                     ),
// // //                                     padding: const EdgeInsets.symmetric(
// // //                                       horizontal: 24,
// // //                                       vertical: 12,
// // //                                     ),
// // //                                   ),
// // //                                   child: const Text(
// // //                                     'Save',
// // //                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// // //                                   ),
// // //                                 ),
// // //                             ],
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             );
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }

// // //   void _showSnackBar(BuildContext context, String message) {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: Text(message),
// // //         duration: const Duration(seconds: 3),
// // //       ),
// // //     );
// // //   }
// // // }


// // // // import 'dart:convert';
// // // // import 'dart:io';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_html/flutter_html.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:image_picker/image_picker.dart';
// // // // import 'package:http/http.dart' as http;

// // // // // ==========================================
// // // // // 1. DATA MODELS
// // // // // ==========================================

// // // // class AlbumModel {
// // // //   final String id;
// // // //   final String albumName;
// // // //   final String albumPassword;
// // // //   final String image;
// // // //   final String status; // "1" for Approved, otherwise Pending

// // // //   AlbumModel({
// // // //     required this.id,
// // // //     required this.albumName,
// // // //     required this.albumPassword,
// // // //     required this.image,
// // // //     required this.status,
// // // //   });

// // // //   factory AlbumModel.fromJson(Map<String, dynamic> json) {
// // // //     return AlbumModel(
// // // //       id: json['id']?.toString() ?? '',
// // // //       albumName: json['album_name']?.toString() ?? '',
// // // //       albumPassword: json['album_password']?.toString() ?? '',
// // // //       image: json['image']?.toString() ?? '',
// // // //       status: json['status']?.toString() ?? '1',
// // // //     );
// // // //   }
// // // // }

// // // // class AlbumImageModel {
// // // //   final String id;
// // // //   final String albumId;
// // // //   final String image;

// // // //   AlbumImageModel({
// // // //     required this.id,
// // // //     required this.albumId,
// // // //     required this.image,
// // // //   });

// // // //   factory AlbumImageModel.fromJson(Map<String, dynamic> json) {
// // // //     return AlbumImageModel(
// // // //       id: json['id']?.toString() ?? '',
// // // //       albumId: json['album_id']?.toString() ?? '',
// // // //       image: json['image']?.toString() ?? '',
// // // //     );
// // // //   }
// // // // }

// // // // class AlbumDetailsModel {
// // // //   final String id;
// // // //   final String albumName;
// // // //   final String albumPassword;

// // // //   AlbumDetailsModel({
// // // //     required this.id,
// // // //     required this.albumName,
// // // //     required this.albumPassword,
// // // //   });

// // // //   factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
// // // //     return AlbumDetailsModel(
// // // //       id: json['id']?.toString() ?? '',
// // // //       albumName: json['album_name']?.toString() ?? '',
// // // //       albumPassword: json['album_password']?.toString() ?? '',
// // // //     );
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 2. API SERVICE
// // // // // ==========================================

// // // // class AlbumService {
// // // //   static const String baseUrl = 'https://app.beatflirtevent.com/App';

// // // //   // 1. Get all albums (GET)
// // // //   Future<List<AlbumModel>> getAllAlbums() async {
// // // //     try {
// // // //       final response = await http.get(Uri.parse('$baseUrl/user/get_all_album'));
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // // //           return (decoded['data'] as List)
// // // //               .map((item) => AlbumModel.fromJson(item))
// // // //               .toList();
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error fetching albums: $e');
// // // //     }
// // // //     return [];
// // // //   }

// // // //   // 2. Get all approved album images (GET)
// // // //   Future<List<String>> getAllApprovedAlbumImages() async {
// // // //     try {
// // // //       final response = await http.get(
// // // //         Uri.parse('$baseUrl/user/get_all_approve_album_image'),
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // // //           return (decoded['data'] as List)
// // // //               .map((e) => e['image'].toString())
// // // //               .toList();
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error fetching approved images: $e');
// // // //     }
// // // //     return [];
// // // //   }

// // // //   // 3. Get all pending album images (GET)
// // // //   Future<List<String>> getAllPendingAlbumImages() async {
// // // //     try {
// // // //       final response = await http.get(
// // // //         Uri.parse('$baseUrl/user/get_all_pending_album_image'),
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // // //           return (decoded['data'] as List)
// // // //               .map((e) => e['image'].toString())
// // // //               .toList();
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error fetching pending images: $e');
// // // //     }
// // // //     return [];
// // // //   }

// // // //   // 4 & View. Get album images for a specific album (POST)
// // // //   Future<List<AlbumImageModel>> getAlbumImages(String albumId) async {
// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse('$baseUrl/user/get_album_image'),
// // // //         body: {'album_id': albumId},
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // // //           return (decoded['data'] as List)
// // // //               .map((item) => AlbumImageModel.fromJson(item))
// // // //               .toList();
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error fetching album images: $e');
// // // //     }
// // // //     return [];
// // // //   }

// // // //   // 5. Create profile album (POST)
// // // //   Future<bool> createProfileAlbum(String name, String password) async {
// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse('$baseUrl/user/create_profile_album'),
// // // //         body: {'album_name': name, 'album_password': password},
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         return decoded['status'] == '200';
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error creating album: $e');
// // // //     }
// // // //     return false;
// // // //   }

// // // //   // Popup Action 1: Upload image base64 (POST)
// // // //   Future<String?> uploadImageMultiple(String base64Image) async {
// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse('$baseUrl/upload/imageuploadMultiple'),
// // // //         headers: {'Content-Type': 'application/json'},
// // // //         body: jsonEncode({
// // // //           'image': [
// // // //             {'image': base64Image},
// // // //           ],
// // // //         }),
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         if (decoded['status'] == '200' &&
// // // //             decoded['data'] is List &&
// // // //             decoded['data'].isNotEmpty) {
// // // //           return decoded['data'][0]['image_name']?.toString();
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error uploading image base64: $e');
// // // //     }
// // // //     return null;
// // // //   }

// // // //   // Popup Action 2: Link image to album (POST)
// // // //   Future<bool> linkImageToAlbum(String imageName, String albumId) async {
// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse('$baseUrl/user/single_user_mutiple_album_image'),
// // // //         body: {'image': imageName, 'album_id': albumId},
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         return decoded['status'] == '200';
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error linking image to album: $e');
// // // //     }
// // // //     return false;
// // // //   }

// // // //   // Popup Action 3: Get album details (POST)
// // // //   Future<AlbumDetailsModel?> getAlbumDetails(String albumId) async {
// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse('$baseUrl/user/get_album_details'),
// // // //         body: {'album_id': albumId},
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         if (decoded['status'] == '200' && decoded['data'] != null) {
// // // //           return AlbumDetailsModel.fromJson(decoded['data']);
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error fetching album details: $e');
// // // //     }
// // // //     return null;
// // // //   }

// // // //   // Popup Action 4: Upload video binary (POST)
// // // //   Future<String?> uploadVideo(File videoFile) async {
// // // //     try {
// // // //       final request = http.MultipartRequest(
// // // //         'POST',
// // // //         Uri.parse('$baseUrl/upload/video_upload'),
// // // //       );
// // // //       request.files.add(
// // // //         await http.MultipartFile.fromPath('video', videoFile.path),
// // // //       );
// // // //       final streamedResponse = await request.send();
// // // //       final response = await http.Response.fromStream(streamedResponse);
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         if (decoded['status'] == '200' && decoded['data'] != null) {
// // // //           return decoded['data']['file_name']?.toString();
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error uploading video: $e');
// // // //     }
// // // //     return null;
// // // //   }

// // // //   // Popup Action 5: Update profile album (POST)
// // // //   Future<bool> updateProfileAlbum(
// // // //     String albumId,
// // // //     String name,
// // // //     String password,
// // // //   ) async {
// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse('$baseUrl/user/update_profile_album'),
// // // //         body: {
// // // //           'album_id': albumId,
// // // //           'album_name': name,
// // // //           'album_password': password,
// // // //         },
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         return decoded['status'] == '200';
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error updating album: $e');
// // // //     }
// // // //     return false;
// // // //   }

// // // //   // 6. Delete album (POST)
// // // //   Future<bool> deleteAlbum(String albumId) async {
// // // //     try {
// // // //       final response = await http.post(
// // // //         Uri.parse('$baseUrl/user/delete_album'),
// // // //         body: {'album_id': albumId},
// // // //       );
// // // //       if (response.statusCode == 200) {
// // // //         final decoded = jsonDecode(response.body);
// // // //         return decoded['status'] == '200';
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error deleting album: $e');
// // // //     }
// // // //     return false;
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 3. RIVERPOD PROVIDERS
// // // // // ==========================================

// // // // final albumServiceProvider = Provider<AlbumService>((ref) => AlbumService());

// // // // // State provider for active toggles (true = Approved, false = Pending)
// // // // final albumTabProvider = StateProvider<bool>((ref) => true);

// // // // class AlbumsNotifier extends StateNotifier<AsyncValue<List<AlbumModel>>> {
// // // //   final AlbumService _service;

// // // //   AlbumsNotifier(this._service) : super(const AsyncValue.loading()) {
// // // //     fetchAlbums();
// // // //   }

// // // //   Future<void> fetchAlbums() async {
// // // //     state = const AsyncValue.loading();
// // // //     try {
// // // //       final list = await _service.getAllAlbums();
// // // //       state = AsyncValue.data(list);
// // // //     } catch (e, stack) {
// // // //       state = AsyncValue.error(e, stack);
// // // //     }
// // // //   }

// // // //   Future<bool> createAlbum(String name, String password) async {
// // // //     try {
// // // //       final success = await _service.createProfileAlbum(name, password);
// // // //       if (success) {
// // // //         await fetchAlbums();
// // // //       }
// // // //       return success;
// // // //     } catch (e) {
// // // //       return false;
// // // //     }
// // // //   }

// // // //   Future<bool> updateAlbum(String id, String name, String password) async {
// // // //     try {
// // // //       final success = await _service.updateProfileAlbum(id, name, password);
// // // //       if (success) {
// // // //         await fetchAlbums();
// // // //       }
// // // //       return success;
// // // //     } catch (e) {
// // // //       return false;
// // // //     }
// // // //   }

// // // //   Future<bool> deleteAlbum(String id) async {
// // // //     try {
// // // //       final success = await _service.deleteAlbum(id);
// // // //       if (success) {
// // // //         await fetchAlbums();
// // // //       }
// // // //       return success;
// // // //     } catch (e) {
// // // //       return false;
// // // //     }
// // // //   }
// // // // }

// // // // final albumsProvider =
// // // //     StateNotifierProvider<AlbumsNotifier, AsyncValue<List<AlbumModel>>>((ref) {
// // // //       return AlbumsNotifier(ref.watch(albumServiceProvider));
// // // //     });

// // // // final approvedAlbumsProvider = Provider<List<AlbumModel>>((ref) {
// // // //   final state = ref.watch(albumsProvider);
// // // //   return state.maybeWhen(
// // // //     data: (list) => list.where((album) => album.status == '1').toList(),
// // // //     orElse: () => [],
// // // //   );
// // // // });

// // // // final pendingAlbumsProvider = Provider<List<AlbumModel>>((ref) {
// // // //   final state = ref.watch(albumsProvider);
// // // //   return state.maybeWhen(
// // // //     data: (list) => list.where((album) => album.status != '1').toList(),
// // // //     orElse: () => [],
// // // //   );
// // // // });

// // // // // ==========================================
// // // // // 4. MAIN WIDGET: MyProfileAlbumTab
// // // // // ==========================================

// // // // class MyProfileAlbumTab extends ConsumerWidget {
// // // //   const MyProfileAlbumTab({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final showApproved = ref.watch(albumTabProvider);
// // // //     final albumsState = ref.watch(albumsProvider);

// // // //     final approvedItems = ref.watch(approvedAlbumsProvider);
// // // //     final pendingItems = ref.watch(pendingAlbumsProvider);

// // // //     final currentList = showApproved ? approvedItems : pendingItems;

// // // //     final width = MediaQuery.of(context).size.width;
// // // //     final isCompact = width < 380;
// // // //     final cardWidth = isCompact ? width - 48 : 220.0;

// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         // Status toggle tabs (Approved / Pending)
// // // //         _buildStatusTabs(context, ref, showApproved),
// // // //         const SizedBox(height: 16),

// // // //         // Quality Info Strip
// // // //         if (showApproved) ...[_buildInfoStrip(), const SizedBox(height: 16)],

// // // //         // Section Title & Action
// // // //         Padding(
// // // //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               Text(
// // // //                 'Your Private\nAlbums',
// // // //                 style: TextStyle(
// // // //                   fontSize: isCompact ? 26 : 30,
// // // //                   fontWeight: FontWeight.w800,
// // // //                   color: const Color(0xFF19001F),
// // // //                   height: 1.1,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(height: 12),
// // // //               ElevatedButton.icon(
// // // //                 onPressed: () => _showAddAlbumDialog(context, ref),
// // // //                 icon: const Icon(Icons.create_new_folder_outlined, size: 18),
// // // //                 label: const Text(
// // // //                   'Create Album',
// // // //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// // // //                 ),
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: const Color(0xFF220027),
// // // //                   foregroundColor: Colors.white,
// // // //                   shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(22),
// // // //                   ),
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                     horizontal: 20,
// // // //                     vertical: 12,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //         const SizedBox(height: 20),

// // // //         // Albums list or state rendering
// // // //         albumsState.when(
// // // //           loading: () => const Center(
// // // //             child: Padding(
// // // //               padding: EdgeInsets.all(40.0),
// // // //               child: CircularProgressIndicator(
// // // //                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //           error: (error, _) => Center(
// // // //             child: Padding(
// // // //               padding: const EdgeInsets.all(24.0),
// // // //               child: Column(
// // // //                 children: [
// // // //                   const Icon(Icons.error_outline, color: Colors.red, size: 40),
// // // //                   const SizedBox(height: 10),
// // // //                   Text('Error loading albums: $error'),
// // // //                   TextButton(
// // // //                     onPressed: () =>
// // // //                         ref.read(albumsProvider.notifier).fetchAlbums(),
// // // //                     child: const Text('Retry'),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //           data: (_) {
// // // //             if (currentList.isEmpty) {
// // // //               return Center(
// // // //                 child: Padding(
// // // //                   padding: const EdgeInsets.symmetric(vertical: 48.0),
// // // //                   child: Text(
// // // //                     showApproved
// // // //                         ? 'No approved albums found.'
// // // //                         : 'No pending albums found.',
// // // //                     style: TextStyle(color: Colors.grey[600], fontSize: 16),
// // // //                   ),
// // // //                 ),
// // // //               );
// // // //             }

// // // //             return Wrap(
// // // //               spacing: 16,
// // // //               runSpacing: 16,
// // // //               children: currentList
// // // //                   .map((item) => _buildAlbumCard(context, ref, item, cardWidth))
// // // //                   .toList(),
// // // //             );
// // // //           },
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   // Approved vs Pending toggle
// // // //   Widget _buildStatusTabs(
// // // //     BuildContext context,
// // // //     WidgetRef ref,
// // // //     bool showApproved,
// // // //   ) {
// // // //     return Container(
// // // //       height: 44,
// // // //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
// // // //       decoration: BoxDecoration(
// // // //         borderRadius: BorderRadius.circular(22),
// // // //         gradient: const LinearGradient(
// // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // //         ),
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           Expanded(
// // // //             child: _buildPillTab(
// // // //               label: 'Approved',
// // // //               selected: showApproved,
// // // //               onTap: () => ref.read(albumTabProvider.notifier).state = true,
// // // //             ),
// // // //           ),
// // // //           Expanded(
// // // //             child: _buildPillTab(
// // // //               label: 'Pending',
// // // //               selected: !showApproved,
// // // //               onTap: () => ref.read(albumTabProvider.notifier).state = false,
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildPillTab({
// // // //     required String label,
// // // //     required bool selected,
// // // //     required VoidCallback onTap,
// // // //   }) {
// // // //     return InkWell(
// // // //       onTap: onTap,
// // // //       borderRadius: BorderRadius.circular(18),
// // // //       child: Container(
// // // //         alignment: Alignment.center,
// // // //         decoration: BoxDecoration(
// // // //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// // // //           borderRadius: BorderRadius.circular(18),
// // // //         ),
// // // //         child: Text(
// // // //           label,
// // // //           style: const TextStyle(
// // // //             color: Colors.white,
// // // //             fontSize: 12,
// // // //             fontWeight: FontWeight.w700,
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildInfoStrip() {
// // // //     return Container(
// // // //       width: double.infinity,
// // // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// // // //       decoration: BoxDecoration(
// // // //         borderRadius: BorderRadius.circular(8),
// // // //         border: Border.all(color: const Color(0xFF2D1935)),
// // // //         color: const Color(0xFFFDF8FD),
// // // //       ),
// // // //       child: const Row(
// // // //         children: [
// // // //           Icon(Icons.collections_outlined, size: 18, color: Color(0xFF490040)),
// // // //           SizedBox(width: 10),
// // // //           Expanded(
// // // //             child: Text(
// // // //               'Only high-quality album photos are approved. Avoid contact info in images.',
// // // //               style: TextStyle(
// // // //                 fontSize: 12,
// // // //                 fontWeight: FontWeight.w600,
// // // //                 color: Color(0xFF490040),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // Individual Album Card layout
// // // //   Widget _buildAlbumCard(
// // // //     BuildContext context,
// // // //     WidgetRef ref,
// // // //     AlbumModel item,
// // // //     double cardWidth,
// // // //   ) {
// // // //     return Container(
// // // //       width: cardWidth,
// // // //       height: 250,
// // // //       decoration: BoxDecoration(
// // // //         color: const Color(0xFF2E3539), // Slate grey background
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.black.withOpacity(0.15),
// // // //             blurRadius: 8,
// // // //             offset: const Offset(0, 4),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.stretch,
// // // //         children: [
// // // //           // Card Header: Title & Edit pencil
// // // //           Container(
// // // //             height: 42,
// // // //             padding: const EdgeInsets.symmetric(horizontal: 12),
// // // //             decoration: const BoxDecoration(
// // // //               gradient: LinearGradient(
// // // //                 colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // //               ),
// // // //               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
// // // //             ),
// // // //             child: Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: Text(
// // // //                     item.albumName,
// // // //                     maxLines: 1,
// // // //                     overflow: TextOverflow.ellipsis,
// // // //                     style: const TextStyle(
// // // //                       color: Colors.white,
// // // //                       fontSize: 14,
// // // //                       fontWeight: FontWeight.bold,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 GestureDetector(
// // // //                   onTapDown: (details) => _showCardPopupMenu(
// // // //                     context,
// // // //                     ref,
// // // //                     item,
// // // //                     details.globalPosition,
// // // //                   ),
// // // //                   child: const Padding(
// // // //                     padding: EdgeInsets.all(4.0),
// // // //                     child: Icon(
// // // //                       Icons.edit_outlined,
// // // //                       size: 18,
// // // //                       color: Colors.white,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),

// // // //           // Card Body: Centered Private Lock Icon
// // // //           Expanded(
// // // //             child: Center(
// // // //               child: Column(
// // // //                 mainAxisAlignment: MainAxisAlignment.center,
// // // //                 children: [
// // // //                   Icon(
// // // //                     Icons.lock_outline,
// // // //                     size: 64,
// // // //                     color: Colors.white.withOpacity(0.4),
// // // //                   ),
// // // //                   if (item.status != '1') ...[
// // // //                     const SizedBox(height: 8),
// // // //                     Container(
// // // //                       padding: const EdgeInsets.symmetric(
// // // //                         horizontal: 8,
// // // //                         vertical: 3,
// // // //                       ),
// // // //                       decoration: BoxDecoration(
// // // //                         color: const Color(0xFFFF2D87).withOpacity(0.2),
// // // //                         borderRadius: BorderRadius.circular(4),
// // // //                         border: Border.all(
// // // //                           color: const Color(0xFFFF2D87),
// // // //                           width: 0.5,
// // // //                         ),
// // // //                       ),
// // // //                       child: const Text(
// // // //                         'PENDING',
// // // //                         style: TextStyle(
// // // //                           color: Color(0xFFFF2D87),
// // // //                           fontSize: 9,
// // // //                           fontWeight: FontWeight.bold,
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // Precise popup menu overlay positioning
// // // //   void _showCardPopupMenu(
// // // //     BuildContext context,
// // // //     WidgetRef ref,
// // // //     AlbumModel item,
// // // //     Offset position,
// // // //   ) async {
// // // //     final result = await showMenu<String>(
// // // //       context: context,
// // // //       position: RelativeRect.fromLTRB(
// // // //         position.dx - 100,
// // // //         position.dy,
// // // //         position.dx,
// // // //         position.dy + 100,
// // // //       ),
// // // //       color: Colors.white,
// // // //       elevation: 8,
// // // //       shape: RoundedRectangleBorder(
// // // //         borderRadius: BorderRadius.circular(8),
// // // //         side: const BorderSide(color: Color(0xFFE0E0E0)),
// // // //       ),
// // // //       items: [
// // // //         const PopupMenuItem<String>(
// // // //           value: 'add_photo',
// // // //           child: Text(
// // // //             'Add Photo',
// // // //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
// // // //           ),
// // // //         ),
// // // //         const PopupMenuItem<String>(
// // // //           value: 'add_video',
// // // //           child: Text(
// // // //             'Add Video',
// // // //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
// // // //           ),
// // // //         ),
// // // //         const PopupMenuItem<String>(
// // // //           value: 'name_password',
// // // //           child: Text(
// // // //             'Name & Password',
// // // //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
// // // //           ),
// // // //         ),
// // // //         const PopupMenuItem<String>(
// // // //           value: 'view',
// // // //           child: Text(
// // // //             'View',
// // // //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
// // // //           ),
// // // //         ),
// // // //         const PopupMenuItem<String>(
// // // //           value: 'delete',
// // // //           child: Text(
// // // //             'Delete',
// // // //             style: TextStyle(
// // // //               color: Colors.redAccent,
// // // //               fontWeight: FontWeight.w500,
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );

// // // //     if (result == null) return;

// // // //     switch (result) {
// // // //       case 'add_photo':
// // // //         _handlePopupAddPhoto(context, ref, item);
// // // //         break;
// // // //       case 'add_video':
// // // //         _handlePopupAddVideo(context, ref, item);
// // // //         break;
// // // //       case 'name_password':
// // // //         _handlePopupNamePassword(context, ref, item);
// // // //         break;
// // // //       case 'view':
// // // //         _handlePopupView(context, ref, item);
// // // //         break;
// // // //       case 'delete':
// // // //         _handlePopupDelete(context, ref, item);
// // // //         break;
// // // //     }
// // // //   }

// // // //   // ==========================================
// // // //   // 5. POPUP OPTION HANDLERS
// // // //   // ==========================================

// // // //   // Add Photo: Picker -> Base64 -> Multiple Image Upload -> Link to Album ID -> Refetch
// // // //   Future<void> _handlePopupAddPhoto(
// // // //     BuildContext context,
// // // //     WidgetRef ref,
// // // //     AlbumModel item,
// // // //   ) async {
// // // //     final source = await _chooseMediaSource(context, isVideo: false);
// // // //     if (source == null) return;

// // // //     final pickedFile = await ImagePicker().pickImage(
// // // //       source: source,
// // // //       imageQuality: 85,
// // // //     );
// // // //     if (pickedFile == null) return;

// // // //     final navigator = Navigator.of(context);
// // // //     _showLoadingOverlay(context);

// // // //     try {
// // // //       final bytes = await pickedFile.readAsBytes();
// // // //       final base64Str = base64Encode(bytes);
// // // //       final ext = pickedFile.path.split('.').last.toLowerCase();
// // // //       final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
// // // //       final dataUri = 'data:$mimeType;base64,$base64Str';

// // // //       final service = ref.read(albumServiceProvider);
// // // //       final imageName = await service.uploadImageMultiple(dataUri);

// // // //       if (imageName != null) {
// // // //         final success = await service.linkImageToAlbum(imageName, item.id);
// // // //         navigator
// // // //             .pop(); // Dismiss loader safely using captured navigator reference

// // // //         if (success) {
// // // //           _showSnackBar(
// // // //             context,
// // // //             'Photo uploaded and linked to album successfully.',
// // // //           );
// // // //           ref.read(albumsProvider.notifier).fetchAlbums();
// // // //         } else {
// // // //           _showSnackBar(context, 'Photo uploaded but link failed.');
// // // //         }
// // // //       } else {
// // // //         navigator
// // // //             .pop(); // Dismiss loader safely using captured navigator reference
// // // //         _showSnackBar(context, 'Failed to upload photo.');
// // // //       }
// // // //     } catch (e) {
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference
// // // //       _showSnackBar(context, 'Error uploading photo: $e');
// // // //     }
// // // //   }

// // // //   // Add Video: Pick -> Multipart Video Upload -> Refetch
// // // //   Future<void> _handlePopupAddVideo(
// // // //     BuildContext context,
// // // //     WidgetRef ref,
// // // //     AlbumModel item,
// // // //   ) async {
// // // //     final pickedFile = await ImagePicker().pickVideo(
// // // //       source: ImageSource.gallery,
// // // //     );
// // // //     if (pickedFile == null) return;

// // // //     final navigator = Navigator.of(context);
// // // //     _showLoadingOverlay(context);

// // // //     try {
// // // //       final service = ref.read(albumServiceProvider);
// // // //       final fileName = await service.uploadVideo(File(pickedFile.path));
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference

// // // //       if (fileName != null) {
// // // //         _showSnackBar(context, 'Video uploaded successfully.');
// // // //         ref.read(albumsProvider.notifier).fetchAlbums();
// // // //       } else {
// // // //         _showSnackBar(context, 'Failed to upload video.');
// // // //       }
// // // //     } catch (e) {
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference
// // // //       _showSnackBar(context, 'Error uploading video: $e');
// // // //     }
// // // //   }

// // // //   // Name & Password: Fetch details -> Prefill custom Dialog -> Update -> Refetch
// // // //   Future<void> _handlePopupNamePassword(
// // // //     BuildContext context,
// // // //     WidgetRef ref,
// // // //     AlbumModel item,
// // // //   ) async {
// // // //     final navigator = Navigator.of(context);
// // // //     _showLoadingOverlay(context);

// // // //     try {
// // // //       final service = ref.read(albumServiceProvider);
// // // //       final details = await service.getAlbumDetails(item.id);
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference

// // // //       if (details != null) {
// // // //         _showAddAlbumDialog(context, ref, editDetails: details);
// // // //       } else {
// // // //         _showSnackBar(context, 'Failed to load album details.');
// // // //       }
// // // //     } catch (e) {
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference
// // // //       _showSnackBar(context, 'Error: $e');
// // // //     }
// // // //   }

// // // //   // View: Fetch images for this album -> Render elegant bottom sheet
// // // //   Future<void> _handlePopupView(
// // // //     BuildContext context,
// // // //     WidgetRef ref,
// // // //     AlbumModel item,
// // // //   ) async {
// // // //     final navigator = Navigator.of(context);
// // // //     _showLoadingOverlay(context);

// // // //     try {
// // // //       final service = ref.read(albumServiceProvider);
// // // //       final images = await service.getAlbumImages(item.id);
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference

// // // //       if (images.isEmpty) {
// // // //         _showSnackBar(context, 'No images found in this album.');
// // // //         return;
// // // //       }

// // // //       showModalBottomSheet(
// // // //         context: context,
// // // //         isScrollControlled: true,
// // // //         backgroundColor: Colors.black87,
// // // //         shape: const RoundedRectangleBorder(
// // // //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // // //         ),
// // // //         builder: (context) {
// // // //           return DraggableScrollableSheet(
// // // //             expand: false,
// // // //             initialChildSize: 0.6,
// // // //             maxChildSize: 0.9,
// // // //             builder: (context, scrollController) {
// // // //               return Column(
// // // //                 children: [
// // // //                   const SizedBox(height: 12),
// // // //                   Container(
// // // //                     width: 40,
// // // //                     height: 5,
// // // //                     decoration: BoxDecoration(
// // // //                       color: Colors.white24,
// // // //                       borderRadius: BorderRadius.circular(10),
// // // //                     ),
// // // //                   ),
// // // //                   const Padding(
// // // //                     padding: EdgeInsets.all(16.0),
// // // //                     child: Text(
// // // //                       'Album Photos',
// // // //                       style: TextStyle(
// // // //                         color: Colors.white,
// // // //                         fontSize: 18,
// // // //                         fontWeight: FontWeight.bold,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   Expanded(
// // // //                     child: GridView.builder(
// // // //                       controller: scrollController,
// // // //                       padding: const EdgeInsets.all(16),
// // // //                       gridDelegate:
// // // //                           const SliverGridDelegateWithFixedCrossAxisCount(
// // // //                             crossAxisCount: 3,
// // // //                             crossAxisSpacing: 10,
// // // //                             mainAxisSpacing: 10,
// // // //                           ),
// // // //                       itemCount: images.length,
// // // //                       itemBuilder: (context, index) {
// // // //                         return ClipRRect(
// // // //                           borderRadius: BorderRadius.circular(8),
// // // //                           child: Image.network(
// // // //                             images[index].image,
// // // //                             fit: BoxFit.cover,
// // // //                             errorBuilder: (_, __, ___) => Container(
// // // //                               color: Colors.grey[800],
// // // //                               child: const Icon(
// // // //                                 Icons.image_not_supported,
// // // //                                 color: Colors.white38,
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                         );
// // // //                       },
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               );
// // // //             },
// // // //           );
// // // //         },
// // // //       );
// // // //     } catch (e) {
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference
// // // //       _showSnackBar(context, 'Error retrieving images: $e');
// // // //     }
// // // //   }

// // // //   // Delete Album: Confirms -> Deletes -> Refetch
// // // //   Future<void> _handlePopupDelete(
// // // //     BuildContext context,
// // // //     WidgetRef ref,
// // // //     AlbumModel item,
// // // //   ) async {
// // // //     final confirm = await showDialog<bool>(
// // // //       context: context,
// // // //       builder: (context) {
// // // //         return AlertDialog(
// // // //           title: const Text('Delete Album'),
// // // //           content: Text(
// // // //             'Are you sure you want to delete the album "${item.albumName}"?',
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.pop(context, false),
// // // //               child: const Text('Cancel'),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () => Navigator.pop(context, true),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: Colors.redAccent,
// // // //               ),
// // // //               child: const Text(
// // // //                 'Delete',
// // // //                 style: TextStyle(color: Colors.white),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );

// // // //     if (confirm != true) return;

// // // //     final navigator = Navigator.of(context);
// // // //     _showLoadingOverlay(context);

// // // //     try {
// // // //       final success = await ref
// // // //           .read(albumsProvider.notifier)
// // // //           .deleteAlbum(item.id);
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference

// // // //       if (success) {
// // // //         _showSnackBar(context, 'Album deleted successfully.');
// // // //       } else {
// // // //         _showSnackBar(context, 'Failed to delete album.');
// // // //       }
// // // //     } catch (e) {
// // // //       navigator
// // // //           .pop(); // Dismiss loader safely using captured navigator reference
// // // //       _showSnackBar(context, 'Error deleting album: $e');
// // // //     }
// // // //   }

// // // //   // ==========================================
// // // //   // 6. HELPER OVERLAYS AND DIALOGS
// // // //   // ==========================================

// // // //   Future<ImageSource?> _chooseMediaSource(
// // // //     BuildContext context, {
// // // //     required bool isVideo,
// // // //   }) async {
// // // //     return showModalBottomSheet<ImageSource>(
// // // //       context: context,
// // // //       builder: (context) {
// // // //         return SafeArea(
// // // //           child: Column(
// // // //             mainAxisSize: MainAxisSize.min,
// // // //             children: [
// // // //               ListTile(
// // // //                 leading: const Icon(Icons.photo_library_outlined),
// // // //                 title: const Text('Choose from Gallery'),
// // // //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// // // //               ),
// // // //               if (!isVideo)
// // // //                 ListTile(
// // // //                   leading: const Icon(Icons.camera_alt_outlined),
// // // //                   title: const Text('Take Photo'),
// // // //                   onTap: () => Navigator.pop(context, ImageSource.camera),
// // // //                 ),
// // // //             ],
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }

// // // //   void _showLoadingOverlay(BuildContext context) {
// // // //     showDialog(
// // // //       context: context,
// // // //       barrierDismissible: false,
// // // //       builder: (context) => const Center(
// // // //         child: CircularProgressIndicator(
// // // //           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // Edit / Add Album Form Dialog (Matches third screenshot perfectly and handles async safely)
// // // //   void _showAddAlbumDialog(
// // // //     BuildContext context,
// // // //     WidgetRef ref, {
// // // //     AlbumDetailsModel? editDetails,
// // // //   }) {
// // // //     final nameController = TextEditingController(
// // // //       text: editDetails?.albumName ?? '',
// // // //     );
// // // //     final passwordController = TextEditingController(
// // // //       text: editDetails?.albumPassword ?? '',
// // // //     );
// // // //     final isEditing = editDetails != null;

// // // //     showDialog(
// // // //       context: context,
// // // //       barrierDismissible: true,
// // // //       builder: (dialogContext) {
// // // //         bool isLoading = false;

// // // //         return StatefulBuilder(
// // // //           builder: (context, setState) {
// // // //             return Dialog(
// // // //               shape: RoundedRectangleBorder(
// // // //                 borderRadius: BorderRadius.circular(12),
// // // //               ),
// // // //               child: SingleChildScrollView(
// // // //                 child: Column(
// // // //                   mainAxisSize: MainAxisSize.min,
// // // //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// // // //                   children: [
// // // //                     // Header Bar (Matches design exactly)
// // // //                     Container(
// // // //                       height: 52,
// // // //                       padding: const EdgeInsets.symmetric(horizontal: 16),
// // // //                       decoration: const BoxDecoration(
// // // //                         gradient: LinearGradient(
// // // //                           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // //                         ),
// // // //                         borderRadius: BorderRadius.vertical(
// // // //                           top: Radius.circular(12),
// // // //                         ),
// // // //                       ),
// // // //                       child: Row(
// // // //                         children: [
// // // //                           const Icon(
// // // //                             Icons.create_new_folder_outlined,
// // // //                             color: Colors.white,
// // // //                             size: 22,
// // // //                           ),
// // // //                           const SizedBox(width: 8),
// // // //                           Text(
// // // //                             isEditing ? 'Edit Album' : 'Add Album',
// // // //                             style: const TextStyle(
// // // //                               color: Colors.white,
// // // //                               fontSize: 18,
// // // //                               fontWeight: FontWeight.bold,
// // // //                             ),
// // // //                           ),
// // // //                           const Spacer(),
// // // //                           if (!isLoading)
// // // //                             IconButton(
// // // //                               onPressed: () => Navigator.pop(dialogContext),
// // // //                               icon: const Icon(
// // // //                                 Icons.close,
// // // //                                 color: Colors.white,
// // // //                                 size: 20,
// // // //                               ),
// // // //                               padding: EdgeInsets.zero,
// // // //                               constraints: const BoxConstraints(),
// // // //                             ),
// // // //                         ],
// // // //                       ),
// // // //                     ),

// // // //                     // Form Textfields
// // // //                     Padding(
// // // //                       padding: const EdgeInsets.all(20.0),
// // // //                       child: Column(
// // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // //                         children: [
// // // //                           const Text(
// // // //                             'Album Name',
// // // //                             style: TextStyle(
// // // //                               fontWeight: FontWeight.bold,
// // // //                               color: Colors.black87,
// // // //                               fontSize: 14,
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(height: 8),
// // // //                           TextField(
// // // //                             controller: nameController,
// // // //                             enabled: !isLoading,
// // // //                             decoration: InputDecoration(
// // // //                               hintText: 'Enter album name',
// // // //                               fillColor: const Color(0xFFF2F4F7),
// // // //                               filled: true,
// // // //                               contentPadding: const EdgeInsets.symmetric(
// // // //                                 horizontal: 12,
// // // //                                 vertical: 10,
// // // //                               ),
// // // //                               border: OutlineInputBorder(
// // // //                                 borderRadius: BorderRadius.circular(8),
// // // //                                 borderSide: BorderSide(
// // // //                                   color: Colors.grey.shade300,
// // // //                                 ),
// // // //                               ),
// // // //                               enabledBorder: OutlineInputBorder(
// // // //                                 borderRadius: BorderRadius.circular(8),
// // // //                                 borderSide: BorderSide(
// // // //                                   color: Colors.grey.shade300,
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(height: 16),
// // // //                           const Text(
// // // //                             'Album Password',
// // // //                             style: TextStyle(
// // // //                               fontWeight: FontWeight.bold,
// // // //                               color: Colors.black87,
// // // //                               fontSize: 14,
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(height: 8),
// // // //                           TextField(
// // // //                             controller: passwordController,
// // // //                             enabled: !isLoading,
// // // //                             obscureText:
// // // //                                 false, // Visible text matching screenshot
// // // //                             decoration: InputDecoration(
// // // //                               hintText: 'Enter password',
// // // //                               fillColor: const Color(0xFFF2F4F7),
// // // //                               filled: true,
// // // //                               contentPadding: const EdgeInsets.symmetric(
// // // //                                 horizontal: 12,
// // // //                                 vertical: 10,
// // // //                               ),
// // // //                               border: OutlineInputBorder(
// // // //                                 borderRadius: BorderRadius.circular(8),
// // // //                                 borderSide: BorderSide(
// // // //                                   color: Colors.grey.shade300,
// // // //                                 ),
// // // //                               ),
// // // //                               enabledBorder: OutlineInputBorder(
// // // //                                 borderRadius: BorderRadius.circular(8),
// // // //                                 borderSide: BorderSide(
// // // //                                   color: Colors.grey.shade300,
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(height: 24),

// // // //                           // Save Button or Loading Spinner
// // // //                           Row(
// // // //                             mainAxisAlignment: MainAxisAlignment.end,
// // // //                             children: [
// // // //                               if (isLoading)
// // // //                                 const Padding(
// // // //                                   padding: EdgeInsets.symmetric(
// // // //                                     horizontal: 24.0,
// // // //                                   ),
// // // //                                   child: CircularProgressIndicator(
// // // //                                     valueColor: AlwaysStoppedAnimation<Color>(
// // // //                                       Color(0xFFFF2D87),
// // // //                                     ),
// // // //                                   ),
// // // //                                 )
// // // //                               else
// // // //                                 ElevatedButton(
// // // //                                   onPressed: () async {
// // // //                                     final name = nameController.text.trim();
// // // //                                     final password = passwordController.text
// // // //                                         .trim();

// // // //                                     if (name.isEmpty || password.isEmpty) {
// // // //                                       _showSnackBar(
// // // //                                         dialogContext,
// // // //                                         'Please enter both name and password.',
// // // //                                       );
// // // //                                       return;
// // // //                                     }

// // // //                                     setState(() {
// // // //                                       isLoading = true;
// // // //                                     });

// // // //                                     bool success;
// // // //                                     try {
// // // //                                       if (isEditing) {
// // // //                                         success = await ref
// // // //                                             .read(albumsProvider.notifier)
// // // //                                             .updateAlbum(
// // // //                                               editDetails.id,
// // // //                                               name,
// // // //                                               password,
// // // //                                             );
// // // //                                       } else {
// // // //                                         success = await ref
// // // //                                             .read(albumsProvider.notifier)
// // // //                                             .createAlbum(name, password);
// // // //                                       }
// // // //                                     } catch (_) {
// // // //                                       success = false;
// // // //                                     }

// // // //                                     if (success) {
// // // //                                       Navigator.pop(
// // // //                                         dialogContext,
// // // //                                       ); // Safely close the dialog
// // // //                                       _showSnackBar(
// // // //                                         context, // Show on parent context safely
// // // //                                         isEditing
// // // //                                             ? 'Album updated successfully!'
// // // //                                             : 'Album created successfully!',
// // // //                                       );
// // // //                                     } else {
// // // //                                       setState(() {
// // // //                                         isLoading = false;
// // // //                                       });
// // // //                                       _showSnackBar(
// // // //                                         dialogContext,
// // // //                                         'Failed to save album.',
// // // //                                       );
// // // //                                     }
// // // //                                   },
// // // //                                   style: ElevatedButton.styleFrom(
// // // //                                     backgroundColor: const Color(0xFF220027),
// // // //                                     foregroundColor: Colors.white,
// // // //                                     shape: RoundedRectangleBorder(
// // // //                                       borderRadius: BorderRadius.circular(8),
// // // //                                     ),
// // // //                                     padding: const EdgeInsets.symmetric(
// // // //                                       horizontal: 24,
// // // //                                       vertical: 12,
// // // //                                     ),
// // // //                                   ),
// // // //                                   child: const Text(
// // // //                                     'Save',
// // // //                                     style: TextStyle(
// // // //                                       fontSize: 14,
// // // //                                       fontWeight: FontWeight.bold,
// // // //                                     ),
// // // //                                   ),
// // // //                                 ),
// // // //                             ],
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             );
// // // //           },
// // // //         );
// // // //       },
// // // //     );
// // // //   }

// // // //   void _showSnackBar(BuildContext context, String message) {
// // // //     // ScaffoldMessenger.of(context).showSnackBar(
// // // //     //   SnackBar(
// // // //     //     content: Text(message),
// // // //     //     duration: const Duration(seconds: 3),
// // // //     //   ),
// // // //     // );
// // // //     Get.snackbar(Text(message), duration: const Duration(seconds: 3));
// // // //   }
// // // // }

// // // // // import 'dart:convert';
// // // // // import 'dart:io';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:image_picker/image_picker.dart';
// // // // // import 'package:http/http.dart' as http;

// // // // // // ==========================================
// // // // // // 1. DATA MODELS
// // // // // // ==========================================

// // // // // class AlbumModel {
// // // // //   final String id;
// // // // //   final String albumName;
// // // // //   final String albumPassword;
// // // // //   final String image;
// // // // //   final String status; // "1" for Approved, otherwise Pending

// // // // //   AlbumModel({
// // // // //     required this.id,
// // // // //     required this.albumName,
// // // // //     required this.albumPassword,
// // // // //     required this.image,
// // // // //     required this.status,
// // // // //   });

// // // // //   factory AlbumModel.fromJson(Map<String, dynamic> json) {
// // // // //     return AlbumModel(
// // // // //       id: json['id']?.toString() ?? '',
// // // // //       albumName: json['album_name']?.toString() ?? '',
// // // // //       albumPassword: json['album_password']?.toString() ?? '',
// // // // //       image: json['image']?.toString() ?? '',
// // // // //       status: json['status']?.toString() ?? '1',
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class AlbumImageModel {
// // // // //   final String id;
// // // // //   final String albumId;
// // // // //   final String image;

// // // // //   AlbumImageModel({
// // // // //     required this.id,
// // // // //     required this.albumId,
// // // // //     required this.image,
// // // // //   });

// // // // //   factory AlbumImageModel.fromJson(Map<String, dynamic> json) {
// // // // //     return AlbumImageModel(
// // // // //       id: json['id']?.toString() ?? '',
// // // // //       albumId: json['album_id']?.toString() ?? '',
// // // // //       image: json['image']?.toString() ?? '',
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class AlbumDetailsModel {
// // // // //   final String id;
// // // // //   final String albumName;
// // // // //   final String albumPassword;

// // // // //   AlbumDetailsModel({
// // // // //     required this.id,
// // // // //     required this.albumName,
// // // // //     required this.albumPassword,
// // // // //   });

// // // // //   factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
// // // // //     return AlbumDetailsModel(
// // // // //       id: json['id']?.toString() ?? '',
// // // // //       albumName: json['album_name']?.toString() ?? '',
// // // // //       albumPassword: json['album_password']?.toString() ?? '',
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ==========================================
// // // // // // 2. API SERVICE
// // // // // // ==========================================

// // // // // class AlbumService {
// // // // //   static const String baseUrl = 'https://app.beatflirtevent.com/App';

// // // // //   // 1. Get all albums (GET)
// // // // //   Future<List<AlbumModel>> getAllAlbums() async {
// // // // //     try {
// // // // //       final response = await http.get(Uri.parse('$baseUrl/user/get_all_album'));
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // // // //           return (decoded['data'] as List)
// // // // //               .map((item) => AlbumModel.fromJson(item))
// // // // //               .toList();
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error fetching albums: $e');
// // // // //     }
// // // // //     return [];
// // // // //   }

// // // // //   // 2. Get all approved album images (GET)
// // // // //   Future<List<String>> getAllApprovedAlbumImages() async {
// // // // //     try {
// // // // //       final response = await http.get(Uri.parse('$baseUrl/user/get_all_approve_album_image'));
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // // // //           return (decoded['data'] as List).map((e) => e['image'].toString()).toList();
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error fetching approved images: $e');
// // // // //     }
// // // // //     return [];
// // // // //   }

// // // // //   // 3. Get all pending album images (GET)
// // // // //   Future<List<String>> getAllPendingAlbumImages() async {
// // // // //     try {
// // // // //       final response = await http.get(Uri.parse('$baseUrl/user/get_all_pending_album_image'));
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // // // //           return (decoded['data'] as List).map((e) => e['image'].toString()).toList();
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error fetching pending images: $e');
// // // // //     }
// // // // //     return [];
// // // // //   }

// // // // //   // 4 & View. Get album images for a specific album (POST)
// // // // //   Future<List<AlbumImageModel>> getAlbumImages(String albumId) async {
// // // // //     try {
// // // // //       final response = await http.post(
// // // // //         Uri.parse('$baseUrl/user/get_album_image'),
// // // // //         body: {'album_id': albumId},
// // // // //       );
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         if (decoded['status'] == '200' && decoded['data'] is List) {
// // // // //           return (decoded['data'] as List)
// // // // //               .map((item) => AlbumImageModel.fromJson(item))
// // // // //               .toList();
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error fetching album images: $e');
// // // // //     }
// // // // //     return [];
// // // // //   }

// // // // //   // 5. Create profile album (POST)
// // // // //   Future<bool> createProfileAlbum(String name, String password) async {
// // // // //     try {
// // // // //       final response = await http.post(
// // // // //         Uri.parse('$baseUrl/user/create_profile_album'),
// // // // //         body: {
// // // // //           'album_name': name,
// // // // //           'album_password': password,
// // // // //         },
// // // // //       );
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         return decoded['status'] == '200';
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error creating album: $e');
// // // // //     }
// // // // //     return false;
// // // // //   }

// // // // //   // Popup Action 1: Upload image base64 (POST)
// // // // //   Future<String?> uploadImageMultiple(String base64Image) async {
// // // // //     try {
// // // // //       final response = await http.post(
// // // // //         Uri.parse('$baseUrl/upload/imageuploadMultiple'),
// // // // //         headers: {'Content-Type': 'application/json'},
// // // // //         body: jsonEncode({
// // // // //           'image': [
// // // // //             {'image': base64Image}
// // // // //           ]
// // // // //         }),
// // // // //       );
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         if (decoded['status'] == '200' && decoded['data'] is List && decoded['data'].isNotEmpty) {
// // // // //           return decoded['data'][0]['image_name']?.toString();
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error uploading image base64: $e');
// // // // //     }
// // // // //     return null;
// // // // //   }

// // // // //   // Popup Action 2: Link image to album (POST)
// // // // //   Future<bool> linkImageToAlbum(String imageName, String albumId) async {
// // // // //     try {
// // // // //       final response = await http.post(
// // // // //         Uri.parse('$baseUrl/user/single_user_mutiple_album_image'),
// // // // //         body: {
// // // // //           'image': imageName,
// // // // //           'album_id': albumId,
// // // // //         },
// // // // //       );
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         return decoded['status'] == '200';
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error linking image to album: $e');
// // // // //     }
// // // // //     return false;
// // // // //   }

// // // // //   // Popup Action 3: Get album details (POST)
// // // // //   Future<AlbumDetailsModel?> getAlbumDetails(String albumId) async {
// // // // //     try {
// // // // //       final response = await http.post(
// // // // //         Uri.parse('$baseUrl/user/get_album_details'),
// // // // //         body: {'album_id': albumId},
// // // // //       );
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         if (decoded['status'] == '200' && decoded['data'] != null) {
// // // // //           return AlbumDetailsModel.fromJson(decoded['data']);
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error fetching album details: $e');
// // // // //     }
// // // // //     return null;
// // // // //   }

// // // // //   // Popup Action 4: Upload video binary (POST)
// // // // //   Future<String?> uploadVideo(File videoFile) async {
// // // // //     try {
// // // // //       final request = http.MultipartRequest(
// // // // //         'POST',
// // // // //         Uri.parse('$baseUrl/upload/video_upload'),
// // // // //       );
// // // // //       request.files.add(
// // // // //         await http.MultipartFile.fromPath('video', videoFile.path),
// // // // //       );
// // // // //       final streamedResponse = await request.send();
// // // // //       final response = await http.Response.fromStream(streamedResponse);
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         if (decoded['status'] == '200' && decoded['data'] != null) {
// // // // //           return decoded['data']['file_name']?.toString();
// // // // //         }
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error uploading video: $e');
// // // // //     }
// // // // //     return null;
// // // // //   }

// // // // //   // Popup Action 5: Update profile album (POST)
// // // // //   Future<bool> updateProfileAlbum(String albumId, String name, String password) async {
// // // // //     try {
// // // // //       final response = await http.post(
// // // // //         Uri.parse('$baseUrl/user/update_profile_album'),
// // // // //         body: {
// // // // //           'album_id': albumId,
// // // // //           'album_name': name,
// // // // //           'album_password': password,
// // // // //         },
// // // // //       );
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         return decoded['status'] == '200';
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error updating album: $e');
// // // // //     }
// // // // //     return false;
// // // // //   }

// // // // //   // 6. Delete album (POST)
// // // // //   Future<bool> deleteAlbum(String albumId) async {
// // // // //     try {
// // // // //       final response = await http.post(
// // // // //         Uri.parse('$baseUrl/user/delete_album'),
// // // // //         body: {'album_id': albumId},
// // // // //       );
// // // // //       if (response.statusCode == 200) {
// // // // //         final decoded = jsonDecode(response.body);
// // // // //         return decoded['status'] == '200';
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error deleting album: $e');
// // // // //     }
// // // // //     return false;
// // // // //   }
// // // // // }

// // // // // // ==========================================
// // // // // // 3. RIVERPOD PROVIDERS
// // // // // // ==========================================

// // // // // final albumServiceProvider = Provider<AlbumService>((ref) => AlbumService());

// // // // // // State provider for active toggles (true = Approved, false = Pending)
// // // // // final albumTabProvider = StateProvider<bool>((ref) => true);

// // // // // class AlbumsNotifier extends StateNotifier<AsyncValue<List<AlbumModel>>> {
// // // // //   final AlbumService _service;

// // // // //   AlbumsNotifier(this._service) : super(const AsyncValue.loading()) {
// // // // //     fetchAlbums();
// // // // //   }

// // // // //   Future<void> fetchAlbums() async {
// // // // //     state = const AsyncValue.loading();
// // // // //     try {
// // // // //       final list = await _service.getAllAlbums();
// // // // //       state = AsyncValue.data(list);
// // // // //     } catch (e, stack) {
// // // // //       state = AsyncValue.error(e, stack);
// // // // //     }
// // // // //   }

// // // // //   Future<bool> createAlbum(String name, String password) async {
// // // // //     try {
// // // // //       final success = await _service.createProfileAlbum(name, password);
// // // // //       if (success) {
// // // // //         await fetchAlbums();
// // // // //       }
// // // // //       return success;
// // // // //     } catch (e) {
// // // // //       return false;
// // // // //     }
// // // // //   }

// // // // //   Future<bool> updateAlbum(String id, String name, String password) async {
// // // // //     try {
// // // // //       final success = await _service.updateProfileAlbum(id, name, password);
// // // // //       if (success) {
// // // // //         await fetchAlbums();
// // // // //       }
// // // // //       return success;
// // // // //     } catch (e) {
// // // // //       return false;
// // // // //     }
// // // // //   }

// // // // //   Future<bool> deleteAlbum(String id) async {
// // // // //     try {
// // // // //       final success = await _service.deleteAlbum(id);
// // // // //       if (success) {
// // // // //         await fetchAlbums();
// // // // //       }
// // // // //       return success;
// // // // //     } catch (e) {
// // // // //       return false;
// // // // //     }
// // // // //   }
// // // // // }

// // // // // final albumsProvider = StateNotifierProvider<AlbumsNotifier, AsyncValue<List<AlbumModel>>>((ref) {
// // // // //   return AlbumsNotifier(ref.watch(albumServiceProvider));
// // // // // });

// // // // // final approvedAlbumsProvider = Provider<List<AlbumModel>>((ref) {
// // // // //   final state = ref.watch(albumsProvider);
// // // // //   return state.maybeWhen(
// // // // //     data: (list) => list.where((album) => album.status == '1').toList(),
// // // // //     orElse: () => [],
// // // // //   );
// // // // // });

// // // // // final pendingAlbumsProvider = Provider<List<AlbumModel>>((ref) {
// // // // //   final state = ref.watch(albumsProvider);
// // // // //   return state.maybeWhen(
// // // // //     data: (list) => list.where((album) => album.status != '1').toList(),
// // // // //     orElse: () => [],
// // // // //   );
// // // // // });

// // // // // // ==========================================
// // // // // // 4. MAIN WIDGET: MyProfileAlbumTab
// // // // // // ==========================================

// // // // // class MyProfileAlbumTab extends ConsumerWidget {
// // // // //   const MyProfileAlbumTab({super.key});

// // // // //   @override
// // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // //     final showApproved = ref.watch(albumTabProvider);
// // // // //     final albumsState = ref.watch(albumsProvider);

// // // // //     final approvedItems = ref.watch(approvedAlbumsProvider);
// // // // //     final pendingItems = ref.watch(pendingAlbumsProvider);

// // // // //     final currentList = showApproved ? approvedItems : pendingItems;

// // // // //     final width = MediaQuery.of(context).size.width;
// // // // //     final isCompact = width < 380;
// // // // //     final cardWidth = isCompact ? width - 48 : 220.0;

// // // // //     return Column(
// // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // //       children: [
// // // // //         // Status toggle tabs (Approved / Pending)
// // // // //         _buildStatusTabs(context, ref, showApproved),
// // // // //         const SizedBox(height: 16),

// // // // //         // Quality Info Strip
// // // // //         if (showApproved) ...[
// // // // //           _buildInfoStrip(),
// // // // //           const SizedBox(height: 16),
// // // // //         ],

// // // // //         // Section Title & Action
// // // // //         Padding(
// // // // //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // // // //           child: Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               Text(
// // // // //                 'Your Private\nAlbums',
// // // // //                 style: TextStyle(
// // // // //                   fontSize: isCompact ? 26 : 30,
// // // // //                   fontWeight: FontWeight.w800,
// // // // //                   color: const Color(0xFF19001F),
// // // // //                   height: 1.1,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               ElevatedButton.icon(
// // // // //                 onPressed: () => _showAddAlbumDialog(context, ref),
// // // // //                 icon: const Icon(Icons.create_new_folder_outlined, size: 18),
// // // // //                 label: const Text(
// // // // //                   'Create Album',
// // // // //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// // // // //                 ),
// // // // //                 style: ElevatedButton.styleFrom(
// // // // //                   backgroundColor: const Color(0xFF220027),
// // // // //                   foregroundColor: Colors.white,
// // // // //                   shape: RoundedRectangleBorder(
// // // // //                     borderRadius: BorderRadius.circular(22),
// // // // //                   ),
// // // // //                   padding: const EdgeInsets.symmetric(
// // // // //                     horizontal: 20,
// // // // //                     vertical: 12,
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //         const SizedBox(height: 20),

// // // // //         // Albums list or state rendering
// // // // //         albumsState.when(
// // // // //           loading: () => const Center(
// // // // //             child: Padding(
// // // // //               padding: EdgeInsets.all(40.0),
// // // // //               child: CircularProgressIndicator(
// // // // //                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           error: (error, _) => Center(
// // // // //             child: Padding(
// // // // //               padding: const EdgeInsets.all(24.0),
// // // // //               child: Column(
// // // // //                 children: [
// // // // //                   const Icon(Icons.error_outline, color: Colors.red, size: 40),
// // // // //                   const SizedBox(height: 10),
// // // // //                   Text('Error loading albums: $error'),
// // // // //                   TextButton(
// // // // //                     onPressed: () => ref.read(albumsProvider.notifier).fetchAlbums(),
// // // // //                     child: const Text('Retry'),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           data: (_) {
// // // // //             if (currentList.isEmpty) {
// // // // //               return Center(
// // // // //                 child: Padding(
// // // // //                   padding: const EdgeInsets.symmetric(vertical: 48.0),
// // // // //                   child: Text(
// // // // //                     showApproved ? 'No approved albums found.' : 'No pending albums found.',
// // // // //                     style: TextStyle(color: Colors.grey[600], fontSize: 16),
// // // // //                   ),
// // // // //                 ),
// // // // //               );
// // // // //             }

// // // // //             return Wrap(
// // // // //               spacing: 16,
// // // // //               runSpacing: 16,
// // // // //               children: currentList
// // // // //                   .map((item) => _buildAlbumCard(context, ref, item, cardWidth))
// // // // //                   .toList(),
// // // // //             );
// // // // //           },
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   // Approved vs Pending toggle
// // // // //   Widget _buildStatusTabs(BuildContext context, WidgetRef ref, bool showApproved) {
// // // // //     return Container(
// // // // //       height: 44,
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
// // // // //       decoration: BoxDecoration(
// // // // //         borderRadius: BorderRadius.circular(22),
// // // // //         gradient: const LinearGradient(
// // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // //         ),
// // // // //       ),
// // // // //       child: Row(
// // // // //         children: [
// // // // //           Expanded(
// // // // //             child: _buildPillTab(
// // // // //               label: 'Approved',
// // // // //               selected: showApproved,
// // // // //               onTap: () => ref.read(albumTabProvider.notifier).state = true,
// // // // //             ),
// // // // //           ),
// // // // //           Expanded(
// // // // //             child: _buildPillTab(
// // // // //               label: 'Pending',
// // // // //               selected: !showApproved,
// // // // //               onTap: () => ref.read(albumTabProvider.notifier).state = false,
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildPillTab({
// // // // //     required String label,
// // // // //     required bool selected,
// // // // //     required VoidCallback onTap,
// // // // //   }) {
// // // // //     return InkWell(
// // // // //       onTap: onTap,
// // // // //       borderRadius: BorderRadius.circular(18),
// // // // //       child: Container(
// // // // //         alignment: Alignment.center,
// // // // //         decoration: BoxDecoration(
// // // // //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// // // // //           borderRadius: BorderRadius.circular(18),
// // // // //         ),
// // // // //         child: Text(
// // // // //           label,
// // // // //           style: const TextStyle(
// // // // //             color: Colors.white,
// // // // //             fontSize: 12,
// // // // //             fontWeight: FontWeight.w700,
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildInfoStrip() {
// // // // //     return Container(
// // // // //       width: double.infinity,
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// // // // //       decoration: BoxDecoration(
// // // // //         borderRadius: BorderRadius.circular(8),
// // // // //         border: Border.all(color: const Color(0xFF2D1935)),
// // // // //         color: const Color(0xFFFDF8FD),
// // // // //       ),
// // // // //       child: const Row(
// // // // //         children: [
// // // // //           Icon(Icons.collections_outlined, size: 18, color: Color(0xFF490040)),
// // // // //           SizedBox(width: 10),
// // // // //           Expanded(
// // // // //             child: Text(
// // // // //               'Only high-quality album photos are approved. Avoid contact info in images.',
// // // // //               style: TextStyle(
// // // // //                 fontSize: 12,
// // // // //                 fontWeight: FontWeight.w600,
// // // // //                 color: Color(0xFF490040),
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // Individual Album Card layout
// // // // //   Widget _buildAlbumCard(
// // // // //     BuildContext context,
// // // // //     WidgetRef ref,
// // // // //     AlbumModel item,
// // // // //     double cardWidth,
// // // // //   ) {
// // // // //     return Container(
// // // // //       width: cardWidth,
// // // // //       height: 250,
// // // // //       decoration: BoxDecoration(
// // // // //         color: const Color(0xFF2E3539), // Slate grey background
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         boxShadow: [
// // // // //           BoxShadow(
// // // // //             color: Colors.black.withOpacity(0.15),
// // // // //             blurRadius: 8,
// // // // //             offset: const Offset(0, 4),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.stretch,
// // // // //         children: [
// // // // //           // Card Header: Title & Edit pencil
// // // // //           Container(
// // // // //             height: 42,
// // // // //             padding: const EdgeInsets.symmetric(horizontal: 12),
// // // // //             decoration: const BoxDecoration(
// // // // //               gradient: LinearGradient(
// // // // //                 colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // //               ),
// // // // //               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
// // // // //             ),
// // // // //             child: Row(
// // // // //               children: [
// // // // //                 Expanded(
// // // // //                   child: Text(
// // // // //                     item.albumName,
// // // // //                     maxLines: 1,
// // // // //                     overflow: TextOverflow.ellipsis,
// // // // //                     style: const TextStyle(
// // // // //                       color: Colors.white,
// // // // //                       fontSize: 14,
// // // // //                       fontWeight: FontWeight.bold,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //                 GestureDetector(
// // // // //                   onTapDown: (details) => _showCardPopupMenu(context, ref, item, details.globalPosition),
// // // // //                   child: const Padding(
// // // // //                     padding: EdgeInsets.all(4.0),
// // // // //                     child: Icon(
// // // // //                       Icons.edit_outlined,
// // // // //                       size: 18,
// // // // //                       color: Colors.white,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),

// // // // //           // Card Body: Centered Private Lock Icon
// // // // //           Expanded(
// // // // //             child: Center(
// // // // //               child: Column(
// // // // //                 mainAxisAlignment: MainAxisAlignment.center,
// // // // //                 children: [
// // // // //                   Icon(
// // // // //                     Icons.lock_outline,
// // // // //                     size: 64,
// // // // //                     color: Colors.white.withOpacity(0.4),
// // // // //                   ),
// // // // //                   if (item.status != '1') ...[
// // // // //                     const SizedBox(height: 8),
// // // // //                     Container(
// // // // //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// // // // //                       decoration: BoxDecoration(
// // // // //                         color: const Color(0xFFFF2D87).withOpacity(0.2),
// // // // //                         borderRadius: BorderRadius.circular(4),
// // // // //                         border: Border.all(color: const Color(0xFFFF2D87), width: 0.5),
// // // // //                       ),
// // // // //                       child: const Text(
// // // // //                         'PENDING',
// // // // //                         style: TextStyle(
// // // // //                           color: Color(0xFFFF2D87),
// // // // //                           fontSize: 9,
// // // // //                           fontWeight: FontWeight.bold,
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // Precise popup menu overlay positioning
// // // // //   void _showCardPopupMenu(
// // // // //     BuildContext context,
// // // // //     WidgetRef ref,
// // // // //     AlbumModel item,
// // // // //     Offset position,
// // // // //   ) async {
// // // // //     final result = await showMenu<String>(
// // // // //       context: context,
// // // // //       position: RelativeRect.fromLTRB(position.dx - 100, position.dy, position.dx, position.dy + 100),
// // // // //       color: Colors.white,
// // // // //       elevation: 8,
// // // // //       shape: RoundedRectangleBorder(
// // // // //         borderRadius: BorderRadius.circular(8),
// // // // //         side: const BorderSide(color: Color(0xFFE0E0E0)),
// // // // //       ),
// // // // //       items: [
// // // // //         const PopupMenuItem<String>(
// // // // //           value: 'add_photo',
// // // // //           child: Text('Add Photo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// // // // //         ),
// // // // //         const PopupMenuItem<String>(
// // // // //           value: 'add_video',
// // // // //           child: Text('Add Video', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// // // // //         ),
// // // // //         const PopupMenuItem<String>(
// // // // //           value: 'name_password',
// // // // //           child: Text('Name & Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// // // // //         ),
// // // // //         const PopupMenuItem<String>(
// // // // //           value: 'view',
// // // // //           child: Text('View', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
// // // // //         ),
// // // // //         const PopupMenuItem<String>(
// // // // //           value: 'delete',
// // // // //           child: Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
// // // // //         ),
// // // // //       ],
// // // // //     );

// // // // //     if (result == null) return;

// // // // //     switch (result) {
// // // // //       case 'add_photo':
// // // // //         _handlePopupAddPhoto(context, ref, item);
// // // // //         break;
// // // // //       case 'add_video':
// // // // //         _handlePopupAddVideo(context, ref, item);
// // // // //         break;
// // // // //       case 'name_password':
// // // // //         _handlePopupNamePassword(context, ref, item);
// // // // //         break;
// // // // //       case 'view':
// // // // //         _handlePopupView(context, ref, item);
// // // // //         break;
// // // // //       case 'delete':
// // // // //         _handlePopupDelete(context, ref, item);
// // // // //         break;
// // // // //     }
// // // // //   }

// // // // //   // ==========================================
// // // // //   // 5. POPUP OPTION HANDLERS
// // // // //   // ==========================================

// // // // //   // Add Photo: Picker -> Base64 -> Multiple Image Upload -> Link to Album ID -> Refetch
// // // // //   Future<void> _handlePopupAddPhoto(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // // // //     final source = await _chooseMediaSource(context, isVideo: false);
// // // // //     if (source == null) return;

// // // // //     final pickedFile = await ImagePicker().pickImage(
// // // // //       source: source,
// // // // //       imageQuality: 85,
// // // // //     );
// // // // //     if (pickedFile == null) return;

// // // // //     final navigator = Navigator.of(context);
// // // // //     _showLoadingOverlay(context);

// // // // //     try {
// // // // //       final bytes = await pickedFile.readAsBytes();
// // // // //       final base64Str = base64Encode(bytes);
// // // // //       final ext = pickedFile.path.split('.').last.toLowerCase();
// // // // //       final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
// // // // //       final dataUri = 'data:$mimeType;base64,$base64Str';

// // // // //       final service = ref.read(albumServiceProvider);
// // // // //       final imageName = await service.uploadImageMultiple(dataUri);

// // // // //       if (imageName != null) {
// // // // //         final success = await service.linkImageToAlbum(imageName, item.id);
// // // // //         navigator.pop(); // Dismiss loader safely using captured navigator reference

// // // // //         if (success) {
// // // // //           _showSnackBar(context, 'Photo uploaded and linked to album successfully.');
// // // // //           ref.read(albumsProvider.notifier).fetchAlbums();
// // // // //         } else {
// // // // //           _showSnackBar(context, 'Photo uploaded but link failed.');
// // // // //         }
// // // // //       } else {
// // // // //         navigator.pop(); // Dismiss loader safely using captured navigator reference
// // // // //         _showSnackBar(context, 'Failed to upload photo.');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // // // //       _showSnackBar(context, 'Error uploading photo: $e');
// // // // //     }
// // // // //   }

// // // // //   // Add Video: Pick -> Multipart Video Upload -> Refetch
// // // // //   Future<void> _handlePopupAddVideo(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // // // //     final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
// // // // //     if (pickedFile == null) return;

// // // // //     final navigator = Navigator.of(context);
// // // // //     _showLoadingOverlay(context);

// // // // //     try {
// // // // //       final service = ref.read(albumServiceProvider);
// // // // //       final fileName = await service.uploadVideo(File(pickedFile.path));
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// // // // //       if (fileName != null) {
// // // // //         _showSnackBar(context, 'Video uploaded successfully.');
// // // // //         ref.read(albumsProvider.notifier).fetchAlbums();
// // // // //       } else {
// // // // //         _showSnackBar(context, 'Failed to upload video.');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // // // //       _showSnackBar(context, 'Error uploading video: $e');
// // // // //     }
// // // // //   }

// // // // //   // Name & Password: Fetch details -> Prefill custom Dialog -> Update -> Refetch
// // // // //   Future<void> _handlePopupNamePassword(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // // // //     final navigator = Navigator.of(context);
// // // // //     _showLoadingOverlay(context);

// // // // //     try {
// // // // //       final service = ref.read(albumServiceProvider);
// // // // //       final details = await service.getAlbumDetails(item.id);
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// // // // //       if (details != null) {
// // // // //         _showAddAlbumDialog(context, ref, editDetails: details);
// // // // //       } else {
// // // // //         _showSnackBar(context, 'Failed to load album details.');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // // // //       _showSnackBar(context, 'Error: $e');
// // // // //     }
// // // // //   }

// // // // //   // View: Fetch images for this album -> Render elegant bottom sheet
// // // // //   Future<void> _handlePopupView(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // // // //     final navigator = Navigator.of(context);
// // // // //     _showLoadingOverlay(context);

// // // // //     try {
// // // // //       final service = ref.read(albumServiceProvider);
// // // // //       final images = await service.getAlbumImages(item.id);
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// // // // //       if (images.isEmpty) {
// // // // //         _showSnackBar(context, 'No images found in this album.');
// // // // //         return;
// // // // //       }

// // // // //       showModalBottomSheet(
// // // // //         context: context,
// // // // //         isScrollControlled: true,
// // // // //         backgroundColor: Colors.black87,
// // // // //         shape: const RoundedRectangleBorder(
// // // // //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // // // //         ),
// // // // //         builder: (context) {
// // // // //           return DraggableScrollableSheet(
// // // // //             expand: false,
// // // // //             initialChildSize: 0.6,
// // // // //             maxChildSize: 0.9,
// // // // //             builder: (context, scrollController) {
// // // // //               return Column(
// // // // //                 children: [
// // // // //                   const SizedBox(height: 12),
// // // // //                   Container(
// // // // //                     width: 40,
// // // // //                     height: 5,
// // // // //                     decoration: BoxDecoration(
// // // // //                       color: Colors.white24,
// // // // //                       borderRadius: BorderRadius.circular(10),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const Padding(
// // // // //                     padding: EdgeInsets.all(16.0),
// // // // //                     child: Text(
// // // // //                       'Album Photos',
// // // // //                       style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// // // // //                     ),
// // // // //                   ),
// // // // //                   Expanded(
// // // // //                     child: GridView.builder(
// // // // //                       controller: scrollController,
// // // // //                       padding: const EdgeInsets.all(16),
// // // // //                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // //                         crossAxisCount: 3,
// // // // //                         crossAxisSpacing: 10,
// // // // //                         mainAxisSpacing: 10,
// // // // //                       ),
// // // // //                       itemCount: images.length,
// // // // //                       itemBuilder: (context, index) {
// // // // //                         return ClipRRect(
// // // // //                           borderRadius: BorderRadius.circular(8),
// // // // //                           child: Image.network(
// // // // //                             images[index].image,
// // // // //                             fit: BoxFit.cover,
// // // // //                             errorBuilder: (_, __, ___) => Container(
// // // // //                               color: Colors.grey[800],
// // // // //                               child: const Icon(Icons.image_not_supported, color: Colors.white38),
// // // // //                             ),
// // // // //                           ),
// // // // //                         );
// // // // //                       },
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               );
// // // // //             },
// // // // //           );
// // // // //         },
// // // // //       );
// // // // //     } catch (e) {
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // // // //       _showSnackBar(context, 'Error retrieving images: $e');
// // // // //     }
// // // // //   }

// // // // //   // Delete Album: Confirms -> Deletes -> Refetch
// // // // //   Future<void> _handlePopupDelete(BuildContext context, WidgetRef ref, AlbumModel item) async {
// // // // //     final confirm = await showDialog<bool>(
// // // // //       context: context,
// // // // //       builder: (context) {
// // // // //         return AlertDialog(
// // // // //           title: const Text('Delete Album'),
// // // // //           content: Text('Are you sure you want to delete the album "${item.albumName}"?'),
// // // // //           actions: [
// // // // //             TextButton(
// // // // //               onPressed: () => Navigator.pop(context, false),
// // // // //               child: const Text('Cancel'),
// // // // //             ),
// // // // //             ElevatedButton(
// // // // //               onPressed: () => Navigator.pop(context, true),
// // // // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
// // // // //               child: const Text('Delete', style: TextStyle(color: Colors.white)),
// // // // //             ),
// // // // //           ],
// // // // //         );
// // // // //       },
// // // // //     );

// // // // //     if (confirm != true) return;

// // // // //     final navigator = Navigator.of(context);
// // // // //     _showLoadingOverlay(context);

// // // // //     try {
// // // // //       final success = await ref.read(albumsProvider.notifier).deleteAlbum(item.id);
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference

// // // // //       if (success) {
// // // // //         _showSnackBar(context, 'Album deleted successfully.');
// // // // //       } else {
// // // // //         _showSnackBar(context, 'Failed to delete album.');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       navigator.pop(); // Dismiss loader safely using captured navigator reference
// // // // //       _showSnackBar(context, 'Error deleting album: $e');
// // // // //     }
// // // // //   }

// // // // //   // ==========================================
// // // // //   // 6. HELPER OVERLAYS AND DIALOGS
// // // // //   // ==========================================

// // // // //   Future<ImageSource?> _chooseMediaSource(BuildContext context, {required bool isVideo}) async {
// // // // //     return showModalBottomSheet<ImageSource>(
// // // // //       context: context,
// // // // //       builder: (context) {
// // // // //         return SafeArea(
// // // // //           child: Column(
// // // // //             mainAxisSize: MainAxisSize.min,
// // // // //             children: [
// // // // //               ListTile(
// // // // //                 leading: const Icon(Icons.photo_library_outlined),
// // // // //                 title: const Text('Choose from Gallery'),
// // // // //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// // // // //               ),
// // // // //               if (!isVideo)
// // // // //                 ListTile(
// // // // //                   leading: const Icon(Icons.camera_alt_outlined),
// // // // //                   title: const Text('Take Photo'),
// // // // //                   onTap: () => Navigator.pop(context, ImageSource.camera),
// // // // //                 ),
// // // // //             ],
// // // // //           ),
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }

// // // // //   void _showLoadingOverlay(BuildContext context) {
// // // // //     showDialog(
// // // // //       context: context,
// // // // //       barrierDismissible: false,
// // // // //       builder: (context) => const Center(
// // // // //         child: CircularProgressIndicator(
// // // // //           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // Edit / Add Album Form Dialog (Matches third screenshot perfectly and handles async safely)
// // // // //   void _showAddAlbumDialog(
// // // // //     BuildContext context,
// // // // //     WidgetRef ref, {
// // // // //     AlbumDetailsModel? editDetails,
// // // // //   }) {
// // // // //     final nameController = TextEditingController(text: editDetails?.albumName ?? '');
// // // // //     final passwordController = TextEditingController(text: editDetails?.albumPassword ?? '');
// // // // //     final isEditing = editDetails != null;

// // // // //     showDialog(
// // // // //       context: context,
// // // // //       barrierDismissible: true,
// // // // //       builder: (dialogContext) {
// // // // //         bool isLoading = false;

// // // // //         return StatefulBuilder(
// // // // //           builder: (context, setState) {
// // // // //             return Dialog(
// // // // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // //               child: SingleChildScrollView(
// // // // //                 child: Column(
// // // // //                   mainAxisSize: MainAxisSize.min,
// // // // //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// // // // //                   children: [
// // // // //                     // Header Bar (Matches design exactly)
// // // // //                     Container(
// // // // //                       height: 52,
// // // // //                       padding: const EdgeInsets.symmetric(horizontal: 16),
// // // // //                       decoration: const BoxDecoration(
// // // // //                         gradient: LinearGradient(
// // // // //                           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // //                         ),
// // // // //                         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
// // // // //                       ),
// // // // //                       child: Row(
// // // // //                         children: [
// // // // //                           const Icon(Icons.create_new_folder_outlined, color: Colors.white, size: 22),
// // // // //                           const SizedBox(width: 8),
// // // // //                           Text(
// // // // //                             isEditing ? 'Edit Album' : 'Add Album',
// // // // //                             style: const TextStyle(
// // // // //                               color: Colors.white,
// // // // //                               fontSize: 18,
// // // // //                               fontWeight: FontWeight.bold,
// // // // //                         ),
// // // // //                       ),
// // // // //                       const Spacer(),
// // // // //                       if (!isLoading)
// // // // //                         IconButton(
// // // // //                           onPressed: () => Navigator.pop(dialogContext),
// // // // //                           icon: const Icon(Icons.close, color: Colors.white, size: 20),
// // // // //                           padding: EdgeInsets.zero,
// // // // //                           constraints: const BoxConstraints(),
// // // // //                         ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),

// // // // //                 // Form Textfields
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.all(20.0),
// // // // //                   child: Column(
// // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                     children: [
// // // // //                       const Text(
// // // // //                         'Album Name',
// // // // //                         style: TextStyle(
// // // // //                           fontWeight: FontWeight.bold,
// // // // //                           color: Colors.black87,
// // // // //                           fontSize: 14,
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(height: 8),
// // // // //                       TextField(
// // // // //                         controller: nameController,
// // // // //                         enabled: !isLoading,
// // // // //                         decoration: InputDecoration(
// // // // //                           hintText: 'Enter album name',
// // // // //                           fillColor: const Color(0xFFF2F4F7),
// // // // //                           filled: true,
// // // // //                           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // // // //                           border: OutlineInputBorder(
// // // // //                             borderRadius: BorderRadius.circular(8),
// // // // //                             borderSide: BorderSide(color: Colors.grey.shade300),
// // // // //                           ),
// // // // //                           enabledBorder: OutlineInputBorder(
// // // // //                             borderRadius: BorderRadius.circular(8),
// // // // //                             borderSide: BorderSide(color: Colors.grey.shade300),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(height: 16),
// // // // //                       const Text(
// // // // //                         'Album Password',
// // // // //                         style: TextStyle(
// // // // //                           fontWeight: FontWeight.bold,
// // // // //                           color: Colors.black87,
// // // // //                           fontSize: 14,
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(height: 8),
// // // // //                       TextField(
// // // // //                         controller: passwordController,
// // // // //                         enabled: !isLoading,
// // // // //                         obscureText: false, // Visible text matching screenshot
// // // // //                         decoration: InputDecoration(
// // // // //                           hintText: 'Enter password',
// // // // //                           fillColor: const Color(0xFFF2F4F7),
// // // // //                           filled: true,
// // // // //                           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // // // //                           border: OutlineInputBorder(
// // // // //                             borderRadius: BorderRadius.circular(8),
// // // // //                             borderSide: BorderSide(color: Colors.grey.shade300),
// // // // //                           ),
// // // // //                           enabledBorder: OutlineInputBorder(
// // // // //                             borderRadius: BorderRadius.circular(8),
// // // // //                             borderSide: BorderSide(color: Colors.grey.shade300),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(height: 24),

// // // // //                       // Save Button or Loading Spinner
// // // // //                       Row(
// // // // //                         mainAxisAlignment: MainAxisAlignment.end,
// // // // //                         children: [
// // // // //                           if (isLoading)
// // // // //                             const Padding(
// // // // //                               padding: EdgeInsets.symmetric(horizontal: 24.0),
// // // // //                               child: CircularProgressIndicator(
// // // // //                                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D87)),
// // // // //                               ),
// // // // //                             )
// // // // //                           else
// // // // //                             ElevatedButton(
// // // // //                               onPressed: () async {
// // // // //                                 final name = nameController.text.trim();
// // // // //                                 final password = passwordController.text.trim();

// // // // //                                 if (name.isEmpty || password.isEmpty) {
// // // // //                                   _showSnackBar(dialogContext, 'Please enter both name and password.');
// // // // //                                   return;
// // // // //                                 }

// // // // //                                 setState(() {
// // // // //                                   isLoading = true;
// // // // //                                 });

// // // // //                                 bool success;
// // // // //                                 try {
// // // // //                                   if (isEditing) {
// // // // //                                     success = await ref
// // // // //                                         .read(albumsProvider.notifier)
// // // // //                                         .updateAlbum(editDetails.id, name, password);
// // // // //                                   } else {
// // // // //                                     success = await ref
// // // // //                                         .read(albumsProvider.notifier)
// // // // //                                         .createAlbum(name, password);
// // // // //                                   }
// // // // //                                 } catch (_) {
// // // // //                                   success = false;
// // // // //                                 }

// // // // //                                 if (success) {
// // // // //                                   Navigator.pop(dialogContext); // Safely close the dialog
// // // // //                                   _showSnackBar(
// // // // //                                     context, // Show on parent context safely
// // // // //                                     isEditing
// // // // //                                         ? 'Album updated successfully!'
// // // // //                                         : 'Album created successfully!',
// // // // //                                   );
// // // // //                                 } else {
// // // // //                                   setState(() {
// // // // //                                     isLoading = false;
// // // // //                                   });
// // // // //                                   _showSnackBar(dialogContext, 'Failed to save album.');
// // // // //                                 }
// // // // //                               },
// // // // //                               style: ElevatedButton.styleFrom(
// // // // //                                 backgroundColor: const Color(0xFF220027),
// // // // //                                 foregroundColor: Colors.white,
// // // // //                                 shape: RoundedRectangleBorder(
// // // // //                                   borderRadius: BorderRadius.circular(8),
// // // // //                                 ),
// // // // //                                 padding: const EdgeInsets.symmetric(
// // // // //                                   horizontal: 24,
// // // // //                                   vertical: 12,
// // // // //                                 ),
// // // // //                               ),
// // // // //                               child: const Text(
// // // // //                                 'Save',
// // // // //                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// // // // //                               ),
// // // // //                             ),
// // // // //                         ],
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             );
// // // // //           },
// // // // //         );
// // // // //       },
// // // // //     );
// // // // //   }

// // // // //   void _showSnackBar(BuildContext context, String message) {
// // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // //       SnackBar(
// // // // //         content: Text(message),
// // // // //         duration: const Duration(seconds: 3),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // // import 'dart:convert';
// // // // // // // import 'dart:io';
// // // // // // //
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:image_picker/image_picker.dart';
// // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // //
// // // // // // // class MyProfileAlbumTab extends StatefulWidget {
// // // // // // //   const MyProfileAlbumTab({super.key});
// // // // // // //
// // // // // // //   @override
// // // // // // //   State<MyProfileAlbumTab> createState() => _MyProfileAlbumTabState();
// // // // // // // }
// // // // // // //
// // // // // // // class _MyProfileAlbumTabState extends State<MyProfileAlbumTab> {
// // // // // // //   static const String _pendingKey = 'profile_album_pending';
// // // // // // //   static const String _approvedKey = 'profile_album_approved';
// // // // // // //
// // // // // // //   final ImagePicker _picker = ImagePicker();
// // // // // // //   bool _showApproved = false;
// // // // // // //
// // // // // // //   List<_AlbumItem> _pendingItems = [
// // // // // // //     _AlbumItem(path: 'assets/images/notification-image1.jpg', approved: false, title: 'Weekend Party'),
// // // // // // //     _AlbumItem(path: 'assets/images/notification-image5.jpg', approved: false, title: 'Beach Night'),
// // // // // // //   ];
// // // // // // //   List<_AlbumItem> _approvedItems = [
// // // // // // //     _AlbumItem(path: 'assets/images/notification-image4.jpg', approved: true, title: 'Main Album'),
// // // // // // //   ];
// // // // // // //
// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     _loadAlbums();
// // // // // // //   }
// // // // // // //
// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final list = _showApproved ? _approvedItems : _pendingItems;
// // // // // // //     final sectionTitle = _showApproved ? 'Approved Albums' : 'Pending Albums';
// // // // // // //     final width = MediaQuery.of(context).size.width;
// // // // // // //     final isCompact = width < 380;
// // // // // // //     final cardWidth = isCompact ? width - 64 : 220.0;
// // // // // // //
// // // // // // //     return Column(
// // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //       children: [
// // // // // // //         _statusTabs(),
// // // // // // //         const SizedBox(height: 12),
// // // // // // //         if (_showApproved) _infoStrip(),
// // // // // // //         if (_showApproved) const SizedBox(height: 16),
// // // // // // //         if (_showApproved)
// // // // // // //           Wrap(
// // // // // // //             spacing: 8,
// // // // // // //             runSpacing: 8,
// // // // // // //             crossAxisAlignment: WrapCrossAlignment.center,
// // // // // // //             children: [
// // // // // // //               Text(
// // // // // // //                 sectionTitle,
// // // // // // //                 style: TextStyle(fontSize: isCompact ? 24 : 28, fontWeight: FontWeight.w700),
// // // // // // //               ),
// // // // // // //               ElevatedButton.icon(
// // // // // // //                 onPressed: _addAlbumPhoto,
// // // // // // //                 icon: const Icon(Icons.add, size: 16),
// // // // // // //                 label: const Text('Add Album'),
// // // // // // //                 style: ElevatedButton.styleFrom(
// // // // // // //                   backgroundColor: const Color(0xFF220027),
// // // // // // //                   foregroundColor: Colors.white,
// // // // // // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           )
// // // // // // //         else
// // // // // // //           Text(
// // // // // // //             sectionTitle,
// // // // // // //             style: TextStyle(fontSize: isCompact ? 24 : 28, fontWeight: FontWeight.w700),
// // // // // // //           ),
// // // // // // //         const SizedBox(height: 14),
// // // // // // //         if (list.isEmpty)
// // // // // // //           Center(
// // // // // // //             child: Padding(
// // // // // // //               padding: const EdgeInsets.only(top: 24),
// // // // // // //               child: Text(
// // // // // // //                 _showApproved ? 'No approved albums.' : 'No pending albums.',
// // // // // // //                 style: TextStyle(color: Colors.grey[700], fontSize: 16),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           )
// // // // // // //         else
// // // // // // //           Wrap(
// // // // // // //             spacing: 14,
// // // // // // //             runSpacing: 14,
// // // // // // //             children: list.map((item) => _albumCard(item, cardWidth)).toList(),
// // // // // // //           ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _statusTabs() {
// // // // // // //     return Container(
// // // // // // //       height: 40,
// // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // // //         gradient: const LinearGradient(
// // // // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       child: Row(
// // // // // // //         children: [
// // // // // // //           _pillTab(
// // // // // // //             label: 'Approved',
// // // // // // //             selected: _showApproved,
// // // // // // //             onTap: () => setState(() => _showApproved = true),
// // // // // // //           ),
// // // // // // //           const Spacer(),
// // // // // // //           _pillTab(
// // // // // // //             label: 'Pending',
// // // // // // //             selected: !_showApproved,
// // // // // // //             onTap: () => setState(() => _showApproved = false),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _pillTab({
// // // // // // //     required String label,
// // // // // // //     required bool selected,
// // // // // // //     required VoidCallback onTap,
// // // // // // //   }) {
// // // // // // //     return InkWell(
// // // // // // //       onTap: onTap,
// // // // // // //       borderRadius: BorderRadius.circular(16),
// // // // // // //       child: Container(
// // // // // // //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// // // // // // //         decoration: BoxDecoration(
// // // // // // //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// // // // // // //           borderRadius: BorderRadius.circular(16),
// // // // // // //         ),
// // // // // // //         child: Text(
// // // // // // //           label,
// // // // // // //           style: const TextStyle(
// // // // // // //             color: Colors.white,
// // // // // // //             fontSize: 11,
// // // // // // //             fontWeight: FontWeight.w700,
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _infoStrip() {
// // // // // // //     return Container(
// // // // // // //       width: double.infinity,
// // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         borderRadius: BorderRadius.circular(4),
// // // // // // //         border: Border.all(color: const Color(0xFF2D1935)),
// // // // // // //       ),
// // // // // // //       child: const Row(
// // // // // // //         children: [
// // // // // // //           Icon(Icons.collections_outlined, size: 16),
// // // // // // //           SizedBox(width: 8),
// // // // // // //           Expanded(
// // // // // // //             child: Text(
// // // // // // //               'Only high-quality album photos are approved. Avoid contact info in images.',
// // // // // // //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _albumCard(_AlbumItem item, double width) {
// // // // // // //     return Container(
// // // // // // //       width: width,
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.white,
// // // // // // //         borderRadius: BorderRadius.circular(14),
// // // // // // //         border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // // // //         boxShadow: [
// // // // // // //           BoxShadow(
// // // // // // //             color: Colors.black.withValues(alpha: 0.05),
// // // // // // //             blurRadius: 10,
// // // // // // //             offset: const Offset(0, 4),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           Stack(
// // // // // // //             children: [
// // // // // // //               ClipRRect(
// // // // // // //                 borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
// // // // // // //                 child: item.xFile != null
// // // // // // //                     ? Image.file(
// // // // // // //                         File(item.xFile!.path),
// // // // // // //                         height: 170,
// // // // // // //                         width: double.infinity,
// // // // // // //                         fit: BoxFit.cover,
// // // // // // //                         errorBuilder: (_, __, ___) => _fallbackImage(),
// // // // // // //                       )
// // // // // // //                     : Image.asset(
// // // // // // //                         item.path,
// // // // // // //                         height: 170,
// // // // // // //                         width: double.infinity,
// // // // // // //                         fit: BoxFit.cover,
// // // // // // //                         errorBuilder: (_, __, ___) => _fallbackImage(),
// // // // // // //                       ),
// // // // // // //               ),
// // // // // // //               Positioned(
// // // // // // //                 left: 8,
// // // // // // //                 top: 8,
// // // // // // //                 child: Container(
// // // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// // // // // // //                   decoration: BoxDecoration(
// // // // // // //                     color: item.approved ? const Color(0xFF20B35D) : const Color(0xFFF7D12D),
// // // // // // //                     borderRadius: BorderRadius.circular(8),
// // // // // // //                   ),
// // // // // // //                   child: Text(
// // // // // // //                     item.approved ? 'APPROVED' : 'PENDING',
// // // // // // //                     style: const TextStyle(
// // // // // // //                       color: Colors.white,
// // // // // // //                       fontSize: 10,
// // // // // // //                       fontWeight: FontWeight.w700,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               Positioned(
// // // // // // //                 right: 8,
// // // // // // //                 top: 8,
// // // // // // //                 child: CircleAvatar(
// // // // // // //                   radius: 12,
// // // // // // //                   backgroundColor: const Color(0xFFFF4473),
// // // // // // //                   child: IconButton(
// // // // // // //                     icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
// // // // // // //                     onPressed: () => _deleteAlbum(item),
// // // // // // //                     padding: EdgeInsets.zero,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //           Padding(
// // // // // // //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// // // // // // //             child: Row(
// // // // // // //               children: [
// // // // // // //                 Icon(
// // // // // // //                   item.approved ? Icons.check_circle_outline : Icons.access_time,
// // // // // // //                   size: 14,
// // // // // // //                   color: Colors.black54,
// // // // // // //                 ),
// // // // // // //                 const SizedBox(width: 6),
// // // // // // //                 Expanded(
// // // // // // //                   child: Text(
// // // // // // //                     '${item.title} • ${item.approved ? 'Approved' : 'Awaiting Approval'}',
// // // // // // //                     maxLines: 1,
// // // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // // //                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> _addAlbumPhoto() async {
// // // // // // //     final source = await _chooseSource();
// // // // // // //     if (source == null) return;
// // // // // // //
// // // // // // //     final picked = await _picker.pickImage(
// // // // // // //       source: source,
// // // // // // //       imageQuality: 85,
// // // // // // //       maxWidth: 1600,
// // // // // // //     );
// // // // // // //     if (picked == null) return;
// // // // // // //
// // // // // // //     setState(() {
// // // // // // //       _pendingItems.insert(
// // // // // // //         0,
// // // // // // //         _AlbumItem(
// // // // // // //           path: picked.path,
// // // // // // //           approved: false,
// // // // // // //           title: 'New Album Photo',
// // // // // // //           xFile: picked,
// // // // // // //         ),
// // // // // // //       );
// // // // // // //       _showApproved = false;
// // // // // // //     });
// // // // // // //     await _persistAlbums();
// // // // // // //
// // // // // // //     if (!mounted) return;
// // // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //       const SnackBar(content: Text('Album photo added to pending approval')),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<ImageSource?> _chooseSource() async {
// // // // // // //     return showModalBottomSheet<ImageSource>(
// // // // // // //       context: context,
// // // // // // //       builder: (context) {
// // // // // // //         return SafeArea(
// // // // // // //           child: Column(
// // // // // // //             mainAxisSize: MainAxisSize.min,
// // // // // // //             children: [
// // // // // // //               ListTile(
// // // // // // //                 leading: const Icon(Icons.photo_library_outlined),
// // // // // // //                 title: const Text('Choose from Gallery'),
// // // // // // //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// // // // // // //               ),
// // // // // // //               ListTile(
// // // // // // //                 leading: const Icon(Icons.camera_alt_outlined),
// // // // // // //                 title: const Text('Take Photo'),
// // // // // // //                 onTap: () => Navigator.pop(context, ImageSource.camera),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         );
// // // // // // //       },
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   void _deleteAlbum(_AlbumItem item) {
// // // // // // //     setState(() {
// // // // // // //       if (item.approved) {
// // // // // // //         _approvedItems.remove(item);
// // // // // // //       } else {
// // // // // // //         _pendingItems.remove(item);
// // // // // // //       }
// // // // // // //     });
// // // // // // //     _persistAlbums();
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> _loadAlbums() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     final pendingRaw = prefs.getString(_pendingKey);
// // // // // // //     final approvedRaw = prefs.getString(_approvedKey);
// // // // // // //
// // // // // // //     List<_AlbumItem> decode(String? raw) {
// // // // // // //       if (raw == null || raw.isEmpty) return [];
// // // // // // //       try {
// // // // // // //         final decoded = jsonDecode(raw);
// // // // // // //         if (decoded is! List) return [];
// // // // // // //         return decoded
// // // // // // //             .whereType<Map>()
// // // // // // //             .map((e) => _AlbumItem.fromJson(Map<String, dynamic>.from(e)))
// // // // // // //             .toList();
// // // // // // //       } catch (_) {
// // // // // // //         return [];
// // // // // // //       }
// // // // // // //     }
// // // // // // //
// // // // // // //     final p = decode(pendingRaw);
// // // // // // //     final a = decode(approvedRaw);
// // // // // // //     if (!mounted) return;
// // // // // // //     setState(() {
// // // // // // //       if (p.isNotEmpty) _pendingItems = p;
// // // // // // //       if (a.isNotEmpty) _approvedItems = a;
// // // // // // //     });
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> _persistAlbums() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     await prefs.setString(
// // // // // // //       _pendingKey,
// // // // // // //       jsonEncode(_pendingItems.map((e) => e.toJson()).toList()),
// // // // // // //     );
// // // // // // //     await prefs.setString(
// // // // // // //       _approvedKey,
// // // // // // //       jsonEncode(_approvedItems.map((e) => e.toJson()).toList()),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _fallbackImage() {
// // // // // // //     return Container(
// // // // // // //       height: 170,
// // // // // // //       width: double.infinity,
// // // // // // //       color: Colors.grey[200],
// // // // // // //       alignment: Alignment.center,
// // // // // // //       child: const Icon(Icons.image_not_supported_outlined),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // //
// // // // // // // class _AlbumItem {
// // // // // // //   const _AlbumItem({
// // // // // // //     required this.path,
// // // // // // //     required this.approved,
// // // // // // //     required this.title,
// // // // // // //     this.xFile,
// // // // // // //   });
// // // // // // //
// // // // // // //   final String path;
// // // // // // //   final bool approved;
// // // // // // //   final String title;
// // // // // // //   final XFile? xFile;
// // // // // // //
// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'path': path,
// // // // // // //       'approved': approved,
// // // // // // //       'title': title,
// // // // // // //       'isLocal': xFile != null,
// // // // // // //     };
// // // // // // //   }
// // // // // // //
// // // // // // //   factory _AlbumItem.fromJson(Map<String, dynamic> json) {
// // // // // // //     final path = (json['path'] ?? '').toString();
// // // // // // //     final isLocal = json['isLocal'] == true;
// // // // // // //     return _AlbumItem(
// // // // // // //       path: path,
// // // // // // //       approved: json['approved'] == true,
// // // // // // //       title: (json['title'] ?? 'Album Photo').toString(),
// // // // // // //       xFile: isLocal && path.isNotEmpty ? XFile(path) : null,
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // import 'dart:io';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import 'package:image_picker/image_picker.dart';
// // // // // // import 'package:beatflirt/providers/album_providers.dart';

// // // // // // // ✅ Changed to ConsumerWidget
// // // // // // class MyProfileAlbumTab extends ConsumerWidget {
// // // // // //   const MyProfileAlbumTab({super.key});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // // // //     // ✅ Watch providers
// // // // // //     final showApproved = ref.watch(albumTabProvider);
// // // // // //     final pendingItems = ref.watch(pendingAlbumsProvider);
// // // // // //     final approvedItems = ref.watch(approvedAlbumsProvider);

// // // // // //     final list = showApproved ? approvedItems : pendingItems;
// // // // // //     final sectionTitle = showApproved ? 'Approved Albums' : 'Pending Albums';
// // // // // //     final width = MediaQuery.of(context).size.width;
// // // // // //     final isCompact = width < 380;
// // // // // //     final cardWidth = isCompact ? width - 64 : 220.0;

// // // // // //     return Column(
// // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //       children: [
// // // // // //         _buildStatusTabs(context, ref, showApproved),
// // // // // //         const SizedBox(height: 12),
// // // // // //         if (showApproved) _buildInfoStrip(),
// // // // // //         if (showApproved) const SizedBox(height: 16),
// // // // // //         if (showApproved)
// // // // // //           Wrap(
// // // // // //             spacing: 8,
// // // // // //             runSpacing: 8,
// // // // // //             crossAxisAlignment: WrapCrossAlignment.center,
// // // // // //             children: [
// // // // // //               Text(
// // // // // //                 sectionTitle,
// // // // // //                 style: TextStyle(
// // // // // //                   fontSize: isCompact ? 24 : 28,
// // // // // //                   fontWeight: FontWeight.w700,
// // // // // //                 ),
// // // // // //               ),
// // // // // //               ElevatedButton.icon(
// // // // // //                 onPressed: () => _addAlbumPhoto(context, ref),
// // // // // //                 icon: const Icon(Icons.add, size: 16),
// // // // // //                 label: const Text('Add Album'),
// // // // // //                 style: ElevatedButton.styleFrom(
// // // // // //                   backgroundColor: const Color(0xFF220027),
// // // // // //                   foregroundColor: Colors.white,
// // // // // //                   shape: RoundedRectangleBorder(
// // // // // //                     borderRadius: BorderRadius.circular(20),
// // // // // //                   ),
// // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // //                     horizontal: 16,
// // // // // //                     vertical: 10,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           )
// // // // // //         else
// // // // // //           Text(
// // // // // //             sectionTitle,
// // // // // //             style: TextStyle(
// // // // // //               fontSize: isCompact ? 24 : 28,
// // // // // //               fontWeight: FontWeight.w700,
// // // // // //             ),
// // // // // //           ),
// // // // // //         const SizedBox(height: 14),
// // // // // //         if (list.isEmpty)
// // // // // //           Center(
// // // // // //             child: Padding(
// // // // // //               padding: const EdgeInsets.only(top: 24),
// // // // // //               child: Text(
// // // // // //                 showApproved ? 'No approved albums.' : 'No pending albums.',
// // // // // //                 style: TextStyle(color: Colors.grey[700], fontSize: 16),
// // // // // //               ),
// // // // // //             ),
// // // // // //           )
// // // // // //         else
// // // // // //           Wrap(
// // // // // //             spacing: 14,
// // // // // //             runSpacing: 14,
// // // // // //             children: list
// // // // // //                 .map((item) => _buildAlbumCard(context, ref, item, cardWidth))
// // // // // //                 .toList(),
// // // // // //           ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildStatusTabs(
// // // // // //     BuildContext context,
// // // // // //     WidgetRef ref,
// // // // // //     bool showApproved,
// // // // // //   ) {
// // // // // //     return Container(
// // // // // //       height: 40,
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
// // // // // //       decoration: BoxDecoration(
// // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // //         gradient: const LinearGradient(
// // // // // //           colors: [Color(0xFF19001F), Color(0xFF490040)],
// // // // // //         ),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           _buildPillTab(
// // // // // //             label: 'Approved',
// // // // // //             selected: showApproved,
// // // // // //             onTap: () {
// // // // // //               // ✅ Update provider instead of setState
// // // // // //               ref.read(albumTabProvider.notifier).state = true;
// // // // // //             },
// // // // // //           ),
// // // // // //           const Spacer(),
// // // // // //           _buildPillTab(
// // // // // //             label: 'Pending',
// // // // // //             selected: !showApproved,
// // // // // //             onTap: () {
// // // // // //               // ✅ Update provider instead of setState
// // // // // //               ref.read(albumTabProvider.notifier).state = false;
// // // // // //             },
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildPillTab({
// // // // // //     required String label,
// // // // // //     required bool selected,
// // // // // //     required VoidCallback onTap,
// // // // // //   }) {
// // // // // //     return InkWell(
// // // // // //       onTap: onTap,
// // // // // //       borderRadius: BorderRadius.circular(16),
// // // // // //       child: Container(
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
// // // // // //           borderRadius: BorderRadius.circular(16),
// // // // // //         ),
// // // // // //         child: Text(
// // // // // //           label,
// // // // // //           style: const TextStyle(
// // // // // //             color: Colors.white,
// // // // // //             fontSize: 11,
// // // // // //             fontWeight: FontWeight.w700,
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildInfoStrip() {
// // // // // //     return Container(
// // // // // //       width: double.infinity,
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // // // // //       decoration: BoxDecoration(
// // // // // //         borderRadius: BorderRadius.circular(4),
// // // // // //         border: Border.all(color: const Color(0xFF2D1935)),
// // // // // //       ),
// // // // // //       child: const Row(
// // // // // //         children: [
// // // // // //           Icon(Icons.collections_outlined, size: 16),
// // // // // //           SizedBox(width: 8),
// // // // // //           Expanded(
// // // // // //             child: Text(
// // // // // //               'Only high-quality album photos are approved. Avoid contact info in images.',
// // // // // //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildAlbumCard(
// // // // // //     BuildContext context,
// // // // // //     WidgetRef ref,
// // // // // //     AlbumItem item,
// // // // // //     double width,
// // // // // //   ) {
// // // // // //     return Container(
// // // // // //       width: width,
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(14),
// // // // // //         border: Border.all(color: const Color(0xFFE8E0F2)),
// // // // // //         boxShadow: [
// // // // // //           BoxShadow(
// // // // // //             color: Colors.black.withValues(alpha: 0.05),
// // // // // //             blurRadius: 10,
// // // // // //             offset: const Offset(0, 4),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           Stack(
// // // // // //             children: [
// // // // // //               ClipRRect(
// // // // // //                 borderRadius: const BorderRadius.vertical(
// // // // // //                   top: Radius.circular(14),
// // // // // //                 ),
// // // // // //                 child: SizedBox(
// // // // // //                   height: 170,
// // // // // //                   width: double.infinity,
// // // // // //                   child: item.xFile != null
// // // // // //                       ? Image.file(
// // // // // //                           File(item.xFile!.path),
// // // // // //                           fit: BoxFit.cover,
// // // // // //                           errorBuilder: (_, _, _) => _buildFallbackImage(),
// // // // // //                         )
// // // // // //                       : Image.asset(
// // // // // //                           item.path,
// // // // // //                           fit: BoxFit.cover,
// // // // // //                           errorBuilder: (_, _, _) => _buildFallbackImage(),
// // // // // //                         ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               Positioned(
// // // // // //                 left: 8,
// // // // // //                 top: 8,
// // // // // //                 child: Container(
// // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // //                     horizontal: 8,
// // // // // //                     vertical: 3,
// // // // // //                   ),
// // // // // //                   decoration: BoxDecoration(
// // // // // //                     color: item.approved
// // // // // //                         ? const Color(0xFF20B35D)
// // // // // //                         : const Color(0xFFF7D12D),
// // // // // //                     borderRadius: BorderRadius.circular(8),
// // // // // //                   ),
// // // // // //                   child: Text(
// // // // // //                     item.approved ? 'APPROVED' : 'PENDING',
// // // // // //                     style: const TextStyle(
// // // // // //                       color: Colors.white,
// // // // // //                       fontSize: 10,
// // // // // //                       fontWeight: FontWeight.w700,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               Positioned(
// // // // // //                 right: 8,
// // // // // //                 top: 8,
// // // // // //                 child: CircleAvatar(
// // // // // //                   radius: 12,
// // // // // //                   backgroundColor: const Color(0xFFFF4473),
// // // // // //                   child: IconButton(
// // // // // //                     icon: const Icon(
// // // // // //                       Icons.delete_outline,
// // // // // //                       size: 14,
// // // // // //                       color: Colors.white,
// // // // // //                     ),
// // // // // //                     onPressed: () => _deleteAlbum(ref, item),
// // // // // //                     padding: EdgeInsets.zero,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           Padding(
// // // // // //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// // // // // //             child: Row(
// // // // // //               children: [
// // // // // //                 Icon(
// // // // // //                   item.approved
// // // // // //                       ? Icons.check_circle_outline
// // // // // //                       : Icons.access_time,
// // // // // //                   size: 14,
// // // // // //                   color: Colors.black54,
// // // // // //                 ),
// // // // // //                 const SizedBox(width: 6),
// // // // // //                 Expanded(
// // // // // //                   child: Text(
// // // // // //                     '${item.title} • ${item.approved ? 'Approved' : 'Awaiting Approval'}',
// // // // // //                     maxLines: 1,
// // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // //                     style: const TextStyle(
// // // // // //                       fontSize: 12,
// // // // // //                       fontWeight: FontWeight.w600,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Future<void> _addAlbumPhoto(BuildContext context, WidgetRef ref) async {
// // // // // //     final source = await _chooseSource(context);
// // // // // //     if (source == null) return;

// // // // // //     final picker = ImagePicker();
// // // // // //     final picked = await picker.pickImage(
// // // // // //       source: source,
// // // // // //       imageQuality: 85,
// // // // // //       maxWidth: 1600,
// // // // // //     );
// // // // // //     if (picked == null) return;

// // // // // //     // ✅ Add photo using unified provider
// // // // // //     ref.read(albumProvider.notifier).addAlbum(picked);

// // // // // //     // ✅ Switch to pending tab
// // // // // //     ref.read(albumTabProvider.notifier).state = false;

// // // // // //     if (!context.mounted) return;
// // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // //       const SnackBar(content: Text('Album photo added to pending approval')),
// // // // // //     );
// // // // // //   }

// // // // // //   Future<ImageSource?> _chooseSource(BuildContext context) async {
// // // // // //     return showModalBottomSheet<ImageSource>(
// // // // // //       context: context,
// // // // // //       builder: (context) {
// // // // // //         return SafeArea(
// // // // // //           child: Column(
// // // // // //             mainAxisSize: MainAxisSize.min,
// // // // // //             children: [
// // // // // //               ListTile(
// // // // // //                 leading: const Icon(Icons.photo_library_outlined),
// // // // // //                 title: const Text('Choose from Gallery'),
// // // // // //                 onTap: () => Navigator.pop(context, ImageSource.gallery),
// // // // // //               ),
// // // // // //               ListTile(
// // // // // //                 leading: const Icon(Icons.camera_alt_outlined),
// // // // // //                 title: const Text('Take Photo'),
// // // // // //                 onTap: () => Navigator.pop(context, ImageSource.camera),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         );
// // // // // //       },
// // // // // //     );
// // // // // //   }

// // // // // //   void _deleteAlbum(WidgetRef ref, AlbumItem item) {
// // // // // //     // ✅ Delete using unified provider
// // // // // //     ref.read(albumProvider.notifier).removeAlbum(item.id);
// // // // // //   }

// // // // // //   Widget _buildFallbackImage() {
// // // // // //     return Container(
// // // // // //       height: 170,
// // // // // //       width: double.infinity,
// // // // // //       color: Colors.grey[200],
// // // // // //       alignment: Alignment.center,
// // // // // //       child: const Icon(Icons.image_not_supported_outlined),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // import '../../../providers/profile_provider.dart';
// // // // // // // import '../../../core/constants.dart';
// // // // // // //
// // // // // // // class AlbumTab extends ConsumerStatefulWidget {
// // // // // // //   const AlbumTab({super.key});
// // // // // // //
// // // // // // //   @override
// // // // // // //   ConsumerState<AlbumTab> createState() => _AlbumTabState();
// // // // // // // }
// // // // // // //
// // // // // // // class _AlbumTabState extends ConsumerState<AlbumTab> {
// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     Future.microtask(() {
// // // // // // //       ref.read(albumsProvider.notifier).fetchAlbums();
// // // // // // //     });
// // // // // // //   }
// // // // // // //
// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final albumsState = ref.watch(albumsProvider);
// // // // // // //
// // // // // // //     return Column(
// // // // // // //       children: [
// // // // // // //         // Header
// // // // // // //         _buildHeader(albumsState),
// // // // // // //
// // // // // // //         // Albums grid
// // // // // // //         Expanded(
// // // // // // //           child: albumsState.isLoading
// // // // // // //               ? _buildLoadingGrid()
// // // // // // //               : albumsState.albums.isEmpty
// // // // // // //               ? _buildEmptyState()
// // // // // // //               : _buildAlbumGrid(albumsState.albums),
// // // // // // //         ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildHeader(AlbumsState state) {
// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // //       decoration: const BoxDecoration(
// // // // // // //         color: AppColors.surface,
// // // // // // //         border: Border(
// // // // // // //           bottom: BorderSide(color: AppColors.divider, width: 0.5),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       child: Row(
// // // // // // //         children: [
// // // // // // //           const Icon(Icons.photo_album, color: AppColors.primary, size: 22),
// // // // // // //           const SizedBox(width: 10),
// // // // // // //           Text('My Albums', style: AppTextStyles.heading3),
// // // // // // //           const Spacer(),
// // // // // // //           Text(
// // // // // // //             '${state.albums.length} albums',
// // // // // // //             style: AppTextStyles.bodySmall,
// // // // // // //           ),
// // // // // // //           const SizedBox(width: 12),
// // // // // // //           Material(
// // // // // // //             color: AppColors.primary,
// // // // // // //             borderRadius: BorderRadius.circular(12),
// // // // // // //             child: InkWell(
// // // // // // //               borderRadius: BorderRadius.circular(12),
// // // // // // //               onTap: () => _showCreateAlbumDialog(),
// // // // // // //               child: Container(
// // // // // // //                 padding: const EdgeInsets.symmetric(
// // // // // // //                   horizontal: 16,
// // // // // // //                   vertical: 10,
// // // // // // //                 ),
// // // // // // //                 child: const Row(
// // // // // // //                   mainAxisSize: MainAxisSize.min,
// // // // // // //                   children: [
// // // // // // //                     Icon(Icons.add, color: Colors.white, size: 18),
// // // // // // //                     SizedBox(width: 6),
// // // // // // //                     Text(
// // // // // // //                       'Create',
// // // // // // //                       style: TextStyle(
// // // // // // //                         color: Colors.white,
// // // // // // //                         fontSize: 13,
// // // // // // //                         fontWeight: FontWeight.w600,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildEmptyState() {
// // // // // // //     return Center(
// // // // // // //       child: Padding(
// // // // // // //         padding: const EdgeInsets.all(48),
// // // // // // //         child: Column(
// // // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //           children: [
// // // // // // //             Container(
// // // // // // //               padding: const EdgeInsets.all(24),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 color: AppColors.primary.withOpacity(0.1),
// // // // // // //                 shape: BoxShape.circle,
// // // // // // //               ),
// // // // // // //               child: Icon(
// // // // // // //                 Icons.photo_album_outlined,
// // // // // // //                 size: 64,
// // // // // // //                 color: AppColors.primary.withOpacity(0.6),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 24),
// // // // // // //             const Text('No Albums Yet', style: AppTextStyles.heading2),
// // // // // // //             const SizedBox(height: 8),
// // // // // // //             Text(
// // // // // // //               'Create albums to organize your\nphotos and memories!',
// // // // // // //               style: AppTextStyles.bodyMedium,
// // // // // // //               textAlign: TextAlign.center,
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 24),
// // // // // // //             ElevatedButton.icon(
// // // // // // //               onPressed: () => _showCreateAlbumDialog(),
// // // // // // //               icon: const Icon(Icons.add),
// // // // // // //               label: const Text('Create Album'),
// // // // // // //               style: ElevatedButton.styleFrom(
// // // // // // //                 backgroundColor: AppColors.primary,
// // // // // // //                 foregroundColor: Colors.white,
// // // // // // //                 padding: const EdgeInsets.symmetric(
// // // // // // //                   horizontal: 32,
// // // // // // //                   vertical: 14,
// // // // // // //                 ),
// // // // // // //                 shape: RoundedRectangleBorder(
// // // // // // //                   borderRadius: BorderRadius.circular(14),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildLoadingGrid() {
// // // // // // //     return GridView.builder(
// // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // //         crossAxisCount: 2,
// // // // // // //         crossAxisSpacing: 12,
// // // // // // //         mainAxisSpacing: 12,
// // // // // // //         childAspectRatio: 0.85,
// // // // // // //       ),
// // // // // // //       itemCount: 4,
// // // // // // //       itemBuilder: (context, index) {
// // // // // // //         return Container(
// // // // // // //           decoration: BoxDecoration(
// // // // // // //             color: AppColors.cardDark,
// // // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // // //           ),
// // // // // // //           child: const Center(
// // // // // // //             child: CircularProgressIndicator(
// // // // // // //               color: AppColors.primary,
// // // // // // //               strokeWidth: 2,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         );
// // // // // // //       },
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildAlbumGrid(List<Map<String, dynamic>> albums) {
// // // // // // //     return GridView.builder(
// // // // // // //       physics: const BouncingScrollPhysics(),
// // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // //         crossAxisCount: 2,
// // // // // // //         crossAxisSpacing: 12,
// // // // // // //         mainAxisSpacing: 12,
// // // // // // //         childAspectRatio: 0.85,
// // // // // // //       ),
// // // // // // //       itemCount: albums.length,
// // // // // // //       itemBuilder: (context, index) {
// // // // // // //         return _buildAlbumCard(albums[index], index);
// // // // // // //       },
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildAlbumCard(Map<String, dynamic> album, int index) {
// // // // // // //     final name = album['name'] ?? 'Untitled Album';
// // // // // // //     final photos = (album['photos'] as List?)?.cast<String>() ?? [];
// // // // // // //     final photoCount = photos.length;
// // // // // // //
// // // // // // //     return GestureDetector(
// // // // // // //       onTap: () => _openAlbum(album),
// // // // // // //       onLongPress: () => _showAlbumOptions(index),
// // // // // // //       child: Container(
// // // // // // //         decoration: BoxDecoration(
// // // // // // //           color: AppColors.cardDark,
// // // // // // //           borderRadius: BorderRadius.circular(16),
// // // // // // //           border: Border.all(color: AppColors.divider, width: 0.5),
// // // // // // //           boxShadow: [
// // // // // // //             BoxShadow(
// // // // // // //               color: Colors.black.withOpacity(0.2),
// // // // // // //               blurRadius: 8,
// // // // // // //               offset: const Offset(0, 4),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //         child: Column(
// // // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //           children: [
// // // // // // //             // Cover image
// // // // // // //             Expanded(
// // // // // // //               child: ClipRRect(
// // // // // // //                 borderRadius: const BorderRadius.vertical(
// // // // // // //                   top: Radius.circular(16),
// // // // // // //                 ),
// // // // // // //                 child: photos.isNotEmpty
// // // // // // //                     ? Stack(
// // // // // // //                   fit: StackFit.expand,
// // // // // // //                   children: [
// // // // // // //                     Image.network(
// // // // // // //                       photos.first,
// // // // // // //                       fit: BoxFit.cover,
// // // // // // //                       errorBuilder: (_, __, ___) =>
// // // // // // //                           _buildAlbumPlaceholder(),
// // // // // // //                     ),
// // // // // // //                     // Photo count badge
// // // // // // //                     Positioned(
// // // // // // //                       top: 8,
// // // // // // //                       right: 8,
// // // // // // //                       child: Container(
// // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // //                           horizontal: 8,
// // // // // // //                           vertical: 4,
// // // // // // //                         ),
// // // // // // //                         decoration: BoxDecoration(
// // // // // // //                           color: Colors.black54,
// // // // // // //                           borderRadius: BorderRadius.circular(12),
// // // // // // //                         ),
// // // // // // //                         child: Row(
// // // // // // //                           mainAxisSize: MainAxisSize.min,
// // // // // // //                           children: [
// // // // // // //                             const Icon(
// // // // // // //                               Icons.photo,
// // // // // // //                               color: Colors.white,
// // // // // // //                               size: 14,
// // // // // // //                             ),
// // // // // // //                             const SizedBox(width: 4),
// // // // // // //                             Text(
// // // // // // //                               '$photoCount',
// // // // // // //                               style: const TextStyle(
// // // // // // //                                 color: Colors.white,
// // // // // // //                                 fontSize: 12,
// // // // // // //                                 fontWeight: FontWeight.w600,
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                           ],
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 )
// // // // // // //                     : _buildAlbumPlaceholder(),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //
// // // // // // //             // Album info
// // // // // // //             Padding(
// // // // // // //               padding: const EdgeInsets.all(12),
// // // // // // //               child: Column(
// // // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //                 children: [
// // // // // // //                   Text(
// // // // // // //                     name,
// // // // // // //                     style: AppTextStyles.heading3.copyWith(fontSize: 15),
// // // // // // //                     maxLines: 1,
// // // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 4),
// // // // // // //                   Text(
// // // // // // //                     '$photoCount photos',
// // // // // // //                     style: AppTextStyles.bodySmall,
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   Widget _buildAlbumPlaceholder() {
// // // // // // //     return Container(
// // // // // // //       color: AppColors.surface,
// // // // // // //       child: Center(
// // // // // // //         child: Column(
// // // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //           children: [
// // // // // // //             Icon(
// // // // // // //               Icons.photo_album_outlined,
// // // // // // //               size: 40,
// // // // // // //               color: AppColors.textMuted.withOpacity(0.5),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 4),
// // // // // // //             Text(
// // // // // // //               'No Photos',
// // // // // // //               style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   void _openAlbum(Map<String, dynamic> album) {
// // // // // // //     Navigator.push(
// // // // // // //       context,
// // // // // // //       MaterialPageRoute(
// // // // // // //         builder: (_) => AlbumDetailScreen(album: album),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   void _showAlbumOptions(int index) {
// // // // // // //     showModalBottomSheet(
// // // // // // //       context: context,
// // // // // // //       backgroundColor: AppColors.cardDark,
// // // // // // //       shape: const RoundedRectangleBorder(
// // // // // // //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // // // // // //       ),
// // // // // // //       builder: (context) => Padding(
// // // // // // //         padding: const EdgeInsets.symmetric(vertical: 20),
// // // // // // //         child: Column(
// // // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // // //           children: [
// // // // // // //             Container(
// // // // // // //               width: 40,
// // // // // // //               height: 4,
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 color: AppColors.divider,
// // // // // // //                 borderRadius: BorderRadius.circular(2),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 20),
// // // // // // //             ListTile(
// // // // // // //               leading: const Icon(Icons.edit, color: AppColors.primary),
// // // // // // //               title: const Text('Rename Album',
// // // // // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // // // // //               onTap: () {
// // // // // // //                 Navigator.pop(context);
// // // // // // //                 // TODO: Rename album
// // // // // // //               },
// // // // // // //             ),
// // // // // // //             ListTile(
// // // // // // //               leading: const Icon(Icons.add_photo_alternate,
// // // // // // //                   color: AppColors.accent),
// // // // // // //               title: const Text('Add Photos',
// // // // // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // // // // //               onTap: () {
// // // // // // //                 Navigator.pop(context);
// // // // // // //                 // TODO: Add photos to album
// // // // // // //               },
// // // // // // //             ),
// // // // // // //             ListTile(
// // // // // // //               leading: const Icon(Icons.delete, color: AppColors.error),
// // // // // // //               title: const Text('Delete Album',
// // // // // // //                   style: TextStyle(color: AppColors.error)),
// // // // // // //               onTap: () {
// // // // // // //                 Navigator.pop(context);
// // // // // // //                 _confirmDeleteAlbum(index);
// // // // // // //               },
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   void _confirmDeleteAlbum(int index) {
// // // // // // //     showDialog(
// // // // // // //       context: context,
// // // // // // //       builder: (context) => AlertDialog(
// // // // // // //         backgroundColor: AppColors.cardDark,
// // // // // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // // // // //         title: const Text('Delete Album',
// // // // // // //             style: TextStyle(color: AppColors.textPrimary)),
// // // // // // //         content: const Text(
// // // // // // //           'Are you sure you want to delete this album and all its photos?',
// // // // // // //           style: TextStyle(color: AppColors.textSecondary),
// // // // // // //         ),
// // // // // // //         actions: [
// // // // // // //           TextButton(
// // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // //             child: const Text('Cancel'),
// // // // // // //           ),
// // // // // // //           ElevatedButton(
// // // // // // //             onPressed: () {
// // // // // // //               Navigator.pop(context);
// // // // // // //               ref.read(albumsProvider.notifier).deleteAlbum(index);
// // // // // // //             },
// // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // //               backgroundColor: AppColors.error,
// // // // // // //               foregroundColor: Colors.white,
// // // // // // //             ),
// // // // // // //             child: const Text('Delete'),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // //
// // // // // // //   void _showCreateAlbumDialog() {
// // // // // // //     final controller = TextEditingController();
// // // // // // //
// // // // // // //     showDialog(
// // // // // // //       context: context,
// // // // // // //       builder: (context) => AlertDialog(
// // // // // // //         backgroundColor: AppColors.cardDark,
// // // // // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // // // // //         title: const Text('Create Album',
// // // // // // //             style: TextStyle(color: AppColors.textPrimary)),
// // // // // // //         content: Column(
// // // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // // //           children: [
// // // // // // //             const Text(
// // // // // // //               'Enter a name for your new album',
// // // // // // //               style: TextStyle(color: AppColors.textSecondary),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 16),
// // // // // // //             TextField(
// // // // // // //               controller: controller,
// // // // // // //               autofocus: true,
// // // // // // //               style: const TextStyle(color: AppColors.textPrimary),
// // // // // // //               decoration: InputDecoration(
// // // // // // //                 hintText: 'Album name',
// // // // // // //                 hintStyle: const TextStyle(color: AppColors.textMuted),
// // // // // // //                 filled: true,
// // // // // // //                 fillColor: AppColors.surface,
// // // // // // //                 border: OutlineInputBorder(
// // // // // // //                   borderRadius: BorderRadius.circular(12),
// // // // // // //                   borderSide:
// // // // // // //                   const BorderSide(color: AppColors.divider),
// // // // // // //                 ),
// // // // // // //                 focusedBorder: OutlineInputBorder(
// // // // // // //                   borderRadius: BorderRadius.circular(12),
// // // // // // //                   borderSide:
// // // // // // //                   const BorderSide(color: AppColors.primary),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //         actions: [
// // // // // // //           TextButton(
// // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // //             child: const Text('Cancel'),
// // // // // // //           ),
// // // // // // //           ElevatedButton(
// // // // // // //             onPressed: () {
// // // // // // //               final name = controller.text.trim();
// // // // // // //               if (name.isNotEmpty) {
// // // // // // //                 ref.read(albumsProvider.notifier).createAlbum(name);
// // // // // // //                 Navigator.pop(context);
// // // // // // //               }
// // // // // // //             },
// // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // //               backgroundColor: AppColors.primary,
// // // // // // //               foregroundColor: Colors.white,
// // // // // // //             ),
// // // // // // //             child: const Text('Create'),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // //
// // // // // // // // ─── Album Detail Screen ───
// // // // // // // class AlbumDetailScreen extends StatelessWidget {
// // // // // // //   final Map<String, dynamic> album;
// // // // // // //
// // // // // // //   const AlbumDetailScreen({super.key, required this.album});
// // // // // // //
// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final name = album['name'] ?? 'Untitled Album';
// // // // // // //     final photos = (album['photos'] as List?)?.cast<String>() ?? [];
// // // // // // //
// // // // // // //     return Scaffold(
// // // // // // //       backgroundColor: AppColors.background,
// // // // // // //       appBar: AppBar(
// // // // // // //         backgroundColor: AppColors.surface,
// // // // // // //         foregroundColor: AppColors.textPrimary,
// // // // // // //         title: Text(name),
// // // // // // //         actions: [
// // // // // // //           IconButton(
// // // // // // //             icon: const Icon(Icons.add_photo_alternate),
// // // // // // //             onPressed: () {
// // // // // // //               // TODO: Add photos to album
// // // // // // //             },
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       body: photos.isEmpty
// // // // // // //           ? Center(
// // // // // // //         child: Column(
// // // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //           children: [
// // // // // // //             Icon(
// // // // // // //               Icons.photo_library_outlined,
// // // // // // //               size: 64,
// // // // // // //               color: AppColors.textMuted.withOpacity(0.5),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 16),
// // // // // // //             const Text('No photos in this album',
// // // // // // //                 style: AppTextStyles.bodyMedium),
// // // // // // //             const SizedBox(height: 16),
// // // // // // //             ElevatedButton.icon(
// // // // // // //               onPressed: () {
// // // // // // //                 // TODO: Add photos
// // // // // // //               },
// // // // // // //               icon: const Icon(Icons.add),
// // // // // // //               label: const Text('Add Photos'),
// // // // // // //               style: ElevatedButton.styleFrom(
// // // // // // //                 backgroundColor: AppColors.primary,
// // // // // // //                 foregroundColor: Colors.white,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       )
// // // // // // //           : GridView.builder(
// // // // // // //         physics: const BouncingScrollPhysics(),
// // // // // // //         padding: const EdgeInsets.all(12),
// // // // // // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // //           crossAxisCount: 3,
// // // // // // //           crossAxisSpacing: 8,
// // // // // // //           mainAxisSpacing: 8,
// // // // // // //         ),
// // // // // // //         itemCount: photos.length,
// // // // // // //         itemBuilder: (context, index) {
// // // // // // //           return ClipRRect(
// // // // // // //             borderRadius: BorderRadius.circular(12),
// // // // // // //             child: Image.network(
// // // // // // //               photos[index],
// // // // // // //               fit: BoxFit.cover,
// // // // // // //               errorBuilder: (_, __, ___) => Container(
// // // // // // //                 color: AppColors.cardDark,
// // // // // // //                 child: const Icon(
// // // // // // //                   Icons.broken_image,
// // // // // // //                   color: AppColors.textMuted,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           );
// // // // // // //         },
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
