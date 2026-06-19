// // import 'dart:convert';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:http/http.dart' as http;
// //
// // import 'package:beatflirt/core/services/auth_services.dart';
// // import 'package:beatflirt/screens/login_page.dart';
// // import 'upgrade_page.dart';
// //
// // // --- ENDPOINTS ---
// // class _AccountApi {
// //   static const String _base = 'https://app.beatflirtevent.com/App';
// //
// //   static const String profile        = '$_base/user/signle_user_profile';
// //   static const String changePassword = '$_base/user/change_password';
// //   static const String deleteAccount  = '$_base/user/delete_account';
// //   static const String membershipPlan = '$_base/membership/get_user_membership_plan';
// // }
// //
// // // --- STATE ---
// // class AccountState {
// //   final bool isLoadingProfile;
// //   final bool isUpdatingPassword;
// //   final bool isDeletingAccount;
// //
// //   // Profile
// //   final String email;
// //   final String uniqueId;
// //   final String profileType; // 'single' | 'couple'
// //   final String joinedDate;       // created
// //   final String lastPaymentDate;  // last_payment
// //   final String expireDate;       // expire_date
// //
// //   // Membership
// //   final bool isLoadingMembership;
// //   final bool hasMembership;
// //   final String planName;       // e.g. "PLATINUM"
// //   final String planPrice;      // e.g. "159"
// //   final String planPeriod;     // e.g. "Year"
// //   final String planValidTo;    // e.g. "2027-06-01"
// //
// //   const AccountState({
// //     this.isLoadingProfile = true,
// //     this.isUpdatingPassword = false,
// //     this.isDeletingAccount = false,
// //     this.email = '',
// //     this.uniqueId = '',
// //     this.profileType = '',
// //     this.joinedDate = '',
// //     this.lastPaymentDate = '',
// //     this.expireDate = '',
// //     this.isLoadingMembership = true,
// //     this.hasMembership = false,
// //     this.planName = '',
// //     this.planPrice = '',
// //     this.planPeriod = '',
// //     this.planValidTo = '',
// //   });
// //
// //   AccountState copyWith({
// //     bool? isLoadingProfile,
// //     bool? isUpdatingPassword,
// //     bool? isDeletingAccount,
// //     String? email,
// //     String? uniqueId,
// //     String? profileType,
// //     String? joinedDate,
// //     String? lastPaymentDate,
// //     String? expireDate,
// //     bool? isLoadingMembership,
// //     bool? hasMembership,
// //     String? planName,
// //     String? planPrice,
// //     String? planPeriod,
// //     String? planValidTo,
// //   }) {
// //     return AccountState(
// //       isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
// //       isUpdatingPassword: isUpdatingPassword ?? this.isUpdatingPassword,
// //       isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
// //       email: email ?? this.email,
// //       uniqueId: uniqueId ?? this.uniqueId,
// //       profileType: profileType ?? this.profileType,
// //       joinedDate: joinedDate ?? this.joinedDate,
// //       lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
// //       expireDate: expireDate ?? this.expireDate,
// //       isLoadingMembership: isLoadingMembership ?? this.isLoadingMembership,
// //       hasMembership: hasMembership ?? this.hasMembership,
// //       planName: planName ?? this.planName,
// //       planPrice: planPrice ?? this.planPrice,
// //       planPeriod: planPeriod ?? this.planPeriod,
// //       planValidTo: planValidTo ?? this.planValidTo,
// //     );
// //   }
// // }
// //
// // // --- NOTIFIER ---
// // class AccountNotifier extends Notifier<AccountState> {
// //   // final ApiServices _api = ApiServices();
// //
// //   @override
// //   AccountState build() => const AccountState();
// //
// //   Map<String, String> _authHeaders(String token) => {
// //         'Accept': 'application/json',
// //         'Content-Type': 'application/json',
// //         'Authorization': 'Bearer $token',
// //       };
// //
// //   /// Loads single/couple profile from /user/signle_user_profile
// //   Future<String?> loadProfile() async {
// //     try {
// //       final token = await AuthService.getToken();
// //       if (token == null || token.isEmpty) {
// //         state = state.copyWith(
// //           isLoadingProfile: false,
// //           isLoadingMembership: false,
// //         );
// //         return null;
// //       }
// //
// //       final res = await http.get(
// //         Uri.parse(_AccountApi.profile),
// //         headers: _authHeaders(token),
// //       );
// //
// //       if (res.statusCode != 200) {
// //         state = state.copyWith(isLoadingProfile: false);
// //         return 'Could not fetch account profile (${res.statusCode})';
// //       }
// //
// //       final body = jsonDecode(res.body);
// //       final status = body['status']?.toString() ?? '';
// //       if (status != '200') {
// //         state = state.copyWith(isLoadingProfile: false);
// //         return body['message']?.toString() ?? 'Could not fetch account profile';
// //       }
// //
// //       final data = body['data'];
// //       String s(dynamic v) => (v ?? '').toString();
// //
// //       state = state.copyWith(
// //         isLoadingProfile: false,
// //         email: s(data is Map ? data['email'] : ''),
// //         uniqueId: s(data is Map ? data['id'] : ''),
// //         profileType: s(data is Map ? data['profile_type'] : ''),
// //         joinedDate: s(data is Map ? data['created'] : ''),
// //         lastPaymentDate: s(data is Map ? data['last_payment'] : ''),
// //         expireDate: s(data is Map ? data['expire_date'] : ''),
// //       );
// //
// //       // Kick off membership load after profile is in place
// //       await loadMembership();
// //
// //       return null;
// //     } catch (_) {
// //       state = state.copyWith(
// //         isLoadingProfile: false,
// //         isLoadingMembership: false,
// //       );
// //       return 'Could not fetch account profile';
// //     }
// //   }
// //
// //   /// Loads current membership from /membership/get_user_membership_plan
// //   Future<String?> loadMembership() async {
// //     try {
// //       final token = await AuthService.getToken();
// //       if (token == null || token.isEmpty) {
// //         state = state.copyWith(isLoadingMembership: false, hasMembership: false);
// //         return null;
// //       }
// //
// //       final res = await http.get(
// //         Uri.parse(_AccountApi.membershipPlan),
// //         headers: _authHeaders(token),
// //       );
// //
// //       // The API returns 200 for both "purchased" and "not purchased",
// //       // distinguished by the body "status" field.
// //       final body = jsonDecode(res.body);
// //       final apiStatus = body['status']?.toString() ?? '';
// //
// //       if (apiStatus == '200') {
// //         final data = body['data'];
// //         String s(dynamic v) => (v ?? '').toString();
// //         state = state.copyWith(
// //           isLoadingMembership: false,
// //           hasMembership: true,
// //           planName: s(data is Map ? data['plan_name'] : ''),
// //           planPrice: s(data is Map ? data['plan_price'] : ''),
// //           planPeriod: s(data is Map ? data['plan_year'] : ''),
// //           planValidTo: s(data is Map ? data['plan_valid_to_date'] : ''),
// //         );
// //       } else {
// //         // 404 / "Plan not purchase yet" or anything else => no active plan
// //         state = state.copyWith(
// //           isLoadingMembership: false,
// //           hasMembership: false,
// //           planName: '',
// //           planPrice: '',
// //           planPeriod: '',
// //           planValidTo: '',
// //         );
// //       }
// //       return null;
// //     } catch (_) {
// //       state = state.copyWith(isLoadingMembership: false, hasMembership: false);
// //       return 'Could not fetch membership details';
// //     }
// //   }
// //
// //   Future<String?> updatePassword({
// //     required String oldPwd,
// //     required String newPwd,
// //     required String confirmPwd,
// //   }) async {
// //     if (oldPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
// //       return 'Please fill all password fields';
// //     }
// //     if (newPwd != confirmPwd) {
// //       return 'New password and confirm password must match';
// //     }
// //     if (newPwd.length < 6) {
// //       return 'New password must be at least 6 characters';
// //     }
// //
// //     state = state.copyWith(isUpdatingPassword: true);
// //     try {
// //       final token = await AuthService.getToken();
// //       if (token == null || token.isEmpty) throw Exception('Session expired');
// //
// //       final res = await http.post(
// //         Uri.parse(_AccountApi.changePassword),
// //         headers: _authHeaders(token),
// //         body: jsonEncode({
// //           'old_password': oldPwd,
// //           'new_password': newPwd,
// //         }),
// //       );
// //
// //       if (res.statusCode != 200) {
// //         throw Exception('Failed to change password (${res.statusCode})');
// //       }
// //
// //       final body = jsonDecode(res.body);
// //       final apiStatus = body['status']?.toString() ?? '';
// //       if (apiStatus != '200') {
// //         throw Exception(body['message']?.toString() ?? 'Failed to change password');
// //       }
// //
// //       return null;
// //     } catch (e) {
// //       return e.toString().replaceFirst('Exception: ', '');
// //     } finally {
// //       state = state.copyWith(isUpdatingPassword: false);
// //     }
// //   }
// //
// //   /// Deletes account via GET /user/delete_account
// //   Future<String?> deleteAccount() async {
// //     state = state.copyWith(isDeletingAccount: true);
// //     try {
// //       final token = await AuthService.getToken();
// //       if (token == null || token.isEmpty) throw Exception('Session expired');
// //
// //       final res = await http.get(
// //         Uri.parse(_AccountApi.deleteAccount),
// //         headers: _authHeaders(token),
// //       );
// //
// //       if (res.statusCode != 200) {
// //         throw Exception('Failed to delete account (${res.statusCode})');
// //       }
// //
// //       final body = jsonDecode(res.body);
// //       final apiStatus = body['status']?.toString() ?? '';
// //       if (apiStatus != '200') {
// //         throw Exception(body['message']?.toString() ?? 'Failed to delete account');
// //       }
// //
// //       await AuthService.logout();
// //       return null;
// //     } catch (e) {
// //       return e.toString().replaceFirst('Exception: ', '');
// //     } finally {
// //       state = state.copyWith(isDeletingAccount: false);
// //     }
// //   }
// // }
// //
// // // --- PROVIDER ---
// // final accountProvider = NotifierProvider<AccountNotifier, AccountState>(
// //   AccountNotifier.new,
// // );
// //
// // // --- WIDGET ---
// // class AccountPage extends ConsumerStatefulWidget {
// //   const AccountPage({super.key});
// //
// //   @override
// //   ConsumerState<AccountPage> createState() => _AccountPageState();
// // }
// //
// // class _AccountPageState extends ConsumerState<AccountPage> {
// //   final TextEditingController _oldPasswordController = TextEditingController();
// //   final TextEditingController _newPasswordController = TextEditingController();
// //   final TextEditingController _confirmPasswordController =
// //       TextEditingController();
// //
// //   bool _obscureOldPassword = true;
// //   bool _obscureNewPassword = true;
// //   bool _obscureConfirmPassword = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _loadProfile();
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _oldPasswordController.dispose();
// //     _newPasswordController.dispose();
// //     _confirmPasswordController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _loadProfile() async {
// //     final error = await ref.read(accountProvider.notifier).loadProfile();
// //     if (error != null && mounted) {
// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(SnackBar(content: Text(error)));
// //     }
// //   }
// //
// //   Future<void> _updatePassword() async {
// //     final error = await ref.read(accountProvider.notifier).updatePassword(
// //           oldPwd: _oldPasswordController.text.trim(),
// //           newPwd: _newPasswordController.text.trim(),
// //           confirmPwd: _confirmPasswordController.text.trim(),
// //         );
// //
// //     if (!mounted) return;
// //
// //     if (error == null) {
// //       _oldPasswordController.clear();
// //       _newPasswordController.clear();
// //       _confirmPasswordController.clear();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Password updated successfully')),
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(SnackBar(content: Text(error)));
// //     }
// //   }
// //
// //   Future<void> _confirmDeleteAccount() async {
// //     final shouldDelete = await showDialog<bool>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Delete Account'),
// //         content: const Text(
// //           'This action is permanent. Do you really want to delete your account?',
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, false),
// //             style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
// //             child: const Text('Cancel'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () => Navigator.pop(context, true),
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
// //             child: const Text('Delete'),
// //           ),
// //         ],
// //       ),
// //     );
// //
// //     if (shouldDelete != true) return;
// //
// //     final error = await ref.read(accountProvider.notifier).deleteAccount();
// //
// //     if (!mounted) return;
// //
// //     if (error == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('User deleted successfully')),
// //       );
// //       Navigator.pushAndRemoveUntil(
// //         context,
// //         MaterialPageRoute(builder: (_) => const LoginPage()),
// //         (_) => false,
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(SnackBar(content: Text(error)));
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final state = ref.watch(accountProvider);
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('My Account'),
// //         leading: IconButton(
// //           icon: const Icon(
// //             Icons.arrow_back_ios_new,
// //             color: Colors.black,
// //             size: 20,
// //           ),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ),
// //       backgroundColor: const Color(0xFFF7EFF7),
// //       body: SafeArea(
// //         child: state.isLoadingProfile
// //             ? const Center(child: CircularProgressIndicator())
// //             : LayoutBuilder(
// //                 builder: (context, constraints) {
// //                   final isCompact = constraints.maxWidth < 920;
// //                   if (isCompact) {
// //                     return ListView(
// //                       padding: const EdgeInsets.all(16),
// //                       children: [
// //                         _leftPanel(state),
// //                         const SizedBox(height: 14),
// //                         _rightPanel(state),
// //                       ],
// //                     );
// //                   }
// //                   return ListView(
// //                     padding: const EdgeInsets.all(16),
// //                     children: [
// //                       Row(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Expanded(flex: 6, child: _leftPanel(state)),
// //                           const SizedBox(width: 14),
// //                           Expanded(flex: 4, child: _rightPanel(state)),
// //                         ],
// //                       ),
// //                     ],
// //                   );
// //                 },
// //               ),
// //       ),
// //     );
// //   }
// //
// //   Widget _leftPanel(AccountState state) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: const Color(0xFFE8E0F2)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             'My Account',
// //             style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
// //           ),
// //           const SizedBox(height: 12),
// //           const Text('Email', style: TextStyle(fontWeight: FontWeight.w700)),
// //           const SizedBox(height: 6),
// //           TextField(
// //             onTapOutside: (_) {
// //               FocusManager.instance.primaryFocus!.unfocus();
// //             },
// //             enabled: false,
// //             decoration: InputDecoration(
// //               hintText:
// //                   state.email.isEmpty ? 'No email available' : state.email,
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               disabledBorder: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           // const Text('My Unique ID',
// //           //     style: TextStyle(fontWeight: FontWeight.w700)),
// //           // const SizedBox(height: 6),
// //           // TextField(
// //           //   onTapOutside: (_) {
// //           //     FocusManager.instance.primaryFocus!.unfocus();
// //           //   },
// //           //   enabled: false,
// //           //   decoration: InputDecoration(
// //           //     hintText:
// //           //         state.uniqueId.isEmpty ? 'Generating ID...' : state.uniqueId,
// //           //     hintStyle: const TextStyle(
// //           //         color: Colors.pinkAccent, fontWeight: FontWeight.bold),
// //           //     border: OutlineInputBorder(
// //           //       borderRadius: BorderRadius.circular(8),
// //           //     ),
// //           //     disabledBorder: OutlineInputBorder(
// //           //       borderRadius: BorderRadius.circular(8),
// //           //       borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //           //     ),
// //           //     suffixIcon: IconButton(
// //           //       icon: const Icon(Icons.copy,
// //           //           size: 18, color: Colors.pinkAccent),
// //           //       onPressed: () => _copyUniqueId(state.uniqueId),
// //           //     ),
// //           //   ),
// //           // ),
// //           // const SizedBox(height: 16),
// //           const Text(
// //             'Change my Password',
// //             style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
// //           ),
// //           const SizedBox(height: 12),
// //           _passwordField(
// //             label: 'Old Password',
// //             hint: 'Enter old password',
// //             controller: _oldPasswordController,
// //             obscureText: _obscureOldPassword,
// //             onToggleVisibility: () {
// //               setState(() {
// //                 _obscureOldPassword = !_obscureOldPassword;
// //               });
// //             },
// //           ),
// //           const SizedBox(height: 10),
// //           _passwordField(
// //             label: 'Password',
// //             hint: 'Enter new password',
// //             controller: _newPasswordController,
// //             obscureText: _obscureNewPassword,
// //             onToggleVisibility: () {
// //               setState(() {
// //                 _obscureNewPassword = !_obscureNewPassword;
// //               });
// //             },
// //           ),
// //           const SizedBox(height: 10),
// //           _passwordField(
// //             label: 'Confirm Password',
// //             hint: 'Enter confirm password',
// //             controller: _confirmPasswordController,
// //             obscureText: _obscureConfirmPassword,
// //             onToggleVisibility: () {
// //               setState(() {
// //                 _obscureConfirmPassword = !_obscureConfirmPassword;
// //               });
// //             },
// //           ),
// //           const SizedBox(height: 18),
// //           Center(
// //             child: SizedBox(
// //               width: MediaQuery.of(context).size.width * 0.9,
// //               height: MediaQuery.of(context).size.height * 0.057,
// //               child: ElevatedButton(
// //                 onPressed: state.isUpdatingPassword ? null : _updatePassword,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFF220027),
// //                   foregroundColor: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(22),
// //                   ),
// //                   padding: const EdgeInsets.symmetric(vertical: 12),
// //                 ),
// //                 child: state.isUpdatingPassword
// //                     ? const SizedBox(
// //                         width: 16,
// //                         height: 16,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           color: Colors.white,
// //                         ),
// //                       )
// //                     : const Text('Update'),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   static const List<String> _months = [
// //     'January', 'February', 'March', 'April', 'May', 'June',
// //     'July', 'August', 'September', 'October', 'November', 'December',
// //   ];
// //
// //   /// Converts "2026-05-27" -> "May 27, 2026". Returns input unchanged on failure.
// //   String _formatDate(String raw) {
// //     if (raw.isEmpty) return '-';
// //     try {
// //       final d = DateTime.parse(raw);
// //       return '${_months[d.month - 1]} ${d.day}, ${d.year}';
// //     } catch (_) {
// //       return raw;
// //     }
// //   }
// //
// //   Widget _rightPanel(AccountState state) {
// //     final membershipLine = state.isLoadingMembership
// //         ? 'Loading...'
// //         : (state.hasMembership
// //             ? '${state.planName} \$${state.planPrice}/${state.planPeriod}'
// //             : 'Free');
// //
// //     final expireLine = state.isLoadingMembership
// //         ? 'Loading...'
// //         : (state.hasMembership && state.planValidTo.isNotEmpty
// //             ? _formatDate(state.planValidTo)
// //             : _formatDate(state.expireDate));
// //
// //     return Column(
// //       children: [
// //         Container(
// //           width: double.infinity,
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(color: const Color(0xFFE8E0F2)),
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'Membership Details',
// //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
// //               ),
// //               const SizedBox(height: 12),
// //               _memberLine('Joined:', _formatDate(state.joinedDate)),
// //               _memberLine('Last Payment:', _formatDate(state.lastPaymentDate)),
// //               _memberLine('Membership:', membershipLine),
// //               _memberLine('Expire/Renew date:', expireLine),
// //               const SizedBox(height: 12),
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: () async {
// //                     await Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (_) => const UpgradePage()),
// //                     );
// //                     // refresh membership after returning from upgrade
// //                     if (mounted) {
// //                       ref.read(accountProvider.notifier).loadMembership();
// //                     }
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF220027),
// //                     foregroundColor: Colors.white,
// //                   ),
// //                   child: const Text('Upgrade'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //         Container(
// //           width: double.infinity,
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(color: const Color(0xFFE8E0F2)),
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 'You can permanently delete your Beat Flirt account and all your services and data, such as emails and photos will be removed!',
// //                 style: TextStyle(color: Colors.grey[700], height: 1.4),
// //               ),
// //               const SizedBox(height: 12),
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: state.isDeletingAccount
// //                       ? null
// //                       : _confirmDeleteAccount,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF273036),
// //                     foregroundColor: Colors.white,
// //                   ),
// //                   child: state.isDeletingAccount
// //                       ? const SizedBox(
// //                           width: 16,
// //                           height: 16,
// //                           child: CircularProgressIndicator(
// //                             strokeWidth: 2,
// //                             color: Colors.white,
// //                           ),
// //                         )
// //                       : const Text('Delete Account'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _passwordField({
// //     required String label,
// //     required String hint,
// //     required TextEditingController controller,
// //     required bool obscureText,
// //     required VoidCallback onToggleVisibility,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
// //         const SizedBox(height: 6),
// //         TextField(
// //           onTapOutside: (_) {
// //             FocusManager.instance.primaryFocus!.unfocus();
// //           },
// //           controller: controller,
// //           obscureText: obscureText,
// //           decoration: InputDecoration(
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(8),
// //               borderSide: const BorderSide(color: Colors.black),
// //             ),
// //             hintText: hint,
// //             border:
// //                 OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //             enabledBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(8),
// //               borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
// //             ),
// //             suffixIcon: IconButton(
// //               icon: Icon(
// //                 obscureText ? Icons.visibility_off : Icons.visibility,
// //                 color: Colors.grey,
// //               ),
// //               onPressed: onToggleVisibility,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _memberLine(String label, String value) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 4),
// //       child: Text.rich(
// //         TextSpan(
// //           text: '$label ',
// //           style: const TextStyle(fontWeight: FontWeight.w700),
// //           children: [
// //             TextSpan(
// //               text: value,
// //               style: const TextStyle(fontWeight: FontWeight.w500),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
//
// import 'package:beatflirt/core/services/auth_services.dart';
// import 'package:beatflirt/screens/login_page.dart';
// import 'upgrade_page.dart';
//
// // --- ENDPOINTS ---
// class _AccountApi {
//   static const String _base = 'https://app.beatflirtevent.com/App';
//   static const String profile        = '$_base/user/signle_user_profile';
//   static const String changePassword = '$_base/user/change_password';
//   static const String deleteAccount  = '$_base/user/delete_account';
//   static const String membershipPlan = '$_base/membership/get_user_membership_plan';
// }
//
// /// Confirm in Chrome DevTools (Request Headers) which one your backend uses.
// enum _AuthHeaderMode { bearer, tokenHdr, authtoken, query }
//
// // >>> CHANGE THIS to match your backend (see DevTools).
// const _AuthHeaderMode kAuthMode = _AuthHeaderMode.bearer;
// // const _AuthHeaderMode kAuthMode = _AuthHeaderMode.tokenHdr;
//
// class AccountState {
//   final bool isLoadingProfile, isUpdatingPassword, isDeletingAccount;
//   final String email, uniqueId, profileType;
//   final String joinedDate, lastPaymentDate, expireDate;
//   final bool isLoadingMembership, hasMembership;
//   final String planName, planPrice, planPeriod, planValidTo;
//
//   const AccountState({
//     this.isLoadingProfile = true,
//     this.isUpdatingPassword = false,
//     this.isDeletingAccount = false,
//     this.email = '', this.uniqueId = '', this.profileType = '',
//     this.joinedDate = '', this.lastPaymentDate = '', this.expireDate = '',
//     this.isLoadingMembership = true, this.hasMembership = false,
//     this.planName = '', this.planPrice = '', this.planPeriod = '', this.planValidTo = '',
//   });
//
//   AccountState copyWith({
//     bool? isLoadingProfile, bool? isUpdatingPassword, bool? isDeletingAccount,
//     String? email, String? uniqueId, String? profileType,
//     String? joinedDate, String? lastPaymentDate, String? expireDate,
//     bool? isLoadingMembership, bool? hasMembership,
//     String? planName, String? planPrice, String? planPeriod, String? planValidTo,
//   }) => AccountState(
//     isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
//     isUpdatingPassword: isUpdatingPassword ?? this.isUpdatingPassword,
//     isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
//     email: email ?? this.email,
//     uniqueId: uniqueId ?? this.uniqueId,
//     profileType: profileType ?? this.profileType,
//     joinedDate: joinedDate ?? this.joinedDate,
//     lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
//     expireDate: expireDate ?? this.expireDate,
//     isLoadingMembership: isLoadingMembership ?? this.isLoadingMembership,
//     hasMembership: hasMembership ?? this.hasMembership,
//     planName: planName ?? this.planName,
//     planPrice: planPrice ?? this.planPrice,
//     planPeriod: planPeriod ?? this.planPeriod,
//     planValidTo: planValidTo ?? this.planValidTo,
//   );
// }
//
// class AccountNotifier extends Notifier<AccountState> {
//   @override
//   AccountState build() => const AccountState();
//
//   Map<String, String> _authHeaders(String token, {bool jsonBody = false}) {
//     final h = <String, String>{'Accept': 'application/json'};
//     if (jsonBody) h['Content-Type'] = 'application/json';
//     switch (kAuthMode) {
//       case _AuthHeaderMode.bearer:    h['Authorization'] = 'Bearer $token'; break;
//       case _AuthHeaderMode.tokenHdr:  h['token'] = token; break;
//       case _AuthHeaderMode.authtoken: h['Authtoken'] = token; break;
//       case _AuthHeaderMode.query: break;
//     }
//     return h;
//   }
//
//   Uri _withAuth(String url, String token) {
//     if (kAuthMode == _AuthHeaderMode.query) {
//       final sep = url.contains('?') ? '&' : '?';
//       return Uri.parse('$url${sep}token=$token');
//     }
//     return Uri.parse(url);
//   }
//
//   void _log(String t, String m) { if (kDebugMode) debugPrint('[Account/$t] $m'); }
//
//   Future<String?> _getToken() async {
//     final token = await AuthService.getToken();
//     _log('TOKEN', token == null ? 'null' : (token.isEmpty ? 'EMPTY' : 'len=${token.length}'));
//     return token;
//   }
//
//   Future<String?> loadProfile() async {
//     try {
//       final token = await _getToken();
//       if (token == null || token.isEmpty) {
//         state = state.copyWith(isLoadingProfile: false);
//         return 'You are not logged in (no token)';
//       }
//       final uri = _withAuth(_AccountApi.profile, token);
//       _log('PROFILE', 'GET $uri');
//       final res = await http.get(uri, headers: _authHeaders(token));
//       _log('PROFILE', 'status=${res.statusCode} body=${res.body}');
//
//       if (res.statusCode != 200) {
//         state = state.copyWith(isLoadingProfile: false);
//         return 'Profile HTTP ${res.statusCode}';
//       }
//       if (res.body.trimLeft().startsWith('<')) {
//         state = state.copyWith(isLoadingProfile: false);
//         return 'Profile returned HTML (auth header wrong)';
//       }
//       final body = jsonDecode(res.body);
//       final status = body['status']?.toString() ?? '';
//       if (status != '200') {
//         state = state.copyWith(isLoadingProfile: false);
//         return body['message']?.toString() ?? 'Profile status=$status';
//       }
//       final data = body['data'];
//       String s(dynamic v) => (v ?? '').toString();
//       state = state.copyWith(
//         isLoadingProfile: false,
//         email: s(data is Map ? data['email'] : ''),
//         uniqueId: s(data is Map ? data['id'] : ''),
//         profileType: s(data is Map ? data['profile_type'] : ''),
//         joinedDate: s(data is Map ? data['created'] : ''),
//         lastPaymentDate: s(data is Map ? data['last_payment'] : ''),
//         expireDate: s(data is Map ? data['expire_date'] : ''),
//       );
//       return null;
//     } catch (e, st) {
//       _log('PROFILE', 'EXCEPTION $e\n$st');
//       state = state.copyWith(isLoadingProfile: false);
//       return 'Profile error: $e';
//     }
//   }
//
//   Future<String?> loadMembership() async {
//     try {
//       final token = await _getToken();
//       if (token == null || token.isEmpty) {
//         state = state.copyWith(isLoadingMembership: false, hasMembership: false);
//         return 'You are not logged in (no token)';
//       }
//       final uri = _withAuth(_AccountApi.membershipPlan, token);
//       _log('MEMBERSHIP', 'GET $uri');
//       final res = await http.get(uri, headers: _authHeaders(token));
//       _log('MEMBERSHIP', 'status=${res.statusCode} body=${res.body}');
//
//       if (res.statusCode != 200 && res.statusCode != 404) {
//         state = state.copyWith(isLoadingMembership: false, hasMembership: false);
//         return 'Membership HTTP ${res.statusCode}';
//       }
//       if (res.body.trimLeft().startsWith('<')) {
//         state = state.copyWith(isLoadingMembership: false, hasMembership: false);
//         return 'Membership returned HTML (auth header wrong)';
//       }
//       final body = jsonDecode(res.body);
//       final apiStatus = body['status']?.toString() ?? '';
//       if (apiStatus == '200') {
//         final data = body['data'];
//         String s(dynamic v) => (v ?? '').toString();
//         state = state.copyWith(
//           isLoadingMembership: false, hasMembership: true,
//           planName:    s(data is Map ? data['plan_name'] : ''),
//           planPrice:   s(data is Map ? data['plan_price'] : ''),
//           planPeriod:  s(data is Map ? data['plan_year'] : ''),
//           planValidTo: s(data is Map ? data['plan_valid_to_date'] : ''),
//         );
//       } else {
//         state = state.copyWith(
//           isLoadingMembership: false, hasMembership: false,
//           planName: '', planPrice: '', planPeriod: '', planValidTo: '',
//         );
//       }
//       return null;
//     } catch (e, st) {
//       _log('MEMBERSHIP', 'EXCEPTION $e\n$st');
//       state = state.copyWith(isLoadingMembership: false, hasMembership: false);
//       return 'Membership error: $e';
//     }
//   }
//
//   Future<String?> updatePassword({
//     required String oldPwd, required String newPwd, required String confirmPwd,
//   }) async {
//     if (oldPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) return 'Please fill all password fields';
//     if (newPwd != confirmPwd) return 'New password and confirm password must match';
//     if (newPwd.length < 6) return 'New password must be at least 6 characters';
//
//     state = state.copyWith(isUpdatingPassword: true);
//     try {
//       final token = await _getToken();
//       if (token == null || token.isEmpty) throw Exception('Session expired');
//       final uri = _withAuth(_AccountApi.changePassword, token);
//       _log('CHG_PWD', 'POST $uri');
//       final res = await http.post(uri,
//         headers: _authHeaders(token, jsonBody: true),
//         body: jsonEncode({'old_password': oldPwd, 'new_password': newPwd}),
//       );
//       _log('CHG_PWD', 'status=${res.statusCode} body=${res.body}');
//       if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
//       final body = jsonDecode(res.body);
//       if ((body['status']?.toString() ?? '') != '200') {
//         throw Exception(body['message']?.toString() ?? 'Failed');
//       }
//       return null;
//     } catch (e) { return e.toString().replaceFirst('Exception: ', ''); }
//     finally { state = state.copyWith(isUpdatingPassword: false); }
//   }
//
//   Future<String?> deleteAccount() async {
//     state = state.copyWith(isDeletingAccount: true);
//     try {
//       final token = await _getToken();
//       if (token == null || token.isEmpty) throw Exception('Session expired');
//       final uri = _withAuth(_AccountApi.deleteAccount, token);
//       _log('DELETE', 'GET $uri');
//       final res = await http.get(uri, headers: _authHeaders(token));
//       _log('DELETE', 'status=${res.statusCode} body=${res.body}');
//       if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
//       final body = jsonDecode(res.body);
//       if ((body['status']?.toString() ?? '') != '200') {
//         throw Exception(body['message']?.toString() ?? 'Failed');
//       }
//       await AuthService.logout();
//       return null;
//     } catch (e) { return e.toString().replaceFirst('Exception: ', ''); }
//     finally { state = state.copyWith(isDeletingAccount: false); }
//   }
// }
//
// final accountProvider =
// NotifierProvider<AccountNotifier, AccountState>(AccountNotifier.new);
//
// class AccountPage extends ConsumerStatefulWidget {
//   const AccountPage({super.key});
//   @override
//   ConsumerState<AccountPage> createState() => _AccountPageState();
// }
//
// class _AccountPageState extends ConsumerState<AccountPage> {
//   final _oldPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscureOldPassword = true, _obscureNewPassword = true, _obscureConfirmPassword = true;
//
//   @override
//   void initState() {
//     super.initState();
//     AuthService.probeAuth();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
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
//   Future<void> _loadAll() async {
//     final n = ref.read(accountProvider.notifier);
//     final results = await Future.wait([n.loadProfile(), n.loadMembership()]);
//     if (!mounted) return;
//     final errors = results.whereType<String>().toList();
//     if (errors.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(duration: const Duration(seconds: 6),
//             content: Text(errors.join(' | '))),
//       );
//     }
//   }
//
//   Future<void> _updatePassword() async {
//     final error = await ref.read(accountProvider.notifier).updatePassword(
//       oldPwd: _oldPasswordController.text.trim(),
//       newPwd: _newPasswordController.text.trim(),
//       confirmPwd: _confirmPasswordController.text.trim(),
//     );
//     if (!mounted) return;
//     if (error == null) {
//       _oldPasswordController.clear();
//       _newPasswordController.clear();
//       _confirmPasswordController.clear();
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Password updated successfully')));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
//     }
//   }
//
//   Future<void> _confirmDeleteAccount() async {
//     final shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (c) => AlertDialog(
//         title: const Text('Delete Account'),
//         content: const Text('This action is permanent. Do you really want to delete your account?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(c, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//     if (shouldDelete != true) return;
//     final error = await ref.read(accountProvider.notifier).deleteAccount();
//     if (!mounted) return;
//     if (error == null) {
//       Navigator.pushAndRemoveUntil(context,
//           MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(accountProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Account'),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.black,
//             size: 20,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       backgroundColor: const Color(0xFFF7EFF7),
//       body: SafeArea(
//         child: state.isLoadingProfile
//             ? const Center(child: CircularProgressIndicator())
//             : LayoutBuilder(
//                 builder: (context, constraints) {
//                   final isCompact = constraints.maxWidth < 920;
//                   if (isCompact) {
//                     return ListView(
//                       padding: const EdgeInsets.all(16),
//                       children: [
//                         _leftPanel(state),
//                         const SizedBox(height: 14),
//                         _rightPanel(state),
//                       ],
//                     );
//                   }
//                   return ListView(
//                     padding: const EdgeInsets.all(16),
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(flex: 6, child: _leftPanel(state)),
//                           const SizedBox(width: 14),
//                           Expanded(flex: 4, child: _rightPanel(state)),
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
//   Widget _leftPanel(AccountState state) {
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
//           const Text('Email', style: TextStyle(fontWeight: FontWeight.w700)),
//           const SizedBox(height: 6),
//           TextField(
//             onTapOutside: (_) {
//               FocusManager.instance.primaryFocus!.unfocus();
//             },
//             enabled: false,
//             decoration: InputDecoration(
//               hintText:
//                   state.email.isEmpty ? 'No email available' : state.email,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               disabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           // const Text('My Unique ID',
//           //     style: TextStyle(fontWeight: FontWeight.w700)),
//           // const SizedBox(height: 6),
//           // TextField(
//           //   onTapOutside: (_) {
//           //     FocusManager.instance.primaryFocus!.unfocus();
//           //   },
//           //   enabled: false,
//           //   decoration: InputDecoration(
//           //     hintText:
//           //         state.uniqueId.isEmpty ? 'Generating ID...' : state.uniqueId,
//           //     hintStyle: const TextStyle(
//           //         color: Colors.pinkAccent, fontWeight: FontWeight.bold),
//           //     border: OutlineInputBorder(
//           //       borderRadius: BorderRadius.circular(8),
//           //     ),
//           //     disabledBorder: OutlineInputBorder(
//           //       borderRadius: BorderRadius.circular(8),
//           //       borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//           //     ),
//           //     suffixIcon: IconButton(
//           //       icon: const Icon(Icons.copy,
//           //           size: 18, color: Colors.pinkAccent),
//           //       onPressed: () => _copyUniqueId(state.uniqueId),
//           //     ),
//           //   ),
//           // ),
//           // const SizedBox(height: 16),
//           const Text(
//             'Change my Password',
//             style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 12),
//           _passwordField(
//             label: 'Old Password',
//             hint: 'Enter old password',
//             controller: _oldPasswordController,
//             obscureText: _obscureOldPassword,
//             onToggleVisibility: () {
//               setState(() {
//                 _obscureOldPassword = !_obscureOldPassword;
//               });
//             },
//           ),
//           const SizedBox(height: 10),
//           _passwordField(
//             label: 'Password',
//             hint: 'Enter new password',
//             controller: _newPasswordController,
//             obscureText: _obscureNewPassword,
//             onToggleVisibility: () {
//               setState(() {
//                 _obscureNewPassword = !_obscureNewPassword;
//               });
//             },
//           ),
//           const SizedBox(height: 10),
//           _passwordField(
//             label: 'Confirm Password',
//             hint: 'Enter confirm password',
//             controller: _confirmPasswordController,
//             obscureText: _obscureConfirmPassword,
//             onToggleVisibility: () {
//               setState(() {
//                 _obscureConfirmPassword = !_obscureConfirmPassword;
//               });
//             },
//           ),
//           const SizedBox(height: 18),
//           Center(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: MediaQuery.of(context).size.height * 0.057,
//               child: ElevatedButton(
//                 onPressed: state.isUpdatingPassword ? null : _updatePassword,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF220027),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(22),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 child: state.isUpdatingPassword
//                     ? const SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Text('Update'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static const List<String> _months = [
//     'January', 'February', 'March', 'April', 'May', 'June',
//     'July', 'August', 'September', 'October', 'November', 'December',
//   ];
//
//   /// Converts "2026-05-27" -> "May 27, 2026". Returns input unchanged on failure.
//   String _formatDate(String raw) {
//     if (raw.isEmpty) return '-';
//     try {
//       final d = DateTime.parse(raw);
//       return '${_months[d.month - 1]} ${d.day}, ${d.year}';
//     } catch (_) {
//       return raw;
//     }
//   }
//
//   Widget _rightPanel(AccountState state) {
//     final membershipLine = state.isLoadingMembership
//         ? 'Loading...'
//         : (state.hasMembership
//             ? '${state.planName} \$${state.planPrice}/${state.planPeriod}'
//             : 'Free');
//
//     final expireLine = state.isLoadingMembership
//         ? 'Loading...'
//         : (state.hasMembership && state.planValidTo.isNotEmpty
//             ? _formatDate(state.planValidTo)
//             : _formatDate(state.expireDate));
//
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
//               _memberLine('Joined:', _formatDate(state.joinedDate)),
//               _memberLine('Last Payment:', _formatDate(state.lastPaymentDate)),
//               _memberLine('Membership:', membershipLine),
//               _memberLine('Expire/Renew date:', expireLine),
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const UpgradePage()),
//                     );
//                     // refresh membership after returning from upgrade
//                     if (mounted) {
//                       ref.read(accountProvider.notifier).loadMembership();
//                     }
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
//                   onPressed: state.isDeletingAccount
//                       ? null
//                       : _confirmDeleteAccount,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF273036),
//                     foregroundColor: Colors.white,
//                   ),
//                   child: state.isDeletingAccount
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
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
//     required bool obscureText,
//     required VoidCallback onToggleVisibility,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//         const SizedBox(height: 6),
//         TextField(
//           onTapOutside: (_) {
//             FocusManager.instance.primaryFocus!.unfocus();
//           },
//           controller: controller,
//           obscureText: obscureText,
//           decoration: InputDecoration(
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Colors.black),
//             ),
//             hintText: hint,
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 obscureText ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.grey,
//               ),
//               onPressed: onToggleVisibility,
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
// }
// // ... keep your existing build(), _leftPanel(), _rightPanel(), _passwordField(), _memberLine() exactly as you have them ...


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatflirt/Api_services/api_service.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:beatflirt/screens/login_page.dart';
import 'upgrade_page.dart';

