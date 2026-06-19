// import 'package:beatflirt/core/app_color_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import '../providers/register_provider.dart';
// import 'home_screen.dart';

// class RegisterPage extends ConsumerStatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   ConsumerState<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends ConsumerState<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;
//     final state = ref.read(registerProvider);
//     if (state.isLoading) return;

//     final result = await ref.read(registerProvider.notifier).register(
//       name: _nameController.text,
//       email: _emailController.text,
//       password: _passwordController.text,
//     );

//     if (!mounted || result == null) return;

//     if (result.$2) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const HomePage()),
//             (route) => false,
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
//         "Registration Failed",
//         result.$1,
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(registerProvider);
//     final notifier = ref.read(registerProvider.notifier);

//     return Scaffold(
//       backgroundColor: Colors.amber,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text("Create Account"),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // const SizedBox(height: 10),
//                 // const Text(
//                 //   "Register",
//                 //   style: TextStyle(
//                 //     fontSize: 34,
//                 //     color: Colors.black,
//                 //     fontWeight: FontWeight.bold,
//                 //   ),
//                 // ),
//                 // const SizedBox(height: 20),
//                 _label("Full Name"),
//                 _field(
//                   controller: _nameController,
//                   hint: "Enter your name",
//                   textInputAction: TextInputAction.next,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) return "Please enter name";
//                     if (value.trim().length < 2) return "Name must be at least 2 characters";
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 _label("Email"),
//                 _field(
//                   controller: _emailController,
//                   hint: "Enter your email",
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
//                 _label("Password"),
//                 _field(
//                   controller: _passwordController,
//                   hint: "Enter password",
//                   obscureText: state.obscurePassword,
//                   textInputAction: TextInputAction.next,
//                   onChanged: notifier.updatePassword,
//                   suffixIcon: IconButton(
//                     onPressed: notifier.toggleObscurePassword,
//                     icon: Icon(
//                       state.obscurePassword ? Icons.visibility_off : Icons.visibility,
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return "Please enter password";
//                     if (!ref.read(registerProvider).isStrongByRegex) {
//                       return "Password must match required format";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 // _passwordRule("Minimum 8 characters", state.hasMinLength),
//                 // _passwordRule("First letter must be CAPITAL", state.startsWithCapital),
//                 // _passwordRule("Must contain a letter in between", state.hasMiddleLetter),
//                 // _passwordRule("Last character must be a letter", state.endsWithLetter),

//                 _passwordRule("At least 8 characters", state.hasMinLength),
//                 _passwordRule("At least one uppercase letter (A-Z)", state.hasUppercase),
//                 _passwordRule("At least one lowercase letter (a-z)", state.hasLowercase),
//                 _passwordRule("At least one digit (0-9)", state.hasDigit),
//                 _passwordRule("At least one special character (!@#\$%&*)", state.hasSpecialChar),

//                 const SizedBox(height: 12),
//                 _label("Confirm Password"),
//                 _field(
//                   controller: _confirmPasswordController,
//                   // hint: "Re-enter password",
//                   hint: "Confirm Password",
//                   obscureText: state.obscureConfirmPassword,
//                   textInputAction: TextInputAction.done,
//                   suffixIcon: IconButton(
//                     onPressed: notifier.toggleObscureConfirmPassword,
//                     icon: Icon(
//                       state.obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please confirm password";
//                     }
//                     if (value != _passwordController.text) {
//                       return "Passwords do not match";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _register,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     child: state.isLoading
//                         ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                         : const Text("Register"),
//                   ),
//                 ),
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
//     ValueChanged<String>? onChanged,
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
//       onChanged: onChanged,
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

