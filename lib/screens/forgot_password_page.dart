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


// import 'dart:ui';

// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';

// // --- STATE ---
// class ForgotPasswordState {
//   final bool isLoading;
//   final bool tokenRequested;
//   final bool obscureNew;
//   final bool obscureConfirm;

//   const ForgotPasswordState({
//     this.isLoading = false,
//     this.tokenRequested = false,
//     this.obscureNew = true,
//     this.obscureConfirm = true,
//   });

//   ForgotPasswordState copyWith({
//     bool? isLoading,
//     bool? tokenRequested,
//     bool? obscureNew,
//     bool? obscureConfirm,
//   }) {
//     return ForgotPasswordState(
//       isLoading: isLoading ?? this.isLoading,
//       tokenRequested: tokenRequested ?? this.tokenRequested,
//       obscureNew: obscureNew ?? this.obscureNew,
//       obscureConfirm: obscureConfirm ?? this.obscureConfirm,
//     );
//   }
// }

// // --- NOTIFIER ---
// class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
//   final ApiServices _apiServices = ApiServices();

//   @override
//   ForgotPasswordState build() => const ForgotPasswordState();

//   void toggleObscureNew() {
//     state = state.copyWith(obscureNew: !state.obscureNew);
//   }

//   void toggleObscureConfirm() {
//     state = state.copyWith(obscureConfirm: !state.obscureConfirm);
//   }

//   Future<(String message, bool isSuccess)?> requestToken(String email) async {
//     if (email.isEmpty ||
//         !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
//       return ('Please enter a valid email first', false);
//     }

//     state = state.copyWith(isLoading: true);

//     try {
//       final data = await _apiServices.requestPasswordReset(email: email);

//       final token = (data['resetToken'] ?? '').toString();

//       state = state.copyWith(tokenRequested: true);

//       return (
//         token.isNotEmpty
//             ? 'Use token: $token (dev mode)'
//             : 'Reset token generated successfully',
//         true
//       );
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }

//   Future<(String message, bool isSuccess)?> resetPassword({
//     required String email,
//     required String resetToken,
//     required String newPassword,
//   }) async {
//     state = state.copyWith(isLoading: true);

//     try {
//       await _apiServices.resetPassword(
//         email: email,
//         resetToken: resetToken,
//         newPassword: newPassword,
//       );

//       return ('Password updated. Please login.', true);
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }

// // --- PROVIDER ---
// final forgotPasswordProvider =
//     NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
//   ForgotPasswordNotifier.new,
// );

// // --- WIDGET ---
// class ForgotPasswordPage extends ConsumerStatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _tokenController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   static const String _backgroundImage =
//       'https://www.beatflirtevent.com/assets/img/login-img/signup.jpg';

//   static const String _partyImage =
//       'https://www.beatflirtevent.com/assets/img/login-img/img1.jpg';

