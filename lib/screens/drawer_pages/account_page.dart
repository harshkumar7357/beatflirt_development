import 'package:flutter/material.dart';
import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:beatflirt/screens/login_page.dart';
import 'upgrade_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ApiServices _api = ApiServices();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoadingProfile = true;
  bool _isUpdatingPassword = false;
  bool _isDeletingAccount = false;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      backgroundColor: const Color(0xFFF7EFF7),
      body: SafeArea(
        child: _isLoadingProfile
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 920;
                  if (isCompact) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _leftPanel(),
                        const SizedBox(height: 14),
                        _rightPanel(),
                      ],
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: _leftPanel()),
                          const SizedBox(width: 14),
                          Expanded(flex: 4, child: _rightPanel()),
                        ],
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _leftPanel() {
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
              hintText: _email.isEmpty ? 'No email available' : _email,
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
                onPressed: _isUpdatingPassword ? null : _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF220027),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isUpdatingPassword
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

  Widget _rightPanel() {
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
                  onPressed: _isDeletingAccount ? null : _confirmDeleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF273036),
                    foregroundColor: Colors.white,
                  ),
                  child: _isDeletingAccount
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

  Future<void> _loadProfile() async {
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        if (!mounted) return;
        setState(() => _isLoadingProfile = false);
        return;
      }
      final res = await _api.getProfile(token: token);
      final user = res['user'];
      if (!mounted) return;
      setState(() {
        _email = (user is Map ? user['email'] : '')?.toString() ?? '';
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingProfile = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not fetch account profile')),
      );
    }
  }

  Future<void> _updatePassword() async {
    final oldPwd = _oldPasswordController.text.trim();
    final newPwd = _newPasswordController.text.trim();
    final confirmPwd = _confirmPasswordController.text.trim();

    if (oldPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all password fields')),
      );
      return;
    }
    if (newPwd != confirmPwd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password and confirm password must match')),
      );
      return;
    }
    if (newPwd.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isUpdatingPassword = true);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) throw Exception('Session expired');
      await _api.changePassword(
        token: token,
        oldPassword: oldPwd,
        newPassword: newPwd,
      );
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isUpdatingPassword = false);
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
    setState(() => _isDeletingAccount = true);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) throw Exception('Session expired');
      await _api.deleteAccount(token: token);
      await AuthService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isDeletingAccount = false);
    }
  }
}