//   Widget _passwordRule(String text, bool isValid) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(
//         children: [
//           Icon(
//             isValid ? Icons.check_circle : Icons.cancel,
//             size: 18,
//             color: isValid ? Colors.green : Colors.red,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 13,
//               color: isValid ? Colors.green.shade800 : Colors.red.shade700,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// lib/screens/register_page.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/register_provider.dart';
import 'home_screen.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────────
  final TextEditingController _nameController            = TextEditingController();
  final TextEditingController _emailController           = TextEditingController();
  final TextEditingController _passwordController        = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _locationController        = TextEditingController();

  // ── Profile & Gender ─────────────────────────────
  String  _profileType     = 'single';
  String? _singleGender;
  String? _coupleGenderFrom;
  String? _coupleGenderTo;

  // ── Terms ─────────────────────────────────────────
  bool _acceptedTerms  = false;
  bool _showTermsError = false;

  // ── Location fields (populated from _locationController for now) ──
  // If you integrate Google Places later, populate these from the picker
  String _lat              = '0.0';
  String _lng              = '0.0';
  String _placeId          = '';
  String _mapUrl           = '';
  String _formattedAddress = '';

  // ── Assets ────────────────────────────────────────
  static const String _backgroundImage =
      'https://www.beatflirtevent.com/assets/img/login-img/signup.jpg';
  static const String _logoImage =
      'https://www.beatflirtevent.com/assets/img/logo/logo.png';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════
  // REGISTER — wired to both Single & Couple API
  // ══════════════════════════════════════════════════
  Future<void> _register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _showTermsError = !_acceptedTerms;
    });

    if (!_formKey.currentState!.validate() || !_acceptedTerms) return;

    final state = ref.read(registerProvider);
    if (state.isLoading) return;

    // Use location controller text as city / formatted address fallback
    final cityName         = _locationController.text.trim();
    final formattedAddress = _formattedAddress.isNotEmpty
        ? _formattedAddress
        : _locationController.text.trim();

    (String, bool)? result;

    // ════════════════════════════════════════════════
    // SINGLE
    // ════════════════════════════════════════════════
    if (_profileType == 'single') {
      if (_singleGender == null) {
        Get.snackbar(
          "Required",
          "Please select your gender",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      result = await ref.read(registerProvider.notifier).registerSingle(
        username:         _nameController.text.trim(),
        email:            _emailController.text.trim(),
        password:         _passwordController.text.trim(),
        gender:           _singleGender!,   // "male" | "female" | "transgender"
        lat:              _lat,
        lng:              _lng,
        cityName:         cityName,
        placeId:          _placeId,
        mapUrl:           _mapUrl,
        formattedAddress: formattedAddress,
      );

    // ════════════════════════════════════════════════
    // COUPLE
    // ════════════════════════════════════════════════
    } else {
      if (_coupleGenderFrom == null || _coupleGenderTo == null) {
        Get.snackbar(
          "Required",
          "Please select gender for both partners",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      result = await ref.read(registerProvider.notifier).registerCouple(
        username:         _nameController.text.trim(),
        email:            _emailController.text.trim(),
        password:         _passwordController.text.trim(),
        genderFrom:       _coupleGenderFrom!,  // "male" | "female" | "transgender"
        genderTo:         _coupleGenderTo!,    // "male" | "female" | "transgender"
        lat:              _lat,
        lng:              _lng,
        cityName:         cityName,
        placeId:          _placeId,
        mapUrl:           _mapUrl,
        formattedAddress: formattedAddress,
      );
    }

    if (!mounted || result == null) return;

    if (result.$2) {
      // ✅ Success — token already saved by provider via AuthService.login()
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
      Get.snackbar(
        "Success 🎉",
        result.$1,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // ❌ Failed
      Get.snackbar(
        "Registration Failed",
        "Please Try Again",
        // result.$1,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ══════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final state    = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

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
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: _buildRegisterCard(state, notifier),
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

  // ══════════════════════════════════════════════════
  // REGISTER CARD
  // ══════════════════════════════════════════════════
  Widget _buildRegisterCard(RegisterState state, RegisterNotifier notifier) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 40,
                offset: const Offset(0, 22),
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
                  width: 120,
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

                const SizedBox(height: 18),

                const Text(
                  "REGISTER NOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 26),

                // ── Profile Type ──────────────────────
                _label("Profile Type *"),
                const SizedBox(height: 8),
                _profileSelector(),

                const SizedBox(height: 16),

                // ── Gender Section ────────────────────
                _genderSection(),

                const SizedBox(height: 14),

                // ── Username ──────────────────────────
                _field(
                  controller: _nameController,
                  hint: "Username",
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter username";
                    }
                    if (value.trim().length < 2) {
                      return "Username must be at least 2 characters";
                    }
                    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value.trim())) {
                      return "Username can contain only letters and numbers";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ── Email ─────────────────────────────
                _field(
                  controller: _emailController,
                  hint: "Your email address",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter email";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value.trim())) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ── Password ──────────────────────────
                _field(
                  controller: _passwordController,
                  hint: "Password",
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.next,
                  onChanged: notifier.updatePassword,
                  suffixIcon: IconButton(
                    onPressed: notifier.toggleObscurePassword,
                    icon: Icon(
                      state.obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF6B75A6),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    }
                    if (!ref.read(registerProvider).isStrongByRegex) {
                      return "Password must match required format";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                _passwordRules(state),
                const SizedBox(height: 14),

                // ── Confirm Password ──────────────────
                _field(
                  controller: _confirmPasswordController,
                  hint: "Confirm Password",
                  obscureText: state.obscureConfirmPassword,
                  textInputAction: TextInputAction.next,
                  suffixIcon: IconButton(
                    onPressed: notifier.toggleObscureConfirmPassword,
                    icon: Icon(
                      state.obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF6B75A6),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ── Location ──────────────────────────
                _field(
                  controller: _locationController,
                  hint: "Enter Location (City Name)",
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter location";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // ── Terms ─────────────────────────────
                _termsSection(),

                const SizedBox(height: 18),

                // ── Submit Button ─────────────────────
                _GradientRegisterButton(
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : _register,
                ),

                const SizedBox(height: 18),

                TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                  child: const Text(
                    "Existing members log in at Beat Flirt",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6C7CFF),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Erotic Dating for Swingers, Open-Minded Couples & Singles",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFE8EAF0), fontSize: 12),
                ),

                const SizedBox(height: 6),

                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _showInfoDialog(
                        title: "Terms and Conditions",
                        message: "Terms and Conditions content can be added here.",
                      ),
                      child: const Text(
                        "Terms and Conditions",
                        style: TextStyle(color: Color(0xFF6C7CFF), fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showInfoDialog(
                        title: "Privacy Policy",
                        message: "Privacy Policy content can be added here.",
                      ),
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(color: Color(0xFF6C7CFF), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Profile type radio ────────────────────────────
  Widget _profileSelector() {
    return Row(
      children: [
        _profileRadio("single", "Single"),
        const SizedBox(width: 22),
        _profileRadio("couple", "Couple"),
      ],
    );
  }

  Widget _profileRadio(String value, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => setState(() => _profileType = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: _profileType,
            activeColor: const Color(0xFF7B3FA3),
            onChanged: (selected) {
              if (selected == null) return;
              setState(() => _profileType = selected);
            },
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Gender section ────────────────────────────────
  Widget _genderSection() {
    if (_profileType == 'single') {
      return _genderDropdown(
        value: _singleGender,
        onChanged: (v) => setState(() => _singleGender = v),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoCol = constraints.maxWidth > 560;
        final from = _genderDropdown(
          value: _coupleGenderFrom,
          onChanged: (v) => setState(() => _coupleGenderFrom = v),
        );
        final to = _genderDropdown(
          value: _coupleGenderTo,
          onChanged: (v) => setState(() => _coupleGenderTo = v),
        );

        return twoCol
            ? Row(children: [
                Expanded(child: from),
                const SizedBox(width: 14),
                Expanded(child: to),
              ])
            : Column(children: [
                from,
                const SizedBox(height: 14),
                to,
              ]);
      },
    );
  }

  Widget _genderDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: _inputDecoration(hintText: "Please Select Gender"),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF6B75A6),
      ),
      items: const [
        DropdownMenuItem(value: "male",        child: Text("Male")),
        DropdownMenuItem(value: "female",      child: Text("Female")),
        DropdownMenuItem(value: "transgender", child: Text("Transgender")),
      ],
      onChanged: onChanged,
      validator: (v) =>
          (v == null || v.isEmpty) ? "Please select gender" : null,
    );
  }

  // ── Form helpers ──────────────────────────────────
  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
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
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: const Color(0xFF7B3FA3),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: _inputDecoration(hintText: hint, suffixIcon: suffixIcon),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF7C8494), fontSize: 14),
      errorStyle: const TextStyle(
        color: Color(0xFFFFC4C4),
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD4DBFF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF7B3FA3), width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    );
  }

  // ── Password rules checklist ──────────────────────
  Widget _passwordRules(RegisterState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          _passwordRule("At least 8 characters",              state.hasMinLength),
          _passwordRule("At least one uppercase letter (A-Z)", state.hasUppercase),
          _passwordRule("At least one lowercase letter (a-z)", state.hasLowercase),
          _passwordRule("At least one digit (0-9)",            state.hasDigit),
          _passwordRule("At least one special character (!@#\$%&*)", state.hasSpecialChar),
        ],
      ),
    );
  }

  Widget _passwordRule(String text, bool isValid) {
    final color = isValid ? const Color(0xFF35D07F) : const Color(0xFFFF7878);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 17,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Terms & Conditions ────────────────────────────
  Widget _termsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: _acceptedTerms,
              activeColor: const Color(0xFF7B3FA3),
              checkColor: Colors.white,
              side: const BorderSide(color: Colors.white70),
              onChanged: (v) {
                setState(() {
                  _acceptedTerms  = v ?? false;
                  _showTermsError = !_acceptedTerms;
                });
              },
            ),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    "I agree to the ",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  InkWell(
                    onTap: () => _showInfoDialog(
                      title: "Terms and Conditions",
                      message: "Terms and Conditions content can be added here.",
                    ),
                    child: const Text(
                      "Terms and Conditions",
                      style: TextStyle(
                        color: Color(0xFF6C7CFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_showTermsError)
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 2),
            child: Text(
              "Please accept Terms and Conditions",
              style: TextStyle(
                color: Color(0xFFFFC4C4),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  void _showInfoDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
// GRADIENT BUTTON
// ══════════════════════════════════════════════════
class _GradientRegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _GradientRegisterButton({
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
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF5A2D82), Color(0xFF7B3FA3)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B3FA3).withValues(alpha: 0.36),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
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
                  : const Text(
                      "Create Account",
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



// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';

// import '../providers/register_provider.dart';
// import 'home_screen.dart';

// class RegisterPage extends ConsumerStatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   ConsumerState<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends ConsumerState<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final TextEditingController _locationController = TextEditingController();

//   String _profileType = 'single';
//   String? _singleGender;
//   String? _coupleGenderFrom;
//   String? _coupleGenderTo;

//   bool _acceptedTerms = false;
//   bool _showTermsError = false;

//   static const String _backgroundImage =
//       'https://www.beatflirtevent.com/assets/img/login-img/signup.jpg';

//   static const String _logoImage =
//       'https://www.beatflirtevent.com/assets/img/logo/logo.png';

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _locationController.dispose();
//     super.dispose();
//   }

//   Future<void> _register() async {
//     FocusManager.instance.primaryFocus?.unfocus();

//     setState(() {
//       _showTermsError = !_acceptedTerms;
//     });

//     if (!_formKey.currentState!.validate() || !_acceptedTerms) return;

//     final state = ref.read(registerProvider);
//     if (state.isLoading) return;

//     /*
//       Your current provider accepts only:
//       name, email, password

//       Profile type, gender, location and terms are added for UI like website.
//       If your backend needs them, add those parameters in register_provider.dart
//       and ApiServices registration method also.
//     */
//     final result = await ref.read(registerProvider.notifier).register(
//           name: _nameController.text.trim(),
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );

//     if (!mounted || result == null) return;

//     if (result.$2) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const HomePage()),
//         (route) => false,
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
//         "Registration Failed",
//         result.$1,
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(registerProvider);
//     final notifier = ref.read(registerProvider.notifier);

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

//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.45),
//             ),
//           ),

//           SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 28,
//                   ),
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight,
//                     ),
//                     child: Center(
//                       child: ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 760),
//                         child: _buildRegisterCard(state, notifier),
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

//   Widget _buildRegisterCard(dynamic state, dynamic notifier) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(18),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.16),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.28),
//                 blurRadius: 40,
//                 offset: const Offset(0, 22),
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
//                   width: 120,
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

//                 const SizedBox(height: 18),

//                 const Text(
//                   "REGISTER NOW",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 25,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 0.8,
//                   ),
//                 ),

//                 const SizedBox(height: 26),

//                 _label("Profile Type *"),
//                 const SizedBox(height: 8),
//                 _profileSelector(),

//                 const SizedBox(height: 16),

//                 _genderSection(),

//                 const SizedBox(height: 14),

//                 _field(
//                   controller: _nameController,
//                   hint: "Username",
//                   textInputAction: TextInputAction.next,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(
//                       RegExp(r'[a-zA-Z0-9]'),
//                     ),
//                   ],
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Please enter username";
//                     }

//                     if (value.trim().length < 2) {
//                       return "Username must be at least 2 characters";
//                     }

//                     if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value.trim())) {
//                       return "Username can contain only letters and numbers";
//                     }

//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 14),

//                 _field(
//                   controller: _emailController,
//                   hint: "Your email address",
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

//                 const SizedBox(height: 14),

//                 _field(
//                   controller: _passwordController,
//                   hint: "Password",
//                   obscureText: state.obscurePassword,
//                   textInputAction: TextInputAction.next,
//                   onChanged: notifier.updatePassword,
//                   suffixIcon: IconButton(
//                     onPressed: notifier.toggleObscurePassword,
//                     icon: Icon(
//                       state.obscurePassword
//                           ? Icons.visibility_off_outlined
//                           : Icons.visibility_outlined,
//                       color: const Color(0xFF6B75A6),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter password";
//                     }

//                     if (!ref.read(registerProvider).isStrongByRegex) {
//                       return "Password must match required format";
//                     }

//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 10),

//                 _passwordRules(state),

//                 const SizedBox(height: 14),

//                 _field(
//                   controller: _confirmPasswordController,
//                   hint: "Confirm Password",
//                   obscureText: state.obscureConfirmPassword,
//                   textInputAction: TextInputAction.next,
//                   suffixIcon: IconButton(
//                     onPressed: notifier.toggleObscureConfirmPassword,
//                     icon: Icon(
//                       state.obscureConfirmPassword
//                           ? Icons.visibility_off_outlined
//                           : Icons.visibility_outlined,
//                       color: const Color(0xFF6B75A6),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please confirm password";
//                     }

//                     if (value != _passwordController.text) {
//                       return "Passwords do not match";
//                     }

//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 14),

//                 _field(
//                   controller: _locationController,
//                   hint: "Enter Location",
//                   textInputAction: TextInputAction.done,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Please enter location";
//                     }

//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 12),

//                 _termsSection(),

//                 const SizedBox(height: 18),

//                 _GradientRegisterButton(
//                   isLoading: state.isLoading,
//                   onPressed: state.isLoading ? null : _register,
//                 ),

//                 const SizedBox(height: 18),

//                 TextButton(
//                   onPressed: () {
//                     if (Navigator.canPop(context)) {
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: const Text(
//                     "Existing members log in at Beat Flirt",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Color(0xFF6C7CFF),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 const Text(
//                   "Erotic Dating for Swingers, Open-Minded Couples & Singles",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0xFFE8EAF0),
//                     fontSize: 12,
//                   ),
//                 ),

//                 const SizedBox(height: 6),

//                 Wrap(
//                   alignment: WrapAlignment.center,
//                   children: [
//                     TextButton(
//                       onPressed: () => _showInfoDialog(
//                         title: "Terms and Conditions",
//                         message:
//                             "Terms and Conditions content can be added here.",
//                       ),
//                       child: const Text(
//                         "Terms and Conditions",
//                         style: TextStyle(
//                           color: Color(0xFF6C7CFF),
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () => _showInfoDialog(
//                         title: "Privacy Policy",
//                         message: "Privacy Policy content can be added here.",
//                       ),
//                       child: const Text(
//                         "Privacy Policy",
//                         style: TextStyle(
//                           color: Color(0xFF6C7CFF),
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _profileSelector() {
//     return Row(
//       children: [
//         _profileRadio("single", "Single"),
//         const SizedBox(width: 22),
//         _profileRadio("couple", "Couple"),
//       ],
//     );
//   }

//   Widget _profileRadio(String value, String title) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(30),
//       onTap: () {
//         setState(() {
//           _profileType = value;
//         });
//       },
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Radio<String>(
//             value: value,
//             groupValue: _profileType,
//             activeColor: const Color(0xFF7B3FA3),
//             onChanged: (selected) {
//               if (selected == null) return;

//               setState(() {
//                 _profileType = selected;
//               });
//             },
//           ),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _genderSection() {
//     if (_profileType == 'single') {
//       return _genderDropdown(
//         value: _singleGender,
//         onChanged: (value) {
//           setState(() {
//             _singleGender = value;
//           });
//         },
//       );
//     }

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final bool twoColumns = constraints.maxWidth > 560;

//         final fromDropdown = _genderDropdown(
//           value: _coupleGenderFrom,
//           onChanged: (value) {
//             setState(() {
//               _coupleGenderFrom = value;
//             });
//           },
//         );

//         final toDropdown = _genderDropdown(
//           value: _coupleGenderTo,
//           onChanged: (value) {
//             setState(() {
//               _coupleGenderTo = value;
//             });
//           },
//         );

//         if (twoColumns) {
//           return Row(
//             children: [
//               Expanded(child: fromDropdown),
//               const SizedBox(width: 14),
//               Expanded(child: toDropdown),
//             ],
//           );
//         }

//         return Column(
//           children: [
//             fromDropdown,
//             const SizedBox(height: 14),
//             toDropdown,
//           ],
//         );
//       },
//     );
//   }

//   Widget _genderDropdown({
//     required String? value,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       isExpanded: true,
//       decoration: _inputDecoration(
//         hintText: "Please Select Gender",
//       ),
//       icon: const Icon(
//         Icons.keyboard_arrow_down_rounded,
//         color: Color(0xFF6B75A6),
//       ),
//       items: const [
//         DropdownMenuItem(
//           value: "male",
//           child: Text("Male"),
//         ),
//         DropdownMenuItem(
//           value: "female",
//           child: Text("Female"),
//         ),
//         DropdownMenuItem(
//           value: "transgender",
//           child: Text("Transgender"),
//         ),
//       ],
//       onChanged: onChanged,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "Please select gender";
//         }

//         return null;
//       },
//     );
//   }

//   Widget _label(String text) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 13,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.3,
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
//     ValueChanged<String>? onChanged,
//     Widget? suffixIcon,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return TextFormField(
//       controller: controller,
//       cursorColor: const Color(0xFF7B3FA3),
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       obscureText: obscureText,
//       onChanged: onChanged,
//       inputFormatters: inputFormatters,
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
//         horizontal: 15,
//         vertical: 14,
//       ),
//       suffixIcon: suffixIcon,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(
//           color: Color(0xFFD4DBFF),
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(
//           color: Color(0xFF7B3FA3),
//           width: 1.4,
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(
//           color: Colors.redAccent,
//         ),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(
//           color: Colors.redAccent,
//           width: 1.4,
//         ),
//       ),
//     );
//   }

//   Widget _passwordRules(dynamic state) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.18),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.12),
//         ),
//       ),
//       child: Column(
//         children: [
//           _passwordRule("At least 8 characters", state.hasMinLength),
//           _passwordRule("At least one uppercase letter (A-Z)", state.hasUppercase),
//           _passwordRule("At least one lowercase letter (a-z)", state.hasLowercase),
//           _passwordRule("At least one digit (0-9)", state.hasDigit),
//           _passwordRule(
//             "At least one special character (!@#\$%&*)",
//             state.hasSpecialChar,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _passwordRule(String text, bool isValid) {
//     final Color color =
//         isValid ? const Color(0xFF35D07F) : const Color(0xFFFF7878);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Row(
//         children: [
//           Icon(
//             isValid ? Icons.check_circle : Icons.cancel,
//             size: 17,
//             color: color,
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 12.5,
//                 color: color,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _termsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Checkbox(
//               value: _acceptedTerms,
//               activeColor: const Color(0xFF7B3FA3),
//               checkColor: Colors.white,
//               side: const BorderSide(
//                 color: Colors.white70,
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _acceptedTerms = value ?? false;
//                   _showTermsError = !_acceptedTerms;
//                 });
//               },
//             ),
//             Expanded(
//               child: Wrap(
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 children: [
//                   const Text(
//                     "I agree to the ",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () => _showInfoDialog(
//                       title: "Terms and Conditions",
//                       message: "Terms and Conditions content can be added here.",
//                     ),
//                     child: const Text(
//                       "Terms and Conditions",
//                       style: TextStyle(
//                         color: Color(0xFF6C7CFF),
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         if (_showTermsError)
//           const Padding(
//             padding: EdgeInsets.only(left: 12, top: 2),
//             child: Text(
//               "Please accept Terms and Conditions",
//               style: TextStyle(
//                 color: Color(0xFFFFC4C4),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   void _showInfoDialog({
//     required String title,
//     required String message,
//   }) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _GradientRegisterButton extends StatelessWidget {
//   final bool isLoading;
//   final VoidCallback? onPressed;

//   const _GradientRegisterButton({
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
//           borderRadius: BorderRadius.circular(25),
//           gradient: const LinearGradient(
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             colors: [
//               Color(0xFF5A2D82),
//               Color(0xFF7B3FA3),
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF7B3FA3).withOpacity(0.36),
//               blurRadius: 18,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(25),
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
//                       "Create Account",
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