//   static const String _logoImage =
//       'https://www.beatflirtevent.com/assets/img/logo/logo.png';

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _tokenController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _requestToken() async {
//     FocusManager.instance.primaryFocus?.unfocus();

//     final state = ref.read(forgotPasswordProvider);
//     if (state.isLoading) return;

//     final result = await ref
//         .read(forgotPasswordProvider.notifier)
//         .requestToken(_emailController.text.trim());

//     if (!mounted || result == null) return;

//     Get.snackbar(
//       result.$2 ? "Success" : "Invalid Email",
//       result.$1,
//       duration: const Duration(seconds: 4),
//       backgroundColor: result.$2 ? Colors.green : Colors.red,
//       colorText: Colors.white,
//     );
//   }

//   Future<void> _resetPassword() async {
//     FocusManager.instance.primaryFocus?.unfocus();

//     if (!_formKey.currentState!.validate()) return;

//     final state = ref.read(forgotPasswordProvider);
//     if (state.isLoading) return;

//     final result =
//         await ref.read(forgotPasswordProvider.notifier).resetPassword(
//               email: _emailController.text.trim(),
//               resetToken: _tokenController.text.trim(),
//               newPassword: _newPasswordController.text.trim(),
//             );

//     if (!mounted || result == null) return;

//     Get.snackbar(
//       result.$2 ? "Success" : "Failed",
//       result.$1,
//       duration: const Duration(seconds: 3),
//       backgroundColor: result.$2 ? Colors.green : Colors.red,
//       colorText: Colors.white,
//     );

//     if (result.$2) {
//       Navigator.pop(context);
//     }
//   }

//   void _backToLogin() {
//     FocusManager.instance.primaryFocus?.unfocus();

//     if (Navigator.canPop(context)) {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(forgotPasswordProvider);
//     final notifier = ref.read(forgotPasswordProvider.notifier);

//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.network(
//               _backgroundImage,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFF12051D),
//                         Color(0xFF2B0B36),
//                         Color(0xFF07133D),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Dark overlay like website
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withValues(alpha: 0.45),
//             ),
//           ),

//           SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 final bool isWide = constraints.maxWidth >= 900;

//                 return SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: isWide ? 32 : 20,
//                     vertical: 28,
//                   ),
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight - 56,
//                     ),
//                     child: Center(
//                       child: ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 1100),
//                         child: isWide
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     flex: 5,
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: ConstrainedBox(
//                                         constraints:
//                                             const BoxConstraints(maxWidth: 480),
//                                         child: _buildForgotPasswordCard(
//                                           state,
//                                           notifier,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 44),
//                                   Expanded(
//                                     flex: 6,
//                                     child: Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: _buildPartyImage(),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : ConstrainedBox(
//                                 constraints:
//                                     const BoxConstraints(maxWidth: 480),
//                                 child: _buildForgotPasswordCard(
//                                   state,
//                                   notifier,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildForgotPasswordCard(
//     ForgotPasswordState state,
//     ForgotPasswordNotifier notifier,
//   ) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(18),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(28, 32, 28, 30),
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.08),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: Colors.white.withValues(alpha: 0.16),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.25),
//                 blurRadius: 35,
//                 offset: const Offset(0, 20),
//               ),
//             ],
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.network(
//                   _logoImage,
//                   width: 125,
//                   fit: BoxFit.contain,
//                   errorBuilder: (_, __, ___) {
//                     return const Text(
//                       "Beat Flirt",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 22),

//                 const Text(
//                   "Forgot Password",
//                   style: TextStyle(
//                     fontSize: 28,
//                     color: Color(0xFFECEEF2),
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 _label("Username/Email"),

//                 const SizedBox(height: 8),

//                 _field(
//                   controller: _emailController,
//                   hint: "Enter Your Username/Email",
//                   keyboardType: TextInputType.emailAddress,
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Please enter email";
//                     }

//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                         .hasMatch(value.trim())) {
//                       return "Please enter a valid email";
//                     }

//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 12),

//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: TextButton(
//                     onPressed: _backToLogin,
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: const Size(0, 36),
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: const Text(
//                       "back to Login",
//                       style: TextStyle(
//                         color: Color(0xFFE8EAF0),
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 if (!state.tokenRequested)
//                   _GradientActionButton(
//                     label: "Send",
//                     isLoading: state.isLoading,
//                     onPressed: state.isLoading ? null : _requestToken,
//                   ),

//                 if (state.tokenRequested) ...[
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withValues(alpha: 0.18),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: Colors.white.withValues(alpha: 0.12),
//                       ),
//                     ),
//                     child: const Text(
//                       "Reset token generated. Please enter the token and your new password below.",
//                       style: TextStyle(
//                         color: Color(0xFFE8EAF0),
//                         fontSize: 13,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 18),

//                   _label("Reset Token"),

//                   const SizedBox(height: 8),

//                   _field(
//                     controller: _tokenController,
//                     hint: "Enter reset token",
//                     textInputAction: TextInputAction.next,
//                     validator: (value) {
//                       if (!state.tokenRequested) return null;

//                       if (value == null || value.trim().isEmpty) {
//                         return "Please enter reset token";
//                       }

//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   _label("New Password"),

//                   const SizedBox(height: 8),

//                   _field(
//                     controller: _newPasswordController,
//                     hint: "Enter new password",
//                     obscureText: state.obscureNew,
//                     textInputAction: TextInputAction.next,
//                     suffixIcon: IconButton(
//                       onPressed: notifier.toggleObscureNew,
//                       icon: Icon(
//                         state.obscureNew
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: const Color(0xFF6B75A6),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (!state.tokenRequested) return null;

//                       if (value == null || value.isEmpty) {
//                         return "Please enter new password";
//                       }

//                       if (value.length < 6) {
//                         return "Password must be at least 6 characters";
//                       }

//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   _label("Confirm Password"),

//                   const SizedBox(height: 8),

//                   _field(
//                     controller: _confirmPasswordController,
//                     hint: "Re-enter new password",
//                     obscureText: state.obscureConfirm,
//                     textInputAction: TextInputAction.done,
//                     suffixIcon: IconButton(
//                       onPressed: notifier.toggleObscureConfirm,
//                       icon: Icon(
//                         state.obscureConfirm
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: const Color(0xFF6B75A6),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (!state.tokenRequested) return null;

//                       if (value == null || value.isEmpty) {
//                         return "Please confirm password";
//                       }

//                       if (value != _newPasswordController.text) {
//                         return "Passwords do not match";
//                       }

//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 24),

//                   _GradientActionButton(
//                     label: "Update Password",
//                     isLoading: state.isLoading,
//                     onPressed: state.isLoading ? null : _resetPassword,
//                   ),

//                   const SizedBox(height: 12),

//                   TextButton(
//                     onPressed: state.isLoading ? null : _requestToken,
//                     child: const Text(
//                       "Resend Token",
//                       style: TextStyle(
//                         color: Color(0xFF6C7CFF),
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
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

//   Widget _label(String text) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 14,
//           color: Color(0xFFE8EAF0),
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.2,
//         ),
//       ),
//     );
//   }

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
//       cursorColor: const Color(0xFF6C7CFF),
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       obscureText: obscureText,
//       onTapOutside: (_) {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       decoration: _inputDecoration(
//         hintText: hint,
//         suffixIcon: suffixIcon,
//       ),
//       validator: validator,
//     );
//   }

//   InputDecoration _inputDecoration({
//     required String hintText,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       hintText: hintText,
//       hintStyle: const TextStyle(
//         color: Color(0xFF7C8494),
//         fontSize: 14,
//       ),
//       errorStyle: const TextStyle(
//         color: Color(0xFFFFC4C4),
//         fontWeight: FontWeight.w600,
//       ),
//       contentPadding: const EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: 15,
//       ),
//       suffixIcon: suffixIcon,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Color(0xFFD6DCFF),
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Color(0xFF6C7CFF),
//           width: 1.4,
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Colors.redAccent,
//         ),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Colors.redAccent,
//           width: 1.4,
//         ),
//       ),
//     );
//   }

//   Widget _buildPartyImage() {
//     return Container(
//       width: 480,
//       height: 570,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.35),
//             blurRadius: 45,
//             offset: const Offset(0, 25),
//           ),
//         ],
//       ),
//       child: Image.network(
//         _partyImage,
//         fit: BoxFit.cover,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;

//           return Container(
//             color: Colors.black.withValues(alpha: 0.25),
//             child: const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               ),
//             ),
//           );
//         },
//         errorBuilder: (_, __, ___) {
//           return Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF2F0B3A),
//                   Color(0xFF07133D),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _GradientActionButton extends StatelessWidget {
//   final String label;
//   final bool isLoading;
//   final VoidCallback? onPressed;

//   const _GradientActionButton({
//     required this.label,
//     required this.isLoading,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: onPressed == null ? 0.65 : 1,
//       child: Container(
//         width: double.infinity,
//         height: 54,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             colors: [
//               Color(0xFF2F5BFF),
//               Color(0xFF6C7CFF),
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF2F5BFF).withValues(alpha: 0.35),
//               blurRadius: 18,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(30),
//             onTap: onPressed,
//             child: Center(
//               child: isLoading
//                   ? const SizedBox(
//                       width: 22,
//                       height: 22,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : Text(
//                       label,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'dart:ui';
// // import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/Api_services/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';

// // --- STATE ---
// class ForgotPasswordState {
//   final bool isLoading;
//   final bool tokenRequested;
//   final bool obscureNew;
//   final bool obscureConfirm;

//   const ForgotPasswordState({
//     this.isLoading = false,
//     this.tokenRequested = false,
//     this.obscureNew = true,
//     this.obscureConfirm = true,
//   });

//   ForgotPasswordState copyWith({
//     bool? isLoading,
//     bool? tokenRequested,
//     bool? obscureNew,
//     bool? obscureConfirm,
//   }) {
//     return ForgotPasswordState(
//       isLoading: isLoading ?? this.isLoading,
//       tokenRequested: tokenRequested ?? this.tokenRequested,
//       obscureNew: obscureNew ?? this.obscureNew,
//       obscureConfirm: obscureConfirm ?? this.obscureConfirm,
//     );
//   }
// }

// // --- NOTIFIER ---
// class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
//   final ApiService _apiServices = ApiService();

//   @override
//   ForgotPasswordState build() => const ForgotPasswordState();

//   void toggleObscureNew() {
//     state = state.copyWith(obscureNew: !state.obscureNew);
//   }

//   void toggleObscureConfirm() {
//     state = state.copyWith(obscureConfirm: !state.obscureConfirm);
//   }

//   Future<(String message, bool isSuccess)?> requestToken(String usernameOrEmail) async {
//     if (usernameOrEmail.trim().isEmpty) {
//       return ('Please enter your username or email first', false);
//     }

//     state = state.copyWith(isLoading: true);

//     try {
//       final data = await _apiServices.requestPasswordReset(usernameOrEmail: usernameOrEmail);

//       final token = (data['resetToken'] ?? '').toString();
//       final message = (data['message'] ?? 'Reset instructions sent successfully').toString();

//       state = state.copyWith(tokenRequested: true);

//       return (
//         token.isNotEmpty
//             ? 'Use token: $token (dev mode)'
//             : message,
//         true
//       );
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }

