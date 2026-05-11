import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/profile_provider.dart';
import 'profile_tabs/my_profile_album_tab.dart';
import 'profile_tabs/my_profile_edit_tab.dart';
import 'profile_tabs/my_profile_home_tab.dart';
import 'profile_tabs/my_profile_location_tab.dart';
import 'profile_tabs/my_profile_photos_tab.dart';
import 'profile_tabs/my_profile_video_tab.dart';

class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({super.key});

  static const List<String> _tabLabels = [
    'Home',
    'Edit',
    'Photos',
    'Video',
    'Album',
    'Location',
  ];

  List<Widget> _tabPages() {
    return const [
      MyProfileHomeTab(),
      MyProfileEditTab(),
      MyProfilePhotosTab(),
      MyProfileVideoTab(),
      MyProfileAlbumTab(),
      MyProfileLocationTab(),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(profileTabProvider);
    final pages = _tabPages();

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTopTabs(ref, selectedTabIndex),
                const SizedBox(height: 14),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: SingleChildScrollView(
                      key: ValueKey<int>(selectedTabIndex),
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: pages[selectedTabIndex],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopTabs(WidgetRef ref, int selectedTabIndex) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF14001C), Color(0xFF3B004B)],
        ),
      ),
      child: Row(
        children: List.generate(
          _tabLabels.length,
          (index) => _TopTab(
            label: _tabLabels[index],
            selected: selectedTabIndex == index,
            onTap: () {
              ref.read(profileTabProvider.notifier).state = index;
            },
          ),
        ),
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
