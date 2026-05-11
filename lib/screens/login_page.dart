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

import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/app_color_constants.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'forgot_password_page.dart';
import 'home_screen.dart';
import 'register_page.dart';

// --- STATE ---
class LoginState {
  final bool isLoading;
  final bool obscurePassword;

  const LoginState({
    this.isLoading = false,
    this.obscurePassword = true,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? obscurePassword,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

// --- NOTIFIER ---
class LoginNotifier extends Notifier<LoginState> {
  final ApiServices _apiServices = ApiServices();

  @override
  LoginState build() => const LoginState();

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<(String message, bool isSuccess)?> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _apiServices.login(
        email: email,
        password: password,
      );
      final token = (data['token'] ?? '').toString();
      final user = (data['user'] as Map<String, dynamic>?);
      final userEmail = (user?['email'] ?? email).toString();
      await AuthService.login(token: token, email: userEmail);
      return ('Login Successful', true);
    } catch (e) {
      return (e.toString().replaceFirst('Exception: ', ''), false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// --- PROVIDER ---
final loginProvider =
NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);

// --- WIDGET ---
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final state = ref.read(loginProvider);
    if (state.isLoading) return;

    final result = await ref.read(loginProvider.notifier).login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted || result == null) return;

    if (result.$2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      Get.snackbar(
        "Success",
        result.$1,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Login Failed",
        result.$1,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Account Login",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.pink.withValues(alpha: 0.5),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background,
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        hintText: "Enter Your Email",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: state.obscurePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        filled: true,
                        fillColor: AppColors.background,
                        hintText: "Enter Your Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: notifier.toggleObscurePassword,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                            : const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterPage()),
                            );
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}