//   Future<(String message, bool isSuccess)?> resetPassword({
//     required String usernameOrEmail,
//     required String resetToken,
//     required String newPassword,
//   }) async {
//     state = state.copyWith(isLoading: true);

//     try {
//       final data = await _apiServices.resetPassword(
//         usernameOrEmail: usernameOrEmail,
//         resetToken: resetToken,
//         newPassword: newPassword,
//       );

//       final message = (data['message'] ?? 'Password updated. Please login.').toString();

//       return (message, true);
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }

// // --- PROVIDER ---
// final forgotPasswordProvider =
//     NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
//   ForgotPasswordNotifier.new,
// );

// // --- WIDGET ---
// class ForgotPasswordPage extends ConsumerStatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   ConsumerState<ForgotPasswordPage> createState() => ForgotPasswordPageState();
// }

// class ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
//   final formKey = GlobalKey<FormState>();

//   // Upgraded Controller for Username or Email
//   final TextEditingController _usernameOrEmailController = TextEditingController();
//   final TextEditingController _tokenController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   static const String backgroundImage =
//       'https://www.beatflirtevent.com/assets/img/login-img/signup.jpg';

//   static const String partyImage =
//       'https://www.beatflirtevent.com/assets/img/login-img/img1.jpg';

//   static const String logoImage =
//       'https://www.beatflirtevent.com/assets/img/logo/logo.png';

