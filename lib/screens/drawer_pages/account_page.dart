// import 'package:flutter/material.dart';
// import 'package:beatflirt/Api_services/api_services.dart';
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:beatflirt/screens/login_page.dart';
// import 'upgrade_page.dart';
//
// class AccountPage extends StatefulWidget {
//   const AccountPage({super.key});
//
//   @override
//   State<AccountPage> createState() => _AccountPageState();
// }
//
// class _AccountPageState extends State<AccountPage> {
//   final ApiServices _api = ApiServices();
//   final TextEditingController _oldPasswordController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   bool _isLoadingProfile = true;
//   bool _isUpdatingPassword = false;
//   bool _isDeletingAccount = false;
//   String _email = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }
//
//   @override
//   void dispose() {
//     _oldPasswordController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Account'),
//       ),
//       backgroundColor: const Color(0xFFF7EFF7),
//       body: SafeArea(
//         child: _isLoadingProfile
//             ? const Center(child: CircularProgressIndicator())
//             : LayoutBuilder(
//                 builder: (context, constraints) {
//                   final isCompact = constraints.maxWidth < 920;
//                   if (isCompact) {
//                     return ListView(
//                       padding: const EdgeInsets.all(16),
//                       children: [
//                         _leftPanel(),
//                         const SizedBox(height: 14),
//                         _rightPanel(),
//                       ],
//                     );
//                   }
//                   return ListView(
//                     padding: const EdgeInsets.all(16),
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(flex: 6, child: _leftPanel()),
//                           const SizedBox(width: 14),
//                           Expanded(flex: 4, child: _rightPanel()),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//       ),
//     );
//   }
//
//   Widget _leftPanel() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE8E0F2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'My Account',
//             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'Email',
//             style: TextStyle(fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 6),
//           TextField(
//             enabled: false,
//             decoration: InputDecoration(
//               hintText: _email.isEmpty ? 'No email available' : _email,
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               disabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Change my Password',
//             style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 12),
//           _passwordField(
//             label: 'Old Password',
//             hint: 'Enter old password',
//             controller: _oldPasswordController,
//           ),
//           const SizedBox(height: 10),
//           _passwordField(
//             label: 'Password',
//             hint: 'Enter new password',
//             controller: _newPasswordController,
//           ),
//           const SizedBox(height: 10),
//           _passwordField(
//             label: 'Confirm Password',
//             hint: 'Enter confirm password',
//             controller: _confirmPasswordController,
//           ),
//           const SizedBox(height: 18),
//           Center(
//             child: SizedBox(
//               width: 140,
//               child: ElevatedButton(
//                 onPressed: _isUpdatingPassword ? null : _updatePassword,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF220027),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 child: _isUpdatingPassword
//                     ? const SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                       )
//                     : const Text('update'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _rightPanel() {
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: const Color(0xFFE8E0F2)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Membership Details',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(height: 12),
//               _memberLine('Joined:', 'December 17, 2025'),
//               _memberLine('Last Payment:', 'December 17, 2025'),
//               _memberLine('Membership:', 'PLATINUM | \$159/Year'),
//               _memberLine('Expire/Renew date:', 'December 17, 2026'),
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const UpgradePage()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF220027),
//                     foregroundColor: Colors.white,
//                   ),
//                   child: const Text('Upgrade'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: const Color(0xFFE8E0F2)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'You can permanently delete your Beat Flirt account and all your services and data, such as emails and photos will be removed!',
//                 style: TextStyle(color: Colors.grey[700], height: 1.4),
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isDeletingAccount ? null : _confirmDeleteAccount,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF273036),
//                     foregroundColor: Colors.white,
//                   ),
//                   child: _isDeletingAccount
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Text('Delete Account'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _passwordField({
//     required String label,
//     required String hint,
//     required TextEditingController controller,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           obscureText: true,
//           decoration: InputDecoration(
//             hintText: hint,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _memberLine(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Text.rich(
//         TextSpan(
//           text: '$label ',
//           style: const TextStyle(fontWeight: FontWeight.w700),
//           children: [
//             TextSpan(
//               text: value,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _loadProfile() async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) {
//         if (!mounted) return;
//         setState(() => _isLoadingProfile = false);
//         return;
//       }
//       final res = await _api.getProfile(token: token);
//       final user = res['user'];
//       if (!mounted) return;
//       setState(() {
//         _email = (user is Map ? user['email'] : '')?.toString() ?? '';
//         _isLoadingProfile = false;
//       });
//     } catch (_) {
//       if (!mounted) return;
//       setState(() => _isLoadingProfile = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not fetch account profile')),
//       );
//     }
//   }
//
//   Future<void> _updatePassword() async {
//     final oldPwd = _oldPasswordController.text.trim();
//     final newPwd = _newPasswordController.text.trim();
//     final confirmPwd = _confirmPasswordController.text.trim();
//
//     if (oldPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all password fields')),
//       );
//       return;
//     }
//     if (newPwd != confirmPwd) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('New password and confirm password must match')),
//       );
//       return;
//     }
//     if (newPwd.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('New password must be at least 6 characters')),
//       );
//       return;
//     }
//
//     setState(() => _isUpdatingPassword = true);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) throw Exception('Session expired');
//       await _api.changePassword(
//         token: token,
//         oldPassword: oldPwd,
//         newPassword: newPwd,
//       );
//       _oldPasswordController.clear();
//       _newPasswordController.clear();
//       _confirmPasswordController.clear();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Password updated successfully')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
//       );
//     } finally {
//       if (mounted) setState(() => _isUpdatingPassword = false);
//     }
//   }
//
//   Future<void> _confirmDeleteAccount() async {
//     final shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Account'),
//         content: const Text('This action is permanent. Do you really want to delete your account?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//
//     if (shouldDelete != true) return;
//     setState(() => _isDeletingAccount = true);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null || token.isEmpty) throw Exception('Session expired');
//       await _api.deleteAccount(token: token);
//       await AuthService.logout();
//       if (!mounted) return;
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//         (_) => false,
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
//       );
//     } finally {
//       if (mounted) setState(() => _isDeletingAccount = false);
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:beatflirt/screens/login_page.dart';
import 'upgrade_page.dart';

// --- STATE ---
class AccountState {
  final bool isLoadingProfile;
  final bool isUpdatingPassword;
  final bool isDeletingAccount;
  final String email;

  const AccountState({
    this.isLoadingProfile = true,
    this.isUpdatingPassword = false,
    this.isDeletingAccount = false,
    this.email = '',
  });

  AccountState copyWith({
    bool? isLoadingProfile,
    bool? isUpdatingPassword,
    bool? isDeletingAccount,
    String? email,
  }) {
    return AccountState(
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isUpdatingPassword: isUpdatingPassword ?? this.isUpdatingPassword,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      email: email ?? this.email,
    );
  }
}

// --- NOTIFIER ---
class AccountNotifier extends Notifier<AccountState> {
  final ApiServices _api = ApiServices();

  @override
  AccountState build() => const AccountState();

  Future<String?> loadProfile() async {
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        state = state.copyWith(isLoadingProfile: false);
        return null;
      }
      final res = await _api.getProfile(token: token);
      final user = res['user'];
      final email = (user is Map ? user['email'] : '')?.toString() ?? '';
      state = state.copyWith(isLoadingProfile: false, email: email);
      return null;
    } catch (_) {
      state = state.copyWith(isLoadingProfile: false);
      return 'Could not fetch account profile';
    }
  }

  Future<String?> updatePassword({
    required String oldPwd,
    required String newPwd,
    required String confirmPwd,
  }) async {
    if (oldPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      return 'Please fill all password fields';
    }
    if (newPwd != confirmPwd) {
      return 'New password and confirm password must match';
    }
    if (newPwd.length < 6) {
      return 'New password must be at least 6 characters';
    }

    state = state.copyWith(isUpdatingPassword: true);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) throw Exception('Session expired');
      await _api.changePassword(
        token: token,
        oldPassword: oldPwd,
        newPassword: newPwd,
      );
      return null; // Success
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      state = state.copyWith(isUpdatingPassword: false);
    }
  }

  Future<String?> deleteAccount() async {
    state = state.copyWith(isDeletingAccount: true);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) throw Exception('Session expired');
      await _api.deleteAccount(token: token);
      await AuthService.logout();
      return null; // Success
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      state = state.copyWith(isDeletingAccount: false);
    }
  }
}

