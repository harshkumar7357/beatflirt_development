import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/providers/user_list_provider.dart';

class BlocklistPage extends ConsumerWidget {
  const BlocklistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userListProvider('blocklist'));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Blocklist', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: state.users.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(user.imageUrl),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('Blocked on 12 Oct 2023'),
                      trailing: TextButton(
                        onPressed: () {
                          ref.read(userListProvider('blocklist').notifier).removeUser(user.id);
                        },
                        child: const Text('UNBLOCK', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Divider(height: 1, indent: 80),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('Your blocklist is empty', style: TextStyle(color: Colors.grey)),
    );
  }
}
