import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class NewMemberPage extends StatelessWidget {
  const NewMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'New Member', icon: Icons.account_circle);
  }
}
