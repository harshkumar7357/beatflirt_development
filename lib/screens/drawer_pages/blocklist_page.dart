import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class BlocklistPage extends StatelessWidget {
  const BlocklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Blocklist', icon: Icons.account_circle);
  }
}
