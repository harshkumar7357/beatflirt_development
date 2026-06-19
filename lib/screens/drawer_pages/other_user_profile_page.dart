import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/providers/user_list_provider.dart';
import 'package:beatflirt/core/utils/image_utils.dart';
import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';

final otherUserProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, userId) async {
  final token = await AuthService.getToken();
  if (token == null) throw Exception('Unauthorized');
  return ApiServices().getOtherUserProfile(token: token, userId: userId);
});

class OtherUserProfilePage extends ConsumerStatefulWidget {
  final UserListItem user;
  const OtherUserProfilePage({super.key, required this.user});

  @override
  ConsumerState<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends ConsumerState<OtherUserProfilePage> {
  int _selectedTabIndex = 0;

  final List<String> _tabLabels = ['Home', 'Photos', 'Video', 'Album'];

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(otherUserProvider(widget.user.id));

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.user.name,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
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
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTopTabs(),
                const SizedBox(height: 14),
                Expanded(
                  child: userAsync.when(
                    data: (data) => _buildTabContent(data),
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.pink)),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(colors: [Color(0xFF14001C), Color(0xFF3B004B)]),
      ),
      child: Row(
        children: List.generate(
          _tabLabels.length,
          (index) => Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedTabIndex == index ? const Color(0xFFFF2D87) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _tabLabels[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: _selectedTabIndex == index ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(Map<String, dynamic> data) {
    switch (_selectedTabIndex) {
      case 0: return _HomeTab(data: data);
      case 1: return _MediaGrid(media: data['photos'] ?? [], isVideo: false);
      case 2: return _MediaGrid(media: data['videos'] ?? [], isVideo: true);
      case 3: return const Center(child: Text('No Albums found'));
      default: return const SizedBox.shrink();
    }
  }
}

class _HomeTab extends StatelessWidget {
  final Map<String, dynamic> data;
  const _HomeTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final user = data['user'] ?? {};
    final p1 = user['partner1Traits'] ?? {};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _ProfileCard(user: user),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: _TraitsTable(p1: p1),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _InfoPanel(title: 'About', content: user['aboutMe'] ?? 'No bio provided'),
          const SizedBox(height: 10),
          _InfoPanel(title: 'Interests', content: user['lookingFor'] ?? 'Not specified'),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic> user;
  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1C0027), Color(0xFF32003E)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: buildUserImage(user['imageUrl'] ?? '', height: 120, width: double.infinity),
          ),
          const SizedBox(height: 8),
          Text(user['name'] ?? 'Unknown', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          Text('${user['age'] ?? 24} Years', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(user['location'] ?? 'Jaipur, India', style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _TraitsTable extends StatelessWidget {
  final Map<String, dynamic> p1;
  const _TraitsTable({required this.p1});

  @override
  Widget build(BuildContext context) {
    final traits = [
      {'label': 'Body Type', 'value': p1['bodyType'] ?? 'Average'},
      {'label': 'Height', 'value': p1['height'] ?? "5'7"},
      {'label': 'Weight', 'value': p1['weight'] ?? '65'},
      {'label': 'Ethnicity', 'value': p1['ethnic'] ?? 'Indian'},
      {'label': 'Sexuality', 'value': p1['sexuality'] ?? 'Straight'},
    ];

    return Column(
      children: traits.map((t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(child: Container(
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFF3B004B), borderRadius: BorderRadius.circular(14)),
              child: Text(t['label']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            )),
            const SizedBox(width: 8),
            Expanded(child: Container(
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
              child: Text(t['value']!, style: const TextStyle(color: Colors.black87, fontSize: 10)),
            )),
          ],
        ),
      )).toList(),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final String title;
  final String content;
  const _InfoPanel({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFFBF8FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5DDF2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2F1047))),
          const SizedBox(height: 6),
          Text(content, style: TextStyle(fontSize: 12, height: 1.3, color: Colors.grey[800])),
        ],
      ),
    );
  }
}

class _MediaGrid extends StatelessWidget {
  final List<dynamic> media;
  final bool isVideo;
  const _MediaGrid({required this.media, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const Center(child: Text('No media found'));
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: media.length,
      itemBuilder: (context, index) {
        final path = isVideo ? media[index]['thumbnailPath'] : media[index]['path'];
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildUserImage(path ?? ''),
              if (isVideo) const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 30)),
            ],
          ),
        );
      },
    );
  }
}
