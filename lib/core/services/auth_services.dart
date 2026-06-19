// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static const String _loginKey = "is_logged_in";
//   static const String _tokenKey = "auth_token";
//   static const String _userEmailKey = "user_email";
//   static const String _userIdKey = "user_id";

//   // Save login session
//   static Future<void> login({
//     required String token,
//     required String email,
//     String? userId,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_loginKey, true);
//     await prefs.setString(_tokenKey, token);
//     await prefs.setString(_userEmailKey, email);
//     if (userId != null) {
//       await prefs.setString(_userIdKey, userId);
//     }
//   }

//   static Future<String?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userIdKey);
//   }

//   // Logout
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(_tokenKey);
//     if (token != null && token.isNotEmpty) {
//       try {
//         await ApiServices().logout(token: token);
//       } catch (_) {
//         // Still clear local session if the network or server fails.
//       }
//     }
//     await prefs.setBool(_loginKey, false);
//     await prefs.remove(_tokenKey);
//     await prefs.remove(_userEmailKey);
//     await prefs.remove(_userIdKey);
//   }

//   // Check login
//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     final loggedIn = prefs.getBool(_loginKey) ?? false;
//     final token = prefs.getString(_tokenKey) ?? "";
//     return loggedIn && token.isNotEmpty;
//   }

//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenKey);
//   }

//   static Future<String?> getSavedEmail() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userEmailKey);
//   }

//   static Future<void> saveEmail(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userEmailKey, email);
//   }
// }

// lib/core/services/auth_services.dart

// import 'package:beatflirt/Api_services/api_service(new).dart';
// import 'package:beatflirt/Api_services/api_services.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../Api_services/api_service.dart';

class AuthService {
  static const String _loginKey     = "is_logged_in";
  static const String _tokenKey     = "auth_token";
  static const String _userEmailKey = "user_email";
  static const String _userIdKey    = "user_id";

  // ✅ Called by LoginNotifier after successful login
  static Future<void> login({
    required String token,
    required String email,
    String? userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userEmailKey, email);
    if (userId != null) {
      await prefs.setString(_userIdKey, userId);
    }
  }

  // ✅ Use this to get userId anywhere in the app
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // ✅ Calls API logout + clears local session
  // static Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString(_tokenKey);
  //   if (token != null && token.isNotEmpty) {
  //     try {
  //       await ApiServices().logout(token: token);
  //     } catch (_) {
  //       // Still clear local session even if network fails
  //     }
  //   }
  //   await prefs.setBool(_loginKey, false);
  //   await prefs.remove(_tokenKey);
  //   await prefs.remove(_userEmailKey);
  //   await prefs.remove(_userIdKey);
  // }
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      try {
        await ApiService().logout(token: token);
      } catch (_) {
        // Still clear local session even if network fails
      }
    }
    await prefs.setBool(_loginKey, false);
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userIdKey);
  }

  // ✅ Use this in SplashScreen to check if user is already logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_loginKey) ?? false;
    final token    = prefs.getString(_tokenKey) ?? "";
    return loggedIn && token.isNotEmpty;
  }

  // ✅ Use this to attach token to API calls: 'Authorization': 'Bearer $token'
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ✅ Save token directly (e.g., when user provides it manually)
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_loginKey, true);
  }
  

  // ✅ Get saved email (for profile page, etc.)
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // ✅ Update email if user changes it
  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  /// Debug helper to test different header formats against the server
  static Future<void> probeAuth() async {
    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      debugPrint('[PROBE] no token');
      return;
    }
    const url = 'https://app.beatflirtevent.com/App/user/signle_user_profile';
    final base = {'Accept': 'application/json'};

    Future<void> tryIt(String label, Uri uri, Map<String, String> headers) async {
      try {
        final r = await http.get(uri, headers: headers);
        final preview = r.body.length > 200 ? r.body.substring(0, 200) : r.body;
        debugPrint('[PROBE/$label] ${r.statusCode} $preview');
      } catch (e) {
        debugPrint('[PROBE/$label] ERR $e');
      }
    }

    // Header variants
    // await tryIt('Bearer',       Uri.parse(url), {...base, 'Authorization': 'Bearer $token'});
    // await tryIt('AuthRaw',      Uri.parse(url), {...base, 'Authorization': token});
    // await tryIt('token-lower',  Uri.parse(url), {...base, 'token': token});
    // await tryIt('Token-cap',    Uri.parse(url), {...base, 'Token': token});
    // await tryIt('Authtoken',    Uri.parse(url), {...base, 'Authtoken': token});
    // await tryIt('Auth-Token',   Uri.parse(url), {...base, 'Auth-Token': token});
    // await tryIt('X-Auth-Token', Uri.parse(url), {...base, 'X-Auth-Token': token});
    // await tryIt('X-API-KEY',    Uri.parse(url), {...base, 'X-API-KEY': token});
    // await tryIt('access_token', Uri.parse(url), {...base, 'access_token': token});

    // // Query / body variants
    // await tryIt('query-token',        Uri.parse('$url?token=$token'),        base);
    // await tryIt('query-access_token', Uri.parse('$url?access_token=$token'), base);
    // await tryIt('query-Authtoken',    Uri.parse('$url?Authtoken=$token'),    base);

    // POST form variants (some PHP backends route everything through POST)
    try {
      final r = await http.post(Uri.parse(url), headers: base, body: {'token': token});
      final preview = r.body.length > 200 ? r.body.substring(0, 200) : r.body;
      debugPrint('[PROBE/POST-form-token] ${r.statusCode} $preview');
    } catch (e) {
      debugPrint('[PROBE/POST-form-token] ERR $e');
    }
    try {
      final r = await http.post(Uri.parse(url), headers: base, body: {'Authtoken': token});
      final preview = r.body.length > 200 ? r.body.substring(0, 200) : r.body;
      debugPrint('[PROBE/POST-form-Authtoken] ${r.statusCode} $preview');
    } catch (e) {
      debugPrint('[PROBE/POST-form-Authtoken] ERR $e');
    }
  }
}