// --- STATE ---
class AccountState {
  final bool isLoadingProfile;
  final bool isUpdatingPassword;
  final bool isDeletingAccount;

  // Profile
  final String email;
  final String uniqueId;
  final String profileType;
  final String joinedDate;
  final String lastPaymentDate;
  final String expireDate;

  // Membership
  final bool isLoadingMembership;
  final bool hasMembership;
  final String planName;
  final String planPrice;
  final String planPeriod;
  final String planValidTo;

  const AccountState({
    this.isLoadingProfile = true,
    this.isUpdatingPassword = false,
    this.isDeletingAccount = false,
    this.email = '',
    this.uniqueId = '',
    this.profileType = '',
    this.joinedDate = '',
    this.lastPaymentDate = '',
    this.expireDate = '',
    this.isLoadingMembership = true,
    this.hasMembership = false,
    this.planName = '',
    this.planPrice = '',
    this.planPeriod = '',
    this.planValidTo = '',
  });

  AccountState copyWith({
    bool? isLoadingProfile,
    bool? isUpdatingPassword,
    bool? isDeletingAccount,
    String? email,
    String? uniqueId,
    String? profileType,
    String? joinedDate,
    String? lastPaymentDate,
    String? expireDate,
    bool? isLoadingMembership,
    bool? hasMembership,
    String? planName,
    String? planPrice,
    String? planPeriod,
    String? planValidTo,
  }) {
    return AccountState(
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isUpdatingPassword: isUpdatingPassword ?? this.isUpdatingPassword,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      email: email ?? this.email,
      uniqueId: uniqueId ?? this.uniqueId,
      profileType: profileType ?? this.profileType,
      joinedDate: joinedDate ?? this.joinedDate,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      expireDate: expireDate ?? this.expireDate,
      isLoadingMembership: isLoadingMembership ?? this.isLoadingMembership,
      hasMembership: hasMembership ?? this.hasMembership,
      planName: planName ?? this.planName,
      planPrice: planPrice ?? this.planPrice,
      planPeriod: planPeriod ?? this.planPeriod,
      planValidTo: planValidTo ?? this.planValidTo,
    );
  }
}

