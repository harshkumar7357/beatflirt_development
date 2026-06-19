// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../Api_services/api_services.dart';
// import '../core/services/auth_services.dart';
//
// class RegisterState {
//   final bool isLoading;
//   final bool obscurePassword;
//   final bool obscureConfirmPassword;
//   final String password;
//
//   const RegisterState({
//     this.isLoading = false,
//     this.obscurePassword = true,
//     this.obscureConfirmPassword = true,
//     this.password = '',
//   });
//
//   RegisterState copyWith({
//     bool? isLoading,
//     bool? obscurePassword,
//     bool? obscureConfirmPassword,
//     String? password,
//   }) {
//     return RegisterState(
//       isLoading: isLoading ?? this.isLoading,
//       obscurePassword: obscurePassword ?? this.obscurePassword,
//       obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
//       password: password ?? this.password,
//     );
//   }
//
//   bool get hasMinLength => password.length >= 8;
//   bool get startsWithCapital => RegExp(r'^[A-Z]').hasMatch(password);
//   bool get hasMiddleLetter => RegExp(r'^.{1,}[A-Za-z].{1,}$').hasMatch(password);
//   bool get endsWithLetter => RegExp(r'[A-Za-z]$').hasMatch(password);
//   bool get isStrongByRegex =>
//       RegExp(r'^(?=.{8,}$)[A-Z].*[A-Za-z]$').hasMatch(password) && hasMiddleLetter;
//
//
// }
//
// class RegisterNotifier extends Notifier<RegisterState> {
//   final ApiServices _apiServices = ApiServices();
//
//   @override
//   RegisterState build() => const RegisterState();
//
//   void toggleObscurePassword() {
//     state = state.copyWith(obscurePassword: !state.obscurePassword);
//   }
//
//   void toggleObscureConfirmPassword() {
//     state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
//   }
//
//   void updatePassword(String value) {
//     state = state.copyWith(password: value);
//   }
//
//   Future<(String message, bool isSuccess)?> register({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final data = await _apiServices.register(
//         name: name,
//         email: email,
//         password: password,
//       );
//       final token = (data['token'] ?? '').toString();
//       final user = (data['user'] as Map<String, dynamic>?);
//       final userEmail = (user?['email'] ?? email).toString();
//       await AuthService.login(token: token, email: userEmail);
//       return ('Account created successfully', true);
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }
//
// final registerProvider =
//     NotifierProvider<RegisterNotifier, RegisterState>(RegisterNotifier.new);


// lib/providers/register_provider.dart

// import 'package:beatflirt/Api_services/api_service(new).dart';
import 'package:beatflirt/Api_services/api_service.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ══════════════════════════════════════════════════
// GENDER HELPER
// Converts dropdown string → API number code
// and computes imageType / genderProfileType
// ══════════════════════════════════════════════════
class GenderHelper {
  /// "male" → "1" | "female" → "2" | "transgender" → "3"
  static String toCode(String gender) {
    switch (gender.toLowerCase()) {
      case 'female':      return '2';
      case 'transgender': return '3';
      default:            return '1'; // male
    }
  }

  /// Single: "male" → "male.png"
  static String toSingleImage(String gender) {
    switch (gender.toLowerCase()) {
      case 'female':      return 'female.png';
      case 'transgender': return 'transgender.png';
      default:            return 'male.png';
    }
  }

  /// Single: "male" → "Male"
  static String toLabel(String gender) {
    switch (gender.toLowerCase()) {
      case 'female':      return 'Female';
      case 'transgender': return 'Transgender';
      default:            return 'Male';
    }
  }

  /// Couple image: "male" + "female" → "male-female.png"
  static String toCoupleImage(String from, String to) {
    final f = from.toLowerCase();
    final t = to.toLowerCase();
    if (f == 'male'   && t == 'female')      return 'male-female.png';
    if (f == 'female' && t == 'male')        return 'female-male.png';
    if (f == 'male'   && t == 'male')        return 'male-male.png';
    if (f == 'female' && t == 'female')      return 'female-female.png';
    return 'male-female.png';
  }

  /// Couple label: "male" + "female" → "Male | Female"
  static String toCoupleLabel(String from, String to) {
    return '${toLabel(from)} | ${toLabel(to)}';
  }
}

