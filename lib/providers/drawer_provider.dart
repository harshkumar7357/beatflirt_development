import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/auth_services.dart';
import '../Api_services/api_services.dart';

final isProfileExpandedProvider = StateProvider<bool>((ref) => false);

final drawerEmailProvider = StateNotifierProvider<DrawerEmailNotifier, String>((ref) {
  return DrawerEmailNotifier();
});

class DrawerEmailNotifier extends StateNotifier<String> {
  DrawerEmailNotifier() : super('Loading...') {
    loadEmail();
  }

  final ApiServices _apiServices = ApiServices();

  Future<void> loadEmail() async {
    final savedEmail = await AuthService.getSavedEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      state = savedEmail;
    }

    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) return;
      final profile = await _apiServices.getProfile(token: token);
      final user = profile['user'];
      String? email;
      if (user is Map) {
        email = user['email']?.toString();
      }
      if (email != null && email.isNotEmpty) {
        await AuthService.saveEmail(email);
        state = email;
      }
    } catch (_) {
      // Keep cached email on API failure.
    }
  }
}
