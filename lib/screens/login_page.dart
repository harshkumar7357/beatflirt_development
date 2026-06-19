// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/core/app_color_constants.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'forgot_password_page.dart';
// import 'home_screen.dart';
// import 'register_page.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final ApiServices _apiServices = ApiServices();
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.amber,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) => SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(minHeight: constraints.maxHeight),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Account Login",
//                       style: TextStyle(
//                         fontSize: 35,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Email",
//                         style: TextStyle(
//                           letterSpacing: 1,
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: _emailController,
//                       cursorColor: Colors.pink.withValues(alpha: 0.5),
//                       keyboardType: TextInputType.emailAddress,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: AppColors.background,
//                         visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
//                         hintText: "Enter Your Email",
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter Email';
//                         }
//                         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                           return 'Please enter a valid Email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 14),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Password",
//                         style: TextStyle(
//                           letterSpacing: 1,
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: _obscurePassword,
//                       textInputAction: TextInputAction.done,
//                       decoration: InputDecoration(
//                         visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
//                         filled: true,
//                         fillColor: AppColors.background,
//                         hintText: "Enter Your Password",
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword
//                                 ? Icons.visibility_off_outlined
//                                 : Icons.visibility_outlined,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter Password';
//                         }
//                         if (value.length < 6) {
//                           return 'Password must be at least 6 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
//                           );
//                         },
//                         child: const Text("Forgot Password?",style: TextStyle(color: Colors.black),),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           if (!_formKey.currentState!.validate()) return;
//                           if (_isLoading) return;
//                           setState(() => _isLoading = true);
//                           try {
//                             final data = await _apiServices.login(
//                               email: _emailController.text,
//                               password: _passwordController.text,
//                             );
//                             final token = (data['token'] ?? '').toString();
//                             final user = (data['user'] as Map<String, dynamic>?);
//                             final email =
//                                 (user?['email'] ?? _emailController.text).toString();
//                             await AuthService.login(token: token, email: email);
//                             if (!context.mounted) return;
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(builder: (context) => const HomePage()),
//                             );
//                             Get.snackbar(
//                               "Success",
//                               "Login Successful",
//                               duration: const Duration(seconds: 2),
//                               backgroundColor: Colors.green,
//                               colorText: Colors.white,
//                             );
//                           } catch (e) {
//                             Get.snackbar(
//                               "Login Failed",
//                               e.toString().replaceFirst('Exception: ', ''),
//                               duration: const Duration(seconds: 2),
//                               backgroundColor: Colors.red,
//                               colorText: Colors.white,
//                             );
//                           } finally {
//                             if (mounted) {
//                               setState(() => _isLoading = false);
//                             }
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           foregroundColor: Colors.white,
//                           elevation: 8,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: _isLoading
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Text("Login"),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Don't have an account?",
//                           style: TextStyle(fontSize: 15, color: Colors.black),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (_) => const RegisterPage()),
//                             );
//                           },
//                           child: Text(
//                             "Register",
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.red.withValues(alpha: 0.7),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:ui';

// import 'package:beatflirt/Api_services/api_service(new).dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';

// import 'forgot_password_page.dart';
// import 'home_screen.dart';
// import 'register_page.dart';

// // --- STATE ---
// class LoginState {
//   final bool isLoading;
//   final bool obscurePassword;

//   const LoginState({
//     this.isLoading = false,
//     this.obscurePassword = true,
//   });

//   LoginState copyWith({
//     bool? isLoading,
//     bool? obscurePassword,
//   }) {
//     return LoginState(
//       isLoading: isLoading ?? this.isLoading,
//       obscurePassword: obscurePassword ?? this.obscurePassword,
//     );
//   }
// }

// // --- NOTIFIER ---
// class LoginNotifier extends Notifier<LoginState> {
//   // final ApiServices _apiServices = ApiServices();
//   final ApiService _apiService = ApiService();

//   @override
//   LoginState build() => const LoginState();

//   void toggleObscurePassword() {
//     state = state.copyWith(obscurePassword: !state.obscurePassword);
//   }

//   Future<(String message, bool isSuccess)?> login({
//     required String email,
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true);

//     try {
//       final data = await _apiService.login(
//         email: email,
//         password: password,
//       );