// --- NOTIFIER ---
class AccountNotifier extends Notifier<AccountState> {
  final ApiService _api = ApiService();

  @override
  AccountState build() => const AccountState();

  void _log(String t, String m) {
    if (kDebugMode) debugPrint('[Account/$t] $m');
  }

  // ---- PROFILE ----
  Future<String?> loadProfile() async {
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        state = state.copyWith(isLoadingProfile: false);
        return 'You are not logged in';
      }

      final body = await _api.getSingleUserProfile(token: token);
      final status = body['status']?.toString() ?? '';
      _log('PROFILE', 'status=$status');

      if (status != '200') {
        state = state.copyWith(isLoadingProfile: false);
        return body['message']?.toString() ?? 'Failed to load profile';
      }

      final data = body['data'];
      String s(dynamic v) => (v ?? '').toString();

      state = state.copyWith(
        isLoadingProfile: false,
        email: s(data is Map ? data['email'] : ''),
        uniqueId: s(data is Map ? data['id'] : ''),
        profileType: s(data is Map ? data['profile_type'] : ''),
        joinedDate: s(data is Map ? data['created'] : ''),
        lastPaymentDate: s(data is Map ? data['last_payment'] : ''),
        expireDate: s(data is Map ? data['expire_date'] : ''),
      );
      return null;
    } catch (e, st) {
      _log('PROFILE', 'EXCEPTION $e\n$st');
      state = state.copyWith(isLoadingProfile: false);
      return 'Profile error: $e';
    }
  }

  // ---- MEMBERSHIP ----
  Future<String?> loadMembership() async {
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        state =
            state.copyWith(isLoadingMembership: false, hasMembership: false);
        return null;
      }

      final body = await _api.getUserMembershipPlanRaw(token: token);
      final apiStatus = body['status']?.toString() ?? '';
      _log('MEMBERSHIP', 'status=$apiStatus');

      if (apiStatus == '200') {
        final data = body['data'];
        String s(dynamic v) => (v ?? '').toString();
        state = state.copyWith(
          isLoadingMembership: false,
          hasMembership: true,
          planName: s(data is Map ? data['plan_name'] : ''),
          planPrice: s(data is Map ? data['plan_price'] : ''),
          planPeriod: s(data is Map ? data['plan_year'] : ''),
          planValidTo: s(data is Map ? data['plan_valid_to_date'] : ''),
        );
      } else {
        // 404 / "Plan not purchase yet" => no plan
        state = state.copyWith(
          isLoadingMembership: false,
          hasMembership: false,
          planName: '',
          planPrice: '',
          planPeriod: '',
          planValidTo: '',
        );
      }
      return null;
    } catch (e, st) {
      _log('MEMBERSHIP', 'EXCEPTION $e\n$st');
      state =
          state.copyWith(isLoadingMembership: false, hasMembership: false);
      return 'Membership error: $e';
    }
  }

  // ---- PASSWORD ----
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

      final body = await _api.changePassword(
        token: token,
        oldPassword: oldPwd,
        newPassword: newPwd,
      );
      final apiStatus = body['status']?.toString() ?? '';
      if (apiStatus != '200') {
        throw Exception(body['message']?.toString() ?? 'Failed to change password');
      }
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      state = state.copyWith(isUpdatingPassword: false);
    }
  }

  // ---- DELETE ----
  Future<String?> deleteAccount() async {
    state = state.copyWith(isDeletingAccount: true);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) throw Exception('Session expired');

      final body = await _api.deleteAccount(token: token);
      final apiStatus = body['status']?.toString() ?? '';
      if (apiStatus != '200') {
        throw Exception(
            body['message']?.toString() ?? 'Failed to delete account');
      }
      await AuthService.logout();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      state = state.copyWith(isDeletingAccount: false);
    }
  }
}

