// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/core/app_color_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});
//
//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }
//
// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final ApiServices _apiServices = ApiServices();
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _tokenController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//
//   bool _isLoading = false;
//   bool _tokenRequested = false;
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _tokenController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _requestToken() async {
//     if (_isLoading) return;
//     final email = _emailController.text.trim();
//     if (email.isEmpty ||
//         !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
//       Get.snackbar(
//         "Invalid Email",
//         "Please enter a valid email first",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//     try {
//       final data = await _apiServices.requestPasswordReset(email: email);
//       final token = (data['resetToken'] ?? '').toString();
//       if (!mounted) return;
//       setState(() {
//         _tokenRequested = true;
//       });
//       Get.snackbar(
//         "Reset Token Generated",
//         token.isNotEmpty
//             ? "Use token: $token (dev mode)"
//             : "Token generated successfully",
//         duration: const Duration(seconds: 4),
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       Get.snackbar(
//         "Failed",
//         e.toString().replaceFirst('Exception: ', ''),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _resetPassword() async {
//     if (!_formKey.currentState!.validate() || _isLoading) return;
//     setState(() => _isLoading = true);
//     try {
//       await _apiServices.resetPassword(
//         email: _emailController.text,
//         resetToken: _tokenController.text,
//         newPassword: _newPasswordController.text,
//       );
//       if (!mounted) return;
//       Get.snackbar(
//         "Success",
//         "Password updated. Please login.",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       Get.snackbar(
//         "Failed",
//         e.toString().replaceFirst('Exception: ', ''),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.amber,
//       appBar: AppBar(
//         title: const Text("Forgot Password"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Reset Password",
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 _label("Email"),
//                 _field(
//                   controller: _emailController,
//                   hint: "Enter registered email",
//                   keyboardType: TextInputType.emailAddress,
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return "Please enter email";
//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                       return "Please enter a valid email";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     onPressed: _requestToken,
//                     child: _isLoading && !_tokenRequested
//                         ? const SizedBox(
//                             width: 18,
//                             height: 18,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Text("Request Reset Token"),
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 if (_tokenRequested) ...[
//                   _label("Reset Token"),
//                   _field(
//                     controller: _tokenController,
//                     hint: "Enter reset token",
//                     textInputAction: TextInputAction.next,
//                     validator: (value) {
//                       if (!_tokenRequested) return null;
//                       if (value == null || value.isEmpty) return "Please enter reset token";
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   _label("New Password"),
//                   _field(
//                     controller: _newPasswordController,
//                     hint: "Enter new password",
//                     obscureText: _obscureNew,
//                     textInputAction: TextInputAction.next,
//                     suffixIcon: IconButton(
//                       onPressed: () => setState(() => _obscureNew = !_obscureNew),
//                       icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
//                     ),
//                     validator: (value) {
//                       if (!_tokenRequested) return null;
//                       if (value == null || value.isEmpty) return "Please enter new password";
//                       if (value.length < 6) return "Password must be at least 6 characters";
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   _label("Confirm Password"),
//                   _field(
//                     controller: _confirmPasswordController,
//                     hint: "Re-enter new password",
//                     obscureText: _obscureConfirm,
//                     textInputAction: TextInputAction.done,
//                     suffixIcon: IconButton(
//                       onPressed: () =>
//                           setState(() => _obscureConfirm = !_obscureConfirm),
//                       icon:
//                           Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
//                     ),
//                     validator: (value) {
//                       if (!_tokenRequested) return null;
//                       if (value == null || value.isEmpty) return "Please confirm password";
//                       if (value != _newPasswordController.text) {
//                         return "Passwords do not match";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _resetPassword,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Text("Update Password"),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _label(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         letterSpacing: 1,
//         fontSize: 20,
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
//
//   Widget _field({
//     required TextEditingController controller,
//     required String hint,
//     required String? Function(String?) validator,
//     TextInputAction? textInputAction,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       cursorColor: Colors.pink.withValues(alpha: 0.5),
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: AppColors.background,
//         hintText: hint,
//         suffixIcon: suffixIcon,
//         visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       validator: validator,
//     );
//   }
// }


import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/app_color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// --- STATE ---
class ForgotPasswordState {
  final bool isLoading;
  final bool tokenRequested;
  final bool obscureNew;
  final bool obscureConfirm;

  const ForgotPasswordState({
    this.isLoading = false,
    this.tokenRequested = false,
    this.obscureNew = true,
    this.obscureConfirm = true,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? tokenRequested,
    bool? obscureNew,
    bool? obscureConfirm,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      tokenRequested: tokenRequested ?? this.tokenRequested,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
    );
  }
}

// --- NOTIFIER ---
class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  final ApiServices _apiServices = ApiServices();

  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  void toggleObscureNew() {
    state = state.copyWith(obscureNew: !state.obscureNew);
  }

  void toggleObscureConfirm() {
    state = state.copyWith(obscureConfirm: !state.obscureConfirm);
  }

  Future<(String message, bool isSuccess)?> requestToken(String email) async {
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return ('Please enter a valid email first', false);
    }

    state = state.copyWith(isLoading: true);
    try {
      final data = await _apiServices.requestPasswordReset(email: email);
      final token = (data['resetToken'] ?? '').toString();
      state = state.copyWith(tokenRequested: true);
      return (
      token.isNotEmpty
          ? 'Use token: $token (dev mode)'
          : 'Token generated successfully',
      true
      );
    } catch (e) {
      return (e.toString().replaceFirst('Exception: ', ''), false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<(String message, bool isSuccess)?> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _apiServices.resetPassword(
        email: email,
        resetToken: resetToken,
        newPassword: newPassword,
      );
      return ('Password updated. Please login.', true);
    } catch (e) {
      return (e.toString().replaceFirst('Exception: ', ''), false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// --- PROVIDER ---
final forgotPasswordProvider =
NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  ForgotPasswordNotifier.new,
);

// --- WIDGET ---
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _requestToken() async {
    final state = ref.read(forgotPasswordProvider);
    if (state.isLoading) return;

    final result = await ref
        .read(forgotPasswordProvider.notifier)
        .requestToken(_emailController.text.trim());

    if (!mounted || result == null) return;

    Get.snackbar(
      result.$2 ? "Reset Token Generated" : "Invalid Email",
      result.$1,
      duration: const Duration(seconds: 4),
      backgroundColor: result.$2 ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final state = ref.read(forgotPasswordProvider);
    if (state.isLoading) return;

    final result = await ref.read(forgotPasswordProvider.notifier).resetPassword(
      email: _emailController.text,
      resetToken: _tokenController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted || result == null) return;

    Get.snackbar(
      result.$2 ? "Success" : "Failed",
      result.$1,
      backgroundColor: result.$2 ? Colors.green : Colors.red,
      colorText: Colors.white,
    );

    if (result.$2) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordProvider);
    final notifier = ref.read(forgotPasswordProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _label("Email"),
                _field(
                  controller: _emailController,
                  hint: "Enter registered email",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter email";
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _requestToken,
                    child: state.isLoading && !state.tokenRequested
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text("Request Reset Token"),
                  ),
                ),
                const SizedBox(height: 14),
                if (state.tokenRequested) ...[
                  _label("Reset Token"),
                  _field(
                    controller: _tokenController,
                    hint: "Enter reset token",
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (!state.tokenRequested) return null;
                      if (value == null || value.isEmpty) return "Please enter reset token";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _label("New Password"),
                  _field(
                    controller: _newPasswordController,
                    hint: "Enter new password",
                    obscureText: state.obscureNew,
                    textInputAction: TextInputAction.next,
                    suffixIcon: IconButton(
                      onPressed: notifier.toggleObscureNew,
                      icon: Icon(state.obscureNew ? Icons.visibility_off : Icons.visibility),
                    ),
                    validator: (value) {
                      if (!state.tokenRequested) return null;
                      if (value == null || value.isEmpty) return "Please enter new password";
                      if (value.length < 6) return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _label("Confirm Password"),
                  _field(
                    controller: _confirmPasswordController,
                    hint: "Re-enter new password",
                    obscureText: state.obscureConfirm,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      onPressed: notifier.toggleObscureConfirm,
                      icon: Icon(state.obscureConfirm ? Icons.visibility_off : Icons.visibility),
                    ),
                    validator: (value) {
                      if (!state.tokenRequested) return null;
                      if (value == null || value.isEmpty) return "Please confirm password";
                      if (value != _newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text("Update Password"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        letterSpacing: 1,
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.pink.withValues(alpha: 0.5),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        hintText: hint,
        suffixIcon: suffixIcon,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}