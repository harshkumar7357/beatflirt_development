import 'package:beatflirt/Api_services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loginKey = "is_logged_in";
  static const String _tokenKey = "auth_token";
  static const String _userEmailKey = "user_email";

  // Save login session
  static Future<void> login({
    required String token,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userEmailKey, email);
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      try {
        await ApiServices().logout(token: token);
      } catch (_) {
        // Still clear local session if the network or server fails.
      }
    }
    await prefs.setBool(_loginKey, false);
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
  }

  // Check login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_loginKey) ?? false;
    final token = prefs.getString(_tokenKey) ?? "";
    return loggedIn && token.isNotEmpty;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }
}