// --- PROVIDER ---
final accountProvider = NotifierProvider<AccountNotifier, AccountState>(
  AccountNotifier.new,
);

// --- WIDGET ---
class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    final notifier = ref.read(accountProvider.notifier);
    final results = await Future.wait([
      notifier.loadProfile(),
      notifier.loadMembership(),
    ]);
    if (!mounted) return;
    final errors = results.whereType<String>().toList();
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          // content: Text(errors.join(' | ')),
          content:Text('No Internet Commection')
        ),
      );
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action is permanent. Do you really want to delete your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;

    final error = await ref.read(accountProvider.notifier).deleteAccount();
    if (!mounted) return;
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
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
          const Text('My Account',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const Text('Email', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextField(
            onTapOutside: (_) =>
                FocusManager.instance.primaryFocus!.unfocus(),
            enabled: false,
            decoration: InputDecoration(
              hintText:
              state.email.isEmpty ? 'No email available' : state.email,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Change my Password',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _passwordField(
            label: 'Old Password',
            hint: 'Enter old password',
            controller: _oldPasswordController,
            obscureText: _obscureOldPassword,
            onToggleVisibility: () =>
                setState(() => _obscureOldPassword = !_obscureOldPassword),
          ),
          const SizedBox(height: 10),
          _passwordField(
            label: 'Password',
            hint: 'Enter new password',
            controller: _newPasswordController,
            obscureText: _obscureNewPassword,
            onToggleVisibility: () =>
                setState(() => _obscureNewPassword = !_obscureNewPassword),
          ),
          const SizedBox(height: 10),
          _passwordField(
            label: 'Confirm Password',
            hint: 'Enter confirm password',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            onToggleVisibility: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.057,
              child: ElevatedButton(
                onPressed: state.isUpdatingPassword ? null : _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF220027),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: state.isUpdatingPassword
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Update'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  String _formatDate(String raw) {
    if (raw.isEmpty) return '-';
    try {
      final d = DateTime.parse(raw);
      return '${_months[d.month - 1]} ${d.day}, ${d.year}';
    } catch (_) {
      return raw;
    }
  }

  Widget _rightPanel(AccountState state) {
    final membershipLine = state.isLoadingMembership
        ? 'Loading...'
        : (state.hasMembership
        ? '${state.planName} \$${state.planPrice}/${state.planPeriod}'
        : 'Free');
    final expireLine = state.isLoadingMembership
        ? 'Loading...'
        : (state.hasMembership && state.planValidTo.isNotEmpty
        ? _formatDate(state.planValidTo)
        : _formatDate(state.expireDate));

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
              const Text('Membership Details',
                  style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _memberLine('Joined:', _formatDate(state.joinedDate)),
              _memberLine(
                  'Last Payment:', _formatDate(state.lastPaymentDate)),
              _memberLine('Membership:', membershipLine),
              _memberLine('Expire/Renew date:', expireLine),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const UpgradePage()));
                    if (mounted) {
                      ref.read(accountProvider.notifier).loadMembership();
                    }
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
                  onPressed:
                  state.isDeletingAccount ? null : _confirmDeleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF273036),
                    foregroundColor: Colors.white,
                  ),
                  child: state.isDeletingAccount
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
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
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          onTapOutside: (_) =>
              FocusManager.instance.primaryFocus!.unfocus(),
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            hintText: hint,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
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
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