//   @override
//   void dispose() {
//     _usernameOrEmailController.dispose();
//     _tokenController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> requestToken() async {
//     FocusManager.instance.primaryFocus?.unfocus();

//     final state = ref.read(forgotPasswordProvider);
//     if (state.isLoading) return;

//     final result = await ref
//         .read(forgotPasswordProvider.notifier)
//         .requestToken(_usernameOrEmailController.text.trim());

//     if (!mounted || result == null) return;

//     Get.snackbar(
//       result.$2 ? "Success" : "Invalid Input",
//       result.$1,
//       duration: const Duration(seconds: 4),
//       backgroundColor: result.$2 ? Colors.green : Colors.red,
//       colorText: Colors.white,
//     );
//   }

//   Future<void> resetPassword() async {
//     FocusManager.instance.primaryFocus?.unfocus();

//     if (!formKey.currentState!.validate()) return;

//     final state = ref.read(forgotPasswordProvider);
//     if (state.isLoading) return;

//     final result = await ref
//         .read(forgotPasswordProvider.notifier)
//         .resetPassword(
//           usernameOrEmail: _usernameOrEmailController.text.trim(),
//           resetToken: _tokenController.text.trim(),
//           newPassword: _newPasswordController.text.trim(),
//         );

//     if (!mounted || result == null) return;

//     Get.snackbar(
//       result.$2 ? "Success" : "Failed",
//       result.$1,
//       duration: const Duration(seconds: 3),
//       backgroundColor: result.$2 ? Colors.green : Colors.red,
//       colorText: Colors.white,
//     );

//     if (result.$2) {
//       Navigator.pop(context);
//     }
//   }

//   void backToLogin() {
//     FocusManager.instance.primaryFocus?.unfocus();

//     if (Navigator.canPop(context)) {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(forgotPasswordProvider);
//     final notifier = ref.read(forgotPasswordProvider.notifier);

//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.network(
//               backgroundImage,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFF12051D),
//                         Color(0xFF2B0B36),
//                         Color(0xFF07133D),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Dark overlay like website
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withValues(alpha: 0.45),
//             ),
//           ),

//           SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 final bool isWide = constraints.maxWidth >= 900;

