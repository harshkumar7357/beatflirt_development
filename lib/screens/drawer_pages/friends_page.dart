import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Friends', icon: Icons.person_2);
  }
}
