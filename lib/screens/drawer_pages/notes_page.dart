import 'package:flutter/material.dart';
import 'drawer_page_template.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerPageTemplate(title: 'Notes', icon: Icons.photo_library);
  }
}
