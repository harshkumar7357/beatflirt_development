import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class NewMembersPage extends StatelessWidget {
  const NewMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'New Members', icon: Icons.insert_emoticon_sharp);
  }
}
