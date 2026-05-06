import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class BeatFlirtNotificationPage extends StatelessWidget {
  const BeatFlirtNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(
      title: 'BeatFlirt Notification',
      icon: Icons.notifications_none,
    );
  }
}