//                 return SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: isWide ? 32 : 20,
//                     vertical: 28,
//                   ),
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight - 56,
//                     ),
//                     child: Center(
//                       child: ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 1100),
//                         child: isWide
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     flex: 5,
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: ConstrainedBox(
//                                         constraints:
//                                             const BoxConstraints(maxWidth: 480),
//                                         child: buildForgotPasswordCard(
//                                           state,
//                                           notifier,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 44),
//                                   Expanded(
//                                     flex: 6,
//                                     child: Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: buildPartyImage(),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : ConstrainedBox(
//                                 constraints:
//                                     const BoxConstraints(maxWidth: 480),
//                                 child: buildForgotPasswordCard(
//                                   state,
//                                   notifier,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildForgotPasswordCard(
//     ForgotPasswordState state,
//     ForgotPasswordNotifier notifier,
//   ) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(18),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(28, 32, 28, 30),
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.08),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: Colors.white.withValues(alpha: 0.16),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.25),
//                 blurRadius: 35,
//                 offset: const Offset(0, 20),
//               ),
//             ],
//           ),
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.network(
//                   logoImage,
//                   width: 125,
//                   fit: BoxFit.contain,
//                   errorBuilder: (_, __, ___) {
//                     return const Text(
//                       "Beat Flirt",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 22),

//                 const Text(
//                   "Forgot Password",
//                   style: TextStyle(
//                     fontSize: 28,
//                     color: Color(0xFFECEEF2),
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 _label("Username/Email"),

//                 const SizedBox(height: 8),

//                 _field(
//                   controller: _usernameOrEmailController,
//                   hint: "Enter Your Username/Email",
//                   keyboardType: TextInputType.text, // Updated so regular usernames aren't blocked by keyboards
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Please enter your username or email";
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 12),

//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: TextButton(
//                     onPressed: backToLogin,
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: const Size(0, 36),
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: const Text(
//                       "back to Login",
//                       style: TextStyle(
//                         color: Color(0xFFE8EAF0),
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 if (!state.tokenRequested)
//                   _GradientActionButton(
//                     label: "Send",
//                     isLoading: state.isLoading,
//                     onPressed: state.isLoading ? null : requestToken,
//                   ),

//                 if (state.tokenRequested) ...[
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withValues(alpha: 0.18),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: Colors.white.withValues(alpha: 0.12),
//                       ),
//                     ),
//                     child: const Text(
//                       "Reset instructions sent. Please enter your email token/code and your new password below.",
//                       style: TextStyle(
//                         color: Color(0xFFE8EAF0),
//                         fontSize: 13,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 18),

//                   _label("Reset Token"),

//                   const SizedBox(height: 8),

//                   _field(
//                     controller: _tokenController,
//                     hint: "Enter reset token (if provided)",
//                     textInputAction: TextInputAction.next,
//                     validator: (value) {
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   _label("New Password"),

//                   const SizedBox(height: 8),

//                   _field(
//                     controller: _newPasswordController,
//                     hint: "Enter new password",
//                     obscureText: state.obscureNew,
//                     textInputAction: TextInputAction.next,
//                     suffixIcon: IconButton(
//                       onPressed: notifier.toggleObscureNew,
//                       icon: Icon(
//                         state.obscureNew
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: const Color(0xFF6B75A6),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (!state.tokenRequested) return null;

//                       if (value == null || value.isEmpty) {
//                         return "Please enter new password";
//                       }

//                       if (value.length < 4) {
//                         return "Password must be at least 4 characters";
//                       }

//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   _label("Confirm Password"),

//                   const SizedBox(height: 8),

//                   _field(
//                     controller: _confirmPasswordController,
//                     hint: "Re-enter new password",
//                     obscureText: state.obscureConfirm,
//                     textInputAction: TextInputAction.done,
//                     suffixIcon: IconButton(
//                       onPressed: notifier.toggleObscureConfirm,
//                       icon: Icon(
//                         state.obscureConfirm
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: const Color(0xFF6B75A6),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (!state.tokenRequested) return null;

//                       if (value == null || value.isEmpty) {
//                         return "Please confirm password";
//                       }

//                       if (value != _newPasswordController.text) {
//                         return "Passwords do not match";
//                       }

//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 24),

//                   _GradientActionButton(
//                     label: "Update Password",
//                     isLoading: state.isLoading,
//                     onPressed: state.isLoading ? null : resetPassword,
//                   ),

//                   const SizedBox(height: 12),

//                   TextButton(
//                     onPressed: state.isLoading ? null : requestToken,
//                     child: const Text(
//                       "Resend Token",
//                       style: TextStyle(
//                         color: Color(0xFF6C7CFF),
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
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

//   Widget _label(String text) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 14,
//           color: Color(0xFFE8EAF0),
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.2,
//         ),
//       ),
//     );
//   }

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
//       cursorColor: const Color(0xFF6C7CFF),
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       obscureText: obscureText,
//       onTapOutside: (_) {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       decoration: _inputDecoration(
//         hintText: hint,
//         suffixIcon: suffixIcon,
//       ),
//       validator: validator,
//     );
//   }

//   InputDecoration _inputDecoration({
//     required String hintText,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       hintText: hintText,
//       hintStyle: const TextStyle(
//         color: Color(0xFF7C8494),
//         fontSize: 14,
//       ),
//       errorStyle: const TextStyle(
//         color: Color(0xFFFFC4C4),
//         fontWeight: FontWeight.w600,
//       ),
//       contentPadding: const EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: 15,
//       ),
//       suffixIcon: suffixIcon,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Color(0xFFD6DCFF),
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Color(0xFF6C7CFF),
//           width: 1.4,
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Colors.redAccent,
//         ),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Colors.redAccent,
//           width: 1.4,
//         ),
//       ),
//     );
//   }

//   Widget buildPartyImage() {
//     return Container(
//       width: 480,
//       height: 570,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.35),
//             blurRadius: 45,
//             offset: const Offset(0, 25),
//           ),
//         ],
//       ),
//       child: Image.network(
//         partyImage,
//         fit: BoxFit.cover,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;

//           return Container(
//             color: Colors.black.withValues(alpha: 0.25),
//             child: const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               ),
//             ),
//           );
//         },
//         errorBuilder: (_, __, ___) {
//           return Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF2F0B3A),
//                   Color(0xFF07133D),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _GradientActionButton extends StatelessWidget {
//   final String label;
//   final bool isLoading;
//   final VoidCallback? onPressed;

//   const _GradientActionButton({
//     required this.label,
//     required this.isLoading,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: onPressed == null ? 0.65 : 1,
//       child: Container(
//         width: double.infinity,
//         height: 54,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             colors: [
//               Color(0xFF2F5BFF),
//               Color(0xFF6C7CFF),
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF2F5BFF).withValues(alpha: 0.35),
//               blurRadius: 18,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(30),
//             onTap: onPressed,
//             child: Center(
//               child: isLoading
//                   ? const SizedBox(
//                       width: 22,
//                       height: 22,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : Text(
//                       label,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:ui';
import 'package:beatflirt/Api_services/api_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// --- STATE ---
class ForgotPasswordState {
  final bool isLoading;

