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


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Api_services/api_services.dart';
import '../core/services/auth_services.dart';

class RegisterState {
  final bool isLoading;
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  // New password rules
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigit;
  final bool hasSpecialChar;

  const RegisterState({
    this.isLoading = false,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasLowercase = false,
    this.hasDigit = false,
    this.hasSpecialChar = false,
  });

  bool get isStrongByRegex =>
      hasMinLength && hasUppercase && hasLowercase && hasDigit && hasSpecialChar;

  RegisterState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? hasMinLength,
    bool? hasUppercase,
    bool? hasLowercase,
    bool? hasDigit,
    bool? hasSpecialChar,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasDigit: hasDigit ?? this.hasDigit,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
    );
  }
}

class RegisterNotifier extends Notifier<RegisterState> {
  final ApiServices _apiServices = ApiServices();

  @override
  RegisterState build() {
    return const RegisterState();
  }

  void updatePassword(String password) {
    state = state.copyWith(
      hasMinLength: password.length >= 8,
      hasUppercase: RegExp(r'[A-Z]').hasMatch(password),
      hasLowercase: RegExp(r'[a-z]').hasMatch(password),
      hasDigit: RegExp(r'[0-9]').hasMatch(password),
      hasSpecialChar: RegExp(r'[!@#$%&*]').hasMatch(password),
    );
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleObscureConfirmPassword() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

//   Future<(String, bool)> register({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true);
//
//     try {
//       // TODO: Replace this delay with your actual API call / Firebase auth
//       await Future.delayed(const Duration(seconds: 2));
//
//       // Example success response
//       // return ("Registration successful!", true);
//
//       // Example failure response (uncomment to test)
//       // return ("Email already in use", false);
//
//       state = state.copyWith(isLoading: false);
//       return ("Registration successful!", true);
//     } catch (e) {
//       state = state.copyWith(isLoading: false);
//       return (e.toString(), false);
//     }
//   }
// }

    Future<(String message, bool isSuccess)?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _apiServices.register(
        name: name,
        email: email,
        password: password,
      );
      final token = (data['token'] ?? '').toString();
      final user = (data['user'] as Map<String, dynamic>?);
      final userEmail = (user?['email'] ?? email).toString();
      await AuthService.login(token: token, email: userEmail);
      return ('Account created successfully', true);
    } catch (e) {
      return (e.toString().replaceFirst('Exception: ', ''), false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);