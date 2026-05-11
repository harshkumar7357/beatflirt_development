// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:beatflirt/providers/user_list_provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// class FavoritePage extends ConsumerWidget {
//   const FavoritePage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(userListProvider('favorites'));
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F1A),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           _buildAppBar(context),
//           _buildFavoritesHeader(state.users.length),
//           _buildFavoritesGrid(state.users),
//           const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       floating: true,
//       pinned: true,
//       backgroundColor: const Color(0xFF0F0F1A),
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
//         onPressed: () => Navigator.pop(context),
//       ),
//       centerTitle: true,
//       title: const Text(
//         'FAVORITES',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w900,
//           fontSize: 16,
//           letterSpacing: 2.0,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFavoritesHeader(int count) {
//     return SliverToBoxAdapter(
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         padding: const EdgeInsets.all(25),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Row(
//           children: [
//             const CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white24,
//               child: FaIcon(FontAwesomeIcons.solidHeart, color: Colors.white, size: 25),
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Saved Profiles', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//                   Text('$count people in your list', style: const TextStyle(color: Colors.white70, fontSize: 13)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFavoritesGrid(List<UserListItem> users) {
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 15,
//           crossAxisSpacing: 15,
//           childAspectRatio: 0.75,
//         ),
//         delegate: SliverChildBuilderDelegate(
//           (context, index) {
//             final user = users[index % users.length];
//             return _buildFavoriteCard(user);
//           },
//           childCount: 8,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFavoriteCard(UserListItem user) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//       ),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Image.asset(user.imageUrl, fit: BoxFit.cover),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 12,
//             left: 12,
//             right: 12,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, color: Colors.white70, size: 10),
//                     const SizedBox(width: 4),
//                     Text(user.location, style: const TextStyle(color: Colors.white70, fontSize: 10)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 10,
//             right: 10,
//             child: CircleAvatar(
//               radius: 15,
//               backgroundColor: Colors.black38,
//               child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/providers/user_list_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userListProvider('favorites'));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F1A), // Deep dark
              Color(0xFF1A1A2E), // Midnight blue tint
              Color(0xFF0F0F1A),
            ],
          ),
        ),
        child: RefreshIndicator(
          color: Colors.pinkAccent,
          backgroundColor: const Color(0xFF1A1A2E),
          onRefresh: () => ref.read(userListProvider('favorites').notifier).fetchUsers(),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              if (state.isLoading && state.users.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
                )
              else if (state.error != null && state.users.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white54, size: 60),
                        const SizedBox(height: 16),
                        Text(state.error!, style: const TextStyle(color: Colors.white70)),
                        TextButton(
                          onPressed: () => ref.read(userListProvider('favorites').notifier).fetchUsers(),
                          child: const Text('Retry', style: TextStyle(color: Colors.pinkAccent)),
                        )
                      ],
                    ),
                  ),
                )
              else ...[
                  _buildFavoritesHeader(state.users.length),
                  if (state.users.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No favorites yet.',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ),
                    )
                  else
                    _buildFavoritesGrid(state.users, ref),
                ],
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent, // Let the background gradient show through
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'FAVORITES',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildFavoritesHeader(int count) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4081).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white24,
              child: FaIcon(FontAwesomeIcons.solidHeart, color: Colors.white, size: 25),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saved Profiles', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('$count people in your list', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid(List<UserListItem> users, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final user = users[index];
            return _buildFavoriteCard(user, ref);
          },
          childCount: users.length,
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(UserListItem user, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: user.imageUrl.startsWith('http')
                ? Image.network(user.imageUrl, fit: BoxFit.cover)
                : Image.asset(user.imageUrl, fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 10),
                    const SizedBox(width: 4),
                    Text(user.location, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: () => ref.read(userListProvider('favorites').notifier).removeUser(user.id),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