  const ForgotPasswordState({
    this.isLoading = false,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// --- NOTIFIER ---
class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  final ApiService _apiServices = ApiService();

  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  Future<(String message, bool isSuccess)?> requestPasswordReset(String usernameOrEmail) async {
    if (usernameOrEmail.trim().isEmpty) {
      return ('Please enter your username or email first', false);
    }

    state = state.copyWith(isLoading: true);

    try {
      final data = await _apiServices.requestPasswordReset(usernameOrEmail: usernameOrEmail);
      final message = (data['message'] ?? 'Reset instructions sent successfully to your email').toString();

      return (message, true);
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
  ConsumerState<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _usernameOrEmailController = TextEditingController();

  static const String backgroundImage =
      'https://www.beatflirtevent.com/assets/img/login-img/signup.jpg';

  static const String partyImage =
      'https://www.beatflirtevent.com/assets/img/login-img/img1.jpg';

  static const String logoImage =
      'https://www.beatflirtevent.com/assets/img/logo/logo.png';

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    super.dispose();
  }

  Future<void> handleSend() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.validate()) return;

    final state = ref.read(forgotPasswordProvider);
    if (state.isLoading) return;

    final result = await ref
        .read(forgotPasswordProvider.notifier)
        .requestPasswordReset(_usernameOrEmailController.text.trim());

    if (!mounted || result == null) return;

    Get.snackbar(
      result.$2 ? "Success" : "Error",
      result.$1,
      duration: const Duration(seconds: 4),
      backgroundColor: result.$2 ? Colors.green : Colors.red,
      colorText: Colors.white,
    );

    // If successful, automatically return to the login screen so the user can check their email!
    if (result.$2) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }
  }

