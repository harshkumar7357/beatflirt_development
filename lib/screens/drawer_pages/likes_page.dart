import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Likes', icon: Icons.verified_user);
  }
}
