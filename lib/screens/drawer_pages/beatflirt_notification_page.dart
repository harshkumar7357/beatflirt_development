import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BeatFlirtNotificationPage extends ConsumerWidget {
  const BeatFlirtNotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          _buildNotificationList(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF0F0F1A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'NOTIFICATIONS',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 2.0,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Clear All', style: TextStyle(color: Colors.pinkAccent, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildNotificationList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildNotificationCard(index);
        },
        childCount: 6,
      ),
    );
  }

  Widget _buildNotificationCard(int index) {
    final types = ['Match', 'Message', 'Like', 'System', 'Event', 'Update'];
    final icons = [
      FontAwesomeIcons.heartCircleCheck,
      FontAwesomeIcons.envelopeOpenText,
      FontAwesomeIcons.solidHeart,
      FontAwesomeIcons.circleExclamation,
      FontAwesomeIcons.calendarCheck,
      FontAwesomeIcons.rocket
    ];
    final colors = [Colors.pink, Colors.blue, Colors.red, Colors.orange, Colors.purple, Colors.green];
    final titles = [
      'New Match Found!',
      'Message from Jessica',
      'Someone liked your photo',
      'Security Alert',
      'Upcoming Party Reminder',
      'New App Features'
    ];
    final times = ['2m ago', '15m ago', '1h ago', '3h ago', '5h ago', '1d ago'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: colors[index % colors.length].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: FaIcon(icons[index % icons.length], color: colors[index % colors.length], size: 18),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      types[index % types.length].toUpperCase(),
                      style: TextStyle(
                        color: colors[index % colors.length],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(times[index % times.length], style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  titles[index % titles.length],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Tap to see details and respond to this notification.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
