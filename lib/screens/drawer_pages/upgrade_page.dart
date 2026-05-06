import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Upgrade', icon: Icons.upgrade);
  }
}