//       final token = (data['token'] ?? '').toString();
//       final user = (data['user'] as Map<String, dynamic>?);
//       final userEmail = (user?['email'] ?? email).toString();
//       final userId = (user?['_id'] ?? user?['id'] ?? '').toString();

//       await AuthService.login(
//         token: token,
//         email: userEmail,
//         userId: userId,
//       );

//       return ('Login Successful', true);
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }

// // --- PROVIDER ---
// final loginProvider =
//     NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);

// // --- WIDGET ---
// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});

//   @override
//   ConsumerState<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends ConsumerState<LoginPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   static const String _backgroundImage =
//       'https://www.beatflirtevent.com/assets/img/login-img/signup.jpg';

//   static const String _partyImage =
//       'https://www.beatflirtevent.com/assets/img/login-img/img1.jpg';

//   static const String _logoImage =
//       'https://www.beatflirtevent.com/assets/img/logo/logo.png';

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitLogin() async {
//     if (!_formKey.currentState!.validate()) return;

//     final state = ref.read(loginProvider);
//     if (state.isLoading) return;

//     final result = await ref.read(loginProvider.notifier).login(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );

//     if (!mounted || result == null) return;

//     if (result.$2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );

//       Get.snackbar(
//         "Success",
//         result.$1,
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } else {
//       Get.snackbar(
//         "Login Failed",
//         result.$1,
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(loginProvider);
//     final notifier = ref.read(loginProvider.notifier);

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

//           // Dark overlay for better readability
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.45),
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
//                                         child:
//                                             _buildLoginCard(state, notifier),
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
//                                 child: _buildLoginCard(state, notifier),
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

//   Widget _buildLoginCard(LoginState state, LoginNotifier notifier) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(18),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(28, 32, 28, 30),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.16),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.25),
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
//                   "Login",
//                   style: TextStyle(
//                     fontSize: 28,
//                     color: Color(0xFFECEEF2),
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 _label("Email"),

//                 const SizedBox(height: 8),

//                 TextFormField(
//                   controller: _emailController,
//                   cursorColor: const Color(0xFF6C7CFF),
//                   keyboardType: TextInputType.emailAddress,
//                   textInputAction: TextInputAction.next,
//                   onTapOutside: (_) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   decoration: _inputDecoration(
//                     hintText: "Enter Your Email",
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter Email';
//                     }

//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                         .hasMatch(value.trim())) {
//                       return 'Please enter a valid Email';
//                     }

//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 18),

//                 Row(
//                   children: [
//                     _label("Password"),
//                     const SizedBox(width: 6),
//                     const Icon(
//                       Icons.sentiment_satisfied_alt,
//                       color: Color(0xFFE8EAF0),
//                       size: 16,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 8),

//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: state.obscurePassword,
//                   textInputAction: TextInputAction.done,
//                   onFieldSubmitted: (_) => _submitLogin(),
//                   onTapOutside: (_) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   decoration: _inputDecoration(
//                     hintText: "Enter Your Password",
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         state.obscurePassword
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: const Color(0xFF6B75A6),
//                       ),
//                       onPressed: notifier.toggleObscurePassword,
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter Password';
//                     }

//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }

//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 10),

//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const ForgotPasswordPage(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Forgot Password",
//                       style: TextStyle(
//                         color: Color(0xFFE8EAF0),
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 2),

//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const RegisterPage(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "New members Signup in at Beat Flirt",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Color(0xFF6C7CFF),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 _GradientLoginButton(
//                   isLoading: state.isLoading,
//                   onPressed: state.isLoading ? null : _submitLogin,
//                 ),
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
//             color: Colors.black.withOpacity(0.35),
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
//             color: Colors.black.withOpacity(0.25),
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

// class _GradientLoginButton extends StatelessWidget {
//   final bool isLoading;
//   final VoidCallback? onPressed;

//   const _GradientLoginButton({
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
//               color: const Color(0xFF2F5BFF).withOpacity(0.35),
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
//                   : const Text(
//                       "Sign In",
//                       style: TextStyle(
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

// lib/screens/login_page.dart

import 'dart:convert';
import 'dart:ui';

import 'package:beatflirt/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_page.dart';
import 'home_screen.dart';
import 'register_page.dart';

// ══════════════════════════════════════════════════════════════
// STATE
// ══════════════════════════════════════════════════════════════
class LoginState {
  final bool isLoading;
  final bool obscurePassword;