  void backToLogin() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              backgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF12051D),
                        Color(0xFF2B0B36),
                        Color(0xFF07133D),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Dark overlay exactly like the website
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isWide = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 32 : 20,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 56,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: isWide
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 480),
                                        child: buildForgotPasswordCard(state),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 44),
                                  Expanded(
                                    flex: 6,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: buildPartyImage(),
                                    ),
                                  ),
                                ],
                              )
                            : ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 480),
                                child: buildForgotPasswordCard(state),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildForgotPasswordCard(ForgotPasswordState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 30),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 35,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  logoImage,
                  width: 125,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Text(
                      "Beat Flirt",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 22),

                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFFECEEF2),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 30),

                _label("Username/Email"),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _usernameOrEmailController,
                  cursorColor: const Color(0xFF6C7CFF),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your username or email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter Your Username/Email",
                    hintStyle: const TextStyle(
                      color: Color(0xFF7C8494),
                      fontSize: 14,
                    ),
                    errorStyle: const TextStyle(
                      color: Color(0xFFFFC4C4),
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD6DCFF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF6C7CFF), width: 1.4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: backToLogin,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "back to Login",
                      style: TextStyle(
                        color: Color(0xFFE8EAF0),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                _GradientActionButton(
                  label: "Send",
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : handleSend,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFFE8EAF0),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget buildPartyImage() {
    return Container(
      width: 480,
      height: 570,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 45,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: Image.network(
        partyImage,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            color: Colors.black.withValues(alpha: 0.25),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2F0B3A),
                  Color(0xFF07133D),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _GradientActionButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.65 : 1,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF2F5BFF),
              Color(0xFF6C7CFF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2F5BFF).withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onPressed,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/core/app_color_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';

// // --- STATE ---
// class ForgotPasswordState {
//   final bool isLoading;
//   final bool tokenRequested;
//   final bool obscureNew;
//   final bool obscureConfirm;

//   const ForgotPasswordState({
//     this.isLoading = false,
//     this.tokenRequested = false,
//     this.obscureNew = true,
//     this.obscureConfirm = true,
//   });

//   ForgotPasswordState copyWith({
//     bool? isLoading,
//     bool? tokenRequested,
//     bool? obscureNew,
//     bool? obscureConfirm,
//   }) {
//     return ForgotPasswordState(
//       isLoading: isLoading ?? this.isLoading,
//       tokenRequested: tokenRequested ?? this.tokenRequested,
//       obscureNew: obscureNew ?? this.obscureNew,
//       obscureConfirm: obscureConfirm ?? this.obscureConfirm,
//     );
//   }
// }

// // --- NOTIFIER ---
// class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
//   final ApiServices _apiServices = ApiServices();

//   @override
//   ForgotPasswordState build() => const ForgotPasswordState();

//   void toggleObscureNew() {
//     state = state.copyWith(obscureNew: !state.obscureNew);
//   }

//   void toggleObscureConfirm() {
//     state = state.copyWith(obscureConfirm: !state.obscureConfirm);
//   }

//   Future<(String message, bool isSuccess)?> requestToken(String email) async {
//     if (email.isEmpty ||
//         !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
//       return ('Please enter a valid email first', false);
//     }

//     state = state.copyWith(isLoading: true);
//     try {
//       final data = await _apiServices.requestPasswordReset(email: email);
//       final token = (data['resetToken'] ?? '').toString();
//       state = state.copyWith(tokenRequested: true);
//       return (
//       token.isNotEmpty
//           ? 'Use token: $token (dev mode)'
//           : 'Token generated successfully',
//       true
//       );
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }

//   Future<(String message, bool isSuccess)?> resetPassword({
//     required String email,
//     required String resetToken,
//     required String newPassword,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       await _apiServices.resetPassword(
//         email: email,
//         resetToken: resetToken,
//         newPassword: newPassword,
//       );
//       return ('Password updated. Please login.', true);
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }

// // --- PROVIDER ---
// final forgotPasswordProvider =
// NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
//   ForgotPasswordNotifier.new,
// );

// // --- WIDGET ---
// class ForgotPasswordPage extends ConsumerStatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _tokenController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _tokenController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _requestToken() async {
//     final state = ref.read(forgotPasswordProvider);
//     if (state.isLoading) return;

//     final result = await ref
//         .read(forgotPasswordProvider.notifier)
//         .requestToken(_emailController.text.trim());

//     if (!mounted || result == null) return;

