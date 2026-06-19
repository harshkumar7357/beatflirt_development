// //
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../Api_services/api_services.dart';
// // import '../core/services/auth_services.dart';
// //
// // // Profile expansion state provider
// // final profileExpansionProvider = StateProvider<bool>((ref) => false);
// //
// // // ✅ Provider family to manage expansion state for each card by index
// // final cardExpansionProvider = StateProvider.family<bool, int>((ref, index) {
// //   return false; // Default: collapsed
// // });
// //
// //
// // // Keep provider alive even when widget is disposed
// // final cardExpansionProvider = StateProvider.family.autoDispose<bool, int>(
// //       (ref, index) {
// //     ref.keepAlive(); // ✅ Keeps state alive
// //     return false;
// //   },
// // );
// //
// // // Drawer email provider
// // final drawerEmailProvider = StateNotifierProvider<DrawerEmailNotifier, String>(
// //       (ref) => DrawerEmailNotifier(),
// // );
// //
// // class DrawerEmailNotifier extends StateNotifier<String> {
// //   DrawerEmailNotifier() : super('Loading...') {
// //     loadEmail();
// //   }
// //
// //   final ApiServices _apiServices = ApiServices();
// //
// //   Future<void> loadEmail() async {
// //     // First load cached email
// //     final savedEmail = await AuthService.getSavedEmail();
// //     if (savedEmail != null && savedEmail.isNotEmpty) {
// //       state = savedEmail;
// //     }
// //
// //     // Then try to fetch from API
// //     try {
// //       final token = await AuthService.getToken();
// //       if (token == null || token.isEmpty) return;
// //
// //       final profile = await _apiServices.getProfile(token: token);
// //       final user = profile['user'];
// //
// //       String? email;
// //       if (user is Map) {
// //         email = user['email']?.toString();
// //       }
// //
// //       if (email != null && email.isNotEmpty) {
// //         await AuthService.saveEmail(email);
// //         state = email;
// //       }
// //     } catch (_) {
// //       // Keep cached email on API failure
// //     }
// //   }
// //
// //   void refresh() {
// //     loadEmail();
// //   }
// // }
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../Api_services/api_services.dart';
// import '../core/services/auth_services.dart';
//
// // Profile expansion state provider
// final profileExpansionProvider = StateProvider<bool>((ref) => false);
//
// // Drawer email provider
// final drawerEmailProvider = StateNotifierProvider<DrawerEmailNotifier, String>(
//       (ref) => DrawerEmailNotifier(),
// );
//
// class DrawerEmailNotifier extends StateNotifier<String> {
//   DrawerEmailNotifier() : super('Loading...') {
//     loadEmail();
//   }
//
//   final ApiServices _apiServices = ApiServices();
//
//   Future<void> loadEmail() async {
//     // First load cached email
//     final savedEmail = await AuthService.getSavedEmail();
//     if (savedEmail != null && savedEmail.isNotEmpty) {
//       state = savedEmail;
//     }
//
//     // Then try to fetch from API
//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) return;
//
//       final profile = await _apiServices.getProfile(token: token);
//       final user = profile['user'];
//
//       String? email;
//       if (user is Map) {
//         email = user['email']?.toString();
//       }
//
//       if (email != null && email.isNotEmpty) {
//         await AuthService.saveEmail(email);
//         state = email;
//       }
//     } catch (_) {
//       // Keep cached email on API failure
//     }
//   }
//
//   void refresh() {
//     loadEmail();
//   }
// }
import 'package:beatflirt/screens/drawer_pages/profile_tabs/my_profile_edit_tab.dart' as _apiService;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';  
import '../Api_services/api_services.dart';
import '../core/services/auth_services.dart';

// Profile expansion state provider
final profileExpansionProvider = StateProvider<bool>((ref) => false);

// Drawer email provider
final drawerEmailProvider = NotifierProvider<DrawerEmailNotifier, String>(
  DrawerEmailNotifier.new,
);

// ✅ Updated for Riverpod 3.x - use Notifier instead of StateNotifier
class DrawerEmailNotifier extends Notifier<String> {
  // final ApiService _apiService = ApiService();

  @override
  String build() {
    // Initialize with loading state and start loading email
    loadEmail();
    return 'Loading...';
  }

  Future<void> loadEmail() async {
    // First load cached email
    final savedEmail = await AuthService.getSavedEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      state = savedEmail; // ✅ Now this works
    }

    // Then try to fetch from API
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) return;

      final profile = await _apiService.getProfile(token: token);
      final user = profile['user'];

      String? email;
      if (user is Map) {
        email = user['email']?.toString();
      }

      if (email != null && email.isNotEmpty) {
        await AuthService.saveEmail(email);
        state = email; // ✅ Now this works
      }
    } catch (_) {
      // Keep cached email on API failure
    }
  }

  void refresh() {
    loadEmail();
  }
}