  const LoginState({
    this.isLoading       = false,
    this.obscurePassword = true,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? obscurePassword,
  }) {
    return LoginState(
      isLoading:       isLoading       ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

// ══════════════════════════════════════════════════════════════
// NOTIFIER
// ══════════════════════════════════════════════════════════════
class LoginNotifier extends Notifier<LoginState> {
  // static const String _baseUrl = 'https://beatflirtevent.com';
  static const String _baseUrl = 'https://app.beatflirtevent.com';


  @override
  LoginState build() => const LoginState();

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  // ── LOGIN ─────────────────────────────────────────────────
  // URL     : POST https://beatflirtevent.com/api/App/auth/login
  //
  // Payload : { "username": "testing6", "password": "Jin@123456" }
  //
  // Response: {
  //   "status": "200",
  //   "message": "Sucessfully login.",
  //   "data": {
  //     "token":        "...",
  //     "sign":         "...",
  //     "userid":       "408",
  //     "username":     "testing6",
  //     "email":        "harshkmr12@gmail.com",
  //     "profile_type": "single",
  //     "profile_image":"male.png"
  //   }
  // }
  // ──────────────────────────────────────────────────────────
//   Future<(String, bool)?> login({
//     required String username, // ✅ API uses 'username' NOT 'email'
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true);

//     try {
//       final uri = Uri.parse('$_baseUrl/api/App/auth/login');

//       final response = await http.post(
//         uri,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': username, // ✅ confirmed field name
//           'password': password,
//         }),
//       );

//       final body = jsonDecode(response.body) as Map<String, dynamic>;

//       // API returns status as string "200" inside body
//       final apiStatus = body['status']?.toString() ?? '';

//       if (response.statusCode == 200 && apiStatus == '200') {
//         // ── Parse confirmed response structure ──────────────
//         final data         = body['data'] as Map<String, dynamic>? ?? {};
//         final token        = (data['token']    ?? '').toString();
//         final userId       = (data['userid']   ?? '').toString();
//         final email        = (data['email']    ?? username).toString();
//         final profileType  = (data['profile_type'] ?? '').toString();
//         final profileImage = (data['profile_image'] ?? '').toString();

//         // ── Save full session ────────────────────────────────
//         await AuthService.login(
//           token:  token,
//           email:  email,
//           userId: userId,
//         );

//         // Optionally save extra fields if AuthService supports them
//         // await AuthService.saveProfileType(profileType);
//         // await AuthService.saveProfileImage(profileImage);

//         return (body['message']?.toString() ?? 'Login Successful', true);
//       } else {
//         throw Exception(body['message'] ?? 'Login failed');
//       }
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }

  Future<(String, bool)?> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // final uri = Uri.parse('$_baseUrl/api/App/auth/login');
      final uri = Uri.parse('$_baseUrl/App/auth/login');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final apiStatus = body['status']?.toString() ?? '';

      if (response.statusCode == 200 && apiStatus == '200') {
        final data = body['data'] as Map<String, dynamic>? ?? {};
        final token = (data['token'] ?? '').toString().trim();
        final sign = (data['sign'] ?? '').toString().trim();
        final userId = (data['userid'] ?? '').toString();
        final email = (data['email'] ?? username).toString();

        // ── NEW: Reject login if token is missing/empty ────
        if (token.isEmpty) {
          throw Exception('Login succeeded but no token was received.');
        }

        await AuthService.login(
          token: token,
          email: email,
          userId: userId,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Access-Token', token);
        await prefs.setString('access_token', token);
        await prefs.setString('accessToken', token);
        await prefs.setString('token', token);

        if (sign.isNotEmpty) {
          await prefs.setString('Access-Sign', sign);
          await prefs.setString('access_sign', sign);
          await prefs.setString('accessSign', sign);
          await prefs.setString('sign', sign);
        }

        // Debug: confirm it was saved (remove after testing)
        final savedToken = await AuthService.getToken();
        debugPrint('🔑 Token saved: $savedToken');

        return (body['message']?.toString() ?? 'Login Successful', true);
      } else {
        throw Exception(body['message'] ?? 'Login failed');
        // throw Exception('Login Failed');
      }
    } catch (e) {
      return (e.toString().replaceFirst('Exception: ', ''), false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// ══════════════════════════════════════════════════════════════
// PROVIDER
// ══════════════════════════════════════════════════════════════
final loginProvider =
    NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);

// ══════════════════════════════════════════════════════════════
// WIDGET
// ══════════════════════════════════════════════════════════════
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Field is now 'username' to match API payload
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();

  static const String _backgroundImage =
      'https://www.beatflirtevent.com/assets/img/login-img/signup.jpg';
  static const String _partyImage =
      'https://www.beatflirtevent.com/assets/img/login-img/img1.jpg';
  static const String _logoImage =
      'https://www.beatflirtevent.com/assets/img/logo/logo.png';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Submit Login ───────────────────────────────────────────
  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(loginProvider);
    if (state.isLoading) return;

    final result = await ref.read(loginProvider.notifier).login(
      username: _usernameController.text.trim(), // ✅ sends as 'username'
      password: _passwordController.text.trim(),
    );

    if (!mounted || result == null) return;

    if (result.$2) {
      // ✅ Success → go to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      Get.snackbar(
        "Success",
        result.$1,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // ❌ Failed → show error
      Get.snackbar(
        "Login Failed",
        "Please Try Again",
        // result.$1,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ══════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final state    = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              _backgroundImage,
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

          // Dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),

          // Content
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
                                        constraints: const BoxConstraints(
                                            maxWidth: 480),
                                        child: _buildLoginCard(state, notifier),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 44),
                                  Expanded(
                                    flex: 6,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: _buildPartyImage(),
                                    ),
                                  ),
                                ],
                              )
                            : ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 480),
                                child: _buildLoginCard(state, notifier),
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

  // ══════════════════════════════════════════════════════════
  // LOGIN CARD
  // ══════════════════════════════════════════════════════════
  Widget _buildLoginCard(LoginState state, LoginNotifier notifier) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 30),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 35,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.network(
                  _logoImage,
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
                  // "Login",
                  "Sign In",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFFECEEF2),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 30),

                // ── Username field ✅ (API uses 'username') ──
                _label("Username"),
                const SizedBox(height: 8),
                TextFormField(
                
                  controller: _usernameController,
                  cursorColor: const Color(0xFF6C7CFF),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: _inputDecoration(
                    hintText: "Enter Your Username",
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                
                    
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Username';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ── Password field ────────────────────────────
                Row(
                  children: [
                    _label("Password"),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.sentiment_satisfied_alt,
                      color: Color(0xFFE8EAF0),
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submitLogin(),
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: _inputDecoration(
                    hintText: "Enter Your Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF6B75A6),
                      ),
                      onPressed: notifier.toggleObscurePassword,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: -4),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // ── Forgot Password ───────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Color(0xFFE8EAF0),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                // ── Go to Register ────────────────────────────
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "New members Signup in at Beat Flirt",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6C7CFF),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Login Button ──────────────────────────────
                _GradientLoginButton(
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : _submitLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────
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

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
    bool isDense = false,
    EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      isDense: isDense,
      hintStyle: const TextStyle(color: Color(0xFF7C8494), fontSize: 14),
      errorStyle: const TextStyle(
        color: Color(0xFFFFC4C4),
        fontWeight: FontWeight.w600,
      ),
      contentPadding: contentPadding,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD6DCFF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Color(0xFF6C7CFF), width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    );
  }

  // ── Party image (wide layout only) ───────────────────────
  Widget _buildPartyImage() {
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
        _partyImage,
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
                colors: [Color(0xFF2F0B3A), Color(0xFF07133D)],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// GRADIENT LOGIN BUTTON
// ══════════════════════════════════════════════════════════════
class _GradientLoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _GradientLoginButton({
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
            colors: [Color(0xFF2F5BFF), Color(0xFF6C7CFF)],
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
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Sign In",
                      style: TextStyle(
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
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';

// import 'forgot_password_page.dart';
// import 'home_screen.dart';
// import 'register_page.dart';

// // --- STATE ---
// class LoginState {
//   final bool isLoading;
//   final bool obscurePassword;

//   const LoginState({
//     this.isLoading = false,
//     this.obscurePassword = true,
//   });

//   LoginState copyWith({
//     bool? isLoading,
//     bool? obscurePassword,
//   }) {
//     return LoginState(
//       isLoading: isLoading ?? this.isLoading,
//       obscurePassword: obscurePassword ?? this.obscurePassword,
//     );
//   }
// }

// // --- NOTIFIER ---
// class LoginNotifier extends Notifier<LoginState> {
//   final ApiServices _apiServices = ApiServices();

//   @override
//   LoginState build() => const LoginState();

//   void toggleObscurePassword() {
//     state = state.copyWith(obscurePassword: !state.obscurePassword);
//   }

//   Future<(String message, bool isSuccess)?> login({
//     required String email,
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final data = await _apiServices.login(
//         email: email,
//         password: password,
//       );
//       final token = (data['token'] ?? '').toString();
//       final user = (data['user'] as Map<String, dynamic>?);
//       final userEmail = (user?['email'] ?? email).toString();
//       final userId = (user?['_id'] ?? user?['id'] ?? '').toString();
//       await AuthService.login(token: token, email: userEmail, userId: userId);
//       return ('Login Successful', true);
//     } catch (e) {
//       return (e.toString().replaceFirst('Exception: ', ''), false);
//     } finally {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }

// // --- PROVIDER ---
// final loginProvider =
// NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);

// // --- WIDGET ---
// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});

//   @override
//   ConsumerState<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends ConsumerState<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//     final state = ref.read(loginProvider);
//     if (state.isLoading) return;

//     final result = await ref.read(loginProvider.notifier).login(
//       email: _emailController.text,
//       password: _passwordController.text,
//     );

//     if (!mounted || result == null) return;

//     if (result.$2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//       Get.snackbar(
//         "Success",
//         result.$1,
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } else {
//       Get.snackbar(
//         "Login Failed",
//         result.$1,
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(loginProvider);
//     final notifier = ref.read(loginProvider.notifier);

//     return Scaffold(
//       backgroundColor: Colors.amber,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) => SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(minHeight: constraints.maxHeight),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // const Text(
//                     //   "BeatFlirt",
//                     //   style: TextStyle(
//                     //     fontSize: 35,
//                     //     color: Colors.black,
//                     //     fontWeight: FontWeight.bold,
//                     //   ),
//                     // ),
//                     const Text(
//                       "Account Login",
//                       style: TextStyle(
//                         fontSize: 30,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Email",
//                         style: TextStyle(
//                           letterSpacing: 1,
//                           fontSize: 16,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       onTapOutside: (_) {
//         FocusManager.instance.primaryFocus!.unfocus();
//       },
//                       controller: _emailController,
//                       cursorColor: Colors.pink.withValues(alpha: 0.5),
//                       keyboardType: TextInputType.emailAddress,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         isDense: true,
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         filled: true,
//                         fillColor: AppColors.background,
//                         hintText: "Enter Your Email",
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter Email';
//                         }
//                         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                           return 'Please enter a valid Email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 14),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Password",
//                         style: TextStyle(
//                           letterSpacing: 1,
//                           // fontSize: 20,
//                             fontSize: 16,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       onTapOutside: (_) {
//         FocusManager.instance.primaryFocus!.unfocus();
//       },
                      
//                       controller: _passwordController,
//                       obscureText: state.obscurePassword,
//                       textInputAction: TextInputAction.done,
//                       decoration: InputDecoration(
//                         isDense: true,
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         filled: true,
//                         fillColor: AppColors.background,
//                         hintText: "Enter Your Password",
//                         suffixIconConstraints: const BoxConstraints(
//                           minWidth: 40,
//                           minHeight: 30,
//                         ),
//                         suffixIcon: IconButton(
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                           icon: Icon(
//                             state.obscurePassword
//                                 ? Icons.visibility_off_outlined
//                                 : Icons.visibility_outlined,
//                           ),
//                           onPressed: notifier.toggleObscurePassword,
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter Password';
//                         }
//                         if (value.length < 6) {
//                           return 'Password must be at least 6 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
//                           );
//                         },
//                         child: const Text(
//                           "Forgot Password?",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     // const SizedBox(height: 24),
//                     const SizedBox(height: 4),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _submitLogin,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           foregroundColor: Colors.white,
//                           elevation: 8,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: state.isLoading
//                             ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                             : const Text("Log in"),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Don't have an account?",
//                           style: TextStyle(fontSize: 15, color: Colors.black),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (_) => const RegisterPage()),
//                             );
//                           },
//                           child: Text(
//                             "Register",
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.red.withValues(alpha: 0.7),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }