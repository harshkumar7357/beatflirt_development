import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/privacy_provider.dart';

class PrivacyPage extends ConsumerWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyState = ref.watch(privacyProvider);
    final privacyNotifier = ref.read(privacyProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A), // AAA Premium Dark Background
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoBox(),
                const SizedBox(height: 30),
                _buildSectionHeader("Visibility Settings"),
                _buildSettingsCard([
                  _buildCustomToggle(
                    icon: FontAwesomeIcons.solidCircleDot,
                    title: "Online Status",
                    subtitle: "Let others know when you are active.",
                    value: privacyState.showOnlineStatus,
                    onChanged: (_) => privacyNotifier.toggleOnlineStatus(),
                  ),
                  _buildDivider(),
                  _buildCustomToggle(
                    icon: FontAwesomeIcons.eyeSlash,
                    title: "Incognito in Search",
                    subtitle: "Hide your profile from global results.",
                    value: privacyState.hideFromSearch,
                    onChanged: (_) => privacyNotifier.toggleSearchHide(),
                  ),
                  _buildDivider(),
                  _buildCustomToggle(
                    icon: FontAwesomeIcons.clockRotateLeft,
                    title: "Last Seen",
                    subtitle: "Show when you last used the app.",
                    value: privacyState.showLastSeen,
                    onChanged: (_) => privacyNotifier.toggleLastSeen(),
                  ),
                ]),
                const SizedBox(height: 30),
                _buildSectionHeader("Interactions & Security"),
                _buildSettingsCard([
                  _buildCustomToggle(
                    icon: FontAwesomeIcons.commentDots,
                    title: "Message Requests",
                    subtitle: "Allow messages from strangers.",
                    value: privacyState.allowMessagesFromStrangers,
                    onChanged: (_) => privacyNotifier.toggleMessages(),
                  ),
                  _buildDivider(),
                  _buildCustomToggle(
                    icon: FontAwesomeIcons.shieldHalved,
                    title: "Strict Profile Mode",
                    subtitle: "Only approved members can view details.",
                    value: !privacyState.showProfileToPublic,
                    onChanged: (_) => privacyNotifier.toggleProfilePublic(),
                  ),
                ]),
                const SizedBox(height: 40),
                _buildFooter(),
                const SizedBox(height: 50),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0F0F1A),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'PRIVACY CONTROL',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A11CB).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        children: [
          FaIcon(FontAwesomeIcons.userLock, color: Colors.white, size: 30),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Privacy First",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 6),
                Text(
                  "You decide who sees your activity and how you interact with others.",
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 15),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildCustomToggle({
    required FaIconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
        ),
        child: FaIcon(icon, size: 18, color: Colors.pinkAccent),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5), height: 1.4),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.pinkAccent,
      activeTrackColor: Colors.pinkAccent.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.white.withValues(alpha: 0.05), indent: 70);
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user_rounded, color: Colors.greenAccent, size: 16),
            const SizedBox(width: 8),
            Text(
              "Privacy Settings Encrypted",
              style: TextStyle(color: Colors.greenAccent.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "Changes are applied instantly to your profile.\nBeat Flirt ensures your data remains secure.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11, height: 1.5),
        ),
      ],
    );
  }
}