//     Get.snackbar(
//       result.$2 ? "Reset Token Generated" : "Invalid Email",
//       result.$1,
//       duration: const Duration(seconds: 4),
//       backgroundColor: result.$2 ? Colors.green : Colors.red,
//       colorText: Colors.white,
//     );
//   }

//   Future<void> _resetPassword() async {
//     if (!_formKey.currentState!.validate()) return;
//     final state = ref.read(forgotPasswordProvider);
//     if (state.isLoading) return;

//     final result = await ref.read(forgotPasswordProvider.notifier).resetPassword(
//       email: _emailController.text,
//       resetToken: _tokenController.text,
//       newPassword: _newPasswordController.text,
//     );

//     if (!mounted || result == null) return;

//     Get.snackbar(
//       result.$2 ? "Success" : "Failed",
//       result.$1,
//       backgroundColor: result.$2 ? Colors.green : Colors.red,
//       colorText: Colors.white,
//     );

//     if (result.$2) Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(forgotPasswordProvider);
//     final notifier = ref.read(forgotPasswordProvider.notifier);

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
//                 // const Text(
//                 //   "Reset Password",
//                 //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                 // ),
//                 // const SizedBox(height: 16),
//                 _label("Email"),
//                 const SizedBox(height: 5),
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
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.black,
//                       // padding: const EdgeInsets.symmetric(vertical: 14),
//                       // shape: RoundedRectangleBorder(
//                         // borderRadius: BorderRadius.circular(10),
//                       // ),
//                     ),
//                     child: state.isLoading && !state.tokenRequested
//                         ? const SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(strokeWidth: 2,color: Colors.black),
//                     )
//                         : const Text("Request Reset Token"),
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 if (state.tokenRequested) ...[
//                   _label("Reset Token"),
//                   const SizedBox(height: 5),
//                   _field(
//                     controller: _tokenController,
//                     hint: "Enter reset token",
//                     textInputAction: TextInputAction.next,
//                     validator: (value) {
//                       if (!state.tokenRequested) return null;
//                       if (value == null || value.isEmpty) return "Please enter reset token";
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   _label("New Password"),
//                   const SizedBox(height: 5),
//                   _field(
//                     controller: _newPasswordController,
//                     hint: "Enter new password",
//                     obscureText: state.obscureNew,
//                     textInputAction: TextInputAction.next,
//                     suffixIcon: IconButton(
//                       onPressed: notifier.toggleObscureNew,
//                       icon: Icon(state.obscureNew ? Icons.visibility_off : Icons.visibility),
//                     ),
//                     validator: (value) {
//                       if (!state.tokenRequested) return null;
//                       if (value == null || value.isEmpty) return "Please enter new password";
//                       if (value.length < 6) return "Password must be at least 6 characters";
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   _label("Confirm Password"),
//                   const SizedBox(height: 5),
//                   _field(
//                     controller: _confirmPasswordController,
//                     hint: "Re-enter new password",
//                     obscureText: state.obscureConfirm,
//                     textInputAction: TextInputAction.done,
//                     suffixIcon: IconButton(
//                       onPressed: notifier.toggleObscureConfirm,
//                       icon: Icon(state.obscureConfirm ? Icons.visibility_off : Icons.visibility),
//                     ),
//                     validator: (value) {
//                       if (!state.tokenRequested) return null;
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
//                       child: state.isLoading
//                           ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
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

//   Widget _label(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         letterSpacing: 1,
//         // fontSize: 20,
//         fontSize: 16,
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   Widget _field({
//     required TextEditingController controller,
//     required String hint,
//     required String? Function(String?) validator,
//     TextInputAction? textInputAction,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     Widget? customSuffixIcon;
//     if (suffixIcon != null) {
//       if (suffixIcon is IconButton) {
//         customSuffixIcon = IconButton(
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//           icon: suffixIcon.icon,
//           onPressed: suffixIcon.onPressed,
//         );
//       } else {
//         customSuffixIcon = suffixIcon;
//       }
//     }

//     return TextFormField(
//       onTapOutside: (_) {
//         FocusManager.instance.primaryFocus!.unfocus();
//       },
//       controller: controller,
//       cursorColor: Colors.pink.withValues(alpha: 0.5),
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         isDense: true,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         filled: true,
//         fillColor: AppColors.background,
//         hintText: hint,
//         suffixIconConstraints: suffixIcon != null
//             ? const BoxConstraints(
//                 minWidth: 40,
//                 minHeight: 30,
//               )
//             : null,
//         suffixIcon: customSuffixIcon,
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       validator: validator,
//     );
//   }
// }