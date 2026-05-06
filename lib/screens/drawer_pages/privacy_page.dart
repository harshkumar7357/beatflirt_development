import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Privacy', icon: Icons.privacy_tip_outlined);
  }
}