// --- PROVIDER ---
final accountProvider =
NotifierProvider<AccountNotifier, AccountState>(AccountNotifier.new);

// --- WIDGET ---
class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final error = await ref.read(accountProvider.notifier).loadProfile();
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _updatePassword() async {
    final error = await ref.read(accountProvider.notifier).updatePassword(
      oldPwd: _oldPasswordController.text.trim(),
      newPwd: _newPasswordController.text.trim(),
      confirmPwd: _confirmPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action is permanent. Do you really want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    final error = await ref.read(accountProvider.notifier).deleteAccount();

    if (!mounted) return;

    if (error == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF7EFF7),
      body: SafeArea(
        child: state.isLoadingProfile
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 920;
            if (isCompact) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _leftPanel(state),
                  const SizedBox(height: 14),
                  _rightPanel(state),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: _leftPanel(state)),
                    const SizedBox(width: 14),
                    Expanded(flex: 4, child: _rightPanel(state)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _leftPanel(AccountState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E0F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Account',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: state.email.isEmpty ? 'No email available' : state.email,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Change my Password',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _passwordField(
            label: 'Old Password',
            hint: 'Enter old password',
            controller: _oldPasswordController,
          ),
          const SizedBox(height: 10),
          _passwordField(
            label: 'Password',
            hint: 'Enter new password',
            controller: _newPasswordController,
          ),
          const SizedBox(height: 10),
          _passwordField(
            label: 'Confirm Password',
            hint: 'Enter confirm password',
            controller: _confirmPasswordController,
          ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: state.isUpdatingPassword ? null : _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF220027),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: state.isUpdatingPassword
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text('update'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightPanel(AccountState state) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E0F2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Membership Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _memberLine('Joined:', 'December 17, 2025'),
              _memberLine('Last Payment:', 'December 17, 2025'),
              _memberLine('Membership:', 'PLATINUM | \$159/Year'),
              _memberLine('Expire/Renew date:', 'December 17, 2026'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UpgradePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF220027),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Upgrade'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E0F2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You can permanently delete your Beat Flirt account and all your services and data, such as emails and photos will be removed!',
                style: TextStyle(color: Colors.grey[700], height: 1.4),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isDeletingAccount ? null : _confirmDeleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF273036),
                    foregroundColor: Colors.white,
                  ),
                  child: state.isDeletingAccount
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Delete Account'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _passwordField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _memberLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          text: '$label ',
          style: const TextStyle(fontWeight: FontWeight.w700),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}