// ══════════════════════════════════════════════════
// STATE
// ══════════════════════════════════════════════════
class RegisterState {
  final bool   isLoading;
  final bool   obscurePassword;
  final bool   obscureConfirmPassword;
  final String password;

  const RegisterState({
    this.isLoading              = false,
    this.obscurePassword        = true,
    this.obscureConfirmPassword = true,
    this.password               = '',
  });

  // Password rule checks — drives the checklist UI
  bool get hasMinLength   => password.length >= 8;
  bool get hasUppercase   => password.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase   => password.contains(RegExp(r'[a-z]'));
  bool get hasDigit       => password.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar => password.contains(RegExp(r'[!@#\$%&*]'));
  bool get isStrongByRegex =>
      hasMinLength && hasUppercase && hasLowercase && hasDigit && hasSpecialChar;

  RegisterState copyWith({
    bool?   isLoading,
    bool?   obscurePassword,
    bool?   obscureConfirmPassword,
    String? password,
  }) {
    return RegisterState(
      isLoading:              isLoading              ?? this.isLoading,
      obscurePassword:        obscurePassword        ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      password:               password               ?? this.password,
    );
  }
}

// ══════════════════════════════════════════════════
// NOTIFIER
// ══════════════════════════════════════════════════
class RegisterNotifier extends Notifier<RegisterState> {
  final ApiService _api = ApiService();

  @override
  RegisterState build() => const RegisterState();

