import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage authentication tokens
class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _accessSignKey = 'access_sign';
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'user_id';

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> saveAccessSign(String sign) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessSignKey, sign);
  }

  Future<String?> getAccessSign() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessSignKey);
  }

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final sign = await getAccessSign();
    return token != null && sign != null;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_accessSignKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_userIdKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String accessSign,
    String? username,
    String? userId,
  }) async {
    await saveAccessToken(accessToken);
    await saveAccessSign(accessSign);
    if (username != null) await saveUsername(username);
    if (userId != null) await saveUserId(userId);
  }
}