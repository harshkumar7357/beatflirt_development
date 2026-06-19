import 'package:beatflirt/model/notification_model.dart';
import 'package:beatflirt/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BeatFlirtNotificationPage extends ConsumerWidget {
  const BeatFlirtNotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(notificationProvider.notifier).fetchNotifications(),
        color: Colors.pinkAccent,
        backgroundColor: const Color(0xFF1A1A2E),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _buildAppBar(context, ref),
            if (state.isLoading && state.notifications.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.pinkAccent),
                ),
              )
            else if (state.notifications.isEmpty)
              _buildEmptyState()
            else
              _buildNotificationList(state.notifications, ref),
            const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF0F0F1A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
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
          onPressed: () => ref.read(notificationProvider.notifier).clearAll(),
          child: const Text(
            'Clear All',
            style: TextStyle(color: Colors.pinkAccent, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 20),
            const Text(
              'No notifications yet',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We will notify you when something important happens.',
              style: TextStyle(color: Colors.white24, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    List<NotificationModel> notifications,
    WidgetRef ref,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification, ref);
      }, childCount: notifications.length),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, WidgetRef ref) {
    final typeData = _getTypeData(notification.type, notification.title);

    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          ref.read(notificationProvider.notifier).markAsRead(notification.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.pinkAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: notification.isRead
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.pinkAccent.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: typeData.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: FaIcon(typeData.icon, color: typeData.color, size: 18),
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
                        notification.type.toUpperCase(),
                        style: TextStyle(
                          color: typeData.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        _formatTime(notification.createdAt),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification.title,
                    style: TextStyle(
                      color: notification.isRead
                          ? Colors.white70
                          : Colors.white,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.description,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 25, left: 5),
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(date);
  }

  _TypeData _getTypeData(String type, String title) {
    if (title.toLowerCase().contains('room code')) {
      return _TypeData(FontAwesomeIcons.key, Colors.pinkAccent);
    }

    switch (type.toLowerCase()) {
      case 'match':
        return _TypeData(FontAwesomeIcons.heartCircleCheck, Colors.pink);
      case 'message':
        return _TypeData(FontAwesomeIcons.envelopeOpenText, Colors.blue);
      case 'like':
        return _TypeData(FontAwesomeIcons.solidHeart, Colors.red);
      case 'system':
        return _TypeData(FontAwesomeIcons.circleExclamation, Colors.orange);
      case 'event':
        return _TypeData(FontAwesomeIcons.calendarCheck, Colors.purple);
      case 'update':
        return _TypeData(FontAwesomeIcons.rocket, Colors.green);
      default:
        return _TypeData(FontAwesomeIcons.bell, Colors.grey);
    }
  }
}

class _TypeData {
  final dynamic icon;
  final Color color;
  _TypeData(this.icon, this.color);
}