  void toggleObscurePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void toggleObscureConfirmPassword() =>
      state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);

  void updatePassword(String value) =>
      state = state.copyWith(password: value);

  // ─────────────────────────────────────────────
  // REGISTER SINGLE
  // gender: "male" | "female" | "transgender"
  // ─────────────────────────────────────────────
  Future<(String, bool)?> registerSingle({
    required String username,
    required String email,
    required String password,
    required String gender,
    required String lat,
    required String lng,
    required String cityName,
    required String placeId,
    required String mapUrl,
    required String formattedAddress,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _api.registerSingle(
        email:                   email,
        password:                password,
        username:                username,
        singleProfileGenderFrom: GenderHelper.toCode(gender),
        lat:                     lat,
        lng:                     lng,
        cityName:                cityName,
        placeId:                 placeId,
        mapUrl:                  mapUrl,
        formattedAddress:        formattedAddress,
        imageType:               GenderHelper.toSingleImage(gender),
        genderProfileType:       GenderHelper.toLabel(gender),
      );

      // ── Save session from confirmed response structure ──
      // Response: { "status":"200", "data": { "token":"...", "userid":"408", ... } }
      final responseData = data['data'] as Map<String, dynamic>?;
      final token  = (responseData?['token']  ?? '').toString();
      final userId = (responseData?['userid'] ?? '').toString();

      await AuthService.login(
        token:  token,
        email:  email,
        userId: userId,
      );

      return (data['message']?.toString() ?? 'Registration Successful!', true);
    } catch (e) {
      return (e.toString().replaceFirst('Exception: ', ''), false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ─────────────────────────────────────────────
  // REGISTER COUPLE
  // genderFrom / genderTo: "male" | "female" | "transgender"
  // ─────────────────────────────────────────────
  Future<(String, bool)?> registerCouple({
    required String username,
    required String email,
    required String password,
    required String genderFrom,
    required String genderTo,
    required String lat,
    required String lng,
    required String cityName,
    required String placeId,
    required String mapUrl,
    required String formattedAddress,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _api.registerCouple(
        email:                   email,
        password:                password,
        username:                username,
        coupleProfileGenderFrom: GenderHelper.toCode(genderFrom),
        coupleProfileGenderTo:   GenderHelper.toCode(genderTo),
        lat:                     lat,
        lng:                     lng,
        cityName:                cityName,
        placeId:                 placeId,
        mapUrl:                  mapUrl,
        formattedAddress:        formattedAddress,
        imageType:               GenderHelper.toCoupleImage(genderFrom, genderTo),
        genderProfileType:       GenderHelper.toCoupleLabel(genderFrom, genderTo),
      );

      // ── Save session from confirmed response structure ──
      // Response: { "status":"200", "data": { "token":"...", "userid":"407", ... } }
      final responseData = data['data'] as Map<String, dynamic>?;
      final token  = (responseData?['token']  ?? '').toString();
      final userId = (responseData?['userid'] ?? '').toString();

      await AuthService.login(
        token:  token,
        email:  email,
        userId: userId,
      );

      return (data['message']?.toString() ?? 'Registration Successful!', true);
    } catch (e) {
      return (e.toString().replaceFirst('Exception: ', ''), false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// ══════════════════════════════════════════════════
// PROVIDER
// ══════════════════════════════════════════════════
final registerProvider =
    NotifierProvider<RegisterNotifier, RegisterState>(RegisterNotifier.new);


// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../Api_services/api_services.dart';
// import '../core/services/auth_services.dart';

// class RegisterState {
//   final bool isLoading;
//   final bool obscurePassword;
//   final bool obscureConfirmPassword;

//   // New password rules
//   final bool hasMinLength;
//   final bool hasUppercase;
//   final bool hasLowercase;
//   final bool hasDigit;
//   final bool hasSpecialChar;

//   const RegisterState({
//     this.isLoading = false,
//     this.obscurePassword = true,
//     this.obscureConfirmPassword = true,
//     this.hasMinLength = false,
//     this.hasUppercase = false,
//     this.hasLowercase = false,
//     this.hasDigit = false,
//     this.hasSpecialChar = false,
//   });

//   bool get isStrongByRegex =>
//       hasMinLength && hasUppercase && hasLowercase && hasDigit && hasSpecialChar;

//   RegisterState copyWith({
//     bool? isLoading,
//     bool? obscurePassword,
//     bool? obscureConfirmPassword,
//     bool? hasMinLength,
//     bool? hasUppercase,
//     bool? hasLowercase,
//     bool? hasDigit,
//     bool? hasSpecialChar,
//   }) {
//     return RegisterState(
//       isLoading: isLoading ?? this.isLoading,
//       obscurePassword: obscurePassword ?? this.obscurePassword,
//       obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
//       hasMinLength: hasMinLength ?? this.hasMinLength,
//       hasUppercase: hasUppercase ?? this.hasUppercase,
//       hasLowercase: hasLowercase ?? this.hasLowercase,
//       hasDigit: hasDigit ?? this.hasDigit,
//       hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
//     );
//   }
// }

// class RegisterNotifier extends Notifier<RegisterState> {
//   final ApiServices _apiServices = ApiServices();

//   @override
//   RegisterState build() {
//     return const RegisterState();
//   }

//   void updatePassword(String password) {
//     state = state.copyWith(
//       hasMinLength: password.length >= 8,
//       hasUppercase: RegExp(r'[A-Z]').hasMatch(password),
//       hasLowercase: RegExp(r'[a-z]').hasMatch(password),
//       hasDigit: RegExp(r'[0-9]').hasMatch(password),
//       hasSpecialChar: RegExp(r'[!@#$%&*]').hasMatch(password),
//     );
//   }

//   void toggleObscurePassword() {
//     state = state.copyWith(obscurePassword: !state.obscurePassword);
//   }

//   void toggleObscureConfirmPassword() {
//     state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
//   }

// //   Future<(String, bool)> register({
// //     required String name,
// //     required String email,
// //     required String password,
// //   }) async {
// //     state = state.copyWith(isLoading: true);
// //
// //     try {
// //       // TODO: Replace this delay with your actual API call / Firebase auth
// //       await Future.delayed(const Duration(seconds: 2));
// //
// //       // Example success response
// //       // return ("Registration successful!", true);
// //
// //       // Example failure response (uncomment to test)
// //       // return ("Email already in use", false);
// //
// //       state = state.copyWith(isLoading: false);
// //       return ("Registration successful!", true);
// //     } catch (e) {
// //       state = state.copyWith(isLoading: false);
// //       return (e.toString(), false);
// //     }
// //   }
// // }

//     Future<(String message, bool isSuccess)?> register({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final data = await _apiServices.register(
//         name: name,
//         email: email,
//         password: password,
//       );
//       final token = (data['token'] ?? '').toString();
//       final user = (data['user'] as Map<String, dynamic>?);
//       final userEmail = (user?['email'] ?? email).toString();
//       final userId = (user?['_id'] ?? user?['id'] ?? '').toString();
//       await AuthService.login(token: token, email: userEmail, userId: userId.isNotEmpty ? userId : null);
//       return ('Account created successfully', true);
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }

// final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
//   RegisterNotifier.new,
// );